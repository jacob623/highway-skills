# Research: Profile Conversation Conformance

Phase 0 output. Each entry records a decision, why it was taken, and what was rejected.

---

## D1 — What "point-of-use text" is allowed to be

**Decision**: Point-of-use text is restricted to two forms: (a) a **literal the skill emits**, and
(b) a **procedure the skill itself owns**. It is never a restatement of an obligation held in the
Experience Standard.

**Rationale**: P7.3 prohibits a skill from restating a requirement owned outside it, and its
observable directs skills to *name* the Experience Standard instead. The Profile skill contains
zero MUST statements; the house style is declarative instruction, not normative rules. A naive
reading of FR-002 — copy the rule into the skill — would put this feature in direct breach of the
rule set it is trying to strengthen.

The restriction is also what the evidence actually supports. The structural observation from the
assessment was:

| Rule | Present in Profile SKILL.md | Outcome over six runs |
|---|---|---|
| X2.49 validation question | Yes, four times | Held 6/6 |
| X2.21 capture heading | No | Violated across all four domains by one agent |
| X2.51 no re-review | No | Violated by one agent in both runs |
| X2.53 no unadopted terms | No | Violated by one agent |

X2.49 did not hold because the skill restated the obligation. It held because the skill carried the
**exact question string the agent had to type**. There was nothing left to interpret. That is the
mechanism, and it generalizes only to literals and local procedure.

A corroborating check run during planning: `highway-controls`, `highway-nfrs`, and
`highway-objectives` all carry the `Here's what I've captured as your ...` literal at their capture
step. `highway-profile` is the only skill that does not — and it is the only one observed violating
X2.21. The correlation holds outside the Profile transcripts.

**Consequence for the thirteen behaviors**: they do not all receive the same treatment. Each is
classified in `contracts/rule-inventory.md` as one of:

- **Literal** — the skill gains an emitted string. Strongest guarantee.
- **Procedure** — the skill gains a step it owns (how readiness is obtained, which artifact is read).
- **Rule-only** — the obligation is genuinely not reducible to either; it stays in the standard with
  a decision procedure in the Observable, per FR-005.

Rule-only items are the weakest leg and must be acknowledged as such rather than counted as equally
enforced.

**Alternatives rejected**:
- *Restate each rule inside the skill* — breaches P7.3, and inflates sections against P7.5.
- *Add MUST rules to the skill* — breaches the skill's own style and pushes toward the P7.4 ceiling
  from a current count of zero.
- *Standard-only, as Feature 150 did* — this is the approach whose failure produced the feature.

---

## D2 — Managing the P7.5 word budget

**Decision**: Define each repeated literal **once**, under `#### Domain completeness`, and have the
four domain subsections reference it by name. Measure every touched section's word count before and
after.

**Rationale**: FR-014 already requires one definition of the validation question rather than four
copies. Extending that to the capture heading and the acceptance request keeps the four domain
subsections nearly flat in size while still giving each one a resolvable point of use. Without this,
four domains × three literals is the fastest route to a P7.5 breach.

**Tension acknowledged**: single-definition-plus-reference is weaker than four verbatim copies, and
D1 argues verbatim literals are what made X2.49 hold. The mitigation is the test, not the document:
SC-002 counts point-of-use sites and SC-004 requires removal of any single site to fail by name. A
reference that is tested per-site is still a per-site obligation.

**Alternatives rejected**:
- *Four verbatim copies of every literal* — likely P7.5 breach in `#### Domain completeness` and
  clear duplication the spec explicitly ruled out in FR-014.
- *Split the domain subsections into a new section* — restructures a document eight other tests
  assert against, for no behavioral gain.

---

## D3 — Which behaviors need a new rule and which reuse an existing one

**Decision**: Six of the thirteen reuse an existing rule and need only point-of-use work. Seven need
new rules or an amendment.

**Reuse, point-of-use only**:

| Behavior | Existing rule | Why no new rule |
|---|---|---|
| Capture heading | X2.21 | The rule is correct and specific. Only the literal was missing. |
| Narration of internals | X2.36 | The rule is correct. Profile adds which of *its own* internal vocabulary must not surface. |
| Validation question wording | X2.49 | Already held. Only the string changes, per FR-013. |
| Vision boundary | — | Domain meaning is Profile-owned. Competitive Path already carries a negative clause; Vision does not. Pure skill edit. |
| Cross-domain preservation | — | Relocated from Profile's `## Verification` into the domain instructions per FR-028. Profile-owned. |
| Readiness and persistence operations | — | FR-024 through FR-026 are entirely Profile-owned procedure. |

**New or amended rules** (exact rows in `contracts/rule-inventory.md`): the acceptance floor, the
re-presentation ceiling, recognition of acceptance by meaning rather than phrase, rejected
vocabulary including synonyms, form preservation under amendment, the unlocatable-amendment fallback,
acknowledgment substance, and emphasis.

**Rationale**: adding a rule where one already exists would create two rules for one obligation, and
it would repeat the Feature 150 error of treating rule text as the lever. The gap for those six was
never the rule.

---

## D4 — Two live X2.49 violations found outside the Profile skill

**Finding**: `highway-controls` and `highway-nfrs` still emit closed acceptance questions —
`Would you like to accept this Control?` and `Would you like to accept this NFR?`. Both are
answerable by bare agreement, which is the precise shape X2.49 exists to prevent. Feature 150
corrected only the Profile skill. `highway-objectives` was checked and is clean.

**Decision**: **Out of scope.** This feature modifies `highway-profile` and nothing else. The finding
is recorded here as a handoff to a separate spec covering the remaining skills.

**Rationale**: the user scoped this feature to Profile explicitly and will address other skills in
their own spec. That keeps the change set to one skill, one standard, and their tests, which also
means the evidence base and the blast radius match: all six recorded transcripts are Profile
conversations, and nothing here was observed in a Controls or NFR conversation.

The cost is that a located violation of an existing rule stays open for now. That is a timing
choice, not a dismissal — the finding is specific, reproducible by `grep`, and carries its own
replacement wording below.

**Handoff detail for the follow-up spec**:

| Skill | Current | Candidate replacement |
|---|---|---|
| `highway-controls` | `**Would you like to accept this Control?**` | `**What would you add, correct, or remove?**` |
| `highway-nfrs` | `**Would you like to accept this NFR?**` | `**What would you add, correct, or remove?**` |

**Scope guard**: task T068 asserts mechanically that no skill other than `highway-profile` was
modified, so this boundary cannot erode during implementation.

---

## D5 — Emphasis has no rule anywhere

**Finding**: Neither the Experience Standard nor any skill contains a rule about bold or emphasis.
The Profile validation questions carry `**` markers only as part of the literal string.

**Decision**: Add an emphasis rule to the standard, and keep the markers inside every literal in
`contracts/profile-wording.md`.

**Rationale**: formatting carried only inside a quoted string is the first thing an agent normalizes
away. One observed run dropped the markers; another inverted which part was emphasized. Neither was
a rule violation, because there was no rule.

---

## D6 — Reconciling the sharpening obligation with X2.4

**Decision**: Amend X2.4's **Observable** rather than add a rule that competes with it.

**Rationale**: the spec's Assumptions record an unratified position — that the FR-020 sharpening
obligation governs during domain composition while X2.4 governs elsewhere. Two rules pointing in
opposite directions at the same moment is the condition under which an agent picks the cheaper one,
and X2.4 is the cheaper one. It is also the rule that produced the shallowest observed run.

Amending the Observable states that a material ambiguity in the person's own contribution *is*
consequential, result-changing uncertainty. This is a clarification of X2.4's existing meaning, not
a carve-out from it, and it leaves exactly one rule governing the moment.

**Alternatives rejected**:
- *Add a competing rule scoped to composition* — produces the conflict described above.
- *Leave the tension unresolved* — the clarify report flagged this as a planning decision; deferring
  it again only moves it to implementation, where it would be settled by whoever writes the line.

---

## D7 — Version and counter updates

**Decision**: Experience Standard `10.0.0` → `11.0.0`. Profile `10.0.0` → `11.0.0`. `highway-controls`
and `highway-nfrs` take MINOR bumps — their emitted wording changes but no rule they own is redefined.

New rule identifiers start at **X2.58**. Retired identifiers X1.7, X2.2, X2.27, X2.28, and X2.33 are
never reused.

**Mechanical updates required** (exact sites inventoried, to be enumerated as tasks):
- Experience Standard version string at line 3 and in the provenance footer.
- Rule-count assertion `-ne 49` at five test sites, updated to the new total.
- Profile `version: 10.0.0` at eight test sites.
- Provenance paragraph in the footer, naming every element this amendment changes, per D5.3.

**Rationale**: MAJOR on both documents because rules are redefined and superseded strings are removed
outright rather than deprecated, per FR-030. There is no backward-compatibility obligation; the user
confirmed the repository is pre-release.

---

## D8 — Test design

**Decision**: One new file, `feature-152-profile-conversation-conformance.test.sh`, declaring
`static-document-contract` with artifact classes `source-document` and `generated-artifact`, and
implementing the `--probe` / `--neutralise` contract required by D3.7.

For each behavior the test asserts three things: the rule row in the standard, the gate bullet in the
skill's `## Verification` section, and the point-of-use text at every applicable site — with the site
count asserted, so that deleting one site fails rather than silently passing on the remaining three.

**Rationale**: SC-004 requires removal of the rule row, the gate, or any single point-of-use site to
fail the test by name. A `require_text` call per site satisfies the last clause only if the count is
also asserted; otherwise a reference-based implementation could collapse four sites into one and
still pass. This is the specific failure mode D2's single-definition decision introduces, so the
count assertion is load-bearing rather than defensive.

**Explicitly not claimed**: none of this is evidence that any behavior occurs in conversation. D3.8
forbids recording it as such, and the spec's Evidence boundary says so in the artifact itself.
