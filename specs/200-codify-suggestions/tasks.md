---
description: "Task list for codify suggestions"
---

# Tasks: Codify Suggestions

**Input**: Design documents from `/specs/200-codify-suggestions/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: The specification does not request test-first work. The plan adds assertions to `.highway/tools/tests/highway-codify.test.sh`. No assertion is removed.

**Organization**: Tasks are grouped by user story. All four stories are P1 and stay in spec order. Task IDs follow execution order.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prove the suite is green before any edit

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing summary in `specs/200-codify-suggestions/baseline.txt`. Stop if it exits non-zero

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Give the saved proposal its new sections

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 Update `.highway/library/templates/output/codify-record.md` to version 2.0.0 per `specs/200-codify-suggestions/contracts/proposal-shape.md`. Add `## Summary`, `## Description`, `## Diagram`, and `## Acceptance Criteria`. In `## Components`, state `Responsibility:` and `Boundary:` for each component, or `None`. Keep `## Current State`, `## Action`, `## Day`, and `## Means`. The diagram skeleton is one fenced `flowchart` block
- [X] T003 Confirm `.highway/skills/highway-request/SKILL.md`, `.highway/skills/highway-assessment/SKILL.md`, and `.highway/library/templates/output/codify-catalog.md` are not edited

**Checkpoint**: The saved proposal can hold the suggestion's title and summary plus the new sections

---

## Phase 3: User Story 1 - See suggestions for this implementation (Priority: P1) 🎯 MVP

**Goal**: An implementation with no named action shows an ordered list of at most five self-service suggestions

**Independent Test**: Start codify with one accepted implementation and no named action. Read the list. It is ordered, each item has a title and a summary, and the question asks whether to explore an option or provide one of their own. Nothing is written

### Implementation for User Story 1

- [X] T004 [US1] In `.highway/skills/highway-codify/SKILL.md`, add a `suggest` step per `specs/200-codify-suggestions/contracts/suggestion-list.md` and `specs/200-codify-suggestions/research.md`. After an accepted implementation is selected and no action was named, emit `Based on the current state of this implementation, these may be worth visiting:` then at most five numbered items. Each item is `**[Title]:**` and one summary sentence. A title containing `establish` is establishing. Other realized capabilities run, change, or recover. The fitting kind comes first. Within a kind, keep Realized Capabilities order. When the leading kind is missing, add `Establish [implementation title]` or `Run [implementation title]`. Drop items past five from the end. Then ask `Would you like to explore any of these options?` and say `You can also provide your own.` An empty list says no suggestion is grounded. Do not write a file. Do not use an id as a label

**Checkpoint**: The list is shown once before any proposal

---

## Phase 4: User Story 2 - Choose a suggestion or provide one (Priority: P1)

**Goal**: A number, a title, a summary, or the person's own words selects one automation

**Independent Test**: Answer the list with a number, with a title, with a summary, and with an automation the list does not contain. Each answer selects one automation. Naming two actions keeps one

### Implementation for User Story 2

- [X] T005 [US2] In `.highway/skills/highway-codify/SKILL.md`, classify the reply to `suggest` before acting. A number, a title, or a summary on the list selects that suggestion and goes to `start`. The person's own automation selects that automation even when they also name a listed item. Two actions keep one, and the reply says the other waits for another run. A number that is not on the list asks again and writes nothing. Declining stops and writes nothing

**Checkpoint**: One automation is selected and nothing is written

---

## Phase 5: User Story 3 - Review the proposal for that choice (Priority: P1)

**Goal**: The proposal carries the selected title and summary, plus a description, a flowchart, acceptance criteria, and each component's responsibility and boundary

**Independent Test**: Select one suggestion and read the proposal. The title and summary match the suggestion. The description, diagram, acceptance criteria, and component boundaries are present. Nothing is written until it is accepted

### Implementation for User Story 3

- [X] T006 [US3] In `.highway/skills/highway-codify/SKILL.md`, extend `start` per `specs/200-codify-suggestions/contracts/proposal-shape.md`. Keep `Here is a proposed starting point for your automation:`, `What would you add, correct, or remove?`, and `If this is accurate, just say so.` Add title, summary, description, one fenced `flowchart`, acceptance criteria, and components. The title and summary are the ones just selected. The action is that same automation. Each component states `Responsibility:` and `Boundary:`. When no component is named, components are `None` and the flowchart has one node for the action title. Keep current state, day, and means. When the invocation already names one action, skip `suggest` and open this proposal. Removing the last acceptance criterion stays on `start` and writes nothing

**Checkpoint**: The proposal matches the choice and still writes nothing

---

## Phase 6: User Story 4 - Keep the accepted proposal (Priority: P1)

**Goal**: The saved proposal keeps the new sections, and acceptance still does not run the automation

**Independent Test**: Accept one proposal. Read the saved proposal. It contains the title, summary, description, diagram, acceptance criteria, and component boundaries. The automation has not been run, and the implementation record is unchanged

### Implementation for User Story 4

- [X] T007 [US4] In `.highway/skills/highway-codify/SKILL.md`, save the new proposal fields in `write` per `.highway/library/templates/output/codify-record.md`. Bump the skill version from 1.0.0 to 2.0.0. The saved record includes Summary, Description, Diagram, Acceptance Criteria, and each component's Responsibility and Boundary. Keep Current State, Action, Day, and Means. Do not run the automation. Do not change the implementation. Update Verification

**Checkpoint**: The accepted proposal is stored with the new sections

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Test, publish, and prove the suite is green

- [X] T008 Amend `.highway/tools/tests/highway-codify.test.sh` to require `Would you like to explore any of these options?`, `You can also provide your own.`, a fenced `flowchart`, `Responsibility:`, and `Boundary:` in `.highway/skills/highway-codify/SKILL.md`, and `## Summary`, `## Description`, `## Diagram`, and `## Acceptance Criteria` in `.highway/library/templates/output/codify-record.md`. Keep every existing assertion
- [X] T009 Run `.highway/tools/validate-library.sh` on `.highway/library/templates/output/codify-record.md` and `.highway/tools/validate-skill.sh` on `.highway/skills/highway-codify`. Repair only reported authoring-rule failures
- [X] T010 Run `.highway/tools/generate-library-catalog.sh`, `.highway/tools/generate-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh`
- [X] T011 Run `.highway/tools/tests/run-all.sh` once, with no other suite running, and require exit 0
- [X] T012 Execute the checks in `specs/200-codify-suggestions/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup. Blocks every user story
- **User Stories (Phases 3 to 6)**: Depend on Foundational. They edit `.highway/skills/highway-codify/SKILL.md` and stay in phase order
- **Polish (Phase 7)**: Depends on every user story

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational. Adds `suggest`
- **User Story 2 (P1)**: Starts after User Story 1. Classifies the reply to that list
- **User Story 3 (P1)**: Starts after User Story 2. Extends `start`
- **User Story 4 (P1)**: Starts after User Story 3. Extends `write`

### Parallel Opportunities

- T002 and T003 touch different files. T003 only confirms files stay unchanged, so it can run beside T002
- Do not parallelize T004, T005, T006, and T007. They edit `.highway/skills/highway-codify/SKILL.md`

---

## Parallel Example: User Stories

```text
Task: "T002 Update the saved proposal sections in .highway/library/templates/output/codify-record.md"
Task: "T003 Confirm .highway/skills/highway-request/SKILL.md is not edited"
```

---

## Implementation Strategy

### MVP First (User Story 1)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Stop and confirm an implementation with no named action shows the ordered list

### Incremental Delivery

1. User Story 1 shows the ordered suggestions
2. User Story 2 selects one suggestion or the person's own automation
3. User Story 3 shows the proposal for that choice
4. User Story 4 saves the proposal and does not run it
5. Polish adds the test assertions, publishes the skill, and requires a green suite

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to a user story for traceability
- Do not commit unless asked
- Stop at any checkpoint to validate that story on its own
