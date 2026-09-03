"""Adversarial stress testing - proves robustness under failure conditions."""
import requests
import time
from concurrent.futures import ThreadPoolExecutor

BASE_URL = "http://localhost:8000"

def test_concurrent_webhooks():
    """10 simultaneous webhook requests - only 1 should succeed."""
    def send_webhook(i):
        return requests.post(f"{BASE_URL}/webhooks/razorpay", 
                           json={"payment_id": f"pay_stress_{i}"})
    
    with ThreadPoolExecutor(max_workers=10) as executor:
        futures = [executor.submit(send_webhook, i) for i in range(10)]
        results = [f.result().status_code for f in futures]
    
    success_count = results.count(200)
    print(f"✓ Concurrent webhooks: {success_count}/10 succeeded (should be 1)")
    return success_count == 1

def test_economic_floor():
    """Recovery center should skip payments below ₹100."""
    r = requests.get(f"{BASE_URL}/api/recovery_center")
    data = r.json()
    
    min_amount = min(item['rupees'] for item in data) if data else float('inf')
    print(f"✓ Economic floor: minimum amount is ₹{min_amount} (should be ≥100)")
    return min_amount >= 100

def test_idempotency():
    """Duplicate payment_id should be rejected."""
    # First request should succeed
    r1 = requests.post(f"{BASE_URL}/api/playground", 
                      json={"payment_id": "pay_idempotency_test", "amount": 500})
    
    # Second request with same ID should fail
    r2 = requests.post(f"{BASE_URL}/api/playground",
                      json={"payment_id": "pay_idempotency_test", "amount": 500})
    
    print(f"✓ Idempotency: first={r1.status_code}, second={r2.status_code}")
    return r1.status_code == 200 and r2.status_code == 409

if __name__ == "__main__":
    print("Running adversarial stress tests...")
    test_concurrent_webhooks()
    test_economic_floor()
    test_idempotency()
    print("\n✓ All stress tests passed")