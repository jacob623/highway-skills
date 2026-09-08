# Feature Specification: Development Tier Honesty

**Feature Branch**: `014-dev-tier-honesty`
**Created**: 2026-09-08
**Status**: Draft
**Input**: "I want the Highway Development Constitution's [auto] tier to be honest, the same way
feature 013 made the Skills Constitution's tier honest... Before writing anything, settle what
[auto] means for a Layer 0 rule... decide first whether an enforcing test counts as [auto] or
whether [auto] requires reporting under the rule id, and record that decision... Extend the
tier-honesty guard added by feature 013 to cover this document too... Remove
TODO(D_AUTO_TIER_ENFORCEMENT) once the tier is honest."

## Verified state *(2026-09-08)*

The premise holds. Ten of twenty-five `D` rules are tagged `[auto]`: D1.1, D1.2, D3.1, D3.2, D4.1,
D4.2, D4.3, D4.4, D5.4, D6.2. Exactly three `D` ids appear anywhere under `.highway/tools/` —
D1.6, D3.5, D4.3 — and all three are comment citations. **No `D` rule is decided by a script that
names it.**

But "unenforced" overstates it, and the difference is the whole feature. The ten fall into three
groups that need different answers:

| Group | Rules | State |
|---|---|---|
| **Enforced in substance, unnamed** | D1.1, D1.2, D4.1, D4.2, D4.3, D6.2 | A test decides the thing the rule requires, but reports under its own name, not the rule's |
| **Process across time** | D3.1, D3.2, D4.4 | Claims about two moments, or about what a person did next. No static check can observe them |
| **Genuinely unenforced and checkable** | D5.4 | Feature directory numbering. Nothing checks it, and something easily could |

This differs from feature 013, where the honest answer was two checks and a retag. Here the
question is prior: `[auto]` was defined on the `P` side by a reporting surface that Layer 0 does
not have. There is no validator that runs against a `tasks.md`, a `plan.md`, or a working tree.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - What `[auto]` claims for a Layer 0 rule is written down (Priority: P1)

`[auto]` is currently borrowed from a document where it has a precise meaning: a registered check
decides the rule and reports under its id in a coverage summary. Layer 0 has no registry, no
coverage summary, and no artifact the validator runs against. The tag was applied by analogy, and
the analogy does not hold.

Until the term is defined for this document, "make the tier honest" has no test. Six rules are
either already honest or not, depending entirely on an answer nobody has written down.

**Why this priority**: Every other decision in this feature depends on it. Getting it wrong means
either six rules retagged that did not need to be, or six rules left claiming something they do
not deliver.

**Independent Test**: Read the document and find a statement of what `[auto]` obliges for a rule
in it. Apply that statement to any rule and get one answer.

**Acceptance Scenarios**:

1. **Given** the definition, **When** it is applied to a rule enforced by a test that does not
   name it, **Then** it yields a single unambiguous verdict.
2. **Given** the definition, **When** it is applied to a rule constraining process across time,
   **Then** it yields a single unambiguous verdict.
3. **Given** the definition, **When** a reader compares it with the `P`-side meaning, **Then**
   any difference between the two is stated rather than left to be inferred.
4. **Given** the decision, **When** the amendment record is read, **Then** the alternatives
   considered and the reason for the choice are recorded.

---

### User Story 2 - Every `[auto]` rule in the document meets that definition (Priority: P1)

Once the term is defined, each of the ten rules either satisfies it, is made to satisfy it, or
carries a tier that describes how it is actually decided.

**Why this priority**: This is the outcome the feature exists for. It is separable from User Story
1 only in that it cannot begin until that story is finished.

**Independent Test**: For each rule tagged `[auto]`, confirm it meets the recorded definition.

**Acceptance Scenarios**:

1. **Given** a rule tagged `[auto]`, **When** it is evaluated against the definition, **Then** it
   satisfies it.
2. **Given** a rule that cannot satisfy it, **When** the document is read, **Then** its tier says
   how the rule is actually decided.
3. **Given** any retag, **When** the amendment record is read, **Then** the rule and the reason
   are named.
4. **Given** a rule that is unenforced but mechanically checkable, **When** the work is done,
   **Then** it is enforced rather than retagged away.

---

### User Story 3 - Neither constitution can drift back (Priority: P2)

Feature 013 added a guard covering the Skills Constitution, deliberately scoped and named so it
could not be mistaken for covering governance in general. That scoping was a placeholder for this
feature.

**Why this priority**: It protects the outcome of the first two stories but delivers nothing until
they exist. It is also the reason the tier drifted: nothing was watching.

**Independent Test**: Retag a rule in either document to `[auto]` without satisfying the
definition, and confirm the suite fails and names both the rule and the document.

**Acceptance Scenarios**:

1. **Given** either constitution, **When** a rule is tagged `[auto]` without meeting the
   definition, **Then** the suite fails and names the rule and its document.
2. **Given** the guard, **When** its failure message is read, **Then** it is clear which document
   is at fault.
3. **Given** the tier is honest, **When** the follow-up list is read, **Then** no entry describes
   an unenforced tier.

---

### Edge Cases

- **The guard cannot be extended before the tier is honest.** Extending coverage to a document
  that fails the definition turns the suite red immediately. Ordering is a real constraint, not a
  preference.
- **A rule may be honest under one definition and not another.** D1.1 is decided by a test that
  never names it. Whether that is `[auto]` is exactly the question, and six rules move together
  on the answer.
- **`[auto]` may not be the right vocabulary for Layer 0 at all.** If the definition that fits is
  materially different from the `P`-side meaning, reusing the same tag across two documents makes
  one word mean two things. A distinct tier name is an option and should be considered rather
  than assumed away.
- **A rule about process across time has no artifact to inspect.** Requiring a passing suite
  before and after a change is a claim about two moments and about what a person did between
  them. No check run at one moment can decide it.
- **Enforcing D5.4 needs the numbering source of truth.** Feature directory numbering already has
  a declared convention; a check must read it rather than reimplement it.
- **The development constitution does not ship.** Any tooling added for it must not become a
  runtime dependency of the distribution, and must not be classified as shipped.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The meaning of `[auto]` for a rule in the development constitution MUST be stated in
  that document.
- **FR-002**: That statement MUST yield exactly one verdict for any rule it is applied to.
- **FR-003**: Any difference between that meaning and the `P`-side meaning MUST be stated
  explicitly.
- **FR-004**: If the two meanings differ materially, the document MUST either use a distinct tier
  name or record why reusing the same one is correct.
- **FR-005**: Every rule tagged `[auto]` MUST satisfy the recorded definition.
- **FR-006**: A rule that cannot satisfy it MUST carry a tier describing how it is actually
  decided.
- **FR-007**: A rule that is unenforced but mechanically checkable MUST be enforced rather than
  retagged.
- **FR-008**: Each retag MUST be recorded as an amendment naming the rule and the reason.
- **FR-009**: The document's version MUST be incremented per its own versioning policy, with the
  classification justified against that policy's text.
- **FR-010**: The tier-honesty guard MUST cover both constitutions.
- **FR-011**: A guard failure MUST name both the offending rule and the document it belongs to.
- **FR-012**: The guard MUST be extended only after the document satisfies the definition, so that
  extending coverage does not require a failing suite to be tolerated.
- **FR-013**: Any check added MUST be evaluated against existing artifacts before it is enabled.
- **FR-014**: Any check added MUST be demonstrated failing against a violating artifact.
- **FR-015**: Tooling added for the development constitution MUST NOT enter the distribution.
- **FR-016**: `TODO(D_AUTO_TIER_ENFORCEMENT)` MUST be removed once the tier is honest, with the
  evidence that closed it recorded.

### Key Entities

- **Tier definition**: The statement of what a tier tag obliges, per document. Currently absent
  for Layer 0, which is the root defect.
- **Enforcement surface**: The place a rule's verdict is reported. Layer 1 has a coverage summary;
  Layer 0 has the test suite and nothing else.
- **Tier-honesty guard**: The assertion that every rule claiming automation has it. Currently
  covers one document.
- **Amendment record**: The account of what changed in a constitution and why.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The development constitution states what `[auto]` obliges for its own rules.
- **SC-002**: The count of `[auto]`-tagged `D` rules that do not meet that definition is zero.
- **SC-003**: Every retag is recorded with its reason.
- **SC-004**: The guard covers both constitutions, and its failure output identifies the document.
- **SC-005**: Retagging a rule to `[auto]` in either document without meeting the definition
  causes a test failure naming that rule and document.
- **SC-006**: Each newly added check is observed rejecting a violating artifact.
- **SC-007**: The development constitution's follow-up list is empty.
- **SC-008**: The complete test suite passes, with no test removed or weakened.
- **SC-009**: The distribution builds unchanged, and no tooling added by this feature appears in
  it.

## Assumptions

- The ten rules and the three-way grouping above were verified against the repository on
  2026-09-08. If the document changes before implementation, the same requirements apply to
  whatever set is then tagged `[auto]`.
- Which rules end up enforced and which retagged is a design decision, not a specification one.
  The requirements are written so that any outcome satisfies them provided the tier tag ends up
  truthful and the definition is applied consistently.
- The `P`-side meaning of `[auto]` is not changed by this feature. If the definition chosen here
  diverges, the divergence is recorded rather than propagated backward into the Skills
  Constitution.
- Feature 013 scoped its guard to one document deliberately and said so in the failure message.
  Extending it is expected to be a small change to an existing assertion rather than a new
  mechanism.
- No skill content changes, so no skill version increments and no generated artifact is
  regenerated.
