"""Unit tests for the deterministic Consent Gate (R-01..R-07)."""
from app.core.gate import evaluate_consent, Verdict
from app.core.diagnosis import DiagnosisOut
from app.db.models import PaymentFailure


def mk(context="in_session_online"):
    return PaymentFailure(
        external_payment_id="pay_unit_test", amount_paise=10000, method="upi",
        failure_code="TEST", customer_id="cust_t", merchant_id="merch_t",
        context=context, session_active=context.startswith("in_session"))


def d(arch, owner):
    return DiagnosisOut(archetype=arch, owner=owner, confidence=0.9, reasoning="unit test")


def test_r01_rbi_mandate_blocks():
    v, r, _ = evaluate_consent(None, mk(), d("lifecycle", "merchant"))
    assert (v, r) == (Verdict.BLOCK, "R01_RBI_MANDATE")

def test_r02_fee_shock_blocks():
    v, r, _ = evaluate_consent(None, mk(), d("intent", "merchant"))
    assert (v, r) == (Verdict.BLOCK, "R02_FEE_SHOCK")

def test_r03_structural_stop_blocks():
    v, r, _ = evaluate_consent(None, mk(), d("affordability", "customer_structural"))
    assert (v, r) == (Verdict.BLOCK, "R03_STRUCTURAL_STOP")

def test_r07_offline_qr_trap_blocks():
    v, r, _ = evaluate_consent(None, mk("post_session_offline"), d("technical", "infra"))
    assert (v, r) == (Verdict.BLOCK, "R07_OFFLINE_QR_TRAP")

def test_r05_technical_retry_allowed():
    v, r, _ = evaluate_consent(None, mk(), d("technical", "infra"))
    assert (v, r) == (Verdict.ALLOW, "R05_TECH_RETRY")

def test_r06_default_allow():
    v, r, _ = evaluate_consent(None, mk(), d("intent", "customer_temp"))
    assert (v, r) == (Verdict.ALLOW, "R06_DEFAULT_ALLOW")