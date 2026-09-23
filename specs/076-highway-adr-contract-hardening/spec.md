# Feature Specification: Highway ADR Contract Hardening

**Feature Branch**: `076-highway-adr-contract-hardening`

**Created**: 2026-09-22

**Status**: Draft

**Input**: User description: "Create a new spec to address the following with highway-adr: make Decision Confidence mandatory; add ADR-to-Discovery uniqueness verification; clarify Alternative outcome vocabulary; move Supersedes metadata to frontmatter only; add explicit None behavior for Clarification Inputs; add the ADR identifier allocation rule; add a Comparison Matrix projection rule; and verify Recommendation Override is absent when the selected option equals the Discovery recommendation."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Render Complete Decision Confidence (Priority: P1)

As a repository maintainer, I want every ADR to contain a deterministic Decision Confidence section so that accepted decisions have the same output shape even when Discovery does not provide confidence evidence.

**Why this priority**: Confidence is part of the ADR decision record and must not become conditionally absent, because missing sections make downstream review and validation ambiguous.

**Independent Test**: Run ADR contract fixtures with Discovery confidence present and unavailable, then verify both outputs contain Decision Confidence with the required fields and explicit `None` values when evidence is absent.

**Acceptance Scenarios**:

1. **Given** Discovery provides confidence and confidence considerations, **When** an ADR is rendered, **Then** Decision Confidence is present with both values projected without rescoring.
2. **Given** Discovery confidence is unavailable, **When** an ADR is rendered, **Then** Decision Confidence is still present with `Discovery Confidence: None` and `Confidence Considerations: None`.
3. **Given** an ADR output is validated, **When** Decision Confidence is missing or incomplete, **Then** validation fails before any write and preserves all pre-operation bytes.

### User Story 2 - Enforce Discovery Uniqueness and Catalog Allocation (Priority: P1)

As a repository maintainer, I want ADR publication to enforce one ADR per Discovery and allocate identifiers only from the catalog so that the ADR baseline remains traceable and collision-free.

**Why this priority**: Duplicate Discovery references undermine architectural traceability, while allocation outside the catalog can create conflicting identifiers.

**Independent Test**: Run publication fixtures with a duplicate Discovery reference, an available catalog `Next ID`, and conflicting catalog state, then verify duplicate rejection, catalog-only allocation, bounded retries, and no partial writes.

**Acceptance Scenarios**:

1. **Given** the ADR catalog already contains an ADR for the requested Discovery, **When** publication is attempted, **Then** the workflow rejects the request without modifying the existing ADR, catalog, or source artifacts.
2. **Given** no ADR references the requested Discovery, **When** publication succeeds, **Then** the ADR identifier is exactly the catalog's `Next ID` and the catalog advances once.
3. **Given** catalog allocation conflicts persist, **When** the retry limit is exhausted, **Then** publication fails without creating a partial ADR or catalog entry.
4. **Given** the ADR catalog is inspected, **When** uniqueness validation runs, **Then** no two ADR entries reference the same Discovery identifier.

### User Story 3 - Normalize ADR Output Vocabulary and Projection (Priority: P1)

As a repository maintainer, I want alternative outcomes, supersession metadata, Clarification absence, comparison evidence, and recommendation overrides to have one explicit contract so that ADR records are consistent and unambiguous.

**Why this priority**: The current record and skill leave several output choices open, which can produce contradictory interpretations across implementations and generated artifacts.

**Independent Test**: Inspect the canonical ADR skill and templates, then run fixtures for selected/rejected alternatives, optional Clarification, matrix projection, supersession metadata, and recommendation agreement or divergence.

**Acceptance Scenarios**:

1. **Given** an option is selected, **When** Alternatives Considered is rendered, **Then** its outcome is `Selected` and every non-selected option is classified as either `Rejected` or `Evaluated`, with `Evaluated` explicitly meaning viable but not selected and `Rejected` meaning invalid or unsuitable.
2. **Given** no Clarification artifact contributes evidence, **When** the ADR is rendered, **Then** Clarification Inputs contains exactly `None` rather than an empty list or placeholder entry.
3. **Given** an ADR is created, **When** supersession metadata is inspected, **Then** authoritative `supersedes` and `superseded_by` values appear only in frontmatter and are not repeated in the handoff body.
4. **Given** Discovery contains a Comparison Matrix, **When** an ADR is rendered, **Then** the matrix is projected verbatim without recalculation, reordering, or interpretation.
5. **Given** the selected option equals the Discovery recommendation, **When** verification runs, **Then** Recommendation Override is absent.
6. **Given** the selected option differs from the Discovery recommendation, **When** the ADR is rendered, **Then** Recommendation Override appears immediately after Decision with the recommendation, selected option, and rationale.

### Edge Cases

- Discovery has no confidence value or confidence considerations.
- Discovery confidence exists but one confidence field is empty or malformed.
- The ADR catalog contains duplicate Discovery identifiers in existing rows.
- The requested Discovery has a duplicate ADR in a malformed or differently ordered catalog.
- The catalog `Next ID` is missing, malformed, already used, or changes during allocation.
- Alternatives contain an outcome outside `Selected`, `Rejected`, or `Evaluated`.
- An `Evaluated` alternative is described as invalid or unsuitable, or a `Rejected` alternative is described as viable but not selected.
- Clarification is missing, unavailable, malformed, or limited to excluded `CLAR-ADR######` input.
- The Comparison Matrix contains formatting or ordering that must remain byte-for-byte unchanged.
- Recommendation Override is rendered despite recommendation agreement, or omitted despite a divergent selection.
- A validation failure occurs after a proposed ADR or catalog has been assembled; all source and destination bytes must remain unchanged.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The ADR workflow MUST always render a Decision Confidence section.
- **FR-002**: The Decision Confidence section MUST contain `Discovery Confidence` and `Confidence Considerations` fields.
- **FR-003**: When Discovery confidence is unavailable, the ADR MUST render `Discovery Confidence: None` and `Confidence Considerations: None`.
- **FR-004**: The ADR workflow MUST reject any output missing Decision Confidence or either required confidence field before writing.
- **FR-005**: The ADR workflow MUST verify through the authoritative ADR catalog that no two ADR records reference the same Discovery identifier.
- **FR-006**: Duplicate Discovery references MUST be rejected before ADR or catalog writes, preserving all pre-operation bytes.
- **FR-007**: ADR identifiers MUST be allocated only from the ADR catalog `Next ID` value.
- **FR-008**: A successful ADR publication MUST advance the catalog `Next ID` exactly once and create exactly one corresponding index entry.
- **FR-009**: Alternative outcomes MUST use only `Selected`, `Rejected`, or `Evaluated`.
- **FR-010**: `Evaluated` MUST mean viable but not selected, and `Rejected` MUST mean invalid or unsuitable; the distinction MUST be stated in the canonical ADR contract.
- **FR-011**: Exactly one Discovery option MUST be marked `Selected`; every other Discovery option MUST be marked `Rejected` or `Evaluated`.
- **FR-012**: Authoritative supersession values MUST appear only in ADR frontmatter as `supersedes` and `superseded_by`.
- **FR-013**: The ADR body and Reference Architecture Handoff MUST NOT repeat supersession metadata fields or values; the canonical `adr-record.md` template MUST remove `Supersedes` and `Superseded By` from the handoff body.
- **FR-014**: When no Clarification evidence contributes, the canonical ADR template and generated ADR MUST render `## Clarification Inputs` followed by exactly `None`, not `- None` or an empty list.
- **FR-015**: The ADR workflow MUST project the Discovery Comparison Matrix verbatim without recalculation, reordering, or semantic transformation.
- **FR-016**: Recommendation Override MUST be absent when the selected option equals the Discovery recommendation.
- **FR-017**: Recommendation Override MUST appear immediately after Decision when the selected option differs from the Discovery recommendation and MUST include the recommended option, selected option, and rationale.
- **FR-018**: Verification MUST explicitly check both Recommendation Override conditions: absence on agreement and presence with complete fields on divergence.
- **FR-019**: Invalid confidence shape, duplicate Discovery reference, malformed catalog allocation, invalid alternative outcome, duplicated supersession metadata, missing Clarification `None`, altered Comparison Matrix, or incorrect Recommendation Override behavior MUST fail validation before any write.
- **FR-020**: Generated catalogs, distributed agent adapters, shared output templates, and retained documentation MUST remain synchronized with the canonical ADR skill and output templates after this feature changes them; a distributed agent adapter is a generated copy of the canonical skill for a supported agent tree.
- **FR-021**: Existing ADR ownership boundaries, source immutability, deterministic ordering, accepted initial status, and Reference Architecture-only authorization MUST remain unchanged.
- **FR-022**: The implementation MUST update `adr-record.md` so that `Clarification Inputs` uses the scalar `None` representation rather than list-item rendering, and so that `Supersedes` and `Superseded By` are absent from the Reference Architecture Handoff body.
- **FR-023**: ADR validator fixtures MUST reject an `Evaluated` alternative described as invalid or unsuitable and a `Rejected` alternative described as viable but not selected.
- **FR-024**: The `highway-adr` Verification section MUST explicitly confirm mandatory Decision Confidence, Recommendation Override absence or presence according to selection, catalog-based Discovery uniqueness, scalar Clarification `None` rendering, and allocation from the catalog `Next ID`.

## Key Entities *(include if feature involves data)*

- **Decision Confidence**: The mandatory ADR section containing Discovery confidence and confidence considerations, each with a valid value or explicit `None`.
- **ADR-to-Discovery Uniqueness Set**: The set of Discovery identifiers referenced by existing ADR catalog entries; each identifier may occur at most once.
- **ADR Allocation Cursor**: The catalog-owned `Next ID` value from which the next ADR identifier is allocated.
- **Alternative Outcome**: The controlled classification of an option as `Selected`, `Rejected`, or `Evaluated`, with explicit meanings for the latter two.
- **Supersession Metadata**: The authoritative `supersedes` and `superseded_by` frontmatter fields.
- **Clarification Input State**: The deterministic `None` representation or contributing Clarification snapshot used by an ADR.
- **Comparison Matrix Projection**: The verbatim Discovery matrix retained in the ADR without recalculation or transformation.
- **Recommendation Override**: The conditional ADR section rendered only when selection differs from the Discovery recommendation.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of valid ADR outputs contain Decision Confidence with both required fields, including explicit `None` values when Discovery confidence is unavailable.
- **SC-002**: 100% of duplicate ADR-to-Discovery references are detected before writes and leave ADR, catalog, and source bytes unchanged.
- **SC-003**: 100% of successful ADR allocations use the catalog `Next ID`, advance it once, and add one direct index entry.
- **SC-004**: 100% of alternatives use only the three defined outcome values, and the meanings of `Evaluated` and `Rejected` are identical in the skill, template, tests, and generated adapters.
- **SC-005**: 100% of initial ADR records contain supersession metadata only in frontmatter and contain no duplicate body or handoff representation.
- **SC-006**: 100% of ADR outputs without contributing Clarification evidence render exactly `Clarification Inputs` followed by `None`.
- **SC-007**: 100% of ADR Comparison Matrices match the Discovery matrix character-for-character after both sources are normalized to LF line endings and canonical serialization in projection fixtures.
- **SC-008**: Recommendation Override is absent in 100% of recommendation-agreement fixtures and present with all required fields in 100% of divergent-selection fixtures.
- **SC-009**: Focused ADR contract tests, output-template tests, validators, generator correspondence tests, and the full repository suite pass with zero failures after implementation.
- **SC-010**: A canonical and generated-artifact search finds no contradictory alternative vocabulary, duplicate supersession body fields, missing allocation rule, or ambiguous confidence optionality.
- **SC-011**: All invalid confidence, uniqueness, allocation, alternative, supersession, Clarification, matrix, and override cases fail before any partial write.
- **SC-012**: Reviewers can determine the complete ADR output shape and ownership rules from the canonical skill and templates without relying on unstated implementation conventions.
- **SC-013**: 100% of successful ADR allocations use the catalog `Next ID` value that existed immediately before the write, without substitution, inference, or regeneration.
- **SC-014**: The implemented `adr-record.md` contains scalar `None` under `## Clarification Inputs` when no Clarification contributes and contains no `Supersedes` or `Superseded By` fields in the Reference Architecture Handoff body.
- **SC-015**: Validator fixtures reject both invalid alternative semantic pairings defined by FR-023 before any write.
- **SC-016**: The implemented `highway-adr` Verification section names and checks all five safeguards required by FR-024.

## Assumptions

- Feature 075 remains the authoritative baseline for the ADR workflow; this feature hardens its contract without changing ADR ownership or introducing a new workflow.
- `ADRXXXXXX`, `DISC######`, and `OPTXXXXXX` retain their existing identifier formats.
- The ADR catalog remains the authoritative owner of `Next ID` and direct ADR index entries.
- `Evaluated` and `Rejected` remain available as distinct non-selected outcomes, with the meanings defined by this specification.
- Missing Discovery confidence is represented by explicit `None` values rather than by removing the section or inventing a confidence value.
- Missing contributing Clarification evidence is represented by exactly `None` in Clarification Inputs.
- No runtime service, package, external dependency, or new persistence mechanism is required.
- Existing generated artifacts are regenerated from canonical inputs and are never hand-edited.
