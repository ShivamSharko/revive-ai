"""Run the Recovery Engine on the 500 simulated failures. Fast — no external APIs."""
from app.db.database import SessionLocal
from app.db.models import PaymentFailure, GateDecision, RecoveryAction, Job
from app.core.recovery import execute_recovery

RULE_REASONS = {
    "R01_RBI_MANDATE": "Pre-debit notification < 24h. RBI compliance block.",
    "R02_FEE_SHOCK": "Hidden fees caused abandonment. Do not retry.",
    "R03_STRUCTURAL_STOP": "Repeated failures. Spamming will cause churn.",
    "R04_LIQUIDITY_DEFER": "Insufficient funds. Deferred to salary day.",
    "R05_TECH_RETRY": "Transient technical failure. Safe to retry.",
    "R06_DEFAULT_ALLOW": "No blocking rules triggered.",
    "R07_OFFLINE_QR_TRAP": "Customer left store. Silent retry blocked to prevent double-charge.",
}

def main():
    db = SessionLocal()
    try:
        db.query(RecoveryAction).delete()
        db.query(Job).delete()
        db.commit()

        failures = db.query(PaymentFailure).filter_by(source="synthetic").all()
        print(f"Executing recovery actions for {len(failures)} failures...")

        recovered = deferred = blocked = 0
        recovered_paise = 0

        for f in failures:
            decision = db.query(GateDecision).filter_by(failure_id=f.id).first()
            if not decision:
                continue
            reasoning = RULE_REASONS.get(decision.rule_id, decision.rule_id)
            # BATCH MODE: skip voice/messaging to avoid 150+ API calls
            execute_recovery(db, f, decision.verdict, decision.rule_id, reasoning, live_mode=False)
            if decision.verdict == "ALLOW":
                recovered += 1
                recovered_paise += f.amount_paise
            elif decision.verdict == "DEFER":
                deferred += 1
            elif decision.verdict == "BLOCK":
                blocked += 1

        db.commit()

        print(f"\n--- REVIVE AI RECOVERY EXECUTED ---")
        print(f"RECOVERED : {recovered} (Rs.{recovered_paise/100:,.0f} recaptured)")
        print(f"DEFERRED  : {deferred} (Jobs scheduled for salary day)")
        print(f"BLOCKED   : {blocked} (Customer goodwill protected)")
    finally:
        db.close()

if __name__ == "__main__":
    main()