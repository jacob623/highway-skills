# Feature 039 Validation Guide

This guide validates completion-record enforcement locally without network access or new dependencies.

## Prerequisites

- Run from the repository root.
- macOS or Linux with the existing Bash-compatible shell utilities.
- The repository is restored after any temporary fixture mutation.

## 1. Establish the baseline

```text
.highway/tools/tests/run-all.sh
```

Observed baseline on 2026-09-10: the suite exits 0 before Feature 039 implementation begins.
The `highway-setup.test.sh` negative probes print expected `FAIL` lines while the enclosing test
reports `PASS`; those lines are part of the test's seeded-failure evidence.

## 2. Run the focused completion check

```text
.highway/tools/tests/completion-coverage.test.sh
```

Expected results after implementation:

- Every completed feature from 021 onward, plus Feature 020, is evaluated; Features 001-019 are reported as owned by Feature 040.
- Every evaluated feature uses `coverage.md` with `Requirement`, `Outcome`, and `Evidence`.
- Missing coverage, malformed outcomes, duplicate or unknown requirement IDs, missing evidence, and absent satisfying artifacts fail the check.
- A `historical` outcome in any feature numbered 021 or above fails the check.
- No informational `PRE_ENABLE` line remains for an unchecked feature.

## 3. Verify seeded failure behavior

The focused test must create disposable invalid states for missing records, malformed schemas,
unsupported outcomes, duplicate IDs, unknown IDs, missing evidence, and absent artifacts. Each
invalid state must produce a non-zero result; restoring the fixture must produce a zero result.

## 4. Verify correction history and identity

Inspect the generated coverage records and confirm that deferred rows identify their originating
requirement and superseding feature. Compare every feature directory name with its `Feature Branch`
field, including the reconciled Feature 036 path and the recorded Feature 033 choice.

## 5. Run the full suite

```text
.highway/tools/tests/run-all.sh
```

Expected result: all tests pass, including the completion check and feature-record checks.
Observed final result on 2026-09-10: 39 tests passed and 0 failed.

## Evidence boundaries

Static contract tests remain valid evidence for requirements about Markdown skill content. Runtime
or fixture behavior must be identified separately when a requirement claims behavior rather than
only document structure.
