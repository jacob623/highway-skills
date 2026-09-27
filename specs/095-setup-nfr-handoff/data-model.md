# Data Model: Highway Setup NFR Handoff

This feature adds no retained data model. It changes Setup's user-visible orchestration outputs
while continuing to consume authoritative owner results.

## Setup owner result

| Field | Meaning | Ownership / validation |
|---|---|---|
| Owner status | Current domain result such as `Complete`, `Missing`, `Blocked`, or `In Progress` | Produced by the owning skill; Setup validates the declared result contract. |
| Collection result | Controls `Continue` or `Finished` | Produced by Controls; `Finished` requires explicit user intent. |
| Next Action | Owner-provided route or `None` | Produced by the owner; Setup delegates only supported owner routes. |
| Blocking Reason | Owner-provided actionable reason or `None` | Produced by the owner; required for blocked results. |

## Setup handoff transition

| Property | Rule |
|---|---|
| Owner | Setup |
| Trigger | Controls readiness is `Complete` and NFR readiness requires the first user interaction |
| Cardinality | Exactly once during the initial active handoff |
| Persistence | None; never stored as an artifact, checkpoint, or resume marker |
| Exclusions | Controls `Continue`, Controls `Missing`/`Blocked`, direct NFR invocation, resumed NFR work, and terminal NFR results requiring no interaction |

## Setup conclusion

| Property | Rule |
|---|---|
| Owner | Setup |
| Trigger | Every required owner has supplied the terminal result required by its contract |
| Cardinality | Once per successful Setup completion response |
| Content | Prescribed foundational-context message and `/highway-help` recommendation |
| Exclusions | Blocked, incomplete, malformed, declined, aborted, or failed required-owner paths |
| Persistence | None beyond the existing owner artifacts; the conclusion is a user-visible completion claim |

## State transitions

1. Controls `Continue` -> remain with Controls; no handoff.
2. Controls `Finished` -> request fresh Controls readiness.
3. Fresh or pre-delegation Controls `Complete` -> request NFR readiness.
4. NFR readiness requiring interaction -> emit handoff once -> delegate NFR owner.
5. Terminal NFR readiness requiring no interaction -> do not manufacture interaction or handoff.
6. All required terminal owner results -> emit Setup conclusion.
7. New interaction -> reread authoritative owner state -> resume first incomplete owner; restore no transient Setup state.
