import json
import hmac
import hashlib
from datetime import datetime
from fastapi import APIRouter, HTTPException, Request, BackgroundTasks
from app.config import settings
from app.db.database import SessionLocal
from app.db.models import PaymentFailure
from app.core.worker import process_failure

router = APIRouter()

@router.post("/webhooks/razorpay")
async def razorpay_webhook(request: Request, background_tasks: BackgroundTasks):
    body = await request.body()
    sig = request.headers.get("X-Razorpay-Signature", "")
    expected = hmac.new(settings.WEBHOOK_SECRET.encode(), body, hashlib.sha256).hexdigest()
    if not hmac.compare_digest(sig, expected):
        raise HTTPException(400, "invalid signature")

    event = json.loads(body)
    if event.get("event") != "payment.failed":
        return {"status": "ignored"}

    p = event["payload"]["payment"]["entity"]
    db = SessionLocal()
    try:
        f = db.query(PaymentFailure).filter_by(external_payment_id=p["id"]).first()
        if not f:
            f = PaymentFailure(
                external_payment_id=p["id"], source="live",
                amount_paise=p["amount"], currency=p.get("currency", "INR"),
                method=p.get("method", "upi"),
                failure_code=p.get("error_code", "UNKNOWN"),
                failure_description=p.get("error_description", ""),
                customer_id=p.get("customer_id") or "cust_live_001",
                merchant_id="merch_001", context="in_session_online",
                session_active=True, status="pending",
                occurred_at=datetime.fromtimestamp(event.get("created_at", datetime.now().timestamp())))
            db.add(f)
            db.commit()
            db.refresh(f)

        # QUEUE for async processing — returns immediately
        background_tasks.add_task(process_failure, f.id)
        return {"status": "queued", "payment_id": p["id"], "failure_id": f.id}
    finally:
        db.close()

@router.post("/webhooks/razorpay/subscriptions")
async def subscription_webhook(request: Request, background_tasks: BackgroundTasks):
    body = await request.body()
    sig = request.headers.get("X-Razorpay-Signature", "")
    expected = hmac.new(settings.WEBHOOK_SECRET.encode(), body, hashlib.sha256).hexdigest()
    if not hmac.compare_digest(sig, expected):
        raise HTTPException(400, "invalid signature")

    event = json.loads(body)
    if event.get("event") != "subscription.charged.failed":
        return {"status": "ignored"}

    p = event["payload"]["subscription"]["entity"]
    db = SessionLocal()
    try:
        f = PaymentFailure(
            external_payment_id=p.get("id", "sub_unknown"),
            source="subscription",
            amount_paise=p.get("amount", 0),
            currency="INR",
            method="emandate",
            failure_code="MANDATE_NOTIFICATION_BREACH",
            failure_description="Subscription charge failed — possible mandate breach",
            customer_id=p.get("customer_id", "cust_sub_001"),
            merchant_id="merch_002",
            context="recurring",
            session_active=False,
            status="pending",
            occurred_at=datetime.now()
        )
        db.add(f)
        db.commit()
        db.refresh(f)

        background_tasks.add_task(process_failure, f.id)
        return {"status": "queued", "subscription_id": p.get("id")}
    finally:
        db.close()