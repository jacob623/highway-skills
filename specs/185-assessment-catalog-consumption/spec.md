# Feature Specification: Assessment Catalog Consumption

**Feature Branch**: `185-assessment-catalog-consumption`

**Created**: 2026-10-17

**Status**: Draft

**Input**: User description: "Update highway-assessment to consume the Capability Catalog and existing implementation catalogs directly rather than forcing capability and technology analysis through architecture traversal."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Start Assessment from Authoritative Catalogs (Priority: P1)

As a repository owner, I want assessment to begin with the authoritative ADR, Architecture, Reference Implementation, and Capability catalogs so that analysis can navigate the repository landscape without opening every source record first.

**Why this priority**: Catalog-first analysis reduces unnecessary traversal and gives assessment a stable, direct view of the repository's accepted implementation and capability landscape.

**Independent Test**: Provide valid ADR, Architecture, Implementation, and Capability catalogs plus source records that contain additional details, run assessment for each supported domain, and verify that catalogs are read first and source records are opened only when additional evidence is needed.

**Acceptance Scenarios**:

1. **Given** the four authoritative catalogs are available, **when** assessment begins, **then** it can resolve ADRs, Reference Architectures, Reference Implementations, and capabilities from catalog entries before opening source records.
2. **Given** a catalog entry contains enough evidence for an observation, **when** assessment evaluates it, **then** it does not require architecture traversal or source-record access to produce that observation.
3. **Given** a catalog entry requires supporting detail, **when** assessment evaluates it, **then** it opens only the associated ADR, Architecture, or Implementation record needed for that detail.
4. **Given** a required catalog is missing, malformed, or unreadable, **when** assessment evaluates the affected relationship, **then** it preserves uncertainty, reports the unavailable evidence where relevant, and does not invent a replacement inventory.

### User Story 2 - Assess Capabilities, Providers, and Implementation Patterns (Priority: P1)

As a repository owner, I want assessment to use Capability Catalog rows and Realized By values directly so that capability coverage, provider concentration, technology adoption patterns, reuse, and implementation distribution can be identified without treating architecture traversal as the only path.

**Why this priority**: Direct capability and implementation evidence makes assessment more complete and prevents useful repository knowledge from being hidden behind unrelated architecture relationships.

**Independent Test**: Provide capabilities realized by multiple providers and shared across multiple Reference Implementations, run architecture, implementation, and portfolio assessment, and verify grounded findings use the existing categories and direct catalog evidence.

**Acceptance Scenarios**:

1. **Given** `implementations/capabilities.md` contains realized capabilities, **when** portfolio assessment runs, **then** capability coverage and repository landscape observations may be grounded directly in those rows.
2. **Given** Capability Catalog rows contain repeated Realized By values, **when** implementation assessment runs, **then** it can identify provider concentration or shared realization patterns without inferring a separate technology inventory.
3. **Given** multiple Reference Implementations share capability realization patterns, **when** implementation assessment runs, **then** it can identify implementation reuse using the Capability Catalog and Implementation Catalog.
4. **Given** a capability has no corresponding architectural representation, **when** architecture assessment runs, **then** it may surface a capability-to-architecture coverage finding without requiring architecture traversal to discover that the capability exists.
5. **Given** accepted implementation evidence identifies dependencies, **when** implementation assessment runs, **then** it may use the Implementation Catalog to locate affected implementations before opening their source records.

### User Story 3 - Preserve Assessment Ownership and Determinism (Priority: P1)

As a governance owner, I want catalog consumption to remain advisory and read-only so that assessment can expose useful relationships without creating capability artifacts, changing catalog ownership, or producing nondeterministic findings.

**Why this priority**: The catalogs belong to their owning workflows; assessment must remain an analysis and findings workflow rather than becoming a second capability or implementation publisher.

**Independent Test**: Run assessment with identical catalog inputs repeatedly, compare findings and all source bytes, and verify that no capability identifier, catalog, record, relationship, or publication state changes.

**Acceptance Scenarios**:

1. **Given** assessment reads Capability and Implementation Catalogs, **when** it completes, **then** it creates, updates, allocates, or re-indexes no capability or implementation artifacts.
2. **Given** identical accepted catalog inputs and findings state, **when** assessment runs repeatedly, **then** the resulting observations and finding identities are identical.
3. **Given** a requester asks assessment to create or change a capability, provider, implementation, or catalog, **when** assessment handles the request, **then** it routes the request to the owning workflow without performing the mutation.
4. **Given** a capability-related observation is proposed, **when** it is presented for review, **then** it uses one existing finding category and remains advisory until the requester dispositions it.

### Edge Cases

- The ADR, Architecture, Implementation, or Capability catalog is absent, empty, malformed, duplicated, or unreadable; affected analysis remains unknown or reports unavailable evidence without manufacturing a replacement catalog.
- A catalog row points to a missing, malformed, duplicated, or non-accepted source record; assessment retains the catalog reference, excludes unsupported detail, and does not infer facts from the unresolved record.
- A Capability Catalog row contains multiple Realized By values, repeated providers, or the same capability title under multiple Reference Implementations; assessment preserves each direct relationship and does not merge distinct RI parents.
- A capability exists without a corresponding architecture representation; architecture assessment may report a Coverage finding rather than failing or forcing traversal.
- A provider appears across many capability rows or implementations; assessment may report Reuse, Opportunity, or Risk using direct catalog evidence, but must not create a technology inventory.
- Catalogs contain equivalent rows in different file orders; normalized assessment inputs produce the same finding identity and result ordering.
- A source record contains information that conflicts with its catalog index entry; the catalog remains the authoritative index for navigation while the source record remains authoritative for detailed evidence, and the inconsistency may be reported.
- A requester asks assessment to allocate a CAP identifier, publish a capability, update an implementation, or re-index a catalog; assessment routes the request and performs no owner mutation.
- No accepted catalog evidence supports a proposed capability, provider, technology, or landscape observation; the finding is not created.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The `highway-assessment` workflow MUST accept the ADR catalog at `adrs/adrs.md` as repository context.
- **FR-002**: The workflow MUST accept the Reference Architecture catalog at `architectures/architectures.md` as repository context.
- **FR-003**: The workflow MUST accept the Reference Implementation catalog at `implementations/implementations.md` as repository context.
- **FR-004**: The workflow MUST accept the Capability Catalog at `implementations/capabilities.md` as repository context.
- **FR-005**: The workflow MUST be able to open associated ADR, Reference Architecture, and Reference Implementation records only when additional supporting evidence is required.
- **FR-006**: Assessment input guidance MUST state that catalog indexes are the starting point for navigation and source records are opened selectively for detailed evidence.
- **FR-007**: Assessment MUST treat accepted catalog entries as authoritative indexes for resolving their referenced artifacts and relationships.
- **FR-008**: Source ADR, Architecture, and Implementation records MUST remain authoritative for detailed evidence, rationale, constraints, dependencies, and other retained record content.
- **FR-009**: Assessment MAY derive implementation observations from accepted Capability Catalog rows.
- **FR-010**: Assessment MAY derive provider, platform, and realization observations from Capability Catalog `Realized By` values.
- **FR-011**: Assessment MUST NOT create, update, allocate, or re-index capabilities, Capability Catalog entries, capability records, or capability relationships.
- **FR-012**: Portfolio assessment MUST be able to evaluate capability coverage through `implementations/capabilities.md`.
- **FR-013**: Portfolio assessment MUST be able to evaluate technology adoption patterns through Reference Implementations and Capability Catalog `Realized By` values.
- **FR-014**: Portfolio assessment MAY derive repository landscape observations collectively from ADR, Reference Architecture, Reference Implementation, and Capability Catalog evidence.
- **FR-015**: Assessment MUST prefer accepted repository evidence over inferred technology inventories and MUST NOT create a separate technology inventory.
- **FR-016**: Architecture assessment MUST be able to compare architecture coverage against realized capabilities.
- **FR-017**: Architecture assessment MAY surface capability-to-architecture gaps when accepted capabilities have no corresponding architectural representation.
- **FR-018**: Architecture assessment MAY identify architecture reuse through shared capability realization patterns.
- **FR-019**: Implementation assessment MUST be able to identify implementation reuse through common capability realization patterns.
- **FR-020**: Implementation assessment MUST be able to identify provider concentration through Capability Catalog `Realized By` values.
- **FR-021**: Implementation assessment MUST be able to identify implementation dependencies through accepted implementation evidence.
- **FR-022**: Implementation assessment MUST use the Implementation Catalog to locate and assess implementation distribution before opening source records.
- **FR-023**: Capability-related findings MUST use only the existing categories Coverage, Consistency, Dependency, Opportunity, Reuse, and Risk.
- **FR-024**: Capability-related findings MUST remain advisory and MUST follow the existing finding review, disposition, identity, and persistence rules.
- **FR-025**: Assessment MUST NOT add capability ownership rules, capability allocation logic, capability identifier generation, Capability Catalog structure definitions, capability publication rules, implementation publication rules, architecture publication rules, or a new assessment-specific capability artifact family.
- **FR-026**: Assessment MUST route requests for capability, catalog, implementation, or architecture mutations to the responsible owner workflow without performing the mutation.
- **FR-027**: Catalog and source-record resolution MUST preserve uncertainty when evidence is missing, unsupported, malformed, or conflicting and MUST NOT manufacture organizational facts.
- **FR-028**: Assessment MUST produce identical finding identities and equivalent observations for identical accepted catalog inputs, findings state, and relevant source evidence, regardless of catalog row order.
- **FR-029**: Assessment MUST preserve the existing assessment finding categories, statuses, display IDs, fingerprints, revision rules, and retained findings artifact.
- **FR-030**: Verification MUST confirm catalog-first navigation, selective source access, direct Capability Catalog provider analysis, Implementation Catalog lookup, no architecture traversal requirement when catalog evidence is sufficient, no owner mutations, and deterministic repeated results.
- **FR-031**: The additive assessment contract change MUST use a MINOR version increment from the current assessment skill version.

### Key Entities

- **ADR Catalog**: The accepted index at `adrs/adrs.md` used to resolve ADR records before detailed evidence is opened.
- **Reference Architecture Catalog**: The accepted index at `architectures/architectures.md` used to resolve architecture records and relationships.
- **Reference Implementation Catalog**: The accepted index at `implementations/implementations.md` used to locate implementations and assess implementation distribution.
- **Capability Catalog**: The generated index at `implementations/capabilities.md`, containing capability IDs, RI parents, business-readable titles, and Realized By values; it is owned by `highway-implementation`.
- **Catalog Entry**: An accepted index row used for navigation and relationship analysis before opening its source record.
- **Realized By Value**: A provider, platform, product, technology, service, process, or mechanism associated with a capability in the Capability Catalog.
- **Assessment Finding**: An advisory observation using the existing categories, statuses, identity, disposition, and persistence rules.
- **Source Record**: An ADR, Reference Architecture, or Reference Implementation record opened when catalog evidence alone is insufficient.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of assessment runs with valid catalogs, ADR, Architecture, Implementation, and Capability Catalog indexes are available to assessment before source-record traversal begins.
- **SC-002**: In 100% of sampled observations supported by catalog evidence alone, assessment produces the observation without opening an unrelated source record or requiring architecture traversal.
- **SC-003**: In 100% of provider-analysis fixtures, assessment identifies providers directly from Capability Catalog `Realized By` values without creating a technology inventory.
- **SC-004**: In 100% of implementation-analysis fixtures, assessment can identify the relevant Reference Implementations through the Implementation Catalog before opening their source records.
- **SC-005**: In 100% of repeated runs with identical accepted catalogs and source evidence, finding identities and equivalent observations remain identical regardless of catalog row order.
- **SC-006**: In 100% of assessment runs, no capability identifier, Capability Catalog entry, capability record, capability relationship, implementation publication, or architecture publication is created or changed.
- **SC-007**: At least 90% of reviewed capability-related findings are correctly recognized by reviewers as belonging to an existing finding category and remaining advisory.
- **SC-008**: In 100% of unsupported or unavailable catalog fixtures, assessment preserves uncertainty and creates no unsupported finding or inferred technology inventory.

## Assumptions

- `highway-implementation` remains the sole owner of realized capabilities, Capability Catalog structure, CAP identifier allocation, capability publication, and implementation publication.
- ADR, Reference Architecture, Reference Implementation, and Capability Catalog paths remain the authoritative repository locations for the MVP.
- Catalogs are accepted repository indexes; detailed source records may contain evidence not represented in their indexes.
- Assessment continues to persist findings only in `.highway/library/knowledge/assessment-findings.md` and retains its existing statuses, dispositions, fingerprints, and revision behavior.
- Catalog-first navigation is an additive enhancement to the existing `architectures`, `implementations`, and `portfolio` domains; no new assessment domain is required.
- Missing optional supporting records do not block analysis when catalog evidence is sufficient; unsupported conclusions remain unknown.
- No live external integrations, automated remediation, technology inventory, or cross-workflow publication is required for this feature.

## Scope Boundaries

### Included in Version 1

- ADR, Reference Architecture, Reference Implementation, and Capability Catalog inputs.
- Catalog-first navigation with selective source-record access.
- Capability, provider, realization, implementation reuse, concentration, distribution, and landscape observations.
- Architecture coverage comparison against realized capabilities.
- Existing finding categories, advisory review, deterministic identity, and findings persistence.
- MINOR assessment contract version increment.

### Excluded from Version 1

- Capability ownership, capability allocation, CAP identifier generation, capability publication, or Capability Catalog maintenance.
- Reference Implementation, Reference Architecture, ADR, or catalog publication and mutation.
- A new capability, technology inventory, or assessment-specific artifact family.
- New assessment finding categories, statuses, persistence records, or acceptance boundaries.
- Inferred technology inventories or findings unsupported by accepted catalog or source evidence.
