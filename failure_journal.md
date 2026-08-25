
***

### 2. `failure_journal.md`

```markdown
# The Failure Journal

This isn't a sanitized success story. This is a real engineer's war diary — every bug, every head-slap, and every "why didn't I see that coming" moment. Building production-grade software under pressure is messy. This is what it actually looked like.

---

## Entry 1 — The Port War

**What broke:** I opened my terminal ready to conquer the project. Ran the database init script. Got a cryptic "password authentication failed for user postgres." I stared at it for 20 minutes. The password was right. Docker was running. What the hell?

**The real problem:** My local Windows Postgres was sitting on port 5432, and my Python code was talking to IT instead of the Docker container.

**The fix:** Changed docker-compose to use port 5433. "Schema created: 8 tables." First win.

**What I learned:** "Password failed" doesn't always mean "wrong password." Sometimes it just means "wrong door."

---

## Entry 2 — Ghost State

**What broke:** Ran the synthetic generator twice to test idempotency. Crashed with a `UniqueViolation` on the very first ID. I had written `db.query(PaymentFailure).delete()` thinking that would wipe the table. Turns out the ORM keeps a session cache that doesn't always flush the way you expect.

**The fix:** Dropped the ORM delete. Wrote a raw `TRUNCATE` SQL command. The generator is now genuinely idempotent.

**What I learned:** Idempotency must be real, not assumed. When the ORM fights you, drop to raw SQL.

---

## Entry 3 — The Context Window Bomb

**What broke:** A code review caught a massive landmine before I hit production: my diagnosis function was about to send 500 failures to the LLM in a single prompt. Groq would have instantly rejected it. Worse, I had LLM clients initialized at the module level. If the env file was missing, the whole app would crash on import.

**The fix:** Lazy client initialization (only spin up when needed) and internal chunking (10 per batch). Ran a held-out eval on 40 samples to prove it worked: 92% accuracy. Exhale.

**What I learned:** Always chunk LLM payloads. Init external clients lazily. Never trust vibes — measure on held-out data.

---

## Entry 4 — The Catch-All That Almost Killed the Demo ⭐

**What broke:** This was the closest I came to losing the entire project. My Consent Gate had a catch-all rule at the end: "if technical failure → ALLOW retry." Simple. Clean. Wrong. 

I realized that offline QR failures (customer scanned, app hung, they left and paid cash) were classified as "technical." The catch-all would ALLOW a silent retry 10 minutes later. **Double-charge.** Chargeback. Trust destroyed. My entire thesis — "no money moves without valid consent" — would have been a lie.

**The fix:** Added Rule R-07 (Offline QR Trap) and placed it BEFORE the catch-all. Result: 141 blocked, ₹7L+ in customer goodwill protected.

**What I learned:** Context overrides archetype. Rule order is safety. The demo star was nearly lost to a lazy catch-all rule.

---

## Entry 5 — Schema vs. Reality

**What broke:** Two landmines caught by a late-night review:
1. `AuditLog` is polymorphic (`entity_type/entity_id`, not `failure_id`) — my insert was wrong.
2. `actor` is a `String(8)`, but I was writing "revive-ai" (9 chars) — it would crash at runtime.

**The fix:** Polymorphic insert with `actor="system"`. 

**What I learned:** Write inserts against the schema you actually HAVE, not the one you remember. 

---

## Entry 6 — Windows Strikes Back (Twice)

**What broke:** Python on Windows defaulted to cp1252 encoding. Tried to write Hindi (Devanagari) characters to disk. Crashed with "charmap codec can't encode character." Then, a few days later, `print()` statements with emojis crashed the terminal for the exact same reason. 

**The fix:** Explicit `encoding="utf-8"` on every single file write and print statement.

**What I learned:** Encoding bugs are a platform property. Assume Windows will bite you twice.

---

## Entry 7 — The OOM Trap

**What broke:** Code review caught an O(N) memory trap: the dashboard API was loading EVERY database row into Python just to sum the recovered amounts. At 50 million rows, this would OOM-kill the server.

**The fix:** `func.count` and `func.sum` directly in Postgres. Fetch the answers, not the rows.

**What I learned:** Databases are built to do math. Never sum in Python what Postgres can sum in microseconds.

---

## Entry 8 — The Quota Storm

**What broke:** Free-tier LLM quotas have two doors: requests per minute, and tokens per minute. My old 5-retry backoff would "storm" — burning my free Groq credits on retries that also got 429 Rate Limited. I was hemorrhaging quota in minutes.

**The fix:** Quota-aware cooling. 45-second hard sleep on `RateLimitError`, single retry. Made the batch script resumable so it could pick up where it left off across 6 different waves.

**What I learned:** Under hostile quotas, retries are traffic too. Fail cool, resume later. Never storm.

---

## Entry 9 — The Async Epiphany

**What broke:** I looked at my webhook endpoint and realized it was calling the LLM diagnosis *synchronously*. The HTTP request was hanging for 3 seconds waiting for Groq to reply. In the real world, Razorpay would time out and drop the webhook.

**The fix:** Refactored the entire webhook to use FastAPI `BackgroundTasks`. The endpoint now creates the DB row, queues the task, and returns `{"status": "queued"}` in 5 milliseconds. 

**What I learned:** Webhooks must be fast and dumb. Put the heavy lifting in the background.

---

## Entry 10 — The Voice That Sounded Like a Robot

**What broke:** I finally integrated the Hinglish voice engine. I ran the script, played the audio, and it sounded like a 1990s GPS navigator reading a script. Edge-tts's native Hindi voice completely choked on Latin-script Hinglish ("Aapka payment fail hua...").

**The fix:** 
1. Switched edge-tts to `en-IN-NeerjaNeural` (an Indian-English voice reads Latin Hinglish beautifully).
2. Lowered ElevenLabs `stability` to `0.35` (low stability = expressive human pitch, high stability = monotone robot).
3. Added punctuation (`...`, commas) to force natural pauses.

**What I learned:** Voice UX is just as important as the logic behind it. A robotic voice kills trust; a warm voice builds it.

---

## Entry 11 — The Zero-Cut Push

**What broke:** As the deadline approached, the temptation to cut scope was overwhelming. "Do we really need the B2B receivables?" "Is the Redis Health Graph worth the setup?" "Can't we just fake the Orders API?"

Every instinct said to ship a focused 80% project.

**The fix:** I didn't cut. I sat down and built every single feature promised in the original master plan. Redis Health Graph, ElevenLabs voice, Liquidity histograms, B2B dispute halts, Orders API polling. 

**What I learned:** Scope discipline is the hardest engineering skill. But when you commit to zero cuts and actually execute, the machine you build is exactly the one you promised. That integrity shows in the code.

---

## Final Word

Eleven entries. Eleven times I broke something, found it, fixed it, and wrote it down. 

This repo isn't just code. It's proof that building production-grade, compliance-aware software is messy, iterative, and deeply human. If you're a Razorpay engineer reading this: I built what I promised. Every feature. Every edge case. Every law.

**No money moves without consent.**