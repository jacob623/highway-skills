<!--
Sync Impact Report
Version change: 1.1.0 → 1.2.0 (MINOR), 2026-09-09

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

A bare "Are you sure?" does not satisfy X2.1: the reader cannot decide from it. Naming the loss is
what makes the confirmation a decision rather than a formality.

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
