"""Smart policy engine — TRAI quiet hours + promise-active halt."""
from datetime import datetime, timedelta, time as dtime

POLICY_VERSION = "1.0.0"
QUIET_START = dtime(21, 0)   # 9 PM
QUIET_END = dtime(7, 0)      # 7 AM

def in_quiet_hours(now=None):
    t = (now or datetime.now()).time()
    return t >= QUIET_START or t < QUIET_END

def next_allowed_slot(run_at):
    t = run_at.time()
    if t >= QUIET_START:
        return datetime.combine(run_at.date() + timedelta(days=1), dtime(9, 0))
    if t < QUIET_END:
        return datetime.combine(run_at.date(), dtime(9, 0))
    return run_at

def has_active_promise(db, customer_id):
    from app.db.models import Promise
    return db.query(Promise).filter_by(customer_id=customer_id, status="pending").first() is not None