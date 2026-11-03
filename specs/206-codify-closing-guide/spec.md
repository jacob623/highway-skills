# Feature Specification: Codify Closing Guide

**Feature Branch**: `206-codify-closing-guide`

**Created**: 2026-11-02

**Status**: Draft

**Input**: User description: "highway-codify updates. Replace Implement in README.md with Setup Instructions. Replace Use with User Guide. Once the model has completed all of the tasks, and in closing to the user of the highway-codify skill, state: The codify stage is complete. This code is now part of your Highway knowledge base... The files can be found here: [relative path to files]. If you'd like to review the files together, just say so. Setup and Usage Instructions can be found here: [relative path to README.md]. If you'd like to review the instructions together, just say so. Questions? If you have questions in the future, just ask highway to show your code catalog... Where would you like to go next? Run /highway-help to explore what Highway can help you do."

## Clarifications

### Session 2026-11-02

- Q: When someone later asks Highway to show their code catalog, what should happen? → A: Codify gets a `catalog` entry (`/highway-codify catalog`, or a plain request to show the code catalog) that lists each automation's title, the implementation it automates, and whether every task is done, then asks which one to discuss. It writes nothing.
- Q: When the code catalog has more than five accepted automations, how should the list appear? → A: Show the five most recent, numbered, newest first, say how many more exist, and ask the person to name or describe any automation not shown.
- Q: How should codify know which automations are the most recent? → A: Catalog rows are ordered by acceptance. Each new automation is appended as the last row, and the view takes the last five accepted rows, newest first.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Read a README with plain section names (Priority: P1)

A person opens the README codify wrote for an automation. The first part is headed "Setup Instructions" and says what is put in place, where it goes, and how to enable it. The second part is headed "User Guide" and says how a non-technical person starts the automation, what they provide, and what they receive.

**Why this priority**: "Implement" and "Use" read as instructions to the reader rather than as names for what the sections contain. The README is what a non-technical person opens first.

**Independent Test**: Finish an automation and open its README. It has exactly two parts, "Setup Instructions" then "User Guide", and neither "Implement" nor "Use" is a heading.

**Acceptance Scenarios**:

1. **Given** every task is done, **When** the README is opened, **Then** its first heading is "Setup Instructions" and its second is "User Guide", in that order.
2. **Given** that README, **When** Setup Instructions is read, **Then** it says what is put in place, where it goes, and how to enable it, including the preparation this automation needs.
3. **Given** that README, **When** User Guide is read, **Then** it says how a non-technical person starts this one automation, what they provide, and what they receive, without asking them to edit the generated files or read the implementation record.
4. **Given** that README, **When** its headings are read, **Then** neither "Implement" nor "Use" appears as a heading.

---

### User Story 2 - Close with where the work is and what to do next (Priority: P1)

When codify finishes every task, the person sees a closing message that says the codify stage is complete, that the code is now part of their Highway knowledge base, where the files are, where the setup and usage instructions are, how to ask about the code later, and where to go next.

**Why this priority**: The current close lists record paths. It does not say where the generated files are, where the instructions are, or what the person can do next.

**Independent Test**: Finish every task of an automation. The closing message matches the stated text, with the automation's folder in place of the files path and its README in place of the instructions path.

**Acceptance Scenarios**:

1. **Given** every task is done, **When** codify closes, **Then** the message begins with the heading "The codify stage is complete."
2. **Given** that close, **When** it is read, **Then** it says the code is now part of the person's Highway knowledge base and remains available for future context, and that Highway can help them understand, configure, extend, troubleshoot, and use any code it helped create.
3. **Given** that close, **When** the line after the knowledge-base paragraph is read, **Then** it says "The automation was not run."
4. **Given** that close, **When** the files line is read, **Then** it shows the automation's folder as a relative path, followed by "If you'd like to review the files together, just say so."
5. **Given** that close, **When** the instructions line is read, **Then** it shows the README's relative path, followed by "If you'd like to review the instructions together, just say so."
6. **Given** that close, **When** the questions part is read, **Then** it says to ask Highway to show the code catalog in the future.
7. **Given** that close, **When** the last part is read, **Then** it asks "Where would you like to go next?" and says "Run /highway-help to explore what Highway can help you do."

---

### User Story 3 - Keep the stopped-task close for unfinished work (Priority: P2)

When a task cannot be finished, codify stops at that task. The person is told which task stopped and why, and that the next run starts there. The completion message is not shown, because the codify stage is not complete.

**Why this priority**: Saying the stage is complete when a task is still open would be false.

**Independent Test**: Stop an automation at its second task. The close names that task and its reason. It does not say "The codify stage is complete."

**Acceptance Scenarios**:

1. **Given** a task could not be finished, **When** codify closes, **Then** it names that task, the reason, and that the next run starts there.
2. **Given** a task could not be finished, **When** codify closes, **Then** "The codify stage is complete." does not appear.
3. **Given** a later run finishes every remaining task, **When** codify closes, **Then** the completion message appears.

---

### User Story 4 - Show the code catalog on request (Priority: P2)

Later, the person runs `/highway-codify catalog` or asks Highway to show their code catalog. Codify lists up to five of the most recent automations, newest first, each by title with the implementation it automates and whether every task is done. When more exist, it says how many more. It asks which one they want to discuss. It writes nothing.

**Why this priority**: The completion message tells the person they can ask for this. Without a defined path, the answer depends on whatever the agent improvises.

**Independent Test**: Accept seven automations in order, the last one stopped at a task. Run `/highway-codify catalog`. The seventh through third appear, numbered 1 to 5, newest first, followed by a line saying 2 more exist. The first line names its first open task. Nothing is written.

**Acceptance Scenarios**:

1. **Given** one to five accepted automations exist, **When** the person runs `/highway-codify catalog` or asks to show the code catalog, **Then** each appears as a numbered line, newest first, with its title, its implementation title, and whether every task is done.
2. **Given** more than five accepted automations exist, **When** the catalog is requested, **Then** the five most recently accepted appear, numbered and newest first, followed by how many more exist.
3. **Given** that list, **When** it is shown, **Then** no id is used as a label and removed automations do not appear.
4. **Given** that list, **When** it ends, **Then** codify asks which automation the person would like to discuss. When some are not shown, it says they can name or describe any automation.
5. **Given** the person picks a number or names an accepted automation, shown or not, **When** codify answers, **Then** it shows that automation's files path and README path and invites their question.
6. **Given** no accepted automation exists, **When** the catalog is requested, **Then** codify says no automation has been created yet.
7. **Given** a new automation is accepted, **When** the catalog is written, **Then** its row is appended as the last row.
8. **Given** any catalog request, **When** it finishes, **Then** no file is written and no automation, task, or implementation is started or changed.

---

### Edge Cases

- A coding standards catalog was absent, a named standard was missing, or a technology had two catalog rows. The matching notice still appears, before the completion message.
- The README task is the last task. The completion message appears only after the README exists, so its path is real.
- An automation resumed from an open task closes with the completion message when its last open task finishes.
- An automation that has one Provider file and no task files still shows its folder as the files path.
- Declining a proposal or a failed write never reaches the close. No completion message appears.
- In the catalog view, a chosen automation whose README task is still open shows its files path and says its instructions are not written yet. It shows no README path.
- In the catalog view, a description that matches no accepted automation says so and asks again. A description that matches more than one lists those matches, newest first, at most five.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The README MUST have two parts in this order, headed "Setup Instructions" and "User Guide".
- **FR-002**: Setup Instructions MUST say what is put in place, where it goes, and how to enable it, including the preparation this automation needs.
- **FR-003**: User Guide MUST say how a non-technical person starts this one automation, what they provide, and what they receive. It MUST NOT ask that person to edit the generated files or read the implementation record.
- **FR-004**: "Implement" and "Use" MUST NOT be README headings.
- **FR-005**: When every task is done, the close MUST be the stated completion message, in this order: the heading, the knowledge-base paragraph, "The automation was not run.", the files path and review offer, the instructions path and review offer, the questions part, and the next-step part.
- **FR-006**: The files path MUST be the automation's folder, relative to the repository root. The instructions path MUST be that folder's README, relative to the repository root.
- **FR-007**: When a task could not be finished, the close MUST name that task, its reason, and that the next run starts there. It MUST NOT show the completion message.
- **FR-008**: Coding-standard notices that apply MUST still be shown, before the completion message or the stopped-task close.
- **FR-009**: The completion message MUST include "The automation was not run." as its own line, right after the knowledge-base paragraph and before the files path. The stopped-task close MUST keep its own "The automation was not run." line.
- **FR-010**: The saved proposal and the README template MUST use the new headings, so a README written later follows the same names.
- **FR-011**: Codify MUST recognize a catalog request: the invocation `catalog`, or a request to show the code catalog. It MUST handle that request before resuming a task list or selecting an implementation.
- **FR-012**: A catalog request MUST list at most five accepted automations: the last five accepted rows of the catalog, numbered from 1, newest first. Each line MUST show the automation title, its implementation title, and either that every task is done or its first open task. It MUST NOT use an id as a label and MUST NOT list removed automations.
- **FR-013**: When more than five accepted automations exist, the list MUST be followed by how many more exist. The list MUST end by asking which automation the person would like to discuss. When some are not shown, it MUST say they can name or describe any automation.
- **FR-014**: When the person picks a number or names an accepted automation, shown or not, codify MUST show its files path and README path and invite their question. When no accepted automation exists, codify MUST say no automation has been created yet.
- **FR-015**: Catalog rows MUST be ordered by acceptance. A newly accepted automation MUST be appended as the last row. A row whose status changes keeps its position.
- **FR-016**: A catalog request MUST write nothing and MUST NOT start, resume, or change an automation, task, or implementation.

### Key Entities

- **README**: The guide codify writes last for one automation. Its parts are Setup Instructions and User Guide.
- **Completion message**: The close shown only when every task is done. It names the files path and the instructions path, and points to the code catalog and to `/highway-help`.
- **Stopped-task close**: The close shown when a task could not be finished. It names that task and its reason.
- **Code catalog view**: The read-only list a catalog request shows. It holds up to five of the most recent automations, newest first. Each line has an automation title, its implementation title, and whether every task is done.
- **Automations catalog**: `code/code.md`. Its rows are now ordered by acceptance, not by Automation ID.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A finished README has 2 parts named "Setup Instructions" and "User Guide", and "Implement" or "Use" as a heading 0 times.
- **SC-002**: A run that finishes every task shows "The codify stage is complete." 1 time, the files path 1 time, and the README path 1 time.
- **SC-003**: A run that stops at a task shows "The codify stage is complete." 0 times and names the stopped task 1 time.
- **SC-004**: The completion message ends by pointing to `/highway-help` 1 time.
- **SC-005**: Every close, complete or stopped, says "The automation was not run." 1 time.
- **SC-006**: A catalog request lists at most 5 automations, all of them the most recently accepted, and 0 removed ones. It writes 0 files.
- **SC-007**: With more than 5 accepted automations, the view states the exact count not shown.

## Assumptions

- The completion message replaces the current close only when every task is done. The stopped-task close keeps its current content.
- "[relative path to files]" is the automation folder, `code/[ID]/`. "[relative path to README.md]" is `code/[ID]/README.md`.
- The record and task-list paths no longer appear in the completion message. The files path leads to them.
- "Ask highway to show your code catalog" is handled by the codify catalog request. The catalog is `code/code.md`, and task status comes from each automation's task list.
- `/highway-help` already exists and lists every skill.
- "Setup and Usage Instructions" names the README as a whole. The README's own headings are Setup Instructions and User Guide.
- Existing READMEs are not rewritten. Backward compatibility is not required.
- An existing catalog sorted by Automation ID is treated as if its rows were in acceptance order. It is not reordered.
