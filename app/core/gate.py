"""The Consent Gate: applies business rules and RBI compliance before any action."""
from collections import Counter
from app.db.models import PaymentFailure, MerchantConfig, CustomerPaymentHistory, GateDecision
from app.core.diagnosis import DiagnosisOut
from sqlalchemy.orm import Session
from app.core.liquidity import liquidity_curve

# THE 8 RULES OF THE CONSENT GATE
R01_RBI_MANDATE = "R01_RBI_MANDATE"
R02_FEE_SHOCK = "R02_FEE_SHOCK"
R03_STRUCTURAL_STOP = "R03_STRUCTURAL_STOP"
R04_LIQUIDITY_DEFER = "R04_LIQUIDITY_DEFER"
R05_TECH_RETRY = "R05_TECH_RETRY"
R06_DEFAULT_ALLOW = "R06_DEFAULT_ALLOW"
R07_OFFLINE_QR_TRAP = "R07_OFFLINE_QR_TRAP"
R08_RETRY_BUDGET = "R08_RETRY_BUDGET"

class Verdict:
    ALLOW = "ALLOW"
    BLOCK = "BLOCK"
    DEFER = "DEFER"

def evaluate_consent(db: Session, failure: PaymentFailure, diag: DiagnosisOut):
    """Returns (verdict, rule_id, reasoning)"""
    
    # LAW 8: Retry budget — stopping rules over spam
    prior_allows = db.query(GateDecision).join(
        PaymentFailure, PaymentFailure.id == GateDecision.failure_id).filter(
        PaymentFailure.customer_id == failure.customer_id,
        GateDecision.verdict == "ALLOW").count()
    if prior_allows >= 3:
        return Verdict.BLOCK, R08_RETRY_BUDGET, "Retry budget exhausted (3 safe attempts). Stopping rules over spam."

    # LAW 1: RBI Mandate Compliance
    if diag.archetype == "lifecycle" and diag.owner == "merchant":
        return Verdict.BLOCK, R01_RBI_MANDATE, "Pre-debit notification < 24h. RBI compliance block."

    # LAW 2: Fee Shock Prevention
    if diag.archetype == "intent" and diag.owner == "merchant":
        return Verdict.BLOCK, R02_FEE_SHOCK, "Hidden fees caused abandonment. Do not retry."

    # LAW 3: Structural Stop (Don't spam broken customers)
    if diag.owner == "customer_structural":
        return Verdict.BLOCK, R03_STRUCTURAL_STOP, "Repeated failures. Spamming will cause churn."

    # LAW 4: Liquidity Deferral (Wait for salary day)
    if diag.archetype == "affordability" and diag.owner == "customer_temp":
        curve = liquidity_curve(db, failure.customer_id)
        day = curve["modal_day"] or (failure.occurred_at.day + 7)
        reasoning = (f"Liquidity curve over {curve['samples']} captured payments: modal day "
                     f"{curve['modal_day']} (conf {curve['confidence']}), "
                     f"histogram {curve['histogram']}. Defer to day {day}.")
        return Verdict.DEFER, R04_LIQUIDITY_DEFER, reasoning

    # ★ THE DEMO STAR: Offline QR Consent Trap (R-07) ★
    # Customer left physical store. Silent retry = double charge.
    if diag.archetype == "technical" and failure.context == "post_session_offline":
        return Verdict.BLOCK, R07_OFFLINE_QR_TRAP, "Customer left store. Silent retry blocked to prevent double-charge."

    # LAW 5: Technical / Infra / Merchant Config -> Safe to retry
    if diag.archetype == "technical":
        return Verdict.ALLOW, R05_TECH_RETRY, "Transient technical failure. Safe to retry."

    # Customer-report guard (deterministic): deduction without settlement → never retry
    import re as _re
    if _re.search(r"kat gay|kat gye|deduct|double|do baar|dubara|merchant.{0,20}(nhi|nahi|not)|pahunche|refund",
                  failure.failure_description or "", _re.I):
        return Verdict.BLOCK, "DOUBLE_CHARGE_GUARD", \
            "Customer reports deduction without settlement — a retry would double-charge. " \
            "Reconciliation + auto-refund instead."

    # Default
    return Verdict.ALLOW, R06_DEFAULT_ALLOW, "No blocking rules triggered."