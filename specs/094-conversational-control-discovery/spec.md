# Feature Specification: Conversational Control Discovery

**Feature Branch**: `094-conversational-control-discovery`

**Created**: 2026-09-25

**Status**: Draft

**Input**: User description: "Update highway-setup and highway-controls so that initial Control onboarding follows a conversational, context-aware interaction model. Setup introduces the Controls purpose; Controls owns the conversation. Replace category-driven onboarding with adaptive Concern, Condition, and Obligation discovery while preserving existing Control artifacts, ownership, readiness, persistence, safeguards, and Control-derived NFR behavior."

## User Scenarios & Testing

### User Story 1 - Controls Handoff From Setup (Priority: P1)

As a person completing Highway setup, I want Setup to explain why Controls matter and then hand me to the Controls owner, so that the transition from desired outcomes to governance safeguards feels continuous without Setup taking ownership of Control discovery.

**Why this priority**: The handoff is the contract boundary between orchestration and the new conversational owner flow. Without it, the new Controls experience cannot be reached safely through Setup.

**Independent Test**: Start Setup with fresh terminal Objective success and a non-terminal Controls readiness result. Verify the exact Setup-owned transition, the unchanged Controls-owned opening, and the absence of Control questions or writes by Setup.

**Acceptance Scenarios**:

1. **Given** Objectives has reached fresh terminal success and Controls readiness indicates that setup is required, **When** Setup delegates Controls setup, **Then** Setup emits exactly once:

   > **We've identified what you're trying to accomplish. Now let's think about what needs to be true as you pursue those outcomes.**
   >
   > Highway can use what you've already shared to help identify conditions and safeguards that should guide future decisions.

2. **Given** Setup has emitted the Controls transition, **When** Controls begins collection without usable active Control evidence, **Then** Setup renders the complete Controls-owned opening unchanged:

   > **What concerns should future technology decisions take into account?**
   >
   > For example, you might care about protecting information, controlling access, managing changes, keeping important services available, or meeting an existing obligation.
   >
   > If you'd like some suggestions based on what Highway already knows, just let me know. **If you're not sure, just say "I don't know," and we'll work through it together.**

3. **Given** Controls readiness is terminal `Complete` before Controls has been delegated in the current Setup interaction, **When** Setup advances, **Then** Setup skips both the Controls transition and Controls discovery.

4. **Given** Controls discovery is active, **When** a user answers, **Then** Setup forwards the answer and renders only the Controls-owned next question, decision, proposal, result, or error without rewriting it.

5. **Given** Controls reports failure, cancellation, interruption, or non-terminal completion, **When** Setup receives the result, **Then** Setup does not claim Controls or Setup completion and does not write or interpret Control state.

6. **Given** Setup is invoked again after an interrupted Controls interaction, **When** Setup derives progress, **Then** it reads persisted Controls readiness and does not restore transient Concern, Condition, Obligation, suggestion, proposal, or checkpoint state.

7. **Given** Controls began with readiness `Missing` and the first Control is persisted so fresh readiness would be `Complete`, **When** the user has not explicitly finished collection, **Then** Controls continues to own the interaction, immediate NFR candidate generation has completed or returned its declared result, and Setup does not advance to NFR review.

### User Story 2 - Adaptive Control Discovery (Priority: P1)

As a person defining governance, I want to describe a concern naturally and be guided only where important evidence is missing, so that I can express what should be protected or required without completing a fixed category questionnaire.

**Why this priority**: Adaptive discovery is the central user-visible change. It must produce an enforceable Control while preserving ordinary language and user ownership.

**Independent Test**: Invoke Controls with Concern-only input, Concern plus Condition input, and a complete enforceable obligation. Verify that only unresolved evidence produces a question and that complete evidence proceeds directly toward proposal.

**Acceptance Scenarios**:

1. **Given** a user supplies only a Concern and no Control-ready Obligation, **When** Controls evaluates the response, **Then** it asks one natural question about the desired Condition or the remaining evidence needed for an enforceable Control.

2. **Given** a user supplies Concern and Condition evidence but no Control-ready Obligation, **When** Controls evaluates the response, **Then** it skips redundant Concern discovery, asks a Condition question only when its answer could establish or narrow the required obligation, and otherwise asks directly for the Obligation.

3. **Given** a user supplies Concern, Condition, and an enforceable Obligation in one response, **When** Controls evaluates the response, **Then** it proceeds directly toward a complete proposal without asking generic category or dimension questions.

4. **Given** a rich answer supplies evidence across multiple dimensions, **When** Controls evaluates it, **Then** it evaluates all active evidence before selecting one next action and exposes no more than one unresolved response-demanding question or decision.

5. **Given** a user gives an activity, aspiration, outcome, quality attribute, operational characteristic, constraint, or vague condition rather than an enforceable obligation, **When** Controls evaluates it, **Then** it acknowledges the meaning and either asks one question that could make it measurable against an enforceable requirement or routes the outcome-shaped intent to `/highway-nfrs`.

6. **Given** a user uses formal Control language, **When** Controls evaluates it, **Then** Controls meets the user at that level and does not translate or simplify the language unnecessarily.

### User Story 3 - Context-Aware Guidance (Priority: P1)

As a person defining governance, I want relevant Highway knowledge to improve questions, suggestions, and explanations without becoming invented policy, so that Controls guidance reflects what the organization already knows while preserving my authority over governance content.

**Why this priority**: Context participation makes the conversational flow useful rather than generic, but incorrect context boundaries could silently create organizational policy.

**Independent Test**: Run the same interaction with relevant, irrelevant, absent, malformed, and conflicting context. Verify relevant-only use, explicit missing-context handling, active-user precedence, and no fabricated organizational facts.

**Acceptance Scenarios**:

1. **Given** declared context and accepted Business Objectives or existing Controls contain relevant evidence, **When** Controls asks a question or offers guidance, **Then** it may use that evidence to identify, prioritize, or suggest a concern, adjust explanation depth, identify overlap, or surface a relevant connection.

2. **Given** the Profile owner returns `Blocked`, **When** Controls would otherwise use Profile context, **Then** Controls preserves Profile ownership, returns `Blocked` for the Profile-dependent active action, and does not reclassify the Profile result.

3. **Given** an optional non-Profile context source is absent or malformed, **When** Controls would otherwise use it, **Then** Controls records the unavailable context, excludes it from interpretation, and continues with remaining valid evidence without inventing a replacement.

4. **Given** active user input conflicts with accepted context, **When** Controls evaluates the interaction, **Then** the active user input remains authoritative for the current Control.

5. **Given** existing accepted governance addresses a proposed concern, **When** Controls evaluates the proposal, **Then** it surfaces the existing Control or overlap before recommending redundant governance and leaves the user to decide.

6. **Given** context contains unrelated organizational information, **When** Controls provides a suggestion or acknowledgment, **Then** it does not expose or rely on the unrelated information.

### User Story 4 - Natural Proposal and Persistence (Priority: P1)

As a person reviewing a proposed Control, I want to accept or correct it conversationally before anything is written, so that the retained governance artifact reflects my intent and existing persistence safeguards remain intact.

**Why this priority**: Control creation changes durable governance. The proposal, confirmation, and persistence boundary must be explicit and trustworthy.

**Independent Test**: Produce a complete proposal, then exercise acceptance, correction, replacement, rejection, cancellation, abandonment, and persistence failure. Verify the retained Control structure, non-write exits, and completion claims.

**Acceptance Scenarios**:

1. **Given** the active evidence supports a Control-ready Obligation that can be measured against, **When** Controls presents the proposal, **Then** it shows visibly distinct `Title`, `Statement`, and `Rationale` labels plus one natural validation decision without exposing identifiers, catalog changes, versions, or transaction mechanics.

2. **Given** the user accepts the complete proposal naturally, **When** Controls persists it, **Then** it preserves the existing Control record structure, allocates one permanent identifier according to the existing contract, persists and verifies the retained outputs, and reports completion only after verification succeeds.

3. **Given** the user corrects or replaces the proposal, **When** Controls receives the correction, **Then** it re-evaluates staged Concern, Condition, and Obligation evidence, discards interpretations no longer supported by the revised intent, and presents a revised proposal or one unresolved question.

4. **Given** the user rejects, cancels, abandons, stops responding, or interrupts the proposal, **When** the interaction ends, **Then** no Control record, catalog change, identifier allocation, version change, hidden draft, or transient discovery state is written.

5. **Given** retained-output persistence or verification fails, **When** Controls reports the result, **Then** it preserves the prior verified baseline, names the unverified output, and does not claim successful creation or readiness completion.

6. **Given** an exact duplicate or decision-affecting semantic overlap appears after proposal validation but before allocation, **When** Controls revalidates the authoritative baseline, **Then** it names the overlapping Control, invalidates the prior confirmation, returns to one user decision, and requires renewed validation of the resulting proposal before persistence; unrelated overlap does not invalidate confirmation.

### User Story 5 - Durable Control Baseline and Continuation (Priority: P2)

As an organization establishing governance, I want multiple accepted Controls to remain durable and continue into relevant downstream workflows, so that conversational discovery does not weaken identifiers, catalogs, readiness, destructive safeguards, or Control-derived NFR ownership.

**Why this priority**: The new conversation must fit the existing lifecycle rather than creating a parallel or incomplete Control system.

**Independent Test**: Persist one or more Controls, inspect readiness and catalog behavior, continue with another concern, and verify that existing Add, Update, Remove, Set, Inspect, destructive-action, and Control-derived NFR contracts remain valid.

**Acceptance Scenarios**:

1. **Given** a Control is successfully persisted and verified, **When** setup/configure asks `Would you like to define another Control, ask for suggestions, or finish?`, **Then** the user may supply another concern, condition, or obligation directly, request suggestions, ask for help, or finish without a mandatory category loop.

2. **Given** multiple Controls are accepted, **When** the catalog is regenerated, **Then** permanent identifiers remain immutable and non-reusable, ordering remains deterministic, and the existing catalog contract is preserved.

3. **Given** the persisted Control baseline is valid, **When** readiness is requested, **Then** readiness is derived from persisted state and does not depend on transient discovery evidence or completion of historical categories.

4. **Given** a Control is successfully persisted and verified, **When** the established Control-derived NFR workflow applies, **Then** deterministic candidate generation has already run for that new Control, user-visible NFR review remains deferred until explicit collection finish, and discussion of Concern, Condition, or Obligation alone does not create an NFR.

5. **Given** a destructive Control action is requested, **When** the action is evaluated, **Then** existing impact-analysis and explicit-confirmation safeguards remain in force.

6. **Given** a valid persisted Control baseline exists, **When** a person directly invokes `/highway-controls configure`, **Then** Controls begins a new conversational discovery interaction using accepted Controls as context, while `/highway-setup` still skips Controls when its pre-delegation readiness is `Complete`.

7. **Given** a person directly invokes `/highway-controls add` without usable evidence, **When** Controls begins the action, **Then** it uses the direct purpose sentence and Controls opening, collects one Control, returns the existing verified Add result, and does not automatically open multi-Control continuation.

### Edge Cases

- A user directly invokes Controls without Setup and supplies no usable Control evidence; Controls emits exactly `Controls helps define enforceable safeguards for future technology decisions.` followed by the unchanged Controls-owned opening question and examples in User Story 1. It does not repeat Setup's transition. A direct invocation with an obligation evaluates that evidence first and omits both openings.
- A user directly invokes Control creation with a complete enforceable obligation; Controls skips the generic opening and evaluates supplied evidence first.
- A user says `I don't know`; Controls begins guided discovery, uses relevant accepted context when available, and does not invent a Control or treat illustrative areas as required categories.
- A user explicitly requests suggestions; Controls presents a bounded set of one to three distinct possibilities only when supported by relevant accepted context, and suggestions remain transient until adoption. With zero grounded suggestions it emits exactly `Highway does not have enough accepted context to make a useful suggestion.` and asks one exploratory question.
- A user asks for more information about a suggestion or selects an area to explore; neither action alone accepts a Control.
- A suggested Obligation is explicitly presented as a possibility for consideration; selecting its topic does not adopt its policy or make it active evidence.
- An exact existing Control that satisfies the active need is surfaced as reusable accepted governance. If the user confirms reuse, no new Control is written and the interaction returns to continuation or finish. A distinct user-stated governance intent may proceed as a new proposal.
- A user provides multiple obligations without clear grouping; Controls asks one grouping decision, preserves explicit grouping, and processes explicitly separate obligations in user-provided order.
- A user materially changes the Concern, Condition, or Obligation; obsolete staged evidence becomes unresolved rather than surviving silently.
- A user retains wording that Controls considers vague after receiving guidance; Controls preserves the user's wording and ownership.
- The four historical categories are absent, partially represented, or unevenly represented; Controls does not force category completion or expose category progress.
- Identity, Highway Vision, Highway Platform Objectives, Profile, accepted Business Objectives, or existing Controls are absent, malformed, contradictory, or irrelevant.
- A malformed Profile owner result is consumed as Profile-owned `Blocked` context and is not reclassified by Controls; Controls returns `Action Status: Blocked` for the Profile-dependent active action with a non-empty blocking reason. Other malformed or unavailable context is excluded as optional context.
- The user-owned Control baseline or catalog is absent, malformed, has unsafe allocation state, or contains an unresolved relationship.
- A new overlap appears after the user validates a proposal but before identifier allocation; prior confirmation is invalidated and renewed validation is required.
- Setup receives Controls readiness `Complete`, `Missing`, or `Blocked`; only the owner-provided fresh terminal result determines the next Setup action.
- A Control persistence, catalog regeneration, relationship update, or verification step fails after staging; the previous verified baseline remains unchanged.
- A user starts a second Control and exits before confirmation; the first accepted Control remains unchanged and no transient second Control is restored on the next Setup invocation.
- A user explicitly finishes before accepting any Control; the owner-only result is `Action Status: Succeeded`, `Collection Result: Finished`, `Created Control IDs: []`, `Next Action: /highway-controls setup`, and `Blocking Reason: No accepted Control exists.` The separate fresh Controls Readiness Result is `Missing`. The user-facing response explains that at least one Control is required before Setup can advance and invites the user to define a Control or finish. Setup remains at Controls and does not claim completion or advance to NFR review.
- A user knowingly retains vague wording after receiving classification advice; Controls marks the proposal as a transient user-overridden wording case, does not describe it as measurable, preserves the exact user-approved statement, and may persist it only after explicit acceptance. No classification field is added to the retained record.
- Existing Control relationships are limited to the retained `nfrs` identifier list; contextual connections are advisory unless an existing owner contract explicitly authorizes a writable relationship.
- A direct `/highway-controls configure` invocation may begin a new discovery interaction even when readiness is `Complete`; Setup still skips Controls when its pre-delegation readiness is `Complete`.
- A direct `/highway-controls add` with no usable evidence uses the direct purpose sentence and Controls opening; with a complete obligation it evaluates that evidence first. `add` creates one Control and returns its existing mutation result after verified persistence rather than opening an open-ended collection.
- A user pauses or exits an interaction; transient discovery and continuation state are discarded, and no wording implies that Highway will restore the unfinished interaction.

## Requirements

### Functional Requirements

- **FR-001**: After Objectives reaches fresh terminal success, Setup MUST request Controls readiness before delegating Controls discovery.
- **FR-002**: When Controls readiness indicates that setup is required, Setup MUST emit the exact Controls-purpose transition once immediately before delegating Controls setup.
- **FR-003**: Before Controls has been delegated in the current Setup interaction, terminal Controls readiness `Complete` MUST cause Setup to skip the Controls-purpose transition and Controls discovery. After delegation, Setup MUST consume the Controls action result before using fresh readiness to advance.
- **FR-004**: Setup MUST remain orchestration only and MUST NOT interpret Control evidence, ask Control discovery questions, generate or persist Controls, allocate Control identifiers, own a Control proposal, or restore transient Control state.
- **FR-005**: Setup MUST render Controls-owned questions, suggestions, acknowledgments, proposals, decisions, errors, and completion results unchanged and in owner order.
- **FR-006**: Setup MUST derive subsequent progress solely from fresh persisted owner readiness and MUST NOT restore unanswered questions, transient Concern, Condition, Obligation evidence, suggestions, proposals, or Setup checkpoints.
- **FR-006a**: Conversational Control creation MUST declare `Resume Applicability: New interaction`; a new invocation may use only persisted Controls and validated baseline state as evidence.
- **FR-007**: Controls MUST replace normal four-category onboarding with adaptive discovery across Concern, Condition, and Obligation evidence.
- **FR-008**: Concern, Condition, and Obligation MUST remain transient discovery concepts and MUST NOT become new required persisted Control fields.
- **FR-009**: Controls MUST evaluate all active evidence across Concern, Condition, and Obligation before selecting the next action and MUST expose at most one unresolved response-demanding question or decision at a time.
- **FR-009a**: Controls MUST apply this ordered next-action model: (1) resolve multiple-obligation grouping; (2) classify clearly NFR-shaped intent and route it to `/highway-nfrs`; (3) evaluate all supplied Concern, Condition, and Obligation evidence; (4) if an Obligation is already Control-ready, present the normal proposal; (5) otherwise, if Concern is unresolved, ask one Concern question; (6) otherwise, if resolving Condition can establish or materially narrow the required Obligation, ask one Condition question; (7) otherwise, ask directly for the Obligation; (8) after advice, support the explicit user-override branch in FR-009c.
- **FR-009b**: Controls MUST make multiple-obligation grouping step zero before any single-Control dimension evaluation; unclear grouping receives one grouping decision, while explicitly separate obligations are processed in user-provided order.
- **FR-009c**: When intent could reasonably become either an NFR or a Control, Controls MUST acknowledge the ambiguity and ask one bounded classification question. An explicit NFR choice routes to `/highway-nfrs`; an explicit Control choice continues adaptive discovery; no implicit choice is allowed.
- **FR-010**: Active user evidence MAY satisfy Concern, Condition, and Obligation. An existing accepted Control MAY satisfy or reuse an Obligation. Other contextual sources MAY guide identification, prioritization, explanation, suggestions, overlap, or reuse, but MUST NOT silently establish organizational Condition or Obligation policy unless that content is already accepted governance or the user adopts, restates, or modifies it.
- **FR-010a**: Evidence is Concern-ready when the user states an area, risk, decision, or matter that could govern a future technology decision; Condition-ready when the user states a desired state or boundary and that detail could change the obligation; Obligation-ready when the user states, adopts, or reuses an obligation that can be measured against. Specificity, testability, auditability, and enforceability are supporting evidence for that single measurable-against boundary, not independent alternative gates.
- **FR-010b**: A normal proposal MUST be Control-ready when its Title, Statement, and Rationale are supported by active user evidence or accepted governance and its Statement is an obligation that can be measured against, meaning it is clear enough to check whether it is being followed. It MUST NOT require all three discovery dimensions to be explicitly represented; it does not infer or synthesize Concern or Condition merely to complete an internal model once the Obligation is Control-ready.
- **FR-011**: Controls MUST proceed toward a proposal when a user supplies an Obligation that can be measured against without requiring the normal opening or all conceptual dimensions to be asked separately.
- **FR-011a**: Controls MUST emit the exact Controls-owned opening in User Story 1 only when Setup introduced the purpose and no usable active Control evidence was supplied. Direct invocation without usable evidence MUST emit the exact purpose sentence in the edge case followed by that same Controls-owned opening; it MUST NOT repeat the Setup transition. Direct invocation with an Obligation evaluates it first.
- **FR-012**: Controls MUST support ordinary business language, uncertainty, activity descriptions, formal governance terminology, natural correction, refinement, replacement, acceptance, rejection, cancellation, and abandonment without requiring workflow-command vocabulary.
- **FR-013**: Controls MUST declare and evaluate these Repository Context participation roles before context-dependent output: Identity supplies behavioral framing; Vision supplies strategic and traceability framing; Platform Objectives evaluate Highway assistance; Profile supplies accepted organizational context; Business Objectives supply accepted business-outcome context; existing Controls supply accepted governance, overlap, and reuse evidence.
- **FR-014**: Repository Context Documents MUST mean exactly Identity, Vision, Platform Objectives, and Profile. Accepted Business Objectives and existing Controls are accepted repository artifacts that may participate as context but are not Repository Context Documents.
- **FR-015**: Context MAY identify, prioritize, or suggest a concern and MAY adjust explanation, question selection, overlap, or relevant-connection guidance; it MUST NOT choose organizational policy, add a new Control, create a new persisted relationship, or become active evidence without user adoption or existing accepted governance.
- **FR-016**: Controls MUST consume Profile's owner-provided readiness/result. An owner-confirmed malformed or `Blocked` Profile is excluded from Profile context and remains Profile-owned `Blocked`; Controls MUST NOT validate or reclassify Profile and MUST return `Action Status: Blocked` with a non-empty blocking reason for the Profile-dependent active action. Other unavailable or malformed context MUST be recorded, excluded, and handled as unavailable optional context; a complete direct obligation is not blocked by absent optional Profile context.
- **FR-017**: Active user input MUST remain authoritative when it conflicts with accepted contextual guidance.
- **FR-018**: When `I don't know` or equivalent uncertainty is supplied, Controls MUST begin guided discovery without inventing a Control or presenting generic examples as required categories.
- **FR-019**: When the user explicitly requests suggestions, Controls MUST present a bounded set of one to three distinct possibilities only when supported by relevant accepted context; unsupported suggestions MUST NOT be added merely to reach three.
- **FR-019a**: Suggestions MAY name a possible Concern, Condition, Safeguard, Requirement, Constraint, or Obligation, but every item MUST be labeled as a possibility for consideration. With zero grounded suggestions, Controls MUST emit exactly `Highway does not have enough accepted context to make a useful suggestion.` and ask one exploratory question. Selecting a suggested Obligation's topic MUST NOT adopt its policy or make it active evidence.
- **FR-020**: Suggestions MUST remain transient guidance until the user clearly adopts, restates, or modifies the content; asking for more information or selecting an area to explore MUST NOT alone constitute adoption.
- **FR-020a**: Condition, Safeguard, Requirement, and Constraint are conversational vocabulary only. They MUST NOT become additional state machines, enums, persisted types, or mandatory evidence dimensions. Conversational use of `Constraint` MUST NOT change the existing Control-versus-NFR classification boundary.
- **FR-020b**: If the resulting intent remains an outcome, quality attribute, operational characteristic, constraint, or business outcome rather than an enforceable implementation requirement, Controls MUST preserve routing to `/highway-nfrs`.
- **FR-021**: Controls MUST prefer surfacing an existing relevant or overlapping Control over silently recommending redundant governance. If an existing Control satisfies the active need and the user confirms reuse, Controls MUST write no new record, allocate no identifier, increment no version, modify no existing Control, and return the interaction to continuation or finish.
- **FR-022**: Controls MUST provide one concise Contextual Acknowledgment only when information has Material Influence: it changes a recommendation, workflow action, governance interpretation, decision support, relevant-connection guidance, or generated artifact outcome.
- **FR-023**: Controls MUST use Decision Context when the requested answer affects a downstream recommendation, governance interpretation, proposal, relevant connection, or workflow action, and MAY omit it when that implication was established immediately before the prompt; it MUST NOT repeat the Setup transition on every follow-up.
- **FR-024**: Controls MUST provide concise relevant examples when they clarify the kind of response sought, adapt them to active evidence, and ensure examples illustrate form without constraining user-owned content.
- **FR-025**: Controls MUST present the user-facing proposal with this interaction framing first: `Next Action: Review this proposed Control and accept, correct, replace, or reject it.` It MUST then show visibly distinct human-facing sections for the proposed title, statement, and rationale. `Next Action` is interaction framing, not a retained Control field. Highway MAY derive a deterministic transient title and synthesize rationale from evidence/context, but both become user-approved values only through natural proposal acceptance. Rationale may explain why the Control matters but MUST NOT add a new organizational fact, obligation, or unstated policy. Concern need not survive as a separate field.
- **FR-025a**: The retained artifact names remain `title`, `statement`, and `rationale`; conversational wording such as "obligation statement" MUST NOT create a new persisted field. Generated titles MUST not depend on timestamps, randomness, environment values, filesystem order, or session state.
- **FR-025b**: A user-override proposal is a separate proposal route. After non-Control-ready wording, Controls MUST provide classification guidance and one concrete refinement opportunity; if the user explicitly retains the original wording, Controls MAY present the exact user-approved Statement for acceptance, MUST mark the route only as transient user-overridden interaction state, and MUST NOT describe the Statement as measurable or as satisfying the normal Obligation-ready criterion. The proposal's rationale MUST not imply normal Control-quality sufficiency.
- **FR-026**: Normal pre-persistence proposal review MUST NOT expose identifier allocation, catalog changes, baseline versions, transaction mechanics, or unsupported derivation details.
- **FR-027**: Natural acceptance of the complete proposal MAY authorize non-destructive creation without a redundant second persistence-confirmation question, subject to existing interaction and transaction contracts.
- **FR-028**: Natural correction or replacement MUST re-evaluate staged Concern, Condition, and Obligation evidence and discard interpretations that no longer support the revised intent.
- **FR-029**: Natural rejection, cancellation, abandonment, interruption, malformed input, or failed validation MUST leave the proposal transient and MUST NOT write retained or hidden transient state.
- **FR-030**: Before identifier allocation or retained writes, Controls MUST revalidate the authoritative Control baseline, catalog, allocation state, and final-proposal overlap.
- **FR-031**: If revalidation discovers an exact duplicate or a semantic overlap that changes the proposal decision, Controls MUST name the overlapping Control, invalidate prior creation confirmation, return to one user decision, re-evaluate changed evidence, present the resulting complete proposal again when needed, and require renewed validation before persistence. Unrelated overlap MUST NOT invalidate confirmation.
- **FR-031a**: An exact duplicate MUST be named and no duplicate created unless the user establishes distinct intent. Semantic overlap MUST be named as advisory guidance while allowing a distinct Control to continue.
- **FR-032**: Controls MUST preserve the existing retained Control structure, including permanent `CTLXXXXXX` identifier, user-approved title, active status, `nfrs` relationship list, statement, and rationale.
- **FR-033**: Controls MUST preserve existing identifier immutability and non-reuse, catalog determinism, relationship behavior, readiness ownership, version semantics, and transactional persistence unless explicitly changed by this feature.
- **FR-034**: Controls MUST verify all retained outputs before claiming successful creation, identify any unverified record or catalog output on failure, and preserve the prior verified baseline byte-for-byte. Record creation, catalog regeneration, allocation/version mutation, and covered relationship changes MUST be one validated transaction per accepted Control.
- **FR-035**: Controls readiness MUST derive exactly from valid persisted Control state: at least one valid Control with a consistent baseline is `Complete`; no valid Control is `Missing`; malformed or inconsistent state is `Blocked`. Historical categories, discovery dimensions, and inferred governance completeness MUST NOT affect readiness.
- **FR-036**: Setup MUST consume the delegated Controls action result first, verify the result shape and terminal success, then request fresh Controls readiness. Before delegation, `Complete` skips Controls; after delegation, readiness alone MUST NOT imply that an active Controls conversation has terminated. Setup MUST advance only from the consumed successful action result and its fresh readiness.
- **FR-036a**: `Finished` MUST be a Controls-specific collection field, not a shared Owner Outcome. A setup/configure collection action result MUST use exactly these owner-only fields in this order: `Action Status: Succeeded|Declined|Aborted|Blocked`, `Collection Result: Continue|Finished`, `Created Control IDs: [CTL...]`, and `Next Action: ...`; it MUST include cumulative IDs for every successful collection result, including `[]` for zero creation. `Continue` is returned after a verified new Control when the collection remains active and is consumed by Setup as explicitly non-terminal. `Finished` is returned only after explicit user finish. User-visible text uses natural continuation or finish wording and does not expose these status labels unless the existing owner contract requires machine-readable output. Direct `add` returns its existing mutation result and is not a collection action. Setup consumes the collection result only after successful delegated action completion, then requests separate fresh readiness.
- **FR-036b**: `Created Control IDs` means immutable identifiers allocated by successful, persistence-verified new Control creations in the current active interaction, in creation order, excluding reused, updated, rejected, failed, and pre-existing Controls. Reuse does not add an ID and does not trigger candidate generation.
- **FR-036c**: Controls action results and Controls readiness results are distinct contracts. Readiness remains the existing exact four-field response and reports persisted-baseline state only. Collection action results do not use readiness `Status`; Setup MUST NOT interpret a collection result as readiness or infer collection completion from readiness.
- **FR-036d**: For a setup/configure collection, `Action Status: Succeeded` means the delegated collection action completed its current owner step; `Declined` means the user declined the offered action without a write; `Aborted` means the user exited or interrupted without a write; and `Blocked` means the owner could not safely complete the step and MUST include a non-empty reason. `Continue` is non-terminal; `Finished` is terminal only when explicitly requested. Every result retains the exact field order from FR-036a, with `Created Control IDs: []` when no new Control was created.
- **FR-037**: After each accepted Control is atomically persisted and all retained outputs verify, Controls MUST immediately invoke deterministic NFR candidate generation from that verified Control's normalized title and statement. Candidate generation failure MUST leave the valid Control and its catalog transaction intact, return the declared blocked downstream result, and write no partial NFR relationship. User-visible NFR candidate review remains deferred until setup/configure returns `Collection Result: Finished`.
- **FR-037a**: Controls owns deterministic initial candidate derivation from each verified new Control; the canonical NFR contract owns candidate classification/review decisions and accepted NFR persistence. Candidate-generation readiness is authoritative from the canonical NFR candidate-generation state, including zero candidates and candidates with none accepted. The dependent Controls/NFR contract reconciliation MUST be completed before implementation claims completion and MUST version every changed contract together.
- **FR-037b**: Every successfully persisted new Control MUST reach deterministic candidate classification exactly once from the owner workflow's perspective, regardless of whether the surrounding setup/configure collection later finishes, pauses, aborts, or is interrupted. Discovery resume remains `New interaction`; persisted-Control downstream processing is not discarded or restored as conversational state.
- **FR-038**: Existing Add, Update, Remove, Set, Inspect, Readiness, destructive-action, relationship, catalog, and Control-derived NFR contracts MUST remain valid where not explicitly superseded by this feature. Persisted Control relationships remain limited to identifier-only `nfrs` entries; no Objective-to-Control or other new relationship is created.
- **FR-039**: Setup/configure MUST support post-creation continuation with a direct new concern, condition, or obligation, suggestions, guided help, or explicit finish without restarting a mandatory category loop. Direct `add` creates one Control and terminates after its existing verified mutation result.
- **FR-039a**: After the continuation prompt, an affirmative response without new evidence MUST ask one broad concern question; supplied Concern, Condition, or Obligation MUST begin evaluation immediately; a suggestion request MUST use FR-019; uncertainty MUST use FR-018; and explicit finish MUST produce the FR-036a collection result.
- **FR-040**: Controls MUST preserve explicit grouping of multiple obligations, ask one grouping decision when grouping is unclear, and process explicitly separate obligations in user-provided order.
- **FR-040a**: Initial setup MAY finish after at least one valid persisted Control when the user explicitly indicates they are finished; no exhaustive governance baseline or historical category coverage is mandatory.
- **FR-040b**: If the user explicitly finishes with zero accepted Controls, Controls MUST return a successful collection result with `Collection Result: Finished` and `Created Control IDs: []`; the separate fresh Controls Readiness Result remains `Missing`, and Setup MUST remain at Controls without claiming completion; no "no baseline applicable" state is introduced.
- **FR-041**: Controls MUST remove `Step`, `Category`, `Completed Categories`, and `Current Category` as mandatory guided-collection reporting. Adaptive discovery MUST report no long-running progress unless a later proposal or NFR review phase has meaningful ordered work.
- **FR-041a**: The implementation plan MUST classify Controls, Setup, and any changed NFR candidate-review contract under the Skill Versioning Policy because this feature redefines onboarding, review/write, resume, orchestration, or candidate-timing contracts; the default classification is MAJOR unless governance review records a different justified result.
- **FR-041b**: `setup` and `configure` MUST remain aliases for direct Controls conversational discovery. A valid baseline MUST NOT prevent direct Controls continuation, but Setup MUST invoke initial Controls discovery only when pre-delegation readiness is non-terminal; later user-initiated `configure` or `add` activity is not Setup orchestration.
- **FR-041c**: Controls MUST define a deterministic action-selection table covering `setup`, `configure`, `add`, `readiness`, inspection, `update`, `remove`, and `set`. The feature retains `add` as the direct creation vocabulary and does not add `new` unless a separately versioned contract explicitly does so.
- **FR-041d**: The new setup/configure path MUST remove or rewrite the old Security -> Availability and Resilience -> Operational -> Compliance and Governance collection and batch `Review Complete` contract. No identical new-setup input may select both legacy batch onboarding and conversational discovery; old batch behavior may remain only under an explicitly named non-setup action.
- **FR-041e**: Controls MUST preserve separate target resolution and impact-confirmation behavior for Update, Remove, and Set; adaptive discovery MUST NOT be applied to those mutations unless their own action contract explicitly requires it.
- **FR-041f**: Compliance review MUST evaluate each applicable rule by workflow phase (adaptive discovery, proposal validation, destructive action, read-only readiness, and NFR review). Each applicable rule receives exactly `PASS`, `FAIL`, or `N/A` with evidence; human-review items appear separately in the `DEFERRED` block. Release requires zero `FAIL` and no unresolved `DEFERRED` entries.
- **FR-041g**: Setup Outputs and Verification MUST declare and test the Controls-purpose transition, exact Controls opening, delegated-action consumption, `Collection Result: Finished`, fresh-readiness sequencing, explicit-finish behavior, and false-completion failure path.
- **FR-041h**: The feature MUST reconcile the Controls and NFR canonical contracts, including candidate-generation timing, candidate-review ownership, readiness input, output shape, and version impact, before implementation claims completion.
- **FR-041i**: Adaptive discovery MUST NOT expose Concern, Condition, or Obligation as progress labels or statuses such as `Concern: Complete`, `Condition: In Progress`, or `Obligation: Missing`.
- **FR-041j**: Applying context MUST NOT create an additional question solely to acknowledge, load, or apply that context when active evidence already satisfies the relevant decision criteria.
- **FR-042**: Explanation depth and terminology MAY adapt to supplied or accepted evidence, but Controls MUST NOT infer or persist a persona, maturity tier, organizational class, or advisory class.
- **FR-042a**: When multiple context sources provide relevant evidence, Controls MUST use this deterministic priority for policy interpretation and question selection: active user input, accepted existing Controls, accepted Profile, accepted Business Objectives, then Identity/Vision/Platform Objectives framing. Lower-priority context may refine explanation or suggestions but MUST NOT override higher-priority evidence.
- **FR-042b**: A relevant connection is an advisory contextual association surfaced during conversation. A relationship is an identifier-backed persisted linkage authorized by an owning artifact contract. This feature MAY surface relevant connections but MUST create no new relationship type.
- **FR-042c**: Each accepted conversational Control is one existing Add transaction and increments the baseline version by the existing Add MINOR semantics. Creating two Controls produces two such increments; abandoning a subsequent proposal produces no identifier allocation and no version increment.
- **FR-042d**: Post-persistence action output MAY expose the allocated identifier and resulting version according to the existing mutation contract; pre-persistence proposal output MUST continue to hide them. `Created Control IDs` is machine-consumable owner output and is not routine conversational presentation.
- **FR-042e**: If immediate candidate generation returns `Blocked`, the verified Control remains valid and Setup/configure MUST NOT advance through NFR review or claim downstream completion. The NFR owner MUST expose the blocked readiness/result with a non-empty reason, and no partial NFR relationship may be written. If generation returns zero candidates, the NFR owner MUST use its existing zero-candidate / Not Applicable path without fabricating a review stage.
- **FR-042f**: Setup MUST route Controls readiness `Missing` to `/highway-controls setup`; `setup` and `configure` remain direct aliases, but Setup uses the single declared `setup` route.
- **FR-042g**: Direct Controls invocation MUST tolerate absent Profile or Objectives when the user supplies a complete obligation; these sources improve guidance when available but are not mandatory direct-creation prerequisites unless their owning contracts explicitly declare a dependency.
- **FR-042h**: The implementation MUST declare every context document and accepted artifact path read by Controls in its Inputs contract, and the amended Controls workflow MUST use numbered discovery, proposal, persistence, candidate-generation, and error-handling steps.
- **FR-042i**: The scope of this feature is conversational Controls handoff, adaptive discovery, context participation, per-Control proposal/persistence, continuation/finish, and readiness/completion integrity. NFR timing changes are limited to the immediate candidate-generation and deferred-review behavior required to prevent loss after interruption; broader NFR lifecycle redesign is out of scope.
- **FR-042j**: Interaction state consists of Concern, Condition, Obligation, suggestions, proposal wording, continuation state, and collection provenance. Repository state consists of accepted Control records, catalog/allocation state, and authorized relationships. No interaction state survives a `New interaction` unless a separate persisted owner contract explicitly promotes it.
- **FR-042k**: Control creation completes only after retained outputs verify; collection finishes only by explicit user intent; Controls readiness becomes `Complete` only from verified persisted baseline state; and Setup advances only after both the delegated collection result and fresh owner readiness permit it.

### Controls Action Selection and Output Contract

Controls MUST evaluate action requests in this order:

| Request evidence | Action |
|---|---|
| Explicitly requests `readiness` or asks whether the baseline is ready | `readiness` |
| Explicitly requests `view`, `show`, `describe`, or `inspect` | inspection |
| Explicitly requests `update` and names an existing Control | `update` |
| Explicitly requests `remove` or `delete` and names an existing Control | `remove` |
| Explicitly requests `set` or `replace` of the whole baseline | `set` |
| Explicitly requests `setup` or `configure` | conversational discovery |
| Explicitly requests `add`, or supplies a new Control obligation without another action | conversational discovery for one new Control |
| Otherwise | abort and ask which supported action is intended |

The direct-creation vocabulary remains `add`; `new` is not a supported alias in this feature. `setup` and
`configure` open a multi-Control collection; `add` opens one-Control creation and returns after that
Control's verified mutation result.
Update, Remove, and Set use their existing target-resolution, impact-analysis, confirmation, and
transaction contracts and do not enter adaptive discovery.

For an accepted Control in setup/configure, the Controls collection action result MUST report the
following owner-only fields exactly; these fields are not routine user-facing prose:

```text
Action Status: Succeeded
Collection Result: Continue or Finished
Created Control IDs: [CTLXXXXXX, ...]
Next Action: ...
```

`Collection Result: Finished` is Controls-owned workflow state, not a shared Owner Outcome. Setup
consumes it only after the delegated action returns successfully, then requests fresh readiness.

The implementation MUST update the canonical Setup Outputs and Verification contract with the
Controls transition, exact opening, delegated-result sequence, explicit finish, and false-completion
failure fixture. It MUST update Controls Usage, Examples, Outputs, Interactive Workflow UX Contract,
and Verification so no legacy setup text contradicts this action or output contract.

### Key Entities

- **Control Discovery Evidence**: Transient Concern, Condition, and Obligation interpretations used to decide what remains unresolved; never a replacement for retained Control fields.
- **Control Proposal**: A complete staged title, statement, and rationale presented for natural user validation before persistence.
- **Durable Control Record**: The existing retained governance artifact with permanent identifier, title, status, NFR relationships, statement, and rationale.
- **Control Catalog and Baseline**: The authoritative persisted collection and allocation/version state used for readiness, identifier behavior, ordering, and transactions.
- **Repository Context**: The broad accepted context available to a workflow, including the four declared Repository Context Documents and accepted repository artifacts. Business Objectives and existing Controls participate as accepted artifacts, not as Repository Context Documents.
- **Controls Action Result**: The owner-only result from delegated setup/configure collection, including action status, collection result, cumulative newly created IDs, and next action.
- **Controls Readiness Result**: The separate exact four-field persisted-baseline result used after Controls delegation to determine whether the baseline is `Complete`, `Missing`, or `Blocked`.
- **Control-Derived NFR Candidate**: A downstream governance candidate that may be considered only after successful Control persistence and verification under the existing contract.
- **Collection Result**: `Finished` means the user explicitly ended Control discovery; `Complete` means the persisted Control baseline is valid. These states are never interchangeable.
- **Collection Provenance**: The ordered `Created Control IDs` returned only within the active Controls interaction; it is not persisted, restored, or used by a new invocation.
- **Relevant Connection**: An advisory contextual association surfaced during conversation, distinct from a persisted identifier-backed relationship.

## Success Criteria

### Measurable Outcomes

- **SC-001**: In 100% of Setup handoff tests with pre-delegation non-terminal Controls readiness, the exact Controls-purpose transition appears once immediately before the unchanged Controls-owned opening; pre-delegation `Complete` skips both, while post-delegation completion consumes the action result before fresh readiness.
- **SC-002**: In 100% of adaptive discovery fixtures, Controls evaluates Concern, Condition, and Obligation evidence before choosing the next action and exposes no more than one unresolved response-demanding question or decision.
- **SC-003**: In 100% of complete-obligation fixtures, Controls proceeds toward a proposal without requiring the user to answer a fixed category sequence or provide one Control for each historical category.
- **SC-004**: In 100% of context fixtures, relevant accepted context may influence guidance while an owner-confirmed malformed/Blocked Profile is excluded without Controls reclassification, other unavailable/malformed context is excluded as optional, and active user input remains authoritative without fabricated facts.
- **SC-005**: In 100% of explicit suggestion requests, Controls presents no more than three distinct possibilities, does not pad unsupported results, and does not persist a suggestion before clear user adoption and complete proposal validation.
- **SC-006**: In 100% of correction fixtures, incompatible staged Concern, Condition, and Obligation interpretations are discarded and the workflow either presents a revised proposal or asks one unresolved question.
- **SC-007**: In 100% of late exact-duplicate or decision-changing semantic-overlap fixtures, the overlapping Control is named, prior confirmation is invalidated, and persistence occurs only after renewed resolution and proposal validation; unrelated overlap does not invalidate confirmation.
- **SC-008**: In 100% of declined, cancelled, interrupted, abandoned, malformed, and failed-persistence fixtures, retained Control bytes, catalog state, identifiers, versions, readiness, and transient state remain unchanged from the prior verified baseline; abandoning Control N+1 preserves Controls 1..N and writes zero bytes for N+1.
- **SC-009**: In 100% of successful creation fixtures, the existing Control record structure, identifier behavior, catalog behavior, relationship shape, persistence verification, and completion result remain valid.
- **SC-010**: In 100% of downstream fixtures, deterministic NFR candidate generation begins immediately after successful Control persistence and verification, user-visible NFR review begins only after explicit collection finish, and Setup advances only from a fresh terminal Controls owner result plus readiness.
- **SC-011**: The compliance review evaluates applicable P11, P12, X1.6, and X2.2-X2.10 rules by workflow phase, assigns exactly PASS, FAIL, or N/A with evidence, lists human-review rules in the DEFERRED block, and releases only with zero FAIL and no unresolved DEFERRED entries.
- **SC-012**: In 100% of repeat Setup invocations after interrupted discovery, progress is derived from persisted Controls readiness and no transient question, proposal, suggestion, or discovery evidence is restored.
- **SC-013**: Four organizational-language fixtures (ordinary business, technically sophisticated small team, risk/compliance-aware mid-sized organization, and formal enterprise) express their own governance intent naturally with evidence-appropriate explanation depth and vocabulary, without assumed organizational roles or unnecessary simplification.
- **SC-014**: In 100% of context-rich fixtures where active input plus accepted context already supports a Control-ready obligation, Controls asks no ceremonial question solely to acknowledge context, historical categories, or the discovery dimensions.
- **SC-015**: The North Star fixture completes Profile -> Objectives -> Setup transition -> context-aware discovery -> refinement -> obligation -> natural acceptance -> verified persistence -> explicit finish -> fresh readiness -> Setup continuation while preserving continuous conversation, ownership, identifiers, context boundaries, and no false completion.
- **SC-016**: The final proposal labels title, statement, and rationale as visibly distinct structured values in 100% of presentation fixtures, and relevant examples are shown not to constrain user-owned content.
- **SC-017**: In 100% of reuse fixtures, an adopted existing Control satisfies the active need without a new identifier, record, relationship, version increment, or baseline mutation.
- **SC-018**: In 100% of first-Control continuation fixtures, Controls collects Control 2 after Control 1 makes readiness `Complete`, and Setup does not advance until the delegated result reports `Collection Result: Finished`.
- **SC-019**: In 100% of interrupted and completed collection fixtures, every newly persisted Control has exactly one deterministic candidate-classification result available to NFR readiness; deferred review uses durable candidate-generation state and does not depend on restored Created Control IDs.
- **SC-020**: 100% of adaptive-discovery fixtures expose no historical category or Concern/Condition/Obligation progress label as required user-visible progress.
- **SC-021**: A mature enterprise-language fixture reaches proposal with fewer questions than an equivalent sparse-evidence fixture, while an ordinary-language fixture reaches a precise retained Statement without requiring governance jargon.
- **SC-022**: Identical active evidence and accepted context produce identical staged Title, Statement, and Rationale unless the user supplied or changed wording.
- **SC-023**: A Control write or verification failure produces neither a successful Controls completion claim nor a Setup completion claim, even when a stale or malformed transcript says `Controls: Complete`.
- **SC-024**: In 100% of vague-wording override fixtures, Controls advises first, offers one refinement opportunity, permits explicit retention, persists the exact approved Statement only after acceptance, adds no classification field, and never describes a non-measurable override as measurable.
- **SC-025**: In 100% of candidate-generation failure fixtures, the valid Control remains persisted, no partial NFR relationship is written, NFR readiness is `Blocked` with a reason, and Setup does not advance through NFR review.
- **SC-026**: In 100% of multi-Control version fixtures, each accepted conversational Control produces one existing Add MINOR increment, while an abandoned next proposal consumes neither an identifier nor a version increment.
- **SC-027**: In 100% of direct-action fixtures, `configure` can continue with a valid baseline, `add` creates one Control and terminates, and a complete direct obligation succeeds without Profile or Objectives when those are absent optional context.

## Assumptions

- The existing Control record, catalog, identifier, relationship, readiness, transaction, destructive-action, and Control-derived NFR contracts remain authoritative unless a requirement above explicitly changes their user-facing onboarding behavior.
- Conversational setup explicitly supersedes the old batch Control Review/write boundary for its path; each accepted Control remains one atomic Add transaction, candidate generation follows verified persistence immediately, and NFR candidate review is deferred until explicit collection finish.
- The existing Setup-to-Objectives handoff pattern is the model for the Setup-to-Controls handoff; Setup remains an orchestrator and Controls remains the owner of Control content and persistence.
- Identity, Highway Vision, Highway Platform Objectives, and Profile are the declared Repository Context Documents for Controls; accepted Business Objectives and existing Controls are additional relevant governance context, not replacements for those declarations.
- Concern, Condition, and Obligation are transient reasoning dimensions and do not require schema migration or new retained fields.
- Historical category names may remain available for internal analysis, coverage, or gap detection, but they are not user-facing onboarding steps or completion requirements.
- `setup` and `configure` are aliases for the same flow even when a valid baseline exists; valid persisted Controls provide evidence and do not prohibit adding another Control.
- Controls consumes a malformed owner-level Profile as the Profile owner's `Blocked` result; unavailable optional context is excluded and does not block otherwise valid discovery.
- Existing validation and persistence tooling can be extended with focused contract and executable fixture coverage without introducing a runtime conversation engine.
- User-owned governance language takes precedence over Highway recommendations when the user knowingly retains wording that Highway considers incomplete or vague.
- The feature is complete only when generated distributed artifacts and focused/full verification remain in correspondence with the source skills.
- Candidate review timing is intentionally deferred until `Finished`; candidate derivation occurs once after each successfully persisted Control, and no candidate becomes an NFR without NFR-owner review.
- The feature plan must classify version changes and keep one authoritative requirement-to-test correspondence map rather than relying on duplicated prose.
- Candidate-generation readiness is authoritative from the canonical NFR owner state, including zero candidates, candidates with none accepted, accepted artifacts, and blocked generation; transient `Created Control IDs` are provenance for the active result only and are never required for recovery.
- The existing user-owned wording policy remains: after advice, a user may explicitly accept vague wording. Such wording is transiently marked user-overridden, is not described as measurable, and is persisted only as the exact user-approved `statement` without a new classification field.
- The compliance matrix evaluates applicability per workflow phase. P12.1-P12.4 are N/A when their N6 retained-output condition does not apply, P12.5 is evaluated only when its orchestration trigger applies, and X2.5-X2.6 are N/A under N5 when no meaningful long-running activity exists.
- Feature invariant: Repository context may determine what Highway should explore or recommend; only accepted governance or active user adoption may determine what the organization requires; only verified persisted Controls determine Control readiness.
- Interaction-state invariant: Concern, Condition, Obligation, suggestions, proposal wording, continuation state, and collection provenance are interaction state. Accepted Control records, catalog/allocation state, and authorized relationships are repository state. No interaction state survives a `New interaction` unless a separate persisted owner contract explicitly promotes it.
- Completion invariant: Control creation completes only after retained outputs verify; Control collection finishes only by explicit user intent; Controls readiness becomes `Complete` only from verified persisted baseline state; Setup advances only after both the delegated collection result and fresh owner readiness permit it.
