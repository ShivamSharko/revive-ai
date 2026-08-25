"""Flow D: B2B overdue receivables — dispute halt + payment-plan splitting."""
from collections import Counter

def build_payment_plan(amount_inr, history_days, max_installments=3):
    if not history_days:
        history_days = [5, 15, 25]
    modal = Counter(history_days).most_common(1)[0][0]
    per = amount_inr // max_installments
    return [{"installment": k + 1, "amount_inr": per,
             "due_day": modal if k == 0 else (modal + 10 * k) % 28 + 1}
            for k in range(max_installments)]

def process_receivables(invoices):
    results = []
    for inv in invoices:
        if inv.get("dispute_raised"):
            results.append({"invoice": inv["id"], "action": "HALT_AND_ESCALATE",
                "reason": "Dispute raised — automated chasing is harassment. Human escalation."})
        elif inv.get("cashflow_issue"):
            plan = build_payment_plan(inv["amount_inr"], inv.get("history_days", []))
            results.append({"invoice": inv["id"], "action": "PAYMENT_PLAN", "plan": plan,
                "reason": f"Cashflow issue — split aligned to modal payment day {plan[0]['due_day']}."})
        else:
            results.append({"invoice": inv["id"], "action": "GENTLE_REMINDER",
                "reason": "Simple oversight — one polite reminder, no penalty."})
    return results