def main():
    db = SessionLocal()
    try:
        from sqlalchemy import text
        # Foolproof cleanup: bypasses SQLAlchemy session cache entirely
        db.execute(text("TRUNCATE TABLE payment_failures, customer_payment_history RESTART IDENTITY CASCADE;"))
        db.commit()

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
    finally:
        db.close()