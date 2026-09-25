# Setup Owner Loop Contract

## Owner order

1. Profile
2. Objectives
3. Controls
4. NFRs

## Decision table

| Owner result | Active orchestration | Status-only request |
|---|---|---|
| Terminal success | Advance | Report |
| Missing with supported Next Action | Delegate to owner | Report |
| NFR `In Progress` with supported Next Action | Delegate to owner | Report |
| Blocked | Stop and report | Report |
| Malformed or unknown | Stop and report error | Report error |
| Declined or aborted action | Stop | Not applicable |
| Failed action | Stop | Not applicable |

## Algorithm

1. Request owner readiness.
2. Validate the four-field response shape and the owner's declared status/action combination.
3. Advance only on terminal success.
4. During active orchestration, delegate a supported action for a non-terminal result.
5. Consume the action result.
6. When the action reports verified completion, request owner readiness again.
7. Advance only from the new readiness result.
8. Stop on blocked, malformed, unknown, declined, aborted, or failed results.

Setup does not inspect owner artifacts, recompute owner readiness, write owner artifacts, or invent undeclared action names. Owner Summary and Blocking Reason are passed through as user-facing context without controlling routing.
