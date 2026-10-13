# Feature 164 Quickstart: Objective Portfolio Continuity

## Prerequisites

Run from the repository root with the existing macOS-compatible shell toolchain.

## Focused continuity validation

Run the Feature 164 contract test:

```sh
bash .highway/tools/tests/feature-164-objective-portfolio-continuity.test.sh
```

Expected result: queued, collection, and setup transitions contain optional post-capture synthesis guidance; synthesis is advisory and concise; existing lifecycle and collection boundaries remain intact; and all generated adapters match the source.

## Existing Objective validation

Run the adjacent Objective contracts:

```sh
bash .highway/tools/tests/feature-159-objectives-advisory.test.sh
bash .highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh
bash .highway/tools/tests/objective-management.test.sh
```

Expected result: existing Objective ownership, lifecycle, persistence, and readiness contracts pass.

## Full validation

Run the complete repository suite:

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result: all checks pass with zero failures.

## Manual continuity checks

Inspect `.highway/skills/highway-objectives/SKILL.md` and confirm:

1. Portfolio assessment guidance allows a concise post-capture coverage synthesis.
2. The queued example can identify the next Objective after synthesis.
3. Collection continuation preserves additional-suggestions reassurance and the continuation question.
4. Setup transition can acknowledge accepted coverage before safeguards or the next activity.
5. Synthesis is optional, advisory, post-capture, and not a second review, proposal, recommendation set, or detailed portfolio assessment.
