# Feature Specification: Setup Runtime Architecture Alignment

**Feature Branch**: `147-setup-runtime-alignment`

**Created**: 2026-10-06

**Status**: Draft

**Input**: User description: "Update highway-setup to align with the revised runtime architecture and Highway Experience Standard."

## User Scenarios & Testing

### User Story 1 - Thin owner orchestrator (Priority: P1)

As a person using Highway Setup, I want Setup to coordinate the owning skills without interpreting or changing their work, so that each owner remains responsible for its domain and Setup advances only when the owner permits it.

**Why this priority**: The owner boundary is the foundation of reliable Setup behavior. Violating it can cause incorrect domain decisions, duplicate interaction, or premature completion.

**Independent Test**: Exercise Setup with each owner in sequence and verify that it requests readiness, delegates the owner-supplied action, consumes the owner-specific result, remains with the owner when required, and advances only after fresh readiness permits advancement.

**Acceptance Scenarios**:

1. **Given** Setup has an active owner with a supported next action, **When** Setup continues, **Then** it delegates that action and renders the owner's interaction without reinterpretation.
2. **Given** an owner reports that its active work is finished, **When** Setup evaluates continuation, **Then** it requests fresh readiness before advancing.
3. **Given** all owners permit advancement in order, **When** Setup reaches the end of the owner sequence, **Then** it emits the Setup conclusion exactly once.
4. **Given** an owner still requires interaction, **When** Setup receives the owner's continuing result, **Then** it remains with that owner and does not emit a new-domain transition.

### User Story 2 - Explicit orchestration failures (Priority: P1)

As a person whose Setup process cannot continue, I want a clear user-facing explanation and no false completion claim, so that I know what stopped the process and what context may be needed next.

**Why this priority**: Silent advancement or an inaccurate completion claim can leave foundational context incomplete while appearing valid.

**Independent Test**: Supply malformed results, blocked results, declined or aborted results, unsupported actions, and unexpected orchestration failures, then verify that Setup stops at the current owner and reports actionable context without invoking a later owner.

**Acceptance Scenarios**:

1. **Given** an owner result is malformed or unsupported, **When** Setup handles it, **Then** Setup stops without invoking a later owner.
2. **Given** an owner is Blocked, **When** Setup handles the result, **Then** it stops and reports the owner's blocking reason.
3. **Given** an owner is Declined or Aborted, **When** Setup handles the result, **Then** it stops without advancing.
4. **Given** an owner supplies an unsupported Next Action, **When** Setup handles the result, **Then** it stops and identifies the unsupported action.
5. **Given** an unexpected orchestration failure occurs, **When** Setup reports the failure, **Then** it does not claim Setup completion and provides actionable user-facing context.

### User Story 3 - Setup-owned presentation boundaries (Priority: P1)

As a person moving through Setup, I want transitions and closure to be concise and predictable while owner interactions remain authoritative, so that Setup provides orientation without duplicating or competing with owner guidance.

**Why this priority**: Setup owns the journey-level presentation, while the Experience Standard and owners govern the substance of interactive collaboration.

**Independent Test**: Walk through active and terminal owners and inspect the emitted conversation for one-time welcome, single active-domain transitions, horizontal separation, non-duplicated owner openings, concise completed-domain synthesis, and one final conclusion.

**Acceptance Scenarios**:

1. **Given** Setup enters a new active domain, **When** it presents the transition, **Then** it emits one short outcome-oriented transition with horizontal-rule separation.
2. **Given** an owner is already terminal, **When** Setup skips it, **Then** it emits no transition for that owner.
3. **Given** a guided owner domain completes with meaningful accepted context, **When** Setup moves onward, **Then** it presents one concise user-relevant synthesis unless the owner already provided it.
4. **Given** an orchestrated response contains a delegated owner interaction, **When** Setup adds presentation around it, **Then** the final interaction block contains at most one Setup-owned response-demanding question or decision and does not interfere with the owner's own interaction.
5. **Given** Setup is resumed, **When** it begins, **Then** it omits the initial welcome and does not repeat a prior domain transition.

### User Story 4 - Fresh resume and completion semantics (Priority: P2)

As a person resuming Setup, I want it to start from fresh owner readiness without reconstructing hidden state, so that the current owner contracts determine the current path.

**Why this priority**: Fresh readiness keeps Setup a thin orchestrator and avoids inventing persistence or conversational state ownership.

**Independent Test**: Start a new Setup interaction after an interrupted run and verify fresh readiness in Profile, Objectives, Controls, and NFR order, with no Setup checkpoint or owner-state restoration.

**Acceptance Scenarios**:

1. **Given** Setup is started or resumed, **When** it begins orchestration, **Then** it requests fresh readiness in Profile, Objectives, Controls, and NFR order.
2. **Given** a resumed interaction has no persisted Setup checkpoint, **When** Setup begins, **Then** it does not reconstruct owner-internal conversational state.
3. **Given** fewer than all four owners permit advancement, **When** Setup evaluates completion, **Then** it does not emit the final Setup conclusion.

### Edge Cases

- An owner reports `Continue` repeatedly; Setup remains with that owner and does not repeat the domain transition.
- An owner reports `Finished` but fresh readiness does not permit advancement; Setup stops or continues according to that fresh owner contract rather than assuming completion.
- Controls and NFRs return Collection Result while Profile and Objectives return their own declared result contracts; Setup consumes each without imposing a common result shape.
- An owner provides blocking context that is user-relevant; Setup may present that reason without exposing machine-only readiness or status fields.
- An owner is skipped because it is already terminal; Setup does not emit a transition or synthesis for work that did not occur.
- A completed owner already emits a user-facing synthesis; Setup does not duplicate it.

## Requirements

### Functional Requirements

- **FR-001**: Setup MUST orchestrate owners in the order Profile, Objectives, Controls, and NFRs.
- **FR-002**: Setup MUST request readiness from the current owner before selecting the next orchestration action.
- **FR-003**: Setup MUST delegate a supported Next Action supplied by the active owner.
- **FR-004**: Setup MUST render the owner's interaction without reinterpretation.
- **FR-005**: Setup MUST consume each owner's declared result contract without imposing one common result schema.
- **FR-006**: Setup MUST remain with an owner while that owner's contract requires continued interaction.
- **FR-007**: Setup MUST request fresh readiness after an owner reports that its active work is finished.
- **FR-008**: Setup MUST advance only when fresh owner readiness permits advancement.
- **FR-009**: Setup MUST claim completion only after all four owners permit advancement in order.
- **FR-010**: Setup MUST stop without invoking a later owner when an owner result is malformed or unsupported.
- **FR-011**: Setup MUST stop and report the owner-provided reason when an owner is Blocked.
- **FR-012**: Setup MUST stop without advancing when an owner is Declined or Aborted.
- **FR-013**: Setup MUST stop and identify an unsupported owner Next Action.
- **FR-014**: Setup MUST stop without claiming completion and provide actionable user-facing context after an unexpected orchestration failure.
- **FR-015**: Setup MUST preserve the initial welcome exactly once for initial Setup and omit it for resumed Setup.
- **FR-016**: Setup MUST emit one short outcome-oriented transition only when entering a new active domain.
- **FR-017**: Setup MUST use horizontal-rule separation for visible transitions between major Setup domains.
- **FR-018**: Setup MUST provide at most one Setup-owned response-demanding question or decision in the final interaction block and MUST NOT interfere with the owner's own interaction.
- **FR-019**: Setup MUST provide one concise user-relevant synthesis when a guided owner domain completes and its accepted context can be meaningfully summarized, unless the owner already provides that synthesis.
- **FR-020**: Setup MUST hide machine-consumable readiness, action, collection, status, and other owner result fields from normal user-visible output, except for owner-provided blocking context needed to explain why Setup cannot continue.
- **FR-021**: Setup MUST persist no checkpoint and restore no owner conversational state.
- **FR-022**: Setup MUST retain the Highway Experience Standard as its generic user-visible interaction dependency.
- **FR-023**: Setup MUST NOT perform owner discovery, interpretation, recommendations, convergence, artifact acceptance, persistence, advisory reasoning, or clarification on behalf of owners.
- **FR-024**: Setup MUST NOT consult or reference the Skills Constitution as a runtime dependency.
- **FR-025**: Setup MUST contain exactly one clear `# Purpose` section whose meaning is to orchestrate Profile, Objectives, Controls, and NFR owners in order while consuming their declared results.

### Key Entities

- **Owner**: A domain skill responsible for its semantics, completeness, acceptance, persistence, and declared runtime result contract.
- **Owner Readiness**: The current owner's declaration of whether work is terminal, blocked, continuing, or ready for a supported action.
- **Owner Result**: The owner-specific outcome consumed by Setup after delegated interaction; it may be a Collection Result or another declared contract.
- **Next Action**: The owner-supplied action that Setup may delegate when supported.
- **Domain Transition**: Setup-owned outcome-oriented presentation emitted when entering a new active owner domain.
- **Domain Synthesis**: Setup-owned concise user-relevant closure for a completed guided owner domain when the owner has not already provided equivalent synthesis.

## Success Criteria

### Measurable Outcomes

- **SC-001**: Automated contract checks confirm the owner order Profile → Objectives → Controls → NFRs in 100% of Setup execution paths.
- **SC-002**: Automated failure fixtures confirm that each malformed, blocked, declined, aborted, unsupported-action, and unexpected-failure case stops before invoking a later owner.
- **SC-003**: Automated presentation checks confirm exactly one initial welcome, no resumed welcome, no repeated same-owner transition, and one final conclusion after complete advancement.
- **SC-004**: Automated contract checks confirm that Controls/NFRs retain their Collection Result contracts and Profile/Objectives retain their declared owner-specific result contracts without a common schema.
- **SC-005**: Automated hygiene checks find zero runtime references to the Skills Constitution, retired Experience rule IDs, or Setup-owned machine result fields in normal user-visible output.
- **SC-006**: Reviewers can verify every Setup behavior in the Verification section without relying on generic Experience rules being restated in Setup.
- **SC-007**: Resume checks confirm that Setup creates no checkpoint and begins every new interaction from fresh owner readiness.

## Assumptions

- The four existing owner skills remain authoritative for their domain semantics, acceptance, persistence, and result contracts.
- Existing Setup transition copy, welcome text, and completion conclusion remain product-approved unless this feature explicitly changes their orchestration placement.
- The Highway Experience Standard remains the generic interaction contract and is available through the existing Setup input reference.
- Setup does not mutate artifacts or persist owner state.
- Verification may use the existing Setup contract tests and add focused cases for the clarified failure and presentation behavior.

## Verification

- Owner order remains Profile → Objectives → Controls → NFRs.
- Readiness is requested from the current owner before each action decision.
- Supported owner-supplied actions are delegated without reinterpretation.
- Owner-specific result contracts are consumed without imposing one common schema.
- Setup remains with owners that require continued interaction and requests fresh readiness after active work finishes.
- Malformed, blocked, declined, aborted, unsupported-action, and unexpected-failure cases stop safely and do not invoke later owners.
- Initial and resumed welcome behavior is correct.
- Domain transitions are short, outcome-oriented, separated with `---`, emitted only for active-domain entry, and not repeated within an owner.
- Completed-domain synthesis is concise, user-relevant, non-duplicative, and free of machine result fields.
- Setup exposes no generic advisory, clarification, convergence, acceptance, or persistence mechanics.
- Setup has one proper `# Purpose` section and valid frontmatter/metadata.
- Setup does not reference the Skills Constitution at runtime.
