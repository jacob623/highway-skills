# Quickstart: Unified Recommendation Exploration Refactor

## Prerequisites

- Run from the repository root.
- macOS Bash 3.2 compatibility must be preserved.
- The authoritative Objective and Control skills must be available under `.highway/skills/`.

## Focused Contract Validation

Run the existing owner checks:

```sh
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
bash .highway/tools/tests/feature-159-objectives-advisory.test.sh
bash .highway/tools/tests/feature-160-objectives-structural-refinement.test.sh
bash .highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh
bash .highway/tools/tests/feature-163-objectives-deduplication.test.sh
bash .highway/tools/tests/feature-164-objective-portfolio-continuity.test.sh
bash .highway/tools/tests/feature-166-objective-archetypes.test.sh
bash .highway/tools/tests/objective-management.test.sh
bash .highway/tools/tests/highway-controls-onboarding.test.sh
bash .highway/tools/tests/control-derived-nfr.test.sh
```

Expected outcome: all focused Objective and Control contract checks pass, including lineage,
recommendation exploration, queue membership, proposal-first processing, acceptance, capture, and
continuation assertions.

## Generated Surface Validation

Regenerate source-derived surfaces:

```sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-instructions.sh
```

Then verify correspondence:

```sh
bash .highway/tools/tests/adapter-coverage.test.sh
bash .highway/tools/tests/generate-agent-adapters.test.sh
```

Expected outcome: all Objective and Control adapters match their authoritative sources and catalogs
contain no stale or orphaned entries.

## Full Regression Validation

```sh
.highway/tools/tests/run-all.sh

git diff --check
```

Expected outcome: the repository suite passes with zero failures and no whitespace errors.

## Behavioral Scenarios

1. Present several Objective recommendations, select some, request another set, and verify the
   active Objective queue grows while exploration remains active and processing has not started.
2. Present Control recommendations grounded in accepted Objectives, select some, request another
   set, and verify the active Control queue grows without automatic Control capture.
3. Exhaust useful recommendations or explicitly request queue processing, then verify processing
   begins and recommendation exploration remains closed until the queue is complete.
4. Return `Collection Result: Continue` after one recommendation set and verify another set can be
   explored without starting queue processing.
