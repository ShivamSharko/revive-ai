"""Unit tests for the deterministic Consent Gate (R-01..R-07)."""
from app.core.gate import evaluate_consent, Verdict
from app.core.gate import (R01_RBI_MANDATE, R02_FEE_SHOCK, R03_STRUCTURAL_STOP,
                           R05_TECH_RETRY, R06_DEFAULT_ALLOW, R07_OFFLINE_QR_TRAP)
from app.core.diagnosis import DiagnosisOut
from app.db.models import PaymentFailure
from app.db.database import SessionLocal


def mk(context="in_session_online"):
    return PaymentFailure(
        external_payment_id="pay_unit_test", amount_paise=10000, method="upi",
        failure_code="TEST", customer_id="cust_t", merchant_id="merch_t",
        context=context, session_active=context.startswith("in_session"))


def d(arch, owner):
    return DiagnosisOut(archetype=arch, owner=owner, confidence=0.9, reasoning="unit test")


def run_test(arch, owner, context, expected_verdict, expected_rule):
    db = SessionLocal()
    try:
        v, r, _ = evaluate_consent(db, mk(context), d(arch, owner))
        assert (v, r) == (expected_verdict, expected_rule)
    finally:
        db.close()


def test_r01_rbi_mandate_blocks():
    run_test("lifecycle", "merchant", "in_session_online", Verdict.BLOCK, R01_RBI_MANDATE)


def test_r02_fee_shock_blocks():
    run_test("intent", "merchant", "in_session_online", Verdict.BLOCK, R02_FEE_SHOCK)


def test_r03_structural_stop_blocks():
    run_test("affordability", "customer_structural", "in_session_online", Verdict.BLOCK, R03_STRUCTURAL_STOP)


def test_r07_offline_qr_trap_blocks():
    run_test("technical", "infra", "post_session_offline", Verdict.BLOCK, R07_OFFLINE_QR_TRAP)


def test_r05_technical_retry_allowed():
    run_test("technical", "infra", "in_session_online", Verdict.ALLOW, R05_TECH_RETRY)


def test_r06_default_allow():
    run_test("intent", "customer_temp", "in_session_online", Verdict.ALLOW, R06_DEFAULT_ALLOW)