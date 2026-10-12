# Feature 161 Quickstart

## Prerequisites

- Run from the repository root: `/Users/jacoblong/Documents/wayfinder/highway/highway-skills`.
- Use the repository's existing macOS-compatible Bash toolchain.
- No new dependency installation is required.

## Validate the design artifacts

```sh
.specify/scripts/bash/check-prerequisites.sh --json --paths-only
jq -e . .specify/feature.json >/dev/null
```

Expected result: the active feature directory is `specs/161-objectives-synthesis-lifecycle` and the feature pointer is valid JSON.

## Validate the source contract after implementation

```sh
bash .highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh
bash .highway/tools/tests/feature-160-objectives-structural-refinement.test.sh
bash .highway/tools/tests/feature-159-objectives-advisory.test.sh
bash .highway/tools/tests/objective-management.test.sh
```

Expected result: the Feature 161 lifecycle contract passes, generated adapters match the source, and the existing Objective behavior remains compatible.

## Validate the complete repository

```sh
bash .highway/tools/tests/run-all.sh
```

Verified result: the focused Feature 161 contract, Feature 160 structural refinement, Feature 159 advisory, Objective management, and full repository suites pass; the full suite reports 85 passed and 0 failed.

## Manual review scenarios

1. With accepted Profile evidence supporting an Objective and likely measures, confirm the owner presents a title, statement, proposed Success Measures, and synthesized Rationale before discovery.
2. Select multiple recommendations and confirm they enter an ordered active queue without capture; process only the current item through proposal, one review, and capture before the next item.
3. Remove or modify proposed measures and confirm the correction remains authoritative and stale staged content is not captured.
4. Remove proposal support or introduce consequential ambiguity and confirm the owner uses focused discovery only for the unresolved information.
