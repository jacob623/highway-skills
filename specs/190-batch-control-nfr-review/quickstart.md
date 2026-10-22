# Quickstart: Batch Control and NFR Review

Validate this change after implementation. Do not treat this file as the implementation steps.

## Prerequisites

- Branch `190-batch-control-nfr-review`
- The Controls and NFRs skill sources are available for a manual pass

## Confirm the review

1. Read `.highway/skills/highway-controls/SKILL.md` and `.highway/skills/highway-nfrs/SKILL.md`. Confirm a request to review the queue shows every queued item in one message.
2. Confirm each item uses the shape in [contracts/batch-review.md](contracts/batch-review.md), with a horizontal rule only between items.
3. Confirm the singular headings, the coverage bridges, and "Next we'll develop" are absent from both skills.
4. Confirm neither review contains **Success looks like:**.
5. Confirm a stored active catalog uses the same card and still asks what to add, correct, or remove.

## Confirm the write

1. Confirm one acceptance stores every remaining item and does not ask the person to review the written records.
2. Confirm the stored statement and rationale are the review text named in [data-model.md](data-model.md).
3. Confirm a successful write adds no closing line.

## Confirm the suite

Run `.highway/tools/tests/run-all.sh` from the repository root. The expected result is exit 0.

Run `.highway/tools/validate-skill.sh` on `.highway/skills/highway-controls` and `.highway/skills/highway-nfrs`. Each exits 0.
