# Quickstart: Completion Claim Accountability

**Feature**: 021-completion-claim-accountability

Run from the repository root. These scenarios use temporary fixtures and must not edit completed
feature directories.

## Prerequisites

```bash
.highway/tools/tests/run-all.sh
```

Expected: the baseline suite passes before the new validation check is enabled.

## 1. Validate complete coverage

Create a temporary feature fixture containing `spec.md` with three requirement IDs and
`coverage.md` with one entry for each ID. Run the feature coverage check.

Expected: the check passes and reports every requirement exactly once.

## 2. Prove missing and duplicate IDs fail

Remove one coverage entry and run the same check. Restore it, then duplicate a different entry and
run the check again.

Expected: the first run names the missing ID; the second names the duplicate ID. Restore the valid
fixture after each proof.

## 3. Prove satisfied and deferred outcomes remain distinct

Mark one requirement `satisfied` with an existing artifact path and another `deferred` with a
follow-up reason.

Expected: the record is structurally valid, but a completion report is qualified rather than
unqualified complete.

## 4. Prove task correspondence review

Create one completed task naming an artifact containing its described change and one completed task
naming a missing path. Review both against the task-accountability contract.

Expected: the accurate task passes; the missing-path task fails and names the path. No task checkbox
is changed automatically.

## 5. Prove red-to-green evidence

Record a behavior-specific failing observation for a static prose-contract test, then record its
passing result after the fixture is updated.

Expected: the evidence is accepted. Remove the failing observation and rerun the review.

Expected: the task is no longer eligible for completion even though the passing result remains.

## 6. Pre-enable evaluation

Run the proposed D7.2 coverage check against every existing completed feature without adding
synthetic coverage records.

Expected: each feature receives a recorded verdict. Features without a coverage record are reported
as missing coverage rather than silently passing or being rewritten.

## 7. Final validation

```bash
.highway/tools/tests/completion-coverage.test.sh
.highway/tools/tests/run-all.sh
```

Expected: the existing suite remains green, D7.2 has one Enforcement Map entry, and the final
completion report separates check results from requirement coverage.

The coverage test emits `PRE_ENABLE` verdicts for historical completed features. Missing historical
coverage is reported explicitly and is not silently fabricated.
