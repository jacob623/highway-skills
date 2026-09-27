# Feature Specification: Highway Setup NFR Handoff

**Feature Branch**: `095-setup-nfr-handoff`

**Created**: 2026-09-27

**Status**: Draft

**Input**: User description: "Improve the final portion of `/highway-setup` so Controls transition naturally into NFRs and successful Setup ends with a forward-looking Highway experience instead of a completion dashboard."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Handoff from Controls to NFRs (Priority: P1)

As a Highway user completing Setup, I want a clear transition from established safeguards to the operational qualities future decisions should achieve, so the next domain feels like a continuation of the work I just completed.

**Why this priority**: This is the primary experience change and must preserve the existing owner boundaries and Controls completion semantics.

**Independent Test**: Complete Setup through an authoritative Controls `Finished` result followed by fresh Controls `Complete` readiness, then verify that Setup emits the transition exactly once immediately before the first NFR-owned interaction.

**Acceptance Scenarios**:

1. **Given** Controls returns `Continue`, **When** Setup processes the result, **Then** Setup remains with Controls and emits no NFR transition.
2. **Given** Controls returns `Finished` and fresh Controls readiness is `Missing`, **When** Setup resumes orchestration, **Then** Setup remains with Controls and emits no NFR transition.
3. **Given** Controls returns `Finished` and fresh Controls readiness is `Blocked`, **When** Setup resumes orchestration, **Then** Setup stops with the Controls-owner result and emits no NFR transition.
4. **Given** Controls returns `Finished` and fresh Controls readiness is `Complete`, **When** Setup is about to begin the first NFR-owned interaction, **Then** Setup emits exactly this transition once:

   > **We've established the safeguards that should guide future technology decisions. Now let's consider what those decisions need to achieve in operation.**
   > Based on the Controls we've defined, Highway may already have identified qualities or operational outcomes worth considering.

5. **Given** Controls readiness is already `Complete` when Setup reaches the Controls stage, **When** NFR readiness requires the first NFR-owned interaction, **Then** Setup emits the Controls-to-NFR transition exactly once before that interaction.
6. **Given** the user invokes `/highway-nfrs` directly, **When** the NFR interaction begins, **Then** the Setup transition is not emitted.

### User Story 2 - Preserve NFR Ownership and Resume Semantics (Priority: P1)

As a Highway user, I want NFR interaction to remain owned by the NFR domain and resume from authoritative state, so Setup does not duplicate questions or reinterpret work after an interruption.

**Why this priority**: Ownership and resume behavior protect the correctness of the existing governance workflow while the handoff presentation changes.

**Independent Test**: Start NFR work through Setup, interrupt it, begin a New interaction, and verify that Setup rereads owner readiness, resumes at the first incomplete owner, restores no transient state, and does not replay the initial handoff transition.

**Acceptance Scenarios**:

1. **Given** Setup has emitted the initial handoff and delegated to NFRs, **When** NFRs returns an incomplete or non-terminal result, **Then** Setup consumes the authoritative result without inspecting candidate contents, candidate counts, NFR records, relationships, or other NFR internals.
2. **Given** NFR work is interrupted after the initial handoff, **When** Setup begins a New interaction, **Then** Setup rereads authoritative owner state and resumes at the first incomplete owner without restoring questions, drafts, transition state, or Setup checkpoints.
3. **Given** Setup resumes existing NFR work, **When** the NFR-owned interaction begins again, **Then** Setup does not replay the initial Controls-to-NFR transition.
4. **Given** Setup renders an NFR-owned interaction, **When** NFRs provides its question, recommendation, decision, error, or result, **Then** Setup renders it unchanged and authors no NFR interaction content.

### User Story 3 - Forward-Looking Setup Conclusion (Priority: P1)

As a Highway user who has successfully completed Setup, I want a concise conclusion that explains the value of the context I established and points me to the next available Highway capability, so completion feels like the beginning of useful work rather than a static report.

**Why this priority**: The conclusion is the user-visible outcome of successful Setup and replaces the current completion dashboard.

**Independent Test**: Complete every required owner workflow with the terminal results required by each owner contract and verify that the new conclusion appears once, contains the prescribed `/highway-help` recommendation, and contains no dashboard fields.

**Acceptance Scenarios**:

1. **Given** all required owner contracts permit successful Setup completion, **When** Setup reaches its terminal completion point, **Then** it emits:

   > **Your foundational Highway context is now in place.**
   >
   > Highway understands more about your organization, what you're trying to accomplish, the safeguards that should guide future decisions, and the operational expectations those decisions may need to satisfy.
   >
   > **This is where Highway starts becoming more useful.**
   > The context you've established can help Highway make future guidance more relevant, connect decisions back to your objectives and governance, and build on what it already knows instead of starting over each time.
   >
   > **Where would you like to go next?**
   > Run `/highway-help` to explore what Highway can help you do.

2. **Given** a required owner is Blocked, incomplete, malformed, declined, aborted, or fails persistence, **When** Setup processes that result, **Then** it does not emit the successful conclusion.
3. **Given** Setup emits the successful conclusion, **When** the user sees the result, **Then** the old `Highway Setup Complete` dashboard and its Profile, Business Objectives, Controls, and NFR summary fields are absent.
4. **Given** Setup recommends `/highway-help`, **When** the conclusion is displayed, **Then** Setup offers the command without invoking it automatically.

### Edge Cases

- Controls readiness becoming `Complete` before the user explicitly finishes Controls must not trigger the handoff.
- A zero-Control finish followed by fresh Controls `Missing` readiness must remain in Controls and must not trigger the handoff or successful conclusion.
- A stale, malformed, unknown, declined, aborted, or failed owner result must stop Setup before any later owner or successful conclusion is invoked.
- A direct NFR invocation must never receive Setup-owned transition or conclusion text.
- A resumed NFR interaction must not receive a duplicate transition, even when Setup has no persisted transition marker.
- A successful NFR owner result that does not satisfy the current NFR contract must not allow Setup to claim completion.
- Repeated evaluation of the same successful terminal state must not duplicate the conclusion within one Setup completion response.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Setup MUST preserve the existing Profile-to-Objectives, Objectives-to-Controls, Controls collection, and Controls readiness behavior.
- **FR-002**: Setup MUST treat Controls `Continue` as non-terminal and MUST remain with Controls until the user explicitly finishes collection.
- **FR-003**: Setup MUST request fresh Controls readiness after Controls returns `Finished` and MUST progress toward NFRs only when that fresh readiness is `Complete`.
- **FR-004**: Setup MUST remain with Controls when fresh Controls readiness is `Missing` and MUST stop with the owner result when fresh Controls readiness is `Blocked`.
- **FR-005**: Setup MUST own and emit the specified Controls-to-NFR transition exactly once before the first NFR-owned interaction during the initial active handoff. If the current NFR owner contract returns a terminal result without requiring user interaction, Setup does not manufacture an NFR interaction solely to emit the transition.
- **FR-006**: Setup MUST NOT emit the Controls-to-NFR transition while Controls collection remains active, when Controls is `Missing` or `Blocked`, during direct NFR invocation, or when resuming existing NFR work.
- **FR-007**: Setup MUST delegate NFR interaction to the NFR owner after the transition and MUST render all NFR-owned interaction unchanged.
- **FR-008**: Setup MUST consume the NFR owner's authoritative result without inspecting or interpreting candidate contents, candidate counts, NFR records, relationships, or other NFR internals.
- **FR-009**: Setup MUST NOT author NFR questions, recommendations, decisions, candidate handling, or NFR completion logic within this feature.
- **FR-010**: Setup MUST preserve New interaction semantics by rereading authoritative owner state and resuming at the first incomplete owner.
- **FR-011**: Setup MUST restore no transient questions, drafts, transition state, or Setup checkpoints when resuming.
- **FR-012**: Setup MUST replace the existing completion dashboard with the specified forward-looking conclusion after all required owner contracts permit successful completion.
- **FR-013**: Setup MUST NOT emit the successful conclusion on Blocked, incomplete, malformed, declined, aborted, or failed required-owner paths.
- **FR-014**: Setup MUST include `/highway-help` as a replaceable next-step recommendation and MUST NOT invoke it automatically.
- **FR-015**: Setup MUST remove the old `Highway Setup Complete` dashboard text and its Profile, Business Objectives, Controls, and NFR summary fields from the successful output.

### Governance and Compliance

- Evaluate the `highway-setup` version change under the repository Skill Versioning Policy.
- Complete the required Constitution Compliance Review and applicable Highway Experience Standard review before merge.

### Key Entities *(include if feature involves data)*

- **Setup owner result**: The authoritative result returned by a domain owner, including its status, next action, blocking context, or completion state.
- **Controls collection result**: The authoritative distinction between active collection and explicitly finished Controls work.
- **Setup handoff transition**: The non-persisted Setup-owned message shown once during the initial transition from Controls to the first NFR-owned interaction.
- **Setup conclusion**: The successful, forward-looking message shown only after all required owner contracts permit Setup completion.
- **New interaction resume behavior**: Setup rereads authoritative owner state and selects the first incomplete owner without restoring transient Setup interaction state.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In all acceptance scenarios, Controls `Continue`, fresh Controls `Missing`, and fresh Controls `Blocked` produce zero Controls-to-NFR transition messages.
- **SC-002**: In all successful initial handoff scenarios, exactly one Controls-to-NFR transition message appears before the first NFR-owned interaction.
- **SC-003**: In all direct and resumed NFR scenarios, zero Setup-owned Controls-to-NFR transition messages appear.
- **SC-004**: In all successful Setup scenarios, the new conclusion appears once and the old completion dashboard appears zero times.
- **SC-005**: In 100% of blocked, incomplete, malformed, declined, aborted, and failed required-owner scenarios, the successful conclusion appears zero times.
- **SC-006**: In all NFR delegation scenarios, every NFR-owned user-visible response is preserved without Setup-authored additions or substitutions.
- **SC-007**: In all resume scenarios, no transient question, draft, transition marker, or Setup checkpoint is restored, and the first incomplete owner is selected deterministically.

## Assumptions

- The current NFR readiness and owner-result contract remains authoritative for this feature; NFR collection semantics are deferred to a subsequent NFR-owned change.
- Existing Profile, Objectives, Controls, owner-result, failure, resume, and Experience Standard contracts remain valid unless directly contradicted by the requirements above.
- The handoff transition is presentation state only and is not persisted as a new governance artifact or Setup checkpoint.
- `/highway-help` is an available user-invoked capability and its content is outside this feature's scope.
- The prescribed conclusion is the default contextual next-step recommendation and may be replaced by a future recommendation without changing the completion gate.
- Constitution Compliance Review and applicable Highway Experience Standard checks are available through the repository's existing governance process.
- The feature changes only `highway-setup` behavior and its directly required contract tests or generated representations; it does not change NFR-owner UX.
