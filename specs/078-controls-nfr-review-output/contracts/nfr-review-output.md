# NFR Review Output Contract

## Populated review

The canonical NFR skill emits one entry per candidate. Every entry contains:

- `Candidate Title`
- `Candidate Statement`
- `Candidate Rationale`
- `Originating Control Identifier`
- `Originating Control Title`
- `Available Decisions: Accept, Modify, Replace, Reject`

Candidate order remains stable through review and repeated renders. Identical inputs produce identical ordering based on persisted Control identifier and availability, security, performance derivation order.

## Empty review

When no NFR candidates exist, NFR Review emits exactly:

- `Status: Empty`
- `Entry Count: 0`

This output creates no placeholder governance artifact.

## Readiness and duplicate-failure boundaries

Only successful NFR `Review Complete` outcomes are reflected by later readiness evaluation. Cancellation, rejection, validation failure, allocation failure, duplicate-detection failure, and write failure leave readiness-consumed accepted artifact state unchanged.

Existing NFR duplication is detected before NFR creation and identifier allocation. Duplicate-detection failure preserves candidate, NFR, catalog, and relationship state and performs no partial NFR write.
