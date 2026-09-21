# Feature Specification: highway-nfrs Shared Output Contract Final Cleanup

**Feature Branch**: `065-nfr-shared-output-contract-cleanup`

**Created**: 2026-09-21

**Status**: Draft

**Input**: User description: "Complete the migration of highway-nfrs to the shared-output-contract model by making the NFR record and catalog templates the sole structural authority while retaining workflow behavior in highway-nfrs."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Delegate NFR Record Structure (Priority: P1)

As a repository maintainer, I want the shared NFR record template to be the sole authority for retained record structure so that changes to frontmatter, fields, body layout, and relationship representation do not require duplicated structural prose in `highway-nfrs`.

**Why this priority**: The record template already defines the retained NFR record shape. Removing duplicate record checks prevents the skill and template from drifting while preserving the workflow that creates and validates records.

**Independent Test**: Inspect `highway-nfrs` Inputs, Outputs, and Verification sections; confirm the complete NFR record template is cited, duplicated record-field checks are absent, and record ownership and transaction behavior remain stated.

**Acceptance Scenarios**:

1. **Given** the `highway-nfrs` record output contract, **When** a maintainer reviews its structural authority, **Then** it cites `.highway/library/templates/output/nfr-record.md` as the complete record structure.
2. **Given** the migrated skill, **When** verification behavior is reviewed, **Then** it checks conformance to the shared NFR record template instead of enumerating record fields and body sections.
3. **Given** a disposable copy of the skill with the record-template citation removed or old record-shape checks restored, **When** focused validation runs, **Then** the defect is rejected without changing canonical or user-owned files.

### User Story 2 - Delegate NFR Catalog Structure (Priority: P1)

As a repository maintainer, I want the shared NFR catalog template to be the sole authority for catalog structure so that catalog headings, version, allocation field, index columns, and ordering are maintained in one place.

**Why this priority**: The catalog structure is already defined by `nfr-catalog.md`; retaining a second catalog description in the skill creates an avoidable source of drift.

**Independent Test**: Inspect the `highway-nfrs` Outputs and Verification sections; confirm the catalog template citation replaces the catalog-shape prose and catalog field/index checks, while deterministic catalog behavior remains specified.

**Acceptance Scenarios**:

1. **Given** the `highway-nfrs` catalog output contract, **When** its structural authority is reviewed, **Then** it cites `.highway/library/templates/output/nfr-catalog.md` as the complete catalog structure.
2. **Given** the migrated skill, **When** catalog behavior is reviewed, **Then** it still requires no timestamp and unchanged-baseline determinism, but does not restate catalog fields, headings, or index layout.
3. **Given** a disposable copy of the skill with the catalog citation removed or duplicated catalog-shape prose restored, **When** focused validation runs, **Then** the defect is rejected without changing the canonical skill or user-owned catalog.

### User Story 3 - Prove NFR Behavioral and Distribution Integrity (Priority: P2)

As a repository maintainer, I want focused checks and regenerated adapters to prove that removing structural duplication does not remove NFR workflow behavior or leave stale distributed skill artifacts.

**Why this priority**: The migration is complete only when structure has one authority and classification, routing, allocation, versioning, destructive-action safety, relationships, transactions, determinism, and validation remain owned by `highway-nfrs`.

**Independent Test**: Run focused structural and behavioral probes, validate both shared templates and the canonical skill, regenerate all derived adapters, run correspondence and repository validation, and confirm protected and user-owned bytes remain unchanged.

**Acceptance Scenarios**:

1. **Given** the cleaned canonical skill, **When** focused checks run, **Then** missing citations, restored record/catalog structure, and removed behavioral rules are independently detected.
2. **Given** a changed canonical skill, **When** derived adapters are regenerated, **Then** each supported adapter corresponds to the canonical `highway-nfrs` source.
3. **Given** an accepted or declined NFR workflow action, **When** its behavior is reviewed, **Then** classification, routing, allocation, versioning, relationship boundaries, destructive-action confirmation, transaction safety, determinism, and no-write failure behavior remain unchanged.
4. **Given** the completed migration, **When** repository validation runs, **Then** all applicable checks pass and no protected feature artifacts, Request paths, or user-owned NFR outputs are modified.

### Edge Cases

- A skill cites an NFR template but still repeats a complete record or catalog layout.
- The NFR record citation is removed while catalog behavior and workflow prose remain intact.
- The NFR catalog citation is removed while record behavior remains intact.
- A catalog-shape description is restored without restoring the shared citation.
- A record or catalog template is malformed or unavailable during validation.
- A destructive NFR action is declined and must leave records, catalog, version, allocation state, and relationships unchanged.
- An unchanged baseline is regenerated and must produce an identical catalog.
- A transaction or validation failure occurs after a disposable fixture is applied and must leave every affected byte unchanged.
- Generated adapters remain stale after the canonical skill changes.
- Disposable fixtures must be removed without residue and must not mutate user-owned NFR records or catalogs.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `highway-nfrs` MUST cite `.highway/library/templates/output/nfr-record.md` as the authoritative complete NFR record structure.
- **FR-002**: `highway-nfrs` MUST remove independent declarations of NFR record frontmatter, field names, body structure, relationship field structure, and record ordering from its structural contract.
- **FR-003**: `highway-nfrs` MUST verify generated NFR records by conformance to `.highway/library/templates/output/nfr-record.md`.
- **FR-004**: `highway-nfrs` MUST cite `.highway/library/templates/output/nfr-catalog.md` as the authoritative complete NFR catalog structure.
- **FR-005**: `highway-nfrs` MUST remove independent declarations of catalog headings, global catalog prose, version, `next_id`, index fields, index ordering, and catalog management shape from its structural contract.
- **FR-006**: `highway-nfrs` MUST verify generated NFR catalogs by conformance to `.highway/library/templates/output/nfr-catalog.md`.
- **FR-007**: `highway-nfrs` MUST retain the behavioral rule that the catalog contains no timestamp and that an unchanged baseline regenerates to an identical catalog.
- **FR-008**: `highway-nfrs` MUST retain NFR classification behavior and route Control-shaped statements to `/highway-controls` while outcome-shaped Control input routes to `/highway-nfrs`.
- **FR-009**: `highway-nfrs` MUST retain allocation behavior using the catalog's recorded next identifier, including permanent identifier allocation and no identifier reuse after removal.
- **FR-010**: `highway-nfrs` MUST retain versioning behavior for Add, Update, Remove, and Set actions.
- **FR-011**: `highway-nfrs` MUST retain destructive-action confirmation and relationship-impact behavior before removing an NFR or replacing the baseline.
- **FR-012**: `highway-nfrs` MUST retain transaction and no-write guarantees for rejected, ambiguous, malformed, unavailable, or failed operations.
- **FR-013**: Focused validation MUST independently detect missing shared-template citations, restored structural duplication, removed behavioral rules, stale generated adapters, and disposable-fixture residue.
- **FR-014**: Focused validation MUST leave canonical skills, shared templates, generated adapters, protected Request paths, and user-owned NFR records and catalogs byte-for-byte unchanged.
- **FR-015**: Generated adapters for `highway-nfrs` MUST be regenerated from the canonical skill and validated for correspondence.
- **FR-016**: The complete repository validation suite MUST pass after the cleanup.
- **FR-017**: The final state MUST satisfy Constitution P9.1 by making shared NFR templates the sole structural authority for retained NFR records and catalogs.

### Key Entities *(include if feature involves data)*

- **NFR Record Template**: The shared structural authority for NFR record frontmatter, body, relationship field representation, and ordering.
- **NFR Catalog Template**: The shared structural authority for catalog headings, version, next identifier, index columns, and ordering.
- **Behavioral Skill Contract**: The workflow rules retained by `highway-nfrs`, including classification, routing, allocation, versioning, relationship boundaries, determinism, and transaction safety.
- **Disposable Contract Fixture**: A temporary valid or invalid skill or artifact copy used to prove structural, behavioral, correspondence, and no-write checks.
- **Generated Adapter**: A derived representation of the canonical `highway-nfrs` skill that must remain current after migration.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: `highway-nfrs` contains complete citations to both shared NFR templates and zero independent complete record or catalog shape declarations.
- **SC-002**: Focused structural probes independently reject 100% of the defined citation and duplication defects for the NFR record and catalog contracts.
- **SC-003**: Focused behavioral probes continue to detect all retained NFR workflow invariants for classification, routing, allocation, versioning, destructive-action safety, relationships, transaction handling, determinism, validation, and no-write failures.
- **SC-004**: Every generated adapter representation for `highway-nfrs` corresponds to the canonical skill after regeneration, with no stale adapter content detected.
- **SC-005**: The complete repository validation suite reports zero failed applicable checks after the migration.
- **SC-006**: No protected Feature 061 or Feature 062 artifacts, protected Request paths, or user-owned NFR records and catalogs are changed by focused validation or adapter generation.
- **SC-007**: A maintainer can change retained NFR record or catalog structure in the two shared templates without changing duplicated structural prose in `highway-nfrs`.

## Assumptions

- The existing NFR record and catalog templates are complete and remain the structural authorities for this feature.
- The root `library/governance/` NFR records and catalog are user-owned and are not migration fixtures to be rewritten.
- Generated adapters are disposable derived artifacts and may be regenerated from the canonical skill.
- Existing repository validation conventions and Constitution P9.1 provide the governing interpretation of shared output ownership.
- No new external interface, persistence mechanism, dependency, or user-facing workflow is introduced.
- Feature scope is limited to the canonical `highway-nfrs` skill, its focused validation coverage, generated adapters, and Feature 065 design artifacts.
