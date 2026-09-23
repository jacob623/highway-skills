# Feature Specification: Setup Wizard Contract Hardening

**Feature Branch**: `082-setup-wizard-contract-hardening`

**Created**: 2026-09-23

**Status**: Draft

**Input**: User description: Clarify and harden the Highway Setup Wizard contract by correcting automatic advancement wording, explicitly verifying verbatim owner output preservation, defining terminal completion progress, tightening resume and persistence boundaries, specifying multi-message owner output ordering, distinguishing user exits from owner outcomes, expanding ownership verification, and replacing the remaining legacy readiness stop wording.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Understand Terminal Progress (Priority: P1)

As a repository administrator, I want Setup progress to have one unambiguous meaning at every stage, including completion, so that different implementations and reviewers produce consistent reports.

**Why this priority**: Ambiguous completion progress can cause contradictory user interfaces and incorrect automation at the final stage.

**Independent Test**: Review the progress contract and exercise incomplete and complete Setup states; confirm the defined step-to-stage mapping and completion behavior are explicit and consistent.

**Acceptance Scenarios**:

1. **Given** Setup is advancing after a terminal owner result, **When** the next stage is selected, **Then** the contract uses the corrected automatic-advancement wording and retains the fixed Profile, Objectives, Controls, and NFR order.
2. **Given** all applicable owners are terminally successful, **When** Setup reports completion, **Then** the contract explicitly states whether a numeric step is emitted and uses that rule consistently.
3. **Given** the first owner that is not terminally successful is identified, **When** Setup evaluates readiness, **Then** it enters Guided Setup rather than describing the old readiness-only stop behavior.
4. **Given** `Current Stage` is `Complete`, **When** Setup reports completion, **Then** `Step` is absent.

### User Story 2 - Preserve Owner Meaning and Ownership (Priority: P1)

As an owner workflow author, I want Setup to preserve my questions, examples, informational output, and mutation authority so that orchestration cannot change owner meaning or govern owner artifacts.

**Why this priority**: Verbatim content and owner authority are core safety boundaries of the Setup Wizard.

**Independent Test**: Provide owner output containing informational content and a question, then inspect Setup output and mutation evidence; confirm ordering, byte identity, and owner-only mutation.

**Acceptance Scenarios**:

1. **Given** an owner response contains informational output followed by a next question, **When** Setup presents the response, **Then** it presents the owner output first and the owner question second without reordering or rewriting owner content.
2. **Given** an owner question and example are presented by Setup, **When** their output is compared with the owner workflow output, **Then** they are byte-identical except for Setup-owned progress framing.
3. **Given** Setup routes collection or a proposal, **When** governed state changes are needed, **Then** all mutations originate from the owning workflow and Setup never allocates identifiers, writes catalogs, or writes owner artifacts.

### User Story 3 - Resume Without Hidden Wizard State (Priority: P1)

As a user who pauses or stops responding, I want a later Setup invocation to use authoritative readiness without restoring hidden conversation state, so that resume behavior is deterministic and inspectable.

**Why this priority**: Hidden checkpoints or draft state could conflict with owner artifacts and make cancellation behavior unpredictable.

**Independent Test**: Interrupt Setup at each stage, inspect persisted state, and invoke Setup again; confirm only persisted owner readiness determines the first incomplete owner and no wizard-specific state is restored.

**Acceptance Scenarios**:

1. **Given** a user pauses, cancels, or stops responding during collection, **When** Setup ends the interaction, **Then** it persists no owner collection state, unanswered question, draft response, cancellation marker, or wizard checkpoint.
2. **Given** one or more owners are complete and a later owner is incomplete, **When** Setup is invoked again, **Then** it resumes at the first incomplete owner and preserves the completed stages.
3. **Given** an owner returns `declined`, `aborted`, or `blocked`, **When** Setup reports the outcome, **Then** it identifies it as an owner interruption/outcome rather than a user pause or cancellation.

### Edge Cases

- An owner response contains both explanatory output and a next unresolved question; Setup must preserve the owner-defined order and content.
- Setup reaches `Current Stage: Complete`; the contract must state whether a numeric step is omitted or retained.
- A user pauses or cancels while an owner reports `In Progress`; Setup must not convert that state into owner completion.
- An owner returns `declined`, `aborted`, or `blocked`; Setup must not label the result as user interruption.
- A reviewer checks mutation ownership; identifier, catalog, owner-artifact, candidate, and relationship changes must remain attributable to owner workflows.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Setup documentation MUST state that after each terminal owner result, Guided Setup automatically advances to the next owner stage in the fixed Profile, Objectives, Controls, and NFR order.
- **FR-002**: Setup documentation MUST require verification that owner questions and examples are emitted byte-identically to owner workflow output except for Setup-owned progress framing.
- **FR-003**: Setup documentation MUST define the numeric-step behavior when `Current Stage` is `Complete` by explicitly stating that no numeric step is emitted at completion.
- **FR-004**: Setup documentation MUST state that Guided Setup never persists owner collection state, unanswered questions, draft responses, cancellation markers, or wizard checkpoints.
- **FR-005**: When an owner response includes informational output and a next question, Setup MUST present the owner output first and the owner question afterward without reordering or rewriting owner content.
- **FR-006**: Setup documentation MUST distinguish user interruption terms (`pause`, `cancel`, and `stop responding`) from owner outcomes (`declined`, `aborted`, and `blocked`).
- **FR-006A**: Setup documentation MUST contain a deterministic classification table that separately identifies User Exits and Owner Outcomes.
- **FR-007**: Setup verification MUST confirm that Setup never allocates identifiers, writes catalogs, writes owner artifacts, writes candidate state, or writes relationship state, and that all governed mutations originate from the owning workflow.
- **FR-008**: The ordered readiness rules MUST direct Setup to enter Guided Setup at the first non-terminal owner and continue according to the Guided Setup workflow, rather than instructing it to stop at the first non-complete owner.
- **FR-009**: The contract MUST preserve the existing completion dashboard and fixed owner-stage order while adding the clarifications in this feature.
- **FR-010**: Each clarified rule MUST be stated in language that can be checked by static review or an executable fixture without relying on an unstated implementation detail.

### Verification

- Confirm an owner response containing informational output and a next question renders the informational output before the next question.
- Confirm owner output ordering is preserved without Setup reordering content.
- Confirm Setup never allocates identifiers, writes catalogs, writes owner artifacts, writes candidate state, or writes relationship state.
- Confirm all governed mutations originate from the owning workflow.

The contract MUST include a deterministic classification table with separate rows or sections for these User Exits: `pause`, `cancel`, and `stop responding`; and these Owner Outcomes: `declined`, `aborted`, and `blocked`.

### Key Entities *(include if data involved)*

- **Setup Progress Report**: The user-facing progress record containing stage, completed stages, current stage, remaining stages, and current activity; it has no independently persisted wizard state.
- **Owner Response**: The response supplied by Profile, Objectives, Controls, or NFRs, including informational output, questions, examples, status, next action, and blocking reason.
- **Owner Mutation**: A governed change to an owner artifact, identifier, catalog, candidate, or relationship that may be performed only by the owning workflow.
- **User Exit**: A user-initiated pause, cancellation, or decision to stop responding that ends the current interaction without creating wizard state.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of contract reviews identify one unambiguous rule for numeric step behavior when `Current Stage` is `Complete`.
- **SC-002**: 100% of owner-question and owner-example verification fixtures preserve the owner bytes exactly, excluding only Setup-owned progress framing.
- **SC-003**: 100% of interruption and resume fixtures show no persisted owner collection state, unanswered question, draft response, cancellation marker, or wizard checkpoint.
- **SC-004**: 100% of multi-message owner-response fixtures present informational owner output before the next owner question without content changes.
- **SC-005**: 100% of ownership verification fixtures show no Setup-created identifier, catalog, or owner-artifact mutation.
- **SC-006**: Reviewers can distinguish user exits from owner outcomes in every documented pause, cancellation, decline, abort, and blocked scenario without relying on contextual inference.
- **SC-007**: The existing Setup completion dashboard and four-stage order remain unchanged in all regression scenarios.
- **SC-008**: 100% of first-incomplete-owner scenarios enter Guided Setup rather than terminating after readiness reporting.

## Assumptions

- Feature 081 remains the authoritative baseline for the Highway Setup Wizard behavior and dashboard.
- The four owner workflows remain the authorities for owner questions, examples, statuses, mutation rules, and artifact semantics.
- Persisted owner readiness is available for resume decisions; no new Setup persistence store is introduced.
- The repository continues to require Bash 3.2-compatible validation fixtures and static contract checks.
- The feature changes contract clarity and verification expectations; unrelated Setup behavior remains out of scope.
