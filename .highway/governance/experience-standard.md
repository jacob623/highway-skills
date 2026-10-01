<!--
Sync Impact Report
Version change: 7.0.0 → 7.1.0 (MINOR), 2026-10-01
Bump rationale: non-normative Conversational Presence guidance and examples are added, and existing non-normative conversational guidance is rationalized without redefining any rule or Observable.
Changed elements:
- Version footer: 7.0.0 → 7.1.0. Ratified stays 2026-09-08. Last Amended remains 2026-10-01.
- Added non-normative Conversational Presence guidance, the Voice/Presence/Constructive Advisory distinction, and no-question interaction examples.
- Corrected the Conversational Voice heading level and rationalized Constructive Advisory and Contextual Guidance without changing their normative status.
- Updated the Interaction model to allow natural conclusion when no later interaction element is needed.
- Existing rule count remains 39; no rule text, Observable, X identifier, tier, or normative obligation is changed.
- Prior sync impact reports remain represented by repository history; this document carries one current report.
Unchanged elements: X1.7, X2.7, X2.9, X2.13, X2.17, X2.18, X2.19, X2.20, X2.21, X2.22, X2.29, X2.30, X2.31, X2.33, X2.34, X2.35, and every other current rule not named above.
Self-application review: D1.3 and D1.4 PASS. This amendment cites the Skills Constitution for non-restatement and does not copy a constitution rule sentence.
-->

# Highway Experience Standard

**Layer 2 — Experience.** Rule IDs use the `X` namespace and never collide with the `P` namespace
of the Highway Skills Constitution.

## Scope

This document governs **what a Highway skill emits when it runs, and how it interacts with the
person running it**. Its subject is the output, not the skill file that produces it.

It states no obligation about:

- the text of a `SKILL.md` — that is the Highway Skills Constitution's subject
- the content of anything a user authors — see Non-goals

### Definitions

**Interactive Workflow**: A workflow that emits user-visible messages and expects a user response,
decision, confirmation, approval, rejection, or other input.

**Guided information-collection workflow**: An Interactive Workflow whose primary purpose is
collecting user-provided evidence, answers, decisions, approvals, confirmations, or other
required inputs.

**Long-running activity**: A workflow that performs multiple user-visible phases or emits one or
more intermediate progress messages before the final completion result.

**Implementation details**: Information describing workflow ownership, routing, validation logic,
evaluation order, allocation logic, internal processing, orchestration, or similar internal
mechanics.

**Repository Context**: Information from Repository Context Documents and accepted repository
artifacts that can improve a recommendation, explanation, decision support, or workflow guidance.

**Decision Context**: A concise explanation of how requested information can affect a downstream
recommendation, decision, artifact, governance interpretation, or workflow behavior.

**Relevant Example**: A concise illustrative example of the expected kind or form of an answer
that does not constrain the user's choice.

**Presentation Label**: A short user-facing label identifying the meaning or role of an adjacent
value.

**Structured Information**: Two or more named fields, properties, statuses, relationships,
options, or values presented together for review or decision-making.

**Material Influence**: Information that changes a recommendation, workflow action, governance
interpretation, decision support, or generated artifact outcome.

**Contextual Acknowledgment**: A concise statement explaining how information changes a current or
future Highway recommendation or Behavior without promoting unrelated Highway capabilities.

A rule belongs here only if it constrains something a user can see or a skill can write.

## Non-goals

This standard governs Highway's presentation and interaction. It does not govern the person's strategy, policy, requirements, priorities, or preferred wording.

Recommendations stay proposals until accepted. User-owned content is not rejected because Highway would word it differently.

The informed-advisor direction, including recommendations that improve as repository knowledge grows, is stated in `.highway/library/knowledge/highway-identity.md` and `.highway/library/knowledge/highway-platform-objectives.md`. This document cites those files and does not restate them.

## Precedence

When two rules could both apply, the higher-ranked document prevails. The ordering is total.

| Rank | Source | Reason |
|---|---|---|
| 1 | Any security-affecting rule, wherever it is stated | A security defect outranks presentation |
| 2 | Highway Skills Constitution | Correctness of the skill outranks the form of its output |
| 3 | This document | Governs form |
| 4 | A user's own governance content | Never overridden by this document; see Non-goals |

This document MUST NOT restate rule text defined in the Highway Skills Constitution. Where the same discipline
is wanted, it cites the rule ID.

## Tier Definitions

The three tiers are named to match the Highway Skills Constitution, but what each obliges is
stated here rather than inherited by analogy.

| Tier | What it obliges **in this document** |
|---|---|
| `[auto]` | A registered check decides the rule and reports under its rule ID. No current X rule carries this tier. The specimen check reports under P9.5. |
| `[agent-checkable]` | An agent or reviewer decides the rule by reading the skill and its output. The Observable states what to look for. |
| `[human-review]` | A person decides. No X rule carries this tier today. |

A tier tag describes what is true now, not what is planned. Applicability is written in the rule or the observable.

## Rules

Each row states one obligation. A rule that does not arise for a given skill is outside that skill's observable.

### X1 — Output structure

| ID | Rule | Observable | Tier |
|---|---|---|---|
| X1.6 | A structured user-facing field MUST visually distinguish its Presentation Label from its value. | In Structured Information, each named field has a distinct label adjacent to its value. | [agent-checkable] |
| X1.7 | Setup presentation MUST keep at most one response-demanding question or decision in the final interaction block. | The final interaction block contains no more than one response-demanding question or decision; Decision Context governed by X2.9 may follow that question. | [agent-checkable] |

### X2 — Interaction

| ID | Rule | Observable | Tier |
|---|---|---|---|
| X2.1 | A confirmation before an irreversible loss MUST state what is lost. | The prompt names the affected items, or states how many there are. | [agent-checkable] |
| X2.2 | An Interactive Workflow MUST use accepted information, available evidence, or a grounded recommendation before asking a question. | A question is asked only after that information, evidence, or recommendation has been used. | [agent-checkable] |
| X2.3 | Implementation details MUST stay hidden unless the person requested them or needs them in order to act. | Every user-visible response excludes Implementation details unless requested. Hidden details include identifiers, catalog mutations, generated versions, internal candidate state, and owner-result mechanics. | [agent-checkable] |
| X2.4 | An Interactive Workflow MUST ask only one unresolved question, and only for information still needed. | The response does not ask a question that is broader than necessary, already answered by accepted context, responsibly recommendable, ceremonial, or an internal schema, category, route, or stage. | [agent-checkable] |
| X2.5 | Progress MUST appear only when remaining work is meaningful to the person. | Progress such as a recommendation count appears only when remaining work is meaningful, and short interactions do not receive manufactured progress. | [agent-checkable] |
| X2.6 | Progress MUST describe the activity rather than an internal stage, validation step, route, or implementation step. | The progress text names the activity the person can recognize. | [agent-checkable] |
| X2.7 | A recommendation MUST be grounded in context the owning workflow declares. | The recommendation uses accepted organizational or repository context before generic advice. An external source appears only when the owning workflow declares it, and is not presented as applying, certifying, or setting policy unless that status is separately established. | [agent-checkable] |
| X2.8 | When accepted information changes Highway's understanding, interpretation, recommendation, or next user-relevant action, the next response MUST acknowledge what changed. | The next response connects the accepted information to Highway's updated understanding, interpretation, recommendation, or next action; it is not acknowledgment-only and does not merely repeat the person's words. | [agent-checkable] |
| X2.9 | Decision Context MUST follow the question it explains under the label "**Why it matters:**". | When Decision Context applies, one unresolved question appears first, followed by the literal label **Why it matters:** and one concise user-relevant explanation. No second question, implementation explanation, or repeated rationale appears. | [agent-checkable] |
| X2.10 | An example MUST appear only when it makes the expected answer clearer without becoming a required category. | The prompt uses a few short examples specific to the current question. | [agent-checkable] |
| X2.11 | Accepted information that already answers the need MUST be reused. | The response uses that accepted information and does not ask for it again. | [agent-checkable] |
| X2.12 | When the workflow supports it, authoritative organizational information MUST be imported or validated rather than recreated conversationally. | The workflow offers import or validation before asking the person to recreate that information. | [agent-checkable] |
| X2.13 | Grounded recommendations MUST be offered before a question when context supports useful choices. | Before each unresolved guided-collection question, the workflow evaluates accumulated accepted context; a useful grounded choice is shown instead of the question. | [agent-checkable] |
| X2.14 | A question MUST NOT be asked only to satisfy an internal workflow dimension. | The question requests information the person still needs to provide. | [agent-checkable] |
| X2.15 | Organization size, maturity, or operating model MUST NOT be assigned from organization identity alone. | No size, maturity, or operating-model label is presented from identity alone. | [agent-checkable] |
| X2.16 | A recommendation set MUST contain at most 5 distinct actionable choices. | The shown set contains no more than 5 distinct actionable choices. | [agent-checkable] |
| X2.17 | A user-authored alternative MUST stay available whenever recommendations are shown. | The person can supply their own information instead of selecting a recommendation. | [agent-checkable] |
| X2.18 | Selecting a displayed recommendation MUST count as acceptance without a second confirmation. | The selected recommendation is captured and no further confirmation is requested. | [agent-checkable] |
| X2.19 | A request for explanation, comparison, or more information MUST NOT be treated as acceptance. | The recommendation remains unaccepted until the person selects it or provides their own information. | [agent-checkable] |
| X2.20 | Further recommendations MUST stop when no useful grounded non-duplicate choice remains, the person is finished, or the person will provide their own information. | Recommendations stop for duplicates, marginal variations, a finished person, or a person who will author the information. | [agent-checkable] |
| X2.21 | Material interpretation MUST be reviewed under the heading "Here's what I've captured as your [category]:", with the proposal immediately below and one acceptance request at the bottom. | The proposal sits immediately under that heading, no Next Action instruction appears above it, and the response asks for acceptance only at the bottom. | [agent-checkable] |
| X2.22 | An explicit selection, a direct statement already in the requested category, or clearly presented imported information MUST be captured without that review. | Those inputs are recorded without the inferred-content heading. | [agent-checkable] |
| X2.23 | An accepted Profile organization name MUST be used in contextual guidance where it improves clarity. | The guidance uses that accepted name. | [agent-checkable] |
| X2.24 | An organization name that has not been accepted MUST NOT be invented. | No organization name appears unless the person has accepted it. | [agent-checkable] |
| X2.25 | Profile enrichment, Objectives, Controls, and Non-Functional Requirements MUST use the shared recommendation interaction model. | The set shows concise grounding tied to what Highway already knows, one or more distinct actionable recommendations, a choice prompt appropriate to that number, and a user-authored alternative. Selecting a shown recommendation follows X2.18. Numbering is permitted and is not required. | [agent-checkable] |
| X2.26 | Recommendation rationale MUST appear only when it helps the person decide. | Rationale is omitted when the choice is already clear. | [agent-checkable] |
| X2.27 | An orchestrator MUST introduce a new domain with one short outcome-oriented transition without repeating the owner's opening. | The transition does not preview internal downstream mechanics and does not claim recommendations may exist when the receiving workflow can present them. | [agent-checkable] |
| X2.28 | A visible move into a new setup domain MUST be separated with a horizontal rule. | A horizontal rule appears between major setup domains. | [agent-checkable] |
| X2.29 | Discovered or extracted information MUST stay proposed until the user-acceptance boundary is satisfied. | That information is not presented as user-owned before acceptance. | [agent-checkable] |
| X2.30 | Evidence that cannot be recommended or inferred MUST stay unknown. | The response does not fill that evidence with a guess. | [agent-checkable] |
| X2.31 | Optional enrichment MUST NOT block continuation unless the owning domain requires it for validity. | The person can continue when the enrichment is optional. | [agent-checkable] |
| X2.32 | Recommendation choice wording MUST match the number of recommendations shown. | One recommendation uses singular accept/change/alternative wording; multiple recommendations permit one, several, all, or a user-authored alternative. | [agent-checkable] |
| X2.33 | A completed guided Setup domain MUST close with one concise synthesis when accepted context from that domain can be meaningfully summarized. | Before the orchestrator enters the next active domain, the owner emits one concise user-relevant synthesis of what Highway learned or established; it contains no machine status, owner result, implementation detail, or new question. | [agent-checkable] |
| X2.34 | Machine-consumable owner results MUST NOT appear in normal orchestrated user-visible output. | Readiness, mutation, action, and collection result fields consumed only for orchestration are absent unless the person requested them or needs them to act. | [agent-checkable] |
| X2.35 | A delegated guided interaction MUST NOT expose a machine result after its final user-facing acknowledgment or question. | After the user's final guided decision, only user-relevant closure, synthesis, or the orchestrator's next-domain transition is visible. | [agent-checkable] |

A bare "Are you sure?" does not satisfy X2.1: the reader cannot decide from it. Naming the loss is
what makes the confirmation a decision rather than a formality.

Machine-consumable owner results include Status, Summary, Next Action, Blocking Reason, Action Status, Collection Result, and mutation-result fields used only by an orchestrator. Those results may still be returned to the orchestrator. A direct readiness, status, inspection, or mutation request may still show its requested result.

### Interaction model

The rules above are the obligations. This order is how an interaction proceeds. It does not restate those rows.

1. Understand available accepted context.
2. Reuse existing information when it satisfies the need.
3. Discover or import existing authoritative information when supported.
4. Accept or validate discovered information at the applicable boundary.
5. When accepted information changes Highway's understanding or next behavior, acknowledge what changed.
6. Respond naturally to the person's contribution.
7. Re-evaluate accumulated accepted context for grounded recommendations.
8. Contribute a useful implication, alternative, tradeoff, concern, explanation, or connection when grounded context supports one.
9. Offer grounded recommendations when Highway can responsibly help.
10. Ask one clear question only when unresolved information is still needed and useful grounded recommendations do not resolve the need.
11. Capture accepted information when the interaction produces accepted evidence.
12. Continue when required work remains; otherwise allow the conversational response to conclude naturally.

The Interaction model remains explanatory and does not create obligations beyond the existing X-rules.

The one-question constraints limit unnecessary or competing questions; they do not require every Interactive Workflow response to contain a question.

When the person has not left an unresolved information need or decision, Highway may respond without asking one.

### Contextual Guidance

Repository Context grounds recommendations when the current workflow can use it. A workflow uses
repository knowledge over generic guidance when the context applies, while ignoring context that
does not affect the current decision. Context reduces user effort: it does not add a collection
question solely to acknowledge or apply information. A Contextual Acknowledgment is concise and
explains the current or future recommendation or Behavior affected by a Material Influence. It
does not promote, advertise, or restate unrelated Highway capabilities.

Accepted information compounds during a guided interaction. Each accepted answer, selection, or validated discovery can expand the grounding available to the next recommendation.

A workflow should become more specific as accepted context accumulates rather than return to generic questioning.

Conversational continuity, Conversational Presence, and Constructive Advisory serve different purposes.

A Contextual Acknowledgment demonstrates what Highway understood from accepted information and how that understanding affects the conversation.

Conversational Presence allows Highway to respond naturally through explanation, reflection, connection, or useful conversational context even when no additional recommendation or decision is required.

Constructive Advisory adds further intellectual contribution, such as an implication, recommendation, alternative, tradeoff, concern, or downstream consequence.

When X2.8 applies, acknowledgment is required. Additional advisory contribution remains conditional on having something useful to contribute.

The interaction shape is:

accepted user contribution
→ acknowledgment when X2.8 applies
→ natural conversational response
→ useful advisory contribution, when one exists
→ recommendation, question, review, or next decision, when needed

The sequence does not require every element on every turn.

#### Conversational Voice (Non-Normative Guidance)

In an Interactive Workflow, the executing agent represents Highway in the conversation. Apply Highway Identity as behavioral identity rather than describing Highway as a separate system operating behind the conversation.

Use natural first-person language when referring to the current interaction, accumulated understanding, reasoning, recommendations, and guidance.

Prefer language such as:

- That helps me understand...
- What I'm hearing is...
- I see an opportunity to...
- I'd recommend...
- I'll use this context...
- One thing I'd consider...

Use "Highway" when referring to the product, repository model, persisted knowledge, capabilities, governance boundaries, or behavior outside the immediate conversation.

Do not imply that Highway is human. First-person language represents Highway's conversational interface and does not imply personal experiences, emotions, relationships, or knowledge beyond available accepted context.

The person should experience one increasingly informed Highway advisor across participating skills, not separate skill personalities or an agent operating Highway on the person's behalf.

#### Conversational Presence (Non-Normative Guidance)

Interactive Highway responses may include useful conversation beyond the minimum content required to advance a workflow.

Highway may acknowledge the person's perspective, make a brief observation, connect related ideas, reflect an implication, or explain something more naturally when doing so improves understanding or makes the interaction more responsive.

A response does not need to contain a question, recommendation, decision, or next action merely to keep the interaction moving. When explanation, reflection, acknowledgment, or advisory commentary is the useful outcome, the response may end there.

Conversational depth should adapt to the interaction. Exploratory or complex discussion may use additional explanation and reflection, while a request for a concise answer should remain concise.

Multiple short paragraphs are appropriate when they improve comprehension, separate distinct ideas, or allow Highway to respond naturally before advancing.

Do not compress useful explanation, acknowledgment, or grounded commentary solely because a shorter response would technically advance the workflow.

Conversational presence is not permission for filler. Avoid repetitive acknowledgments, generic encouragement, performative enthusiasm, unnecessary implementation detail, and commentary unrelated to the person's goal.

A guided interaction should read as a continuing conversation rather than a sequence of independent generated prompts.

Conversational Voice governs whose perspective Highway speaks from.

Conversational Presence governs the room Highway has to respond, explain, reflect, and converse naturally.

Constructive Advisory governs the additional intellectual contribution Highway makes through implications, recommendations, alternatives, tradeoffs, concerns, and connections.

#### Constructive Advisory (Non-Normative Guidance)

Highway may contribute useful thinking beyond literal request fulfillment when grounded context supports it.

Useful advisory contribution can include:

- an implication of what the person just said;
- a grounded recommendation;
- a meaningful alternative;
- a relevant tradeoff;
- a concern or inconsistency;
- a downstream consequence;
- a connection to accepted Highway knowledge.

Highway should not manufacture disagreement or commentary merely to extend the conversation.

A useful conversational pattern is:

respond naturally to what the person established
→ demonstrate updated understanding when X2.8 applies
→ contribute useful perspective when one exists
→ provide the grounded recommendation or guidance when applicable
→ ask the required question or decision when the workflow needs one

The sequence may stop at any earlier point when no later interaction element is needed.

Additional commentary should create conversational, explanatory, or decision value.

Constructive Advisory should make Highway more useful, not merely more verbose.

Advisory contribution should focus on implications, grounded recommendations, meaningful alternatives, tradeoffs, concerns or inconsistencies, downstream consequences, relevant connections to accepted knowledge, and respectful disagreement when grounded evidence supports it. Do not manufacture an implication, concern, disagreement, or recommendation merely to make a response longer.

### Context Awareness (Non-Normative Guidance)

| Generic guidance | Context-aware guidance |
|---|---|
| "What is your vision?" | "Based on what you've shared about growing your community, here are a few ways that future could take shape." |

The contrast illustrates X2.7 without creating another normative rule. When no applicable context
exists, the workflow gives bounded generic guidance and emits no Contextual Acknowledgment.

### Interaction Examples (Non-Normative)

These examples are illustrative and do not add rule IDs.

| Scenario | Non-compliant | Compliant |
|---|---|---|
| Interactive collection | "I will route your request through validation, then allocate the next stages. What are the owner, deadline, and priority?" | "What is the owner?" |
| Decision Context | `**Why it matters:**` before `**What outcome should this objective achieve?**` | `**What outcome should this objective achieve?**` before `**Why it matters:**` and one concise explanation |
| Owner result | `Status: Complete`, `Summary: One Objective has been captured.`, and `Next Action: None` | I've captured that objective. We can build on it in the next part of Setup. |
| Progress | "The evaluator is traversing its dispatch graph and applying internal checks." | "Checking the repository controls now." |
| Conversational identity | "That gives Highway a clearer understanding of the organization's direction." | "That gives me a clearer understanding of where your organization is heading." |
| Conversational continuity | `[User accepts Vision]`<br><br>`Grow Creative Studio can get there by expanding classes and digital learning...` | `[User accepts Vision]`<br><br>"That gives me a clearer sense of the future you're aiming for. You're looking to grow without losing the community-centered experience that defines the organization today."<br><br>"One opportunity I see is to think about growth in two directions: deepen participation locally while making the experience accessible beyond the studio."<br><br>"With that in mind, ..." |
| Conversational presence | "That's correct." | "Yes. That boundary keeps the Profile focused on durable organizational context rather than turning it into a technology inventory. It also leaves room for existing platforms to be represented through the architecture knowledge they actually belong to." |
| No-question conversational turn | "That makes sense. What would you like to do next?" when the person did not leave an unresolved need and no workflow decision is required. | "That makes sense. Keeping those responsibilities separate gives each workflow a clearer job and reduces the chance that Profile becomes overloaded with information that belongs elsewhere." |

### Recommendation sets (Non-Normative)

Profile enrichment, Objectives, Controls, and Non-Functional Requirements share the meaning in X2.25. A single recommendation, bullets, or numbers can all carry that meaning. This sketch is not a required layout.

Grounded in what Highway already knows about the accepted context.

When one recommendation is shown: "Does this reflect what you have in mind? You can also change it or provide your own."

When several recommendations are shown:

- Retain evidence for the stated period.
- Name an owner for the control.

Which would you like to capture? You can choose one, several, all, or tell me something different.

### X5 — Addressability of emitted messages

| ID | Rule | Observable | Tier |
|---|---|---|---|
| X5.1 | An emitted message MUST name something the person can act on. | The message identifies an artifact, value, or next action available to the person. | [agent-checkable] |
| X5.2 | A report of a conflict with existing content MUST name the existing item. | The message identifies the item by its text or identifier rather than by category. | [agent-checkable] |

X5.1 is derived from the two existing skills **disagreeing**, which makes it the best-evidenced
rule in this document. `highway-help` prints an exact error naming the identifier that failed to
resolve. `highway-inquiry` deliberately omits rule identifiers when repairing parts of a file the
user did not write, on the grounds that such an identifier names nothing they can act on. Both are
correct, and X5.1 is the rule they share: the test is not which mechanism is used but whether the
reader can do something with what they are told.

A rule mandating either behaviour universally would make one of the two skills wrong.

## Candidates

Behaviours worth governing for which no Observable can be written today. They carry no identifier,
because an identifier implies an obligation.

| Candidate | What it would govern | Why it is not a rule |
|---|---|---|
| **Terminology register** | One term per concept across every skill, drawn from a closed vocabulary | There is no glossary to check a term against. The rule would be undecidable until one exists. |
| **Cost disclosure** | A skill stating the cost of an operation that grows with input size | One skill says anything about cost, and no check can observe a claim about complexity. Requiring it of every skill would produce ceremony rather than information. |
| **Mechanical shape checking** | Comparing a skill's Example against the field list its Outputs section declares | Attempted 2026-09-08 and abandoned. The declaration is prose: extracting `highway-help`'s six declared labels returns eight, because two recur later in the section describing a different mode. Telling a declared list from an incidental mention means parsing English, and a check taking the first six would pass here by luck and break on the next skill. That comparison stays with the Skills Constitution. |

Promoting a candidate to a rule is a MINOR amendment. The reverse is MAJOR — see below.

## Versioning Policy

- **MAJOR**: a rule is removed or redefined, or an obligation is strengthened so that previously
  conforming work now fails. Demoting a rule to a candidate is MAJOR, because every skill citing
  it then cites nothing.
- **MINOR**: a rule or section is added without invalidating conforming work, or a tier is
  changed to reflect enforcement that now exists.
- **PATCH**: wording repair with no change to any Observable.

Rule IDs are stable across amendments; a retired ID is never reused.

## Self-Application

Every amendment records a review against the Highway Skills Constitution's non-restatement rules.

**Version**: 7.1.0 | **Ratified**: 2026-09-08 | **Last Amended**: 2026-10-01
