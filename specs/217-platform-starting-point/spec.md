# Feature Specification: Platform Starting Point and Automation Grounding

**Feature Branch**: `217-platform-starting-point`

**Created**: 2026-11-05

**Status**: Draft

**Input**: User description: "In highway-codify-config, platform proposal, after stating the consequence and before the proposal state: **Here is a starting point for configuring <platform> for a platform capable of executing automation**" Added: "I want the When to use and When not to use to be grounded in best practices for the type of platform as relates to automation. I want the same for coding standards. Replace the current grounding in realized capabilities. The real capabilities the platform is capable of, as relates to automation, may become new realized capabilities." Added: "I also want each When to use and When not to use to be no more than 5 words, where each describes one thing. For example: Workflow orchestration, Web Service, Application Front-End, Desired State Configuration Management, GitOps, Code Deployment. This applies to both platform and coding standards. Also, move the **Why it matters:** statement to the described proposal shape so that it is clearly on a new line under the [Entry]."

## Clarifications

### Session 2026-11-05

- Q: How does an accepted new realized capability get recorded? → A: The platform proposal lists the new realized capabilities. After the platform write, configuration hands off to `highway-implementation` with a return step. `highway-implementation` gains an update path that records them on that implementation, then returns to configuration.
- Q: When the person has already accepted new realized capabilities in the platform proposal, should `highway-implementation` ask again before recording? → A: No. `highway-implementation` records exactly what was accepted, says what it wrote, and returns. Changes are made in the platform proposal before acceptance.
- Q: When should the starting-point line appear on a platform add or update proposal? → A: The line reads "**Here is a proposed starting point for configuring [Platform] as a platform capable of executing automation**". It appears only when Highway authored the proposal: the first showing, and re-showings after a question or an unknown. Not after an edit, and never on a remove.
- Q: How many entries can each When to use and When not to use list hold on a platform or standard? → A: At least one, with no upper limit. Every entry is grounded in and related to automation capabilities.
- Q: Is the implementation written as deterministic instructions or as prose? → A: Deterministic instructions and ordered steps. Each new or changed step is numbered conditions and actions. Each branch names the next step. Grounding, entry rules, the update path, and the return are stated as steps or as shapes, not as explanation.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The proposal is introduced as a starting point (Priority: P1)

A person adds or updates a platform in configuration. Configuration states the consequence of the change, then tells them the proposal that follows is a starting point for configuring that platform, then shows the proposal.

**Why this priority**: The person currently moves from the consequence sentence straight into the fields with nothing saying what the fields are or that they can change them.

**Independent Test**: Add a platform from an accepted implementation. The consequence sentence appears, then the starting-point line naming that platform, then `**Platform:**`.

**Acceptance Scenarios**:

1. **Given** a platform add, **When** the proposal is first shown, **Then** the consequence sentence comes first, then "**Here is a proposed starting point for configuring [Platform] as a platform capable of executing automation**", then the proposal fields.
2. **Given** a platform update, **When** the proposal is first shown, **Then** the same line appears in the same position.
3. **Given** the line, **When** it is read, **Then** [Platform] is replaced with the platform's title.

---

### User Story 2 - The line appears only where it is true (Priority: P2)

The line appears only where the proposal really is a starting point for configuring a platform.

**Why this priority**: A removal configures nothing. A proposal re-shown after an edit already contains the person's own changes.

**Independent Test**: Remove a platform and edit an add. Neither the removal proposal nor the re-shown proposal contains the line.

**Acceptance Scenarios**:

1. **Given** a platform removal, **When** its proposal is shown, **Then** the line does not appear.
2. **Given** an add or update proposal, **When** the person edits it and the proposal is shown again, **Then** the line does not appear.

---

### User Story 3 - Platform guidance follows automation best practice (Priority: P1)

A person adds or updates a platform. Its When to use and When not to use entries reflect accepted best practice for that type of platform in automation, such as a pipeline, an orchestrator, a GitOps tool, or an agent. They are not limited to what the accepted implementation happens to realize today.

**Why this priority**: Guidance taken from the implementation's realized capabilities only repeats what the record already says. It does not tell highway when this kind of platform is the right one to carry out an automation.

**Independent Test**: Add a pipeline platform whose implementation realizes only builds. When to use and When not to use name best-practice uses and limits for pipelines in automation, such as repeatable unattended runs and not long-lived interactive work, and not just builds.

**Acceptance Scenarios**:

1. **Given** a platform add or update, **When** the proposal is shown, **Then** each When to use and When not to use entry states a best practice for that platform's type as it relates to automation.
2. **Given** an implementation whose Realized Capabilities name less than the platform type supports, **When** the proposal is shown, **Then** the entries are not limited to those realized capabilities.
3. **Given** another platform row, **When** the proposal is shown, **Then** that row is still used to tell the two platforms apart and to assess conflicts.

---

### User Story 4 - Coding standard guidance follows automation best practice (Priority: P1)

A person adds or updates a coding standard. Its When to use and When not to use entries reflect accepted best practice for that language or platform type as it relates to automation.

**Why this priority**: The same grounding keeps platform guidance and standard guidance consistent when highway picks a platform and the standard it codes against.

**Independent Test**: Add a standard for a pipeline definition language. When to use and When not to use name best-practice uses and limits for that language in automation.

**Acceptance Scenarios**:

1. **Given** a standard add or update, **When** the proposal is shown, **Then** each When to use and When not to use entry states a best practice for that language or platform type as it relates to automation.
2. **Given** a standard proposal, **When** it is shown, **Then** its rules and file and folder structure keep their current grounding in the documentation `current` read.

---

### User Story 5 - Automation capabilities can become realized capabilities (Priority: P2)

While configuring a platform, the platform's current documentation describes automation capabilities the accepted implementation does not yet list. Those capabilities can become new realized capabilities.

**Why this priority**: Codify suggests automations from realized capabilities. A capability the platform really has but the record does not list is never suggested.

**Independent Test**: Configure a platform whose documentation describes an automation capability that is missing from the implementation's Realized Capabilities. The platform proposal lists it. Accepting the proposal writes the platform row, then `highway-implementation` records the capability on that implementation without asking again. Configuration then continues where it left off.

**Acceptance Scenarios**:

1. **Given** documentation describing an automation capability that the implementation does not realize, **When** `current` runs, **Then** that capability is captured and not dropped.
2. **Given** a captured automation capability that is not realized, **When** the platform proposal is shown, **Then** it is listed under New Realized Capabilities.
3. **Given** a capability that has nothing to do with automation, **When** `current` runs, **Then** it is not listed.
4. **Given** an accepted platform proposal that lists new realized capabilities, **When** the platform row is written, **Then** configuration emits a transition naming the implementation and follows `highway-implementation` for that implementation, with a return step in `highway-codify-config`.
5. **Given** that handoff, **When** `highway-implementation` runs, **Then** it adds exactly the accepted capabilities to the implementation's Realized Capabilities and to `implementations/capabilities.md`, says what it wrote, and returns to the held step without asking a question.
6. **Given** the platform proposal, **When** the person edits New Realized Capabilities before accepting, **Then** only the edited list is recorded.
7. **Given** the return, **When** configuration continues, **Then** it goes on to the conflicts question, the coding-standards question, or `platforms`, as it does today after a platform write.
8. **Given** an accepted platform proposal that lists no new realized capabilities, **When** the row is written, **Then** no handoff happens.

---

### User Story 6 - Each use entry names one thing in five words or fewer (Priority: P1)

A person reads When to use and When not to use on a platform or a coding standard. Each entry is a short item naming one thing, such as Workflow orchestration, Web Service, Application Front-End, Desired State Configuration Management, GitOps, or Code Deployment. An entry can be a condition or an outcome. A condition and an outcome are separate entries.

**Why this priority**: Short single-purpose labels are easy to compare across platforms and standards, and two entries that overlap are easy to see.

**Independent Test**: Add a platform and a standard. Every When to use and When not to use entry has at most five words and names one thing.

**Acceptance Scenarios**:

1. **Given** a platform or standard proposal, **When** it is shown, **Then** every When to use and When not to use entry has five words or fewer.
2. **Given** an entry, **When** it is read, **Then** it names one thing and does not join two things with "and", "or", a comma, or a slash.
3. **Given** two things to say, **When** the proposal is built, **Then** they become two entries.
4. **Given** a condition and its outcome, **When** the proposal is built, **Then** the condition is one entry and the outcome is another, each five words or fewer.
5. **Given** a platform or standard proposal, **When** it is shown, **Then** each list holds at least one entry, and every entry relates to automation capabilities.
6. **Given** an update to a row whose saved entry is longer than five words or names more than one thing, **When** the proposal is shown, **Then** that entry is proposed in the new form and the change is named in Consequences.

---

### User Story 7 - Why it matters sits under its entry (Priority: P1)

A person reads a platform or standard proposal. Under each When to use and When not to use entry, on its own line, is **Why it matters:** and one sentence.

**Why this priority**: The proposal shape is what the model copies. When the shape shows the line under the entry, the line reliably appears there.

**Independent Test**: Open a platform proposal and a standard proposal. Each shows **Why it matters:** on a new line directly under each [Entry].

**Acceptance Scenarios**:

1. **Given** the platform proposal shape and the standard proposal shape, **When** they are read, **Then** each [Entry] under When to use and When not to use is followed by a new line, indented under that entry, holding **Why it matters:** [One sentence.]
2. **Given** a proposal, **When** it is shown, **Then** every entry has exactly one Why it matters line, directly under it.
3. **Given** a catalog view, a conflict quote, or a saved cell, **When** it is read, **Then** it holds the entry only, with no Why it matters line.

---

### User Story 8 - Each skill states the change as ordered steps (Priority: P1)

A maintainer reads the changed parts of `highway-codify-config` and `highway-implementation`. Each is a numbered list of conditions and actions, or a proposal shape. Each branch names the step that follows. No sentence explains, justifies, or describes the flow.

**Why this priority**: The model follows ordered conditions and actions reliably. Prose leaves the order and the branch to interpretation.

**Independent Test**: Read `current`, `platform proposal`, `standard proposal`, and the `highway-implementation` update path. Each is numbered steps or a shape, each branch names its next step, and none uses the banned words.

**Acceptance Scenarios**:

1. **Given** a new or changed step, **When** it is read, **Then** it is numbered conditions and actions in the order they run.
2. **Given** a branch, **When** it is read, **Then** it names the next step.
3. **Given** a new or changed step, **When** it is read, **Then** it contains no so that, because, in order to, should, consider, prefer, usually, or where appropriate.
4. **Given** the `highway-implementation` update path, **When** it is read, **Then** it is its own step of 250 words or fewer.

---

### Edge Cases

- Configuration entered directly with a platform name, or handed off from onboarding or implementation, shows the same line on an add or update proposal that has not been edited.
- When the current documentation cannot be read, its notice still comes before the proposal step, and the line still appears between the consequence sentence and the fields.
- A question or an unknown before any edit re-shows the proposal unchanged, so the line appears again.
- When the documentation cannot be read, When to use and When not to use still come from best practice for the platform type, and no new realized capability is offered.
- A platform type with no clear best practice for automation still gets at least one When to use and one When not to use entry, based on the closest type the implementation's Technology Choice names.
- A remove neither offers new realized capabilities nor changes any.
- A hyphenated term, such as Front-End, counts as one word.
- A remove shows the saved entries as they are, with no Why it matters line and no rewrite.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The `platform proposal` step MUST emit "**Here is a proposed starting point for configuring [Platform] as a platform capable of executing automation**" after the consequence sentence and before `**Platform:**`.
- **FR-002**: The line MUST appear for an add and for an update.
- **FR-003**: The line MUST NOT appear for a remove.
- **FR-004**: The line MUST NOT appear when the proposal is re-shown after an `edit`. It MUST appear when the proposal is re-shown after a `question` or an `unknown` and no edit has been made.
- **FR-005**: [Platform] MUST be the platform's title, as on the `**Platform:**` line.
- **FR-006**: The line MUST be bold and match FR-001 exactly, with no trailing period.
- **FR-007**: Every new or changed step in `highway-codify-config` and `highway-implementation` MUST be numbered conditions and actions in the order they run, or a proposal shape. Each branch MUST name its next step. No new or changed sentence explains, justifies, or describes the flow. These steps MUST NOT contain so that, because, in order to, should, consider, prefer, usually, or where appropriate.
- **FR-007a**: Grounding (FR-009, FR-011) and entry rules (FR-022 to FR-027) MUST be numbered steps in one new step, `use entries`, which both `platform proposal` and `standard proposal` follow to build When to use and When not to use. Capture in `current` (FR-012) MUST be a numbered step in `current`. These rules MUST NOT stay as Procedure prose.
- **FR-007b**: The `highway-implementation` update path MUST be its own step of 250 words or fewer, entered from `Entry` by a numbered condition. A decision that does not fit an existing step MUST become its own step. Each changed step MUST stay at 400 words or fewer, excluding its heading.
- **FR-008**: `highway-codify-config` MUST move from 3.1.0 to 3.2.0, and `highway-implementation` from 7.1.0 to 7.2.0.
- **FR-009**: `platform proposal` MUST ground When to use and When not to use in best practice for the platform's type as it relates to automation. The type comes from the implementation's Technology Choice and `current`.
- **FR-010**: `platform proposal` MUST NOT ground When to use and When not to use in the implementation's Realized Capabilities or Runtime Components. Other platform rows MUST stay in use to tell platforms apart and to assess conflicts.
- **FR-011**: `standard proposal` MUST ground When to use and When not to use in best practice for that language or platform type as it relates to automation. Rules and the file and folder structure MUST keep their current grounding.
- **FR-012**: `current` MUST capture every automation capability the platform's documentation describes, whether or not the implementation realizes it. The sentence "For a platform, a documented capability is proposed only when the accepted implementation realizes it." MUST be removed.
- **FR-013**: `platform proposal` MUST list each captured automation capability that the implementation does not realize under **New Realized Capabilities**, with Title, Realized By, and Evidence. With none, it shows `None`. A remove does not show the field.
- **FR-014**: A capability that has nothing to do with automation MUST NOT be listed.
- **FR-015**: After the platform write, when the accepted proposal listed new realized capabilities, configuration MUST emit "Let's record the new capabilities for [Platform]." ([Platform] is the implementation title.) and follow `highway-implementation` for that implementation, passing those capabilities and a return step in `highway-codify-config`.
- **FR-016**: The return step MUST continue with the existing after-write order: the conflicts question, then the coding-standards question, then `platforms`.
- **FR-017**: `highway-implementation` MUST gain an update path, entered when the invocation names an accepted implementation, new realized capabilities, and a return step. It holds the return step for that visit.
- **FR-018**: The update path MUST NOT ask a question or show a proposal. It records exactly the capabilities passed from the accepted platform proposal. It MUST NOT change any other section of the record, the architecture, or the decision.
- **FR-019**: The update path MUST append the capabilities to the implementation's Realized Capabilities, write their rows to `implementations/capabilities.md` with the existing id rule, keep every other byte of the record, and say what it wrote. A failed write leaves both files unchanged and says what failed.
- **FR-020**: After the write or a failed write, the update path MUST go to the held return step. It MUST NOT emit `close`.
- **FR-021**: The update path MUST NOT run `platforms` in `highway-implementation`.
- **FR-022**: Each When to use and When not to use entry on a platform or standard MUST have five words or fewer and name one thing. Words are separated by spaces.
- **FR-023**: An entry MUST NOT join two things with "and", "or", a comma, or a slash. Two things MUST become two entries.
- **FR-024**: An entry MAY be a condition or an outcome. A condition and an outcome MUST be separate entries. The rule that each entry "is one sentence that names a condition and the required outcome" MUST be replaced by FR-022, FR-023, and this requirement.
- **FR-025**: Each When to use and When not to use list MUST hold at least one entry, with no upper limit.
- **FR-026**: Every entry MUST be grounded in and related to automation capabilities. An entry unrelated to automation MUST NOT be proposed.
- **FR-027**: On an update, a saved entry that breaks FR-022 or FR-023 MUST be proposed in the new form and named in Consequences.
- **FR-028**: The `platform proposal` and `standard proposal` shapes MUST show, under each [Entry] in When to use and When not to use, a new indented line: **Why it matters:** [One sentence.]
- **FR-029**: The Procedure paragraph that describes use entries and the Why it matters line MUST be removed. The proposal shapes place the Why it matters line, and the numbered entry rules sit in `platform proposal` and `standard proposal`.
- **FR-030**: The catalog view, a conflict quote, and the saved cell MUST keep the entry only.

### Key Entities

- **Starting-point line**: one bold line naming the platform. It sits between the consequence sentence and the proposal fields on an add or update proposal that has not been edited.
- **Platform type**: the kind of automation platform, such as a pipeline, an orchestrator, a self-service platform, a desired-state or GitOps tool, or an agent that starts the work. It selects the best practice that grounds When to use and When not to use.
- **New realized capability**: an automation capability the platform's documentation describes that the accepted implementation's Realized Capabilities do not list. It has a Title, Realized By, and Evidence, as in the implementation record.
- **Use entry**: one When to use or When not to use item. Five words or fewer, one thing, which is a condition or an outcome related to automation capabilities. Each list holds at least one. In a proposal it carries one Why it matters line beneath it. Saved and viewed, it is the label alone.
- **`use entries` step**: the one place that builds When to use and When not to use for platforms and standards. Numbered steps ground each entry in automation best practice and apply the entry rules. 250 words or fewer.
- **Update path**: a visit to `highway-implementation` that adds realized capabilities to one accepted implementation and returns to the caller's held step.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: On every add or update proposal that has not been edited, the starting-point line appears exactly once, between the consequence sentence and `**Platform:**`.
- **SC-002**: No remove proposal, and no proposal re-shown after an edit, contains the line.
- **SC-003**: The existing suite passes with 0 failures after the change.
- **SC-004**: Every When to use and When not to use entry in a platform or standard proposal states a best practice for its type in automation, and none restates a realized capability title.
- **SC-005**: Every automation capability the documentation describes and the implementation does not list appears under New Realized Capabilities, and no capability unrelated to automation appears there.
- **SC-006**: After an accepted update, the implementation record and the capability catalog both list the new capabilities, and no other record byte has changed.
- **SC-007**: Every update path visit asks no question and ends at the step configuration held, whether the write succeeds or fails.
- **SC-008**: Every When to use and When not to use entry in a platform or standard proposal has five words or fewer, names one thing, and relates to automation capabilities. Each list holds at least one entry.
- **SC-009**: Every entry in a platform or standard proposal has exactly one Why it matters line directly beneath it, and no saved cell or catalog view contains one.
- **SC-010**: Every new or changed step is numbered conditions and actions or a shape, every branch names its next step, and none of the banned words appears in them.
- **SC-011**: The update path and `use entries` are each 250 words or fewer, and no changed step exceeds 400 words.

## Assumptions

- "highway-config-config" in the request means `highway-codify-config`.
- "the consequence" is the existing "[One sentence stating the consequence of this change.]" line in `platform proposal`.
- The line is proposal framing only. The platform file and its row are unchanged.
- Offering new realized capabilities is a new capability, so the version change is MINOR.
- "Best practice" means practice widely accepted for that platform type in automation. `current` supplies what this platform can do. Best practice decides when this type is the right one to carry out an automation, and when it is not.
- The coding standard rules stay as they are. Only When to use and When not to use change grounding.
- The examples Workflow orchestration, Web Service, Application Front-End, Desired State Configuration Management, GitOps, and Code Deployment go into the skill as examples of the entry form.
- The five-word rule replaces the existing one-sentence condition-and-outcome form. Conditions and outcomes stay, as separate entries. Tests that pin that sentence move, with reasons recorded in planning.
- `standard proposal` is 383 words and `platform proposal` 279 words today. Moving grounding and entry rules into `use entries` keeps both under 400 once the Why it matters lines are added to their shapes.
- The update path uses the same return-step pattern as spec 216: the caller names a step, the callee holds it and goes there when done.
- An implementation update does not change the implementation's id, title, or status. The record has no version field, the implementation catalog is not written, and the capability catalog keeps its version line.
- After an edit, a later question or unknown re-shows the edited proposal, so the line stays off.
