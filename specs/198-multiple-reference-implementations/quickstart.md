# Quickstart: Multiple Reference Implementations

Validate this change after implementation. Do not treat this file as the implementation steps.

## Prerequisites

- Branch `198-multiple-reference-implementations`

## Confirm the records

1. Compare the architecture and implementation templates with [contracts/record-and-catalog-shape.md](contracts/record-and-catalog-shape.md).
2. Confirm the decision handoff has no implementation entry.
3. Confirm an architecture catalog row can list more than one current decision, and an implementation catalog can list more than one row for one architecture.

## Confirm the flow

1. Compare discovery and the ADR proposal with [contracts/decision-flow.md](contracts/decision-flow.md).
2. A wording resemblance does not surface an implementation.
3. The same exact option title uses the existing implementation and does not ask replace or beside.
4. A different option title asks that question once. The closing message suggests exactly one next step.

## Confirm the suite

Run `.highway/tools/validate-library.sh` on the six templates, `.highway/tools/validate-skill.sh` on the five skills, and `.highway/tools/tests/run-all.sh`. Each is expected to exit 0.
