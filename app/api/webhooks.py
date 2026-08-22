"""Razorpay webhook ingestion with HMAC verification + full pipeline."""
import hashlib
import hmac
import json
from datetime import datetime

from fastapi import APIRouter, HTTPException, Request

from app.config import settings
from app.core.diagnosis import diagnose_batch
from app.core.gate import evaluate_consent
from app.core.recovery import execute_recovery
from app.db.database import SessionLocal
from app.db.models import (AuditLog, Diagnosis, GateDecision, PaymentFailure)

router = APIRouter()

@router.post("/webhooks/razorpay")
async def razorpay_webhook(request: Request):
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

        (diag, model), = diagnose_batch([f])
        db.add(Diagnosis(failure_id=f.id, archetype=diag.archetype, owner=diag.owner,
                         confidence=diag.confidence, reasoning=diag.reasoning,
                         model_used=model))
        verdict, rule_id, reasoning = evaluate_consent(db, f, diag)
        db.add(GateDecision(failure_id=f.id, rule_id=rule_id, verdict=verdict))
        execute_recovery(db, f, verdict, rule_id, reasoning)
        
        # FIX: Polymorphic audit log insertion with string(8) actor constraint
        db.add(AuditLog(entity_type="failure", entity_id=f.id, actor="system",
                        action=f"{verdict}:{rule_id}", reasoning=reasoning))
        
        db.commit()
        return {"payment_id": p["id"], "verdict": verdict, "rule_id": rule_id}
    finally:
        db.close()