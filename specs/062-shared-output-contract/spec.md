# Feature Specification: Shared Output Contract Implementation

**Feature Branch**: `062-shared-output-contract`

**Created**: 2026-09-21

**Status**: Draft

**Input**: User description: "Implement the Highway shared-output-contract model consistently across all skills that emit retained artifacts. Templates own artifact structure; skills own behavior. Create authoritative catalog templates where needed and remove duplicated structural descriptions from skill contracts."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Establish Complete Output Contract Coverage (Priority: P1)

As a repository maintainer, I want every retained artifact type to have an authoritative record and catalog structure so that future structural changes have one clear contract owner.

**Why this priority**: Without complete templates, skills and generated artifacts can continue to drift and maintainers cannot validate structural consistency uniformly.

**Independent Test**: Inventory the retained artifact types, confirm each has an authoritative record template and catalog template, and validate each template's required structure and identity.

**Acceptance Scenarios**:

1. **Given** the retained artifact types Request, Objective, Control, NFR, and Discovery, **When** the shared output contract inventory is checked, **Then** each type has an authoritative record template and catalog template under the shared template library.
2. **Given** a catalog template, **When** it is validated, **Then** it declares its artifact identity, version, next identifier, index structure, and stable column ordering.
3. **Given** a template is the authority for a retained artifact, **When** a structural rule changes, **Then** the change can be made in that template without requiring a duplicate structural declaration in a skill.

### User Story 2 - Migrate Skills to Template-Owned Structure (Priority: P1)

As a skill maintainer, I want file-emitting skills to cite complete shared templates instead of repeating record and catalog shape so that workflow behavior remains separate from retained artifact structure.

**Why this priority**: Structural duplication is the source of contract drift and makes validation ambiguous across the Request, Objective, Control, NFR, and Discovery workflows.

**Independent Test**: Inspect each affected skill's Outputs and Verification sections, confirm complete record and catalog template citations, and confirm duplicated structural field, heading, ordering, and catalog-shape declarations are absent while behavioral rules remain present.

**Acceptance Scenarios**:

1. **Given** `highway-new`, **When** its output and verification contract is reviewed, **Then** it cites the request record and catalog templates and retains evidence completeness, privacy, allocation, transaction, and determinism behavior.
2. **Given** `highway-objectives`, `highway-controls`, and `highway-nfrs`, **When** their output and verification contracts are reviewed, **Then** each cites its record and catalog templates and retains allocation, relationship, readiness, versioning, and transaction behavior appropriate to that workflow.
3. **Given** `highway-discovery`, **When** its output and verification contract is reviewed, **Then** it cites the Discovery record and catalog templates while retaining elimination, filtering, scoring, recommendation, traceability, and deterministic-ordering behavior.
4. **Given** a skill emits a retained artifact, **When** its shared template citation is checked, **Then** the citation points to the complete structure contract rather than a partial list of fields or headings.

### User Story 3 - Prove Structural Authority and Regeneration (Priority: P2)

As a repository maintainer, I want focused checks and generated artifacts to prove that templates are authoritative and adapters/catalogs remain current so that contract changes are detectable before release.

**Why this priority**: The ownership model only provides value when validators can detect missing templates, stale citations, duplicated structure, and stale generated outputs.

**Independent Test**: Run focused shared-output validation, mutate a disposable structural fixture, confirm the relevant check fails, restore the fixture, regenerate derived artifacts, and confirm correspondence and full-suite validation pass.

**Acceptance Scenarios**:

1. **Given** a complete template inventory and migrated skills, **When** the shared output contract test runs, **Then** it validates all authoritative record and catalog templates and all affected skill citations.
2. **Given** a disposable fixture with a missing or stale template citation, **When** the focused check runs, **Then** it fails for that targeted defect without modifying canonical artifacts.
3. **Given** canonical skill or template changes, **When** generated adapters and catalogs are regenerated, **Then** the derived outputs correspond to their canonical sources.
4. **Given** all focused checks pass, **When** the repository suite runs, **Then** structural contract, generated-artifact, and regression validation complete without failures.

### Edge Cases

- A record template exists but its corresponding catalog template is missing.
- A catalog template exists but omits its artifact identity, version, next identifier, or index columns.
- A skill cites a record template but describes the catalog structure independently.
- A skill retains a duplicated field or section list after migration.
- A behavioral rule is accidentally removed while structural prose is being removed.
- A generated adapter or catalog remains stale after a canonical template or skill change.
- A disposable validation fixture fails and leaves a mutation in a canonical source or generated artifact.
- Existing user-owned records or catalogs contain legacy structure that is outside this feature's migration scope.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The shared template library MUST provide an authoritative record template and catalog template for Request, Objective, Control, NFR, and Discovery retained artifacts.
- **FR-002**: Each record template MUST own its artifact frontmatter, section names, section ordering, field labels, body layout, table structures, empty-state formatting, and retained-record shape.
- **FR-003**: Each catalog template MUST own its artifact identity, version field, next-identifier field, index headings, column ordering, and catalog layout.
- **FR-004**: `highway-new` MUST cite the complete Request record and catalog templates for output structure and MUST retain evidence completeness, privacy, allocation, transaction, and determinism behavior.
- **FR-005**: `highway-objectives` MUST cite the complete Objective record and catalog templates and MUST NOT duplicate objective body fields or section ordering as an independent structure contract.
- **FR-006**: `highway-controls` MUST cite the complete Control record and catalog templates and MUST NOT duplicate control record or catalog shape as an independent structure contract.
- **FR-007**: `highway-nfrs` MUST cite the complete NFR record and catalog templates and MUST NOT duplicate NFR record or catalog shape as an independent structure contract.
- **FR-008**: `highway-discovery` MUST cite the complete Discovery record and catalog templates and MUST NOT duplicate the complete Discovery section or catalog structure as an independent contract.
- **FR-009**: All migrated skills MUST retain behavioral ownership for workflow, lifecycle, ownership, allocation, versioning, validation, readiness, relationships, transaction guarantees, determinism, and domain-specific decision rules.
- **FR-010**: Structural verification in each migrated skill MUST confirm conformance to the referenced template; behavioral verification MUST remain in the skill.
- **FR-011**: The shared-output validation MUST detect missing authoritative templates, incomplete catalog templates, missing skill citations, duplicated structural declarations, and stale generated artifacts.
- **FR-012**: Focused validation MUST use disposable valid and invalid fixtures where fixture-based behavior is needed, must exercise independently failing invalid cases for each deterministic rule, and must leave canonical sources and generated outputs unchanged.
- **FR-013**: Generated adapters and catalogs MUST be regenerated from canonical sources after shared-output contract changes.
- **FR-014**: Existing user-owned records, catalogs, baselines, relationships, and behavioral semantics MUST remain unchanged unless a separate migration requirement explicitly authorizes a change.
- **FR-015**: The implementation MUST preserve Constitution P9.1 compliance: every skill that emits a retained file cites a shared template for that file's complete structure.

### Key Entities

- **Record Template**: The authoritative structural contract for one retained artifact record, including frontmatter and body shape.
- **Catalog Template**: The authoritative structural contract for one retained artifact catalog, including metadata and index layout.
- **Skill Output Contract**: A skill's citation of the complete templates governing its emitted records and catalogs.
- **Behavioral Contract**: The workflow rules that remain owned by a skill after structure moves to templates.
- **Generated Artifact**: An adapter, catalog, or manifest derived from canonical skill and template sources.
- **Contract Validation Fixture**: A disposable valid or invalid artifact used to prove acceptance, rejection, and no-write behavior.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of the five retained artifact types have both an authoritative record template and an authoritative catalog template.
- **SC-002**: 100% of the five affected skills cite the complete shared templates for every retained file they emit.
- **SC-003**: 0 migrated skills retain duplicated complete record or catalog structure descriptions after validation.
- **SC-004**: 100% of migrated skills retain their required behavioral verification rules after structural prose is removed.
- **SC-005**: Focused shared-output validation detects each seeded missing-template, missing-citation, duplicated-structure, and stale-output defect independently and passes after restoration.
- **SC-006**: Generated adapters, catalogs, and manifests match canonical sources after regeneration, excluding only documented generation timestamps.
- **SC-007**: Existing user-owned records, catalogs, governance baselines, relationships, and behavioral outputs remain byte-for-byte unchanged by focused validation and template-authority checks.
- **SC-008**: The complete repository validation suite passes after the shared-output contract migration.
- **SC-009**: A maintainer can identify the sole structural authority for each retained artifact type from the shared template inventory without consulting duplicated skill prose.

## Assumptions

- The existing Request and Discovery catalog templates remain authoritative and will be refined only where required for consistency with the shared model.
- Objective, Control, and NFR catalog templates will be created from their current catalog behavior without changing user-owned catalog paths or allocation semantics.
- The existing profile YAML template and clarification record template remain valid shared-library contracts but are outside the five retained baseline pairs in this feature's primary scope.
- Feature 061's Discovery contract alignment is the starting baseline; this feature does not reopen its candidate filtering, scoring, or ADR ownership decisions.
- Generated adapters and catalogs remain derived artifacts and are regenerated after canonical source changes.
- Tests and validators may use disposable fixtures and temporary workspaces, but no user-owned artifact is written during focused contract validation.
- No new runtime, persistence system, external interface, or governance baseline is introduced.

## Scope Boundaries

### Included in Version 1

- Authoritative catalog templates for Objective, Control, and NFR, plus consistency review of existing Request and Discovery catalog templates.
- Structural-authority migration of `highway-new`, `highway-objectives`, `highway-controls`, `highway-nfrs`, and `highway-discovery`.
- Replacement of duplicated structural output and verification prose with complete template citations.
- Focused validation for template completeness, skill citations, structural duplication, behavioral preservation, disposable fixture isolation, and generated-artifact correspondence.
- Regeneration of affected adapters, catalogs, and manifests.

### Excluded from Version 1

- Changing user-owned record or catalog paths, identifiers, versions, allocation rules, or retained artifact data.
- Changing Request Solution Constraints collection, Discovery candidate generation, filtering, scoring, recommendation, or ADR ownership semantics.
- Migrating the profile YAML or clarification record contracts beyond confirming they remain compatible with the shared template library.
- Introducing a new parser, runtime, persistence mechanism, external service, or user interface.
- Rewriting behavioral workflows merely to improve wording when no structural ownership decision requires it.
- Changing Constitution P9.1 or adding a new governance principle.
