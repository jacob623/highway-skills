# Quickstart: Batch Objective Acceptance

Validate this change after implementation. Do not treat this file as the implementation steps.

## Prerequisites

- Branch `189-batch-objective-acceptance`
- The objectives skill source and a readable accepted profile are available for a manual pass

## Confirm the review

1. Read `.highway/skills/highway-objectives/SKILL.md` and confirm a request to review the queue shows every queued objective in one message.
2. Confirm each objective uses the shape in [contracts/batch-review.md](contracts/batch-review.md), with a horizontal rule only between objectives.
3. Confirm the one-at-a-time heading, the coverage bridge, and "Next we'll develop" are absent.
4. Confirm the stored-objective review still shows an existing catalog and still asks what to add, correct, or remove.

## Confirm the write

1. Confirm one acceptance stores every remaining objective and does not ask the person to review the written records.
2. Confirm the stored statement, success measures, and rationale are the review text named in [data-model.md](data-model.md).
3. Confirm a successful write adds no closing line about viewing the objectives later.

## Confirm the suite

Run `.highway/tools/tests/run-all.sh` from the repository root. The expected result is exit 0.

Run `.highway/tools/validate-skill.sh` on `.highway/skills/highway-objectives`. The expected result is exit 0.
