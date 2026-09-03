"""Background scheduler: runs deferred jobs and polls abandoned orders."""
import asyncio
from datetime import datetime
from app.db.database import SessionLocal
from app.db.models import Job, PaymentFailure
from app.core.orders import fetch_abandoned_orders
from app.core.worker import process_failure


async def run_job_processor():
    """Poll jobs table every 60s and execute due deferred retries."""
    while True:
        await asyncio.sleep(60)
        # Smart policy: TRAI quiet hours (21:00–07:00) — pause outreach, keep polling
        from app.core.policy import in_quiet_hours
        if in_quiet_hours():
            continue
        db = SessionLocal()
        try:
            now = datetime.now()
            due_jobs = (db.query(Job)
                        .filter(Job.status == "queued")
                        .filter(Job.run_at <= now)
                        .filter(Job.attempts < Job.max_attempts)
                        .all())

            for job in due_jobs:
                job.attempts += 1
                failure = db.query(PaymentFailure).get(job.failure_id)
                if failure and failure.status == "deferred":
                    fid = failure.id
                    job.status = "processing"
                    db.commit()
                    try:
                        await asyncio.to_thread(process_failure, fid)
                        job.status = "completed"
                    except Exception as e:
                        job.status = "failed"
                        job.last_error = str(e)[:500]
                    db.commit()
                else:
                    job.status = "cancelled"
                    db.commit()
        except Exception as e:
            db.rollback()
        finally:
            db.close()


async def run_orders_poller():
    """Poll Razorpay Orders API every 5 minutes for abandoned carts."""
    while True:
        await asyncio.sleep(300)  # 5 minutes
        db = SessionLocal()
        try:
            # FIX: network call to Razorpay runs in a thread
            orders = await asyncio.to_thread(fetch_abandoned_orders)
            for o in orders:
                if db.query(PaymentFailure).filter_by(external_payment_id=o["id"]).first():
                    continue
                db.add(PaymentFailure(
                    external_payment_id=o["id"],
                    source="orders_api",
                    amount_paise=o.get("amount", 0),
                    currency=o.get("currency", "INR"),
                    method="upi",
                    failure_code="ABANDONED_AT_CHECKOUT",
                    failure_description=f"Order {o['id']} created but never paid",
                    customer_id="cust_live_001",
                    merchant_id="merch_001",
                    context="post_session_online",
                    session_active=False,
                    dropped_step="checkout",
                    true_archetype="intent",
                    true_owner="merchant",
                    status="pending",
                    occurred_at=datetime.now()
                ))
            db.commit()
        except Exception:
            db.rollback()
        finally:
            db.close()