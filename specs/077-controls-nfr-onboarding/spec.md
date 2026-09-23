# Feature Specification: Controls and NFRs Onboarding Enhancement

**Feature Branch**: `077-controls-nfr-onboarding`

**Created**: 2026-09-23

**Status**: Draft

**Input**: User description: "Create a complete governance onboarding experience in which Profile Setup and Objective Setup lead to deterministic Control Setup, Control Review, Control-derived NFR Generation, NFR Review, and NFR Readiness. Controls remain the primary governance onboarding mechanism. NFRs remain independently authorable, reviewable from Control-derived candidates, optionally unattached to Controls, and downstream from Control onboarding."

## Clarifications

### Session 2026-09-23

- Q: How should the Proposed Title be created during Control collection? → A: Generate an initial title from the submitted statement, then allow the user to edit or replace it during review. Example: "Administrative access must require multi-factor authentication." produces "Require Multi-Factor Authentication for Administrative Access".

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Guided Control Baseline Setup (Priority: P1)

As a repository maintainer starting governance onboarding, I want a guided Control setup flow organized by fixed categories so that I can create an initial Control baseline without defining the same governance concern twice.

**Why this priority**: Controls are the primary governance onboarding mechanism and must exist before derived NFR candidates can be reviewed.

**Independent Test**: Invoke Control setup with responses across all four categories, including a category answered with `none`, add multiple Controls in one category, and verify deterministic prompts, no writes during collection, and a complete review queue.

**Acceptance Scenarios**:

1. **Given** the profile and objective prerequisites are complete, **When** Control setup begins, **Then** it presents Security, Availability and Resilience, Operational, and Compliance and Governance categories in that exact order.
2. **Given** a category is active, **When** the user provides one Control, **Then** the workflow records a proposed Control and asks whether another Control should be added in that category.
3. **Given** the user answers Yes to another Control, **When** the next collection prompt appears, **Then** the workflow accepts another Control in the same category before advancing.
4. **Given** the first response for a category is `none`, **When** the category is processed, **Then** it completes immediately without adding a proposed Control.
5. **Given** all categories are complete, **When** collection ends, **Then** no Control identifier is allocated and no Control, catalog, or candidate file is written before review.
6. **Given** the user submits a Control statement, **When** the proposal is recorded, **Then** the workflow generates a deterministic initial Proposed Title from that statement without asking for a separate title.
7. **Given** a valid Control baseline already exists, **When** `/highway-controls setup` is invoked, **Then** the workflow reports the existing baseline, displays no collection prompts, and routes to existing Control management actions.
8. **Given** Control collection is in progress, **When** the user cancels collection, **Then** all collected proposals are discarded and no artifacts are written.
9. **Given** a generated Proposed Title exists, **When** Control collection completes but review has not completed, **Then** the generated title exists only in proposal state and is not persisted.

### User Story 2 - Control Review and Candidate Generation (Priority: P1)

As a repository maintainer, I want to review proposed Controls before they become baseline artifacts and then receive derived NFR candidates so that only reviewed Control content enters governance records.

**Why this priority**: Review is the ownership boundary between user-provided proposals and durable governance content, and candidate generation must preserve the one-way Control-to-NFR relationship.

**Independent Test**: Submit proposed Controls, exercise Accept, Modify, Replace, and Remove decisions, then verify identifiers and artifacts are created only for accepted proposals and candidate details retain their originating Control.

**Acceptance Scenarios**:

1. **Given** collection has completed, **When** Control review is displayed, **Then** every proposal shows Category, Proposed Title, and Statement and offers Accept, Modify, Replace, and Remove.
2. **Given** proposal decisions have been recorded, **When** Review Complete is invoked, **Then** the workflow allocates identifiers, writes the accepted Controls in one transaction, updates the Control catalog, validates the baseline, and generates any matching Control-derived NFR candidates.
3. **Given** a proposal is modified or replaced, **When** Review Complete is invoked, **Then** the resulting Control uses the approved content and only the accepted content is used for candidate generation.
4. **Given** a proposal is removed, **When** Review Complete is invoked, **Then** no Control artifact or candidate is created for that proposal.
5. **Given** Control Review completes successfully and candidate generation finds a match, **When** candidates are displayed, **Then** each candidate includes title, statement, rationale, originating Control identifier, and originating Control title in deterministic order.
6. **Given** a Control produces no matching candidate, **When** generation completes, **Then** the Control remains valid and the workflow reports zero candidates without creating an NFR.
7. **Given** one or more proposed Controls remain undecided, **When** Review Complete is invoked, **Then** Review Complete fails and no identifiers are allocated.
8. **Given** multiple Controls generate candidates, **When** candidates are displayed, **Then** they are ordered by originating Control identifier and derivation rule order.
9. **Given** one or more proposed Controls remain undecided, **When** Cancel Review is invoked, **Then** the review terminates and no Control, catalog, relationship, or candidate artifact is written.
10. **Given** multiple proposed Controls contain identical approved content, **When** Control Review is displayed, **Then** the workflow identifies the duplication and allows each proposal to be reviewed independently.

### User Story 3 - NFR Candidate Review and Readiness (Priority: P1)

As a repository maintainer, I want to review Control-derived NFR candidates separately from direct NFR authoring so that I can accept, edit, replace, reject, or cancel proposed NFRs while preserving optional Control relationships and clear readiness guidance.

**Why this priority**: NFR review completes the onboarding path while keeping NFR ownership distinct from Control ownership and preserving direct NFR authoring.

**Independent Test**: Review candidates using each decision, verify accepted outputs and preserved relationships, verify cancellation and rejection write nothing, and verify readiness routes missing Control baselines to Control setup.

**Acceptance Scenarios**:

1. **Given** Control-derived candidates exist, **When** NFR review starts, **Then** each candidate displays Candidate Title, Candidate Statement, Candidate Rationale, and Originating Control.
2. **Given** the user accepts a candidate, **When** Review Complete is invoked, **Then** the proposed NFR is created with its originating Control relationship preserved.
3. **Given** the user modifies or replaces a candidate, **When** Review Complete is invoked, **Then** the approved title, statement, and rationale are used and the originating Control relationship is preserved.
4. **Given** the user rejects a candidate, **When** Review Complete is invoked, **Then** no NFR artifact, catalog entry, or relationship is created.
5. **Given** the user cancels NFR review, **When** cancellation is processed, **Then** all candidate, NFR, catalog, and relationship bytes remain unchanged.
6. **Given** no Control baseline exists, **When** Control readiness is requested, **Then** the response reports `Status: Missing`, identifies no Control baseline, routes to `/highway-controls setup`, and uses `Blocking Reason: None`.
7. **Given** a user directly authors an NFR, **When** it is created outside the derived review workflow, **Then** it remains valid with an empty Control relationship.
8. **Given** a user invokes `/highway-nfrs review` or `/highway-nfrs onboarding`, **When** the action is resolved, **Then** it enters the same NFR candidate review workflow.
9. **Given** candidate generation succeeds and accepted NFRs do not exist, **When** NFR readiness is requested, **Then** readiness reports In Progress.
10. **Given** candidate generation succeeds with zero candidates and accepted NFRs do not exist, **When** NFR readiness is requested, **Then** readiness reports Not Applicable.
11. **Given** accepted NFR artifacts exist, **When** NFR readiness is requested, **Then** readiness reports Complete.
12. **Given** candidate generation fails or candidate state is malformed, **When** NFR readiness is requested, **Then** readiness reports Blocked.
13. **Given** one or more NFR candidates remain undecided, **When** Review Complete is invoked, **Then** Review Complete fails and no NFR artifact is created.
14. **Given** acceptance of a candidate would create a duplicate NFR, **When** NFR creation is attempted, **Then** creation fails, no identifier is allocated, and all existing bytes remain unchanged.
15. **Given** one or more NFR candidates remain undecided, **When** Cancel Review is invoked, **Then** the review terminates and no NFR, catalog, or relationship artifact is written.
16. **Given** multiple approved Controls generate candidates, **When** candidate generation completes, **Then** candidate ordering is based on persisted Control identifiers and derivation rule order.

### Edge Cases

- The profile or objective prerequisite is missing or blocked when Control setup is requested.
- A category receives blank input, whitespace-only input, or case variants of `none`.
- The user answers an unsupported value to the add-another question.
- The user cancels or abandons Control collection before all categories complete.
- A proposal has no usable title or statement after Modify or Replace.
- The review contains duplicate proposals or multiple decisions for the same proposal.
- Control catalog allocation, artifact creation, validation, or catalog regeneration fails.
- A valid Control produces no candidate, or one Control produces multiple candidates in fixed rule order.
- Candidate state is missing, malformed, contradictory, or contains a candidate without an originating Control.
- The user rejects some candidates and cancels before deciding on the remainder.
- An accepted candidate would duplicate an existing NFR or reuse an identifier.
- Direct NFR authoring occurs without any Control baseline.
- Readiness is requested when a Control baseline is malformed rather than absent.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Control workflow MUST support `setup` and `configure` as aliases for the guided Control setup workflow.
- **FR-002**: The Control workflow MUST retain `readiness`, `view`, `show`, `describe`, `add`, `update`, `remove`, and `set` as supported actions.
- **FR-003**: Guided Control setup MUST process Security Controls, Availability and Resilience Controls, Operational Controls, and Compliance and Governance Controls in that fixed order.
- **FR-004**: Guided Control setup MUST request one Control at a time for the active category.
- **FR-004a**: Guided Control setup MUST generate an initial Proposed Title from each submitted Control statement.
- **FR-004c**: The generated Proposed Title is advisory and MAY be modified or replaced during review.
- **FR-004d**: The Control statement remains authoritative during collection.
- **FR-004e**: The approved title used for persistence MUST be the review-approved title.
- **FR-004f**: Generated Proposed Titles MUST NOT be persisted before review approval.
- **FR-004g**: Only the review-approved title may appear in a persisted Control artifact.
- **FR-005**: After each recorded Control, the workflow MUST ask whether another Control should be added to the active category.
- **FR-006**: A case-insensitive `none` as the first category response MUST complete that category without creating a proposal.
- **FR-007**: Collection MUST allocate no identifiers and write no Control, catalog, relationship, or candidate artifacts before Control review is complete.
- **FR-007a**: Cancellation during Control collection MUST discard all in-memory proposals.
- **FR-007b**: Cancellation during Control collection MUST write no Control, catalog, relationship, or candidate artifact.
- **FR-007c**: Cancellation during Control collection MUST preserve all existing bytes.
- **FR-008**: The Control review MUST display Category, Proposed Title, and Statement for every proposal.
- **FR-009**: Control review MUST offer Accept, Modify, Replace, and Remove decisions for every proposal.
- **FR-009a**: Duplicate proposed Controls MUST be detected and displayed as advisory review information.
- **FR-009b**: Duplicate proposed Controls MUST remain individually reviewable.
- **FR-009c**: Duplicate detection MUST NOT prevent review completion.
- **FR-010**: Accepted, modified, or replaced proposals MUST allocate identifiers and create Control artifacts only after Review Complete is invoked.
- **FR-010a**: Control review MUST allow the user to edit or replace the generated Proposed Title before acceptance.
- **FR-010b**: Control Review MUST support a Review Complete action.
- **FR-010c**: Control identifiers MUST NOT be allocated until Review Complete is invoked.
- **FR-010d**: Accepted Control proposals MUST be written in a single transaction after Review Complete.
- **FR-010e**: Control Review MUST support Cancel Review.
- **FR-010f**: Cancel Review MUST preserve all proposal, Control, catalog, relationship, and candidate bytes.
- **FR-010g**: Every proposed Control MUST have exactly one final decision before Review Complete succeeds.
- **FR-010h**: Review Complete MUST fail when one or more proposed Controls remain undecided.
- **FR-010i**: Successful Control Review Complete MUST either persist the entire approved Control set or persist none of it.
- **FR-010j**: Cancel Review MUST terminate Control Review without requiring proposal decisions.
- **FR-010k**: Review-completeness requirements apply only when Review Complete is invoked.
- **FR-011**: Control review MUST create no artifact for a removed proposal.
- **FR-012**: A successful Control review MUST update the Control catalog and run existing Control validation before reporting success.
- **FR-013**: Control-derived candidate generation MUST occur only after Control Review completes successfully and MUST remain one-way from Control to candidate NFR.
- **FR-013a**: Candidate generation MUST evaluate the final approved Control set.
- **FR-013b**: No candidate generation may occur during Control collection or during active review.
- **FR-014**: Candidate generation MUST use only the approved Control title and statement and MUST produce candidates in fixed availability, security, and performance rule order.
- **FR-015**: Every candidate MUST include Candidate Title, Candidate Statement, Candidate Rationale, Originating Control identifier, and Originating Control title.
- **FR-015a**: Candidate ordering MUST be determined first by originating Control identifier and then by derivation rule order.
- **FR-015b**: Derivation rule order MUST be availability, security, performance.
- **FR-015c**: Candidate ordering MUST use originating Control identifiers allocated during successful Control Review Complete.
- **FR-016**: A valid Control with no matching derivation rule MUST remain valid and produce zero candidates.
- **FR-017**: The NFR workflow MUST support `review` and `onboarding` as aliases for Control-derived NFR candidate review.
- **FR-018**: The NFR workflow MUST retain `readiness`, `inspect`, `add`, `update`, `remove`, and `set` as supported actions.
- **FR-019**: The NFR workflow MUST NOT expose `setup` or `configure` as NFR onboarding actions.
- **FR-020**: NFR candidate review MUST display Candidate Title, Candidate Statement, Candidate Rationale, and Originating Control for each candidate.
- **FR-021**: NFR candidate review MUST offer Accept, Modify, Replace, Reject, and Cancel decisions.
- **FR-022**: Accept, Modify, and Replace MUST create an NFR only with approved title, statement, and rationale and MUST preserve the originating Control relationship.
- **FR-022a**: Existing NFR duplication MUST be detected before NFR creation.
- **FR-022b**: Duplicate candidate acceptance MUST fail safely and preserve all existing bytes.
- **FR-022c**: Duplicate candidate detection MUST occur before identifier allocation.
- **FR-023**: Reject MUST create no NFR artifact, catalog entry, or relationship.
- **FR-024**: Cancel MUST preserve all candidate, NFR, catalog, and relationship bytes.
- **FR-024a**: NFR Review MUST support Review Complete.
- **FR-024b**: Accepted NFR candidates MUST be written in a single transaction after Review Complete.
- **FR-024c**: NFR Review MUST support Cancel Review.
- **FR-024d**: Cancel Review MUST preserve all candidate, NFR, catalog, and relationship bytes.
- **FR-024e**: Every NFR candidate MUST have exactly one final decision before Review Complete succeeds.
- **FR-024f**: Review Complete MUST fail when one or more NFR candidates remain undecided.
- **FR-024g**: Successful NFR Review Complete MUST either persist the entire approved NFR set or persist none of it.
- **FR-024h**: Cancel Review MUST terminate NFR Review without requiring candidate decisions.
- **FR-024i**: Review-completeness requirements apply only when Review Complete is invoked.
- **FR-025**: Direct NFR authoring MUST remain supported with an empty Control relationship when no derived Control relationship applies.
- **FR-026**: Control readiness with no Control baseline MUST emit exactly four ordered fields: `Status: Missing`, a no-baseline summary, `Next Action: /highway-controls setup`, and `Blocking Reason: None`.
- **FR-027**: Control readiness MUST distinguish an absent baseline from a malformed or inconsistent baseline and MUST report the latter as blocked with a non-empty reason.
- **FR-027a**: Candidate generation succeeded and accepted NFRs do not exist MUST report NFR readiness as In Progress.
- **FR-027b**: Candidate generation succeeded with zero candidates and no accepted NFRs MUST report Not Applicable.
- **FR-027c**: Accepted NFR artifacts MUST report Complete.
- **FR-027d**: Candidate-generation failures or malformed candidate state MUST report Blocked.
- **FR-028**: Any failed allocation, validation, catalog update, artifact write, or relationship update MUST preserve all pre-operation bytes.
- **FR-029**: Control setup, review, candidate generation, NFR review, and readiness outputs MUST use deterministic ordering and must not use timestamps, randomness, or session state.
- **FR-030**: The onboarding workflow MUST preserve the existing ownership sequence: Profile Setup and Objective Setup precede Control Setup; Control-derived candidates precede optional NFR review; direct NFR authoring remains independent.
- **FR-030a**: Control setup MUST detect an existing Control baseline.
- **FR-030b**: When a valid Control baseline exists, setup MUST NOT create a second onboarding baseline.
- **FR-030c**: The workflow MUST direct users to add, update, remove, or view Controls using existing Control management actions.
- **FR-030d**: Control setup MUST NOT enter collection mode when a valid Control baseline exists.
- **FR-030e**: Control setup MUST NOT create onboarding proposal state when a valid Control baseline exists.

The specification does not require a specific title-generation algorithm. Implementations MAY improve title quality without changing onboarding behavior.

### Key Entities

- **Control Setup Category**: One of the four fixed collection categories, with ordered proposed Controls.
- **Proposed Control**: User-provided category and statement with a generated Proposed Title awaiting review; it has no identifier before acceptance.
- **Control Review Decision**: Accept, Modify, Replace, or Remove decision applied to one proposed Control.
- **Control Baseline**: Accepted identified Control artifacts and their authoritative catalog.
- **Control-Derived NFR Candidate**: A deterministic proposal containing title, statement, rationale, and originating Control identity.
- **NFR Review Decision**: Accept, Modify, Replace, Reject, or Cancel decision applied to candidates.
- **NFR Baseline**: Accepted NFR artifacts, including direct NFRs with an empty Control relationship.
- **Readiness Result**: Four ordered fields describing whether the relevant governance baseline can proceed and the next owner action.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of guided Control setup runs present the four categories in the specified order.
- **SC-002**: 100% of collection fixtures allocate no identifier and change no governed artifact before review completion.
- **SC-003**: 100% of accepted Control review decisions create exactly one corresponding Control artifact and catalog entry.
- **SC-004**: 100% of removed Control proposals create no Control artifact or candidate.
- **SC-005**: 100% of candidate fixtures preserve originating Control identifier and title through candidate review.
- **SC-006**: 100% of valid Controls without matching derivation rules remain valid and produce zero candidates.
- **SC-007**: 100% of NFR review cancellations and rejections leave NFR, catalog, candidate, and relationship bytes unchanged.
- **SC-008**: 100% of accepted, modified, or replaced candidates preserve the originating Control relationship.
- **SC-009**: 100% of direct NFR fixtures remain valid with an empty Control relationship.
- **SC-010**: 100% of missing-Control readiness responses contain the four required fields in the required order and route to `/highway-controls setup`.
- **SC-011**: 100% of malformed or inconsistent Control baselines are distinguished from missing baselines and reported as blocked with a reason.
- **SC-012**: 100% of failure-path fixtures preserve every pre-operation byte and create no partial governance artifact.
- **SC-013**: Focused Control, NFR, readiness, candidate, and generated-artifact tests pass with zero failures, followed by the full repository suite.
- **SC-014**: Reviewers can identify the owner, decision options, write boundary, and relationship direction for every onboarding stage from the canonical skill contracts.
- **SC-015**: 100% of Control Review Complete fixtures either persist the entire approved Control set or persist nothing.
- **SC-016**: 100% of NFR Review Complete fixtures either persist the entire approved NFR set or persist nothing.
- **SC-017**: 100% of failed Control Review Complete operations create no partial Control artifacts.
- **SC-018**: 100% of failed NFR Review Complete operations create no partial NFR artifacts.

## Assumptions

- Profile Setup and Objective Setup already exist and remain prerequisites; Feature 077 does not redefine their workflows.
- `setup` and `configure` are aliases with identical Control behavior, while `review` and `onboarding` are aliases with identical NFR candidate-review behavior.
- `none` is case-insensitive and is recognized only as the first response for a category.
- Existing Control and NFR record templates, catalogs, validation, identifier formats, and relationship conventions remain authoritative.
- Candidate derivation remains the existing one-way Control-owned process; this feature adds its onboarding review surface without reverse-generating Controls.
- Empty categories, rejected proposals, rejected candidates, and cancelled reviews are valid outcomes and do not require placeholder artifacts.
- Existing direct NFR actions remain available even when no Control baseline exists.
- User-owned governance records remain outside `.highway` at the established root-level governance paths.
- Accepted feature behavior supersedes legacy onboarding behavior when conflicts exist.
