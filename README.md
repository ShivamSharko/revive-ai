# Revive AI — Consent-First Payment Recovery Agent

> *"140 million payments fail in India every month. Most recovery systems are just spam engines. We studied airlines, hospitals, and logistics to build a recovery system based on dignity, operational design, and strict consent."*

---

## The Problem (2026 Reality)

India's digital payments infrastructure is the world's most advanced, which means its failure problem is the world's largest:

| Metric | 2026 Value | Source |
|---|---|---|
| Monthly UPI Transactions | **23.6 Billion** (July 2026) | NPCI |
| Annual Digital Transactions | **24,162 Crore** (FY 2025-26) | PIB |
| UPI Failure Rate | **~0.3%** = **54 Crore failures/year** | Industry Estimates |
| Failed Transactions per Day | **~1.5 Crore** | VyaparGateway |
| Global Revenue Leakage | **$47 Billion/year** (1 in 5 e-commerce orders) | Optimus |
| RBI E-Mandate Framework | **April 2026 update**: Mandatory 24h pre-debit alerts | RBI |

Blindly retrying these failures double-charges customers, spams them during salary-day shortages, and compounds RBI mandate fines. **Revive AI** diagnoses every failure, passes it through a deterministic **Consent Gate**, and only then acts.

---

## 🌐 Live Demo (Internet-Deployed)

| Endpoint | URL |
|---|---|
| 🖥️ **Command Center** | [Streamlit Dashboard](https://revive-ai-shxvy4uyvqydxucqxbqyin.streamlit.app) |
| 📊 **Live API Data** | [Railway `/api/overview`](https://revive-ai-production-3535.up.railway.app/api/overview) |
| 📜 **Full Audit Trail** | [Railway `/api/audit`](https://revive-ai-production-3535.up.railway.app/api/audit) |
| 💓 **Health Check** | [Railway `/health`](https://revive-ai-production-3535.up.railway.app/health) |
| 🎙️ **Hinglish Voice** | [`voice_technical.mp3`](voice_technical.mp3) (ElevenLabs Multilingual TTS) |

---

## 📈 The Numbers (Verified — Latest 500-Batch Run)

| Metric | Value |
|---|---|
| Failures processed | 500 synthetic + 3 real Razorpay test payments |
| Diagnosis accuracy | **90% archetype / 92% owner** (Groq GPT-OSS + Gemini failover, held-out n=40) |
| Pure LLM coverage | **500/500** (0 rule fallback) |
| Gate ALLOW (safe retry) | **278** |
| Gate DEFER (salary-day EV) | **64** |
| Gate BLOCK (protect) | **158** |
| Revenue safely recaptured | **₹7,66,852** |
| Customer goodwill protected | **₹5,66,624** (BLOCK ₹4,03,092 + DEFER ₹1,63,532) |
| Per-archetype recovered | Technical ₹3,83,698 · Intent ₹2,47,560 · Lifecycle ₹95,811 |

**Real test-mode IDs:** `pay_TSO8itQ6X4u1TT` (captured) · `pay_TSOALEUJL823Wr` (failed) · `pay_TSODxy4fmJFYBE` (authorized-stuck).

---

## 🏛️ Cross-Industry Inspiration (The Secret Sauce)

We didn't study other payment gateways. We studied industries that mastered high-stakes value recovery.

| Industry | Their Proven Protocol | How Revive AI Steals It |
|---|---|---|
| **✈️ Airlines** | Expected Value (EV) & Predictive Rebooking | **EV Optimizer**: `(Probability × Amount) − Cost of Attempt` |
| **🏥 Hospitals** | "Watchful Waiting" (Triage) | **Affordability Triage**: Defer to salary day (Liquidity Curves) |
| **🏨 Hotels** | The "Walk" Protocol (Overbooking) | **Graceful Exit**: Pause subscription, no late fees for structural churn |
| **📦 Logistics** | Alternate Mechanism (Lockers/Neighbors) | **Mechanism Swap**: OTP fails → swap to UPI Collect Request |

---

## ⚖️ The 5 Laws (The Conscience)

Every line of code in this repo passes through these 5 laws. If it violates a law, we cut it.

1. **No money moves without valid consent.** (Protects against the Offline QR Trap)
2. **Never retry in a way that can double-charge.**
3. **Never pressure, threaten, or shame a customer.** (Tone guard on every message)
4. **Never debit without RBI-compliant notice.** (24-hour pre-debit rule)
5. **Every decision is logged and auditable.**

---

## 🧱 Architecture & The Consent Gate

```text
Razorpay Webhook / Orders API / Synthetic Generator
     │
     ▼
[Ingestion] ──→ FastAPI BackgroundTasks (Async Queue)
     │
     ▼
[Diagnosis Engine] ──→ Groq GPT-OSS + Gemini Failover + Pydantic Validation
     │
     ▼
[Consent Gate] ──→ Deterministic Rules (R-01 to R-07)
     │
     ├─→ ALLOW  → Recovery Engine (EV Optimizer + Health Graph + Mechanism Swap)
     ├─→ DEFER  → Jobs Table (Liquidity Curves → Modal Salary Day)
     └─→ BLOCK  → Audit Log (Double-charge prevented)
```

### The 7 Rules of the Consent Gate

| Rule | Trigger | Verdict |
|---|---|---|
| **R-01** RBI Mandate | Pre-debit notice < 24 hours | BLOCK |
| **R-02** Fee Shock | Abandonment at fee reveal | BLOCK (sends merchant insight instead) |
| **R-03** Structural Stop | 4+ consecutive affordability failures | BLOCK (Graceful Exit) |
| **R-04** Liquidity Defer | One-time insufficient balance | DEFER to salary day |
| **R-05** Tech Retry | Transient infra failure | ALLOW (silent retry) |
| **R-06** Default Allow | Safe retry path | ALLOW |
| **R-07** Offline QR Trap ⭐ | `context=post_session_offline` | BLOCK (prevents double-charge) |

*R-07 is the demo star: it fires BEFORE the generic "technical → ALLOW" rule, blocking silent retries for customers who scanned a QR, got impatient, and paid cash.*

---

## 🎯 Track 03 Coverage (Zero Scope Cut)

Every example direction in the Razorpay Buildathon problem statement is implemented:

| Example Direction | Implementation |
|---|---|
| Payment degradation + root cause | `diagnosis.py` + `health.py` (Redis) + `ev_optimizer.py` |
| Checkout drop-off recovery | Mechanism Swap + `dropoff_funnel.py` + `poll_orders.py` |
| Failed subscription recovery | `/webhooks/razorpay/subscriptions` + mandate gate |
| B2B receivables recovery | `receivables.py`: dispute halt + payment-plan splitting |
| Mandate expiry assurance | `audit.py` (RBI 24h pre-debit) + R-01 |
| Hinglish voice recovery | `voice.py`: ElevenLabs → edge-tts → text fallback |
| Drop-to-pay flow tracker | `dropoff_funnel.py` |
| Promise-to-pay tracker | `promise.py`: customer commits to date, auto-retry or human escalate |

---

## 🛠️ Run Locally

```bash
docker compose up -d                          # Postgres + Redis
python -m venv venv && venv\Scripts\activate
pip install -r requirements.txt

# Database & Data
python -m scripts.wipe_and_init               # 9 tables
python -m app.data.generator                  # 500 labeled failures

# The Pipeline
python -m app.data.simulate                   # diagnose + gate
python -m app.data.recover                    # execute actions

# The API & UI
uvicorn app.main:app --reload                 # API on :8000
streamlit run app/dashboard.py                # Dashboard on :8501
```

### Demo Scripts
```bash
python -m scripts.verify_numbers              # Print all verified metrics
python -m scripts.wipe_and_init               # Nuclear reset: drop & recreate all tables
python -m scripts.simulate_promise            # Flow: Promise-to-Pay tracker
python -m app.data.evaluate                   # Held-out accuracy check
python -m scripts.send_test_webhook           # HMAC-verified real webhook
python -m scripts.simulate_dropoffs           # Flow B: merchant insights
python -m scripts.simulate_b2b                # Flow D: B2B dispute halt + plans
python -m scripts.voice_demo                  # Hinglish TTS (ElevenLabs)
python -m scripts.generate_money_slide        # Dynamic per-archetype money slide
```

---

## 🙏 Honesty & Assumptions

- Simulation treats ALLOW retries as successful; production would track real Razorpay retry outcomes per attempt.
- Synthetic batch is labeled ground truth; accuracy measured on held-out sample (n=40).
- `failure_journal.md` logs every break, fix, and "aha" moment from Entry 1 onward.

**Revive AI. Never remind. Resolve. No money moves without consent.**