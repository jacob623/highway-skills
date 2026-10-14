# Quickstart: Recommendation Exploration Simplification Pass

## Prerequisites

- macOS with the repository's default shell utilities.
- Repository root at `/Users/jacoblong/Documents/wayfinder/highway/highway-skills`.
- Feature 174 source edits made only under `.highway/skills/` before regeneration.

## Validate the recommendation contracts

From the repository root, run the focused owner contract checks after implementation:

```sh
.highway/tools/tests/highway-controls-onboarding.test.sh
.highway/tools/tests/feature-159-objectives-advisory.test.sh
.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh
```

The implementation should also add or amend focused assertions for all three owners so that they
verify the review-of-selected-artifacts wording, thin Creation Workflow, preserved internal queue
boundary, and absence of user-facing queue-processing commands.

## Regenerate derived surfaces

Run the existing generators from the repository root:

```sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-instructions.sh
```

Do not hand-edit generated adapters or catalogs. Confirm that rerunning the generators leaves no
unexpected source-to-generated drift.

## Run the complete validation suite

```sh
.highway/tools/tests/run-all.sh
git diff --check
```

Expected result:

- Every repository test passes.
- Each owner has explicit review-intent language for selected artifacts.
- No user-facing workflow example instructs the person to process or capture a queue.
- Creation Workflow contains routing only and retains the canonical no-recommendation path.
- Generated adapters and catalogs correspond to the authoritative sources.
