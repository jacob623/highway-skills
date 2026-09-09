# Research: Highway Experience Standard

**Feature**: 017-experience-standard | **Date**: 2026-09-08

Four questions were open after the spec. The first is the one that shapes the whole document.

---

## R1 — Where is the boundary between a `P` rule and an `X` rule?

**Decision**: `P` constrains what a `SKILL.md` **declares**. `X` constrains **the form of what the
skill emits** when it runs. Where both could touch a topic, `P` owns the obligation to have a
behaviour and `X` owns what that behaviour must look like.

**Why this needed settling first.** Verified 2026-09-08 that several `P` rules already occupy
territory a naive `X` draft would have re-occupied. The closest is not close — it is nearly exact:

| `P` rule | Text | The `X` rule it would have collided with |
|---|---|---|
| `P1.7` | *"A skill MUST require clarification when a declared input is absent or self-contradictory."* Observable: the Error Handling section names this condition and directs escalation. | "A skill MUST ask rather than guess when the intended action is not decidable." **This is P1.7.** Drafting it would violate `D1.4`. |
| `P5.2` | *"Every failure condition MUST name exactly one next action from: retry, abort, escalate, fall back."* | "A skill MUST abort rather than proceed on an ambiguous instruction." Also already owned. |
| `P4.6` | *"A skill MUST require the agent to report a suspected vulnerability rather than altering it silently."* | Any "report rather than silently act" rule. |

The rescue is the routing test in the governance plan: *"Something a Highway skill produces or
displays when a user runs it → Layer 2."* `P1.7` requires that a skill **ask**. It says nothing
about what the asking must contain. `highway-inquiry` goes further than `P1.7` requires — it
aborts *"naming every candidate question"* — and that surplus is Layer 2 material.

So the admissible `X` rule is not "ask when ambiguous" but "when you ask, name the candidates".
The same split applies throughout: `P` requires the behaviour to exist, `X` constrains its shape.

**Alternatives rejected**:

- *Draft the X rules first and check for collisions after.* This is how a restatement gets shipped.
  Both documents ship, so a duplicated obligation would be visible to users and would drift.
- *Widen the P rules instead.* That would move runtime concerns into Layer 1 and dissolve the
  layer this phase exists to create.

---

## R2 — Which rules can be admitted today, and which are only candidates?

**Decision**: admit rules only where the Observable can be applied by hand against the two existing
skills right now. Everything else is recorded as a candidate.

Derived from what the skills actually do, not from the seed families:

| Family | Admissible today | Evidence in the skills |
|---|---|---|
| **X1 Output structure** | Yes | `highway-help` declares six labelled fields in a fixed order; `highway-inquiry` declares a preserved file shape. Both declare a shape in Outputs. |
| **X2 Interaction** | Yes, narrowly | `highway-inquiry` confirms before discarding and states *how many* questions are lost — it explicitly rejects "Are you sure?" as insufficient. |
| **X3 Terminology** | **No** | A terminology rule needs a term list to check against. No glossary exists. Candidate. |
| **X4 Artifact placement** | Yes | `highway-inquiry` declares the exact path it writes; `highway-help` declares that it writes nothing. |
| **X5 Provenance** | Yes, narrowly | Both name the artifact they read. `highway-inquiry` requires naming the existing question rather than reporting a duplicate abstractly. |
| **X6 Determinism** | Yes | `highway-inquiry`: *"No timestamp is written, so an unchanged question set produces an unchanged file."* |

**Cost disclosure is a candidate, not a rule.** `highway-help` declares its listing cost as `O(n)`.
One skill says something about cost, no check can observe it, and requiring it of a skill that
writes a file would be meaningless. Recorded, not admitted.

---

## R3 — How should the error-reporting disagreement be resolved?

**Decision**: state the rule as an obligation about **who the message serves**, not about which
mechanism to use. Neither existing skill becomes wrong.

**The disagreement is deliberate and documented.** `highway-help` aborts and prints an exact
string, and explicitly refuses to fall back to its other mode. `highway-inquiry` repairs
framework-owned parts silently, and says why in its own text:

> A repaired file is rewritten without reporting a rule identifier. Those parts are not written by
> the user, so an identifier names nothing they can act on. [...] Loud about their content, quiet
> about the framework's.

A rule mandating "always print the rule id" makes `highway-inquiry` wrong. A rule mandating "never
print a rule id" makes `highway-help` wrong. The rule both satisfy is that a message must name
something **its reader can act on** — which is the principle `highway-inquiry` already articulates
and `highway-help` already follows, since its reader *can* act on a bad skill id.

**This is the most valuable rule in the standard**, because it is the only one derived from a
disagreement rather than from agreement. Two skills agreeing may mean one author's habit; two
skills differing with a stated reason is a real distinction.

---

## R4 — What tier should the rules carry?

**Decision**: all `[agent-checkable]` at first, except where an Observable is decidable against the
`SKILL.md` text today. No rule is tagged `[auto]` in this phase.

**Rationale**: Phase 6 builds the enforcement. Tagging a rule `[auto]` before a check exists is
precisely the defect features 013 and 014 spent two features removing — ten `D` rules and two `P`
rules carried `[auto]` while nothing decided them. A brand-new document is the easiest place to
reintroduce it, because there is no inventory yet to contradict the claim.

The standard must also state what each tier obliges **in this document**, because `[auto]` already
means two different things: in the Skills Constitution it requires a registered check reporting
under the rule id; in the Development Constitution it requires a named test in the Enforcement Map.
For Layer 2 the meaning will be settled by Phase 6, and the standard should say that plainly rather
than borrow a meaning by analogy — the same error feature 014 found and corrected.

---

## R5 — What does editing both skills cost?

**Decision**: PATCH for each skill. Adding a citation changes no behaviour, no contract, and no
declared output.

**Verified 2026-09-08**:

- Adding a representative `X` citation line to `highway-inquiry`'s Outputs and running the
  validator returned `OK: skill 'highway-inquiry' is valid (13 rules checked, 35 deferred, 0
  unchecked)`. So `P7.5`'s 400-word cap on a normative section is not breached. An earlier naive
  word count suggested 427 words and was wrong: `rc_check_P7_5` counts only normative sections and
  delimits them differently.
- `P7.7` governs the MAJOR case and is not triggered — no skill contract changes.

**This feature is the first governed by `D4.7`.** Editing either `SKILL.md` changes a generator's
input, so the catalog and all three adapters per skill must be regenerated in the same change.
Feature 016 made that an enforced obligation rather than a remembered one, and
`adapter-coverage.test.sh` will fail the suite if it is skipped.

**Namespace confirmed free**: no `X`-namespace rule id appears anywhere under `.highway/` as of
2026-09-08.
