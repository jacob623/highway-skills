# Feature Specification: Codify File Layout

**Feature Branch**: `208-codify-file-layout`

**Created**: 2026-11-03

**Status**: Draft

**Input**: User description: "Update codify-tasks and highway-codify-config so a coding standard carries a mandatory file and folder structure and a tests section. Codify places each automation's files from that structure. Paths shown to the person are relative to the automation folder. The executor and task-N folders are removed. Remove the seeded Terraform standard and the seeded coding standards catalog. The skill that writes the first coding standard creates the catalog then."

## Clarifications

### Session 2026-11-03

- Q: When a pipeline calls a Terraform module, should those be two coding standards with their own folders, or should the pipeline standard inherit the Terraform standard? → A: Separate standards and folders. Inheritance only places a language's file names inside the platform folder.
- Q: When a coding standard lists several files, how should the task list be organized? → A: The same way Speckit organizes work. Each proposal task is a feature. Its lines are grouped together and name the files that feature creates or changes. The file and folder structure is the layout used to place a new file. Coding a line reads that layout and the files the line names. When tests are required, the feature includes its test. The structure is not copied into the task list as one line per path.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Accept a file and folder structure with each coding standard (Priority: P1)

The person adds or updates a coding standard in `/highway-codify-config`. The proposal includes a file and folder structure and a tests section, both required before it can be accepted. Every path is relative to the automation folder. Accepting stores both in the standard. The next automation that uses the standard places its files there.

**Why this priority**: The structure is the source of every later path. Without it, codify still has to invent folders.

**Independent Test**: Add a Terraform standard. The proposal shows **File and Folder Structure:** as relative paths, then **Tests:**. Remove the structure and try to accept. Acceptance stays closed. Restore it and accept. The standard file contains the structure and the tests section.

**Acceptance Scenarios**:

1. **Given** the person adds or updates a coding standard, **When** the proposal appears, **Then** it shows **File and Folder Structure:** as an ordered list of paths relative to the automation folder, and **Tests:** either as "required" with one sentence and one of those paths, or as "not required".
2. **Given** no standard exists yet, **When** Highway proposes one, **Then** the structure comes from that platform's current documentation, the same way the rules come from current best practices, and the person can correct it.
3. **Given** a standard already exists, **When** the proposal appears, **Then** the structure and the tests section start from the current standard.
4. **Given** the structure is missing or empty, **When** the person accepts, **Then** nothing is written and the proposal stays open, saying a file and folder structure is needed.
5. **Given** tests are required, **When** the test path is not one of the structure's paths, **Then** acceptance stays closed until the path is in the structure or tests are marked not required.
6. **Given** the person accepts a complete proposal, **When** the write succeeds, **Then** the standard file holds the structure and the tests section, and the catalog row is unchanged apart from the fields it already stores.
7. **Given** any path in the proposal, **When** it is shown, **Then** it does not begin with the automation folder. A Terraform structure shows paths such as `terraform/modules/<module>/main.tf`.

---

### User Story 2 - Place an automation's files from its standards (Priority: P1)

The person accepts a codify proposal. The proposal's tasks are the features, in delivery order. The task list groups each feature's lines together. A line names the relative paths that line creates or changes. The coding standard's file and folder structure is the layout a new file is placed in. It is not turned into a line for every path it lists. A pipeline step changes the workflow file. Adding a module creates the module files that feature needs. Coding a line reads the layout and the files that line names, and does not read the rest of the automation. No file is placed in `executor/` or `task-N/`.

**Why this priority**: This is the result the person copies or deploys. A feature can be coded from its own lines. The layout tells a new file where to go.

**Independent Test**: Accept an automation whose tasks are three pipeline steps, with a standard whose structure is `.github/workflows/<name>.yml` plus other paths the steps do not deliver. The task list has three feature groups, and each names that workflow path. The other paths have no line. The written file is that workflow. No `executor/` or `task-N/` folder exists.

**Acceptance Scenarios**:

1. **Given** a feature whose standard has a structure, **When** the task list is written, **Then** the feature's lines name only the files that feature creates or changes. Each path comes from the structure, with placeholders such as `<module>` and `<name>` filled from the feature. A path the feature does not deliver has no line.
2. **Given** several features that are steps of one workflow, **When** the task list is written, **Then** each feature names that workflow path.
3. **Given** a feature that introduces a Terraform module, **When** the task list is written, **Then** its lines name the module files that feature creates, placed by the Terraform structure.
4. **Given** an accepted task list, **When** a line is coded, **Then** its files are written inside the automation folder at their relative paths. Coding reads the layout and the files that line names, and does not read the other files in the automation.
5. **Given** any task line the person sees, **When** it names a file, **Then** the path is relative. The automation folder appears once, in the completion message that says where the automation lives.
6. **Given** the task list, **When** it is written, **Then** it contains no `executor/` path and no `task-N/` path.
7. **Given** the person corrects a task's file path on the proposal, **When** they accept, **Then** that automation uses the corrected path, and the coding standard is not changed.
8. **Given** the README task, **When** it is written, **Then** its path is `README.md`.

---

### User Story 3 - Combine standards without mixing their files (Priority: P2)

A platform standard owns its component's folder. A language standard it inherits from supplies file names inside that folder when the platform standard does not name them. The earlier standard wins when both name a file. A feature with no standard names its files at the automation root, taken from the feature.

**Why this priority**: The first two stories cover one standard and one automation. This story covers inheritance, several components, and a task that has no standard.

**Independent Test**: With a Kubernetes standard that inherits from a YAML standard, the Kubernetes files stay in the Kubernetes folder, and a YAML file name is used there only where the Kubernetes standard does not already name it. Separately, a pipeline that calls one Terraform module keeps the workflow in the pipeline folder and the module in the Terraform folder. The pipeline standard does not inherit the Terraform standard. A feature with no standard names its files at the automation root.

**Acceptance Scenarios**:

1. **Given** a platform standard and a language standard it inherits from, **When** both describe files, **Then** the platform standard's folder is the component root, and the language standard's file names sit inside it only where the platform standard does not already name them.
2. **Given** a pipeline that calls a Terraform module, **When** the task list is written, **Then** the workflow uses the pipeline standard's structure, the module uses the Terraform standard's structure, and neither standard inherits from the other.
3. **Given** two standards on a task that name the same file, **When** the path is chosen, **Then** the earlier standard in the task's list wins.
4. **Given** a feature whose list says no coding standard applies, **When** the task list is written, **Then** its lines name the files that feature delivers as relative names at the automation root, and the lines say no coding standard applies.
5. **Given** two standards that name the same relative path and neither inherits from the other, **When** conflicts are assessed, **Then** that overlap is a conflict, quoting both paths and naming both standards.
6. **Given** a listed standard whose file has no file and folder structure, **When** codify proposes a task that uses it, **Then** the task is treated as having no structure for placement, and the proposal says the standard has no file and folder structure and points to `/highway-codify-config`.

---

### User Story 4 - Start with no coding standards (Priority: P1)

A project ships with no coding standards catalog and no Terraform standard. The person sees an empty list until they accept a standard. The acceptance that writes the first standard also creates the catalog, with that standard as its only row. `highway-codify` never creates the catalog.

**Why this priority**: A seeded Terraform standard decides file placement before the organization has accepted one. The catalog should appear only when the person has accepted a standard.

**Independent Test**: Open coding standards in a project that has not accepted one. Both `library/coding-standards/coding-standards.md` and `library/coding-standards/terraform.md` are absent, and the reply says no coding standard is listed yet. Accept a Terraform standard. The standard file and the catalog now exist, and the catalog has that one row.

**Acceptance Scenarios**:

1. **Given** a project that has not accepted a coding standard, **When** the person opens View or Update Coding Standards, **Then** `library/coding-standards/coding-standards.md` and `library/coding-standards/terraform.md` are absent, and Highway says no coding standard is listed yet.
2. **Given** no catalog, **When** the person accepts the first coding standard, **Then** the skill writes the standard file and creates the catalog from its template, with that standard as the only row.
3. **Given** the standard file write fails, **When** acceptance ends, **Then** the catalog is not created.
4. **Given** the catalog already exists, **When** the person accepts another standard, **Then** the catalog gains that row and its other rows stay as they are.
5. **Given** no catalog, **When** `highway-codify` proposes an automation, **Then** every task says no coding standard applies, and codify does not create the catalog or a standard file.

---

### Edge Cases

- The person marks tests not required. The tests section says so, no test path is required, and codify adds no test task for that standard.
- Tests are required. The feature that delivers the behavior includes its test as its first line, using the test path in the structure. A feature that changes a file and does not change that behavior adds no second test line.
- A structure uses a placeholder the task never names. The proposal shows the placeholder still unfilled and asks the person to correct the path. Acceptance stays open until the path has no unfilled placeholder.
- The person corrects one automation's path. Later automations still use the standard's structure.
- A standard is removed from the catalog and later re-added. The re-add proposal starts from the existing file, including its structure.
- The seeded catalog and the seeded Terraform standard are removed. A project that already has its own catalog or standard files keeps them. This feature does not delete a standard the person accepted.
- An automation folder already has files from an older task list that used `executor/` or `task-N/`. This feature does not move them. New automations do not create those folders.
- Canceling a standard proposal writes nothing.

## Requirements *(mandatory)*

### Functional Requirements

**Coding standard**

- **FR-001**: A coding standard MUST include a file and folder structure: an ordered list of paths relative to the automation folder, covering the component root and the files in it. The standard proposal MUST show it as **File and Folder Structure:** and MUST refuse acceptance while it is missing or empty.
- **FR-002**: A coding standard MUST include a tests section, shown as **Tests:**. It is either "required", with one sentence on how tests are written and a path that appears in the structure, or "not required". Acceptance MUST stay closed while tests are required and the test path is outside the structure.
- **FR-003**: Every path in the structure, the tests section, the standard proposal, and the task list MUST be relative to the automation folder. None of them MAY begin with the automation folder or show `code/[ID]/`.
- **FR-004**: The structure MUST live in the standard file. It MUST NOT be a column of the coding standards catalog. File Patterns stay the way a file is matched to a standard.
- **FR-005**: When no standard exists, Highway MUST propose the structure from the platform's current documentation. When one exists, the proposal MUST start from it. The person's corrections MUST be what is stored.
- **FR-006**: The repository MUST NOT ship `library/coding-standards/coding-standards.md` or `library/coding-standards/terraform.md`. The skill that writes a coding standard MUST create the catalog, from its template, when the catalog is absent, and only after the standard file write succeeds. `highway-codify` MUST NOT create the catalog or a standard file.

**Task list and coding**

- **FR-007**: The file and folder structure MUST be the layout. A feature's lines MUST name the files that feature creates or changes, placed by that layout, with placeholders filled from the feature. The task list MUST NOT contain a line for a path in the structure that no feature delivers.
- **FR-008**: Each proposal task MUST be one feature. Its lines MUST be grouped together, in the proposal's delivery order. A line creates or changes the files it names. Several features MAY name the same path. A feature that only adds a step MUST name the existing file it changes. Coding a line MUST read the layout and the files that line names, and MUST NOT read the other files in the automation.
- **FR-009**: The task list and the written files MUST NOT use an `executor/` folder or a `task-N/` folder. Work tags on a line MAY still name the executor or the proposal task.
- **FR-010**: A correction to a file path on a codify proposal MUST apply to that automation only and MUST NOT change the coding standard.
- **FR-011**: The README task MUST name `README.md`. The completion message MUST still name the automation folder once, as the place the automation lives.
- **FR-012**: A feature with no coding standard MUST name the files it delivers as relative names at the automation root, taken from the feature, and MUST say no coding standard applies.
- **FR-013**: When a feature's standard says tests are required, that feature's first line MUST be the test for the behavior it delivers, using the test path from the structure. When the standard says tests are not required, the feature MUST NOT have a test line. A later feature that does not change that behavior MUST NOT add another test line.

**Inheritance and conflicts**

- **FR-014**: The platform standard MUST own the component root. File names from an inherited language standard MUST be used inside that root only where the platform standard does not name them. Where both name a file, the earlier standard on the task MUST win. A component an automation calls, such as a Terraform module called by a pipeline, MUST keep its own standard and its own folder. That relationship MUST NOT be recorded as Inherits From.
- **FR-015**: Two standards that name the same relative path, with neither inheriting from the other, MUST be reported as a conflict. The conflict MUST quote both paths and name both standards.
- **FR-016**: A listed standard with no file and folder structure MUST be treated as having no structure for placement. The proposal MUST say so and point to `/highway-codify-config`.

### Key Entities

- **File and folder structure**: The layout in one coding standard. It says where a new file of that kind goes. One standard describes one component. It is not the list of tasks.
- **Feature**: One proposal task. The task list groups that feature's lines together. Each line names the files it creates or changes.
- **Tests section**: The standard's statement that tests are required, with a path inside the structure, or that tests are not required. A required test belongs to the feature that delivers the behavior.
- **Task file path**: A relative path a feature's line creates or changes. It is placed by the standard, or named at the automation root when no standard applies, and it can be corrected for that automation.
- **Component**: The set of files a standard places together, such as one workflow, one agent project, one orchestrator flow, or one Terraform module.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of accepted coding standards contain a file and folder structure and a tests section. A proposal with either one missing is accepted 0 times.
- **SC-002**: 100% of the paths shown in a standard proposal and in a task list are relative. The text `code/[ID]/` appears 0 times in those paths.
- **SC-003**: An automation whose features are steps of one pipeline produces 1 workflow file, named by each of those features. Paths in the standard that no feature delivers produce 0 lines. The automation produces 0 `executor/` folders and 0 `task-N/` folders.
- **SC-004**: An automation that calls one Terraform module from two orchestration steps produces 1 module folder. The feature that adds the module names the files it creates. The two steps name the module. Coding one of those lines reads 0 files that belong to the other.
- **SC-005**: Correcting a path on one automation changes that automation and leaves the coding standard unchanged.
- **SC-006**: The same standard, used for 3 automations, proposes the same relative structure 3 times, with only the placeholders filled differently.
- **SC-007**: A project that has not accepted a coding standard contains 0 coding standards catalogs and 0 Terraform standards. The first accepted standard leaves exactly 1 catalog, with 1 row.

## Assumptions

- "highway-condify-config" in the request is `highway-codify-config`. `highway-codify` is in scope because it writes the task list and the files. `codify-tasks` is the task list template it writes.
- A path is relative to the automation folder. The skill joins the automation folder and that path when it writes. The person sees the relative path.
- One standard describes one component. ServiceNow, an orchestrator, and Terraform remain three structures, combined by the tasks that list them. Inherits From connects a platform standard to a language standard. It does not connect a caller, such as a pipeline, to a component it calls, such as a Terraform module.
- A path correction on a codify proposal is for that automation. Changing the organization's default is done in `highway-codify-config`.
- The task list follows the proposal's features the way Speckit follows user stories. A line is completable from the layout and the files it names. The development constitution decides when a Highway change is verified. It does not decide this breakdown.
- A line is tagged with the feature it belongs to. The README line is last. A file the provider needs that no feature writes is a line before the features. These tags do not decide the folder.
- The catalog template stays in Highway. It is used when the first standard is accepted, not shipped as the person's catalog.
- Removing the seeded files does not remove a catalog or a standard the person has already accepted in their own project.
- Backward compatibility is not required. Existing automation folders are not rewritten. Checks that expect the seeded catalog or the seeded Terraform standard are updated to expect their absence.
- A standard that already has rules and tests keeps them. This feature adds the structure and ties a required test to a path in it.
