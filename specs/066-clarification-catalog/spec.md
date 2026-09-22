# Feature Specification: Clarification Catalog (Phase 1)

**Feature Branch**: `066-clarification-catalog`

**Created**: 2026-09-22

**Status**: Draft

**Input**: User description: "Introduce a Clarification Catalog to provide deterministic lookup of clarification artifacts by stable identifier, including a shared catalog template and catalog maintenance during clarification generation and updates."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Discover Clarifications by Stable Identifier (Priority: P1)

As a repository maintainer, I want a catalog of clarification identifiers and their linked artifacts so that I can deterministically find every clarification without scanning the filesystem.

**Why this priority**: Stable lookup and complete inventory are the primary value of the feature and establish the catalog contract used by future integrations.

**Independent Test**: Create a valid clarification artifact, generate the catalog, and confirm the catalog contains exactly one row with the derived clarification ID, artifact ID, artifact type, and current status.

**Acceptance Scenarios**:

1. **Given** a valid clarification for `REQ000001` does not have a catalog, **When** clarification generation succeeds, **Then** `clarifications/clarifications.md` is created from the clarification catalog structure and contains `CLAR-REQ000001` exactly once.
2. **Given** a catalog contains clarifications for multiple artifact types, **When** it is generated or updated, **Then** rows are ordered by artifact type and then artifact ID, independent of filesystem or creation order.
3. **Given** a clarification artifact already appears in the catalog, **When** that clarification is regenerated, **Then** its existing row is updated rather than duplicated.

### User Story 2 - Keep Catalog State Synchronized (Priority: P1)

As a repository maintainer, I want clarification status changes to update the catalog with the clarification so that lookup results remain accurate.

**Why this priority**: A catalog that lists stale status is misleading and cannot safely support later consumers.

**Independent Test**: Update a clarification from `in-progress` to `complete` or `blocked`, then confirm the artifact and catalog report the same status after the successful operation.

**Acceptance Scenarios**:

1. **Given** a catalog row reports an `in-progress` clarification, **When** a successful update changes the clarification to `complete`, **Then** the corresponding catalog row reports `complete`.
2. **Given** a clarification update fails validation or cannot be persisted, **When** the operation ends, **Then** neither the clarification artifact nor the catalog is changed.
3. **Given** a clarification uses an unsupported artifact type or status, **When** generation or update is requested, **Then** the operation is rejected before catalog creation or mutation.

### User Story 3 - Protect Catalog Integrity (Priority: P2)

As a repository maintainer, I want malformed, duplicate, or unwriteable catalog state to fail safely so that the catalog never silently loses or invents clarification mappings.

**Why this priority**: Catalog integrity is necessary for deterministic lookup and protects existing artifact records during maintenance.

**Independent Test**: Apply malformed, duplicate, missing-reference, and write-failure fixtures and verify that the operation reports failure while preserving the original catalog bytes.

**Acceptance Scenarios**:

1. **Given** a catalog contains duplicate clarification IDs or duplicate artifact mappings, **When** catalog maintenance runs, **Then** the operation aborts and preserves the catalog bytes.
2. **Given** a catalog entry references a clarification artifact that does not exist, **When** verification runs, **Then** the catalog is rejected and no successful catalog update is reported.
3. **Given** catalog writing fails after clarification validation, **When** generation or update completes, **Then** the clarification and original catalog remain unchanged.

### Edge Cases

- The catalog is absent when the first valid clarification is generated.
- A catalog has valid rows in a non-deterministic order and must be normalized.
- A catalog is malformed, has unsupported artifact types or statuses, or has missing required columns.
- A catalog contains duplicate clarification IDs, duplicate clarification artifact references, or duplicate artifact mappings.
- A clarification artifact is present without a catalog row, or a catalog row points to a missing artifact.
- The clarification status and catalog status disagree.
- The same valid input is processed repeatedly and must produce identical catalog content and ordering.
- Clarification validation, artifact persistence, or catalog persistence fails at any stage.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The repository MUST provide `.highway/library/templates/output/clarification-catalog.md` as the complete output skeleton for a Clarifications Catalog.
- **FR-002**: The catalog template MUST define the `Clarifications Catalog` document, version `1.0.0`, and a Clarification Index containing Clarification ID, Artifact ID, Artifact Type, and Status columns.
- **FR-003**: The repository MUST store the catalog at `clarifications/clarifications.md` when a catalog is present.
- **FR-004**: Clarification generation and update workflows MUST identify each clarification as `CLAR-<ARTIFACT-ID>` and MUST maintain one catalog row for the corresponding artifact.
- **FR-005**: Clarification generation MUST create the catalog and its first entry when the catalog is absent, and MUST append or update the corresponding entry when it exists.
- **FR-006**: Catalog entries MUST support only artifact types `REQ`, `DISC`, `ADR`, and `RA`.
- **FR-007**: Catalog entries MUST support only statuses `not-started`, `in-progress`, `complete`, and `blocked`.
- **FR-008**: Catalog status MUST match the status recorded by its clarification artifact after every successful generation or update.
- **FR-009**: Catalog rows MUST be ordered deterministically by Artifact Type and then Artifact ID, with no dependence on filesystem, creation-time, or modification-time ordering.
- **FR-010**: The catalog MUST contain exactly one row per clarification, MUST reject duplicate Clarification IDs, and MUST reject duplicate mappings to the same clarification artifact or artifact ID.
- **FR-011**: Verification MUST confirm that every clarification artifact appears exactly once in the catalog and that every catalog entry references an existing clarification artifact.
- **FR-012**: Verification MUST confirm that clarification and catalog statuses agree and that repeated identical inputs produce identical catalog ordering.
- **FR-013**: A malformed catalog MUST cause maintenance to abort while preserving its original bytes.
- **FR-014**: A catalog write failure MUST abort the operation while preserving the original catalog bytes and clarification artifact bytes.
- **FR-015**: Clarification generation or update failure MUST prevent any catalog update.
- **FR-016**: Clarification inputs MUST include the clarification catalog template and the repository catalog artifact when present; clarification outputs MUST include the maintained catalog.
- **FR-017**: The feature MUST not modify Discovery, make Discovery consume Clarifications, change Clarification findings or analysis order, or add Clarification-derived scoring.

### Key Entities *(include if feature involves data)*

- **Clarification Catalog Template**: The shared output skeleton defining the catalog document and required index columns.
- **Clarification Catalog**: The repository artifact that inventories clarification IDs, linked artifact IDs, artifact types, and statuses.
- **Clarification Artifact**: The authoritative record containing clarification content, findings, responses, revision history, and status.
- **Catalog Entry**: The single row linking one clarification artifact to its stable identifier and current status.
- **Artifact Type**: The supported source category, limited to `REQ`, `DISC`, `ADR`, or `RA`.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every valid clarification artifact is represented by exactly one catalog row, and every catalog row resolves to an existing clarification artifact.
- **SC-002**: 100% of supported artifact types and statuses are accepted when valid, and 100% of unsupported values are rejected before catalog mutation.
- **SC-003**: Repeating an identical clarification generation or update operation produces byte-identical catalog content, apart from no permitted variable metadata, including identical row ordering.
- **SC-004**: A successful clarification status change leaves the clarification artifact and catalog reporting the same status in 100% of verified cases.
- **SC-005**: Malformed catalogs, duplicate mappings, missing references, clarification failures, and catalog write failures preserve all pre-operation bytes in 100% of failure-path tests.
- **SC-006**: Maintainers can locate a clarification by its `CLAR-<ARTIFACT-ID>` identifier using the catalog without filesystem-order assumptions.
- **SC-007**: Phase 1 validation confirms that Discovery behavior, Clarification findings, analysis ordering, and scoring remain unchanged.

## Assumptions

- Existing Clarification artifacts already define the authoritative clarification identity and status representation.
- Existing Clarify workflows remain responsible for clarification content, findings, responses, revision history, and analysis behavior.
- The catalog is a repository-maintained artifact and is created only after clarification validation succeeds.
- Catalog maintenance uses the repository's existing artifact and transaction conventions.
- No new external interface, dependency, storage mechanism, or Discovery integration is introduced in Phase 1.
- Feature numbering is explicitly `066` for this request.
