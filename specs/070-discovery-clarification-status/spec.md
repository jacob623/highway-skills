# Feature Specification: Discovery Clarification Status Rules

**Feature Branch**: `070-discovery-clarification-status`

**Created**: 2026-09-22

**Status**: Draft

**Input**: User description: "Enhance the highway-discovery Clarification Consumption Contract with explicit status handling, evidence precedence, open and resolved finding rules, verification rules, stronger invalid-artifact handling, determinism guarantees, and a minor version update without changing Discovery outputs, ownership boundaries, scoring, recommendation logic, or ADR contracts."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Interpret Clarification Status Consistently (Priority: P1)

As a repository maintainer, I want Discovery to interpret each Clarification status consistently so that advisory analysis reflects the available evidence without allowing Clarification lifecycle state to control architectural decisions.

**Why this priority**: Status is the controlling condition for whether open uncertainty, accepted responses, or blocked-state risk may be projected into Discovery analysis.

**Independent Test**: Run Discovery with equivalent Requests and Clarification artifacts in `not-started`, `in-progress`, `complete`, and `blocked` states, then verify the allowed advisory projections while comparing candidate generation, scores, ordering, recommendation totals, selection, and ADR ownership.

**Acceptance Scenarios**:

1. **Given** a Clarification artifact with `not-started` status, **When** Discovery consumes it, **Then** no Clarification evidence is projected and Discovery proceeds normally.
2. **Given** a Clarification artifact with `in-progress` status and open findings, **When** Discovery consumes it, **Then** open findings may contribute to Assumptions, Unknowns, Risks, and confidence rationale, while responses may contribute to Research Findings.
3. **Given** a Clarification artifact with `complete` status and accepted responses, **When** Discovery consumes it, **Then** responses may contribute to Research Findings and no open-finding uncertainty is introduced.
4. **Given** a Clarification artifact with `blocked` status, **When** Discovery consumes it, **Then** Discovery may record advisory risk evidence and continues to analysis, recommendation generation, and ADR handoff.
5. **Given** any Clarification status, **When** Discovery evaluates candidates, **Then** status does not affect candidate generation, filtering, scores, ordering, recommendation selection, or ADR ownership.

---

### User Story 2 - Preserve Evidence Authority and Finding Meaning (Priority: P1)

As a repository maintainer, I want Request evidence to remain authoritative and finding state to determine how Clarification evidence is projected so that responses clarify the Request without silently rewriting it.

**Why this priority**: Clear precedence prevents advisory Clarification material from becoming an implicit replacement for the user-owned Request or from turning resolved findings into lingering uncertainty.

**Independent Test**: Supply conflicting Request and Clarification response text plus both open and resolved findings, then verify Request evidence is retained as authoritative, disagreement is recorded only as advisory risk evidence, open findings remain uncertainty, and resolved findings contribute only accepted-response evidence.

**Acceptance Scenarios**:

1. **Given** Request evidence and a conflicting Clarification response, **When** Discovery analyzes the inputs, **Then** Request evidence remains authoritative and the disagreement may contribute advisory risk evidence.
2. **Given** an open finding, **When** Discovery consumes it, **Then** it may contribute to Assumptions, Unknowns, Risks, and confidence rationale but not to candidate evaluation.
3. **Given** a resolved finding with an accepted response, **When** Discovery consumes it, **Then** the response may contribute to Research Findings and the finding does not contribute uncertainty, Unknowns, or unresolved-risk evidence.
4. **Given** any Clarification response, **When** Discovery renders evidence, **Then** the response supplements, explains, or clarifies Request evidence without overwriting, replacing, or modifying the Request.
5. **Given** open and resolved findings together, **When** Discovery renders its existing record, **Then** the evidence appears through existing Research Findings, Assumptions, Risks, Unknowns, or confidence rationale sections without a new Clarification section.

---

### User Story 3 - Reject Invalid Evidence Without Blocking Discovery (Priority: P1)

As a repository maintainer, I want invalid Clarification records to be treated as unavailable so that Discovery remains usable and Clarification remains unchanged when status or count integrity is not valid.

**Why this priority**: Optional advisory evidence must not become a hidden prerequisite, and invalid records must not be repaired by a consuming skill.

**Independent Test**: Run Discovery with unreadable, malformed, path-mismatched, state-invalid, and count-invalid Clarification artifacts, then verify it preserves all bytes, continues normally, and optionally records advisory risk evidence without mutation.

**Acceptance Scenarios**:

1. **Given** a referenced Clarification artifact is unreadable, malformed, or path-mismatched, **When** Discovery resolves it, **Then** the artifact is treated as unavailable and Discovery continues normally.
2. **Given** a Clarification artifact has an invalid state or inconsistent counts, **When** Discovery resolves it, **Then** it is treated as unavailable, its bytes remain unchanged, and Discovery does not consume invalid evidence.
3. **Given** an invalid Clarification artifact, **When** Discovery completes, **Then** it may record advisory risk evidence when appropriate but does not mutate Clarification or block analysis.
4. **Given** identical valid inputs are processed repeatedly, **When** Discovery consumes Clarification evidence, **Then** resolution, evidence projection, confidence rationale, recommendation totals, recommendation selection, and ADR ownership are identical.
5. **Given** Clarification evidence is absent or rejected, **When** Discovery runs with valid existing prerequisites, **Then** it retains the existing Discovery behavior and output schema.

### Edge Cases

- A `not-started` artifact contains stale response text or finding rows; no Clarification evidence is projected.
- An `in-progress` artifact has open findings but no responses, or responses but no open findings.
- A `complete` artifact contains a stale open-finding count or unresolved finding row; count or state invalidity makes the artifact unavailable rather than partially consumable.
- A `blocked` artifact has a blocking reason but no usable response; Discovery continues and may record advisory risk evidence.
- Request evidence conflicts with one or more responses; Request evidence remains authoritative and the disagreement is advisory only.
- A resolved finding has an accepted response that adds business evidence but must not create uncertainty.
- Clarification status or finding state changes between repeated runs; each valid input snapshot is evaluated deterministically, without mutation.
- A catalog path points to an artifact whose internal path or identifier does not match the catalog entry.
- Clarification is missing entirely; Discovery proceeds under its existing optional-input behavior.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Discovery MUST interpret Clarification status as an input to advisory analysis only.
- **FR-002**: For `not-started` Clarification, Discovery MUST make no Clarification evidence available and MUST proceed normally.
- **FR-003**: For `in-progress` Clarification, Discovery MUST allow open findings to contribute to Assumptions, Unknowns, Risks, and confidence rationale, and MUST allow responses to contribute to Research Findings.
- **FR-004**: For `complete` Clarification, Discovery MUST allow responses to contribute to Research Findings and MUST NOT introduce uncertainty from open findings.
- **FR-005**: For `blocked` Clarification, Discovery MUST allow advisory risk evidence when appropriate, MUST continue normally, and MUST NOT prevent analysis, recommendation generation, or ADR handoff.
- **FR-006**: Clarification status MUST NOT affect candidate generation, candidate filtering, candidate scores, candidate ordering, recommendation selection, or ADR ownership.
- **FR-007**: Request evidence MUST remain authoritative over Clarification responses.
- **FR-008**: Clarification responses MAY supplement, explain, or clarify Request evidence but MUST NOT overwrite, replace, or modify Request evidence.
- **FR-009**: When Request evidence and Clarification responses disagree, Discovery MUST retain Request evidence as authoritative and MAY record advisory risk evidence without modifying the Request.
- **FR-010**: Open findings MAY contribute to Assumptions, Unknowns, Risks, and confidence rationale.
- **FR-011**: Resolved findings MAY contribute to Research Findings through accepted responses and MUST NOT contribute uncertainty, Unknowns, or unresolved-risk evidence.
- **FR-012**: Finding state MUST NOT affect candidate generation, scoring, ranking, recommendation totals, or recommendation selection.
- **FR-013**: Discovery MUST treat unreadable, malformed, path-mismatched, state-invalid, or count-invalid Clarification artifacts as unavailable.
- **FR-014**: When a Clarification artifact is unavailable, Discovery MUST preserve all bytes, continue normally, and MAY record advisory risk evidence without mutating Clarification.
- **FR-015**: Discovery MUST provide deterministic Clarification resolution and advisory projections for identical Request, Clarification, Profile, Objective, Control, NFR, Reference Architecture, and Reference Implementation inputs.
- **FR-016**: Deterministic repeated runs MUST produce identical Research Findings, Assumptions, Risks, Unknowns, confidence rationale, candidate evaluation, recommendation totals, recommendation selection, and ADR ownership.
- **FR-017**: Clarification evidence MUST NOT change candidate generation, candidate scoring, candidate ranking, recommendation totals, recommendation selection, or ADR ownership.
- **FR-018**: Discovery MUST verify that Clarification status is advisory-only, Request evidence remains authoritative, open and resolved findings are projected according to state, blocked status does not block execution, and no Clarification mutation occurs.
- **FR-019**: This feature MUST NOT change the Discovery record schema, Discovery scoring logic, recommendation logic, Clarification ownership, or ADR contracts.
- **FR-020**: Discovery MUST update its declared version from 2.0.0 to 2.1.0 to document the clarified contract without changing Discovery outputs or ownership boundaries.

### Key Entities *(include if feature involves data)*

- **Clarification Status**: The lifecycle state (`not-started`, `in-progress`, `complete`, or `blocked`) that determines which advisory evidence may be projected.
- **Clarification Finding State**: The open or resolved state that determines whether a finding contributes uncertainty or accepted-response evidence.
- **Request Evidence**: User-owned evidence that remains authoritative when it conflicts with Clarification responses.
- **Clarification Advisory Evidence**: Read-only Clarification responses, findings, and blocking context projected into existing Discovery evidence categories.
- **Clarification Validity**: The combined readability, structural, path, state, and count conditions required before Clarification evidence can be consumed.
- **Discovery Determinism Set**: The Request, Clarification, Profile, Objective, Control, NFR, Reference Architecture, and Reference Implementation inputs whose identical values must produce identical outputs.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of valid Clarification artifacts in each supported status produce only the advisory projections permitted for that status.
- **SC-002**: 100% of candidate generation, filtering, scores, ranking, ordering, recommendation totals, recommendation selection, and ADR ownership comparisons remain unchanged across status and finding-state variants with identical non-Clarification inputs.
- **SC-003**: 100% of Request-versus-response conflict cases preserve Request evidence as authoritative and leave the Request bytes unchanged.
- **SC-004**: 100% of open findings are treated as advisory uncertainty only, and 100% of resolved findings contribute only accepted-response evidence when such responses are available.
- **SC-005**: 100% of unreadable, malformed, path-mismatched, state-invalid, and count-invalid artifacts allow Discovery to continue when existing prerequisites are valid, with zero Clarification mutations.
- **SC-006**: 100% of repeated runs over identical Discovery Determinism Set inputs produce identical resolution, evidence projection, confidence rationale, recommendation totals, recommendation selection, and ADR ownership.
- **SC-007**: 100% of Discovery outputs continue to use the existing record schema with no dedicated Clarification section.
- **SC-008**: The Discovery contract declares version 2.1.0 and all specified verification rules are present and testable without changing scoring, recommendation, ownership, or ADR behavior.

## Assumptions

- Feature 069 remains the baseline contract for catalog resolution, optional Clarification consumption, evidence projection, and preservation of existing Discovery behavior.
- The `highway-clarify` skill remains authoritative for Clarification lifecycle status, finding state, responses, blocking reason, path validity, and count validity.
- Clarification is optional and advisory; a valid Request and existing Discovery prerequisites remain sufficient to continue when Clarification is absent or unavailable.
- Request evidence, not Clarification evidence, is the user-authoritative source when the two disagree.
- Existing Discovery evidence sections and privacy behavior remain sufficient; this feature does not introduce a new output section or retention policy.
- Status and finding-state validation are consumed as contract conditions; Discovery does not repair invalid Clarification records.
- The version change is a contract/documentation minor release and does not authorize changes to Discovery scoring, recommendation selection, ownership, or ADR handoff.
- No extension hooks are configured in this repository, so no pre- or post-specification hook changes the specification workflow.
