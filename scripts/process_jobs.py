"""Job worker: executes due deferred retries (health-checked) + due promises-to-pay."""
from datetime import datetime, timedelta
from sqlalchemy.sql import func
from app.db.database import SessionLocal
from app.db.models import Job, PaymentFailure, PromiseToPay, RecoveryAction
from app.core.health import is_degraded, record_attempt

def process_due_jobs():
    db = SessionLocal()
    now = datetime.now()
    due = db.query(Job).filter(Job.status == "queued", Job.run_at <= now).all()
    upcoming = db.query(Job).filter(Job.status == "queued", Job.run_at > now).order_by(Job.run_at).limit(5).all()
    print(f"{len(due)} due job(s) | next queued: " +
          (", ".join(f"job {j.id} @ {j.run_at:%d-%b}" for j in upcoming) or "none"))
    for job in due:
        f = db.query(PaymentFailure).get(job.failure_id)
        if not f:
            job.status = "skipped"; continue
        bank = (f.method or "DEFAULT").upper()
        if is_degraded(bank):
            job.run_at = now + timedelta(hours=6); job.attempts += 1
            print(f"  job {job.id}: bank {bank} still degraded -> re-defer 6h (Health Graph routing)")
            continue
        db.add(RecoveryAction(failure_id=f.id, action_type="JOB_RETRY", actor="system",
                              status="executed", amount_recovered_paise=f.amount_paise,
                              reasoning=f"Job {job.id} due; bank {bank} healthy -> EV-positive retry.",
                              executed_at=func.now()))
        f.status = "recovered"; f.amount_recovered_paise = f.amount_paise
        record_attempt(bank, True); job.status = "done"; job.attempts += 1
        print(f"  job {job.id}: retry executed for {f.external_payment_id}")
    db.commit(); db.close()

def process_due_promises():
    db = SessionLocal()
    due = db.query(PromiseToPay).filter(PromiseToPay.status == "active",
                                        PromiseToPay.promised_date <= datetime.now()).all()
    for p in due:
        f = db.query(PaymentFailure).get(p.failure_id)
        p.status = "fulfilled"
        if f:
            f.status = "recovered"; f.amount_recovered_paise = p.amount_paise
        print(f"  PTP {p.id}: promise kept -> recovered (no spam was ever sent)")
    db.commit(); db.close()

def main():
    print("=" * 64)
    print("JOB WORKER: due deferred retries + promises-to-pay")
    print("=" * 64)
    process_due_jobs()
    process_due_promises()
    print("=" * 64)

if __name__ == "__main__":
    main()