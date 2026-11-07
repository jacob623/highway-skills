# Feature Specification: Establish From Record

**Feature Branch**: `223-establish-from-record`

**Created**: 2026-11-06

**Status**: Draft

**Input**: User description: "create a new spec for this implementation." The implementation is the agreed record of Deployed by, Managed by, and Language, and the platform kind saved on the platforms catalog. Deployed by and Managed by are the executors. The model breaks the work into tasks and may give a task its own platform or method. A coding standard for a platform in the platforms catalog proposes When to use as "[Platform] is used" and When not to use as "[Platform] is not used", and nothing else.

## Clarifications

### Session 2026-11-06

- Q: How should the model pre-select Deployed by and Managed by when the platforms catalog has more than one row? → A: Deployed by is the earliest pipeline, otherwise orchestrator, otherwise desired-state, otherwise agent. Managed by is the earliest self-service, otherwise agent, otherwise the Deployed by row.
- Q: What tasks should a run, change, or recover proposal contain? → A: Neither establish nor a later action has a fixed task list. The model keeps breaking the work into tasks and choosing each task's platform. Deployed by and Managed by are the executors. A task may use another platform or method, such as Helm, Terraform, or CloudFormation, within that executor.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The implementation records who deploys it, who runs it later, and its language (Priority: P1)

A person reviewing an implementation sees three values on the proposal and can replace any of them before accepting. Deployed by and Managed by are platforms from the platforms catalog. Language is a coding standard, or none. The accepted record keeps the three values.

**Why this priority**: Later proposals read these values. They no longer infer a platform from a missing coding standard, or a language from prose in the record.

**Independent Test**: Propose an implementation while the platforms catalog has a pipeline platform and a day-2 platform, and the coding standards catalog has one language standard that the implementation's technology choice names. The proposal shows those three values. Replace one, accept, and read the record.

**Acceptance Scenarios**:

1. **Given** a platforms catalog whose earliest pipeline is GitHub Pipeline and whose earliest self-service is Backstage, and a coding standards catalog whose Java standard's Technology is Java, **When** an implementation whose technology choice names Java is proposed, **Then** the proposal shows Deployed by GitHub Pipeline, Managed by Backstage, and Language Java Coding Standard.
2. **Given** that proposal, **When** the person replaces Deployed by with Cursor, Managed by with Cursor, and Language with none, **Then** the proposal shows those replacements and acceptance stores them.
3. **Given** an implementation whose technology choices name no coding standard's Technology, such as a store or a packaged application, **When** it is proposed, **Then** Language is none.
4. **Given** the catalog's only row is an agent, **When** the proposal is shown, **Then** Deployed by and Managed by are that agent.
5. **Given** a pipeline row and no self-service row and no agent row, **When** the proposal is shown, **Then** Managed by is that pipeline.
6. **Given** an accepted record, **When** it is read, **Then** Deployed by and Managed by each keep the platform title and that row's Implementation ID, and Language keeps the standard title or none.

---

### User Story 2 - A named platform is added or onboarded before the proposal continues (Priority: P1)

A person names a platform that is not a row in the platforms catalog. The proposal waits. A platform that already has an accepted implementation is configured, which adds the row. A platform with no accepted implementation is onboarded, and that implementation's platforms step adds the row. The proposal then continues with that row.

**Why this priority**: Deployed by and Managed by are catalog rows. A name that is not a row cannot be stored as one.

**Independent Test**: On an implementation proposal, name a platform that has an accepted implementation and no row, and name one that has neither. Each path returns to the proposal with a row.

**Acceptance Scenarios**:

1. **Given** an accepted implementation and no platforms-catalog row for it, **When** the person names it as Deployed by or Managed by, **Then** the proposal pauses, configuration adds the row, and the proposal resumes with that row.
2. **Given** no accepted implementation for the named platform, **When** the person names it, **Then** the proposal pauses, onboarding records the implementation, its platforms step adds the row, and the proposal resumes with that row.
3. **Given** a name that is already a row, **When** the person selects it, **Then** that row is used and configuration and onboarding are not started.

---

### User Story 3 - Establish keeps its executor and lets each task name a platform (Priority: P1)

A person chooses the establish action for an accepted implementation. The executor is Deployed by. The model breaks the work into tasks and chooses each task's platform. A task's platform may differ from the executor, and its method may be Helm, Terraform, CloudFormation, or another method. The codify session is the author and is not chosen from a catalog. Managed by is not the executor.

**Why this priority**: A pipeline that deploys an application still has work inside it. One fixed task would hide the platforms and methods that work uses.

**Independent Test**: Propose establish for an implementation whose Deployed by is a pipeline. The executor is that pipeline. At least one task can name a different platform or method, and that name is still there after the proposal is formed.

**Acceptance Scenarios**:

1. **Given** Deployed by is Cursor and Language is none, **When** establish is proposed, **Then** the executor is Cursor, Managed by is not the executor, and the task count is not fixed.
2. **Given** Deployed by is GitHub Pipeline and Language is none, **When** establish is proposed, **Then** the executor is GitHub Pipeline and a task may name Terraform, Helm, CloudFormation, or another platform or method.
3. **Given** Deployed by is GitHub Pipeline and Language is Java Coding Standard, **When** establish is proposed, **Then** the executor is GitHub Pipeline, a task that writes the custom solution lists Java Coding Standard, and a task may name another platform or method.
4. **Given** a task whose platform has no coding standard, **When** establish is proposed, **Then** that task remains, the executor remains Deployed by, the task says no coding standard applies, and its file is named at the product root from the task.
5. **Given** Language is set, **When** a task that writes the custom solution is listed, **Then** it lists that standard, and a When to use phrase that does not appear in the task does not remove it.

---

### User Story 4 - A later action is run by the day-2 executor (Priority: P2)

A person chooses a run, change, or recover action. The executor is Managed by. The model breaks the work into tasks and chooses each task's platform. A task's platform may differ from the executor.

**Why this priority**: Managed by is unused if establish is the only reader. A later action uses that executor without taking establish's task list.

**Independent Test**: On an implementation whose Deployed by and Managed by differ, propose a run action. The executor is Managed by, and a task may name a different platform.

**Acceptance Scenarios**:

1. **Given** Deployed by is GitHub Pipeline and Managed by is Backstage, **When** a run, change, or recover action is proposed, **Then** the executor is Backstage.
2. **Given** that proposal, **When** a task names Terraform, Helm, CloudFormation, or another platform or method, **Then** that name is kept.
3. **Given** Language is Java Coding Standard, **When** a later action's task writes the custom solution, **Then** that task lists Java Coding Standard, and a missing When to use phrase does not remove it.

---

### User Story 5 - A platform standard proposes one use and one exclusion (Priority: P1)

A person adding or updating a coding standard for a platform that has a row in the platforms catalog sees one When to use entry and one When not to use entry. When to use is `[Platform] is used`. When not to use is `[Platform] is not used`. A language standard keeps its class entries.

**Why this priority**: A platform standard is used when that platform is the one doing the work. Class lists on that standard are what made a task fail to match unless every class appeared in it.

**Independent Test**: With Cursor as a platform row and Java as a language with no platform row, propose both coding standards. Compare the two When to use lists and the two When not to use lists.

**Acceptance Scenarios**:

1. **Given** a platforms row whose title is Cursor, **When** the Cursor coding standard is added or updated, **Then** When to use is only `Cursor is used` and When not to use is only `Cursor is not used`.
2. **Given** no platforms row whose title is Java, **When** the Java coding standard is added or updated, **Then** its entries stay the class list, and neither `Java is used` nor `Java is not used` is required.
3. **Given** a platform standard for a row titled Cursor, **When** it is updated, **Then** the proposal shows only `Cursor is used` and `Cursor is not used`. Saved class entries are not carried into the proposal.
4. **Given** that unedited proposal, **When** it is shown, **Then** each of the two entries keeps its blank line and **Why it matters:** line, and the saved catalog keeps the entry only.
5. **Given** a platform standard proposal, **When** the person edits an entry, **Then** the edit is kept. A remove shows the saved entries and does not replace them with the two phrases.

---

### Edge Cases

- A platform row with a blank kind is not offered for pre-selection. A blank When to use does not change Deployed by or Managed by. A person can still name a row. Acceptance waits until the row has a kind.
- An empty Deployed by or Managed by does not take the first catalog row. The proposal names the missing field and waits. Older records are not kept working.
- A Deployed by or Managed by row that is later removed from the catalog is reported as not included. The proposal does not substitute another row.
- The same platform may be stored for both Deployed by and Managed by.
- A language version, such as a release number on a technology choice, stays on that technology choice. Language stores the coding standard title.
- When several coding standards share a Technology, Language is the earliest row. The person can replace it.
- The model breaks an establish action and a later action into tasks. The task count is not fixed, and there is no single instruction task or single pipeline task.
- A task's platform may differ from the executor. Helm, Terraform, CloudFormation, or another method may be that platform or the task's method. That name does not have to be a platforms-catalog row, and naming it does not start configuration or onboarding.
- The diagram starts at the executor. Each task adds its platform as a target.
- A second action in one reply still waits for another run.
- A standard is for a platform when its Technology is a platforms-catalog title, compared without regard to case as the whole Technology value. A platform title of more than one word stays one name inside `[Platform] is used` and `[Platform] is not used`.
- Those two phrases are not split, and they are not rewritten into classes. A standard whose platform row is later removed uses the class list on its next add or update.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The implementation proposal MUST show **Deployed by**, **Managed by**, and **Language** before acceptance, and the person MUST be able to replace any of the three. Acceptance MUST store them on the implementation record.
- **FR-002**: Pre-selected Deployed by MUST be the earliest platforms-catalog row whose kind is `pipeline`. When none, the earliest `orchestrator`. When none, the earliest `desired-state`. When none, the earliest `agent`. A row with a blank kind MUST NOT be offered. When to use MUST NOT be read for this choice.
- **FR-003**: Pre-selected Managed by MUST be the earliest row whose kind is `self-service`. When none, the earliest `agent`. When none, the Deployed by row. A row with a blank kind MUST NOT be offered. When to use MUST NOT be read for this choice.
- **FR-004**: Pre-selected Language MUST be the earliest coding-standards row whose Technology appears on its own in a technology choice of this implementation, compared without regard to case. When none match, Language MUST be none. The stored value MUST be the standard title, or none. A version MUST remain on the technology choice.
- **FR-005**: A replacement platform MUST be a platforms-catalog row, or the proposal MUST pause as FR-007 or FR-008. A replacement language MUST be a coding-standards title or none. A title that is not listed MUST be left out, and the person MUST be told to add it through configuration.
- **FR-006**: The record MUST store Deployed by and Managed by as the platform title and that row's Implementation ID, and Language as the standard title or none.
- **FR-007**: When the person names a platform that has an accepted implementation and no catalog row, the proposal MUST pause, configuration MUST add the row, and the proposal MUST resume with that row.
- **FR-008**: When the person names a platform that has no accepted implementation, the proposal MUST pause, onboarding MUST record the implementation, that implementation's platforms step MUST add the row, and the proposal MUST resume with that row.
- **FR-009**: The platforms catalog MUST store Kind on each row as one of `agent`, `pipeline`, `orchestrator`, `self-service`, or `desired-state`. Configuration MUST save the kind it already chooses. Until configuration sets the kind, the row MUST keep a blank kind.
- **FR-010**: For an establishing action, the executor MUST be Deployed by. The model MUST break the work into tasks and choose each task's platform. The codify session MUST be the author, and MUST NOT be selected from a catalog. Managed by MUST NOT be the executor. The task count MUST NOT be fixed.
- **FR-011**: A task's platform MAY differ from the executor. The model MUST NOT replace a task's platform with the executor. Helm, Terraform, CloudFormation, or another method MAY be a task's platform or its method.
- **FR-012**: A task platform or method that is not a platforms-catalog row MUST NOT start configuration or onboarding. FR-007 and FR-008 apply only when the person names Deployed by or Managed by.
- **FR-013**: When Language is set, each task that writes the custom solution MUST list Language. When Language is none, this rule adds no language standard. The task count is not the runtime component count.
- **FR-014**: A task MUST list the earliest coding standard whose Technology appears on its own in that task's platform. When no such standard exists, the task MUST say no coding standard applies, keep its platform, keep the executor, and name its file at the product root from the task.
- **FR-015**: A When to use phrase that does not appear in a task MUST NOT remove Language from a task that writes the custom solution, and MUST NOT remove that task's platform standard.
- **FR-016**: For a run, change, or recover action, the executor MUST be Managed by. The model MUST break the work into tasks and choose each task's platform. FR-011 through FR-015 apply to those tasks.
- **FR-017**: When the field this action needs is empty, or its row is gone, the proposal MUST name the missing field or platform and MUST NOT take the first catalog row or this implementation's row in its place.
- **FR-018**: A coding standard whose Technology is a platforms-catalog title, compared without regard to case as the whole value, MUST be treated as a platform standard. Any other standard MUST keep the class entries it has today.
- **FR-019**: On an add or update of a platform standard, the model's proposal MUST list one When to use entry, `[Platform] is used`, and one When not to use entry, `[Platform] is not used`. `[Platform]` is that row's title. No other entry is proposed, and the class list is not used. Each entry keeps its **Why it matters:** line on the proposal. The saved cell keeps the entry only.
- **FR-020**: An add or update of a platform standard MUST propose those two phrases and MUST NOT carry other saved entries into the proposal. A person's edit of either entry MUST be kept. A remove MUST show the saved entries.

### Key Entities

- **Deployment record**: Deployed by, Managed by, and Language on one accepted implementation. Deployed by is who ships it. Managed by is who operates it after it is up. Language is the coding standard for a custom solution, or none.
- **Platform kind**: The kind stored on a platforms-catalog row. It pre-selects Deployed by and Managed by.
- **Executor**: Deployed by on an establishing action, and Managed by on a run, change, or recover action. It is not a substitute for a task's platform.
- **Task platform**: The platform the model chooses for one task. It may be the executor or another platform, and its method may name Helm, Terraform, CloudFormation, or another method.
- **Platform standard**: A coding standard whose Technology is a platforms-catalog title. Its model proposal uses `[Platform] is used` and `[Platform] is not used` as its only entries.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: An establish proposal names Deployed by as the executor. The task count is not fixed to one.
- **SC-002**: When the executor is a pipeline, a task that names Terraform, Helm, CloudFormation, or another platform or method keeps that name.
- **SC-003**: When Language is set, every task that writes the custom solution lists it. The task count is not the runtime component count.
- **SC-004**: Removing the coding standard for a task's platform leaves that task and the executor in place.
- **SC-005**: A platform name with no catalog row is stored on 0 proposals before configure or onboard returns a row.
- **SC-006**: On an establish proposal, Managed by is the executor 0 times. On a run, change, or recover proposal, Deployed by is the executor 0 times. A task platform may be either.
- **SC-007**: An empty Deployed by or Managed by selects the first catalog row 0 times.
- **SC-008**: An unedited add or update of a platform standard shows 1 When to use entry and 1 When not to use entry, and those entries are `[Platform] is used` and `[Platform] is not used`. An unedited language-standard proposal shows those phrases 0 times.

## Assumptions

- Deployed by and Managed by are pre-selected by platform kind, in the order in FR-002 and FR-003. Catalog order decides which row wins inside one kind. When to use is not read for this choice. The person can replace either value before acceptance.
- Custom-developed is not a separate flag. Language is set only when a technology choice names a coding standard's Technology.
- One Language field is stored. A solution written in two languages keeps the earliest standard, and the person can replace it. A second language field is out of scope.
- Language is the custom application standard only. A task may still name Terraform, Helm, CloudFormation, Ansible, or another platform or method. That name is not stored in Language.
- Kind is chosen by the existing configuration step that already distinguishes an agent, a pipeline, an orchestrator, a self-service platform, and a desired-state or GitOps tool. This feature saves that kind. GitOps is stored as `desired-state`.
- Establishing already means a capability title containing `establish`, or the fallback `Establish [implementation title]` when no capability is of that kind. This feature uses that meaning only to choose the executor. It does not change how suggestions are ranked, and it does not fix the task list.
- The one-action limit stays. The diagram starts at the executor, and each task adds its platform as a target. File placement for a task that has a standard stays as it is.
- Skill version numbers are decided in planning.
- This project is in development. Older implementation records, platform rows, and saved coding-standard entries do not need to keep working. There is no migration.
- A platform standard's two phrases replace the class list on the model's add or update only. The person can edit either phrase before acceptance. Platform proposals are unchanged.
