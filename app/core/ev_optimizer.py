"""Expected Value Optimizer. (Probability * Amount) - Cost."""
from app.core.health import get_success_rate

RETRY_COST_INR = 2.50  # Assumed Razorpay retry fee

def calculate_ev(amount_paise: int, bank_code: str = "DEFAULT") -> dict:
    prob = get_success_rate(bank_code)
    amount_inr = amount_paise / 100
    expected_revenue = prob * amount_inr
    ev = expected_revenue - RETRY_COST_INR
    return {
        "probability": round(prob, 2),
        "expected_revenue": round(expected_revenue, 2),
        "cost": RETRY_COST_INR,
        "ev": round(ev, 2),
        "recommendation": "RETRY" if ev > 0 else "DEFER"
    }