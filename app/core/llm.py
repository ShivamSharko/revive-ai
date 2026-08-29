"""Lightweight LLM wrapper for conversational replies."""
import os


def generate_text(system_prompt: str, user_message: str, max_tokens: int = 150):
    try:
        from openai import OpenAI
        client = OpenAI(api_key=os.getenv("GROQ_API_KEY"),
                        base_url="https://api.groq.com/openai/v1")
        for model in ("openai/gpt-oss-120b", "llama-3.1-8b-instant", "llama3-8b-8192"):
            try:
                r = client.chat.completions.create(
                    model=model,
                    messages=[{"role": "system", "content": system_prompt},
                              {"role": "user", "content": user_message}],
                    max_tokens=max_tokens, temperature=0.7)
                return r.choices[0].message.content.strip()
            except Exception:
                continue
        return None
    except Exception:
        return None