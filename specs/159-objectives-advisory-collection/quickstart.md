# Quickstart: Objectives Advisory Collection

## Prerequisites

Run from the repository root with macOS Bash 3.2-compatible shell tools. The repository must have
the `.highway/` tree and generated agent adapters.

## Focused validation

Run the Feature 159 contract test:

```sh
bash .highway/tools/tests/feature-159-objectives-advisory.test.sh
```

Expected result: support wording, correction-oriented review, grounded advisory limits, portfolio
authority, sequential queue behavior, unresolved Success gating, recommendation lifecycle,
exhaustion/future-suggestion wording, preserved owner contracts, and generated adapter equality all
pass.

Run the existing Objective owner and persistence regression test:

```sh
bash .highway/tools/tests/objective-management.test.sh
```

Expected result: existing readiness, record, catalog, identifier, overlap, atomicity, and
non-write fixture checks remain passing.

## Full validation

Regenerate adapters using the repository's established generator, then run:

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result: the full repository verification suite passes with no adapter drift or unrelated
regression.

## Manual review scenarios

1. Present an Objective proposal and verify the only emphasized review element is
   `What would you add, correct, or remove?` or a sharper correction-oriented question.
2. Select several recommendations and verify the first item completes required Success handling
   before the next item begins.
3. Ask for more recommendations after broad coverage and verify grounded exhaustion explanation,
   user-authored continuation, and explicit future suggestion availability.
4. Confirm that accepted Objective records and catalogs retain their existing paths and mutation
   fields; queue and portfolio assessment content must not be persisted as Objective records.