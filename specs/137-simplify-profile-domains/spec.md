# Feature Specification: Simplify Profile Domain Meaning

**Feature Branch**: `137-simplify-profile-domains`

**Created**: 2026-10-03

**Status**: Draft

**Input**: User description: Amend the highway-profile skill from baseline version 5.3.0 without a wholesale rewrite. Keep the working interaction architecture, simplify Vision to the desired future and Competitive Path to the broad strategic approach, keep Guiding Principles as enduring decision principles, preserve Identity breadth, add existing-context acquisition and transient organizational expression, strengthen the acceptance-to-persistence boundary, and remove the internal enrichment-category framework. Do not change the Profile record, Experience Standard, Setup, Controls, NFRs, or Constitution, and do not change Profile schema 3.0.0.

## Clarifications

### Session 2026-10-03

- Q: If someone volunteers a safeguard, operational expectation, or implementation detail while explaining how the organization will get there, what should Profile do with it? → A: Profile may use volunteered downstream detail as evidence of the broad Competitive Path, but it does not develop or retain that detail as a safeguard, NFR, architecture, or implementation requirement.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Reuse existing organizational context (Priority: P1)

As a person starting or continuing Profile, I want one chance to share something that already describes the organization, so that I do not have to recreate known context one question at a time.

**Why this priority**: Recreating context the person already has is the main avoidable burden. Acquisition must happen before ordinary domain questioning and must feed every unresolved Profile domain.

**Independent Test**: Start Profile with a missing Repository Name, supply the name, and then either provide a website, a description, strategy material, or an assistant export or summary, or decline. Verify that usable material is interpreted before the first ordinary Profile-domain question, and that declining continues the conversation without exposing unavailable retrieval.

**Acceptance Scenarios**:

1. **Given** Repository Name has just been accepted and ordinary domain questioning has not started, **When** Profile continues, **Then** it offers one opportunity to reuse existing organizational material, such as a public website, an existing description or strategy document, or an export or summary from another assistant, and makes clear that the Profile can instead be built together.
2. **Given** the person supplies usable existing material, **When** Profile receives it, **Then** Profile processes that material before asking an ordinary Profile-domain question.
3. **Given** the person supplies a public website and supported retrieval is available, **When** Profile acquires from it, **Then** it retrieves organizational Profile evidence only, and the supplied Organization URL is accepted optional context while derived Organization Name and other derived facts stay proposed until accepted.
4. **Given** the person supplies another readable source, **When** Profile acquires from it, **Then** the supplied material is acquisition evidence, not automatically accepted Profile knowledge, and it does not need to use Profile's domains, headings, schema, or vocabulary.
5. **Given** no usable existing material is available, or supported retrieval is unavailable, **When** Profile continues, **Then** it continues conversational development without exposing unavailable retrieval mechanics.
6. **Given** supplied material contains evidence for more than one unresolved Profile domain, **When** Profile interprets it, **Then** it evaluates that evidence across Identity, Vision, Competitive Path, and Guiding Principles before deciding what the person still needs to provide, and does not ask the person to reproduce information already present.

---

### User Story 2 - Develop a simple desired future (Priority: P1)

As a person defining direction, I want Vision to mean the future the organization is trying to create, so that Profile does not turn that conversation into a checklist of internal strategy dimensions.

**Why this priority**: Vision is the first domain this amendment narrows. An internal category framework was over-steering the conversation away from the desired future.

**Independent Test**: Accept an Identity, including one with several meaningful activities, then develop Vision. Verify that Profile reasons from the full accepted Identity, develops only uncertainty that can change the desired future, and does not require coverage of internal Vision categories.

**Acceptance Scenarios**:

1. **Given** accepted Identity and other relevant accepted Profile evidence, **When** Vision opens, **Then** Profile re-evaluates that context, opens the "where you're going" conversation, and presents a Converged Proposal when the desired future is already supported, otherwise contributes a useful Vision Working Idea when supported, otherwise asks what the future vision of the organization is.
2. **Given** a Vision Working Idea exists, **When** Profile needs more information, **Then** it asks only about unresolved information that can materially change the desired future, rather than decomposing Vision into internal dimensions.
3. **Given** accepted Identity contains multiple meaningful activities or expressions, **When** Vision is developed, **Then** Profile considers how those parts affect the future being created and does not let one prominent facet become the whole Vision merely because it is the easiest continuation.
4. **Given** the relationship among accepted Identity evidence creates consequential uncertainty about the desired future and the person's information is required, **When** Profile evaluates it, **Then** it asks one focused question; otherwise it incorporates the responsible interpretation into the Working Idea.
5. **Given** accepted evidence supports more than one materially distinct future direction, **When** Profile contributes a Vision Working Idea, **Then** it may present a small grounded set of alternatives and a grounded advisory perspective while preserving the person's own direction, and it does not create alternatives merely to force a choice or cover an internal dimension.
6. **Given** Profile materially shaped the substantive Vision, **When** the Vision is ready to converge, **Then** Profile applies the shared Contribution Opportunity unless an equivalent opportunity or shared exception applies, then synthesizes one cohesive Vision and asks whether it accurately reflects where the organization should go, while still allowing the person to change it or provide their own vision.

---

### User Story 3 - Keep the path broad and the principles enduring (Priority: P1)

As a person explaining how the organization intends to progress, I want Competitive Path to stay a broad approach and Guiding Principles to stay enduring decision guidance, so that safeguards, operational expectations, and implementation planning remain with their later owners.

**Why this priority**: Profile was drifting into work owned by Controls, NFRs, architecture, and implementation. The amendment exists to stop that drift without weakening contextual reasoning.

**Independent Test**: Accept Identity and Vision, then develop Competitive Path and Guiding Principles. Verify that Profile can discuss strategic choices, sequencing, priorities, and principles already visible in accepted context; that it does not ask safeguard questions or turn principles into enforceable Controls; and that volunteered downstream detail may inform the broad path without being retained as a safeguard, operational expectation, architecture, or implementation requirement.

**Acceptance Scenarios**:

1. **Given** accepted Identity, accepted Vision, and other relevant accepted Profile evidence, **When** Competitive Path opens, **Then** Profile re-evaluates that context, opens the "how you'll get there" conversation, and presents a Converged Proposal when supported, otherwise contributes a useful Working Idea when supported, otherwise asks how the organization plans to get there.
2. **Given** a Competitive Path Working Idea, **When** Profile develops it, **Then** it may develop broad strategic choices, sequencing, approaches, priorities, or organizational direction when those explain the intended progress, and it asks only about unresolved information that can materially change that broad approach.
3. **Given** Competitive Path is active, **When** Profile chooses its next question, **Then** it does not ask about enforceable safeguards, Controls, NFRs, architecture, implementation requirements, or detailed plans.
4. **Given** the person volunteers a safeguard, operational expectation, architecture note, or implementation detail during Competitive Path, **When** Profile develops the path, **Then** Profile may use that volunteered downstream detail as evidence of the broad Competitive Path, and it does not develop or retain that detail as a safeguard, NFR, architecture, or implementation requirement.
5. **Given** a constraint, dependency, capability, concern, or tradeoff arises, **When** Profile considers it during Competitive Path, **Then** it remains in Competitive Path only when it changes interpretation of the broad organizational approach.
6. **Given** Profile materially shaped the substantive path, **When** the path is ready to converge, **Then** Profile applies the shared Contribution Opportunity unless an equivalent opportunity or shared exception applies, then synthesizes one cohesive Competitive Path and asks whether it accurately reflects how the organization plans to get there, while still allowing the person to change it or provide their own approach.
7. **Given** Competitive Path has been accepted, **When** Guiding Principles begins, **Then** Profile re-evaluates accumulated Profile evidence for principles already becoming visible, opens the "what will guide your decisions" conversation, and presents a Converged Proposal when supported, otherwise contributes a useful Working Idea when supported, otherwise asks what principles or values guide decisions.
8. **Given** a Guiding Principles Working Idea exists, **When** Profile needs more information, **Then** it asks only about an unresolved principle or decision priority that can materially change the organizational principles being developed, and it does not turn a principle into an enforceable Control merely to make it more precise.
9. **Given** Profile materially shaped Guiding Principles, **When** they are ready to converge, **Then** the existing Contribution Opportunity and final Guiding Principles validation behavior still apply.

---

### User Story 4 - Keep Identity broad and contributable (Priority: P1)

As a person reviewing who the organization is, I want Profile to keep the successful Identity breadth behavior and let me contribute when Profile assembled that picture, so that imported or discovered context does not silently become a narrow or finished Identity.

**Why this priority**: Identity remains the foundation for the simplified later domains. The amendment extends contribution to materially assembled Identity without forcing it on a complete user-supplied Identity.

**Independent Test**: Supply website evidence, imported material, multiple sources, or a complete user-written Identity. Verify the provisional-breadth path when Profile materially assembles the picture, the direct accuracy path when the person supplied a domain-complete Identity that Profile does not reshape, and a single Identity accuracy validation rather than a duplicate earlier prompt.

**Acceptance Scenarios**:

1. **Given** website evidence, imported organizational material, other discovered evidence, or direct user input establishes multiple meaningful aspects of what the organization does, **When** Profile develops Identity, **Then** it establishes the meaningful organizational picture and provides provisional facets before final synthesis.
2. **Given** Profile materially assembles or interprets Identity from website discovery, imported organizational material, multiple evidence sources, or substantial synthesis, **When** no equivalent opportunity has already occurred, **Then** Profile presents provisional substantive pieces and offers one Contribution Opportunity before the Converged Proposal.
3. **Given** the person supplies a domain-complete Identity that Profile does not materially reshape, **When** Profile evaluates it, **Then** it may proceed directly to the accuracy-oriented validation path without a distinct Contribution Opportunity.
4. **Given** the person adds something missing to provisional Identity, **When** Profile continues, **Then** it re-evaluates, clarifies only when consequential uncertainty requires the person's information, synthesizes one cohesive Identity, and validates accuracy once through the detailed Identity development behavior.
5. **Given** Identity development reaches validation, **When** the person is asked whether the description is accurate, **Then** that validation occurs through the detailed Identity development behavior and is not also issued as a separate earlier Identity validation prompt.

---

### User Story 5 - Treat acceptance as authorization to save, not as a saved result (Priority: P1)

As a person who has accepted a Profile domain, I want that acceptance retained before Profile moves on, so that later conversation and setup do not treat unsaved knowledge as accepted organizational context.

**Why this priority**: Conversational acceptance was being treated too much like a completed save. Dependent Profile behavior, completion, and return to Setup must wait for a successful owner mutation.

**Independent Test**: Accept a domain proposal, including the final guided domain, and separately force an accepted mutation to fail. Verify that successful acceptance is persisted before any dependent behavior, and that failure stops progression without a completion synthesis or a terminal result that would let Setup advance.

**Acceptance Scenarios**:

1. **Given** a Converged Proposal is accepted and changes retained Profile state, **When** Profile continues, **Then** it immediately constructs and performs the accepted Profile mutation before selecting any behavior that depends on that accepted domain.
2. **Given** the person accepts a recommendation, discovery, imported evidence, or correction, **When** that acceptance changes retained Profile state, **Then** the same persistence boundary applies, and conversational acceptance alone is not a successful mutation.
3. **Given** an accepted mutation has not yet succeeded, **When** Profile selects its next behavior, **Then** it does not advance as though that domain's knowledge were retained.
4. **Given** an accepted mutation succeeds, **When** Profile continues, **Then** the accepted domain becomes available for contextual re-evaluation and subsequent Profile behavior.
5. **Given** guided setup or configure is ready to complete, **When** any accepted mutation for a discussed or bounded Profile domain is unperformed or failed, **Then** Profile does not emit the guided completion synthesis and does not return a terminal Profile result.
6. **Given** the final domain is accepted, **When** guided completion is reached, **Then** Profile persists that mutation before emitting the completion synthesis and before returning to Setup.
7. **Given** an accepted Profile mutation fails, **When** Profile handles the failure, **Then** the affected domain is not established as persisted, Profile stops before dependent progression, and it reports actionable user-facing failure context under the existing common failure model, without adding a post-write read-back or verification stage.

---

### User Story 6 - Sound like the organization without inventing truth (Priority: P2)

As a person reviewing Profile proposals, I want recognizable organizational language used when it is accurate, so that proposals feel natural without treating tone, marketing, or source phrasing as proof of organizational facts.

**Why this priority**: Expression improves the conversation after acquisition works, but it must not become a new retained domain or a source of unsupported claims.

**Independent Test**: Supply acquisition material with consistent organizational terminology and separate marketing claims that are not otherwise supported. Verify that suitable terminology can shape later proposals in the same interaction, that the person's corrections win, and that no expression, tone, voice, style, or persona information is retained.

**Acceptance Scenarios**:

1. **Given** suitable acquisition sources show characteristic terminology, recurring language, recognizable phrasing, formality, or other communication patterns, **When** Profile prepares proposals, **Then** that expression may shape how supported Identity, Vision, Competitive Path, and Guiding Principles evidence is expressed.
2. **Given** source language is available, **When** Profile uses it, **Then** it does not establish unsupported organizational facts, strategy, intentions, priorities, or principles, and it does not treat tone, style, phrasing, terminology, or communication patterns as evidence that a substantive claim is true.
3. **Given** acquisition evidence consistently uses recognizable organizational terminology, **When** that terminology accurately expresses supported meaning, **Then** Profile uses it in Working Ideas and Converged Proposals, without imitating marketing language for stylistic similarity, preserving unsupported marketing claims, or sacrificing clarity.
4. **Given** the person uses different wording or corrects source-derived expression, **When** Profile continues the active interaction, **Then** the person's active wording and corrections remain authoritative.
5. **Given** expression guidance was useful earlier in the interaction, **When** later Vision, Competitive Path, or Guiding Principles proposals are formed, **Then** the same recognizable language may be used while it remains suitable, and the guidance stays transient.
6. **Given** the Profile interaction ends, **When** retained Profile knowledge is inspected, **Then** expression guidance has created no retained domain, readiness state, tone field, voice field, persona, style classification, or terminology field, and it has not automatically controlled Objectives, Controls, NFRs, or other Highway owners.

---

### User Story 7 - Keep the amendment inside Profile (Priority: P1)

As a maintainer of Highway, I want this amendment to change only the highway-profile skill contract, so that simpler domain meaning does not rewrite shared interaction rules, retained Profile structure, or neighboring owners.

**Why this priority**: The value of the amendment depends on staying inside Profile. Neighboring documents already own shared interaction, retained structure, setup order, safeguards, and operational expectations.

**Independent Test**: Compare the amended skill with its 5.3.0 baseline and with protected neighboring artifacts. Verify the title heading, version classification, unchanged shared interaction behavior, unchanged schema, and zero required edits outside the Profile skill.

**Acceptance Scenarios**:

1. **Given** the highway-profile skill is amended, **When** its title is inspected, **Then** the primary title is the top-level heading `highway-profile`.
2. **Given** the amendment is classified, **When** the skill version is published, **Then** it is the MAJOR successor of baseline 5.3.0 because existing behavioral guarantees are removed, narrowed, or redefined, and the Profile schema version remains 3.0.0.
3. **Given** retained Profile structure is inspected, **When** the amendment is complete, **Then** it still has exactly `identity`, `vision`, `competitive_path`, and `guiding_principles`, with none of the prohibited retained fields.
4. **Given** protected neighboring artifacts are inspected, **When** the amendment is complete, **Then** the Profile record template, Experience Standard, Setup, Controls, NFRs, and Constitution are unchanged.
5. **Given** the skill's verification expectations are inspected, **When** the amendment is complete, **Then** they cover the new acquisition, expression, Identity, Vision, Competitive Path, Guiding Principles, and persistence boundaries, and they no longer require internal enrichment-category coverage.
6. **Given** unspecified sections of the skill are compared with baseline 5.3.0, **When** the amendment is complete, **Then** those sections keep their current meaning, including Working Ideas, Converged Proposals, shared contribution and clarification behavior, and acceptance plus new substantive information.

### Edge Cases

- Several acquisition sources are available, including a public website and user-supplied internal material. Profile considers them together. Neither source silently overrides the person's active input. Supported evidence may be combined. Consequentially different interpretations that require the person's information use existing Conversational Clarification. No source-precedence state or retained acquisition metadata is introduced.
- Another assistant may hold useful organizational context, but Profile cannot see it unless the person supplies an export, summary, document, pasted description, or other input Profile can evaluate. Unspecified model memory, prior-agent memory, and information the executing agent cannot identify in the active interaction are not organizational evidence. Missing context stays missing.
- Imported material includes technology-platform details. Profile does not perform technology-platform discovery from a website and does not turn imported material into a technology-platform inventory. Details that do not establish durable Profile context remain outside Profile scope.
- A person volunteers a safeguard, operational expectation, architecture note, or implementation detail during Competitive Path. Profile may use that volunteered downstream detail as evidence of the broad Competitive Path, but it does not develop or retain that detail as a safeguard, NFR, architecture, or implementation requirement, and it does not store it as a Control.
- During Guiding Principles, Profile does not develop or retain volunteered safeguard, NFR, architecture, or implementation detail as those artifacts, and it does not turn a principle into an enforceable Control.
- A domain-complete contribution, a prior equivalent opportunity, or an explicitly finished substantive contribution may skip a distinct Contribution Opportunity. A complete discovered Identity no longer skips that opportunity merely because it was discovered; material assembly or interpretation from website discovery, imported material, multiple sources, or substantial synthesis still receives the opportunity unless an equivalent one already occurred.
- Acceptance that also adds new substantive information keeps the existing acceptance-plus-new-information behavior. The new information is not treated as already persisted merely because the proposal was accepted.
- An accepted mutation fails after the person has agreed. Profile does not compensate by claiming the domain is retained, by continuing to the next domain, or by adding a read-back verification stage.
- Optional enrichment, expression guidance, and contextual reasoning do not by themselves change readiness.
- Profile does not store a small-business, enterprise, maturity, persona, or advisory classification.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The amendment MUST update the highway-profile skill from baseline version 5.3.0 as a targeted amendment, not a wholesale rewrite. Behavior not named by this amendment MUST keep its current meaning.
- **FR-002**: The skill's primary title MUST be the top-level heading `highway-profile`, replacing the reverted second-level heading.
- **FR-003**: Profile inputs MUST include user-supplied existing organizational material for acquisition, including an organizational description, strategy material, or an export or summary from an existing assistant when the person chooses to provide one, and a public organizational website supplied by the person when supported retrieval is available.
- **FR-004**: Imported or discovered material MUST remain acquisition evidence until accepted through the normal Profile boundaries. It MUST NOT be automatically accepted Profile knowledge.
- **FR-005**: Acquisition MUST follow the existing contribution precedence: classify the retained Profile; establish Repository Name when missing; use supported existing organizational material or public-website acquisition when available; process acquired evidence across all unresolved Profile domains; reuse accepted evidence across all four domains; re-evaluate accumulated accepted evidence before each unresolved guided question; present a Converged Proposal when supported, otherwise contribute a useful Working Idea when supported, otherwise ask the focused canonical question; persist accepted evidence; report readiness.
- **FR-006**: After Repository Name is accepted, Profile MUST give the person one opportunity to reuse existing organizational material before ordinary domain questioning. The prompt shape MUST invite a public website, an existing description or strategy document, or an export or summary from another assistant, and MUST allow building the Profile together. That shape is illustrative, not required literal wording.
- **FR-007**: Profile MUST NOT require imported material to follow Profile's internal domains, retained schema, headings, or vocabulary. Ordinary organizational descriptions, strategic summaries, planning material, and assistant exports or summaries MAY provide relevant evidence.
- **FR-008**: Evidence in one acquisition source MAY support multiple unresolved Profile domains. Profile MUST evaluate that evidence before determining what the person still needs to provide, and MUST NOT ask the person to reproduce information already present in supplied acquisition material.
- **FR-009**: Profile MUST NOT treat unspecified model memory, prior-agent memory, or information the executing agent cannot identify in the active interaction as organizational evidence. Useful context from another assistant MUST be usable only when the person supplies it in a form Profile can evaluate.
- **FR-010**: When multiple acquisition sources are available, Profile MUST consider them together before selecting the next Profile behavior. A website and user-supplied material MAY differ in breadth or emphasis. Neither source MAY silently override the person's active input. Responsibly combinable evidence MUST be incorporated. Consequentially different interpretations that require the person's information MUST use existing Conversational Clarification. Profile MUST NOT introduce source-precedence state or retained acquisition metadata.
- **FR-011**: Website and imported-source acquisition MUST be limited to evidence relevant to the organizational Profile. Profile MUST NOT perform technology-platform discovery from a supplied website and MUST NOT turn imported organizational material into a technology-platform inventory.
- **FR-012**: Suitable acquisition sources MAY provide transient organizational expression guidance, including characteristic terminology, recurring language, recognizable phrasing, degree of formality, and other communication patterns. Expression MUST influence representation only. It MUST NOT establish unsupported organizational facts, strategy, intentions, priorities, or principles, and MUST NOT be used as evidence that a substantive claim is true.
- **FR-013**: When suitable acquisition evidence consistently uses recognizable organizational terminology that accurately expresses supported meaning, Profile MUST use that terminology in Working Ideas and Converged Proposals. Profile MUST NOT imitate marketing language merely for stylistic similarity, preserve unsupported marketing claims, or sacrifice clarity for source mimicry. The person's active wording and corrections MUST remain authoritative.
- **FR-014**: Organizational expression guidance MAY remain available throughout the active Profile interaction for later domain proposals when it remains suitable. It MUST remain transient and MUST NOT create a retained Profile domain, readiness state, tone field, voice field, persona, style classification, or terminology field. It MUST NOT automatically control Objectives, Controls, NFRs, or other Highway owners.
- **FR-015**: Profile MUST consume the shared Contribution Opportunity for a materially shaped Identity, Vision, Competitive Path, or Guiding Principles Working Idea when no equivalent opportunity has already occurred, presenting provisional substantive pieces before the Converged Proposal.
- **FR-016**: A user-supplied domain-complete Identity that Profile does not materially reshape MAY proceed directly to its accuracy-oriented validation path. When Profile materially assembles or interprets Identity from website discovery, imported organizational material, multiple evidence sources, or substantial synthesis, Profile MUST apply the shared Contribution Opportunity unless an equivalent opportunity already occurred.
- **FR-017**: Profile MUST preserve the Identity breadth flow: available evidence, provisional organizational breadth, an opportunity to add something missing, re-evaluation, clarification only for consequential uncertainty requiring user information, one cohesive Identity, and accuracy validation.
- **FR-018**: Profile MUST remove the obsolete standalone Identity validation prompt. The detailed Identity development behavior MUST remain the sole owner of final Identity accuracy validation.
- **FR-019**: Vision, Competitive Path, and Guiding Principles MUST reason from relevant accumulated accepted Profile evidence. Completeness MUST be determined by whether the developed understanding coherently answers the active Profile domain, not by coverage of an internal category framework. Optional enrichment MUST NOT change readiness by itself. Profile MUST NOT store a small-business, enterprise, maturity, persona, or advisory classification.
- **FR-020**: Profile MUST remove the internal enrichment-category framework, including Future State, Impact, Reach / Scale, Position, Experience / Reputation, Customer / Participant, Offering, Market / Reach, Differentiation, Operations, Capability Development, People, Trust, Quality, Simplicity, Change, Stewardship, and Autonomy as reasoning categories. Those names MUST NOT be presented, retained, or used to dictate conversational order or completeness.
- **FR-021**: Vision MUST ask what future the organization is trying to create. It MUST evaluate the full accepted Identity and other relevant accepted Profile evidence before asking its canonical question, contribute or converge when supported, and ask only about unresolved information that can materially change the desired future.
- **FR-022**: A Vision Working Idea MUST be a grounded future direction, distinction, implication, alternative, or recommendation that advances understanding of the future the organization wants to create. It MUST remain transient until a complete Converged Proposal crosses the existing acceptance boundary. A Vision Contribution Opportunity MUST present only the substantive future-direction pieces needed for the person to add to or correct that developing Vision before final synthesis.
- **FR-023**: When accepted Identity contains multiple meaningful activities or expressions, Vision MUST consider how those parts affect the future being created. Profile MUST NOT let one prominent Identity facet become the whole Vision merely because it provides the easiest continuation. It MUST ask a focused question only when that relationship creates consequential uncertainty about the desired future and the person's information is required.
- **FR-024**: When accepted evidence supports more than one materially distinct future direction, a Vision Working Idea MAY present a small grounded set of alternatives and a grounded advisory perspective while preserving the user's own direction. Profile MUST NOT create alternatives merely to force a choice or to cover an internal Vision dimension.
- **FR-025**: Competitive Path MUST ask what broad approach the organization intends to take toward its accepted Vision. It MAY develop broad strategic choices, sequencing, approaches, priorities, or organizational direction when those help explain intended progress. It MUST ask only about unresolved information that can materially change that broad approach.
- **FR-026**: Competitive Path MUST NOT elicit enforceable safeguards, Controls, NFRs, detailed implementation requirements, architecture, or implementation plans. If the person volunteers such downstream detail, Profile MAY use it as evidence of the broad Competitive Path, but MUST NOT develop or retain that detail as a safeguard, NFR, architecture, or implementation requirement. Constraint, dependency, capability, concern, and tradeoff reasoning MUST remain inside Competitive Path only when it changes interpretation of the broad organizational approach.
- **FR-027**: Guiding Principles MUST ask which enduring principles should shape organizational decisions while pursuing the accepted direction. After Competitive Path acceptance, Profile MUST re-evaluate accumulated evidence for principles already becoming visible. A Guiding Principles Working Idea MUST lead only to questions about an unresolved principle or decision priority that can materially change the principles being developed.
- **FR-028**: Guiding Principles MUST describe enduring organizational decision guidance. Profile MUST NOT turn a principle into an enforceable Control merely to make it more precise. Governance obligations MUST remain owned by their downstream workflows. Existing Guiding Principles Contribution Opportunity and final validation behavior MUST remain.
- **FR-029**: Profile MUST preserve existing behavior for Working Ideas, Converged Proposals, the shared Contribution Opportunity, Substantive Contribution re-evaluation, consequential Conversational Clarification, suppression of ceremonial clarification, acceptance plus new substantive information, transient Active Reasoning Context, and cross-domain relevance of substantive evidence.
- **FR-030**: After a Converged Proposal or other accepted change is accepted and changes retained Profile state, Profile MUST immediately construct and perform the accepted Profile mutation before selecting any behavior that depends on that accepted domain. Conversational acceptance authorizes the mutation but is not itself a successful mutation. Recommendation selections, accepted discoveries, imported evidence, and accepted corrections MUST use the same boundary.
- **FR-031**: Profile MUST NOT advance from an accepted Profile domain as though its knowledge were retained until the applicable Profile mutation succeeds. After successful persistence, the accepted domain MUST become available for contextual re-evaluation and subsequent Profile behavior.
- **FR-032**: Guided Profile completion MUST require every accepted mutation establishing the discussed or bounded Profile domains to have succeeded. Profile MUST NOT emit the guided completion synthesis or return a terminal Profile result while an accepted Profile mutation remains unperformed or failed. If the final domain is accepted, Profile MUST persist that mutation before emitting the completion synthesis.
- **FR-033**: An accepted Profile mutation that fails MUST NOT establish the affected domain as successfully persisted and MUST NOT permit Profile to return a dependent terminal result. Profile MUST stop before dependent progression and report actionable user-facing failure context under the existing common failure model. Profile MUST NOT add a post-write read-back or verification stage.
- **FR-034**: The skill's verification expectations MUST cover reusable acquisition, nonconforming imported material, cross-domain evaluation without wholesale acceptance, proposed-until-accepted website and import evidence, refusal of unspecified model or prior-agent memory, reuse of already supplied evidence, transient organizational expression, Identity contribution boundaries, simplified Vision, narrowed Competitive Path, Guiding Principles ownership, and the strengthened persistence boundary.
- **FR-035**: Verification language whose only purpose is to preserve internal Vision or Competitive Path enrichment dimensions MUST be removed. Verification MUST NOT imply that Competitive Path completeness depends on internal Operations, Capability Development, Market, Differentiation, or similar categories.
- **FR-036**: The retained Profile structure MUST remain schema version 3.0.0 with exactly the readiness domains `identity`, `vision`, `competitive_path`, and `guiding_principles`. The amendment MUST NOT add retained acquisition-source fields, assistant-export metadata, source lists, tone, voice, style, persona, terminology guidance, Identity facets, Vision dimensions, Competitive Path dimensions, safeguard fields, Control fields, NFR fields, or reasoning or clarification state.
- **FR-037**: The feature MUST NOT modify the Profile record template, Experience Standard, Setup, Controls, NFRs, or Constitution. Setup MUST continue to orchestrate Profile, then Objectives, then Controls, then NFRs, and MUST continue to delegate Profile discovery and persistence to Profile.
- **FR-038**: The complete amendment MUST be classified under the Skill Versioning Policy rather than assigned a version before classification. Because the amendment removes, narrows, and redefines existing Vision, Competitive Path, enrichment-category, and discovered-Identity behavioral guarantees, the classification MUST be a breaking change and therefore MAJOR from baseline 5.3.0. Added acquisition and expression capabilities MUST NOT reduce that classification to MINOR. The Profile schema version MUST NOT change.
- **FR-039**: User-facing domain openings and acceptance questions MUST remain recognizable: Vision opens as where the organization is going and accepts with whether the proposal reflects where the organization should go; Competitive Path opens as how the organization will get there and accepts with whether the proposal reflects how it plans to get there; Guiding Principles opens as what will guide decisions and asks what principles or values guide decisions when a canonical question is required. The person MUST still be able to change a proposal or provide their own.

### Key Entities *(include if feature involves data)*

- **Acquisition Evidence**: User-supplied or website-derived organizational material used to develop Profile understanding. It is not accepted Profile knowledge until it crosses the normal acceptance boundary, and it is not retained as source metadata.
- **Organizational Expression**: Transient guidance about recognizable terminology and communication patterns. It shapes wording only and is not a retained Profile field or a proof of organizational claims.
- **Profile Domain**: One of four retained readiness areas: Identity, Vision, Competitive Path, and Guiding Principles. Their meanings are who the organization is, the future it wants to create, the broad approach toward that future, and the enduring principles that guide choices along the way.
- **Accepted Profile Mutation**: The owner-controlled save of accepted domain knowledge. Acceptance authorizes it; only its success makes the domain retained accepted knowledge.
- **Working Idea and Converged Proposal**: Transient developing understanding and the complete candidate presented for acceptance. Neither is retained Profile knowledge by itself.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In every reviewed acquisition scenario, the person receives one opportunity to reuse existing organizational material before the first ordinary Profile-domain question, and usable supplied material is interpreted before that question.
- **SC-002**: In every reviewed import and website scenario, zero sources are accepted wholesale, and every derived organizational fact remains proposed until the person accepts it through the normal Profile boundary.
- **SC-003**: In every reviewed scenario where acquisition material already supplies applicable domain evidence, the person is not asked to reproduce that evidence when the domain becomes active.
- **SC-004**: In every reviewed Vision scenario, zero questions are asked only to cover an internal Vision category, and every Vision question is limited to unresolved information that can materially change the desired future.
- **SC-005**: In every reviewed multi-activity Identity scenario, Vision uses the full accepted Identity, and zero scenarios let one prominent facet become the whole future solely because it is the easiest continuation.
- **SC-006**: In every reviewed Competitive Path scenario, zero questions elicit enforceable safeguards, Controls, NFRs, architecture, implementation requirements, or detailed implementation plans. In every reviewed scenario where such detail is volunteered, it may inform the broad path, and zero volunteered details are developed or retained as a safeguard, NFR, architecture, or implementation requirement.
- **SC-007**: In every reviewed Guiding Principles scenario, zero principles are converted into enforceable Controls merely to increase specificity.
- **SC-008**: In every reviewed materially assembled Identity scenario, the person receives one provisional contribution opportunity before convergence unless an equivalent opportunity already occurred. In every reviewed user-supplied domain-complete Identity that Profile does not reshape, Profile may proceed directly to one accuracy validation.
- **SC-009**: In every reviewed acceptance scenario, zero dependent Profile behaviors, readiness claims, completion syntheses, or Setup-advancing results occur before the applicable accepted mutation succeeds.
- **SC-010**: In every reviewed accepted-mutation failure, Profile returns zero dependent terminal results and emits zero guided completion syntheses.
- **SC-011**: After the amendment, 100% of retained Profile structures still use exactly the four existing readiness domains and schema version 3.0.0, with none of the prohibited retained fields.
- **SC-012**: The Profile record template, Experience Standard, Setup, Controls, NFRs, and Constitution require zero changes for this feature.
- **SC-013**: The published highway-profile skill version is the MAJOR successor of baseline 5.3.0, and the Profile schema version remains 3.0.0.
- **SC-014**: In every reviewed expression scenario, source language changes wording only, the person's correction overrides it, and zero unsupported substantive claims are established from tone, style, phrasing, or terminology alone.

## Assumptions

- The request's `profile.md` identifies the highway-profile skill contract at baseline version 5.3.0, whose title heading is currently second-level. It does not identify the retained organizational Profile or the Profile record template. Those artifacts stay unchanged.
- Published copies of the highway-profile skill are expected to match the amended source so a person invoking the skill receives the amended behavior. That consistency does not authorize changes to neighboring owner skills or governance documents.
- The current Experience Standard remains the owner of import and validation, context-before-question behavior, Working Ideas, Contribution Opportunity, Substantive Contribution re-evaluation, selective Conversational Clarification, convergence, and acceptance behavior. This feature corrects Profile domain meaning, not shared interaction rules.
- Setup already orchestrates Profile, then Objectives, then Controls, then NFRs, and already delegates Profile discovery and persistence. This feature does not change that order.
- Controls remain the owner of enforceable safeguards. NFRs remain the owner of operational and quality expectations. Objectives remain the owner of outcomes. Brownfield technology discovery remains outside Profile.
- A supplied Organization URL remains accepted optional Profile context. Organization Name and organizational facts derived from a website or import remain proposed until accepted.
- The illustrative acquisition prompt is a shape, not mandatory literal wording.
- The Skill Versioning Policy's breaking-change definition applies to the complete amendment. Removing, narrowing, or redefining an existing behavioral guarantee is MAJOR even when the same amendment also adds capabilities.
- No post-write read-back or verification stage is added. The required boundary is that the owner mutation occurs and succeeds before a dependent result.
- Existing one-question, owner-authority, and transience boundaries remain in force.
