"""Tokenized payment-method references — zero PAN storage.

Recovery flows never touch raw card data. Card-update links carry opaque,
non-reversible tokens instead of account numbers."""
import hashlib
import secrets


def tokenize(method: str, last4: str) -> str:
    seed = f"{method}:{last4}:{secrets.token_hex(4)}"
    return "pm_" + hashlib.sha256(seed.encode()).hexdigest()[:24]


def card_update_link(token: str) -> str:
    return f"https://revive-ai-production-3535.up.railway.app/update/{token}"