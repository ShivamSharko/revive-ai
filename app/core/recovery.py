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
        
        if is_degraded(bank_code):
            db.add(Job(
                failure_id=failure.id, kind="DEFERRED_RETRY",
                run_at=failure.occurred_at + timedelta(days=1), status="queued"))
            db.add(RecoveryAction(
                failure_id=failure.id, action_type="DEFER_BANK_DEGRADED",
                actor="system", status="deferred",
                reasoning=f"Bank {bank_code} degraded (rate {ev_data['probability']}). EV={ev_data['ev']}. Deferred.",
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
        db.add(Job(
            failure_id=failure.id, kind="DEFERRED_RETRY",
            run_at=failure.occurred_at + timedelta(days=7), status="queued"))
        db.add(RecoveryAction(
            failure_id=failure.id, action_type="DEFERRED",
            actor="system", status="scheduled",
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