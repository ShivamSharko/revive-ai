"""Held-out eval: 40 stratified samples, batched diagnosis, honest accuracy report."""
import random
from collections import defaultdict

from app.core.diagnosis import diagnose_batch
from app.db.database import SessionLocal
from app.db.models import PaymentFailure

random.seed(7)

def main():
    db = SessionLocal()
    try:
        rows = db.query(PaymentFailure).filter_by(source="synthetic").all()
        by_arch = defaultdict(list)
        for r in rows:
            by_arch[r.true_archetype].append(r)
        sample = [r for lst in by_arch.values() for r in random.sample(lst, 10)]
        random.shuffle(sample)

        ok_a = ok_o = 0
        for i in range(0, len(sample), 10):
            batch = sample[i:i + 10]
            for f, (d, model) in zip(batch, diagnose_batch(batch)):
                a_ok = d.archetype == f.true_archetype
                o_ok = d.owner == f.true_owner
                ok_a += a_ok
                ok_o += o_ok
                tag = "OK" if a_ok and o_ok else "MISS"
                print(f"{f.external_payment_id} true={f.true_archetype}/{f.true_owner} "
                      f"got={d.archetype}/{d.owner} via={model} {tag}")

        n = len(sample)
        print(f"\nHELD-OUT EVAL n={n} | archetype acc={ok_a/n:.0%} | owner acc={ok_o/n:.0%}")
    finally:
        db.close()

if __name__ == "__main__":
    main()