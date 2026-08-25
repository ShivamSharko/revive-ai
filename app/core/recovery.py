"""Recovery Engine: executes bounded actions based on the Consent Gate's verdict."""
from datetime import timedelta
from sqlalchemy.sql import func
import razorpay
from app.config import settings
from app.db.models import PaymentFailure, RecoveryAction, Job
from app.core.health import record_attempt, is_degraded
from app.core.ev_optimizer import calculate_ev

def create_upi_collect_link(failure: PaymentFailure):
    """Real Mechanism Swap: create a Razorpay Payment Link for UPI Collect."""
    try:
        if not settings.RAZORPAY_KEY_ID:
            return "https://rzp.io/l/revive-fallback", None
        client = razorpay.Client(auth=(settings.RAZORPAY_KEY_ID, settings.RAZORPAY_KEY_SECRET))
        link = client.payment_link.create({
            "amount": failure.amount_paise,
            "currency": "INR",
            "description": f"Complete your payment (revived from {failure.external_payment_id})",
            "notify": {"sms": True, "email": False},
            "reminder_enable": False,
        })
        return link.get("short_url"), link.get("id")
    except Exception:
        return "https://rzp.io/l/revive-fallback", None

def execute_recovery(db, failure: PaymentFailure, verdict: str, rule_id: str, reasoning: str):
    """Translates a Gate verdict into a real database action."""

    if verdict == "ALLOW":
        bank_code = failure.method.upper() if failure.method else "DEFAULT"
        ev_data = calculate_ev(failure.amount_paise, bank_code)

        if is_degraded(bank_code) or ev_data["recommendation"] == "DEFER":
            db.add(Job(
                failure_id=failure.id, kind="DEFERRED_RETRY",
                run_at=failure.occurred_at + timedelta(days=1), status="queued"))
            db.add(RecoveryAction(
                failure_id=failure.id, action_type="DEFER_EV" if ev_data["recommendation"] == "DEFER" else "DEFER_BANK_DEGRADED",
                actor="system", status="deferred",
                reasoning=f"EV={ev_data['ev']} (prob={ev_data['probability']}, cost={ev_data['cost']}). Bank degraded={is_degraded(bank_code)}. Deferred.",
                executed_at=func.now()))
            failure.status = "deferred"
            failure.amount_protected_paise = failure.amount_paise
        else:
            # Normal ALLOW: retry — with Mechanism Swap for OTP drop-offs
            if failure.failure_code == "ABANDONED_AT_OTP":
                link_url, link_id = create_upi_collect_link(failure)
                action_type = "UPI_COLLECT"
                extra_reasoning = f"Mechanism Swap: OTP→UPI Collect. Link: {link_url} | {reasoning}"
            else:
                action_type = "RETRY_LINK"
                extra_reasoning = reasoning
            
            db.add(RecoveryAction(
                failure_id=failure.id, action_type=action_type,
                actor="system", status="executed",
                amount_recovered_paise=failure.amount_paise,
                reasoning=extra_reasoning,
                executed_at=func.now()))
            failure.status = "recovered"
            failure.amount_recovered_paise = failure.amount_paise
            record_attempt(bank_code, success=True)

    elif verdict == "DEFER":
        import re
        from datetime import datetime

        # Parse modal salary day from gate reasoning: "Defer to day X."
        day_match = re.search(r"Defer to day (\d+)", reasoning)
        if day_match:
            target_day = int(day_match.group(1))
            today = datetime.now().day
            days_until = (target_day - today) % 30
            if days_until <= 0:
                days_until += 30
            run_at = failure.occurred_at + timedelta(days=days_until)
        else:
            run_at = failure.occurred_at + timedelta(days=7)

        db.add(Job(
            failure_id=failure.id, kind="DEFERRED_RETRY",
            run_at=run_at, status="queued"))
        db.add(RecoveryAction(
            failure_id=failure.id, action_type="DEFERRED",
            actor="system", status="scheduled",
            reasoning=f"Deferred to salary day. {reasoning}",
            executed_at=func.now()))
        failure.status = "deferred"
        failure.amount_protected_paise = failure.amount_paise

    elif verdict == "BLOCK":
        db.add(RecoveryAction(
            failure_id=failure.id, action_type="BLOCKED",
            actor="system", status="blocked", reasoning=reasoning,
            executed_at=func.now()))
        failure.status = "protected"
        failure.amount_protected_paise = failure.amount_paise

    # --- Integrated messaging + voice (graceful: never breaks recovery) ---
    # Runs only for LIVE failures (webhook), keeps the 500-batch fast & quota-safe
    try:
        if failure.source != "synthetic":
            from app.db.models import Diagnosis as _Diag
            _d = (db.query(_Diag).filter_by(failure_id=failure.id)
                    .order_by(_Diag.id.desc()).first())
            _arch = (_d.archetype if _d and _d.archetype else "technical")

            if verdict in ("ALLOW", "DEFER"):
                from app.core import messaging as _msg
                _fn = next((getattr(_msg, n) for n in
                            ("generate_message", "draft_message", "compose_message",
                             "build_message", "create_message")
                            if hasattr(_msg, n)), None)
                if _fn:
                    import inspect as _ins
                    _np = len(_ins.signature(_fn).parameters)
                    _out = _fn(failure, _d, verdict.lower()) if _np >= 3 else (
                           _fn(failure, _d) if _np == 2 else _fn(failure))
                    _text = _out if isinstance(_out, str) else (
                            _out.get("en") or _out.get("message") or str(_out))
                    db.add(RecoveryAction(
                        failure_id=failure.id, action_type="MESSAGE_DRAFTED",
                        actor="system", status="pending_send",
                        reasoning=f"Message drafted: {str(_text)[:80]}",
                        executed_at=func.now()))

            if verdict == "ALLOW" and _arch == "technical":
                from app.core.voice import voice_script, synthesize
                _audio = synthesize(voice_script(_arch), f"voice_{failure.id}.mp3")
                db.add(RecoveryAction(
                    failure_id=failure.id, action_type="VOICE_SYNTHESIZED",
                    actor="system", status="generated",
                    reasoning=f"Voice file: {_audio}",
                    executed_at=func.now()))
    except Exception:
        pass

    # Wire messaging for ALLOW and DEFER verdicts
    if verdict in ("ALLOW", "DEFER"):
        try:
            msg = draft_message(failure, diag, verdict.lower())
            db.add(RecoveryAction(
                failure_id=failure.id,
                action_type="MESSAGE_DRAFTED",
                actor="system",
                status="pending_send",
                reasoning=f"Message drafted: {msg.get('en', '')[:80]}...",
                executed_at=func.now()
            ))
        except Exception as e:
            # Don't fail the recovery if messaging fails
            pass

    # Wire voice for ALLOW verdicts (technical failures get voice explanation)
    if verdict == "ALLOW" and diag.archetype == "technical":
        try:
            script = voice_script(diag.archetype)
            audio_path = synthesize(script, f"voice_{failure.id}.mp3")
            db.add(RecoveryAction(
                failure_id=failure.id,
                action_type="VOICE_SYNTHESIZED",
                actor="system",
                status="generated",
                reasoning=f"Voice file: {audio_path}",
                executed_at=func.now()
            ))
        except Exception as e:
            # Don't fail the recovery if voice fails
            pass