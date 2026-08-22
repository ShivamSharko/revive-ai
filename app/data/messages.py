"""Showcase: EN + HI messages for ALLOW & DEFER; BLOCK = silence."""
import json
from pathlib import Path

from app.core.messaging import generate_message
from app.db.database import SessionLocal
from app.db.models import GateDecision, PaymentFailure

def pick(db, rule):
    g = db.query(GateDecision).filter_by(rule_id=rule).first()
    if not g:
        return None
    return db.query(PaymentFailure).filter_by(id=g.failure_id).first()

def main():
    db = SessionLocal()
    try:
        out = {}
        allow = pick(db, "TECH_RETRY")
        defer = pick(db, "LIQUIDITY_DEFER")
        block = pick(db, "OFFLINE_QR_TRAP") or pick(db, "R07_OFFLINE_BLOCK")

        if allow:
            out["ALLOW"] = {"en": generate_message(allow, "ALLOW", "en"),
                            "hi": generate_message(allow, "ALLOW", "hi")}
        if defer:
            out["DEFER"] = {"en": generate_message(defer, "DEFER", "en", defer_day=1),
                            "hi": generate_message(defer, "DEFER", "hi", defer_day=1)}

        for verdict, langs in out.items():
            print(f"\n=== {verdict} ===")
            for lang, r in langs.items():
                print(f"{lang.upper()} [{r['via']}]: {r['message']}")

        if block:
            print("\n=== BLOCK (offline QR) ===")
            print("(no message sent — Consent Gate R-07 protects the customer. Silence is the action.)")
            out["BLOCK"] = {"message": None, "reason": "R-07 offline consent trap"}

        Path("sample_messages.json").write_text(json.dumps(out, ensure_ascii=False, indent=2), encoding="utf-8")
        print("\nSaved: sample_messages.json")
    finally:
        db.close()

if __name__ == "__main__":
    main()