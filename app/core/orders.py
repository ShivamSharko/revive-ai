"""Flow B real trigger: poll Razorpay Orders API for abandoned carts."""
import razorpay
from app.config import settings

def fetch_abandoned_orders():
    if not settings.RAZORPAY_KEY_ID:
        return []
    try:
        client = razorpay.Client(auth=(settings.RAZORPAY_KEY_ID, settings.RAZORPAY_KEY_SECRET))
        return [o for o in client.order.all({"count": 50})["items"]
                if o.get("status") in ("created", "attempted") and not o.get("paid")]
    except Exception:
        return []