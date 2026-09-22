# Feature Specification: Clarification Guided Resolution Workflow

**Feature Branch**: `071-clarification-guided-resolution`

**Created**: 2026-09-22

**Status**: Draft

**Input**: User description: "Enhance highway-clarify from a passive findings registry into a guided resolution workflow that generates deterministic advisory questions, explanations, recommended and alternative options, and custom response paths while preserving user decision authority, source immutability, existing finding states, and governance, architecture, and ADR ownership boundaries."

## Clarifications

### Session 2026-09-22

- Q: When multiple highest-precedence evidence items conflict, how should Clarification generate the Recommended option? → A: Do not select either value; recommend `Unknown / Escalate for Decision`, record both conflicting evidence sources, present the conflicting values as alternatives B and C, explain the conflict, and require explicit user selection among A, B, C, or D Custom.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Understand an Open Finding (Priority: P1)

As a repository user, I want each open Clarification finding to include a clear question and explanation of why it matters so that I understand the decision needed before responding.

**Why this priority**: A deterministic question and consequence explanation are the minimum guidance needed to turn a finding into an actionable resolution conversation.

**Independent Test**: Generate a Clarification record containing open findings for each supported artifact type and confirm every open finding contains exactly one deterministic question and one deterministic Why It Matters explanation.

**Acceptance Scenarios**:

1. **Given** an open finding, **When** Clarification generates guidance, **Then** it contains Finding, Question, and Why It Matters content.
2. **Given** identical source and advisory inputs, **When** guidance is generated repeatedly, **Then** the question and consequence explanation are byte-identical.
3. **Given** a finding is already resolved, **When** its record is rendered, **Then** its guidance fields remain available for traceability.

---

### User Story 2 - Compare Advisory Resolution Options (Priority: P1)

As a repository user, I want three deterministic options with rationale plus a Custom choice for each open finding so that I can compare possible answers without surrendering the decision to Clarification.

**Why this priority**: Structured choices reduce response effort while keeping the user responsible for accepting, rejecting, or replacing the guidance.

**Independent Test**: Generate guidance from identical inputs and confirm each open finding presents options in A Recommended, B Alternative, C Alternative, D Custom order, with rationale for every generated option and the recommended option first.

**Acceptance Scenarios**:

1. **Given** an open finding, **When** Clarification generates resolution guidance, **Then** it creates exactly three generated options, one Custom option, and rationale for each generated option.
2. **Given** authoritative evidence exists, **When** Clarification selects a Recommended option, **Then** it uses the highest-precedence available source and includes traceable rationale.
3. **Given** no authoritative evidence resolves the finding, **When** Clarification generates guidance, **Then** the Recommended option may be `Unknown` with rationale explaining the evidence gap.
4. **Given** a generated option is displayed, **When** the user reviews it, **Then** the option remains advisory and does not itself resolve the finding or approve a decision.

---

### User Story 3 - Record User Selection Without Taking Ownership (Priority: P1)

As a repository user, I want my selected guidance option and accepted response recorded separately so that Clarification preserves history while leaving resolution and downstream decisions under my control.

**Why this priority**: Informational selection tracking supports traceability without confusing option selection with an accepted response or an authoritative governance decision.

**Independent Test**: Record selections A, B, C, D, and None for open and resolved findings, then confirm the selected option is informational, only an accepted response transitions a finding from open to resolved, and source artifacts remain unchanged.

**Acceptance Scenarios**:

1. **Given** an open finding, **When** a user selects A, B, C, D, or None, **Then** Clarification records the selection without automatically resolving the finding.
2. **Given** a user supplies a Custom answer, **When** Clarification records it, **Then** the answer is retained as a response candidate while the finding remains open until an accepted response is explicitly recorded.
3. **Given** an accepted response is recorded, **When** Clarification updates the finding, **Then** the finding transitions only from open to resolved and retains its guidance, selection, identifier, fingerprint, and history.
4. **Given** a generated option or accepted response is recorded, **When** the workflow completes, **Then** the source artifact is byte-for-byte unchanged.
5. **Given** any guidance or selection, **When** downstream workflows consume Clarification, **Then** Clarification has not approved a governance decision, architecture, recommendation, or ADR decision.

### Edge Cases

- A finding has no authoritative evidence; the Recommended option is `Unknown` and its rationale states why.
- A source artifact contains evidence from multiple precedence levels; only the highest-precedence evidence supports the Recommended option.
- Multiple highest-precedence evidence items contain contradictory values; neither value is Recommended, the recommendation is `Unknown / Escalate for Decision`, both evidence sources and values are retained as traceable alternatives, and explicit user selection is required.
- An open finding has stale or incomplete guidance; generation replaces generated guidance deterministically without changing source bytes or finding identity.
- A user selects None or a generated option but provides no accepted response; the finding remains open.
- A user supplies a Custom answer containing sensitive information; existing privacy filtering applies before retention.
- A resolved finding retains its guidance and selected option for traceability even though it cannot transition back to open.
- A finding contains a selected option value outside A, B, C, D, or None; the record is invalid and no write occurs.
- A generation or update conflict occurs; Clarification preserves all pre-operation bytes and does not merge automatically.
- Artifact-specific source evidence is absent; generation uses only the declared sources for that artifact type and does not invent evidence.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Clarification MUST generate resolution guidance for every open finding without changing finding detection, tracking, lifecycle ownership, response capture, or history ownership.
- **FR-002**: Every finding guidance block MUST contain Finding, Question, Why It Matters, and Resolution Options content.
- **FR-003**: Every open finding MUST contain exactly one deterministic resolution question and exactly one deterministic Why It Matters explanation.
- **FR-004**: Every open finding MUST contain exactly three generated options and one Custom option ordered A Recommended, B Alternative, C Alternative, D Custom.
- **FR-005**: Clarification MUST generate rationale for every generated option and present the Recommended option first.
- **FR-006**: Generated questions, explanations, options, ordering, and rationale MUST be deterministic for identical inputs.
- **FR-007**: Recommended options MUST use only authoritative sources in this precedence order: Source artifact, Clarification responses, Profile, Objectives, Controls, NFRs, Discovery, Reference Architectures, Reference Implementations.
- **FR-008**: Clarification MUST use the highest-precedence available evidence for the Recommended option and MUST NOT use semantic similarity, model preference, external knowledge, architectural taste, or unstated assumptions.
- **FR-008a**: When multiple highest-precedence evidence items provide contradictory values for the same finding, Clarification MUST NOT select either value as Recommended; it MUST generate `Unknown / Escalate for Decision`, record the conflicting evidence sources, present the conflicting values as alternatives B and C, explain why the conflict exists, and require explicit user selection from A, B, C, or D Custom.
- **FR-009**: Clarification MUST support artifact-specific guidance sources: REQ from Request evidence, Profile, Objectives, Controls, and NFRs; DISC from Discovery Findings, Assumptions, Risks, Unknowns, Objectives, Controls, and NFRs; ADR from Discovery handoff, ADR context, and selected candidate option; and RA from Architecture contents, Controls, NFRs, and Objectives.
- **FR-010**: Clarification MUST preserve finding states exactly as `open` and `resolved` and MUST NOT introduce another finding state.
- **FR-011**: Each finding MUST support informational `selected_option` values A, B, C, D, or None.
- **FR-012**: Recording a selected option MUST NOT automatically resolve a finding; resolution MUST still require an explicitly accepted response and only the open-to-resolved transition.
- **FR-013**: Resolved findings MUST retain their guidance fields, selected option, response, identifier, fingerprint, history, and evidence references for traceability.
- **FR-014**: Clarification MUST NOT automatically resolve findings, modify source artifacts, select an option for the user, approve architecture, approve governance decisions, or approve ADR decisions.
- **FR-015**: The Clarification record template MUST provide Question, Why Matters, Recommended Option, Recommended Rationale, Alternative Option B and rationale, Alternative Option C and rationale, Selected Option defaulting to None, and Response defaulting to None for every finding.
- **FR-016**: Generated guidance MUST preserve existing privacy filtering, validation, conflict handling, count invariants, finding identity rules, and no-partial-write behavior.
- **FR-017**: Clarification MUST verify that every open finding has the required guidance fields, exactly one Recommended option, rationale, Custom option, deterministic output, source precedence, no automatic resolution, accepted-response resolution, and source immutability.
- **FR-018**: This feature MUST NOT change Clarification ownership of finding detection, finding tracking, lifecycle, response capture, or history.
- **FR-019**: This feature MUST NOT grant Clarification ownership of governance decisions, architecture decisions, recommendation selection, source artifact mutation, or ADR decisions.
- **FR-020**: The `highway-clarify` contract MUST update its declared version from 1.4.0 to 2.0.0 to document the guided-resolution capability and expanded retained output contract.

### Key Entities *(include if feature involves data)*

- **Resolution Guidance**: The deterministic Finding, Question, Why It Matters, generated options, Custom option, and rationales presented for an open finding.
- **Recommended Option**: The first advisory option derived from the highest-precedence authoritative evidence available for the artifact type.
- **Alternative Option**: One of two additional generated advisory options with contextual rationale.
- **Custom Option**: The user-supplied answer path that is always available and never selected automatically.
- **Selected Option**: Informational A, B, C, D, or None tracking that does not resolve a finding by itself.
- **Accepted Response**: The explicit user-owned response that may transition an open finding to resolved.
- **Guidance Source Precedence**: The ordered evidence sources used to support a Recommended option.
- **Artifact-Type Guidance Set**: The source subset used for REQ, DISC, ADR, or RA findings.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of generated open-finding records contain one Finding explanation, one Question, one Why It Matters explanation, exactly three generated options, one Custom option, and rationale for every generated option.
- **SC-002**: 100% of repeated generations with identical inputs produce byte-identical guidance, option ordering, rationale, and source traceability.
- **SC-003**: 100% of Recommended options are traceable to the highest-precedence available authoritative source or explicitly identify the absence of such evidence.
- **SC-004**: 100% of selected-option updates leave the finding open unless an explicit accepted response is recorded, with no automatic resolution.
- **SC-005**: 100% of resolved findings retain guidance, selection, accepted response, identifier, fingerprint, and history fields.
- **SC-006**: 100% of generation and selection operations preserve source artifact bytes and prevent governance, architecture, recommendation, or ADR decisions.
- **SC-007**: 100% of invalid selected-option values, unsupported states, privacy violations, conflicts, and validation failures produce no partial write.
- **SC-008**: All four supported artifact types generate only from their declared source sets, with zero use of semantic similarity, model preference, external knowledge, architectural taste, or unstated assumptions.
- **SC-009**: The `highway-clarify` contract declares version 2.0.0 and its verification contract covers guidance completeness, precedence, determinism, custom-option presence, no automatic resolution, accepted-response resolution, and source immutability.

## Assumptions

- Existing Clarification findings continue to be detected only from explicit ambiguity vocabulary, declared structures, and declared contradiction rules.
- Finding states remain exactly `open` and `resolved`; selected-option tracking is informational and is not a lifecycle state.
- An accepted response remains the only user-owned event that can resolve an open finding.
- Existing privacy filtering, revision conflicts, catalog integrity, fingerprint identity, count invariants, and no-partial-write behavior remain authoritative.
- The user remains the decision maker; generated recommendations are advisory and may be rejected or replaced with a Custom answer.
- Artifact-specific guidance sources are limited to the declared sets and are evaluated in the global precedence order.
- ADR context and selected candidate information are read-only inputs to guidance and do not authorize ADR mutation.
- The version change is a major behavioral contract expansion and does not authorize Clarification to make governance, architecture, recommendation, source, or ADR decisions.
