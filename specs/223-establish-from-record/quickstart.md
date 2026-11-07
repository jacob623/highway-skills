# Quickstart: Establish From Record

## Prerequisites

- Repository root with `.highway/`.
- Bash 3.2 or later.

## Static check

```bash
bash .highway/tools/tests/establish-from-record.test.sh
```

Expected: `PASS: establish reads the record and a platform standard has two entries`

The test checks [contracts/execution.md](contracts/execution.md), [contracts/proposal.md](contracts/proposal.md), and [contracts/platform-entries.md](contracts/platform-entries.md), the rejected fallback, and the versions.

## Full suite

```bash
bash .highway/tools/tests/run-all.sh
```

Expected: `Summary: 78 passed, 0 failed`

## Validation

```bash
bash .highway/tools/validate-skill.sh .highway/skills/highway-implementation
bash .highway/tools/validate-skill.sh .highway/skills/highway-codify
bash .highway/tools/validate-skill.sh .highway/skills/highway-codify-config
bash .highway/tools/validate-skill.sh .highway/skills/highway-onboarding
```

## Walkthrough

1. Propose an implementation while the catalog has a pipeline and a self-service platform. Deployed by is the pipeline. Managed by is the self-service platform. Language is the standard whose Technology the technology choice names, or None.
2. Replace a platform with a name that has no row. The proposal waits for configuration or onboarding, then returns.
3. Propose establish. The executor is Deployed by. A task may name another platform or method.
4. Propose a run. The executor is Managed by.
5. Add a coding standard whose Technology is a platform title. When to use is `[Platform] is used`. When not to use is `[Platform] is not used`.
