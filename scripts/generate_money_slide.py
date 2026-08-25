"""Generates the dynamic Money Slide from the live database."""
from app.db.database import SessionLocal
from app.db.models import PaymentFailure, GateDecision
from sqlalchemy import func

def main():
    db = SessionLocal()
    
    total_failures = db.query(func.count(PaymentFailure.id)).scalar()
    total_at_risk = db.query(func.sum(PaymentFailure.amount_paise)).scalar() / 100
    recovered = db.query(func.sum(PaymentFailure.amount_recovered_paise)).scalar() / 100
    protected = db.query(func.sum(PaymentFailure.amount_protected_paise)).scalar() / 100
    
    deferred_q = db.query(func.sum(PaymentFailure.amount_paise)).join(
        GateDecision, PaymentFailure.id == GateDecision.failure_id
    ).filter(GateDecision.verdict == "DEFER").scalar()
    deferred = (deferred_q or 0) / 100

    print("\n" + "=" * 60)
    print("REVIVE AI: THE MONEY SLIDE (DYNAMIC)")
    print("=" * 60)
    print(f"{total_failures} failures (₹{total_at_risk:,.0f} At Risk)")
    print(f"├── Technical:     Silent retries executed (Invisible recovery)")
    print(f"├── Intent:        Mechanism swaps & nudges deployed")
    print(f"├── Affordability: ₹0 recovered now · ₹{deferred:,.0f} scheduled (Deferred EV to salary day)")
    print(f"└── Lifecycle:     Mandate compliance enforced")
    print(f"\nTotal: ₹{recovered:,.0f} recovered · ₹{protected:,.0f} protected (double-charges blocked)")
    print(f"\n\"Customer-structural recovery = ₹0. That's intentional. (Hotel 'Walk' Protocol)\"")
    print("=" * 60 + "\n")

if __name__ == "__main__":
    main()