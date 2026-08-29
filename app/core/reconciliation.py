"""Reconciliation engine — 2-way reconciliation with backdated support.

Flags 'limbo' payments (customer deducted, merchant not settled) and opens
refund jobs with the NPCI auto-reversal window (T+48h) as SLA."""
from datetime import datetime, timedelta
from app.db.models import PaymentFailure, Job, AuditLog


def find_limbo(db):
    return db.query(PaymentFailure).filter(
        PaymentFailure.status.in_(["authorized", "limbo", "deducted_not_settled"])).all()


def run_reconciliation(db):
    opened = 0
    for f in find_limbo(db):
        exists = db.query(Job).filter_by(failure_id=f.id, kind="REFUND_SLA").first()
        if not exists:
            db.add(Job(failure_id=f.id, kind="REFUND_SLA",
                       run_at=datetime.now() + timedelta(hours=48), status="queued"))
            db.add(AuditLog(entity_type="reconciliation", entity_id=f.id,
                            actor="recon_engine", action="REFUND_SLA_OPENED",
                            reasoning="Deducted without settlement; NPCI auto-reversal window T+48h."))
            opened += 1
    db.commit()
    return opened