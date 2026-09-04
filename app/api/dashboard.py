"""Read-only dashboard API: the agent's brain state as clean JSON."""
from fastapi import APIRouter
from datetime import datetime
from fastapi.responses import HTMLResponse
from sqlalchemy import func

from app.core.audit import audit_merchant_compliance
from app.db.database import SessionLocal
from app.db.models import (AuditLog, Diagnosis, GateDecision, RecoveryAction, Job, PaymentFailure)

from pydantic import BaseModel

try:
    from app.api.webhooks import _DROPPED  # shared malformed-drop counter
except Exception:
    _DROPPED = {"count": 0}

router = APIRouter(prefix="/api")

@router.get("/overview")
def overview():
    db = SessionLocal()
    try:
        totals = db.query(
            func.count(PaymentFailure.id).label("count"),
            func.sum(PaymentFailure.amount_paise).label("at_risk"),
            func.sum(PaymentFailure.amount_recovered_paise).label("recovered"),
            func.sum(PaymentFailure.amount_protected_paise).label("protected")
        ).first()

        verdicts = dict(db.query(GateDecision.verdict, func.count(GateDecision.id))
                        .group_by(GateDecision.verdict).all())

        archetypes = dict(db.query(Diagnosis.archetype, func.count(Diagnosis.id))
                          .group_by(Diagnosis.archetype).all())

        allow_n, defer_n = verdicts.get("ALLOW", 0), verdicts.get("DEFER", 0)
        attempt_cost = round(allow_n * 2 + defer_n * 0.5, 2)
        recovered_rupees = round(float(totals.recovered or 0) / 100, 2)
        economics = {
            "attempt_cost_rupees": attempt_cost,
            "net_recovered_rupees": round(recovered_rupees - attempt_cost, 2),
            "cost_per_rupee_recovered": round(attempt_cost / max(recovered_rupees, 1), 4),
            "retry_budget_per_customer": 3,
        }

        # ERV calculation: expected value of unrecovered payments weighted by success rates
        per_method = db.query(PaymentFailure.method, func.sum(PaymentFailure.amount_paise)) \
            .filter(PaymentFailure.status.notin_(["recovered", "protected"])) \
            .group_by(PaymentFailure.method).all()
        from app.core.mechanism import mechanism_success_rates
        rates = {m["method"]: m["success_rate"] for m in mechanism_success_rates(db)}
        economics["expected_recovery_value_rupees"] = round(
            sum(float(amt or 0) / 100 * rates.get(m, 0.5) for m, amt in per_method), 2)

        return {
            "failures_total": totals.count or 0,
            "amount_at_risk_rupees": round(float(totals.at_risk or 0) / 100, 2),
            "amount_recovered_rupees": recovered_rupees,
            "amount_protected_rupees": round(float(totals.protected or 0) / 100, 2),
            "verdicts": verdicts,
            "archetypes": archetypes,
            "economics": economics,
        }
    finally:
        db.close()

@router.get("/failures")
def failures(limit: int = 20, verdict: str = None):
    db = SessionLocal()
    try:
        q = db.query(PaymentFailure)
        if verdict:
            q = q.join(GateDecision, GateDecision.failure_id == PaymentFailure.id) \
                 .filter(GateDecision.verdict == verdict)
        rows = q.order_by(PaymentFailure.id.desc()).limit(min(limit, 100)).all()
        ids = [f.id for f in rows]
        diags = {d.failure_id: d for d in db.query(Diagnosis).filter(Diagnosis.failure_id.in_(ids)).all()}
        gates = {g.failure_id: g for g in db.query(GateDecision).filter(GateDecision.failure_id.in_(ids)).all()}
        return [{
            "payment_id": f.external_payment_id,
            "rupees": round(f.amount_paise / 100, 2),
            "method": f.method,
            "failure_code": f.failure_code,
            "context": f.context,
            "source": f.source,
            "diagnosis": {"archetype": diags[f.id].archetype, "owner": diags[f.id].owner,
                          "confidence": diags[f.id].confidence, "model": diags[f.id].model_used}
                         if f.id in diags else None,
            "verdict": gates[f.id].verdict if f.id in gates else None,
            "rule_id": gates[f.id].rule_id if f.id in gates else None,
            "status": f.status,
        } for f in rows]
    finally:
        db.close()

@router.get("/merchants")
def merchants():
    db = SessionLocal()
    try:
        return audit_merchant_compliance(db)
    finally:
        db.close()

@router.get("/jobs")
def jobs():
    db = SessionLocal()
    try:
        rows = db.query(Job).filter_by(status="queued").limit(50).all()
        fails = {f.id: f for f in db.query(PaymentFailure)
                 .filter(PaymentFailure.id.in_([j.failure_id for j in rows])).all()}
        return [{"payment_id": fails[j.failure_id].external_payment_id,
                 "kind": j.kind, "run_at": j.run_at.isoformat(), "status": j.status}
                for j in rows if j.failure_id in fails]
    finally:
        db.close()

@router.get("/audit")
def audit():
    db = SessionLocal()
    try:
        rows = db.query(AuditLog).order_by(AuditLog.id.desc()).limit(20).all()
        return [{"id": a.id, "entity": a.entity_type, "entity_id": a.entity_id,
                 "actor": a.actor, "action": a.action, "reasoning": a.reasoning}
                for a in rows]
    finally:
        db.close()

class PlaygroundInput(BaseModel):
    amount_rupees: float = 499
    method: str = "upi"
    context: str = "in_session_online"
    failure_code: str = "BANK_TIMEOUT"
    failure_description: str = "UPI transaction failed due to bank server timeout"
    merchant_id: str = "merch_001"
    voice: bool = False

@router.post("/playground")
def playground(inp: PlaygroundInput):
    """Interactive: send a failure, watch the agent diagnose -> gate -> act."""
    from datetime import datetime
    import uuid
    from app.core.diagnosis import diagnose_batch
    from app.core.gate import evaluate_consent

    db = SessionLocal()
    try:
        ext_id = "play_" + uuid.uuid4().hex[:10]
        f = PaymentFailure(
            external_payment_id=ext_id, source="playground",
            amount_paise=int(inp.amount_rupees * 100), currency="INR",
            method=inp.method, failure_code=inp.failure_code,
            failure_description=inp.failure_description,
            customer_id="cust_play", merchant_id=inp.merchant_id,
            context=inp.context,
            session_active=inp.context.startswith("in_session"),
            status="pending", occurred_at=datetime.now())
        db.add(f); db.commit(); db.refresh(f)

        diag = model = None
        try:
            res = diagnose_batch([f])
            if res:
                diag, model = res[0]
        except Exception:
            diag = None

        verdict = rule_id = reasoning = None
        if diag:
            verdict, rule_id, reasoning = evaluate_consent(db, f, diag)

        # Adversarial reasoning: Devil's Advocate challenges the gate decision
        adversarial = None
        if diag and verdict:
            try:
                from app.core.adversarial import challenge_decision
                adversarial = challenge_decision(
                    diag.archetype, verdict, rule_id, reasoning, inp.amount_rupees
                )
                if adversarial["escalate"]:
                    verdict = "BLOCK"
                    rule_id = "ADVERSARIAL_ESCALATE"
                    reasoning = f"Adversarial agent found critical flaw: {adversarial['counter']}"
            except Exception:
                adversarial = None

        actions = {
            "ALLOW": "Silent retry via Health Graph + Mechanism Swap (invisible recovery).",
            "DEFER": "Deferred to salary day via Liquidity Curve (watchful waiting).",
            "BLOCK": "Retry BLOCKED. Customer protected. No money moves without consent.",
        }
        import asyncio, os, edge_tts

        from app.core.mechanism import choose_mechanism
        from app.core.vault import tokenize, card_update_link

        ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
        MSG = {
            ("technical", "ALLOW"): "Bank mein temporary problem thi, ab fix ho gayi hai. Humne dobara try kiya — payment successful. Koi action needed nahi.",
            ("technical", "BLOCK"): "Aapne store par cash se payment kar di thi — humne QR dobara charge nahi kiya. Double-charge prevented.",
            ("intent", "ALLOW"): "OTP mein problem ho gayi thi. Ab humne UPI Collect request bheji hai — one tap se approve kar sakte ho.",
            ("affordability", "DEFER"): "Koi baat nahi! Humne payment aapke salary day tak shift kar di hai. Tab tak koi reminder nahi, koi late fee nahi.",
            ("lifecycle", "BLOCK"): "Aapka card expire ho gaya tha, isliye payment nahi hui. Jab convenient ho, naya card update karein. Koi jaldi nahi.",
        }
        key = (diag.archetype, verdict) if diag else (None, None)
        fallback = MSG.get(key, "Humne payment issue samajh liya hai aur safely handle kar rahe hain. Aapko spam nahi karenge.")
        # Rules decide the action; the AI writes the customer message (never robotic)
        action_hint = {
            "ALLOW": "A safe action was taken quietly. Reassure warmly, no jargon.",
            "DEFER": "The payment is moved to a better time (salary day). No reminders, no late fees.",
            "BLOCK": "Do NOT retry or move any money. Reassure the customer they are safe and nothing will be charged.",
        }.get(verdict, "")
        message_source = "deterministic-fallback"
        try:
            from app.core.llm import generate_text
            system = (
                "You are Revive AI, a warm human support agent for Indian payments. "
                "Write a SHORT Hinglish (roman Hindi + English mix) message of at most 2 sentences (under 45 words). "
                "Always end with a complete sentence — never cut off mid-sentence. "
                "Speak as a team using 'hum/humne' (we) forms ONLY — never 'main chahta hoon/chahti hoon' — so it matches any voice gender. "
                "Empathetic, natural, no emojis, no robotic templates. "
                f"The failure type is '{diag.archetype if diag else 'unknown'}' and the safety engine decided {verdict}. {action_hint} "
                f"The customer's situation: {inp.failure_description}. "
                "Never invent amounts or payment IDs."
            )
            ai = generate_text(system, inp.failure_description, max_tokens=250)
            if ai:
                from app.core.validator import validate_customer_message
                ok, why = validate_customer_message(ai, inp.amount_rupees)
                if ok:
                    customer_message = ai
                    message_source = "live-ai"
                else:
                    customer_message = fallback
            else:
                customer_message = fallback
        except Exception:
            customer_message = fallback

        voice_url = None
        if inp.voice:
            try:
                import base64, io
                async def _tts():
                    buf = io.BytesIO()
                    import re as _re3
                    _v = "hi-IN-SwaraNeural" if _re3.search(r"[ऀ-ॿ]", customer_message) else "en-IN-NeerjaNeural"
                    comm = edge_tts.Communicate(customer_message, _v)
                    async for chunk in comm.stream():
                        if chunk["type"] == "audio":
                            buf.write(chunk["data"])
                    return base64.b64encode(buf.getvalue()).decode()
                voice_url = "data:audio/mpeg;base64," + asyncio.run(_tts())
            except Exception:
                voice_url = None

        confidence_level = "LOW"
        if diag and diag.confidence:
            if diag.confidence >= 0.85:
                confidence_level = "HIGH"
            elif diag.confidence >= 0.65:
                confidence_level = "MED"

        out = {
            "adversarial": adversarial,
            "payment_id": ext_id,
            "diagnosis": {"archetype": diag.archetype, "owner": diag.owner,
                          "confidence": round(getattr(diag, "confidence", 0) or 0, 2),
                          "model": model} if diag else None,
            "confidence_level": confidence_level,
            "verdict": verdict, "rule_id": rule_id, "reasoning": reasoning,
            "action": actions.get(verdict, "Diagnosis unavailable."),
            "customer_message": customer_message,
            "message_source": message_source,
            "voice_url": voice_url,
            "mechanism": choose_mechanism(db),
            "update_link": (card_update_link(tokenize("card", "4242"))
                            if diag and diag.archetype == "lifecycle" else None),
            "upi_autopay_link": (f"https://rzp.io/autopay/{uuid.uuid4().hex[:12]}"
                                 if diag and diag.archetype == "lifecycle" else None),
            "reschedule_link": (_reschedule_token(f.id) if verdict == "DEFER" else None),
        }

        db.query(GateDecision).filter_by(failure_id=f.id).delete()
        db.query(RecoveryAction).filter_by(failure_id=f.id).delete()
        db.query(Diagnosis).filter_by(failure_id=f.id).delete()
        db.query(PaymentFailure).filter_by(id=f.id).delete()

        if adversarial and adversarial["counter"]:
            db.add(AuditLog(
                entity_type="playground",
                entity_id=f.id,
                actor="advrsry",  # ← Fixed: 8 characters
                action=f"CHALLENGE_{adversarial['confidence']}",
                reasoning=f"Devil's Advocate: {adversarial['counter']}"
            ))

        db.commit()
        return out
    finally:
        db.close()

@router.get("/explain")
def explain(payment_id: str):
    """Grounded lookup: return the REAL stored diagnosis + gate decision for a payment."""
    db = SessionLocal()
    try:
        f = db.query(PaymentFailure).filter(
            PaymentFailure.external_payment_id.ilike(f"%{payment_id}%")).first()
        if not f:
            return {"found": False}
        diag = db.query(Diagnosis).filter_by(failure_id=f.id).first()
        gate = db.query(GateDecision).filter_by(failure_id=f.id).first()
        return {
            "found": True,
            "payment_id": f.external_payment_id,
            "rupees": round((f.amount_paise or 0) / 100, 2),
            "status": f.status,
            "archetype": diag.archetype if diag else None,
            "owner": diag.owner if diag else None,
            "verdict": gate.verdict if gate else None,
            "rule_id": gate.rule_id if gate else None,
            "reasoning": getattr(gate, "reasoning", None) if gate else None,
        }
    finally:
        db.close()

@router.get("/recon")
def recon():
    from app.core.reconciliation import run_reconciliation, find_limbo
    db = SessionLocal()
    try:
        opened = run_reconciliation(db)
        rows = find_limbo(db)
        return {"refund_jobs_opened": opened,
                "limbo": [{"payment_id": f.external_payment_id,
                           "rupees": round((f.amount_paise or 0) / 100, 2)} for f in rows]}
    finally:
        db.close()

@router.get("/mechanisms")
def mechanisms():
    from app.core.mechanism import mechanism_success_rates
    db = SessionLocal()
    try:
        return mechanism_success_rates(db)
    finally:
        db.close()

@router.get("/promises")
def promises():
    from app.db.models import Promise
    db = SessionLocal()
    try:
        rows = db.query(Promise).order_by(Promise.created_at.desc()).limit(20).all()
        return [{"id": p.id, "customer_id": p.customer_id,
                 "promised_at": p.promised_at.isoformat() if p.promised_at else None,
                 "status": p.status, "notes": p.notes} for p in rows]
    finally:
        db.close()

@router.post("/promises")
def create_promise_endpoint(failure_id: int, customer_id: str, promised_date: str):
    from datetime import datetime, timedelta
    from app.db.models import Promise
    db = SessionLocal()
    try:
        try:
            promised_at = datetime.fromisoformat(promised_date)
        except Exception:
            promised_at = datetime.now() + timedelta(days=7)
        p = Promise(failure_id=failure_id, customer_id=customer_id,
                    promised_at=promised_at, status="pending")
        db.add(p)
        db.commit()
        return {"id": p.id, "status": p.status, "promised_at": p.promised_at.isoformat()}
    finally:
        db.close()

@router.get("/mandate_jobs")
def mandate_jobs():
    db = SessionLocal()
    try:
        rows = db.query(Job).filter(Job.kind.like("MANDATE%")).order_by(Job.id.desc()).limit(12).all()
        out = []
        for j in rows:
            f = db.query(PaymentFailure).filter_by(id=j.failure_id).first()
            out.append({"payment_id": f.external_payment_id if f else "?",
                        "kind": j.kind,
                        "run_at": j.run_at.isoformat() if j.run_at else None})
        return out
    finally:
        db.close()

@router.get("/receivables")
def receivables():
    """Seeded once, then served from the database — stable across refreshes."""
    from app.db.models import Receivable
    db = SessionLocal()
    try:
        rows = db.query(Receivable).all()
        if not rows:
            import random
            from app.core.receivables import process_receivables
            random.seed(7)
            invoices = [{"id": f"INV-2026-{i:03d}",
                         "amount_inr": random.choice([15000, 42000, 80000, 120000]),
                         "dispute_raised": i % 5 == 2,
                         "cashflow_issue": i % 3 == 0 and i % 5 != 2,
                         "history_days": random.choice([[1, 1, 5], [15, 15, 20], [5, 10, 15]])}
                        for i in range(12)]
            for r in process_receivables(invoices):
                db.add(Receivable(invoice=r.get("invoice") or r.get("id"),
                                  action=r.get("action"), reason=r.get("reason", "")))
            db.commit()
            rows = db.query(Receivable).all()
        return [{"invoice": r.invoice, "action": r.action, "reason": r.reason} for r in rows]
    finally:
        db.close()

@router.get("/funnel")
def funnel():
    db = SessionLocal()
    try:
        rows = db.query(PaymentFailure).filter(
            PaymentFailure.source.in_(["synthetic", "orders_api"])).all()
        orders = len(rows)
        dropped_otp = sum(1 for r in rows if r.dropped_step == "otp")
        dropped_fees = sum(1 for r in rows if r.dropped_step == "fees")
        attempted = sum(1 for r in rows if r.session_active)
        recovered = sum(1 for r in rows if r.status == "recovered")
        return {"orders": orders, "dropped_fees": dropped_fees, "dropped_otp": dropped_otp,
                "attempted": attempted, "recovered": recovered,
                "leak": dropped_otp + dropped_fees}
    finally:
        db.close()

_AGENT_INTENTS = [
    (r"don.?t want|use nahi|nahi karna|band karo|stop|cancel|unsubscribe|refuse|mana kiya", "BLOCK", "LAW-1", "customer withdrew consent"),
    (r"kat gaye|kat gye|deduct|double|do baar|merchant.*(nhi|nahi|not)|pahunche", "BLOCK", "R-07", "money deducted but not settled"),
    (r"cash|store|left|shop|qr|offline|dukaan", "BLOCK", "R-07", "already paid cash in person"),
    (r"salary|broke|no money|balance|paise nahi|paisa nahi", "DEFER", "R-04", "short on money right now"),
    (r"mandate|rbi|24 ?h|pre.?debit", "BLOCK", "R-01", "RBI mandate notice issue"),
    (r"fee|shipping|hidden|extra charge", "BLOCK", "R-02", "surprised by hidden fees"),
    (r"expir|purana card", "ALLOW", "R-06", "saved card expired"),
    (r"net|internet|wifi|bank|server|timeout|upi.*down", "ALLOW", "R-05", "technical glitch"),
]

class AgentInput(BaseModel):
    text: str
    lang: str = "en"
    history: list = []
    voice: bool = False

@router.post("/agent")
def agent(inp: AgentInput):
    """Block only brand-reputation risks; answer everything else naturally, with memory + voice."""
    import re, asyncio, base64, io
    from datetime import datetime
    from app.core.llm import generate_text

    text, lang = inp.text, inp.lang

    def speak(reply_text):
        """On-the-fly TTS returned as base64 data URI (no static files needed)."""
        if not inp.voice or not reply_text:
            return None
        try:
            import edge_tts
            has_devanagari = bool(re.search(r"[ऀ-ॿ]", reply_text))
            voice_name = "hi-IN-SwaraNeural" if has_devanagari else "en-IN-NeerjaNeural"
            async def _tts():
                buf = io.BytesIO()
                comm = edge_tts.Communicate(reply_text, voice_name)
                async for chunk in comm.stream():
                    if chunk["type"] == "audio":
                        buf.write(chunk["data"])
                return base64.b64encode(buf.getvalue()).decode()
            return "data:audio/mpeg;base64," + asyncio.run(_tts())
        except Exception:
            return None

    # 0) Prompt-injection guard: deterministic, cannot be talked around
    injection = [
        r"ignore (all |any )?(previous|prior|above) (instructions|rules|prompts)",
        r"disregard (all |any )?(previous|prior|rules|instructions)",
        r"forget (everything|all|your) (instructions|rules|training)",
        r"override (the |your )?(rules|gate|policy|safety|consent)",
        r"bypass (the |your )?(gate|rules|safety|consent)",
        r"jailbreak",
        r"developer mode",
        r"you are now (a|an) ",
        r"pretend (you are|to be)",
        r"(retry|charge|deduct|authorize|approve).*(now|immediately|anyway) (without|no) (consent|confirmation)",
    ]
    if any(re.search(p, text, re.I) for p in injection):
        reply = ("Security notice: I detected an attempt to override my safety rules. "
                 "My Consent Gate is deterministic code — it cannot be overridden by any message. "
                 "I'm here to help with your payment. Bataiye, kya hua tha?"
                 if lang == "hi" else
                 "Security notice: I detected an attempt to override my safety rules. "
                 "My Consent Gate is deterministic code and cannot be overridden by any message. "
                 "I'm here to help with your payment. What went wrong?")
        try:
            from app.db.database import SessionLocal
            from app.db.models import AuditLog
            db = SessionLocal()
            db.add(AuditLog(entity_type="security", entity_id=0, actor="sec",
                            action="INJECT", reasoning=f"Prompt-injection attempt blocked: {text[:120]}"))
            db.commit(); db.close()
        except Exception:
            pass
        return {"reply": reply, "verdict": "BLOCK", "rule_id": "SEC-INJECT", "voice_data": speak(reply)}

    # 1) Brand guard: competitor questions → confident redirect
    if re.search(r"\b(justpay|juspay|stripe|paytm|phonepe|cashfree|gpay|google pay|amazon pay|competitor)\b|compare|which is better|\bvs\b", text, re.I):
        reply = ("Main Razorpay par bana hoon, isliye main apni team ke liye cheer karunga — Razorpay, har din! "
                 "Ab aapki payment ki baat karte hain. Bataiye, kya hua tha?"
                 if lang == "hi" else
                 "I'm built on Razorpay, so I'll cheer for my own team — Razorpay, every day! "
                 "Now let's fix your payment. What went wrong?")
        return {"reply": reply, "verdict": None, "rule_id": None, "voice_data": speak(reply)}

    # 2) Reputation guard: politics/religion/medical/legal/investment → neutral deflect
    if re.search(r"politic|election|religion|communal|caste|medical|medicine|doctor|legal|lawyer|lawsuit|stock|share market|crypto|bitcoin|\binvest\b", text, re.I):
        reply = ("Main sirf payments mein madad karta hoon — is topic par main koi ray nahi deta. Aapki payment ki baat karein?"
                 if lang == "hi" else
                 "I only help with payments — I don't give opinions on that. Shall we talk about your payment?")
        return {"reply": reply, "verdict": None, "rule_id": None, "voice_data": speak(reply)}

    # 3) Intent detection for safety verdicts
    verdict = rule = note = None
    for pat, v, r, n in _AGENT_INTENTS:
        if re.search(pat, text, re.I):
            verdict, rule, note = v, r, n
            break

    action = {
        "BLOCK": "Do NOT retry or move any money. Reassure the customer they are safe and nothing will be charged.",
        "DEFER": "The payment is moved to a better time (salary day). No reminders, no late fees.",
        "ALLOW": "A safe action was taken, or offer a safe one-tap option the customer approves first.",
    }.get(verdict, "")

    system = (
        "You are Revive AI, a warm human support agent for Indian payments, built ON Razorpay. "
        f"Today is {datetime.now().strftime('%A, %d %B %Y')}. "
        f"Reply in {'Hinglish (roman Hindi + English mix)' if lang=='hi' else 'English'}, matching the user's tone. "
        "2-4 short sentences, empathetic, no emojis. Address the customer's ACTUAL words. "
        "Speak as a team using 'hum/humne' (we) forms ONLY — never 'main chahta hoon/sochta hoon' — so the female voice sounds natural. Always finish every sentence completely. "
        "For harmless small talk or simple facts (date, time, greetings), answer briefly and friendly, then gently steer to payments. "
        "Never mention competitor brands. Never give political, religious, medical, legal, or investment opinions. "
        "You can see the recent conversation — use it to stay consistent and refer back to earlier messages when relevant. "
        + (f"Safety engine decided: {verdict} ({rule}) because {note}. {action} Respect this exactly. " if verdict else "")
        + "Never invent amounts, IDs, or promises."
    )
    reply = generate_text(system, text, max_tokens=220, history=inp.history)
    from app.core.validator import validate_customer_message
    if reply and not validate_customer_message(reply)[0]:
        reply = None  # validator rejected → deterministic fallback
    if not reply:
        if lang == "hi":
            reply = ("Samajh gaya. Main is par koi paisa nahi kataunga jab tak aap confirm na karein."
                     if verdict == "BLOCK" else
                     "Main Revive AI hoon — bataiye kya hua, main samajh kar madad karunga.")
        else:
            reply = ("Understood. I will not move any money until you confirm."
                     if verdict == "BLOCK" else
                     "I'm Revive AI — tell me what happened and I'll help.")
    return {"reply": reply, "verdict": verdict, "rule_id": rule, "voice_data": speak(reply)}

@router.post("/chat")
def chat(query: str, voice: bool = False):
    from app.core.llm import generate_text
    hi_markers = any(w in query.lower() for w in
                     ["hai", "kya", "kaise", "kaun", "tum", "aap", "mera", "meri", "nahi", "bhai", "namaste"])
    system_prompt = ("You are Revive AI, a warm, friendly payment-recovery assistant for an Indian audience, built ON Razorpay. "
                     "Reply in the same language/style the user writes (Hinglish or English). "
                     "Keep it to 2-3 short sentences. Never invent payment details. "
                     "You help with failed payments, refunds, double-charges and payment guidance.")
    reply = generate_text(system_prompt, query)
    if not reply:
        reply = ("Namaste! Main Revive AI hoon — failed payments, refunds aur payment issues mein madad karta hoon. Bataiye, kya hua?"
                 if hi_markers else
                 "Hi! I'm Revive AI — I help with failed payments, refunds and payment issues. Tell me what happened?")
    return {"reply": reply}

@router.post("/reply")
def reply(user_text: str, lang: str = "en", verdict: str = "", rule_id: str = "", note: str = ""):
    """Rules decide the action; the LLM composes a natural, language-matched reply."""
    from app.core.llm import generate_text
    action = {
        "BLOCK": "Do NOT retry or move any money. Reassure the customer they are safe.",
        "DEFER": "The payment is moved to a better time (salary day). No reminders, no late fees.",
        "ALLOW": "A safe action was taken, or offer a safe one-tap option.",
    }.get(verdict, "")
    system = (
        "You are Revive AI, a warm human support agent for Indian payments, built ON Razorpay. "
        f"Reply in {'Hinglish (roman Hindi + English mix)' if lang=='hi' else 'English'}, matching the user's tone. "
        "2-4 short sentences, empathetic, no emojis. Address the customer's ACTUAL words. "
        "You are proudly Razorpay-aligned, never neutral about competitors. "
        + (f"Safety engine decided: {verdict} ({rule_id}) because {note}. {action} Respect this exactly. " if verdict else
           "This is general conversation — no payment action needed. Be friendly and helpful. ")
        + "Never invent amounts, IDs, or promises."
    )
    text = generate_text(system, user_text, max_tokens=220)
    return {"reply": text}

@router.get("/explain_latest")
def explain_latest(customer_id: str = "cust_live_001"):
    """Grounded lookup for the 'logged in' user's most recent payment."""
    db = SessionLocal()
    try:
        f = db.query(PaymentFailure).filter_by(customer_id=customer_id) \
               .order_by(PaymentFailure.id.desc()).first()
        if not f:
            return {"found": False}
        diag = db.query(Diagnosis).filter_by(failure_id=f.id).first()
        gate = db.query(GateDecision).filter_by(failure_id=f.id).first()
        return {
            "found": True,
            "payment_id": f.external_payment_id,
            "rupees": round((f.amount_paise or 0) / 100, 2),
            "status": f.status,
            "archetype": diag.archetype if diag else None,
            "owner": diag.owner if diag else None,
            "verdict": gate.verdict if gate else None,
            "rule_id": gate.rule_id if gate else None,
        }
    finally:
        db.close()

@router.post("/upi_autopay_link")
def upi_autopay_link(customer_id: str = "cust_play", merchant_id: str = "merch_001", amount: int = 499):
    """Generates a mock Razorpay UPI Autopay mandate link for lifecycle/card failures."""
    import hashlib, time
    token = hashlib.sha256(f"{customer_id}{merchant_id}{time.time()}".encode()).hexdigest()[:16]
    return {
        "link": f"https://rzp.io/autopay/{token}",
        "mandate_type": "upi_autopay",
        "frequency": "as_presented",
        "max_amount": amount * 5,
        "reasoning": "Card failed repeatedly. Migrating customer to high-success UPI Autopay mandate."
    }

@router.post("/send_nudges")
def send_nudges(leak_type: str = "otp"):
    """Simulates sending recovery nudges (UPI Collect) to drop-off customers."""
    # In a real system, this would query the funnel and send via Razorpay/WhatsApp
    db = SessionLocal()
    try:
        from app.db.models import PaymentFailure
        if leak_type == "otp":
            count = db.query(PaymentFailure).filter(PaymentFailure.dropped_step == "otp").count()
        else:
            count = db.query(PaymentFailure).filter(PaymentFailure.dropped_step == "fees").count()
        
        # Simulate a 15% success rate on nudges
        estimated_recovery = count * 0.15
        return {
            "sent": count, 
            "channel": "upi_collect_request", 
            "estimated_recovery_count": int(estimated_recovery),
            "success_rate": 0.15
        }
    finally:
        db.close()

_VOICE_SCRIPTS = {
    "technical": "Bank mein temporary problem thi, ab fix ho gayi hai. Humne dobara koshish ki aur payment successful ho gayi. Aapko kuch karne ki zaroorat nahi.",
    "affordability": "Koi baat nahi! Humne payment aapke salary day tak shift kar di hai. Tab tak koi reminder nahi, koi late fee nahi.",
    "intent": "OTP mein problem ho gayi thi. Ab humne UPI Collect request bheji hai — one tap se approve kar sakte ho.",
    "lifecycle": "Aapka card expire ho gaya tha. Jab convenient ho, naya card update karein ya UPI Autopay set karein. Koi jaldi nahi.",
}
_voice_cache = {}

@router.get("/voice_stream")
def voice_stream(archetype: str = "technical"):
    """Live TTS showcase — synthesized on demand, cached in memory, zero files."""
    import asyncio, io, re
    import edge_tts
    from fastapi.responses import Response
    if archetype not in _voice_cache:
        text = _VOICE_SCRIPTS.get(archetype, _VOICE_SCRIPTS["technical"])
        voice = "hi-IN-SwaraNeural" if re.search(r"[ऀ-ॿ]", text) else "en-IN-NeerjaNeural"
        async def _tts():
            buf = io.BytesIO()
            comm = edge_tts.Communicate(text, voice)
            async for chunk in comm.stream():
                if chunk["type"] == "audio":
                    buf.write(chunk["data"])
            return buf.getvalue()
        _voice_cache[archetype] = asyncio.run(_tts())
    return Response(content=_voice_cache[archetype], media_type="audio/mpeg")

@router.get("/policy")
def policy():
    from app.core.policy import in_quiet_hours, next_allowed_slot
    from datetime import datetime
    from app.db.models import Promise, AuditLog
    db = SessionLocal()
    try:
        now = datetime.now()
        return {
            "quiet_window": "21:00 – 07:00 (TRAI DND)",
            "in_quiet_hours": in_quiet_hours(now),
            "next_allowed_slot": next_allowed_slot(now).strftime("%d %b, %H:%M"),
            "active_promises": db.query(Promise).filter_by(status="pending").count(),
            "promise_halts": db.query(AuditLog).filter_by(action="P_HALT").count(),
        }
    finally:
        db.close()

@router.get("/channels")
def channels():
    db = SessionLocal()
    try:
        counts = dict(db.query(Diagnosis.archetype, func.count(Diagnosis.id))
                      .group_by(Diagnosis.archetype).all())
        plan = [
            ("technical", "Silent retry — zero outreach (Law 3)"),
            ("intent", "WhatsApp + UPI Collect one-tap"),
            ("affordability", "Hinglish voice call + Promise-to-Pay"),
            ("lifecycle", "Email + tokenized card-update link"),
        ]
        return [{"archetype": a, "channel": c, "cases": counts.get(a, 0)} for a, c in plan]
    finally:
        db.close()

import hashlib

def _reschedule_token(failure_id: int) -> str:
    sig = hashlib.sha256(f"revive:{failure_id}".encode()).hexdigest()[:8]
    return f"{failure_id}-{sig}"

def _verify_token(token: str):
    try:
        fid, sig = token.split("-", 1)
        fid = int(fid)
    except Exception:
        return None
    if hashlib.sha256(f"revive:{fid}".encode()).hexdigest()[:8] == sig:
        return fid
    return None

RESCHEDULE_HTML = """<!DOCTYPE html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Pick your payment day — Revive AI</title>
<style>body{font-family:Inter,system-ui,sans-serif;background:#f4f7fc;display:flex;align-items:center;justify-content:center;min-height:100vh;margin:0}
.card{background:#fff;border:1.5px solid #0a0f1a;border-radius:20px;padding:32px;max-width:420px;width:92%;box-shadow:8px 8px 0 rgba(11,92,255,.2)}
h1{font-size:22px;margin:0 0 6px}p{color:#6b7a90;font-size:14px;line-height:1.6}
.amt{font-size:30px;font-weight:800;color:#0b5cff;margin:12px 0}
input[type=range]{width:100%;accent-color:#0b5cff}
.day{font-size:40px;font-weight:800;text-align:center;color:#0a0f1a;margin:8px 0}
button{width:100%;background:#0b5cff;color:#fff;border:none;border-radius:999px;padding:14px;font-weight:700;font-size:15px;cursor:pointer;margin-top:12px}
button:hover{background:#0a0f1a}.ok{color:#149a52;font-weight:700;text-align:center;margin-top:12px}
small{color:#6b7a90}</style></head><body><div class="card">
<h1>When do you get paid?</h1>
<p>No pressure. Pick a day that works for you and we'll quietly retry then — no reminders, no late fees.</p>
<div class="amt">₹__RUPEES__</div>
<div class="day" id="d">5</div>
<input type="range" min="1" max="30" value="5" id="r" oninput="document.getElementById('d').textContent=this.value">
<button onclick="go()">Confirm my day ▸</button>
<div class="ok" id="ok"></div>
<small>100% your choice · Law 1: no money without consent</small>
</div><script>
function go(){var day=document.getElementById('r').value;
fetch('/api/reschedule',{method:'POST',headers:{'Content-Type':'application/json'},
body:JSON.stringify({failure_id:__FID__,day:+day})}).then(r=>r.json()).then(o=>{
document.getElementById('ok').textContent=o.ok?('Done! We\\'ll retry on day '+day+'. No reminders until then.'):'Something went wrong.';});}
</script></body></html>"""

@router.get("/reschedule/{token}", response_class=HTMLResponse)
def reschedule_page(token: str):
    from fastapi.responses import HTMLResponse as _H
    fid = _verify_token(token)
    if fid is None:
        return _H("<h1>Invalid or expired link.</h1>", status_code=404)
    db = SessionLocal()
    try:
        f = db.query(PaymentFailure).filter_by(id=fid).first()
        if not f:
            return _H("<h1>Payment not found.</h1>", status_code=404)
        rupees = round((f.amount_paise or 0) / 100, 2)
    finally:
        db.close()
    return _H(RESCHEDULE_HTML.replace("__FID__", str(fid)).replace("__RUPEES__", str(rupees)))

class RescheduleInput(BaseModel):
    failure_id: int
    day: int

@router.post("/reschedule")
def reschedule(inp: RescheduleInput):
    from datetime import datetime
    from app.core.policy import next_allowed_slot
    from app.db.models import Promise
    db = SessionLocal()
    try:
        f = db.query(PaymentFailure).filter_by(id=inp.failure_id).first()
        if not f:
            return {"ok": False}
        now = datetime.now()
        day = max(1, min(30, inp.day))
        try:
            target = now.replace(day=day, hour=9, minute=0, second=0, microsecond=0)
        except ValueError:
            target = now.replace(day=30, hour=9, minute=0, second=0, microsecond=0)
        if target <= now:
            target = target.replace(month=now.month + 1) if now.month < 12 else target.replace(year=now.year + 1, month=1)
        target = next_allowed_slot(target)
        p = db.query(Promise).filter_by(failure_id=f.id, status="pending").first()
        if not p:
            p = Promise(failure_id=f.id, customer_id=f.customer_id, status="pending")
            db.add(p)
        p.promised_at = target
        p.notes = f"Customer self-served reschedule to day {day}."
        f.status = "deferred"
        job = db.query(Job).filter_by(failure_id=f.id, status="queued").first()
        if not job:
            job = Job(failure_id=f.id, kind="RETRY", run_at=target, status="queued")
            db.add(job)
        else:
            job.run_at = target
        db.add(AuditLog(entity_type="promise", entity_id=f.id, actor="cust",
                        action="RESCHED", reasoning=f"Customer chose day {day} via self-serve portal. Retry at {target}."))
        db.commit()
        return {"ok": True, "scheduled": target.strftime("%d %b, %H:%M")}
    finally:
        db.close()

@router.get("/whatsapp")
def whatsapp():
    """Mock WhatsApp recovery conversation: Hinglish text + voice note + 1-tap Razorpay link."""
    from app.db.models import Diagnosis
    db = SessionLocal()
    try:
        f = (db.query(PaymentFailure)
             .filter(PaymentFailure.status.in_(["deferred", "pending", "recovered"]))
             .order_by(PaymentFailure.id.desc()).first())
        diag = db.query(Diagnosis).filter_by(failure_id=f.id).first() if f else None
        archetype = diag.archetype if diag else "affordability"
        rupees = round((f.amount_paise or 0) / 100, 2) if f else 499
        pay_id = f.external_payment_id if f else "pay_demo000"
    finally:
        db.close()
    scripts = {
        "technical": "bank server mein thodi der ki dikkat thi, ab fix ho gayi hai. Aapko kuch karne ki zaroorat nahi.",
        "affordability": "koi baat nahi! Payment aapke salary day tak shift kar di hai. Chaaho toh abhi 1-tap se pay kar sakte ho.",
        "intent": "OTP par atak gayi thi payment — UPI Collect request bheji hai, 1 tap mein approve kar do.",
        "lifecycle": "aapka card expire ho gaya tha. Naya card update karo ya 1-tap UPI Autopay set karo.",
    }
    ctas = {
        "technical": None,  # already recovered — never ask for money again
        "affordability": {"label": f"Pay ₹{rupees} now (1-tap) →", "url": f"https://rzp.io/r/{pay_id[-6:]}"},
        "intent": {"label": "Approve UPI Collect (1-tap) →", "url": f"https://rzp.io/r/{pay_id[-6:]}"},
        "lifecycle": {"label": "Set up UPI Autopay →", "url": f"https://rzp.io/autopay/{pay_id[-6:]}"},
    }
    return {
        "customer": "+91 ••••• 4821",
        "merchant": "ShopKart",
        "rupees": rupees,
        "payment_id": pay_id,
        "text": scripts.get(archetype, scripts["affordability"]),
        "voice_url": f"/api/voice_stream?archetype={archetype}",
        "cta": ctas.get(archetype, ctas["affordability"]),
    }

@router.get("/merchant_insights")
def merchant_insights():
    """Revive AI as free product consultant: money-valued checkout fixes per merchant."""
    rows = None
    db = SessionLocal()
    try:
        rows = (db.query(PaymentFailure.merchant_id,
                         PaymentFailure.dropped_step,
                         PaymentFailure.true_archetype,
                         func.count(PaymentFailure.id).label("n"),
                         func.sum(PaymentFailure.amount_paise).label("amt"))
                .filter(PaymentFailure.source.in_(["synthetic", "orders_api"]))
                .group_by(PaymentFailure.merchant_id,
                          PaymentFailure.dropped_step,
                          PaymentFailure.true_archetype).all())
    finally:
        db.close()

    merchants = {}
    for m, step, arch, n, amt in rows:
        key = "fees" if step == "fees" else "otp" if step == "otp" else (arch or "other")
        e = merchants.setdefault(m, {}).setdefault(key, {"n": 0, "amt": 0.0})
        e["n"] += n
        e["amt"] += float(amt or 0) / 100

    plan = [
        ("fees", 0.30, "dropped at fee reveal", "Show ALL fees on the cart page, not at checkout"),
        ("otp", 0.45, "stuck at OTP step", "Swap OTP flow to UPI Collect (1-tap approve)"),
        ("lifecycle", 0.50, "expired-card failures", "Offer UPI Autopay migration at first card failure"),
        ("affordability", 0.60, "low-balance failures", "Enable salary-day defer + Promise-to-Pay"),
    ]
    out = []
    for m, d in merchants.items():
        ins = []
        for key, rate, issue, action in plan:
            if key in d and d[key]["n"]:
                ins.append({"issue": f"{d[key]['n']} customers {issue}",
                            "action": action,
                            "save": round(d[key]["amt"] * rate)})
        if ins:
            out.append({"merchant": m, "insights": ins,
                        "total_save": sum(i["save"] for i in ins)})
    out.sort(key=lambda x: -x["total_save"])
    return out

def _recovery_score(f, gate):
    """Deterministic recovery score: verdict × amount × context × freshness."""
    if not gate or gate.verdict == "BLOCK":
        return 0
    base = 90 if gate.verdict == "ALLOW" else 65
    amt = min((f.amount_paise or 0) / 1e5, 1.5)  # up to 1.5× boost for large amounts
    ctx = 1.2 if getattr(f, "session_active", False) else 1.0
    if f.occurred_at:
        occurred = f.occurred_at.replace(tzinfo=None) if f.occurred_at.tzinfo else f.occurred_at
        age_hours = max(0.1, (datetime.now() - occurred).total_seconds() / 3600)
    else:
        age_hours = 1
    fresh = max(0.5, 1.0 - (age_hours / 72))  # decays over 3 days
    return round(base * (0.6 + amt) * ctx * fresh)

@router.get("/recovery_center")
def recovery_center(limit: int = 20):
    """Ranked queue of recoverable failures — highest score first."""
    db = SessionLocal()
    MIN_INTERVENTION_VALUE = 100  # Don't recover payments under ₹100
    try:
        rows = (db.query(PaymentFailure, GateDecision)
                .join(GateDecision, GateDecision.failure_id == PaymentFailure.id)
                .filter(GateDecision.verdict.in_(["ALLOW", "DEFER"]))
                .filter(PaymentFailure.status != "recovered")
                .order_by(PaymentFailure.id.desc())
                .limit(50).all())
        scored = []
        for f, gate in rows:
            rupees = (f.amount_paise or 0) / 100
            if rupees < MIN_INTERVENTION_VALUE:
                continue  # Skip sub-economic interventions
            
            s = _recovery_score(f, gate)
            if s > 0:
                scored.append({
                    "payment_id": f.external_payment_id,
                    "rupees": round(rupees, 2),
                    "verdict": gate.verdict,
                    "rule_id": gate.rule_id,
                    "score": s,
                    "bucket": "HIGH" if s >= 80 else "MEDIUM" if s >= 55 else "LOW",
                    "occurred": f.occurred_at.isoformat() if f.occurred_at else None,
                })
        scored.sort(key=lambda x: -x["score"])
        return scored[:limit]
    finally:
        db.close()

@router.post("/recovery_batch")
def recovery_batch(bucket: str = "HIGH"):
    """Mock 'batch recover' for a priority bucket — logs each as RESCHED action."""
    db = SessionLocal()
    try:
        rows = (db.query(PaymentFailure, GateDecision)
                .join(GateDecision, GateDecision.failure_id == PaymentFailure.id)
                .filter(GateDecision.verdict.in_(["ALLOW", "DEFER"]))
                .filter(PaymentFailure.status != "recovered")
                .all())
        processed = 0
        recovered_rupees = 0.0
        for f, gate in rows:
            s = _recovery_score(f, gate)
            b = "HIGH" if s >= 80 else "MEDIUM" if s >= 55 else "LOW"
            if b == bucket and f.status != "recovered":
                f.status = "recovered"
                f.amount_recovered_paise = f.amount_paise
                recovered_rupees += round((f.amount_paise or 0) / 100, 2)
                db.add(AuditLog(entity_type="failure", entity_id=f.id, actor="batch",
                                action="BATCH",
                                reasoning=f"Batch-recovered {bucket} priority case (score {s})."))
                processed += 1
        db.commit()
        return {"processed": processed, "bucket": bucket, "recovered_rupees": round(recovered_rupees, 2)}
    finally:
        db.close()

NATURAL_P = {
    ("technical", True): 0.85, ("technical", False): 0.55,
    ("intent", True): 0.45, ("intent", False): 0.30,
    ("affordability", True): 0.35, ("affordability", False): 0.22,
    ("lifecycle", True): 0.20, ("lifecycle", False): 0.12,
}

@router.get("/uplift")
def uplift(cost: float = 2.0, boost: float = 1.0, limit: int = 15):
    """Incremental uplift: act only when intervention creates value beyond natural recovery."""
    from app.core.mechanism import mechanism_success_rates
    db = SessionLocal()
    try:
        rows = (db.query(PaymentFailure, Diagnosis)
                .join(Diagnosis, Diagnosis.failure_id == PaymentFailure.id)
                .join(GateDecision, GateDecision.failure_id == PaymentFailure.id)
                .filter(GateDecision.verdict.in_(["ALLOW", "DEFER"]))
                .filter(PaymentFailure.status != "recovered")
                .order_by(PaymentFailure.amount_paise.desc())
                .limit(300).all())
        rates = {m["method"]: m["success_rate"] for m in mechanism_success_rates(db)}
    finally:
        db.close()
    out, tot_ev, act_n, conf_n, abs_n, waste = [], 0.0, 0, 0, 0, 0.0
    for f, d in rows:
        rupees = (f.amount_paise or 0) / 100
        p_nat = NATURAL_P.get((d.archetype, bool(f.session_active)), 0.3)
        p_treat = min(0.95, rates.get(f.method, 0.5) * 1.15 * boost)
        up = max(0.0, p_treat - p_nat)
        ev = up * rupees - cost
        if ev > 0:
            decision = "ACT" if rupees <= 5000 else "CONFIRM"  # hard stop: >₹5k needs human
            if decision == "CONFIRM": conf_n += 1
            act_n += 1; tot_ev += ev
        else:
            decision = "ABSTAIN"; abs_n += 1; waste += cost
        out.append({"payment_id": f.external_payment_id, "rupees": round(rupees, 2),
                    "archetype": d.archetype, "p_natural": p_nat, "p_treat": round(p_treat, 2),
                    "uplift": round(up, 2), "incremental_ev": round(ev, 2),
                    "decision": decision})
    out.sort(key=lambda r: -r["incremental_ev"])
    return {"rows": out[:limit], "act": act_n, "confirm": conf_n, "abstain": abs_n,
            "total_incremental_ev": round(tot_ev, 2), "waste_avoided": round(waste, 2)}

@router.post("/simulate_call")
def simulate_call():
    from datetime import datetime, timedelta
    from app.db.models import Promise
    db = SessionLocal()
    try:
        row = (db.query(PaymentFailure, Diagnosis)
               .join(Diagnosis, Diagnosis.failure_id == PaymentFailure.id)
               .filter(Diagnosis.archetype == "affordability")
               .filter(PaymentFailure.status != "recovered")
               .order_by(PaymentFailure.id.desc()).first())
        if not row:
            return {"ok": False}
        f, d = row
        promised = (datetime.now() + timedelta(days=1)).replace(hour=17, minute=0, second=0, microsecond=0)
        p = db.query(Promise).filter_by(failure_id=f.id, status="pending").first()
        if not p:
            p = Promise(failure_id=f.id, customer_id=f.customer_id, status="pending")
            db.add(p)
        p.promised_at = promised
        p.notes = "Promise captured via simulated voice call."
        db.add(AuditLog(entity_type="promise", entity_id=f.id, actor="voice",
                        action="CALL", reasoning=f"Voice call captured promise-to-pay for {f.customer_id} at {promised}."))
        db.commit()
        return {"ok": True, "customer": f.customer_id,
                "rupees": round((f.amount_paise or 0) / 100, 2),
                "promised": promised.strftime("%d %b, %I:%M %p"),
                "voice_url": "/api/voice_stream?archetype=affordability"}
    finally:
        db.close()

@router.get("/benchmark")
def benchmark():
    """Offline strategy comparison: No Action vs Spam-All vs Revive AI."""
    db = SessionLocal()
    try:
        totals = db.query(
            func.count(PaymentFailure.id),
            func.sum(PaymentFailure.amount_paise),
            func.sum(PaymentFailure.amount_recovered_paise)).first()
        verdicts = dict(db.query(GateDecision.verdict, func.count(GateDecision.id))
                        .group_by(GateDecision.verdict).all())
    finally:
        db.close()
    n = totals[0] or 0
    at_risk = float(totals[1] or 0) / 100
    recovered = float(totals[2] or 0) / 100
    allow, defer, block = verdicts.get("ALLOW", 0), verdicts.get("DEFER", 0), verdicts.get("BLOCK", 0)
    natural_rate, blind_rate = 0.10, 0.25
    return {
        "no_action": {"recovered_rupees": round(at_risk * natural_rate, 2), "contacts": 0, "double_charges": 0},
        "spam_all": {"recovered_rupees": round(at_risk * blind_rate, 2), "contacts": n, "double_charges": block},
        "revive_ai": {"recovered_rupees": round(recovered, 2), "contacts": allow + defer, "double_charges": 0},
    }

@router.get("/manual_review")
def manual_review():
    """Compliance/structural blocks routed to humans — never auto-outreach."""
    db = SessionLocal()
    try:
        rows = (db.query(PaymentFailure, GateDecision)
                .join(GateDecision, GateDecision.failure_id == PaymentFailure.id)
                .filter(GateDecision.rule_id.in_(["R01_RBI_MANDATE", "R03_STRUCTURAL_STOP", "R08_RETRY_BUDGET"]))
                .order_by(PaymentFailure.id.desc()).limit(20).all())
        return [{"payment_id": f.external_payment_id,
                 "rupees": round((f.amount_paise or 0) / 100, 2), "rule": g.rule_id} for f, g in rows]
    finally:
        db.close()

@router.get("/attribution")
def attribution():
    """Two-signal honesty: recovered only when capture + link-paid match within 30 min."""
    db = SessionLocal()
    try:
        live = db.query(func.count(PaymentFailure.id)).filter_by(status="recovered", source="live").scalar() or 0
        sim = db.query(func.count(PaymentFailure.id)).filter_by(status="recovered") \
                .filter(PaymentFailure.source != "live").scalar() or 0
        return {"window_minutes": 30, "live_two_signal": live,
                "simulated_dual_signal": sim, "malformed_dropped": _DROPPED["count"]}
    finally:
        db.close()

@router.get("/zombies")
def zombies():
    """Zombie subscription guard: pause billed-but-inactive users BEFORE chargebacks."""
    import random
    random.seed(11)
    rows, saved = [], 0
    for i in range(12):
        monthly = random.choice([199, 499, 999, 1499])
        months = random.choice([1, 2, 4, 6, 8])
        idle = random.choice([5, 20, 45, 75, 120, 160])
        zombie = idle > 60 and months >= 3
        action = ("PAUSE + CONFIRM" if monthly > 500 else "AUTO_PAUSE") if zombie else "HEALTHY"
        if zombie:
            saved += monthly
        rows.append({"sub_id": f"sub_{i+1:03d}", "monthly": monthly, "months_billed": months,
                     "idle_days": idle, "zombie": zombie, "action": action})
    return {"rows": rows, "monthly_savings": saved}

@router.get("/confirm_queue")
def confirm_queue():
    """High-value recoveries above the merchant auto-limit wait for a human."""
    db = SessionLocal()
    try:
        rows = (db.query(PaymentFailure, GateDecision)
                .join(GateDecision, GateDecision.failure_id == PaymentFailure.id)
                .filter(GateDecision.verdict == "ALLOW")
                .filter(PaymentFailure.amount_paise > 300000)
                .filter(PaymentFailure.status.in_(["pending", "deferred"]))
                .order_by(PaymentFailure.amount_paise.desc()).limit(20).all())
        return [{"id": f.id, "payment_id": f.external_payment_id,
                 "rupees": round((f.amount_paise or 0) / 100, 2), "rule": g.rule_id} for f, g in rows]
    finally:
        db.close()

@router.post("/confirm_action")
def confirm_action(failure_id: int, approve: bool):
    db = SessionLocal()
    try:
        f = db.query(PaymentFailure).filter_by(id=failure_id).first()
        if not f:
            return {"ok": False}
        if approve:
            f.status = "recovered"
            f.amount_recovered_paise = f.amount_paise
            action, why = "APPROVE", f"Human approved high-value recovery of ₹{round((f.amount_paise or 0)/100,2)}."
        else:
            f.status = "protected"
            action, why = "REJECT", f"Human rejected auto-recovery of ₹{round((f.amount_paise or 0)/100,2)}; customer protected."
        db.add(AuditLog(entity_type="failure", entity_id=f.id, actor="human",
                        action=action, reasoning=why))
        db.commit()
        return {"ok": True, "approved": approve}
    finally:
        db.close()