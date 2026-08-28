"""Recovery Engine: executes bounded actions based on the Consent Gate's verdict."""
from datetime import timedelta
from sqlalchemy.sql import func
from app.config import settings
from app.db.models import PaymentFailure, RecoveryAction, Job
from app.core.health import record_attempt, is_degraded
from app.core.ev_optimizer import calculate_ev
from app.core.messaging import generate_message
from app.core.voice import voice_script, synthesize
from app.razorpay.client import get_client

RULE_REASONS = {
    "R01_RBI_MANDATE": "Pre-debit notification < 24h. RBI compliance block.",
    "R02_FEE_SHOCK": "Hidden fees caused abandonment. Do not retry.",
    "R03_STRUCTURAL_STOP": "Repeated failures. Spamming will cause churn.",
    "R04_LIQUIDITY_DEFER": "Insufficient funds. Deferred to salary day.",
    "R05_TECH_RETRY": "Transient technical failure. Safe to retry.",
    "R06_DEFAULT_ALLOW": "No blocking rules triggered.",
    "R07_OFFLINE_QR_TRAP": "Customer left store. Silent retry blocked to prevent double-charge.",
}

def create_upi_collect_link(failure: PaymentFailure):
    """Real Mechanism Swap: create a Razorpay Payment Link for UPI Collect."""
    try:
        if not settings.RAZORPAY_KEY_ID:
            return "https://rzp.io/l/revive-fallback", None
        client = get_client()
        link = client.payment_link.create({
            "amount": failure.amount_paise,
            "currency": "INR",
            "description": f"Complete your payment (revived from {failure.external_payment_id})",
            "notify": {"sms": True, "email": False},
            "reminder_enable": False,
        })
        return link.get("short_url"), link.get("id")
    except Exception as e:
        return "https://rzp.io/l/revive-fallback", f"razorpay_error:{str(e)[:100]}"

def _draft_customer_comms(db, failure, verdict, rule_id, reasoning, live_mode: bool):
    """Draft message + voice for ALLOW/DEFER cases. Only runs in live_mode to avoid batch API storms."""
    if not live_mode or verdict not in ("ALLOW", "DEFER"):
        return

    # 1. Draft message
    lang = "hi" if failure.method in ("upi", "netbanking") else "en"
    defer_day = 1
    if verdict == "DEFER":
        import re
        m = re.search(r"Defer to day (\d+)", reasoning)
        if m:
            defer_day = int(m.group(1))

    real_link = "https://rzp.io/l/revive-fallback"
    if failure.failure_code == "ABANDONED_AT_OTP":
        real_link, _ = create_upi_collect_link(failure)

    msg_data = generate_message(failure, verdict, lang=lang, defer_day=defer_day, link=real_link)
    db.add(RecoveryAction(
        failure_id=failure.id,
        action_type="MESSAGE_DRAFTED",
        actor="system",
        status="pending_send",
        reasoning=f"[{msg_data['via']}] {msg_data['message'][:200]}",
        executed_at=func.now()
    ))

    # 2. Synthesize voice (Hinglish for UPI/card, archetype-aware)
    script = voice_script(failure.archetype or "technical")
    voice_path = f"voice_{failure.external_payment_id}.mp3"
    try:
        result = synthesize(script, voice_path)
        db.add(RecoveryAction(
            failure_id=failure.id,
            action_type="VOICE_SYNTHESIZED",
            actor="system",
            status="pending_send",
            reasoning=f"Voice: {result}",
            executed_at=func.now()
        ))
    except Exception as e:
        db.add(RecoveryAction(
            failure_id=failure.id,
            action_type="VOICE_FAILED",
            actor="system",
            status="error",
            reasoning=f"Voice synthesis failed: {str(e)[:200]}",
            executed_at=func.now()
        ))

def execute_recovery(db, failure: PaymentFailure, verdict: str, rule_id: str, reasoning: str, live_mode: bool = False):
    """Translates a Gate verdict into a real database action.
    
    Args:
        live_mode: If True, triggers external APIs (voice, messaging). 
                   Set to False for batch simulation to avoid API throttling.
    """
    readable_reasoning = RULE_REASONS.get(rule_id, reasoning)

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
            if failure.failure_code == "ABANDONED_AT_OTP":
                link_url, link_id = create_upi_collect_link(failure)
                action_type = "UPI_COLLECT"
                extra_reasoning = f"Mechanism Swap: OTP→UPI Collect. Link: {link_url} | {readable_reasoning}"
            else:
                action_type = "RETRY_LINK"
                link_url = "https://rzp.io/l/revive-fallback"
                extra_reasoning = readable_reasoning

            db.add(RecoveryAction(
                failure_id=failure.id, action_type=action_type,
                actor="system", status="executed",
                amount_recovered_paise=failure.amount_paise,
                reasoning=extra_reasoning,
                executed_at=func.now()))
            failure.status = "recovered"
            failure.amount_recovered_paise = failure.amount_paise

        _draft_customer_comms(db, failure, verdict, rule_id, readable_reasoning, live_mode)

    elif verdict == "DEFER":
        import re
        from datetime import datetime

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
            reasoning=f"Deferred to salary day. {readable_reasoning}",
            executed_at=func.now()))
        failure.status = "deferred"
        failure.amount_protected_paise = failure.amount_paise

        _draft_customer_comms(db, failure, verdict, rule_id, readable_reasoning, live_mode)

    elif verdict == "BLOCK":
        db.add(RecoveryAction(
            failure_id=failure.id, action_type="BLOCKED",
            actor="system", status="blocked", reasoning=readable_reasoning,
            executed_at=func.now()))
        failure.status = "protected"
        failure.amount_protected_paise = failure.amount_paise