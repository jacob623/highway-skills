# Feature Specification: Repository Controls

**Feature Branch**: `019-repository-controls`

**Created**: 2026-09-08

**Status**: Draft

**Input**: User description: a `/highway-controls` skill that manages the repository-wide Control baseline — mandatory, auditable, testable requirements applying across the repository. Phase 1 of a larger governance model: NFR management and Control-to-NFR relationships are out of scope, but the data model must support them later. Supported actions are Set, Add, Update, Remove. Controls carry stable `CTLXXXXXX` identifiers that are never reused and never change. The baseline is semantically versioned, maintained automatically by the skill, and the skill is the authoritative mechanism for managing Controls.

**Decisions settled before drafting** (2026-09-08):

| Question | Decision |
|---|---|
| Where Controls live | `library/governance/` at the **project root**, a sibling of `.highway/` — never inside it |
| Control file format | YAML frontmatter and a Markdown body, in `.md` |
| Catalog format | `controls.md`, a generated prose index |
| Identifier allocation | A `next_id` field in the catalog, so identifiers survive removal |
| Destructive actions | Confirm first, naming each Control that would be lost |
| Versioning | **The baseline carries the only version.** Individual Controls carry none |

**Why Controls carry no version of their own.** Two counters over the same content can disagree,
and nothing would say which is authoritative or whether a Control's MAJOR forces a baseline MAJOR.
The question an auditor asks is about the baseline. A Control's own edit history already exists in
version control, which is where history belongs. Adding per-Control versions later is a MINOR
change; removing them once written is breaking.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - An author states a Control and it becomes governable (Priority: P1)

Someone with a policy in their head — administrative access needs MFA — says so in their own words
and gets back a Control with a stable identifier, stored in a file they own, indexed so the rest of
the repository can find it.

**Why this priority**: Without Add there is no baseline, and every other action operates on one.

**Independent test**: Add a Control from a plain-language sentence and confirm a file, an
identifier, and an index entry all exist.

**Acceptance Scenarios**:

1. **Given** no Controls exist, **When** the first is added, **Then** it receives the lowest unused identifier and the catalog is created.
2. **Given** a Control is added, **When** the catalog is read, **Then** it lists that Control and records the next identifier to allocate.
3. **Given** a Control is added, **When** its file is read, **Then** it carries an identifier, title, statement, rationale, status, and an empty NFR relationship field.
4. **Given** an added Control, **When** the baseline version is read, **Then** it has incremented by a MINOR step.

---

### User Story 2 - A user's governance is never judged by Highway's rules (Priority: P1)

A Control reads *"Administrative access MUST require multi-factor authentication."* That is the
user's policy, in the user's words. Nothing in Highway may reject it for its prose style, its
length, or how many obligations it states.

**Why this priority**: This boundary leaks silently and is expensive to retract once users have
built a baseline. Measured 2026-09-08: content under `.highway/library/governance/` is judged
against the Skills Constitution — thirteen Controls written with an uppercase keyword fail `P7.4`,
and a Control longer than twenty-five words fails `P1.3`, reported as though the user's policy were
a skill.

**Independent test**: Write a baseline that would fail Highway's authoring rules and confirm it is
accepted.

**Acceptance Scenarios**:

1. **Given** Controls in the user's tree, **When** any Highway generator runs, **Then** none of them is swept, indexed, or validated.
2. **Given** a baseline of thirty Controls each stating an obligation, **When** the suite runs, **Then** nothing fails.
3. **Given** a Control longer than twenty-five words, **When** the suite runs, **Then** nothing fails.
4. **Given** the library validator is invoked directly on a user's Control file by any path form, **Then** it declines to judge it rather than classifying it as Highway content.

---

### User Story 3 - Nothing is destroyed without the user seeing what they lose (Priority: P1)

Set replaces the whole baseline and Remove deletes a Control. Both destroy work the user may have
spent weeks on, and neither is recoverable through the skill.

**Why this priority**: Equal to the others because the damage is permanent. A tool that loses a
user's governance is not used twice.

**Independent test**: Attempt a Set that would drop Controls and confirm each is named before
anything is written.

**Acceptance Scenarios**:

1. **Given** a Set that would drop Controls, **When** it is requested, **Then** each dropped Control is named and confirmation is required before any file changes.
2. **Given** a Remove, **When** it is requested, **Then** the Control is named by its identifier and title before deletion.
3. **Given** confirmation is withheld, **When** the action ends, **Then** no file has changed.
4. **Given** any Control is removed, **When** the baseline version is read, **Then** it has incremented by a MAJOR step.

---

### User Story 4 - An identifier means one thing forever (Priority: P2)

`CTL000023` refers to one Control for the life of the repository. Anything citing it — a design
document, an audit finding, a future NFR — keeps its meaning.

**Why this priority**: Cheap to guarantee now, impossible to repair once an identifier has been
reused and cited.

**Independent test**: Add, remove the highest-numbered Control, add again, and confirm the
identifier is not reused.

**Acceptance Scenarios**:

1. **Given** the highest-numbered Control is removed, **When** another is added, **Then** it receives an identifier above the removed one.
2. **Given** a Control is updated, **When** its file is read, **Then** its identifier is unchanged.
3. **Given** the catalog, **When** it is read, **Then** it records the next identifier to allocate.

---

### User Story 5 - The skill advises on quality without overruling the author (Priority: P2)

A Control reading *"Systems must be secure"* states an outcome rather than an enforceable
requirement. The skill should say so and offer better, then do what the user decides.

**Why this priority**: Useful, and the failure mode is specific — a skill that refuses gets
bypassed, and the files get edited by hand, which loses every guarantee above.

**Independent test**: Offer an outcome-shaped Control and confirm the skill objects, proposes an
alternative, and still accepts the original if the user keeps it.

**Acceptance Scenarios**:

1. **Given** an outcome-shaped Control, **When** it is offered, **Then** the skill names what is wrong and proposes at least one enforceable alternative.
2. **Given** the user keeps their wording, **When** they confirm, **Then** the Control is written as they wrote it.
3. **Given** a Control resembling an existing one, **When** it is offered, **Then** the skill names the existing Control rather than reporting a duplicate in the abstract.

---

### Edge Cases

- **An empty baseline.** The first Add must create the catalog rather than assume it.
- **Removing the highest-numbered Control.** Deriving the next identifier from the highest existing file would reuse it. This is why the high-water mark is recorded rather than computed.
- **A Set that adds and drops simultaneously.** Both effects must be reported before either is applied.
- **A Control the user references that does not exist.** Abort naming what was searched for, rather than creating one.
- **Two Controls with near-identical statements.** Permitted — the skill advises, it does not enforce uniqueness of meaning.
- **An identifier cited by something outside the baseline.** Out of scope in Phase 1; removal is MAJOR partly because such citations cannot be checked.
- **A user hand-edits a Control file.** Detectable only if the catalog disagrees with the files; the skill should report rather than silently overwrite.
- **The catalog is absent but Control files exist.** Rebuild from the files, but the next identifier cannot be recovered safely — abort and ask.

## Requirements *(mandatory)*

### Functional Requirements

#### Location and containment

- **FR-001**: Controls MUST be written under `library/governance/` at the project root, never inside `.highway/`.
- **FR-002**: No Highway generator may sweep, index, or catalogue user Control files.
- **FR-003**: The library validator MUST decline to classify any file outside its own framework root, regardless of how the path is written, so containment does not depend on the invocation form.
- **FR-004**: No Highway rule may be applied to the content of a Control.

#### The artifacts

- **FR-005**: Each Control MUST be stored in its own file named for its identifier, with YAML frontmatter and a Markdown body.
- **FR-006**: Each Control MUST carry an identifier, title, statement, rationale, status, and a relationship field for future NFRs, present and empty in this phase.
- **FR-031**: A Control MUST NOT carry a version of its own. The baseline holds the only version.
- **FR-007**: A generated catalog at `library/governance/controls.md` MUST index every Control, state the baseline version, record the next identifier to allocate, and state that Controls are managed through the skill rather than by hand.
- **FR-008**: The catalog MUST be a function of the Controls and the recorded next identifier, with no timestamp or other undeclared content, so an unchanged baseline regenerates identically.

#### Identifiers

- **FR-009**: An identifier MUST take the form `CTL` followed by six digits.
- **FR-010**: An identifier MUST NOT be reused after the Control carrying it is removed.
- **FR-011**: An identifier MUST NOT change once assigned.
- **FR-012**: The next identifier MUST be recorded in the catalog rather than derived from the files present.

#### Actions

- **FR-013**: The skill MUST support Add, Update, Remove, and Set.
- **FR-014**: Add MUST allocate the recorded next identifier, create the file, and update the catalog.
- **FR-015**: Update MUST preserve the identifier and any metadata it does not change.
- **FR-016**: Remove MUST delete the file and its catalog entry.
- **FR-017**: Set MUST replace the baseline, removing Controls absent from the new one.

#### Destructive change

- **FR-018**: Before any action that removes a Control, the skill MUST name each Control that would be lost, by identifier and title, and obtain confirmation.
- **FR-019**: A count alone MUST NOT be treated as sufficient notice.
- **FR-020**: Where confirmation is withheld, no file may change.

#### Versioning

- **FR-021**: The baseline MUST carry a semantic version maintained by the skill.
- **FR-022**: Adding a Control increments MINOR; a non-breaking edit increments PATCH; **removing a Control or replacing the baseline increments MAJOR**.
- **FR-023**: The version MUST change exactly once per action, whatever the action's size.

#### Quality advice

- **FR-024**: The skill MUST assess whether a Control states an enforceable requirement rather than an outcome, and say what is wrong where it does not.
- **FR-025**: The skill MUST offer at least one improved alternative when it objects.
- **FR-026**: The skill MUST NOT refuse a Control the user still wants after being advised.
- **FR-027**: Where a Control resembles an existing one, the skill MUST name the existing Control.

#### Ambiguity

- **FR-028**: Where the intended action, the intended Control, or whether the user means to update or replace is not decidable, the skill MUST ask before changing anything.
- **FR-029**: Where a referenced Control does not exist, the skill MUST abort naming what it searched for, rather than creating one.

#### Forward compatibility

- **FR-030**: The relationship field MUST be present on every Control from this phase, so a later feature can populate it without rewriting every file.

### Key Entities

- **Control**: a mandatory, auditable requirement with a stable identifier. Owned by the user.
- **Baseline**: the set of Controls, carrying one semantic version — the only version in the system.
- **Catalog**: the generated index, the baseline version, and the next identifier.
- **Identifier**: `CTLXXXXXX`, allocated once, never reused, never changed.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A user can state a policy in plain language and get a stable, indexed Control back.
- **SC-002**: A baseline that would fail Highway's authoring rules is accepted without complaint, and no Highway check reports on a Control's content.
- **SC-003**: No sequence of add and remove produces a repeated identifier.
- **SC-004**: No Control is lost without having been named to the user first.
- **SC-005**: Regenerating the catalog from an unchanged baseline produces an identical file.
- **SC-006**: A user who disagrees with the skill's advice can still record the Control they want.
- **SC-007**: The suite passes, and nothing under the user's governance directory appears in any Highway catalog.

## Assumptions

- **The user owns everything under `library/governance/`.** Highway writes there through this skill and governs nothing about the content.
- **Phase 1 is Controls only.** NFR management and relationships are later work; only the field is reserved.
- **The skill's own `SKILL.md` is Highway content** and is subject to the Skills Constitution and the Experience Standard, unlike the Controls it manages.
- **One skill, for now.** Whether Set belongs in a separate skill is a question for planning, if the authoring limits force it.

## Dependencies

- The Experience Standard's rules on confirmation before loss, declared output shape, and determinism.
- The Skills Constitution, which governs the skill's own text.

## Out of Scope

- **NFR management and Control-to-NFR relationships.** Only the empty field.
- **Validating a Control's content against anything.** The skill advises; it does not judge.
- **Checking whether citations of a removed identifier still resolve.** Part of why removal is MAJOR.
- **Migrating existing governance content** from any prior location.
