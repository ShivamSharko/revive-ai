# The Failure Journal

This isn't a sanitized success story. This is a real engineer's war diary — every bug, every head-slap, and every "why didn't I see that coming" moment. Building production-grade software under pressure is messy. This is what it actually looked like.

---

## Entry 1 — The Port War

**What broke:** I opened my terminal ready to conquer the project. Ran the database init script. Got a cryptic "password authentication failed for user postgres." I stared at it for 20 minutes. The password was right. Docker was running. What the hell?

**The real problem:** My local Windows Postgres was sitting on port 5432, and my Python code was talking to IT instead of the Docker container.

**The fix:** Changed docker-compose to use port 5433. "Schema created: 8 tables." First win.

**What I learned:** "Password failed" doesn't always mean "wrong password." Sometimes it just means "wrong door."

---

## Entry 2 — The Offline QR Trap That Almost Killed the Demo ⭐

**What broke:** My Consent Gate had a catch-all rule: "if technical failure → ALLOW retry." Simple. Clean. Wrong.

I realized that offline QR failures (customer scanned, app hung, they left and paid cash) were classified as "technical." The catch-all would ALLOW a silent retry 10 minutes later. **Double-charge.** Chargeback. Trust destroyed. My entire thesis — "no money moves without valid consent" — would have been a lie.

**The fix:** Added Rule R-07 (Offline QR Trap) and placed it BEFORE the catch-all. Result: 141 blocked, ₹7L+ in customer goodwill protected.

**What I learned:** Context overrides archetype. Rule order is safety. The demo star was nearly lost to a lazy catch-all rule.

---

## Entry 3 — The Promise Model That Couldn't Find Its Parent

**What broke:** I built a beautiful Promise-to-Pay tracker in `app/core/promise.py`. Ran the table-creation one-liner. SQLAlchemy exploded: `NoReferencedTableError: Foreign key associated with column 'promises.failure_id' could not find table 'payment_failures'`.

But `payment_failures` absolutely existed. The table was right there.

**The real problem:** My one-liner only imported `Promise`, not `PaymentFailure`. SQLAlchemy's metadata only knows about tables it's seen. Standalone module = orphaned FK.

**The fix:** Moved the `Promise` model into `app/db/models.py` where all models live together. Deleted the standalone module. One import now loads everything.

**What I learned:** SQLAlchemy metadata is a graph. If you don't import a node, it doesn't exist. Keep models together or import them all.

---

## Entry 4 — The Missing `datetime` That Broke Everything

**What broke:** Right after Entry 3, the table creation crashed again: `NameError: name 'datetime' is not defined. Did you mean: 'DateTime'?`

I was using `default=datetime.now` in the Promise model. But `models.py` only imported SQLAlchemy's `DateTime` type, not Python's `datetime` module. Same word, two completely different things.

**The fix:** Added `from datetime import datetime` at the top of `models.py`. One line. Two hours of debugging.

**What I learned:** Name collisions between framework types and stdlib modules are invisible traps. Always check your imports when you see "did you mean..." errors.

---

## Entry 5 — The VARCHAR(8) Landmine

**What broke:** Ran the mandate sequencer script. Crashed with `StringDataRightTruncation: value too long for type character varying(8)`.

I was writing `action="MANDATE_SEQUENCE_SCHEDULED"` (26 chars) and `actor="sequencer"` (9 chars) into the `audit_logs` table. The schema had `VARCHAR(8)` for both.

**The fix:** Shortened to `action="MAND_SEQ"` and `actor="seq"`. Three characters saved the day.

**What I learned:** Write against the schema you actually HAVE, not the one you remember. Always check column widths before seeding.

---

## Entry 6 — The Decimal Crash That Killed the Dashboard

**What broke:** Added the Recovery Economics panel. Refreshed the page. **Everything went blank.** Stats showed zeros, charts disappeared, audit trail empty.

The server logs showed `TypeError: unsupported operand type(s) for -: 'decimal.Decimal' and 'float'` in the `/api/overview` endpoint.

**The real problem:** Postgres `SUM()` returns `decimal.Decimal`. I was doing `recovered_rupees - attempt_cost` where one was Decimal and the other was float. Python refuses to mix them. The endpoint 500'd, and the frontend's `load()` function crashed on the first fetch, killing every panel downstream.

**The fix:** Wrapped every `totals.X` in `float()`: `round(float(totals.recovered or 0) / 100, 2)`. Three one-word fixes.

**What I learned:** Postgres math types don't auto-cast to Python floats. Always wrap aggregates. And one uncaught exception in a fetch chain kills the entire dashboard.

---

## Entry 7 — The Frontend DOM Null Cascade

**What broke:** Added B2B receivables and drop-off funnel panels. Refreshed. The Promise tracker and Audit trail were empty. Console showed `Cannot set properties of null (setting 'innerHTML')`.

But I had the HTML panels. I had the JS variables. Everything looked wired.

**The real problem:** I put the B2B/funnel row **outside** the `<section id="feed">` tag. Then I referenced `mech` (mechanism selector) in a catch block, but `mech` was null because its panel was also missing from the HTML. The catch block crashed → killed the entire `load()` function → audit and promises never rendered.

One missing panel killed two others. A cascade failure.

**The fix:** Moved all telemetry panels inside the feed section. Added `if(mech)mech.innerHTML=...` null-checks on every catch block.

**What I learned:** Frontend error handling must be defensive. One unguarded null check can cascade and kill unrelated features. And HTML structure matters — orphaned elements break everything.

---

## Entry 8 — The Chatbot Identity Crisis

**What broke:** Built the chat widget. Typed "I already paid cash at the store." Got back: `BLOCK R07_OFFLINE_QR_TRAP · Customer already paid cash at the store — a silent retry would double-charge them. The Gate blocks it.`

The logic was right. The **voice** was wrong. I was talking to a log parser, not a human.

**The fix:** Rewrote every reply in warm, conversational Hinglish/English. Changed the header from "Ask the agent" to "Customer experience preview." Reframed the technical footnote as a small muted box under the human reply.

Now the bot says: *"Arre nahi nahi, aapne store par cash se payment kar di thi na, toh humne wo QR payment cancel kar diya hai. Dobara kuch nahi katega. Aap bilkul tension mat lo."*

**What I learned:** A bot that talks like a database is worse than no bot at all. Identity matters. Frame matters. Voice matters.

---

## Entry 9 — The Consent Violation in the Copy

**What broke:** A customer types *"paise kate hi nhi"* (nothing was deducted). The bot replies: *"Bank mein temporary problem thi... humne dobara try kiya — payment successful."*

The bot just told a customer who paid nothing that their payment succeeded. **Exact opposite of reality.** This is the spam-engine behavior my 5 Laws exist to kill.

**The real problem:** My KB treated "customer's net off" and "bank down mid-purchase" as the same thing. They're not. One has established intent (silent retry OK). The other has no completed intent (never silent-deduct).

**The fix:** Split them into two intents. For customer-side failures: *"Koi paisa deduct nahi hua. Paise bilkul safe hain. Bina aapke approval ke kuch nahi katega."* Added a deterministic backend override that blocks any retry on "deducted-but-unsettled" payments, regardless of what the LLM says.

**What I learned:** Consent violations hide in the copy, not the code. Read your bot's replies out loud. If it contradicts the customer's reality, you've failed Law 1.

---

## Entry 10 — The Refund Intent Hijack

**What broke:** A customer asks *"when will I get my refund?"* The bot replies with the DOUBLE-CHARGE GUARD message about limbo payments and NPCI auto-reversal.

Completely wrong answer. The customer wasn't reporting a stuck payment — they were asking about a normal refund timeline.

**The real problem:** My double-charge regex contained `refund|wapas|received`. It was too greedy. It swallowed the refund question before the refund intent could match.

**The fix:** Added a dedicated REFUND-SLA intent and placed it **before** the double-charge rule. Removed `refund|wapas|received` from the double-charge regex.

**What I learned:** Regex order is intent priority. Put specific intents before greedy catch-alls. A hijacked intent is worse than no intent.

---

## Entry 11 — The Chatbot Going Through the LLM for Unknowns

**What broke:** A customer types *"mereco razor pay use nhi krna"* (I don't want to use Razorpay). The bot thinks for 3 seconds, then says: *"Your payment hit a technical issue that has since been fixed, so we safely retried and it completed."*

The customer just withdrew consent. The bot told them their payment succeeded. **Law 1 violation.**

**The real problem:** The message didn't match any KB intent, so it fell through to the live engine. The engine classified it as "technical / ALLOW R-06" and pasted the technical reply template. Garbage in, garbage out.

**The fix:** Added a LAW-1 consent-withdrawal intent that hard-blocks on any "don't want / stop / cancel / unsubscribe" phrase. Added an honest fallback for anything truly unknown: *"Yeh situation meri training mein nahi thi... maine case human team ko forward kar diya hai. Koi retry nahi hogi."*

**What I learned:** A bot that invents answers is worse than one that admits it doesn't know. Three modes: knows it → answers; consent moment → protects; doesn't know → escalates.

---

## Entry 12 — The Async Epiphany

**What broke:** I looked at my webhook endpoint and realized it was calling the LLM diagnosis *synchronously*. The HTTP request was hanging for 3 seconds waiting for Groq to reply. In the real world, Razorpay would time out and drop the webhook.

**The fix:** Refactored the entire webhook to use FastAPI `BackgroundTasks`. The endpoint now creates the DB row, queues the task, and returns `{"status": "queued"}` in 5 milliseconds.

**What I learned:** Webhooks must be fast and dumb. Put the heavy lifting in the background.

---

## Entry 13 — The Voice That Sounded Like a Robot

**What broke:** I finally integrated the Hinglish voice engine. Played the audio. Sounded like a 1990s GPS navigator. Edge-tts's native Hindi voice completely choked on Latin-script Hinglish.

**The fix:** Switched to `en-IN-NeerjaNeural` (Indian-English voice reads Latin Hinglish beautifully). Lowered ElevenLabs `stability` to `0.35`. Added punctuation to force natural pauses.

**What I learned:** Voice UX is just as important as the logic behind it. A robotic voice kills trust; a warm voice builds it.

---

## Entry 14 — The Railway Seeding Gap

**What broke:** Local dashboard showed beautiful mandate sequences and promise tracker. Deployed to Railway. Refreshed the live site. "No mandate sequences yet." "Promises unavailable."

My code was identical. My data was not.

**The real problem:** Railway has its own Postgres. I'd been seeding my local DB for weeks. Railway's DB was a blank slate. The tables didn't even exist.

**The fix:** Copied the `DATABASE_URL` from Railway dashboard. Ran `Base.metadata.create_all()` against it. Ran the seed scripts. Refreshed. Live site now matches local.

**What I learned:** Every deploy target has its own database. Code parity ≠ data parity. Always seed production after deploy.

---

## Entry 15 — The Password in the Chat

**What broke:** In the middle of debugging Railway, I pasted my live database URL — including the plaintext password — into a chat window.

No code bug. Pure operational stupidity.

**The fix:** Rotated the password immediately. Updated Railway env vars. Lesson learned the expensive way.

**What I learned:** Secrets live in env vars, never in chat. Never in screenshots. Never in commit messages. The moment a secret leaves its vault, it's compromised.

---

## Entry 16 — The Zero-Cut Push

**What broke:** As the deadline approached, the temptation to cut scope was overwhelming. "Do we really need the B2B receivables?" "Is the Redis Health Graph worth the setup?" "Can't we just fake the Orders API?"

Every instinct said to ship a focused 80% project.

**The fix:** I didn't cut. I sat down and built every single feature promised in the original master plan. Redis Health Graph, ElevenLabs voice, Liquidity histograms, B2B dispute halts, Orders API polling, chat agent, promise tracker, mandate sequencer, reconciliation engine.

**What I learned:** Scope discipline is the hardest engineering skill. But when you commit to zero cuts and actually execute, the machine you build is exactly the one you promised. That integrity shows in the code.

---

## Final Word

Sixteen entries. Sixteen times I broke something, found it, fixed it, and wrote it down.

This repo isn't just code. It's proof that building production-grade, compliance-aware software is messy, iterative, and deeply human. If you're a Razorpay engineer reading this: I built what I promised. Every feature. Every edge case. Every law.

**No money moves without consent.**