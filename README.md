# Revive AI — Consent-First Payment Recovery Agent

> ### 🎯 Headline result — ₹7,21,681 recovered · 165 double-charges blocked · 98% diagnosis accuracy
>
> A consent-gated recovery agent that diagnoses every failure, passes it through a deterministic 8-rule Consent Gate, and only then acts. Built for the **Razorpay Buildathon 2026 · Track 03: AI Revenue Recovery**.

---

> *"140 million payments fail in India every month. Most recovery systems are spam engines. We studied airlines, hospitals, and logistics to build a recovery system based on dignity, operational design, and strict consent."*

---

## The Problem (2026 Reality)

| Metric | Value | Source |
|---|---|---|
| Monthly UPI transactions | **23.6 billion** (July 2026) | NPCI |
| Conservative failure rate | **~0.6%** (technical + business) | Industry estimates |
| Monthly payment failures | **~140 million** (~14 crore) | Calculated |
| Daily payment failures | **~4.6 million** (~46 lakh) | Calculated |
| Annualized failure volume | **~168 crore** | Calculated |
| Global revenue leakage | **$47B/year** — 1 in 5 e-commerce orders affected | Optimus |
| RBI Digital Payments E-Mandate Framework | **21 April 2026** — mandatory 24h pre-debit alerts; no AFA up to ₹15,000 | RBI |

With 23.6 billion monthly UPI transactions and ~140 million failures, blindly retrying these double-charges customers who already paid cash, spams salary-day shortages, and compounds mandate fines. **Revive AI diagnoses every failure, passes it through a deterministic Consent Gate, and only then acts.**

---

## 📦 All Artifacts in One Table

| Artifact | Link |
|---|---|
| **Live Command Center** | [revive-ai-production-3535.up.railway.app](https://revive-ai-production-3535.up.railway.app/) |
| **Interactive Playground** | [revive-ai-production-3535.up.railway.app/#play](https://revive-ai-production-3535.up.railway.app/#play) |
| **Chat with the Agent** | Click the 💬 button on the live site — Hinglish + English, grounded ledger lookups |
| **Live API Overview** | [revive-ai-production-3535.up.railway.app/api/overview](https://revive-ai-production-3535.up.railway.app/api/overview) |
| **Full Audit Trail** | [revive-ai-production-3535.up.railway.app/api/audit](https://revive-ai-production-3535.up.railway.app/api/audit) |
| **Streamlit Dashboard** | [revive-ai-shxvy4uyvqydxucqxbqyin.streamlit.app](https://revive-ai-shxvy4uyvqydxucqxbqyin.streamlit.app) |
| **Failure Journal** | [`failure_journal.md`](failure_journal.md) |
| **Hinglish Voice Sample** | [`voice_technical.mp3`](voice_technical.mp3) |

---

## 🎯 Track 03 Theme Alignment

| Track 03 Direction | Fit | Implementation |
|---|---|---|
| **Payment degradation + root cause** | ✅✅✅ | `diagnosis.py` + `health.py` (Redis) + `ev_optimizer.py` |
| **Checkout drop-off recovery** | ✅✅✅ | Mechanism Swap + `dropoff_funnel.py` + `poll_orders.py` |
| **Failed subscription recovery** | ✅✅✅ | `/webhooks/razorpay/subscriptions` + mandate gate + sequencer |
| **B2B receivables recovery** | ✅✅✅ | `receivables.py`: dispute halt + payment-plan splitting |
| **Mandate expiry assurance** | ✅✅✅ | `audit.py` (RBI 24h pre-debit) + R-01 + Mandate Sequencer |
| **Hinglish voice recovery** | ✅✅✅ | `voice.py`: ElevenLabs → edge-tts → text fallback, opt-in voice replies |
| **Drop-to-pay flow tracker** | ✅✅✅ | `dropoff_funnel.py` + `/api/funnel` live endpoint |
| **Promise-to-pay tracker** | ✅✅✅ | `app/db/models.py:Promise` + fulfillment stats |

---

## 🚀 Quick Start for Reviewers (3 minutes)

1. **Open the Command Center** → [revive-ai-production-3535.up.railway.app](https://revive-ai-production-3535.up.railway.app/)
2. **Try the Playground** → pick the **🏪 Offline QR trap (R-07 ★)** preset → tick "Include Hinglish voice reply" → press **Run the agent** → watch it diagnose + gate + act + speak
3. **Open the Chat widget (💬)** → type *"mere paise kat gaye par merchant ko nahi mile"* → get an instant Hinglish reply. Type `pay_sim_0499` → get a grounded ledger lookup
4. **Click the API** → `/api/overview` returns 513 failures, ₹7,21,681 recovered
5. **Run the audit** → `/api/audit` shows every decision logged end-to-end

---

## 📈 The Numbers (Fresh 513-Batch, Test-Mode Evidence)

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
2. **Never remind. Resolve.** (A message must encode the diagnosis. "Bank was down, it's fixed now" > "Your cart is saved!")
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

## 📊 12 Live Telemetry Panels (on the Command Center)

Every decision is visible, replayable, and measurable:

| Panel | What it Shows |
|---|---|
| **Failure Feed** | Every failed payment with archetype, owner, verdict, rule, status |
| **Deferred Jobs** | Queued salary-day retries and liquidity deferrals |
| **Merchant Audit** | Merchant-specific failure patterns and insights |
| **Recovery Economics** | Attempt cost, net recovered, cost per ₹ recovered, retry budget |
| **Reconciliation / Limbo Watch** | Deducted-but-not-settled payments, NPCI T+48h auto-reversal window |
| **Mechanism Selector** | Success-rate routing: which channel wins (UPI vs Card vs eMandate) |
| **Mandate Sequencer** | T-24h notice → T+0 gated retry → T+48h human escalation jobs |
| **Promise-to-Pay Tracker** | Customer commitments with pending / fulfilled / escalated stats |
| **B2B Receivables** | Dispute halts, payment plans, gentle reminders |
| **Drop-off Funnel** | Orders → fee-shock drops → OTP drops → attempted → recovered |
| **Verdicts (chart)** | ALLOW / DEFER / BLOCK distribution |
| **Archetypes (chart)** | Technical / Intent / Affordability / Lifecycle split |

---

## 💬 The Agent Talks (Chat Widget)

A full conversational agent on the live site — not a canned FAQ:

- **Language-aware**: auto-detects Hinglish vs English and replies in the same language
- **Intent routing**: 13 regex-matched intents with human-tone replies
- **Consent protection**: hard-blocks on "I don't want to pay this way" (Law 1)
- **Double-charge guard**: catches "paise kat gaye par merchant ko nahi mile" and prevents retry
- **Grounded ledger lookups**: paste a `pay_…` ID → agent queries the real database and explains that specific payment
- **Engine fallback**: for anything untrained, runs the real diagnosis + gate and explains the result
- **Opt-in voice**: toggle 🔊 to hear every reply spoken in natural Hinglish

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
[Consent Gate] ──→ deterministic rules R-01..R-08
     ├─→ ALLOW  → Recovery Engine (EV Optimizer + Health Graph + Mechanism Swap)
     ├─→ DEFER  → Jobs table (Liquidity Curve → modal salary day)
     └─→ BLOCK  → Audit log (double-charge prevented)
     │
     ▼
[AuditLog + Bilingual Messages + Hinglish Voice + Chat Agent]
     │
     ▼
[Command Center + Streamlit + REST API + /api/explain ledger lookup]
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
| **R-08** Retry Budget | 3+ safe attempts per customer | BLOCK (stopping rules over spam) |

---

## 🏗️ Production-Grade Recovery Infrastructure

| Module | Implementation |
|---|---|
| **Retry budget enforcement** | R-08: 3 safe attempts per customer, then hard stop |
| **Reconciliation engine** | `app/core/reconciliation.py`: limbo detection + REFUND_SLA jobs, NPCI T+48h window |
| **Cost observability** | Attempt cost, net recovered, cost per ₹ recovered |
| **Mechanism selector** | Success-rate routing: retries via the highest-success channel |
| **Mandate sequencer** | T-24h notice → T+0 gated retry → T+48h human escalation |
| **Tokenized method refs** | Card-update links carry opaque tokens — zero PAN storage |
| **Connector seam** | `app/connectors/`: processor-agnostic interface, Razorpay implementation shipped |
| **Chat agent** | Language-aware, intent-routed, grounded ledger lookups, opt-in voice |

*Revive AI is not a switch replacement — it is the intelligence layer that sits on top of any switch. When the transaction fails, that's when Revive AI wakes up.*

---

## 🛠️ Run Locally

```bash
docker compose up -d
python -m venv venv && venv\Scripts\activate
pip install -r requirements.txt
python -m scripts.wipe_and_init          # 12 tables (incl. promises)
python -m app.data.generator             # 500 labeled failures
python -m app.data.simulate              # diagnose + gate (500/500 pure-LLM)
python -m app.data.recover               # execute actions
uvicorn app.main:app --reload            # API on :8000 + Command Center on /
streamlit run app/dashboard.py           # Dashboard on :8501
```

### Demo Scripts

```bash
python -m app.data.evaluate              # held-out accuracy (98% / 95%, seeded)
python -m scripts.send_test_webhook      # HMAC-verified real webhook + tamper rejection
python -m scripts.simulate_dropoffs      # Flow B: merchant insights
python -m scripts.simulate_b2b           # Flow D: dispute halt + payment plans
python -m scripts.simulate_promise       # Promise-to-Pay tracker
python -m scripts.simulate_promises      # seed 10 demo promises
python -m scripts.voice_demo             # Hinglish TTS (ElevenLabs)
python -m scripts.generate_money_slide   # dynamic per-archetype money slide
python -m scripts.dropoff_funnel         # drop-to-pay flow tracker
python -m scripts.simulate_mandate_sequence  # RBI-compliant dunning sequencer
pytest tests                             # 7 unit tests (R-01..R-07 full coverage)
```

---

## 🎥 Video Demo

A 3-minute walkthrough is available here: **[YouTube Unlisted Link — add after recording]**

The demo covers:
1. Command Center hero + stats count-up
2. Playground: Offline QR trap (R-07) with Hinglish voice reply
3. Chat widget: double-charge guard + payment-ID ledger lookup
4. Gate rules + Audit trail walkthrough
5. Closing: *"Never remind. Resolve."*

---

## 🙏 Honesty & Assumptions

- Simulation treats ALLOW retries as successful; production would track real Razorpay retry outcomes per attempt.
- Synthetic batch is labeled ground truth; accuracy measured on held-out sample (n=40, stratified, seeded).
- `failure_journal.md` logs every break, fix, and "aha" moment — including the day Groq retired our model mid-build.
- Accuracy is computed only over rows holding a pure-LLM diagnosis; rules-fallback rows (none in the shipped batch — verify via `scripts/verify_numbers.py`) are excluded from the calculation.
- Playground and chat runs never pollute the money-slide numbers — rows are deleted after the response.
- The B2B receivables panel is a deterministic simulation (seed=7) of the Flow D engine — it demonstrates dispute-halt and payment-plan logic, not live invoicing data.

---

**Revive AI. Never remind. Resolve. No money moves without consent.**