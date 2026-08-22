"""Replays your REAL Day-1 failed payment as a signed Razorpay webhook,
plus a tampered request to prove signature verification works."""
import hashlib
import hmac
import json
import urllib.request

from app.config import settings

URL = "http://127.0.0.1:8000/webhooks/razorpay"
SECRET = settings.WEBHOOK_SECRET.encode()

payload = {
    "event": "payment.failed",
    "created_at": 1755600000,
    "payload": {"payment": {"entity": {
        "id": "pay_TSOALEUJL823Wr",          # your real Day-1 failed payment
        "amount": 49900, "currency": "INR", "method": "netbanking",
        "error_code": "NB_SESSION_TIMEOUT",
        "error_description": "Netbanking session timed out at bank page",
    }}},
}

def send(body: bytes, sig: str):
    req = urllib.request.Request(URL, data=body,
        headers={"Content-Type": "application/json", "X-Razorpay-Signature": sig})
    try:
        with urllib.request.urlopen(req) as r:
            return r.status, json.loads(r.read())
    except urllib.error.HTTPError as e:
        return e.code, e.read().decode()

body = json.dumps(payload).encode()
good = hmac.new(SECRET, body, hashlib.sha256).hexdigest()

print("valid signature  ->", send(body, good))
print("tampered request ->", send(body, "deadbeef" * 8))