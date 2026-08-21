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