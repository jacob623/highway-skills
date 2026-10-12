# Feature 162 Quickstart: Objectives Lifecycle Canonicalization

## Prerequisites

Run from the repository root with the existing macOS-compatible shell toolchain.

## Focused validation

Run the Objective lifecycle contract test:

```sh
.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh
```

Expected result: the source skill contains one canonical Objective Development Lifecycle, uses User Acceptance before capture, references the canonical proposal from queue guidance, rejects preliminary/double-review interpretations, and all four adapters match the source.

## Full validation

Run the repository suite:

```sh
.highway/tools/tests/run-all.sh
```

Expected result: all repository checks pass with zero failures.

## Manual document checks

Inspect `.highway/skills/highway-objectives/SKILL.md` and confirm:

1. The lifecycle begins with `Recommendation Selected or User Provided Objective`.
2. The only canonical proposal field list contains title, statement, proposed Success Measures, and synthesized Rationale.
3. The sequence uses `Present Converged Objective proposal`, `User Acceptance`, `Capture`, and `Next Objective`.
4. Queue processing references the lifecycle and says an item is accepted and captured before the next item.
5. The anti-pattern does not make a preliminary Objective or review a separate lifecycle stage.

The generated adapters must remain byte-identical to the source.
