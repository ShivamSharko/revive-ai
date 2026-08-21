import razorpay
from app.config import settings

_client = None
def get_client() -> razorpay.Client:
    global _client
    if _client is None:
        assert settings.RAZORPAY_KEY_ID, "Set RAZORPAY_KEY_ID in .env"
        _client = razorpay.Client(auth=(settings.RAZORPAY_KEY_ID, settings.RAZORPAY_KEY_SECRET))
    return _client