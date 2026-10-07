# Quickstart: Constitution Runtime Boundary

This feature changes the Highway Skills Constitution and its development-time validation expectations. It does not change runtime skills or the Experience Standard.

## Prerequisites

- Run from the repository root.
- Use the existing Bash-compatible development toolchain.
- Keep the current worktree changes and protected runtime files intact.

## Focused validation

Run the Constitution-specific checks after editing `.highway/governance/constitution.md`:

```sh
bash .highway/tools/tests/constitution-inventory.test.sh
bash .highway/tools/tests/constitution-experience-alignment.test.sh
bash .highway/tools/tests/constitution-profile-context.test.sh
bash .highway/tools/tests/coverage-summary.test.sh
bash .highway/tools/tests/rule-checks.test.sh
```

Expected result: all checks pass with the revised version, rule inventory, tier coverage, Experience Compliance boundary, context declarations, and self-application expectations.

## Dependency and stale-reference audit

Search the repository for downstream references without editing them as part of this feature:

```sh
rg -n 'common failure model|highway-vision\.md|highway-platform-objectives\.md|runtime governance|runtime precedence|Active Reasoning Context|Collaborative Knowledge Development' .highway specs
```

Expected result: the Constitution has no stale current runtime-governance dependencies; remaining downstream references are recorded as follow-up work and are not hidden by duplicating runtime contracts in Layer 1.

## Protected-file check

```sh
git diff --name-only -- .highway/governance/experience-standard.md .highway/library/knowledge/highway-identity.md .highway/skills
```

Expected result: no files are listed for this feature.

## Full validation

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result: the full development suite passes, including Constitution inventory, coverage, rule checks, Experience alignment, context checks, and the existing downstream tests. Any failures caused by downstream runtime references are reported as follow-up migration work rather than fixed by changing protected skills in this feature.
