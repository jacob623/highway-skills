# Feature Specification: Codify Coding Standards and Task List

**Feature Branch**: `201-codify-coding-standards`

**Created**: 2026-10-31

**Status**: Draft

**Input**: User description: "Create a catalog the model can reference for coding standards. Coding standards could be for Terraform, Python, Java, SonataFlow, Golang, and others, and each standard is its own file. Store the catalog and the standards in library/coding-standards/. In highway-codify, create a task list before coding, similar to how the speckit-tasks skill does. Store the task list in the related codify folder as codify-tasks.md. Read the coding standards catalog, create the tasks based on the coding standards, and direct the model to the relevant coding standards in each task. Code from the task list. Mark each task complete as it is completed."

## Clarifications

### Session 2026-10-31

- Q: Which coding standards does this feature provide? → A: The catalog plus one sample standard that shows the expected shape.
- Q: Does the person review the task list before coding starts? → A: Coding starts immediately after the task list is written. The accepted proposal is the only approval.
- Q: Should the task list include tasks that test or check the code, and if so, when? → A: Add a test task for a file only when its coding standard asks for tests.
- Q: When codify cannot finish a task, should it stop at that task or skip it and continue with tasks that do not depend on it? → A: Stop at that task, leave it and every later task open, and say what blocked it.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Find the coding standard for a technology (Priority: P1)

A maintainer keeps one coding standard per technology in one library folder. One catalog lists every standard with its title, the technology it covers, a short summary, and where the file is. Codify reads the catalog to learn which standards exist, then opens only the ones that apply.

**Why this priority**: The tasks cannot point to a standard that cannot be found. The catalog is the single place codify looks.

**Independent Test**: Read the catalog. Each row names one technology and one standard file, and each listed file exists in the same folder. A technology with no row has no standard.

**Acceptance Scenarios**:

1. **Given** the coding standards folder, **When** the catalog is read, **Then** it lists each standard once with its title, the technology it covers, a one-sentence summary, and the file path.
2. **Given** a catalog row, **When** its path is followed, **Then** the standard file exists in the coding standards folder and covers only that technology.
3. **Given** a new standard file is added, **When** the catalog is updated, **Then** the new standard has one row and no other row changes.
4. **Given** a technology with no row, **When** codify looks for its standard, **Then** it finds none and does not invent one.
5. **Given** a new installation, **When** the coding standards folder is read, **Then** it contains the catalog and one sample standard, and the catalog has one row for that sample.

---

### User Story 2 - Get a task list before any code is written (Priority: P1)

After the person accepts the automation proposal, codify writes an ordered task list in that automation's folder before writing any code. Each task is one small piece of work for one component. Tasks are numbered, ordered so that what a task depends on comes first, and each names the file it produces. A task that produces code for a technology with a standard points to that standard.

**Why this priority**: A visible plan lets the person see what will be built and lets each piece of code follow the organization's standards.

**Independent Test**: Accept one proposal whose components use two technologies, one with a standard and one without. Open the task list. Every task names its component and its file. Each task for the first technology points to that standard. Each task for the second says no standard applies. No code exists before the task list.

**Acceptance Scenarios**:

1. **Given** an accepted proposal, **When** codify continues, **Then** the task list is written in the automation's folder before any component file is written.
2. **Given** the task list, **When** it is read, **Then** each task has a number, an open checkbox, one component, the file it produces, and a short description of the work.
3. **Given** a task that produces code for a technology in the catalog, **When** it is read, **Then** it names that standard's file path.
4. **Given** a task that produces code for a technology not in the catalog, **When** it is read, **Then** it says no coding standard applies.
5. **Given** two tasks where one depends on the other, **When** the list is read, **Then** the task depended on comes first.
6. **Given** the proposal names a component, **When** the list is read, **Then** at least one task produces that component's files. No task produces files for a component the proposal does not name.
7. **Given** the task list, **When** it is read, **Then** it includes a task for the folder's README, so the Implement and Use parts are produced from the list.
8. **Given** the task list is written, **When** codify continues, **Then** it starts coding without asking the person to accept the task list.
9. **Given** a file whose coding standard asks for tests, **When** the list is read, **Then** a test task for that file follows the task that produces it and names the same standard. A file whose standard does not ask for tests, or that has no standard, has no test task.

---

### User Story 3 - Code from the task list (Priority: P1)

Codify writes the code by working through the task list in order. For each task it reads the standard the task points to, writes that task's files in line with the standard, and marks the task complete before starting the next one. When it finishes, every task is complete and the automation has still not been run.

**Why this priority**: The task list only matters if the code is produced from it and the standards are applied at the point the code is written.

**Independent Test**: Accept one proposal with three tasks. Watch the task list as codify works. Tasks are completed in order, each is marked complete before the next begins, and the files each task names exist when its checkbox is marked. The automation has not been run.

**Acceptance Scenarios**:

1. **Given** a task list, **When** codify codes, **Then** it completes tasks in list order and does not start a task before the tasks it depends on are complete.
2. **Given** a task that points to a standard, **When** codify writes that task's files, **Then** it reads that standard first and the files follow it.
3. **Given** a task is finished, **When** the task list is read, **Then** that task's checkbox is marked complete before the next task begins.
4. **Given** every task is complete, **When** codify closes, **Then** it says the automation was written and was not run.
5. **Given** coding stops before the last task, **When** the task list is read, **Then** finished tasks are marked complete and unfinished tasks remain open.
6. **Given** a later codify run for the same automation finds open tasks, **When** it continues, **Then** it resumes at the first open task and does not redo completed tasks.
7. **Given** codify cannot finish a task, **When** it stops, **Then** that task and every later task stay open, no later task is started, and the close names the blocked task and what blocked it.

---

### Edge Cases

- The coding standards catalog is missing. Codify still writes the task list, every task says no coding standard applies, and the close says no catalog was found.
- A catalog row names a file that does not exist. That standard is treated as unavailable, tasks for that technology say no coding standard applies, and the close names the missing file.
- One technology has two catalog rows. Codify uses the first row, and the close names the duplicate.
- A component uses more than one technology. Each task covers one file, and each task points to the standard for that file's technology.
- A standard conflicts with the accepted architecture or implementation. The accepted architecture and implementation decide what is built. The standard decides how the code is written.
- The proposal names no component. The task list still contains the README task, and no component folder is created.
- The automation already exists and every task is complete. Codify reuses the existing record, writes no new task, and closes.
- The person stops partway through coding. Completed tasks stay complete, and nothing that a completed task wrote is removed.
- A task cannot be finished, for example because its standard cannot be met with the accepted means. Codify stops at that task, leaves it and every later task open, and names what blocked it.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The library MUST contain one coding standards folder at `library/coding-standards/`. It MUST hold one catalog and one file per coding standard.
- **FR-002**: Each coding standard MUST cover exactly one technology, such as one language, one infrastructure tool, or one workflow format.
- **FR-003**: The catalog MUST list each standard once, with its title, the technology it covers, a one-sentence summary, and the path to its file.
- **FR-004**: The coding standards folder MUST ship with the catalog and exactly one sample standard for one of the technologies named in the request. The sample MUST show the shape every standard follows, and the catalog MUST have one row for it.
- **FR-005**: After the person accepts the automation proposal, `highway-codify` MUST write a task list at `code/[ID]/codify-tasks.md` before it writes any component file or the README.
- **FR-006**: To create the task list, `highway-codify` MUST read the coding standards catalog, then read each standard that applies to a file the tasks will produce.
- **FR-007**: Each task MUST have a sequential number, an open checkbox, one component (or the README), the path of the file it produces, and a one-line description of the work.
- **FR-008**: A task that produces a file for a technology in the catalog MUST name that standard's file path. A task for a technology with no available standard MUST say no coding standard applies.
- **FR-009**: Tasks MUST be ordered so that each task comes after every task it depends on. Every component the accepted proposal names MUST have at least one task. No task MAY produce files for a component the proposal does not name.
- **FR-010**: The task list MUST include one task that produces `README.md` with its Implement and Use parts.
- **FR-010a**: When a file's coding standard asks for tests, the task list MUST include one test task for that file. It comes after the task that produces the file and names the same standard. No test task MAY be added for a file whose standard does not ask for tests or that has no standard.
- **FR-011**: Coding MUST start immediately after the task list is written. `highway-codify` MUST NOT ask the person to accept the task list. The accepted proposal is the only approval.
- **FR-012**: `highway-codify` MUST write code by completing tasks in list order. Before writing a task's files, it MUST read the standard that task names, and the files MUST follow that standard.
- **FR-013**: `highway-codify` MUST mark each task complete in `codify-tasks.md` after that task's files are written and before the next task begins.
- **FR-014**: When coding stops before the last task, completed tasks MUST stay marked and their files MUST stay in place. A later run for the same automation MUST resume at the first open task.
- **FR-014a**: When codify cannot finish a task, it MUST stop at that task. That task and every later task MUST stay open, and no later task MAY be started in that run. The close MUST name the blocked task and what blocked it.
- **FR-015**: The accepted architecture and implementation MUST decide what is built. A coding standard MUST decide only how the code is written.
- **FR-016**: Writing the task list and the code MUST NOT run the automation, MUST NOT change the implementation, its architecture, its decision, or the request, and MUST NOT change any coding standard or the catalog.
- **FR-017**: The close MUST name the task list, say whether every task is complete, name any blocked task, name any missing catalog, missing standard file, or duplicate technology row, and say the automation was not run.
- **FR-018**: The task list and the coding steps MUST be imperative steps in `highway-codify`. The system MUST NOT add a separate skill for tasks or for coding.

### Key Entities

- **Coding standard**: One file of rules for writing code in one technology. It is read, never changed by codify.
- **Coding standards catalog**: The one list of every coding standard, with title, technology, summary, and path.
- **Task list**: The ordered, numbered list of work for one accepted automation, stored as `codify-tasks.md` in that automation's folder.
- **Task**: One piece of work that produces one file for one component or the README. It names the standard that applies, or says none applies, and it is open or complete.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every standard file in the coding standards folder has exactly 1 catalog row, and every catalog row points to 1 file in that folder.
- **SC-002**: For an accepted proposal, 0 component files exist before the task list is written.
- **SC-003**: 100% of tasks that produce a file for a technology in the catalog name that standard's path. 100% of the other tasks say no coding standard applies.
- **SC-004**: Every component the accepted proposal names has at least 1 task, and 0 tasks produce files for components the proposal does not name.
- **SC-005**: After a complete run, 100% of tasks are marked complete and every file the tasks name exists.
- **SC-006**: A run stopped after task 2 of 4 leaves 2 tasks complete and 2 open. The next run completes the remaining 2 tasks and redoes 0 tasks.
- **SC-007**: A complete run runs the automation 0 times and changes the implementation, architecture, decision, request, coding standards, and catalog in 0 places.
- **SC-008**: A new installation contains 1 coding standards catalog with 1 row and 1 sample standard.
- **SC-009**: Between accepting the proposal and the first task being marked complete, the person is asked 0 questions.

## Assumptions

- `library/coding-standards/` is at the repository root, beside the organization's other library content such as `library/governance/controls/`. It is organization content, not Highway framework content. The catalog lives in that folder.
- Coding standards are maintained by hand in this feature. No Highway skill writes or edits them.
- Planning chooses which technology the sample standard covers. The organization replaces or extends it and adds a catalog row for each new standard.
- A technology matches a catalog row by the technology the file is written in, such as Terraform for a `.tf` file. Codify does not guess a standard for an unlisted technology.
- The task list follows the speckit-tasks style: numbered tasks with checkboxes, file paths, and dependency order. It is shaped by a Highway output template so every task list has the same structure.
- The saved proposal, the README, the component folders, and the catalog of automations keep their current shape. This feature adds the task list and changes how the code is produced.
- One task produces one file. A component with several files has several tasks. A test task produces the test file for one file.
- The sample standard shows how a standard states whether it asks for tests.
- Today's all-or-nothing write still applies to the saved proposal, the task list, and the catalog of automations. Code written by completed tasks stays in place when coding stops, because the task list records what is done.
- The request close, the suggestion list, and the proposal are unchanged.
