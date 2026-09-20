# Feature Specification: Discovery Contract Completion

**Feature Branch**: `051-discovery-contract-completion`

**Created**: 2026-09-19

**Status**: Draft

**Input**: User description: "Complete the partially implemented Reference Implementation changes in the Discovery skill by replacing the corrupted Outputs contract, defining explicit matching and counting rules, formalizing deterministic recommendation tie-breaking, adding determinism, scope, traceability, verification, and error-handling rules, and preserving ADR ownership."

## User Scenarios & Testing

### User Story 1 - Produce a valid Discovery output contract (Priority: P1)

A repository owner invokes Discovery and can rely on a complete, readable description of the user-owned record, catalog, completion response, and failure behavior.

**Why this priority**: A valid output contract is required before Discovery results can be consumed or validated by later workflows.

**Independent Test**: Review the Discovery skill's Outputs section and verify that it names the record path, catalog path, required record sections, completion response, shared catalog template, and no-output failure rule.

**Acceptance Scenarios**:

1. **Given** Discovery succeeds, **when** the output contract is applied, **then** it produces one user-owned record at `discoveries/DISCXXXXXX.md`, one catalog at `discoveries/discoveries.md`, and a completion response naming both identifiers and paths.
2. **Given** source resolution, validation, privacy review, scoring, allocation, or writing fails, **when** Discovery handles the failure, **then** it produces no output and preserves existing bytes.
3. **Given** a successful Discovery record, **when** its sections are inspected, **then** all required relationship and Reference Architecture sections are present in shared-template order.

### User Story 2 - Evaluate Reference Implementations explicitly and deterministically (Priority: P1)

A repository owner receives Reference Implementation evidence that is traceable to explicit Reference Architecture references and counted without semantic inference.

**Why this priority**: Matching and counting are the foundation for trustworthy implementation evidence and must be defined before tie-breaking can be relied upon.

**Independent Test**: Evaluate identical closed inputs containing explicit references, duplicate paths, malformed entries, absent catalogs, unreadable entries, and unresolved references; verify deterministic matches, unique counts, zero-count fallbacks, and recorded failure reasons.

**Acceptance Scenarios**:

1. **Given** a Reference Implementation explicitly references a Reference Architecture matched by an option, **when** matching runs, **then** it matches that option.
2. **Given** a Reference Implementation explicitly references the identifier of a Reference Architecture matched by an option, **when** matching runs, **then** it matches that option.
3. **Given** no explicit matching reference exists, **when** matching runs, **then** semantic similarity, inference, approximation, and similarity scoring do not create a match.
4. **Given** multiple matching paths identify one implementation, **when** counting runs, **then** the implementation contributes one count.
5. **Given** a malformed implementation or an unavailable catalog, **when** evaluation runs, **then** the affected implementation contributes zero, the blocking reason is recorded when applicable, and Discovery continues.

### User Story 3 - Resolve ties without changing recommendation authority (Priority: P1)

An ADR reviewer receives deterministic tie-break evidence while Recommendation scores, confidence, rationale, and ADR ownership remain unchanged.

**Why this priority**: Tie resolution is the only permitted effect of Reference Implementation evidence and must preserve the boundary between Discovery and ADR.

**Independent Test**: Supply tied options with varying Reference Architecture matches, implementation counts, and `OPT` identifiers; verify the ordered winner, immediate stopping, unchanged scores and confidence, and unchanged ADR authority.

**Acceptance Scenarios**:

1. **Given** tied options where only one has a Reference Architecture match, **when** tie-breaking runs, **then** the matched option wins before implementation counts are evaluated.
2. **Given** tied options with equivalent Reference Architecture Match status, **when** one has the higher unique Reference Implementation Count, **then** that option wins.
3. **Given** tied options with equal Reference Implementation Counts, **when** tie-breaking runs, **then** the lowest Discovery-scoped `OPT` identifier wins.
4. **Given** an earlier criterion selects one option, **when** tie-breaking continues, **then** later criteria are not evaluated.
5. **Given** Reference Implementation evidence is present, **when** Recommendation and ADR handoff are produced, **then** scores, confidence, rationale, and ADR ownership remain unchanged.

### Edge Cases

- The Outputs section is malformed or incomplete; Discovery documentation is invalid until the complete output contract is restored.
- Source resolution, validation, privacy review, scoring, allocation, or writing fails; Discovery emits no output and preserves existing bytes.
- A Reference Implementation has an invalid structure, missing stable identity, or missing required fields; exclude it, record the blocking reason, and continue.
- A Reference Implementation cannot be read; treat its contribution as zero.
- A Reference Implementation catalog is absent or unreadable; continue with zero counts.
- A Reference Implementation catalog is internally inconsistent; exclude affected implementations, record the reason, and continue.
- An otherwise valid Reference Implementation references an unresolved Reference Architecture; treat it as a valid non-match.
- An option matches multiple Reference Architectures; use the highest Reference Implementation Count among those matches.
- A tie resolves at an earlier criterion; do not evaluate later criteria.
- Identical closed inputs are evaluated repeatedly; results remain identical and no timestamp or environment state affects the result.

## Requirements

### Functional Requirements

- **FR-001**: The Discovery skill MUST define one user-owned record at `discoveries/DISCXXXXXX.md`.
- **FR-002**: The Discovery skill MUST define one user-owned catalog at `discoveries/discoveries.md`.
- **FR-003**: The Discovery record MUST contain Request Reference, Research Findings, Assumptions, Risks, Unknowns, Candidate Solution Options, Candidate Solution Comparison Matrix, Recommendation, Objective Relationships, Control Relationships, NFR Relationships, and Reference Architecture Matches.
- **FR-004**: The Discovery catalog MUST follow the shared Discovery catalog template.
- **FR-005**: A successful Discovery completion response MUST name the Discovery identifier, Request identifier, record path, and catalog path.
- **FR-006**: Discovery MUST produce no output when source resolution, validation, privacy review, scoring, allocation, or writing fails.
- **FR-007**: A Reference Implementation MUST match an option only when it explicitly references a matching Reference Architecture or explicitly references the identifier of a Reference Architecture matched by that option.
- **FR-008**: Semantic similarity, inference, approximation, and similarity scoring MUST NOT create Reference Implementation matches.
- **FR-009**: Reference Implementation Count MUST equal the number of unique matching Reference Implementations for an option.
- **FR-010**: Duplicate matching references MUST count once per stable Reference Implementation identifier.
- **FR-011**: Missing or unreadable Reference Implementations MUST contribute zero to the affected count.
- **FR-012**: Malformed Reference Implementations MUST be excluded from counting and tie-breaking, with the blocking reason recorded.
- **FR-013**: An unresolved Reference Architecture reference in an otherwise valid implementation MUST produce a valid non-match.
- **FR-014**: An internally inconsistent Reference Implementation catalog MUST exclude affected implementations, record the reason, and continue with zero affected counts.
- **FR-015**: When an option matches multiple Reference Architectures, its tie-break count MUST be the highest Reference Implementation Count among those matches.
- **FR-016**: Tied options MUST be evaluated in this order: Reference Architecture Match, Reference Implementation Count, then lowest Discovery-scoped `OPT` identifier.
- **FR-017**: Options with one or more Reference Architecture matches MUST outrank options with no Reference Architecture matches during the first tie-break criterion.
- **FR-018**: Tie-break evaluation MUST stop immediately when a criterion selects a single option.
- **FR-019**: Reference Implementation evidence MUST NOT change Recommendation scores.
- **FR-020**: Reference Implementation evidence MUST NOT change Recommendation confidence.
- **FR-021**: Reference Implementation evidence MUST NOT change Recommendation rationale or ranking except through the defined deterministic tie-break.
- **FR-022**: Reference Implementation evaluation MUST NOT change ADR ownership or authorize implementation.
- **FR-023**: For identical declared inputs and baselines, Reference Implementation matches, counts, tie-break outcomes, and Recommendation selection MUST remain identical.
- **FR-024**: Reference Implementation evaluation MUST NOT use timestamps, creation dates, modification dates, recency, environment state, randomness, semantic similarity, inference, or similarity scoring.
- **FR-025**: A Reference Implementation match MUST indicate only that a related implementation artifact exists.
- **FR-026**: ADR MUST remain responsible for selecting a Candidate Solution Option and recording architecture decisions.
- **FR-027**: Verification MUST confirm explicit matching, unique counting, malformed exclusion, zero-count fallbacks, score and confidence preservation, tie-break order, immediate stopping, deterministic repetition, and unchanged ADR ownership.
- **FR-028**: Error handling MUST preserve existing bytes and avoid ADR creation, decisions, authorization, or governance mutation after any failure.

### Required Discovery Contract Sections

The Discovery skill MUST contain the following sections with these behaviors:

#### Outputs

- One user-owned Discovery record at:

  `discoveries/DISCXXXXXX.md`

- One user-owned Discovery catalog at:

  `discoveries/discoveries.md`

- The Discovery record contains:

  - Request Reference
  - Research Findings
  - Assumptions
  - Risks
  - Unknowns
  - Candidate Solution Options
  - Candidate Solution Comparison Matrix
  - Recommendation
  - Objective Relationships
  - Control Relationships
  - NFR Relationships
  - Reference Architecture Matches

- The Discovery catalog follows the shared Discovery catalog template.

- A completion response naming:

  - Discovery identifier
  - Request identifier
  - Record path
  - Catalog path

- No output when source resolution, validation, privacy review, scoring, allocation, or writing fails.

#### Reference Implementation Matching

A Reference Implementation matches a Candidate Solution Option when either condition is true:

1. The Reference Implementation explicitly references a matching Reference Architecture.
2. The Reference Implementation explicitly references the identifier of a Reference Architecture matched by that option.

No match exists otherwise. Semantic similarity, inference, approximation, or similarity scoring MUST NOT be used for matching.

#### Reference Implementation Counting

Reference Implementation Count equals the number of unique matching Reference Implementations for an option.

Duplicate references count once.

Missing Reference Implementations contribute zero.

Unreadable Reference Implementations contribute zero.

Malformed Reference Implementations are excluded from counting and tie-breaking.

#### Recommendation Tie-Break Evaluation

When multiple options have identical Recommendation scores:

1. Reference Architecture Match
2. Reference Implementation Count
3. Lowest Discovery-scoped `OPT` identifier

Reference Architecture Match evaluates whether an option has one or more matched Reference Architectures.

Options with one or more matches outrank options with no matches.

Evaluation stops immediately when a criterion selects a single option.

Later criteria MUST NOT be evaluated once a winner has been selected.

Where an option matches multiple Reference Architectures, use the highest Reference Implementation Count among those matches.

#### Reference Implementation Determinism

For identical:

- Requests
- Discovery inputs
- Profile baselines
- Objective baselines
- Control baselines
- NFR baselines
- Reference Architecture baselines
- Reference Implementation baselines

The following MUST remain identical:

- Reference Implementation matches
- Reference Implementation counts
- tie-break outcomes
- Recommendation selection

Reference Implementation evaluation MUST NOT use:

- timestamps
- creation dates
- modification dates
- recency
- environment state
- randomness
- semantic similarity
- inference
- similarity scoring

#### Reference Implementation Scope Clarification

Included:

- advisory matching
- deterministic counting
- deterministic tie-breaking
- implementation reuse visibility
- architecture adoption visibility
- traceability

Excluded:

- recommendation creation
- recommendation scoring
- recommendation confidence
- recommendation rationale
- recommendation ranking except tie-breaking
- implementation authorization
- implementation approval
- architecture approval
- governance approval
- ADR ownership

#### Reference Implementation Traceability

A Reference Implementation match indicates only that a related implementation artifact exists.

A match does NOT indicate:

- recommendation
- endorsement
- approval
- architectural correctness
- implementation suitability
- implementation authorization

ADR remains responsible for selecting a Candidate Solution Option and recording all architecture decisions.

### Workflow Updates

The workflow MUST state:

> Reference Implementation data is evaluated only according to the Reference Implementation Evaluation rules and is used exclusively for deterministic tie-breaking.

Reference Implementation matching and counting occur only after score calculation and Reference Architecture evaluation, and they do not mutate source baselines or ADR records.

### Verification Expectations

- Confirm Reference Implementation matching uses only explicit matching rules.
- Confirm duplicate matches are counted once.
- Confirm malformed Reference Implementations are excluded from counting.
- Confirm missing or unreadable Reference Implementations produce zero counts.
- Confirm Recommendation scores are unchanged by Reference Implementations.
- Confirm Recommendation confidence is unchanged by Reference Implementations.
- Confirm tie-break order is:
  1. Reference Architecture Match
  2. Reference Implementation Count
  3. Lowest `OPT` identifier
- Confirm evaluation stops after a winner is selected.
- Confirm repeated executions with identical inputs are deterministic.
- Confirm ADR ownership is unchanged.

### Error Handling Expectations

- A Reference Implementation is malformed: exclude it from evaluation, record the blocking reason, and continue.
- A Reference Implementation cannot be read: treat its contribution as zero.
- Multiple matching paths identify the same Reference Implementation: count the implementation once.
- A Reference Implementation catalog is absent: continue with zero counts.
- A Reference Implementation catalog is unreadable: continue with zero counts.
- A Reference Implementation catalog is internally inconsistent: exclude affected implementations, record the reason, and continue.
- Reference Implementation matching fails: continue with zero matching implementations.
- Any source, validation, privacy, scoring, allocation, or writing failure: produce no output, preserve existing bytes, and do not create an ADR or record a decision.

## Key Entities

- **Discovery Output Contract**: The user-owned record, catalog, completion response, required sections, and no-output failure boundary.
- **Reference Implementation**: An optional implementation artifact with a stable identity and explicit Reference Architecture references.
- **Reference Implementation Catalog**: The authoritative collection used to evaluate implementation evidence and detect catalog inconsistencies.
- **Reference Implementation Count**: The unique matching implementation count used only as deterministic tie-break evidence.
- **Recommendation Tie-Break State**: An ephemeral ordered evaluation of tied options that stops after one criterion selects a winner.
- **ADR Handoff**: The advisory Discovery projection whose decision ownership remains with ADR.

## Success Criteria

### Measurable Outcomes

- **SC-001**: 100% of successful Discovery outputs identify one record path, one catalog path, both identifiers, and every required record section.
- **SC-002**: 100% of source resolution, validation, privacy review, scoring, allocation, and writing failures produce no new output and preserve existing bytes.
- **SC-003**: 100% of Reference Implementation matches are produced by one of the two explicit matching conditions.
- **SC-004**: 100% of duplicate matching paths contribute one count per stable implementation identifier.
- **SC-005**: 100% of malformed, missing, unreadable, and inconsistent implementation cases follow the specified exclusion or zero-count behavior.
- **SC-006**: 100% of tied selections follow Reference Architecture Match, Reference Implementation Count, then lowest `OPT` order.
- **SC-007**: 100% of resolved ties stop evaluating criteria after a single option is selected.
- **SC-008**: 100% of repeated executions with identical declared inputs produce identical matches, counts, tie-break outcomes, and Recommendation selection.
- **SC-009**: 100% of Recommendation scores, confidence, rationale, and ADR ownership remain unchanged by Reference Implementation evidence except for the defined tie-break selection.
- **SC-010**: 100% of Reference Implementation matches are reported as traceability evidence only and never as endorsement, approval, suitability, or authorization.

## Assumptions

- Feature 050 remains the governing semantic baseline for Reference Implementation evaluation; this feature completes the corresponding Discovery skill contract.
- Discovery already has authoritative Request, Profile, Objective, Control, NFR, Reference Architecture, ADR handoff, and shared output-template contracts.
- `DISCXXXXXX` and `REQXXXXXX` identifiers use the existing Discovery and Request identifier conventions.
- Reference Implementation absence is valid and does not independently fail Discovery.
- The feature changes the Discovery skill documentation and its validation evidence; it does not authorize ADR decisions or implementation.

## Scope Boundaries

### Included in Version 1

- Replacement of the corrupted Discovery Outputs contract.
- Explicit Reference Implementation matching and unique counting rules.
- Deterministic recommendation tie-break and early-stop rules.
- Determinism, scope, traceability, workflow, verification, and error-handling contract updates.
- Preservation of ADR decision ownership and no-output-on-failure behavior.

### Excluded from Version 1

- Creating or modifying ADR decisions.
- Approving or authorizing implementations, architectures, or governance changes.
- Semantic similarity or inference-based Reference Implementation matching.
- Changing Recommendation score calculation or confidence calculation.
- Changing Reference Implementation generation or catalog ownership.
