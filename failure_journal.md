## Entry 1 — Day 1

**What broke:**
1. Local Windows Postgres owned port 5432 → `init_db` failed with
   "password authentication failed" (Python hit the local DB, not Docker).
2. Dashboard locked behind KYC onboarding; UPI missing at checkout.
3. Checkout quirks: UPI QR-only, test card 4111... rejected.

**Fixes:**
1. Pre-flight review patched 6 issues before running (missing __init__.py,
   port conflict, psycopg2 risk, groq dep, .env.example, test VPAs).
2. Docker DB → port 5433 → "Schema created: 8 tables."
3. Finished onboarding → UPI enabled; used Netbanking mock page
   (Success/Failure) for real captured + failed pay_ IDs.

**Lessons:**
- Pre-flight > firefighting.
- "Password failed" can mean "wrong door" — check who owns the port.

## Entry 2 — Day 2
**What broke:** Re-running generator crashed: UniqueViolation on pay_sim_0000.
ORM .delete() left ghost state in the session cache.
**Fixes:** Raw TRUNCATE, then full drop_all/create_all wipe; generator now idempotent.
**Lessons:** Idempotency must be real, not assumed; when the ORM fights you,
drop to raw SQL; wipe-and-rebuild is fine for synthetic data.

## Entry 3 — Day 3
**What broke:** Review caught two landmines: module-level LLM clients crash on
empty keys; an unchunked 500-item prompt would blow the context window on the
final batch.
**Fixes:** Lazy client init; internal chunking (10/batch); held-out eval n=40
→ archetype 100% / owner 100%.
**Lessons:** Init external clients lazily; always chunk LLM payloads;
measure on held-out data, never trust vibes.

## Entry 4 — Day 4
**What broke:** Gate's catch-all "technical → ALLOW" swallowed offline QR
failures → silent retry would double-charge a customer who left the store
and paid cash.
**Fixes:** R-07 offline QR trap placed BEFORE the generic rule; result:
180 blocked, Rs.4,63,124 goodwill protected.
**Lessons:** Context (offline) overrides archetype; rule order is safety;
the demo star was nearly lost to a catch-all rule.

## Entry 5 — Day 5
**What broke:** Nothing new — pipeline ran clean end-to-end.
**Verified:** 250 recovered / 70 deferred / 180 blocked; jobs table now holds
70 queued DEFERRED_RETRY rows.
**Lesson:** When diagnosis + gate are correct, execution is boring.
Boring execution is the goal.
**Assumption:** simulation treats every ALLOW retry as successful; production
would track actual Razorpay retry outcomes per attempt.

## Entry 6 — Day 6
**What broke:** Review caught two schema mismatches before runtime: AuditLog is
polymorphic (entity_type/entity_id — no failure_id) and actor is String(8),
so "revive-ai" (9 chars) would raise DataError. Also pasted Python into cmd
and corrupted main.py once — file-role confusion.
**Fixes:** Polymorphic insert with actor="system"; restored main.py to the
12-line FastAPI server.
**Lesson:** Write inserts against the schema you HAVE. Python goes in files,
commands go in terminals.

## Entry 7 — Day 7
**What broke:** Windows Python defaulted to cp1252 encoding and crashed when 
trying to write Hindi (Devanagari) characters to disk.
**Fixes:** Explicitly passed encoding="utf-8" to write_text().
**Lesson:** Always specify encoding="utf-8" on Windows file I/O to prevent 
charmap codec errors.

## Entry 8 — Day 8
**What broke:** Review caught two pre-run landmines: emoji print() would crash
on Windows cp1252 (Day 7's bug family), and a per-merchant query inside the
loop = N+1 (10,001 DB calls at scale).
**Fixes:** ASCII status icons; one group_by aggregation + dict lookup.
**Lesson:** Encoding bugs are a platform property — assume Windows bites twice.
Aggregate first, loop second.

## Entry 9 — Day 9
**What broke:** Review caught an O(N) memory trap: /overview loaded every row
into Python just to sum amounts (OOM at 50M rows).
**Fixes:** func.count/func.sum in Postgres; fetch answers, not rows.
**Scheduled:** CORS middleware (Day 11); AuditLog writes in simulate.py (Day 12).
**Lesson:** Databases are built to do math. Never sum in Python what Postgres
can sum in microseconds.

## Entry 11 — Day 11
**What broke:** Review caught an empty Audit trail on the dashboard (batch
pipeline never wrote AuditLog) and a phantom pandas dependency.
**Fixes:** Idempotent AuditLog writes in simulate.py (live webhook rows kept);
pandas + streamlit pinned in requirements.
**Lesson:** A dashboard with one empty table quietly destroys trust in the
other nine that are full.

## Entry 12 — Day 12
**What broke:** Free-tier quotas had two doors: RPM, then a tokens-per-minute
window. The old 5-retry backoff storm burned quota on retries that also 429'd.
**Fixes:** Quota-aware cooling (45s on RateLimitError, single retry); resumable
simulate kept LLM diagnoses and upgraded rules rows across 6 waves.
**Result:** 500/500 pure-LLM diagnoses (groq primary, gemini failover).
**Lesson:** Under hostile quotas, retries are traffic too. Fail cool, resume
later; never storm.