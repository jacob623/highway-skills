# Feature Specification: NFR Skill Contract Simplification

**Feature Branch**: `109-nfr-skill-contract`

**Created**: 2026-09-30

**Status**: Draft

**Input**: User description: "Simplify highway-nfrs around NFR-specific semantics, preserve the Control-derived candidate ownership boundary, update NFR collection/readiness behavior, and revise nfr-record.md placeholders and versioning."

## Clarifications

### Session 2026-09-30

- Q: Should changing the retained NFR body placeholders bump `nfr-record.md` metadata from `1.0.0` to `2.0.0`? → A: Yes — bump to `2.0.0`.

## User Scenarios & Testing

### User Story 1 - NFR owners resolve Control-derived recommendations first (Priority: P1)

As a repository maintainer, I want unresolved NFR candidates derived from successfully created Controls to be presented and handled before open NFR discovery, so that useful grounded recommendations are not hidden behind a broad question.

**Why this priority**: Control-derived recommendations are durable, ordered, and directly traceable to the originating Control.

**Independent Test**: Exercise setup/configure with unresolved candidate state and verify candidates are presented first, decisions are persisted before advancing, review resumes at the first unresolved candidate, and no `Created Control IDs` dependency exists.

**Acceptance Scenarios**:

1. **Given** unresolved NFR-owned candidates exist, **When** setup/configure starts, **Then** those candidates are presented before the broad NFR question.
2. **Given** a candidate is explicitly selected, **When** the selection is processed, **Then** it is accepted without a second proposal-confirmation cycle.
3. **Given** a candidate is modified, rejected, skipped, or replaced, **When** the decision completes, **Then** the decision is persisted in NFR-owned durable state before the next candidate is shown.
4. **Given** candidate review is interrupted, **When** it resumes, **Then** review starts at the first unresolved candidate without restoring conversational prompts.
5. **Given** a new Control is successfully created, **When** candidate generation runs, **Then** it occurs exactly once for that originating `CTLXXXXXX`.

---

### User Story 2 - NFR owners discover and capture additional NFRs with grounded interaction (Priority: P1)

As a repository maintainer, I want additional NFR recommendations grounded in accepted context, and a clear captured-NFR review only when Highway materially interprets my input, so that NFR collection remains useful without redundant questions.

**Why this priority**: Open discovery is the main authoring path after Control-derived candidates are resolved.

**Independent Test**: Exercise grounded recommendations, the broad question fallback, direct NFR capture, materially interpreted review, and Control-shaped routing.

**Acceptance Scenarios**:

1. **Given** accepted Profile, Objectives, Controls, or existing NFRs support useful choices, **When** open discovery begins, **Then** grounded recommendations are offered before unnecessary questioning.
2. **Given** no useful grounded recommendations exist, **When** open discovery begins, **Then** Highway asks `Are there any qualities or operational expectations you'd like future solutions to meet?` with concise illustrative examples when useful.
3. **Given** a direct statement is already expressed as an NFR, **When** it requires no material transformation, **Then** it is captured directly.
4. **Given** Highway materially interprets, classifies, normalizes, or synthesizes user-authored NFR evidence, **When** it presents the result, **Then** it uses the captured-NFR review with Title, Statement, Why it matters, and one acceptance request at the bottom.
5. **Given** a user-authored statement is enforceable, auditable, or checkable, **When** classification remains unresolved, **Then** Highway asks one bounded classification question or routes the evidence to Controls.
6. **Given** an explicitly selected Highway recommendation is accepted, **When** it is captured, **Then** it does not receive a second review or confirmation cycle.

---

### User Story 3 - NFR readiness and collection completion remain distinct (Priority: P1)

As a setup owner, I want NFR readiness and collection completion to remain separate owner results, so that a usable NFR baseline does not falsely end an active collection conversation.

**Why this priority**: Setup must rely on owner-controlled state rather than inspecting candidate internals or counts.

**Independent Test**: Exercise all readiness states and setup/configure collection states with zero candidates, unresolved candidates, accepted NFRs, malformed state, and explicit finish.

**Acceptance Scenarios**:

1. **Given** valid zero Control-derived candidates and no accepted NFRs, **When** readiness is requested, **Then** it returns `Not Applicable`.
2. **Given** unresolved Control-derived candidates exist, **When** readiness is requested, **Then** it returns `In Progress`.
3. **Given** accepted valid NFR artifacts exist, **When** readiness is requested, **Then** it returns `Complete`.
4. **Given** required NFR state is malformed or unavailable, **When** readiness is requested, **Then** it returns `Blocked` without mutation.
5. **Given** setup/configure collection is active, **When** readiness becomes Complete, **Then** collection continues until explicit user finish.
6. **Given** the user explicitly finishes, **When** setup/configure returns, **Then** the four-field collection result reports `Finished` without a created-NFR-ID list.

---

### User Story 4 - NFR records preserve accepted content and Control traceability (Priority: P1)

As an NFR owner, I want the retained NFR record to distinguish accepted content from its origin while preserving identifier-only Control relationships, so that direct and Control-derived NFRs remain traceable.

**Why this priority**: The shared NFR record template is the durable structural authority.

**Independent Test**: Validate direct NFR records, Control-derived NFR records, frontmatter, body placeholders, and relationship updates.

**Acceptance Scenarios**:

1. **Given** a direct NFR is created, **When** its record is read, **Then** frontmatter contains `id`, `title`, `status`, and `controls: []`.
2. **Given** a Control-derived NFR is accepted, **When** its record is read, **Then** `controls` contains immutable originating `CTLXXXXXX` identifiers only.
3. **Given** an NFR record is generated, **When** its body is read, **Then** it uses `<accepted NFR statement>` and `<accepted evidence-grounded rationale>`.
4. **Given** an NFR value came from direct authorship, accepted material interpretation, or an explicitly selected recommendation, **When** the template guidance is read, **Then** all three origins are permitted without implying literal user typing.
5. **Given** a relationship mutation is accepted, **When** persistence completes, **Then** the record, catalog, and relationship changes are atomic and destructive impact is handled before mutation.

---

### User Story 5 - Maintainers receive a concise, maintainable NFR skill contract (Priority: P2)

As a Highway maintainer, I want `highway-nfrs` to contain only NFR-specific behavior and references to shared governance, so that the runtime skill is easier to follow and does not conflict with the Constitution or Experience Standard.

**Why this priority**: Removing duplicated and historical runtime prose reduces contradictory behavior while preserving the domain contract.

**Independent Test**: Inspect the skill for the simplified workflow, NFR-specific exceptions, version change, ownership boundary, and absence of obsolete Feature 094, Security Gate, Maintainability Gate, per-step error, post-write verification, and duplicated interaction material.

**Acceptance Scenarios**:

1. **Given** the runtime skill is read, **When** its Experience section is reviewed, **Then** it says `User-visible interaction follows the Highway Experience Standard.` and does not restate generic interaction rules.
2. **Given** the runtime workflow is reviewed, **When** its steps are counted, **Then** it uses the short ordered NFR-specific flow and preserves mutation/ownership ordering.
3. **Given** the Verification and Error Handling sections are reviewed, **When** obsolete material is searched for, **Then** only NFR-specific checks and exceptions remain.
4. **Given** NFR candidate state is described in the skill, **When** the description is compared across sections, **Then** the durable state schema is defined once and referenced elsewhere.
5. **Given** the skill metadata is read, **When** the version is checked, **Then** `highway-nfrs` is `11.0.0`.

### Edge Cases

- A valid zero-candidate state is Not Applicable, not Blocked or Complete.
- Candidate review resumes at the first unresolved candidate without replaying prompts.
- A candidate-generation request with an invalid originating Control produces a Blocked owner result and no partial NFR relationship.
- A malformed durable candidate state blocks without mutating accepted NFR records.
- A direct NFR with no Control relationship remains valid with `controls: []`.
- A user asks for suggestions after candidates are resolved; grounded recommendations are shown without restarting broad discovery.
- No useful grounded recommendations remain; collection ends only after explicit finish, not merely because readiness is Complete.
- A user-authored Control-shaped statement remains user-owned while classification is resolved or routed.
- Duplicate or overlapping NFRs are named before persistence, and destructive Remove/Set impact is analyzed before mutation.
- An attempted post-write verification step is absent; successful persistence is governed by the Constitution common failure model.

## Requirements

### Functional Requirements

#### Runtime skill scope and shared governance

- **FR-001**: `highway-nfrs` MUST focus on NFR-specific semantics, Control-derived recommendations, readiness, persistence, relationships, and collection continuation.
- **FR-002**: The runtime skill MUST replace its Experience content with `User-visible interaction follows the Highway Experience Standard.` and MUST remove local restatements of shared interaction, recommendation, progress, exit, acknowledgment, and presentation rules.
- **FR-003**: The runtime skill MUST remove Feature 094, historical FR/SC, Security Gate, Maintainability Gate, development-test, compliance, per-step error-table, and duplicated Repository Context material.
- **FR-004**: The runtime skill MUST retain only NFR-specific Error Handling exceptions and rely on the Constitution common failure model for generic failures.
- **FR-005**: The runtime skill MUST use the short ordered workflow: classify action/baseline; load grounding/state; resolve pending Control-derived recommendations; offer additional recommendations; process user evidence or route Control-shaped evidence; capture selections/review interpreted input; revalidate and persist atomically; continue until explicit finish; report readiness separately.

#### Inputs and ownership

- **FR-006**: NFR grounding MUST include accepted Profile, Business Objectives, Controls, existing NFRs, declared Highway framing artifacts, NFR-owned durable candidate state, the Controls candidate-generation input/result contract, and destructive relationship impact analysis where applicable.
- **FR-007**: Controls MUST remain responsible only for triggering candidate generation after a successfully created new Control, deterministic initial derivation, originating `CTLXXXXXX`, and consuming the declared generation result.
- **FR-008**: NFRs MUST own durable candidate state, classification, review, NFR persistence and identifiers, catalog, Control relationships, readiness, and collection completion.
- **FR-009**: All remaining `verified new Control`, `verified Control`, and `persistence-verified` terminology MUST be replaced with `successfully created new Control`, and all `Created Control IDs` dependencies MUST be removed.
- **FR-010**: NFRs MUST preserve exactly-once candidate generation per successfully created originating Control and MUST not duplicate Controls-owned derivation rules beyond the input/result contract.

#### Durable candidate state and recommendations

- **FR-011**: `.highway/catalog/nfr-candidate-state.md` MUST remain NFR-owned and durable.
- **FR-012**: Durable candidate state MUST retain only originating Control identity, ordered candidate content, candidate decisions, unresolved-review position, and readiness-required state, with the schema defined once.
- **FR-013**: Pending Control-derived candidates MUST be presented before broad NFR discovery, reviewed in order, resumable, and persisted decision-by-decision before advancing.
- **FR-014**: Candidate selection MUST count as acceptance without redundant confirmation; modification, rejection/skip, and alternatives MUST remain available.
- **FR-015**: After pending candidates are resolved, NFR recommendations MUST be grounded in accepted Profile, Objectives, Controls, or existing NFRs before unnecessary questions, with accepted Organization Name used when helpful.
- **FR-016**: When no useful grounded recommendation exists, open discovery MUST use the exact broad NFR question and bounded illustrative examples.
- **FR-017**: Recommendation sets MUST remain small, non-duplicate, and continue only while useful grounded choices remain and the user wants to continue.

#### NFR authoring and classification

- **FR-018**: Directly expressed NFR evidence MUST be captured without material-interpretation review when no transformation is required.
- **FR-019**: Materially interpreted user-authored NFRs MUST use the captured-NFR review with the exact heading, Title, Statement, Why it matters, and bottom acceptance request specified by the feature.
- **FR-020**: Rationale MUST be synthesized from accepted evidence and grounding rather than collected through a separate rationale question.
- **FR-021**: NFR-versus-Control classification MUST remain transient; ambiguous classification MAY ask one bounded question, and user-owned wording MUST NOT be rejected merely because refinement is recommended.
- **FR-022**: Obvious Control statements MUST NOT be presented as improved NFR alternatives.

#### Readiness and collection

- **FR-023**: NFR readiness MUST preserve the exact four-field result with `Status: Complete|In Progress|Blocked|Not Applicable`, Summary, Next Action, and Blocking Reason.
- **FR-024**: Readiness MUST mean Not Applicable for valid zero candidates with no accepted NFRs, In Progress for unresolved candidates, Complete for accepted valid NFR artifacts, and Blocked for malformed or unavailable required state.
- **FR-025**: Readiness MUST remain owner-controlled, separate from collection completion, and must not require Setup to inspect candidate counts or state.
- **FR-026**: Setup/configure collection MUST preserve the exact four-field result with Action Status, Collection Result, Next Action, and Blocking Reason; Continue remains active, Finished requires explicit user finish, and no created-NFR-ID list may be added.

#### Records, relationships, and persistence

- **FR-027**: NFR records MUST follow `nfr-record.md`, retain frontmatter fields `id`, `title`, `status`, and identifier-only `controls`, and preserve direct creation with `controls: []`.
- **FR-028**: `nfr-record.md` MUST replace the body placeholders with `<accepted NFR statement>` and `<accepted evidence-grounded rationale>`.
- **FR-029**: `nfr-record.md` MUST explain that accepted values may originate from direct user authorship, accepted material interpretation, or explicitly selected Highway recommendations without requiring literal user typing.
- **FR-030**: Accepted Control-derived NFRs MUST preserve immutable originating `CTLXXXXXX` relationships, and relationship updates MUST remain atomic with accepted NFR persistence.
- **FR-031**: NFR persistence MUST preserve baseline validation, duplicate/overlap handling, permanent identifier allocation/non-reuse, deterministic catalog generation, semantic version behavior, atomic mutation, and destructive safeguards.
- **FR-032**: Post-write persistence verification, shell/file verification, retained-output verification, and equivalent wording MUST be removed.

#### Verification, error handling, and versioning

- **FR-033**: Verification MUST cover shared templates, readiness meanings, collection separation, durable ordered candidate state, exactly-once generation, recommendation ordering/acceptance, classification, relationships, atomic persistence, destructive safeguards, and absence of post-write verification.
- **FR-034**: Error Handling MUST retain only malformed record/catalog/allocation state, malformed candidate state, invalid originating Control/generation request, unresolved target, unresolved classification, destructive action, and unavailable relationship-impact exceptions.
- **FR-035**: `highway-nfrs` MUST increment from `10.0.0` to `11.0.0`, and `nfr-record.md` metadata MUST increment from `1.0.0` to `2.0.0` for the retained placeholder contract change.
- **FR-036**: Generated adapters, catalogs, registrations, and dependent tests MUST remain aligned with canonical skill and template changes.

### Key Entities

- **NFR**: An accepted non-functional requirement with stable identity, title, status, statement, rationale, and identifier-only Control relationships.
- **NFR candidate state**: NFR-owned durable ordered recommendations, decisions, originating Control identity, unresolved position, and readiness information.
- **NFR readiness result**: The four-field owner-controlled result describing NFR baseline usability.
- **NFR collection result**: The four-field setup/configure result describing whether active NFR collection continues or finishes.
- **Control-derived relationship**: Immutable `CTLXXXXXX` traceability retained on accepted Control-derived NFRs.

## Success Criteria

### Measurable Outcomes

- **SC-001**: 100% of `highway-nfrs` runtime interaction, verification, and error text is NFR-specific or a reference to the Constitution/Experience Standard; obsolete Feature 094, duplicated generic, and post-write verification material has zero retained occurrences.
- **SC-002**: 100% of unresolved Control-derived candidates are presented before open discovery, preserve order, persist decisions before advancement, and resume from the first unresolved candidate.
- **SC-003**: Candidate generation occurs exactly once for every successfully created new Control and never depends on `Created Control IDs`.
- **SC-004**: All four readiness states and both collection outcomes are returned with their exact four-field contracts, with readiness and collection completion remaining independent.
- **SC-005**: 100% of retained NFR records preserve the four required frontmatter fields, identifier-only `controls`, and the accepted-content body placeholders; direct NFRs use `controls: []`.
- **SC-006**: 100% of accepted Control-derived NFRs retain immutable originating Control identifiers and atomic reciprocal relationship updates.
- **SC-007**: 100% of materially interpreted user-authored NFRs use the captured-NFR review, while direct NFR statements and selected recommendations avoid redundant review.
- **SC-008**: The full test suite passes with generated adapters/catalogs aligned and no linter errors.

## Assumptions

- The existing NFR catalog and candidate-state paths remain authoritative; this feature changes their runtime contract, not their ownership.
- Existing Control-derived candidate fixtures and relationship fixtures are updated to the new terminology rather than replaced with a parallel mechanism.
- NFRs remain user-owned governance artifacts while the NFR skill and shared templates remain Highway artifacts governed by the Constitution and Experience Standard.
- `nfr-record.md` metadata changes from `1.0.0` to `2.0.0` because the retained placeholder contract changes.
- Setup consumes owner results and does not inspect durable candidate internals.

## Dependencies

- The existing `highway-controls` candidate-generation input/result contract and Control `nfrs` relationship field.
- The Highway Skills Constitution and Highway Experience Standard.
- The existing NFR catalog, candidate-state, relationship, readiness, generator, adapter, and test infrastructure.

## Out of Scope

- Changing Control ownership of initial candidate derivation or the Control record's relationship schema.
- Introducing external benchmark applicability or copying Control Recommendation Grounding into NFR records.
- Adding a persisted classification field or a created-NFR-ID collection result field.
- Changing the user-owned meaning or achievement validation of an NFR.
