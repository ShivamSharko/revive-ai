"""Diagnosis engine: Groq -> Gemini -> deterministic rules. Strict JSON + Pydantic."""
import json
import time
from typing import Literal

from openai import OpenAI, RateLimitError
from pydantic import BaseModel, Field, ValidationError

from app.config import settings


class DiagnosisOut(BaseModel):
    archetype: Literal["technical", "intent", "affordability", "lifecycle"]
    owner: Literal["infra", "merchant", "customer_temp", "customer_structural"]
    confidence: float = Field(ge=0, le=1)
    reasoning: str


def _get_clients():
    clients = []
    if settings.GROQ_API_KEY:
        clients.append(("groq", OpenAI(api_key=settings.GROQ_API_KEY,
            base_url="https://api.groq.com/openai/v1"),
            "openai/gpt-oss-120b"))
    if settings.GEMINI_API_KEY:
        clients.append(("gemini", OpenAI(api_key=settings.GEMINI_API_KEY,
            base_url="https://generativelanguage.googleapis.com/v1beta/openai/"),
            "gemini-3.6-flash"))
    return clients


SYSTEM = """You are Revive AI's payment-failure diagnostician.
Classify EACH failure by archetype and owner.
archetype must be exactly one of: technical | intent | affordability | lifecycle
owner must be exactly one of: infra | merchant | customer_temp | customer_structural
Guidance:
- bank/PSP/gateway error or timeout => technical/infra
- merchant config, fee shock, late mandate notification => owner merchant
- dropped at OTP, no other signal => intent/customer_temp
- insufficient balance once => affordability/customer_temp
- repeated insufficient balance => affordability/customer_structural
- expired card => lifecycle/customer_temp
- pre-debit notification <24h => lifecycle/merchant
Output ONLY JSON in this exact shape, one entry per input, same order:
{"diagnoses":[{"archetype":"technical","owner":"infra","confidence":0.9,"reasoning":"bank timeout"}]}"""

RULE_MAP = {
    "UPI_BANK_TIMEOUT": ("technical", "infra"),
    "GATEWAY_5XX": ("technical", "infra"),
    "OFFLINE_QR_TIMEOUT": ("technical", "infra"),
    "CHECKOUT_CONFIG_ERROR": ("technical", "merchant"),
    "ABANDONED_AT_FEES": ("intent", "merchant"),
    "ABANDONED_AT_OTP": ("intent", "customer_temp"),
    "INSUFFICIENT_BALANCE": ("affordability", "customer_temp"),
    "REPEATED_INSUFFICIENT_BALANCE": ("affordability", "customer_structural"),
    "MANDATE_NOTIFICATION_BREACH": ("lifecycle", "merchant"),
    "CARD_EXPIRED": ("lifecycle", "customer_temp"),
}

ARCHS = ["technical", "intent", "affordability", "lifecycle"]
OWNERS = ["infra", "merchant", "customer_temp", "customer_structural"]


def rule_fallback(f):
    a, o = RULE_MAP.get(f.failure_code, ("technical", "infra"))
    return DiagnosisOut(archetype=a, owner=o, confidence=0.6,
                        reasoning=f"rule fallback from {f.failure_code}")


def _payload(f):
    return {"id": f.external_payment_id, "code": f.failure_code,
            "desc": f.failure_description, "method": f.method,
            "context": f.context, "dropped_step": f.dropped_step}


def _validate(item):
    """Repair or reject a single diagnosis dict. Never crash."""
    if not isinstance(item, dict):
        raise ValidationError("Not a dict")
    try:
        return DiagnosisOut.model_validate(item)
    except ValidationError:
        arch = str(item.get("archetype") or "").lower()
        owner = str(item.get("owner") or "").lower()
        a = next((x for x in ARCHS if x == arch or x in arch), None)
        o = next((x for x in OWNERS if x == owner or x in owner), None)
        if not a or not o:
            raise
        try:
            conf = min(max(float(item.get("confidence", 0.7)), 0.0), 1.0)
        except (TypeError, ValueError):
            conf = 0.7
        return DiagnosisOut(archetype=a, owner=o, confidence=conf,
                            reasoning=str(item.get("reasoning") or "repaired from model output"))


def llm_batch(failures, client, model):
    resp = client.chat.completions.create(
        model=model,
        response_format={"type": "json_object"},
        messages=[
            {"role": "system", "content": SYSTEM},
            {"role": "user", "content": json.dumps([_payload(f) for f in failures])}
        ]
    )
    data = json.loads(resp.choices[0].message.content)
    items = data.get("diagnoses", []) if isinstance(data, dict) else data
    return [_validate(x) for x in items]


def diagnose_batch(failures, chunk_size=10):
    """Quota-aware failover: cool down on 429, never storm; resumable callers
    upgrade any 'rules' rows on the next run."""
    all_results = []
    chunks = [failures[i:i + chunk_size] for i in range(0, len(failures), chunk_size)]
    for ci, chunk in enumerate(chunks):
        chunk_results = None
        for name, client, model in _get_clients():
            for attempt in range(2):
                try:
                    outs = llm_batch(chunk, client, model)
                    if len(outs) == len(chunk):
                        chunk_results = [(o, name) for o in outs]
                    break
                except RateLimitError:
                    print(f"[diagnosis] {name} rate-limited; cooling 45s")
                    time.sleep(45)
                except Exception as e:
                    print(f"[diagnosis] {name} failed ({type(e).__name__}) -> next provider")
                    break
            if chunk_results:
                break
        if chunk_results is None:
            chunk_results = [(rule_fallback(f), "rules") for f in chunk]
            print(f"chunk {ci+1}/{len(chunks)} -> rules (upgrades next run)")
        else:
            print(f"chunk {ci+1}/{len(chunks)} ok via {chunk_results[0][1]}")
        all_results.extend(chunk_results)
        time.sleep(10)
    return all_results