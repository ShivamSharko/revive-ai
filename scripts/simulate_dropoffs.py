"""Simulates Flow B: Checkout drop-offs and generates merchant insights."""
from collections import Counter
from app.db.database import SessionLocal
from app.db.models import PaymentFailure

def main():
    db = SessionLocal()
    fee_drops = db.query(PaymentFailure).filter(
        PaymentFailure.failure_code == "ABANDONED_AT_FEES"
    ).all()
    
    print("\n" + "=" * 60)
    print("FLOW B: CHECKOUT DROP-OFF ANALYSIS")
    print("=" * 60)
    
    if not fee_drops:
        print("No fee-shock drop-offs detected.")
        return

    merchants = Counter(f.merchant_id for f in fee_drops)
    
    for merch, count in merchants.most_common():
        print(f"\n🚨 MERCHANT INSIGHT: {merch}")
        print(f"   {count} users abandoned their cart at the fee reveal today.")
        print(f"   ACTION: Do NOT message the customers. The price shock is killing conversion.")
        print(f"   FIX: Review your shipping/tax disclosure timing.")
    print("=" * 60 + "\n")

if __name__ == "__main__":
    main()