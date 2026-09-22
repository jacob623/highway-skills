# Feature Specification: Clarification State and Fingerprint Normalization

**Feature Branch**: `068-clarification-state-normalization`

**Created**: 2026-09-22

**Status**: Draft

**Input**: User description: "Add fingerprint normalization, finding state transitions, count invariants, catalog consistency verification, and version updates to the clarification contracts."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Normalize Finding Fingerprints Deterministically (Priority: P1)

As a repository maintainer, I want equivalent finding inputs to normalize identically before fingerprint generation so that harmless differences in line endings, casing, whitespace, or source-field spelling do not create new finding identities.

**Why this priority**: Fingerprints control identifier reuse. Without a single normalization contract, equivalent evidence can produce different identities and destabilize clarification history.

**Independent Test**: Generate fingerprints from inputs that differ only by line endings, surrounding whitespace, casing, repeated whitespace, or non-canonical source-field spelling. Confirm that every equivalent set produces one identical fingerprint and that genuinely different normalized inputs remain distinguishable.

**Acceptance Scenarios**:

1. **Given** equivalent values use CRLF, CR, or LF line endings, **When** fingerprints are generated, **Then** all values are normalized to LF before further processing.
2. **Given** equivalent values differ by leading/trailing whitespace, casing, or repeated internal whitespace, **When** fingerprints are generated, **Then** all values produce the same normalized fingerprint inputs.
3. **Given** a source-field identifier has an alias or non-canonical spelling, **When** the fingerprint is generated, **Then** the canonical declared source-field name is used.
4. **Given** normalized category, source-field, and evidence inputs are identical, **When** fingerprints are generated repeatedly, **Then** the fingerprints are identical.
5. **Given** two inputs differ after normalization, **When** fingerprints are generated, **Then** they remain distinguishable and are not incorrectly merged.

### User Story 2 - Govern Finding State and Count Integrity (Priority: P1)

As a repository maintainer, I want finding states and record counts to follow explicit lifecycle rules so that resolved findings remain auditable and malformed records cannot report a misleading status.

**Why this priority**: State transitions and count relationships determine whether a clarification is open, complete, or blocked. Explicit invariants protect downstream consumers from contradictory records.

**Independent Test**: Create records with open and resolved findings, apply permitted and prohibited transitions, and vary count fields. Confirm only `open` and `resolved` are accepted, resolution is one-way, identifiers/history/evidence are retained, and count violations produce malformed blocked records.

**Acceptance Scenarios**:

1. **Given** a newly generated finding, **When** its state is assigned, **Then** its state is `open`.
2. **Given** an open finding receives an accepted response, **When** the record is updated, **Then** the finding transitions to `resolved`.
3. **Given** a resolved finding is updated again, **When** state validation runs, **Then** it remains `resolved` and retains its identifier, fingerprint, history, and evidence references.
4. **Given** a resolved finding is requested to transition back to open or to any unsupported state, **When** validation runs, **Then** the record is rejected as malformed.
5. **Given** a record's counts are evaluated, **When** `total_findings` does not equal `open_findings + resolved_findings`, **Then** the record is malformed and status derivation returns `blocked`.
6. **Given** a valid record contains both open and resolved findings, **When** its status is derived, **Then** counts and states remain consistent with the record's lifecycle.

### User Story 3 - Verify Catalog Consistency and Versioned Schema (Priority: P1)

As a repository maintainer, I want catalog entries and clarification artifacts to remain in one-to-one agreement under the versioned catalog schema so that lookup paths, statuses, and ownership remain trustworthy.

**Why this priority**: The catalog is derived lookup state. Explicit cross-artifact checks prevent stale, duplicate, missing, or misleading entries from becoming authoritative by accident.

**Independent Test**: Validate catalogs containing valid rows, missing artifacts, duplicate entries, status mismatches, unresolved paths, missing rows, and extra rows. Confirm every valid artifact has exactly one matching entry, every entry resolves to an artifact, statuses agree, paths are direct and informational, and the catalog reports version `1.1.0`.

**Acceptance Scenarios**:

1. **Given** a catalog entry references an existing clarification artifact, **When** consistency verification runs, **Then** the entry resolves directly to that artifact.
2. **Given** a clarification artifact exists, **When** consistency verification runs, **Then** exactly one catalog entry references it.
3. **Given** a catalog status differs from its clarification artifact status, **When** consistency verification runs, **Then** validation fails without writing either artifact.
4. **Given** a Clarification Path points elsewhere or cannot resolve, **When** consistency verification runs, **Then** validation fails and preserves pre-operation bytes.
5. **Given** the catalog schema is rendered after the path-column addition, **When** its metadata is read, **Then** its version is `1.1.0`.
6. **Given** the clarification record schema is rendered after the lifecycle additions, **When** its metadata is read, **Then** its version is `1.2.0`.

### Edge Cases

- Mixed CRLF, CR, and LF line endings occur within one evidence value.
- A value contains only whitespace or repeated whitespace between words.
- A source-field alias differs from its canonical declared name only by case or separator style.
- A profile or input supplies an empty, duplicate, or unsupported finding state.
- A resolved finding is edited with a response that would otherwise reopen it.
- A record has negative counts, non-integer counts, or a total that differs from the open-plus-resolved sum.
- A record has zero open findings but contains an invalid state or count relationship; it must remain `blocked`.
- A catalog has two rows for one clarification, one row for a missing artifact, or an artifact with no row.
- A catalog status and clarification status disagree while both artifacts are otherwise structurally valid.
- A catalog path resolves to a different clarification artifact than the row's stable identity.
- A failed consistency validation or write occurs after one artifact has been staged; all pre-operation bytes must remain unchanged.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The `highway-clarify` contract MUST define a Fingerprint Normalization Contract within the Finding Identity Contract.
- **FR-002**: Fingerprint normalization MUST convert line endings to LF before trimming, lowercasing, whitespace collapsing, and source-field canonicalization.
- **FR-003**: Fingerprint normalization MUST trim leading and trailing whitespace, convert values to lowercase, collapse consecutive whitespace to one space, and use canonical declared source-field names.
- **FR-004**: Fingerprints MUST be generated only after all normalization steps complete.
- **FR-005**: Identical normalized category, source-field, and evidence inputs MUST generate identical fingerprints.
- **FR-006**: The `highway-clarify` contract MUST define a Finding State Contract after the Finding Identity Contract.
- **FR-007**: Supported finding states MUST be exactly `open` and `resolved`.
- **FR-008**: New findings MUST begin in `open`; an open finding MAY transition to `resolved` only after an accepted response.
- **FR-009**: A resolved finding MUST retain its identifier, fingerprint, history, and evidence references and MUST NOT transition back to `open`.
- **FR-010**: No finding state other than `open` or `resolved` may be persisted or accepted.
- **FR-011**: The clarification record template MUST document the invariant `total_findings = open_findings + resolved_findings`.
- **FR-012**: A record violating the count invariant MUST be treated as malformed and derive status `blocked`.
- **FR-013**: The clarification record specimen MUST demonstrate one open and one resolved finding with `open_findings: 1`, `resolved_findings: 1`, and `total_findings: 2`.
- **FR-014**: The catalog template metadata version MUST be `1.1.0`, including its rendered `Version: 1.1.0` value.
- **FR-015**: The clarification record template metadata version MUST be `1.2.0`.
- **FR-016**: The `highway-clarify` skill metadata version MUST advance to `1.4.0`.
- **FR-017**: The `highway-clarify` contract MUST declare that finding fingerprints preserve identifiers across reordering, retired identifiers are never reused, status precedence is `blocked`, `complete`, `in-progress`, `not-started`, and Clarification Path is informational rather than authoritative.
- **FR-018**: The `highway-clarify` Verification section MUST check normalization before fingerprint generation, case differences, surrounding whitespace, repeated whitespace, supported states, new open findings, resolved-history retention, and prevention of resolved-to-open transitions.
- **FR-019**: The `highway-clarify` Verification section MUST confirm total count equals open plus resolved and that malformed count relationships produce `blocked` status.
- **FR-020**: The `highway-clarify` Verification section MUST confirm every catalog entry resolves to an existing clarification artifact, every clarification artifact has exactly one catalog entry, catalog status equals clarification status, and Clarification Path resolves to the referenced artifact.
- **FR-021**: Catalog consistency or write validation MUST preserve all pre-operation clarification and catalog bytes on failure.
- **FR-022**: Existing command syntax, supported artifact types, artifact ownership, analysis ordering, and source-artifact immutability MUST remain unchanged.

### Key Entities *(include if data involved)*

- **Normalized Fingerprint Input**: A category, canonical source-field or section name, and evidence reference after ordered normalization.
- **Finding Fingerprint**: The deterministic identity value generated from normalized finding inputs.
- **Clarification Finding State**: The lifecycle state of a finding, restricted to `open` or `resolved` with one-way resolution.
- **Clarification Record Counts**: The open, resolved, and total finding counts governed by an arithmetic invariant.
- **Clarification Catalog Schema**: The versioned catalog structure containing identity, artifact linkage, status, and informational path.
- **Catalog Consistency Relation**: The one-to-one relationship between catalog entries and authoritative clarification artifacts, including status and path agreement.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of equivalent fingerprint inputs differing only in line endings, casing, surrounding whitespace, or repeated whitespace produce identical normalized fingerprints.
- **SC-002**: 100% of fingerprint inputs use canonical declared source-field names before identity comparison, with no duplicate identities caused by aliases.
- **SC-003**: 100% of newly created findings begin `open`, and 100% of accepted resolutions transition only from `open` to `resolved`.
- **SC-004**: 100% of resolved findings retain their identifiers, fingerprints, history, and evidence references, with zero resolved-to-open transitions accepted.
- **SC-005**: 100% of records with invalid count relationships are classified `blocked`, including records whose open count is zero.
- **SC-006**: 100% of valid records satisfy `total_findings = open_findings + resolved_findings`.
- **SC-007**: 100% of valid catalog entries resolve to existing clarification artifacts and every authoritative clarification artifact has exactly one catalog entry.
- **SC-008**: 100% of catalog status and path checks agree with the referenced clarification artifact, and failed consistency operations preserve all pre-operation bytes.
- **SC-009**: The catalog template reports version `1.1.0`, the clarification record template reports version `1.2.0`, and the `highway-clarify` skill reports version `1.4.0`.
- **SC-010**: Command syntax, supported artifact types, ownership boundaries, analysis ordering, and source immutability remain unchanged across all existing contract checks.

## Assumptions

- Feature 067 remains the behavioral baseline; Feature 068 adds normalization, finding-state, count-invariant, catalog-consistency, and versioning contracts without redefining prior identity or status rules.
- The existing Clarification Path remains informational and derived; it does not become an authority over clarification artifacts.
- Canonical source-field names are supplied by existing artifact declarations or profiles; this feature does not add a field-alias authoring interface.
- An accepted response is the existing workflow event that resolves an open finding; no new command syntax is required.
- Count fields are non-negative integers because they represent persisted finding quantities.
- Catalog consistency checks apply to both bootstrap and maintenance paths before any write.
- Existing generated adapters and catalog indexes remain derived artifacts and are regenerated after canonical inputs change.
- No new storage system, external dependency, Discovery integration, or supported artifact type is required.
