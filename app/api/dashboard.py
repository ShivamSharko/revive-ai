"""Read-only dashboard API: the agent's brain state as clean JSON."""
from fastapi import APIRouter
from sqlalchemy import func

from app.core.audit import audit_merchant_compliance
from app.db.database import SessionLocal
from app.db.models import (AuditLog, Diagnosis, GateDecision, Job, PaymentFailure)

router = APIRouter(prefix="/api")

@router.get("/overview")
def overview():
    db = SessionLocal()
    try:
        # O(1) memory: Postgres does the math, we just fetch the answers
        totals = db.query(
            func.count(PaymentFailure.id).label("count"),
            func.sum(PaymentFailure.amount_paise).label("at_risk"),
            func.sum(PaymentFailure.amount_recovered_paise).label("recovered"),
            func.sum(PaymentFailure.amount_protected_paise).label("protected")
        ).first()

        verdicts = dict(db.query(GateDecision.verdict, func.count(GateDecision.id))
                        .group_by(GateDecision.verdict).all())

        archetypes = dict(db.query(Diagnosis.archetype, func.count(Diagnosis.id))
                          .group_by(Diagnosis.archetype).all())

        return {
            "failures_total": totals.count or 0,
            "amount_at_risk_rupees": round((totals.at_risk or 0) / 100, 2),
            "amount_recovered_rupees": round((totals.recovered or 0) / 100, 2),
            "amount_protected_rupees": round((totals.protected or 0) / 100, 2),
            "verdicts": verdicts,
            "archetypes": archetypes,
        }
    finally:
        db.close()

@router.get("/failures")
def failures(limit: int = 20, verdict: str = None):
    db = SessionLocal()
    try:
        q = db.query(PaymentFailure)
        if verdict:
            q = q.join(GateDecision, GateDecision.failure_id == PaymentFailure.id) \
                 .filter(GateDecision.verdict == verdict)
        rows = q.order_by(PaymentFailure.id.desc()).limit(min(limit, 100)).all()
        ids = [f.id for f in rows]
        # two bulk lookups — no N+1 (lesson from Day 8)
        diags = {d.failure_id: d for d in db.query(Diagnosis).filter(Diagnosis.failure_id.in_(ids)).all()}
        gates = {g.failure_id: g for g in db.query(GateDecision).filter(GateDecision.failure_id.in_(ids)).all()}
        return [{
            "payment_id": f.external_payment_id,
            "rupees": round(f.amount_paise / 100, 2),
            "method": f.method,
            "failure_code": f.failure_code,
            "context": f.context,
            "source": f.source,
            "diagnosis": {"archetype": diags[f.id].archetype, "owner": diags[f.id].owner,
                          "confidence": diags[f.id].confidence, "model": diags[f.id].model_used}
                         if f.id in diags else None,
            "verdict": gates[f.id].verdict if f.id in gates else None,
            "rule_id": gates[f.id].rule_id if f.id in gates else None,
            "status": f.status,
        } for f in rows]
    finally:
        db.close()

@router.get("/merchants")
def merchants():
    db = SessionLocal()
    try:
        return audit_merchant_compliance(db)
    finally:
        db.close()

@router.get("/jobs")
def jobs():
    db = SessionLocal()
    try:
        rows = db.query(Job).filter_by(status="queued").limit(50).all()
        fails = {f.id: f for f in db.query(PaymentFailure)
                 .filter(PaymentFailure.id.in_([j.failure_id for j in rows])).all()}
        return [{"payment_id": fails[j.failure_id].external_payment_id,
                 "kind": j.kind, "run_at": j.run_at.isoformat(), "status": j.status}
                for j in rows if j.failure_id in fails]
    finally:
        db.close()

@router.get("/audit")
def audit():
    db = SessionLocal()
    try:
        rows = db.query(AuditLog).order_by(AuditLog.id.desc()).limit(20).all()
        return [{"id": a.id, "entity": a.entity_type, "entity_id": a.entity_id,
                 "actor": a.actor, "action": a.action, "reasoning": a.reasoning}
                for a in rows]
    finally:
        db.close()