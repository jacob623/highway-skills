# Feature Specification: Requirements Inquiry Skill

**Feature Branch**: `015-requirements-inquiry`
**Created**: 2026-09-08
**Status**: Draft
**Input**: "I want to create a skill called 'highway-inquiry'. The purpose of this skill is to
manage and maintain the requirements discovery questionnaire used by other Highway skills... The
skill should enable platform users to modify the questionnaire without editing skill code."

## Corrections to the input *(verified 2026-09-08)*

Three things in the description need settling before requirements can be written against it.

**The questionnaire's path is stated two ways.** The opening says
`.highway/library/templates/requirements-inquiry.md`; the Question Management and Output sections
say `/library/templates/requirements-inquiry.md`. Only the first exists as a real location. This
specification uses it throughout.

**The questionnaire does not exist yet.** `.highway/library/templates/` contains a README and
nothing else. The skill therefore cannot assume a file to edit, and something must define what a
new installation starts with.

**It has no consumer yet, but one is planned.** The description calls it "the authoritative source
of questions for requirements discovery workflows... used by other Highway skills", and a skill
that reads the questionnaire and presents the questions in order is intended. It does not exist
today, and `highway-help` does not read the questionnaire. Requirements about being "suitable for
direct consumption by downstream skills" are therefore written as properties of the file, which is
what a future reader will depend on.

## How ordering works, and what was decided *(2026-09-08)*

The description asked both for questions to be renumbered on removal and for "stable question
identifiers where possible". Those pull in opposite directions, so it was raised.

**Decision: the number is the order, and there is no separate identifier.** A question's number is
its position in the sequence the questions are asked. Numbering is contiguous, renumbers whenever
questions are added, removed, or moved, and is the thing the user manages directly.

**Why no identifier**: the argument for one is that a stored reference to "question 7" silently
points at a different question after a removal. That needs something to be storing references. A
skill that reads the questionnaire and presents the questions in order — which is planned — does
not: it re-reads the current file each time, so renumbering is invisible to it. Adding identifiers
now would be machinery for a problem that has not arrived, and would put a second number beside
the one the user actually manages.

**The condition that would change this** is narrower than "a consumer exists", and worth stating
precisely because a consumer is now known to be coming: identity becomes necessary when something
**records an answer, or emits an artifact, keyed by question number**. "Q7: yes" stored anywhere
outside the moment of asking is a reference that ages, and nothing errors when it does.

**What keeps that door shut cheaply**: an answer keyed by *question text* never ages, because the
text travels with the meaning. That only works if the text is unique, which FR-005a requires — and
which the duplicate-detection this skill already performs makes natural rather than extra. A
future presenting skill should therefore record answers against question text, not against
number. If it cannot, this decision needs revisiting before that skill is built, not after.

**What this costs today**, and how the requirements below cover it: a user working from a
questionnaire they viewed earlier can name a number that has since moved. The skill therefore
reports the resulting numbering after every change, and resolves each instruction against the
current file rather than against what the user last saw.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A platform user changes the questions without touching skill code (Priority: P1)

The questions asked during requirements discovery are a matter of organisational judgement, not
framework design. Today changing them would mean editing a skill's prompt text, which puts a
governance decision behind a code change and makes it invisible to the people who own it.

**Why this priority**: This is the feature. Everything else qualifies how it behaves.

**Independent Test**: Add, update, remove, and reorder questions through the skill alone, and
confirm the questionnaire changed and no skill file was edited.

**Acceptance Scenarios**:

1. **Given** an existing questionnaire, **When** a user asks to add a question, **Then** it is
   added and the file is updated without any skill file changing.
2. **Given** an existing questionnaire, **When** a user asks to view it, **Then** the current
   questions are presented in their stated order.
3. **Given** a question that exists, **When** a user asks to update it, **Then** its text changes
   and its position does not.
4. **Given** a question that exists, **When** a user asks to move it, **Then** it appears at the
   requested position and the surrounding questions are renumbered to stay contiguous.
5. **Given** no questionnaire exists yet, **When** the skill is first used, **Then** it either
   creates one or states plainly that none exists and what to do.

---

### User Story 2 - The skill refuses to act on a guess (Priority: P1)

"Move monitoring higher" names no question, no destination, and possibly several candidates. A
skill that resolves that by picking one has made a governance change the user did not ask for, in
a file they may not re-read.

**Why this priority**: Inseparable from User Story 1. An editing skill that guesses is worse than
no editing skill, because the user believes their instruction was followed.

**Independent Test**: Issue an ambiguous instruction and confirm the skill asks rather than acts,
and that the file is unchanged until the ambiguity is resolved.

**Acceptance Scenarios**:

1. **Given** an instruction naming no specific question, **When** the skill cannot identify one
   unambiguously, **Then** it asks which is meant and changes nothing.
2. **Given** an instruction matching several questions, **When** the skill reports the ambiguity,
   **Then** it names the candidates rather than describing them generically.
3. **Given** an action that would discard existing questions, **When** the skill proceeds,
   **Then** it first states what will be lost and obtains confirmation.
4. **Given** an unresolved ambiguity, **When** the exchange ends, **Then** the questionnaire is
   byte-identical to what it was before.

---

### User Story 3 - Poor questions are challenged before they enter the questionnaire (Priority: P2)

A questionnaire is only as useful as the answers it produces. A question that cannot be answered,
or that collects nothing a downstream artifact can use, costs every future respondent time and
yields nothing.

**Why this priority**: It improves quality but delivers nothing until questions can be managed at
all. It is also the part most likely to frustrate a user if applied too strictly, which argues for
challenging rather than blocking.

**Independent Test**: Submit a question that cannot reasonably be answered and confirm the skill
explains the problem, offers alternatives, and lets the user decide.

**Acceptance Scenarios**:

1. **Given** a question that cannot reasonably be answered, **When** it is submitted, **Then** the
   skill explains why and offers at least one improved alternative.
2. **Given** a rejection, **When** the user supplies their own revision instead of an offered
   alternative, **Then** it is accepted.
3. **Given** a question that duplicates an existing one, **When** it is submitted, **Then** the
   skill names the existing question rather than reporting a duplicate abstractly.
4. **Given** a user who insists after a challenge, **When** they confirm, **Then** the question is
   added — the skill advises, it does not veto.

---

### User Story 4 - The questionnaire stays a valid library artifact (Priority: P2)

The file lives in the Highway library and is distributed to users. A file the framework's own
validator rejects is not something to hand over, and the skill writes it on every change.

**Why this priority**: Invisible until it breaks, then breaks for everyone who runs the validator.

**Independent Test**: After any skill action, run the library validator against the questionnaire
and confirm it passes.

**Acceptance Scenarios**:

1. **Given** any action that writes the questionnaire, **When** the library validator runs against
   it, **Then** it passes.
2. **Given** an unchanged set of questions, **When** the questionnaire is written twice, **Then**
   the two results are identical.

---

### Edge Cases

- **A number the user is holding may already have moved.** Someone who viewed the questionnaire,
  then removed a question, then says "update question 7" may mean the old seventh or the new one.
  This is the cost of using position as the reference, and it is why the skill reports the
  resulting numbering after every change.
- **A multi-step instruction resolves step by step.** "Remove question 3 and update question 4"
  is ambiguous about whether 4 is counted before or after the removal.
- **"Set the complete questionnaire" destroys everything not restated.** It is the only action
  that can lose work the user did not mention. It needs different treatment from the others.
- **The file does not exist on a fresh installation.** Every action except creation has no subject.
- **A user may edit the file by hand.** They own it and are invited to. The skill must not assume
  it wrote every byte, and must not silently discard a hand edit it does not understand.
- **The questionnaire has no consumer yet.** Nothing today reads it, so "suitable for downstream
  consumption" cannot be demonstrated end to end and must be expressed as properties of the file.
- **Section membership and ordering interact.** Moving a question across a section boundary changes
  which section it belongs to; moving within one does not. An instruction may not say which is
  meant.
- **Quality judgement is not mechanical.** Whether a question is answerable is a judgement. Stating
  it as an absolute rule would make the skill unpredictable.
- **A validation failure is the framework's problem, not the user's.** A platform user managing
  questions has no use for a rule id, and the elements those rules govern — frontmatter, Purpose,
  Verification — are ones they never wrote. Reporting such a failure asks them to fix something
  they do not own.
- **But repair must not reach the user's content.** Every rule a library file is checked against
  today is framework structure, so this boundary costs nothing now. It would start to matter if
  library validation were ever widened to judge prose, which is exactly when silently "fixing" a
  user's question would become possible.
- **A repair can fail.** A file hand-edited into a state the skill cannot parse is the user's
  content and their problem to resolve, so it must be reported rather than silently rewritten or
  retried indefinitely.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The skill MUST support viewing the complete questionnaire.
- **FR-002**: The skill MUST support adding, updating, removing, and reordering questions.
- **FR-003**: The skill MUST support placing a question before another, after another, or at a
  stated position.
- **FR-004**: The skill MUST support replacing the entire questionnaire.
- **FR-005**: Every question MUST carry a number that is its position in the order the questions
  are asked.
- **FR-005a**: Question text MUST be unique within the questionnaire, so that an answer can be
  recorded against the text rather than against a number that changes.
- **FR-006**: Numbering MUST be contiguous, with no gap and no duplicate, after every action.
- **FR-007**: Numbering MUST run across the whole questionnaire rather than restarting per
  section, because it expresses the order questions are asked and that order is global.
- **FR-007a**: After any action that changes numbering, the skill MUST report the resulting
  numbering, so a user's next instruction is given against what the file now contains.
- **FR-007b**: Where an instruction contains several steps, the skill MUST resolve each against
  the state produced by the previous step, and MUST say so when the numbering it used differs
  from the numbering the user named.
- **FR-008**: The skill MUST determine the user's intended action before changing anything.
- **FR-009**: Where the intended action or its subject is ambiguous, the skill MUST ask and MUST
  leave the questionnaire unchanged until the ambiguity is resolved.
- **FR-010**: An ambiguity report MUST name the candidate questions.
- **FR-011**: Before an action that discards existing questions, the skill MUST state what will be
  lost and obtain confirmation.
- **FR-012**: The skill MUST assess a new or updated question for clarity, answerability,
  relevance to requirements discovery, and duplication.
- **FR-013**: On challenging a question, the skill MUST explain the problem and offer at least one
  alternative.
- **FR-014**: The user MUST be able to accept an alternative, supply their own, or proceed
  unchanged. The skill advises; it does not veto.
- **FR-015**: The questionnaire MUST support named sections, and MUST preserve section membership
  across actions that do not change it.
- **FR-016**: The questionnaire MUST remain readable and editable by hand.
- **FR-017**: Every write MUST produce a file that passes the library validator.
- **FR-017a**: After writing, the skill MUST check the questionnaire against the library validator
  rather than assuming the write was conformant.
- **FR-017b**: Where that check fails on a structural element the framework owns — the frontmatter
  fields, the Purpose section, or the Verification section — the skill MUST repair it and rewrite,
  without reporting the failure to the user. These are not things the user authored, and a rule id
  is not information they can act on.
- **FR-017c**: The skill MUST NOT alter a question's text, a section's name, or the order of
  either in order to satisfy a check. Repair applies to framework structure only.
- **FR-017d**: Where the questionnaire still fails after repair, the skill MUST report it, naming
  what it could not fix. Silence is correct only when the problem is fixed.
- **FR-018**: Writing an unchanged set of questions twice MUST produce identical results.
- **FR-019**: The skill MUST behave predictably when no questionnaire exists, either creating one
  or stating that none exists and what to do.
- **FR-020**: The skill's own definition MUST satisfy the Highway Skills Constitution, including
  the eight required sections.
- **FR-021**: The skill MUST NOT require a user to edit any skill file to change any question.

### Key Entities

- **Questionnaire**: The file holding the questions, their sections, and their order. Distributed
  to users and editable by them.
- **Question**: A single discovery prompt, its text, its section, and its number.
- **Section**: A named grouping of questions, itself ordered.
- **Number**: A question's position in the order the questions are asked. It is the only handle a
  question has, and it changes as the questionnaire changes.
- **Challenge**: The skill's advisory response to a question it judges weak — an explanation plus
  alternatives, never a refusal.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every supported action can be performed without editing any skill file.
- **SC-002**: After adding, removing, and moving questions, numbering is contiguous with no gap
  and no duplicate.
- **SC-002a**: No two questions in the questionnaire have identical text.
- **SC-003**: Every action that changes numbering is followed by a report of the resulting
  numbering.
- **SC-004**: An ambiguous instruction leaves the questionnaire byte-identical.
- **SC-005**: An action that would discard questions does not proceed without confirmation.
- **SC-006**: A question that cannot reasonably be answered is challenged with at least one
  alternative offered.
- **SC-007**: A user who insists after a challenge gets their question.
- **SC-008**: The library validator passes against the questionnaire after every action.
- **SC-008a**: A questionnaire whose framework structure is damaged is repaired without the user
  being told a rule id.
- **SC-008b**: No question's text or section's name is ever changed by a repair.
- **SC-009**: Two writes of an unchanged question set produce no difference.
- **SC-010**: The skill validates against the Highway Skills Constitution.
- **SC-011**: The complete test suite passes, with no test removed or weakened.

## Assumptions

- **A question's number is its position, and there is no separate identifier.** Decided
  2026-09-08 on the stated intent that the order questions are asked should be evident and
  directly manageable. The trade-off, and the condition that would reverse it, are recorded above.
- The questionnaire is Highway framework content, not user architecture content. It is a set of
  questions the framework asks, which a user may tune — so it belongs in the Highway library, and
  the Layer 3 containment rule that keeps user architecture content out of `.highway/` does not
  apply to it.
- Library validation is structural rather than editorial. Verified 2026-09-08: a library file is
  checked for required frontmatter fields, a Purpose section, `metadata.version`, and a
  Verification section. The prose rules, including the vagueness list, are not applied. A user's
  question wording is therefore not judged against Highway's own writing rules.
- This feature does not build a consumer. It defines the questionnaire and the skill that
  maintains it. A skill that reads the questionnaire and presents the questions in order is
  planned separately; the ordering decision above assumes it re-reads the file rather than caching
  question numbers, and states what would have to change if it records answers by number.
- This is the second skill in the catalog, which clears the gate the governance plan places before
  authoring the Experience Standard. It is not, however, written against that standard, because
  the standard does not exist yet. Some rework when it does is expected and accepted.
- Three files already in `.highway/library/` fail the library validator today, and no test
  validates real library content. That is a pre-existing defect, out of scope here, but it means
  FR-017 cannot be demonstrated by pointing at existing library files as examples.
