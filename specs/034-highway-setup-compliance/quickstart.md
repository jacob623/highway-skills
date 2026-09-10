# Feature 034 Quickstart

## Prerequisites

- Run from the repository root.
- Bash 3.2-compatible shell is available.
- Feature 033's `highway-setup` skill and focused test are present.
- Existing catalog, adapter, distribution, and validator tools are available.

## Baseline

Run the existing suite before the first Feature 034 behavioral edit:

```sh
.highway/tools/tests/run-all.sh
```

Expected result: exit status 0. Record the result separately from Feature 034 routing coverage.

## Behavioral Fixture Validation

Run the focused Feature 034/Feature 033 verification:

```sh
PATH=/usr/bin:/bin:/usr/sbin:/sbin bash .highway/tools/tests/highway-setup.test.sh
```

The enhanced fixture suite must execute and report:

- ordered Profile -> Objectives -> Controls -> NFR readiness events;
- the first owner route for each incomplete readiness state;
- continuation after successful owner results;
- no downstream calls after declined, failed, malformed, or incomplete results;
- `NFRs: Missing` before proposal invocation and `NFRs: In Progress` while awaiting acceptance;
- byte-for-byte complete, objective-missing, and pending-NFR dashboards;
- zero owner calls and unchanged artifact hashes on complete-state reruns.

## Routing Coverage

Score the 20 rows in [routing-matrix.md](contracts/routing-matrix.md):

```text
routing coverage = passing rows / 20
```

Expected result: at least `19 / 20` (95%). Report the numerator, denominator, and percentage separately from the suite exit status.

Observed during Feature 034 implementation: 20/20 rows passed (100%).

## Ownership Review

Complete [ownership-review.md](contracts/ownership-review.md) with one evidence-backed outcome for O-001 through O-006. A full compliance claim requires all six outcomes and no unresolved exception.

## Contract and Repository Validation

Compare fixture output byte-for-byte with [dashboard-output.md](contracts/dashboard-output.md), then run:

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-setup
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/run-all.sh
git diff --check
```

After any source skill or metadata change, regenerate the declared catalogs and adapters before the final suite run. Report these categories separately:

1. Executable suite results.
2. Routing coverage.
3. Requirement coverage.
4. Manual ownership review.

## Feature 034 Evidence Record

- Executable checks: focused setup test passed; `validate-skill.sh` passed.
- Routing coverage: 20/20 rows passed (100%); threshold was 19/20 (95%).
- Requirement coverage: FR-001 through FR-012 each appear exactly once in `coverage.md`.
- Manual ownership review: O-001 through O-006 reviewed and recorded as PASS in `contracts/ownership-review.md`.
