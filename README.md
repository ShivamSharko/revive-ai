# Revive AI — Consent-First Payment Recovery Agent

> *"140 million payments fail in India every month. Most recovery systems are spam engines. We studied airlines, hospitals, and logistics to build a recovery system based on dignity, operational design, and strict consent."*

---

## The Problem (2026 Reality)

| Metric | 2026 Value | Source |
|---|---|---|
| Monthly UPI transactions | **23.6 billion** (July 2026) | NPCI |
| Annual digital transactions | **24,162 crore** (FY 2025-26) | PIB |
| Conservative failure rate | **0.3%** = **54 crore failures/year** (~1.5 crore/day) | Industry estimates |
| Global revenue leakage | **$47B/year** — 1 in 5 e-commerce orders affected | Optimus |
| RBI Digital Payments E-Mandate Framework | **21 April 2026** — mandatory 24h pre-debit alerts; no AFA up to ₹15,000 | RBI |

Blindly retrying these failures double-charges customers who already paid cash, spams salary-day shortages, and compounds mandate fines. **Revive AI diagnoses every failure, passes it through a deterministic Consent Gate, and only then acts.**

---

## 🌐 Live Demo (Internet-Deployed)

| Endpoint | URL |
|---|---|
| 🖥️ **Command Center** | [Streamlit Dashboard](https://revive-ai-shxvy4uyvqydxucqxbqyin.streamlit.app) |
| 📊 **Live API Overview** | [revive-ai-production-3535.up.railway.app/api/overview](https://revive-ai-production-3535.up.railway.app/api/overview) |
| 📜 **Full Audit Trail** | [revive-ai-production-3535.up.railway.app/api/audit](https://revive-ai-production-3535.up.railway.app/api/audit) |
| 💓 **Health Check** | [revive-ai-production-3535.up.railway.app/health](https://revive-ai-production-3535.up.railway.app/health) |
| 🎙️ **Hinglish Voice Sample** | [`voice_technical.mp3`](voice_technical.mp3) — ElevenLabs multilingual TTS |

---

## 📈 The Numbers (Fresh 500-Batch, Test-Mode Evidence)

| Metric | Value |
|---|---|
| Failures processed | 513 (500 synthetic + live test payments) |
| Diagnosis accuracy (held-out, n=40, seeded) | **98% archetype / 95% owner** |
| Retries blocked by Consent Gate | **165 (32%)** |
| Safe retries executed (ALLOW) | **277** |
| Deferred to salary day (DEFER) | **58** |
| Revenue safely recaptured | **₹7,21,681** (incl. 1 real Razorpay test payment) |
| Customer goodwill protected | **₹5,72,511** (₹4,29,877 blocked + ₹1,42,634 deferred) |

### The Money Slide (generated live by `scripts/generate_money_slide.py`)

```text
513 failures (₹13,00,180 At Risk)
├── Technical:     ₹3,75,412 recovered (silent retries, invisible recovery)
├── Intent:        ₹2,50,458 recovered (mechanism swaps & nudges)
├── Affordability: ₹0 now · ₹1,42,634 scheduled (Deferred EV to salary day)
├── Lifecycle:     ₹95,811 recovered (card updates) · ₹1,37,251 protected (mandate compliance)
└── In-flight:     ₹5,988 promised / live-test / human escalation

Total: ₹7,21,681 recovered · ₹4,29,877 protected · ₹1,42,634 deferred
Plus:  ₹5,988 in-flight / promised / escalated

"Customer-structural recovery = Rs.0. That's intentional. (Hotel 'Walk' Protocol)"
```

**Real test-mode IDs:** `pay_TSO8itQ6X4u1TT` (captured) · `pay_TSOALEUJL823Wr` (failed, replayable via `send_test_webhook`) · `pay_TSODxy4fmJFYBE` (authorized-stuck).

---

## ⚖️ The 5 Laws (The Conscience)

1. **No money moves without valid consent.** (Protects against the Offline QR trap)
2. **Never remind. Resolve.** (A message must encode the diagnosis. "Bank was down, it's fixed now" &gt; "Your cart is saved!")
3. **The best recovery is invisible.** (Silent retries for technical failures)
4. **Safety is rules, not AI.** (The Consent Gate and stopping rules are deterministic code, never probabilistic LLMs)
5. **Assign ownership before acting.** (Never sell debt as recovery. Check if infra, merchant, or customer owns the failure)

---

## 🏛️ Cross-Industry Inspiration (The Secret Sauce)

| Industry | Their Proven Protocol | How Revive AI Steals It |
|---|---|---|
| **✈️ Airlines** | Expected Value & predictive rebooking | **EV Optimizer**: `(Probability × Amount) − Cost of Attempt` |
| **🏥 Hospitals** | "Watchful Waiting" (triage) | **Affordability Triage**: defer to salary day via Liquidity Curves |
| **🏨 Hotels** | The "Walk" Protocol | **Graceful Exit**: pause, no late fees for structural churn |
| **📦 Logistics** | Alternate Mechanism | **Mechanism Swap**: OTP fails → UPI Collect Request |

---

## 🧱 Architecture & The Consent Gate

```text
Razorpay Webhook / Orders API / Synthetic Generator
     │
     ▼
[Ingestion] ──→ FastAPI BackgroundTasks (async queue, 5ms response)
     │
     ▼
[Diagnosis Engine] ──→ Groq gpt-oss-120b + Gemini failover + Pydantic + rule fallback
     │
     ▼
[Consent Gate] ──→ deterministic rules R-01..R-07
     ├─→ ALLOW  → Recovery Engine (EV Optimizer + Health Graph + Mechanism Swap)
     ├─→ DEFER  → Jobs table (Liquidity Curve → modal salary day)
     └─→ BLOCK  → Audit log (double-charge prevented)
     │
     ▼
[AuditLog + Bilingual Messages + Hinglish Voice] → [Streamlit + REST API]
```

| Rule | Trigger | Verdict |
|---|---|---|
| **R-01** RBI Mandate | Pre-debit notice < 24h | BLOCK |
| **R-02** Fee Shock | Abandonment at fee reveal | BLOCK (merchant insight instead) |
| **R-03** Structural Stop | Repeated affordability failures | BLOCK (Graceful Exit) |
| **R-04** Liquidity Defer | One-time insufficient balance | DEFER to modal salary day |
| **R-05** Tech Retry | Transient infra failure | ALLOW (silent retry) |
| **R-06** Default Allow | Safe path | ALLOW |
| **R-07** Offline QR Trap ⭐ | `context=post_session_offline` | BLOCK (prevents double-charge) |

---

## 🎯 Track 03 Coverage (Zero Scope Cut)

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
docker compose up -d
python -m venv venv && venv\Scripts\activate
pip install -r requirements.txt
python -m scripts.wipe_and_init          # 9 tables
python -m app.data.generator             # 500 labeled failures
python -m app.data.simulate              # diagnose + gate (500/500 pure-LLM)
python -m app.data.recover               # execute actions
uvicorn app.main:app --reload            # API on :8000
streamlit run app/dashboard.py           # Dashboard on :8501
```

### Demo Scripts
```bash
python -m app.data.evaluate              # held-out accuracy (98% / 95%, seeded)
python -m scripts.send_test_webhook      # HMAC-verified real webhook + tamper rejection
python -m scripts.simulate_dropoffs      # Flow B: merchant insights
python -m scripts.simulate_b2b           # Flow D: dispute halt + payment plans
python -m scripts.simulate_promise       # Promise-to-Pay tracker
python -m scripts.voice_demo             # Hinglish TTS (ElevenLabs)
python -m scripts.generate_money_slide   # dynamic per-archetype money slide
python -m scripts.dropoff_funnel         # drop-to-pay flow tracker
```

---

## 🙏 Honesty & Assumptions

- Simulation treats ALLOW retries as successful; production would track real Razorpay retry outcomes per attempt.
- Synthetic batch is labeled ground truth; accuracy measured on held-out sample (n=40, stratified).
- `failure_journal.md` logs every break, fix, and "aha" moment — including the day Groq retired our model mid-build.
- Accuracy is computed only over rows holding a pure-LLM diagnosis; rules-fallback rows (none in the shipped batch — verify via `scripts/verify_numbers.py`) are excluded from the calculation.

**Revive AI. Never remind. Resolve. No money moves without consent.**