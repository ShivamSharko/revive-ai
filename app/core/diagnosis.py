"""Diagnosis engine: Gemini -> Groq -> deterministic rules. Strict JSON + Pydantic."""
import json
from typing import Literal

from openai import OpenAI
from pydantic import BaseModel, Field

from app.config import settings
from app.core.resilience import with_backoff


class DiagnosisOut(BaseModel):
    archetype: Literal["technical", "intent", "affordability", "lifecycle"]
    owner: Literal["infra", "merchant", "customer_temp", "customer_structural"]
    confidence: float = Field(ge=0, le=1)
    reasoning: str


def _get_clients():
    """Lazy-initialize clients to avoid crashing on empty API keys."""
    clients = []
    if settings.GEMINI_API_KEY:
        clients.append(("gemini", OpenAI(api_key=settings.GEMINI_API_KEY,
                        base_url="https://generativelanguage.googleapis.com/v1beta/openai/"),
                        "gemini-2.5-flash"))
    if settings.GROQ_API_KEY:
        clients.append(("groq", OpenAI(api_key=settings.GROQ_API_KEY,
                        base_url="https://api.groq.com/openai/v1"),
                        "llama-3.3-70b-versatile"))
    return clients


SYSTEM = """You are Revive AI's payment-failure diagnostician.
Classify EACH failure by archetype and owner.
archetype: technical | intent | affordability | lifecycle
owner: infra | merchant | customer_temp | customer_structural
Guidance:
- bank/PSP/gateway error or timeout => technical/infra
- merchant config, fee shock, late mandate notification => owner merchant
- dropped at OTP, no other signal => intent/customer_temp
- insufficient balance once => affordability/customer_temp
- repeated insufficient balance => affordability/customer_structural
- expired card => lifecycle/customer_temp
- pre-debit notification <24h => lifecycle/merchant
Output ONLY JSON: {"diagnoses":[{...},{...}]} in the same order as input."""

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

def rule_fallback(f):
    a, o = RULE_MAP.get(f.failure_code, ("technical", "infra"))
    return DiagnosisOut(archetype=a, owner=o, confidence=0.6,
                        reasoning=f"rule fallback from {f.failure_code}")

def _payload(f):
    return {"id": f.external_payment_id, "code": f.failure_code,
            "desc": f.failure_description, "method": f.method,
            "context": f.context, "dropped_step": f.dropped_step}

def llm_batch(failures, client, model):
    resp = with_backoff(lambda: client.chat.completions.create(
        model=model,
        response_format={"type": "json_object"},
        messages=[{"role": "system", "content": SYSTEM},
                  {"role": "user", "content": json.dumps([_payload(f) for f in failures])}]))
    data = json.loads(resp.choices[0].message.content)
    items = data.get("diagnoses", data if isinstance(data, list) else [])
    return [DiagnosisOut.model_validate(x) for x in items]

def diagnose_batch(failures, chunk_size=10):
    """Returns [(DiagnosisOut, model_used)] with graceful provider failover and internal chunking."""
    all_results = []
    for i in range(0, len(failures), chunk_size):
        chunk = failures[i:i + chunk_size]
        chunk_results = None
        
        # Try each provider for this specific chunk
        for name, client, model in _get_clients():
            try:
                outs = llm_batch(chunk, client, model)
                if len(outs) == len(chunk):
                    chunk_results = [(o, name) for o in outs]
                    break
            except Exception as e:
                print(f"[diagnosis] {name} failed on chunk {i//chunk_size} ({type(e).__name__}) -> next provider")
        
        # If all LLMs failed for this chunk, use rules
        if chunk_results is None:
            chunk_results = [(rule_fallback(f), "rules") for f in chunk]
            
        all_results.extend(chunk_results)
        
    return all_results