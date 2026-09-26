# Feature Specification: Conversational Objective Discovery

**Feature Branch**: `093-conversational-objective-discovery`

**Created**: 2026-09-25

**Status**: Draft

**Input**: User description: "Update highway-setup and highway-objectives: Conversational Objective Discovery. Setup introduces the purpose. Objectives has the conversation. Replace the rigid three-prompt Objective form with adaptive conversational discovery while preserving the existing Objective artifact, ownership, readiness, identifiers, catalogs, transactions, persistence, and verification contracts."

## User Scenarios & Testing

### User Story 1 - Guided Setup Handoff (Priority: P1)

As a person completing Highway setup, I want Setup to explain why Objectives matter and immediately hand me to the Objective owner, so that the onboarding flow feels continuous without Setup taking ownership of Objective discovery.

**Why this priority**: Without a clear handoff, the feature cannot replace the current onboarding experience safely and users cannot reach the new conversation through Setup.

**Independent Test**: Start setup with a terminal-success Profile and an incomplete Objective baseline. Verify the purpose introduction, the exact first Objective question, and the absence of Objective questions or artifact writes by Setup.

**Acceptance Scenarios**:

1. **Given** Profile has reached terminal success and Objective readiness returns the non-terminal owner `Next Action` `/highway-objectives setup`, **When** Setup is about to delegate that owner action, **Then** Setup displays `Let's identify some explicit outcomes worth pursuing.` and `These give Highway something concrete to connect future decisions back to and help us evaluate whether you're accomplishing what you set out to do.` immediately before delegating the owner collection action.
2. **Given** Profile has reached terminal success and Objective readiness is already terminal `Complete`, **When** Setup advances, **Then** Setup skips the Objective-purpose introduction and continues according to the existing orchestration contract.
3. **Given** Setup has displayed the Objective introduction, **When** the Objectives owner supplies its first question, **Then** Setup immediately renders the complete Objectives-owned opening:

	> **What's an important outcome you'd like to achieve?**
	>
	> If you'd like some suggestions based on your organization's Profile, just let me know. **If you're not sure, just say "I don't know," and we'll work through it together.**

	Setup does not add, duplicate, or rewrite this owner-owned text.
4. **Given** Objective discovery is active, **When** a user answers a question, **Then** Setup forwards the answer to Objectives and renders only the resulting owner-owned next question, decision, or result.
5. **Given** Objective discovery is active, **When** Setup exits or the owner reports a failure, **Then** Setup does not claim completion and does not write or interpret an Objective artifact.

The opening ownership is explicit and independently testable:

**Setup-owned**:

> **Let's identify some explicit outcomes worth pursuing.**
>
> These give Highway something concrete to connect future decisions back to and help us evaluate whether you're accomplishing what you set out to do.

**Objectives-owned**:

> **What's an important outcome you'd like to achieve?**
>
> If you'd like some suggestions based on your organization's Profile, just let me know. **If you're not sure, just say "I don't know," and we'll work through it together.**

### User Story 2 - Adaptive Outcome Discovery (Priority: P1)

As a person defining an Objective, I want to describe an outcome naturally and be guided only where my answer leaves an important gap, so that I can express the outcome in my own language instead of filling out a rigid form.

**Why this priority**: Adaptive discovery is the central user-visible change and must retain enough structured information to make the Objective useful later.

**Independent Test**: Invoke Objective creation directly with a concise answer, a rich answer, and an answer containing uncertainty. Verify that each produces an appropriate next question or proposal while preserving the statement, success measures, and rationale fields.

**Acceptance Scenarios**:

1. **Given** a user answers the outcome question with a concise natural-language outcome, **When** Objectives evaluates it, **Then** it asks the next unresolved question about Outcome, Success, or Significance rather than requiring a fixed prompt sequence.
2. **Given** a user gives a rich answer containing outcome, success, and significance evidence, **When** Objectives evaluates it, **Then** it skips resolved areas and asks at most one unresolved question at a time.
3. **Given** a user says they do not know or are unsure, **When** Objectives receives the response, **Then** it begins guided discovery with one conversational question at a time and does not manufacture or immediately suggest an Objective unless the user subsequently asks for suggestions.
4. **Given** a user explicitly asks for suggestions, **When** relevant Profile context is available, **Then** Objectives offers between one and three distinct context-grounded possibilities for consideration without treating any suggestion as accepted Objective evidence. The possibilities support one unresolved user decision, and each possibility MUST NOT become a separate response-demanding question.
5. **Given** the discovery conversation supports a Statement, at least one Success Measure, and a Rationale, **When** Objectives evaluates the response, **Then** it presents a complete user-relevant proposal without asking a question for a dimension already supported by the active conversation.
6. **Given** a user explicitly asks for suggestions but available Profile evidence does not support meaningful organization-specific possibilities, **When** Objectives evaluates the request, **Then** it says `I don't see enough in your Profile to make a useful suggestion here, but we can work through it together.` and offers a conversational discovery question instead; it does not manufacture a recommendation or imply that Profile setup is deficient.

The complete Objectives-owned opening is:

> **What's an important outcome you'd like to achieve?**
>
> If you'd like some suggestions based on your organization's Profile, just let me know. **If you're not sure, just say "I don't know," and we'll work through it together.**

An Objective is ready for complete proposal synthesis only when Outcome evidence supports a Statement, Success evidence supports at least one Success Measure, and Significance evidence supports a Rationale. Significance is supported when the active conversation contains an explicit reason the outcome matters, or applicable accepted Profile evidence provides a direct organizational connection that can be stated without introducing an unsupported fact. Vision and Competitive Path are often useful sources because they describe organizational direction, but their absence does not prevent suggestions or rationale synthesis when other accepted Profile evidence supports useful guidance. When neither Significance condition is met, Significance remains unresolved and Objectives asks one conversational question to understand why the outcome matters. Context-derived rationale remains proposal content until the user validates the complete Objective; a separate rationale-approval step is not required.

Repository-grounded suggestions and generic discovery assistance are distinct. An explicit request such as `Give me some suggestions` triggers a small set of possibilities grounded in relevant accepted Profile evidence. An uncertainty response such as `I don't know` triggers a conversational question such as `What's something about the business you wish worked better?`; that question is exploratory assistance, not a recommendation, and does not need to manufacture a context-grounded suggestion.

### User Story 3 - Natural Correction and Confirmation (Priority: P1)

As a person reviewing a proposed Objective, I want to validate or correct the interpretation conversationally, so that the retained record reflects my intent rather than an irreversible first interpretation.

**Why this priority**: User ownership and trust depend on corrections being normal conversation and on no record being written before confirmation.

**Independent Test**: Provide an answer that yields a complete Objective proposal, then exercise natural acceptance, partial correction, substantial replacement, rejection, cancellation, and abandonment. Verify the resulting staged interpretation and byte-preservation behavior. Example responses include `Yes, that's right.`, `Mostly, but emphasize consistency instead of speed.`, `No, the real reason is reducing duplicated engineering work.`, `That's not what I meant.`, and `Cancel.` The user is not required to use workflow-command vocabulary.

**Acceptance Scenarios**:

1. **Given** Objectives has staged a complete proposal, **When** the user corrects part of it in natural language, **Then** Objectives updates the staged interpretation, re-evaluates affected evidence, and either presents the revised complete proposal or asks one unresolved question when the correction makes a required dimension unsupported.
2. **Given** the user substantially changes the proposed outcome, **When** Objectives receives the correction, **Then** it re-evaluates all staged Outcome, Success, and Significance evidence, retains only evidence that still supports the revised intent, and asks one new question when an affected dimension becomes unresolved.
3. **Given** the user validates the proposal in natural language, **When** the mutation is confirmed, **Then** Objectives writes the complete retained record and regenerated catalog as one all-or-nothing transaction and verifies both retained outputs before claiming creation completed.
4. **Given** the user declines, cancels, stops responding, or abandons the proposal, **When** the interaction ends, **Then** no Objective record, catalog, identifier allocation, version, or hidden draft is written.

The normal complete Objective review is presented as one user-relevant decision:

> **Here's the objective I've captured:**
>
> **[Objective Title]**
>
> [Statement]
>
> **Success looks like:**
> - [Success Measure]
> - [Success Measure]
>
> **Why it matters:**
> [Rationale]
>
> **Does this reflect what you're trying to accomplish?**

This illustrative shape keeps title, Statement, Success Measures, and Rationale visible while omitting catalog, version, and identifier mechanics. The normal complete Objective review does not display the unallocated or newly allocated OBJ identifier before persistence. The pre-persistence OBJ identifier remains internal unless the user explicitly requests implementation detail. After successful persistence, Objectives may report the user-relevant artifact, for example `Created **OBJ000004 - Reduce Repetitive Platform Engineering**.`

### User Story 4 - Context-Aware Objective Conversation (Priority: P2)

As a person defining an Objective, I want relevant repository context to inform suggestions without having facts fabricated or irrelevant context exposed, so that the conversation is useful and grounded.

**Why this priority**: Objectives must participate in the repository context contract while remaining the sole owner of Objective interpretation and retained content.

**Independent Test**: Run discovery with each declared context document present, absent, and malformed, and with accepted existing Objective artifacts available. Verify relevant context is used when available, unavailable context is recorded without creating unnecessary user questions, and no unsupported claim is added to the Objective.

**Acceptance Scenarios**:

1. **Given** the repository has Identity, Vision, Platform Objectives, and Profile context documents, **When** Objectives asks a discovery question or offers a suggestion, **Then** it consumes only context relevant to that interaction.
2. **Given** one declared context document is unavailable, **When** Objectives would otherwise use that context, **Then** it records the absence according to the Repository Context contract, does not fabricate substitute context, excludes the unavailable document from context-dependent interpretation, and continues using valid workflow evidence and other available declared context.
3. **Given** the repository has accepted existing Business Objective artifacts, **When** the user proposes a new Objective, **Then** Objectives may use those artifacts as accepted Repository Context while keeping them distinct from the four declared Repository Context Documents: Identity, Vision, Platform Objectives, and Profile.
4. **Given** the proposed outcome may overlap an existing Objective, **When** Objectives presents the overlap, **Then** it asks whether the proposed outcome is distinct or represents a change or expansion to the existing Objective; semantic overlap is advisory and does not independently block creation, while structural or baseline-invalid conditions continue to block according to existing validation rules.
5. **Given** an existing Objective is `OBJ000004 - Reduce Scheduling Effort` and the user says `I want to reduce scheduling effort`, **When** Objectives evaluates the proposed outcome, **Then** it identifies the exact duplicate intent, asks whether the user intends to change that Objective or create a distinct outcome, and does not silently create a duplicate.

### User Story 4a - Direct Objective Invocation (Priority: P2)

As a person invoking Objectives directly, I want enough concise context to understand the opening question without Setup's transition language, so that Objectives remains independently usable.

**Why this priority**: Direct invocation is an existing supported entry point and must not depend on Setup to explain the owner workflow.

**Independent Test**: Invoke `/highway-objectives setup`, `/highway-objectives add`, and `/highway-objectives add Reduce customer scheduling effort` without Setup. Verify that the first two explain the immediate task concisely and render the exact opening, while the supplied outcome is processed as initial evidence without repeating the standard Outcome question.

**Acceptance Scenarios**:

1. **Given** a user invokes `/highway-objectives setup` or `/highway-objectives add` directly, **When** Objectives begins collection, **Then** it provides concise context for the task and renders the complete Objectives-owned opening.
2. **Given** Objectives is invoked directly, **When** the first question is rendered, **Then** it does not claim that Setup introduced the purpose or emit Setup's owner-transition text.
3. **Given** `/highway-objectives add` includes usable Objective evidence, **When** Objectives begins collection, **Then** it acknowledges or evaluates that evidence and asks only the next unresolved question rather than repeating the standard opening Outcome question.
4. **Given** a user invokes `/highway-objectives setup` or bare `/highway-objectives add` directly, **When** Objectives provides introductory context, **Then** that context explains that the interaction is identifying an outcome worth pursuing and does not duplicate Setup's transition language.
5. **Given** `/highway-objectives add` includes a rich answer containing Outcome, Success, and Significance evidence, **When** Objectives evaluates the supplied evidence, **Then** it presents the complete Objective proposal directly without rendering the standard opening or another discovery question.

### User Story 5 - Multiple Objectives and Durable Baseline (Priority: P2)

As a person establishing a baseline, I want to define more than one Objective in one interaction and retain each approved Objective safely, so that the baseline reflects the outcomes I actually want to pursue.

**Why this priority**: Objective onboarding commonly requires several outcomes, and the conversation must preserve the existing durable baseline contract rather than producing a single disposable answer.

**Independent Test**: Confirm one Objective, respond to `Anything else you'd like to accomplish?` with a direct second outcome, confirm it, then indicate that the collection is finished. Inspect records, catalog ordering, IDs, versions, readiness, relationships, and the owner terminal result.

**Acceptance Scenarios**:

1. **Given** one Objective has been successfully persisted and verified, **When** Objectives asks `Anything else you'd like to accomplish?` and the user directly supplies another outcome, **Then** Objectives begins the next discovery conversation from that supplied evidence without an intermediate yes/no turn, without restoring an unanswered prompt, and without reusing the prior Objective's identifier.
2. **Given** multiple Objectives are confirmed, **When** the catalog is regenerated, **Then** entries are ordered deterministically by permanent identifier and `next_id` is greater than every allocated identifier.
3. **Given** the baseline contains valid Objective records, **When** readiness is requested, **Then** readiness reports the existing contract status without starting discovery or mutating any artifact.
4. **Given** an Objective may later relate to a Capability, **When** it is retained, **Then** its permanent `OBJ` identifier and existing `capabilities: []` relationship shape are preserved.
5. **Given** the user indicates they are finished after one or more verified Objective creations, **When** Objectives receives that response, **Then** Objective collection returns its terminal owner result so Setup can continue without creating another record.
6. **Given** the user indicates that they want another Objective but supplies no outcome, **When** Objectives receives the response, **Then** it asks `What's another important outcome you'd like to achieve?`.
7. **Given** one Objective was successfully persisted, Objectives asked whether another should be added, and the interaction stopped before another Objective was confirmed, **When** `/highway-setup` is invoked again, **Then** Setup uses persisted Objective readiness and does not restore the prior `Anything else you'd like to accomplish?` question or any transient Objective draft.
8. **Given** one Objective was successfully persisted and persistence verification succeeded, **When** the user responds `No, that's it.` to `Anything else you'd like to accomplish?`, **Then** Objective collection returns terminal success, Setup re-reads Objective readiness, receives `Complete`, and advances to Controls.

### Objective Collection Loop

After each Objective is successfully persisted and verified, Objectives asks:

> **Anything else you'd like to accomplish?**

Objectives interprets the response as follows:

1. **Another outcome is supplied directly**: begin the next Objective discovery conversation using that response as initial evidence.
2. **The user indicates they want another but supplies no outcome**: ask `What's another important outcome you'd like to achieve?`.
3. **The user asks for suggestions**: apply the same Profile-grounded suggestion behavior used for the first Objective, evaluating Profile-wide accepted evidence rather than requiring Vision or Competitive Path specifically.
4. **The user says they do not know whether there is another Objective**: offer to help identify another outcome, but do not require continued discovery. For example: `That's okay. We can move on, or I can help you think through whether there's another outcome worth capturing.`
5. **The user indicates they are finished**: end active Objective collection and return the owner collection-completion result.

There is no fixed number of Objectives. Uncertainty during initial outcome discovery begins guided discovery; uncertainty after this loop question concerns whether to continue collection and does not automatically begin a new full discovery conversation.

### Edge Cases

- A user gives a rich answer that resolves all discovery dimensions in the first response.
- A user gives an answer that is too vague to distinguish an outcome from an activity, task, or implementation detail; Objectives acknowledges the activity and asks what improvement or result it should produce, such as `What would moving to the cloud help you improve or accomplish?`.
- A user says “I don’t know,” changes direction repeatedly, or answers a different unresolved dimension than the one asked.
- Objectives asks about Success, and the user's answer supplies both Success and Significance; Objectives evaluates both dimensions, does not subsequently ask the Significance question, and, when Outcome was already resolved, proceeds directly to the complete proposal.
- Objectives presents several Profile-grounded possibilities, the user selects one, and Objectives treats the selection as Outcome evidence only to the extent supported by the adopted possibility; it evaluates remaining Success and Significance evidence normally and does not treat explanatory suggestion text as accepted user evidence.
- A user supplies multiple independently meaningful outcomes in one response, such as reducing delivery time, improving reliability, and making deployments easier; Objectives asks whether to represent them as one combined Objective or separate Objectives and does not silently split or combine them.
- A user explicitly groups multiple outcomes, such as `I have two objectives. First, reduce delivery time. Second, improve reliability.`; Objectives preserves that grouping and does not ask a redundant grouping question.
- A user explicitly supplies multiple separate Objectives in one response; Objectives retains them as transient evidence, works through one at a time, and continues with the next supplied outcome after persistence without requiring repetition.
- A user corrects only the title, statement, success measure, or rationale while leaving other fields unchanged.
- A user substantially changes the Outcome after providing a Success Measure; incompatible downstream evidence becomes unresolved rather than surviving silently.
- A proposed Objective overlaps an existing Objective but is not identical; the user chooses to keep both.
- A user attempts to create an Objective when the catalog is absent, malformed, has an unsafe `next_id`, or contains an unresolved record.
- A user exits after a proposal is shown but before explicit confirmation.
- Context documents are absent, malformed, contradictory, or contain no evidence relevant to the active Objective interaction.
- A persistence or catalog write fails after staging; the prior baseline must remain intact.
- The Objective baseline changes after discovery begins but before validation; Objectives revalidates authoritative catalog, version, allocation, and overlap state before mutation and does not use stale assumptions.
- A new overlapping Objective appears after initial overlap detection but before confirmation; Objectives rechecks the final proposal against the authoritative accepted Objective baseline and returns to one user decision before writing.
- A new overlapping Objective appears after the user validates the proposal but before identifier allocation; Objectives names it, the user revises the proposed Objective, Objectives re-evaluates Outcome, Success, and Significance, presents a revised complete proposal, and persists only after the revised proposal is validated again.
- A user chooses to create another Objective after the first is confirmed, then exits before confirming the next one.
- Objective 1 is persisted, the user begins Objective 2, and then exits before confirmation; Objective 1 remains unchanged, Objective 2 creates no record, `next_id` and baseline version remain at Objective 1's verified state, and no draft or checkpoint is persisted.
- Setup is invoked when Objectives is already complete; Setup must not start discovery.

## Requirements

### Functional Requirements

- **FR-001**: After Profile reaches terminal success, Setup MUST request Objective readiness. When Objective readiness returns the non-terminal owner `Next Action` `/highway-objectives setup`, Setup MUST emit the exact Objective-purpose introduction immediately before delegating that owner action. When Objective readiness is already terminal `Complete`, Setup MUST skip the Objective-purpose introduction and continue according to the existing orchestration contract; Setup MUST NOT introduce Objective onboarding solely because Profile reached terminal success.
- **FR-002**: Setup MUST render the complete Objectives-owned opening exactly as supplied by Objectives:
	`What's an important outcome you'd like to achieve?`
	followed by `If you'd like some suggestions based on your organization's Profile, just let me know. If you're not sure, just say "I don't know," and we'll work through it together.` Setup-owned introduction text and Objectives-owned opening text MUST remain independently testable.
- **FR-003**: Setup MUST remain an orchestrator and MUST NOT ask Objective questions, interpret Objective evidence, construct Objective records, allocate Objective identifiers, write Objective records or catalogs, or persist Objective drafts/checkpoints.
- **FR-004**: Setup MUST forward Objective interaction results without reordering, rewriting, or fabricating owner questions, decisions, errors, or completion claims.
- **FR-005**: Objectives MUST become a Repository Context Participating Skill and MUST declare Identity, Highway Vision, Highway Platform Objectives, and Profile as its four Repository Context Documents for this feature, using only the behavior categories and evidence boundaries defined below. Identity MAY influence conversational behavior and advisory framing but MUST NOT supply organizational Objective evidence. Highway Vision MAY alter explanations of downstream Objective traceability but MUST NOT establish organizational Significance without supporting user-owned organizational evidence. Highway Platform Objectives MAY evaluate the quality of Highway's assistance but MUST NOT provide Outcome, Success, or Significance evidence for an organizational Business Objective. Profile MAY supply accepted organizational context supporting suggestions, question framing, Significance interpretation, and proposed Rationale synthesis. Identity, Highway Vision, and Highway Platform Objectives MUST NOT introduce organizational facts into the proposed title, Statement, Success Measures, or Rationale unless those facts are independently supported by user-owned workflow evidence or accepted Profile context. Objectives MUST consume each declared document only when relevant to the active decision, and workflow-specific user evidence remains authoritative. Among the four declared Repository Context Documents, Profile is the only source that MAY supply accepted organizational evidence for Objective interpretation.
- **FR-006**: Objectives MUST consume only declared context relevant to the active interaction, record unavailable declared context, and MUST NOT fabricate substitute context or user-owned evidence.
- **FR-007**: Objectives MUST replace the fixed three-prompt creation form with adaptive discovery across Outcome, Success, and Significance.
- **FR-008**: During Objective collection, Objectives MUST expose at most one unresolved response-demanding question or decision at a time and MUST NOT report fixed adaptive-discovery progress such as `Step 1 of 3`.
- **FR-009**: Objectives MUST support natural-language outcomes, explicit requests for suggestions, uncertainty-driven guided discovery, and responses that resolve multiple discovery dimensions simultaneously.
- **FR-010**: Objectives MUST interpret supported workflow evidence into staged, transient `Statement`, `Success Measures`, and `Rationale` content; these interpretations MUST remain transient until complete-Objective validation. User-supplied wording that the user explicitly wants retained MUST be preserved; otherwise, Objectives MAY synthesize concise wording from supported user evidence and applicable Repository Context, subject to complete-proposal validation.
- **FR-011**: Objectives MUST support natural-language validation, correction, refinement, replacement, rejection, cancellation, and abandonment without requiring workflow-command vocabulary such as `Accept`, `Modify`, or `Replace`.
- **FR-012**: Objectives MUST detect possible overlap with existing Objectives and present the overlap for user resolution by asking whether the proposed outcome is distinct or represents a change or expansion to the existing Objective; semantic overlap or exact duplicate intent does not independently make the Objective baseline invalid. Objectives MUST name the existing Objective and let the user decide whether the proposed intent is distinct or represents a change to that Objective. Structural baseline failures remain blocking under the existing Objective contract, and Objectives MUST NOT merge, delete, or silently rewrite an existing Objective.
- **FR-013**: Objectives MUST present the complete user-relevant Objective interpretation for validation before persistence, including the proposed title, Statement, Success Measures, Rationale, and one natural-language validation decision. Validation of the complete Objective constitutes approval of the proposed title and synthesized Rationale when the user accepts the complete proposal without correcting either. Identifier allocation, catalog changes, semantic-version calculations, and persistence mechanics remain internal unless explicitly requested.
- **FR-014**: Objectives MUST allocate permanent six-digit `OBJ` identifiers exactly once from the catalog's authoritative `next_id` within the confirmed mutation transaction; discovery and user-visible validation MUST NOT consume an identifier, and failed, declined, cancelled, abandoned, or persistence-failed attempts MUST leave `next_id` unchanged. Identifiers MUST never be reused, including after removal or reset.
- **FR-015**: Objectives MUST preserve the existing Objective record schema, including `id`, `title`, `status`, `capabilities: []`, Statement, Success Measures, and Rationale, and MUST NOT add assessment snapshot fields as part of this feature.
- **FR-016**: Objectives MUST preserve the existing Objective catalog schema, deterministic identifier ordering, ownership warning, semantic baseline version, and authoritative `next_id`.
- **FR-017**: After creation confirmation, Objectives MUST revalidate authoritative baseline and catalog state and complete FR-035 overlap re-evaluation before identifier allocation or retained writes. It MUST then allocate the identifier, persist record and catalog as one all-or-nothing transaction, and verify both retained outputs before claiming completion.
- **FR-018**: Objectives MUST increment the baseline version exactly once per confirmed action using the existing action semantics: Add/New MINOR, Update PATCH, and Remove/Reset MAJOR.
- **FR-019**: Objectives MUST preserve readiness behavior and MUST keep readiness read-only; beginning or abandoning adaptive discovery MUST NOT change readiness or persisted baseline state.
- **FR-020**: After each verified Objective creation, Objectives MUST ask `Anything else you'd like to accomplish?` and allow continued Objective discovery until the user indicates they are finished. A directly supplied new outcome starts the next discovery conversation immediately; an affirmative response without an outcome asks `What's another important outcome you'd like to achieve?`; an explicit request for suggestions uses Profile-grounded suggestion behavior; uncertainty about whether another Objective exists offers help without requiring discovery; and there is no fixed limit on the number of Objectives collected in the interaction.
- **FR-021**: Objectives MUST preserve existing read-only actions, destructive confirmation behavior, malformed-baseline rejection, record locations, catalog locations, Capability relationship compatibility, and verification requirements.
- **FR-022**: The feature MUST include focused tests covering Setup handoff, exact independent opening text, direct invocation, direct and rich answers, explicit suggestions versus uncertainty-driven discovery, suggestion adoption, evidence completion, rationale synthesis, natural validation and correction, downstream evidence invalidation, activity-to-outcome exploration, non-write exits, declared context use and absence, overlap handling, persistence boundaries, multiple Objectives, finished collection, IDs, catalog ordering, readiness, and transaction failure.
- **FR-023**: `highway-setup` and `highway-objectives` MUST be versioned independently under the repository's Skill Versioning Policy according to their respective contract changes. Replacing `highway-objectives`' current three-prompt and `Accept, modify, or replace?` behavioral guarantees is a breaking change expected to require `1.0.0` -> `2.0.0`; Setup's version MUST be classified independently rather than predeclared here.
- **FR-024**: Repository-context-generated suggestions MUST remain transient guidance until the user explicitly selects one, restates it as an outcome they want, modifies it into their own intended outcome, or otherwise unambiguously expresses that it should be pursued. Asking for more information, such as `Tell me more about option 2.`, `Why would that matter?`, or `What would success look like for that?`, MUST NOT by itself count as adoption.
- **FR-025**: Guided Objective discovery MUST accept ordinary business language without requiring users to understand the terms Objective, Success Measure, Rationale, Outcome, Success, or Significance.
- **FR-026**: After a user correction, Objectives MUST re-evaluate staged Outcome, Success, and Significance evidence and discard staged interpretations no longer supported by the revised intent.
- **FR-027**: During active Objective collection, persisted Objective baseline readiness and transient collection completion MUST remain separate. After each verified creation, Objectives MAY continue collecting additional Objectives even though baseline readiness is `Complete`. Objectives returns successful collection completion only when the user indicates they are finished. Setup then re-reads Objective readiness and advances only from the owner's fresh terminal readiness result. No persisted wizard state is required.
- **FR-028**: When multiple meaningful outcomes are present and grouping is unstated, Objectives MUST ask whether to represent them together or separately. Explicit user grouping MUST be preserved, and Objectives MUST NOT ask a redundant grouping question.
- **FR-029**: When a Success question has a downstream implication not already established, Objectives MUST explain how the answer defines success for future Highway work, for example: `This gives us a clear definition of success that future Highway work can stay connected to.`
- **FR-030**: Before proposing a new Objective, Objectives MUST inspect the accepted Objective baseline when it exists and use relevant existing Objectives for overlap detection and contextual guidance. Existing Objective artifacts remain accepted Repository Context rather than Repository Context Documents. Existing Objectives MAY inform overlap, reuse, and related-Objective guidance but MUST NOT independently establish new organizational facts about the proposed Objective.
- **FR-031**: When the user explicitly requests suggestions, Objectives MUST present between one and three distinct Profile-grounded possibilities when supported evidence exists; it MUST NOT add unsupported suggestions merely to reach three. The possibilities MUST support one unresolved user decision rather than separate response-demanding questions, and the presentation MAY include a concise acknowledgment of the relevant Profile basis without exposing irrelevant context.
- **FR-032**: When the user explicitly supplies multiple separate Objectives in one response, Objectives MUST retain those outcomes as transient evidence in user-provided order, complete them one at a time in that order, and MUST NOT require the user to repeat an outcome already supplied during the active interaction.
- **FR-033**: When direct `/highway-objectives add` invocation already contains usable Objective evidence, Objectives MUST process that evidence before selecting a question and MUST NOT ask the standard opening Outcome question when Outcome is already supported. Setup-forwarded evidence, when present, follows the same owner-controlled rule without Setup interpreting it.
- **FR-034**: Natural-language acceptance of the complete Objective MUST authorize non-destructive creation without a second persistence-confirmation question.
- **FR-035**: After user confirmation and before identifier allocation, Objectives MUST re-evaluate the final proposal against the authoritative accepted Objective baseline for newly introduced overlap. If new overlap exists, Objectives MUST name the existing Objective and return to one user decision before mutation. When newly discovered overlap returns the workflow to the user, creation confirmation is no longer active; Objectives proceeds only after the user resolves the overlap and validates the resulting complete proposal.
- **FR-036**: Objective readiness MUST remain `Complete` when at least one valid Objective exists with a consistent catalog and valid `next_id`, even while active collection continues.
- **FR-037**: Objective onboarding MUST NOT require exhaustive discovery of organizational Objectives. The user determines when to finish the active collection interaction and may add Objectives later; Highway MUST NOT attempt to discover every possible Objective before allowing completion.
- **FR-038**: After evaluating all supported evidence in a response, Objectives MUST select the next action in this order:
	1. If Outcome is unresolved, ask one Outcome question.
	2. Otherwise, if Success is unresolved, ask one Success question.
	3. Otherwise, if Significance is unresolved, ask one Significance question.
	4. Otherwise, present the complete Objective proposal.
- **FR-039**: When user input materially changes Objective interpretation, suggestion relevance, Rationale synthesis, overlap handling, or downstream relationships, Objectives MUST provide one concise contextual acknowledgment before continuing.
- **FR-040**: Objectives MUST provide Relevant Examples only when they clarify the expected response kind or form; examples MUST NOT be added mechanically to every question.
- **FR-041**: A failed retained-output verification MUST NOT produce a successful Objective creation claim and MUST identify the unverified Objective record or catalog.
- **FR-042**: Objective readiness MUST preserve the existing four-field output order: `Status`, `Summary`, `Next Action`, `Blocking Reason`. Missing returns `/highway-objectives setup`; Complete and Blocked return `None`.
	Expected states are: no valid Objective baseline returns `Status: Missing` and `Next Action: /highway-objectives setup`; a valid Objective baseline returns `Status: Complete` and `Next Action: None`; and a malformed or inconsistent baseline returns `Status: Blocked` and `Next Action: None`.
	`Blocked` MUST include a non-empty `Blocking Reason`; `Missing` and `Complete` MUST use `Blocking Reason: None`.
- **FR-043**: When a declared Repository Context Document is malformed or unusable, Objectives MUST record that condition, exclude that document from context-dependent interpretation, and continue using valid workflow evidence and other available declared context.
- **FR-044**: When declared Repository Context Documents provide conflicting applicable guidance, Objectives MUST apply their Constitution-defined roles and ordering while keeping workflow-specific user evidence authoritative.

### Implementation Requirements

- **Implementation Note**: Feature Functional Requirements define required behavior and are not intended to be copied verbatim into `SKILL.md`. Implementation MUST decompose them into Constitution-compliant directives, decision tables, workflow steps, verification checks, and cross-references without changing the specified behavior.
- **Implementation Requirement**: Replace every retained reference to the former three-prompt Objective workflow, `Step 1 of 3`, and `Accept, modify, or replace?` interaction in the Objective UX contract, creation workflow, Verification, and Example. Replacement MUST also remove the old creation guarantee that exposes the proposed identifier, catalog change, and resulting version before confirmation.
- The amended `highway-objectives` Example MUST illustrate adaptive conversational discovery, skip already-supported evidence, validate the complete Objective naturally, allocate the identifier only after acceptance, and report the permanent Objective identifier only after verified persistence.
- The amended Objective Interactive Workflow UX Contract MUST describe adaptive discovery, one unresolved decision at a time, `New interaction` resume behavior, and owner authority without retaining fixed three-step progress language or describing the ordered flow as Objective statement, Success Measures, and Rationale approval.
- Verification MUST confirm that the complete Objective review uses distinct user-facing presentation labels for the title, Statement, Success Measures, and Rationale sections required for validation.
- Confirmed creation follows this order: revalidate authoritative baseline and catalog state; re-evaluate overlap; return to user validation if the proposal is affected; allocate the permanent identifier; construct the mutation; persist record and catalog; verify both retained outputs; report completion.
- Verification MUST confirm that synthesized title, Statement, Success Measures, and Rationale are rendered only into the existing Objective fields and that no discovery dimensions, evidence classifications, conversation state, or synthesis metadata are persisted.
- `highway-setup` Verification MUST verify both Objective transition branches: `Objective readiness = Missing` causes the Setup-owned introduction exactly once, followed by owner delegation and the Objectives-owned opening exactly once; `Objective readiness = Complete` causes no Objective-purpose introduction and Setup proceeds to Controls readiness.
- Focused malformed-context tests MUST cover each declared Repository Context Document: Identity, Highway Vision, Highway Platform Objectives, and Profile.
- Focused suggestion tests MUST include relevant Profile evidence alongside unrelated Profile evidence and verify that every suggestion is supportable from the relevant evidence, unrelated evidence is not exposed, and no unsupported organizational fact appears.
- Focused contradictory-context tests MUST demonstrate that conflicting Highway-owned context does not override the user's stated organizational intent.
- Direct-invocation tests MUST verify that `/highway-objectives setup` and bare `/highway-objectives add` explain that the interaction identifies an outcome worth pursuing without duplicating Setup's transition language.
- Focused direct-`add` tests MUST verify that a rich Outcome, Success, and Significance answer proceeds directly to the complete Objective proposal without the standard opening or another discovery question.
- Focused cross-dimension tests MUST verify that an answer to a Success question containing both Success and Significance evidence resolves both dimensions and does not trigger a redundant Significance question.
- Focused suggestion-adoption tests MUST verify that selecting a Profile-grounded suggestion establishes only the supported Outcome evidence, after which remaining Success and Significance evidence is evaluated normally without treating explanatory suggestion text as accepted user evidence.
- The amended `highway-objectives` skill MUST retain `Resume Applicability: New interaction`. Resume verification MUST confirm that an interrupted proposed Objective and an interrupted `Anything else you'd like to accomplish?` question are not restored, persisted Objectives remain authoritative, and a later invocation begins from persisted readiness rather than transient collection state.
- Persistence-failure tests MUST verify that Objectives does not claim successful creation and names the Objective record or catalog retained output whose verification failed.
- The implementation MUST preserve the current complete-Objective review shape and acceptance semantics, keep permanent Objective identifiers out of normal pre-persistence review, keep assessment outside this feature, and preserve the expected `highway-objectives` `1.0.0` -> `2.0.0` MAJOR classification while classifying `highway-setup` independently.

### Key Entities

- **Objective Discovery Conversation**: A transient owner-controlled interaction that gathers and interprets evidence across Outcome, Success, and Significance. It has no retained identity and is never restored as an unanswered prompt, draft, or hidden checkpoint.
- **Objective Proposal**: A complete staged interpretation containing the proposed title, Statement, Success Measures, and Rationale for user validation. Identifier allocation, catalog change, and resulting version remain internal transaction state until confirmed persistence.
- **Objective Record**: The durable user-owned Markdown record under `library/objectives/OBJXXXXXX.md`, preserving the existing schema and stable identifier.
- **Objective Catalog**: The durable user-owned baseline index under `library/governance/objectives.md`, owning semantic version and `next_id` and listing records in stable identifier order.
- **Repository Context Document**: One of the four declared context sources, Identity, Vision, Platform Objectives, or Profile, which Objectives may consume when relevant and available.
- **Accepted Repository Context**: Relevant information from declared Repository Context Documents or accepted repository artifacts, including existing Business Objective records when applicable. Existing Business Objective records are not Repository Context Documents.
- **Objective Relationship**: The existing `capabilities: []` relationship field and future stable references from Capabilities to permanent Objective identifiers.

## Success Criteria

### Measurable Outcomes

- **SC-001**: In 100% of Setup-to-Objectives onboarding runs with terminal-success Profile and incomplete Objectives, the purpose introduction and owner-supplied first question appear in order before any Objective answer is collected.
- **SC-002**: In focused interaction tests, 100% of rich answers that support a Statement, at least one Success Measure, and a Rationale skip already-resolved dimensions and present no more than one unresolved question at a time.
- **SC-003**: In 100% of declined, cancelled, abandoned, or failed mutations, the authoritative baseline remains byte-identical to immediately preceding verified state, and any previously verified creations remain intact.
- **SC-004**: In 100% of confirmed creation tests, the resulting record conforms to the existing schema, uses a unique permanent six-digit `OBJ` identifier, is indexed exactly once by a deterministically regenerated catalog, and successful completion is reported only after both retained outputs pass persistence verification.
- **SC-005**: In 100% of context-availability tests, Objectives either uses relevant available context or explicitly handles missing/malformed context without adding unsupported user-owned evidence.
- **SC-006**: In 100% of multiple-Objective tests, each confirmed Objective receives its own permanent identifier and the second conversation does not restore or reuse transient state from the first.
- **SC-007**: Existing Objective readiness, read-only, destructive-action, malformed-baseline, relationship, and transaction verification tests remain passing after the conversational workflow is introduced.
- **SC-008**: Test evidence covers both owner-direct invocation and Setup-mediated invocation, with no Setup test requiring Setup to understand or reconstruct Objective record content and with Setup emitting its introduction exactly once.
- **SC-009**: In 100% of explicit suggestion tests, suggestions are Profile-grounded and remain unretained until the user adopts, modifies, or independently expresses the outcome.
- **SC-010**: In 100% of major Outcome-correction tests, incompatible staged Success or Significance evidence is removed from the active interpretation or marked unresolved before another proposal is synthesized.
- **SC-011**: Compliance Review Protocol results for amended `highway-setup` and `highway-objectives` contain no unresolved `FAIL` verdicts for applicable Constitution or Experience Standard rules.
- **SC-012**: In 100% of direct `add` tests containing usable Outcome evidence, Objectives does not repeat the standard Outcome question and instead asks only for unresolved evidence.
- **SC-013**: In 100% of accepted complete-proposal creation tests, no second persistence-confirmation question is required before the confirmed mutation transaction.
- **SC-014**: In 100% of concurrent-baseline-change tests, Objectives revalidates authoritative catalog, version, allocation, and overlap state before writing.
- **SC-015**: In 100% of interrupted second-Objective tests, the first verified Objective remains persisted while the unconfirmed second Objective leaves no record, identifier allocation, catalog change, version change, or hidden draft.
- **SC-016**: In 100% of active collection tests, the user may finish after one or more Objectives without Highway attempting exhaustive Objective discovery.
- **SC-017**: In 100% of adaptive-discovery fixtures, Objectives does not ask for a discovery dimension already supported by active workflow evidence or applicable accepted context.
- **SC-018**: In 100% of multi-Objective-input fixtures, explicitly separate Objectives are processed in user-provided order without requiring repeated outcome input.
- **SC-019**: In 100% of Objective readiness tests, a missing valid baseline returns `Missing` with `/highway-objectives setup` and `Blocking Reason: None`, a valid baseline returns `Complete` with `None` and `Blocking Reason: None`, and a malformed baseline returns `Blocked` with `None` and a non-empty `Blocking Reason`, without mutation.
- **SC-020**: In 100% of Setup runs where Profile is terminal-success and Objective readiness is already `Complete`, Setup emits no Objective-purpose introduction or Objective discovery question and proceeds to Controls readiness.
- **SC-021**: In 100% of fixtures where active user evidence conflicts with accepted Profile context, Objective interpretation follows the active workflow evidence and does not silently overwrite the user's stated intent with Profile content. For example, when Profile suggests growth is important but the user explicitly says the current Objective is about reducing operational burden, the retained interpretation follows the user's stated purpose.
- **SC-022**: In 100% of pre-write overlap-change fixtures, Objectives names the newly overlapping Objective, invalidates the previous confirmation, accepts the user's revised Objective, re-evaluates Outcome, Success, and Significance, presents a revised complete proposal for validation, and persists only after that second validation.
- **SC-023**: In 100% of grounded-suggestion fixtures, Profile contains relevant evidence and unrelated evidence; every suggestion is supportable from the relevant evidence, unrelated evidence is not exposed, and no unsupported organizational fact appears.
- **SC-024**: In 100% of contradictory-context fixtures, conflicting applicable Identity, Highway Vision, or Highway Platform Objectives guidance is resolved according to their Constitution-defined roles and ordering, and the user's stated organizational intent remains authoritative.
- **SC-025**: In 100% of direct-invocation tests for `/highway-objectives setup` and bare `/highway-objectives add`, introductory context explains that the interaction identifies an outcome worth pursuing and does not duplicate Setup's transition language.
- **SC-026**: In 100% of direct-`add` tests containing rich Outcome, Success, and Significance evidence, Objectives presents the complete Objective proposal without rendering the standard opening or another discovery question.
- **SC-027**: In 100% of cross-dimension fixtures where a Success response also supplies Significance evidence, Objectives evaluates both dimensions, does not ask a redundant Significance question, and proceeds directly to the complete proposal when Outcome is already resolved.
- **SC-028**: In 100% of suggestion-adoption fixtures, selecting a Profile-grounded possibility establishes only the Outcome evidence supported by that possibility, and remaining Success and Significance evidence is evaluated without accepting explanatory suggestion text as user evidence.
- **SC-029**: In 100% of interruption and resume fixtures, the amended skill reports `Resume Applicability: New interaction`; an interrupted proposed Objective and an interrupted `Anything else you'd like to accomplish?` question are not restored, persisted Objectives remain authoritative, and a later invocation begins from persisted readiness rather than transient collection state.

## Assumptions

- The existing Objective record and catalog templates remain authoritative for retained structure and output ordering.
- The existing Highway Experience Standard and Repository Context rules govern interaction presentation, user exits, owner outcomes, and context declarations.
- Setup can invoke or delegate to an Objectives owner action that supplies the first question and subsequent interaction results without taking over Objective semantics.
- “Outcome,” “Success,” and “Significance” are discovery dimensions, not additional retained record fields.
- Suggestions are prompts for user reflection; they are not evidence and cannot be persisted without user adoption, modification, or independent restatement. Objective discovery is intentionally separate from Objective assessment: this feature captures stable intent and Success Measures, while future assessment may compare those measures against accumulated repository evidence without persisting transient progress into the Objective record.
- Profile-grounded suggestions may use any accepted Profile-wide evidence that changes the relevance of a proposed outcome. Vision and Competitive Path are likely sources because they describe organizational direction, but suggestions do not require either source when other accepted Profile evidence supports useful guidance. If no meaningful organization-specific suggestion is supported, Objectives reports that limitation and offers generic discovery help instead of a fabricated recommendation.
- Interruption after at least one verified Objective does not make the Objective baseline incomplete. On a new Setup invocation, persisted-readiness behavior governs and Setup may advance to Controls; the user can add additional Objectives later through `highway-objectives`. No transient `Anything else you'd like to accomplish?` question or unfinished Objective draft is restored.
- Objective readiness remains `Complete` when at least one valid Objective exists with a consistent catalog and valid `next_id`; active collection may continue after readiness becomes `Complete`.
- Objective onboarding is not intended to exhaustively discover every organizational Objective. The user determines when the captured baseline is enough for the current interaction and may add Objectives later.
- The current Objective skill's replacement of its three-prompt behavioral guarantee is expected to require a MAJOR version increment; Setup is classified independently under the Skill Versioning Policy.
- The repository's current user-owned record locations remain `library/objectives/` and `library/governance/objectives.md` relative to the project root.
- No new assessment snapshot, confidence, or conversation-transcript fields are required in the durable Objective schema.
- Existing actions other than guided creation, including view, show, describe, readiness, update, remove, and reset, remain supported unless a later approved specification changes them.
- Feature implementation will use the repository's existing shell-based test and generation conventions and will not introduce external dependencies.
