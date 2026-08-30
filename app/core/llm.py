"""Lightweight LLM wrapper with Groq → Gemini failover."""
import os


def _messages(system_prompt, user_message, history):
    msgs = [{"role": "system", "content": system_prompt}]
    for h in (history or [])[-8:]:
        if h.get("role") in ("user", "assistant") and h.get("content"):
            msgs.append({"role": h["role"], "content": str(h["content"])[:500]})
    msgs.append({"role": "user", "content": user_message})
    return msgs


def generate_text(system_prompt: str, user_message: str, max_tokens: int = 150, history=None):
    msgs = _messages(system_prompt, user_message, history)

    # 1) Groq (OpenAI-compatible) — try each model
    try:
        from openai import OpenAI
        client = OpenAI(api_key=os.getenv("GROQ_API_KEY"),
                        base_url="https://api.groq.com/openai/v1")
        for model in ("openai/gpt-oss-120b", "llama-3.1-8b-instant", "llama3-8b-8192"):
            try:
                r = client.chat.completions.create(
                    model=model, messages=msgs,
                    max_tokens=max_tokens, temperature=0.7)
                out = (r.choices[0].message.content or "").strip()
                if out:
                    return out
            except Exception:
                continue
    except Exception:
        pass

    # 2) Gemini failover — when Groq quota is exhausted
    try:
        import google.generativeai as genai
        key = os.getenv("GEMINI_API_KEY") or os.getenv("GOOGLE_API_KEY")
        if key:
            genai.configure(api_key=key)
            model = genai.GenerativeModel("gemini-1.5-flash")
            flat = system_prompt + "\n" + "\n".join(
                f"{m['role']}: {m['content']}" for m in msgs[1:])
            r = model.generate_content(flat)
            out = (r.text or "").strip()
            if out:
                return out
    except Exception:
        pass

    return None