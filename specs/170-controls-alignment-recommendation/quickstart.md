# Quickstart: Controls Alignment Recommendation

## Prerequisites

Run from the repository root on macOS or a supported Linux shell:

```sh
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
```

The repository's existing Bash test harness and generators are the only required tooling.

## Baseline

Before implementation, confirm the suite is clean:

```sh
.highway/tools/tests/run-all.sh
```

Expected result: all registered tests pass with zero failures.

## Focused Contract Validation

After updating the authoritative Controls skill, run the focused onboarding and preserved downstream checks:

```sh
.highway/tools/tests/highway-controls-onboarding.test.sh
.highway/tools/tests/control-derived-nfr.test.sh
```

Validate that scenarios cover:

1. Grounded recommendations precede exploratory questions.
2. Single, multiple, and all selections create ordered development without capture.
3. User-authored safeguards remain available.
4. Proposal review contains title, statement, and rationale.
5. Capture follows explicit acceptance and owner capture.
6. Coverage-derived suggestions remain internal and subordinate to context-derived suggestions.
7. Continuation remains available after capture and explicit finish is the only terminal collection action.
8. Existing classification, persistence, relationship, and Control-derived NFR behavior remains intact.

## Derived Artifact Validation

Regenerate from the authoritative source using the repository's established generator workflow, then run:

```sh
.highway/tools/tests/generate-agent-adapters.test.sh
.highway/tools/tests/generate-catalog.test.sh
.highway/tools/tests/adapter-coverage.test.sh
```

Expected result: every generated adapter, catalog entry, manifest row, and distribution entry corresponds to the authoritative source, with no hand-edited drift.

## Full Validation

Run the complete suite:

```sh
.highway/tools/tests/run-all.sh
```

Expected result: zero failures. Static document-contract checks must be reported separately from executable behavior checks.

## Acceptance Evidence

The feature is ready when the full suite passes, generated artifacts are current, no Coverage Area is exposed as a user-facing workflow concept, and existing Control record and NFR behavior remains passing. The requirement coverage report must distinguish these claims from the raw test result.
