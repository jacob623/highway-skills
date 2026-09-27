# Feature Specification: Highway NFR Setup Experience

**Feature Branch**: `096-nfr-setup-experience`

**Created**: 2026-09-27

**Status**: Draft

**Input**: User description: "Update highway-nfrs so Setup presents Control-derived NFRs as contextual Highway recommendations, then always gives the user an opportunity to define additional NFRs through natural conversation while preserving NFR ownership, persistence, readiness, and completion semantics."

## Clarifications

### Session 2026-09-27

- Q: Should active NFR `setup`/`configure` expose collection continuation and explicit finish as a separate owner-only result contract, distinct from the existing four-field readiness result? -> A: Use a separate NFR collection result with `Continue`/`Finished`; keep readiness unchanged.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Contextual Control-Derived Recommendations (Priority: P1)

As a person completing Setup, I want Control-derived NFRs presented as relevant recommendations rather than internal artifacts, so that I can decide what operational expectations matter without needing to understand Highway's candidate machinery.

**Why this priority**: Derived NFR review is the existing entry point into NFR work and must become understandable without weakening durable candidate ownership or recovery.

**Independent Test**: Run NFR setup with zero, one, and multiple persisted Control-derived candidates. Verify one unresolved recommendation at a time, contextual wording, dynamic descriptors, preserved decision order, and unchanged durable candidate state.

**Acceptance Scenarios**:

1. **Given** an unresolved Control-derived candidate, **When** NFR setup presents it, **Then** it says `Based on your [Control subject] [descriptor], Highway recommends:`, shows the NFR statement and user-relevant rationale, and asks whether to accept, change, replace, or skip it.
2. **Given** a Control's accepted evidence naturally represents requirements, safeguards, obligations, constraints, or conditions, **When** the recommendation is presented, **Then** NFRs selects the fitting descriptor and uses `requirements` when no better descriptor is supported.
3. **Given** a candidate review is active, **When** the user has not decided the current candidate, **Then** NFRs presents no second candidate and does not begin open NFR discovery.
4. **Given** candidate review resumes after interruption, **When** NFR setup starts again, **Then** it continues from durable candidate state in stable order and does not regenerate or reclassify already classified candidates.
5. **Given** routine recommendation output is shown, **When** the user reads it, **Then** Control identifiers, Control titles, candidate titles, candidate-generation language, and internal candidate-state language are omitted unless needed for an explicit error or recovery explanation.

### User Story 2 - Open Conversational NFR Discovery (Priority: P1)

As a person establishing governance, I want Setup to continue from derived recommendations into an open conversation about qualities and operational expectations, so that Control-derived suggestions do not limit the NFRs I can define.

**Why this priority**: The central value of the feature is ensuring that the user's own NFR concerns are collected after, or instead of, derived candidates.

**Independent Test**: Complete candidate review and exercise direct statements, partial statements, multiple dimensions, corrections, suggestions, uncertainty, and explicit finish. Verify adaptive questioning, no more than one unresolved question, and continuation after each accepted NFR.

**Acceptance Scenarios**:

1. **Given** all derived candidates have been decisioned and the review boundary succeeds, **When** Setup begins open discovery, **Then** NFRs asks the specified broad question about qualities or operational expectations and invites suggestions when requested.
2. **Given** zero Control-derived candidates exist, **When** NFR setup begins, **Then** it starts with the same broad discovery question rather than treating zero candidates as completion.
3. **Given** the user supplies precise NFR language, ordinary language, partial evidence, or multiple relevant dimensions, **When** NFRs evaluates it, **Then** it evaluates the supplied evidence before asking another question and exposes at most one unresolved response-demanding question or decision.
4. **Given** the user says `I don't know`, **When** NFRs evaluates the response, **Then** it starts guided discovery with one helpful follow-up and does not interpret uncertainty as finish, skip, no NFRs, or permission to invent an NFR.
5. **Given** the user explicitly requests suggestions, **When** NFRs responds, **Then** it offers one to three transient possibilities grounded only in context declared by NFRs, and clearly requires adoption or restatement before persistence.
6. **Given** a user-authored NFR is accepted and verified, **When** NFRs continues the interaction, **Then** it asks whether to define another NFR, request suggestions, or finish; acceptance alone does not finish collection.
7. **Given** the user explicitly says `finish`, `done`, `that's all`, or an equivalent, **When** NFRs evaluates the response, **Then** it returns an authoritative collection-finished result.
8. **Given** zero derived candidates exist and no user-authored NFR has been accepted, **When** open discovery begins and the user immediately says `finish`, **Then** NFRs accepts the explicit finish, returns `Collection Result: Finished`, and leaves fresh readiness to determine the persisted-state result independently.

After successful derived-candidate review, and immediately when zero derived candidates exist, NFRs asks:

> **Are there any qualities or operational expectations you'd like future solutions to meet?**
>
> For example, you might care about reliability, availability, scalability, performance, security, compliance, maintainability, or operability.
>
> If you'd like some suggestions based on what Highway already knows, just let me know. **If you're not sure, just say "I don't know," and we'll work through it together.**

### User Story 3 - Durable NFR Ownership and Setup Handoff (Priority: P1)

As a person using Setup or NFRs directly, I want NFRs to own candidate records, NFR persistence, readiness, and collection completion, so that Setup can orchestrate without duplicating NFR logic or changing existing durable guarantees.

**Why this priority**: The feature crosses a Setup-to-NFR boundary; explicit ownership prevents duplicate state machines, relationship errors, and false completion.

**Independent Test**: Exercise Setup delegation, direct NFR invocation, user-authored persistence, readiness checks, failures, and resume. Verify that Setup consumes authoritative owner results without inspecting NFR internals and that direct invocation does not emit Setup-owned transition text.

**Acceptance Scenarios**:

1. **Given** Setup delegates NFR work, **When** NFRs returns a continuation or finished result, **Then** Setup consumes the authoritative result without inspecting candidate contents, counts, records, relationships, or internal state.
2. **Given** a direct `/highway-nfrs` invocation begins, **When** the NFR interaction starts, **Then** it does not emit Setup-owned Controls-to-NFR transition language.
3. **Given** a direct `setup` or `configure` invocation has no usable evidence, **When** NFRs begins, **Then** it may introduce its purpose briefly and uses the same broad discovery question; usable direct Add evidence is evaluated before the generic opening.
4. **Given** a user-authored NFR is persisted, **When** the retained record is verified, **Then** it uses the existing NFR Add contract and has `controls: []` without inferred Control relationships.
5. **Given** a persistence, duplicate, identifier, catalog, relationship, or verification failure occurs, **When** NFRs reports the result, **Then** it preserves the prior verified baseline and does not claim successful creation or collection completion.
6. **Given** collection is active, **When** readiness is complete, candidates exist, or an NFR has just been accepted, **Then** none of those events alone produces a collection-finished result; only explicit user finish does.
7. **Given** the NFR owner reports collection continuation, **When** Setup evaluates the result, **Then** Setup remains in the NFR stage; given explicit collection finish and valid readiness, Setup may proceed to its existing conclusion contract.

### Edge Cases

- A Control-derived candidate has no suitable evidence for a specialized descriptor; NFRs uses `requirements` without adding persisted Control classifications.
- A candidate review decision is declined, skipped, corrected, or replaced; user-facing `accept`, `change`, `replace`, and `skip` map to the existing durable acceptance, modification, replacement, and final non-acceptance decisions without adding new durable decision values. Cancel, pause, and interruption remain workflow-exit behavior rather than synonyms for `skip`.
- Zero candidates exist while NFR records already exist; Setup still offers open discovery and does not infer that collection is complete.
- Zero candidates exist, no NFR has been accepted, and the user explicitly finishes immediately after the opening question; NFRs returns `Collection Result: Finished`, while fresh readiness independently reports the persisted-state result.
- Multiple NFR concerns are supplied in one response; NFRs evaluates them together and exposes at most one unresolved question or proposal.
- The user changes a proposed NFR before acceptance; unsupported staged interpretations are discarded and the revised evidence is evaluated.
- The user requests suggestions when no declared context supports one; NFRs does not invent organizational facts and asks a useful exploratory question instead.
- A suggestion is discussed, explained, or selected as a topic without explicit adoption; no NFR is persisted.
- A user-authored NFR resembles a Control requirement; NFRs preserves the conversational classification boundary and routes specific enforceable implementation requirements toward `/highway-controls` when appropriate.
- A direct NFR invocation occurs after Setup has completed; no Setup transition or conclusion is repeated.
- An unanswered discovery question or transient draft exists when the user starts a New interaction; it is not restored, while durable candidate review state is resumed.
- A malformed, blocked, declined, aborted, or failed owner result is returned; Setup does not claim successful NFR or Setup completion.
- A duplicate or relationship conflict is found before persistence; the proposal is re-evaluated under the existing duplicate and relationship safeguards.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: NFRs MUST preserve Control-owned deterministic candidate derivation and NFR-owned durable candidate state, stable ordering, persisted decisions, resume from the first pending candidate, Review Complete semantics, duplicate detection, identifier allocation, catalog behavior, relationship semantics, and persistence verification.
- **FR-002**: NFRs MUST present each unresolved Control-derived candidate as a contextual recommendation with the prescribed recommendation, rationale, and decision wording.
- **FR-003**: NFRs MUST select a transient descriptor from `requirements`, `safeguards`, `obligations`, `constraints`, or `conditions` based on accepted Control evidence and MUST fall back to `requirements`.
- **FR-004**: NFRs MUST derive a concise transient subject from accepted Control evidence and MUST NOT add persisted Control types, fields, enums, or classifications for presentation purposes.
- **FR-005**: NFRs MUST review derived candidates in durable order, one unresolved decision at a time, and MUST not begin open discovery until every derived candidate is decisioned and the candidate-review persistence boundary succeeds. User-facing `accept`, `change`, `replace`, and `skip` MUST map to existing durable acceptance, modification, replacement, and final non-acceptance decisions without adding new durable decision values; cancel, pause, and interruption remain workflow-exit behavior.
- **FR-006**: Routine candidate presentation MUST NOT expose candidate titles, Control identifiers, originating Control titles, candidate-generation terminology, or internal candidate-state terminology.
- **FR-007**: After derived candidate review completes, NFRs MUST ask the specified broad discovery question; when zero derived candidates exist, NFRs MUST begin with that same question.
- **FR-008**: Active `setup` and `configure` collection MUST support natural language, formal NFR language, partial statements, multiple dimensions, correction, replacement, explicit suggestion requests, `I don't know`, and explicit finish.
- **FR-009**: NFRs MUST evaluate supplied evidence before asking another question and MUST expose at most one unresolved response-demanding question or decision.
- **FR-010**: NFRs MUST treat `I don't know` as guided discovery and MUST ask one useful follow-up without interpreting it as no NFRs, finish, skip, or permission to invent an NFR.
- **FR-011**: Explicit suggestions MUST be limited to one through three transient possibilities grounded only in context declared by NFRs; suggestions MUST require clear user adoption or restatement before acceptance, and NFRs MUST NOT invent missing organizational facts.
- **FR-012**: NFRs MUST present supported user-authored proposals using the established expectation, rationale, and confirmation pattern and MUST allow title refinement where needed for the retained record.
- **FR-013**: Accepted user-authored NFRs MUST use the existing Add persistence contract and MUST persist with `controls: []`; conversational proximity to a Control MUST NOT create a Control relationship.
- **FR-014**: After every verified user-authored NFR creation, NFRs MUST ask whether to define another NFR, request suggestions, or finish, and MUST continue until the user explicitly finishes.
- **FR-015**: NFRs MUST provide this separate owner-authoritative collection result for active `setup` and `configure`:
	```text
	Action Status: Succeeded|Declined|Aborted|Blocked
	Collection Result: Continue|Finished
	Next Action: <owner route or None>
	Blocking Reason: <reason or None>
	```
	`Continue` means active NFR collection remains open. `Finished` requires explicit user intent to finish. `Declined`, `Aborted`, and `Blocked` do not represent successful collection completion. `Blocked` requires a non-empty blocking reason. The collection result MUST remain distinct from the existing four-field readiness result and MUST NOT include a created-NFR-ID list.
- **FR-016**: NFRs MUST NOT report collection `Finished` solely because there are zero candidates, candidate Review Complete occurred, an NFR was accepted, readiness is Complete, or NFR artifacts already exist.
- **FR-017**: NFR readiness MUST remain the unchanged four-field persisted-state contract, while active collection completion MUST use the separate NFR collection result. After `Collection Result: Finished`, Setup MUST request fresh NFR readiness and advance only when that fresh readiness satisfies the NFR owner's terminal-success contract; otherwise Setup MUST stop or remain with NFRs according to the owner result. Setup MUST consume these authoritative results without inspecting NFR internals.
- **FR-018**: Direct `/highway-nfrs` invocation MUST remain supported and MUST NOT repeat Setup-owned Controls-to-NFR transition language. Direct setup/configure with no usable evidence MAY introduce NFR purpose briefly; direct Add with usable evidence MUST evaluate it first.
- **FR-019**: NFRs MUST preserve the conversational distinction between qualities, operational characteristics, outcomes, or constraints appropriate for NFRs and specific enforceable implementation requirements more appropriate for `/highway-controls`.
- **FR-020**: NFRs MUST preserve resume semantics: durable unresolved candidate review resumes from owner state, while unanswered discovery questions and transient user-authored drafts are discarded; already classified candidates MUST NOT be regenerated.
- **FR-021**: NFRs MUST preserve existing record shapes, identifiers, catalogs, relationships, duplicate handling, failure behavior, atomicity, and persistence guarantees for both derived and user-authored NFRs.
- **FR-022**: Setup MUST consume NFR continuation or finish state through the owner contract and MUST NOT implement candidate review, NFR proposal logic, NFR persistence, readiness interpretation, or collection completion internally.

### Governance and Compliance

- Evaluate the `highway-nfrs` version change using the repository Skill Versioning Policy.
- Complete the Constitution Compliance Review and applicable Highway Experience Standard review before merge.

### Key Entities *(include if feature involves data)*

- **Control-derived candidate**: A durable NFR candidate produced from an accepted Control and owned by the existing candidate derivation and review contracts.
- **Contextual recommendation**: Transient user-facing presentation of a Control-derived candidate using an evidence-derived subject, descriptor, statement, rationale, and decision prompt.
- **User-authored NFR proposal**: A transient proposed expectation assembled from the user's conversational evidence before acceptance and persistence.
- **NFR collection result**: NFR-owned result distinguishing active continuation from explicit user-finished collection.
- **NFR readiness result**: The existing persisted-state readiness result, kept distinct from active collection completion.
- **NFR record**: A verified retained NFR with existing fields, identifier, catalog participation, and Control relationship semantics.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of candidate-review scenarios, at most one unresolved candidate decision is visible at a time and open discovery begins only after all derived candidates are decisioned.
- **SC-002**: In 100% of zero-candidate scenarios, the user receives the broad NFR discovery question and is not treated as complete solely because no candidates exist.
- **SC-003**: In 100% of tested explicit suggestion scenarios, every suggestion is grounded in declared context, remains transient until adoption, and contains no invented organizational fact.
- **SC-004**: In 100% of accepted user-authored NFR scenarios, the retained record has `controls: []`.
- **SC-005**: In 100% of continuation scenarios, an accepted NFR is followed by an explicit choice to define another NFR, request suggestions, or finish; acceptance alone never ends collection.
- **SC-006**: In 100% of resume scenarios, durable candidate state determines the first pending candidate, no classified candidate is regenerated, and no transient discovery draft or unanswered question is restored.
- **SC-007**: In 100% of direct invocation scenarios, Setup-owned transition language is absent and NFR-owned output remains authoritative.
- **SC-008**: In 100% of failed, blocked, malformed, declined, aborted, duplicate, or persistence-failure scenarios, no false NFR collection completion or successful retained-record claim is emitted.
## Assumptions

- Feature 095's Setup transition and conclusion remain unchanged; this feature changes NFR ownership and behavior behind that existing orchestration boundary.
- Existing Control-derived candidate generation remains the source of derived candidates and is not redesigned here.
- Existing NFR record shapes, identifier rules, catalog rules, relationship rules, duplicate detection, persistence verification, and readiness semantics remain authoritative unless an explicit requirement above separates collection completion from readiness.
- The NFR owner can expose a collection continuation or finish result without exposing internal candidate or record structures to Setup.
- Context used for suggestions means only context that `highway-nfrs` explicitly declares and successfully reads; missing or malformed optional context is excluded rather than replaced with invented facts.
- User-authored NFR discovery state is transient until verified persistence; durable candidate-review state remains resumable under the existing owner contract.
- The prescribed prompts are user-facing contract text; exact wording is authoritative where quoted in the feature requirements and acceptance scenarios.
- Constitution and Highway Experience Standard reviews are governance checks for implementation and do not create new retained NFR fields or classifications.
- Mobile, future `/highway` routing, brownfield onboarding, unrelated NFR update/remove/set behavior, Control candidate derivation, and Setup transition wording are out of scope.
