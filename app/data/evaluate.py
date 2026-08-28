"""Held-out eval: 40 stratified samples. Reads directly from the pure-LLM DB state."""
import random
random.seed(42)
import random
from collections import defaultdict

from app.db.database import SessionLocal
from app.db.models import PaymentFailure, Diagnosis

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

        # Read pure-LLM diagnoses directly from DB (0 API calls, instant execution)
        sample_ids = [f.id for f in sample]
        diags = {d.failure_id: d for d in db.query(Diagnosis).filter(Diagnosis.failure_id.in_(sample_ids)).all()}

        ok_a = ok_o = 0
        for f in sample:
            d = diags.get(f.id)
            if not d:
                print(f"WARNING: No diagnosis for {f.external_payment_id}")
                continue
            a_ok = d.archetype == f.true_archetype
            o_ok = d.owner == f.true_owner
            ok_a += a_ok
            ok_o += o_ok
            tag = "OK" if a_ok and o_ok else "MISS"
            print(f"{f.external_payment_id} true={f.true_archetype}/{f.true_owner} "
                  f"got={d.archetype}/{d.owner} via={d.model_used} {tag}")

        n = len(sample)
        print(f"\nHELD-OUT EVAL n={n} | archetype acc={ok_a/n:.0%} | owner acc={ok_o/n:.0%}")
    finally:
        db.close()

if __name__ == "__main__":
    main()