# Feature Specification: Reference Implementation Evaluation

**Feature Branch**: `050-reference-implementation-evaluation`

**Created**: 2026-09-19

**Status**: Draft

**Input**: User description: "Formalize Reference Implementation evaluation as advisory, deterministic tie-break evidence for Discovery without allowing it to influence recommendation scoring, confidence, or ADR authority."

## Clarifications

### Session 2026-09-19

- Q: What should make a Reference Implementation "malformed"? → A: Option A: malformed means unparseable data, a missing or invalid stable identifier, or missing required fields; unresolved references are valid non-matches and duplicate catalog identifiers are catalog inconsistencies.

## User Scenarios & Testing

### User Story 1 - Evaluate implementation evidence deterministically (Priority: P1)

A repository owner runs Discovery with optional Reference Implementations and receives deterministic implementation counts for tied Candidate Solution Options.

**Independent Test**: Given identical Discovery inputs and Reference Implementation baselines, repeated runs produce identical matches, counts, tie-break outcomes, and Recommendation selection.

**Acceptance Scenarios**:

1. **Given** a Reference Implementation explicitly referencing a matched Reference Architecture, **when** Discovery evaluates it, **then** it counts as a match for the associated option.
2. **Given** duplicate references to one Reference Implementation, **when** Discovery counts matches, **then** the implementation is counted once.
3. **Given** a missing or unreadable Reference Implementation catalog, **when** Discovery evaluates a tie, **then** every Reference Implementation count is zero and Discovery continues.
4. **Given** a malformed Reference Implementation, **when** Discovery evaluates the catalog, **then** it is excluded, the reason is recorded, and Discovery continues.

### User Story 2 - Resolve recommendation ties without changing scores (Priority: P1)

An ADR reviewer receives a recommendation whose tie-break outcome reflects available implementation evidence while preserving Discovery's advisory boundary.

**Independent Test**: Given tied Recommendation scores, verify the order Reference Architecture Match, Reference Implementation Count, then the lowest Discovery-scoped `OPT` identifier, with evaluation stopping once one option is selected.

**Acceptance Scenarios**:

1. **Given** tied options, **when** one has a Reference Architecture match and another does not, **then** the matched option wins before Reference Implementation Count is evaluated.
2. **Given** tied options with equivalent Reference Architecture Match status, **when** one has the higher unique Reference Implementation Count, **then** that option wins.
3. **Given** tied options with equal Reference Implementation Counts, **then** the lower Discovery-scoped `OPT` identifier wins.
4. **Given** a Reference Implementation match, **then** Recommendation scores, confidence, rationale, and ADR authority remain unchanged by that match.

## Edge Cases

- A Reference Implementation is structurally malformed because it is unparseable, lacks a valid stable identifier, or lacks required fields; Discovery excludes it from evaluation, records the blocking reason, and continues.
- A Reference Implementation cannot be read; its contribution is zero.
- Multiple matching paths identify the same Reference Implementation; it counts once.
- Reference Implementation matching fails; Discovery continues with zero matching implementations.
- The authoritative catalog is missing, unreadable, or internally inconsistent; affected counts are zero and Discovery continues.
- An option matches multiple Reference Architectures; its Reference Implementation tie-break count is the highest count among those matches.
- A tie is resolved by an earlier criterion; later criteria are not evaluated.

## Requirements

### Functional Requirements

- **FR-001**: Reference Implementations MUST be evaluated only for deterministic tie-breaking.
- **FR-002**: Reference Implementation matching MUST use only the Reference Implementation Evaluation rules in this specification.
- **FR-003**: A Reference Implementation MUST match an option only when it explicitly references a matching Reference Architecture or explicitly references the identifier of a Reference Architecture matched by that option.
- **FR-004**: Semantic similarity, inference, score generation, and score weighting MUST NOT be used for Reference Implementation matching.
- **FR-005**: Reference Implementation Count MUST equal the number of unique matching Reference Implementations for an option.
- **FR-006**: Missing or unreadable Reference Implementations MUST produce a count of zero.
- **FR-007**: Reference Implementations MUST be considered malformed only when they are unparseable, lack a valid stable identifier, or lack required fields; malformed implementations MUST be excluded from matching and tie-breaking, with the exclusion reason recorded.
- **FR-008**: Reference Implementations MUST NOT contribute to Recommendation scores.
- **FR-009**: Reference Implementations MUST NOT contribute to Recommendation confidence.
- **FR-010**: Reference Implementations MUST NOT create or change Recommendations, Recommendation rationale, or Recommendation ranking except through the deterministic tie-break order.
- **FR-011**: Reference Implementation tie-breaking MUST occur only after Recommendation scoring and Reference Architecture tie-breaking have completed.
- **FR-012**: Tie-break criteria MUST be evaluated in this order: Reference Architecture Match, Reference Implementation Count, then lowest Discovery-scoped `OPT` identifier.
- **FR-013**: Evaluation MUST stop immediately when a criterion selects a single option; later criteria MUST NOT be evaluated.
- **FR-014**: When an option has multiple matched Reference Architectures, its Reference Implementation Count for tie-breaking MUST be the highest count among those matches.
- **FR-015**: Reference Implementation matching and counting MUST be advisory and MUST NOT mutate Reference Implementations, Reference Architectures, governance baselines, Discovery source inputs, or ADR records.
- **FR-016**: Reference Implementation absence and zero matching implementations MUST be valid states and MUST NOT fail Discovery.
- **FR-017**: Discovery MUST remain advisory; ADR exclusively owns selection, rejection, acceptance, rationale, consequences, decisions, and implementation authorization.

### Reference Implementation Evaluation

Reference Implementations are optional repository-owned advisory artifacts with stable identifiers and an authoritative catalog. They provide implementation reuse visibility, architecture adoption visibility, and traceability only.

A Reference Implementation matches a Candidate Solution Option when either condition is true:

1. The implementation explicitly references a matching Reference Architecture.
2. The implementation explicitly references the identifier of a Reference Architecture matched by the option.

No match exists otherwise. Matching MUST use explicit deterministic references only.

Reference Implementation Count is the number of unique matching implementations. Duplicate references count once. Missing or unreadable artifacts contribute zero. Structurally malformed artifacts are those that are unparseable, lack a valid stable identifier, or lack required fields; they are excluded and cannot affect tie-breaking. An otherwise well-formed implementation with an unresolved Reference Architecture reference is a valid non-match. Duplicate catalog identifiers are catalog inconsistencies handled by the catalog failure rules.

### Recommendation Tie-Break Evaluation

When multiple options have identical Recommendation scores, Discovery MUST apply the following order:

1. Reference Architecture Match
2. Reference Implementation Count
3. Lowest Discovery-scoped `OPT` identifier

The earlier criterion wins. Evaluation stops immediately when a criterion selects a single option. For an option with multiple matched Reference Architectures, use the highest Reference Implementation Count among those matches. If all counts are equal, use the lower `OPT` identifier.

### Reference Implementation Scope Clarification

**Included**: advisory matching, deterministic unique counting, deterministic tie-breaking, implementation reuse visibility, architecture adoption visibility, and traceability.

**Excluded**: semantic or inference-based similarity, score generation, score weighting, Recommendation creation, Recommendation confidence, Recommendation rationale, Recommendation ranking except tie-breaking, implementation authorization or approval, architecture decisions or approval, governance decisions or approval, and ADR record ownership.

### Reference Implementation Determinism

For identical Requests, Discovery inputs, Profile, Objective, Control, NFR, Reference Architecture, and Reference Implementation baselines, matching results, counts, tie-break outcomes, and Recommendation selection MUST be identical.

Evaluation MUST NOT depend on timestamps, recency, file dates, modification dates, creation dates, environment state, randomness, semantic similarity, inference, or non-authoritative catalog order.

### Reference Implementation Traceability

A Reference Implementation match indicates only that a related implementation artifact exists. It does not indicate recommendation, endorsement, approval, correctness, suitability, or authorization. ADR remains responsible for selecting an option and recording all architectural decisions.

## Success Criteria

- **SC-001**: 100% of Reference Implementation matches use only explicit Reference Implementation Evaluation rules.
- **SC-002**: 100% of Reference Implementation Counts equal the number of unique matching implementations.
- **SC-003**: 100% of missing or unreadable Reference Implementation catalogs produce zero counts without failing Discovery.
- **SC-004**: 100% of malformed Reference Implementations are excluded from matching and tie-breaking.
- **SC-005**: 100% of Recommendation scores remain unchanged when Reference Implementations are added, removed, or unavailable.
- **SC-006**: 100% of Recommendation confidence values remain unchanged when Reference Implementations are added, removed, or unavailable.
- **SC-007**: 100% of tied Recommendation selections follow Reference Architecture Match, Reference Implementation Count, then lowest `OPT` identifier.
- **SC-008**: 100% of resolved ties stop evaluation after the first criterion that selects a single option.
- **SC-009**: 100% of repeated executions with identical inputs produce identical matches, counts, tie-break outcomes, and Recommendation selection.
- **SC-010**: 100% of Reference Implementation matches remain advisory and do not authorize implementation or change ADR ownership.

## Verification Expectations

- Verify matching succeeds only for explicit Reference Architecture references.
- Verify semantic similarity and inference do not create matches.
- Verify duplicate matching paths produce one count per unique implementation.
- Verify malformed implementations are excluded and their reasons are recorded.
- Verify missing, unreadable, and zero-match catalogs produce zero counts without failing Discovery.
- Verify multiple Reference Architecture matches use the highest implementation count.
- Verify tie-break order is Reference Architecture Match, Reference Implementation Count, then `OPT` identifier.
- Verify later tie-break criteria are not evaluated after a winner is selected.
- Verify Recommendation scores, confidence, rationale, and ADR ownership are unchanged by implementation evidence.
- Verify repeated identical executions are deterministic.

## Assumptions

- Discovery already produces Candidate Solution Options, Recommendation scores, Reference Architecture Matches, and an advisory ADR handoff.
- Reference Implementations are optional repository-owned artifacts with stable identifiers and an authoritative catalog.
- Reference Implementation absence is valid and is not an error.
- Reference Architecture and Reference Implementation generation remain outside this feature.
- The existing Discovery and ADR contracts remain authoritative where this specification does not define a Reference Implementation behavior.

## Scope Boundaries

### Included in Version 1

- Explicit Reference Implementation matching.
- Unique Reference Implementation counting.
- Deterministic Recommendation tie-breaking.
- Advisory implementation and architecture adoption traceability.
- Deterministic handling of absent, unreadable, malformed, and duplicate artifacts.

### Excluded from Version 1

- Recommendation score or confidence changes.
- Semantic similarity or inference-based matching.
- Implementation authorization, approval, or deployment.
- Architecture or governance decisions and approvals.
- ADR selection, rejection, acceptance, rationale, consequence, and decision ownership.
- Reference Architecture or Reference Implementation generation.
