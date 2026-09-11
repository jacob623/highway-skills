# Feature Specification: Specification-Record Governance Removal

**Feature Branch**: `044-spec-governance-removal`

**Created**: 2026-09-11

**Status**: Draft

**Input**: User description: "What if we remove all governance over the spec folder? I don't
necessarily care about the paperwork. The proof is in the unit and integration tests, which is the
direction I'd like to go down." Plus: "Let's fold 2 into the 044 spec" — item 2 being the closure of
Feature 043 as withdrawn and the recording of Feature 042 as complete.

## Summary

The development constitution governs two different things under one roof: the product under
`.highway/`, which ships, and the record under `specs/` and `.specify/`, which does not. This
feature removes the second. Ten rules across two principles, four of the thirteen Enforcement Map
rows, and three test files stop existing. The repository keeps every rule that decides a shipped
file, and keeps the `specs/` tree itself as history — it simply stops asserting things about it
mechanically.

This is a deliberate reduction in scope. It is **not** a coverage improvement, and this feature
makes no claim that the removed checks were worthless. It records that their subject is stripped
from the distribution, and that effort spent proving properties of the record is effort not spent
proving properties of the product — where, measured 2026-09-11, `validate-skill.sh` decides 93 of
480 rule-to-skill pairs, or 19.4%.

## Clarifications

### Session 2026-09-11

- Q: Does this feature also address the suite's runtime, which exceeds the 180 second target? → A:
  No, and it must not be justified on that basis. Measured 2026-09-11, the three tests removed here
  total 11.8 seconds of a roughly 200 second run — 5.9%. `constitution-inventory.test.sh` at 97.2s
  and `distribution-packaging.test.sh` at 38.3s are 135.5s between them, and both survive this
  feature. Any runtime improvement observed here is a side effect to be recorded, not a goal.
- Q: Are all ten rules of Principles V and VII removed? → A: Eight are. `D5.3` and `D7.3` are
  retained by relocation because their subject is not the `specs/` tree: `D5.3` governs superseding
  documents including constitution amendments, and `D7.3` governs the shape of a completion report.
  Relocating a rule is not amending it; the text and Observable of both carry over unchanged.
- Q: Is the `specs/` tree itself deleted? → A: No. Nothing under `specs/` is deleted by this
  feature except as stated for Feature 043's status line. The history remains readable; it just
  stops being adjudicated.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The development constitution governs only what ships (Priority: P1)

As a Highway maintainer, I want the development constitution to contain no rule whose subject is
the `specs/` tree or the completion register, so that every rule I am accountable to decides a file
a user actually receives.

**Why this priority**: This is the feature. Everything else follows from it.

**Independent Test**: Read the development constitution and confirm that no remaining rule's
Observable names a feature directory, a coverage record, `spec.md`, `plan.md`, `tasks.md`, or the
completion register. Confirm `D1.1` and `D1.2`, which name `specs/` and `.specify/` as *prohibited*
content in shipped files, are untouched — they govern the product, not the record.

**Acceptance Scenarios**:

1. **Given** the amended constitution, **When** every rule's Observable is read, **Then** none names
   an artifact under `specs/` or `.specify/` as its subject.
2. **Given** the amended constitution, **When** `D1.1` and `D1.2` are read, **Then** both are
   byte-identical to their current text.
3. **Given** the amended Enforcement Map, **When** each row's named test file is checked, **Then**
   every file exists.
4. **Given** the amended constitution, **When** `D5.3` and `D7.3` are read, **Then** their Rule and
   Observable columns are byte-identical to their current text, under a different principle heading.

---

### User Story 2 - Feature 042 is recorded complete and Feature 043 is withdrawn (Priority: P1)

As a Highway maintainer, I want the two open features closed in the same change that removes their
subject, so that no feature is left in a state whose meaning has been deleted underneath it.

**Why this priority**: Feature 042 has been blocked from honest completion since 2026-09-11 by
`correction_check`, which demanded a `deferred` row that `D7.5` never required. Feature 043 existed
solely to repair that check. Removing `D7.5` and its check resolves both at once — 042 completes
because nothing rejects it, and 043 becomes unnecessary rather than unfinished.

**Independent Test**: Confirm Feature 042's register row reads `complete`, that its coverage record
still holds 27 rows all `satisfied`, and that Feature 043's spec carries a `Withdrawn` status naming
this feature as the reason.

**Acceptance Scenarios**:

1. **Given** this feature is complete, **When** Feature 042's register row is read, **Then** its
   status is `complete`.
2. **Given** that row is `complete`, **When** the suite runs, **Then** it exits 0, and no row of
   Feature 042's coverage record was changed from `satisfied` to achieve it.
3. **Given** Feature 043's spec, **When** it is read, **Then** its Status reads `Withdrawn` and
   names Feature 044 as the feature that removed its subject.
4. **Given** Feature 043's directory, **When** it is listed, **Then** it still exists and its
   requirements are still readable — a withdrawn feature is recorded, not erased.
5. **Given** the completion register, **When** Feature 043's row is read, **Then** its status is
   `withdrawn` and the register's stated vocabulary includes that value.

---

### User Story 3 - The removal is recorded as a scope decision, not disguised as an improvement (Priority: P1)

As a Highway maintainer, I want the reason for deleting three passing tests written down against
`D3.5`, so that a later reader cannot mistake this for tests being dropped because they were
inconvenient.

**Why this priority**: `D3.5` — a test MUST NOT be weakened to accommodate a change — is the one
`[human-review]` rule in the constitution, and deleting three passing tests is the strongest form of
weakening there is. A removal that does not confront that rule head-on is exactly the behaviour the
rule exists to catch. This repository has twice shipped a check that could not fail; it must not now
ship a deletion that was never argued for.

**Independent Test**: Read this feature's research record and confirm it states, per test removed,
what behaviour is no longer checked and why that behaviour no longer matters — and that a human
sign-off against `D3.5` is recorded.

**Acceptance Scenarios**:

1. **Given** this feature's research record, **When** it is read, **Then** it names each removed
   test, the rules it decided, and the behaviour that becomes unchecked.
2. **Given** that record, **When** it is read, **Then** it states that the removal is justified by
   the subject leaving scope, not by the checks being weak or slow.
3. **Given** that record, **When** it is read, **Then** it carries an explicit `D3.5` human-review
   verdict rather than an assertion that `D3.5` does not apply.
4. **Given** this feature's completion report, **When** it is read, **Then** it states the suite's
   before and after runtime as a measured side effect, and does not present runtime as the reason
   for the change.

---

### Edge Cases

- A rule that governs both the record and the product. None was found: `D1.1` and `D1.2` name
  `specs/` and `.specify/` only as prohibited *content* of shipped files, which is the opposite
  direction and must be retained.
- `constitution-inventory.test.sh` executes the declared probe of every test in the Enforcement Map.
  Removing four rows removes two files from that loop, so this feature changes that test's workload
  without editing it. The effect must be measured rather than assumed.
- `feature-038-evidence-report.sh` references a removed test file. It must be updated or removed in
  the same change, or it becomes a dangling caller.
- `run-all.sh` names `feature-038-plan.test.sh` explicitly in its ordered tail list. Deleting the
  test without editing that list leaves `run-all.sh` invoking a file that does not exist.
- The completion register loses every mechanical reader. It is retained as a maintainer-kept index,
  but its header currently asserts that `D7.2`, `D7.4` and `D7.5` read it — claims that become false
  the moment those rules are gone.
- A future feature directory numbered by guess. `D5.4` and `D5.5` will no longer catch it. This is
  an accepted consequence, stated rather than mitigated.

## Requirements *(mandatory)*

### Functional Requirements

#### Constitution

- **FR-001**: `D5.1`, `D5.2`, `D5.4`, `D5.5`, `D7.1`, `D7.2`, `D7.4` and `D7.5` MUST be removed from
  `.specify/memory/constitution.md`.
- **FR-002**: `D5.3` and `D7.3` MUST be retained, with their Rule and Observable text byte-identical,
  relocated under a principle that survives this feature.
- **FR-003**: The `### V. Specification Record Integrity` and `### VII. Completion Integrity`
  principle sections, including their rationale paragraphs, MUST be removed once emptied of retained
  rules.
- **FR-004**: `D1.1` and `D1.2` MUST NOT be edited.
- **FR-005**: The Enforcement Map rows for `D5.4`, `D5.5`, `D7.2` and `D7.4` MUST be removed, leaving
  nine rows, and every remaining row's named test file MUST exist.
- **FR-006**: The constitution's version MUST be bumped to `2.0.0` and its version-history entry MUST
  record the removed rule ids, the new rule count, and the new tier counts. The bump is MAJOR because
  the document's own Versioning Policy defines MAJOR as "a principle is removed or redefined", and
  this feature removes two principles.
- **FR-007**: No historical version-history entry MUST be edited. Existing entries state counts that
  were true when written and remain true as history.
- **FR-008**: No rule MUST be removed beyond those named in FR-001. A rule whose subject is the
  product is retained even where this feature's reasoning would otherwise reach it.

#### Tests

- **FR-009**: `.highway/tools/tests/completion-coverage.test.sh`,
  `.highway/tools/tests/spec-record.test.sh` and `.highway/tools/tests/feature-038-plan.test.sh`
  MUST be removed.
- **FR-010**: `run-all.sh` MUST NOT name a file that does not exist, including in its ordered tail
  list.
- **FR-011**: `.highway/tools/tests/feature-038-evidence-report.sh` MUST be removed or amended so
  that no surviving file references a removed test. `.highway/tools/tests/feature-038-helpers.sh`
  MUST be retained: `readiness-executable.test.sh` and `highway-setup-executable.test.sh` both
  source it, and neither is in scope.
- **FR-012**: No test that decides a file under `.highway/` MUST be removed, weakened, or have any
  assertion loosened by this feature.
- **FR-013**: `coverage-summary.test.sh` MUST be retained. Its subject is the shipped governance
  constitution, not the specification record, despite its name.
- **FR-014**: After the removal, no file under `.highway/` MUST reference the completion register or
  a feature directory, whether by literal token or by a token assembled at run time.

#### Record closure

- **FR-015**: Feature 042's completion register row MUST be recorded `complete`, with no row of its
  coverage record changed from `satisfied`.
- **FR-016**: Feature 043's spec Status MUST be changed to `Withdrawn`, naming this feature as the
  reason and stating that its subject — `correction_check` and `D7.5` — no longer exists.
- **FR-017**: Feature 043's directory MUST NOT be deleted, and no requirement or clarification within
  it MUST be removed.
- **FR-018**: Feature 043's completion register row MUST read `withdrawn`, and the register's stated
  status vocabulary MUST be updated to include that value.
- **FR-019**: The completion register's header MUST be rewritten so that it asserts no rule reads it,
  and MUST state plainly that it is a maintainer-kept index no check consumes.

#### Accountability

- **FR-020**: This feature's research record MUST name each removed test, the rules it decided, and
  the behaviour that becomes unchecked as a result.
- **FR-021**: This feature's research record MUST carry an explicit `D3.5` human-review verdict on
  the deletion of three passing tests.
- **FR-022**: The completion report MUST state the suite's runtime before and after as a measured
  side effect, and MUST NOT present runtime reduction as a justification for the change.
- **FR-023**: `governance-plan.md` MUST contain no active or deferred phase whose subject is the
  `specs/` tree.
- **FR-024**: `.highway/tools/tests/run-all.sh` MUST exit 0 after the final edit.

### Key Entities

- **Specification-record governance**: the set of constitution rules, Enforcement Map rows and test
  files whose subject is `specs/` or `.specify/memory/completion-register.md`. Measured 2026-09-11:
  8 rules removed and 2 relocated, 4 of 13 Enforcement Map rows, 3 test files totalling 811 lines.
- **Retained-by-relocation rule**: a rule under a removed principle whose subject is not the
  specification record. `D5.3` and `D7.3` are the only two.
- **Withdrawn feature**: a feature whose subject ceased to exist before it was implemented. Its
  directory and requirements are retained; its status records why it will never complete.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: No rule in `.specify/memory/constitution.md` has an Observable naming `spec.md`,
  `plan.md`, `tasks.md`, a coverage record, a feature directory, or the completion register.
- **SC-002**: The Enforcement Map holds nine rows and every named test file exists.
- **SC-003**: `D5.3` and `D7.3` are byte-identical in Rule and Observable to their pre-change text.
- **SC-004**: Three test files are removed and no surviving file under `.highway/` names any of them.
- **SC-005**: `run-all.sh` exits 0 with Feature 042's register row recorded `complete`.
- **SC-006**: Feature 042's coverage record still shows 27 rows, all `satisfied`.
- **SC-007**: Feature 043's directory still exists, its requirement count is unchanged, and its
  Status reads `Withdrawn`.
- **SC-008**: The count of `[auto]` Enforcement Map rows decided by tests over `.highway/` files is
  unchanged by this feature — every removed row's subject was the record.
- **SC-009**: The suite's runtime is recorded before and after. No target is claimed as met by this
  feature.
- **SC-010**: `validate-skill.sh`'s rule-to-skill decision count is unchanged at 93 of 480, because
  this feature adds no coverage. Any change to that figure indicates an unintended edit.

## Assumptions

- The `specs/` tree remains valuable as history and remains readable. This feature removes the
  assertion that it is correct, not the tree itself.
- Numbering and naming of future feature directories become a convention rather than a checked
  property. The cost of an occasional gap is accepted in exchange for not maintaining a check over a
  directory that does not ship.
- "The proof is in the unit and integration tests" is a direction, not a present state. At 19.4%
  rule-to-skill coverage it is aspirational, and this feature does not advance it. The work that
  does — Phase 17's frontmatter contract and the output-template correspondence — is unaffected and
  becomes the next priority.
- `D3.1` and `D3.2` continue to bind: the suite passes before the first edit and after the last.

## Out of Scope

- Any reduction of `constitution-inventory.test.sh` or `distribution-packaging.test.sh` runtime.
  Those hold 135.5 of roughly 200 seconds and are the subject of a separate phase.
- Any new check over `.highway/` files. This feature only removes.
- Deletion or rewriting of any coverage record, including the 96 blanket-deferred rows previously
  owned by Phase 16. Those rows become unread rather than corrected.
- Amendment of `.highway/governance/constitution.md`, the shipped authoring constitution. Only the
  development constitution is in scope.
