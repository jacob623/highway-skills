# Setup Readiness Contract

## Ordered calls

Setup requests readiness in this order and does not inspect later owners after a non-complete result:

1. Profile
2. Objectives
3. Controls
4. NFRs

## Routing

- `Complete`: continue to the next owner.
- Profile, Objectives, or Controls `Missing`/`Blocked`: report that owner and its response fields; stop.
- NFR `Complete` or `Not Applicable`: emit the completion dashboard.
- NFR `Missing`: report the NFR missing activity and owner next action.
- NFR `In Progress`: report the pending review activity and owner next action.
- NFR `Blocked`: report the blocked activity and include the non-empty owner blocking reason.
- Unknown status or malformed response: emit a deterministic Setup `Blocked` result and do not assume completion.

Setup may render owner-provided `Summary`, `Next Action`, and `Blocking Reason`, but it MUST NOT recompute owner-specific completeness rules.
