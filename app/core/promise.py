"""Promise-to-Pay tracker — customer commits to a date, we auto-fulfill or escalate."""
from datetime import datetime, timedelta
from app.db.models import Promise


def create_promise(db, failure_id, customer_id, promised_date_str):
    """Parse date and create promise."""
    try:
        promised_at = datetime.fromisoformat(promised_date_str)
    except:
        promised_at = datetime.now() + timedelta(days=7)
    
    p = Promise(failure_id=failure_id, customer_id=customer_id,
                promised_at=promised_at, status="pending")
    db.add(p)
    db.commit()
    return p


def check_broken_promises(db):
    """Find promises past their date that weren't fulfilled."""
    now = datetime.now()
    broken = db.query(Promise).filter(
        Promise.status == "pending",
        Promise.promised_at < now
    ).all()
    for p in broken:
        p.status = "escalated"
    db.commit()
    return len(broken)