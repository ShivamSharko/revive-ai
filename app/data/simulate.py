"""Run the 500 failures through the Diagnosis Engine + Consent Gate."""
from app.db.database import SessionLocal
from app.db.models import PaymentFailure, Diagnosis, GateDecision, AuditLog
from app.core.diagnosis import diagnose_batch
from app.core.gate import evaluate_consent

def main():
    db = SessionLocal()
    try:
        # 1. Wipe old diagnoses/decisions for a clean run
        db.query(Diagnosis).delete()
        db.query(GateDecision).delete()
        db.commit()

        failures = db.query(PaymentFailure).filter_by(source="synthetic").all()

        # Idempotent audit: clear previous batch rows, keep live webhook rows
        db.query(AuditLog).filter(
            AuditLog.entity_type == "failure",
            AuditLog.entity_id.in_([f.id for f in failures])
        ).delete(synchronize_session=False)

        print(f"Processing {len(failures)} failures through Revive AI...")

        # 2. Diagnose in batches (our chunked engine handles the 500 safely)
        diag_results = diagnose_batch(failures)

        allow = block = defer = 0
        protected_paise = 0

        for f, (d, model) in zip(failures, diag_results):
            # Save Diagnosis to DB
            db.add(Diagnosis(failure_id=f.id, archetype=d.archetype, owner=d.owner,
                             confidence=d.confidence, reasoning=d.reasoning, model_used=model))

            # Run Gate
            verdict, rule_id, reasoning = evaluate_consent(db, f, d)

            # Save GateDecision to DB
            db.add(GateDecision(failure_id=f.id, rule_id=rule_id, verdict=verdict))

            # Audit trail: every decision logged with actor + reasoning
            db.add(AuditLog(entity_type="failure", entity_id=f.id, actor="system",
                            action=f"{verdict}:{rule_id}", reasoning=reasoning))

            if verdict == "ALLOW":
                allow += 1
            elif verdict == "BLOCK":
                block += 1
                protected_paise += f.amount_paise
            elif verdict == "DEFER":
                defer += 1

        db.commit()

        print(f"\n--- REVIVE AI GATE RESULTS ---")
        print(f"ALLOW : {allow} (Safe to retry immediately)")
        print(f"DEFER : {defer} (Scheduled for salary day / liquidity)")
        print(f"BLOCK : {block} (Spam prevented | Rs.{protected_paise/100:,.0f} customer goodwill protected)")
        print(f"Total : {allow+block+defer}")
    finally:
        db.close()

if __name__ == "__main__":
    main()