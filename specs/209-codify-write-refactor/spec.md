# Feature Specification: Codify Write Refactor

**Feature Branch**: `209-codify-write-refactor`

**Created**: 2026-11-03

**Status**: Draft

**Input**: User description: "Refactor write in highway-codify so the task list follows its template. Keep in write only the rules the template cannot express. Do not split the task list into another skill. When highway-codify provides recommendations for automation, check the catalog and do not suggest an automation that has already been codified."

## Clarifications

### Session 2026-11-03

- Q: When a recommendation repeats an automation this implementation has already accepted, which catalog titles should hide it? → A: Check the catalog. A word-for-word match of Implementation ID and Automation Title hides the suggestion. When those do not match word for word but the meaning suggests the automation may already be implemented, read `codify.md` at the Automation Path and omit the suggestion only when that record verifies the match.
- Q: Do capitalization differences in the title count as a different automation? → A: No. Ignore case differences. The same words in the same order are a word-for-word match.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - One statement of how a task list is written (Priority: P1)

The person who maintains Highway changes how an automation's task list is shaped. That shape is stated once, in the task list template. `write` in `highway-codify` names the template and does not repeat its line rules. The record, the catalog row, and the rule that all three are written together stay in `write`.

**Why this priority**: `write` is near the limit for one step because it restates rules the template already states. A later change to the list should be made in one place.

**Independent Test**: Read `write` and the task list template. The template states feature grouping, the executor lines, the files and standards on a line, the test line, and the README line. `write` names the template and does not state those rules again. `write` still says the record, the task list, and the catalog row are written together.

**Acceptance Scenarios**:

1. **Given** `write`, **When** it describes the task list, **Then** it says the list follows the task list template, and it does not restate feature grouping, executor lines, the files and standards on a line, the test line, or the README line.
2. **Given** a task-list rule that `write` states and the template does not, **When** the refactor is done, **Then** that rule is in the template, and `write` no longer states it.
3. **Given** `write`, **When** the refactor is done, **Then** it still writes the automation record, the task list, and the catalog row together, writes none of them until all are valid, and does not write the README or any file the task list names.
4. **Given** `write` after the refactor, **When** its length is counted the same way as the other steps, **Then** it is at most 250 words.

---

### User Story 2 - The task list the person receives does not change (Priority: P1)

The person accepts an automation. The task list they receive is the same list they receive today: features in proposal order, executor lines only for files the Provider needs that no feature writes, a required test as the first line of its feature, relative paths, and the README last.

**Why this priority**: The refactor removes a duplicate statement. It must not change the list.

**Independent Test**: Accept the same proposal before and after the refactor. The two task lists match in grouping, paths, standards, test lines, and the README line. A failed write still leaves every existing automation unchanged.

**Acceptance Scenarios**:

1. **Given** an accepted proposal, **When** the task list is written, **Then** each proposal task is one feature, its lines sit together in proposal order, and each line names only files from that task's accepted Files.
2. **Given** a file the Provider needs that no task's Files includes, **When** the task list is written, **Then** it is an executor line before every feature.
3. **Given** a feature whose first standard says tests are required, **When** the task list is written, **Then** that feature's first line is its test, at that standard's test path. A later feature that does not change the tested behavior adds no test.
4. **Given** a path in a standard's structure that no feature delivers, **When** the task list is written, **Then** that path has no line. The README line is last.
5. **Given** a failed write, **When** it ends, **Then** no partial folder is left and existing automations are unchanged.

---

### User Story 3 - Verification checks the list once (Priority: P2)

The skill's verification stops repeating the line rules. It still checks that acceptance writes the three files together, and it still says a required test is the feature's first line, so that obligation remains visible in the skill.

**Why this priority**: Verification is a second copy of the same rules. It can shrink after the template is the one statement. The story is separate because the list is already correct if only `write` changes.

**Independent Test**: Read Verification. It does not restate feature grouping, executor lines, or the files and standards on a line. It still says the three files are written together, and it still says `Tests: required`.

**Acceptance Scenarios**:

1. **Given** Verification, **When** it describes the task list, **Then** it says the list follows the template, and it does not repeat the line rules `write` no longer states.
2. **Given** Verification, **When** the refactor is done, **Then** it still contains `Tests: required` and `No coding standard applies.`
3. **Given** `layout`, `propose`, and `code`, **When** the refactor is done, **Then** those steps are unchanged.

---

### User Story 4 - Recommend only automations that are not yet codified (Priority: P1)

The person asks `highway-codify` for recommendations. The list leaves out an action this implementation has already accepted. A later capability fills that place, up to the five the list already holds. A removed automation can be recommended again. An automation for a different implementation does not hide a recommendation here.

**Why this priority**: The person sees the same action again after they have already accepted it. The catalog is the record of what has been codified.

**Independent Test**: This implementation has accepted automations titled "Establish the worker" and "Restart the worker", and a third capability would recommend "Recover the worker". The recommendation list includes "Recover the worker" and does not include the two accepted titles. A suggestion titled "Bring the worker back up", whose meaning is close to "Restart the worker", is left out only after that automation's `codify.md` shows it is the same action. Remove "Restart the worker" from the catalog. It can be recommended again.

**Acceptance Scenarios**:

1. **Given** an accepted catalog row for this implementation, **When** a suggestion's action title is the same words as that row's Automation Title, ignoring capitalization, **Then** the suggestion is left out and the automation record is not opened. "Establish the worker" and "establish the worker" are the same title.
2. **Given** an accepted row for this implementation whose Automation Title is not the suggestion's words, **When** the title's meaning suggests it may already be that suggestion, **Then** Highway reads `codify.md` at that row's Automation Path. The suggestion is left out when the record is that action, and kept when the record is a different action.
3. **Given** more grounded capabilities than the omitted ones, **When** the list is capped at five, **Then** the omitted ones are removed first, and the next capabilities in the existing order fill the list.
4. **Given** every grounded suggestion is an accepted automation for this implementation, by title or by its record, **When** the list is shown, **Then** it includes none of them, says those actions are already codified, and still invites the person to describe another idea.
5. **Given** a removed catalog row, or an accepted row for a different implementation, **When** recommendations are built, **Then** that row does not hide a suggestion and its record is not opened.
6. **Given** no catalog, **When** recommendations are built, **Then** nothing is omitted because of this check.
7. **Given** the person names an action, or describes their own idea, **When** `highway-codify` continues, **Then** this check does not refuse it.

---

### Edge Cases

- A proposal task has no Files. It adds no task-list line. Executor lines and the README line are unchanged.
- The template already states every rule `write` repeats. The template text is unchanged, and its version stays `4.0.0`.
- A rule is found only in `write`. It is added to the template before `write` drops it, and the template version becomes `4.0.1`.
- An automation already has a task list. Resuming it starts at the first open task. This feature does not rewrite that list.
- The person declines, or the id is not free yet. Nothing is written, as today.
- The person rewrote an automation's title after accepting it. The catalog title is not the suggestion's words. Highway opens that row's `codify.md` only when the title's meaning suggests the same action, and leaves the suggestion out when the record verifies it.
- A catalog title whose meaning does not suggest the suggestion is left unread, and the suggestion stays.
- The Automation Path has no `codify.md`. That row does not hide the suggestion.
- The recommendation list is empty because nothing is grounded in the implementation. Highway says no suggestion is grounded, as today. It uses the already-codified wording only when grounded suggestions were left out.
- The `suggest` step stays at most 400 words.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `write` MUST name the task list template as the statement of how the task list is shaped. It MUST NOT restate feature grouping, executor lines, the files and standards on a line, the test line, or the README line.
- **FR-002**: A task-list rule that `write` states and the template does not MUST be added to the template before it is removed from `write`. After the refactor, each such rule is stated once.
- **FR-003**: `write` MUST still write the automation record, the task list, and the catalog row together, write none of them until all are valid, and leave every existing automation unchanged when a write fails. It MUST NOT write the README or any file the task list names.
- **FR-004**: The task list produced from an accepted proposal MUST be the same list the current template requires: features in proposal order, executor lines only for files the Provider needs that no feature writes, relative paths from the accepted Files, a required test as the first line of its feature, no line for a structure path no feature delivers, and the README last.
- **FR-005**: The `write` step MUST be at most 250 words, counted the same way as the other steps.
- **FR-006**: Verification MUST stop repeating the line rules. It MUST still say the three files are written together, and the skill MUST still contain `Tests: required` and `No coding standard applies.`
- **FR-007**: `layout`, `propose`, `code`, the record write, and the catalog write MUST stay as they are. No new skill is created. The task list remains owned by `highway-codify`.
- **FR-008**: `highway-codify` MUST become version `9.0.0`. The task list template stays `4.0.0` unless FR-002 adds a rule, in which case it becomes `4.0.1`.
- **FR-009**: While building recommendations, `highway-codify` MUST read the accepted rows of `code/code.md` for the selected implementation. It MUST omit a suggestion whose action title is the same words, in the same order, as that row's Automation Title, compared without regard to case, and it MUST NOT open the record for that match. The omission happens before the list is capped at five. A removed row, a row for another implementation, and a missing catalog MUST omit nothing and MUST NOT be opened.
- **FR-010**: When an accepted row for this implementation has a different Automation Title, and that title's meaning suggests the suggestion may already be implemented, `highway-codify` MUST read `codify.md` at that row's Automation Path. It MUST omit the suggestion when the record's title, summary, or description is that action. It MUST keep the suggestion when the record is a different action, when the meaning does not suggest a match, or when the file is absent.
- **FR-011**: When every grounded suggestion is omitted, the recommendation MUST include none of them, MUST say those actions are already codified, and MUST still invite another idea. A named action and the person's own idea MUST NOT be refused by this check. The `suggest` step MUST stay at most 400 words.

### Key Entities

- **Task list template**: The one statement of line shape, grouping, standards, the test line, and the README line.
- **Write step**: The step that stores the accepted record, the task list, and the catalog row together.
- **Accepted proposal**: The source of each feature's Files and Standards. The template already says which proposal task supplies which line.
- **Automation catalog**: `code/code.md`. An accepted row is an automation that has been codified for one implementation. A word-for-word title match decides on its own. A close title is verified by the `codify.md` at that row's Automation Path.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The five task-list rules named in FR-001 appear in the template and zero times in `write`.
- **SC-002**: The `write` step is at most 250 words, down from 395, and remains under the 400-word step limit.
- **SC-003**: For the same accepted proposal, the task list after the refactor matches the list the current template requires in grouping, paths, standards, test lines, and the README line.
- **SC-004**: The full check suite passes with the same passing count as before the refactor, plus any new check this feature adds. No existing check is removed.
- **SC-005**: `highway-codify` is the only skill that writes the task list. The procedure order is unchanged.
- **SC-006**: For an implementation that already has accepted automations, the recommendation list holds at most five and includes none that a word-for-word catalog title, or that automation's `codify.md`, shows is already accepted.
- **SC-007**: When the only grounded suggestions are already accepted for this implementation, the recommendation list shows zero of them and still invites another idea.

## Assumptions

- The task list template at version `4.0.0` already states the line rules `write` repeats, including which proposal task supplies which line. FR-002 applies only if a comparison finds a rule the template lacks.
- "The same way as the other steps" means the word count used for the 400-word step limit: words in the step, excluding the step heading.
- The task list itself is unchanged. The recommendation list is not: the same implementation can now produce a different list, so `highway-codify` moves from `8.0.0` to `9.0.0`. The record template and the catalog template are unchanged.
- Word for word means the same words in the same order, compared without regard to case. The catalog does not record which capability produced an automation. A rewritten title is checked through the automation record only when its meaning suggests the same action.
- Existing checks that require `Tests: required` and `No coding standard applies.` in the skill stay as they are. Those phrases remain in the skill outside the removed `write` bullets.
- Resuming an open task list, coding a line, and the completion message are out of scope.
