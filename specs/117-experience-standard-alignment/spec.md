# Feature Specification: Experience Standard Alignment

**Feature Branch**: `117-experience-standard-alignment`

**Created**: 2026-10-01

**Status**: Draft

**Input**: User description: Update the shared Experience Standard so its interaction rules align with current owner and Setup contracts, preserve context-first recommendations and acceptance boundaries, clarify Setup transitions and synthesis, prevent machine-result leakage, remain compatible with Profile, Objectives, Controls, and NFRs, correct stale examples, preserve rule IDs, and apply the versioning policy consistently.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Receive Grounded Help Before Questioning (Priority: P1)

As a person using any Highway workflow, I want accepted context, available evidence, discovery, and grounded recommendations used before Highway asks for more information, so that I answer only questions that are still necessary.

**Why this priority**: Context-first interaction is the shared behavior that makes Profile, Objectives, Controls, and NFRs feel coherent rather than like separate questionnaires.

**Independent Test**: Run representative Profile enrichment, Objective, Control, and NFR interactions with accepted context and available recommendations. Confirm useful recommendations appear before unnecessary guided questions, accepted information is reused, only one unresolved question or decision appears at a time, and unknown information is not guessed.

**Acceptance Scenarios**:

1. **Given** accepted context or available evidence supports a useful grounded recommendation, **When** a workflow would otherwise ask for more information, **Then** it shows the recommendation first.
2. **Given** accepted information has already answered or grounded a need, **When** the workflow continues, **Then** it reuses that information instead of asking for it again.
3. **Given** no useful grounded recommendation remains, **When** more information is required, **Then** Highway asks one unresolved question or decision and does not ask merely to satisfy an internal schema, dimension, route, stage, or category.
4. **Given** information is unknown or unsupported, **When** Highway responds, **Then** it leaves that information unknown rather than guessing.
5. **Given** information was discovered or extracted, **When** the applicable user-acceptance boundary has not been satisfied, **Then** it remains proposed rather than becoming accepted context.
6. **Given** a person is making a normal user-visible decision, **When** Highway responds, **Then** implementation details remain hidden unless the person asks for them or needs them to act.

### User Story 2 - Make and Review Recommendations Clearly (Priority: P1)

As a person choosing among grounded guidance, I want recommendations presented with clear choice boundaries and an available alternative, so that I can accept useful guidance without redundant confirmation and can stop when no useful choice remains.

**Why this priority**: Profile enrichment, Objectives, Controls, and NFRs share this model, so ambiguity here creates inconsistent ownership and acceptance behavior across Highway.

**Independent Test**: Exercise single and multiple recommendation cases across the four owner workflows. Confirm no more than five actionable choices are shown, selection wording matches the count, displayed selection is acceptance, user-authored alternatives remain available, explanation requests are not acceptance, duplicate recommendations stop, and rationale appears only when decision-useful.

**Acceptance Scenarios**:

1. **Given** a workflow has one useful grounded recommendation, **When** it presents the choice, **Then** the selection wording is singular and offers acceptance, change, or an alternative.
2. **Given** a workflow has multiple useful grounded recommendations, **When** it presents the choices, **Then** it shows no more than five actionable choices and permits selection of one, several, all, or a user-authored alternative as appropriate.
3. **Given** a person selects a displayed recommendation, **When** the selection is explicit, **Then** it counts as acceptance and Highway does not request redundant confirmation.
4. **Given** a person asks for explanation, comparison, or more information, **When** Highway responds, **Then** the request does not count as acceptance.
5. **Given** no useful grounded non-duplicate recommendation remains, **When** Highway continues, **Then** it stops recommending and uses the owning workflow's next applicable interaction.
6. **Given** recommendation rationale would not help the person decide, **When** Highway presents the choice, **Then** it omits unnecessary rationale.

### User Story 3 - Review Interpretation and Decision Context in the Right Order (Priority: P1)

As a person reviewing an interpretation or answering a context-setting question, I want the proposal or question presented in a predictable order, so that I know exactly what I am accepting and why a question matters.

**Why this priority**: Review and Decision Context are shared presentation boundaries, and incorrect ordering can turn explanation into an accidental second question or acceptance request.

**Independent Test**: Review materially interpreted content and a Decision Context question. Confirm the exact review heading, proposal placement, single acceptance request, question-first Decision Context ordering, literal label, concise explanation, optional examples, and absence of implementation mechanics or a second question.

**Acceptance Scenarios**:

1. **Given** content has been materially interpreted, **When** Highway presents it for review, **Then** it uses `Here's what I've captured as your [category]:`, places the proposal immediately below the heading, and puts one acceptance request at the bottom.
2. **Given** the content is an explicit recommendation selection, a direct statement already expressed in the requested category, or clearly presented imported information, **When** Highway presents it, **Then** it does not use the material-interpretation review.
3. **Given** Decision Context is needed for an unresolved question, **When** Highway presents the interaction, **Then** the question appears first, followed by the literal label `**Why it matters:**` and one concise user-relevant explanation.
4. **Given** Decision Context is presented, **When** Highway completes the explanation, **Then** it does not add a second question or expose implementation mechanics.
5. **Given** relevant examples could help, **When** Decision Context is presented, **Then** examples remain optional and illustrative rather than required categories.

### User Story 4 - Move Through Setup Without Machine-Result Leakage (Priority: P1)

As a person moving through guided Setup, I want concise domain transitions, completion synthesis, and owner responses presented as natural conversation, so that orchestration details do not interrupt the final acknowledgment or next-domain transition.

**Why this priority**: Setup is the shared visible orchestrator; it must coordinate owner contracts without exposing machine fields or duplicating owner openings.

**Independent Test**: Run guided Setup through multiple active domains, a completed domain, and a delegated owner completion. Confirm each newly active domain has one short outcome-oriented transition separated by a horizontal rule, the receiving owner owns its opening, a completed domain may emit one concise synthesis, the final block has one response-demanding question or decision, and machine-result fields remain hidden except on direct request.

**Acceptance Scenarios**:

1. **Given** Setup activates a new domain, **When** it transitions to that domain, **Then** it gives one short outcome-oriented transition and separates visible domain transitions with a horizontal rule.
2. **Given** Setup delegates to an owner, **When** the owner begins, **Then** Setup does not duplicate the owner's opening.
3. **Given** a guided Setup domain completes and accepted context can be meaningfully summarized, **When** Setup moves to the next active domain, **Then** it may emit one concise user-relevant synthesis with no new question or orchestration mechanics.
4. **Given** Setup presents its final interaction block, **When** the block is visible, **Then** it contains at most one response-demanding question or decision.
5. **Given** normal orchestrated conversation receives owner output, **When** the owner returns Status, Summary, Next Action, Blocking Reason, Action Status, Collection Result, or mutation-result fields used only for orchestration, **Then** those fields are not rendered as conversation.
6. **Given** the person directly requests readiness, status, inspection, or a mutation result, **When** the owner returns the requested result, **Then** the relevant machine-oriented fields may be shown.
7. **Given** a delegated owner has produced its final guided acknowledgment, synthesis, or next-domain transition, **When** control returns to Setup, **Then** Setup does not append a machine result after it.
8. **Given** Setup consumes owner results internally, **When** it advances, **Then** it follows the owning skill's declared contract rather than imposing a shared collection-result shape.

### User Story 5 - Keep Shared Rules Aligned With Domain Owners (Priority: P2)

As a governance maintainer, I want the Experience Standard to define only shared presentation and interaction behavior, so that Profile, Objectives, Controls, NFRs, Setup, and the Constitution retain their own domain-specific ownership and persistence contracts.

**Why this priority**: A shared standard is useful only when it is coherent with current owners and does not become a competing source of domain behavior.

**Independent Test**: Review the standard against the current Constitution, Setup, Profile, Objectives, Controls, and NFR contracts. Confirm shared rules are generalized, domain-specific workflows remain referenced rather than copied, Profile has four readiness domains without Highway Role, and stale examples no longer show machine results as normal conclusions.

**Acceptance Scenarios**:

1. **Given** Profile behavior is reviewed, **When** shared compatibility is checked, **Then** the standard recognizes Identity, Vision, Competitive Path, and Guiding Principles, excludes Highway Role as a readiness domain, treats optional enrichment as non-blocking and non-readiness-bearing, and allows concise guided completion synthesis without adding Profile-specific mechanics.
2. **Given** Objectives, Controls, and NFRs are reviewed, **When** shared compatibility is checked, **Then** the standard permits their current grounded recommendation and acceptance behavior without copying their domain-specific lifecycle, persistence, readiness, identifiers, or derivation workflows.
3. **Given** the Constitution defines a requirement also relevant to interaction quality, **When** the standard addresses that concern, **Then** it cross-references the Constitution rule rather than duplicating its rule text.
4. **Given** the standard's examples are reviewed, **When** they illustrate guided completion or owner output, **Then** they are explicitly non-normative and do not present orchestration-only machine results as a normal visible conclusion.

### User Story 6 - Maintain a Coherent Versioned Standard (Priority: P2)

As a governance maintainer, I want the Experience Standard amendment classified and recorded according to its versioning policy, so that the strength and compatibility impact of the new shared rules are visible.

**Why this priority**: The request changes several observable obligations, so version metadata and stable rule identity are part of the contract's accountability.

**Independent Test**: Review the amendment metadata, rule identifiers, version policy application, and final consistency review. Confirm rule IDs remain stable, new IDs are allocated only when needed, the version reflects strengthened/redefined obligations, and the standard's own self-application review cites the Constitution.

**Acceptance Scenarios**:

1. **Given** existing rules are strengthened or redefined such that conforming behavior changes, **When** the amendment is recorded, **Then** the version advances from 5.0.0 to 6.0.0 as MAJOR.
2. **Given** the amendment adds or repairs rule content, **When** rule identifiers are reviewed, **Then** existing IDs are not reused or silently redefined and any genuinely new obligation receives a new X identifier.
3. **Given** the amendment is complete, **When** its metadata is reviewed, **Then** the amendment report names changed elements, preserves unlisted elements, and includes a non-restatement review against the Constitution.

### Edge Cases

- A workflow has accepted context but no useful grounded non-duplicate recommendation; it asks the one applicable unresolved question rather than manufacturing a choice.
- A workflow has more than five possible recommendations; it presents no more than five actionable choices and preserves a user-authored alternative.
- A selected recommendation is explicit, while a request to compare or explain it is not; only the former crosses the acceptance boundary.
- Discovered or extracted information is clear but still proposed because its acceptance boundary has not been met.
- A material interpretation is mixed with an explicit recommendation selection or direct category statement; the material-review heading is not used for the non-interpretive portion.
- Decision Context would naturally invite a follow-up question; the explanation remains one concise statement and does not add that question.
- A receiving owner already has an opening; Setup transitions to it without repeating the opening.
- A completed Setup domain has nothing meaningful to summarize; no empty or mechanical synthesis is emitted.
- An owner returns machine fields after a final user-facing acknowledgment; Setup consumes them internally and does not append them visibly.
- A person directly requests status or a mutation result; the requested machine-oriented fields remain available.
- Profile optional enrichment is declined; readiness and continuation remain unchanged.
- A stale example conflicts with a current rule; the example is corrected without changing the rule ID unless the obligation itself changes.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Experience Standard MUST govern what a Highway skill emits and how it interacts with the person running it. It MUST NOT govern SKILL.md authoring structure or user-authored strategy, policy, requirements, priorities, or preferred wording.
- **FR-002**: The Experience Standard MUST cross-reference Constitution rules where the same discipline is relevant and MUST NOT duplicate Constitution rule text.
- **FR-003**: Highway interaction MUST use accepted information, available evidence, imports or discovery, and grounded recommendations before asking for more information.
- **FR-004**: Highway MUST reuse accepted information instead of asking for it again, ask only one unresolved question or decision at a time, and MUST NOT ask solely to satisfy an internal schema, dimension, route, stage, or category.
- **FR-005**: Highway MUST keep implementation details hidden unless the person asks for them or needs them to act, and MUST leave unknown information unknown rather than guessing.
- **FR-006**: Discovered or extracted information MUST remain proposed until the applicable user-acceptance boundary is satisfied.
- **FR-007**: Recommendations MUST be grounded in context declared by the owning workflow and MUST be shown before an unnecessary guided-collection question when a useful grounded recommendation exists.
- **FR-008**: The shared recommendation model MUST keep a user-authored alternative available, show no more than five actionable choices, and match selection wording to the number of recommendations shown.
- **FR-009**: Selecting a displayed recommendation MUST count as acceptance without redundant confirmation. Requests for explanation, comparison, or more information MUST NOT count as acceptance.
- **FR-010**: Highway MUST stop recommending when no useful grounded non-duplicate choice remains. Recommendation rationale MUST appear only when it helps the person make the decision.
- **FR-011**: Materially interpreted content MUST be reviewed under `Here's what I've captured as your [category]:`, with the proposal immediately below the heading and one acceptance request at the bottom.
- **FR-012**: The material-interpretation review MUST NOT be used for an explicit recommendation selection, a direct statement already expressed in the requested category, or clearly presented imported information.
- **FR-013**: When Decision Context is needed, Highway MUST ask the unresolved question first, follow it with the literal label `**Why it matters:**`, and give one concise user-relevant explanation.
- **FR-014**: Decision Context MUST NOT add a second question or expose implementation mechanics. Relevant Examples MUST remain optional and illustrative rather than required categories.
- **FR-015**: Setup MUST introduce a newly active domain with one short, outcome-oriented transition, separate visible domain transitions with a horizontal rule, and MUST NOT duplicate the receiving owner's opening.
- **FR-016**: The final Setup interaction block MUST contain one response-demanding question or decision at most.
- **FR-017**: A completed guided Setup domain MAY emit one concise user-relevant synthesis before Setup moves to the next active domain when accepted context can be meaningfully summarized. The synthesis MUST introduce no question and expose no orchestration mechanics.
- **FR-018**: Status, Summary, Next Action, Blocking Reason, Action Status, Collection Result, and mutation-result fields that exist only for orchestration MUST NOT appear during normal orchestrated conversation.
- **FR-019**: Machine-oriented owner fields MAY appear when the person directly requests readiness, status, inspection, or a mutation result.
- **FR-020**: After a delegated owner's final guided acknowledgment, synthesis, or next-domain transition, Setup MUST NOT append a machine result after it.
- **FR-021**: Setup MUST consume owner results internally and advance only according to the owning skill's declared contract; the Experience Standard MUST NOT impose a shared collection-result shape.
- **FR-022**: Profile compatibility MUST recognize exactly four readiness domains: Identity, Vision, Competitive Path, and Guiding Principles. Highway Role MUST NOT be treated as a Profile readiness domain.
- **FR-023**: Profile optional enrichment MUST remain non-readiness-bearing and non-blocking, and guided Profile completion MUST be allowed to emit a concise synthesis before control returns to Setup. The Experience Standard MUST NOT add Profile-specific implementation mechanics.
- **FR-024**: Shared interaction behavior MUST remain compatible with Objectives offering Profile-grounded recommendations and capturing explicit selections directly, without copying Objective-specific lifecycle or persistence rules.
- **FR-025**: Shared interaction behavior MUST remain compatible with Controls using accepted Profile, Objective, Control, Highway framing, and declared external expertise as allowed grounding while preserving proposal and user-ownership boundaries, without copying Control-specific workflows.
- **FR-026**: Shared interaction behavior MUST remain compatible with NFRs resolving pending Control-derived candidates first, offering additional grounded recommendations, directly capturing explicit selections, and reserving captured-NFR review for materially interpreted content, without copying NFR-specific workflows.
- **FR-027**: Non-normative examples MUST demonstrate current interaction rules and MUST NOT show orchestration-only machine results as the normal visible conclusion of guided interaction.
- **FR-028**: Every X rule MUST remain a single observable user-visible obligation. Existing rule IDs MUST remain stable and MUST NOT be reused or silently redefined.
- **FR-029**: If a genuinely new shared obligation is required, the amendment MUST allocate a new X identifier rather than changing an existing rule solely to avoid adding one.
- **FR-030**: The amendment MUST apply the Experience Standard versioning policy to the actual observable changes. Because this feature strengthens or redefines existing obligations, the standard version MUST advance from 5.0.0 to 6.0.0 as MAJOR.
- **FR-031**: Amendment metadata MUST consistently record the version change, date, rationale, changed elements, unmodified elements, and self-application review against the Constitution.
- **FR-032**: The final consistency review MUST compare the Experience Standard with constitution.md, setup.md, profile.md, objectives.md, controls.md, and nfrs.md, leaving shared presentation and interaction with the standard and domain-specific behavior, ownership, persistence, readiness, and orchestration with the owning documents.

### Key Entities

- **Experience Standard**: The shared contract for user-visible Highway skill interaction and emitted presentation.
- **Owning workflow**: The Profile, Objectives, Controls, NFRs, or Setup contract that supplies domain context, evidence, state, persistence, and orchestration behavior.
- **Accepted information**: Context that has crossed the applicable owner-defined acceptance boundary and may be reused for later interaction.
- **Proposed information**: Discovered or extracted information that remains provisional until accepted.
- **Grounded recommendation**: A useful, non-duplicate choice derived from context declared by the owning workflow and presented within the shared recommendation limits.
- **Material interpretation**: Content materially inferred from what the person supplied and therefore presented for explicit review under the shared capture heading.
- **Decision Context**: The optional question-first explanation consisting of the unresolved question, the literal `**Why it matters:**` label, and one concise user-relevant explanation.
- **Machine-oriented owner result**: Status, summary, next action, blocking reason, action status, collection result, or mutation-result data used by Setup or another orchestrator and shown only when directly requested.
- **Domain transition**: Setup's short outcome-oriented handoff to a newly active owner, separated from the prior visible domain by a horizontal rule.
- **Completion synthesis**: One concise user-relevant summary emitted at a completed guided domain when accepted context can be meaningfully summarized, without a new question or orchestration mechanics.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of reviewed owner interactions where accepted context supports a useful grounded non-duplicate recommendation, the recommendation appears before an unnecessary guided-collection question.
- **SC-002**: In 100% of reviewed recommendation sets, no more than five actionable choices appear, selection wording matches the number shown, displayed selection is accepted without redundant confirmation, and a user-authored alternative remains available.
- **SC-003**: In 100% of reviewed material interpretations, the required heading, immediate proposal placement, and single bottom acceptance request appear in that order; zero excluded content types use the material-review presentation.
- **SC-004**: In 100% of reviewed Decision Context interactions, the unresolved question precedes the literal label `**Why it matters:**`, exactly one concise explanation follows, and no second question or implementation mechanics appear.
- **SC-005**: In 100% of reviewed multi-domain Setup flows, each newly active domain receives at most one short transition, visible transitions are separated, receiving-owner openings are not duplicated, and the final interaction block has at most one response-demanding question or decision.
- **SC-006**: In 100% of reviewed completed guided domains where meaningful accepted context exists, at most one concise synthesis appears, with zero new questions and zero orchestration mechanics.
- **SC-007**: In 100% of reviewed normal orchestrated conversations, orchestration-only machine fields are absent after owner output and after final acknowledgment, synthesis, or next-domain transition; direct requests continue to expose the requested result.
- **SC-008**: In 100% of reviewed Profile compatibility cases, only Identity, Vision, Competitive Path, and Guiding Principles determine Profile readiness; Highway Role and optional enrichment determine readiness in zero cases.
- **SC-009**: Objectives, Controls, and NFRs retain their domain-specific ownership, lifecycle, persistence, readiness, and derivation behavior in 100% of reviewed consistency checks, while shared recommendation behavior remains compatible.
- **SC-010**: The amendment preserves all existing X rule IDs, allocates no duplicate identifiers, records a 5.0.0 to 6.0.0 MAJOR change, and includes a complete amendment and Constitution self-application review.
- **SC-011**: Zero non-normative examples present orchestration-only machine results as the normal visible conclusion, and zero Experience Standard rules restate Constitution rule text or internal implementation mechanics.

## Assumptions

- The current Experience Standard version is 5.0.0 with 39 X rules, and X2.36 is the next unused identifier.
- Because the requested changes strengthen and redefine existing observable obligations, the correct version is 6.0.0 under the stated versioning policy, not a MINOR or PATCH release.
- Existing rule IDs remain stable; a new ID is added only if the final implementation identifies a genuinely new shared obligation that cannot be expressed by correcting or amending an existing rule.
- The current owner documents remain authoritative for Profile readiness and persistence, Objective ownership and records, Control proposal and readiness behavior, NFR candidate lifecycle and derivation, and Setup orchestration.
- The standard may use concise illustrative examples, but examples are explicitly non-normative and cannot expand owner contracts.
- Direct requests for readiness, status, inspection, or mutation results are distinct from normal delegated guided conversation.
- The requested consistency review covers the current Markdown owner documents named by the request; it does not amend those owner documents unless a separate feature explicitly authorizes it.
- No new runtime dependency or external interface is required for this governance-document amendment.
