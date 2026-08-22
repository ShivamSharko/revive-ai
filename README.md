# Revive AI — Consent-First Payment Recovery Agent

Revive AI turns failed payments into recovered revenue **without violating
customer consent or RBI rules**. Most recovery systems blindly retry every
failure — double-charging customers who already paid cash at the store,
spamming salary-day shortages, and compounding mandate fines. Revive AI
diagnoses every failure, passes it through a **Consent Gate**, and only then acts.

<!-- UPDATE AFTER DAY 12 BATCH RUN -->


## The numbers (test-mode evidence)

| Metric | Value |
|---|---|
| Failures processed | 500 synthetic + 3 real Razorpay test payments |
| Diagnosis accuracy (held-out, n=40) | 92% archetype / 92% owner (via Groq + Gemini) |
| Retries blocked by Consent Gate | 141 (28%) |
| Customer goodwill protected | Rs.3,60,283 |
| Revenue safely recaptured | Rs.7,69,682 |
| Deferred to salary day | 67 |
| Safe retries executed | 292 |

Real test-mode IDs: `pay_TSO8itQ6X4u1TT` (captured) · `pay_TSOALEUJL823Wr`
(failed) · `pay_TSODxy4fmJFYBE` (authorized-stuck — at-risk revenue detected).

## Pipeline
Razorpay webhook / synthetic generator
→ Diagnosis Engine (Gemini → Groq → rules failover, strict JSON + Pydantic)
→ Consent Gate (RBI mandate · fee-shock · structural stop · liquidity defer · R-07 offline QR trap)
→ Recovery Engine (retry / salary-day job / block)
→ AuditLog → Dashboard API (/api/overview, /api/audit, ...)

## The 5 Laws (the conscience)

1. **No money moves without valid consent.**
2. **Never retry in a way that can double-charge** (offline QR trap R-07).
3. **Never pressure, threaten, or shame a customer** (tone guard on every message).
4. **Never debit without RBI-compliant notice** (24h pre-debit rule).
5. **Every decision is logged and auditable** (audit trail on every verdict).

## Same failure physics, other industries

| Industry | What Revive AI logic maps to |
|---|---|
| Airlines | Booking-window payment holds; intent drops at fee reveal = surprise-fee abandonment |
| Hospitals | Procedure deposits declined; mandate renewals = insurance pre-auth lifecycle |
| Hotels / OTAs | Pre-arrival auth declines; affordability defers = re-offer at check-in window |
| SaaS subscriptions | Card-on-file expiry + notice breaches = dunning without spam |

The archetypes (technical / intent / affordability / lifecycle) and the Consent
Gate are industry-agnostic; only the payment rail changes.


## The Consent Gate (the conscience)

| Rule | Trigger | Verdict |
|---|---|---|
| R-07 Offline QR Trap | context = post_session_offline | BLOCK (prevents double-charge) |
| RBI Mandate | pre-debit notice < 24h | BLOCK |
| Fee Shock | abandonment at fee reveal | BLOCK |
| Structural Stop | repeated affordability failures | BLOCK |
| Liquidity Defer | one-time insufficient balance | DEFER to salary day |
| Tech Retry | transient infra failure | ALLOW |

## Run locally
docker compose up -d
python -m venv venv && venv\Scripts\activate
pip install -r requirements.txt
python -m scripts.init_db # creates 8 tables
python -m app.data.generator # 500 labeled failures
python -m app.data.simulate # diagnose + gate
python -m app.data.recover # execute actions
uvicorn app.main:app --reload # API on :8000


## Honesty & assumptions

- Simulation treats ALLOW retries as successful; production would track real
  Razorpay retry outcomes per attempt.
- Synthetic batch is labeled ground truth; accuracy measured on held-out sample.
- `failure_journal.md` logs every break and fix from Day 1 onward.