# Feature Specification: Final NFR Contract Cleanup

**Feature Branch**: `110-nfr-cleanup-correction`

**Created**: 2026-09-30

**Status**: Draft

**Input**: User description: "Final highway-nfrs and nfr-record cleanup instructions"

## User Scenarios & Testing

### User Story 1 - Capture NFRs without redundant review (Priority: P1)

As a person authoring NFRs, I want direct NFR statements and explicitly selected recommendations
captured without an inferred-content review, while materially interpreted input receives a clear,
correctly formatted review.

**Why this priority**: It prevents redundant confirmation and makes the acceptance boundary
consistent with the shared Experience Standard.

**Independent Test**: Inspect the canonical NFR skill and exercise direct, selected-recommendation,
and materially interpreted input paths independently.

**Acceptance Scenarios**:

1. **Given** a direct statement already expressed as an NFR, **When** it is processed, **Then** it
   bypasses the inferred-content review but still undergoes validation, duplicate handling,
   identifier allocation, relationship handling, and atomic persistence.
2. **Given** a displayed Highway recommendation is explicitly selected, **When** it is accepted,
   **Then** it is captured without a second NFR proposal confirmation.
3. **Given** user-authored evidence is materially interpreted, classified, normalized, or
   synthesized, **When** Highway presents the review, **Then** it uses the exact captured-NFR
   heading, labeled Title, Statement, and Why it matters fields, followed by the acceptance request
   at the bottom.

### User Story 2 - Preserve ordered, durable candidate handling (Priority: P1)

As the NFR owner, I want Control-derived candidate state described as persisted NFR-owned recovery
state so pending recommendations are resolved in order before additional recommendations or broad
discovery.

**Why this priority**: It preserves resumability and the ownership boundary established by the
11.0.0 contract.

**Independent Test**: Inspect the candidate-state reference and verify ordering, decision
persistence, resume behavior, and readiness implications without relying on conversational prompts.

**Acceptance Scenarios**:

1. **Given** unresolved Control-derived candidates, **When** NFR setup/configure continues, **Then**
   those candidates are offered before contextual recommendations and broad discovery.
2. **Given** candidate review is interrupted, **When** it resumes, **Then** review starts at the
   first unresolved candidate using persisted order, content, decisions, and originating Control.
3. **Given** no useful grounded recommendation exists after pending candidates are resolved, **When**
   open discovery begins, **Then** Highway asks the exact fallback question and does not ask a separate
   rationale question.

### User Story 3 - Preserve NFR record and relationship semantics (Priority: P1)

As a repository owner, I want the NFR record template to remain structurally stable while clearly
representing accepted content and Control relationships.

**Why this priority**: Existing records and downstream traceability depend on the unchanged 2.0.0
frontmatter and relationship shape.

**Independent Test**: Validate the NFR record template and direct and Control-derived relationship
fixtures.

**Acceptance Scenarios**:

1. **Given** the NFR record template, **When** it is validated, **Then** it remains version 2.0.0
   with only `id`, `title`, `status`, and `controls` frontmatter.
2. **Given** a direct NFR, **When** it is retained, **Then** its `controls` relationship list is
   empty.
3. **Given** a Control-derived NFR, **When** it is retained, **Then** it may contain immutable
   `CTLXXXXXX` identifiers and does not copy the Control's Recommendation Grounding.
4. **Given** accepted NFR content, **When** its origin is described, **Then** the template permits
   direct user-authored content, accepted materially interpreted content, or an explicitly selected
   Highway recommendation without claiming the user literally typed every retained value.

### User Story 4 - Keep owner results and safeguards concise (Priority: P2)

As a workflow owner, I want readiness, collection completion, persistence safeguards, workflow, and
error handling to remain concise and NFR-specific.

**Why this priority**: It prevents regression into duplicated generic interaction or failure rules.

**Independent Test**: Validate the skill's result contracts, workflow ordering, verification scope,
and error exceptions.

**Acceptance Scenarios**:

1. **Given** valid zero candidates and no accepted NFRs, **When** readiness is calculated, **Then**
   status is Not Applicable.
2. **Given** unresolved candidates, accepted NFR artifacts, or malformed required state, **When**
   readiness is calculated, **Then** status is respectively In Progress, Complete, or Blocked.
3. **Given** setup/configure collection, **When** it completes, **Then** the result contains only
   Action Status, Collection Result, Next Action, and Blocking Reason, and Finished requires explicit
   user intent.
4. **Given** an accepted NFR mutation, **When** it is persisted, **Then** pre-write validation,
   duplicate/overlap handling, permanent identifiers, deterministic catalogs, relationship
   integrity, semantic version behavior, atomic persistence, and destructive safeguards remain
   enforced without post-write verification.

### Edge Cases

- A direct NFR must not skip validation merely because it skips inferred-content review.
- A selected recommendation lacking required NFR evidence must continue only with the unresolved
  information.
- A blocked or inconsistent candidate state must not create an accepted-NFR mutation.
- An optional rationale must be synthesized from accepted evidence and grounding rather than causing
  a new question.
- A Control-derived NFR must retain its originating Control relationship without duplicating
  Recommendation Grounding.
- A setup/configure session may remain active after readiness becomes Complete until explicit finish.

## Requirements

### Functional Requirements

- **FR-001**: `highway-nfrs` MUST remain at version `11.0.0`.
- **FR-002**: The materially interpreted user-authored NFR review MUST use exactly:
  `**Here's what I've captured as your NFR:**`, labeled Title, Statement, and Why it matters
  fields, followed by `**Would you like to accept this NFR?**`.
- **FR-003**: Direct NFR capture MUST skip inferred-content review while retaining NFR validation,
  duplicate handling, identifier allocation, relationship handling, and atomic persistence.
- **FR-004**: Explicitly selected recommendations MUST be captured without redundant NFR proposal
  confirmation.
- **FR-005**: Rationale MUST be synthesized from accepted evidence and grounding; no separate
  rationale question may be required.
- **FR-006**: Candidate state MUST be described as authoritative persisted NFR-owned recovery state
  and remain limited to originating Control association, ordered content, decisions, unresolved
  review resume, and readiness.
- **FR-007**: Pending Control-derived recommendations MUST precede additional contextual
  recommendations and broad discovery.
- **FR-008**: Open discovery MUST use the exact fallback question only when no useful grounded
  recommendation exists, with concise examples only when they improve clarity.
- **FR-009**: NFR-versus-Control classification MUST remain transient and use one bounded question
  only when evidence remains ambiguous.
- **FR-010**: Direct NFR creation MUST retain `controls: []`; Control-derived NFRs MUST retain
  immutable `CTLXXXXXX` relationships.
- **FR-011**: NFR records MUST NOT add Recommendation Grounding or external-framework lineage.
- **FR-012**: Readiness MUST remain separate from collection completion and preserve Not Applicable,
  In Progress, Complete, and Blocked meanings.
- **FR-013**: The setup/configure Collection Result MUST contain only Action Status, Collection
  Result, Next Action, and Blocking Reason; it MUST contain no created-NFR-ID list.
- **FR-014**: Finished collection MUST require explicit user finish intent.
- **FR-015**: Post-write persistence verification MUST remain absent while existing pre-write,
  duplicate, allocation, catalog, relationship, atomicity, versioning, and destructive safeguards
  remain intact.
- **FR-016**: The skill MUST retain its short Workflow and NFR-specific Error Handling without
  restoring generic Experience Standard, Constitution, development-gate, feature-ID, or per-step
  verification language.
- **FR-017**: `nfr-record.md` MUST remain version `2.0.0`, retain its four existing frontmatter
  fields, accepted-content placeholders, origin guidance, and identifier-only `controls` semantics.
- **FR-018**: No additional structural changes may be made to `nfr-record.md`.

### Key Entities

- **NFR skill contract**: The runtime behavior, interaction boundaries, owner results, persistence
  safeguards, and verification scope for repository NFR management.
- **NFR candidate state**: Persisted NFR-owned recovery information for Control-derived candidate
  review.
- **NFR record template**: The structural authority for retained NFR record frontmatter and body.
- **Control relationship**: The immutable originating `CTLXXXXXX` traceability relationship for a
  Control-derived NFR.

## Success Criteria

### Measurable Outcomes

- **SC-001**: The canonical NFR skill and all generated adapters report version `11.0.0`.
- **SC-002**: The NFR record template reports version `2.0.0` and has no frontmatter fields beyond
  `id`, `title`, `status`, and `controls`.
- **SC-003**: Automated contract checks confirm the exact captured-NFR review, direct-capture
  validation boundary, recommendation ordering, readiness meanings, and four-field collection
  result.
- **SC-004**: Automated checks confirm no Recommendation Grounding or external-framework lineage is
  added to NFR records.
- **SC-005**: The complete repository test suite passes with zero failures, and canonical skill and
  template validators pass.
- **SC-006**: No linter diagnostics are introduced in changed canonical, test, or generated files.

## Assumptions

- The current `highway-nfrs` 11.0.0 rewrite and `nfr-record.md` 2.0.0 template are the baseline;
  this feature corrects wording and contract clarity rather than introducing a new version.
- `.highway/catalog/nfr-candidate-state.md` remains the persisted candidate-state artifact; no
  separate schema document is introduced by this cleanup.
- Generated adapters and catalogs remain derived outputs and are regenerated from canonical sources.
- The Constitution and Highway Experience Standard remain authoritative for generic failures and
  user-visible interaction behavior.
- Existing tests and fixtures can be amended to reflect the approved cleanup without changing
  unrelated domain contracts.
