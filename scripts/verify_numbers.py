"""One-command health check: prints every metric you need for the README."""
from app.db.database import SessionLocal
from app.db.models import PaymentFailure, Diagnosis, GateDecision, RecoveryAction
from sqlalchemy import func

db = SessionLocal()

# Core counts
total = db.query(func.count(PaymentFailure.id)).scalar()

# Gate breakdown
allow = db.query(func.count(GateDecision.id)).filter(GateDecision.verdict == "ALLOW").scalar()
defer = db.query(func.count(GateDecision.id)).filter(GateDecision.verdict == "DEFER").scalar()
block = db.query(func.count(GateDecision.id)).filter(GateDecision.verdict == "BLOCK").scalar()

# Money
recovered_paise = db.query(func.sum(PaymentFailure.amount_recovered_paise)).scalar() or 0
protected_paise = db.query(func.sum(PaymentFailure.amount_protected_paise)).scalar() or 0
blocked_paise = (db.query(func.sum(PaymentFailure.amount_protected_paise))
                 .filter(PaymentFailure.status == "protected").scalar() or 0)
deferred_paise = (db.query(func.sum(PaymentFailure.amount_protected_paise))
                  .filter(PaymentFailure.status == "deferred").scalar() or 0)

# Diagnosis source
llm_count = db.query(func.count(Diagnosis.id)).filter(Diagnosis.model_used != "rules").scalar()
rules_count = db.query(func.count(Diagnosis.id)).filter(Diagnosis.model_used == "rules").scalar()

# Per-archetype recovered
from sqlalchemy import case
arch_recovered = dict(db.query(
    Diagnosis.archetype,
    func.sum(PaymentFailure.amount_recovered_paise)
).join(PaymentFailure).filter(PaymentFailure.status == "recovered")
 .group_by(Diagnosis.archetype).all())

db.close()

print("\n" + "=" * 56)
print("REVIVE AI — NUMBERS VERIFICATION")
print("=" * 56)
print(f"Total failures processed : {total}")
print(f"Gate ALLOW (retry)       : {allow}")
print(f"Gate DEFER (salary-day)  : {defer}")
print(f"Gate BLOCK (protect)     : {block}")
print("-" * 56)
print(f"Revenue recaptured       : ₹{recovered_paise/100:,.0f}")
print(f"Protected (BLOCK)        : ₹{blocked_paise/100:,.0f}")
print(f"Deferred (DEFER)         : ₹{deferred_paise/100:,.0f}")
print(f"TOTAL protected          : ₹{(blocked_paise + deferred_paise)/100:,.0f}")
print("-" * 56)
print(f"LLM diagnosed            : {llm_count}")
print(f"Rules fallback           : {rules_count}")
print(f"Pure LLM batch           : {'✅ YES' if rules_count == 0 else '❌ NO — run simulate again'}")
print("-" * 56)
for arch in ["technical", "intent", "affordability", "lifecycle"]:
    val = (arch_recovered.get(arch, 0) or 0) / 100
    print(f"  {arch:15s} : ₹{val:>10,.0f} recovered")
print("=" * 56)
print("\nRun `python -m app.data.evaluate` separately for accuracy %.")