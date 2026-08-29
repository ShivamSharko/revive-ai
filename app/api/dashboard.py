"""Read-only dashboard API: the agent's brain state as clean JSON."""
from fastapi import APIRouter
from sqlalchemy import func

from app.core.audit import audit_merchant_compliance
from app.db.database import SessionLocal
from app.db.models import (AuditLog, Diagnosis, GateDecision, RecoveryAction, Job, PaymentFailure)

from pydantic import BaseModel

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
            import re as _re
            if _re.search(r"kat gay|kat gye|deduct|double|do baar|dubara|merchant.{0,20}(nhi|nahi|not)|pahunche|refund",
                          inp.failure_description, _re.I):
                verdict, rule_id, reasoning = ("BLOCK", "DOUBLE_CHARGE_GUARD",
                    "Customer reports deduction without settlement — a retry would double-charge. "
                    "Reconciliation + auto-refund instead.")

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
        customer_message = MSG.get(key, "Humne payment issue samajh liya hai aur safely handle kar rahe hain. Aapko spam nahi karenge.")

        voice_url = None
        if inp.voice:
            voice_file = f"voice_play_{ext_id}.mp3"
            try:
                async def _tts():
                    comm = edge_tts.Communicate(customer_message, "hi-IN-MadhurNeural")
                    await comm.save(os.path.join(ROOT, voice_file))
                asyncio.run(_tts())
                voice_url = "/voice/" + voice_file
            except Exception:
                voice_url = None

        out = {
            "payment_id": ext_id,
            "diagnosis": {"archetype": diag.archetype, "owner": diag.owner,
                          "confidence": round(getattr(diag, "confidence", 0) or 0, 2),
                          "model": model} if diag else None,
            "verdict": verdict, "rule_id": rule_id, "reasoning": reasoning,
            "action": actions.get(verdict, "Diagnosis unavailable."),
            "customer_message": customer_message,
            "voice_url": voice_url,
            "mechanism": choose_mechanism(db),
            "update_link": (card_update_link(tokenize("card", "4242"))
                            if diag and diag.archetype == "lifecycle" else None),
        }

        db.query(GateDecision).filter_by(failure_id=f.id).delete()
        db.query(RecoveryAction).filter_by(failure_id=f.id).delete()
        db.query(Diagnosis).filter_by(failure_id=f.id).delete()
        db.query(PaymentFailure).filter_by(id=f.id).delete()
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
    import random
    from app.core.receivables import process_receivables
    random.seed(7)
    invoices = [{"id": f"INV-2026-{i:03d}",
                 "amount_inr": random.choice([15000, 42000, 80000, 120000]),
                 "dispute_raised": i % 5 == 2,
                 "cashflow_issue": i % 3 == 0 and i % 5 != 2,
                 "history_days": random.choice([[1, 1, 5], [15, 15, 20], [5, 10, 15]])}
                for i in range(12)]
    return process_receivables(invoices)

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

@router.post("/agent")
def agent(text: str, lang: str = "en"):
    """Rules decide the action; the LLM writes every reply."""
    import re
    from app.core.llm import generate_text

    # Brand guard: competitor / comparison questions get a confident redirect (rules, not AI)
    if re.search(r"\b(justpay|juspay|stripe|paytm|phonepe|cashfree|competitor)\b|compare|which is better|\bvs\b", text, re.I):
        return {
            "reply": ("Main Razorpay par bana hoon, isliye main apni team ke liye cheer karunga — Razorpay, har din! "
                      "Ab aapki payment ki baat karte hain. Bataiye, kya hua tha?"
                      if lang == "hi" else
                      "I'm built on Razorpay, so I'll cheer for my own team — Razorpay, every day! "
                      "Now let's fix your payment. What went wrong?"),
            "verdict": None, "rule_id": None,
        }

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
        f"Reply in {'Hinglish (roman Hindi + English mix)' if lang=='hi' else 'English'}, matching the user's tone. "
        "2-4 short sentences, empathetic, no emojis. Address the customer's ACTUAL words. "
        + (f"Safety engine decided: {verdict} ({rule}) because {note}. {action} Respect this exactly. " if verdict else
           "This is general conversation — no payment action needed. Be friendly and helpful. ")
        + "Never invent amounts, IDs, or promises."
    )
    reply = generate_text(system, text, max_tokens=220)
    if not reply:
        if lang == "hi":
            reply = ("Samajh gaya. Main is par koi paisa nahi kataunga jab tak aap confirm na karein."
                     if verdict == "BLOCK" else
                     "Main Revive AI hoon — bataiye kya hua, main samajh kar madad karunga.")
        else:
            reply = ("Understood. I will not move any money until you confirm."
                     if verdict == "BLOCK" else
                     "I'm Revive AI — tell me what happened and I'll help.")
    return {"reply": reply, "verdict": verdict, "rule_id": rule}

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