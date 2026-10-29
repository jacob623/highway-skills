# Quickstart: ADR Record Completeness

Validate this change after implementation. Do not treat this file as the implementation steps.

## Prerequisites

- Branch `197-adr-record-completeness`

## Confirm the templates

1. Compare `.highway/library/templates/output/adr-record.md` with [contracts/adr-record-shape.md](contracts/adr-record-shape.md).
2. Confirm `adr-catalog.md` allows `accepted`, `superseded`, and `removed`, and that a superseded row keeps its file.

## Confirm the writers

1. `highway-adr` writes Problem, Forces, Decision Scope, Revisit When, definitions, typed links, the chosen option as `Selected`, and both handoff ids as `None`.
2. `highway-onboarding` writes the same sections with the onboarding values from the contract, and sets each handoff id after that record is written.
3. `highway-architecture` and `highway-implementation` set only their handoff id, keep their own record when that update fails, and fill a missing id on re-invocation.

## Confirm the suite

Run `.highway/tools/validate-library.sh`, `.highway/tools/validate-skill.sh` on the four skills, and `.highway/tools/tests/run-all.sh`. Each is expected to exit 0.
