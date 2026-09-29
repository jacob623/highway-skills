<!--
Sync Impact Report
Version change: 3.0.0 → 4.0.0 (MAJOR), 2026-09-29
Bump rationale: Decision Context is strengthened so unlabeled context fails, and the shared recommendation rule is redefined. Removing or redefining a rule is MAJOR. Strengthening an obligation so previously conforming work fails is MAJOR.
Changed elements:
- Version footer: 3.0.0 → 4.0.0. Ratified stays 2026-09-08. Last Amended stays 2026-09-29.
- Redefined rule rows: X2.9, X2.25.
- Recommendation guidance now demonstrates the shared meaning without one required layout.
- Prior sync impact reports are removed from this document. Repository history keeps them.
Unchanged elements: every other current rule, including X2.16 through X2.22 and X2.27 through X2.31.
Self-application review: this amendment cites the Skills Constitution for non-restatement and does not copy a constitution rule sentence.
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
| X1.7 | Setup presentation MUST place one decision or question last, after framing, the main content, and any supporting rationale or example. | That decision or question is the last response-demanding element. | [agent-checkable] |

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
| X2.8 | An acknowledgment MUST appear only when new information changes the recommendation, interpretation, or next user-relevant action. | The response is not acknowledgment-only, and it does not promote an unrelated capability. | [agent-checkable] |
| X2.9 | Decision Context MUST use the label "**Why it matters:**" and explain why the answer matters to the person without asking a second question. | When Decision Context applies, the response shows the literal label `**Why it matters:**`, then a concise user-relevant explanation, then one unresolved question. It includes no implementation explanation, no second question, and no repetition when the implication was just established. The label is absent when Decision Context is not needed. | [agent-checkable] |
| X2.10 | An example MUST appear only when it makes the expected answer clearer without becoming a required category. | The prompt uses a few short examples specific to the current question. | [agent-checkable] |
| X2.11 | Accepted information that already answers the need MUST be reused. | The response uses that accepted information and does not ask for it again. | [agent-checkable] |
| X2.12 | When the workflow supports it, authoritative organizational information MUST be imported or validated rather than recreated conversationally. | The workflow offers import or validation before asking the person to recreate that information. | [agent-checkable] |
| X2.13 | Grounded recommendations MUST be offered before a question when context supports useful choices. | A question is not asked while a useful grounded choice remains available. | [agent-checkable] |
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
| X2.25 | Profile enrichment, Objectives, Controls, and Non-Functional Requirements MUST use the shared recommendation interaction model. | The set shows concise grounding, one or more distinct actionable recommendations, a clear selection path, and a user-authored alternative. Selecting a shown recommendation follows X2.18. Numbering is permitted and is not required. | [agent-checkable] |
| X2.26 | Recommendation rationale MUST appear only when it helps the person decide. | Rationale is omitted when the choice is already clear. | [agent-checkable] |
| X2.27 | An orchestrator MUST introduce a new domain with one short outcome-oriented transition without repeating the owner's opening. | The transition does not preview internal downstream mechanics and does not claim recommendations may exist when the receiving workflow can present them. | [agent-checkable] |
| X2.28 | A visible move into a new setup domain MUST be separated with a horizontal rule. | A horizontal rule appears between major setup domains. | [agent-checkable] |
| X2.29 | Discovered or extracted information MUST stay proposed until the user-acceptance boundary is satisfied. | That information is not presented as user-owned before acceptance. | [agent-checkable] |
| X2.30 | Evidence that cannot be recommended or inferred MUST stay unknown. | The response does not fill that evidence with a guess. | [agent-checkable] |
| X2.31 | Optional enrichment MUST NOT block continuation unless the owning domain requires it for validity. | The person can continue when the enrichment is optional. | [agent-checkable] |

A bare "Are you sure?" does not satisfy X2.1: the reader cannot decide from it. Naming the loss is
what makes the confirmation a decision rather than a formality.

### Interaction model

The rules above are the obligations. This order is how an interaction proceeds. It does not restate those rows.

1. Understand available accepted context.
2. Reuse existing information when it satisfies the need.
3. Discover or import existing authoritative information when the organization already has it.
4. Offer grounded recommendations when Highway can responsibly help.
5. Accept selected recommendations directly.
6. Ask one clear question only when information remains unresolved.
7. Present the inferred-content heading only when Highway materially inferred or transformed the input.
8. Put that review's acceptance request at the bottom.
9. Capture accepted information.
10. Offer additional grounded recommendations or let the person continue.
11. Stop when the person is satisfied or no useful recommendations remain.

### Contextual Guidance

Repository Context grounds recommendations when the current workflow can use it. A workflow uses
repository knowledge over generic guidance when the context applies, while ignoring context that
does not affect the current decision. Context reduces user effort: it does not add a collection
question solely to acknowledge or apply information. A Contextual Acknowledgment is concise and
explains the current or future recommendation or Behavior affected by a Material Influence. It
does not promote, advertise, or restate unrelated Highway capabilities.

### Context Awareness (Non-Normative Guidance)

| Generic guidance | Context-aware guidance |
|---|---|
| "Choose a suitable repository structure." | "Use the repository's declared library and governance paths when selecting the structure." |

The contrast illustrates X2.7 without creating another normative rule. When no applicable context
exists, the workflow gives bounded generic guidance and emits no Contextual Acknowledgment.

### Interaction Examples (Non-Normative)

These examples are illustrative and do not add rule IDs.

| Scenario | Non-compliant | Compliant |
|---|---|---|
| Interactive collection | "I will route your request through validation, then allocate the next stages. What are the owner, deadline, and priority?" | "What is the owner?" |
| Progress | "The evaluator is traversing its dispatch graph and applying internal checks." | "Checking the repository controls now." |

### Recommendation sets (Non-Normative)

Profile enrichment, Objectives, Controls, and Non-Functional Requirements share the meaning in X2.25. A single recommendation, bullets, or numbers can all carry that meaning. This sketch is not a required layout.

Grounded in the accepted repository context.

- Retain evidence for the stated period.
- Name an owner for the control.

Select any of these, or write your own.

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

**Version**: 4.0.0 | **Ratified**: 2026-09-08 | **Last Amended**: 2026-09-29
