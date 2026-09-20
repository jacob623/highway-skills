# Feature Specification: Discovery Contract Consolidation

**Feature Branch**: `052-discovery-contract-consolidation`

**Created**: 2026-09-19

**Status**: Draft

**Input**: User description: "Create a new spec for updates to the highway-discovery skill: merge the Verification and Verification Expectations sections, merge the Error Handling and Error Handling Expectations sections, and replace the Workflow wording that says prefer a matched architecture with a direct reference to the Tie-Break Evaluation section."

## User Scenarios & Testing

### User Story 1 - Consolidate verification and failure contracts (Priority: P1)

A repository owner reads the Discovery skill and finds one complete Verification contract and one
complete Error Handling contract, without duplicate sections that could drift apart.

**Why this priority**: Verification and failure behavior are core contract boundaries. Duplicate
sections make it unclear which requirements govern the skill and allow contradictory edits.

**Independent Test**: Inspect the Discovery skill and confirm exactly one `## Verification` section
contains the prior Verification and Verification Expectations requirements, and exactly one
`## Error Handling` section contains the prior Error Handling and Error Handling Expectations
requirements.

**Acceptance Scenarios**:

1. **Given** the current Discovery skill contains both Verification sections, **when** the contract is consolidated, **then** one Verification section preserves all existing verification requirements, including explicit matching, unique counting, malformed exclusion, zero-count behavior, score and confidence preservation, tie-break order, early stopping, determinism, and ADR ownership.
2. **Given** the current Discovery skill contains both Error Handling sections, **when** the contract is consolidated, **then** one Error Handling section preserves all existing failure behavior, including malformed, unreadable, duplicate-path, absent, unreadable-catalog, inconsistent-catalog, match-failure, source-failure, no-output, byte-preservation, and ADR-boundary behavior.
3. **Given** the consolidated skill is reviewed, **when** section headings are counted, **then** `## Verification Expectations` and `## Error Handling Expectations` no longer exist as separate headings.

### User Story 2 - Make Workflow tie-break authority explicit (Priority: P1)

An ADR reviewer reads the Discovery Workflow and is directed to the authoritative Recommendation
Tie-Break Evaluation section instead of encountering a second, abbreviated tie-break rule.

**Why this priority**: A direct section reference keeps tie-break behavior centralized and prevents
Workflow wording from diverging from the ordered tie-break contract.

**Independent Test**: Inspect Workflow step 10 and confirm it directly references the Recommendation
Tie-Break Evaluation section, does not use the phrase `prefer a matched architecture`, and preserves
matrix-before-Recommendation ordering.

**Acceptance Scenarios**:

1. **Given** Workflow step 10 currently embeds `prefer a matched architecture`, **when** the wording is updated, **then** the step directs readers to the Recommendation Tie-Break Evaluation section.
2. **Given** the Workflow is updated, **when** the complete skill is reviewed, **then** the authoritative Tie-Break Evaluation section remains the only detailed source for tie-break criteria, ordering, and early stopping.
3. **Given** the Workflow renders the Comparison Matrix, **when** tie handling is referenced, **then** the matrix-before-Recommendation sequence remains unchanged.

### Edge Cases

- Consolidation must not drop requirements that appear only in the Expectations sections.
- Consolidation must not create two `## Verification` or two `## Error Handling` headings.
- The merged sections must retain no-output, existing-byte preservation, and ADR ownership boundaries.
- The Workflow reference must not introduce a second tie-break algorithm or alter score and confidence semantics.
- The generated agent adapters must remain synchronized with the authoritative Discovery skill after implementation.

## Requirements

### Functional Requirements

- **FR-001**: The Discovery skill MUST contain exactly one `## Verification` section.
- **FR-002**: The consolidated Verification section MUST preserve explicit matching, unique counting, malformed exclusion, zero-count fallbacks, score preservation, confidence preservation, tie-break order, immediate stopping, deterministic repetition, and unchanged ADR ownership requirements.
- **FR-003**: The Discovery skill MUST NOT contain a separate `## Verification Expectations` section after consolidation.
- **FR-004**: The Discovery skill MUST contain exactly one `## Error Handling` section.
- **FR-005**: The consolidated Error Handling section MUST preserve malformed, unreadable, duplicate-path, absent-catalog, unreadable-catalog, inconsistent-catalog, match-failure, source-failure, no-output, byte-preservation, ADR-creation, decision, authorization, and governance-mutation behavior.
- **FR-006**: The Discovery skill MUST NOT contain a separate `## Error Handling Expectations` section after consolidation.
- **FR-007**: Workflow step 10 MUST directly reference the Recommendation Tie-Break Evaluation section for equal-score tie handling.
- **FR-008**: Workflow step 10 MUST NOT use the wording `prefer a matched architecture`.
- **FR-009**: Workflow step 10 MUST preserve rendering the complete Comparison Matrix before the Recommendation.
- **FR-010**: The consolidated contract MUST preserve Recommendation score, confidence, rationale, ranking, and ADR ownership invariants.
- **FR-011**: Generated agent adapters MUST remain synchronized with the authoritative Discovery skill after the change.
- **FR-012**: The change MUST NOT create an ADR, record a decision, authorize implementation, or mutate governance baselines.

## Key Entities

- **Verification Contract**: The single Discovery section containing structural, determinism, tie-break, invariant, and ownership checks.
- **Error Handling Contract**: The single Discovery section containing input, evaluation, write-failure, no-output, byte-preservation, and governance-boundary behavior.
- **Recommendation Tie-Break Evaluation**: The authoritative section referenced by Workflow for equal-score tie handling.
- **Workflow Step 10**: The matrix and Recommendation sequencing step that delegates tie handling to the authoritative tie-break section.
- **Generated Discovery Adapter**: Each agent-facing Discovery skill copy that must remain synchronized with the authoritative source.

## Success Criteria

### Measurable Outcomes

- **SC-001**: 100% of Discovery skill copies contain exactly one Verification section and exactly one Error Handling section after implementation.
- **SC-002**: 100% of verification requirements from both pre-consolidation sections remain present in the merged Verification section.
- **SC-003**: 100% of error-handling requirements from both pre-consolidation sections remain present in the merged Error Handling section.
- **SC-004**: 100% of Workflow step 10 tie handling directs readers to the Recommendation Tie-Break Evaluation section and contains zero occurrences of `prefer a matched architecture`.
- **SC-005**: 100% of generated Discovery adapters match the authoritative source according to the repository's adapter validation.
- **SC-006**: 100% of existing focused and full repository validation checks pass after the consolidation.

## Assumptions

- Feature 051 is the governing baseline for the current Discovery contract contents.
- The authoritative Discovery source remains `.highway/skills/highway-discovery/SKILL.md`.
- Agent-facing Discovery adapters are generated from the authoritative source and are not hand-edited.
- The Recommendation Tie-Break Evaluation section remains the sole detailed source for tie-break criteria.
- No runtime evaluator or new dependency is required; this feature changes the skill contract and its validation evidence only.

## Scope Boundaries

### Included in Version 1

- Merge Verification with Verification Expectations.
- Merge Error Handling with Error Handling Expectations.
- Replace Workflow step 10's embedded preference wording with a direct Recommendation Tie-Break Evaluation reference.
- Add or update focused validation for unique section headings, requirement preservation, direct Workflow reference, adapter synchronization, and existing invariants.

### Excluded from Version 1

- Changing Recommendation scoring or confidence calculation.
- Changing Reference Implementation matching or counting semantics.
- Changing Recommendation Tie-Break Evaluation criteria or order.
- Creating or modifying ADR decisions.
- Changing output templates, generators, packaging manifests, or governance baselines.
