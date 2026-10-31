---
description: "Task list for highway codify"
---

# Tasks: Highway Codify

**Input**: Design documents from `/specs/199-highway-codify/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, retirements.md

**Tests**: The specification does not request test-first work. The plan adds `highway-codify.test.sh` and amends the citing-skill count in `output-template.test.sh`. That amendment is already recorded in `retirements.md`.

**Organization**: Tasks are grouped by user story. All five stories are P1 and stay in spec order. Task IDs follow execution order.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4, US5)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prove the suite is green before any edit

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing summary in `specs/199-highway-codify/baseline.txt`. Stop if it exits non-zero

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Give the automation record and catalog their shape

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 [P] Create `.highway/library/templates/output/codify-record.md` at version 1.0.0 to match `specs/199-highway-codify/contracts/record-and-catalog.md` and `specs/199-highway-codify/data-model.md`. Frontmatter is `id` (`CDY` plus eight hex digits), `implementation`, `architecture`, and `status: accepted`. The body states current state or `None`, one action, `Day 1` or `Day 2`, the means by architecture title, and the components or `None`
- [X] T003 [P] Create `.highway/library/templates/output/codify-catalog.md` at version 1.0.0 to match `specs/199-highway-codify/contracts/record-and-catalog.md`. The file is `code/code.md`. Columns are Automation ID, Implementation ID, Automation Title, Automation Path, and Status. More than one row may name the same Implementation ID. A removed row keeps its id and has no folder. Rows are ordered by Automation ID. There is no `Next ID` field. An empty baseline is `Version: 1.0.0` and the header
- [X] T004 Confirm `.highway/library/templates/output/implementation-record.md`, `.highway/library/templates/output/implementation-catalog.md`, `.highway/library/templates/output/request-record.md`, `.highway/library/templates/output/request-catalog.md`, and `.highway/skills/highway-assessment/SKILL.md` are not edited

**Checkpoint**: The templates define the saved proposal and the catalog

---

## Phase 3: User Story 1 - Choose an implementation by title (Priority: P1) 🎯 MVP

**Goal**: A person selects one accepted implementation by title or description, and the lists do not use ids as labels

**Independent Test**: Start codify with a title, with a description, with nothing while five or fewer implementations exist, and with nothing while more than five exist. Each path ends on one implementation, and the lists show titles and descriptions

### Implementation for User Story 1

- [X] T005 [US1] Create `.highway/skills/highway-codify/SKILL.md` at version 1.0.0 with the section order of `.highway/skills/highway-implementation/SKILL.md`. In Entry and `choose`, select an accepted implementation by exact title, by a description, or by a supplied id. After an id matches, show the title. When the person names nothing and one to five accepted implementations exist, list each by title and implementation summary. A number, a title, or a description selects one. When more than five exist and none is named, list none, ask for a title or description, then suggest at most five. Order those five as exact title, then realized capability title, then summary, each in implementation catalog order, compared without regard to case, per `specs/199-highway-codify/research.md`. When none exist or nothing matches, say so and write nothing. Do not use an id as a choice label

**Checkpoint**: One implementation can be selected by title or description

---

## Phase 4: User Story 2 - Review one proposed automation (Priority: P1)

**Goal**: The person sees one editable automation, its day, and the accepted architecture used as the means

**Independent Test**: Select one implementation and read the proposal. It contains one automation. Change the action, the day, or the means. The revised proposal still contains one automation, and nothing is written until it is accepted

### Implementation for User Story 2

- [X] T006 [US2] In `.highway/skills/highway-codify/SKILL.md`, add `start` per `specs/199-highway-codify/contracts/codify-flow.md`. Emit `Here is a proposed starting point for your automation:` with the current state, one action, Day 1 or Day 2, and the architecture title used as the means. Ask `What would you add, correct, or remove?` and say `If this is accurate, just say so.` Classify the reply before acting. An instance is running only when Context or Implementation Summary contains `instance is running` or `instances are running`. Show that sentence, or `None`. When the start carries an action, use that action and still set the day from the instance reading. When no action is carried, use `Establish [implementation title]` as Day 1, or the first realized capability title as Day 2, or `Run [implementation title]` when no capability exists. Keep one action and say a second waits for another run. The means is the implementation's accepted architecture. The person can switch to another accepted architecture by title. A means that is not accepted is refused. When no accepted architecture is available, say so and do not invent one. A preparation-only request stays a self-service action, with preparation left for the readme. Declining writes nothing

**Checkpoint**: The proposal is one automation and nothing is written yet

---

## Phase 5: User Story 3 - Receive one self-service automation (Priority: P1)

**Goal**: Acceptance writes one folder, one saved proposal, a two-part readme, and the component folders, and does not run the automation

**Independent Test**: Accept one proposal for one action. Confirm one catalog row, one folder, a readme with two instruction sets, and only the component folders that action needs. Confirm the implementation record is unchanged and the automation was not run

### Implementation for User Story 3

- [X] T007 [US3] In `.highway/skills/highway-codify/SKILL.md`, add `identifier`, `title`, `write`, and `close` per `specs/199-highway-codify/contracts/record-and-catalog.md` and `specs/199-highway-codify/data-model.md`. Derive `CDY` plus eight hex digits from the automation title with the same sampling map as an implementation id. A title collision shows a small title change and waits. On acceptance, write `code/code.md` and `code/<id>/` together: `codify.md`, `README.md` with `## Implement` then `## Use`, and one lowercased hyphenated subfolder per component the proposal names. Implement includes preparation. Use follows the accepted means and does not ask a non-technical person to edit generated files or read the implementation record. Do not run the automation. Do not change the implementation, its architecture, its decision, the request, the assessment finding, Controls, or NFRs. A failed write leaves no partial folder or catalog row. A removed row keeps its id and has no folder. The first catalog version is `1.0.0`. Adding a row increments the minor version. Emit no timestamp, random value, or environment value

**Checkpoint**: One accepted automation is on disk and has not been run

---

## Phase 6: User Story 4 - Follow the skill as steps (Priority: P1)

**Goal**: The skill reads as ordered instructions, in the same shape as the implementation skill

**Independent Test**: Read the skill from its first procedure step through the write. Each step says what to do next. The proposal step emits the starting-point block. No step is an essay about why codify exists

### Implementation for User Story 4

- [X] T008 [US4] In `.highway/skills/highway-codify/SKILL.md`, make the procedure emit only the active step, in this order: `choose` when no implementation is named, otherwise `start`, then `identifier`, `title` when needed, `write`, and `close`. Keep Purpose, When to use, When not to use, Inputs, Outputs, Procedure, Verification, Error Handling, and Example in that order. When to use lists two scenarios. Inputs name `.highway/library/templates/output/codify-record.md`, `.highway/library/templates/output/codify-catalog.md`, the implementation catalog and record, and the architecture catalog and record. Verification states the choice-list rule, the one-action proposal, the folder contents, and that acceptance does not run the automation. Error Handling stops without a write when `.highway/` is missing, a template is missing, the implementation is not accepted, or the write fails. The Example is labeled Illustrative and sits outside every numbered list. Do not create a second skill for a means, and do not put lifecycle activities on the implementation record

**Checkpoint**: The skill can be followed as steps

---

## Phase 7: User Story 5 - Reach an existing implementation from a request (Priority: P1)

**Goal**: An accepted request that matches an implementation closes with codify for that title and that action. No match closes with discovery

**Independent Test**: Close a request that matches one implementation, a request seeded from a finding that names two, and a request that matches none. Confirm the next step is codify, codify after a pick, or discovery. Confirm the proposal's action is the one the request asked for, the request does not state the day, and assessment writes no automation

### Implementation for User Story 5

- [X] T009 [P] [US5] In `.highway/skills/highway-request/SKILL.md`, replace the close that always names discovery, per `specs/199-highway-codify/contracts/codify-flow.md`. Bump the version from 4.0.0 to 5.0.0. After the request is written, match accepted implementations. A finding-seeded request uses the implementations named by that finding's accepted evidence. Otherwise match the request title and Desired Change by exact title, then realized capability title, then summary, using the same order as `specs/199-highway-codify/research.md`. One match names that implementation by title and tells the person to run `/highway-codify` for that title to do the one action from Desired Change. Two to five matches list titles and short descriptions, then use the one-match close after a pick and say the others wait for another run. More than five lists none until the person gives a title or description, then suggests at most five. No match tells the person to run `/highway-discovery` with the request id. The close does not state the day, does not continue into codify in the same message, and does not rewrite the request. Update Outputs, the Entry note that options are explored later, When not to use so the close may name an implementation, and Verification. Do not edit `.highway/skills/highway-assessment/SKILL.md`

**Checkpoint**: The request close chooses one next step

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Test, publish, and prove the suite is green

- [X] T010 Amend `.highway/tools/tests/output-template.test.sh` so the citing-skill count is 12 and `.highway/skills/highway-codify/SKILL.md` is in the citing list. Leave the retirement in `specs/199-highway-codify/retirements.md` as written
- [X] T011 Add `.highway/tools/tests/highway-codify.test.sh` with instrument-class, artifact-class, and seeded-failure-probe comments, mode 644. Require `Here is a proposed starting point for your automation:`, `What would you add, correct, or remove?`, `If this is accurate, just say so.`, `CDY`, `instance is running`, `instances are running`, `Establish`, `## Implement`, `## Use`, `code/code.md`, the many-rows catalog sentence, the removed-row sentence, the request close for `/highway-codify` and for `/highway-discovery`, and the assessment sentence that continues as `highway-request` at `start`. Reject `/highway-codify` in `.highway/skills/highway-assessment/SKILL.md` and reject an implementation id used as a choice label in `.highway/skills/highway-codify/SKILL.md`. Use `grep -Fq --`. The seeded probe is a choice line that labels an implementation by its id
- [X] T012 Run `.highway/tools/validate-library.sh` on `.highway/library/templates/output/codify-record.md` and `.highway/library/templates/output/codify-catalog.md`, and `.highway/tools/validate-skill.sh` on `.highway/skills/highway-codify` and `.highway/skills/highway-request`. Repair only reported authoring-rule failures
- [X] T013 Run `.highway/tools/generate-library-catalog.sh`, `.highway/tools/generate-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh`
- [X] T014 Run `.highway/tools/tests/run-all.sh` once, with no other suite running, and require exit 0
- [X] T015 Execute the checks in `specs/199-highway-codify/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup. Blocks every user story
- **User Stories (Phases 3 to 7)**: Depend on Foundational. Stories that share `highway-codify` stay in phase order
- **Polish (Phase 8)**: Depends on every user story

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational. Creates `.highway/skills/highway-codify/SKILL.md`
- **User Story 2 (P1)**: Starts after User Story 1. Fills `start` in that skill
- **User Story 3 (P1)**: Starts after User Story 2. Fills the write in that skill
- **User Story 4 (P1)**: Starts after User Story 3. Finishes the procedure shape in that skill
- **User Story 5 (P1)**: Starts after Foundational. Edits only `.highway/skills/highway-request/SKILL.md` and can proceed beside User Stories 1 through 4

### Parallel Opportunities

- T002 and T003 edit two different templates
- T009 edits only `highway-request` and can run beside T005 through T008
- Do not parallelize T005, T006, T007, and T008. They edit `.highway/skills/highway-codify/SKILL.md`

---

## Parallel Example: User Stories

```text
Task: "T005 [US1] Create the codify choose step in .highway/skills/highway-codify/SKILL.md"
Task: "T009 [US5] Route a matching request to codify in .highway/skills/highway-request/SKILL.md"
```

---

## Implementation Strategy

### MVP First (User Story 1)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Stop and confirm an implementation can be selected by title or description

### Incremental Delivery

1. User Story 1 selects one implementation by title or description
2. User Story 2 shows one editable automation
3. User Story 3 writes that automation and does not run it
4. User Story 4 makes the skill followable as steps
5. User Story 5 sends a matching request to codify and leaves every other request on discovery
6. Polish adds the test, publishes the skill, and requires a green suite

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to a user story for traceability
- Do not commit unless asked
- Stop at any checkpoint to validate that story on its own
