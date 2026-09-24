# Feature 085 Quickstart

## Prerequisites

Run from the repository root on macOS or a GNU-like environment with Bash 3.2-compatible scripts.

## Focused validation

```sh
.highway/tools/tests/highway-setup.test.sh
.highway/tools/tests/highway-setup-executable.test.sh
```

Expected result: both commands exit 0 and report their setup contract as passing.

## Full validation

```sh
.highway/tools/tests/run-all.sh
```

Expected result: the full Highway test suite exits 0.

## Manual contract review

1. Read `.highway/skills/highway-setup/SKILL.md` and confirm input-required collection starts with a welcome or resume greeting, active owner introduction, and one owner question.
2. Confirm routine collection does not foreground progress stages or owner-selection and orchestration mechanics.
3. Confirm blocked, declined, aborted, and explicit status responses retain actionable owner context.
4. Confirm the completion dashboard remains byte-for-byte represented by the existing contract and still includes ownership destinations.
5. Confirm no new setup checkpoint, artifact store, or owner mutation path is documented.

## Requirement evidence

- `contracts/setup-output.md` defines the ordered conversational contract.
- `data-model.md` records presentation states and preserved owner relationships.
- `highway-setup.test.sh` checks the shipped skill document and forbidden narration vocabulary.
- `highway-setup-executable.test.sh` checks deterministic owner routing, stop behavior, resume behavior, and completion behavior.
