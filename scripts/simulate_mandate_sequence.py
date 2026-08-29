"""Mandate retry sequencer — compliant e-mandate dunning.

For every failed e-mandate/subscription payment, schedules the RBI-compliant
sequence: T-24h pre-debit notice -> T+0 gated retry -> T+48h human escalation."""
from datetime import datetime, timedelta
from app.db.database import SessionLocal
from app.db.models import PaymentFailure, Job, AuditLog


def main():
    db = SessionLocal()
    rows = db.query(PaymentFailure).filter(
        (PaymentFailure.method == "emandate") |
        (PaymentFailure.context == "recurring")).all()
    made = 0
    for f in rows:
        if db.query(Job).filter_by(failure_id=f.id, kind="MANDATE_SEQUENCE").first():
            continue
        now = datetime.now()
        for kind, at in [("MANDATE_NOTIFY", now),
                         ("MANDATE_RETRY", now + timedelta(hours=24)),
                         ("MANDATE_ESCALATE", now + timedelta(hours=72))]:
            db.add(Job(failure_id=f.id, kind=kind, run_at=at, status="queued"))
        db.add(AuditLog(entity_type="mandate", entity_id=f.id, actor="seq",
                        action="MAND_SEQ",
                        reasoning="T-24h notice -> T+0 gated retry -> T+48h human escalation."))
        made += 1
    db.commit()
    print(f"Mandate sequences scheduled for {made} failed mandates.")
    db.close()


if __name__ == "__main__":
    main()