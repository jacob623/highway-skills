# Quickstart: Profile Collaboration Convergence

This guide validates the development-time Profile convergence behavior without changing Profile save behavior or retained schema.

## Prerequisites

- Run from the repository root.
- Use the repository's existing Bash 3.2-compatible toolchain.
- Keep generated agent adapters synchronized with `.highway/skills/highway-profile/SKILL.md`.

## Focused validation

Run the new fixture evaluation and the existing Profile contracts:

```sh
bash .highway/tools/tests/profile-convergence-behavior.test.sh
bash .highway/tools/tests/profile-behavior.test.sh
bash .highway/tools/tests/profile-context-contract.test.sh
bash .highway/tools/tests/profile-lifecycle.test.sh
bash .highway/tools/tests/profile-runtime-separation.test.sh
```

Expected result: every command exits zero. The behavioral fixture command reports all eight required categories and fails on any applicable hard governance violation.

## Generated artifacts

After changing the source Profile skill, regenerate adapters:

```sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-catalog.sh
```

The four Profile adapters must compare byte-for-byte with the source after generation.

## Full validation

Run the complete development validation workflow:

```sh
.highway/tools/tests/run-all.sh
```

Expected result: the suite exits zero, including the eight behavioral fixture categories and all existing Profile persistence, readiness, migration, schema, adapter, and runtime-separation checks.

## Feature 144 validation result

The completed implementation reports `73 passed, 0 failed` from `.highway/tools/tests/run-all.sh`.
The resulting `highway-profile` version is `8.1.0`. Fixture validation remains development-only;
Profile saving does not invoke the fixture runner and the retained Profile schema remains unchanged.

## Contract expectations

Refer to [profile-behavioral-evaluation.md](contracts/profile-behavioral-evaluation.md) for fixture fields, required categories, rubric dimensions, and hard-failure rules. Refer to [data-model.md](data-model.md) for the transient-versus-retained boundary.
