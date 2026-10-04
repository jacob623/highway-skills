# Feature Specification: Profile Experience Synchronization

**Feature Branch**: `122-profile-experience-synchronization`

**Created**: 2026-10-01

**Status**: Draft

**Input**: User description: Synchronize only `highway-profile` with Highway Identity and Experience Standard 7.1.0 so Profile owns organizational evidence and persistence while shared documents own conversational acknowledgment, presence, and advisory behavior.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Continue Naturally After Accepted Evidence (Priority: P1)

As a person building an organizational Profile, I want Highway to connect newly accepted evidence to its next recommendation when the evidence changes its understanding, so that Profile feels like one informed conversation rather than disconnected prompts.

**Why this priority**: The central change is to remove local Profile wording that makes shared acknowledgment and natural conversation optional or overly compressed.

**Independent Test**: Review the Profile enrichment model and verification expectations after accepted Identity, Vision, Competitive Path, and Guiding Principles evidence; confirm X2.8 is applied when relevant, natural conversation is allowed, and no local paragraph or sentence quota is imposed.

**Acceptance Scenarios**:

1. **Given** newly accepted Profile evidence changes the understanding used by a later recommendation, **When** Profile advances, **Then** it connects that change to the next response according to X2.8 without prescribing a local acknowledgment sentence.
2. **Given** accepted evidence supports useful explanation, reflection, connection, or contextual commentary, **When** Profile responds, **Then** the shared Conversational Presence model may govern the response without requiring a question or minimal recommendation-only turn.
3. **Given** no useful advisory contribution is grounded, **When** Profile responds, **Then** it does not manufacture commentary merely to lengthen the turn.
4. **Given** the Profile interaction needs a validation question, **When** the response is composed, **Then** Profile preserves the existing validation wording and does not add another response-demanding question.

### User Story 2 - Ground Each Domain From Accepted Profile Evidence (Priority: P1)

As a person reviewing organizational direction, I want each Profile domain recommendation to state what accepted evidence grounds it, so that the recommendation is specific without exposing internal categories or inventing organizational facts.

**Why this priority**: Profile's durable responsibility is the evidence and interpretation behind Identity, Vision, Competitive Path, and Guiding Principles.

**Independent Test**: Inspect each domain's grounding and recommendation guidance, then verify accepted evidence supports the recommendation, internal category names remain hidden, and each domain keeps its existing accuracy-oriented validation path.

**Acceptance Scenarios**:

1. **Given** accepted Identity, website-derived accepted organizational evidence, accepted Vision evidence, and other accepted Profile context, **When** Vision is synthesized, **Then** it uses that accumulated grounding and presents one cohesive future-direction paragraph without prescribing a bridge or lead-in.
2. **Given** accepted Vision and accumulated accepted Profile evidence, **When** Competitive Path is synthesized, **Then** it uses that grounding and presents one cohesive paragraph about pursuing the accepted direction.
3. **Given** accepted Competitive Path and accumulated accepted Profile evidence, **When** Guiding Principles is synthesized, **Then** it uses that grounding and presents one cohesive paragraph about supported decision principles.
4. **Given** a domain recommendation is reviewed, **When** Profile validates it, **Then** the existing accuracy-oriented question and correction or replacement wording remain available.
5. **Given** accepted evidence does not establish enough grounding for useful synthesis, **When** Profile needs the domain, **Then** its canonical question remains the fallback rather than a fabricated recommendation.

### User Story 3 - Preserve Accepted Versus Transient Context (Priority: P1)

As an organization owner, I want richer conversation to remain separate from retained Profile evidence, so that acknowledgments, reflections, advisory observations, and internal reasoning do not silently become organizational facts.

**Why this priority**: Shared conversational behavior must not weaken Profile's ownership, persistence, or readiness boundaries.

**Independent Test**: Review the enrichment and operations guidance against the retained Profile model and verify only accepted organizational narrative, accepted optional context, and existing domain state transitions are retained.

**Acceptance Scenarios**:

1. **Given** a person accepts an organizational narrative or explicitly incorporates a conversational observation into it, **When** Profile persists the result, **Then** only the accepted Profile evidence is retained.
2. **Given** Profile emits an acknowledgment, reflection, implication, tradeoff, concern, alternative, explanatory commentary, or internal category, **When** the person does not incorporate it into accepted Profile evidence, **Then** it remains transient.
3. **Given** accepted evidence changes retained Profile state, **When** Profile returns a dependent result, **Then** persistence precedes that result and existing readiness semantics remain unchanged.
4. **Given** optional enrichment is added to an already `discussed` or `bounded` domain, **When** Profile continues, **Then** readiness and canonical-question behavior remain unchanged.

### User Story 4 - Keep Profile Scope and Compatibility Stable (Priority: P2)

As a governance maintainer, I want Profile to delegate generic conversation to the shared behavioral documents while preserving its domain and persistence contract, so that this synchronization does not create competing interaction rules or alter retained artifacts.

**Why this priority**: The requested change is intentionally narrow and must remain compatible with existing Profile consumers and governance boundaries.

**Independent Test**: Review the Profile skill, Profile-specific checks, shared Profile template, Highway Identity, and Experience Standard together; confirm only Profile-specific guidance and checks are in scope.

**Acceptance Scenarios**:

1. **Given** the Profile skill is updated, **When** its Experience section is reviewed, **Then** it remains exactly `User-visible interaction follows the Highway Experience Standard.`
2. **Given** the shared Profile template is reviewed, **When** this feature is implemented, **Then** `profile-record.md`, schema version `3.0.0`, four domain keys, and readiness semantics remain unchanged.
3. **Given** Profile processes website or organizational evidence, **When** it evaluates scope, **Then** organizational evidence remains in scope and technology-platform or brownfield discovery remains outside scope.
4. **Given** Profile completion is reached, **When** it emits its synthesis, **Then** it remains concise, user-relevant, free of machine fields and implementation details, and free of a new question while naturally connecting accepted understanding to later guidance.
5. **Given** Profile's generic interaction wording is reviewed, **When** shared behavior is already defined elsewhere, **Then** Profile does not duplicate first-person voice, acknowledgment mechanics, Conversational Presence, generic Constructive Advisory, question-ending behavior, recommendation-count wording, Decision Context ordering, or machine-result suppression.

### Edge Cases

- Newly accepted evidence materially changes a downstream recommendation but does not support an additional advisory observation; X2.8 still governs the next response.
- A response benefits from multiple short paragraphs or explanatory reflection; Profile does not impose a local length quota.
- A person accepts a recommendation after transient advisory commentary; only the accepted organizational narrative is retained.
- A person explicitly adopts a previously transient observation into Profile evidence; the adopted content may be retained through the existing acceptance boundary.
- Accepted website-derived organizational evidence remains proposed until accepted; technology discovery remains excluded.
- Organization Name is unavailable; domain guidance uses available accepted Profile context without inventing a name.
- A domain has accepted evidence but no useful grounded synthesis; canonical fallback remains available only when the evidence cannot resolve the need.
- Persistence fails after acceptance; Profile does not report dependent success.
- The existing completion synthesis has no supported Organization Name; it remains natural without inventing one.
- Existing Profile records use schema version `3.0.0`; conversational synchronization does not change the retained schema.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The feature MUST modify only the `highway-profile` skill and directly affected Profile-specific verification or contract tests.
- **FR-002**: The feature MUST NOT modify `.highway/library/templates/output/profile-record.md`, the four Profile readiness domains, readiness semantics, persistence ownership, or completion ownership.
- **FR-003**: Profile MUST continue to own what accepted organizational evidence grounds each domain, while the Experience Standard and Highway Identity own generic conversational behavior.
- **FR-004**: Profile enrichment MUST describe one concise Profile-specific composition model using the concepts of acknowledging when X2.8 applies, conversing naturally, optionally contributing useful perspective, recommending, and validating, without exposing those concepts as user-visible headings or workflow stages.
- **FR-005**: Profile MUST state that acknowledgment follows X2.8 and connects newly accepted evidence to the next response when that evidence changes understanding, interpretation, recommendation, or the next user-relevant action; it MUST NOT duplicate the full X2.8 rule.
- **FR-006**: Profile MUST NOT describe acknowledgment as optional when X2.8 applies.
- **FR-007**: Profile MUST NOT impose a sentence count, paragraph count, minimum-response pattern, or local brevity requirement that conflicts with shared Conversational Presence.
- **FR-008**: Profile-specific advisory permission MUST cover grounded implications, opportunities, useful connections, tradeoffs, tensions, concerns, and sharpening observations when grounded context makes the contribution useful to the Profile interaction.
- **FR-009**: Profile MUST NOT require an advisory contribution on every turn, limit usefulness to decision value alone, or manufacture commentary when grounding does not support it.
- **FR-010**: Profile MUST keep acknowledgments, reflections, advisory observations, implications, tradeoffs, concerns, alternatives, explanatory commentary, and internal enrichment categories transient unless the person explicitly incorporates them into accepted Profile evidence.
- **FR-011**: Profile MUST retain only accepted Identity, Vision, Competitive Path, Guiding Principles, and accepted optional Profile Context as organizational evidence under the existing persistence boundary.
- **FR-012**: Identity MUST preserve its accuracy-oriented validation wording and keep website-derived Organization Name and organizational evidence proposed until accepted.
- **FR-013**: After accepted Identity evidence changes the understanding used to recommend Vision, Profile MUST persist the accepted evidence, re-evaluate the Profile domains, and apply X2.8 to the next response without prescribing a local acknowledgment sentence.
- **FR-014**: Vision MUST use accepted Identity, accepted website-derived organizational evidence, existing accepted Vision evidence, and other accepted Profile context as grounding, then present one cohesive future-direction paragraph supported by accepted evidence.
- **FR-015**: Competitive Path MUST use accepted Vision and accumulated accepted Profile evidence as grounding, then present one cohesive paragraph describing how the organization could pursue its accepted direction.
- **FR-016**: Guiding Principles MUST use accepted Competitive Path and accumulated accepted Profile evidence as grounding, then present one cohesive paragraph expressing supported decision principles.
- **FR-017**: Profile MUST preserve the existing accuracy-oriented validation questions and correction or replacement paths for Identity, Vision, Competitive Path, and Guiding Principles.
- **FR-018**: Profile MUST NOT prescribe exact acknowledgment, conversational bridge, recommendation lead-in, or fixed recommendation sentence wording.
- **FR-019**: Profile MUST preserve canonical questions as fallback acquisition mechanisms and MUST evaluate accepted evidence for useful grounded synthesis before asking them.
- **FR-020**: Profile MUST preserve the acquisition lifecycle of accepted evidence, persistence, all-domain processing, accumulated-context re-evaluation, applicable acknowledgment, natural response, grounded recommendation when available, and canonical fallback only when needed.
- **FR-021**: Profile MUST NOT add separate persisted or workflow states for acknowledgment, conversation, or advisory contribution.
- **FR-022**: Profile MUST preserve the first-time introduction once before Repository Name and MUST NOT repeat it during configure, resume, or retained-Profile interactions.
- **FR-023**: Profile MUST preserve organizational website scope, accepted Organization URL context, proposed-until-accepted website discoveries, and exclusion of registrar, hosting, CMS, commerce, DNS, SaaS, and other technology-platform discovery.
- **FR-024**: Profile completion synthesis MUST naturally connect accepted Profile understanding to how it can inform later Highway guidance, may use first-person conversational identity, and MUST remain concise, user-relevant, free of machine status fields, implementation details, and a new question.
- **FR-025**: The Profile Experience section MUST remain exactly `User-visible interaction follows the Highway Experience Standard.`
- **FR-026**: Profile MUST NOT independently define generic rules for first-person voice, required acknowledgment mechanics, Conversational Presence, multiple-paragraph permission, question-free conclusions, generic Constructive Advisory, recommendation singular-versus-multiple wording, Decision Context ordering, or machine-result suppression.
- **FR-027**: Profile MUST preserve schema version `3.0.0`, the four domain keys, `not_discussed`, `discussed`, and `bounded` meanings, accepted-evidence boundaries, readiness ownership, and completion ownership.
- **FR-028**: Profile MUST preserve recommendation-first acquisition, accepted recommendation to `discussed` behavior, canonical fallback, persistence-before-dependent-result behavior, and all existing error handling.
- **FR-029**: Verification MUST cover enrichment rationalization, X2.8 applicability, natural conversational depth without local quotas, optional grounded advisory contribution, transient-versus-retained separation, all four domain grounding paths, canonical fallback, persistence ordering, readiness, website scope, completion synthesis, and template compatibility.
- **FR-030**: The existing `highway-profile` version `5.1.0` MUST remain unchanged unless the repository's Skill Versioning Policy requires a documented release classification; conversational synchronization MUST NOT change the retained Profile schema version.
- **FR-031**: Profile-specific tests MUST reject the removed optional-acknowledgment wording, decision-only advisory restriction, fixed local brevity wording, stale contextualization wording, and duplicated generic interaction rules.
- **FR-032**: Profile-specific tests MUST preserve the existing validation questions, canonical fallback prompts, first-time introduction, four-domain readiness, accepted-evidence persistence boundary, brownfield exclusion, and shared Experience sentence.
- **FR-033**: No individual skill other than `highway-profile`, Highway Identity, Experience Standard, Profile record, shared output template, Profile schema, or unrelated governance artifact may be modified by this feature.

### Key Entities

- **Profile**: The retained organizational context with four readiness domains, optional accepted context, domain narratives, and schema version `3.0.0`.
- **Accepted Profile evidence**: User-provided or user-accepted organizational information that may be persisted and reused across domains.
- **Transient conversational context**: Acknowledgment, reflection, advisory contribution, explanation, implications, tradeoffs, concerns, alternatives, and internal categories that remain unretained unless explicitly adopted.
- **Domain grounding**: The accepted evidence used to support Identity, Vision, Competitive Path, or Guiding Principles recommendations.
- **Canonical fallback question**: The domain-specific acquisition question used only when accepted evidence cannot support a useful grounded recommendation.
- **Completion synthesis**: The concise user-relevant summary emitted after guided Profile completion and before control returns to Setup.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of reviewed Profile enrichment guidance uses the single Profile-specific composition model and contains no duplicated Acknowledge/Build/Recommend/Validate description.
- **SC-002**: 100% of reviewed cases where accepted evidence materially changes Profile understanding preserve applicable X2.8 acknowledgment behavior without requiring Profile to prescribe a sentence.
- **SC-003**: 100% of reviewed Profile turns permit useful explanation, reflection, connection, or contextual commentary when appropriate without imposing sentence, paragraph, or minimum-response quotas.
- **SC-004**: 100% of reviewed grounded advisory cases allow implications, opportunities, connections, tradeoffs, tensions, concerns, or sharpening observations when useful, while unsupported cases contain no manufactured advisory contribution.
- **SC-005**: 100% of reviewed retained Profile narratives contain only accepted organizational evidence; transient conversational context and unadopted internal categories appear in 0% of retained narratives.
- **SC-006**: 100% of Identity, Vision, Competitive Path, and Guiding Principles recommendation paths preserve their existing accuracy-oriented validation questions and correction or replacement paths.
- **SC-007**: 100% of reviewed domain recommendations use the specified accepted-evidence grounding and preserve canonical fallback when grounding cannot resolve the need.
- **SC-008**: 100% of accepted Profile mutations preserve persistence-before-dependent-result behavior, four-domain readiness, and existing state meanings.
- **SC-009**: 100% of scope reviews find no change to `profile-record.md`, schema version `3.0.0`, website scope, brownfield exclusion, completion ownership, or the shared Experience sentence.
- **SC-010**: 100% of focused Profile contracts pass after implementation, and the complete applicable repository validation suite reports no Feature 122 regression.

## Assumptions

- The current authoritative `highway-profile` version is 5.1.0, so this synchronization preserves that version rather than adding another bump.
- Highway Identity and Experience Standard 7.1.0 are authoritative for Conversational Identity, Conversational Presence, Constructive Advisory, and X2.8; this feature cites and delegates to them rather than copying their generic rules.
- The existing Profile acceptance boundary, acquisition order, persistence behavior, readiness states, completion synthesis, website scope, and error handling remain authoritative.
- Profile-specific verification may update focused tests, but no generated adapter, shared template, Profile record, or unrelated governance artifact is required.
- No new storage, runtime state, public interface, external integration, or dependency is introduced.
- Existing Profile records remain compatible because this feature changes conversational guidance and verification, not retained schema or domain keys.
- No extension hooks are registered for this specification workflow.
