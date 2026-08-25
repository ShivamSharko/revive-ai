"""Background worker for async webhook processing."""
from app.db.database import SessionLocal
from app.db.models import PaymentFailure, Diagnosis, GateDecision, AuditLog
from app.core.diagnosis import diagnose_batch
from app.core.gate import evaluate_consent
from app.core.recovery import execute_recovery

def process_failure(failure_id: int):
    db = SessionLocal()
    try:
        f = db.query(PaymentFailure).get(failure_id)
        if not f:
            return

        # 1. Diagnose
        (diag, model), = diagnose_batch([f])
        db.add(Diagnosis(
            failure_id=f.id,
            archetype=diag.archetype,
            owner=diag.owner,
            confidence=diag.confidence,
            reasoning=diag.reasoning,
            model_used=model
        ))

        # 2. Gate
        verdict, rule_id, reasoning = evaluate_consent(db, f, diag)
        db.add(GateDecision(failure_id=f.id, rule_id=rule_id, verdict=verdict))

        # 3. Audit
        db.add(AuditLog(
            entity_type="failure",
            entity_id=f.id,
            actor="system",
            action=f"{verdict}:{rule_id}",
            reasoning=reasoning
        ))

        # 4. Recover
        execute_recovery(db, f, verdict, rule_id, reasoning)
        db.commit()

    finally:
        db.close()