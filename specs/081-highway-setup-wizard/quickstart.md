# Feature 081 Quickstart

## Prerequisites

- Repository root: `/Users/jacoblong/Documents/wayfinder/highway/highway-skills`
- Bash 3.2.57-compatible shell
- Existing `.highway/` tree and test fixtures
- No `.specify/extensions.yml` hooks are required

## Focused Static and Executable Validation

From the repository root, run:

```sh
bash .highway/tools/tests/highway-setup.test.sh
bash .highway/tools/tests/highway-setup-executable.test.sh
```

Expected outcome: both commands exit `0` and verify the active Guided Setup contract, fixed owner ordering, one-question forwarding, terminality routing, malformed-response blocking, no downstream advance, readiness-based resume, owner-byte preservation, and completion behavior.

## Full Suite Validation

```sh
.highway/tools/tests/run-all.sh
```

Expected outcome: the full suite exits `0`.

## Manual Scenario Matrix

| Scenario | Starting readiness | Expected result |
|---|---|---|
| Fresh setup | Profile incomplete | Step 1 asks the owner-provided Profile question. |
| Profile completion | Profile returns `Complete` | Setup advances automatically to Objectives. |
| Not applicable | Owner returns applicable `Not Applicable` | Stage is terminally successful and Setup advances. |
| Multi-turn collection | Owner returns `In Progress` with a question | One question is shown; Setup waits for one response. |
| Blocked owner | Owner returns `Blocked` | Setup pauses, reports reason/action, and does not call later owners. |
| Malformed response | Unknown or invalid owner status | Setup reports `Setup: Blocked` and does not assume completion. |
| Interruption | User stops or cancels mid-stage | Next invocation re-reads readiness and resumes the first incomplete owner. |
| Full completion | All four stages terminally successful | Setup emits `Highway Setup Complete` and the existing dashboard. |

Pause and cancellation are transient interaction outcomes: Setup creates no cancellation marker or separate Setup checkpoint.

## Requirement Evidence

- FR-009A: verify numeric step mapping in [setup-wizard.md](contracts/setup-wizard.md).
- FR-013A: verify the terminality decision table in [setup-wizard.md](contracts/setup-wizard.md).
- FR-018 and SC-001 through SC-009: use the focused tests and full suite results, then report test results separately from requirement coverage.
