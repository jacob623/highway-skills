# Feature Specification: Codify Proposal Tasks

**Feature Branch**: `203-codify-proposal-tasks`

**Created**: 2026-11-01

**Status**: Draft

**Input**: User description: "In highway-codify suggest, name the product, platform, or application instead of 'this implementation,' say that automating these tasks may be worth visiting, make each title the action the automation will take with a summary that expands on it, and invite another idea with a brief description. Before the proposal is shown, check it against any applicable coding standard, then against current public sources. Carry the selected title and summary into the proposal. Draw the diagram from top to bottom, starting with who executes the automation, with each arrow a verb and each box the place that action happens. Replace components with an ordered task list that matches the diagram, one action against one target, each with scope, provider, method, and assumptions. Show title, summary, description, acceptance criteria, diagram, and tasks. Leave out current state, action, day, and means unless a later reader cannot recover them."

## Clarifications

### Session 2026-11-01

- Q: When the proposal is accepted, do current state, action, day, and means stay on the saved automation? → A: Remove all four from the proposal and from the saved record. Coverage reads the automation title.
- Q: When the person accepts, how many files can one proposal task produce? → A: The executor is written once. A task adds files only when its method needs an artifact of its own. A task carried entirely by the executor adds no extra file. A task with its own artifact adds every file that artifact needs, and no file that belongs to another task. A test file follows its file only when that file's standard requires tests. The readme stays last.
- Q: Before the proposal is shown, what should the coding-standard check change? → A: The check accounts for provider boundaries, acceptable libraries or modules, and required patterns. The shown proposal is congruent with those expectations. The selected action stays. Writing each file later still follows that file's standard.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - See actions worth automating (Priority: P1)

A person has chosen an implementation and has not named an action. Codify opens the suggestion list by naming that implementation's product, platform, or application, and by saying that automating these tasks may be worth visiting. Each suggestion title is the action the automation would take. The sentence under it expands on that action. The list still asks which option to explore, and then invites the person to describe another idea so it can be worked through together.

**Why this priority**: The current opening talks about "this implementation" and "worth visiting," and the titles repeat capability names. The person is choosing work to automate, and the list should say that.

**Independent Test**: Open suggestions for an implementation whose product is named. Read the opening, one suggestion, and the closing line. The opening names the product and says automating these tasks may be worth visiting. The title is an action. The sentence under it expands on that action. The closing line invites a brief description of another idea.

**Acceptance Scenarios**:

1. **Given** an implementation that names a product, platform, or application, **When** the suggestion list is shown, **Then** the opening names that product, platform, or application and says that automating these tasks may be worth visiting.
2. **Given** the suggestion list, **When** one suggestion is read, **Then** its title is the action the automation would take and the sentence under the title expands on that action.
3. **Given** the suggestion list, **When** the lines after the choices are read, **Then** it asks which option to explore and then says, "If you have another idea, provide a brief description and we'll work through it together."
4. **Given** the person describes their own idea, **When** codify accepts it, **Then** the title is that action and the summary is one sentence that expands on it.
5. **Given** no suggestion is grounded, **When** the list is empty, **Then** codify says so and uses the same invitation. It does not say "You can also provide your own."
6. **Given** the suggestion list, **When** it is read, **Then** it shows at most five suggestions, and nothing is written.

---

### User Story 2 - Check the proposal before it is shown (Priority: P1)

The person has selected an action. Before the proposal appears, codify checks the executor and each task against any coding standard that applies, including that standard's provider boundaries, acceptable libraries or modules, and required patterns. It then checks named products and methods against current public sources. The proposal the person sees is already congruent with those expectations. The selected title and summary are the ones carried into the proposal.

**Why this priority**: A proposal that crosses a provider boundary, names a library the organization does not accept, skips a required pattern, or names a retired product sends the person into acceptance of work that will not hold.

**Independent Test**: Select an action whose provider sits outside the standard's boundary, whose method names a library the standard does not accept, and whose named product the vendor no longer offers. Read what appears before the proposal. The standard is checked first. The provider, the library, and any required pattern match the standard. The source check is named second, the retired product is corrected, and the source is cited. The title and summary are the ones just selected.

**Acceptance Scenarios**:

1. **Given** a coding standard applies to the executor or a task, **When** the proposal is built, **Then** that standard is checked before any public source, and the shown proposal is congruent with its provider boundaries, acceptable libraries or modules, and required patterns.
2. **Given** the draft uses a provider outside the standard's boundary, a library or module the standard does not accept, or a pattern other than the one the standard requires, **When** the proposal is shown, **Then** the provider or method has been corrected and one sentence before the proposal says what changed.
3. **Given** no coding standard applies, **When** the proposal is shown, **Then** one sentence says that no coding standard applies, and the source check still runs.
4. **Given** the standard cannot be met without replacing the selected action, **When** the check finishes, **Then** the proposal is not shown, one sentence says the standard cannot be met for this action, and the person is asked for a different action.
5. **Given** the proposal names a product, API, plugin, module, or library, **When** the vendor's current public documentation says it is no longer offered, **Then** the proposal is corrected before it is shown and the sentence cites the source.
6. **Given** no vendor documentation is found, only a secondary source is found, or the check cannot be completed, **When** the proposal is shown, **Then** the check is named as inconclusive and is not treated as confirmation.
7. **Given** the person selected a title and summary, **When** the proposal is shown, **Then** those are the title and summary on the proposal.
8. **Given** the checks have run and the person has not accepted, **When** the repository is read, **Then** nothing is written.

---

### User Story 3 - Read the automation as ordered tasks (Priority: P1)

The proposal shows the title, the summary, the description, the acceptance criteria, a top-to-bottom diagram, and the tasks, in that order. The diagram starts with who executes the automation. Each arrow is a verb. Each box after the start is the place that action happens. The tasks are the same actions in the same order. Each task is one action against one target, with its scope, provider, method, and assumptions. Current state, a separate action line, day, and means are not part of the proposal or the saved record. The title is the action. A later decision that checks coverage reads that title.

**Why this priority**: Components, current state, action, day, and means describe the automation sideways. The person needs the work in the order it will be done, and the picture and the list need to be the same work.

**Independent Test**: Read a proposal with three tasks. The sections are in the stated order. The diagram reads top to bottom, starts with who executes it, and has three arrows whose verbs match the three task titles. Each task names one target, a provider, a method, and any assumptions that are not earlier tasks. Current state, action, day, and means do not appear.

**Acceptance Scenarios**:

1. **Given** the proposal, **When** it is read, **Then** the sections appear in this order: title, summary, description, acceptance criteria, diagram, tasks.
2. **Given** the diagram, **When** it is read, **Then** it runs from top to bottom, the first box is who executes the automation, each arrow starts with a verb, and each following box is the platform, object, or API where that action happens.
3. **Given** the diagram has several arrows, **When** the tasks are read, **Then** there is one task per arrow, in the same order, and the task title is that arrow's verb phrase.
4. **Given** a task, **When** it is read, **Then** it is one action against one platform, object, or API, and it shows scope, provider, method, and assumptions in that order.
5. **Given** a task's provider, **When** it is read, **Then** it names the specific thing that completes the task, such as a pipeline, an agent, the person, or a named product.
6. **Given** a task's assumptions, **When** they are read, **Then** each one is something the task relies on that is not an earlier task, such as network access, an access level, an authentication method, or a credential source.
7. **Given** a step would act on two targets, **When** the proposal is shown, **Then** that step is two tasks and two arrows.
8. **Given** the proposal, **When** it is read, **Then** it has no current state, no separate action line, no day, and no means.
9. **Given** the person edits a task, **When** the proposal is shown again, **Then** the diagram and the tasks still describe the same actions in the same order.
10. **Given** the person accepts, **When** the saved proposal is read, **Then** it has the same sections in the same order, and it does not add current state, action, day, or means.
11. **Given** a later decision checks whether this implementation is already covered, **When** it reads the saved automation, **Then** it matches the automation title and does not look for a separate action line.
12. **Given** the executor is one agent instruction and every task is part of that instruction, **When** the person accepts, **Then** the file list is that instruction file and the readme.
13. **Given** a pipeline or flow calls an API and that call is contained in the executor, **When** the person accepts, **Then** that task adds no extra file.
14. **Given** a task runs Terraform, Ansible, or another artifact of its own, **When** the person accepts, **Then** that task adds every file that artifact needs and no file that belongs to another task.
15. **Given** the executor is a service or operator, **When** the person accepts, **Then** its shared files are written once and each task adds the files for its own action.

---

### Edge Cases

- The implementation names no product, platform, or application. The suggestion opening uses the implementation's title.
- The implementation names more than one. The opening uses the implementation's title, because no single automation has been chosen yet.
- The person names two actions in one reply. One is kept. The other waits for another run.
- A listed number is not on the list. The list is shown again and nothing is written.
- No coding standard applies. The proposal says so in one sentence, then the source check runs.
- The standard sets a provider boundary. A provider outside that boundary is changed before the proposal is shown. The selected action stays.
- The standard names the libraries or modules it accepts. A named library or module outside that list is replaced before the proposal is shown.
- The standard requires a pattern. The method uses that pattern.
- The standard has no provider boundary, library, module, or pattern rule. The standard check leaves the proposal unchanged.
- The executor and a task use different technologies. Each is checked against the standard for that technology.
- The standard cannot be met without a different action. The proposal is not shown. One sentence says so and asks for a different action.
- A standard's file is missing. That standard is unavailable. The sentence says so, and the source check still runs.
- One vendor page still describes a named product and another says it is no longer offered. The proposal is corrected and both sources are cited.
- A blog, forum, or comparison is the only source. The check is inconclusive. The proposal is not changed because of it.
- The source check cannot be completed. The check is inconclusive. The proposal is still shown.
- The diagram has one action. It has the starting box, one arrow, and one target box, and one task.
- The person removes the last task. The proposal asks for at least one task and stays on the proposal.
- The person removes the last acceptance criterion. The proposal asks for at least one and stays on the proposal.
- A task's assumptions are none. The assumptions say none.
- The person declines. Nothing is written.
- An accepted automation is opened again to continue work already started. The saved proposal is used. The suggestion list, the checks, and the proposal are not rebuilt.
- The person names a different accepted architecture while editing. The proposal still has no means line. The architecture reference on the saved record follows that choice.
- A later decision checks coverage. It matches the automation title. The saved record has no separate action, current state, day, or means section.
- Every task is part of the executor file. The file list is that executor file and the readme.
- One task is an API call inside a pipeline or flow, and another task runs Terraform. The API task adds no file. The Terraform task adds its own files. The pipeline or flow is written once.
- A service or operator has shared files and two tasks. The shared files appear once. Each task's files appear only under that task.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The suggestion list MUST open with **Based on the current state of [name], automating these tasks may be worth visiting:** where [name] is the product, platform, or application the selected implementation provides. When the implementation names none, or names more than one, [name] MUST be the implementation's title.
- **FR-002**: Each suggestion title MUST be the action the automation would take. The sentence under the title MUST expand on that action. A suggestion MUST NOT use an id as its label.
- **FR-003**: After **Would you like to explore any of these options?** the list MUST say, "If you have another idea, provide a brief description and we'll work through it together." It MUST NOT say "You can also provide your own."
- **FR-004**: The suggestion list MUST keep its current limit of five, its current question, and the current rule that the person's own description selects their own automation. An empty list MUST say that no suggestion is grounded and MUST use the invitation in FR-003.
- **FR-005**: A person's own idea MUST become the action title, with one summary sentence that expands on it. Two actions in one reply MUST keep one and say the other waits for another run.
- **FR-006**: Before the proposal is shown, codify MUST check the draft against any applicable coding standard, and MUST then check named products, APIs, plugins, modules, and libraries against current public vendor documentation. The standard check MUST finish before the source check starts. The source check MUST see the draft after any standard correction.
- **FR-007**: A standard applies when the organization's coding standards name the technology of the executor or of a task. Before the proposal is shown, the executor and each task MUST be compared with that standard's provider boundaries, acceptable libraries or modules, and required patterns. The shown proposal MUST be congruent with those expectations: each provider falls inside the boundary the standard allows, each named library or module is one the standard accepts, and each required pattern is the pattern the method uses. A conflict MUST be corrected in the provider or method before the proposal is shown, and one sentence before the proposal MUST say what changed. The selected action MUST stay the selected action. When the standard cannot be met without a different action, the proposal MUST NOT be shown, one sentence MUST say so, and the person MUST be asked for a different action. When no standard applies, or the standard cannot be read, one sentence MUST say so and the source check MUST still run. Writing each file later MUST still follow that file's standard.
- **FR-008**: When vendor documentation says a named product, API, plugin, module, or library is deprecated, retired, or no longer offered, the proposal MUST be corrected before it is shown and the sentence MUST cite the source. Conflicting vendor pages MUST correct the proposal and cite both. A blog, forum, comparison, a missing source, or a check that cannot be completed MUST be named as inconclusive before the proposal, MUST NOT be treated as confirmation, and MUST NOT by itself change the proposal. Check results are shown before the proposal and are not saved.
- **FR-009**: The proposal title and summary MUST be the title and summary selected from the suggestion list, or the person's own action and its one-sentence summary. The checks MUST NOT replace the selected action with a different action.
- **FR-010**: The proposal MUST show, in this order: title, summary, description, acceptance criteria, diagram, and tasks. It MUST still ask what the person would add, correct, or remove, and say that if it is accurate they can say so.
- **FR-011**: The diagram MUST read from top to bottom. The first box MUST be who or what executes the automation. Each arrow MUST be the action and MUST start with a verb. Each later box MUST be the platform, object, or API where that action happens.
- **FR-012**: Tasks MUST replace components. The tasks MUST be an ordered list in the diagram's arrow order, one task per arrow. Each task MUST be one action against one platform, object, or API. A step that would act on two targets MUST be two tasks and two arrows.
- **FR-013**: Each task MUST be shown as a numbered action, then scope, provider, method, and assumptions, in that order. Scope says what the task does. Provider names the specific thing that completes it. Method says how, including the plugins, modules, libraries, or APIs it uses when it uses them. Assumptions list what the task relies on that is not an earlier task, or say none.
- **FR-014**: The proposal and the saved proposal MUST NOT include current state, a separate action line, day, or means. The action is the title. A later decision that treats an implementation as already covered MUST match the automation title, without regard to case, and MUST NOT read a separate action section. The architecture reference on the saved record remains the trace to the accepted architecture. Current state and day are not written.
- **FR-015**: The proposal MUST keep at least one task and at least one acceptance criterion. Removing the last of either MUST stay on the proposal and ask for one.
- **FR-016**: An edit to a task, the diagram, or the acceptance criteria MUST be shown again with the diagram and the tasks still matching. Nothing is written before the person accepts.
- **FR-017**: Acceptance MUST save the proposal in the order in FR-010, including the tasks. The file list MUST write the executor once, then each task's own files in task order, then the readme last. The executor is who or what the diagram starts with: one pipeline, one flow, one agent instruction, or the shared files of one service or operator. A task whose action is carried entirely by that executor MUST add no extra file. A task whose method needs an artifact of its own MUST add every file that artifact needs and MUST NOT add a file that belongs to another task. A test file MUST follow its file only when that file's standard requires tests. How a file is coded, and how a file's coding standard is chosen, MUST stay as they are.
- **FR-018**: Opening an automation that already has saved work MUST continue that work. It MUST NOT show the suggestion list again, MUST NOT run the checks again, and MUST NOT rebuild the proposal.

### Key Entities

- **Suggestion**: One action offered for the selected implementation. It has an action title and one sentence that expands on that action.
- **Proposal task**: One action against one target, in diagram order. It has a scope, a provider, a method, and assumptions. It adds files only when its method needs an artifact of its own.
- **Executor**: Who or what the diagram starts with. It is written once: a pipeline, a flow, an agent instruction, or the shared files of a service or operator.
- **Diagram step**: The starting executor, then one arrow and one target box per proposal task. The arrow and the task title are the same verb phrase.
- **Standard alignment**: The result of comparing the executor and each task with an applicable coding standard before the proposal is shown. The comparison covers provider boundaries, acceptable libraries or modules, and required patterns. The result is congruent, corrected, impossible without a different action, none applies, or unavailable.
- **Source check**: The result of reading current public vendor documentation for a named product or method: confirmed, corrected, or inconclusive. An inconclusive result is not confirmation.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A suggestion list names the product, platform, or application 1 time in the opening and uses the phrase "this implementation" 0 times. It says automating these tasks may be worth visiting 1 time.
- **SC-002**: Each suggestion title is an action 1 time, and the sentence under it expands on that action 1 time. The list ends with the new invitation 1 time and with "You can also provide your own." 0 times.
- **SC-003**: Before one proposal is shown, the coding-standard check runs 1 time and the source check runs 1 time, in that order. A provider outside the standard's boundary, a library or module the standard does not accept, and a missing required pattern appear 0 times in the shown proposal.
- **SC-004**: The shown title and summary match the selected suggestion 1 time. The checks replace that action with a different action 0 times.
- **SC-005**: The proposal and the saved record show the six sections in the stated order 1 time. Current state, a separate action line, day, and means appear 0 times. A coverage check matches the automation title 1 time.
- **SC-006**: A diagram of 3 actions has 3 arrows and 3 tasks. Each arrow starts with a verb, and each task is 1 action against 1 target. The task order matches the arrow order.
- **SC-007**: Accepting the proposal writes the suggestion list, the checks, and a second proposal 0 times. The saved proposal contains the same tasks in the same order.
- **SC-008**: An agent instruction whose tasks all live inside it produces 1 executor file and the readme, and 0 extra task files. A pipeline with 1 contained API task and 1 Terraform task produces the pipeline once, the Terraform files for that one action, and 0 files for the API task.

## Assumptions

- The suggestion list still offers at most five actions and still asks which option to explore. This feature changes the opening, the titles, the summaries, and the closing invitation.
- The product, platform, or application name is taken from the accepted implementation. The implementation title is used when that name is absent or when the implementation names more than one.
- Whether an instance is running may still decide which suggestions come first. That decision is not shown as current state or as a day.
- A coding standard applies when the organization's standards name the technology of the executor or of a task. The check uses that standard's provider boundaries, acceptable libraries or modules, and required patterns. It does not edit the standard or its catalog. Writing each file later still follows that file's standard.
- The source check uses the vendor's current public documentation, product pages, and release notes, and sends only the name being checked. A secondary source cannot confirm or contradict a claim.
- Correcting a conflict keeps the selected action. It changes the provider, the method, the library, the module, or the pattern so the proposal matches the standard. When the standard cannot be met for that action, the proposal is not shown.
- The first box of the diagram is who or what starts the automation. It is not a task. Each task is one arrow and the box that arrow points to.
- The provider is who completes that task. The box is where the action happens. Those two can differ.
- The saved record keeps its reference to the accepted architecture so later coding can read it. The proposal does not display that reference as means. The person can still name a different accepted architecture while editing. Current state, a separate action line, day, and means are not saved. Coverage matches the automation title.
- The file list writes the executor once. A task adds files only when its method needs an artifact of its own. A test file follows its file only when that file's standard requires tests. The readme stays last. This feature does not change how each file is written, how a standard is matched to a file, or the rule that the automation is not run.
- Opening saved work continues that work. The checks belong to building a new proposal, not to finishing files already listed.
