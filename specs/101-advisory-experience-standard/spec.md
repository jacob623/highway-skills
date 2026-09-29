# Feature Specification: Revise the Runtime Experience Standard

**Feature Branch**: `101-advisory-experience-standard`

**Created**: 2026-09-29

**Status**: Draft

**Input**: User description: "Amend the Highway Experience Standard so it is the single runtime authority for user-visible interaction and presentation. Replace question-first collection with an evidence-first informed-advisor model, keep domain workflow outside the standard, and remove development compliance machinery and rules that do not govern something the person sees."

## Background

The Experience Standard governs what a person sees and how a Highway skill interacts with that person. Today it also carries skill-file structure, retained-file shape, artifact determinism, a long second interaction contract, resume and ownership mechanics, and development review vocabulary. Guided collection is written as question-first: the opening move is a question, and skills are expected to restate that interaction contract in their own words.

This feature revises the standard so a setup-oriented interaction behaves as understand, reuse, recommend, select, capture, and continue, with a question only when the needed information cannot be reused or responsibly recommended. Highway identity remains the source of the informed-advisor direction. Platform objectives remain the source of reducing repetitive input and improving relevance as organizational knowledge grows. The Skills Constitution remains the source of owner and orchestrator completion, artifact ownership, readiness, identifiers, persistence, and routing. Each skill remains the source of its domain workflow and of any interaction meaning that belongs only to that domain.

The current Experience Standard is version 2.0.0. Removing and redefining rules is a major amendment under its own versioning policy. The current Skills Constitution is version 4.0.0. Receiving the relocated skill-file and retained-artifact obligations is a minor amendment, because those obligations already apply to shipped skills.

## Clarifications

### Session 2026-09-29

- Q: Which artifacts should this amendment change? → A: The Experience Standard and the Skills Constitution. X1.1, X1.2, X1.3, X1.4, X1.5, X4.1, and X6.1 move into the Skills Constitution. Skill domain workflows and the development constitution stay unchanged.
- Q: Should the change also clear the development-process exceptions? → A: Yes. Tests, the specimen check's reported identifier, and live references to the removed contract or retired rule identifiers are updated in this change. The suite exits 0 before the governance edits and after them. Domain skill workflows are not rewritten. The development constitution stays unchanged.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Guided interaction starts from evidence (Priority: P1)

As a person setting up Highway, I want the interaction to use what is already known before it asks me anything, so that I am not walked through a form when accepted context, organizational evidence, or a grounded recommendation could answer the need.

**Why this priority**: The evidence-first order is the change a person feels on every guided interaction. The later recommendation and presentation rules depend on it.

**Independent Test**: Read the amended interaction priority. Before a question, the standard requires accepted information, then available relevant evidence, then a grounded recommendation, and only then an unresolved question. A question asked only to fill an internal workflow dimension is prohibited. Organization size, maturity, and operating model are not inferred from the organization name alone.

**Acceptance Scenarios**:

1. **Given** accepted information that already answers the need, **When** a guided interaction continues, **Then** that information is reused and the person is not asked to supply it again.
2. **Given** authoritative organizational information the workflow can import or validate, **When** the person is asked to provide that information, **Then** the interaction helps the person provide, connect, discover, import, or validate it rather than recreate it conversationally.
3. **Given** context that supports useful choices, **When** the needed information is not already accepted, **Then** the interaction offers grounded recommendations before it asks a question.
4. **Given** information that cannot be obtained or responsibly recommended, **When** the interaction continues, **Then** it asks one direct question for that unresolved need.
5. **Given** an internal workflow dimension that the person does not need to answer, **When** the interaction continues, **Then** it does not ask a question only to satisfy that dimension.
6. **Given** only an organization name, **When** the interaction chooses how to acquire information, **Then** it does not assign a persistent small-business, enterprise, maturity, or advisory classification, and different domains in the same organization may use different acquisition approaches.

---

### User Story 2 - Recommendations are selected once and captured (Priority: P1)

As a person reviewing Highway suggestions, I want to accept, skip, change, or replace a small set of grounded recommendations, and I want a selected recommendation captured without a second confirmation, so that setup does not become a loop of restated choices.

**Why this priority**: Recommendation selection is the main alternative to questioning. It is independently useful once the evidence-first order exists, and it defines when Highway must stop and ask the person to review an inference.

**Independent Test**: A recommendation set is a small group of distinct, actionable, grounded choices, with a user-authored alternative still available. Selecting one, several, or all displayed recommendations accepts them once. The inferred-content review appears only when Highway materially interpreted the category, and its single acceptance request is at the bottom.

**Acceptance Scenarios**:

1. **Given** grounded evidence for useful choices, **When** recommendations are shown, **Then** the person does not have to ask for suggestions first, and the set is a small group of distinct actionable choices rather than generic filler or a repeated loop.
2. **Given** a displayed recommendation set, **When** the person responds, **Then** the person can accept one, several, or all, reject or skip them, modify one, or provide something different, and the user-authored path remains available.
3. **Given** an explicitly presented recommendation, **When** the person selects it, **Then** that selection is acceptance, the same recommendation is not shown again only for confirmation, and it is captured according to the owning skill's artifact contract.
4. **Given** a request to explain, compare, or learn more about a recommendation, **When** the person has not selected it, **Then** that request is not treated as acceptance.
5. **Given** additional grounded recommendations that are not duplicates or marginal variations, **When** accepted recommendations have been captured, **Then** the interaction may offer another small set through a lightweight continue-or-finish choice, and it does not show every remaining recommendation at once.
6. **Given** no further grounded recommendations, only duplicates or marginal variations, a person who says they are finished, or a person who chooses to provide their own information, **When** the interaction would offer more recommendations, **Then** it stops offering them.
7. **Given** an explicit selection, a direct statement already in the requested category, or imported information clearly presented for validation, **When** no material reinterpretation is required, **Then** the information is captured without the inferred-content review.
8. **Given** Highway has inferred, classified, synthesized, or transformed the person's input into a retained category the person did not explicitly provide, **When** review is required, **Then** the response begins with "Here's what I've captured as your [category]:", shows the proposed content immediately below, places one acceptance request at the bottom, and does not add another confirmation or a Next Action instruction above the proposal.

---

### User Story 3 - One interaction contract, only for what the person experiences (Priority: P2)

As a person using any setup-oriented Highway skill, I want questions, examples, acknowledgments, progress, transitions, and presentation to follow one shared standard, so that each skill keeps its domain meaning and does not carry a second copy of the same interaction rules.

**Why this priority**: The shared presentation rules make the evidence-first model consistent. They depend on User Stories 1 and 2 for the interaction they present.

**Independent Test**: The long Interactive Workflow UX Contract is gone. One concise interaction model remains, and the normative rules do not restate that model in a second prose contract. Presentation-label behavior remains. Skill-file structure, retained-file shape, path declaration, artifact determinism, resume mechanics, and development review vocabulary are absent. A skill is required to reference this standard for the listed generic interaction behaviors and to keep only domain-specific interaction rules.

**Acceptance Scenarios**:

1. **Given** a guided interaction, **When** the person sees it, **Then** the visible order is concise framing when needed, then the recommendation, question, or captured information, then supporting rationale or examples when useful, then one decision or question at the bottom.
2. **Given** a question is necessary, **When** it is asked, **Then** it is the only unresolved response-demanding question, it is specific to the information still needed, and it does not ask for something already accepted, something Highway can recommend, or an internal schema, category, route, or stage.
3. **Given** an answer that affects a future recommendation, decision, governance interpretation, or generated artifact, **When** the question is asked, **Then** concise Decision Context explains why the answer matters to the person, does not repeat an implication already established, and is not itself a second question.
4. **Given** an example would make the expected answer clearer, **When** it is shown, **Then** it is short, specific to the current question, and does not become a hidden required category.
5. **Given** new information that changes the recommendation, interpretation, or next action the person cares about, **When** the interaction continues, **Then** a concise acknowledgment may appear. Context that was only consulted does not require an acknowledgment, an acknowledgment-only turn, or a promotion of an unrelated Highway capability.
6. **Given** an accepted Profile that contains the organization name, **When** contextual guidance uses a name, **Then** that accepted name is used where it improves clarity. A name that has not been accepted is not invented.
7. **Given** a short conversational setup, **When** progress would be shown, **Then** no progress indicator is manufactured. Progress appears only when remaining work is meaningful to the person, and it does not name internal stages, validation, routing, or implementation steps.
8. **Given** an orchestrator moving the person into a new setup domain, **When** the transition is shown, **Then** it is one short outcome-oriented introduction, major setup domains are separated with a horizontal rule, the owning skill's opening is not repeated, and the transition does not claim that recommendations might exist when the receiving workflow can present them.
9. **Given** normal conversational setup, **When** the person has not asked for internals, **Then** routing, validation, allocation, persistence, source selection, internal classifications, orchestration, identifiers, catalog changes, generated versions, internal candidate state, and owner-result mechanics stay out of the response.
10. **Given** a skill that shows recommendations, questions, acknowledgments, examples, progress, acceptance, or inferred-content review, **When** the skill is read, **Then** it is required to reference this standard for those generic behaviors and to state only the domain-specific interaction behavior it owns.

---

### User Story 4 - The two amendments agree (Priority: P2)

As a maintainer of Highway governance, I want the Experience Standard recorded as one major amendment and the relocated skill-file obligations recorded in the Skills Constitution, so that a retired interaction rule cannot still govern a shipped skill and a retained-file obligation is not lost when it leaves the standard.

**Why this priority**: A partial edit would leave two interaction contracts, citations of constitution rules that no longer exist, or a skill-file obligation that lives in neither document. The amendment is safe once both documents agree.

**Independent Test**: The Experience Standard version advances by a major increment from 2.0.0. The Skills Constitution version advances by a minor increment from 4.0.0 and states the seven moved obligations. The Experience Standard amendment record lists every removed, redefined, and added interaction obligation. X1.1, X1.2, X1.3, X1.4, X1.5, X4.1, and X6.1 are absent from the Experience Standard and present in the Skills Constitution. Tests and live references agree with that map, and the suite exits 0.

**Acceptance Scenarios**:

1. **Given** the current version 2.0.0, **When** the amendment is adopted, **Then** the version advances by a major increment, the ratified date stays 2026-09-08, and the amendment record states why the change is major.
2. **Given** the amended standard, **When** definitions, rule references, and applicability conditions are read, **Then** each one describes only the obligations that remain, and a definition exists only where a remaining rule needs it.
3. **Given** a retired rule identifier, **When** the Experience Standard is searched, **Then** that identifier is not a current obligation and is not assigned to a replacement rule.
4. **Given** constitution rules removed by the runtime constitution amendment, **When** the Experience Standard is searched, **Then** those identifiers are not cited as current obligations.
5. **Given** this amendment, **When** the changed artifacts are listed, **Then** the Experience Standard, the Skills Constitution, the tests that read them, and the live references to the removed contract or retired identifiers are updated. Domain workflows inside skills stay in place. The development constitution is unchanged.
6. **Given** user-owned strategy, policy, requirements, priorities, and preferred wording, **When** the standard is applied, **Then** it governs Highway's presentation and interaction and does not take ownership of that content.

---

### Edge Cases

- A recommendation grounded in an external framework does not say that the framework applies to the organization, and it is not presented as certification, compliance, regulatory applicability, or the organization's policy unless that status was separately established.
- A workflow that has not declared an external benchmark, industry, regulatory, standards, or expertise source does not use that source as recommendation grounding.
- Provenance is shown when it helps the person decide or trace a recommendation. The way Highway chose the source stays internal.
- Selecting every displayed recommendation is one acceptance. There is no second acceptance step.
- Changing a recommendation into the person's own wording, already in the requested category, is captured directly. Reclassifying that content into a category the person did not provide requires the inferred-content review.
- Corrections, replacement, rejection, and cancellation of an inferred proposal remain available in ordinary language.
- Discovered or extracted information stays proposed evidence until the workflow's user-acceptance boundary is satisfied. The person is asked to validate it rather than re-enter it.
- Evidence Highway cannot responsibly recommend or infer stays unknown. The interaction does not invent content to make setup look complete.
- Established organizational information is ingested, discovered, normalized, or validated. Partial information is reused and the useful gaps are filled. Little information produces grounded guidance. Informal language does not by itself make the interaction simpler, and enterprise wording is not introduced unless it helps the person decide.
- Optional enrichment does not block continuation unless the owning domain needs that information to be valid.
- A confirmation before an irreversible loss still names what is lost.
- A message the person must act on still names the artifact, value, or next action the person can use, and a conflict with existing content still names the existing item.
- A user-visible structured field still distinguishes its label from its value.
- Conversational wording is not required to be identical on every run.
- An example or definition that teaches a removed obligation is removed or rewritten so it agrees with the remaining rules.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Experience Standard MUST identify itself as the single runtime authority for user-visible Highway interaction and presentation.
- **FR-002**: Domain semantics, artifact ownership, readiness, identifiers, persistence, and routing MUST remain outside this standard. The Skills Constitution and the owning skill remain the authorities for those concerns.
- **FR-003**: A skill MUST be required to reference this standard for generic interaction behavior and MUST keep only domain-specific interaction behavior. The generic behaviors a skill must not restate are: one-question limits, implementation-detail suppression, recommendation selection, contextual acknowledgments, Decision Context, Relevant Examples, generic acceptance, general exits, generic progress, presentation labels, recommendation presentation, direct capture, and inferred-content review.
- **FR-004**: The standard MUST optimize for an informed-advisor experience rather than a form-filling experience. Interaction MUST reduce user effort as accepted context increases, MUST prefer reuse, recommendations, and recognition over repeated collection, and MUST stay professional, conversational, direct, and concise.
- **FR-005**: The standard MUST stay consistent with Highway identity's informed-advisor direction and with platform objectives to reduce repetitive input, increase repository-grounded recommendations, adapt to available organizational knowledge, and improve relevance as that knowledge grows. It MUST cite those sources rather than restate them.
- **FR-006**: Question-first guided collection MUST be replaced by an evidence-first order. Before asking, the interaction MUST consider accepted information, then available relevant evidence, then grounded recommendations that could help the person express the information, and only then an unresolved question.
- **FR-007**: The interaction priority MUST be: reuse accepted information when it already answers the need; use existing authoritative organizational information when the workflow supports importing or validating it; offer grounded recommendations when context supports useful choices; ask one direct question when the required information cannot be obtained or responsibly recommended; never ask only to satisfy an internal workflow dimension.
- **FR-008**: When the organization already has authoritative information, the interaction MUST prefer helping the person provide, connect, discover, import, or validate that information over asking the person to recreate it conversationally.
- **FR-009**: The interaction MUST NOT infer organization size, maturity, or operating model from organization identity alone, MUST adapt acquisition from available evidence rather than a persistent small-business, enterprise, maturity, or advisory classification, and MUST allow different domains in the same organization to use different acquisition approaches.
- **FR-010**: A skill MAY offer recommendations without being asked when it has grounded evidence for them. Each set MUST be a small, focused group of distinct, actionable choices. Generic filler recommendations MUST be prohibited. Recommendations MUST NOT be invented only to continue a recommendation loop.
- **FR-011**: A recommendation set MUST let the person accept one, accept several, accept all, reject or skip, modify a recommendation, or provide something different. The user-authored path MUST remain available whenever recommendations are shown.
- **FR-012**: Every recommendation MUST be grounded in context the owning workflow declares. Accepted organizational or repository context MUST be used before generic advice. An external benchmark, industry, regulatory, standards, or expertise source MAY ground a recommendation only when the owning workflow declares it. An external framework MUST NOT be implied to apply to the organization merely because it informed a recommendation, and framework-grounded guidance MUST NOT be represented as certification, compliance, regulatory applicability, or user policy unless that status is separately established. Provenance MUST be preserved when it helps explain or trace a recommendation. Internal source-selection mechanics MUST stay hidden unless requested.
- **FR-013**: Selection of an explicitly presented recommendation MUST be acceptance of that recommendation. The selected recommendation MUST NOT be presented again solely for confirmation, and a second acceptance step MUST NOT be required after the person selects one, several, or all displayed recommendations. Accepted recommendations MUST be captured according to the owning skill's artifact contract. A request for explanation, comparison, or more information MUST NOT be treated as acceptance.
- **FR-014**: After accepted recommendations are captured, the interaction MAY offer another small set when additional grounded, non-duplicate recommendations remain. It MUST NOT present every remaining recommendation at once. A lightweight continue-or-finish path MUST be available between sets. Offering MUST stop when no additional grounded recommendations remain, when the remainder are duplicates or marginal variations, when the person says they are finished, or when the person chooses to provide their own information.
- **FR-015**: Direct user-owned information MUST be distinguished from information Highway materially interprets. Confirmation MUST NOT be required when Highway stores an explicit selection or a direct statement without material reinterpretation. Review MUST be required when Highway materially infers, classifies, synthesizes, or transforms input into a retained category. Classification into a category the person did not explicitly provide MUST be treated as material interpretation.
- **FR-016**: An inferred-content review MUST begin with "Here's what I've captured as your [category]:", MUST present the proposed retained content immediately below that heading, and MUST place the single acceptance request at the bottom. It MUST NOT place a Next Action instruction above the proposal and MUST NOT request confirmation elsewhere in the same response. Correction, replacement, rejection, and cancellation MUST remain available in ordinary language.
- **FR-017**: When no material inference is required, accepted information MUST be captured without the inferred-content review. This includes selecting an explicitly presented recommendation, supplying content already in the requested category, and accepting imported or discovered information that was clearly presented for validation.
- **FR-018**: A guided interaction MUST ask only one unresolved response-demanding question or decision at a time. The question MUST be clear, direct, and specific to the information still needed. It MUST NOT be broader than necessary, MUST NOT ask the person to formulate information Highway can responsibly recommend, MUST NOT ask for information already in accepted context, MUST NOT be asked only to demonstrate context awareness, and MUST NOT expose internal evidence dimensions, schemas, categories, routing, or workflow stages as questionnaire fields.
- **FR-019**: Decision Context MUST be given when the answer affects future recommendations, decisions, governance interpretation, or generated artifacts. It MUST be concise, MUST explain why the answer matters to the person, MUST NOT explain Highway's internal processing, MUST NOT be repeated when the implication was just established, and MUST NOT be a second response-demanding prompt.
- **FR-020**: An example MUST be provided only when it makes the expected answer clearer. Examples MUST be short and specific to the current question, MUST show the kind of information being sought, MUST NOT become hidden required categories, and MUST prefer a few sharp examples over a long list.
- **FR-021**: An acknowledgment MUST be concise and MUST be used when new information changes the recommendation, interpretation, or next action the person cares about. An acknowledgment MUST NOT be required merely because context was consulted, MUST NOT occupy a turn by itself, and MUST NOT promote unrelated Highway capabilities.
- **FR-022**: When the accepted Profile contains the organization name, user-visible contextual guidance MUST use that name where it improves clarity. A generic phrase such as "your organization" MUST NOT replace that name in those cases. An organization name that has not been accepted as organizational evidence MUST NOT be invented.
- **FR-023**: Setup-oriented presentation MUST use this order: concise contextual framing when needed; the recommendation, question, or captured information; supporting rationale or examples when useful; one clear decision or question at the bottom. Meaningful structured information MUST use a visually distinct label. Unnecessary status labels, workflow labels, implementation terminology, and internal state MUST be avoided. Visible structure MUST focus on what the person is deciding.
- **FR-024**: Profile enrichment, Objectives, Controls, and Non-Functional Requirements MUST share one recommendation pattern: a short grounding line that can name the organization, a short numbered list of labeled recommendations, and one closing choice that allows one, several, all, or something different. A domain skill MAY use its own terms, such as suggestions, outcomes, safeguards, or expectations. Identical wording MUST NOT be required when domain-specific phrasing is clearer.
- **FR-025**: Recommendation rationale MUST be included when it helps the person decide, MUST stay relevant to that decision, and MUST NOT be added merely because a recommendation was produced. Generic rationale that adds no decision value MUST be prohibited. The owning skill MAY surface grounding when the provenance itself helps the decision.
- **FR-026**: Progress indicators MUST NOT be manufactured for short conversational setup. Progress MUST be used only when the person benefits from seeing meaningful remaining work. A known finite set MAY use natural progress such as "Recommendation 2 of 4". Internal workflow stages, validation stages, routing, and implementation steps MUST NOT be shown as progress.
- **FR-027**: An orchestrator MAY introduce a new owner or domain with one short, outcome-oriented transition. Major setup domains MUST be separated with a horizontal rule when the person is visibly moving into a new setup area. Transitions MUST stay positive and concise, MUST NOT duplicate the owning skill's opening, MUST NOT preview internal downstream mechanics, and MUST NOT claim that recommendations may exist when the receiving workflow can present them.
- **FR-028**: Unless the person requested them, or needs them in order to act, user-visible setup MUST NOT expose routing, validation logic, allocation, persistence mechanics, source-selection logic, internal classifications, orchestration mechanics, identifiers, catalog mutations, generated versions, internal candidate state, or owner-result mechanics.
- **FR-029**: User ownership of organizational information and governance content MUST remain. Recommendations MUST stay proposals until selected or otherwise accepted. Discovered, imported, extracted, inferred, or generated information MUST NOT silently become user-owned truth. User-owned content MUST NOT be rejected because Highway would word it differently. Highway MAY explain a classification or quality concern and MAY offer an alternative without taking ownership of the person's policy or intent.
- **FR-030**: Discovered or extracted information MUST remain proposed evidence until the applicable user-acceptance boundary is satisfied. Validation of discovered information MUST be preferred over asking the person to re-enter it. Missing evidence MUST remain unknown when Highway cannot responsibly recommend or infer it. Information MUST NOT be manufactured to produce a complete-looking setup.
- **FR-031**: Interaction MUST adapt to the knowledge available rather than to a persistent maturity label. Established information emphasizes ingestion, discovery, normalization, and validation. Partial information is reused and useful gaps are filled. Little information produces grounded guidance and recommendations. Informal language MUST NOT by itself simplify the interaction. Enterprise terminology MUST NOT be introduced unless it improves the person's decision.
- **FR-032**: Reducing setup fatigue MUST be an explicit objective. The standard MUST prefer recognition and selection over repeated origination, small recommendation sets over long questionnaires, and reuse of accepted information in later interactions. It MUST NOT ask for rationale or explanatory prose unless that prose improves a downstream decision or artifact, MUST NOT require redundant confirmation, MUST NOT force optional enrichment before the person can continue, and MUST keep enrichment non-blocking unless the owning domain requires the information for validity.
- **FR-033**: The long Interactive Workflow UX Contract MUST be replaced by one concise interaction model. The standard MUST NOT keep both detailed interaction rules and a second prose contract that substantially restates those rules. The shared model MUST be: understand available accepted context; reuse existing information when it satisfies the need; discover or import existing authoritative information when the organization already has it; offer grounded recommendations when Highway can responsibly help; accept selected recommendations directly; ask one clear question only when information remains unresolved; present the inferred-content review only when Highway materially inferred or transformed the input; put that review's acceptance request at the bottom; capture accepted information; offer additional grounded recommendations or let the person continue; stop when the person is satisfied or no useful recommendations remain.
- **FR-034**: Definitions MUST be kept only when a remaining normative rule needs them. Generic ownership mechanics that the Skills Constitution now governs MUST be removed from this standard. Resume and restoration mechanics MUST be removed unless they create a user-visible experience requirement. Durable state and restoration semantics MUST remain with the owning skill and the Skills Constitution.
- **FR-035**: X1.1, X1.2, X1.3, X1.4, X1.5, and X4.1 MUST leave the Experience Standard and MUST be stated in the Skills Constitution with the same obligations: a skill declares the shape of what it emits; emitted content follows that declared shape; an empty result has a declared form; a specimen agrees with the metadata it repeats; a retained file includes frontmatter; a skill that writes a file declares its path. X1.6, or an equivalent presentation-label rule, MUST remain in the Experience Standard for user-visible structured information.
- **FR-036**: X6.1 MUST leave the Experience Standard and MUST be stated in the Skills Constitution: a retained artifact contains only content derived from its declared inputs. Conversational wording MUST NOT be required to be deterministic, and that limit MUST remain in the Experience Standard.
- **FR-037**: Development compliance machinery MUST be removed from this standard, including PASS, FAIL, and N/A review vocabulary, sample counts, enforcement-tier registration, and test registration. A shipped skill MUST NOT be required to understand that vocabulary in order to follow the standard. Applicability conditions that a person can observe MUST be stated in the rules themselves.
- **FR-038**: The non-goal that this standard does not govern the content of the person's own governance artifacts MUST remain, in a shorter form. The standard MUST state that it governs Highway's presentation and interaction, and that it does not govern the person's strategy, policy, requirements, priorities, or preferred wording.
- **FR-039**: These user-visible behaviors MUST remain, redefined where the new model changes them: a confirmation before irreversible loss names what is lost; an opening interaction is not required to be a question; implementation details stay hidden unless requested; one unresolved question is asked only when a question is necessary; progress describes activity the person can understand and is omitted when there is no meaningful remaining work; recommendations are grounded in relevant accepted context; an acknowledgment appears only for a material change; Decision Context and examples support a question without becoming a second demand; a message names something the person can act on; a conflict names the existing item.
- **FR-040**: The amendment MUST be a major version change from 2.0.0. The ratified date MUST remain 2026-09-08. The amendment record MUST name the version change and every removed, redefined, and added obligation, including updated definitions and rule references. Older amendment records MUST remain.
- **FR-041**: The Experience Standard MUST contain no current obligation that uses a retired rule identifier, and a retired identifier MUST NOT be reused. References to constitution rules removed by the runtime constitution amendment MUST be removed from current obligations. References to development governance that are not runtime dependencies MUST be removed. Examples and definitions that describe a removed obligation MUST be removed or rewritten.
- **FR-042**: This amendment MUST NOT add a rule whose only purpose is to preserve a historical test or duplicated legacy interaction wording.
- **FR-043**: This amendment MUST change the Experience Standard and the Skills Constitution. It MUST also update tests and live references that name the removed interaction contract or a retired rule identifier as current. It MUST leave each skill's domain workflow in place, MUST leave shared templates unchanged, and MUST leave the development constitution unchanged.
- **FR-044**: Each moved obligation MUST receive a new Skills Constitution identifier. A retired Experience Standard identifier MUST NOT be reused, and an existing constitution identifier MUST NOT be reused. The Skills Constitution version MUST advance by a minor increment from 4.0.0, its ratified date MUST remain 2026-09-06, and its amendment record MUST name the seven moved obligations.
- **FR-045**: The test suite MUST exit 0 before the governance documents are edited and MUST exit 0 after the final edit. A test assertion that described superseded behavior MUST be replaced only with a comment naming that superseded behavior. The specimen check MUST report under P9.5. Generated skill copies MUST be regenerated from the updated sources rather than hand-edited.

### Key Entities

- **Experience Standard**: The runtime authority for what a person sees and how Highway interacts with that person during a guided workflow.
- **Accepted context**: Information the person or the applicable acceptance boundary has already accepted, including an accepted Profile and other accepted organizational or repository evidence.
- **Grounded recommendation**: A distinct, actionable proposal based on context the owning workflow declares. It stays a proposal until the person selects or otherwise accepts it.
- **Material interpretation**: Highway inferring, classifying, synthesizing, or transforming the person's input into a retained category the person did not explicitly provide.
- **Inferred-content review**: The single review shown for material interpretation, with the captured-category heading, the proposal, and one acceptance request at the bottom.
- **Direct capture**: Storing an explicit selection or a direct statement without that review, because Highway did not materially reinterpret it.
- **Retired rule**: An obligation removed from the Experience Standard. Its identifier stays unused.
- **Moved obligation**: A skill-file or retained-artifact obligation that leaves the Experience Standard and is stated again in the Skills Constitution under a new identifier. The seven moved obligations are the successors of X1.1, X1.2, X1.3, X1.4, X1.5, X4.1, and X6.1.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of these are absent from the Experience Standard as current obligations: X1.1 through X1.5, X4.1, X6.1, the long Interactive Workflow UX Contract, resume-applicability states, owner-outcome tokens, PASS/FAIL/N/A review procedure, sample counts, enforcement-tier registration, and the N3, N5, N7, N8, and N9 compliance tokens.
- **SC-002**: The interaction priority states all 5 ordered steps, and the shared guided model states all 11 steps from understanding accepted context through stopping when the person is satisfied or no useful recommendations remain.
- **SC-003**: A recommendation response presents at most 5 distinct choices, and 0 of those choices exist only to continue a recommendation loop.
- **SC-004**: Selecting a displayed recommendation requires 1 acceptance and 0 additional confirmation steps. An inferred-content review contains 1 acceptance request, placed after the proposal.
- **SC-005**: The standard version advances by one major increment from 2.0.0, the ratified date remains 2026-09-08, and the amendment record accounts for every removed, redefined, and added obligation.
- **SC-006**: A search of the Experience Standard finds 0 retired rule identifiers used as current obligations, 0 retired identifiers reused for a new rule, and 0 current citations of constitution rules removed by the runtime constitution amendment.
- **SC-007**: The suite exits 0 after the change. Every test that named the removed interaction contract, the 4.0.0 constitution footer, or X1.1, X1.2, X1.3, X1.4, X1.5, X4.1, or X6.1 as a current Experience Standard row has been updated. The development constitution has 0 edits. Shared templates have 0 edits.
- **SC-008**: 100% of the user-visible behaviors in FR-039 are still present after the amendment.
- **SC-009**: The Skills Constitution states all 7 moved obligations, and the Experience Standard states 0 of them as current rules. The constitution version advances by one minor increment from 4.0.0, and its ratified date remains 2026-09-06.

## Assumptions

- A recommendation set is small when it contains at most 5 distinct choices. The illustrated pattern of about 3 choices satisfies that limit. Further grounded choices wait for a continue-or-finish response.
- Shipped skills stop restating the generic interaction contract when they are next changed under this amended standard. That later reduction is a separate change. This feature states the requirement and does not edit skill text.
- X1.1, X1.2, X1.3, X1.4, X1.5, X4.1, and X6.1 move into the Skills Constitution with the same obligations. Shared templates stay unchanged. The move is minor, from 4.0.0 to 4.1.0, because a skill that already satisfied those rules still satisfies them.
- Development review procedures, sample counts, enforcement tiers, and test registration leave the Experience Standard and are not copied into the development constitution. Tests and live references that would otherwise still require the removed vocabulary are updated in this change.
- Skill edits are limited to citations. A skill that names the removed interaction contract, or that cites X1.1, X1.2, X1.3, X1.4, X1.5, X4.1, or X6.1 as a current Experience Standard rule, points at the Experience Standard or at P9.2 through P9.8. Its domain workflow stays as it is. Generated copies are regenerated from those sources.
- The Skills Constitution's owner and orchestrator contract already governs readiness, domain state, and completion. This feature removes the overlapping ownership and resume mechanics from the Experience Standard and does not add a second ownership or resume contract to the constitution.
- A confirmation before irreversible loss, addressable messages, and presentation labels stay because the person sees them. Their identifiers may be redefined in place. New obligations receive new identifiers.
- The major version that follows 2.0.0 is 3.0.0.
- "Here's what I've captured as your [category]:" is the required heading for inferred-content review. Domain skills may name the category. They may not replace the review with a second confirmation pattern.
- Highway identity and platform objectives stay the behavioral sources named in FR-005. This feature does not edit those documents.
