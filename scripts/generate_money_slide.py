"""Generates the dynamic Money Slide with per-archetype ₹ breakdowns."""
from app.db.database import SessionLocal
from app.db.models import PaymentFailure, Diagnosis
from sqlalchemy import func


ARCHES = ["technical", "intent", "affordability", "lifecycle"]


def rupees(paise):
    return (paise or 0) / 100


def main():
    db = SessionLocal()
    try:
        total_failures = db.query(func.count(PaymentFailure.id)).scalar()
        total_at_risk = rupees(db.query(func.sum(PaymentFailure.amount_paise)).scalar())

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

        total_rec = sum((recovered.get(a, 0) or 0) for a in ARCHES) / 100
        total_prot = sum((protected.get(a, 0) or 0) for a in ARCHES) / 100
        total_defer = sum((deferred.get(a, 0) or 0) for a in ARCHES) / 100

        accounted = total_rec + total_prot + total_defer
        in_flight = max(total_at_risk - accounted, 0)

        print("\n" + "=" * 64)
        print("REVIVE AI: THE MONEY SLIDE (DYNAMIC)")
        print("=" * 64)
        print(f"{total_failures} failures (₹{total_at_risk:,.0f} At Risk)\n")

        for arch in ARCHES:
            rec = rupees(recovered.get(arch, 0))
            prot = rupees(protected.get(arch, 0))
            defer = rupees(deferred.get(arch, 0))

            if arch == "technical":
                print(f"├── Technical:     ₹{rec:,.0f} recovered (silent retries, invisible recovery)")

            elif arch == "intent":
                print(f"├── Intent:        ₹{rec:,.0f} recovered (mechanism swaps & nudges)")

            elif arch == "affordability":
                print(f"├── Affordability: ₹0 now · ₹{defer:,.0f} scheduled (Deferred EV to salary day)")

            else:
                parts = []
                if rec > 0:
                    parts.append(f"₹{rec:,.0f} recovered (card updates)")
                if prot > 0:
                    parts.append(f"₹{prot:,.0f} protected (mandate compliance)")
                if not parts:
                    parts.append("₹0")
                prefix = "├──" if in_flight > 0 else "└──"
                print(f"{prefix} Lifecycle:     {' · '.join(parts)}")

        if in_flight > 0:
            print(f"└── In-flight:     ₹{in_flight:,.0f} promised / live-test / human escalation")

        print(
            f"\nTotal: ₹{total_rec:,.0f} recovered · "
            f"₹{total_prot:,.0f} protected · "
            f"₹{total_defer:,.0f} deferred"
        )

        if in_flight > 0:
            print(f"Plus:  ₹{in_flight:,.0f} in-flight / promised / escalated")

        print(f"\n\"Customer-structural recovery = ₹0. That's intentional. (Hotel 'Walk' Protocol)\"")
        print("=" * 64 + "\n")

    finally:
        db.close()


if __name__ == "__main__":
    main()