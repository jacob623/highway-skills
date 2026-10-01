# Feature Specification: Update Profile Skill

**Feature Branch**: `115-update-profile-skill`

**Created**: 2026-10-01

**Status**: Draft

**Input**: User description: Update the Profile skill to version 5.0.0 so accepted evidence is re-evaluated before every unresolved question, website acceptance immediately grounds recommendations, accepted changes are persisted before dependent results, and guided completion closes with one user-relevant synthesis. Keep the four readiness domains and the retained Profile structure. Align with constitution 6.0.0 and Experience Standard 5.0.0 without restating their generic rules.

## Clarifications

### Session 2026-10-01

- Q: When accepted evidence resolves a Profile domain, which readiness state should that domain receive? → A: Accepted evidence that establishes a Profile domain sets that domain to `discussed`. An explicit user boundary sets an otherwise unresolved domain to `bounded`. Optional enrichment never changes readiness by itself and never requires another question.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Website Acceptance Grounds the Next Recommendation (Priority: P1)

As a person setting up an organizational Profile, I want Highway to use what it learned from an accepted website before asking a generic vision question, so that the next step shows understanding of the organization rather than restarting a questionnaire.

**Why this priority**: The first interaction after accepted website information is the visible proof that Profile compounds context instead of walking four fixed questions.

**Independent Test**: Accept website-derived identity evidence and confirm Vision, Competitive Path, and Guiding Principles are re-evaluated before any generic canonical question. Useful Vision choices are shown instead of the vision question when that evidence supports them.

**Acceptance Scenarios**:

1. **Given** Repository Name is missing, **When** Profile acquisition starts, **Then** Repository Name is established before website acquisition.
2. **Given** a public website can be used, **When** Repository Name is known, **Then** supported website acquisition is offered before a generic domain question.
3. **Given** the person supplies an organization web address directly, **When** that address is accepted, **Then** it is accepted without a separate proposal review.
4. **Given** website-derived organization name or organizational facts are discovered, **When** they have not been accepted, **Then** they remain proposals and are not treated as organizational truth.
5. **Given** the person accepts website-derived identity or other organizational evidence that supports useful Vision choices, **When** Profile continues, **Then** those Vision choices are shown and the generic vision question is not asked.
6. **Given** accepted website evidence does not support a useful Vision choice, **When** Vision is still unresolved, **Then** Profile asks one vision question and may explain why it matters after that question.

---

### User Story 2 - Recommendations Before Canonical Questions (Priority: P1)

As a person enriching a Profile, I want each accepted answer to improve recommendations across all four domains, so that I am not forced through a fixed sequence of four questions.

**Why this priority**: Recommendation-first sequencing is the behavior that replaces the current question-then-enrichment order.

**Independent Test**: After an accepted answer, selection, or validated discovery, confirm all four domains are re-evaluated and a useful grounded choice replaces the next canonical question whenever one exists.

**Acceptance Scenarios**:

1. **Given** accepted evidence supports a useful choice for an unresolved or enrichable domain, **When** Profile would otherwise ask a canonical question, **Then** the grounded recommendations are presented instead.
2. **Given** no useful grounded recommendation can resolve the next need, **When** Profile continues, **Then** it asks only the applicable canonical question.
3. **Given** one grounded recommendation is shown, **When** the person is asked to respond, **Then** the wording is a singular accept, change, or alternative choice.
4. **Given** several grounded recommendations are shown, **When** the person is asked to respond, **Then** the person may choose one, several, all, or supply their own alternative.
5. **Given** the person selects a displayed recommendation, **When** that selection is explicit, **Then** it becomes accepted Profile evidence without another confirmation.
6. **Given** one response contains evidence for more than one domain, **When** it is accepted, **Then** each affected domain is updated and recommendation opportunities are evaluated again.
7. **Given** enrichment is optional, **When** the person does not select it, **Then** Profile can continue, readiness is unchanged by that enrichment, and no further question is required.
8. **Given** accepted evidence establishes a domain, **When** that evidence is saved, **Then** the domain is `discussed` and its canonical question is not asked.
9. **Given** a domain is otherwise unresolved, **When** the person explicitly sets a boundary for it, **Then** the domain is `bounded` and its canonical question is not asked.

---

### User Story 3 - Accepted Evidence Is Saved Before Results (Priority: P1)

As a person accepting Profile evidence, I want that acceptance saved before Highway reports readiness or hands control back, so that later guidance is based on what was actually retained.

**Why this priority**: A readiness or owner result that describes unsaved evidence would mislead both the person and the orchestrator.

**Independent Test**: Accept a Profile change and confirm the retained Profile is updated before any dependent readiness or owner result is returned. Confirm guided completion shows one synthesis and does not show machine readiness fields unless readiness was directly requested.

**Acceptance Scenarios**:

1. **Given** the person accepts a change to retained Profile state, **When** Profile finishes that change, **Then** the accepted mutation is constructed and saved before a dependent readiness or owner result is returned.
2. **Given** a recommendation selection or accepted discovery changes retained Profile state, **When** that acceptance is processed, **Then** it follows the same save-before-result path.
3. **Given** conversational acceptance has not been saved, **When** a dependent result is considered, **Then** acceptance alone is not treated as a successful mutation.
4. **Given** guided Profile setup reaches completion, **When** control returns to Setup, **Then** Profile first emits one concise synthesis of the accepted organization and no new question.
5. **Given** guided Setup is showing normal conversation, **When** Profile returns readiness internally, **Then** status, summary, next action, and blocking reason are not shown as conversation.
6. **Given** the person directly requests Profile readiness, **When** that result is the requested output, **Then** the declared readiness result may be shown.
7. **Given** Decision Context applies to a canonical question, **When** the question is presented, **Then** the question appears first, followed by why it matters and one concise explanation, with no second question.

---

### User Story 4 - A Bounded Major Profile Update (Priority: P2)

As a governance maintainer, I want this Profile change recorded as version 5.0.0 without changing readiness domains or the retained record shape, so that reviewers can see what changed and what must stay stable.

**Why this priority**: The interaction change is not adoptable until the skill version, ownership boundaries, and verification match the new behavior.

**Independent Test**: Review the Profile skill and its verification. Confirm version 5.0.0, four unchanged readiness domains, schema 3.0.0, no restated generic interaction rules, and no edits to the deferred documents.

**Acceptance Scenarios**:

1. **Given** the Profile skill is updated, **When** its version is read, **Then** it is 5.0.0 and the version value does not contain the skill name.
2. **Given** readiness is evaluated, **When** the domains are listed, **Then** they remain Identity, Vision, Competitive Path, and Guiding Principles only.
3. **Given** the retained Profile record template is inspected, **When** this feature is complete, **Then** its schema remains 3.0.0 unless a genuine retained-structure defect is found.
4. **Given** verification is run, **When** the new Profile contract is checked, **Then** it requires recommendation-first sequencing, save-before-result, question-before-explanation, and a completion synthesis, and it does not accept the superseded question-first order.
5. **Given** Highway Profile Intent Summary and Brownfield Onboarding Idea still describe the former five-domain Profile, **When** this feature is complete, **Then** they are recorded as stale follow-up documentation and are not edited.

---

### Edge Cases

- No supported website or existing information is available, so acquisition continues from accepted evidence and canonical questions only when recommendations cannot resolve the need.
- Website-derived facts that the person does not accept never become recommendation grounding or retained organizational truth.
- Foundational Highway context does not become an unsupported organizational fact.
- A domain with no useful grounded recommendation still receives its one canonical question. Decision Context, when useful, follows that question.
- One recommendation is not padded into several, and several useful alternatives are not collapsed into one.
- Optional enrichment never changes readiness by itself and never requires another question.
- Accepted evidence that establishes a domain sets it to `discussed`. An explicit boundary sets an otherwise unresolved domain to `bounded`. A boundary does not first pass through `discussed`.
- A `discussed` or `bounded` domain is not unresolved, so its canonical question is not asked.
- Grounding-category names for Vision, Competitive Path, and Guiding Principles are used to form recommendations and are not saved in the retained Profile.
- An unsupported schema or a malformed retained Profile is blocked and is not mutated. An obsolete non-Markdown Profile is ignored.
- Generic mutation and unexpected failures follow the constitution's common failure model. Profile does not restate that model.
- Guided completion does not say "Profile Complete", "Status: Complete", or "Next Action: None" as the user-facing close.
- A synthesis is omitted only when guided completion has not been reached. Completion with an accepted organization name uses that name; completion without one does not invent a name.
- Direct readiness display remains available. Orchestrated conversation does not render the same machine fields.
- Profile does not restore a post-write persistence check after saving.
- Setup does not become the owner of Profile persistence, interpretation, readiness, or mutation.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Profile skill version MUST be a semantic version only. It MUST NOT contain the skill name. This change MUST set it to 5.0.0 because acquisition sequencing, mutation timing, and guided completion behavior change.
- **FR-002**: Profile MUST remain the sole owner of accepted organizational Profile evidence, the retained Profile, the four readiness-domain states, Profile readiness, and Profile mutations. Setup MUST NOT gain Profile persistence or interpretation.
- **FR-003**: The readiness domains MUST remain exactly Identity, Vision, Competitive Path, and Guiding Principles. Readiness MUST stay Missing when the Profile is absent or any domain is `not_discussed`, Blocked when the retained Profile is malformed or unsupported, and Complete only when all four domains are `discussed` or `bounded`.
- **FR-004**: Accepted evidence that establishes a Profile domain MUST set that domain to `discussed`. An explicit user boundary MUST set an otherwise unresolved domain to `bounded`. A domain that is `discussed` or `bounded` MUST NOT be asked its canonical question.
- **FR-005**: Optional Profile context and optional enrichment MUST NOT change readiness by themselves, MUST NOT block continuation, and MUST NOT require another question.
- **FR-006**: The retained Profile record template MUST remain schema 3.0.0 with exactly four readiness-domain keys unless implementation reveals a genuine retained-structure requirement. Highway Role MUST NOT be reintroduced.
- **FR-007**: Acquisition MUST classify the retained Profile, establish Repository Name when missing, use supported existing-information or website acquisition when available, and present discovered information for acceptance where required before asking a canonical question.
- **FR-008**: After each acceptance, selected recommendation, or validated discovery, Profile MUST re-evaluate accumulated accepted evidence across all four domains before the next unresolved guided question.
- **FR-009**: When accepted evidence supports a useful grounded recommendation for an unresolved or enrichable domain, Profile MUST present that recommendation instead of the canonical question. A canonical question MUST be asked only when no useful grounded recommendation resolves the need.
- **FR-010**: Profile MUST NOT proceed from accepted Identity to the generic vision question when accepted evidence supports useful Vision recommendations. The first interaction after accepted website information MUST demonstrate what Highway learned about the organization.
- **FR-011**: A directly supplied organization web address MUST be accepted as the organization URL. Website-derived organization name and organizational facts MUST remain proposed until accepted. Discovered information MUST stay proposed until accepted.
- **FR-012**: Foundational Highway context MUST NOT be presented as an unsupported organizational fact.
- **FR-013**: Vision recommendations MUST be grounded in accepted Identity, accepted website-derived information, existing accepted Vision evidence, and other accepted Profile context, using the internal categories Future State, Impact, Reach / Scale, Position, and Experience / Reputation. Those category names MUST NOT be persisted.
- **FR-014**: When no useful grounded Vision recommendation exists, Profile MUST ask exactly `**What is the future vision of [Organization Name]?**`. When Decision Context is useful, the explanation follows that question and states how Vision improves later recommendations.
- **FR-015**: Competitive Path recommendations MUST be grounded in accepted Profile evidence, especially accepted Identity and Vision, using the internal categories Customer / Participant, Offering, Market / Reach, Differentiation, Operations, and Capability Development. Those category names MUST NOT be persisted.
- **FR-016**: Profile MUST evaluate Competitive Path recommendations before asking `**How does [Organization Name] plan to get there?**`, and MUST ask that question only when grounding is insufficient.
- **FR-017**: Guiding Principles recommendations MUST be grounded in accepted Identity, Vision, Competitive Path, website-derived accepted information, and previously accepted principles, using the internal categories People, Trust, Quality, Simplicity, Change, Stewardship, and Autonomy. Those category names MUST NOT be persisted.
- **FR-018**: Guiding Principles recommendations MUST prefer decision-relevant principles over generic virtue words. Profile MUST evaluate them before asking `**What principles or values guide decisions at [Organization Name]?**`, and MUST ask that question only when useful recommendations cannot be grounded.
- **FR-019**: Profile MUST NOT restate the generic recommendation, question-order, synthesis, owner-result, or acceptance rules owned by the Experience Standard. It MUST own the Profile grounding semantics and follow the shared recommendation interaction model by reference.
- **FR-020**: Selecting a displayed recommendation MUST count as acceptance without another confirmation. A user-authored alternative MUST remain available. One recommendation uses singular accept, change, or alternative wording. Multiple recommendations permit one, several, all, or a user-authored alternative.
- **FR-021**: One accepted response MAY contribute evidence to more than one Profile domain. Profile MUST NOT treat acquisition as a fixed sequence of four questions.
- **FR-022**: The statement that Profile asks the first unresolved canonical question and then uses optional enrichment MUST be replaced with recommendation-first sequencing. Wording that enrichment occurs only after that domain's canonical question MUST be removed.
- **FR-023**: After acceptance that changes retained Profile state, Profile MUST construct the accepted mutation, persist the retained Profile, and only then return readiness or another owner result that depends on that mutation.
- **FR-024**: Recommendation selections and accepted discovered information that create accepted Profile evidence MUST follow the same persist-before-result path. Conversational acceptance alone MUST NOT count as a successful mutation.
- **FR-025**: Profile MUST NOT return readiness that reflects newly accepted evidence before that evidence has been persisted. Profile MUST NOT restore post-write persistence verification. This boundary implements constitution rule P12.13 without copying that rule sentence.
- **FR-026**: When guided Profile setup or configure reaches completion, Profile MUST emit one concise synthesis before returning control to Setup. The synthesis uses the accepted organization name when available, summarizes the important accepted direction, states that this understanding will improve later guidance, and contains no machine status field and no new question.
- **FR-027**: The completion synthesis MUST NOT use the literal phrases "Profile Complete", "Status: Complete", or "Next Action: None". The supplied synthesis pattern is illustrative, not required identical wording.
- **FR-028**: Profile MUST preserve the internal readiness result of status, summary, next action, and blocking reason for an orchestrator. Those fields MUST NOT appear in normal orchestrated conversation. A direct readiness request MAY show the requested result.
- **FR-029**: Where Decision Context applies, Profile MUST present one question first, then the literal label "**Why it matters:**", then one concise explanation, with no second response-demanding question. Profile MUST NOT encode why-it-matters before the question and MUST NOT duplicate the generic presentation rule.
- **FR-030**: The Profile experience statement MUST remain that user-visible interaction follows the Highway Experience Standard. It MUST NOT add generic recommendation, question-order, synthesis, owner-result, or acceptance rules.
- **FR-031**: Unsupported schema and malformed retained Profile MUST remain Blocked without mutation. An obsolete non-Markdown Profile MUST be ignored. Generic mutation and unexpected failures MUST rely on the constitution's common failure model rather than a restated Profile failure model.
- **FR-032**: Profile verification MUST be updated so it requires the new acquisition, grounding, persistence, synthesis, and question-order contract, and so it no longer accepts the superseded question-first order. Generic Experience Standard rules MUST be checked as references, not as restated sentences.
- **FR-033**: This change MUST NOT update Highway Profile Intent Summary or Brownfield Onboarding Idea. Both MUST be recorded as stale follow-up documentation because they still describe the former five-domain Profile, and the Intent Summary also describes Highway Role, schema 2.0.0, and the former persistence-verification model.
- **FR-034**: This change MUST NOT amend the constitution, the Experience Standard, Setup, Objectives, Controls, Non-Functional Requirements, or their output templates. The retained Profile record template is unchanged unless a genuine retained-structure requirement is discovered.

### Key Entities

- **Profile skill**: The capability that collects, recommends, accepts, and mutates organizational Profile evidence. Its version becomes 5.0.0.
- **Retained Profile**: The accepted organizational Profile evidence and its four readiness-domain states. Optional context is not readiness-bearing.
- **Readiness domain**: One of Identity, Vision, Competitive Path, or Guiding Principles. Each is `not_discussed`, `discussed`, or `bounded`. Accepted establishing evidence sets `discussed`. An explicit boundary sets an otherwise unresolved domain to `bounded`.
- **Grounded recommendation**: A distinct actionable Profile choice derived from accepted evidence and the domain's internal grounding categories. Category names are not retained.
- **Canonical question**: The fallback question for one domain, asked only when recommendations cannot resolve the need.
- **Profile completion synthesis**: One user-relevant closing statement emitted when guided Profile collection is complete, before control returns to Setup.
- **Profile readiness result**: The internal status, summary, next action, and blocking reason returned to an orchestrator or shown only when readiness is directly requested.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of reviewed acquisitions where accepted website evidence supports a useful Vision choice, that choice is shown and the generic vision question is not asked.
- **SC-002**: Before each unresolved canonical Profile question in a guided collection, accumulated accepted context is evaluated. A useful grounded choice replaces the question in every case where one exists.
- **SC-003**: Zero reviewed Profile prompts place why-it-matters before the question. Where Decision Context applies, one question appears first and no second question appears.
- **SC-004**: In 100% of reviewed acceptances that change retained Profile state, the retained Profile is saved before a dependent readiness or owner result is returned. Zero results describe unsaved evidence as current.
- **SC-005**: Guided Profile completion emits exactly one user-relevant synthesis and zero machine status fields before control returns to Setup. A direct readiness request may still show the requested result.
- **SC-006**: Readiness still uses exactly four domains. Accepted establishing evidence sets `discussed` in 100% of reviewed cases. An explicit boundary on an otherwise unresolved domain sets `bounded`. Optional enrichment changes readiness in zero reviewed cases and requires another question in zero reviewed cases. Grounding-category names appear in zero retained Profile records.
- **SC-007**: The Profile skill version is 5.0.0 and contains no skill name in the version value. The retained record schema remains 3.0.0 unless a genuine structure defect is recorded.
- **SC-008**: Profile verification passes against the recommendation-first contract and fails if it still requires the superseded question-first order. Zero generic Experience Standard rule sentences are copied into the Profile skill.
- **SC-009**: Highway Profile Intent Summary and Brownfield Onboarding Idea are unchanged and identified as stale follow-up. Setup and the other governance skills are unchanged by this feature.

## Assumptions

- "profile.md" in the request means the Profile skill document, not the user-owned retained Profile and not the retained record template. The current source version field is already a separate semantic version; this change sets it to 5.0.0 and rejects a value that concatenates the skill name.
- Constitution 6.0.0 and Experience Standard 5.0.0 are already authoritative. This feature aligns Profile to them and does not amend either document.
- P12.13 is satisfied by persisting accepted Profile evidence before a dependent owner result and by not restoring post-write persistence verification. The constitution rule sentence is not copied.
- Canonical question text is required only when that question is asked. Recommendation, synthesis, and why-it-matters sentences are illustrative except the literal why-it-matters label and the three canonical questions named in this specification.
- Verification that encodes Profile behavior is in scope because the request requires it. Distributed copies of the Profile skill must not contradict the updated source. Other skills and templates are out of scope.
- No Highway Profile Intent Summary or Brownfield Onboarding Idea is edited, even if one is present. Their stale content is recorded for a later documentation change.
- Repository Name opening behavior and supported website acquisition immediately after Repository Name stay as they are, except that accepted website evidence now pivots to recommendations.
- No git branch was created for this specification because no pre-specification hook is registered.
- No extension hooks are registered because `.specify/extensions.yml` is absent.
