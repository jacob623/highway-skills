# Feature 091 Quickstart

## Prerequisites

Run from the repository root on macOS or a POSIX-like shell. No network service or external dependency is required.

## Focused validation

```sh
bash .highway/tools/tests/profile-behavior.test.sh
bash .highway/tools/tests/highway-setup.test.sh
bash .highway/tools/tests/readiness-ownership.test.sh
```

Expected result: each command exits zero and reports its contract as passing. During implementation,
these focused tests are updated to assert Markdown Profile paths, five domain outcomes, proposal versus
accepted state, Setup resume routing, and template authority.

## Full validation

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result: all discovered tests pass, with no generated-artifact or disposable-fixture residue.

## Manual contract checks

1. Start Setup with no Profile and verify the first question is Identity and no artifact is created.
2. Accept a complete proposal and verify `.highway/library/knowledge/profile.md` exists, validates, and produces `Status: Complete`.
3. Interrupt first-time Setup and verify no Profile is created; interrupt Configure on an incomplete accepted Profile and verify its bytes are unchanged.
4. Remove the last Discussed evidence and verify the preview transitions to `not_discussed` and readiness becomes `Missing`.
5. Run constitutional and Experience Standard compliance checks after the governance amendment and identity synchronization.

See [data-model.md](data-model.md) for state invariants and the contract files for exact output shapes.
