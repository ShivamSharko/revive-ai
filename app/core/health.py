"""In-memory Health Graph. Tracks bank success rates to route away from degraded banks."""
from collections import defaultdict

_bank_stats = defaultdict(lambda: {"success": 0, "fail": 0})

def record_attempt(bank_code: str, success: bool):
    _bank_stats[bank_code]["success" if success else "fail"] += 1

def get_success_rate(bank_code: str) -> float:
    stats = _bank_stats[bank_code]
    total = stats["success"] + stats["fail"]
    if total < 5: return 0.95  # Assume healthy until proven otherwise
    return stats["success"] / total

def is_degraded(bank_code: str, threshold: float = 0.6) -> bool:
    return get_success_rate(bank_code) < threshold

def simulate_degradation(bank_code: str):
    """Demo tool: force a bank to look degraded for the video."""
    _bank_stats[bank_code] = {"success": 1, "fail": 15}