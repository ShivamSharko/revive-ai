"""Deterministic message validator — AI drafts, rules approve (Law 4)."""
import re

FORBIDDEN = [
    r"urgent", r"last chance", r"final notice", r"legal action", r"penalt",
    r"cashback", r"reward points", r"discount", r"offer expires", r"act now",
]

def validate_customer_message(text: str, rupees: float = None):
    """Returns (ok, reason). Rejects pressure, fake promises, invented amounts."""
    if not text or len(text) > 400:
        return False, "empty or too long"
    low = text.lower()
    for pat in FORBIDDEN:
        if re.search(pat, low):
            return False, f"pressure/promise term: {pat}"
    if rupees is not None:
        for m in re.finditer(r"(?:₹|rs\.?|inr)\s?([\d,]+)", low):
            if abs(float(m.group(1).replace(",", "")) - rupees) > 0.5:
                return False, "invented amount"
    return True, "ok"