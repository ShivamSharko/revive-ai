import random
import time

def with_backoff(fn, *, max_tries=5, on_throttle=print):
    """Wraps external calls. On 429/rate-limit: exponential backoff + jitter,
    logged loudly. Throttling is a feature, not a failure."""
    delay = 0.5
    for _ in range(max_tries):
        try:
            return fn()
        except Exception as e:
            if getattr(e, "status_code", None) == 429 or "rate" in str(e).lower():
                wait = round(delay + random.uniform(0, delay * 0.3), 2)
                on_throttle(f"Throttled: backing off {wait}s")
                time.sleep(wait)
                delay *= 2
            else:
                raise
    raise RuntimeError("backoff exhausted")