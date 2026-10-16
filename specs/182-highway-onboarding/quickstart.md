# Quickstart: Highway Onboarding

## Validate the design

From the repository root:

```bash
.specify/scripts/bash/check-prerequisites.sh --json
.specify/scripts/bash/validate-clarifications.sh specs/182-highway-onboarding/spec.md
```

## Exercise the workflow

1. Run `/highway-onboarding` with no arguments.
2. Confirm the first response is one concise summary of accepted Profile, Objective, Control, NFR, ADR, Architecture, and Implementation coverage.
3. Review proposed capabilities and answer `What would you add, correct, or remove?` with a correction, removal, or uncertainty.
4. Accept one capability and provide multiple platform/process mappings, including an explicit unknown if needed.
5. Review one grouped provider proposal and correct its rationale or alternatives before accepting it.
6. Verify `highway-onboarding` creates a normal ADR directly from the shared ADR record and catalog templates with `request: onboarding` and `discovery: highway`, without a synthetic Discovery record.
7. Verify Architecture runs only after onboarding ADR persistence, and Implementation only after Architecture persistence.
8. Force a downstream owner failure and verify three attempts, a stopped handoff, preserved earlier identifiers, and resume from the failed owner.

## Implementation validation

After `/speckit-implement`, run the focused onboarding and ADR tests, generated correspondence checks, then the complete suite:

```bash
.highway/tools/tests/highway-onboarding.test.sh
.highway/tools/tests/highway-adr.test.sh
.highway/tools/tests/run-all.sh
```

The exact focused test names may be finalized by `/speckit-tasks` while preserving the scenarios above.
