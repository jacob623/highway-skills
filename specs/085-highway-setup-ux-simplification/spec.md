# Feature Specification: Highway Setup UX Simplification and Welcome Flow

**Feature Branch**: `085-highway-setup-ux-simplification`

**Created**: 2026-09-23

**Status**: Draft

**Input**: User description: "Make Highway onboarding feel like a guided product experience rather than a workflow engine by adding a welcoming setup opening, suppressing orchestration commentary, prioritizing the owner's next question, reducing dashboard visibility during collection, simplifying collection output, and aligning verification with the Experience Standard."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Start Setup With a Human Welcome (Priority: P1)

As a person starting Highway setup, I want a brief welcome and the active owner's next question presented immediately, so that onboarding feels like a guided product experience and I know what to answer without learning the setup engine.

**Why this priority**: The first response establishes whether setup feels user-oriented or internally mechanical. It is the primary UX correction.

**Independent Test**: Invoke setup against a repository that requires Profile input and compare the first response with the canonical welcome sequence; verify the welcome, owner introduction, and unresolved owner question appear in that order and the interaction waits for the response.

**Acceptance Scenarios**:

1. **Given** setup is invoked and user input is required, **when** the first response is emitted, **then** it contains the Highway welcome message, a brief introduction to the active owner workflow, and the owner's next unresolved question in that order.
2. **Given** the active owner is Profile, **when** setup begins collection, **then** it presents the canonical organization question: "What is the name of the organization, business unit, team, or project group this repository represents?"
3. **Given** the owner question is presented, **when** setup reaches the question, **then** it waits for the user's response before continuing.
4. **Given** setup is resumed after a prior interaction, **when** user input is still required, **then** it uses the same welcome-and-owner-question structure without exposing internal routing or readiness mechanics.

### User Story 2 - Collect Information Without Workflow-Engine Noise (Priority: P1)

As a Highway user answering setup questions, I want collection output to focus on the active owner and question, so that readiness evaluation, routing, progress bookkeeping, and orchestration do not compete with the action I need to take.

**Why this priority**: Suppressing internal commentary and progress framing directly addresses the stated failure mode across every guided setup stage.

**Independent Test**: Exercise Profile, Objectives, Controls, and NFR collection states and verify that active collection emits only the owner workflow and question, while dashboards and status are reserved for completion, blocking, or explicit status requests.

**Acceptance Scenarios**:

1. **Given** setup requires user input, **when** the owner question is emitted, **then** it appears before setup status, progress, routing, or readiness information.
2. **Given** setup is actively collecting an answer, **when** output is rendered, **then** the collection contract uses `Owner Workflow` and `Question` and does not use `Step`, `Stage`, `Completed Stages`, `Current Stage`, `Remaining Stages`, or `Current Activity`.
3. **Given** setup is collecting routine input, **when** output is rendered, **then** it does not explain readiness evaluation logic, stage selection, owner selection, workflow routing, contract loading, artifact inspection, orchestration, or internal processing decisions unless the user explicitly requests those details.
4. **Given** setup is incomplete but no question is currently required, **when** setup is blocked or paused, **then** it may identify the blocking owner and actionable reason without presenting internal orchestration as user work.
5. **Given** setup completes, is blocked, or the user explicitly requests status, **when** setup emits status, **then** it may display the appropriate setup dashboard.

### User Story 3 - Preserve Owner Workflow Semantics While Simplifying Output (Priority: P1)

As a governance owner, I want Profile, Objectives, Controls, and NFRs to remain authoritative for their questions and outcomes while Setup changes only its presentation, so that onboarding becomes simpler without bypassing ownership or readiness safety.

**Why this priority**: UX simplification must not change artifact ownership, terminality, safe stopping, or the ordering of foundational governance work.

**Independent Test**: Run setup through each owner route and failure state, then verify owner question content and delegation semantics remain intact while the simplified output contract and Experience Standard alignment are enforced.

**Acceptance Scenarios**:

1. **Given** Profile, Objectives, Controls, or NFR setup is incomplete, **when** Setup activates that owner, **then** it identifies the owner and presents that owner's next unresolved question without taking ownership of the artifact or readiness decision.
2. **Given** an owner returns a terminal success, non-terminal outcome, decline, abort, malformed response, or blocked result, **when** Setup handles it, **then** existing owner routing and safe-stop behavior remain unchanged.
3. **Given** setup is complete, **when** the completion dashboard is requested or emitted, **then** existing ownership routes and completion semantics remain available.
4. **Given** the Experience Standard is reviewed, **when** setup behavior is compared with it, **then** setup allows a welcome greeting, prioritizes the next required action, avoids implementation details and workflow-engine narration, and asks only the next unresolved question.
5. **Given** verification is run, **when** the setup output is evaluated, **then** it checks the welcome opening, immediate owner question, absence of orchestration commentary, absence of readiness-evaluation and routing explanations, and status visibility restrictions.

### Edge Cases

- Setup is invoked when all required foundations are already complete; it must not ask a collection question and may show the completion dashboard.
- Setup is blocked before an owner question is available; it may show blocking status and the owner-provided next action without exposing internal evaluation mechanics.
- An owner provides informational context together with a next question; the simplified contract must preserve the owner content needed for the question without adding progress framing.
- A user explicitly requests setup status or implementation details; the response may provide the requested information while keeping ordinary collection output quiet.
- A user pauses, cancels, or stops responding; existing User Exit handling and resume semantics remain unchanged.
- An owner returns declined, aborted, blocked, malformed, or unknown output; Setup must preserve existing Owner Outcome and safe-stop handling.
- Profile, Objectives, Controls, and NFRs have different question wording and domain fields; the shared presentation contract must not replace owner-specific questions with generic text.
- A complete dashboard is emitted; dashboard visibility rules must not remove required completion or ownership information.

## Requirements *(mandatory)*

### Setup Opening Experience

- **FR-001**: When setup is invoked and user input is required, Setup MUST emit a Highway welcome message, briefly identify the owner workflow being started, present the owner's next unresolved question, and wait for the user's response in that order.
- **FR-002**: The opening experience MUST distinguish user-facing onboarding from workflow progress reporting and MUST NOT require progress fields before presenting the owner's question.
- **FR-003**: The Profile opening experience MUST support the canonical welcome sequence and organization question defined in this specification.

### Implementation Detail Boundary

- **FR-004**: During ordinary setup interaction, Setup MUST NOT explain readiness evaluation logic, stage selection logic, owner selection logic, workflow routing, contract loading, artifact inspection, orchestration behavior, or internal processing decisions unless explicitly requested by the user.
- **FR-005**: Setup MUST NOT present repository initialization, first-incomplete-owner narration, owner-workflow reading, response forwarding, or equivalent internal mechanics as the user's work.
- **FR-006**: When user input is required, the owner's next unresolved question MUST appear before setup status, progress, routing, or readiness information.

### Status and Collection Visibility

- **FR-007**: Setup MAY display dashboard information when setup completes, setup is blocked, setup is declined, setup is aborted, or the user explicitly requests status.
- **FR-008**: During active guided collection, Setup MUST use the simplified collection contract `Owner Workflow` and `Question` and MUST NOT emit `Step`, `Stage`, `Completed Stages`, `Current Stage`, `Remaining Stages`, or `Current Activity` as routine progress framing. Blocked, declined, aborted, and status responses MAY identify `Owner Workflow`, `Blocking Reason`, and `Next Action` when needed for actionable context.
- **FR-009**: Progress reporting MUST remain available when explicitly requested, but routine collection MUST NOT manufacture or foreground progress stages.
- **FR-010**: When user input is required, Setup MUST emit the welcome message, the owner introduction, and the owner's next unresolved question in that order.
- **FR-011**: When status is requested, Setup MUST emit `Setup Status`, `Current Owner`, and `Current Activity` as the status contract.
- **FR-012**: When setup completes, Setup MUST emit the existing completion dashboard and ownership destinations without requiring a collection question.

### Owner Workflow and Experience Alignment

- **FR-013**: For incomplete Profile, Objectives, Controls, and NFR setup, Setup MUST identify the active owner workflow and present that owner's next unresolved question without exposing readiness evaluation details or routing explanations.
- **FR-014**: Setup MUST preserve owner authority, owner-specific question wording, existing terminality classification, User Exit handling, Owner Outcome handling, safe-stop behavior, and artifact non-mutation boundaries.
- **FR-015**: Setup MUST align with Experience Standard rules X2.2 through X2.4 by allowing a welcome greeting, prioritizing the next required user action, avoiding implementation details and workflow-engine narration, and asking only the next unresolved question.
- **FR-016**: Verification MUST confirm that setup begins with the welcome experience, places the owner question immediately after owner identification, emits no ordinary orchestration commentary, does not explain readiness evaluation or routing, and restricts dashboard visibility to completion, blocked, declined, or aborted setup, or explicit status requests.
- **FR-017**: Verification MUST include compliant and non-compliant output examples, including the canonical welcome sequence and a non-compliant sequence containing readiness, stage, routing, or orchestration commentary. Verification MUST confirm that normal collection never emits `first incomplete stage`, `owner contract`, `workflow routing`, `forwarding response`, or `repository initialization state`.
- **FR-018**: The feature MUST NOT add a second setup authority, change owner artifact ownership, add hidden setup persistence, or change the required order of Profile, Objectives, Controls, and NFR readiness.
- **FR-019**: When setup resumes after a previous interaction, Setup MUST present a resume greeting before the active owner introduction and unresolved question.
- **FR-020**: Setup MUST NOT explain why a specific owner workflow was selected unless the user explicitly requests implementation details.

### Key Entities *(include if feature involves data)*

- **Setup Opening Experience**: The welcome, owner introduction, next unresolved question, and wait-for-response sequence shown when setup requires input.
- **Owner Question**: The next unresolved question supplied by the active Profile, Objectives, Controls, or NFR owner workflow.
- **Simplified Collection Contract**: The `Owner Workflow` and `Question` output used during routine guided collection.
- **Setup Status Contract**: The status fields shown after completion, when blocked, declined, or aborted, or when the user explicitly requests status.
- **Completion Dashboard**: The existing complete-state dashboard and ownership destinations shown when setup completes.
- **Implementation Detail Boundary**: The set of readiness, routing, orchestration, and internal processing details suppressed unless explicitly requested.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of input-required setup scenarios begin with the welcome message, owner introduction, and owner question in that order.
- **SC-002**: 100% of routine collection scenarios present the owner question before status, progress, routing, or readiness information.
- **SC-003**: 0 routine collection responses contain prohibited orchestration commentary or readiness/routing explanations unless the user explicitly requests those details.
- **SC-004**: 100% of active collection outputs use the simplified `Owner Workflow` and `Question` contract without routine `Step`, `Stage`, completed-stage, remaining-stage, or current-activity framing.
- **SC-005**: 100% of dashboard outputs occur only at setup completion, blocked, declined, or aborted setup, or explicit status requests, while required completion information remains available.
- **SC-006**: 100% of Profile, Objectives, Controls, and NFR owner routes preserve owner-supplied question wording, ownership, terminality, User Exit, Owner Outcome, and safe-stop semantics.
- **SC-007**: 100% of verification cases cover the welcome opening, question priority, implementation-detail suppression, dashboard visibility, Experience Standard alignment, and compliant/non-compliant examples.
- **SC-008**: 0 new setup artifacts, hidden persistence records, or alternate setup authorities are introduced by this feature.

## Assumptions

- The current `highway-setup` skill and Feature 033/034 contracts are the baseline being simplified; this feature changes presentation and verification boundaries rather than owner workflow semantics.
- Existing owner workflows remain authoritative for Profile, Objectives, Controls, and NFR questions, readiness, artifacts, terminality, and outcome classification.
- The canonical Profile question is the organization question stated in this specification; other owner questions continue to come from their owning workflows.
- Setup status and completion dashboard content remains available when the stated visibility conditions apply.
- Explicit user requests for status or implementation details may override ordinary suppression for that response.
- Setup resumes with a resume greeting before the active owner introduction and unresolved question.
- The Experience Standard X2.2-X2.4 rules remain authoritative; this feature does not add an X rule.
- Verification may use deterministic fixtures or representative output records, but no hidden runtime observation or persistent setup checkpoint is required.

## Out of Scope

- Changing Profile, Objectives, Controls, or NFR artifact schemas, ownership, readiness rules, or direct mutation behavior.
- Changing the required readiness order or terminality and outcome classifications.
- Removing the completion dashboard or ownership destinations when setup completes.
- Removing or redefining Setup's existing readiness model; this feature changes only the presentation of setup interactions.
- Adding a new setup persistence store, checkpoint mechanism, or alternate orchestration authority.
- Changing the Experience Standard normative text or introducing X2.5, X2.6, or another new rule.
- Rewriting unrelated Highway skills or replacing owner-specific question content with a generic questionnaire.
