# Feature Specification: Highway Setup Wizard

**Feature Branch**: `081-highway-setup-wizard`

**Created**: 2026-09-23

**Status**: Draft

**Input**: User description: "Create a new spec for converting highway-setup from a passive readiness dashboard into an active onboarding wizard that guides Profile, Objectives, Controls, and NFR setup through owner workflows while preserving ownership boundaries."

## Clarifications

### Session 2026-09-23

- Q: When `/highway-setup` is interrupted, should it resume only from persisted owner readiness, or also preserve the exact unanswered wizard question and response context? → A: Resume from persisted owner readiness only; re-derive the first incomplete stage and do not persist an exact wizard checkpoint.
- Q: When the user explicitly pauses or cancels an active owner workflow, should Setup end without additional wizard state and resume that same first incomplete owner on the next invocation? → A: End without additional wizard state; the next invocation re-reads owner readiness and resumes the first incomplete owner.
- Q: Should Setup present each owner’s question and example verbatim, or may it summarize them while preserving the owner’s meaning? → A: Present owner questions and examples verbatim, with only Setup-owned progress context added around them.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Complete Setup Through One Guided Entry Point (Priority: P1)

As a new Highway user, I want `/highway-setup` to guide me through each incomplete governance area so that I can complete initial repository setup without manually invoking downstream owner workflows.

**Why this priority**: The central problem is fragmented onboarding. A single guided entry point must replace the current report-and-stop behavior.

**Independent Test**: Start with each owner area incomplete, provide the owner workflow's required responses, and verify Setup asks the next owner-required question, invokes the owner, reassesses completion, and advances through Profile, Objectives, Controls, and NFRs without a second user command.

**Acceptance Scenarios**:

1. **Given** Profile is incomplete, **when** the user invokes `/highway-setup`, **then** Setup enters guided setup mode and presents the next Profile owner question with its owner-provided example.
2. **Given** an owner asks for another response, **when** the user answers, **then** Setup forwards the response to that owner and continues collection until the owner reports `Status: Complete` or `Status: Not Applicable`.
3. **Given** an owner reports completion, **when** Setup receives that result, **then** it automatically begins the next incomplete stage without requiring the user to invoke another command.
4. **Given** all four areas reach terminal success, **when** Setup finishes, **then** it emits the completion message and existing administration dashboard.

### User Story 2 - Owner Workflows Retain Artifact Authority (Priority: P1)

As a governance owner, I want the wizard to collect and route responses without creating governance artifacts itself so that Profile, Objective, Control, and NFR ownership remains unambiguous.

**Why this priority**: Active orchestration must not recreate the ownership drift that earlier setup work corrected.

**Independent Test**: Run wizard scenarios through all four stages and inspect owner calls, artifacts, catalogs, identifiers, relationships, and proposal state to verify only the owning workflow performs mutations.

**Acceptance Scenarios**:

1. **Given** the wizard is collecting Profile information, **when** a response is submitted, **then** Setup forwards it to `/highway-profile` and does not write the Profile artifact.
2. **Given** Objectives, Controls, or NFRs are active, **when** the owner workflow produces a proposal or accepted result, **then** Setup presents the owner output and does not directly create, update, remove, or replace owner artifacts.
3. **Given** a user declines, cancels, or an owner rejects a proposal, **when** the owner reports the outcome, **then** Setup preserves owner-controlled bytes and stops or pauses without fabricating completion.

### User Story 3 - Users Can See and Resume Wizard Progress (Priority: P1)

As a user completing setup over multiple turns, I want explicit stage and activity progress and reliable resume behavior so that interruption does not restart or lose my place.

**Why this priority**: A multi-turn wizard is only useful if the current action is obvious and the next invocation resumes at the first incomplete owner.

**Independent Test**: Interrupt setup at each stage, invoke `/highway-setup` again, and verify it reports the first incomplete owner, preserves completed stages, identifies the owner-defined current activity, and asks only the next unresolved question.

**Acceptance Scenarios**:

1. **Given** Profile and Objectives are complete and Controls is in progress, **when** the user invokes `/highway-setup`, **then** Setup resumes Controls rather than restarting Profile or Objectives.
2. **Given** a collection stage is active, **when** Setup emits progress, **then** it identifies the step number, stage, completed stages, current stage, remaining stages, and current owner-defined activity.
3. **Given** a collection stage has multiple unresolved prompts, **when** Setup asks for input, **then** it asks exactly one unresolved question and waits for the response before presenting another.
4. **Given** an owner has no applicable work, **when** it reports `Status: Not Applicable`, **then** Setup records that stage as terminally successful and advances to the next stage.

### User Story 4 - Wizard Failures Remain Deterministic and Actionable (Priority: P2)

As a maintainer, I want malformed, blocked, declined, and incomplete owner outcomes handled explicitly so that the wizard never skips governance work or falsely reports completion.

**Why this priority**: Orchestration errors can create incomplete or misleading governance baselines, so failure behavior must be as explicit as success behavior.

**Independent Test**: Feed Setup malformed, blocked, declined, pending, and incomplete owner responses and verify deterministic pause/stop output, no downstream advance, preserved owner state, and actionable owner-provided blocking information.

**Acceptance Scenarios**:

1. **Given** an owner response is malformed or has an unknown status, **when** Setup processes it, **then** Setup reports `Setup: Blocked`, identifies the response-shape failure, and does not assume completion.
2. **Given** an owner reports `Blocked`, **when** Setup processes it, **then** Setup pauses at that owner, presents the owner-provided `Blocking Reason` and `Next Action`, and does not invoke later owners.
3. **Given** an owner reports `In Progress`, **when** Setup processes it, **then** Setup remains in wizard mode at that stage and does not emit the completion dashboard.
4. **Given** an owner declines or aborts collection, **when** Setup receives that outcome, **then** Setup reports the incomplete stage and preserves the owner workflow's no-write guarantee.

## Edge Cases

- A repository with all four baselines already complete must retain the existing completion dashboard and must not start collection prompts.
- Profile, Objectives, Controls, and NFRs may complete or be not applicable only through the owner-defined response contract; Setup must not infer completion from partial artifacts.
- NFR `Not Applicable` remains terminal success only for the existing successful zero-candidate condition; unavailable, malformed, contradictory, pending, or unaccepted candidates do not become complete.
- A user may stop responding between questions; resume must identify the first incomplete owner and preserve completed stages.
- An explicit pause or cancellation ends the current Setup interaction without a cancellation marker or wizard checkpoint; the next invocation resumes the first incomplete owner from persisted owner readiness.
- A response may contain owner output plus a next question; Setup must present the output and next question without rewriting owner terminology.
- Setup may add progress context around an owner question, but must not summarize, replace, or otherwise rewrite the owner-provided question or example.
- A downstream owner must not be invoked when an earlier owner is blocked, declined, malformed, or still incomplete.
- A user request to directly mutate a Profile, Objective, Control, or NFR remains routed to the owning skill rather than handled by Setup.
- A wizard progress message must not expose internal implementation details unless the user requests an implementation explanation.
- A long-running collection stage must identify current activity; a stage with no long-running activity may report X2.5 and X2.6 as N/A under the existing N5 condition.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `/highway-setup` MUST assess readiness in the fixed order Profile, Objectives, Controls, and NFRs before entering or resuming guided setup.
- **FR-002**: When the first owner area is incomplete, `/highway-setup` MUST enter guided setup mode instead of stopping after a readiness dashboard.
- **FR-003**: Guided setup MUST route each owner-required question and user response through the owning workflow and MUST present the owner's question, example, and output verbatim, adding only Setup-owned progress context around that content.
- **FR-004**: Setup MUST continue a stage until terminal success, user interruption, or an owner non-terminal stop condition; Setup MUST advance only after the owner reports `Status: Complete` or applicable `Status: Not Applicable`.
- **FR-005**: Setup MUST automatically advance to the next owner stage after terminal success without requiring another `/highway-setup` invocation.
- **FR-006**: Setup MUST define and expose `Current Stage` with exactly these values: `Profile`, `Objectives`, `Controls`, `NFRs`, or `Complete`.
- **FR-007**: Setup MUST expose `Current Activity` using the active owner's activity or next-action contract.
- **FR-008**: During collection, Setup MUST ask exactly one unresolved question at a time and MUST wait for the corresponding response before presenting the next unresolved question.
- **FR-009**: Progress output MUST identify the wizard step, stage, completed stages, current stage, and remaining stages, with wording that emphasizes the user's next required action.
- **FR-009A**: Wizard step numbers MUST correspond to setup stages as follows:
	1. Profile
	2. Objectives
	3. Controls
	4. NFRs
- **FR-010**: On a new `/highway-setup` invocation after interruption, Setup MUST re-read persisted owner readiness, resume at the first incomplete owner, preserve completed owner stages, and re-ask that owner's next unresolved question rather than restoring an exact Setup checkpoint.
- **FR-011**: Setup MUST NOT directly create, update, remove, replace, allocate identifiers for, regenerate catalogs for, or repair relationships among Profile, Objective, Control, or NFR artifacts.
- **FR-012**: Setup MUST preserve each owner's existing proposal, confirmation, cancellation, rejection, duplicate, validation, and no-write semantics by invoking the owner workflow rather than reproducing them.
- **FR-013**: Setup MUST treat owner `Complete` and applicable owner `Not Applicable` responses as terminal success, and MUST treat `Missing`, `In Progress`, `Blocked`, declined, aborted, malformed, and unknown outcomes as non-terminal unless the owner contract explicitly states otherwise.
- **FR-013A**: Setup MUST classify owner responses as terminal or non-terminal using the following explicit decision table:

	| Owner response | Classification | Setup behavior |
	|---|---|---|
	| `Complete` | Terminal success | Mark the stage complete and advance to the next stage. |
	| Applicable `Not Applicable` | Terminal success | Mark the stage not applicable and advance to the next stage. |
	| `Missing` or `In Progress` | Non-terminal | Remain at the stage and present the owner's next action or question. |
	| `Blocked` | Non-terminal | Pause at the stage and present the owner's blocking reason and next action. |
	| Declined or aborted | Non-terminal | End or pause Setup without advancing or fabricating completion. |
	| Malformed or unknown | Non-terminal | Mark Setup blocked, identify the response-shape failure, and do not invoke downstream owners. |
- **FR-014**: Setup MUST stop or pause at the first non-terminal owner and MUST NOT invoke downstream owners until the active owner reaches terminal success.
- **FR-015**: Setup MUST emit `Highway Setup Complete` before the existing administration dashboard when all owner stages are terminally successful.
- **FR-016**: Setup MUST preserve the existing administration dashboard's fields, ownership routes, ordering, and availability after wizard completion.
- **FR-017**: Setup MUST produce deterministic, actionable output for malformed or blocked owner responses, including the owner, blocking reason, and next action where supplied.
- **FR-018**: Focused validation MUST verify that wizard mode never requires manual downstream invocation, advances automatically, resumes at the first incomplete owner, asks one question at a time, reports completed/current/remaining stages, preserves owner authority, and retains the completion dashboard.
- **FR-019**: The wizard MUST preserve the existing X2 interaction obligations, including next-action prioritization, one-question-at-a-time collection, activity-focused progress, and N5 handling where no long-running activity exists.
- **FR-020**: The Experience Standard version impact of this behavioral expansion MUST be recorded as MAJOR, changing `/highway-setup` from readiness reporting and stopping to active guided orchestration.
- **FR-021**: When the user explicitly pauses or cancels an active owner workflow, Setup MUST end the current interaction without creating a cancellation marker or wizard checkpoint, and the next invocation MUST resume the first incomplete owner from persisted owner readiness.

### Key Entities *(include if feature involves data)*

- **Setup Wizard State**: The current in-session setup conversation state containing `Current Stage`, `Current Activity`, completed stages, remaining stages, and the active owner outcome; it is not an independently persisted wizard checkpoint.
- **Owner Workflow Response**: The owner-provided question, example, status, summary, next action, blocking reason, and output used by Setup without redefining owner semantics.
- **Setup Stage**: One of Profile, Objectives, Controls, NFRs, or Complete, evaluated in fixed order.
- **Setup Progress Report**: A user-facing report identifying step, stage, completed stages, current stage, remaining stages, and next action.
- **Completion Dashboard**: The existing terminal administration dashboard emitted after all owner stages reach terminal success.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of valid incomplete-owner scenarios, one `/highway-setup` conversation can reach the next owner stage without requiring the user to manually invoke a downstream owner command.
- **SC-002**: In 100% of multi-turn collection scenarios, Setup emits no more than one unresolved collection question per turn.
- **SC-003**: In 100% of interruption scenarios, resuming `/highway-setup` starts at the first incomplete owner and preserves every completed stage.
- **SC-004**: In 100% of owner mutation scenarios, only the owner workflow changes its governed artifacts, catalogs, identifiers, proposals, or relationships.
- **SC-005**: In 100% of terminal-success scenarios, Setup advances through all applicable stages and emits `Highway Setup Complete` followed by the unchanged administration dashboard.
- **SC-006**: In 100% of blocked, declined, malformed, or incomplete scenarios, Setup does not invoke downstream owners or report setup completion.
- **SC-007**: Focused executable validation covers all seven requested verification criteria: no manual downstream invocation, automatic advancement, first-incomplete resume, one-question collection, completed/current/remaining progress, preserved ownership, and completion dashboard availability.
- **SC-008**: The wizard's user-facing progress is consistent with the applicable X2 rules, and no new verdict vocabulary, owner namespace, or artifact ownership boundary is introduced.
- **SC-009**: 100% of owner questions and examples presented by Setup are byte-identical to the owner workflow output except for Setup-owned progress framing.

## Assumptions

- The existing readiness response contracts and guided collection behavior of `highway-profile`, `highway-objectives`, `highway-controls`, and `highway-nfrs` remain authoritative.
- `Status: Complete` and `Status: Not Applicable` are the only terminal owner statuses for wizard advancement unless an owner contract is explicitly amended in the same feature.
- Setup conversation state is available for the duration of the interaction. A later invocation re-reads persisted owner readiness to find the first incomplete stage and does not restore an exact unanswered question or create a competing wizard checkpoint store.
- Existing owner workflows remain independently invokable for direct administration outside wizard mode.
- Existing completion dashboard content remains the terminal administration view and is not replaced by the wizard progress view.
- The version impact is MAJOR because the user-facing behavior and completion contract expand materially.
- No user-owned governance artifact or distribution-manifest classification needs to change.

## Out of Scope

- Reassigning ownership of Profile, Objective, Control, NFR, catalog, identifier, candidate, or relationship artifacts.
- Rewriting the internal governance rules or collection questionnaires owned by the four downstream skills.
- Adding a second persistent Setup artifact store that competes with owner state.
- Changing the existing owner readiness vocabulary or NFR zero-candidate semantics.
- Replacing the existing completion administration dashboard.
- Adding live semantic conversation classification beyond the explicit wizard interaction contract.
- Changing the distribution manifest or packaging classification.
