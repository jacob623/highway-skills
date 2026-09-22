# Research: Clarification Catalog (Phase 1)

## Decision 1: Use a shared Markdown output template

- **Decision**: Add `.highway/library/templates/output/clarification-catalog.md` as the complete structural authority for `clarifications/clarifications.md`.
- **Rationale**: Existing Highway catalog-backed artifacts use shared output templates, and the active constitution requires file-emitting skills to cite a complete shared template under P9.1. The Clarify skill should retain workflow behavior while delegating catalog shape to the template.
- **Alternatives considered**: Keeping the catalog layout only in `highway-clarify` was rejected because it creates a second structural authority. A generated JSON catalog was rejected because the requested artifact and existing catalog conventions are Markdown.

## Decision 2: Preserve the existing clarification identity and status authority

- **Decision**: Derive `CLAR-<ARTIFACT-ID>` from the validated source identifier and mirror the status already recorded by the clarification artifact.
- **Rationale**: `highway-clarify` already defines supported identifier families, stable clarification identity, and status derivation. The catalog adds lookup and inventory without changing clarification analysis or content ownership.
- **Alternatives considered**: Allocating a separate catalog identifier was rejected because it would introduce a second identity. Deriving status independently from catalog rows was rejected because it could create drift from the clarification artifact.

## Decision 3: Order catalog entries by artifact type and artifact ID

- **Decision**: Normalize all valid rows and sort by Artifact Type, then Artifact ID, before rendering the catalog.
- **Rationale**: This is the feature's explicit deterministic ordering rule and avoids filesystem, creation-time, modification-time, or environment-dependent ordering.
- **Alternatives considered**: Sorting by Clarification ID alone was rejected because the requested contract names artifact type and then artifact ID. Filesystem order and creation order were rejected as nondeterministic sources.

## Decision 4: Validate before mutation and preserve bytes on failure

- **Decision**: Validate source clarification state and existing catalog structure before writing; update the clarification and catalog only after both intended outputs are valid, with failure paths preserving pre-operation bytes.
- **Rationale**: The feature explicitly requires no catalog update after clarification failure, and malformed catalog or catalog write failures must preserve bytes. Existing Clarify behavior already guarantees no partial output for validation and write failures.
- **Alternatives considered**: Appending a row before validating the full catalog was rejected because it can preserve duplicates or malformed state. Best-effort repair was rejected because malformed input must abort.

## Decision 5: Keep Phase 1 internal to Clarify

- **Decision**: Extend only the Clarify skill, its shared catalog template, focused validation, and generated adapters. Do not modify Discovery, ADR, analysis ordering, findings, or scoring.
- **Rationale**: The feature explicitly defers consumption and integration to Phase 2. Keeping ownership local reduces the change surface and preserves existing downstream behavior.
- **Alternatives considered**: Updating Discovery to read the new catalog was rejected as an explicit non-goal. Adding a general catalog service was rejected because the repository uses file contracts and no external service boundary is required.
