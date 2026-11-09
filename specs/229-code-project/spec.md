# Feature Specification: Code Project

**Feature Branch**: `229-code-project`

**Created**: 2026-11-08

**Status**: Draft

**Input**: User description: "If a Language is defined on the implementation record, highway-codify treats the Product as a code project. That is the trigger. Establish initializes the Product code using the associated coding standard if it exists. When Deployed by is a pipeline, Establish includes writing the pipeline using the pipeline platform coding standard, if it exists. Additional codify suggestions operate on the product code, based on what the product does or could do, grounded in the implementation record. Create a new section called 'code project' in highway-codify to contain the instructions. Point to this section when it meets the trigger criteria. Keep it deterministic instructions as opposed to prose. When the person chooses an implementation, the message for missing Deployed by, Managed by, and Language redirects them at that time. Language is Needed until accepted. It is now mandatory to complete the implementation record before highway-codify can operate on it."

## Clarifications

### Session 2026-11-08

- Q: When Establish initializes a code project, should it write only the project skeleton, or also the product's realized capabilities? → A: Skeleton only: project structure, build file, entry point, configuration, and a health check, plus the pipeline when Deployed by is a pipeline. Capabilities come later as separate suggestions. The person can add scope to the proposal as they see fit.
- Q: For a code project whose record says an instance is already running, what should highway-codify suggest? → A: Offer Establish anyway, to start the product code in Highway. Other code suggestions appear only after an Establish feature is recorded.
- Q: When the person declines the highway-implementation view, which leaves the record incomplete, what should they see before highway-codify stops? → A: "Leaving the preferred delivery platforms for [Title] unset. highway-codify needs these details before it can make proposals for [Title].", then a yes/no question to return and provide the details. Yes shows the view again. No returns to highway-codify, which stops.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - An incomplete record is completed before codify operates (Priority: P1)

A person selects an implementation whose record has Deployed by, Managed by, or Language unset. highway-codify tells them the record is missing critical detail and sends them straight to highway-implementation to set it. There is no option to continue without it.

The message is:

**[Product Title]'s implementation record is missing critical detail required for highway-codify proposals.**

Then:

Let's set those details now for [Product Title].

highway-implementation opens with:

**Here is the proposed Deployed by, Managed by and Language for [Product Title]**

It shows Product Title and Architecture Reference for traceability, then Deployed by, Managed by, and Language, each followed by its own **Why it matters:** line.

**Why this priority**: Every later behavior, including the code project trigger, reads these three fields.

**Independent Test**: Onboard a platform, select its implementation in highway-codify, and read the message, the hand-off line, and the highway-implementation view.

**Acceptance Scenarios**:

1. **Given** a selected implementation with Deployed by, Managed by, or Language `Needed`, empty, or naming a title with no catalog row, **When** highway-codify reads the record right after selection, **Then** it emits the message above, then the hand-off line, and follows highway-implementation without asking a question. No suggestion list appears.
2. **Given** Language is `None` and both platforms name catalog rows, **When** the implementation is selected, **Then** no message appears.
3. **Given** the highway-implementation view, **When** it opens, **Then** it starts with the bold heading above, then Product Title and Architecture Reference, then the three fields.
4. **Given** the view, **When** it is shown, **Then** each of Deployed by, Managed by, and Language is followed by its FR-006 **Why it matters:** line on its own line.
5. **Given** the view shows Language `None`, **When** it is shown, **Then** Language's **Why it matters:** line is the Platform-to-manage sentence. Any other Language shows the coding-project sentence.
6. **Given** the view shows Deployed by or Managed by as `Needed`, **When** it is shown, **Then** that field's **Why it matters:** line is its "needs a codify platform" sentence.
7. **Given** the view with any field `Needed`, **When** the person accepts, **Then** that field is named and the view stays open.
8. **Given** the person accepts a complete view, **When** highway-codify resumes, **Then** it reads the record again and continues to suggestions.
9. **Given** the person declines the view, **When** the decline is read, **Then** highway-implementation writes nothing, emits "Leaving the preferred delivery platforms for [Title] unset. highway-codify needs these details before it can make proposals for [Title].", and asks **Would you like to return and provide these details now?**
10. **Given** that question, **When** the person says yes, **Then** the view is shown again.
11. **Given** that question, **When** the person says no, **Then** highway-codify reads the record again, finds it still incomplete, and stops. It writes nothing.
12. **Given** a record that was complete at selection, **When** `provider` finds the Executor has no catalog row, **Then** the same message and hand-off apply there.
13. **Given** an onboarded implementation, **When** it is written, **Then** Deployed by, Managed by, and Language are all `Needed`.

---

### User Story 2 - Establish initializes the product code and its pipeline (Priority: P1)

A person runs highway-codify for an implementation whose record names a Language coding standard, such as an Orders Service written in Java. The first suggestion is Establish. Its proposal writes the product's own code with the Language coding standard. When Deployed by is a pipeline, the same proposal also writes that pipeline with the pipeline's platform coding standard.

**Why this priority**: Without this, highway-codify writes automation around a service it never creates.

**Independent Test**: Seed an implementation with Language `Java`, a Java coding standard, Deployed by a platform whose Kind is `pipeline`, and a platform standard for that pipeline. Run highway-codify, select Establish, and read the proposal.

**Acceptance Scenarios**:

1. **Given** an implementation whose Language names a coding standard and no Establish feature is recorded, **When** highway-codify lists suggestions, **Then** `Establish [implementation title]` is the only suggestion, even when an instance is running.
2. **Given** that Establish is selected, **When** the proposal is shown, **Then** it has code tasks that initialize the product code (project structure, build file, entry point, configuration, and a health check), each with the Language standard first on its Standards list, and no task for a Realized Capability.
3. **Given** the Establish proposal, **When** the person adds a capability with an edit, **Then** the proposal gains that code task.
4. **Given** Deployed by's platforms-catalog row has Kind `pipeline`, **When** the Establish proposal is shown, **Then** it also has pipeline tasks that write that pipeline, each with the pipeline's platform standard on its Standards list.
5. **Given** Deployed by's Kind is not `pipeline`, **When** the Establish proposal is shown, **Then** it has no pipeline task.
6. **Given** the Language standard file is absent, **When** the Establish proposal is shown, **Then** the code tasks say no coding standard applies and the proposal points to `/highway-codify-config`.
7. **Given** the pipeline platform standard is absent, **When** the Establish proposal is shown, **Then** the pipeline tasks say no coding standard applies.
8. **Given** the proposal is accepted and coded, **When** the files are written, **Then** the Language standard places the source files and the pipeline standard places only the pipeline files.

---

### User Story 3 - Later suggestions change the product code (Priority: P1)

After Establish, a person runs highway-codify again for the same implementation. The suggestions are changes to the product code, drawn from what the record says the product does or could do.

**Why this priority**: A code project grows by changing its code, not by adding automation beside it.

**Independent Test**: With an Establish feature already recorded, run highway-codify for the implementation and read the suggestions and one proposal.

**Acceptance Scenarios**:

1. **Given** a code project, **When** suggestions are listed, **Then** they come from the record in this order: Realized Capabilities, Realized Interfaces, architecture responsibilities the record covers, then NFR Realization items.
2. **Given** a suggestion that a recorded feature already delivers, **When** suggestions are listed, **Then** it is left out.
3. **Given** more than five grounded suggestions, **When** suggestions are listed, **Then** the first five are shown.
4. **Given** a selected code-project suggestion, **When** the proposal is shown, **Then** its code tasks change the product code and show the Language standard first.
5. **Given** a code project with no recorded Establish feature, **When** suggestions are listed, **Then** no other code-project suggestion appears.

---

### User Story 4 - The proposal shape fits a code project (Priority: P2)

The person reads a code-project proposal and sees which platform delivers the code, which tasks write code, and which tasks write the pipeline.

**Why this priority**: The automation shape (a platform running tasks against targets) does not describe writing source code.

**Independent Test**: Read a code-project Establish proposal and its README after coding.

**Acceptance Scenarios**:

1. **Given** a code project, **When** the proposal is shown, **Then** the Executor is Deployed by for every action.
2. **Given** a code task, **When** the proposal is shown, **Then** the task shows **Language:** in place of **Provider:**.
3. **Given** a pipeline task, **When** the proposal is shown, **Then** the task keeps **Provider:**.
4. **Given** a code project, **When** the diagram is shown, **Then** it starts at the Executor and points to the product.
5. **Given** a code project, **When** a proposal would join another implementation into its product, **Then** no join happens. The code project's product lists only its own implementation.
6. **Given** a new code project, **When** its product folder is named, **Then** the product title is the implementation title.
7. **Given** a coded code project, **When** the README is written, **Then** Setup Instructions say how to build, configure, and run the product, and User Guide says how to use its interfaces.

---

### Edge Cases

- Language is `None`: the product is not a code project. Today's automation flow applies.
- Language names a title that is not in the coding standards catalog: the record is incomplete and the message appears.
- Language names a catalog title whose standard file is absent: the product is a code project and the standard is reported missing.
- An action connects the code project to another implementation: it is recorded in a separate product, not in the code project's product.
- The record's Realized Interfaces, architecture responsibilities, and NFR Realization are all `None` and every capability is codified: the suggestion list says each grounded action is already codified.

## Requirements *(mandatory)*

### Functional Requirements

**Complete record**

- **FR-001**: Right after an implementation is selected, highway-codify MUST read its Execution. When Deployed by or Managed by is `Needed`, empty, or names a platform with no platforms-catalog row, or Language is `Needed`, empty, or names a title not in the coding standards catalog, the record is incomplete.
- **FR-002**: For an incomplete record, highway-codify MUST emit "**[Product Title]'s implementation record is missing critical detail required for highway-codify proposals.**", then "Let's set those details now for [Product Title].", then follow highway-implementation with a return to the selection. It MUST NOT ask a question or offer a one-run platform.
- **FR-003**: On return, highway-codify MUST read the record again. A complete record continues. An incomplete record stops the run and writes nothing.
- **FR-003a**: A decline of the highway-implementation view MUST write nothing, emit "Leaving the preferred delivery platforms for [Title] unset. highway-codify needs these details before it can make proposals for [Title].", then ask **Would you like to return and provide these details now?** A yes MUST show the view again. A no MUST return to highway-codify.
- **FR-004**: `provider` MUST apply FR-002 when the Executor has no catalog row.
- **FR-005**: The highway-implementation view MUST begin with "**Here is the proposed Deployed by, Managed by and Language for [Product Title]**", then show Product Title and Architecture Reference, then Deployed by, Managed by, and Language.
- **FR-006**: Each of Deployed by, Managed by, and Language MUST be followed by its own **Why it matters:** line, exactly:
  - Deployed by: "highway-codify will use [codify platform] to get [Product title] up and running."
  - Deployed by that is `Needed`: "highway-codify needs a codify platform to get [Product title] up and running."
  - Managed by: "highway-codify will use [codify platform] for managing [Product title] once its running."
  - Managed by that is `Needed`: "highway-codify needs a codify platform for managing [Product title] once its running."
  - Language that is not `None`: "highway-codify will treat [Product title] as a [Language] coding project."
  - Language that is `None`: "highway-codify will treat this as a Platform to manage as opposed to a coding project to write."

  [codify platform] is the platform shown for that field. [Language] is the Language shown.
- **FR-007**: The view MUST NOT accept while any of the three fields is `Needed`.
- **FR-008**: In the view, Language is unset when `Needed`, empty, or naming a standard with no row in the coding standards catalog. A stored `None` MUST be shown as stored.
- **FR-009**: highway-onboarding MUST store Language as `Needed`. The implementation record template MUST allow `Needed` for Language.

**Code project**

- **FR-010**: An implementation whose record Language names a coding standard MUST be treated as a code project. Language `None` is not a code project.
- **FR-011**: The code-project check MUST run after the record is complete, before suggestions.
- **FR-012**: highway-codify MUST hold the code-project instructions in one section named `code project`. A step that meets the trigger MUST point to it. When that section exceeds the step word limit, it MAY point to one further section for the proposal of a code project, including Establish.
- **FR-013**: The instructions MUST be ordered, deterministic steps.
- **FR-014**: Until an Establish feature is recorded for the code project, the only code-project suggestion MUST be `Establish [implementation title]`, whether or not an instance is running.
- **FR-015**: Establish MUST propose code tasks that initialize the product code: project structure, build file, entry point, configuration, and a health check. It MUST NOT propose a Realized Capability. Each code task lists the Language standard first when its file exists. The person can add scope with an edit on `revise`.
- **FR-016**: When Deployed by's row has Kind `pipeline`, Establish MUST also propose pipeline tasks that write that pipeline, with its platform standard on each Standards list when the file exists.
- **FR-017**: After an Establish feature is recorded, code-project suggestions MUST come from, in order: Realized Capabilities, Realized Interfaces, architecture responsibilities the record covers, and NFR Realization items. At most five are shown after recorded features are left out.
- **FR-018**: A code-project suggestion other than Establish MUST propose code tasks that change the product code.
- **FR-019**: The Executor of every code-project action MUST be Deployed by.
- **FR-020**: A code task MUST show **Language:** in place of **Provider:**. A pipeline task MUST keep **Provider:**.
- **FR-021**: Each code task's Standards list MUST start with the Language standard, then the standards it inherits, then any standard whose Technology appears on its own in the Technology Choice.
- **FR-022**: In a code project, the Language standard MUST place source files. The pipeline platform standard MUST place only pipeline files.
- **FR-023**: A code project's product MUST list only its own implementation. `join` MUST NOT merge another implementation into it.
- **FR-024**: A new code project's product title MUST be the implementation title.
- **FR-025**: A code project's README MUST say how to build, configure, and run the product in Setup Instructions, and how to use its interfaces in User Guide.
- **FR-026**: The diagram MUST start at the Executor and point to the product.
- **FR-027**: Today's flow MUST stay unchanged after the complete-record check for an implementation whose Language is `None`.

### Key Entities

- **Complete record**: Deployed by and Managed by each name a platforms-catalog row, and Language names a coding-standards catalog title or is `None`.
- **Code project**: A product whose implementation record names a Language coding standard.
- **Code task**: A proposal task that writes or changes the product's own source code.
- **Pipeline task**: A proposal task that writes the Deployed by pipeline.
- **Language standard**: The coding standard the implementation record names as Language.
- **Pipeline platform standard**: The coding standard for the Deployed by platform.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of selections of an incomplete record show the message and open highway-implementation before any suggestion.
- **SC-002**: 0 highway-codify proposals are shown for an incomplete record.
- **SC-003**: 100% of runs for an implementation with a Language standard follow the `code project` instructions; 100% of runs with Language `None` follow today's flow.
- **SC-004**: 100% of code-project Establish proposals include code tasks, and include pipeline tasks exactly when Deployed by's Kind is `pipeline`.
- **SC-005**: 100% of code-project suggestions trace to one named section of the implementation record.

## Assumptions

- Spec 229 "Task Provider Is the Executor" is withdrawn. Pipeline and automation tasks keep a per-task Provider.
- The `platforms needed` message, its question, and every one-run reply are replaced by FR-002. A platform or coding standard can no longer be named for one run.
- Spec 228's choice to propose Language when it is `None` is reversed: `None` is an accepted decision.
- The highway-implementation return line after acceptance keeps its wording. The decline line changes per FR-003a.
- The **Why it matters:** lines in FR-006 are used exactly as the person supplied them.
- A recorded feature delivers a suggestion when `codified` would leave it out today.
- An existing codebase is not imported. Establish starts the product code in Highway even when an instance is running.
- The close message keeps its structure. Its last line names that the code was not run.
- Verification lines that describe the automation shape gain code-project exceptions in the same change.
