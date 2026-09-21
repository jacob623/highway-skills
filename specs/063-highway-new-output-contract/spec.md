# Feature Specification: Highway New Shared Output Contract Migration

**Feature Branch**: `063-highway-new-output-contract`

**Created**: 2026-09-21

**Status**: Draft

**Input**: User description: "Migrate highway-new to the shared-output-contract model. The Request record and catalog templates own complete retained structure while highway-new owns collection, validation, allocation, privacy, determinism, transaction, and Discovery handoff behavior."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Delegate Request Record Structure (Priority: P1)

As a repository maintainer, I want `highway-new` to identify the Request record template as the sole structural authority so that Request records can evolve without duplicated skill prose.

**Why this priority**: The Request record is the primary retained artifact emitted by the skill; its structure must have one unambiguous owner before verification and regression checks are updated.

**Independent Test**: Inspect the `highway-new` Outputs contract and confirm it cites the complete Request record template as authoritative while retaining evidence collection, privacy, validation, status, and write behavior.

**Acceptance Scenarios**:

1. **Given** the `highway-new` Outputs section, **When** its Request record contract is reviewed, **Then** it names `requests/REQXXXXXX.md` and cites `.highway/library/templates/output/request-record.md` as the complete authoritative structure.
2. **Given** the Request record template, **When** the skill contract is compared with it, **Then** the skill does not independently restate the record's frontmatter, section names, section order, field labels, completeness layout, or Solution Constraints layout.
3. **Given** an incomplete or privacy-blocked intake, **When** `highway-new` handles it, **Then** no Request record is written and evidence collection behavior remains unchanged.

### User Story 2 - Delegate Request Catalog Structure (Priority: P1)

As a repository maintainer, I want `highway-new` to identify the Request catalog template as the sole catalog-structure authority so that catalog layout changes do not require duplicated skill declarations.

**Why this priority**: Request allocation depends on the catalog, and structural duplication in catalog verification can cause drift between the catalog template and the skill contract.

**Independent Test**: Inspect the `highway-new` Outputs and Verification sections and confirm complete catalog-template citation, removal of duplicated catalog-shape assertions, and retention of allocation, retry, transaction, and write-sequencing behavior.

**Acceptance Scenarios**:

1. **Given** the `highway-new` Outputs section, **When** its Request catalog contract is reviewed, **Then** it names `requests/requests.md` and cites `.highway/library/templates/output/request-catalog.md` as the complete authoritative structure.
2. **Given** the `highway-new` Verification section, **When** catalog structure checks are reviewed, **Then** duplicated `Version`, `Next ID`, and index-row shape declarations are absent and template conformance is verified instead.
3. **Given** a catalog allocation conflict or write failure, **When** the workflow aborts or retries, **Then** the existing Request and catalog bytes remain unchanged according to the existing transaction rules.

### User Story 3 - Preserve Behavioral Ownership and Prove Compliance (Priority: P2)

As a maintainer, I want focused checks to prove that moving structure to shared templates does not remove `highway-new` behavior or violate P9.1.

**Why this priority**: The migration is valuable only if structural duplication is removed without weakening evidence collection, privacy handling, deterministic output, allocation safety, or future Discovery handoff behavior.

**Independent Test**: Run focused source-document and disposable-fixture checks, validate the skill, regenerate derived adapters, and run the repository suite; confirm structural defects fail while behavioral checks and generated correspondence pass.

**Acceptance Scenarios**:

1. **Given** a disposable copy of `highway-new` with a missing Request record or catalog citation, **When** the focused contract check runs, **Then** it fails for that citation defect without changing canonical files or user-owned artifacts.
2. **Given** the migrated skill, **When** behavioral contract checks run, **Then** evidence completeness, privacy filtering, deterministic title generation, Solution Constraints collection, allocation, retries, transaction behavior, status `proposed`, incomplete-intake no-write behavior, and Discovery handoff rules remain present.
3. **Given** canonical skill changes, **When** derived adapters are regenerated and the repository suite runs, **Then** adapters correspond to the canonical skill and all applicable validation passes.

### Edge Cases

- The Request record template exists but the skill omits its citation.
- The Request catalog template exists but the skill omits its citation.
- The skill cites a template but still repeats the complete Request section or field order.
- Verification retains catalog-shape assertions instead of checking template conformance.
- A behavioral rule is accidentally removed while structural wording is deleted.
- A disposable citation fixture mutates a canonical skill or generated adapter.
- A generated adapter remains stale after the canonical skill changes.
- A failed allocation, validation, privacy screen, or write leaves partial Request or catalog output.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `highway-new` MUST identify `.highway/library/templates/output/request-record.md` as the authoritative complete structure for retained Request records.
- **FR-002**: `highway-new` MUST identify `.highway/library/templates/output/request-catalog.md` as the authoritative complete structure for the Request catalog.
- **FR-003**: The `highway-new` Outputs section MUST name the user-owned Request record path and cite the complete Request record template without restating its structural contract.
- **FR-004**: The `highway-new` Outputs section MUST name the user-owned Request catalog path and cite the complete Request catalog template without restating its structural contract.
- **FR-005**: The `highway-new` Verification section MUST replace duplicated record-shape checks with verification that generated Request records conform to the cited record template.
- **FR-006**: The `highway-new` Verification section MUST replace duplicated catalog-shape checks with verification that generated Request catalogs conform to the cited catalog template.
- **FR-007**: The migration MUST remove independent declarations of Request frontmatter, section names, section ordering, field labels, completeness layout, Solution Constraints ordering, catalog headings, catalog version, next identifier, index structure, and column ordering from the skill contract.
- **FR-008**: The migration MUST retain evidence collection and completeness behavior, including one-question-at-a-time intake and the seven evidence domains.
- **FR-009**: The migration MUST retain privacy filtering behavior for secrets and regulated personal data, including replacement-evidence handling and no-write behavior when blocked.
- **FR-010**: The migration MUST retain allocation, retry, validation, transaction, and write-sequencing behavior, including exactly-once successful Next ID advancement and preservation of existing bytes on failure.
- **FR-011**: The migration MUST retain deterministic title generation, question/example determinism, status `proposed`, empty-array versus `unknown` semantics, and `allowed_solution_classes` validation.
- **FR-012**: The migration MUST retain Solution Constraints collection order and future Discovery handoff boundaries without selecting an architecture or creating Discovery/ADR artifacts.
- **FR-013**: Focused validation MUST use disposable valid and invalid fixtures to detect missing citations, duplicated structure, removed behavior, and stale generated adapters independently.
- **FR-014**: Focused validation MUST leave canonical skills, shared templates, generated artifacts, and user-owned Request data unchanged.
- **FR-015**: Generated adapters MUST be regenerated from the canonical `highway-new` skill after the migration and correspondence MUST be validated.
- **FR-016**: The implementation MUST preserve Constitution P9.1 compliance for every retained file emitted by `highway-new`.

### Key Entities

- **Request Record Template**: The shared structural authority for Request record frontmatter, body sections, fields, ordering, completeness, and Solution Constraints layout.
- **Request Catalog Template**: The shared structural authority for Request catalog headings, version, next identifier, index, columns, and layout.
- **Highway New Behavioral Contract**: The skill-owned rules for evidence collection, privacy, validation, allocation, determinism, transactions, and Discovery handoff.
- **Contract Validation Fixture**: A disposable valid or invalid copy used to prove citation, duplication, behavior-preservation, and no-write rules.
- **Generated Adapter**: A derived GitHub Copilot, Claude Code, or Cursor representation of the canonical `highway-new` skill.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The `highway-new` Outputs section contains complete citations to both shared Request templates and no independent complete record/catalog structure declaration.
- **SC-002**: The `highway-new` Verification section contains template-conformance checks for both Request record and Request catalog outputs and contains none of the three removed duplicated shape checks.
- **SC-003**: 100% of the required behavioral invariants remain detectable in focused validation: evidence completeness, privacy, allocation, retries, transactions, determinism, status, Solution Constraints, and Discovery handoff.
- **SC-004**: Focused validation independently rejects missing record citation, missing catalog citation, duplicated structure, removed behavior, and stale adapter fixtures while leaving canonical and user-owned files unchanged.
- **SC-005**: Regenerated GitHub Copilot, Claude Code, and Cursor adapters correspond byte-for-byte with the canonical `highway-new` skill, excluding only documented generator metadata where applicable.
- **SC-006**: The complete repository validation suite passes with zero failures after the migration.
- **SC-007**: Existing Request templates, user-owned Request records/catalogs, allocation semantics, privacy semantics, and Discovery handoff semantics remain unchanged.
- **SC-008**: A maintainer can identify the sole Request record and catalog structural authorities from the `highway-new` contract without consulting duplicated skill prose.

## Assumptions

- Feature 062 established the shared-output-contract model and its focused test conventions; Feature 063 narrows that model to `highway-new`.
- `.highway/library/templates/output/request-record.md` and `.highway/library/templates/output/request-catalog.md` remain the canonical Request structure sources.
- Existing Request paths, identifiers, status semantics, allocation rules, privacy rules, and user-owned data are not migrated.
- The migration changes skill wording and validation evidence only; it introduces no runtime, persistence system, external service, or user interface.
- Generated adapters remain derived artifacts and are regenerated after the canonical skill changes.
- Disposable fixtures may be created under temporary directories but must not write to user-owned Request paths.

## Scope Boundaries

### Included in Version 1

- Refactoring the `highway-new` Outputs section to identify authoritative Request record and catalog templates.
- Refactoring the `highway-new` Verification section to remove duplicated structure checks and add template-conformance checks.
- Adding focused disposable fixture coverage for citations, duplicated structure, retained behavior, no-write guarantees, and generated adapter currency.
- Regenerating and validating affected `highway-new` adapters and running the complete repository suite.

### Excluded from Version 1

- Changing the Request record or catalog templates themselves.
- Changing user-owned Request records, catalogs, identifiers, paths, versions, or allocation semantics.
- Changing evidence-domain definitions, privacy policy, Solution Constraints meaning/order, or Discovery/ADR ownership.
- Migrating other emitting skills or revisiting Feature 062's five-baseline scope.
- Introducing a new runtime, parser, persistence mechanism, external interface, or user interface.
- Changing Constitution P9.1 or adding a new governance principle.
