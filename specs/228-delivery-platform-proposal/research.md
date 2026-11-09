# Research: Delivery Platform Proposal

## R1. Reuse `execution`

- **Decision**: `delivery platforms` follows `execution` and takes its value for each unset field.
- **Rationale**: `execution` is the normal proposal's rule set. Citing it keeps one owner for the Kind order and the Language match (P7.3).
- **Alternatives considered**: Restating the Kind order in `delivery platforms`. Rejected: two copies drift.

## R2. Return target of `execution`

- **Decision**: `execution` step 5 becomes "Return to the step that named this one."
- **Rationale**: `start` and `delivery platforms` both follow it. `capability title` step 7 already uses this wording.
- **Alternatives considered**: "Return to `start` or `delivery platforms`." Rejected: names callers inside the callee.

## R3. Own row

- **Decision**: `execution` states "This implementation's row is not a candidate."
- **Rationale**: In `start` the implementation has no row yet, so the line changes nothing there. In `delivery platforms` it keeps the implementation from delivering itself (FR-005).
- **Alternatives considered**: Stating it in `delivery platforms`. Rejected: the candidate list is owned by `execution`.

## R4. Moved pins

- `delivery-platform-handoff.test.sh`: `'Otherwise rewrite the three Execution lines. Change no other byte.'` moves to `'Otherwise rewrite the three Execution lines with the held fields. Change no other byte.'`
- Version pins `version: 7.6.0` move to `version: 7.7.0` in every test that pins `highway-implementation`.

## R5. Edited values across a hand-off

- **Decision**: Step 3 keeps "a value the person named in this visit".
- **Rationale**: `field` returns to `delivery platforms` after configuration or onboarding, which runs step 3 again (FR-007).
