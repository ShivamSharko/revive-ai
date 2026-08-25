from sqlalchemy import (BigInteger, Boolean, Column, DateTime, Float,
                        ForeignKey, Integer, String, Text, JSON)
from sqlalchemy.sql import func
from app.db.database import Base


class PaymentFailure(Base):
    __tablename__ = "payment_failures"
    id = Column(Integer, primary_key=True)
    external_payment_id = Column(String(64), unique=True, index=True)
    source = Column(String(16))
    amount_paise = Column(BigInteger, nullable=False)
    currency = Column(String(8), default="INR")
    method = Column(String(32))
    failure_code = Column(String(64))
    failure_description = Column(Text)
    customer_id = Column(String(64), index=True)
    merchant_id = Column(String(64), index=True)
    context = Column(String(32))
    session_active = Column(Boolean, default=False)
    dropped_step = Column(String(32))
    archetype = Column(String(24))
    owner = Column(String(24))
    confidence = Column(Float)
    true_archetype = Column(String(24))
    true_owner = Column(String(24))
    status = Column(String(24), default="pending")
    amount_recovered_paise = Column(BigInteger, default=0)
    amount_protected_paise = Column(BigInteger, default=0)
    occurred_at = Column(DateTime(timezone=True))
    created_at = Column(DateTime(timezone=True), server_default=func.now())


class Diagnosis(Base):
    __tablename__ = "diagnoses"
    id = Column(Integer, primary_key=True)
    failure_id = Column(Integer, ForeignKey("payment_failures.id"), index=True)
    archetype = Column(String(24))
    owner = Column(String(24))
    confidence = Column(Float)
    reasoning = Column(Text)
    model_used = Column(String(32))
    created_at = Column(DateTime(timezone=True), server_default=func.now())


class GateDecision(Base):
    __tablename__ = "gate_decisions"
    id = Column(Integer, primary_key=True)
    failure_id = Column(Integer, ForeignKey("payment_failures.id"), index=True)
    rule_id = Column(String(32), nullable=False)  # FIX: was String(16), too short
    verdict = Column(String(16), nullable=False)
    context_snapshot = Column(JSON)
    created_at = Column(DateTime(timezone=True), server_default=func.now())


class RecoveryAction(Base):
    __tablename__ = "recovery_actions"
    id = Column(Integer, primary_key=True)
    failure_id = Column(Integer, ForeignKey("payment_failures.id"), index=True)
    action_type = Column(String(32))
    actor = Column(String(8))
    reasoning = Column(Text)
    status = Column(String(16))
    amount_recovered_paise = Column(BigInteger, default=0)
    executed_at = Column(DateTime(timezone=True))


class AuditLog(Base):
    __tablename__ = "audit_logs"
    id = Column(Integer, primary_key=True)
    entity_type = Column(String(32))
    entity_id = Column(Integer)
    actor = Column(String(8))
    action = Column(String(64))
    reasoning = Column(Text)
    metadata_json = Column(JSON)
    created_at = Column(DateTime(timezone=True), server_default=func.now())


class Job(Base):
    __tablename__ = "jobs"
    id = Column(Integer, primary_key=True)
    failure_id = Column(Integer, ForeignKey("payment_failures.id"), index=True)
    kind = Column(String(32))
    run_at = Column(DateTime(timezone=True), index=True)
    attempts = Column(Integer, default=0)
    max_attempts = Column(Integer, default=3)
    status = Column(String(16), default="queued")
    last_error = Column(Text)


class CustomerPaymentHistory(Base):
    __tablename__ = "customer_payment_history"
    id = Column(Integer, primary_key=True)
    customer_id = Column(String(64), index=True)
    day_of_month = Column(Integer)
    amount_paise = Column(BigInteger)
    status = Column(String(16))


class MerchantConfig(Base):
    __tablename__ = "merchant_config"
    id = Column(Integer, primary_key=True)
    merchant_id = Column(String(64), unique=True)
    pre_debit_notification_hours = Column(Integer, default=24)
    billing_day = Column(Integer)
    fee_reveal_at_checkout = Column(Boolean, default=False)


class PromiseToPay(Base):
    __tablename__ = "promises_to_pay"
    id = Column(Integer, primary_key=True)
    failure_id = Column(Integer, ForeignKey("payment_failures.id"), index=True)
    promised_date = Column(DateTime(timezone=True), nullable=False)
    amount_paise = Column(BigInteger, nullable=False)
    status = Column(String(16), default="active")
    created_at = Column(DateTime(timezone=True), server_default=func.now())