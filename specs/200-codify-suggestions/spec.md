# Feature Specification: Codify Suggestions

**Feature Branch**: `200-codify-suggestions`

**Created**: 2026-10-31

**Status**: Draft

**Input**: User description: "When a user first runs highway-codify and has supplied a reference implementation record, provide an ordered list of self-service automation suggestions (Title and Summary) based on the current state of the implementation. Ask if they would like to explore any of the options, or they can provide their own. Use similar phrasing from the other skills. Once a selection has been made, present a proposal that carries the same title and summary, and also contains a description, a diagram of the automation, acceptance criteria, and each component with its boundary and responsibility in the automation."

## Clarifications

### Session 2026-10-31

- Q: When codify is started with an implementation and the person already named the action, should the suggestion list still appear? → A: Skip the list and open the proposal for that action.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - See suggestions for this implementation (Priority: P1)

A person starts codify with an accepted implementation and has not named an automation. They see an ordered list of self-service automations that fit the current state of that implementation. Each suggestion has a title and a short summary. The list uses the same explore question the other skills use, and it tells them they can provide their own. When the invocation already names one action, the list is skipped and the proposal opens on that action.

**Why this priority**: The person should see grounded choices before a proposal is written. A single invented action hides the other automations the implementation can support.

**Independent Test**: Start codify with one accepted implementation and no named action. Read the list. It is ordered, each item has a title and a summary, and the question asks whether to explore an option or provide one of their own. Nothing is written.

**Acceptance Scenarios**:

1. **Given** an accepted implementation and no named action, **When** codify starts, **Then** it shows an ordered list of self-service suggestions drawn from that implementation's current state.
2. **Given** the list, **When** it is read, **Then** each suggestion has one title and one summary, the items are numbered from 1, and the list contains at most 5 suggestions.
3. **Given** the list, **When** the question is read, **Then** it asks whether the person would like to explore any of these options, and it says they can provide their own.
4. **Given** no instance is running, **When** the list is ordered, **Then** a suggestion that establishes the implementation comes before a suggestion that runs, changes, or recovers one.
5. **Given** an instance is running, **When** the list is ordered, **Then** a suggestion that runs, changes, or recovers the instance comes before a suggestion that establishes one.
6. **Given** the person has not selected a suggestion, **When** the repository is read, **Then** nothing is written.
7. **Given** the invocation already names one action, **When** codify starts, **Then** the suggestion list is not shown and the proposal opens on that action.

---

### User Story 2 - Choose a suggestion or provide one (Priority: P1)

The person explores one suggestion, or states an automation of their own. That choice is the one automation the proposal will describe. A second action is not added to the same choice.

**Why this priority**: The list is only useful if a number, a title, a summary, or the person's own words selects exactly one automation.

**Independent Test**: Answer the list with a number, with a title, with a summary, and with an automation the list does not contain. Each answer selects one automation. Naming two actions keeps one.

**Acceptance Scenarios**:

1. **Given** the list, **When** the person gives a number, a title, or a summary from that list, **Then** that one suggestion is selected.
2. **Given** the list, **When** the person provides their own automation, **Then** that automation is selected and the listed suggestions are not used.
3. **Given** the person names two actions, **When** codify responds, **Then** it keeps one and says the other waits for another run.
4. **Given** the person declines the list, **When** codify stops, **Then** nothing is written.

---

### User Story 3 - Review the proposal for that choice (Priority: P1)

After the choice, the person sees one proposal. It carries the same title and the same summary as the choice. It also describes the automation, shows a diagram of it, states the acceptance criteria, and names each component with the boundary and the responsibility of that component in this automation. The person can correct the proposal before anything is written.

**Why this priority**: The suggestion is a starting point. The proposal is what the person accepts, and it has to show how the automation is put together.

**Independent Test**: Select one suggestion and read the proposal. The title and summary match the suggestion. The description, diagram, acceptance criteria, and component boundaries are present. Change one of them. The revision is shown, and nothing is written until it is accepted.

**Acceptance Scenarios**:

1. **Given** a selected suggestion, **When** the proposal is shown, **Then** its title is that suggestion's title and its summary is that suggestion's summary.
2. **Given** the person provided their own automation, **When** the proposal is shown, **Then** the title and summary are that automation, not a suggestion they did not choose.
3. **Given** the proposal, **When** it is read, **Then** it contains one description, one diagram of the automation, one or more acceptance criteria, and each component's responsibility and boundary in this automation.
4. **Given** the diagram, **When** it is read, **Then** it shows the components and how the one action moves through them.
5. **Given** the person adds, corrects, or removes part of the proposal, **When** it is shown again, **Then** the change is present and the proposal still describes one automation.
6. **Given** the person declines the proposal, **When** codify stops, **Then** nothing is written.

---

### User Story 4 - Keep the accepted proposal (Priority: P1)

The person accepts the proposal. The saved proposal keeps the title, summary, description, diagram, acceptance criteria, and component responsibilities and boundaries. Accepting still does not run the automation and does not change the implementation.

**Why this priority**: The review is lost if the saved proposal drops the diagram, the criteria, or the component boundaries.

**Independent Test**: Accept one proposal. Read the saved proposal. It contains the same title, summary, description, diagram, acceptance criteria, and component boundaries. The automation has not been run, and the implementation record is unchanged.

**Acceptance Scenarios**:

1. **Given** the person accepts the proposal, **When** the saved proposal is read, **Then** it contains the title, the summary, the description, the diagram, the acceptance criteria, and each component's responsibility and boundary.
2. **Given** acceptance succeeds, **When** the automation is inspected, **Then** it has not been run.
3. **Given** acceptance succeeds, **When** the implementation is read, **Then** it is unchanged.
4. **Given** a component was removed from the proposal before acceptance, **When** the saved proposal is read, **Then** that component is absent.

---

### Edge Cases

- The implementation supports more than five self-service actions. The list shows five, with the ones that fit the current state first.
- The implementation supports fewer than five. The list shows only those it supports.
- No self-service action can be grounded in the implementation. The list is empty, the person can provide their own, and nothing is written until a proposal is accepted.
- The person selects a number that is not on the list. Codify asks again and writes nothing.
- The person provides their own automation and also names a listed suggestion. The person's own automation is the one selected.
- The proposal has no component. Components are `None`, and the diagram shows the one action without a component split.
- The person removes every acceptance criterion. Codify does not write until at least one criterion remains.
- The invocation already names the one action. The suggestion list is not shown. The proposal opens on that action and still includes the description, diagram, acceptance criteria, and component boundaries.
- The selected implementation is not accepted. Codify writes nothing.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: When codify starts with an accepted implementation and no named action, the system MUST show an ordered list of self-service automation suggestions before any proposal.
- **FR-002**: Each suggestion MUST have one title and one summary. The list MUST be numbered from 1 and MUST contain at most 5 suggestions.
- **FR-003**: The list MUST be ordered from the implementation's current state. When no instance is running, an establishing suggestion MUST come before a suggestion that runs, changes, or recovers an instance. When an instance is running, that order MUST be reversed.
- **FR-004**: Within the same kind of suggestion, the list MUST follow the order of the realized capabilities on the implementation record.
- **FR-005**: The list MUST ask whether the person would like to explore any of these options, and MUST say they can provide their own. The question MUST use the explore wording the other skills use for a numbered list.
- **FR-006**: A number, a title, or a summary from the list MUST select that one suggestion. The person's own automation MUST select that automation instead of a listed suggestion.
- **FR-007**: A second action in the same choice MUST be refused. One action remains, and the reply MUST say the other waits for another run.
- **FR-008**: Declining the list or the proposal MUST write nothing.
- **FR-009**: After one automation is selected, the system MUST show one proposal before any write. The proposal title MUST be the selected title, and the proposal summary MUST be the selected summary.
- **FR-010**: The proposal MUST contain one description, one diagram of the automation, one or more acceptance criteria, and, for each component, that component's responsibility in the automation and the boundary of that responsibility.
- **FR-011**: The diagram MUST show the components and how the one action moves through them. When the proposal names no component, the diagram MUST show the one action and the components MUST be `None`.
- **FR-012**: The person MUST be able to add, correct, or remove the proposal before acceptance. The revised proposal MUST still describe one automation. Removing every acceptance criterion MUST stop the write until one criterion remains.
- **FR-013**: The proposal MUST use the established starting-point heading and the correction question already used for an automation proposal.
- **FR-014**: Acceptance MUST save the title, summary, description, diagram, acceptance criteria, and each component's responsibility and boundary. Acceptance MUST NOT run the automation and MUST NOT change the implementation.
- **FR-015**: When the invocation already names one action, the system MUST skip the suggestion list and open the proposal for that action. That proposal MUST still satisfy FR-010.
- **FR-016**: The new list and the richer proposal MUST be imperative steps in `highway-codify`. The system MUST NOT add a second skill for suggestions.

### Key Entities

- **Suggestion**: One self-service automation offered for one implementation. It has a title and a summary. It is not saved.
- **Proposal**: The editable statement of the selected automation. It carries that title and summary, plus a description, a diagram, acceptance criteria, and the responsibility and boundary of each component.
- **Component boundary**: Where that component's responsibility in this one automation starts and stops.
- **Acceptance criterion**: A condition a person can check to see that this one automation is ready to use.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A start with an accepted implementation and no named action shows a list of at most 5 suggestions. Each suggestion has 1 title and 1 summary. The list is shown 1 time before any proposal.
- **SC-002**: Selecting item 1 produces a proposal whose title equals that item's title and whose summary equals that item's summary.
- **SC-003**: Every proposal contains 1 description, 1 diagram, and at least 1 acceptance criterion. Every named component has 1 responsibility and 1 boundary.
- **SC-004**: A proposal that contains 0 acceptance criteria produces 0 files.
- **SC-005**: Acceptance runs the automation 0 times and changes the implementation record in 0 places.
- **SC-006**: An invocation that already names 1 action shows the suggestion list 0 times and shows 1 proposal for that action.

## Assumptions

- "First runs" means the opening of a codify run once an implementation is selected. It does not mean the first automation ever written for that implementation.
- The list contains at most 5 suggestions, which is the same cap the other skills use for a list of choices.
- An instance is running under the same reading codify already uses. The list does not invent a current state the implementation record does not support.
- A suggestion the record cannot ground is left off the list. The means remains an accepted architecture. The list does not name a tool that architecture does not describe.
- When the person provides their own automation, its title is a short name for that automation and its summary is one sentence. They can correct both on the proposal.
- Exploring a suggestion opens the proposal for that one automation. It does not open a second detail screen, and it does not write a file.
- The current state, the day, and the accepted architecture used as the means stay on the proposal. This feature adds the description, the diagram, the acceptance criteria, and the component boundaries. It does not remove those earlier fields.
- The diagram is part of the proposal the person reads and part of the saved proposal. The notation of the diagram is left to planning.
- The saved proposal is still the automation record. The catalog still identifies the automation by its title. Component folders are still created only for components the accepted proposal names.
- The request close is unchanged. When that close already names the action, codify opens the proposal for that action and does not insert the suggestion list.
