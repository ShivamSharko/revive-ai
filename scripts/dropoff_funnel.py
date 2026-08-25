"""Drop-to-pay flow tracker: checkout funnel from the 500 batch."""
from app.db.database import SessionLocal
from app.db.models import PaymentFailure

def main():
    db = SessionLocal()
    rows = db.query(PaymentFailure).filter_by(source="synthetic").all()
    orders = len(rows)
    dropped_otp = sum(1 for r in rows if r.dropped_step == "otp")
    dropped_fees = sum(1 for r in rows if r.dropped_step == "fees")
    attempted = sum(1 for r in rows if r.session_active)
    recovered = sum(1 for r in rows if r.status == "recovered")

    print("=" * 64)
    print("DROP-TO-PAY FLOW TRACKER")
    print("=" * 64)
    print(f"Orders created         : {orders}")
    print(f"Dropped at fee reveal  : {dropped_fees}  <- merchant-owned price shock")
    print(f"Dropped at OTP         : {dropped_otp}  <- Mechanism Swap target")
    print(f"Payment attempted      : {attempted}")
    print(f"Recovered by Revive AI : {recovered}")
    leak = dropped_otp + dropped_fees
    print(f"\nBiggest leak: {leak} orders ({leak/orders:.0%}) never reached payment attempt.")
    print("Action: fee-shock -> merchant insight; OTP -> UPI Collect swap.")
    print("=" * 64)

if __name__ == "__main__":
    main()