"""Razorpay implementation of the connector seam (test-mode)."""
import os
import requests

from .base import PaymentConnector

BASE = "https://api.razorpay.com/v1"


class RazorpayConnector(PaymentConnector):
    name = "razorpay"

    def __init__(self):
        self.key = os.getenv("RAZORPAY_KEY_ID", "")
        self.secret = os.getenv("RAZORPAY_KEY_SECRET", "")

    def _get(self, path, **params):
        return requests.get(BASE + path, auth=(self.key, self.secret),
                            params=params, timeout=10).json()

    def fetch_failed_payments(self):
        return self._get("/payments", status="failed")

    def retry_payment(self, external_payment_id):
        return {"payment_id": external_payment_id, "intent": "retry", "via": "razorpay"}

    def order_status(self, external_order_id):
        return self._get(f"/orders/{external_order_id}")