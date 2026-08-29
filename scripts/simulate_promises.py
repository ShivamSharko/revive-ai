"""Seed demo promises — some fulfilled, some broken."""
from datetime import datetime, timedelta
from app.db.database import SessionLocal
from app.db.models import PaymentFailure
from app.db.models import Promise


def main():
    db = SessionLocal()
    failures = db.query(PaymentFailure).limit(10).all()
    
    # Create 5 pending promises (future dates)
    for f in failures[:5]:
        p = Promise(failure_id=f.id, customer_id=f.customer_id,
                    promised_at=datetime.now() + timedelta(days=3),
                    status="pending",
                    notes=f"Customer promised to pay ₹{f.amount_paise//100} on salary day")
        db.add(p)
    
    # Create 2 broken promises (past dates, not fulfilled)
    for f in failures[5:7]:
        p = Promise(failure_id=f.id, customer_id=f.customer_id,
                    promised_at=datetime.now() - timedelta(days=2),
                    status="escalated",
                    notes=f"Customer promised {5} days ago, no payment yet")
        db.add(p)
    
    # Create 3 fulfilled promises
    for f in failures[7:10]:
        p = Promise(failure_id=f.id, customer_id=f.customer_id,
                    promised_at=datetime.now() - timedelta(days=1),
                    status="fulfilled",
                    notes=f"Payment completed on promised date")
        db.add(p)
    
    db.commit()
    print(f"Seeded 10 promises (5 pending, 2 broken, 3 fulfilled)")
    db.close()


if __name__ == "__main__":
    main()