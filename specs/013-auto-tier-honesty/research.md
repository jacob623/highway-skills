# Phase 0 Research: Auto-Tier Honesty

**Feature**: `013-auto-tier-honesty` | **Date**: 2026-09-08

---

## R0. This feature is a prior decision arriving late

Before deciding anything, the repository was searched for prior analysis of the two rules. There
is some, and it is still open.

Feature 003 (constitution enforcement) split its work into two groups. Group A shipped. Group B
was two tasks, both still unchecked in `specs/003-constitution-enforcement/tasks.md`:

| Task | Text | State |
|---|---|---|
| T046 | Implement the `P6.4` check once amendment 2.0.2 defines the prohibited time, randomness, and preference token list in the constitution | Open |
| T047 | Confirm rule `P2.3` reports as deferred once amendment 2.0.2 retags it as judgment-requiring | Open |

Its `data-model.md` records `P6.4 | Skill contains no token from the time/randomness/preference
list | Blocked on 2.0.2`.

**Amendment 2.0.2 never happened.** The constitution went `2.0.1 → 2.1.0` during feature 011,
skipping the planned intermediate. The two rules have been stranded since.

Three consequences:

1. **The design questions were already answered**, and the answers converge with an independent
   reading: retag P2.3, give P6.4 a token-list-backed check. This plan adopts them rather than
   re-deciding.
2. **Feature 003 is not a completed spec** under the development constitution's definition, which
   requires all tasks marked complete. D5.1 therefore does not forbid editing it — but D5.2 says a
   correction ships as a new spec, and this is that spec. Feature 003 is left untouched.
3. **D5.3 applies**: this feature supersedes T046 and T047 and must name them, which R4 does.

---

## R1. P6.4 — implement a check, backed by a declared token list

**Decision**: Add a token list section to the constitution enumerating the prohibited time,
randomness, and preference vocabulary, then implement `rc_check_P6_4` reading it via the existing
`con_token_list()`. Scope the check to the sections that constitute decision criteria: `When to
use` and `When not to use`.

**Rationale**: This is feature 003's recorded design, and the mechanism it depends on already
exists and is proven. `con_token_list(file, heading)` is generic, and the constitution already
carries a `### Prohibited Vagueness List` in exactly the shape it reads — a heading followed by a
blockquote. Adding a second list introduces no new technique.

The scoping question — what is a "decision criterion" — has a structural answer rather than a
semantic one. Skills carry eight required sections, two of which exist solely to state when the
skill applies. A criterion lives there. This avoids the check having to recognise a criterion by
meaning.

**On "agent preference" being judgement**: it is, in general. But the rule does not prohibit
preferences; it prohibits a criterion *referencing* one, and the vocabulary that does so is small
and closed — `prefer`, `preferred`, `idiomatic`, `cleaner`, `nicer`, and similar. Declaring that
list in the constitution makes the boundary reviewable and amendable rather than buried in a
script. That is the same reasoning that produced the vagueness list.

**Alternatives considered**:

- *Retag P6.4 as judgement-requiring.* This was the initial lean before feature 003's record was
  found. Rejected: it discards a workable design for a rule two-thirds of which is plainly
  tokenizable, and the remaining third is tokenizable too once the list is written down.
- *Hard-code the token list in the check.* Rejected: it puts a normative boundary in a script,
  where no reader of the constitution can see it, and where amending it is not an amendment.
- *Split P6.4 into a mechanical rule and a judgement rule.* Rejected: retiring and redefining a
  rule id is a MAJOR amendment, which is a large price for a distinction the token list removes.

---

## R2. P2.3 — retag as judgement-requiring

**Decision**: Retag P2.3 from `[auto]` to `[agent-checkable]`. Its Observable and rule text are
unchanged.

**Rationale**: The rule requires a technology-specific example to be labelled "Illustrative".
Checking for the literal word is trivial. Deciding whether a passage *is* a technology-specific
example is the whole difficulty, and it is semantic. A check that assumes that judgement is
already made would produce confident wrong answers on every skill whose example is generic.

This matches feature 003's T047, which anticipated the retag in those terms.

**Alternatives considered**:

- *Treat a fenced code block with a language tag as technology-specific.* This is a real
  mechanical proxy and was seriously considered. Rejected because it under-detects: a
  technology-specific example written as inline prose, or in an untagged fence, would pass. A
  check that silently misses cases while the tier claims full automation is a subtler version of
  the dishonesty this feature exists to remove.
- *Leave it tagged `[auto]` and accept the empty promise.* Rejected: that is the defect.

---

## R3. Version classification — MINOR, `2.1.0 → 2.2.0`

**Decision**: MINOR.

**Rationale**: Classified against the policy's text, not by analogy. The Constitution Versioning
Policy reads:

- **MAJOR**: a principle or governance rule is removed or redefined, or an obligation is
  strengthened so that a previously conforming artifact now fails.
- **MINOR**: a principle, section, or rule is added without invalidating a conforming artifact.
- **PATCH**: wording or typo repair with no change to any Observable.

This amendment does two things. The P2.3 retag alone would be neither MAJOR (nothing removed,
redefined, or strengthened) nor MINOR (nothing added), leaving PATCH by elimination. But the P6.4
work **adds a section** — the token list — which MINOR names explicitly. The higher classification
governs, so the amendment is MINOR.

No obligation is strengthened. P6.4's rule text is unchanged; only its enforcement becomes real.
A skill that violated P6.4 was always violating it — it simply was not told.

**A gap worth recording**: the policy does not name a tier change. Retagging alters how a rule is
decided without altering the rule, and none of the three clauses describes that cleanly. It fell
to PATCH here only by elimination, and only before MINOR took precedence for another reason. A
later PATCH amendment naming tier changes explicitly would close this. Not blocking, and
deliberately not bundled into this feature.

---

## R4. Superseding feature 003's open tasks

**Decision**: Record in this feature's spec record that T046 and T047 of feature 003 are
superseded, naming both. Do not edit `specs/003-constitution-enforcement/`.

**Rationale**: D5.2 requires a correction to ship as a new spec; D5.3 requires a superseding
document to name every element it changes. Editing feature 003's tasks to mark them complete would
make its record claim it did work it did not do.

**Alternatives considered**:

- *Mark T046 and T047 complete in feature 003.* Rejected: it rewrites history, and D5.1's
  definition of a completed spec exists precisely to prevent a directory being tidied into
  looking finished.

---

## R5. Where the anti-regression guard belongs — and what it must not imply

**Decision**: Extend `.highway/tools/tests/constitution-inventory.test.sh` with an assertion that
the set of rules tagged `[auto]` minus the set of registered checks is empty, **scoped explicitly
to the Highway Skills Constitution**, with the scope stated in the failure message and in a
comment.

**Rationale**: FR-015 and SC-008 require a regression to fail the suite. The comparison is a set
difference between two existing accessors — `con_rule_ids_by_tier <file> auto` and
`rc_registered_ids` — so no new mechanism is needed.

The inventory test is the right home: it already asserts that what the constitution says about
itself is true, including per-tier rule counts. "Every rule claiming automation has one" is the
same class of assertion.

**The scoping is the important part.** The development constitution has the identical defect — ten
`D` rules tagged `[auto]`, only three `D` ids appearing anywhere in the toolchain, and those are
comment citations rather than checks. A guard that silently reads only `con_file()` would report
all-clear while half the problem stood, which is a more dangerous state than no guard at all: it
converts an open gap into an apparently closed one.

So the guard names its scope. A reader who sees it pass learns that the *Skills* Constitution is
honest, not that governance in general is.

**Alternatives considered**:

- *Parameterise the guard over both constitutions.* Rejected for this feature, not on principle.
  It is cheap — `con_rule_ids_by_tier` already takes a file argument — but the development
  constitution would fail immediately, pulling seven or more unenforced `D` rules into a feature
  scoped to two `P` rules. The `D` side also has no comparable enforcement surface: no validator
  runs against a `tasks.md`, so its rules need a different mechanism rather than a registry row.
  Assigned to Phase 4b of the governance plan.
- *Put it in `rule-checks.test.sh`.* Rejected: that file tests check behaviour, and would have to
  reach for the constitution to do this.
- *Rely on the `UNCHECKED` group being visibly empty.* Rejected: that is the situation today. It
  has been visible in every validator run for months and was still reported as fourteen rules.

---

## R6. Fixture pre-evaluation before enabling the P6.4 check

**Decision**: Before registering `P6.4`, run its logic against all eight fixtures and both real
skills, record the expected verdict for each, and only then wire it into the registry.

**Rationale**: D3.4 requires it, and FR-008 restates it. The specific hazard is a fixture built to
produce exactly one failure beginning to produce two, which `assert_single_failure` would catch
only as a confusing failure elsewhere. This nearly shipped during feature 009 and did ship
briefly during 011, where a check passed its own tests without ever being dispatched.

The dispatch trap deserves naming: `rc_registry()` is a heredoc indented with **two tabs**. An
edit using three tabs appears to succeed, leaves the suite green, and silently fails to register
the check. Verify with `rc_check_fn P6.4` directly rather than inferring from a passing suite.

---

## R7. Library exemption

**Decision**: Add `P6.4` to `rc_library_exempt_ids`.

**Rationale**: FR-011. `validate-library.sh` shares the rule registry, so an unconditionally
registered rule is applied to library files too. P6.4 governs a skill's decision criteria, and
scopes to `When to use` and `When not to use` — sections a library file has no reason to carry.
Without the exemption, library files would be judged against a rule written for skills. Feature
011 hit this exact problem with P8.7 and established the mechanism.

An N/A condition keyed on section absence would also work, but would report P6.4 as N/A for every
library file, implying the rule was considered and found inapplicable case by case. The exemption
states once that it does not apply.
