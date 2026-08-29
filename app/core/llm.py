"""Lightweight LLM wrapper for conversational replies."""
import os


def generate_text(system_prompt: str, user_message: str, max_tokens: int = 150, history=None):
    messages = [{"role": "system", "content": system_prompt}]
    for h in (history or [])[-8:]:
        if h.get("role") in ("user", "assistant") and h.get("content"):
            messages.append({"role": h["role"], "content": str(h["content"])[:500]})
    messages.append({"role": "user", "content": user_message})
    try:
        from openai import OpenAI
        client = OpenAI(api_key=os.getenv("GROQ_API_KEY"),
                        base_url="https://api.groq.com/openai/v1")
        for model in ("openai/gpt-oss-120b", "llama-3.1-8b-instant", "llama3-8b-8192"):
            try:
                r = client.chat.completions.create(
                    model=model, messages=messages,
                    max_tokens=max_tokens, temperature=0.7)
                return r.choices[0].message.content.strip()
            except Exception:
                continue
        return None
    except Exception:
        return None