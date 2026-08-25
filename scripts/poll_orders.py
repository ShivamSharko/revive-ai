"""Ingest abandoned carts from Razorpay Orders API as intent failures (Flow B)."""
from datetime import datetime
from app.core.orders import fetch_abandoned_orders
from app.db.database import SessionLocal
from app.db.models import PaymentFailure

def main():
    db = SessionLocal()
    abandoned = fetch_abandoned_orders()
    if not abandoned:
        print("Orders API: no abandoned carts in test mode — synthetic drop-offs cover the demo.")
        return
    n = 0
    for o in abandoned:
        if db.query(PaymentFailure).filter_by(external_payment_id=o["id"]).first():
            continue
        db.add(PaymentFailure(
            external_payment_id=o["id"], source="orders_api", amount_paise=o.get("amount", 0),
            currency=o.get("currency", "INR"), method="upi", failure_code="ABANDONED_AT_CHECKOUT",
            failure_description=f"Order {o['id']} created but never paid",
            customer_id="cust_live_001", merchant_id="merch_001", context="post_session_online",
            session_active=False, dropped_step="checkout", true_archetype="intent",
            true_owner="merchant", status="pending", occurred_at=datetime.now()))
        n += 1
    db.commit()
    print(f"Ingested {n} abandoned orders from Razorpay Orders API.")

if __name__ == "__main__":
    main()