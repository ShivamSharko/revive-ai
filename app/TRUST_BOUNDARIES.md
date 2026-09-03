# Revive AI Trust Boundaries

| Component | Execution Authority | Constraints |
|-----------|-------------------|-------------|
| **LLM (Groq/Gemini)** | None | Only diagnoses archetype/owner, cannot execute actions |
| **Consent Gate** | Absolute | 8 deterministic rules, overrides LLM suggestions |
| **Policy Engine** | Absolute | Quiet hours, promise halts, ₹5k human approval |
| **Database** | Absolute | Primary key prevents duplicate payment_ids |
| **Frontend** | Read-only | Cannot execute recovery actions, only triggers backend |

## Safety Invariants

1. **Consent First**: No retry without explicit consent (Law 1)
2. **At-Most-Once**: Duplicate payment_ids rejected at database level
3. **Economic Floor**: Interventions below ₹100 are skipped
4. **Human-in-Loop**: Amounts >₹5k require manual approval
5. **Audit Trail**: Every action logged with reasoning