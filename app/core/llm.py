"""Lightweight LLM wrapper with Groq → Gemini failover (live 2026 model names)."""
import os

GROQ_MODELS = ("llama-3.1-8b-instant", "llama-3.3-70b-versatile", "openai/gpt-oss-120b")
GEMINI_MODELS = ("gemini-3.5-flash-lite", "gemini-3.7-flash")


def _messages(system_prompt, user_message, history):
    msgs = [{"role": "system", "content": system_prompt}]
    for h in (history or [])[-8:]:
        if h.get("role") in ("user", "assistant") and h.get("content"):
            msgs.append({"role": h["role"], "content": str(h["content"])[:500]})
    msgs.append({"role": "user", "content": user_message})
    return msgs


def generate_text(system_prompt: str, user_message: str, max_tokens: int = 220, history=None):
    msgs = _messages(system_prompt, user_message, history)

    # 1) Groq — fast non-reasoning models first; reasoning model gets a big budget
    try:
        from openai import OpenAI
        client = OpenAI(api_key=os.getenv("GROQ_API_KEY"),
                        base_url="https://api.groq.com/openai/v1")
        for model in GROQ_MODELS:
            try:
                budget = 1024 if model.startswith("openai/") else max_tokens
                r = client.chat.completions.create(
                    model=model, messages=msgs,
                    max_tokens=budget, temperature=0.7)
                out = (r.choices[0].message.content or "").strip()
                if len(out) >= 12:   # reject truncated garbage, try next model
                    return out
            except Exception:
                continue
    except Exception:
        pass

    # 2) Gemini failover — new SDK first, legacy SDK second
    try:
        key = os.getenv("GEMINI_API_KEY") or os.getenv("GOOGLE_API_KEY")
        if key:
            flat = system_prompt + "\n" + "\n".join(
                f"{m['role']}: {m['content']}" for m in msgs[1:])
            try:
                from google import genai
                client = genai.Client(api_key=key)
                for model in GEMINI_MODELS:
                    try:
                        out = (client.models.generate_content(model=model, contents=flat).text or "").strip()
                        if len(out) >= 12:
                            return out
                    except Exception:
                        continue
            except ImportError:
                pass
            try:
                import google.generativeai as legacy
                legacy.configure(api_key=key)
                for model in GEMINI_MODELS:
                    try:
                        out = (legacy.GenerativeModel(model).generate_content(flat).text or "").strip()
                        if len(out) >= 12:
                            return out
                    except Exception:
                        continue
            except Exception:
                pass
    except Exception:
        pass

    return None