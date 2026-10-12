# Feature 163 Quickstart: Objectives Deduplication Pass

## Prerequisites

Run from the repository root with the existing macOS-compatible shell toolchain.

## Focused ownership validation

Run the Feature 163 contract test:

```sh
bash .highway/tools/tests/feature-163-objectives-deduplication.test.sh
```

Expected result: the lifecycle is the sole owner of lifecycle mechanics, queue guidance is limited to queue ownership and a capture-boundary reference, Creation Workflow owns evidence evaluation, Recommendation Development owns grounding, Interpretation Confidence owns confidence, examples demonstrate output, and all adapters match the source.

## Existing Objective validation

Run the adjacent Objective contracts:

```sh
bash .highway/tools/tests/feature-159-objectives-advisory.test.sh
bash .highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh
```

Expected result: both existing contracts pass without changes to Objective behavior.

## Full validation

Run the complete repository suite:

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result: all checks pass with zero failures.

## Manual ownership checks

Inspect `.highway/skills/highway-objectives/SKILL.md` and confirm:

1. `### Objective Development Lifecycle` contains the complete lifecycle mechanics.
2. `## Objective Queue and Acceptance Boundaries` retains selection, queue membership, order, and the lifecycle capture-boundary reference only.
3. Creation Workflow remains focused on evidence evaluation and references the lifecycle for handoff.
4. Recommendation Development and Interpretation Confidence do not restate Objective lifecycle mechanics.
5. Examples demonstrate output without becoming alternative workflow definitions.

The four generated adapters must remain byte-identical to the source.
