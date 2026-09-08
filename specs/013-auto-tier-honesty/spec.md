# Feature Specification: Auto-Tier Honesty

**Feature Branch**: `013-auto-tier-honesty`
**Created**: 2026-09-08
**Status**: Draft
**Input**: "I want the Highway Skills Constitution's [auto] tier to be honest: fourteen rules are
tagged [auto] but are not enforced by any script... Extend validate-skill.sh and the rule-check
library so that every rule tagged [auto] is actually checked automatically... Any rule that cannot
be given a mechanical check must be retagged to [agent-checkable]... Remove
TODO(AUTO_TIER_ENFORCEMENT) from the Sync Impact Report once the tier is honest."

## Correction to the premise *(verified 2026-09-08)*

The description states that fourteen rules are tagged `[auto]` without enforcement. **The actual
number is two.** The validator already reports this itself, in the coverage summary it prints for
every skill:

```text
UNCHECKED: P2.3 P6.4
```

Fifteen rules carry the `[auto]` tier. Thirteen have a registered check and are decided
automatically. The two that are not are:

| Rule | Text | Stated Observable |
|---|---|---|
| P2.3 | A technology-specific example MUST be labeled "Illustrative". | The example carries the literal word "Illustrative". |
| P6.4 | A decision criterion MUST NOT reference time, randomness, or agent preference. | No criterion names a clock, a random value, or a preference. |

Neither appears anywhere in the toolchain. The thirty-four rules shown as `DEFERRED` are
`[agent-checkable]` and `[human-review]`, which are correctly not automated and are out of scope.

This changes the shape of the work substantially — from a large enforcement programme to a
narrow decision about two rules — so the requirements below are written against the verified
state rather than the stated one.

**One figure in the governance plan is wrong; another that looks wrong is not.** Phase 4's command
says "fourteen", which is incorrect and is corrected by FR-014. Appendix A separately says "ten of
the twenty-five", which reads like a contradiction but is not: it describes the **development**
constitution, where 10 of 25 rules are tagged `[auto]`. Verified 2026-09-08. That figure stands.

**The development constitution has the same defect, and it is not in scope here.** Ten `D` rules
claim `[auto]`; only three `D` ids appear anywhere in the toolchain, and those are comment
citations rather than checks. That gap is real but concerns a different document with a different
enforcement surface — there is no validator that runs against a `tasks.md`. It is assigned to
Phase 4b of the governance plan rather than tracked here, because a numbered phase in that
document has a record of being executed and a `TODO(...)` entry does not.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The auto tier stops promising enforcement it does not deliver (Priority: P1)

A tier tag is a claim about how a rule is decided. `[auto]` claims a script decides it. For two
rules that claim is false, and the only way to discover this is to read the coverage summary
closely enough to notice the `UNCHECKED` group is not empty. A skill author reasonably reads
`[auto]` as "the validator will tell me", and for these two rules it never will.

**Why this priority**: This is the whole feature. Everything else is bookkeeping that follows
from it.

**Independent Test**: Read the tier tag of every rule in the constitution, then run the validator
against a skill and compare. Every rule tagged `[auto]` appears in a decided group; no rule
tagged `[auto]` appears as unchecked.

**Acceptance Scenarios**:

1. **Given** a rule tagged `[auto]`, **When** a skill is validated, **Then** the rule appears in
   a group that reflects a decision, and never in the unchecked group.
2. **Given** a rule that cannot be decided mechanically, **When** the constitution is read,
   **Then** its tier says so rather than claiming automation that does not exist.
3. **Given** any retagging, **When** the constitution's amendment record is read, **Then** the
   change and its reason are recorded.
4. **Given** the validator runs against any skill, **When** the coverage summary is printed,
   **Then** the unchecked group is empty.

---

### User Story 2 - A new check does not silently change existing verdicts (Priority: P1)

Adding an unconditional check re-judges every artifact already in the repository. A fixture built
to produce exactly one failure can quietly begin producing two, and the test that asserts a single
failure is the only thing standing between that and a wrong verdict shipping. This nearly happened
during feature 009.

**Why this priority**: It is not separable from User Story 1. A check added without this
discipline can pass its own tests while corrupting the meaning of every other fixture.

**Independent Test**: Before enabling any new check, record the expected verdict of every existing
fixture under it; after enabling, confirm each fixture's verdict is unchanged except where
deliberately updated.

**Acceptance Scenarios**:

1. **Given** a new check, **When** it is evaluated against every existing fixture, **Then** its
   expected effect on each is recorded before it is enabled.
2. **Given** a fixture asserting exactly one failure, **When** the new check is enabled, **Then**
   it still produces exactly one failure, or the change is deliberate and recorded.
3. **Given** a newly added check, **When** it is exercised against content that violates its rule,
   **Then** it fails and names the rule id.

---

### User Story 3 - The follow-up backlog reflects reality (Priority: P2)

The constitution carries a single remaining follow-up entry recording the auto-tier gap. Once the
tier is honest, an entry describing an open gap is itself a false statement about the document.

**Why this priority**: It delivers nothing on its own and is meaningless until the first two
stories are done, but leaving it is how a backlog stops being trusted.

**Independent Test**: Read the Sync Impact Report and confirm no entry describes a gap that no
longer exists.

**Acceptance Scenarios**:

1. **Given** the auto tier is honest, **When** the Sync Impact Report is read, **Then** it carries
   no entry describing an unenforced auto tier.
2. **Given** the entry is removed, **When** the removal is recorded, **Then** the evidence for
   closing it is stated rather than asserted.

---

### Edge Cases

- **A rule may be partly mechanical.** P6.4 forbids referencing time, randomness, or agent
  preference. Clock and random-value vocabulary is a closed set that can be listed; "agent
  preference" is a judgement. A rule that is half-decidable must not be tagged as though it is
  fully decided.
- **A check needs to know what it is looking at.** P2.3 constrains technology-specific examples.
  Deciding whether a passage is an example, and whether it is technology-specific, is the hard
  part; checking for the word "Illustrative" is trivial by comparison. A check that assumes the
  hard part is solved will produce confident wrong answers.
- **Retagging is a weaker claim, not a broken one.** Moving a rule from `[auto]` to
  `[agent-checkable]` does not invalidate any conforming skill, because no obligation changes.
- **A rule with no violating fixture is untested.** A check that has never been observed rejecting
  anything proves nothing about what it accepts.
- **Two validators share the rule registry.** A rule about skills, registered without exemption,
  will also be applied to library files. Feature 011 hit exactly this.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Every rule tagged `[auto]` MUST be decided automatically when a skill is validated.
- **FR-002**: A rule tagged `[auto]` MUST NOT appear in the unchecked group of the coverage
  summary.
- **FR-003**: A rule that cannot be decided mechanically MUST carry a tier that says so, rather
  than remaining tagged `[auto]`.
- **FR-004**: Each decision MUST be reported under the rule's own id, not folded into a general
  failure category.
- **FR-005**: The existing coverage summary format MUST be unchanged, and every rule id MUST
  continue to appear in exactly one group.
- **FR-006**: A retag MUST be recorded as an amendment, with its reason.
- **FR-007**: The constitution's version MUST be incremented according to its own versioning
  policy, and the classification justified against that policy's text.
- **FR-008**: Before a new check is enabled, its expected effect on every existing fixture MUST be
  recorded.
- **FR-009**: After a new check is enabled, every existing fixture's verdict MUST be unchanged
  except where the change is deliberate and recorded.
- **FR-010**: Each newly added check MUST be demonstrated failing against content that violates
  its rule.
- **FR-011**: A check MUST NOT judge content the rule was not written to govern; where the rule
  registry is shared with another validator, the rule MUST be exempted there if it does not apply.
- **FR-012**: The follow-up entry describing the unenforced auto tier MUST be removed once the
  tier is honest.
- **FR-013**: The removal MUST be recorded with the evidence that closed it.
- **FR-014**: The governance plan's description of the gap MUST be corrected to the verified
  count.
- **FR-015**: A regression that leaves a rule tagged `[auto]` without a check MUST fail the test
  suite rather than reaching a reader of the constitution.
- **FR-016**: The guard MUST state which governing document it covers, so that a document it does
  not cover cannot be mistaken for one it passes.

### Key Entities

- **Tier tag**: The claim a rule makes about how it is decided. Its honesty is what this feature
  restores.
- **Rule check**: The mechanical decision procedure for one rule, reported under that rule's id.
- **Coverage group**: One of the summary categories into which every rule id falls exactly once.
- **Fixture**: A prepared artifact whose verdict under the validator is asserted by a test.
- **Amendment record**: The account of what changed in the constitution and why.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The unchecked group of the coverage summary is empty for every skill.
- **SC-002**: The count of rules tagged `[auto]` without a registered check is zero.
- **SC-003**: Every rule id appears in exactly one coverage group, as it does today.
- **SC-004**: Each newly added check is observed rejecting a violating artifact.
- **SC-005**: Every pre-existing fixture produces the same verdict as before, except where a
  change is deliberate and recorded.
- **SC-006**: The constitution's follow-up list is empty.
- **SC-007**: The complete test suite passes, with no test removed or weakened.
- **SC-008**: A rule tagged `[auto]` with no registered check causes a test failure that names the
  rule.

## Assumptions

- The two rules in question are P2.3 and P6.4, verified against the constitution and the toolchain
  on 2026-09-08. If the constitution gains further `[auto]` rules before this feature is
  implemented, the same requirements apply to them without amendment.
- Whether each rule receives a check or a retag is a design decision, not a specification one. The
  requirements above are written so that either outcome satisfies them, provided the tier tag ends
  up truthful.
- The constitution's versioning policy classifies a tier change. Adding a check does not change
  any obligation; retagging weakens a claim about enforcement without weakening the rule itself.
  The classification is to be justified against the policy's text rather than by analogy.
- No skill content changes, so no skill version increments and no generated artifact is
  regenerated by this feature.
- `con_token_list()` already exists in the constitution library, so a rule needing a defined
  vocabulary has an established mechanism available. No such list is currently defined for P6.4.
