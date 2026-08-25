"""Promise-to-Pay: customer commits to pay on a specific date. No spam after."""
from datetime import datetime
from sqlalchemy.orm import Session
from app.db.models import PaymentFailure, PromiseToPay


def register_promise(db: Session, failure_id: int, promised_date: datetime, amount_paise: int):
    """Attach a PTP to a failure. Idempotent: skips if PTP already exists."""
    existing = db.query(PromiseToPay).filter_by(failure_id=failure_id, status="active").first()
    if existing:
        return existing

    f = db.query(PaymentFailure).get(failure_id)
    if not f:
        return None

    ptp = PromiseToPay(
        failure_id=failure_id,
        promised_date=promised_date,
        amount_paise=amount_paise,
        status="active"
    )
    db.add(ptp)
    f.status = "promised"
    db.commit()
    db.refresh(ptp)
    return ptp


def check_promises(db: Session, horizon_date: datetime = None):
    """Return active promises due on or before horizon_date (defaults to now)."""
    target = horizon_date or datetime.now()
    return (db.query(PromiseToPay)
            .filter(PromiseToPay.status == "active")
            .filter(PromiseToPay.promised_date <= target)
            .order_by(PromiseToPay.promised_date)
            .all())


def break_promise(db: Session, ptp_id: int):
    """Mark a promise as broken (customer didn't pay). Escalate, don't spam."""
    ptp = db.query(PromiseToPay).get(ptp_id)
    if ptp:
        ptp.status = "broken"
        f = db.query(PaymentFailure).get(ptp.failure_id)
        if f:
            f.status = "escalate_human"
        db.commit()
    return ptp