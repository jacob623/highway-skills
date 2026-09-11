# Feature Specification: Highway Setup Orchestration

**Feature Branch**: `033-highway-setup-orchestration`

**Created**: 2026-09-10

**Status**: Draft

**Input**: User description: "Create a new Highway skill named `highway-setup` that orchestrates the initial repository setup by evaluating Profile, Business Objectives, Controls, and NFRs in order, invoking the owning workflows for missing artifacts, continuing until setup is complete, and displaying status and ownership guidance."

## Clarifications

### Session 2026-09-10

- Q: When Controls exist but the NFR baseline is missing, should `highway-setup` pause after the Control-owned NFR proposal until the author accepts it, or should it continue automatically through NFR authoring? → A: Pause after the proposal and resume only after author acceptance.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Assess setup readiness in governance order (Priority: P1)

As a new Highway user, I want one entry point to assess my repository setup so that I know which foundational governance area needs attention first.

**Why this priority**: Ordered readiness assessment is the foundation for every subsequent setup action and prevents users from entering downstream workflows without required context.

**Independent Test**: Run setup against isolated repositories representing each readiness state and verify Profile, Business Objective, Control, and NFR statuses are evaluated in that order.

**Acceptance Scenarios**:

1. **Given** no foundational artifacts exist, **When** setup runs, **Then** it reports Profile as Missing and marks later areas Not Evaluated.
2. **Given** a valid Profile exists but no Business Objectives exist, **When** setup runs, **Then** it reports Profile Complete, Business Objectives Missing, and later areas Not Evaluated.
3. **Given** Profile and Business Objectives exist but no Controls exist, **When** setup runs, **Then** it reports Controls Missing and NFRs Not Evaluated.
4. **Given** Profile, Business Objectives, and Controls exist but no NFR proposal has started, **When** setup runs, **Then** it reports NFRs Missing; while a proposal awaits author acceptance, it reports NFRs In Progress.
5. **Given** all required setup artifacts exist, **When** setup runs, **Then** it reports all four areas Complete and does not invoke an owner workflow.

### User Story 2 - Complete missing setup through owning workflows (Priority: P1)

As a new Highway user, I want setup to run the appropriate owner workflow for each missing area and continue automatically so that I only need to invoke `/highway-setup`.

**Why this priority**: The value of the skill is orchestration, not merely status reporting; users should not need to understand internal skill routing.

**Independent Test**: Start from each incomplete readiness state, execute setup with deterministic owner-workflow outcomes, and verify the missing owner workflow runs before the next readiness check.

**Acceptance Scenarios**:

1. **Given** the Profile is missing or `organization.name` is empty, **When** setup runs, **Then** it executes the Profile setup workflow and reassesses before proceeding.
2. **Given** Profile is complete and Objectives are missing or empty, **When** setup runs, **Then** it executes the Objective setup workflow and continues to Control assessment after success.
3. **Given** Profile and Objectives are complete and Controls are missing or empty, **When** setup runs, **Then** it executes Control creation until an initial Control baseline exists.
4. **Given** Controls exist and NFRs are missing, **When** setup runs, **Then** it invokes the Control-owned NFR proposal workflow where applicable, pauses for author acceptance, and resumes only after accepted NFR artifacts exist.
5. **Given** an owner workflow completes successfully, **When** setup reassesses, **Then** it resumes at the next incomplete area rather than restarting from an earlier completed area.

### User Story 3 - Show status and completion guidance (Priority: P1)

As a Highway user, I want a consistent dashboard during and after setup so that I can see progress and learn which skill manages each governance domain.

**Why this priority**: Clear status and ownership guidance turns setup into a usable onboarding experience and reduces future routing errors.

**Independent Test**: Compare dashboard output for incomplete and complete repositories against the specified fields, ordering, and exact completion content.

**Acceptance Scenarios**:

1. **Given** setup is incomplete, **When** setup displays status, **Then** it shows Profile, Business Objectives, Controls, NFRs, Setup, and Current Activity values.
2. **Given** setup is complete before invocation, **When** setup runs, **Then** it immediately displays the completion dashboard.
3. **Given** setup becomes complete during invocation, **When** the final reassessment succeeds, **Then** it displays the same completion dashboard.
4. **Given** the completion dashboard is displayed, **Then** it identifies Profile, Business Objectives, Controls and NFRs, Help, Relationships, and Questionnaire ownership using the specified skill routes.

### User Story 4 - Preserve ownership and stop safely (Priority: P2)

As a governance owner, I want setup to delegate mutations and stop safely when an owner workflow cannot complete so that onboarding never bypasses governance ownership or silently claims success.

**Why this priority**: Setup must coordinate governance without becoming a second authoring system or creating ambiguous partial state.

**Independent Test**: Use owner workflows that decline, fail, return malformed output, or leave the baseline incomplete, then verify setup reports the blocking condition and does not write owner artifacts directly.

**Acceptance Scenarios**:

1. **Given** an owner workflow is declined or fails, **When** setup handles the result, **Then** it reports the incomplete area and stops without invoking downstream areas.
2. **Given** an owner workflow returns successfully but its required artifact remains absent or invalid, **When** setup reassesses, **Then** it reports the blocking state and does not display Setup Complete.
3. **Given** setup is run repeatedly, **When** all artifacts are already complete, **Then** it performs no owner mutation and preserves all existing artifact bytes.
4. **Given** any setup state, **When** setup runs, **Then** it does not directly create, update, remove, or replace Profile, Objective, Control, or NFR records.

### Edge Cases

- The Profile file exists but `organization.name` is empty; treat it as incomplete and invoke Profile setup.
- The Objectives directory exists but contains no objective records; treat it as missing.
- A catalog exists while its underlying artifact directory is empty or malformed; report the owning area as blocked or incomplete rather than Complete.
- Controls exist but the NFR derivation produces zero candidates; report NFR setup as incomplete or not applicable according to the owner workflow and do not fabricate an NFR.
- A Control-owned NFR proposal is declined or remains pending; report NFR setup as In Progress and do not display Setup Complete.
- An owner workflow changes only part of its baseline before failing; setup must not mask the failure or claim completion.
- The project root cannot be located; stop and request the project root without guessing a path.
- A user invokes setup after completion; display the completion dashboard without repeating setup questions.
- A downstream area must never be evaluated as Complete when an earlier prerequisite is incomplete.

### Completion Dashboard Contract

When setup is complete, the output MUST contain exactly this content and ordering:

```text
Highway Setup Status

Profile: Complete
Business Objectives: Complete
Controls: Complete
NFRs: Complete

Setup: Complete

Governance Management

Profile:
	/highway-profile

Business Objectives:
	/highway-objectives

Controls and NFRs:
	/highway-controls

Help:
	/highway-help

Advanced Administration

Relationships:
	/highway-relationships

Questionnaire:
	/highway-inquiry
```

When setup is incomplete, the output MUST contain the current status in this exact format, with the incomplete area and activity updated to match the current state:

```text
Highway Setup Status

Profile: Complete
Business Objectives: Missing
Controls: Not Evaluated
NFRs: Not Evaluated

Setup: In Progress

Current Activity:
Business Objective Setup
```

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The `highway-setup` skill MUST provide a single user-facing setup entry point.
- **FR-002**: Setup MUST evaluate Profile, Business Objectives, Controls, and NFRs in that order.
- **FR-003**: Setup MUST treat a missing Profile or empty `organization.name` as incomplete.
- **FR-004**: Setup MUST treat missing or empty Business Objective records as incomplete.
- **FR-005**: Setup MUST treat missing or empty Control records as incomplete.
- **FR-006**: Setup MUST determine whether an NFR baseline exists after Controls are complete.
- **FR-007**: Setup MUST mark later areas Not Evaluated when an earlier required area is incomplete.
- **FR-008**: Setup MUST execute the Profile owner workflow when Profile setup is incomplete.
- **FR-009**: Setup MUST execute the Business Objective owner workflow when Objective setup is incomplete.
- **FR-010**: Setup MUST execute the Control owner workflow until an initial Control baseline exists when Control setup is incomplete.
- **FR-011**: Setup MUST invoke the owner-approved Control/NFR derivation path when Controls exist but NFR setup is incomplete, pause for author acceptance of proposed NFRs, and resume only after accepted NFR artifacts exist without taking NFR ownership.
- **FR-012**: Setup MUST reassess after each successful owner workflow and continue from the next incomplete area.
- **FR-013**: Setup MUST display an incomplete dashboard using the specified in-progress format, updating each area status, overall setup status, and current activity to match the blocking step.
- **FR-014**: Setup MUST display the specified completion dashboard when all required artifacts exist before or during the current execution.
- **FR-015**: The completion dashboard MUST identify the ownership routes for Profile, Business Objectives, Controls and NFRs, Help, Relationships, and Questionnaire administration.
- **FR-016**: Setup MUST stop and report the blocking condition when a Profile, Objective, or Control owner workflow is declined, fails, malformed, or leaves its required artifact incomplete; for NFR proposals, it MUST report the pending or declined author decision and withhold Setup Complete.
- **FR-017**: Setup MUST NOT directly create, update, remove, or replace Profile, Objective, Control, or NFR artifacts.
- **FR-018**: Setup MUST preserve existing governance artifact bytes when no mutation is required and MUST NOT claim completion after an unsafe or partial owner workflow.

### Key Entities

- **Setup State**: The ordered readiness result for Profile, Business Objectives, Controls, NFRs, and overall setup.
- **Setup Dashboard**: The user-facing status and ownership output for incomplete or complete setup.
- **Owner Workflow Result**: The success, decline, failure, malformed, or incomplete outcome returned by an owning skill.
- **Foundational Artifact Set**: The Profile, Business Objective, Control, and NFR records and baselines whose presence determines readiness.
- **Ownership Route**: The skill invocation associated with managing a governance domain.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of readiness fixtures evaluate Profile, Business Objectives, Controls, and NFRs in the specified order.
- **SC-002**: 100% of missing-area fixtures invoke the correct owner workflow and continue to the next area after a successful result.
- **SC-003**: 100% of incomplete-state dashboards contain all required status fields and identify the current activity.
- **SC-004**: 100% of complete-state runs display the exact completion dashboard content and ordering specified by this feature.
- **SC-005**: 100% of declined, failed, malformed, and incomplete owner-workflow outcomes stop setup without displaying Setup Complete or invoking downstream setup.
- **SC-006**: 100% of repeated complete-state runs perform zero owner mutations and preserve existing artifact bytes.
- **SC-007**: 0 Profile, Objective, Control, or NFR artifacts are directly authored by `highway-setup`.
- **SC-008**: At least 95% of first-time setup scenarios reach the correct next owner workflow without the user manually selecting an underlying skill.

## Assumptions

- Existing owner skills remain authoritative for Profile, Business Objectives, Controls, and NFRs, including author confirmation of proposed NFRs.
- Setup determines readiness from the existing repository artifact locations and record formats defined by those owner skills.
- A complete NFR baseline means the owner workflow recognizes accepted NFR artifacts as present and valid; setup does not invent NFRs when no derivation candidate exists and does not treat a pending proposal as complete.
- Relationships, Help, and Questionnaire are administration guidance destinations, not prerequisites for initial setup completion.
- Setup output is deterministic for identical repository state and owner-workflow outcomes and contains no timestamps or random values.
- The project root is located using the repository's existing `.highway/` discovery convention.
- The exact completion dashboard in the user request is the canonical complete-state output.
