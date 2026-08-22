"""Run the Merchant Compliance Audit and print the B2B risk report."""
from app.db.database import SessionLocal
from app.core.audit import audit_merchant_compliance

def main():
    db = SessionLocal()
    try:
        report = audit_merchant_compliance(db)
        print("\n--- MERCHANT COMPLIANCE AUDIT ---")
        
        critical = 0
        for m in report:
            status_icon = "[OK]" if m["risk_level"] == "CLEAN" else ("[!!]" if m["risk_level"] == "CRITICAL" else "[!]")
            print(f"{status_icon} {m['merchant_id']} | {m['risk_level']} | {m['reason']}")
            if m["risk_level"] == "CRITICAL":
                critical += 1
                
        print(f"\nSummary: {critical} merchants in CRITICAL violation of RBI mandates.")
        print("Action: Revive AI auto-blocks recurring retries for CRITICAL merchants to prevent compounding fines.")
    finally:
        db.close()

if __name__ == "__main__":
    main()