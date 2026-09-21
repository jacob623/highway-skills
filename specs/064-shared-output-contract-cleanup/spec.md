# Feature Specification: Final Shared Output Contract Cleanup

**Feature Branch**: `064-shared-output-contract-cleanup`

**Created**: 2026-09-21

**Status**: Draft

**Input**: User description: "Complete the migration to the Highway shared-output-contract model by removing the final remaining structural duplication from highway-controls and highway-discovery. Shared record and catalog templates are the sole structural authority, while skills retain behavioral ownership."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Delegate Control Catalog Structure (Priority: P1)

As a repository maintainer, I want `highway-controls` to cite the complete Control catalog template without restating its shape so that the catalog has one structural authority.

**Why this priority**: The Control catalog is still described in both the template and skill, allowing the two contracts to drift and weakening Constitution P9.1 compliance.

**Independent Test**: Inspect the Control skill's Outputs section and verify the complete catalog citation, absence of duplicated catalog fields, and retention of catalog determinism behavior.

**Acceptance Scenarios**:

1. **Given** the `highway-controls` Outputs section, **When** its catalog contract is reviewed, **Then** it cites `.highway/library/templates/output/control-catalog.md` as the authoritative complete structure.
2. **Given** the migrated Control skill, **When** its catalog behavior is reviewed, **Then** the catalog remains a function of Controls and the recorded next identifier, writes no timestamp, and remains unchanged for an unchanged baseline.
3. **Given** a disposable Control skill fixture with the old duplicated catalog shape, **When** the structural-contract check runs, **Then** it rejects the duplication without modifying canonical or user-owned files.

### User Story 2 - Delegate Discovery Record and Catalog Structure (Priority: P1)

As a repository maintainer, I want `highway-discovery` to cite complete Discovery record and catalog templates without repeating their layout so that templates alone define retained Discovery structure.

**Why this priority**: Discovery has the largest retained record and catalog contract, so duplicated headings, ordering, matrices, relationships, and catalog fields create the greatest risk of structural drift.

**Independent Test**: Inspect the Discovery Inputs, Outputs, and Verification sections and verify template citations replace structural lists while all analysis and handoff behavior remains specified.

**Acceptance Scenarios**:

1. **Given** the Discovery Inputs section, **When** structural ownership is reviewed, **Then** it does not enumerate Objective, Control, or NFR relationship sections independently.
2. **Given** the Discovery Verification section, **When** record and catalog checks are reviewed, **Then** it cites the complete Discovery record and catalog templates rather than restating section, field, or index shape.
3. **Given** the Discovery workflow, **When** candidate generation, elimination, scoring, recommendation, allocation, or handoff is exercised, **Then** those behavioral rules remain unchanged.

### User Story 3 - Prove Final Migration Integrity (Priority: P2)

As a maintainer, I want focused checks and regenerated adapters to prove that removing structural duplication from both skills does not remove behavior or create stale derived artifacts.

**Why this priority**: The migration is complete only when structural ownership is singular and behavioral ownership remains intact across canonical and generated skill representations.

**Independent Test**: Run disposable structural and behavioral probes, validate both canonical skills and their generated adapters, and run the repository suite with no changes to user-owned outputs.

**Acceptance Scenarios**:

1. **Given** the cleaned canonical skills, **When** focused checks run, **Then** missing citations and reintroduced structural duplication fail independently while retained behavioral checks pass.
2. **Given** changed canonical skills, **When** derived adapters are regenerated, **Then** every generated representation corresponds to its canonical source.
3. **Given** the completed migration, **When** the repository validation suite runs, **Then** all applicable checks pass and no protected Feature 061, Feature 062, or user-owned Request paths are changed.

### Edge Cases

- A skill cites a template but still repeats a complete record or catalog layout.
- A template citation is removed while behavioral wording remains intact.
- Discovery structural headings are removed but a behavioral rule is accidentally removed with them.
- Discovery catalog verification retains a field list instead of template-conformance verification.
- A disposable fixture mutates a canonical skill, generated adapter, or user-owned artifact.
- Generated adapters remain stale after either canonical skill changes.
- Existing Control or Discovery records and catalogs contain user-owned values that must remain untouched.
- A validation failure occurs after one disposable fixture has been applied and must be cleaned up without residue.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `highway-controls` MUST cite `.highway/library/templates/output/control-catalog.md` as the authoritative complete Control catalog structure.
- **FR-002**: `highway-controls` MUST remove the duplicated catalog listing, version, next-identifier, and management-shape declaration from its Outputs contract.
- **FR-003**: `highway-controls` MUST retain the behavioral guarantees that catalog content is derived from Controls and recorded allocation state, contains no timestamp, and remains unchanged for an unchanged baseline.
- **FR-004**: `highway-discovery` MUST cite `.highway/library/templates/output/discovery-record.md` as the authoritative complete Discovery record structure.
- **FR-005**: `highway-discovery` MUST cite `.highway/library/templates/output/discovery-catalog.md` as the authoritative complete Discovery catalog structure.
- **FR-006**: `highway-discovery` MUST remove the Inputs declaration that independently requires the Objective Relationships, Control Relationships, and NFR Relationships sections.
- **FR-007**: `highway-discovery` MUST replace duplicated record section-order verification with conformance verification against `discovery-record.md`.
- **FR-008**: `highway-discovery` MUST replace duplicated catalog field and index verification with conformance verification against `discovery-catalog.md`.
- **FR-009**: `highway-discovery` MUST retain candidate generation, constraint evaluation, elimination ordering, scoring, ranking, recommendation, traceability extraction, Reference Architecture matching, allocation, validation, determinism, and ADR handoff behavior.
- **FR-010**: `highway-discovery` MUST retain advisory Recommendation semantics and MUST NOT authorize implementation, mutate governance baselines, or make ADR decisions.
- **FR-011**: Focused validation MUST independently detect missing template citations, reintroduced structural duplication, removed behavioral rules, stale generated adapters, and disposable-fixture residue.
- **FR-012**: Focused validation MUST leave canonical skills, shared templates, generated artifacts, user-owned Control and Discovery outputs, and protected Request paths unchanged.
- **FR-013**: Generated adapters for both changed skills MUST be regenerated from canonical sources and validated for correspondence.
- **FR-014**: The complete repository validation suite MUST pass after the cleanup.
- **FR-015**: The final state MUST satisfy Constitution P9.1 by making shared templates the sole structural authority for retained Control and Discovery records and catalogs.

### Key Entities

- **Control Catalog Template**: The shared structural authority for Control catalog headings, fields, ordering, and index layout.
- **Discovery Record Template**: The shared structural authority for Discovery record headings, ordering, matrices, candidates, relationships, and architecture matches.
- **Discovery Catalog Template**: The shared structural authority for Discovery catalog headings, fields, ordering, and index layout.
- **Behavioral Skill Contract**: The workflow rules retained by `highway-controls` and `highway-discovery` after structural prose is removed.
- **Disposable Contract Fixture**: A temporary valid or invalid skill copy used to prove structural, behavioral, and no-write checks.
- **Generated Adapter**: A derived representation of a canonical skill that must remain current after migration.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: `highway-controls` contains one complete citation to the Control catalog template and zero independent complete Control catalog shape declarations.
- **SC-002**: `highway-discovery` contains complete citations to the Discovery record and catalog templates and zero independent complete record or catalog layout declarations in Inputs or Verification.
- **SC-003**: 100% of retained Control and Discovery behavioral checks named in this specification remain detectable after cleanup.
- **SC-004**: Focused validation independently rejects missing citations and reintroduced structural duplication for both affected skills while preserving canonical and user-owned bytes.
- **SC-005**: Generated adapters for both affected skills correspond to their canonical sources after regeneration.
- **SC-006**: The complete repository validation suite passes with zero failures after implementation.
- **SC-007**: Existing templates, retained records, catalogs, governance baselines, relationships, and Request paths remain byte-for-byte unchanged during focused validation.
- **SC-008**: A maintainer can identify the sole structural authority for each Control and Discovery retained artifact by reading the shared template citations, without relying on duplicated skill prose.

## Assumptions

- The existing Control and Discovery record/catalog templates are complete and remain unchanged by this feature.
- Feature 062 and Feature 063 provide the shared-output-contract conventions and validation patterns used by this cleanup.
- `highway-controls` and `highway-discovery` remain responsible for behavior, validation, allocation, determinism, relationships, and ownership boundaries.
- Generated adapters are derived artifacts and may be regenerated after canonical skill changes.
- Disposable fixtures may use temporary directories but must not write to user-owned records, catalogs, governance baselines, or Request paths.
- No extension hooks are registered in `.specify/extensions.yml`.

## Scope Boundaries

### Included in Version 1

- Removing the specified duplicated Control catalog structure from `highway-controls`.
- Removing the specified duplicated Discovery record and catalog structure from `highway-discovery`.
- Replacing structural verification lists with complete template-conformance citations.
- Adding or updating focused disposable checks for citations, structural duplication, behavior preservation, adapter currency, and no-write guarantees.
- Regenerating affected adapters and running the complete validation suite.

### Excluded from Version 1

- Changing Control or Discovery record/catalog templates.
- Changing user-owned Control or Discovery records, catalogs, identifiers, versions, allocation state, or baseline values.
- Changing candidate generation, elimination, scoring, recommendation, Reference Architecture matching, Reference Implementation evaluation, or ADR handoff semantics.
- Changing Control-derived NFR behavior, governance relationships, or Constitution P9.1.
- Modifying Features 061 or 062, user-owned Request paths, or unrelated skills.
- Introducing a runtime, persistence mechanism, external service, interface, or user interface.
