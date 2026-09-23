# Feature 082 Data Model: Setup Wizard Contract Hardening

## Setup Progress Report

| Field | Meaning | Validation |
|---|---|---|
| `Step` | Numeric active-stage identifier | `1` Profile, `2` Objectives, `3` Controls, or `4` NFRs; absent when `Current Stage` is `Complete` |
| `Stage` | Stage represented by the active step | Uses the canonical Profile, Objectives, Controls, and NFRs vocabulary |
| `Completed Stages` | Owner stages with terminal success | Ordered subset of the four stages |
| `Current Stage` | Active owner stage or overall completion | One of Profile, Objectives, Controls, NFRs, or Complete |
| `Remaining Stages` | Stages not terminally successful | Ordered complement of completed stages while incomplete |
| `Current Activity` | Next owner action or question | Supplied by the active owner workflow or Setup completion framing |

The progress report is transient interaction framing and is not an independently persisted wizard checkpoint.

## Owner Response

| Field | Meaning | Validation |
|---|---|---|
| `Status` | Owner terminality or blocking state | Owner-defined status, classified by the Setup terminality contract |
| Informational output | Owner explanation or result content | Presented before a following owner question, without rewriting |
| `Question` | Next unresolved owner question | Presented at most one at a time and byte-identically |
| `Example` | Owner-provided example | Preserved byte-identically when presented |
| `Next Action` | Owner-defined next step | Preserved as owner output and used for current activity |
| `Blocking Reason` | Owner-defined blocking explanation | Presented when the owner is blocked |

## Outcome Classification

| Class | Values | Meaning |
|---|---|---|
| User Exit | `pause`, `cancel`, `stop responding` | User ends the current interaction; no wizard state is persisted |
| Owner Outcome | `declined`, `aborted`, `blocked` | Owner workflow reports a non-terminal or blocked result; Setup does not label it as a user exit |
| Terminal Owner Result | `Complete`, applicable `Not Applicable` | Stage may advance or Setup may complete |
| Non-terminal Owner Result | `Missing`, `In Progress`, malformed, unknown | Setup remains at or blocks the active stage |

## Ownership Boundary

Owner artifacts, identifiers, catalogs, candidate state, and relationship state remain owned by Profile, Objectives, Controls, and NFR workflows. Setup may route responses and frame progress but cannot mutate these entities.

## State Transitions

```text
First incomplete owner
  -> Guided Setup at that owner
  -> one owner output/question turn
  -> terminal owner result -> next owner or Complete
  -> User Exit -> end interaction with no wizard state
  -> Owner Outcome -> pause/report at active owner
  -> malformed/unknown -> deterministic Setup Blocked result
```
