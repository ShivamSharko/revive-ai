"""Generates the dynamic Money Slide with cost-per-recovery accounting and value-weighted recovery rate."""

from app.db.database import SessionLocal
from app.db.models import PaymentFailure, Diagnosis, RecoveryAction
from sqlalchemy import func


ARCHES = ["technical", "intent", "affordability", "lifecycle"]

# Cost assumptions (industry-standard India payment ops)
COST_PER_SILENT_RETRY = 0      # ₹0 — no customer contact
COST_PER_MESSAGE = 35          # ~₹0.35 WhatsApp/SMS
COST_PER_VOICE_CALL = 450      # ~₹4.50 voice call
COST_PER_PAYMENT_LINK = 20     # ~₹0.20 Razorpay link fee


def rupees(paise):
    return (paise or 0) / 100


def main():
    db = SessionLocal()
    try:
        total_failures = db.query(func.count(PaymentFailure.id)).scalar()
        total_at_risk = rupees(db.query(func.sum(PaymentFailure.amount_paise)).scalar())

        # Recovery by archetype
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
            db.query(Diagnosis.archetype, func.sum(PaymentFailure.amount_paise))
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

        # Cost accounting from recovery actions
        action_counts = dict(
            db.query(RecoveryAction.action_type, func.count(RecoveryAction.id))
            .group_by(RecoveryAction.action_type)
            .all()
        )

        silent_retries = action_counts.get("silent_retry", 0)
        messages_sent = action_counts.get("message", 0) + action_counts.get("whatsapp", 0)
        voice_calls = action_counts.get("voice_call", 0) + action_counts.get("voice", 0)
        links_sent = action_counts.get("payment_link", 0)

        total_cost = (
            silent_retries * COST_PER_SILENT_RETRY +
            messages_sent * COST_PER_MESSAGE +
            voice_calls * COST_PER_VOICE_CALL +
            links_sent * COST_PER_PAYMENT_LINK
        )

        # Value-weighted recovery rate
        value_weighted_rate = (total_rec / total_at_risk * 100) if total_at_risk else 0
        cost_per_1000 = (total_cost / (total_rec / 1000)) if total_rec > 0 else 0

        print("\n" + "=" * 68)
        print("REVIVE AI: THE MONEY SLIDE (DYNAMIC)")
        print("=" * 68)
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

        print(f"\nTotal: ₹{total_rec:,.0f} recovered · ₹{total_prot:,.0f} protected · ₹{total_defer:,.0f} deferred")

        if in_flight > 0:
            print(f"Plus:  ₹{in_flight:,.0f} in-flight / promised / escalated")

        # Cost & efficiency section
        print(f"\nOutreach Cost:     ₹{total_cost:,.2f}")
        print(f"Net Recovery:      ₹{total_rec - total_cost:,.0f}")
        print(f"Value-Weighted:    {value_weighted_rate:.1f}% of at-risk value recovered")
        if total_rec > 0:
            print(f"Cost per ₹1,000:   ₹{cost_per_1000:,.2f}")

        print(f"\n\"Customer-structural recovery = ₹0. That's intentional. (Hotel 'Walk' Protocol)\"")
        print("=" * 68 + "\n")

    finally:
        db.close()


if __name__ == "__main__":
    main()