"""Flow D demo: synthetic B2B overdue invoices -> dispute halt / payment plans."""
import random
from app.core.receivables import process_receivables

random.seed(7)

def main():
    invoices = [{"id": f"INV-2026-{i:03d}",
                 "amount_inr": random.choice([15000, 42000, 80000, 120000]),
                 "dispute_raised": i % 5 == 2,
                 "cashflow_issue": i % 3 == 0 and i % 5 != 2,
                 "history_days": random.choice([[1, 1, 5], [15, 15, 20], [5, 10, 15]])}
                for i in range(12)]
    print("=" * 64)
    print("FLOW D: B2B OVERDUE RECEIVABLES")
    print("=" * 64)
    for r in process_receivables(invoices):
        print(f"\n{r['invoice']} -> {r['action']}")
        print(f"  why: {r['reason']}")
        for s in r.get("plan", []):
            print(f"    installment {s['installment']}: Rs.{s['amount_inr']:,.0f} due day {s['due_day']}")
    print("=" * 64)

if __name__ == "__main__":
    main()