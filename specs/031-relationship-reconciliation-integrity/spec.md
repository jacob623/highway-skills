# Feature Specification: Relationship Reconciliation and Integrity Management

**Feature Branch**: `031-relationship-reconciliation-integrity`

**Created**: 2026-09-09

**Status**: Draft

**Input**: User description: "Phase 4: Relationship Reconciliation and Integrity Management. Introduce repository-wide relationship validation, repair, and synchronization for governance artifacts while preserving identifier immutability, user confirmation, deterministic output, and the existing Control-to-NFR record fields."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Inspect relationship integrity (Priority: P1)

As a governance author, I want the repository to inspect every Control-to-NFR relationship so that I can trust whether traceability is valid, reciprocal, and resolvable.

**Why this priority**: Reliable inspection is the foundation for safe repair and downstream automation.

**Independent Test**: Run inspection against baselines containing valid, orphaned, malformed, and one-sided relationships, then verify the report classifies every relationship without changing any user-owned file.

**Acceptance Scenarios**:

1. **Given** a baseline with valid reciprocal Control-to-NFR links, **When** inspection runs, **Then** the report lists them as valid.
2. **Given** a Control or NFR references an identifier that does not exist, **When** inspection runs, **Then** the report identifies the reference as an orphan and names the missing identifier.
3. **Given** a relationship exists on only one side, **When** inspection runs, **Then** the report identifies it as asymmetric and names the missing reciprocal reference.
4. **Given** a relationship identifier has an invalid format or type, **When** inspection runs, **Then** the report identifies the invalid relationship without changing the record.

---

### User Story 2 - Review and apply relationship repairs (Priority: P1)

As a governance author, I want proposed relationship repairs shown before they are applied so that I retain control over changes to user-owned traceability.

**Why this priority**: Relationship repair can alter governed content and must not happen silently.

**Independent Test**: Generate repair proposals for asymmetric and orphaned relationships, verify the proposal shows current state, proposed state, reason, and impact, then confirm selected repairs and inspect the resulting relationship fields.

**Acceptance Scenarios**:

1. **Given** an existing NFR is referenced by a Control but lacks the reciprocal Control reference, **When** a repair proposal is generated, **Then** it proposes adding only the missing reciprocal identifier.
2. **Given** a relationship references a missing artifact, **When** a repair proposal is generated, **Then** it proposes removing only the invalid relationship reference and leaving existing artifacts unchanged.
3. **Given** a repair proposal is displayed, **When** the author declines or cancels it, **Then** no relationship or catalog file is changed.
4. **Given** the author confirms a repair proposal, **When** the repair completes, **Then** only the approved relationship fields change and the resulting links are reciprocal and resolvable.
5. **Given** a repair operation contains multiple findings, **When** the author approves only a subset, **Then** only that subset is applied and the remaining findings are preserved for later review.

---

### User Story 3 - Analyze destructive-operation impact (Priority: P1)

As a governance author, I want removal and baseline-replacement impact listed before destructive changes so that I understand which traceability links will be lost.

**Why this priority**: Destructive operations can silently erase important context unless affected identifiers are explicit.

**Independent Test**: Request removal or replacement analysis for Controls and NFRs with relationships, then verify every affected identifier and title is listed before confirmation and that declining confirmation changes nothing.

**Acceptance Scenarios**:

1. **Given** a Control has relationships to several NFRs, **When** removal impact is analyzed, **Then** every affected NFR identifier and title is listed individually.
2. **Given** an NFR is related to one or more Controls, **When** removal impact is analyzed, **Then** every affected Control identifier and title is listed individually.
3. **Given** a baseline replacement would remove related artifacts, **When** impact is analyzed, **Then** all affected relationships and artifacts are listed before confirmation.
4. **Given** the author declines a destructive operation after reviewing impact, **When** the workflow ends, **Then** records, catalogs, and relationships remain unchanged.

---

### User Story 4 - Produce deterministic integrity results (Priority: P2)

As a governance author, I want repeated integrity checks and repair planning to produce the same results for the same baseline so that downstream automation can rely on them.

**Why this priority**: Stable reports and repair plans make governance changes auditable and reproducible.

**Independent Test**: Run inspection and repair planning twice against byte-identical baselines and compare the reports and proposed outputs byte-for-byte.

**Acceptance Scenarios**:

1. **Given** identical Control and NFR baselines, **When** inspection is repeated, **Then** the validation results and ordering are identical.
2. **Given** identical relationship findings, **When** repair planning is repeated, **Then** the proposal contents and ordering are identical.
3. **Given** identical approved repairs, **When** repair is repeated in isolated baselines, **Then** the resulting relationship fields and generated reports are identical.
4. **Given** any inspection or repair proposal, **When** output is generated, **Then** it contains no timestamp, random identifier, or environment-derived value.

### Edge Cases

- A Control or NFR baseline is missing, malformed, or internally inconsistent; inspection reports the blocking condition and repair writes nothing.
- A relationship references an identifier with the wrong prefix or malformed numeric portion; the finding is invalid and is not silently reinterpreted.
- Both sides reference each other but one artifact is duplicated or represented by conflicting records; the workflow stops and reports the ambiguity.
- A relationship appears multiple times on one side; repair removes only approved invalid duplication and preserves valid identifier membership.
- A repair proposal contains both reciprocal additions and orphan removals; each proposed change remains independently reviewable.
- A repair write fails after confirmation; the workflow stops without leaving only one side of an approved relationship changed.
- A destructive operation has no affected relationships; the workflow reports an empty impact set and does not require a misleading confirmation list.
- Existing root-level user governance records and catalogs contain unrelated content; inspection preserves them and repair changes only approved relationship fields and required catalog output.
- A direct NFR has `controls: []`; integrity inspection accepts it as valid rather than requiring an inferred Control.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The relationship workflow MUST inspect every Control-to-NFR reference in both `Control.nfrs` and `NFR.controls`.
- **FR-002**: Inspection MUST validate identifier format, referenced artifact existence, referenced artifact type, and reciprocal membership.
- **FR-003**: Inspection MUST classify findings as valid, broken, asymmetric, orphaned, malformed, or blocked by an invalid baseline when applicable.
- **FR-004**: Read-only inspection MUST produce a relationship summary, integrity report, and repair recommendations without changing user-owned records, catalogs, or relationships.
- **FR-005**: Every repair recommendation MUST show the affected artifact, current relationship state, proposed relationship state, reason, and impact.
- **FR-006**: The workflow MUST show repair recommendations before writing any approved repair.
- **FR-007**: Repair confirmation MUST be explicit; cancellation, rejection, or incomplete confirmation MUST write nothing.
- **FR-008**: An approved reciprocal repair MUST add only the missing immutable identifier to the affected relationship field.
- **FR-009**: An approved orphan repair MUST remove only the invalid relationship reference; the surviving artifact and its non-relationship content MUST remain unchanged.
- **FR-010**: Repair MUST support independent approval or rejection of multiple proposed relationship changes.
- **FR-011**: Before removing a Control, removing an NFR, or replacing a baseline, the workflow MUST list every affected relationship and artifact individually by immutable identifier and title.
- **FR-012**: A destructive operation MUST NOT proceed when required impact confirmation is declined or incomplete.
- **FR-013**: Repair MUST preserve identifiers, titles, statements, rationales, statuses, unrelated records, and unrelated catalog content.
- **FR-014**: Repair MUST never rename, replace, reallocate, or reuse an identifier.
- **FR-015**: Inspection and repair planning MUST be deterministic for identical baselines, including finding classification, proposal content, and ordering.
- **FR-016**: Inspection and repair output MUST contain no timestamps, random identifiers, or environment-derived values.
- **FR-017**: The relationship workflow MUST stop before partial writes when a baseline, catalog, allocation, relationship, or approved repair operation is invalid or cannot be completed safely.
- **FR-018**: Direct NFR authoring with `controls: []` MUST remain valid and MUST NOT trigger inferred relationship creation.
- **FR-019**: This phase MUST not generate new Controls or NFRs, infer governance intent, rewrite statements or rationales, reclassify artifacts, or add a second relationship store.
- **FR-020**: Relationship validation MUST be independently invocable from Control and NFR authoring workflows.

### Key Entities

- **Relationship Graph**: The set of identifier-only Control-to-NFR references represented by existing `nfrs` and `controls` fields.
- **Integrity Finding**: A classified valid, broken, asymmetric, orphaned, malformed, or blocked relationship condition.
- **Repair Recommendation**: A proposed relationship-only change containing artifact, current state, proposed state, reason, and impact.
- **Repair Decision**: An explicit approval, rejection, cancellation, or incomplete decision for one or more recommendations.
- **Impact Analysis**: The individually listed identifiers and titles affected by a removal or baseline replacement.
- **Integrity Report**: The deterministic inspection result containing valid relationships, broken relationships, asymmetric relationships, orphan references, and required repairs.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Inspection correctly classifies 100% of valid, malformed, orphaned, and asymmetric fixture relationships without modifying the inspected baseline.
- **SC-002**: 100% of repair recommendations display artifact, current state, proposed state, reason, and impact before any write occurs.
- **SC-003**: 100% of approved reciprocal repairs add only the missing immutable identifier and produce a reciprocal relationship.
- **SC-004**: 100% of approved orphan repairs remove only the invalid reference and preserve the referenced artifact's remaining content.
- **SC-005**: 100% of cancelled, rejected, incomplete, or read-only operations produce zero relationship or catalog writes.
- **SC-006**: 100% of destructive-operation analyses list every affected identifier and title individually before confirmation.
- **SC-007**: Repeated inspection and repair planning over identical baselines produces byte-identical results and ordering in 100% of comparison runs.
- **SC-008**: Zero repair operations modify identifiers, titles, statements, rationales, statuses, or introduce a second relationship store.
- **SC-009**: Direct NFR baselines containing `controls: []` pass integrity validation without inferred relationships in 100% of direct-authoring cases.
- **SC-010**: The relationship workflow can validate a baseline independently, without invoking Control or NFR creation or derivation.

## Assumptions

- Existing Control and NFR records remain the authoritative relationship storage and require no schema change.
- Relationship values are immutable `CTLXXXXXX` and `NFRXXXXXX` identifiers only.
- A relationship is valid only when both referenced artifacts exist, have the expected type, and reference each other.
- Inspection is read-only; repair is proposal-first and requires explicit author confirmation.
- Repair writes are limited to approved relationship fields and any existing catalog output required by the repository's governance workflows.
- Existing identifier allocation, baseline versioning, catalog generation, validation, and user-data preservation rules remain in force.
- Phase 4 initially supports Controls and NFRs; Objectives, Capabilities, Lifecycle Activities, Reference Architectures, and Implementations remain future expansion areas.
- A valid direct NFR may remain unlinked with `controls: []`.
