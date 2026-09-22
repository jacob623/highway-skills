# Feature Specification: Clarification Contract Hardening

**Feature Branch**: `072-clarification-contract-hardening`

**Created**: 2026-09-22

**Status**: Draft

**Input**: User description: "Harden the Clarification guided-resolution contract by aligning the retained record version, defining artifact-specific recommendation precedence, escalation ownership, selected-option lifecycle, fingerprint consistency, evidence traceability, Unknown versus Escalate semantics, ownership verification, and consumer rules so Clarification remains advisory across Request, Discovery, ADR, and Reference Architecture workflows."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Read a Consistent Clarification Record (Priority: P1)

As a repository maintainer, I want the Clarification skill and retained finding template to declare the same major contract version and internally consistent finding identity so that consumers can interpret records without relying on stale or contradictory metadata.

**Why this priority**: A version mismatch or inconsistent fingerprint makes every downstream interpretation unreliable before recommendation behavior is evaluated.

**Independent Test**: Inspect the canonical Clarification skill and retained record template, then generate a representative finding and verify both declare version 2.0.0 and the finding category matches the category segment of its fingerprint.

**Acceptance Scenarios**:

1. **Given** the guided-resolution contract is active, **When** a consumer reads the skill and record template metadata, **Then** both declare version 2.0.0.
2. **Given** a finding has category `missing_input`, **When** its fingerprint is rendered, **Then** the fingerprint category is `missing_input` rather than a different category such as `ambiguity`.
3. **Given** a resolved finding is retained, **When** a consumer reads its record, **Then** the versioned guidance fields and identity fields remain interpretable under the same contract.

---

### User Story 2 - Trace and Resolve Recommendations Deterministically (Priority: P1)

As a repository maintainer, I want recommendation selection to use only the declared sources for the finding's artifact type, with deterministic precedence, conflict escalation, and evidence traceability, so that every generated option can be audited and explained.

**Why this priority**: Deterministic source selection is the core safeguard against recommendations being driven by irrelevant evidence, hidden assumptions, or inconsistent interpretation.

**Independent Test**: Supply evidence at multiple precedence levels for REQ, DISC, ADR, and RA findings, including absent evidence and conflicting highest-precedence evidence, then verify source filtering, selected recommendation state, alternatives, rationale, and traceability.

**Acceptance Scenarios**:

1. **Given** a finding for a supported artifact type, **When** guidance is generated, **Then** Clarification first selects that artifact type's declared source set and ignores all sources outside it.
2. **Given** multiple eligible sources exist within the selected set, **When** guidance is generated, **Then** Recommendation Precedence is applied only to those eligible sources and the highest-precedence available evidence determines the recommendation.
3. **Given** no authoritative evidence exists in the selected set, **When** guidance is generated, **Then** the recommendation is `Unknown` and its rationale states that authoritative evidence is absent.
4. **Given** contradictory values exist at the highest applicable precedence, **When** guidance is generated, **Then** the recommendation is `Unknown / Escalate for Decision`, both conflicting sources are retained, and their values are presented as alternatives requiring explicit user choice.
5. **Given** evidence contributes to a generated option, **When** the option is rendered, **Then** its Evidence Sources include Source Type, Source Identifier, and Reason Used.

#### Recommendation Source Selection

Guidance generation occurs in two stages:

1. Select the artifact-specific source set.
2. Apply Recommendation Precedence only to sources that are members of the selected artifact-specific source set.

Sources not in the artifact-specific source set are ignored for guidance generation.

The declared artifact-specific source sets are:

- **REQ**: Request, Profile, Objectives, Controls, NFRs.
- **DISC**: Discovery Findings, Assumptions, Risks, Unknowns, Objectives, Controls, NFRs.
- **ADR**: Discovery handoff, ADR context, selected candidate option.
- **RA**: Architecture contents, Controls, NFRs, Objectives.

Within a selected source set, Recommendation Precedence is evaluated in the declared global order from highest to lowest: Source artifact, Clarification responses, Profile, Objectives, Controls, NFRs, Discovery, Reference Architectures, Reference Implementations. A source name is eligible only when it belongs to the finding's selected artifact-specific set.

#### Evidence Traceability Contract

Every recommendation or alternative supported by evidence MUST retain the following structure:

**Evidence Sources**:

- Source Type
- Source Identifier
- Reason Used

Example:

**Evidence Sources**:

- Profile
  - PRF000001
  - Contains approved hosting restriction

- Control
  - CTL000015
  - Requires encrypted storage

### User Story 3 - Preserve Decision Ownership Across Consumers (Priority: P1)

As a repository maintainer, I want selection, response, escalation, and downstream consumption rules to remain explicit so that Clarification guides decisions without making them on behalf of Request, Discovery, ADR, or Reference Architecture owners.

**Why this priority**: Clarification is an upstream advisory dependency; consumers must be able to use its context without treating generated guidance as an authoritative decision.

**Independent Test**: Exercise A/B/C/D and None selection, response acceptance, conflict escalation, and consumer handoffs for REQ, DISC, ADR, and RA findings, then verify lifecycle transitions, escalation ownership, and source immutability.

**Acceptance Scenarios**:

1. **Given** an open finding, **When** a user selects A, B, C, or D, **Then** Clarification records Selected Option and leaves Response unchanged until the user provides or accepts a response.
2. **Given** a selected option without an accepted response, **When** the record is updated, **Then** the finding remains open.
3. **Given** a response is provided or accepted, **When** the user explicitly accepts it, **Then** only the open-to-resolved transition may occur and Response remains authoritative over Selected Option.
4. **Given** a finding escalates for decision, **When** ownership is reported, **Then** REQ routes to the Request owner, DISC to the Discovery consumer or responsible architect, ADR to the ADR decision authority, and RA to the Reference Architecture owner.
5. **Given** a downstream consumer receives Clarification guidance, **When** it interprets the record, **Then** it may use Question, Why It Matters, Response, Selected Option, and Status, but MUST NOT treat Recommended Option or Alternative Options as authoritative decisions.
6. **Given** any guided-resolution operation completes, **When** ownership and immutability are verified, **Then** Clarification has not approved a governance decision, selected an architecture, resolved a finding automatically, changed Discovery recommendations, changed ADR decisions, or modified source artifacts.

#### Escalation Ownership Contract

When a finding escalates for decision:

- **REQ** findings escalate to the Request owner.
- **DISC** findings escalate to the Discovery consumer or responsible architect.
- **ADR** findings escalate to the ADR decision authority.
- **RA** findings escalate to the Reference Architecture owner.

Escalation ownership is advisory and does not modify source artifacts.

#### Option Selection Lifecycle

Selecting an option does not create a response.

1. User selects A, B, C, or D.
2. Clarification records Selected Option.
3. User provides or accepts a Response.
4. Only an accepted Response may transition open to resolved.

Selected Option is informational. Response remains authoritative.

#### Consumer Contract

Consumers may use:

- Question
- Why It Matters
- Response
- Selected Option
- Status

Consumers MUST NOT treat:

- Recommended Option
- Alternative Options

as authoritative decisions. Generated options are advisory guidance only.

### Edge Cases

- The retained template and canonical skill declare different versions; validation rejects the mismatch before the contract is considered valid.
- A finding category and the category segment of its fingerprint disagree; the record is invalid and no partial write occurs.
- Evidence exists in a source outside the artifact-specific set; that evidence is ignored even if it appears earlier in the global precedence list.
- No eligible evidence exists; the recommendation is `Unknown`, not an escalation.
- Multiple eligible values conflict at the highest applicable precedence; the recommendation is `Unknown / Escalate for Decision`, with all conflicting evidence retained.
- A conflict has no clearly identifiable owner; Clarification reports the artifact-type owner mapping and remains advisory without selecting a decision.
- A user selects an option but never accepts a response; the finding remains open and Response remains None or unchanged.
- A user provides a response without an explicit acceptance event; the response remains a candidate and cannot resolve the finding.
- Evidence has incomplete traceability fields; generation fails validation without partially writing the record.
- A consumer attempts to treat a recommendation as authoritative; the consumer contract rejects that interpretation while allowing advisory fields to be read.
- A source artifact is immutable or unavailable; guidance retains only valid evidence and does not modify the source.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Clarification record template MUST declare metadata version `2.0.0`, matching the `highway-clarify` skill contract version `2.0.0`.
- **FR-002**: The Clarification contract MUST require the finding category and the category segment of its fingerprint to agree for every finding.
- **FR-003**: Guidance generation MUST select the artifact-specific source set before applying Recommendation Precedence.
- **FR-004**: Recommendation Precedence MUST be applied only to sources that belong to the selected artifact-specific source set; all other sources MUST be ignored for guidance generation.
- **FR-005**: The artifact-specific source sets MUST be REQ: Request, Profile, Objectives, Controls, NFRs; DISC: Discovery Findings, Assumptions, Risks, Unknowns, Objectives, Controls, NFRs; ADR: Discovery handoff, ADR context, selected candidate option; and RA: Architecture contents, Controls, NFRs, Objectives.
- **FR-006**: When eligible authoritative evidence exists, the recommendation MUST use the highest-precedence available evidence within the selected source set and MUST be deterministic for identical inputs.
- **FR-007**: When no authoritative evidence exists within the selected source set, the recommendation MUST be `Unknown` and the rationale MUST identify the evidence gap.
- **FR-008**: When authoritative evidence conflicts at the highest applicable precedence, the recommendation MUST be `Unknown / Escalate for Decision`; neither conflicting value may be selected as Recommended.
- **FR-009**: A conflict escalation MUST retain each conflicting source and value as traceable alternatives and require explicit user selection among A, B, C, or D Custom.
- **FR-010**: Every evidence-backed recommendation or alternative MUST expose Evidence Sources with Source Type, Source Identifier, and Reason Used.
- **FR-011**: Escalation ownership MUST map REQ findings to the Request owner, DISC findings to the Discovery consumer or responsible architect, ADR findings to the ADR decision authority, and RA findings to the Reference Architecture owner.
- **FR-012**: Escalation ownership MUST remain advisory and MUST NOT modify source artifacts or transfer decision authority to Clarification.
- **FR-013**: Selecting A, B, C, or D MUST record Selected Option without creating or changing Response and without resolving the finding.
- **FR-014**: Only an explicitly accepted Response MAY transition a finding from open to resolved; Selected Option is informational and Response remains authoritative.
- **FR-015**: Consumers MAY use Question, Why It Matters, Response, Selected Option, and Status, but MUST NOT treat Recommended Option or Alternative Options as authoritative decisions.
- **FR-016**: Clarification MUST verify that guided resolution never approves a governance decision, selects an architecture, resolves a finding automatically, changes Discovery recommendations, changes ADR decisions, or mutates source artifacts.
- **FR-017**: Validation failures involving version mismatch, fingerprint/category mismatch, incomplete evidence traceability, invalid selections, conflicts, or ownership violations MUST prevent partial writes.
- **FR-018**: This feature MUST preserve existing Clarification finding detection, tracking, lifecycle states, response capture, history, privacy filtering, source immutability, and ownership boundaries.
- **FR-019**: The contract and retained output examples MUST define `Unknown` as the state used when no authoritative evidence exists and `Escalate for Decision` as the state used when authoritative evidence exists but conflicts.
- **FR-020**: The feature MUST provide verification coverage for all four artifact-specific source sets, both recommendation absence/conflict states, evidence traceability, escalation ownership, option-selection lifecycle, consumer restrictions, and the five ownership prohibitions.

### Key Entities *(include if feature involves data)*

- **Contract Version**: The shared major version declared by the canonical Clarification skill and retained record template.
- **Finding Identity**: The finding category and fingerprint category segment that must agree.
- **Artifact-Specific Source Set**: The allowed evidence sources for REQ, DISC, ADR, or RA guidance generation.
- **Recommendation Precedence**: The ordered ranking applied after source-set filtering.
- **Evidence Source**: A traceability tuple of Source Type, Source Identifier, and Reason Used.
- **Recommendation State**: `Unknown` for absent authoritative evidence or `Unknown / Escalate for Decision` for conflicting authoritative evidence.
- **Escalation Owner**: The advisory responsible owner associated with the finding artifact type.
- **Selected Option**: Informational A, B, C, D, or None tracking.
- **Accepted Response**: The user-authoritative response event that may resolve an open finding.
- **Consumer Contract**: The permitted and prohibited uses of Clarification fields by downstream workflows.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of canonical Clarification skill and retained record template metadata comparisons report matching version `2.0.0`.
- **SC-002**: 100% of representative findings with category `missing_input` contain `missing_input` as the fingerprint category segment.
- **SC-003**: 100% of repeated guidance generations with identical inputs produce identical eligible-source selection, precedence result, recommendation state, alternatives, rationale, and evidence traceability.
- **SC-004**: 100% of guidance generations ignore sources outside the selected artifact-specific source set across REQ, DISC, ADR, and RA fixtures.
- **SC-005**: 100% of no-evidence cases produce `Unknown`, and 100% of highest-precedence conflict cases produce `Unknown / Escalate for Decision` without selecting a conflicting value as Recommended.
- **SC-006**: 100% of evidence-backed options include Source Type, Source Identifier, and Reason Used, and 100% of escalations identify the artifact-type advisory owner.
- **SC-007**: 100% of option selections leave Response authoritative and leave the finding open until an explicitly accepted response occurs.
- **SC-008**: 100% of consumer-contract checks reject treating Recommended Option or Alternative Options as authoritative while permitting the defined advisory fields.
- **SC-009**: 100% of ownership-boundary checks confirm no automatic governance approval, architecture selection, finding resolution, Discovery recommendation change, ADR decision change, or source-artifact mutation.
- **SC-010**: 100% of invalid contract, identity, traceability, selection, conflict, and ownership inputs produce no partial write.

## Assumptions

- Feature 071 remains the baseline guided-resolution contract and is extended rather than replaced.
- The `highway-clarify` skill and clarification record template are the canonical sources for this contract; generated adapters and catalogs remain derived artifacts.
- The global Recommendation Precedence order remains the existing order, but it is evaluated only after artifact-specific source filtering.
- `Unknown` and `Unknown / Escalate for Decision` are retained as distinct deterministic recommendation states; no additional recommendation state is introduced.
- Consumers receive read-only Clarification guidance and remain responsible for their own authoritative decisions and lifecycle transitions.
- Existing privacy filtering, conflict handling, revision checks, no-partial-write behavior, and source immutability remain authoritative.
- Escalation ownership identifies who should decide; it does not grant that owner or Clarification permission to mutate another artifact.
- No additional structural changes are required before ADR implementation once these contract rules are implemented and verified.
