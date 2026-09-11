# Feature 040 Validation Guide

This guide validates historical coverage reconstruction locally without network access or new
dependencies.

## Prerequisites

- Run commands from the repository root.
- Use macOS or Linux with the existing Bash-compatible shell utilities.
- Keep the repository restored after any disposable fixture mutation.

## 1. Establish the baseline

```text
.highway/tools/tests/run-all.sh
```

Expected result before implementation: the existing suite passes. Record the result before adding
historical records or changing the completion-check scope.

## 2. Validate the feature scope

Inspect the completed feature directories and confirm:

- Features 001, 002, and 004 through 019 receive new `coverage.md` files.
- Feature 020 retains its existing coverage record.
- Feature 003 remains excluded because it is incomplete.
- The new records contain 309 requirement rows in the verified historical scope.

## 3. Validate each coverage record

For every target record, compare its rows with the functional requirement identifiers in that
feature's `spec.md`.

```text
.highway/tools/tests/completion-coverage.test.sh
```

Expected results after implementation:

- Every completed feature from 001 onward is evaluated.
- Feature 003 is excluded.
- Each record uses exactly `Requirement`, `Outcome`, and `Evidence`.
- Each requirement appears once, with no unknown or duplicate identifiers.
- `satisfied` rows name existing artifacts.
- `deferred` rows name demonstrated correcting features.
- Remaining historical rows name carried-forward completion records.
- A `historical` row in Feature 021 or above fails.

## 4. Verify negative states

The focused test must create and restore disposable failures for missing records, malformed
headers or outcomes, missing evidence, duplicate identifiers, unknown identifiers, missing
identifiers, absent satisfying artifacts, and an out-of-range `historical` outcome. Each invalid
state must exit non-zero, and the restored fixture must pass.

## 5. Review outcome distribution

Count and report the `satisfied`, `deferred`, and `historical` rows across the reconstructed
records. Treat a predominantly `satisfied` distribution as a defect requiring evidence review,
not as a success criterion.

## 6. Run the full suite

```text
.highway/tools/tests/run-all.sh
```

Expected final result: exit 0 with all tests passing, including the widened completion check.

## Boundary checks

Confirm that no constitution, Experience Standard, or substantive completed spec file changed.
Only the permitted new coverage records and the completion-check scope should be part of the
implementation.
