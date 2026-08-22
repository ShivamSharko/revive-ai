"""Probe LLM providers: test chat + list available models."""
import json

from app.core.diagnosis import _get_clients

payload = [{"id": "pay_probe", "code": "UPI_BANK_TIMEOUT",
            "desc": "UPI request timed out at PSP", "method": "upi",
            "context": "in_session_online", "dropped_step": None}]

for name, client, model in _get_clients():
    try:
        resp = client.chat.completions.create(
            model=model,
            response_format={"type": "json_object"},
            messages=[{"role": "system", "content": "Output ONLY JSON."},
                      {"role": "user", "content": json.dumps(payload)}])
        print(name, "OK ->", resp.choices[0].message.content[:100])
    except Exception as e:
        print(name, "FAILED ->", type(e).__name__, str(e)[:200])
    try:
        print(name, "available:", [m.id for m in client.models.list()][:15])
    except Exception as e:
        print(name, "model list failed:", type(e).__name__)