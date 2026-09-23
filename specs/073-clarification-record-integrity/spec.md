# Feature Specification: Clarification Record Integrity

**Feature Branch**: `073-clarification-record-integrity`

**Created**: 2026-09-22

**Status**: Draft

**Input**: User description: "Create a specification to restore resolution-history traceability, separate contract rules from finding instances, restore a valid frontmatter example, normalize multi-source evidence, add recommendation basis, distinguish Unknown from Escalate for Decision, fix fingerprint formatting, and document the option-selection lifecycle in the Clarification record template."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Trace Resolution History to Findings (Priority: P1)

As a repository maintainer, I want every resolution-history entry to identify its finding so that retained response history can be traced to the exact clarification finding that produced it.

**Why this priority**: Unidentified history entries cannot reliably support auditing, reconstruction, or downstream reporting.

**Independent Test**: Inspect the retained clarification-record example and verify that each resolution-history entry is a list item containing a Finding identifier, Response, Revision, and Actor.

**Acceptance Scenarios**:

1. **Given** a record with open and resolved findings, **When** resolution history is rendered, **Then** every history entry includes the corresponding `CLAR-<ARTIFACT-ID>-NNN` finding identifier.
2. **Given** two findings have separate history entries, **When** a consumer reads the history, **Then** each entry can be mapped to exactly one finding without relying on order or response text.
3. **Given** a history entry is retained after resolution, **When** its finding is read, **Then** the finding identifier remains stable and matches the finding record.

---

### User Story 2 - Read a Valid, Unambiguous Record Template (Priority: P1)

As a repository maintainer, I want the clarification-record template to distinguish retained data from explanatory contract rules so that generated records have valid structure and consumers do not mistake instructions for finding data.

**Why this priority**: Malformed frontmatter and embedded workflow prose can make records invalid or cause consumers to interpret documentation as persisted state.

**Independent Test**: Parse the template example and inspect representative findings to verify valid frontmatter delimiters, aligned fingerprint fields, placeholder escalation ownership, and no workflow-rule prose inside findings.

**Acceptance Scenarios**:

1. **Given** the File Frontmatter example, **When** it is parsed as YAML frontmatter, **Then** it begins and ends with delimiters and contains the retained record fields exactly once.
2. **Given** a finding example, **When** its fields are read, **Then** `fingerprint` aligns with the other finding fields and contains the normalized finding identity.
3. **Given** a finding example, **When** escalation ownership is read, **Then** it contains only `Escalation Owner: <owner>` and does not contain workflow explanations or owner mappings.
4. **Given** the explanatory contract section, **When** a consumer reads it, **Then** workflow and ownership rules are documented outside retained finding instances.

---

### User Story 3 - Interpret Recommendation Evidence and Option Lifecycle (Priority: P1)

As a repository maintainer, I want evidence sources, recommendation basis, evidence-gap outcomes, conflict outcomes, and option selection lifecycle to be explicit so that Clarification remains deterministic and advisory across REQ, DISC, ADR, and RA workflows.

**Why this priority**: Consumers need to distinguish evidence-backed guidance from missing evidence and conflicts without treating a selected option as an authoritative response.

**Independent Test**: Inspect representative recommendation examples and explanatory contract text for multi-source evidence entries, `Recommendation Basis`, distinct `Unknown` and `Escalate for Decision` states, and the four-step option-selection lifecycle.

**Acceptance Scenarios**:

1. **Given** a recommendation supported by multiple sources, **When** Evidence Sources are rendered, **Then** each source has Source Type, Source Identifier, and Reason Used under a separate list item.
2. **Given** a recommendation has a single authoritative value, **When** its basis is read, **Then** `Recommendation Basis` is `authoritative`.
3. **Given** no authoritative evidence exists, **When** the recommendation state is rendered, **Then** it is `Unknown` and the basis is `evidence-gap`.
4. **Given** authoritative evidence conflicts, **When** the recommendation state is rendered, **Then** it is `Escalate for Decision` and the basis is `conflict`; it is not combined with `Unknown`.
5. **Given** a user selects A, B, C, or D, **When** the lifecycle is applied, **Then** Selected Option is recorded, Response remains authoritative, and only an accepted Response performs `open -> resolved`.
6. **Given** a finding is consumed by REQ, DISC, ADR, or RA, **When** recommendation guidance is interpreted, **Then** the state and basis remain advisory and do not transfer decision ownership to Clarification.

### Edge Cases

- A resolution-history entry is missing a Finding identifier; validation rejects the malformed record without partial write.
- A history entry references a finding identifier that is not present in the Findings section; validation rejects the record without silently attaching it to another finding.
- Frontmatter has an opening delimiter but no closing delimiter; validation rejects the template or record example.
- A finding contains contract prose in place of retained data; validation identifies the misplaced content rather than treating it as a field value.
- A finding has zero, one, or many evidence sources; the structure remains unambiguous, and every retained source has all three traceability fields.
- A recommendation has no evidence, one authoritative value, or conflicting authoritative values; its basis and state remain distinct and deterministic.
- A user selects an option without providing an accepted response; the finding remains open and Response is unchanged.
- A response is supplied but not explicitly accepted; it remains a candidate and cannot resolve the finding.
- A fingerprint is formatted with inconsistent indentation; validation still requires the canonical field structure and identity value.
- A record applies to any supported artifact type (`REQ`, `DISC`, `ADR`, or `RA`) while preserving the same lifecycle and ownership boundaries.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The retained Resolution History structure MUST represent each entry as a list item with Finding, Response, Revision, and Actor fields.
- **FR-002**: Every Resolution History Finding value MUST reference exactly one finding identifier present in the same clarification record.
- **FR-003**: The File Frontmatter example MUST be a complete delimited frontmatter block containing `id`, `artifact_id`, `artifact_type`, `source_path`, `status`, `revision`, `open_findings`, `resolved_findings`, `total_findings`, and `blocking_reason`.
- **FR-004**: The template MUST keep retained finding data separate from explanatory contract rules.
- **FR-005**: A finding example MUST retain only `Escalation Owner: <owner>` as its escalation-owner field; owner mappings and workflow explanations MUST appear in the explanatory contract section.
- **FR-006**: The `fingerprint` field MUST align with other finding fields and use the canonical normalized identity format without extra indentation.
- **FR-007**: Every evidence source entry MUST be represented as a separate list item containing Source Type, Source Identifier, and Reason Used.
- **FR-008**: Evidence-backed findings MUST expose `Recommendation Basis: authoritative` when the recommendation derives from authoritative evidence.
- **FR-009**: Findings without authoritative evidence MUST expose `Recommendation Basis: evidence-gap` and recommendation state `Unknown`.
- **FR-010**: Findings with conflicting authoritative evidence MUST expose `Recommendation Basis: conflict` and recommendation state `Escalate for Decision`.
- **FR-011**: The contract MUST NOT combine `Unknown` and `Escalate for Decision` into one recommendation state.
- **FR-012**: The explanatory contract MUST document the Option Selection Lifecycle as: user selects A, B, C, or D; Selected Option is recorded; user provides or accepts a Response; accepted Response performs `open -> resolved`.
- **FR-013**: The contract MUST state that Selected Option is informational and Response remains authoritative.
- **FR-014**: Selecting an option MUST NOT create or change Response and MUST NOT resolve a finding.
- **FR-015**: Only an explicitly accepted Response MAY transition an open finding to resolved; resolved findings MUST NOT transition back to open.
- **FR-016**: Recommendation basis, recommendation state, evidence traceability, history identifiers, and option lifecycle MUST remain deterministic and applicable to REQ, DISC, ADR, and RA records.
- **FR-017**: Validation failures involving history identity, frontmatter delimiters, misplaced contract rules, evidence-source shape, recommendation basis, recommendation-state distinction, or option lifecycle MUST prevent partial writes.
- **FR-018**: The feature MUST preserve existing finding detection, identity, privacy filtering, source immutability, revision handling, response capture, ownership boundaries, and generated-artifact synchronization.
- **FR-019**: Recommendation State SHALL be stored in the Recommended Option field.
- **FR-020**: A Resolution History entry MUST NOT reference a finding identifier already present within the same Resolution History section.
- **FR-021**: When no evidence sources exist, Evidence Sources SHALL contain None.
- **FR-022**: Recommendation Basis and Recommendation State MUST satisfy: `authoritative` -> evidence-backed recommendation; `evidence-gap` -> `Unknown`; `conflict` -> `Escalate for Decision`.
- **FR-023**: Explanatory contract text SHALL appear outside the Findings, Resolution History, Source, and Status sections.

### Key Entities *(include if feature involves data)*

- **Resolution History Entry**: A retained history record identified by Finding, with Response, Revision, and Actor fields.
- **Clarification Record Frontmatter**: The delimited metadata block identifying the clarification artifact, source, status, revision, counts, and blocking reason.
- **Evidence Source**: A traceability item containing Source Type, Source Identifier, and Reason Used.
- **Recommendation Basis**: A classification of `authoritative`, `evidence-gap`, or `conflict` explaining why a recommendation state was produced.
- **Recommendation State**: `Unknown` for absent authoritative evidence or `Escalate for Decision` for conflicting authoritative evidence.
- **Option Selection Lifecycle**: The sequence connecting Selected Option, Response, acceptance, and finding resolution.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of representative Resolution History entries contain a valid Finding identifier that resolves to exactly one finding in the same record.
- **SC-002**: 100% of retained frontmatter examples parse as one complete delimited block with no fields accidentally included in the body or metadata.
- **SC-003**: 100% of finding examples separate retained data from explanatory contract rules and use canonical fingerprint field alignment.
- **SC-004**: 100% of evidence-backed recommendation examples expose one Recommendation Basis value and complete three-field traceability for every evidence source.
- **SC-005**: 100% of absent-evidence examples produce `Unknown` with `evidence-gap`, and 100% of conflict examples produce `Escalate for Decision` with `conflict`.
- **SC-006**: 100% of option-selection tests preserve Response authority and keep findings open until an explicitly accepted Response occurs.
- **SC-007**: 100% of REQ, DISC, ADR, and RA examples preserve the same traceability, recommendation, lifecycle, and ownership rules.
- **SC-008**: 100% of malformed history, frontmatter, evidence, basis, and lifecycle inputs fail validation without partial writes.

## Assumptions

- The shared clarification-record template remains the canonical source for retained record shape and explanatory contract text.
- Generated adapters and catalogs are derived from canonical inputs and are regenerated after the template changes.
- Existing Clarification version, finding identity, source filtering, precedence, privacy, and ownership contracts remain in force unless this specification explicitly refines their representation.
- `Unknown`, `Escalate for Decision`, `authoritative`, `evidence-gap`, and `conflict` are stable contract vocabulary for this feature.
- The template examples are representative contract fixtures; implementation validation may use disposable records rather than user-owned artifacts.
- No new runtime service, persistence mechanism, or external dependency is required.
