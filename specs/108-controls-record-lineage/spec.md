# Feature Specification: Controls Record Lineage Cleanup

**Feature Branch**: `108-controls-record-lineage`

**Created**: 2026-09-30

**Status**: Draft

**Input**: User description: "Rename retained Control recommendation provenance to Recommendation Grounding, clarify its lineage-only meaning, remove duplicated revalidation and common failure wording, preserve the simplified collection result and NFR boundary, and keep highway-controls at version 4.0.0."

## Clarifications

### Session 2026-09-30

- Q: Should `control-record.md` metadata version change from `1.0.0` to `2.0.0` because renaming the retained optional section changes the record contract? → A: Bump `control-record.md` from `1.0.0` to `2.0.0` and update dependent references.

## User Scenarios & Testing

### User Story 1 - Recommendation Grounding accurately represents lineage (Priority: P1)

As a person reviewing a retained Control, I want recommendation lineage labeled as Recommendation Grounding, so that Highway context and external expertise are not confused with organizational policy or compliance.

**Why this priority**: The retained section is user-visible and must clearly distinguish accepted Control content from Highway-generated lineage.

**Independent Test**: Inspect the Controls skill and Control-record template after the update; verify all retained-grounding terminology uses Recommendation Grounding and the section appears only in the record body.

**Acceptance Scenarios**:

1. **Given** a Highway recommendation materially influenced an accepted Control, **When** the Control is retained, **Then** the body may contain `## Recommendation Grounding` with only the sources that influenced the recommendation.
2. **Given** a Highway artifact was used as recommendation grounding, **When** a stable artifact identifier is available, **Then** that identifier is retained.
3. **Given** external expertise influenced a recommendation, **When** Recommendation Grounding is retained, **Then** it includes enough source or reference information to identify that expertise.
4. **Given** a Control was directly authored without a materially influential Highway recommendation, **When** the record is retained, **Then** Recommendation Grounding is omitted.
5. **Given** Recommendation Grounding is present, **When** a reader interprets it, **Then** it is clearly lineage and not organizational policy, framework applicability, certification, or compliance.

### User Story 2 - Control records preserve their accepted content contract (Priority: P1)

As a Control owner, I want accepted Control content and recommendation lineage separated, so that Title, Statement, and Rationale remain the authoritative Control content while grounding remains optional context.

**Why this priority**: The record template is the structural authority for durable Controls.

**Independent Test**: Validate records with and without grounding; verify unchanged frontmatter, unchanged `nfrs` relationship semantics, required accepted content, and optional body-only Recommendation Grounding.

**Acceptance Scenarios**:

1. **Given** a Control record is created, **When** its frontmatter is read, **Then** it contains exactly the existing `id`, `title`, `status`, and `nfrs` semantics with no grounding field.
2. **Given** a Control record has grounding, **When** its body is read, **Then** it contains `## Recommendation Grounding` after the accepted Control content.
3. **Given** a Control record has no materially influential recommendation, **When** its body is read, **Then** the optional section is absent.
4. **Given** a Control includes NFR relationships, **When** its record is updated, **Then** `nfrs` remains an identifier-only relationship list.

### User Story 3 - Controls 4.0.0 corrections remove duplicate or superseded rules (Priority: P1)

As a maintainer, I want the already-planned 4.0.0 Controls contract corrected without reopening its version, so that the runtime skill contains one authoritative revalidation path and relies on the Constitution for common failure behavior.

**Why this priority**: Duplicate instructions can cause inconsistent execution and undermine the simplified 4.0.0 contract.

**Independent Test**: Scan `highway-controls` for the duplicated revalidation paragraph, the final common-failure sentence, restored `Created Control IDs`, and version drift.

**Acceptance Scenarios**:

1. **Given** the Proposal and Persistence section is read, **When** revalidation instructions are reviewed, **Then** only the retained paragraph beginning `Revalidate the authoritative baseline, catalog, allocation state, and final-proposal overlap before persistence...` remains.
2. **Given** the Error Handling section is read, **When** common failure behavior is reviewed, **Then** `A failed mutation cannot report success.` is absent and the Constitution is the authority.
3. **Given** the Controls collection result is read, **When** its fields are reviewed, **Then** it contains only Action Status, Collection Result, Next Action, and Blocking Reason.
4. **Given** the NFR boundary is read, **When** a new Control is successfully created, **Then** candidate generation is invoked once and subsequent candidate state, review, persistence, and readiness remain NFR-owned.
5. **Given** the corrected skill is versioned, **When** its metadata is read, **Then** `highway-controls` remains `4.0.0`.

### Edge Cases

- Recommendation Grounding is omitted when no Highway recommendation materially influenced the accepted Control.
- Only sources that actually influenced a recommendation are retained; available but unused context is not listed.
- A Highway artifact has no stable identifier; the grounding uses the available identifying reference without inventing an identifier.
- External expertise is named sufficiently for lineage but does not establish applicability, certification, compliance, or policy.
- A directly authored Control is later updated using a recommendation; grounding is added only when the recommendation materially influences the accepted updated content.
- Grounding content is attempted in YAML frontmatter; validation rejects the shape because grounding belongs in the body.
- The collection result must not regain `Created Control IDs`.
- Revalidation appears in another section for a different purpose; only the duplicated first paragraph under Proposal and Persistence is removed.
- A failed mutation follows the Constitution's common failure model without a local duplicate sentence.

## Requirements

### Functional Requirements

- **FR-001**: Every retained-grounding reference in `highway-controls` MUST use `Recommendation Grounding`, not `Provenance`.
- **FR-002**: References to the optional retained body section MUST use `## Recommendation Grounding`.
- **FR-003**: Recommendation Grounding MUST be retained only when a Highway recommendation materially influenced the accepted Control.
- **FR-004**: Recommendation Grounding MUST include only sources that actually influenced the recommendation.
- **FR-005**: Grounding for Highway artifacts MUST retain stable artifact identifiers when available.
- **FR-006**: Grounding for external expertise MUST retain enough source or reference information to identify the expertise used.
- **FR-007**: Recommendation Grounding MUST be described as lineage, not organizational policy, framework applicability, certification, or compliance.
- **FR-008**: Recommendation Grounding MUST remain outside Control frontmatter and MUST NOT be required for directly authored Controls without an influential Highway recommendation.
- **FR-009**: Verification references in `highway-controls` MUST use Recommendation Grounding terminology.
- **FR-010**: The first duplicated revalidation paragraph under `### Proposal and Persistence`, beginning `Before allocation, revalidate the authoritative baseline...`, MUST be removed.
- **FR-011**: The later revalidation paragraph beginning `Revalidate the authoritative baseline, catalog, allocation state, and final-proposal overlap before persistence...` MUST remain.
- **FR-012**: The sentence `A failed mutation cannot report success.` MUST be removed from `highway-controls`; common failure behavior remains governed by the Constitution.
- **FR-013**: The Controls collection result MUST contain only Action Status, Collection Result, Next Action, and Blocking Reason, and MUST NOT contain `Created Control IDs`.
- **FR-014**: The existing simplified NFR boundary MUST remain: a successfully created new Control invokes candidate generation once, while NFRs owns subsequent candidate state, review, persistence, and readiness.
- **FR-015**: `highway-controls` metadata MUST remain version `4.0.0`.
- **FR-016**: `control-record.md` MUST rename `## Provenance` to `## Recommendation Grounding`.
- **FR-017**: `control-record.md` MUST replace the old placeholder with `<recommendation grounding sources that influenced the accepted Control, when applicable>`.
- **FR-018**: The template MUST state that Title, Statement, and Rationale represent accepted Control content, while Recommendation Grounding records lineage for sources that influenced a Highway recommendation and is not organizational policy.
- **FR-019**: The template MUST state that Recommendation Grounding is optional and omitted when no Highway recommendation materially influenced the accepted Control.
- **FR-020**: The template MUST state that Recommendation Grounding may identify accepted Profile evidence, accepted Objective identifiers, existing Highway artifact identifiers, and declared external expertise or framework references.
- **FR-021**: The template MUST state that external grounding does not establish framework applicability, certification, compliance, or organizational policy by itself.
- **FR-022**: The template MUST preserve frontmatter fields `id`, `title`, `status`, and `nfrs`, with `nfrs` remaining identifier-only.
- **FR-023**: `control-record.md` metadata version MUST change from `1.0.0` to `2.0.0`, and all dependent references MUST be updated.
- **FR-024**: Generated adapters, catalogs, and dependent template validations MUST remain aligned with the canonical changes.

### Key Entities

- **Recommendation Grounding**: Optional retained body lineage identifying sources that materially influenced a Highway recommendation accepted into a Control.
- **Accepted Control content**: Title, Statement, and Rationale owned by the Control record.
- **Control record frontmatter**: Existing `id`, `title`, `status`, and identifier-only `nfrs` metadata.
- **Controls collection result**: Four-field owner result containing Action Status, Collection Result, Next Action, and Blocking Reason.
- **NFR owner boundary**: The handoff where Controls invokes candidate generation once and NFRs owns subsequent candidate lifecycle state.

## Success Criteria

### Measurable Outcomes

- **SC-001**: 100% of retained-grounding references in the Controls skill and record template use Recommendation Grounding terminology; 0 `## Provenance` references remain in those artifacts.
- **SC-002**: 100% of recommendation-created Control records retain only materially influential grounding sources, with stable artifact identifiers or identifying external references when available.
- **SC-003**: 100% of directly authored Controls without an influential recommendation omit Recommendation Grounding.
- **SC-004**: 100% of Control records with grounding keep it in the body, never frontmatter; 100% preserve the existing four frontmatter fields and identifier-only `nfrs`.
- **SC-005**: 0 duplicated first revalidation paragraphs and 0 local `A failed mutation cannot report success.` sentences remain in `highway-controls`.
- **SC-006**: 100% of Controls collection-result contract checks find exactly the four required fields and no `Created Control IDs`.
- **SC-007**: `highway-controls` remains `4.0.0`, and the simplified NFR boundary remains unchanged.
- **SC-008**: The full test suite passes with 0 failures and all generated artifacts remain aligned.

## Assumptions

- This is a completion/correction of the existing 4.0.0 Controls contract, not a new skill-version change.
- `control-record.md` remains the structural authority and its metadata version changes from `1.0.0` to `2.0.0` because the renamed retained section changes the record contract.
- Recommendation Grounding is lineage and does not grant organizational acceptance to a recommendation's source.
- Setup synchronization is limited to preserving the already-decided four-field Controls result and not restoring `Created Control IDs`.
- The NFR owner contract remains authoritative for candidate state, review, persistence, and readiness.
- Generated adapters are regenerated from canonical source files and are never hand-edited.
