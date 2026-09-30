# Setup Owner Orchestration Contract

## Inputs

Setup receives the project root, the four owner contracts, the Experience Standard, and the
active user request. It does not consume owner-internal artifacts or state.

## Readiness routing

1. Request readiness from the current owner.
2. Advance only when the owner declares a terminal result with `Next Action: None`.
3. Delegate only a supported action supplied by the owner.
4. Stop on `Blocked`, `Declined`, `Aborted`, malformed, or unsupported results.

Owner order is fixed: Profile, Objectives, Controls, NFRs.

## Collection routing

The active owner returns:

```text
Action Status: Succeeded|Declined|Aborted|Blocked
Collection Result: Continue|Finished
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

`Succeeded + Continue` keeps the owner active. `Succeeded + Finished` causes Setup to request
fresh readiness before advancing. `Declined`, `Aborted`, and `Blocked` stop without advancing.

## User-visible boundaries

Setup may emit only concise domain transitions and the final completion message. It forwards the
owner's interaction without rewriting it and does not duplicate owner openings.

## Completion

Setup emits the final conclusion once, only after all four owners return their declared terminal
results. Setup writes no owner artifact and persists no checkpoint.
