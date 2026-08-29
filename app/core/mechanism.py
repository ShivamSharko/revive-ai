"""Mechanism selector — success-rate recovery routing.

Ranks payment channels by observed recovery success in the batch, so the
agent retries through the channel most likely to succeed."""
from sqlalchemy import func
from app.db.models import PaymentFailure


def mechanism_success_rates(db):
    total = dict(db.query(PaymentFailure.method, func.count(PaymentFailure.id))
                 .group_by(PaymentFailure.method).all())
    rec = dict(db.query(PaymentFailure.method, func.count(PaymentFailure.id))
               .filter_by(status="recovered")
               .group_by(PaymentFailure.method).all())
    out = [{"method": m, "attempts": t,
            "success_rate": round(rec.get(m, 0) / max(t, 1), 2)}
           for m, t in total.items()]
    return sorted(out, key=lambda x: -x["success_rate"])


def choose_mechanism(db, fallback="upi"):
    rates = mechanism_success_rates(db)
    return rates[0]["method"] if rates else fallback