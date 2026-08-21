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