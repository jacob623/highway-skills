# Feature Specification: Highway UX Standard Alignment

**Feature Branch**: `083-highway-ux-standard-alignment`

**Created**: 2026-09-23

**Status**: Draft

**Input**: User description: "Create a new spec for addressing the Highway UX Standard Alignment Plan across interactive Highway skills, with a reusable interaction contract and explicit progress, next-action, single-question, outcome, resume, and ownership behavior."

## Clarifications

### Session 2026-09-23

- Q: Where should the reusable Interactive Workflow UX Contract be authoritative? → A: The Highway Experience Standard; it is a reusable section in that document, not a skill-owned contract or standalone library file.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Interactive Skills Lead With the Next Action (Priority: P1)

As a person using an interactive Highway skill, I want the response to make my next required action clear without exposing internal workflow mechanics, so that I can complete the current task without interpreting orchestration details.

**Why this priority**: Next-action focus and implementation-detail avoidance are the foundation of a consistent interaction experience across all guided workflows.

**Independent Test**: Review each in-scope interactive skill's opening and collection output contract, then verify that the current required action is prioritized, internal mechanics are omitted unless requested, and ownership boundaries remain explicit.

**Acceptance Scenarios**:

1. **Given** an in-scope interactive skill begins a workflow that requires user input, **when** it emits its first user-facing content, **then** the content prioritizes the required question, decision, confirmation, approval, or actionable error.
2. **Given** an in-scope skill reports workflow activity, **when** the message is reviewed, **then** it describes the user-relevant activity and does not expose routing, validation, evaluation-order, allocation, processing, or orchestration details unless requested.
3. **Given** a workflow delegates artifact or decision ownership to another skill, **when** the workflow reports the next action, **then** it routes the user to the owning workflow without claiming ownership or presenting internal delegation as user work.

### User Story 2 - Guided Collection Is Focused and Observable (Priority: P1)

As a person completing guided setup or review, I want one unresolved question or decision at a time and useful progress framing, so that I know what I am answering now and how much relevant work remains.

**Why this priority**: The in-scope skills include onboarding, interviews, proposal review, candidate review, clarification, and multi-stage collection. Without a shared interaction contract, each workflow can make the same task feel different and ambiguous.

**Independent Test**: Exercise one representative collection path for Profile, Objectives, Controls, NFRs, New, and Clarify, and inspect Discovery and ADR activity messages. Verify that each path reports the current activity, preserves ordered progress where applicable, and exposes no more than one unresolved collection question or decision at a time.

**Acceptance Scenarios**:

1. **Given** Profile is collecting onboarding information, **when** it asks for input, **then** it presents one unresolved question with current activity and completed/remaining question context.
2. **Given** Objectives is creating an objective, **when** collection begins, **then** it presents the objective statement, success measures, and rationale approval as an ordered three-prompt flow with only the next unresolved prompt active.
3. **Given** Controls is collecting controls or reviewing proposals/candidates, **when** the workflow advances, **then** it reports the relevant step, category or proposal/candidate position, remaining work, and current activity.
4. **Given** NFRs is reviewing candidates, **when** a decision is requested, **then** it presents one candidate decision at a time with candidate position, remaining candidates, and the next required action.
5. **Given** New or Clarify is collecting evidence or resolving findings, **when** the user resumes or answers, **then** the workflow selects the first incomplete domain or finding and exposes exactly one unresolved question or finding question.
6. **Given** a workflow has no long-running activity, **when** progress applicability is reviewed, **then** it does not manufacture progress messages or stages solely to satisfy the interaction standard.

### User Story 3 - Resume and Outcomes Are Understandable (Priority: P1)

As a person pausing, cancelling, declining, or completing an interactive workflow, I want user actions and workflow outcomes distinguished and resume behavior stated, so that I know what happened and what a later invocation will do.

**Why this priority**: Interactive workflows can stop for different reasons. Treating a user exit as an owner outcome, or implying hidden persisted state, makes the workflow difficult to trust and resume.

**Independent Test**: Inspect the outcome and resume contracts for all in-scope collection workflows, then exercise representative pause, cancel, stop-responding, declined, aborted, blocked, and resumed paths without creating Setup-owned state.

**Acceptance Scenarios**:

1. **Given** a user pauses, cancels, or stops responding, **when** the interaction ends, **then** the skill reports a User Exit and documents whether a later invocation resumes from persisted owner evidence or starts a new interaction.
2. **Given** an owner workflow returns declined, aborted, or blocked, **when** the result is reported, **then** it is identified as an Owner Outcome and is not mislabeled as a User Exit.
3. **Given** a workflow supports readiness-based resume, **when** it is invoked after interruption, **then** it resumes at the first incomplete evidence domain, question, category, proposal, candidate, or finding according to its ownership contract.
4. **Given** a workflow does not persist interactive collection state, **when** a user resumes it, **then** it does not claim to restore an unanswered question, draft response, cancellation marker, or hidden workflow checkpoint.

### User Story 4 - Maintainers Can Apply One Shared UX Contract (Priority: P2)

As a Highway maintainer, I want one reusable interaction contract referenced by the applicable skills, so that future amendments can be reviewed consistently without copying contradictory wording across skill documents.

**Why this priority**: A shared contract reduces drift while allowing each owner workflow to retain its domain-specific progress fields, artifact authority, and terminality rules.

**Independent Test**: Inspect the shared contract and each in-scope skill reference, then verify that the shared principles are present once, skill-specific progress fields remain explicit, and no skill is forced to adopt Setup-specific workflow semantics that do not apply.

**Acceptance Scenarios**:

1. **Given** the shared UX contract, **when** it is reviewed, **then** it defines next-action priority, implementation-detail avoidance, one unresolved question at a time, activity-focused progress, user-action/outcome distinction, ownership boundaries, and explicit resume behavior where applicable.
2. **Given** an in-scope skill references the shared contract, **when** its domain workflow is reviewed, **then** the skill preserves its own question, category, proposal, candidate, domain, or finding terminology and adds only applicable progress and outcome fields.
3. **Given** a read-only or primarily analytical skill has no guided collection workflow, **when** alignment is reviewed, **then** it receives only applicable activity-focused output guidance and does not acquire artificial wizard behavior.

## Edge Cases

- A skill may emit supporting context before a question, but the first unresolved collection question or decision must remain unambiguous and there must be no competing unresolved question.
- A prompt may contain multiple informational statements, but only one unresolved collection question or decision may require a response at a time.
- Informational content, examples, summaries, and supporting context may accompany a collection prompt. Only one unresolved response-demanding question or decision may be active at a time.
- A workflow may explain implementation details when the user explicitly requests that explanation; the normal user-facing path must remain activity-focused.
- A workflow can be interactive without being a guided information-collection workflow; that distinction controls whether single-question collection applies.
- A workflow with no long-running activity must report progress requirements as not applicable rather than inventing stages.
- A workflow may stop because of a User Exit or an Owner Outcome; the status vocabulary must distinguish `pause`, `cancel`, and `stop responding` from `declined`, `aborted`, and `blocked`.
- A workflow may resume from persisted owner evidence without persisting its own unanswered questions, drafts, cancellation markers, or checkpoints.
- An owner workflow may reject or defer a proposed artifact; the orchestrating skill must preserve the owner's authority and must not write a substitute artifact.
- Existing skills may contain domain-specific output contracts; alignment must not remove required legacy dashboard, proposal, candidate, or readiness fields.
- Highway Help remains read-only and Highway Relationships remains primarily inspection/repair-oriented; neither is required to adopt guided collection fields unless its applicable behavior changes.

## Requirements *(mandatory)*

### Contract Boundary

The Interactive Workflow UX Contract is an authoritative reusable section within the Highway Experience Standard.

The contract organizes, scopes, and applies the interaction obligations defined by X2.2 through X2.6.

The contract may introduce shared workflow terminology, applicability guidance, progress conventions, resume conventions, ownership-display conventions, and outcome-classification conventions.

The contract must not modify the normative text of X2.2 through X2.6 and must not introduce new X rule identifiers.

Progress fields follow one of these forms, depending on workflow type:

The compact forms are `Current X`, `Completed X Count`, `Remaining X Count` or `Current X`, `Position`, `Remaining X Count`.

```text
Current X
Completed X Count
Remaining X Count
```

or:

```text
Current X
Position
Remaining X Count
```

### Functional Requirements

- **FR-001**: The Highway Experience Standard MUST contain one authoritative reusable Interactive Workflow UX Contract that defines next-action priority, implementation-detail avoidance, one unresolved collection question at a time, current activity, applicable completed/remaining progress, User Exit versus Owner Outcome distinction, ownership boundaries, and resume behavior where applicable.
- **FR-002**: The Interactive Workflow UX Contract MUST organize, scope, and apply the interaction obligations defined by X2.2 through X2.6 without modifying their normative text or introducing new X rule identifiers, and MUST not be duplicated as a skill-owned contract or standalone library file.
- **FR-002A**: A valid UX Contract reference MUST be one of: a direct reference to the Interactive Workflow UX Contract section; a direct reference to the Highway Experience Standard UX Contract; or an explicit declaration that the workflow is governed by the Interactive Workflow UX Contract. For non-guided interactive workflows, a valid reference may be a statement of applicability to the Interactive Workflow UX Contract without adopting collection-specific provisions.
- **FR-003**: `highway-profile` MUST state that guided onboarding asks one unresolved question at a time, reports progress and current collection activity, prioritizes the next action, and resumes at the first incomplete setup/configure evidence according to its owner contract.
- **FR-004**: `highway-profile` MUST expose Profile Setup Progress with `Current Question`, `Completed Questions Count`, `Remaining Questions Count`, and `Current Activity` when guided collection is active.
- **FR-005**: `highway-objectives` MUST identify its ordered three-prompt creation flow as objective statement, success measures, and rationale approval, with only one unresolved prompt active at a time.
- **FR-006**: `highway-objectives` MUST expose activity-focused progress for objective creation, including `Step 1 of 3` or an equivalent ordered position, and `Current Activity`.
- **FR-007**: `highway-controls` MUST expose applicable progress for Guided Control Collection using `Step`, `Category`, `Completed Categories`, `Current Category`, and `Current Activity`.
- **FR-008**: `highway-controls` MUST expose applicable progress for Review Workflow using `Current Proposal`, `Proposal Position`, `Remaining Proposals`, and `Current Activity`.
- **FR-009**: `highway-controls` MUST expose applicable progress for NFR Proposal Review using `Current Candidate`, `Candidate Position`, `Remaining Candidates`, and `Current Activity`.
- **FR-010**: `highway-controls` MUST verify one-question collection, activity-focused progress, next-action priority, implementation-detail avoidance, and preservation of owner artifact and proposal authority.
- **FR-011**: `highway-nfrs` MUST state that candidate review presents one candidate decision at a time, prioritizes the next action, and reports `Candidate Position`, `Remaining Candidates`, and `Current Activity` when applicable.
- **FR-012**: `highway-nfrs` MUST include verification for single-candidate decision flow, progress visibility, activity-focused progress, next-action priority, implementation-detail avoidance, and owner authority.
- **FR-013**: `highway-new` MUST expose `Current Domain`, `Completed Domains`, `Remaining Domains`, and `Current Activity` during multi-stage request intake or evidence collection.
- **FR-014**: `highway-new` MUST state that resume begins at the first incomplete evidence domain and MUST verify one-question collection, progress visibility, next-action priority, and ownership preservation.
- **FR-015**: When highway-discovery emits progress messages, those messages MUST describe user-relevant analysis activity rather than implementation details, while preserving its analytical and non-wizard behavior.
- **FR-016**: When highway-adr emits progress messages, those messages MUST describe user-relevant ADR activity rather than orchestration details, while preserving its interactive decision-workflow behavior.
- **FR-017**: `highway-clarify` MUST state that it presents exactly one open finding question at a time, prioritizes the next resolution action, and reports `Finding Position`, `Remaining Findings`, and `Current Activity` when findings are being resolved.
- **FR-018**: `highway-clarify` MUST include verification for one-question collection, progress visibility, next-action priority, implementation-detail avoidance, outcome distinction, and resume behavior where applicable.
- **FR-019A**: An aligned skill MUST NOT allocate identifiers owned by another workflow.
- **FR-019B**: An aligned skill MUST NOT write artifacts owned by another workflow.
- **FR-019C**: An aligned skill MUST NOT modify catalogs owned by another workflow.
- **FR-019D**: An aligned skill MUST NOT claim completion on behalf of another workflow.
- **FR-019E**: An aligned skill MUST preserve existing ownership boundaries.
- **FR-020**: Every in-scope guided collection workflow MUST distinguish User Exits (`pause`, `cancel`, `stop responding`) from Owner Outcomes (`declined`, `aborted`, `blocked`) using deterministic wording appropriate to its domain.
- **FR-021**: Every in-scope workflow MUST declare one applicable resume state: `Persisted owner evidence`, `Transient interaction state`, `New interaction`, or `Not Applicable`; it MUST not imply persistence that does not exist.
- **FR-022**: `highway-help` and `highway-relationships` MUST remain out of the guided collection alignment scope unless their applicable user-facing behavior is changed by this feature; any changed behavior MUST be reviewed against the shared UX Contract.
- **FR-023**: The feature MUST add focused static or executable validation for the Experience Standard contract itself and for each in-scope skill's applicable next-action, single-question, progress, outcome, resume, implementation-detail, and ownership obligations. Contract validation MUST verify that the contract exists, is unique, references X2.2 through X2.6, does not modify their normative text, and introduces no new X identifiers. The validation MUST verify that exactly one Interactive Workflow UX Contract exists in the Experience Standard and no second authoritative copy exists elsewhere.
- **FR-024**: The feature MUST preserve existing output contracts, owner artifact formats, identifiers, governance content, distribution packaging, and generated artifact correspondence except for explicitly required user-facing contract wording.
- **FR-025**: The feature MUST not introduce a new runtime dependency, hidden persistence store, automatic conversation observer, or second governance authority.

### Key Entities *(include if feature involves data)*

- **Interactive Workflow UX Contract**: The authoritative reusable section of the Highway Experience Standard defining common user-facing interaction principles and boundaries.
- **Guided Collection Progress Report**: The applicable fields that identify current activity and completed/remaining work for an interactive collection workflow.
- **User Exit**: A user-directed pause, cancellation, or stop responding that ends or suspends the current interaction.
- **Owner Outcome**: A workflow-directed `declined`, `aborted`, or `blocked` result that reports owner state without redefining user intent.
- **Ownership Boundary**: The rule identifying which skill may create, update, remove, replace, approve, or reject an artifact, proposal, candidate, relationship, or identifier.
- **Resume Contract**: The declared behavior that selects `Persisted owner evidence`, `Transient interaction state`, `New interaction`, or `Not Applicable` after interruption or invocation.
- **Resume Applicability**: One of four declared states: `Persisted owner evidence`, `Transient interaction state`, `New interaction`, or `Not Applicable` when the workflow is invocation-scoped and does not support resume behavior.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: One authoritative Interactive Workflow UX Contract is present within the Highway Experience Standard and referenced by all eight in-scope skills: Profile, Objectives, Controls, NFRs, New, Discovery, ADR, and Clarify, where each reference satisfies FR-002A. Non-guided interactive workflows may use a statement of applicability without adopting collection-specific provisions.
- **SC-002**: 100% of the eight in-scope skills state an applicable next-action priority and implementation-detail boundary.
- **SC-003**: 100% of the six guided collection skills identify exactly one unresolved question or decision at a time in their applicable workflow contract: Profile, Objectives, Controls, NFRs, New, and Clarify.
- **SC-004**: 100% of workflows with meaningful ordered work expose current activity and applicable completed/remaining or position progress fields. Workflows without meaningful ordered work record the applicable N/A condition rather than manufacturing progress reporting.
- **SC-005**: 100% of in-scope guided collection skills distinguish the three User Exit values from the three Owner Outcome values, with no category collision.
- **SC-006**: 100% of in-scope skills declare one of the four Resume Applicability states, and 0 aligned skills claim restoration of unsupported unanswered questions, drafts, cancellation markers, or hidden checkpoints.
- **SC-007**: 100% of in-scope skills satisfy the observable ownership requirements FR-019A through FR-019E after alignment.
- **SC-008**: Focused validation reports zero missing shared-contract references, missing required progress fields, duplicate unresolved questions, implementation-detail leakage in normative examples, or contradictory outcome/resume wording.
- **SC-009**: Highway Help and Highway Relationships receive no unnecessary guided-collection requirements, while any changed applicable behavior remains reviewable against the shared contract.
- **SC-010**: Existing output contracts, governance artifacts, generated adapters, and distribution packaging remain unchanged except for intentional UX contract and validation updates.
- **SC-011**: The full repository validation suite and focused UX alignment checks pass with no failures attributable to this feature.
- **SC-012**: Exactly one authoritative Interactive Workflow UX Contract exists within the Highway Experience Standard; no duplicated authoritative Interactive Workflow UX Contract exists in any Highway skill or standalone library artifact.

## Assumptions

- The authoritative Experience Standard remains `.highway/governance/experience-standard.md`, especially X2.2 through X2.6.
- The Interactive Workflow UX Contract is a reusable section within the authoritative Highway Experience Standard; no skill-owned contract or standalone library file is introduced.
- Adding the Interactive Workflow UX Contract is expected to be a MINOR Experience Standard version increment because it introduces a new section without modifying existing X2.2 through X2.6 rule text.
- Resume behavior is classified explicitly as `Persisted owner evidence`, `Transient interaction state`, `New interaction`, or `Not Applicable`; invocation-scoped workflows are not required to manufacture resume behavior.
- Existing skill source documents under `.highway/skills/` remain the authorities for skill-specific workflow and ownership behavior.
- Feature 082's Setup Wizard terminology for User Exits, Owner Outcomes, transient state, readiness resume, and owner authority is the baseline vocabulary where applicable.
- Progress fields are reported only when the workflow has meaningful ordered work; a read-only or non-long-running workflow records the applicable N/A condition rather than inventing progress.
- Existing user-owned governance artifacts and their substantive content are out of scope.
- Existing skills that are not changed by this feature are not rewritten solely to demonstrate compliance.
- No extension hooks are registered for this repository unless a future setup adds `.specify/extensions.yml`.

## Out of Scope

- Making every skill behave like the Setup Wizard.
- Adding wizard behavior, question sequencing, or persistence to Highway Help or Highway Relationships without a changed applicable workflow.
- Implementing automatic semantic observation of live agent conversations.
- Changing the Experience Standard's normative X2.2-X2.6 text or creating new X rule IDs.
- Replacing owner workflows, changing artifact ownership, or moving user-owned governance records.
- Adding hidden Setup-style checkpoints, draft stores, cancellation markers, or a new runtime persistence model.
- Rewriting implementation details of skills that are not required for user-facing UX alignment.
