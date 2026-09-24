# Feature 086 Quickstart

## Prerequisites

Run from the repository root on macOS or a GNU-like environment with Bash 3.2-compatible scripts. No new dependency is required.

## Focused validation

```sh
.highway/tools/tests/highway-setup.test.sh
bash .highway/tools/tests/highway-setup-executable.test.sh
```

Expected result: both focused tests exit 0. Any malformed, declined, or aborted fixture diagnostics are expected probes when reported by the fixture harness.

## Full validation

```sh
.highway/tools/tests/run-all.sh
```

Expected result: the full Highway test suite exits 0.

## Manual contract review

1. Read `.highway/skills/highway-setup/SKILL.md` and verify that input-required collection has a welcome or resume greeting, active owner introduction, preserved owner context, and the owner question in order.
2. Verify routine collection excludes the closed prohibited vocabulary and readiness, stage-selection, owner-selection, and orchestration explanations.
3. Verify explicit status, blocked, declined, and aborted outcomes use the Explicit Status Contract only when applicable.
4. Verify successful completion uses the Completion Dashboard instead of the Explicit Status Contract and emits no collection question.
5. Verify owner questions and informational content remain owner-owned and are not reordered or fabricated.
6. Verify readiness order, terminality, safe-stop behavior, and completion destinations remain unchanged.

## Evidence map

- `contracts/setup-verification-output.md` defines the collection, status, completion, and prohibited-vocabulary contract.
- `data-model.md` records verification states, transitions, relationships, and invariants.
- `highway-setup.test.sh` checks static wording and vocabulary obligations.
- `highway-setup-executable.test.sh` checks deterministic opening, status, stop, and completion behavior.
