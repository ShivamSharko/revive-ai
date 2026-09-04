"""Unit tests for the 8-rule Consent Gate (R-01..R-08)."""

import pytest
from app.core.gate import evaluate_consent, Verdict
from app.core.policy import POLICY_VERSION
from app.db.models import PaymentFailure
from datetime import datetime


def _make(archetype, owner, context, amount_paise=150000):
    return PaymentFailure(
        id=99999,
        external_payment_id="pay_test",
        amount_paise=amount_paise,
        currency="INR",
        method="upi",
        failure_code="TEST",
        failure_description="test",
        customer_id="cust_test",
        merchant_id="merch_test",
        context=context,
        session_active=(context == "in_session_online"),
        status="pending",
        source="test",
        occurred_at=datetime.now(),
    )


def test_r01_rbi_mandate_blocks():
    """R-01: RBI mandate < 24h blocks lifecycle failures."""
    from app.core.diagnosis import DiagnosisResult
    f = _make("lifecycle", "merchant", "recurring")
    diag = DiagnosisResult(archetype="lifecycle", owner="merchant", confidence=0.9)
    verdict, rule, reason = evaluate_consent(None, f, diag)
    assert verdict == Verdict.BLOCK
    assert "R01" in rule


def test_r02_fee_shock_blocks():
    """R-02: Fee shock blocks intent failures."""
    from app.core.diagnosis import DiagnosisResult
    f = _make("intent", "merchant", "in_session_online")
    diag = DiagnosisResult(archetype="intent", owner="merchant", confidence=0.9)
    verdict, rule, reason = evaluate_consent(None, f, diag)
    assert verdict == Verdict.BLOCK
    assert "R02" in rule


def test_r03_structural_stop():
    """R-03: Structural affordability failures block."""
    from app.core.diagnosis import DiagnosisResult
    f = _make("affordability", "customer_structural", "in_session_online")
    diag = DiagnosisResult(archetype="affordability", owner="customer_structural", confidence=0.9)
    verdict, rule, reason = evaluate_consent(None, f, diag)
    assert verdict == Verdict.BLOCK
    assert "R03" in rule


def test_r04_liquidity_defer():
    """R-04: Temporary affordability failures defer."""
    from app.core.diagnosis import DiagnosisResult
    f = _make("affordability", "customer_temp", "in_session_online")
    diag = DiagnosisResult(archetype="affordability", owner="customer_temp", confidence=0.9)
    verdict, rule, reason = evaluate_consent(None, f, diag)
    assert verdict == Verdict.DEFER
    assert "R04" in rule


def test_r05_tech_retry():
    """R-05: Technical infra failures allow retry."""
    from app.core.diagnosis import DiagnosisResult
    f = _make("technical", "infra", "in_session_online")
    diag = DiagnosisResult(archetype="technical", owner="infra", confidence=0.9)
    verdict, rule, reason = evaluate_consent(None, f, diag)
    assert verdict == Verdict.ALLOW
    assert "R05" in rule


def test_r06_default_allow():
    """R-06: Default path allows safe retry."""
    from app.core.diagnosis import DiagnosisResult
    f = _make("intent", "customer_temp", "in_session_online")
    diag = DiagnosisResult(archetype="intent", owner="customer_temp", confidence=0.9)
    verdict, rule, reason = evaluate_consent(None, f, diag)
    assert verdict == Verdict.ALLOW
    assert "R06" in rule


def test_r07_offline_qr_trap():
    """R-07: Offline QR trap blocks double-charge."""
    from app.core.diagnosis import DiagnosisResult
    f = _make("technical", "infra", "post_session_offline")
    diag = DiagnosisResult(archetype="technical", owner="infra", confidence=0.9)
    verdict, rule, reason = evaluate_consent(None, f, diag)
    assert verdict == Verdict.BLOCK
    assert "R07" in rule


def test_r08_retry_budget():
    """R-08: Retry budget blocks after 3 attempts."""
    from app.core.diagnosis import DiagnosisResult
    from app.db.database import SessionLocal
    db = SessionLocal()
    
    # Create 3 prior ALLOW decisions for same customer
    for i in range(3):
        f_prior = _make("technical", "infra", "in_session_online")
        f_prior.external_payment_id = f"pay_prior_{i}"
        db.add(f_prior)
        db.commit()
        
        from app.db.models import GateDecision
        gd = GateDecision(failure_id=f_prior.id, rule_id="R05", verdict="ALLOW",
                         context_snapshot={"archetype": "technical"})
        db.add(gd)
        db.commit()
    
    # 4th attempt should block
    f = _make("technical", "infra", "in_session_online")
    diag = DiagnosisResult(archetype="technical", owner="infra", confidence=0.9)
    verdict, rule, reason = evaluate_consent(db, f, diag)
    assert verdict == Verdict.BLOCK
    assert "R08" in rule
    db.close()


def test_double_charge_guard():
    """Double-charge guard blocks when customer reports deduction without settlement."""
    from app.core.diagnosis import DiagnosisResult
    f = _make("technical", "infra", "in_session_online")
    f.failure_description = "mere paise kat gaye par merchant ko nahi mile"
    diag = DiagnosisResult(archetype="technical", owner="infra", confidence=0.9)
    verdict, rule, reason = evaluate_consent(None, f, diag)
    assert verdict == Verdict.BLOCK
    assert "DOUBLE_CHARGE" in rule


def test_precedence_r01_over_r05():
    """R-01 mandate blocks even when archetype is technical."""
    from app.core.diagnosis import DiagnosisResult
    f = _make("technical", "merchant", "recurring")
    diag = DiagnosisResult(archetype="technical", owner="merchant", confidence=0.9)
    verdict, rule, reason = evaluate_consent(None, f, diag)
    # Merchant-owned lifecycle failures should trigger R-01
    assert verdict == Verdict.BLOCK


def test_precedence_r07_over_r05():
    """R-07 offline trap blocks even when infra-owned technical."""
    from app.core.diagnosis import DiagnosisResult
    f = _make("technical", "infra", "post_session_offline")
    diag = DiagnosisResult(archetype="technical", owner="infra", confidence=0.9)
    verdict, rule, reason = evaluate_consent(None, f, diag)
    assert verdict == Verdict.BLOCK
    assert "R07" in rule


def test_economic_floor_sub_100():
    """Transactions below ₹100 handled gracefully (no crash)."""
    from app.core.diagnosis import DiagnosisResult
    f = _make("technical", "infra", "in_session_online", amount_paise=5000)
    diag = DiagnosisResult(archetype="technical", owner="infra", confidence=0.9)
    verdict, rule, reason = evaluate_consent(None, f, diag)
    # Should not crash, verdict is one of the three
    assert verdict in (Verdict.ALLOW, Verdict.BLOCK, Verdict.DEFER)


def test_policy_version_exists():
    """Policy version is defined."""
    assert POLICY_VERSION == "1.0.0"


def test_verdict_enum_values():
    """Verdict enum has correct string values."""
    assert Verdict.ALLOW == "ALLOW"
    assert Verdict.BLOCK == "BLOCK"
    assert Verdict.DEFER == "DEFER"


def test_all_rules_return_reasoning():
    """Every rule returns non-empty reasoning string."""
    from app.core.diagnosis import DiagnosisResult
    test_cases = [
        ("lifecycle", "merchant", "recurring"),
        ("intent", "merchant", "in_session_online"),
        ("affordability", "customer_structural", "in_session_online"),
        ("affordability", "customer_temp", "in_session_online"),
        ("technical", "infra", "in_session_online"),
        ("technical", "infra", "post_session_offline"),
    ]
    for arch, owner, ctx in test_cases:
        f = _make(arch, owner, ctx)
        diag = DiagnosisResult(archetype=arch, owner=owner, confidence=0.9)
        verdict, rule, reason = evaluate_consent(None, f, diag)
        assert reason and len(reason) > 10, f"Rule {rule} returned empty reasoning"