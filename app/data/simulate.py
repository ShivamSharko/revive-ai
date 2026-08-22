"""Diagnose + gate the 500 failures. Resumable: keeps LLM diagnoses between runs."""
from app.db.database import SessionLocal
from app.db.models import PaymentFailure, Diagnosis, GateDecision, AuditLog
from app.core.diagnosis import diagnose_batch
from app.core.gate import evaluate_consent

def main():
    db = SessionLocal()
    try:
        failures = db.query(PaymentFailure).filter_by(source="synthetic").all()

        # Keep LLM diagnoses from earlier waves; redo only rules fallbacks
        kept = {d.failure_id: d for d in db.query(Diagnosis)
                .filter(Diagnosis.model_used != "rules").all()}
        db.query(Diagnosis).filter(Diagnosis.model_used == "rules")\
            .delete(synchronize_session=False)
        db.query(GateDecision).delete()
        db.query(AuditLog).filter(
            AuditLog.entity_type == "failure",
            AuditLog.entity_id.in_([f.id for f in failures])
        ).delete(synchronize_session=False)
        db.commit()

        todo = [f for f in failures if f.id not in kept]
        print(f"Diagnosing {len(todo)} remaining ({len(kept)} already LLM-diagnosed)...")

        if todo:
            for f, (d, model) in zip(todo, diagnose_batch(todo)):
                db.add(Diagnosis(failure_id=f.id, archetype=d.archetype, owner=d.owner,
                                 confidence=d.confidence, reasoning=d.reasoning,
                                 model_used=model))
            db.commit()

        diags = {d.failure_id: d for d in db.query(Diagnosis).all()}

        allow = block = defer = 0
        protected_paise = 0
        for f in failures:
            d = diags.get(f.id)
            if d is None:
                continue
            verdict, rule_id, reasoning = evaluate_consent(db, f, d)
            db.add(GateDecision(failure_id=f.id, rule_id=rule_id, verdict=verdict))
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

        rules_left = sum(1 for d in diags.values() if d.model_used == "rules")
        print(f"\n--- REVIVE AI GATE RESULTS ---")
        print(f"ALLOW : {allow} | DEFER : {defer} | BLOCK : {block} "
              f"(Rs.{protected_paise/100:,.0f} protected)")
        print(f"LLM-diagnosed: {len(diags) - rules_left}/500 | rules left: {rules_left}"
              + (" -> run simulate again to upgrade them" if rules_left else " -> PURE LLM BATCH ✔"))
    finally:
        db.close()

if __name__ == "__main__":
    main()