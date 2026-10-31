# Feature Specification: Highway Codify

**Feature Branch**: `199-highway-codify`

**Created**: 2026-10-31

**Status**: Draft

**Input**: User description: "Create a new spec implementing the highway-codify skill as discussed. One accepted run produces one self-service automation from an implementation the person names by title or description. The proposal is editable before acceptance. The means comes from an accepted architecture. Acceptance writes the proposal, a two-part readme, and the automation files. The skill instructions follow the same imperative, minimal-prose pattern as the other skills."

## Clarifications

### Session 2026-10-31

- Q: When an implementation has no running instance yet, what should the first proposed automation be? → A: One self-service Day 1 action. Preparation is enabling work in the readme, not its own automation.
- Q: When a request leads to codify, what should the first proposed automation be? → A: The one action the accepted request asked for. Day 1 or Day 2 still follows whether an instance is running.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Choose an implementation by title (Priority: P1)

A person runs codify and names the implementation to automate. They name it by title or by describing it. When they name nothing, they see a short list of titles and descriptions, or they are asked for a title or description when the list would be long.

**Why this priority**: Codify cannot propose an automation until it knows which implementation it serves. The person works from titles and descriptions.

**Independent Test**: Run codify with a title, with a description, with nothing while five or fewer implementations exist, and with nothing while more than five exist. Each path ends on one implementation, and the lists show titles and descriptions.

**Acceptance Scenarios**:

1. **Given** the person names an implementation by its exact title, **When** codify starts, **Then** that implementation is selected and its title is what the person sees.
2. **Given** the person describes an implementation, **When** more than one accepted implementation fits, **Then** codify suggests at most five by title and description.
3. **Given** the person names nothing and one to five accepted implementations exist, **When** codify starts, **Then** it lists each by title and a short description. A number, a title, or a description selects one.
4. **Given** the person names nothing and more than five accepted implementations exist, **When** codify starts, **Then** it lists none. It tells the person they can give a title or a description, and then suggests at most five matches.
5. **Given** the person supplies an implementation id, **When** it matches one accepted implementation, **Then** codify selects it and shows the title from then on.
6. **Given** no accepted implementation exists, **When** codify starts, **Then** it says so and writes nothing.

---

### User Story 2 - Review one proposed automation (Priority: P1)

A person sees one proposed automation for the selected implementation. The proposal states the current state, the single action, whether it establishes or runs, and the accepted architecture that supplies the means. The person can change the proposal before anything is written.

**Why this priority**: The automation must be accepted as one self-service action. A bundle of actions would make the result something a non-technical person cannot run as one thing.

**Independent Test**: Select one implementation and read the proposal. It contains one automation. Change the action, the day, or the means. The revised proposal still contains one automation, and nothing is written until it is accepted.

**Acceptance Scenarios**:

1. **Given** an accepted implementation, **When** the proposal is shown, **Then** it states the current state, one automation in plain language, Day 1 or Day 2, and the title of the accepted architecture used as the means.
2. **Given** the implementation already has a running instance, **When** the proposal is first shown, **Then** the automation is a Day 2 action.
3. **Given** the implementation has no instance yet, **When** the proposal is first shown, **Then** the automation is one self-service Day 1 action. Preparation appears in the enabling instructions and is not its own automation.
4. **Given** the person adds, corrects, or removes part of the proposal, **When** it is shown again, **Then** the change is in the proposal and it still describes one automation.
5. **Given** the person names a second action in the same proposal, **When** codify responds, **Then** it keeps one action and says the other waits for another run.
6. **Given** the person names a means that no accepted architecture describes, **When** the proposal is shown again, **Then** that means is not added.
7. **Given** more than one accepted architecture can supply the means, **When** the proposal is shown, **Then** it selects one by title and the person can switch to another accepted architecture.
8. **Given** the person declines the proposal, **When** codify stops, **Then** nothing is written.

---

### User Story 3 - Receive one self-service automation (Priority: P1)

A person accepts the proposal and receives one automation they can enable, plus instructions a non-technical person can follow to use it. Accepting writes the files. It does not run the automation.

**Why this priority**: The value of codify is the automation and the two sets of instructions. The person who accepts may be a platform engineer or a business owner. The person who later runs it is treated as non-technical.

**Independent Test**: Accept one proposal for one action, such as provisioning, configuring a safeguard, or restarting. Confirm one folder, one saved proposal, a readme with two instruction sets, and the component folders that action needs. Confirm the implementation record is unchanged and the automation was not run.

**Acceptance Scenarios**:

1. **Given** the person accepts the proposal, **When** the write finishes, **Then** one catalog row and one folder exist for that automation.
2. **Given** the folder, **When** it is read, **Then** it contains the saved proposal and a readme. The readme has one part for enabling the automation and one part for a non-technical person to use it.
3. **Given** the enabling instructions, **When** they are read, **Then** they say what is being put in place, where it goes, and how to enable it.
4. **Given** the use instructions, **When** they are read, **Then** they say how to start this one automation, what to provide, and what comes back, using the interface of the accepted means.
5. **Given** the accepted proposal names the components of this one action, **When** the folder is read, **Then** each of those components has one folder and no extra component folder exists.
6. **Given** acceptance succeeds, **When** the implementation, its architecture, and its decision are read, **Then** they are unchanged.
7. **Given** acceptance succeeds, **When** the automation is inspected, **Then** its files exist and it has not been run.
8. **Given** a write fails, **When** the repository is read, **Then** no partial codify folder or catalog row remains.

---

### User Story 4 - Follow the skill as steps (Priority: P1)

A person maintaining the skill can follow it the way they follow the other Highway skills. The instructions are steps. They say what to emit and how to classify a reply. They do not explain the workflow in prose.

**Why this priority**: The skill has to be executable as instructions. A prose description of codify would not match the other skills.

**Independent Test**: Read the skill from its first procedure step through the write. Each step says what to do next. The proposal step emits the starting-point block. No step is an essay about why codify exists.

**Acceptance Scenarios**:

1. **Given** the skill, **When** its procedure is read, **Then** the steps are ordered and each step is an instruction.
2. **Given** a person replies, **When** the skill handles it, **Then** the reply is classified before the next action.
3. **Given** the proposal step, **When** it emits the proposal, **Then** it uses the same starting-point heading and correction question as the other proposal-first skills.
4. **Given** the skill body, **When** it is compared with the implementation, architecture, and decision skills, **Then** it uses the same section order and imperative style.

---

### User Story 5 - Reach an existing implementation from a request (Priority: P1)

A platform engineer or a business owner asks for something an accepted implementation already covers. They may start from an assessment finding or from a request in their own words. The request is accepted and written. Its closing message chooses the next skill. One matching implementation leads to codify for that title and the one action the request asks for. Several matches are listed by title and description, and the person picks one. No match leads to discovery. Codify then proposes that action and states Day 1 or Day 2 from whether an instance is running.

**Why this priority**: Enablement, restart, and provisioning are automations of work the repository already accepted. The person should reach that automation from the request they just made.

**Independent Test**: Close a request that matches one implementation, a request seeded from a finding that names two, and a request that matches none. Confirm the next step is codify, codify after a pick, or discovery. Confirm the proposal's action is the one the request asked for, the request does not state the day, and assessment writes no automation.

**Acceptance Scenarios**:

1. **Given** an accepted request whose words match one accepted implementation by exact title, by its summary, or by a realized capability title, **When** the request closes, **Then** the close names that implementation by title and the next step is `/highway-codify` with that title and the one action the request asks for.
2. **Given** a request seeded from an assessment finding whose accepted evidence names two accepted implementations, **When** the request closes, **Then** the close lists those two by title and short description. After the person picks one, the next step is `/highway-codify` with that title and the one action the request asks for, and the close says the other waits for another run.
3. **Given** a request that matches no accepted implementation, **When** the request closes, **Then** the next step is `/highway-discovery` with the request id.
4. **Given** an accepted request that asks to restart, and the matched implementation already has a running instance, **When** codify proposes the automation, **Then** the proposal is that restart action and it is Day 2. The request close did not state the day.
5. **Given** an accepted request that asks to provision, and the matched implementation has no running instance, **When** codify proposes the automation, **Then** the proposal is that provisioning action and it is one self-service Day 1 action. The request close did not state the day.
6. **Given** a platform engineer or a business owner states the request in ordinary language, **When** the close matches an implementation, **Then** the close shows titles and descriptions.
7. **Given** the person explores an assessment finding, **When** assessment continues, **Then** the finding becomes a request. Assessment does not start codify and does not write an automation.
8. **Given** an accepted request that asks to provision, and the matched implementation already has a running instance, **When** codify proposes the automation, **Then** the proposal is that provisioning action and it is Day 2. The person can correct the proposal before acceptance.

---

### Edge Cases

- The title matches no accepted implementation. Codify says so and writes nothing.
- A description matches more than five implementations. The suggestion list is five.
- A description matches nothing. Codify asks again and writes nothing.
- The selected implementation is not accepted. Codify writes nothing.
- No accepted architecture describes a means. The proposal says so and does not invent one.
- The person switches the means to an architecture that is not accepted. The switch is refused.
- The person accepts while the proposal still contains two actions. Codify does not write until one action remains.
- The automation title collides with an existing codify title. The existing title distinction applies, and the person sees a small title change before a write.
- A second run for the same implementation creates another automation and another folder. The first remains.
- A removed codify row keeps its id and has no folder.
- The enabling work is incomplete. The use instructions still describe the finished interface, and the enabling instructions state what remains to be done.
- The person asks codify to run the automation. Codify does not run it.
- The person asks for a preparation-only automation. Codify keeps a self-service action and puts the preparation in the enabling instructions.
- A request description matches more than five implementations. The close lists none until the person gives a title or description, then suggests at most five.
- The person asks the close to automate two matching implementations in one run. The close keeps one and says the other waits for another run.
- The person wants the platform's own enablement for the matched implementation. The proposal uses the means that implementation's accepted architecture describes. When no accepted architecture describes a means, the proposal says so.
- The request matches one implementation. The close contains that one next step.
- The accepted request asks for an action that usually belongs to the other day. The proposal keeps that action and states the day from whether an instance is running. The person can correct the proposal.
- Codify is started with no accepted request. The first proposal follows whether an instance is running.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST provide a skill named `highway-codify`.
- **FR-002**: One acceptance MUST produce one automation. Provisioning, configuring a safeguard, and restarting are separate runs.
- **FR-003**: The person MUST be able to select an implementation by exact title or by a description. A supplied id MUST select the matching accepted implementation, and the skill MUST show that implementation's title afterward.
- **FR-004**: When the person names nothing and one to five accepted implementations exist, the skill MUST list them by title and short description. A number, a title, or a description MUST select one.
- **FR-005**: When more than five accepted implementations exist and the person has not named one, the skill MUST list none. It MUST tell the person they can give a title or a description, and then suggest at most five matches by title and description.
- **FR-006**: When no accepted implementation exists, or the name matches none, the skill MUST write nothing.
- **FR-007**: The proposal MUST be shown before any write. It MUST state the current state, one automation, Day 1 or Day 2, and the title of one accepted architecture used as the means.
- **FR-008**: Day 2 MUST be the first proposal when the implementation already has a running instance. When it does not, the first proposal MUST be one self-service Day 1 action. Preparation MUST be enabling work in the readme and MUST NOT be its own automation.
- **FR-009**: The means MUST be an accepted architecture. When none describes a means, the proposal MUST say so and MUST NOT invent one. When several fit, the proposal MUST select one, and the person MUST be able to switch to another accepted architecture.
- **FR-010**: The person MUST be able to add, correct, or remove the proposal before acceptance. The revised proposal MUST still contain one automation. A second action MUST be refused with the statement that it waits for another run.
- **FR-011**: Declining the proposal MUST write nothing. Accepting it MUST be the only confirmation.
- **FR-012**: Acceptance MUST write one catalog row and one folder for that automation. The folder MUST contain the saved proposal, a readme, and one folder for each component the accepted proposal names. It MUST NOT contain a component the proposal does not name.
- **FR-013**: The readme MUST contain two instruction sets. The first says what is being put in place, where it goes, and how to enable it, including the preparation the automation needs, for a platform engineer or a business owner. The second says how a non-technical person starts this one automation, what they provide, and what they receive.
- **FR-014**: The use instructions MUST follow the interface of the accepted means. They MUST NOT ask the non-technical person to edit the generated files or read the implementation record.
- **FR-015**: Acceptance MUST NOT run the automation. It MUST NOT change the implementation, its architecture, its decision, the request, the assessment finding, Controls, or NFRs.
- **FR-016**: A failed write MUST leave no partial folder or catalog row, and MUST leave every existing record unchanged.
- **FR-017**: The catalog MUST list every accepted automation. More than one row MAY name the same implementation. A removed row MUST keep its id and MUST have no folder.
- **FR-018**: Lists the person uses to choose MUST show titles and descriptions. They MUST NOT use ids as the labels of those choices.
- **FR-019**: The skill instructions MUST be imperative steps with minimal prose, in the same section order and reply-classification pattern as the implementation, architecture, and decision skills. The procedure MUST emit only the active step. The proposal step MUST use the established starting-point heading and the correction question.
- **FR-020**: The skill MUST NOT create plans, tasks, or a second skill for a particular means.
- **FR-021**: An explored assessment finding MUST become a request. Assessment MUST NOT start codify and MUST NOT write an automation.
- **FR-022**: Once one implementation is selected, the accepted request's closing message MUST contain exactly one next step. While two to five matches are still open, the close lists them and waits for the pick.
- **FR-023**: A match MUST be an accepted implementation named by exact title, by its summary, or by a realized capability title. When the request was seeded from an assessment finding, the matches MUST be the accepted implementations named by that finding's accepted evidence.
- **FR-024**: When one implementation matches, the close MUST name it by title and the next step MUST be `/highway-codify` with that title and the one action the request asks for.
- **FR-025**: When two to five implementations match, the close MUST list them by title and short description. After the person picks one, the next step MUST be `/highway-codify` with that title and the one action the request asks for, and the close MUST say the others wait for another run.
- **FR-026**: When more than five implementations match, the close MUST list none. It MUST tell the person they can give a title or a description, and then suggest at most five matches by title and description.
- **FR-027**: When no accepted implementation matches, the next step MUST be `/highway-discovery` with the request id.
- **FR-028**: The request close MUST NOT state whether the automation is Day 1 or Day 2. Codify chooses that when it proposes the automation.
- **FR-029**: The close MUST show titles and descriptions. It MUST NOT use implementation ids as the labels of those choices.
- **FR-030**: When codify is reached from an accepted request, the first proposal MUST use the one action that request asks for. It MUST state Day 2 when an instance is running and Day 1 when it is not. When that request asks for more than one action, the proposal MUST keep one and say the other waits for another run. When codify is started with no accepted request, the first proposal MUST follow whether an instance is running. The person MUST be able to correct the proposal before acceptance.

### Key Entities

- **Codify proposal**: The editable statement of one automation before acceptance. It names the current state, the action, the day, and the means.
- **Automation**: One self-service action for one implementation. It has one saved proposal, one readme, and the component folders that action needs.
- **Codify catalog**: The index of accepted automations. One implementation can have many rows.
- **Means**: One accepted architecture that describes how the automation is delivered. The proposal names it by title.
- **Enabling instructions**: What the person who accepted the proposal puts in place, where, and how, including the preparation the automation needs.
- **Use instructions**: How a non-technical person starts that one automation.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A person can select an implementation by title or description. A choice list contains at most 5 implementations. More than 5 accepted implementations produces a list of 0 until the person gives a title or description.
- **SC-002**: One acceptance produces exactly 1 automation. A proposal that still contains 2 actions produces 0 files.
- **SC-003**: Every accepted automation has 1 saved proposal and 1 readme. The readme contains 2 instruction sets.
- **SC-004**: Acceptance runs the automation 0 times and changes the implementation record in 0 places.
- **SC-005**: The means named on an accepted automation is 1 accepted architecture, or the proposal names 0 means when no accepted architecture describes one.
- **SC-006**: A second accepted run for the same implementation adds 1 catalog row and leaves the first automation in place.
- **SC-007**: The skill procedure is a sequence of instructions. A reply is classified before the next step, and the proposal uses the same starting-point heading and correction question as the other proposal-first skills.
- **SC-008**: A request that matches 1 accepted implementation closes with exactly 1 next step, `/highway-codify` for that title and the one action the request asks for.
- **SC-009**: A request that matches 0 accepted implementations closes with `/highway-discovery` for that request.
- **SC-010**: A finding whose evidence names 2 accepted implementations produces a close that lists 2 titles. After a pick, 1 codify run is the next step and the other implementation is left for another run.
- **SC-011**: The request close states the day in 0 places. A restart request against a running instance yields that restart action as a Day 2 proposal. A provision request against no running instance yields that provision action as one Day 1 proposal.

## Assumptions

- Day 1 establishes the first instance. Day 2 runs, changes, or recovers an instance that already exists. When an accepted request names the action, that action is the first proposal, and the day still follows whether an instance is running. When no request names an action, Day 1 is the first proposal with no instance and Day 2 is the first proposal when one is running. Preparation of the means is enabling work in the readme, not a Day 0 automation.
- The short description in a choice list is the implementation summary.
- The automation title is the name of the one action. An id collision uses the same title distinction as the other records, and the person sees a title rather than an id.
- The catalog stores the id so the folder stays tied to the implementation. The person is not asked to work from that id.
- A component folder is created only for a part the accepted proposal includes. One action may have more than one component folder when those parts together perform that single action.
- The governed repository root receives the catalog and the automation folders, in the same way it receives implementation records.
- Codify does not put lifecycle activities back on the implementation record.
- The person who accepts may still have enabling work to do. That work is described in the first readme section. It is not a second automation.
- A platform engineer and a business owner both submit the request in ordinary language. The close matches an accepted implementation by title, summary, or realized capability. The person is not asked for an implementation id.
- Exploring a finding still writes the request. The finding's accepted evidence supplies the implementations when the person did not name them.
- The request record does not store the matched implementation. The closing message carries the implementation title and the one action to codify. The close does not carry the day.
- Wanting the platform's own enablement uses the means the accepted architecture already describes. It does not add a means.
