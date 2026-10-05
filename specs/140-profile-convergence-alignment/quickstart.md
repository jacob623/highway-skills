# Quickstart: Profile Convergence Alignment

## Prerequisites

- Run from the repository root on branch `140-profile-convergence-alignment`.
- Bash and the existing Highway test tools are available.

## Focused validation

Run the Feature 140 contract test after implementation:

```sh
bash .highway/tools/tests/feature-140-profile-convergence-alignment.test.sh
```

Expected result: the test reports the Profile convergence, reciprocal-development, provisional-structure, domain-specific validation, ownership, and preservation checks as passing.

## Generated adapter validation

Regenerate the distributed agent adapters using the repository's existing generator, then verify the source and adapters are identical:

```sh
bash .highway/tools/generate-agent-adapters.sh
git diff --check
```

The generator must leave the four Profile adapters corresponding to `.highway/skills/highway-profile/SKILL.md`.

## Full validation

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result: the full suite passes with zero failures. No changes should appear in `profile-record.md`, the Constitution, Experience Standard, Highway Identity, setup, Objectives, or downstream owner artifacts.