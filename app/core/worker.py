"""Background worker for async webhook processing."""
import traceback
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

        # Idempotency: never double-process a failure (scheduler re-runs deferred jobs)
        if db.query(Diagnosis).filter_by(failure_id=f.id).first() and \
            db.query(GateDecision).filter_by(failure_id=f.id).first():
            return

        # 1. Diagnose
        try:
            results = diagnose_batch([f])
            if not results:
                raise RuntimeError('diagnose_batch returned empty result')
            diag, model = results[0]
        except Exception as e:
            db.add(AuditLog(
                entity_type="failure", entity_id=f.id,
                actor="system", action="DIAGNOSIS_ERROR",
                reasoning=f"LLM+rules both failed: {type(e).__name__}: {str(e)[:200]}"
            ))
            f.status = "error"
            db.commit()
            return

        db.add(Diagnosis(
            failure_id=f.id,
            archetype=diag.archetype,
            owner=diag.owner,
            confidence=diag.confidence,
            reasoning=diag.reasoning,
            model_used=model
        ))

        # 2. Gate
        try:
            verdict, rule_id, reasoning = evaluate_consent(db, f, diag)
        except Exception as e:
            db.add(AuditLog(
                entity_type="failure", entity_id=f.id,
                actor="system", action="GATE_ERROR",
                reasoning=f"Gate crashed: {type(e).__name__}: {str(e)[:200]}"
            ))
            f.status = "error"
            db.commit()
            return

        db.add(GateDecision(
            failure_id=f.id,
            rule_id=rule_id,
            verdict=verdict,
            context_snapshot={
                "archetype": diag.archetype,
                "owner": diag.owner,
                "context": f.context,
                "method": f.method,
                "failure_code": f.failure_code,
                "amount_paise": f.amount_paise,
            }
        ))

        # 3. Audit
        db.add(AuditLog(
            entity_type="failure",
            entity_id=f.id,
            actor="system",
            action=f"{verdict}:{rule_id}",
            reasoning=reasoning
        ))

        # 4. Recover — LIVE MODE: voice + messaging fire here
        try:
            execute_recovery(db, f, verdict, rule_id, reasoning, live_mode=True)
        except Exception as e:
            db.rollback()
            db.add(AuditLog(
                entity_type="failure", entity_id=f.id,
                actor="system", action="RECOVERY_ERROR",
                reasoning=f"Recovery crashed: {type(e).__name__}: {str(e)[:200]}\n{traceback.format_exc()[:300]}"
            ))
            f.status = "error"
            db.commit()
            return

        db.commit()

    except Exception as e:
        db.rollback()
        try:
            db.add(AuditLog(
                entity_type="failure", entity_id=failure_id,
                actor="system", action="WORKER_FATAL",
                reasoning=f"Worker crashed fatally: {type(e).__name__}: {str(e)[:200]}"
            ))
            db.commit()
        except:
            pass
    finally:
        db.close()