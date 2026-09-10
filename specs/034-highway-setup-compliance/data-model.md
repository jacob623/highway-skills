# Feature 034 Data Model

## Setup Verification Fixture

| Field | Description | Validation |
|---|---|---|
| `fixture_id` | Stable scenario identifier | Unique within the matrix and fixture suite |
| `repository_state` | Disposable Profile, Objective, Control, and NFR state | Declares the first expected readiness boundary |
| `owner_outcomes` | Deterministic owner workflow results | Uses only success, declined, failed, incomplete, or malformed outcomes |
| `expected_events` | Ordered readiness reads and owner calls | Compared exactly with observed events |
| `expected_output` | Canonical dashboard state | Compared byte-for-byte for dashboard scenarios |
| `artifact_hashes_before` | Hashes of governance fixtures before execution | Recorded for idempotence and no-write cases |
| `artifact_hashes_after` | Hashes after execution | Must match before hashes when no mutation is required |

## NFR State

| State | Meaning | Allowed next action |
|---|---|---|
| `Missing` | Controls are complete and no NFR proposal has started | Invoke the Control-owned proposal path |
| `In Progress` | A proposal is pending author acceptance | Pause, report current activity, and withhold completion |
| `Complete` | Accepted valid NFR artifacts are recognized by the NFR owner | Emit the completion dashboard |
| `Blocked` | NFR input or owner result is malformed, unsafe, or contradictory | Stop and report the blocker |
| `Not Evaluated` | An earlier prerequisite is incomplete | Do not inspect or claim NFR readiness |

## Routing Matrix Row

| Field | Description | Validation |
|---|---|---|
| `case_id` | Stable `R###` identifier | Exactly 20 rows exist, R001 through R020 |
| `entry_state` | One of five readiness states | Empty, Profile-only, Profile+Objectives, Profile+Objectives+Controls, or Complete |
| `owner_result` | One of four outcome classes | Success, Declined, Failed, or Incomplete/Malformed |
| `expected_first_action` | Owner route or deliberate stop | Matches the Feature 033 ownership boundary |
| `observed_first_action` | Recorded first owner call or stop | Must equal expected action for a passing row |
| `result` | PASS or FAIL | 19 or more PASS rows are required |

## Ownership Review Item

| Field | Description | Validation |
|---|---|---|
| `boundary_id` | Stable ownership identifier | Covers Profile, Objectives, Controls, Control-owned NFR proposal, accepted NFRs, and second-store prevention |
| `evidence` | File, test, or review observation | Non-empty and specific |
| `outcome` | PASS or documented exception | No blank item may support a full compliance claim |

## Relationships and Invariants

- Readiness events are ordered Profile -> Objectives -> Controls -> NFRs.
- A failed, declined, incomplete, or malformed owner result prevents later owner calls.
- `NFRs: Missing` precedes proposal invocation; `NFRs: In Progress` follows a pending proposal.
- Complete output is possible only when all four baselines are Complete.
- A no-mutation fixture has identical before and after artifact hashes.
- Routing coverage is `PASS rows / 20`; full compliance requires at least `19 / 20`.
