# Feature Specification: Propose Edit Lines

**Feature Branch**: `210-propose-edit-lines`

**Created**: 2026-11-03

**Status**: Draft

**Input**: User description: "Break the edit handling in propose into one line per kind of edit, so the lines stay readable and the step stays under 400 words. Keep the proposal block as it is. Do not add a new step."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Each edit has its own line (Priority: P1)

The person correcting an automation proposal is unaffected. The instruction that handles an edit stops being one line of about 1,007 characters. Each kind of edit is its own line: a different Provider, a changed method, a changed Standards list, a Files change, a title that is not a listed standard, a second action, a switch of architecture, a preparation-only request, and removing the last task or the last acceptance criterion.

**Why this priority**: That one line is where a run can apply the wrong consequence. A line per edit keeps each consequence readable.

**Independent Test**: Read `propose`. The edit handling has one line per kind of edit. No line in that handling is longer than 240 characters. The proposal block, from Title through the closing question, is unchanged.

**Acceptance Scenarios**:

1. **Given** `propose`, **When** it states how an edit is handled, **Then** each kind of edit is its own line, and none of those lines is longer than 240 characters.
2. **Given** the proposal block, **When** the refactor is done, **Then** Title, Summary, Description, Acceptance criteria, Diagram, and Tasks appear in that order, with the same fields, including Standards, Files, and Assumptions.
3. **Given** `accept`, `unknown`, `question`, and `decline`, **When** the refactor is done, **Then** those replies are unchanged.

---

### User Story 2 - An edit still does what it does today (Priority: P1)

The person edits a proposal. A different Provider is set on every task and in the diagram. A changed method, or a changed Standards list, is checked again for that task. A Files change applies only to this automation, and a path that is not relative is left out. A title that is not a listed standard is left out, the rest of the list is kept, and the person is pointed to `/highway-codify-config`. A second action waits for another run. Another accepted architecture can be selected by title. A preparation-only request stays one self-service action. Removing the last task or the last acceptance criterion says at least one is needed. Every edit begins with one consequence sentence, the proposal is shown again with the diagram and tasks still matching, and the run stays on `propose`.

**Why this priority**: The line break must not change what an edit does.

**Independent Test**: Apply each kind of edit before and after the refactor. The consequence, the next step, and the re-shown proposal match.

**Acceptance Scenarios**:

1. **Given** an edit that names a different Provider, **When** it is applied, **Then** every task and the diagram use it, and the run goes to `standards`.
2. **Given** an edit that changes a method, **When** it is applied, **Then** the run goes to `standards`, then `align`, for that task.
3. **Given** an edit that adds, removes, or reorders a task's Standards, **When** it is applied, **Then** only that list changes, and the run goes to `align` for that task.
4. **Given** a Files edit, **When** it is applied, **Then** only this automation changes, and a path that is not relative is left out.
5. **Given** a Standards title that is not in the catalog, **When** it is named, **Then** it is left out, the rest of the list is kept, and the reply points to `/highway-codify-config`.
6. **Given** any edit, **When** it is applied, **Then** it begins with one consequence sentence, the proposal is shown again with the diagram and tasks still matching, and the run stays on `propose`.

---

### Edge Cases

- Removing the last task or the last acceptance criterion keeps the proposal open and says at least one is needed.
- A second action is removed, and the reply says it waits for another run.
- An architecture that is not accepted is not added. An accepted architecture can be selected by its title.
- A preparation-only request stays one self-service action.
- `propose` remains one step. No new step is added. The step stays at or under 400 words.
- `layout`, `suggest`, `start`, `choose`, `catalog`, and `align` are unchanged.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The edit handling in `propose` MUST state each kind of edit on its own line. No line in that handling MAY exceed 240 characters.
- **FR-002**: Each edit MUST keep its current consequence: a different Provider is set on every task and in the diagram, then the run goes to `standards`; a changed method goes to `standards`, then `align`, for that task; a changed Standards list changes only that list, then goes to `align` for that task; a Files edit changes only this automation and leaves out a path that is not relative; a title that is not a listed standard is left out, the rest of the list is kept, and the reply points to `/highway-codify-config`.
- **FR-003**: Every edit MUST begin with one consequence sentence, MUST show the proposal again with the diagram and tasks still matching, and MUST stay on `propose`. A second action waits for another run. An unaccepted architecture is not added. A preparation-only request stays one self-service action. Removing the last task or the last acceptance criterion says at least one is needed.
- **FR-004**: The proposal block MUST stay as it is, from Title through the closing question, including Standards, Files, and Assumptions. `accept`, `unknown`, `question`, and `decline` MUST stay as they are.
- **FR-005**: `propose` MUST remain one step and MUST stay at or under 400 words. No other step is added or changed.
- **FR-006**: `highway-codify` MUST become version `9.0.1`.

### Key Entities

- **Proposal block**: The text the person sees, from Title through the closing question. It is unchanged.
- **Edit handling**: The instruction for a correction. It gains one line per kind of edit and keeps each current consequence.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The edit handling has one line per kind of edit, and its longest line is at most 240 characters, down from 1,007.
- **SC-002**: `propose` is at or under 400 words and remains a single step.
- **SC-003**: For the same edit, the consequence, the next step, and the re-shown proposal match the behavior before the refactor.
- **SC-004**: The full check suite passes with the same passing count as before, plus any new check this feature adds. No existing check is removed.

## Assumptions

- The proposal the person sees and the result of each edit are unchanged, so this is a PATCH of `highway-codify`, from `9.0.0` to `9.0.1`.
- "One line per kind of edit" means a Markdown line under the `edit` reply, not a new step and not a change to the proposal block.
- The 400-word count is the same count used for the step limit: words in the step, excluding the step heading.
- Phrases that existing checks require, including `/highway-codify-config` and the proposal field labels, remain in the skill.
