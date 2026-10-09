# Phase 0 Research: Conversation Delivery Hardening

**Feature**: 153 | **Date**: 2026-10-09 | **Plan**: [plan.md](./plan.md)

Six items were carried into this phase: three named in the Constitution Check as AT RISK or
DOES NOT DECIDE, and three unknowns in the Technical Context. Each is resolved below. Two of them
were held open for sign-off because they introduce user-visible wording or change a requirement's
standing; both were decided on 2026-10-09 and are recorded as R5 and R7. No open item remains.

## Measured baseline

Taken before any edit, so that later claims are comparisons rather than estimates.

`.highway/skills/highway-profile/SKILL.md`, 2088 words total, **0** MUST-level keywords.

| Section | Words | Note |
|---|---:|---|
| `## Purpose` | 11 | |
| `## Scope` | 25 | |
| `## When to use` | 27 | |
| `## When not to use` | 13 | |
| `## Inputs` | 50 | |
| `## Outputs` | 30 | |
| `## Readiness` | 157 | |
| `#### Domain model` | 143 | |
| `### Acquisition` | 122 | |
| `#### Let's get to know your organization` | 144 | emitted literal |
| `#### Domain completeness` | 210 | |
| `##### Organizational expression` | 77 | |
| `##### Identity` | 54 | emitted literal |
| `##### Vision` | 118 | emitted literal |
| `##### Competitive Path` | 114 | emitted literal |
| `##### Guiding Principles` | 97 | emitted literal |
| `#### Cross-domain reasoning` | 67 | |
| `## Operations` | 183 | |
| `## Verification` | 292 | |
| `## Error Handling` | 55 | |
| `## Example` | 2 | |

`P7.5` aggregates by nearest `##` ancestor, not by leaf heading. Every heading from
`## Readiness` through `#### Cross-domain reasoning` rolls up into one measured section of
**1303 words** — three and a quarter times the 400-word limit.

`rc_check_P7_5` returns 2 (N/A) for this file: it derives its section set from
`bs_normative_lines`, which emits only lines containing `MUST`, `MUST NOT` or `SHOULD`, and this
file contains none. The 1303 is therefore unobserved by any check, before and after this feature.

`.highway/governance/experience-standard.md` is at `11.0.0`, 61 rules, highest X2 identifier
**X2.67**. Retired and not reusable: X1.7, X2.2, X2.27, X2.28, X2.33.

## Implementation baseline

Taken at the start of implementation, after the decisions of 2026-10-09 and before any source
edit. Satisfies T001 through T004 and `D3.1`.

**Suite** (`.highway/tools/tests/run-all.sh`): **exit 0**, **76 passed, 0 failed**, wall clock
**215s**.

A first run of the same suite, before this baseline, returned **exit 1, 74 passed, 2 failed**:
`distribution-packaging.test.sh` reported seven unclassified root paths — the setup assessment and
its six transcripts — and `constitution-inventory.test.sh` failed as a cascade, because its seeded
`D1.2` probe cannot observe `distribution-packaging.test.sh` failing for the seeded reason while
that test already fails for another. Neither failure was caused by this feature. The seven
documents were moved to `specs/153-conversation-delivery-hardening/evidence/`, which the manifest
already excludes via `exclude specs`, and both tests returned to passing. `D3.1` is satisfied from
the 76/0 run, not the 74/2 run.

**`.highway/skills/highway-profile/SKILL.md`**

| Measure | Baseline | Requirement |
|---|---:|---|
| Total words | 2088 | — |
| MUST-level keyword count | **0** | FR-015 requires 0 after the change |
| `## Readiness` roll-up, the `P7.5` section | **1303** | FR-017 records the post-change figure |
| Count of `**What would you add, correct, or remove?**` | **1** | R6 guard requires 1 throughout |

The per-section table is the Measured baseline above; it is not restated here.

## R1 — Where the three exemplars live

**Decision**: a new `#### Contribution in practice` subsection inside `### Acquisition`, placed
after `#### Domain completeness` and before `##### Organizational expression`.

**Rationale**: the assessment's operative conclusion is that the rule creates the obligation and
the exemplar creates the behavior. An exemplar read four hundred words away from the moment it
applies is a reference, not a model. Placing it inside `### Acquisition` keeps it on the reading
path between the completeness criteria and the four domain blocks that use it.

**Alternatives considered**:

- *`## Example`, at the end of the file.* Rejected. It is a specimen section governed by `P9.5`,
  which requires its values to agree with frontmatter; it currently holds two words and is not a
  teaching surface. It also sits after `## Verification`, past the point an agent reads for
  conduct.
- *A shared library artifact cited by the skill.* Rejected. No literal-bearing or exemplar-bearing
  artifact exists under `.highway/library/`; every template there is an output template. Creating
  the category is a larger change than this feature supports, and `D8.1` would widen re-validation
  to every citing skill.

**Cost, recorded rather than hidden**: the measured 1303-word section grows by the exemplars plus
the continuity text. FR-017 requires the post-change figure to be recorded in the completion
report. No check will object, which is exactly why the number is recorded.

## R2 — Where the second shared literal is owned

**Decision**: the Experience Standard, as a new X2 rule that names the literal inline.

**Rationale**: this is the shape the document already uses. `X2.21` names
`Here's what I've captured as your [category]:` inside the rule text, and `X2.49` constrains the
acceptance request's form. A literal owned by the Standard is reusable by any workflow without
any skill restating it, which is what `P7.3` and FR-014 require.

**Alternatives considered**: a new `.highway/library/` artifact (rejected, see R1); skill-local
prose (rejected in clarification).

## R3 — Rule identifiers, splitting, and version increments

Next free identifier is **X2.68**. Allocation:

| ID | Obligation | Requirement |
|---|---|---|
| X2.68 | Contribute one grounded addition when reasoning would materially improve the Working Idea | FR-009 |
| X2.69 | The addition must not exceed one per Substantive Contribution | FR-010 |
| X2.70 | Opening text names accepted substance carried forward | FR-012 |
| X2.71 | Opening text states that nothing is accepted yet when nothing is | FR-012's defined behavior |
| X2.72 | The reaction invitation uses the named literal when nothing has been captured | FR-002 |

**Resolving the `P1.2` and `P1.3` risk.** The rule as drafted in `evidence/setup-assessment.md` §4.2 fails
both: it exceeds 25 words and it joins a condition to two permitted forms. Splitting the bound into
its own rule resolves `P1.2`; moving the two permitted forms and the exclusion list into the
Observable resolves `P1.3`. `P1.4` is satisfied because the Observable carries the enumerated
exclusion set rather than leaving "useful" undefined. Drafts, each counted:

- **X2.68**, 18 words: *An Interactive Workflow MUST contribute one grounded addition when
  non-redundant reasoning would materially improve the relevant Working Idea.*
- **X2.69**, 13 words: *A contributed addition MUST NOT exceed one distinction or extension per
  Substantive Contribution.*
- **X2.70**, 14 words: *Text opening a domain MUST name accepted substance carried forward from
  the preceding domain.*
- **X2.71**, 15 words: *Opening text MUST state that nothing has been accepted yet when no
  accepted substance exists.*

**FR-007 is an Observable amendment, not a new rule.** `X2.56` already requires an amended
candidate to present its change distinguishably, and `X2.55` already requires the accepted text to
survive unchanged. FR-007 asks for the *inline* form to be named, which is a property of the
Observable. Amending an Observable while leaving rule text unchanged is the precedent the document
sets in its own provenance section for `X2.51` and `X2.4`. This keeps the rule count at 65 rather
than 66 and avoids a rule that would overlap `X2.56` — which `P7.3`'s sibling discipline in the
development constitution, `D1.3`, exists to prevent.

**FR-003, FR-004 and FR-006 add no rule.** `X2.36` already owns the narration prohibition; the
defect is Profile's delivery of it, not its absence. The domain-boundary cue and the reassurance
are emitted literals belonging to the skill. Adding Standard rules for them would place
Profile-specific obligations in a document that governs every workflow.

**Version increments**:

- Experience Standard `11.0.0` → `11.1.0`. Five rules added, one Observable amended, no rule text
  changed, no identifier retired. Conforming work stays conforming only because no shipped skill
  currently emits a domain opening that the new rules would fail — this must be verified against
  every citing skill before the rules are enabled, which is `D3.4` and `D8.1` together.
- `highway-profile` `11.0.0` → `11.1.0`. Text is added at new delivery sites; no existing contract
  is removed or redefined, so `P7.7` classifies this as MINOR.
- `highway-setup`: not changed, so no version increment (R5).

## R4 — Test placement and instrument declaration

**Decision**: one new file, `.highway/tools/tests/feature-153-delivery-sites.test.sh`, carrying
every new assertion, with the existing header convention:

```bash
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.
```

**Rationale**: `D3.8` requires each test to declare its instrument class, and every assertion in
this feature is of one class. Declaring `static-document-contract` across a single file makes the
feature's evidence limit legible at the top of the file rather than inferred from twenty
assertions. It is also the honest declaration: none of these assertions executes a workflow.

Existing Profile tests are amended only where R6 forces it.

## R5 — The heading level in `highway-setup` — **resolved 2026-10-09: no change**

`highway-profile` uses two levels, and the setup transition is not a heading at all:

| Element | Level |
|---|---|
| Profile's workflow opening, `Let's get to know your organization` | `####` |
| Profile's four domain blocks | `#####` |
| `highway-setup`'s post-Profile transition, `Let's identify some outcomes worth pursuing.` | emitted as bold text, not a heading |

**Decision**: the heading level is not the cause of the observed confusion at the Profile →
Objectives seam, so nothing in `highway-setup` is changed. FR-005 is withdrawn in the spec, C4 in
the delivery-site contract is emptied, and no assertion is written for it. `highway-setup` is not
touched by this feature and therefore takes no version increment and no regeneration.

**What this leaves open**: the seam's remaining confusion is addressed only by FR-002's scoping of
the validation question. Continuity at the seam was already excluded by the Session 2026-10-09
clarification limiting FR-013 to Profile's own four domains. Whatever else produces the confusion
is not identified here and is left to the conversational evaluation that follows this feature.

## R6 — The Feature 152 count assertion — resolves the `D3.5` risk

`feature-152-profile-conversation-conformance.test.sh` line 159 asserts:

```bash
require_count "$PROFILE" 'Profile skill' '**What would you add, correct, or remove?**' 1
```

This is a whole-file count of exactly **one** occurrence of the emphasized literal. Two of this
feature's requirements point straight at it:

- **FR-011's exemplars** each close on a question that invites contribution. If any exemplar
  reproduces the emphasized literal verbatim, the count becomes 4 and the assertion fails.
- **FR-002's restriction text** must describe when the literal may be used without adding a second
  emphasized instance of it.

**Decision**: no existing assertion is weakened. The exemplars close on questions drawn from their
own domain content — which FR-011 already requires, since a repeated stock question would
demonstrate wording rather than the move. FR-002's restriction is written as a condition referring
to the literal, not as a second emphasized copy of it.

**Consequence**: `D3.5` is not triggered. The risk recorded in the Constitution Check closes as
PASS, and the count-of-one assertion becomes a useful guard on FR-011 rather than an obstacle to
it — if an implementer reaches for the stock question inside an exemplar, the suite says so.

## R7 — The reaction literal — **resolved 2026-10-09: accepted as drafted**

The literal required by X2.72 does not exist yet; this feature invents it. The accepted wording,
consistent with `X2.47` (possibilities distinguished from a recommendation set) and `X2.43` (a
Contribution Opportunity is not a candidate for acceptance):

> **Here's a direction worth considering — what's missing from it?**

It must not be emphasized in a way that competes with the acceptance request, and it must not be
satisfiable by agreement alone, which is the property `X2.49` protects for the acceptance request
and which the assessment found the person valued. Recorded as the binding wording in contract C2.

## R8 — Pre-enablement evaluation of X2.68 through X2.72 (`D3.4`, `D8.1`)

T008. Recorded **before** any rule is added, so that no rule is enabled against a tree whose
verdict is unknown.

**Skills citing the Experience Standard** (`grep -rl 'experience-standard' .highway/skills/`):

| Skill | Verdict against X2.68–X2.72 | Basis |
|---|---|---|
| `highway-profile` | would fail X2.68, X2.70, X2.71, X2.72 today | This feature's delivery sites are exactly what closes them; the failures are intended and are fixed in Phases 3–5 |
| `highway-setup` | no new failure | It cites the Standard but delivers no domain sequence of its own; the continuity rules bind the workflow that owns the domains. Untouched by this feature after R5 |
| `highway-controls` | no new failure | No check evaluates a skill against an individual X rule, so adding a rule changes no verdict for it |
| `highway-nfrs` | no new failure | As above |

**No skill is left quietly failing.** The only skill that would newly fail is `highway-profile`,
and this feature is the change that satisfies it.

**Checks that break on the Standard's growth, and must be amended rather than weakened.**

The first pass of this inventory was **incomplete**, and the full suite found what it missed. It
searched for tests referencing an X identifier or the version string and found two count
assertions. There are **seven**. Five more compare against the same literal `59` but write their
message with `grep -cE` against a variable, so neither search term reached them; each also carries
a stale message naming `49`, a number no longer compared anywhere. Corrected inventory:

| Check | Assertion | Required amendment |
|---|---|---|
| `feature-150-collaborative-convergence.test.sh:139` | X-rule inventory `59` | `60` after X2.72; message read "expected 49" |
| `feature-152-profile-conversation-conformance.test.sh:133` | X-rule inventory `59` | `60` after X2.72 |
| `feature-141-experience-standard-refactor.test.sh:46` | X-rule inventory `59` | `60`; message read "49" |
| `highway-ux-alignment.test.sh:48` | X-rule inventory `59` | `60`; message read "49" |
| `experience-standard-convergence.test.sh:27` | X-rule inventory `59` | `60`; message read "49" |
| `experience-standard-amendment.test.sh:29` | X-rule inventory `59` | `60`; message read "49" |
| `constitution-experience-alignment.test.sh:64` | X-rule inventory `59` | `60`; message read "49" |
| `feature-152-profile-conversation-conformance.test.sh:138` | version `11.0.0` | `11.1.0` at the end of the feature |
| `experience-standard-amendment.test.sh:13` | version `11.0.0` | `11.1.0` at the end of the feature |

The count rises once per phase that adds a rule, ending at **64**. It is raised to the actual
figure as each phase lands, so no phase closes against a knowingly red suite.

**Why the first pass missed them**: the search was for evidence of a dependency, not for the
dependency itself. The reliable query is `grep -rn 'rule inventory' .highway/tools`, which names
every site regardless of how it spells the comparison. Six of the seven messages were already
wrong before this feature touched them, which is why a stale message is worth correcting rather
than preserving: a message naming a number nothing compares against cannot tell a later reader
what failed.

**`D3.5` reading**: raising a declared total from 59 to 64 and a declared version from `11.0.0` to
`11.1.0` keeps each assertion exact. Neither loosens a bound, removes a case, or admits an input
that previously failed. These are amendments under `D3.3`, not weakenings, and the reason is
recorded here. No existing assertion is deleted or relaxed by this feature.

**Checks confirmed not to be affected**: no coverage or alignment check requires every Interactive
Workflow to deliver every X rule, so adding five rules creates no per-skill coverage obligation.
`constitution-inventory.test.sh` passes with the new test file present and requires no registration
row for it.

## Observed failures before implementation (`D3.6`)

Each assertion is recorded here as it was seen failing, before the text satisfying it was written.
A failure not observed first is not evidence the assertion decides anything.

### Phase 3, User Story 1 — `bash .highway/tools/tests/feature-153-delivery-sites.test.sh`, exit 1

```text
FAIL: Experience Standard missing: | X2.72 |
FAIL: Experience Standard missing: An invitation to react where nothing has been captured MUST use the heading "Here's a direction worth considering — what's missing from it?".
FAIL: Profile skill missing sentence: A domain's substance is kept only after its finished candidate has been presented and accepted.
FAIL: Profile skill expected 4 occurrences of 'before that candidate is presented and accepted.' but found 0
FAIL: Profile skill missing sentence: Retain nothing from Identity before that candidate is presented and accepted.
FAIL: Profile skill missing sentence: Retain nothing from Vision before that candidate is presented and accepted.
FAIL: Profile skill missing sentence: Retain nothing from Competitive Path before that candidate is presented and accepted.
FAIL: Profile skill missing sentence: Retain nothing from Guiding Principles before that candidate is presented and accepted.
FAIL: Profile skill missing sentence: The validation question applies only where a candidate has been presented.
FAIL: Profile skill missing: **Here's a direction worth considering — what's missing from it?**
FAIL: Profile skill missing: - No domain substance is retained before that domain's candidate has been presented.
```

Eleven assertions, all failing for absence rather than for a defect in the check itself. The
count assertion reporting `found 0` is the one that matters most: it is what stops four domain
sites collapsing into one central sentence.

### Phase 4, User Story 2 — `bash .highway/tools/tests/feature-153-delivery-sites.test.sh`, exit 1

```text
FAIL: Experience Standard missing: | X2.70 |
FAIL: Experience Standard missing: | X2.71 |
FAIL: Experience Standard missing: Text opening a domain MUST name accepted substance carried forward from the preceding domain.
FAIL: Experience Standard missing: Opening text MUST state that nothing has been accepted yet when no accepted substance exists.
FAIL: Profile skill expected 3 occurrences of 'in the person's own words and connecting it to the question being asked.' but found 0
FAIL: Profile skill missing sentence: Open it by naming accepted Identity substance in the person's own words and connecting it to the question being asked.
FAIL: Profile skill missing sentence: Open it by naming accepted Vision substance in the person's own words and connecting it to the question being asked.
FAIL: Profile skill missing sentence: Open it by naming accepted Competitive Path substance in the person's own words and connecting it to the question being asked.
FAIL: Profile skill missing sentence: Where the preceding domain produced no accepted substance, say that nothing has been accepted yet rather than inventing a carry-forward.
FAIL: Profile skill missing sentence: Say nothing about retaining the answer, about where this sits in the sequence, about a domain's state, or about what comes next.
FAIL: Profile skill missing: - Each domain opening names accepted substance from the preceding domain.
```

Eleven assertions, all failing for absence.

**What the count-of-three assertion can and cannot decide.** FR-013 says a generic transition
naming no accepted substance does not satisfy it. No string match can read a sentence and judge it
generic. What the assertion does instead is require each of the three handoffs to name the
*preceding domain by name* — Identity into Vision, Vision into Competitive Path, Competitive Path
into Guiding Principles — which a generic sentence cannot do and which one shared sentence cannot
do three times. That is a proxy, and it is the strongest one available to a document contract.
Whether the agent then names real accepted substance rather than the domain's label is a
conversational property, and this feature does not establish it.

### Phase 5, User Story 3 — `bash .highway/tools/tests/feature-153-delivery-sites.test.sh`, exit 1

```text
FAIL: Experience Standard missing: | X2.68 |
FAIL: Experience Standard has no row for X2.68
FAIL: Experience Standard missing: | X2.69 |
FAIL: Experience Standard has no row for X2.69
FAIL: Experience Standard missing: An Interactive Workflow MUST contribute one grounded addition when non-redundant reasoning would materially improve the relevant Working Idea.
FAIL: Experience Standard missing: A contributed addition MUST NOT exceed one distinction or extension per Substantive Contribution.
FAIL: Experience Standard missing sentence: optional detail, repetition, unsupported speculation, manufactured alternatives, ceremony, or low-value addition does not satisfy it
FAIL: Profile skill missing: #### Contribution in practice
FAIL: Profile skill expected 3 occurrences of 'What the workflow adds:' but found 0
FAIL: Profile skill missing: **Which of those two would you be judged on?**
FAIL: Profile skill missing: **Does that read as the thing you're building, or as one strand of it?**
FAIL: Profile skill missing: **What would have to be true for you to break it?**
FAIL: Profile skill missing: - Contribution in practice carries three worked exemplars, each adding one thing.
```

**Correction to the task text.** T033 says X2.69's Observable carries the exclusion list. Contract
C1 puts it on **X2.68's** Observable, which is where it belongs: the exclusion list says what does
not count as a contribution, and X2.68 is the rule that requires one. X2.69 bounds the count. The
contract is authoritative and the assertion follows it.

**What `require_rule_shape` adds.** `P1.1` and `P1.3` are runtime-constitution rules that
`rc_check_P7_5`'s sibling checks do not evaluate for the Standard itself. Asserting one keyword and
a 25-word ceiling per added rule inside this feature's own test is the only thing making the drafted
word counts in contract C1 a contract rather than a note. Measured: X2.68 is 18 words, X2.69 is 13.

### Phases 6 and 7, User Stories 4 and 5 — same test, exit 1

```text
FAIL: Profile skill missing sentence: **That's the approach rather than the destination — it belongs to Competitive Path, so let's hold it there.**
FAIL: Profile skill missing sentence: "I don't know" is a complete answer to any of it.
FAIL: Experience Standard missing sentence: the change is marked inline, within the candidate
FAIL: Agent grounding source missing sentence: Read `.highway/governance/experience-standard.md` before producing any user-visible output
FAIL: Agent grounding source still contains: - Consult `.highway/governance/experience-standard.md` for applicable user-visible
```

The last of these is an absence assertion, and it fails in the direction that matters: the
"Consult" phrasing FR-008 replaces is present, so removing it is observable rather than assumed.

**A matcher defect found by these assertions, not by review.** Two of the three exemplar questions
in Phase 5 were first written with `require_text`, which matches the raw file. Markdown line
wrapping split both sentences, so both failed while the text was present and correct. The flowed
matcher exists for exactly this and the three question assertions now use it. The lesson is narrow
and worth keeping: in this repository, any assertion over a sentence longer than roughly eighty
characters must use `require_flowed`, because the source is hard-wrapped.

## Closing measurements (Phase 8)

**Suite.** `.highway/tools/tests/run-all.sh` exits 0 with **77 passed, 0 failed, 231s**. The T001
baseline was 76 passed, 0 failed, 215s. The delta is one file — the new
`feature-153-delivery-sites.test.sh` — and 16s.

**Version assertions were broader than the plan assumed.** Raising the Standard to `11.1.0` and the
Profile skill's `metadata.version` to `11.1.0` broke ten further assertions in eight test files that
pin those literals: `feature-092-contract`, `feature-136`, `feature-137`, `feature-138`,
`feature-140`, `profile-behavior`, `profile-runtime-separation` and `profile-structure` pin
`version: 11.0.0` against the Profile skill, and `feature-141` and `experience-standard-amendment`
pin the Standard's full provenance line including `**Last Amended**: 2026-10-08`. All ten were
updated. `nfr-management.test.sh` also contains `version: 11.0.0`, but it pins the `highway-nfrs`
skill, which this feature does not change; it was correctly left alone. The reliable query is
`grep -rn '11\.0\.0' .highway/tools/tests`, run *after* a version bump rather than before it — the
suite finds these faster than an inventory does.

**Rule inventory.** 64 X-rule rows. The seven inventory assertions were raised from 62 to 64.

**FR-015, keyword count.** `.highway/skills/highway-profile/SKILL.md` contains **0** MUST-, SHOULD-
or SHALL-level keywords after all six edits. Unchanged from baseline.

**FR-014, restatement audit (`P7.3`).** No file under `.highway/skills/` contains the rule sentence
of X2.68, X2.69, X2.70, X2.71 or X2.72. The Profile skill names the X2.72 heading literal, which is
the literal the rule governs rather than the rule's own sentence, and it does so without a keyword.

**FR-017, section size.** Per-section word counts of the Profile skill after this feature:

| Section | Words |
| --- | --- |
| `## Purpose` | 11 |
| `## Scope` | 25 |
| `## When to use` | 27 |
| `## When not to use` | 13 |
| `## Inputs` | 50 |
| `## Outputs` | 30 |
| `## Readiness` | 1915 |
| `## Operations` | 183 |
| `## Verification` | 328 |
| `## Error Handling` | 55 |
| `## Example` | 2 |

The `## Readiness` roll-up moved from **1303** to **1915** words, an increase of 612, most of it the
`#### Contribution in practice` exemplars. The `P7.5` 400-word limit is stated for *normative*
sections, and `rc_check_P7_5` returns N/A for this file because it contains no normative lines. **No
check decides this number.** It is recorded so the growth is visible and arguable, not because
anything in the suite constrains it.

**`D1.1`.** No `specs/` or `.specify/` reference appears in any of the three changed source
documents, including the three new exemplars.

**`D4.1`/`D4.5`-`D4.7`.** All four generators were run after the source edits. `.github/`, `.claude/`,
`.cursor/`, `.agents/` and `AGENTS.md` are updated by generation only; none was hand-edited.
