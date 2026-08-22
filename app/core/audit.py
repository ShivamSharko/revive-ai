"""Merchant Compliance Audit: flags RBI mandate violations to prevent fines."""
from sqlalchemy import func
from sqlalchemy.orm import Session
from app.db.models import MerchantConfig, PaymentFailure

def audit_merchant_compliance(db: Session):
    """Checks merchants against RBI mandate rules and returns a risk report."""
    merchants = db.query(MerchantConfig).all()

    # Single grouped aggregation — no N+1 (2 queries total at any scale)
    failure_counts = dict(
        db.query(PaymentFailure.merchant_id, func.count(PaymentFailure.id))
        .filter(PaymentFailure.failure_code == "MANDATE_NOTIFICATION_BREACH")
        .group_by(PaymentFailure.merchant_id)
        .all()
    )

    report = []
    for m in merchants:
        risk_level = "CLEAN"
        reason = ""

        # RBI Rule: pre-debit notification must be >= 24h
        if m.pre_debit_notification_hours < 24:
            risk_level = "CRITICAL"
            reason = f"Notification sent at {m.pre_debit_notification_hours}h (RBI requires >=24h). Fines imminent."

        mandate_failures = failure_counts.get(m.merchant_id, 0)

        if mandate_failures > 10 and risk_level == "CLEAN":
            risk_level = "WARNING"
            reason = f"High volume of mandate failures ({mandate_failures}). Check notification system."

        report.append({
            "merchant_id": m.merchant_id,
            "notification_hours": m.pre_debit_notification_hours,
            "risk_level": risk_level,
            "reason": reason,
            "mandate_failures": mandate_failures,
        })

    return report