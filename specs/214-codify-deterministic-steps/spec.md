# Feature Specification: Codify Deterministic Steps

**Feature Branch**: `214-codify-deterministic-steps`

**Created**: 2026-11-05

**Status**: Draft

**Input**: User description: "Create a new spec to implement the 8 recommendations to highway-codify. Cut the second copy of the rules so a closing check remains only when no step states it. Split suggest into ranking and replies, start into the draft and the Provider, and project into resume, join, and the folder name, so each of those steps is short enough to follow to the end. Make the plan say what it contains: one story per proposal task, the story title is that task's action, and Done when is that task's observable result. Do not include scope, method, standards, or files. Say the same thing in the plan template. Which suggestion is left out, and which product is joined, stay as they are. Replace fits with entries that appear: a platform or coding-standard row applies when each When to use entry appears on its own in the action, the method, or the Provider, and no When not to use entry appears. A blank When to use does not apply. The earliest platform row wins. Replace covers with a shared name: a Control or NFR applies when its statement contains the task's target, a file the task names, or the mechanism named in the implementation's realization. Otherwise it does not apply. List the matches in catalog order. Ask the check questions in story order. A gap is a story with no Done when, two stories with the same title, or an applied Control or NFR with no story. Ask the first five gaps. Record every later gap as an assumption. Place each task under the story whose title is that task's action. A story with no proposal task still gains one line. A line that names work the proposal does not list is left out."

## Clarifications

### Session 2026-11-05

- Q: When the person names a platform, does that platform stay the one that runs the automation, with the catalog-entry match used only when they name none? → A: A named platform stays, including when its catalog row is missing. The entry match replaces only the current fit test and is used when none is named, against the action and the method. The existing fallbacks stay when no row matches.
- Q: Does a coding standard still have to match a file pattern or a technology before its When to use entries are checked? → A: Yes. The entry match replaces only When to use and When not to use. File patterns, technology, and inheritance order stay. The earlier standard wins a disagreement.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The plan shows one story per task (Priority: P1)

The person who reviews the plan sees one story for every proposal task. The story title is that task's action. Done when is that task's observable result. The plan does not include the task's scope, method, standards, or files.

**Why this priority**: The plan is the document the person reviews. Its stories have to account for every accepted task, and the rule that says so has to be the only rule.

**Independent Test**: Accept a proposal and review the plan. There is one story per proposal task, the title equals that task's action, and Done when is the observable result defined below. Scope, method, standards, and files from the task are absent. The plan template states the same rule.

**Acceptance Scenarios**:

1. **Given** an accepted proposal with three tasks, **When** the plan is written, **Then** it has three stories, and each story title is that task's action.
2. **Given** a task whose action appears in an acceptance criterion, **When** the story is written, **Then** Done when is the earliest such criterion.
3. **Given** a task whose action appears in no acceptance criterion, **When** the story is written, **Then** Done when is that task's Scope sentence.
4. **Given** the plan, **When** it is read, **Then** it does not include a task's scope, method, standards, or files, and it does not say that the accepted proposal is not copied.
5. **Given** the plan template, **When** it is read, **Then** it states this same story rule.

---

### User Story 2 - A catalog row matches the entries that appear (Priority: P1)

A platform the person names stays the one that runs the automation. When none is named, the Provider is the earliest platform row whose When to use entries appear on their own in the action or the method, and whose When not to use entries do not. A row whose When to use is blank is not chosen. The existing fallbacks stay when no row matches.

**Why this priority**: The platform and the standards decide how the solution is written. Two runs have to choose them the same way.

**Independent Test**: Name a platform. That platform is the Provider. Name none. The Provider is the earliest platform row whose every When to use entry appears on its own in the action or the method, and whose When not to use entries do not. A blank When to use is not chosen. When no row matches, the existing fallback is used.

**Acceptance Scenarios**:

1. **Given** the person named a platform, **When** the Provider is chosen, **Then** that platform is the Provider, including when it has no catalog row.
2. **Given** no named platform and two platform rows whose every When to use entry appears on its own in the action or the method, and whose When not to use entries do not, **When** the Provider is chosen, **Then** the earlier catalog row is the Provider.
3. **Given** no named platform and a platform row with a blank When to use, **When** the Provider is chosen, **Then** that row is not chosen by this match.
4. **Given** no named platform and no platform row that passes the entry match, **When** the Provider is chosen, **Then** the existing fallback is used: this implementation's row, then the first row.
5. **Given** a coding-standard row whose file patterns match a file the method names, or whose technology names the method or the Provider, and whose When to use entries appear on their own, **When** standards are listed, **Then** that row is included. A row whose entries appear but whose file patterns and technology do not match is not included. Inheritance order stays.
6. **Given** an entry that occurs only inside a longer word, **When** the row is tested, **Then** the entry does not count as appearing.

---

### User Story 3 - A Control or NFR matches a shared name (Priority: P1)

A Control or NFR applies only when its statement contains the task's target, a file the task names, or the mechanism named for it on the implementation. The proposal lists those matches in catalog order. Any other Control or NFR does not apply.

**Why this priority**: An applied Control changes the solution. It has to be the same Control on every run, and the person sees the list.

**Independent Test**: Compare each active statement with the task's target, the files the task names, and the mechanism on the implementation. A statement that contains one of those is listed. A statement that contains none of them is not.

**Acceptance Scenarios**:

1. **Given** an active Control whose statement contains the task's target, **When** the list is made, **Then** that Control is applied.
2. **Given** a statement that contains a file the task names, or the mechanism named in the implementation's realization, **When** the list is made, **Then** that Control or NFR is applied.
3. **Given** a statement that contains none of those, **When** the list is made, **Then** it is not applied.
4. **Given** several matches, **When** the proposal lists them, **Then** Controls come first, in catalog order, then NFRs, in catalog order.
5. **Given** files placed for the task after the first check, **When** the proposal is about to be shown, **Then** the same match is applied to those files, and a new match is added to the list.

---

### User Story 4 - The check asks the first gaps (Priority: P1)

The person is asked only about a fixed kind of gap, in story order, up to five. Every later gap is recorded as an assumption. When there is no gap, the menu appears and the check is not mentioned.

**Why this priority**: The questions the person has to answer have to be the same questions on every run.

**Independent Test**: Write a plan with six gaps of the three kinds below. The person is asked the first five in story order, one at a time. The sixth is an assumption. A plan with none of the three kinds goes to the menu without mentioning the check.

**Acceptance Scenarios**:

1. **Given** a story with no Done when, **When** the check runs, **Then** that gap is asked.
2. **Given** two stories with the same title, **When** the check runs, **Then** that gap is asked.
3. **Given** an applied Control or NFR that no story names, **When** the check runs, **Then** that gap is asked.
4. **Given** six gaps, **When** the check runs, **Then** the first five in story order are asked, one at a time, and each later gap is recorded as an assumption.
5. **Given** no such gap, **When** the check finishes, **Then** the menu appears and the check is not mentioned.
6. **Given** a question whose answer is already in the accepted proposal, the standards, the Controls, the NFRs, or the implementation record, **When** the check runs, **Then** the answer is written into the plan and the person is not asked.

---

### User Story 5 - Each task sits under its own story (Priority: P1)

When the person continues, each proposal task's line is under the story whose title is that task's action. A story with no proposal task still gets one line. A line that names work the proposal does not list is left out.

**Why this priority**: The task list is what gets built. The person has to be able to find each accepted task under the story they reviewed.

**Independent Test**: Continue from a plan. Each proposal task appears under the story titled with its action. A story whose title is not a proposal task has one line. No line names work the proposal does not list.

**Acceptance Scenarios**:

1. **Given** a story titled with a proposal task's action, **When** the task list is written, **Then** that task's line is under that story.
2. **Given** a story whose title is not a proposal task's action, **When** the task list is written, **Then** that story has one line.
3. **Given** a line that would name work the proposal does not list, **When** the task list is written, **Then** that line is absent.
4. **Given** the task list, **When** it is read, **Then** no instruction says to place a task under the story it delivers.

---

### User Story 6 - Each long decision is its own step (Priority: P2)

Ranking suggestions, answering the suggestion list, drafting the proposal, choosing the Provider, resuming a feature, joining a product, and naming the folder are separate steps. Each is short enough to follow to the end. The decisions stay in today's order.

**Why this priority**: A step near 400 words loses its last decision. Splitting these three steps is what makes the match rules get applied.

**Independent Test**: Read the procedure. Ranking, replies, the draft, the Provider, resume, join, and the folder name are separate steps, in that order within their groups. Each of those steps is at or under 250 words. No step exceeds 400 words.

**Acceptance Scenarios**:

1. **Given** the procedure, **When** no action is named, **Then** ranking runs, with the already-codified check, and the suggestion replies are the next step.
2. **Given** a selected action, **When** the proposal is drafted, **Then** the draft is one step and the Provider choice is the next step.
3. **Given** the draft, **When** a product is chosen, **Then** resume, join, and the folder name are three steps in that order.
4. **Given** any of these steps, **When** its words are counted, excluding its heading, **Then** the count is at or under 250.
5. **Given** the procedure, **When** a decision from the old step is needed, **Then** it still happens, in the same order, in the step that now owns it.

---

### User Story 7 - The closing checks do not repeat the steps (Priority: P2)

The closing checks state a rule only when no step states that rule. A rule that already lives in a step is read there.

**Why this priority**: Two copies of a rule let a run follow one and miss the other. One copy is what the shorter steps are for.

**Independent Test**: Compare each closing check with the steps. A sentence that a step already states is absent from the closing checks. A rule that no step states remains.

**Acceptance Scenarios**:

1. **Given** a rule stated in a step, **When** the closing checks are read, **Then** that rule is not stated again.
2. **Given** a rule that no step states, **When** the closing checks are read, **Then** that rule remains there.
3. **Given** a check that looks for a sentence, **When** the sentence moves from the closing checks into a step, **Then** the check still finds it in the step.

---

### Edge Cases

- The person names a platform. That platform is the Provider, including when it has no catalog row. The entry match does not replace it.
- No platform is named and no row passes the entry match. This implementation's row is used, then the first row. When the catalog has no rows, the Provider stays unset.
- A When to use entry is blank. That row is not chosen. A When not to use entry that appears removes the row even when every When to use entry appears.
- An entry appears only as part of a longer word, such as a short entry inside a longer name. It does not count.
- A coding standard's When to use entries appear, and its file patterns and technology do not match the task. It is not listed.
- Two platform rows pass the entry test. The earlier catalog row is the Provider. Every coding-standard row that passes is listed, and the earlier listed standard wins a disagreement between them.
- A Control statement shares no target, file, or mechanism with the task. It is not applied, including when its subject would have been judged to cover the task.
- Files are placed after the first Control check. The same match runs again on the placed files before the proposal is shown, and a new match is added.
- Two proposal tasks have the same action. The plan has two stories with that title, and the check treats the repeated title as a gap.
- The sixth gap and every gap after it are recorded as assumptions and are not asked.
- A story title matches no proposal task. That story still receives one task-list line.
- Splitting a step does not drop its last decision. The new steps together make the same decisions in the same order.
- The summary sentence, the method text, the description, an edge case's wording, a functional-requirement sentence, and the code written from a task line stay generated as they are today.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The plan MUST contain one story per proposal task. The story title MUST be that task's action. When an acceptance criterion contains that action, Done when MUST be the earliest such criterion. Otherwise Done when MUST be the task's Scope sentence. The plan MUST NOT include that task's scope, method, standards, or files. The sentence that the accepted proposal is not copied MUST be removed from the skill and from the plan template. The plan template MUST state this story rule.
- **FR-002**: A platform the person named MUST stay the Provider, including when that platform has no catalog row. When none is named, a platform row MUST apply only when every When to use entry appears on its own in the action or the method, compared without regard to case, and no When not to use entry appears there. The Provider MUST then be the earliest matching platform row. When no row matches, the existing fallbacks MUST stay: this implementation's row, then the first row. When the catalog has no rows and none is named, the Provider MUST stay unset. An entry that occurs only inside a longer word MUST NOT count. A blank When to use MUST NOT apply. A coding-standard row MUST be a candidate only when its file patterns match a file the method names, or its technology names the method or the Provider. A candidate MUST apply only when every When to use entry appears on its own in the action, the method, or the Provider, and no When not to use entry appears there. Inheritance order MUST stay, and the earlier standard MUST win a disagreement.
- **FR-003**: A Control or NFR MUST apply only when its statement contains the task's target, a file the task names, or the mechanism named in the selected implementation's realization for that Control or NFR, compared without regard to case. Otherwise it MUST NOT apply. Applied titles MUST be listed Controls first, in catalog order, then NFRs, in catalog order. After files are placed, and before the proposal is shown, the same match MUST be applied to the placed files, and a new match MUST be added.
- **FR-004**: The check MUST ask only a story with no Done when, a repeated story title, or an applied Control or NFR that no story names. It MUST ask those gaps in story order, then in the order the Control or NFR is listed, one at a time, up to five. Each later gap MUST be recorded as an assumption. When none qualify, the menu MUST appear and the check MUST NOT be mentioned. A question the accepted material already answers MUST be written into the plan and MUST NOT be asked.
- **FR-005**: Each proposal task's line MUST be placed under the story whose title is that task's action. A story whose title is not a proposal task's action MUST receive one line. A line that names work the proposal does not list MUST be left out. The instruction to place a task under the story it delivers MUST be removed.
- **FR-006**: Ranking suggestions, suggestion replies, the proposal draft, the Provider choice, resuming a feature, joining a product, and naming the folder MUST be separate steps, in that order within each group. The already-codified check MUST run with ranking. Each of these steps MUST be at or under 250 words, excluding its heading. The decisions of the replaced steps MUST still happen, in the same order. Routes that named the replaced steps MUST name the new first step of that group.
- **FR-007**: A closing check MUST state a rule only when no step states that rule. A rule moved from the closing checks into a step MUST remain findable in that step.
- **FR-008**: Apart from the requirements in this specification, the proposal, the reply handling, the menu, the completion message, which suggestion is left out, which product is joined, and the generated summary, method, description, edge case, functional requirement, and code MUST stay as they are. No step MAY exceed 400 words, excluding its heading.
- **FR-009**: Each changed step MUST be an ordered instruction: what to read, which condition applies, and what to do next. A step MUST NOT say should, consider, prefer, usually, or where appropriate. The skill body MUST NOT gain the keywords MUST or SHOULD.
- **FR-010**: `highway-codify` MUST move from `11.0.0` to `12.0.0`. The plan template MUST move from `1.0.0` to `2.0.0`.

### Key Entities

- **Entry match**: A When to use entry that appears on its own, and a When not to use entry that does not. For a coding standard, the row is a candidate first by its file patterns or its technology.
- **Shared name**: The task's target, a file the task names, or the realization's mechanism, when that text appears in a Control or NFR statement.
- **Plan story**: One per proposal task. Its title is the task's action. Done when is the earliest matching acceptance criterion, or the Scope sentence.
- **Check gap**: A story with no Done when, a repeated story title, or an applied Control or NFR that no story names.
- **Step group**: Ranking and replies; the draft and the Provider; resume, join, and the folder name.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every accepted proposal produces one plan story per task, titled with that task's action, with Done when taken from the earliest matching acceptance criterion or the Scope sentence. Zero plans include a task's scope, method, standards, or files.
- **SC-002**: A platform the person names is the Provider, including when it has no catalog row. When none is named, the Provider is the earliest platform row whose entries appear on their own in the action or the method. A blank When to use is chosen zero times. An entry hidden inside a longer word counts zero times. When no row matches, the existing fallback is used. A coding standard whose file patterns and technology do not match is included zero times.
- **SC-003**: Every applied Control or NFR contains the task's target, a named file, or the named mechanism. Every other active Control or NFR is absent from the list.
- **SC-004**: The person is asked at most five gaps, only of the three kinds, in order. Every later gap is an assumption. A plan with no gap mentions the check zero times.
- **SC-005**: Every proposal task's line sits under the story titled with its action. A line that names work the proposal does not list appears zero times.
- **SC-006**: The seven split steps are each at or under 250 words, and every step is at or under 400 words. Every closing check states a rule that no step states.
- **SC-007**: The full check suite passes with the same passing count as before, plus any new check this feature adds.

## Assumptions

- The observable result is the earliest acceptance criterion that contains the task's action, compared without regard to case. When none contains it, the observable result is the task's Scope sentence. Both already exist on the proposal, so Done when is copied from one of them.
- "Appears on its own" means the entry is found with a boundary on each side: the start or end of the text, or a character that is not a letter or digit. Case is ignored. A platform row is matched against the action and the method. A coding-standard row is a candidate by its file patterns or its technology, and its When to use entries are then matched against the action, the method, and the Provider. Inheritance order stays.
- A named platform with no catalog row stays the Provider, and the existing notice that it can be added remains. The fallback when no platform row matches is this implementation's row, then the first catalog row.
- The task's target is the target that task's arrow points to. A file the task names is a path or file name written in the task, including a path placed for it. The mechanism is the text the implementation's realization names for that Control or NFR.
- The second Control match runs after files are placed and before the proposal is shown. It adds matches. It does not drop a match already held.
- The check walks stories in plan order, then applied Controls and NFRs in the order the proposal lists them.
- Ranking and the suggestion replies replace the suggestion step's two jobs. The draft and the Provider replace the start step. Resume, join, and the folder name replace the project step. `codified` stays the check that ranking calls.
- A closing check that repeats a step is removed after that step carries the sentence. A check that looks for the sentence is pointed at the step. The reason is that the second copy is the behavior this feature removes.
- The sentence "The accepted proposal is not copied" is removed because this feature replaces it with the story rule. Checks that require it, or that require "fits," "covers," "change the most stories," or "the story it delivers," are updated to the new wording for that reason.
- Which suggestion is left out, and which product is joined, stay as they are. Replacing that meaning test with the same words in order is deferred until it has been tried on its own.
- These match rules narrow which row is chosen, which Control applies, and which question is asked. That is a breaking change, so `highway-codify` moves from `11.0.0` to `12.0.0`. The plan template's story rule changes, so it moves from `1.0.0` to `2.0.0`.
- The summary sentence, the method, the description, edge-case wording, functional-requirement wording, and the code written from a task line are out of scope. This feature does not try to make two runs produce the same sentences or the same code.
- New skill text follows the existing step style: a condition, then the action. The word count excludes the step heading. The words MUST and SHOULD stay out of the skill body.
