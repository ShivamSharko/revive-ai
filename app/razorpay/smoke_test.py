import json
from pathlib import Path
from app.razorpay.client import get_client

def main():
    rz = get_client()

    order = rz.order.create({"amount": 49900, "currency": "INR", "receipt": "revive_smoke_001"})
    print("ORDER  :", order["id"])

    link = rz.payment_link.create({
        "amount": 49900, "currency": "INR",
        "description": "Revive AI smoke test",
    })
    print("PLINK  :", link["id"])
    print("PAY AT :", link["short_url"])

    for p in rz.payment.all({"count": 10})["items"]:
        print(f"PAY    : {p['id']}  {p['status']:>9}  Rs.{p['amount']/100:.2f}  {p.get('method')}")

    Path("real_pay_ids.json").write_text(json.dumps(
        [{"id": p["id"], "status": p["status"], "amount_paise": p["amount"]}
         for p in rz.payment.all({"count": 20})["items"]], indent=2))
    print("Saved  : real_pay_ids.json")

if __name__ == "__main__":
    main()