# Feature Specification: Codify Feature Wording, Governance, and Plan

**Feature Branch**: `213-codify-feature-wording`

**Created**: 2026-11-04

**Status**: Draft

**Input**: User description: "In highway-codify, replace **Here is a proposed starting point for your automation:** with **Here is a proposed starting point for your codify feature:**. After `If this is accurate, just say so.`, add: Highway will use this specification to build out the solution. After proposal acceptance and before creating the tasks, write: Highway is now building out this solution. We can review, discuss, and revise it afterward, and continue refining it as requirements evolve. Under Questions?, replace the sentence about the code catalog with: To revisit this in the future, just ask Highway to show your Code Catalog. We can review, discuss, and revise any of your solutions, and continue refining them as requirements evolve. Also, ensure every codify solution is abiding by established controls and NFRs. After acceptance, write a plan beside the proposal that adds user stories, edge cases, and functional requirements without duplicating the proposal. Resolve anything accepted material already answers, and ask the person only a question they have to answer. Then offer to review the plan or continue. The task list is written when they continue."

## Clarifications

### Session 2026-11-04

- Q: When two accepted Controls require opposite outcomes, or a Control and an NFR do, what should happen to the proposal? → A: A Control wins over an NFR. Two Controls use the earlier catalog row. The proposal still shows, and it names the conflict. Two NFRs use the earlier catalog row the same way.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The proposal says what it is for (Priority: P1)

The person sees the proposal introduced as a codify feature. After the invitation to confirm, one sentence says Highway will use this specification to build out the solution.

**Why this priority**: A product holds several features. The heading and the closing sentence tell the person that what they accept is the specification Highway builds from.

**Independent Test**: Read the proposal block. It opens with **Here is a proposed starting point for your codify feature:**. The line after `If this is accurate, just say so.` is `Highway will use this specification to build out the solution.`

**Acceptance Scenarios**:

1. **Given** a proposal, **When** it is shown, **Then** its heading is **Here is a proposed starting point for your codify feature:**.
2. **Given** a proposal, **When** it is shown, **Then** `Highway will use this specification to build out the solution.` follows `If this is accurate, just say so.`
3. **Given** an edit, a question, or an unknown reply, **When** the proposal is shown again, **Then** it has the same heading and the same closing sentence.
4. **Given** the proposal, **When** these lines change, **Then** its other fields, their order, and the reply handling are unchanged, apart from the Controls and NFRs list in User Story 4.

---

### User Story 2 - Acceptance says building has started (Priority: P1)

When the person continues after the plan, and before the task list is written, Highway says once that it is building out the solution and that the work can be reviewed and refined afterward.

**Why this priority**: Building starts when the person continues, after the plan. They need to know it has started and that they can revise it later.

**Independent Test**: Choose to continue after the plan. Before the task list is written, the message is exactly: `Highway is now building out this solution. We can review, discuss, and revise it afterward, and continue refining it as requirements evolve.`

**Acceptance Scenarios**:

1. **Given** an accepted proposal whose plan is complete, **When** the person continues, **Then** the building message appears once, before the task list is written.
2. **Given** a declined proposal, **When** the run stops, **Then** the building message does not appear.
3. **Given** a run that resumes an open feature, **When** coding continues or the plan menu returns, **Then** the building message does not appear.
4. **Given** the person continues, **When** the message appears, **Then** it asks nothing, and the task list is written next.

---

### User Story 3 - The close says how to come back (Priority: P2)

The completion message keeps **Questions?**. The sentence under it tells the person to ask Highway to show the Code Catalog and that any solution can be reviewed, discussed, revised, and refined.

**Why this priority**: The close is the last thing the person reads. It points to the catalog as the way back to a solution.

**Independent Test**: Read the completion message. Under **Questions?** is exactly: `To revisit this in the future, just ask Highway to show your Code Catalog. We can review, discuss, and revise any of your solutions, and continue refining them as requirements evolve.` The previous sentence is absent.

**Acceptance Scenarios**:

1. **Given** a finished run, **When** the completion message is shown, **Then** **Questions?** is followed by the new sentence.
2. **Given** that message, **When** it is shown, **Then** `If you have questions in the future, just ask highway to show your code catalog.` and `You can always discuss any of the code highway helps you build.` do not appear.
3. **Given** a run that stopped at a task, **When** its close is shown, **Then** it is unchanged.

---

### User Story 4 - Every solution abides by Controls and NFRs (Priority: P1)

Before the proposal, Highway checks the draft against every active Control and NFR, and against how the accepted implementation realizes them. It corrects the draft so it abides by each one that applies. The proposal lists the Controls and NFRs that apply. Coding follows them. An edit that would break one is not applied.

**Why this priority**: Controls and NFRs are the organization's accepted obligations. A solution Highway builds has to meet them, whether or not a coding standard repeats them.

**Independent Test**: With an active Control that says credentials are stored in an approved vault, propose an action that reads a credential. The method uses the vault. The proposal lists that Control. Edit the method to read the credential from a file. The edit is not applied, and the reply names the Control.

**Acceptance Scenarios**:

1. **Given** active Controls and NFRs, **When** the draft is checked before the proposal, **Then** each one whose statement covers something a task does, touches, or stores is applied, and the draft is corrected to abide by it.
2. **Given** the accepted implementation's Security Control Realization and NFR Realization, **When** a task touches that implementation, **Then** the task follows the mechanism the implementation names for that Control or NFR.
3. **Given** a Control or NFR that applies, **When** the proposal is shown, **Then** it lists each one by title. When none applies, it says no Control or NFR applies.
4. **Given** a Control or NFR that no correction can meet for this action, **When** the draft is checked, **Then** no proposal is shown, the reply names it, and the run returns to the suggestions.
5. **Given** a Control or NFR and a coding standard that disagree, **When** the draft is corrected, **Then** the Control or NFR wins, and the reply names the standard that gave way.
6. **Given** two Controls that disagree, **When** the draft is corrected, **Then** the earlier catalog row is applied, the proposal is shown, and the proposal names both titles and which one was applied.
7. **Given** a Control and an NFR that disagree, **When** the draft is corrected, **Then** the Control is applied, the proposal is shown, and the proposal names the NFR that gave way.
8. **Given** two NFRs that disagree, **When** the draft is corrected, **Then** the earlier catalog row is applied, the proposal is shown, and the proposal names both titles and which one was applied.
9. **Given** an edit that would break a listed Control or NFR, **When** it is applied, **Then** that part of the edit is not applied, the reply names the Control or NFR, and says it can be changed with `/highway-controls` or `/highway-nfrs`.
10. **Given** an accepted proposal, **When** each task is coded, **Then** every listed Control and NFR is read before its files are written, and the files abide by them.
11. **Given** no Controls catalog and no NFRs catalog, **When** the draft is checked, **Then** the proposal says no Control or NFR applies, and the run continues.

---

### User Story 5 - A plan breaks the work out before coding (Priority: P1)

After the person accepts the proposal, Highway writes a plan beside it. The plan adds the stories, the edge cases, and the functional requirements the proposal does not already state. A check resolves anything the accepted material answers. The person is asked only a question that changes a story and that only they can answer. The task list waits until they continue.

**Why this priority**: The proposal is the specification. Coding needs the breakdown of that specification, and the person gets to read it before any task is written.

**Independent Test**: Accept a proposal. The feature directory contains the accepted proposal and `plan.md`, and no task list. The menu offers a review of the plan or to continue. Continue writes the task list ordered by story. The building message appears once before that list.

**Acceptance Scenarios**:

1. **Given** an accepted proposal, **When** any title change is settled, **Then** the accepted proposal is saved and `plan.md` is written beside it. The task list is not written. The feature is the open feature.
2. **Given** that plan, **When** it is written, **Then** it holds stories, edge cases, and functional requirements. Each proposal task's outcome is a story, including when that outcome is the task. Scope, method, standards, and files are not copied. A functional requirement comes from the accepted proposal, a Control, an NFR, or a coding standard, and each applied Control or NFR names the story that carries it.
3. **Given** a choice the proposal, the standards, and the Controls leave open, **When** the plan is written, **Then** it records what was chosen, why, and what was rejected. A data shape is included when the feature has state. An interface shape is included when the proposal names an endpoint, a file format, or a command.
4. **Given** the plan, **When** the check runs, **Then** anything the accepted proposal, the standards, the Controls, the NFRs, or the implementation record can answer is resolved in the plan. A contradiction with the accepted proposal is corrected in the plan.
5. **Given** a question whose answer changes a story and that nothing accepted decides, **When** the check runs, **Then** it is asked, one at a time, up to five, and each answer is written into the plan.
6. **Given** no such question, **When** the check finishes, **Then** the menu appears and the check is not mentioned.
7. **Given** a complete plan, **When** the menu is shown, **Then** it reads: `The plan is complete for feature <number>-<action>.` **Would you like to:** `1. Review the plan?` `2. Continue to code the solution?`
8. **Given** a review, **When** the person discusses the plan, **Then** nothing is written and the menu returns. A stated edit regenerates the plan and runs the check again.
9. **Given** the person continues, **When** the task list is written, **Then** it is ordered by story, each heading names how it is tested on its own, and each task names its file. Every proposal task has a line. A proposal task that delivers no story keeps a heading taken from that task. A line that names work the proposal does not list is left out. The list is checked against the plan before the first file is written, and that check stops only for a question the person still has to answer.
10. **Given** an open feature that has a plan and no task list, **When** the person returns, **Then** the menu returns. **Given** a task list with an open task, **When** the person returns, **Then** coding resumes at that task.

---

### User Story 6 - The new instructions stay deterministic (Priority: P1)

Each addition is an ordered instruction. A step says what to read, which condition applies, and what to do next. A decision that does not fit an existing step is its own step. No step explains why the plan, the Controls, or the wording exist.

**Why this priority**: These additions make the skill longer. A paragraph is where a run can choose its own reading.

**Independent Test**: Read each new or changed step. It is a numbered list of conditions. None of those steps exceeds 400 words. None says should, consider, prefer, usually, or where appropriate. The Controls check, the plan, the check, the menu, and the task list are separate steps.

**Acceptance Scenarios**:

1. **Given** a new or changed step, **When** it is read, **Then** each branch names its condition and its next action.
2. **Given** a decision that fits no existing step, **When** it is added, **Then** it is its own step.
3. **Given** any new or changed step, **When** it is counted, **Then** it is at or under 400 words, excluding its heading.
4. **Given** the new steps, **When** they are read, **Then** none explains why the plan, the Controls, or the wording exist, and none says should, consider, prefer, usually, or where appropriate.

---

### Edge Cases

- A title conflict asks for a new title first. The plan follows that title. The building message appears when the person continues, not before.
- Each proposal task's outcome is a story in the plan, including when that outcome is the task. The plan copies no scope, method, standards, or files. A functional requirement from none of the accepted proposal, a Control, an NFR, or a coding standard is left out.
- More than five questions qualify. The five that change the most stories are asked. Each remaining one is recorded as an assumption.
- A failed task-list write says what failed. The building message has already appeared once and is not repeated on retry. The plan remains.
- A failed write says what failed, as it does today. The building message has already appeared once and is not repeated on retry.
- `project` resuming a finished feature goes to the close without the building message.
- The rest of the completion message is unchanged, including the files path, the instructions path, and `The automation was not run.`
- Two Controls, or two NFRs, that disagree use the earlier catalog row. A Control wins over an NFR. The proposal names the title that gave way and the title that was applied.
- A removed Control or NFR does not apply.
- A Control or NFR accepted after a feature's proposal applies to the next proposal. A feature already coding keeps the list it was accepted with.
- A listed Control or NFR that is removed before its task is coded is skipped for that task.
- Codify reads Controls and NFRs only. It does not create, change, or remove them.
- A decision that fits no existing step becomes its own step. It is not a paragraph added to a step that is already near 400 words.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The proposal heading MUST be **Here is a proposed starting point for your codify feature:**.
- **FR-002**: The proposal MUST end with `Highway will use this specification to build out the solution.` on the line after `If this is accurate, just say so.`, each time it is shown.
- **FR-003**: When the person continues, and before the task list is written, Highway MUST emit once: `Highway is now building out this solution. We can review, discuss, and revise it afterward, and continue refining it as requirements evolve.` The message itself MUST NOT ask a question. It MUST NOT appear on decline, on review, on a resumed feature, or on a retry after a failed write.
- **FR-004**: Under **Questions?** in the completion message, the sentence MUST be `To revisit this in the future, just ask Highway to show your Code Catalog. We can review, discuss, and revise any of your solutions, and continue refining them as requirements evolve.` The previous two sentences MUST be removed.
- **FR-005**: Apart from the requirements in this specification, the proposal, the reply handling, the completion message, and the stopped close MUST stay as they are. No step MAY exceed 400 words.
- **FR-006**: Before the proposal, Highway MUST read every active Control and NFR, and the accepted implementation's Security Control Realization and NFR Realization. Each Control or NFR whose statement covers something a task does, touches, or stores MUST apply. The draft MUST be corrected to abide by each one that applies, following the mechanism the implementation names when a task touches that implementation. A removed Control or NFR MUST NOT apply.
- **FR-007**: The proposal MUST list each applied Control and NFR by title, or say that no Control or NFR applies. The accepted list MUST be saved with the feature.
- **FR-008**: A Control or NFR MUST win a disagreement with a coding standard, and the reply MUST name the standard that gave way. When two Controls disagree, or two NFRs disagree, the earlier catalog row MUST be applied. When a Control and an NFR disagree, the Control MUST be applied. The proposal MUST still be shown, and it MUST name the title that was applied and the title that gave way. When no correction meets a Control or NFR for this action, Highway MUST show no proposal, MUST name it, and MUST return to the suggestions.
- **FR-009**: An edit that would break a listed Control or NFR MUST NOT be applied. The reply MUST name it and point to `/highway-controls` or `/highway-nfrs`. Coding MUST read every listed Control and NFR before writing a task's files, and the files MUST abide by them. Codify MUST NOT create, change, or remove a Control or NFR.
- **FR-010**: After acceptance and any title change, Highway MUST save the accepted proposal and write `plan.md` beside it. The task list MUST NOT be written yet. The feature MUST be the open feature.
- **FR-011**: The plan MUST hold stories, edge cases, and functional requirements. Each proposal task's outcome MUST be a story, including when that outcome is the task, so a review of the plan is the whole plan. The plan MUST copy no scope, method, standards, or files. A functional requirement MUST come from the accepted proposal, a Control, an NFR, or a coding standard. Each applied Control or NFR MUST name the story that carries it. A decision MUST be recorded only when a choice remains, with what was rejected. A data shape MUST be included only when the feature has state. An interface shape MUST be included only when the proposal names an endpoint, a file format, or a command.
- **FR-012**: The check MUST run as part of writing the plan. It MUST resolve anything the accepted proposal, the standards, the Controls, the NFRs, or the implementation record can answer, and MUST correct a contradiction with the accepted proposal. It MUST ask the person only when the answer changes a story and nothing accepted decides it, one question at a time, up to five, and MUST write each answer into the plan. When none qualify, the menu MUST appear and the check MUST NOT be mentioned. When more than five qualify, the five that change the most stories MUST be asked and each remaining one MUST be recorded as an assumption.
- **FR-013**: The menu MUST read `The plan is complete for feature <number>-<action>.` followed by **Would you like to:**, `1. Review the plan?`, and `2. Continue to code the solution?`
- **FR-014**: A review MUST write nothing and MUST return to the menu. A stated edit MUST regenerate the plan and MUST run the check again.
- **FR-015**: Continue MUST write the task list ordered by story. Each heading MUST name how it is tested on its own. Each task MUST name its file. Every proposal task MUST have a line, under the story it delivers or, when it delivers none, under a heading taken from that task. A line that names work the proposal does not list MUST be left out. The list MUST be checked against the plan before the first file is written, and that check MUST stop only for a question the person still has to answer. Coding then follows the task list.
- **FR-016**: Returning to an open feature that has a plan and no task list MUST return to the menu. Returning to a feature whose task list has an open task MUST resume coding at that task. A declined proposal MUST write no plan and no task list.
- **FR-017**: Each addition to `highway-codify` MUST be an ordered instruction: what to read, which condition applies, and what to do next. A decision that does not fit an existing step MUST be its own step. A step MUST NOT explain why the plan, the Controls, or the wording exist. A step MUST NOT say should, consider, prefer, usually, or where appropriate. No step MAY exceed 400 words, excluding its heading. The skill body MUST NOT gain the keywords MUST or SHOULD.

### Key Entities

- **Proposal block**: What the person accepts. It gains a new heading and one closing sentence.
- **Building message**: One acknowledgment when the person continues, before the task list is written.
- **Feature plan**: The stories, edge cases, functional requirements, and remaining decisions written beside the accepted proposal. It does not restate the proposal.
- **Completion message**: The close after every task is done. Its **Questions?** sentence changes.
- **Applied Controls and NFRs**: The active Controls and NFRs that cover this feature, listed on the proposal, saved with the feature, and read when each task is coded.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every shown proposal has the codify feature heading and ends with the specification sentence.
- **SC-002**: Each accepted proposal shows the building message exactly once, and a declined or resumed run shows it zero times.
- **SC-003**: The completion message contains the new **Questions?** sentence and neither of the two old sentences.
- **SC-004**: The full check suite passes with the same passing count as before, plus any new check this feature adds.
- **SC-005**: Every proposal lists its applied Controls and NFRs, or says none applies. No accepted feature breaks a Control or NFR it listed.
- **SC-006**: An edit that would break a listed Control or NFR is applied zero times. Every proposal that resolved a disagreement between Controls or NFRs names the title that was applied and the title that gave way.
- **SC-007**: Every accepted proposal has a plan beside it and no task list until the person continues. The menu offers exactly those two choices.
- **SC-008**: A plan asks the person zero questions that accepted material already answers, and at most five that it does not.
- **SC-009**: Every added or changed step is an ordered instruction of at most 400 words, and none explains why the plan, the Controls, or the wording exist.

## Assumptions

- "Before creating the tasks" means when the person continues, after the plan and any questions, and before the task list is written.
- The plan is `plan.md` in the feature directory, beside the accepted proposal. The task list remains the feature's task file and is ordered by story.
- The proposal still asks **What would you add, correct, or remove?** and `If this is accurate, just say so.` The new sentence follows them.
- **Questions?** stays bold, as it is today.
- The building message describes the activity the person is waiting on. It is not an internal stage.
- The Controls and NFRs check runs before the proposal, beside the coding standards and vendor documentation checks. Its results are named before the proposal and are not saved, apart from the accepted list.
- Controls and NFRs outrank coding standards because they are the organization's accepted obligations, and standards say how code is written. The person's edit does not override them. Changing one belongs to `/highway-controls` or `/highway-nfrs`.
- The catalogs are `library/governance/controls.md` and `library/governance/nfrs.md`, each with one record per active entry.
- The proposal gains a list, edits can now be refused, the saved feature gains a field, and acceptance no longer writes the task list. Those changes narrow existing behavior, so `highway-codify` moves from `10.0.0` to `11.0.0`. The feature record template takes a MAJOR bump, and the plan template is new.
- Checks that require the old heading or the old catalog sentence are updated to the new text.
- New skill text follows the existing step style: a condition, then the action. The 400-word count excludes the step heading. The words MUST and SHOULD stay out of the skill body, so a normative rule is written as an instruction.
