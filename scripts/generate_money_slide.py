"""Generates the dynamic Money Slide with per-archetype ₹ breakdowns."""
from app.db.database import SessionLocal
from app.db.models import PaymentFailure, Diagnosis
from sqlalchemy import func


def main():
    db = SessionLocal()
    try:
        total_failures = db.query(func.count(PaymentFailure.id)).scalar()
        total_at_risk = (db.query(func.sum(PaymentFailure.amount_paise)).scalar() or 0) / 100

        recovered = dict(
            db.query(Diagnosis.archetype, func.sum(PaymentFailure.amount_recovered_paise))
            .join(PaymentFailure, Diagnosis.failure_id == PaymentFailure.id)
            .filter(PaymentFailure.status == "recovered")
            .group_by(Diagnosis.archetype)
            .all()
        )

        protected = dict(
            db.query(Diagnosis.archetype, func.sum(PaymentFailure.amount_protected_paise))
            .join(PaymentFailure, Diagnosis.failure_id == PaymentFailure.id)
            .filter(PaymentFailure.status == "protected")
            .group_by(Diagnosis.archetype)
            .all()
        )

        deferred = dict(
            db.query(Diagnosis.archetype, func.sum(PaymentFailure.amount_protected_paise))
            .join(PaymentFailure, Diagnosis.failure_id == PaymentFailure.id)
            .filter(PaymentFailure.status == "deferred")
            .group_by(Diagnosis.archetype)
            .all()
        )

        print("\n" + "=" * 64)
        print("REVIVE AI: THE MONEY SLIDE (DYNAMIC)")
        print("=" * 64)
        print(f"{total_failures} failures (₹{total_at_risk:,.0f} At Risk)\n")

        for arch in ["technical", "intent", "affordability", "lifecycle"]:
            rec = (recovered.get(arch, 0) or 0) / 100
            prot = (protected.get(arch, 0) or 0) / 100
            defer = (deferred.get(arch, 0) or 0) / 100

            if arch == "technical":
                print(f"├── Technical:     ₹{rec:,.0f} recovered (silent retries, invisible recovery)")
            elif arch == "intent":
                print(f"├── Intent:        ₹{rec:,.0f} recovered (mechanism swaps & nudges)")
            elif arch == "affordability":
                print(f"├── Affordability: ₹0 now · ₹{defer:,.0f} scheduled (Deferred EV to salary day)")
            else:
                print(f"└── Lifecycle:     ₹{prot:,.0f} protected (mandate compliance enforced)")

        total_rec = sum((recovered.get(a, 0) or 0) for a in ["technical", "intent", "affordability", "lifecycle"]) / 100
        total_prot = sum((protected.get(a, 0) or 0) for a in ["technical", "intent", "affordability", "lifecycle"]) / 100
        total_defer = sum((deferred.get(a, 0) or 0) for a in ["technical", "intent", "affordability", "lifecycle"]) / 100

        print(f"\nTotal: ₹{total_rec:,.0f} recovered · ₹{total_prot:,.0f} protected · ₹{total_defer:,.0f} deferred")
        print(f"\n\"Customer-structural recovery = ₹0. That's intentional. (Hotel 'Walk' Protocol)\"")
        print("=" * 64 + "\n")

    finally:
        db.close()


if __name__ == "__main__":
    main()