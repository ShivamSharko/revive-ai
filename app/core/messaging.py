"""Customer-facing recovery messages: LLM-drafted, guard-approved, bilingual."""
import json

from app.core.diagnosis import _get_clients
from app.core.resilience import with_backoff

SYSTEM = """You are Revive AI drafting a short WhatsApp payment-recovery message for a merchant.
Hard rules:
- Max 300 characters.
- Warm, respectful, ZERO pressure. No urgency, no threats, no credit-score/legal mentions.
- Plainly state what happened + ONE clear next step.
- MUST include: "Reply STOP to opt out."
- If lang=hi, write simple polite Hindi in Devanagari.
Output ONLY JSON: {"message": "..."}"""

FORBIDDEN = ["legal", "court", "police", "blacklist", "cibil", "credit score",
             "final notice", "last chance", "immediately", "urgent", "seize"]

FALLBACK = {
    ("ALLOW", "en"): "Hi! Your payment of Rs.{amt} didn't go through due to a technical reason. No stress - whenever you're ready, try again here: {link} Reply STOP to opt out.",
    ("ALLOW", "hi"): "नमस्ते! तकनीकी कारण से आपका Rs.{amt} का भुगतान पूरा नहीं हो सका। कोई जल्दी नहीं - जब चाहें यहाँ दोबारा कोशिश करें: {link} | रुकने के लिए STOP लिखें।",
    ("DEFER", "hi"): "नमस्ते! कोई जल्दी नहीं। हम अगले महीने की {day} तारीख़ के बाद आपका Rs.{amt} का भुगतान दोबारा कोशिश करेंगे। धन्यवाद! | रुकने के लिए STOP लिखें।",
    ("DEFER", "en"): "Hi! No rush at all. We'll gently retry your Rs.{amt} payment around day {day} next month. Thank you! Reply STOP to opt out.",
}

def guard(msg: str):
    """The guard disposes. Returns the message only if safe."""
    if not msg or len(msg) > 320:
        return None
    low = msg.lower()
    if any(w in low for w in FORBIDDEN):
        return None
    if "stop" not in low:
        return None
    return msg

def draft_llm(payload, lang):
    for name, client, model in _get_clients():
        try:
            resp = with_backoff(lambda: client.chat.completions.create(
                model=model, response_format={"type": "json_object"},
                messages=[{"role": "system", "content": SYSTEM},
                          {"role": "user", "content": json.dumps({**payload, "lang": lang})}]))
            msg = json.loads(resp.choices[0].message.content).get("message", "")
            ok = guard(msg)
            if ok:
                return ok, name
        except Exception:
            continue
    return None, None

def generate_message(failure, verdict, lang="en", defer_day=1, link=None):
    payload = {
        "amount_rupees": failure.amount_paise / 100,
        "method": failure.method,
        "failure_code": failure.failure_code,
        "verdict": verdict,
        "defer_day": defer_day,
        "link": link or "https://rzp.io/l/revive-fallback"
    }
    msg, model = draft_llm(payload, lang)
    if msg:
        return {"message": msg, "via": model, "guarded": True}
    return {"message": FALLBACK[(verdict, lang)].format(
                amt=f"{failure.amount_paise/100:,.0f}", day=defer_day,
                link=payload["link"]),
            "via": "template", "guarded": True}