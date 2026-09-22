# Clarification Catalog Contract

## Scope

This contract defines the Phase 1 catalog behavior exposed by `highway-clarify`. It does not add a new command and does not change Discovery or clarification analysis.

## Inputs

- One exact supported artifact identifier: `REQ######`, `DISC######`, `ADR######`, or `RA######`.
- The resolved source artifact and its existing or newly generated clarification artifact.
- `.highway/library/templates/output/clarification-catalog.md`.
- `clarifications/clarifications.md` when present.

## Outputs

- Generate creates or updates the colocated `<ARTIFACT-ID>-clarification.md` artifact.
- Generate and Update create or update `clarifications/clarifications.md`.
- The catalog contains one row with Clarification ID, Artifact ID, Artifact Type, and Status.
- Catalog rows are ordered by Artifact Type and then Artifact ID.
- Read-only Inspect, Read, and Status operations do not write the catalog.

## Generate Contract

For `/highway-clarify REQ000123` and equivalent supported identifiers:

1. Validate and resolve the exact source identifier.
2. Derive `CLAR-REQ000123`.
3. Validate or generate the clarification artifact.
4. Validate the existing catalog, if present.
5. Create or replace the one matching catalog row.
6. Validate the complete catalog structure and deterministic ordering.
7. Commit the clarification artifact and catalog only after all validation succeeds.

If the catalog is absent, create it with the first entry.

## Update Contract

For `/highway-clarify update REQ000123` and equivalent supported identifiers:

- Apply the existing clarification Update rules and status transition.
- Update the matching catalog row in the same successful transaction.
- Mirror the final clarification status in the catalog.
- Preserve revision conflict behavior and no-write failure behavior already defined by `highway-clarify`.

## Validation Contract

Reject and do not commit when any condition holds:

- The catalog is malformed or missing required columns.
- A Clarification ID, Artifact ID, or clarification artifact mapping is duplicated.
- An entry uses an unsupported artifact type or status.
- A catalog entry references a missing clarification artifact.
- A clarification artifact is absent from the catalog after successful maintenance.
- Catalog status differs from clarification status.
- Catalog or clarification validation or writing fails.

Failure preserves the pre-operation catalog and clarification bytes.

## Non-Goals

- Discovery does not consume this catalog in Phase 1.
- ADR behavior is unchanged.
- Findings, responses, revision history, clarification content, analysis ordering, and scoring are unchanged.
