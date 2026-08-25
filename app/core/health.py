"""Health Graph — Redis-backed (as planned), in-memory fallback (graceful failure)."""
import os
from collections import defaultdict

_redis = None
try:
    import redis as _r
    _redis = _r.from_url(os.environ.get("REDIS_URL", "redis://localhost:6379/0"),
                         socket_connect_timeout=1)
    _redis.ping()
except Exception:
    _redis = None

_mem = defaultdict(lambda: {"success": 0, "fail": 0})

def backend() -> str:
    return "redis" if _redis else "memory"

def record_attempt(bank_code: str, success: bool):
    if _redis:
        _redis.hincrby(f"health:{bank_code}", "success" if success else "fail", 1)
    else:
        _mem[bank_code]["success" if success else "fail"] += 1

def _stats(bank_code: str):
    if _redis:
        raw = _redis.hgetall(f"health:{bank_code}")
        return {"success": int(raw.get(b"success", 0)), "fail": int(raw.get(b"fail", 0))}
    return _mem[bank_code]

def get_success_rate(bank_code: str) -> float:
    s = _stats(bank_code)
    total = s["success"] + s["fail"]
    return 0.95 if total < 5 else s["success"] / total

def is_degraded(bank_code: str, threshold: float = 0.6) -> bool:
    return get_success_rate(bank_code) < threshold

def simulate_degradation(bank_code: str):
    if _redis:
        _redis.hset(f"health:{bank_code}", mapping={"success": 1, "fail": 15})
    else:
        _mem[bank_code] = {"success": 1, "fail": 15}