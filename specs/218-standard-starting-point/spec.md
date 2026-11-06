# Feature Specification: Standard Starting Point

**Feature Branch**: `218-standard-starting-point`

**Created**: 2026-11-05

**Status**: Draft

**Input**: User description: "In highway-codify-config, I want the standard proposal to include: **Here is a proposed starting point for the [Language or Platform] coding standards**"

## Clarifications

### Session 2026-11-05

- Q: When a coding standard is added or updated, which instructions run first? → A: `standard rules` runs first, then `use entries`. The rules, folder structure, and inheritance are built before When to use and When not to use.
- Q: What heading should the rules step use? → A: `standard rules`.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The standard proposal is introduced as a starting point (Priority: P1)

A person adds or updates a coding standard in configuration. Configuration states the consequence of the change, then tells them the proposal that follows is a starting point for that language's or platform's coding standards, then shows the proposal.

**Why this priority**: The platform proposal already introduces itself this way. The standard proposal moves from the consequence sentence straight into the fields.

**Independent Test**: Add a coding standard. The consequence sentence appears, then the starting-point line naming the language or platform, then `**Standard Title:**`.

**Acceptance Scenarios**:

1. **Given** a standard add, **When** the proposal is first shown, **Then** the consequence sentence comes first, then "**Here is a proposed starting point for the [Language or platform] coding standards**", then the proposal fields.
2. **Given** a standard update, **When** the proposal is first shown, **Then** the same line appears in the same position.
3. **Given** the line, **When** it is read, **Then** [Language or platform] is the same value as the proposal's **Technology:** field.

---

### User Story 2 - The line appears only where it is true (Priority: P2)

The line appears only while the proposal is still Highway's starting point.

**Why this priority**: A removal proposes nothing new. A proposal re-shown after an edit already holds the person's changes.

**Independent Test**: Remove a standard, and edit an add. Neither the removal proposal nor the re-shown proposal contains the line.

**Acceptance Scenarios**:

1. **Given** a standard removal, **When** its proposal is shown, **Then** the line does not appear.
2. **Given** an add or update proposal, **When** the person edits it and the proposal is shown again, **Then** the line does not appear.
3. **Given** an add or update proposal with no edit yet, **When** a question or an unknown re-shows it, **Then** the line appears again.

---

### User Story 3 - The standard proposal stays within its limit as ordered steps (Priority: P1)

A maintainer reads `standard proposal`. Adding the line keeps it at 400 words or fewer, and the rule-building instructions are numbered conditions and actions.

**Why this priority**: `standard proposal` is exactly 400 words today. Any addition passes the limit unless something moves out.

**Independent Test**: Count the words in `standard proposal` and in any new step. Read the moved instructions.

**Acceptance Scenarios**:

1. **Given** the change, **When** `standard proposal` is counted, **Then** it has 400 words or fewer, excluding its heading.
2. **Given** the instructions that build the rules, structure, and inheritance of a standard, **When** they are read, **Then** they are numbered conditions and actions in `standard rules`, a step of 250 words or fewer.
3. **Given** a new or changed step, **When** it is read, **Then** it contains no so that, because, in order to, should, consider, prefer, usually, or where appropriate.
4. **Given** a standard remove, **When** its proposal is built, **Then** it shows the current values and runs neither `current` nor `use entries`.

---

### User Story 4 - Every yes or no question states each reply (Priority: P1)

A person answers one of the four yes or no questions that today name only `accept`. A question gets an answer and the same question again. An unknown gets the same question again. A decline keeps the exit that question already has.

**Why this priority**: Every list and every proposal already states `question` and `unknown`. These four asks leave both replies to interpretation.

**Independent Test**: On each of the four asks, reply with a question, with an unknown, and with a no. The question is answered and asked again, the unknown asks again, and the no takes the exit already written for that ask.

**Acceptance Scenarios**:

1. **Given** the conflicts question in `platform written`, **When** the person asks a question, **Then** it is answered and the same question is asked again. An unknown asks it again. A decline goes to `platforms`.
2. **Given** the coding-standards question in `platform written`, **When** the person asks a question or says they do not know, **Then** the question is asked again after an answer, or immediately for an unknown. A decline goes to `platforms`.
3. **Given** the conflicts question in `standard write`, **When** the person declines, asks a question, or says they do not know, **Then** a decline states the consequence and goes to `menu`, and the other two ask the question again.
4. **Given** the onboard question in `platforms`, **When** the person asks a question or says they do not know, **Then** the question is asked again. A decline re-emits the list and its question, as it does today.

---

### User Story 5 - A named platform opens its proposal (Priority: P1)

A person invokes configuration with a platform name. The menu stays hidden, the platform list stays hidden, and the name is handled by the same rules the list uses for a typed name.

**Why this priority**: Entry carries the name in as an add or update, and Verification says the add or update opens. `platforms` has no step that uses the carried name, so the list is what a reader follows.

**Independent Test**: Invoke `/highway-codify-config` with the title of an accepted implementation that has a platform row, with one that has no row, and with a name that is not an accepted implementation.

**Acceptance Scenarios**:

1. **Given** an accepted implementation that already has a platform row, **When** configuration is invoked with its title, **Then** the menu and the platform list stay hidden and the update proposal opens after `current`.
2. **Given** an accepted implementation with no platform row, **When** configuration is invoked with its title, **Then** the add proposal opens after `current`.
3. **Given** a name that is not an accepted implementation, **When** configuration is invoked with it, **Then** the onboard question is asked and the platform list stays hidden.
4. **Given** an invocation with no platform name, **When** the person picks platforms from the menu, **Then** the platform list is shown, as today.

---

### User Story 6 - Remaining procedure prose becomes numbered steps (Priority: P1)

A maintainer reads `conflicts`, `resolve`, `platform proposal`, `standard proposal`, and `Classify`. Each action that decides what happens is a numbered step. The list bullets, the standing rules above the steps, Verification, and Error Handling stay as they are.

**Why this priority**: Those passages decide the conflict list, the resolution, the proposal close, and which reply class wins. They are sentences today, so the order is left open.

**Independent Test**: Read the five steps. `conflicts` and `resolve` open with numbered steps. `platform proposal` continues past the shape with numbered steps. `standard proposal` points its conflict step at `conflicts`. `Classify` tests the six replies in one order, and `edit` comes before `accept`.

**Acceptance Scenarios**:

1. **Given** `conflicts`, **When** it is read, **Then** numbered steps read both catalogs, assess platforms before standards in catalog order, judge overlap by meaning, and handle an empty list before the reply branches.
2. **Given** `resolve`, **When** it is read, **Then** step 1 proposes the fewest changes that remove the selected conflict, starting from its recommendation, and the shape follows that step.
3. **Given** `platform proposal`, **When** it is read, **Then** steps after the shape assess conflicts, fill New Realized Capabilities, and emit the closing question, in that order.
4. **Given** `standard proposal`, **When** its conflict step is read, **Then** it assesses conflicts as `conflicts` does, against the catalogs as they would be after acceptance.
5. **Given** a reply that both edits and accepts, **When** `Classify` runs, **Then** the reply is `edit`.
6. **Given** a reply that both asks a question and accepts, **When** `Classify` runs, **Then** the reply is `question`.

---

### User Story 7 - use entries sits where the proposals follow it (Priority: P1)

A maintainer reads the procedure from top to bottom. `use entries` stands after `current` and before `platform proposal`, which is the first step that follows it. The step that builds a standard's rules stands after `standards` and before `standard proposal`.

**Why this priority**: `use entries` stands between `standard write` and `conflicts`. Reading `platform proposal` means jumping forward across `standards`, `standard proposal`, and `standard write`, then coming back.

**Independent Test**: Read the procedure headings in order. `current` is followed by `use entries`, then `platform proposal`. `standards` is followed by `standard rules`, then `standard proposal`. `standard write` is followed by `conflicts`.

**Acceptance Scenarios**:

1. **Given** the procedure, **When** the headings are read in order, **Then** `use entries` stands after `current` and before `platform proposal`.
2. **Given** an add or update, **When** `standard proposal` builds the proposal, **Then** it follows `standard rules` first and `use entries` second.
3. **Given** the procedure, **When** the headings are read in order, **Then** `standard rules` stands after `standards` and before `standard proposal`.
4. **Given** the procedure, **When** the headings are read in order, **Then** `standard write` is followed by `conflicts`, then `resolve`.
5. **Given** the move, **When** the word count of `current`, `platform proposal`, and `standard proposal` is taken, **Then** each count stops at that step's next heading.

---

### Edge Cases

- A standard opened from the coding-standards question after a platform write shows the line on its first add or update proposal.
- When the current documentation cannot be read, its notice still comes before the proposal, and the line still sits between the consequence sentence and the fields.
- After an edit, a later question or unknown re-shows the edited proposal, so the line stays off.
- A failed `standard write` check returns to `standard proposal`. The proposal keeps its edited or unedited state, so the line follows FR-004.
- A named platform compared without regard to case follows the same three outcomes as a name typed at the list.
- A decline during the onboard question, reached from a named platform, re-emits the platform list. The list was hidden only for the opening.
- A reply that supplies a fact and also declines is `edit`, because `edit` is tested first.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The `standard proposal` shape MUST emit "**Here is a proposed starting point for the [Language or platform] coding standards**" after the consequence sentence and before `**Standard Title:**`.
- **FR-002**: The line MUST appear on an add and on an update with no edit yet.
- **FR-003**: The line MUST NOT appear on a remove.
- **FR-004**: The line MUST NOT appear when the proposal is re-shown after an `edit`. It MUST appear when the proposal is re-shown after a `question` or an `unknown` and no edit has been made.
- **FR-005**: [Language or platform] MUST be the proposal's **Technology:** value.
- **FR-006**: The line MUST be bold and match FR-001 exactly, with no trailing period.
- **FR-007**: The instructions that build a standard's rules, file and folder structure, and inheritance MUST move out of `standard proposal` into `standard rules`, a step of 250 words or fewer, as numbered conditions and actions. For an add or update, `standard proposal` MUST follow `standard rules` first, then `use entries`. A remove MUST show the current values and run neither `standard rules` nor `current`.
- **FR-008**: `standard proposal` MUST stay at 400 words or fewer, excluding its heading.
- **FR-009**: Every new or changed step MUST be numbered conditions and actions or a proposal shape, each branch MUST name its next step, and these steps MUST NOT contain so that, because, in order to, should, consider, prefer, usually, or where appropriate.
- **FR-010**: The moved instructions MUST keep their meaning: at most ten rules from current documentation when no standard file exists, each containing the word must; the recommended structure; inheritance from language standards; the credentials rule; and the structure path rules.
- **FR-011**: `highway-codify-config` MUST move from 3.2.0 to 3.2.1.
- **FR-012**: The conflicts question and the coding-standards question in `platform written`, the conflicts question in `standard write`, and the onboard question in `platforms` MUST each state `question`, `unknown`, and `decline`.
- **FR-013**: On each of those four asks, a `question` MUST be answered and the same ask MUST be asked again. An `unknown` MUST ask the same ask again.
- **FR-014**: A `decline` MUST keep its current exit: `platforms` for both `platform written` asks, the consequence sentence and `menu` for the `standard write` ask, and the re-emitted list for the onboard ask.
- **FR-015**: When Entry carries a platform name, `platforms` MUST apply its name rules to that name and emit no list. An accepted implementation title with a row opens the update proposal after `current`. One with no row opens the add proposal after `current`. Any other name asks the onboard question.
- **FR-016**: An invocation with no platform name MUST show the platform list when the person picks platforms, as today.
- **FR-017**: `conflicts` MUST open with numbered steps: read both catalogs; assess platforms first, then standards, each in catalog order; judge overlap by meaning, not exact wording; when none exist, emit the empty-state sentence, ask what inconsistencies the person noticed, assess that against the catalogs, and re-emit the step. The reply branches follow those steps.
- **FR-018**: `resolve` MUST make "Propose the fewest changes that remove the selected conflict, starting from its recommendation" step 1. The shape follows that step.
- **FR-019**: `platform proposal` MUST continue after its shape with numbered steps, in order: assess conflicts as `conflicts` does, against the catalogs as they would be after acceptance; list each capability `current` marked new under New Realized Capabilities, or `None`; emit the closing question and the cancel line.
- **FR-020**: `standard proposal` MUST assess conflicts in its own numbered step, as `conflicts` does, against the catalogs as they would be after acceptance. It MUST NOT point that step at `platform proposal`.
- **FR-021**: `Classify` MUST test the latest reply in this order and stop at the first match: `edit`, `decline`, `question`, `select`, `unknown`, `accept`. "looks good" remains `accept`.
- **FR-022**: `conflicts`, `resolve`, `platform proposal`, `standard proposal`, and `Classify` MUST each stay at 400 words or fewer, excluding the heading. The list-storage rule, the consequence sentence, cancel, Verification, and Error Handling stay in place.
- **FR-023**: `use entries` MUST stand after `current` and before `platform proposal`. `standard rules` MUST stand after `standards` and before `standard proposal`. `standard write` MUST be followed by `conflicts`, then `resolve`.
- **FR-024**: The word-count check MUST end `current`, `platform proposal`, and `standard proposal` at each step's next heading. The reason for that move is recorded in planning.

### Key Entities

- **Standard starting-point line**: one bold line naming the language or platform. It sits between the consequence sentence and the proposal fields on an add or update proposal with no edit yet.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: On every add or update standard proposal with no edit yet, the line appears exactly once, between the consequence sentence and `**Standard Title:**`.
- **SC-002**: No remove proposal, and no proposal re-shown after an edit, contains the line.
- **SC-003**: `standard proposal` has 400 words or fewer, and the new step has 250 words or fewer.
- **SC-004**: The existing suite passes with 0 failures after the change.
- **SC-005**: Each of the four yes or no asks states `question`, `unknown`, and `decline`, and each of those replies has one next step.
- **SC-006**: An invocation with a platform name emits neither the menu nor the platform list before the proposal or the onboard question.
- **SC-007**: `conflicts`, `resolve`, and the close of both proposals are numbered steps, `standard proposal` assesses conflicts as `conflicts` does, and a reply that edits and accepts classifies as `edit`.
- **SC-008**: `conflicts`, `resolve`, `platform proposal`, `standard proposal`, and `Classify` each stay at 400 words or fewer.
- **SC-009**: The procedure headings read `current`, `use entries`, `platform proposal`, then later `standards`, `standard rules`, `standard proposal`, `standard write`, `conflicts`, `resolve`.

## Assumptions

- The line follows the same rule as the platform starting-point line from spec 217: shown while Highway authored the proposal, hidden after an edit and on a remove.
- The request's [Language or Platform] uses the skill's existing placeholder spelling, [Language or platform]. The emitted text is the technology name either way.
- Moving existing instructions into a step without changing their meaning, plus one emitted line, is a wording change, so the version change is PATCH.
- Tests that pin the moved sentences keep passing, or move with reasons recorded in planning.
- The four asks take the reply handling already used on the lists and proposals: a question is answered and asked again, and an unknown asks again. A decline keeps the exit already written for that ask.
- A named platform uses the list's existing name rules. The list itself is what changes: it stays hidden until a decline on the onboard question.
- The version stays a PATCH. These additions state behavior the skill and its Verification already point at, as numbered steps.
- Overlap stays "by meaning, not exact wording," and a resolution stays "the fewest changes." Numbering states the order. It does not add a new test for either phrase.
- `Classify` tests `edit` first because a supplied fact changes the proposal. `decline`, `question`, `select`, and `unknown` follow, and `accept` is last because it adds no fact.
- `use entries` moves after `current` because that is the first step both proposals have passed when they follow it. The move changes no behavior. The word-count check ends `current` at `platform proposal` today, so it has to stop at the next heading once `use entries` stands between them.
- On a standard add or update, `standard rules` runs before `use entries`, matching the proposal shape, where Coding Standards stands above When to use.
