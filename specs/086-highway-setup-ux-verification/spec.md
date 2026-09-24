# Feature Specification: Highway Setup UX Verification and Output Contract Clarification

**Feature Branch**: `086-highway-setup-ux-verification`

**Created**: 2026-09-23

**Status**: Draft

**Input**: User description: "Expand highway-setup verification to cover the new UX requirements, clarify the output contract and status applicability, simplify purpose language, preserve owner informational ordering, and separate collection, status, and completion experiences."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Verify the Guided Onboarding Opening (Priority: P1)

As a person starting or resuming Highway setup, I want the verification contract to prove that onboarding begins with a greeting, owner introduction, and next question, so that the user sees onboarding rather than the workflow engine.

**Why this priority**: The opening sequence is the most visible part of the UX change and is the first place legacy orchestration language can regress.

**Independent Test**: Review the setup verification behavior for new and resumed input-required interactions and confirm the greeting, owner introduction, and owner question appear in order, with the resume greeting used after a prior interaction.

**Acceptance Scenarios**:

1. **Given** setup requires input, **when** verification evaluates the interaction, **then** it confirms a welcome or resume greeting, owner introduction, and owner question in that order.
2. **Given** setup resumes after a previous interaction, **when** the active owner requires input, **then** verification confirms a resume greeting appears before the owner question.
3. **Given** an owner provides informational context before its question, **when** setup emits the response, **then** verification confirms the context remains before the associated question.
4. **Given** owner content contains informational context and a question, **when** setup presents it, **then** verification confirms Setup does not reorder the owner-provided content.

### User Story 2 - Distinguish Collection, Status, and Completion Output (Priority: P1)

As a Highway user, I want the output contract to make clear when collection content, status content, and completion content apply, so that routine questions remain quiet while blocked or requested status remains actionable.

**Why this priority**: Ambiguous applicability causes status fields and dashboard language to leak into ordinary question collection.

**Independent Test**: Evaluate routine collection, explicit status, blocked, declined, aborted, and complete outcomes and confirm each uses only its applicable output mode.

**Acceptance Scenarios**:

1. **Given** setup is asking a routine question, **when** output is emitted, **then** it contains the active owner's next unresolved question and any applicable owner-provided informational context, but not the Explicit Status Contract.
2. **Given** status is explicitly requested or setup is blocked, declined, or aborted, **when** output is emitted, **then** it uses the Explicit Status Contract.
3. **Given** setup completes, **when** output is emitted, **then** it uses the Completion Dashboard rather than the collection or status contract.
4. **Given** the owner supplies a summary, output, blocking reason, or next action, **when** that content is emitted, **then** it appears only when supplied by the owner workflow and applicable to the outcome or request.

### User Story 3 - Verify Suppression of Workflow-Engine Narration (Priority: P1)

As a Highway user, I want verification to reject workflow-engine narration during normal collection, so that implementation details do not displace the next action I need to take.

**Why this priority**: The feature exists to remove legacy orchestration commentary, and verification must prevent that behavior from returning.

**Independent Test**: Evaluate normal collection output against the prohibited narration and explanation categories, then confirm owner-selection reasoning is allowed only after an explicit request for implementation details.

**Acceptance Scenarios**:

1. **Given** routine collection is active, **when** output is evaluated, **then** it contains none of the phrases `first incomplete stage`, `owner contract`, `workflow routing`, `forwarding response`, or `repository initialization state`.
2. **Given** routine collection is active, **when** output is evaluated, **then** it contains no readiness evaluation explanation, stage selection explanation, owner selection explanation, or orchestration commentary.
3. **Given** a user explicitly requests implementation details, **when** Setup responds, **then** owner-selection reasoning may be included for that response.
4. **Given** routine collection is active, **when** output is evaluated, **then** verification confirms that Setup describes guided onboarding and does not describe routine collection as an orchestration-first or progress-first workflow.

### Edge Cases

- Setup is complete and no owner question is required; verification must select the Completion Dashboard rather than require an opening question.
- Setup is blocked, declined, or aborted before a question is available; verification must select the Explicit Status Contract and retain actionable owner context when supplied.
- Setup resumes after a prior interaction but the first incomplete owner has changed; verification must use the resume greeting and the newly active owner's question.
- An owner supplies informational context without a question; verification must preserve the context without fabricating a question or status dashboard.
- An owner supplies a question without informational context; verification must present only the applicable question content during collection.
- A user requests status during collection; verification must select status output for that response without changing owner routing or readiness semantics.
- A user requests implementation details during collection; verification may permit the requested explanation without making it routine collection content.
- Completion output remains unchanged and must retain ownership routes and governance destinations.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Verification MUST confirm every input-required interaction begins with a welcome or resume greeting, owner introduction, and owner question in that order.
- **FR-002**: Verification MUST confirm resumed setup uses the resume greeting before the active owner introduction and unresolved question.
- **FR-003**: Verification MUST confirm owner-provided informational content appearing before a question is emitted before that question.
- **FR-004**: Verification MUST confirm Setup does not reorder owner-provided informational content relative to owner-provided questions.
- **FR-005**: Verification MUST confirm routine collection emits none of the Verification Prohibited Vocabulary.
- **FR-006**: Verification MUST confirm routine collection emits no readiness evaluation explanation, stage selection explanation, owner selection explanation, or orchestration commentary.
- **FR-007**: Verification MUST confirm owner-selection reasoning is not emitted unless the user explicitly requests implementation details.
- **FR-008**: Setup MUST describe its Purpose as guided onboarding that evaluates readiness in order, routes to the first incomplete owner workflow, and guides required setup questions until completion or a defined stop condition.
- **FR-009**: Setup MUST describe routine collection as the active owner's next unresolved question and any required owner-provided informational context.
- **FR-010**: Setup MUST state that owner questions, summaries, outputs, blocking reasons, and next actions remain owner-owned content. They are emitted only when supplied by the owner workflow and applicable to the current interaction outcome.
- **FR-011**: Setup MUST state that the Explicit Status Contract is never emitted during routine question collection.
- **FR-012**: Setup MUST state that the Explicit Status Contract applies only to explicit status requests, blocked setup, declined setup, or aborted setup, and MUST NOT be emitted during routine collection.
- **FR-013**: Setup MUST distinguish the Explicit Status Contract from the Completion Dashboard.
- **FR-015**: Setup MUST state that complete setup uses the Completion Dashboard instead of the Explicit Status Contract. Successful completion is not a status response and does not use the Explicit Status Contract.
- **FR-016**: The feature MUST preserve owner authority, owner question wording, owner content ordering, readiness order, terminality, safe-stop behavior, and completion dashboard destinations.
- **FR-017**: Verification MUST confirm completion output uses the Completion Dashboard and does not emit collection questions.

### Key Entities *(include if feature involves data)*

- **Collection Experience**: The greeting, owner introduction, next unresolved question, and applicable owner informational context shown during input-required setup.
- **Explicit Status Contract**: The status content shown only for explicit status requests, blocked setup, declined setup, aborted setup, or applicable status reporting.
- **Completion Dashboard**: The complete-state content and ownership destinations emitted after setup completion.
- **Owner Informational Context**: Summary, output, blocking reason, or next action supplied by an owner workflow and preserved in its original order.
- **Verification Prohibited Vocabulary**: The closed list of exact legacy orchestration phrases that normal collection must reject:
	- `first incomplete stage`
	- `owner contract`
	- `workflow routing`
	- `forwarding response`
	- `repository initialization state`

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of input-required verification cases confirm greeting, owner introduction, and owner question ordering.
- **SC-002**: 100% of resumed input-required verification cases confirm the resume greeting appears before the owner introduction and question.
- **SC-003**: 100% of owner responses containing informational context and a question preserve the original content order.
- **SC-004**: 0 routine collection verification cases contain any item in the Verification Prohibited Vocabulary.
- **SC-005**: 0 routine collection verification cases contain readiness, stage selection, owner selection, or orchestration explanations.
- **SC-006**: 100% of blocked, declined, aborted, and explicit-status cases select the Explicit Status Contract, while 100% of complete cases select the Completion Dashboard.
- **SC-007**: 100% of verification cases reject owner-selection reasoning during routine collection and allow it only for explicit implementation-detail requests.
- **SC-008**: 100% of setup output documentation describes guided onboarding and distinguishes collection, status, and completion experiences.
- **SC-009**: 0 owner authority, owner question wording, readiness order, terminality, safe-stop behavior, or completion dashboard destinations change as a result of this feature.
- **SC-010**: 100% of completion verification cases emit the Completion Dashboard and no collection question.

## Assumptions

- Feature 085 remains the implementation baseline for the simplified setup interaction.
- Existing owner workflows remain authoritative for questions, informational context, readiness, outcomes, and artifact ownership.
- A resume greeting is required whenever setup continues after a prior interaction and input is still required.
- Owner-provided informational context is preserved only when supplied by the active owner workflow.
- Explicit requests for status or implementation details may expand that response without changing routine collection behavior.
- The existing Completion Dashboard remains the source of ownership routes and governance destinations.
- Verification uses deterministic output examples or captured records and introduces no setup persistence.

## Out of Scope

- Changing owner workflow authority, artifact schemas, readiness rules, readiness order, or terminality classifications.
- Changing the existing Completion Dashboard content or ownership destinations.
- Adding a new setup persistence store, checkpoint mechanism, or orchestration authority.
- Replacing owner-provided questions or informational context with generic Setup text.
- Changing the Experience Standard or adding a new normative interaction rule.
- Rewriting unrelated Highway skills.
