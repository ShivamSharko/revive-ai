"""Adversarial reasoning: Devil's Advocate challenges every gate decision."""
from app.core.llm import generate_text

def challenge_decision(archetype: str, verdict: str, rule_id: str, reasoning: str, rupees: float) -> dict:
    """Generate a counter-argument to the gate's decision."""
    system = (
        "You are a skeptical risk officer reviewing a payment recovery decision. "
        "Your job is to find flaws in the reasoning and argue AGAINST the decision. "
        "Be specific: cite regulatory risks, customer harm, technical edge cases, or logical gaps. "
        "Rate your confidence: HIGH (critical flaw) / MED (concern) / LOW (minor nitpick). "
        "Answer in MAXIMUM 2 sentences (under 50 words), plain text, no markdown, no lists. "
        "Format: 'COUNTER: [your argument] | CONFIDENCE: [HIGH/MED/LOW]'"
    )
    
    prompt = (
        f"Payment: ₹{rupees}\n"
        f"Archetype: {archetype}\n"
        f"Gate Decision: {verdict} via {rule_id}\n"
        f"Reasoning: {reasoning}\n\n"
        "Challenge this decision. What could go wrong?"
    )
    
    try:
        response = generate_text(system, prompt, max_tokens=150)
        if not response:
            return {"counter": None, "confidence": "LOW", "escalate": False}
        
        # Parse confidence from response
        if "CONFIDENCE: HIGH" in response:
            confidence = "HIGH"
            escalate = True
        elif "CONFIDENCE: MED" in response:
            confidence = "MED"
            escalate = False
        else:
            confidence = "LOW"
            escalate = False
        
        # Extract counter-argument (short + clean)
        counter = response.split("|")[0].replace("COUNTER:", "").replace("**", "").strip()
        if len(counter) > 220:
            counter = counter[:220].rsplit(" ", 1)[0] + "…"
        
        return {
            "counter": counter,
            "confidence": confidence,
            "escalate": escalate
        }
    except Exception as e:
        return {"counter": None, "confidence": "LOW", "escalate": False, "error": str(e)}