"""Synthetic 500-failure generator — labeled ground truth, seeded, reproducible."""
import random
from collections import Counter
from datetime import datetime

from app.db.database import SessionLocal
from app.db.models import PaymentFailure, CustomerPaymentHistory, MerchantConfig

random.seed(42)
NOW = datetime.now()

MERCHANTS = [
    ("merch_001", 24, 1, False),
    ("merch_002", 12, 1, False),   # RBI compliance violator (12h < 24h)
    ("merch_003", 24, 5, True),    # fee-shock funnel
    ("merch_004", 24, 1, False),
    ("merch_005", 20, 15, False),  # mild violator
]

CASES = [
    dict(w=18, archetype="technical", owner="infra", method="upi",
         code="UPI_BANK_TIMEOUT", desc="UPI request timed out at PSP; bank server degraded",
         context="in_session_online", dropped=None),
    dict(w=8, archetype="technical", owner="infra", method="card",
         code="GATEWAY_5XX", desc="Issuer gateway returned 502 during authorization",
         context="in_session_online", dropped=None),
    dict(w=6, archetype="technical", owner="merchant", method="upi",
         code="CHECKOUT_CONFIG_ERROR", desc="Merchant checkout misconfiguration rejected payment payload",
         context="in_session_online", dropped=None),
    dict(w=10, archetype="intent", owner="merchant", method="upi",
         code="ABANDONED_AT_FEES", desc="Order created; session dropped at fee reveal before payment attempt",
         context="post_session_online", dropped="fees"),
    dict(w=10, archetype="intent", owner="customer_temp", method="card",
         code="ABANDONED_AT_OTP", desc="Order created; user dropped at OTP step",
         context="post_session_online", dropped="otp"),
    dict(w=14, archetype="affordability", owner="customer_temp", method="upi",
         code="INSUFFICIENT_BALANCE", desc="Bank declined: insufficient balance",
         context="in_session_online", dropped=None),
    dict(w=6, archetype="affordability", owner="customer_structural", method="card",
         code="REPEATED_INSUFFICIENT_BALANCE", desc="4th consecutive cycle declined for insufficient balance",
         context="recurring", dropped=None),
    dict(w=10, archetype="lifecycle", owner="merchant", method="upi",
         code="MANDATE_NOTIFICATION_BREACH", desc="E-mandate charge blocked; pre-debit notification sent <24h before debit",
         context="recurring", dropped=None),
    dict(w=8, archetype="lifecycle", owner="customer_temp", method="card",
         code="CARD_EXPIRED", desc="Card on file expired",
         context="recurring", dropped=None),
    dict(w=10, archetype="technical", owner="infra", method="upi",
         code="OFFLINE_QR_TIMEOUT", desc="QR scan timed out in-store; customer left before completion",
         context="post_session_offline", dropped=None),
]

def ts(day=None):
    d = day or random.randint(1, 28)
    return NOW.replace(day=d, hour=random.randint(8, 23),
                       minute=random.randint(0, 59), second=0, microsecond=0)

def main():
    db = SessionLocal()

    # merchants
    for mid, hours, bday, fee in MERCHANTS:
        if not db.query(MerchantConfig).filter_by(merchant_id=mid).first():
            db.add(MerchantConfig(merchant_id=mid, pre_debit_notification_hours=hours,
                                  billing_day=bday, fee_reveal_at_checkout=fee))

    # customers + liquidity histories (salary-day clusters)
    custs = []
    for i in range(1, 81):
        cid = f"cust_{i:03d}"
        liq_day = random.choice([1, 1, 1, 5, 15, 20])
        custs.append((cid, liq_day))
        for k in range(8):
            db.add(CustomerPaymentHistory(customer_id=cid, day_of_month=liq_day,
                                          amount_paise=random.randint(100, 5000) * 100,
                                          status="captured"))

    # 500 labeled failures
    pool = [c for c in CASES for _ in range(c["w"])]
    random.shuffle(pool)
    total = 0
    for i in range(500):
        c = pool[i % len(pool)]
        cid, liq_day = random.choice(custs)
        mid = random.choice(MERCHANTS)[0]
        if c["code"] == "MANDATE_NOTIFICATION_BREACH":
            mid = random.choice(["merch_002", "merch_005"])
        if c["code"] == "ABANDONED_AT_FEES":
            mid = "merch_003"
        day = random.randint(24, 28) if c["archetype"] == "affordability" and \
             c["owner"] == "customer_temp" else None
        amt = random.randint(149, 4999) * 100
        total += amt
        db.add(PaymentFailure(
            external_payment_id=f"pay_sim_{i:04d}", source="synthetic",
            amount_paise=amt, method=c["method"], failure_code=c["code"],
            failure_description=c["desc"], customer_id=cid, merchant_id=mid,
            context=c["context"], session_active=c["context"].startswith("in_session"),
            dropped_step=c["dropped"], true_archetype=c["archetype"],
            true_owner=c["owner"], status="pending", occurred_at=ts(day)))

    db.commit()

    rows = db.query(PaymentFailure).filter_by(source="synthetic").all()
    print(f"Written: {len(rows)} failures | Rs.{total/100:,.0f} at risk")
    print("By archetype:", dict(Counter(r.true_archetype for r in rows)))
    print("By owner:    ", dict(Counter(r.true_owner for r in rows)))

if __name__ == "__main__":
    main()