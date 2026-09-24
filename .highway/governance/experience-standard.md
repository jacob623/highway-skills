<!--
Sync Impact Report
Version change: 1.4.1 → 1.5.0 (MINOR), 2026-09-24

--- Amendment 1.4.1 → 1.5.0 (MINOR), 2026-09-24 ---
Bump rationale: adds Repository Context definitions, Contextual Guidance, and X2.7-X2.8 without
changing X2.1-X2.6 or invalidating the existing interaction rules.
Added definitions: Repository Context, Material Influence, and Contextual Acknowledgment.
Added guidance: Contextual Guidance and Context Awareness, including a generic-versus-context-aware
contrast and a no-promotion boundary for acknowledgments.
Added rules: X2.7-X2.8. Removed rules: none. Rule count: 17.
Self-application review: X2.7-X2.8 remain subordinate to the Highway Skills Constitution and do
not restate P11.1-P11.5; existing X2.1-X2.6 text, identifiers, tiers, Observables, and samples
remain unchanged.

Version change: 1.4.0 → 1.4.1 (PATCH), 2026-09-23

--- Amendment 1.4.0 → 1.4.1 (PATCH), 2026-09-23 ---
Bump rationale: clarifies the Interactive Workflow UX Contract as interpretive and organizational
guidance, adds contract-local non-normative examples, and makes applicability and uniqueness
validation explicit without changing X2.2-X2.6 or introducing another authority.
Changed elements: contract authority wording, rule-attributed guidance, progress applicability,
illustrative examples, and duplicate-contract validation expectations.
Unchanged elements: X2.2-X2.6 normative text, identifiers, tiers, Observables, samples, and N5.
Self-application review: the contract remains subordinate to X2.2-X2.6; P10.1-P10.2 and
D1.5/D8.1 remain the applicable compliance and dependent-review obligations.

Version change: 1.3.1 → 1.4.0 (MINOR), 2026-09-23

--- Amendment 1.3.1 → 1.4.0 (MINOR), 2026-09-23 ---
Bump rationale: adds one reusable Interactive Workflow UX Contract without changing X2.2-X2.6,
adding an X rule identifier, or invalidating the existing interaction rules.
Added guidance: one authoritative contract covering next action, implementation-detail boundaries,
single-question collection, applicable progress, outcomes, ownership, and resume behavior.
The contract is scoped by workflow applicability and does not create a second governance authority.
Self-application review: X2.2-X2.6 normative text is unchanged; P10.1-P10.2 and D1.5/D8.1
remain the applicable compliance and dependent-review obligations.

Version change: 1.3.0 → 1.3.1 (PATCH), 2026-09-23

--- Amendment 1.3.0 → 1.3.1 (PATCH), 2026-09-23 ---
Bump rationale: corrects the X2 table presentation, defines two existing applicability terms,
and separates the non-normative N/A example without changing any rule, Observable, tier, sample,
N/A condition, or non-goal boundary.
Changed elements: the X2.2-X2.6 table placement; the Definitions subsection; X2.3 and X2.4
Observable terminology; the X2 rationale prose; and the Interaction Examples table structure.
Unchanged elements carry forward, including X2.1, the X namespace, N5, PASS/FAIL/N/A vocabulary,
and Feature 079's approved interaction obligations.
Self-application review: the amendment changes no rule text from the Highway Skills Constitution,
adds no development rule, and supersedes no other document.

--- Amendment 1.2.0 → 1.3.0 (MINOR), 2026-09-23 ---
Bump rationale: five additive interaction rules, rationale, and non-normative examples are added
without invalidating unchanged skills. X2.5 and X2.6 explicitly report N/A when no long-running
activity exists.
Added rules: X2.2-X2.6 in the X2 Interaction section.
Added definitions: Interactive Workflow and Long-running activity.
Added guidance: rationale and compliant/non-compliant examples for collection and progress output,
including an N/A example for workflows without long-running activity.
Applicability: X2.2-X2.6 apply to Interactive Workflows; X2.5 and X2.6 are N/A without a
long-running activity.
Constitution synchronization: the Highway Skills Constitution adds Principle X and P10.1-P10.2,
which govern compliance and exception accountability without restating these rules.

--- Amendment 1.1.0 → 1.2.0 (MINOR), 2026-09-09 ---
Bump rationale: one additive retained-file rule is added without invalidating conforming work.
Added rule: X1.5 requires frontmatter on every retained file artifact emitted by a skill and
excludes transient messages and other non-file output.
Verified before enabling: highway-nfrs and highway-controls both use retained record structures
with frontmatter; their transient reports remain outside the rule.
Restatement review: X1.5 is checked against P9.1 and D8.1; it governs the emitted artifact, while
P9.1 governs the authoring citation and D8.1 governs development review after shared changes.
Self-application review: the Experience Standard emits no retained file artifact, so X1.5 is N/A.

Previous amendment:
Version change: none → 1.0.0 (initial ratification); amended 1.0.0 → 1.1.0 on 2026-09-08

--- Amendment 1.0.0 → 1.1.0 (MINOR), 2026-09-08 ---
Bump rationale: one rule is added and no conforming work is invalidated. The single violation it
  exposed was repaired before the rule was enabled, so the strengthening clause that would make
  this MAJOR does not apply.
Added rules (1):
  - X1.4: a specimen agrees with the metadata it repeats. Added because a mechanically decidable
    obligation was found with no rule behind it. The alternatives were rejected: enforcing it as
    a bare check leaves the obligation discoverable only by failing the suite, and widening X1.2
    from shape to values would make that rule mean whatever its check happens to do.
Tier change: [auto] 0 → 1. X1.4 is the only X rule a script decides; the note below is corrected
  accordingly.
Verified before enabling: highway-help's Example showed Version 3.0.1 against a frontmatter of
  3.0.2 — drift introduced by feature 017, which bumped the version and left the Example. Repaired
  first. highway-inquiry's Example repeats no metadata value and records N/A.
Restatement review: X1.4 is checked against P and D and restates neither. No rule in either
  document constrains a skill's Example section.
Follow-up TODOs: none.
Rationale: first version of a new document. It is not an amendment to any existing constitution.
  The `X` namespace is introduced here and has no prior version.

Relationship to the other governing documents: the Highway Skills Constitution governs the text
  inside a SKILL.md; this document governs what a skill emits when it runs. No rule, Observable,
  or tier from that document is carried over, restated, or superseded here. Where both could
  appear to apply, the Skills Constitution prevails — see Precedence.

Added sections: Scope, Non-goals, Precedence, Tier Definitions, Rules, Candidates,
  Versioning Policy, Self-Application.
Removed sections: none. Modified principles: none; no prior version exists.

Rule count: 10. Tier counts: [auto] 1, [agent-checkable] 9, [human-review] 0.

Why only one rule is tagged [auto]: seven of the nine govern runtime output — prompt wording,
  message content, artifact contents — which no static check reading a SKILL.md can observe. Only
  X1.4 is decided by a registered check today. The tier tags describe what is true rather than
  what is intended, and a rule is retagged only when a check exists that decides it.

Restatement review, against the non-restatement rules of the Highway Development Constitution.
  Each entry names the rule it was checked against by ID and states the distinction, without
  reproducing the other rule's text:
  - X2.1 against P1.7: different trigger and different obligation. P1.7 is engaged by an input the
    skill cannot use; X2.1 by an act that destroys something. P1.7 settles whether the skill stops
    to ask; X2.1 settles what the asking must contain.
  - X5.1 against P4.6: P4.6 is engaged only by one subject matter and settles whether the agent
    speaks at all. X5.1 is engaged by every emitted message and settles who it must be useful to.
  - X6.1 against P6.6: P6.6 is about which action is chosen, and its Observable looks at branch
    conditions. X6.1 is about what an emitted artifact contains. A skill can choose its actions
    deterministically and still write a timestamp into the file it produces; P6.6 does not reach
    that, and X6.1 does.
  - X1.1 through X1.3: no rule in either constitution constrains what the Outputs section
    declares. The section is required to exist; its content was ungoverned until now.
  - X1.1 through X1.3: no rule in either constitution constrains what the Outputs section
    declares. The section is required to exist; its content was ungoverned until now.

Rules resting on a single skill: X1.3, X2.1, X4.1, X5.2, X6.1. Marked in the Sample column.
  `highway-help` writes no file, asks nothing, confirms nothing, and reports no conflict with
  existing content, so placement, interaction, determinism and conflict-reporting each generalise
  from `highway-inquiry` alone. X1.3 rests on `highway-help` alone for the opposite reason:
  `highway-inquiry` has no empty-result case, because a questionnaire it cannot find is an error
  rather than an empty result.

Candidates recorded rather than admitted: terminology register, cost disclosure. Both lack a
  writable Observable today.

Follow-up TODOs: none.
-->

# Highway Experience Standard

**Layer 2 — Experience.** Rule IDs use the `X` namespace and never collide with the `P` namespace
of the Highway Skills Constitution or the `D` namespace of the development constitution.

## Scope

This document governs **what a Highway skill emits when it runs, and how it interacts with the
person running it**. Its subject is the output, not the skill file that produces it.

It states no obligation about:

- the text of a `SKILL.md` — that is the Highway Skills Constitution's subject
- how this project is built — that is the development constitution's subject
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

**Material Influence**: Information that changes a recommendation, workflow action, governance
interpretation, decision support, or generated artifact outcome.

**Contextual Acknowledgment**: A concise statement explaining how information changes a current or
future Highway recommendation or Behavior without promoting unrelated Highway capabilities.

A rule belongs here only if it constrains something a user can see or a skill can write.

## Non-goals

**This document governs the form of generated content and states no obligation about the content
of a user's own governance artifacts.**

A Highway skill may require that a user's requirement carry a measurable threshold, because that
is form. It may never require that the threshold be any particular value, because that is content,
and the content belongs to the user. The same holds for their wording, their priorities, and their
identifiers.

This matters because a skill that generates governance artifacts is easy to build and easy to
overreach with. A user whose own policy is rejected for its prose style has been failed by a tool
that mistook its remit.

## Precedence

When two rules could both apply, the higher-ranked document prevails. The ordering is total.

| Rank | Source | Reason |
|---|---|---|
| 1 | Any security-affecting rule, wherever it is stated | A security defect outranks presentation |
| 2 | Highway Skills Constitution | Correctness of the skill outranks the form of its output |
| 3 | This document | Governs form |
| 4 | A user's own governance content | Never overridden by this document; see Non-goals |

This document MUST NOT restate rule text defined in either constitution. Where the same discipline
is wanted, it cites the rule ID.

## Tier Definitions

The three tiers are named to match the other two governing documents, but what each obliges is
stated here rather than inherited by analogy. `[auto]` already means different things in the two
constitutions, and borrowing a meaning across documents is a known source of false claims.

| Tier | What it obliges **in this document** |
|---|---|
| `[auto]` | A registered check decides the rule and reports under its rule ID. **X1.4 carries this tier**; no other rule does, because no other check exists. |
| `[agent-checkable]` | An agent or reviewer decides the rule by reading the skill and its output. The Observable states what to look for. |
| `[human-review]` | A person decides. No X rule carries this tier today. |

A tier tag describes what is true now, not what is planned.

### N/A conditions

A rule whose trigger does not arise is reported `N/A` under a condition token. `N1` and `N2` are
declared by the Highway Skills Constitution and are not restated here. This document declares one
further condition, because the rule that needs it lives here:

| Token | Condition |
|---|---|
| **N3** | The specimen repeats no value the skill's metadata also declares. |
| **N5** | The workflow has no long-running activity; this applies to X2.5 and X2.6. |

If a third governing document ever needs its own condition, the vocabulary should be unified in
one place rather than split further.

## Rules

The **Sample** column records how many existing skills a rule generalises from. A rule marked
*one* rests on a single example and should be revisited when a third skill exists.

A rule whose trigger does not arise for a given skill is satisfied vacuously by that skill, and is
recorded `N/A` rather than as an exception.

### X1 — Output structure

| ID | Rule | Observable | Tier | Sample |
|---|---|---|---|---|
| X1.1 | A skill MUST declare the shape of what it emits. | The Outputs section states the fields, sections, or file structure produced. | [agent-checkable] | two |
| X1.2 | Emitted content MUST follow its declared shape. | Every field and ordering present in the output appears in the Outputs declaration. | [agent-checkable] | two |
| X1.3 | An empty result MUST have a declared form. | The Outputs section states the exact content emitted when there is nothing to report. | [agent-checkable] | one |
| X1.4 | A specimen MUST agree with the metadata it repeats. | Every value the Example section shares with the skill's frontmatter matches it. | [auto] | two |
| X1.5 | Every retained file artifact emitted by a skill MUST include frontmatter. | Each retained emitted file begins with frontmatter; transient messages and other non-file output are excluded. | [agent-checkable] | two |

X1.3 exists because an empty result is where output contracts are usually left undefined, and an
empty table tells a reader nothing about whether the skill worked.

X1.4 governs the `## Example` section, which is a recorded specimen of a skill's output. A
specimen that contradicts the skill it illustrates misinforms every reader who trusts it, and it
is copied verbatim into each agent tree. This is the only rule here a script decides today.

### X2 — Interaction

| ID | Rule | Observable | Tier | Sample |
|---|---|---|---|---|
| X2.1 | A confirmation before an irreversible loss MUST state what is lost. | The prompt names the affected items, or states how many there are. | [agent-checkable] | one |
| X2.2 | An Interactive Workflow MUST prioritize the user's next required action. | For Interactive Workflows, the first emitted content is a greeting, required question, required decision, or required error response. Read-only or informational workflows are N/A. | [agent-checkable] | two |
| X2.3 | An Interactive Workflow MUST NOT begin with implementation details unless the user requested those details. | The opening response excludes Implementation details unless requested. | [agent-checkable] | two |
| X2.4 | A guided information-collection workflow MUST ask only the next required question. | During a Guided information-collection workflow, the prompt contains at most one unresolved collection question and does not introduce future workflow stages. | [agent-checkable] | one |
| X2.5 | A long-running activity MUST disclose current progress. | For a long-running activity, each progress update identifies the current activity, phase, or step. X2.5 is N/A when no long-running activity exists. | [agent-checkable] | one |
| X2.6 | A progress message MUST describe activity rather than implementation. | Each progress message describes work being performed and excludes reasoning, workflow mechanics, validation behavior, and internal orchestration. X2.6 is N/A when X2.5 is N/A. | [agent-checkable] | one |
| X2.7 | An Interactive Workflow MUST ground recommendations in relevant Repository Context when such context exists. | A recommendation cites the applicable Repository Context Document or accepted repository artifact when available. | [agent-checkable] | one |
| X2.8 | An Interactive Workflow MUST acknowledge information that produces a Material Influence on future recommendations, workflow actions, governance interpretation, or decision support. | A concise acknowledgment precedes continuation when the information changes a future action or recommendation. | [agent-checkable] | one |

A bare "Are you sure?" does not satisfy X2.1: the reader cannot decide from it. Naming the loss is
what makes the confirmation a decision rather than a formality.

The rationale for X2.2-X2.6 is that an interactive workflow is easiest to follow when its first
message and each collection step make the user's next action clear. Implementation details belong
only in a response requested for that purpose, because internal routing and evaluation mechanics
do not help a person answer the current question. A long-running activity is the permitted
exception for progress disclosure: the person needs to know what work is currently happening, but
the update remains activity-focused rather than explaining internal orchestration.

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
| Long-running activity | "The evaluator is traversing its dispatch graph and applying internal checks." | "Checking the repository controls now." |

| Scenario | Example |
|---|---|
| No long-running activity (N/A) | A read-only status workflow emits no intermediate activity; record X2.5=N5 and X2.6=N5 in review output. |

### Interactive Workflow UX Contract

This contract is the single reusable interpretive and organizational guidance section for
Interactive Workflows. It organizes, scopes, and applies X2.2-X2.6, N5 applicability, and the
defined concepts Interactive Workflow, Guided information-collection workflow, Long-running
activity, and Implementation details. It does not create additional X-rule obligations, modify
X2.2-X2.6 normative text, or introduce new X rule identifiers. The X2.2-X2.6 rules remain the
sole normative interaction authority.

The bullets below interpret and organize those existing rules; they are not a second rule
namespace. Each skill remains responsible for its domain workflow contract, artifact ownership,
progress fields, terminality rules, and domain-specific behavior.

#### Applicability and next action

- As an application of X2.2, the first user-facing content prioritizes the next required question,
  decision, confirmation, approval, rejection, or actionable error.
- As applications of X2.3 and X2.6, normal user-facing output describes user-relevant activity
  and omits routing, validation, evaluation-order, allocation, processing, and orchestration
  details unless requested.
- A delegated action routes the person to the owning workflow without claiming ownership or
  presenting internal delegation as user work; this is an ownership convention, not a new X rule.
- An interactive workflow that is not guided information collection adopts only the applicable
  activity-focused guidance; it does not acquire artificial wizard stages.

#### Guided collection and progress

- As an application of X2.4, a guided collection workflow exposes exactly one unresolved
  response-demanding question or decision at a time. Supporting context and examples may
  accompany it.
- When meaningful ordered work or long-running activity exists, progress identifies current
  activity and the applicable completed/remaining counts or position/remaining counts.
- When no meaningful ordered work or long-running activity exists, progress stages are not
  manufactured; X2.5 and X2.6 are recorded as N5 where applicable.
- Domain-specific fields remain owned by the skill: question, category, proposal, candidate,
  domain, finding, step, position, and current activity are not interchangeable requirements.

#### Exits, outcomes, and resume

- A **User Exit** is `pause`, `cancel`, or `stop responding`; it describes user-directed
  suspension or termination of the current interaction.
- An **Owner Outcome** is `declined`, `aborted`, or `blocked`; it describes a result returned by
  the owner workflow and must not be presented as user intent.
- Each workflow declares one resume applicability state: `Persisted owner evidence`, `Transient interaction state`, `New interaction`, or `Not Applicable`.
- A workflow must not imply restoration of unsupported unanswered questions, drafts, cancellation
  markers, or hidden checkpoints. Where owner evidence governs resume, the workflow selects the
  first incomplete applicable domain, question, category, proposal, candidate, or finding.

#### Ownership display

- The owning workflow retains authority for its identifiers, artifacts, catalogs, proposals,
  candidates, relationships, and completion claims.
- An aligned skill does not allocate another workflow's identifiers, write its artifacts, modify
  its catalogs, claim its completion, or replace its decisions with a substitute record.

#### Illustrative Examples (Non-Normative)

These examples illustrate the contract's vocabulary and applicability. They do not add X rules,
status namespaces, or authoritative copies of this contract.

| Concept | Illustrative values |
|---|---|
| User Exit | `pause`, `cancel`, `stop responding` |
| Owner Outcome | `declined`, `aborted`, `blocked` |
| Resume Applicability | `Persisted owner evidence`, `Transient interaction state`, `New interaction`, `Not Applicable` |

Validation verifies that exactly one authoritative Interactive Workflow UX Contract section exists,
that no second authoritative copy exists, that skill references are references only, and that
references do not reproduce the complete contract.

### X4 — Artifact placement

| ID | Rule | Observable | Tier | Sample |
|---|---|---|---|---|
| X4.1 | A skill that writes a file MUST declare its path. | The Outputs section names each path written. | [agent-checkable] | one |

X4.1 binds only skills that write. A skill that emits nothing to disk is `N/A` rather than obliged
to declare an absence.

### X5 — Addressability of emitted messages

| ID | Rule | Observable | Tier | Sample |
|---|---|---|---|---|
| X5.1 | An emitted message MUST name something its reader can act on. | The message identifies an artifact, value, or next action available to the reader. | [agent-checkable] | two |
| X5.2 | A report of a conflict with existing content MUST name the existing item. | The message identifies the item by its text or identifier rather than by category. | [agent-checkable] | one |

X5.1 is derived from the two existing skills **disagreeing**, which makes it the best-evidenced
rule in this document. `highway-help` prints an exact error naming the identifier that failed to
resolve. `highway-inquiry` deliberately omits rule identifiers when repairing parts of a file the
user did not write, on the grounds that such an identifier names nothing they can act on. Both are
correct, and X5.1 is the rule they share: the test is not which mechanism is used but whether the
reader can do something with what they are told.

A rule mandating either behaviour universally would make one of the two skills wrong.

### X6 — Determinism of emitted artifacts

| ID | Rule | Observable | Tier | Sample |
|---|---|---|---|---|
| X6.1 | An emitted artifact MUST contain only content derived from its declared inputs. | The artifact contains no timestamp, random value, or environment-dependent content. | [agent-checkable] | one |

X6.1 is about what an artifact *contains*. It is adjacent to, and distinct from, `P6.6`, which is
about which action a skill selects: a skill can choose its actions deterministically and still
write a generation timestamp into the file it produces, which makes an unchanged input set produce
a changed file.

## Candidates

Behaviours worth governing for which no Observable can be written today. They carry no identifier,
because an identifier implies an obligation.

| Candidate | What it would govern | Why it is not a rule |
|---|---|---|
| **Terminology register** | One term per concept across every skill, drawn from a closed vocabulary | There is no glossary to check a term against. The rule would be undecidable until one exists. |
| **Cost disclosure** | A skill stating the cost of an operation that grows with input size | One skill says anything about cost, and no check can observe a claim about complexity. Requiring it of every skill would produce ceremony rather than information. |
| **Mechanical shape checking for X1.2** | Comparing a skill's Example against the field list its Outputs section declares | Attempted 2026-09-08 and abandoned. The declaration is prose: extracting `highway-help`'s six declared labels returns eight, because two recur later in the section describing a different mode. Telling a declared list from an incidental mention means parsing English, and a check taking the first six would pass here by luck and break on the next skill. X1.2 stays `[agent-checkable]`. |

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

Every amendment records a review against the non-restatement rules of the other two governing
documents, and states which rules rest on a single example.
