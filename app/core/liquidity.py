"""Liquidity Curves — full histogram of a customer's captured payment days."""
from collections import Counter

from app.db.models import CustomerPaymentHistory

def liquidity_curve(db, customer_id: str) -> dict:
    days = [h.day_of_month for h in db.query(CustomerPaymentHistory)
            .filter_by(customer_id=customer_id, status="captured").all()]
    hist = Counter(days)
    if not hist:
        return {"histogram": {}, "modal_day": None, "confidence": 0.0, "samples": 0}
    modal, top = hist.most_common(1)[0]
    return {"histogram": dict(sorted(hist.items())), "modal_day": modal,
            "confidence": round(top / sum(hist.values()), 2), "samples": len(days)}