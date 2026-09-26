# Contract: Conversational Objective Workflow

## Entry points

- `/highway-objectives setup` and bare `/highway-objectives add` provide concise direct-invocation context and the complete Objectives-owned opening.
- `/highway-objectives add <evidence>` processes supplied evidence before choosing a question; it does not repeat the opening Outcome question when Outcome is already supported.
- Setup delegates `/highway-objectives setup` after emitting its own purpose introduction only when Objective readiness is non-terminal and routes all subsequent owner content unchanged.

## Adaptive interaction

Objectives evaluates the full active response across Outcome, Success, and Significance before choosing one next action:

1. Ask one Outcome question if Outcome is unresolved.
2. Otherwise ask one Success question if Success is unresolved.
3. Otherwise ask one Significance question if Significance is unresolved.
4. Otherwise present the complete proposal.

The interaction never exposes fixed three-step progress. A rich answer may resolve multiple dimensions. Suggestions are one unresolved decision, remain transient until explicit adoption, and are grounded only in relevant accepted Profile evidence.

## Proposal and confirmation

The proposal displays distinct user-facing sections for title, Statement, Success Measures, and Rationale, followed by one natural-language validation decision. Natural acceptance authorizes non-destructive creation without another persistence-confirmation question. Corrections invalidate unsupported downstream evidence and require a revised complete proposal when needed.

## Confirmed creation

After confirmation, Objectives revalidates the authoritative baseline and catalog, re-evaluates overlap, and invalidates stale confirmation if newly discovered overlap affects the proposal. Once the user resolves any overlap and validates the resulting proposal again, Objectives allocates one permanent identifier, constructs the mutation, writes record and catalog as one all-or-nothing transaction, verifies both retained outputs, and reports creation completed only after verification succeeds.

## Non-write outcomes

Decline, cancellation, abandonment, interruption, malformed baseline, overlap requiring renewed validation, persistence failure, or verification failure does not create a record, consume an identifier, change `next_id`, increment the version, or persist transient state. Verification failure names the unverified Objective record or catalog output.

## Resume

`Resume Applicability: New interaction`. Interrupted proposals and collection-loop questions are not restored. Persisted Objectives remain authoritative, and a later invocation begins from a fresh readiness result.
