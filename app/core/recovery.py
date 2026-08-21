"""Recovery Engine: executes bounded actions based on the Consent Gate's verdict."""
from datetime import timedelta
from sqlalchemy.sql import func
from app.db.models import PaymentFailure, RecoveryAction, Job

def execute_recovery(db, failure: PaymentFailure, verdict: str, rule_id: str, reasoning: str):
    """Translates a Gate verdict into a real database action."""

    if verdict == "ALLOW":
        db.add(RecoveryAction(
            failure_id=failure.id, action_type="RETRY_LINK",
            actor="system", status="executed",
            amount_recovered_paise=failure.amount_paise,
            executed_at=func.now()))
        failure.status = "recovered"
        failure.amount_recovered_paise = failure.amount_paise

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