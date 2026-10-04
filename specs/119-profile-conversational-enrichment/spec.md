# Feature Specification: Profile Conversational Enrichment

**Feature Branch**: `119-profile-conversational-enrichment`

**Created**: 2026-10-01

**Status**: Draft

**Input**: User description: Update only `highway-profile` so synthesized Profile recommendations validate organizational understanding with accuracy-oriented language and a Profile-specific acknowledge, optional advisory build, recommend, and validate composition model while preserving the existing recommendation-first acquisition model, four-domain readiness, persistence boundary, brownfield scope, completion synthesis, and shared Experience Standard ownership.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Validate Organizational Understanding (Priority: P1)

As a person reviewing a Profile recommendation, I want Highway to ask whether its description accurately reflects my organization, so that I can confirm, correct, or replace the understanding without feeling like I am approving a system transaction.

**Why this priority**: Accuracy-oriented validation is the user-visible behavior that establishes trust in every synthesized Profile domain.

**Independent Test**: Present Identity, Vision, Competitive Path, and Guiding Principles recommendations with accepted Organization Name context and verify each uses the required accuracy-oriented validation question and an explicit correction or replacement path, with no second confirmation.

**Acceptance Scenarios**:

1. **Given** a synthesized Identity description is ready for review, **When** Profile validates it, **Then** it asks `**Is this an accurate description of your organization?**` and follows with `You can also change it or provide your own description.`
2. **Given** a synthesized Vision recommendation is ready and an Organization Name is accepted, **When** Profile validates it, **Then** it asks `**Does this accurately reflect where you'd like [Organization Name] to go?**` and follows with `You can also change it or provide your own vision.`
3. **Given** a synthesized Competitive Path recommendation is ready and an Organization Name is accepted, **When** Profile validates it, **Then** it asks `**Does this accurately reflect how [Organization Name] plans to get there?**` and follows with `You can also change it or provide your own approach.`
4. **Given** a synthesized Guiding Principles recommendation is ready and an Organization Name is accepted, **When** Profile validates it, **Then** it asks `**Does this accurately reflect what should guide decisions at [Organization Name]?**` and follows with `You can also change it or provide your own principles.`
5. **Given** a person responds affirmatively to a validation question, **When** Profile processes the response, **Then** it accepts the displayed proposal without adding a second confirmation.
6. **Given** a person requests an explanation rather than accepting, **When** Profile processes the response, **Then** the request remains clarification and does not establish the domain.

### User Story 2 - Receive Useful Conversational Enrichment (Priority: P1)

As a person developing an organizational Profile, I want recommendations to acknowledge what Highway understood and contribute a grounded observation when useful, so that the recommendation helps sharpen my thinking rather than merely repeating my words or seeking agreement.

**Why this priority**: The composition model makes Profile recommendations more useful while keeping the retained narrative concise and evidence-owned.

**Independent Test**: Provide accepted evidence that supports each synthesized domain and verify the user-visible turn may acknowledge the latest understanding, may add one grounded advisory contribution, presents one cohesive recommendation, and ends with one validation question and a correction path.

**Acceptance Scenarios**:

1. **Given** accepted Profile evidence supports a Vision synthesis, **When** Profile responds, **Then** it may briefly connect the newly accepted information to the accumulated organizational context before presenting the cohesive Vision recommendation.
2. **Given** accepted Profile evidence supports a Competitive Path synthesis, **When** Profile responds, **Then** it may identify one grounded implication, opportunity, tradeoff, concern, or sharpening observation before presenting the recommendation.
3. **Given** accepted Profile evidence supports Guiding Principles, **When** Profile responds, **Then** it may identify one useful decision-related observation before presenting principles that have decision value.
4. **Given** accepted evidence supports no useful advisory contribution, **When** Profile presents a recommendation, **Then** it does not manufacture commentary merely to make the response longer.
5. **Given** accepted evidence supports a concern or alternative interpretation, **When** Profile contributes that observation, **Then** it states the observation respectfully without manufacturing agreement or overriding user ownership.
6. **Given** a synthesized recommendation turn is complete, **When** Profile validates it, **Then** the turn contains exactly one response-demanding question followed by the quiet correction or replacement option and no additional question.
7. **Given** a recommendation turn is composed, **When** Profile presents it, **Then** the conceptual acknowledge, build, recommend, and validate parts are not exposed as headings or workflow stages.

### User Story 3 - Preserve Accepted Evidence and Domain Ownership (Priority: P1)

As a person completing a Profile, I want only the accepted organizational narrative to become retained evidence, so that conversational context and optional advisory commentary do not silently change my Profile or its readiness.

**Why this priority**: The composition update must improve the conversation without weakening user ownership, persistence ordering, or the existing Profile state model.

**Independent Test**: Accept, correct, replace, decline, and ask for explanation about recommendations; verify only the accepted cohesive narrative is persisted, domain states transition correctly, and dependent results occur only after persistence.

**Acceptance Scenarios**:

1. **Given** a person accepts a displayed Identity, Vision, Competitive Path, or Guiding Principles recommendation, **When** Profile persists the response, **Then** only the accepted cohesive domain narrative becomes retained evidence and the domain becomes `discussed`.
2. **Given** a person corrects or replaces a displayed recommendation, **When** Profile persists the response, **Then** the accepted alternative replaces the staged proposal and becomes the retained domain evidence.
3. **Given** a person discusses an implication, tradeoff, concern, or alternative without adopting it, **When** Profile persists the interaction, **Then** that commentary is not retained as domain narrative.
4. **Given** internal enrichment categories support reasoning, **When** Profile presents or persists the recommendation, **Then** those category names are neither presented nor persisted.
5. **Given** an accepted paragraph establishes a domain, **When** Profile selects the next interaction, **Then** it does not ask that domain's fallback canonical question.
6. **Given** optional advisory commentary is omitted or declined for an already `discussed` or `bounded` domain, **When** Profile continues, **Then** readiness remains unchanged and continuation is not blocked.
7. **Given** accepted Profile evidence changes retained state, **When** Profile returns readiness or another dependent owner result, **Then** persistence precedes that result.

### User Story 4 - Preserve Existing Profile Boundaries (Priority: P2)

As a governance maintainer, I want conversational enrichment to remain a Profile-only presentation refinement, so that the retained four-domain schema, recommendation-first acquisition, brownfield boundary, completion synthesis, and shared interaction ownership remain compatible.

**Why this priority**: Compatibility ensures the richer conversation does not expand Profile scope or create competing copies of shared interaction rules.

**Independent Test**: Review the updated Profile skill and its verification contracts against the retained template, Highway identity, Experience Standard, and existing Profile behavior; confirm only Profile-specific behavior changes.

**Acceptance Scenarios**:

1. **Given** accepted evidence changes Profile state, **When** acquisition proceeds, **Then** Profile preserves the order accepted evidence, persistence, all-domain re-evaluation, grounded recommendation attempt, and canonical-question fallback.
2. **Given** Profile readiness is evaluated, **When** optional commentary or enrichment is present, **Then** only the four existing domains determine readiness.
3. **Given** Profile processes website or organizational evidence, **When** it evaluates the evidence, **Then** technology-platform and brownfield discovery remain outside Profile.
4. **Given** guided Profile completion is reached, **When** control returns to Setup, **Then** the existing concise completion synthesis remains unchanged in purpose and ownership.
5. **Given** the Profile skill's Experience section is reviewed, **When** generic interaction behavior is described, **Then** it remains `User-visible interaction follows the Highway Experience Standard.` without copied generic advisory, recommendation, acceptance, or single-question rules.
6. **Given** the shared Profile template is reviewed, **When** this feature is implemented, **Then** `profile-record.md` remains unchanged and the existing four-domain schema remains compatible.

### Edge Cases

- Organization Name is unavailable; Vision, Competitive Path, and Guiding Principles validation uses the best accepted Profile context without inventing a name.
- The latest accepted information adds no useful implication or advisory observation; Profile proceeds with a concise acknowledgment or recommendation without manufactured commentary.
- A grounded concern conflicts with the person's apparent preference; Profile states it respectfully and leaves ownership with the person.
- A person asks why a recommendation was made; the explanation request does not count as acceptance and does not persist the staged recommendation.
- A person gives a natural affirmative response; the displayed proposal is accepted without a second confirmation question.
- A person corrects or replaces a recommendation after advisory commentary; only the accepted alternative is persisted.
- Advisory commentary mentions a tradeoff or concern that the person does not adopt; it remains transient.
- An already `discussed` or `bounded` domain receives optional enrichment; readiness and canonical-question behavior remain unchanged.
- Website evidence is supplied; organizational evidence remains within Profile and technology-platform discovery remains out of scope.
- Persistence fails after conversational validation; Profile does not return a successful dependent result.
- Completion is reached after the final accepted mutation; Profile emits the existing completion synthesis rather than a second validation or first-time introduction.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The feature MUST modify only the `highway-profile` skill and Profile-specific verification or contract tests; it MUST NOT modify `profile-record.md`.
- **FR-002**: Profile MUST preserve exactly four readiness domains: Identity, Vision, Competitive Path, and Guiding Principles.
- **FR-003**: Profile MUST preserve the existing `not_discussed`, `discussed`, and `bounded` readiness states and their current meanings.
- **FR-004**: Identity validation MUST use `**Is this an accurate description of your organization?**` followed by `You can also change it or provide your own description.` rather than transactional accept/change wording.
- **FR-005**: Vision validation MUST use `**Does this accurately reflect where you'd like [Organization Name] to go?**` followed by `You can also change it or provide your own vision.` when Organization Name is available.
- **FR-006**: Competitive Path validation MUST use `**Does this accurately reflect how [Organization Name] plans to get there?**` followed by `You can also change it or provide your own approach.` when Organization Name is available.
- **FR-007**: Guiding Principles validation MUST use `**Does this accurately reflect what should guide decisions at [Organization Name]?**` followed by `You can also change it or provide your own principles.` when Organization Name is available.
- **FR-008**: Each Profile-specific validation MUST preserve an explicit correction or replacement path.
- **FR-009**: Natural affirmative responses MUST accept the displayed recommendation through the existing acceptance boundary without a second confirmation.
- **FR-010**: A request for explanation or clarification MUST NOT count as acceptance of the displayed recommendation.
- **FR-011**: Synthesized Vision, Competitive Path, and Guiding Principles turns MAY begin with a concise acknowledgment connecting the latest accepted information to accumulated Profile context.
- **FR-012**: A synthesized recommendation MAY include one grounded implication, opportunity, useful connection, tradeoff, tension, concern, or sharpening observation when accepted evidence supports it.
- **FR-013**: Profile MUST NOT manufacture an advisory observation merely to lengthen a response and MUST NOT manufacture agreement.
- **FR-014**: A grounded concern or alternative interpretation MUST be stated respectfully and MUST preserve user ownership.
- **FR-015**: The Profile-specific composition model MUST organize a synthesized turn conceptually as acknowledge, optionally build, recommend, and validate without exposing those terms as headings or workflow stages.
- **FR-016**: The cohesive recommendation MUST remain the only conversational portion intended to become retained domain narrative when accepted.
- **FR-017**: Acknowledgment and advisory commentary MUST remain transient and MUST NOT be persisted as domain narrative unless the person explicitly incorporates that content into the accepted proposal.
- **FR-018**: Synthesized paragraphs MUST contain only organizational claims supported by accepted evidence.
- **FR-019**: Internal enrichment-category names MUST remain reasoning inputs only and MUST NOT be presented to the user or persisted.
- **FR-020**: Each synthesized recommendation turn MUST end with exactly one response-demanding validation question followed by the quiet correction or replacement option, with no second question or additional `Why it matters` block added solely for validation.
- **FR-021**: Profile MUST preserve the existing recommendation-first order: accepted evidence, persistence, all-domain re-evaluation, grounded recommendation attempt, then canonical question only when grounding cannot resolve the domain.
- **FR-022**: Acceptance of an Identity, Vision, Competitive Path, or Guiding Principles recommendation MUST establish the applicable unresolved domain as `discussed`.
- **FR-023**: A domain established as `discussed` by accepted recommendation evidence MUST NOT receive its fallback canonical question afterward.
- **FR-024**: Optional advisory commentary and optional enrichment MUST NOT change readiness, block continuation, or require another question for an already `discussed` or `bounded` domain.
- **FR-025**: Only accepted organizational evidence MUST be persisted; conversational acknowledgment, unadopted commentary, unadopted tradeoffs, unadopted concerns, unadopted alternative ideas, and internal category names MUST remain transient.
- **FR-026**: Accepted Profile evidence MUST be persisted before dependent readiness or owner results are returned, and failed persistence MUST NOT be represented as successful mutation.
- **FR-027**: Profile MUST preserve its existing four-domain readiness, brownfield boundary, completion synthesis, and machine-result ownership behavior.
- **FR-028**: Profile MUST preserve the shared Experience Standard boundary and MUST NOT copy generic Constructive Advisory, recommendation, acceptance, or single-question rules into the Experience section.
- **FR-029**: The Profile Experience section MUST remain exactly `User-visible interaction follows the Highway Experience Standard.`
- **FR-030**: The feature MUST preserve the existing Profile schema and MUST NOT change `.highway/library/templates/output/profile-record.md`.
- **FR-031**: Verification MUST cover accuracy-oriented validation for all four supported recommendation domains, correction or replacement paths, optional acknowledgment and advisory contribution, non-manufactured commentary, transient conversational content, single-question validation, recommendation-first behavior, readiness, persistence ordering, brownfield scope, completion synthesis, and template compatibility.
- **FR-032**: The existing `highway-profile` version `5.1.0` MUST be preserved; this feature folds presentation refinements into the current version rather than introducing another version bump.

### Key Entities

- **Validation prompt**: The Profile-specific accuracy-oriented question and quiet correction or replacement option for a synthesized domain recommendation.
- **Acknowledgment**: Transient conversational context connecting newly accepted evidence to accumulated Profile understanding.
- **Advisory contribution**: An optional transient observation grounded in accepted Profile evidence that may identify an implication, opportunity, tradeoff, concern, or sharpening direction.
- **Cohesive domain recommendation**: The single grounded Vision, Competitive Path, or Guiding Principles paragraph intended for possible retention.
- **Accepted domain narrative**: The cohesive recommendation or user-authored alternative that the person accepts and Profile persists as domain evidence.
- **Readiness domain**: Identity, Vision, Competitive Path, or Guiding Principles with the existing readiness state.
- **Transient conversational context**: Acknowledgment, unadopted commentary, and internal reasoning material that must not become retained Profile evidence.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of reviewed Identity, Vision, Competitive Path, and Guiding Principles validation turns, the accuracy-oriented question and explicit correction or replacement path are present, and no transactional `accept this` wording remains.
- **SC-002**: In 100% of natural affirmative responses to displayed recommendations, the recommendation is accepted without a second confirmation question.
- **SC-003**: In 100% of explanation or clarification requests about staged recommendations, the request does not establish the domain or persist the staged proposal.
- **SC-004**: In 100% of grounded synthesized turns, Profile presents one cohesive recommendation paragraph and ends with exactly one response-demanding validation question.
- **SC-005**: In 100% of reviewed cases where accepted evidence supports a useful advisory contribution, Profile may provide at most one grounded contribution before the recommendation, while cases without useful contribution contain no manufactured advisory commentary.
- **SC-006**: Zero reviewed retained Profile narratives contain acknowledgment text, unadopted advisory commentary, unadopted concerns or tradeoffs, or internal enrichment-category names.
- **SC-007**: In 100% of accepted recommendation cases, the applicable domain becomes `discussed`, its canonical question is not repeated, and persistence precedes dependent results.
- **SC-008**: Optional advisory commentary and enrichment change readiness in 0% of reviewed cases for already `discussed` or `bounded` domains.
- **SC-009**: Existing recommendation-first acquisition, four-domain readiness, brownfield boundary, persistence ordering, completion synthesis, and shared Experience Standard ownership continue to pass their current contract checks.
- **SC-010**: The shared Profile template remains unchanged and the Profile skill remains at version `5.1.0`.

## Assumptions

- The current `highway-profile` skill is already version `5.1.0`; this feature preserves that version because it refines the current user-visible guarantee rather than introducing a new release capability.
- The current Profile acceptance boundary, recommendation-first ordering, persistence-before-result behavior, readiness model, brownfield boundary, completion synthesis, and shared Experience Standard remain authoritative.
- The supplied validation wording is normative for Profile-specific validation prompts; generic acceptance and alternative handling remain owned by the Experience Standard.
- Acknowledgment and advisory commentary are transient unless the person explicitly incorporates them into an accepted replacement or correction.
- A useful advisory contribution is optional and evidence-dependent; Profile must prefer omission over manufactured commentary.
- Existing Profile records and the shared `profile-record.md` template remain compatible with these presentation changes.
- No new retrieval service, storage mechanism, public API, or external integration is introduced.
- Highway identity and the Experience Standard remain authoritative sources for generic Constructive Advisory and interaction behavior; Profile adds only its domain composition model.
- No extension hooks are registered for this specification workflow.
