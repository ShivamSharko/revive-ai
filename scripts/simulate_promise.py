"""Promise-to-Pay demo: customer commits to pay, we track and follow up."""
from datetime import datetime, timedelta
from app.db.database import SessionLocal
from app.db.models import PaymentFailure
from app.core.promise import register_promise, check_promises


def main():
    db = SessionLocal()
    try:
        print("\n" + "=" * 64)
        print("FLOW: PROMISE-TO-PAY TRACKER")
        print("=" * 64)

        # Find a deferred affordability failure to attach PTP to
        target = (db.query(PaymentFailure)
                  .filter_by(status="deferred", failure_code="INSUFFICIENT_BALANCE")
                  .first())

        if target:
            promise_date = datetime.now() + timedelta(days=5)
            ptp = register_promise(db, target.id, promise_date, target.amount_paise)
            print(f"\n✓ Registered PTP: Payment {target.external_payment_id}")
            print(f"  Customer will pay ₹{target.amount_paise/100:,.0f} on {promise_date.date()}")
            print(f"  PTP record id: {ptp.id}")
        else:
            print("\n⚠ No deferred affordability failure found.")

        # Show all active promises
        promises = check_promises(db, datetime.now() + timedelta(days=10))
        print(f"\n{len(promises)} active promise(s) due within 10 days:")
        for p in promises[:5]:
            f = db.query(PaymentFailure).get(p.failure_id)
            print(f"  - {f.external_payment_id}: ₹{p.amount_paise/100:,.0f} due {p.promised_date.date()}")

        print("\n→ On promise date: auto-retry via UPI Collect Request")
        print("→ If broken: escalate to human agent (no automated spam)")
        print("=" * 64 + "\n")

    finally:
        db.close()


if __name__ == "__main__":
    main()