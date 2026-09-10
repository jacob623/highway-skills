# Feature Specification: Control-Derived NFR Generation

**Feature Branch**: `030-control-derived-nfr-generation`

**Created**: 2026-09-09

**Status**: Draft

**Input**: User description: "Activate the existing reserved Control-to-NFR relationship fields and establish Controls as the authoritative source for deterministic NFR proposal generation, while preserving user ownership and deferring reconciliation."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Propose NFRs from a new Control (Priority: P1)

As a governance author, I want a newly added Control to produce related NFR candidates so that outcome statements do not have to be authored from scratch.

**Why this priority**: Control-derived proposals are the foundation of this phase and provide value even when every proposal is ultimately rejected.

**Independent Test**: Add a Control with stable content and inspect the resulting proposal. The proposal contains one or more candidates tied to that Control and is identical when the same Control content is submitted again.

**Acceptance Scenarios**:

1. **Given** a valid new Control, **When** the Control is successfully added, **Then** the workflow produces one or more NFR candidates associated with that Control.
2. **Given** identical Control content, **When** candidate generation is repeated, **Then** the candidate titles, statements, rationales, ordering, and originating Control information are identical.
3. **Given** a Control with no suitable derived candidate, **When** candidate generation completes, **Then** the Control remains valid and the workflow reports that no candidate was produced without creating an NFR.

---

### User Story 2 - Review candidates before creation (Priority: P1)

As a governance author, I want to review and decide how each generated NFR should be handled before it is stored so that all governance wording remains user-owned.

**Why this priority**: User review is the ownership boundary; proposals must never silently become governance records.

**Independent Test**: Generate candidates, verify the proposal is shown before any NFR record or catalog change, then exercise Accept, Modify, Replace, and Reject decisions and inspect the resulting writes.

**Acceptance Scenarios**:

1. **Given** generated candidates, **When** the proposal is presented, **Then** it includes the originating Control ID and title, candidate NFR title, statement, and rationale before any NFR artifact is written.
2. **Given** a candidate, **When** the author accepts it, **Then** the candidate proceeds to NFR creation using the reviewed content.
3. **Given** a candidate, **When** the author modifies or replaces its title, statement, or rationale, **Then** only the author-approved wording is stored.
4. **Given** a candidate, **When** the author rejects it, **Then** no NFR record, catalog entry, or relationship is written and the Control remains valid.
5. **Given** a review is cancelled or left incomplete, **When** the workflow ends, **Then** no unapproved NFR content is written.

---

### User Story 3 - Preserve accepted Control-to-NFR traceability (Priority: P1)

As a governance author, I want accepted NFRs linked to their originating Controls so that the reason for each derived outcome remains traceable.

**Why this priority**: Traceability is the durable value of activating the reserved relationship fields and must be correct at creation time.

**Independent Test**: Accept one or more reviewed candidates from a Control, then inspect both records and the catalog. Each accepted NFR has the originating Control ID, and the Control lists every accepted NFR ID without changing existing identifiers.

**Acceptance Scenarios**:

1. **Given** an accepted candidate from Control `CTL000001`, **When** its NFR is created, **Then** the NFR references `CTL000001` and the Control references the allocated NFR ID.
2. **Given** several accepted candidates from one Control, **When** creation completes, **Then** the Control may reference multiple NFR IDs and every generated NFR references that Control.
3. **Given** an existing Control and NFR baseline, **When** a derived NFR is accepted, **Then** existing Control and NFR identifiers remain unchanged and only the new allocation and intended relationships are added.
4. **Given** a manually authored NFR, **When** it is created outside the derivation workflow, **Then** it retains an empty Control relationship unless the author explicitly supplies a supported relationship through a later workflow.

## Edge Cases

- A Control is invalid or cannot be added; no candidate generation or NFR write occurs.
- Candidate generation produces zero candidates; the Control remains valid and no NFR relationship is added.
- A candidate is rejected, modified, replaced, or review is cancelled; no unapproved content or relationship is persisted.
- Several candidates are accepted for one Control; all relationships use immutable identifiers and remain distinct.
- The NFR catalog is absent, malformed, or inconsistent; the workflow stops before writing a derived NFR and reports the blocking condition.
- The next NFR identifier cannot be allocated safely; the workflow stops without changing the Control or NFR baseline.
- Candidate output would vary because of a timestamp, random value, environment value, or existing catalog order; generation must remain stable and report no hidden dependency.
- A Control or NFR already contains relationships from an earlier accepted operation; the workflow preserves existing identifiers and does not duplicate an existing relationship.
- A user-owned root governance record or catalog exists; the workflow preserves unrelated content and changes only the accepted records, catalog entries, and intended relationship fields.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Control workflow MUST generate one or more NFR candidates after a valid new Control is successfully created, when the Control has derivable governance intent.
- **FR-002**: Each candidate MUST identify its originating Control ID and title and include a candidate NFR title, statement, and rationale.
- **FR-003**: The workflow MUST present every candidate for review before writing any NFR record, catalog entry, or relationship for that candidate.
- **FR-004**: The review MUST allow the author to accept, modify, replace, or reject each candidate independently.
- **FR-005**: The workflow MUST store only the author-approved title, statement, and rationale for an accepted candidate.
- **FR-006**: Accepting a candidate MUST allocate a new immutable NFR identifier using the existing NFR baseline allocation rules, create the NFR record, and update the NFR catalog.
- **FR-007**: An accepted derived NFR MUST reference at least one originating Control ID in its existing `controls` relationship field.
- **FR-008**: The originating Control MUST reference every accepted derived NFR ID in its existing `nfrs` relationship field.
- **FR-009**: Relationship values MUST use immutable Control and NFR identifiers only; no additional relationship store or alternate identifier form may be introduced.
- **FR-010**: Rejecting a candidate, cancelling review, or producing no candidate MUST create no NFR artifact, catalog entry, or relationship for that candidate while leaving the Control valid.
- **FR-011**: Candidate generation MUST be deterministic: identical Control content MUST produce identical candidate content and ordering, independent of timestamps, random values, environment values, and existing catalog ordering.
- **FR-012**: The workflow MUST preserve existing Control and NFR identifiers, unrelated user-authored content, and existing valid relationships when accepting derived candidates.
- **FR-013**: Manually authored NFRs MUST retain an empty `controls` relationship unless they are explicitly accepted through the Control-derived workflow.
- **FR-014**: This phase MUST activate the existing relationship fields without changing the Control or NFR record formats.
- **FR-015**: The workflow MUST stop before writing derived governance content when the relevant baseline or catalog is invalid, missing, or unable to allocate a safe identifier.
- **FR-016**: The workflow MUST NOT generate Controls from NFRs, remove records because of relationship changes, reconcile broken relationships, or introduce bidirectional synchronization in this phase.

### Key Entities

- **Control**: A user-owned, immutable-identifier governance obligation that may originate NFR proposals and stores accepted NFR IDs in `nfrs`.
- **NFR Candidate**: A reviewable, not-yet-persisted title, statement, rationale, and originating Control reference.
- **NFR**: A user-owned, immutable-identifier non-functional requirement that stores originating Control IDs in `controls` when created through derivation.
- **Review Decision**: The author’s Accept, Modify, Replace, Reject, or cancellation decision for one candidate.
- **Control-to-NFR Relationship**: The identifier-only pair represented by the existing `Control.nfrs` and `NFR.controls` fields.
- **Baseline Catalog**: The authoritative record of allocated identifiers and indexed governance records for safe accepted-candidate creation.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of valid Control-add runs with derivable intent, candidates are presented before any corresponding NFR record, catalog entry, or relationship write.
- **SC-002**: Repeating candidate generation with identical Control content produces byte-identical candidate output and ordering in 100% of repeated runs.
- **SC-003**: In 100% of accepted-candidate runs, each created NFR references its originating Control and the Control references the created NFR ID.
- **SC-004**: In 100% of rejected, cancelled, or zero-candidate runs, no derived NFR artifact, catalog entry, or relationship is created.
- **SC-005**: Existing Control and NFR identifiers and unrelated user-authored governance content remain unchanged in 100% of accepted-candidate runs.
- **SC-006**: Manually authored NFRs continue to start with an empty `controls` relationship in 100% of direct-authoring runs.
- **SC-007**: The feature introduces zero additional relationship stores, reverse-generation paths, automatic reconciliation behaviors, or record-format changes.
- **SC-008**: Invalid baseline, catalog, or identifier-allocation conditions produce zero partial derived-governance writes.

## Assumptions

- The existing Control and NFR record formats already contain the reserved `nfrs` and `controls` fields and can represent the required identifier-only relationships.
- Controls are authoritative only for initial NFR derivation in this phase; the user remains the owner of all final NFR wording and acceptance decisions.
- Candidate generation uses a stable, repository-defined mapping from Control content to candidate content; the exact mapping can be designed during planning without changing the user-visible contract.
- Existing baseline versioning, identifier allocation, catalog generation, validation, and user-data preservation rules remain in force.
- Phase 4 will address relationship reconciliation, orphan and broken-link handling, synchronization, and removal impact analysis; none of those behaviors are required here.
- A valid Control may remain without any related NFR, including when generation yields no candidate or every candidate is rejected.
