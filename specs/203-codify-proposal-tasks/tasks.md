---
description: "Task list for codify action suggestions, checks before the proposal, and task-shaped proposals"
---

# Tasks: Codify Proposal Tasks

**Input**: Design documents from `/specs/203-codify-proposal-tasks/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: The specification does not request test-first work per story. The plan adds `.highway/tools/tests/codify-proposal-tasks.test.sh` and amends four superseded assertions in `.highway/tools/tests/highway-codify.test.sh`. T004 writes the new test and records it failing before any skill or template edit. T005 amends the existing test with the reasons in `specs/203-codify-proposal-tasks/research.md` R12.

**Organization**: Tasks are grouped by user story. All three stories are P1 and stay in spec order. Task IDs follow execution order.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1 through US3)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prove the suite is green before any edit

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing summary in `specs/203-codify-proposal-tasks/baseline.txt`. Stop if it exits non-zero

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Give the saved record and the file list their new shape, and capture the failing probe

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 [P] Update `.highway/library/templates/output/codify-record.md` to version 3.0.0 per `specs/203-codify-proposal-tasks/contracts/proposal.md` and `specs/203-codify-proposal-tasks/data-model.md`. Body order is `# <automation title>`, `## Summary`, `## Description`, `## Acceptance Criteria`, `## Diagram`, `## Tasks`. Remove `## Components`, `## Current State`, `## Action`, `## Day`, and `## Means`. `## Tasks` is one ordered list of `1. **<action>:**` items, each with `**Scope:**`, `**Provider:**`, `**Method:**`, and `**Assumptions:**` with nested items or `None`. Change the Diagram Block to `flowchart TB` with `E["<executor>"] -->|<first action>| T1["<first target>"]` and `T1 -->|<next action>| T2["<next target>"]`. State that the first node is the executor and is not a task, that each arrow label is its task's action and starts with a verb, and that every target has its own node. Keep the frontmatter, the statement that the body states one action whose title is the action, and the Readme section. Replace "It does not contain a plan, tasks, or an instruction to run the automation." with a sentence that it contains no instruction to run the automation
- [X] T003 [P] Update `.highway/library/templates/output/codify-tasks.md` to version 2.0.0 per `specs/203-codify-proposal-tasks/contracts/file-list.md`. Replace `[<component>]` with `[Executor]`, `[Task N]`, and `[README]`. Executor files come first in `code/<id>/executor/`. A proposal task adds lines in `code/<id>/task-N/` only when its method needs its own artifact, and a task carried entirely by the executor adds none. Lines follow proposal task order. Keep one file per line, numbering from `T001` with no gaps, test lines only after a file whose standard says `Tests: required`, `Standard: No coding standard applies.` for files without a standard, and the README last. Replace both component-coverage sentences with: every line names the executor, one proposal task, or the README, and no line names a task the proposal does not list
- [X] T004 Create `.highway/tools/tests/codify-proposal-tasks.test.sh`, mode 644, as a static document contract test. Begin with `# Instrument class: static-document-contract`, `# Artifact classes: source-document`, and a `# Seeded failure probe:` line. In `.highway/skills/highway-codify/SKILL.md`, require `automating these tasks may be worth visiting:**`, `If you have another idea, provide a brief description and we'll work through it together.`, `### align`, `### propose`, `flowchart TB`, `**Tasks:**`, `**Scope:**`, `**Provider:**`, `**Method:**`, `**Assumptions:**`, and `cannot be met for`. Reject `this implementation, these may be worth visiting`, `**Components:**`, `**Current state:**`, `**Day:**`, `**Means:**`, and `flowchart LR`. Require that `### align` comes before `### propose`. In `codify-record.md`, require `## Tasks` and `flowchart TB`, and reject `## Components`, `## Current State`, `## Action`, `## Day`, and `## Means`. In `codify-tasks.md`, require `[Executor]` and `[Task N]`. In `.highway/skills/highway-adr/SKILL.md`, require `that automation's title is this decision's title` and reject ``that automation's `## Action` ``. Run the test once, record the failure in `specs/203-codify-proposal-tasks/probe-fail.txt`, and do not edit a skill or template to make it pass
- [X] T005 Amend `.highway/tools/tests/highway-codify.test.sh` per `specs/203-codify-proposal-tasks/research.md` R12. Replace the codify requirement for `You can also provide your own.` with a requirement for `If you have another idea, provide a brief description and we'll work through it together.` plus a rejection of the old line. Replace `Responsibility:` with `**Scope:**` and `**Provider:**`. Replace `Boundary:` with `**Method:**` and `**Assumptions:**`. Replace the record requirement for `Day 1 or Day 2` with a requirement for `## Tasks` plus a rejection of `## Day`. Keep every other assertion, including `instance is running`, `instances are running`, `Establish`, and the assessment rejection of `/highway-codify`

**Checkpoint**: Both templates are updated, the new test has been seen failing, and the amended test names its replacements

---

## Phase 3: User Story 1 - See actions worth automating (Priority: P1) 🎯 MVP

**Goal**: The suggestion list names the product, offers actions with expanding summaries, and invites another idea

**Independent Test**: Read the suggestion section. The opening names the product and says automating these tasks may be worth visiting. Each title is an action. The closing line invites a brief description. The old opening and closing are absent

### Implementation for User Story 1

- [X] T006 [US1] In `.highway/skills/highway-codify/SKILL.md` `suggest`, per `specs/203-codify-proposal-tasks/contracts/suggest-list.md` and `specs/203-codify-proposal-tasks/research.md` R1 to R3, move the running-instance definition from `start` into `suggest`, using the existing phrases `instance is running` and `instances are running`. It orders the list only. Classify establishing on the source capability title, and keep the existing ordering, the five-item cap, and the no-id label rule. Rewrite each capability as an action that starts with a verb and names its target, and an establishing action starts with `Establish`. Its summary is one sentence that expands on the action, grounded in Realized By and the first sentence of its evidence. The opening is `**Based on the current state of [Product, platform, or application], automating these tasks may be worth visiting:**`, where the name is the `Choice:` of the one Technology Choice, or the implementation title when there are none or several. After **Would you like to explore any of these options?** emit `If you have another idea, provide a brief description and we'll work through it together.` The empty list says no suggestion is grounded and emits the same line. The person's own idea becomes the action title with one expanding summary sentence. Keep the existing reply handling

**Checkpoint**: The suggestion list reads as actions and ends with the new invitation

---

## Phase 4: User Story 2 - Check the proposal before it is shown (Priority: P1)

**Goal**: The draft is checked against coding standards and then vendor documentation before anyone sees it, and the selected action stays

**Independent Test**: Read `start` and `align`. `start` drafts and emits nothing. `align` checks standards first, then sources, names each correction or inconclusive result before the proposal, writes nothing, and returns to suggestions when a standard cannot be met

### Implementation for User Story 2

- [X] T007 [US2] In `.highway/skills/highway-codify/SKILL.md` `start`, per `specs/203-codify-proposal-tasks/data-model.md` and `specs/203-codify-proposal-tasks/research.md` R8 to R10, keep the selected title and summary, or the named action and one sentence for it. Draft the description, at least one acceptance criterion, the executor, and the ordered tasks. Each task is one action that starts with a verb against one target, with scope, provider, method, and assumptions that are not earlier tasks. A provider is the person, or something the accepted architecture or the implementation names, including Realized By, Technology Choice, and Runtime Components. A method may name that provider's plugins, modules, libraries, MCP servers, or APIs. Keep the accepted-architecture requirement and its sentence when none is accepted. Remove the current state, day, action, and means. Emit nothing. Go to `align`. Update Entry step 6, `choose`, and `suggest` so that each still goes to `start`
- [X] T008 [US2] Add `### align` to `.highway/skills/highway-codify/SKILL.md` between `start` and `propose`, per `specs/203-codify-proposal-tasks/contracts/align-checks.md` and `specs/203-codify-proposal-tasks/research.md` R4 to R7. First, for the executor and each task, choose the coding standard row by Technology, or by File Patterns when the method names a file, using the first matching row. Read the whole standard. Correct the provider, method, library, module, or pattern so the draft fits that standard's provider boundaries, accepted libraries or modules, and required patterns. Keep the action. Then, for each named product, API, plugin, module, or library, read the vendor's current public documentation, sending only that name and the vendor name. A vendor page saying deprecated, retired, or no longer offered corrects the draft and cites the source. Conflicting vendor pages cite both. A secondary source, no source, or an incomplete check is inconclusive and changes nothing. Emit the contract's lines before the proposal and save none of them. When no correction keeps the action, emit `[Standard title] cannot be met for **[Action title]**.`, do not show the proposal, and return to `suggest`, or ask for another action when the invocation named it. Do not edit a standard or the catalog. Do not run `align` when continuing an automation that has a task list. Go to `propose`. Add `align` to the Procedure order and the vendor's current public documentation to Inputs

**Checkpoint**: Corrections and inconclusive results appear before the proposal, and nothing is written

---

## Phase 5: User Story 3 - Read the automation as ordered tasks (Priority: P1)

**Goal**: The proposal and the saved record show six sections in order, the diagram runs top to bottom, the tasks match the diagram, and the file list follows the executor and tasks

**Independent Test**: Read `propose`, `write`, `code`, and the ADR coverage line. The block shows Title, Summary, Description, Acceptance criteria, Diagram (`flowchart TB`), and Tasks with Scope, Provider, Method, and Assumptions. No Components, Current state, Action, Day, or Means appear. The file list starts with the executor and ends with the README. ADR coverage matches the title

### Implementation for User Story 3

- [X] T009 [US3] Rename the reply-handling part of `.highway/skills/highway-codify/SKILL.md` `start` to `### propose`, per `specs/203-codify-proposal-tasks/contracts/proposal.md`. Emit **Here is a proposed starting point for your automation:**, then **Title:**, **Summary:**, **Description:**, **Acceptance criteria:**, **Diagram:** as a fenced `flowchart` block with `flowchart TB`, starting at the executor and chaining one arrow and one new target node per task in task order, and **Tasks:** as `1. **[Action]:**` with `**Scope:**`, `**Provider:**`, `**Method:**`, and `**Assumptions:**`. Arrow labels and task actions are the same text. End with **What would you add, correct, or remove?** and `If this is accurate, just say so.` For `edit`, emit one consequence sentence. An edit that changes a provider or method goes to `align` for that task. Show the block again with the diagram and tasks still matching. Removing the last task or acceptance criterion says at least one is needed. Keep the second-action rule, the switch to another accepted architecture by title, and the preparation-only rule. For `accept`, go to `identifier` only with one action, at least one task, at least one acceptance criterion, and an accepted architecture. Keep `unknown`, `question`, and `decline`. Remove `flowchart LR`, Components, Responsibility, Boundary, Current state, Action, Day, and Means
- [X] T010 [US3] In `.highway/skills/highway-codify/SKILL.md` `write`, `code`, Outputs, `close`, and Error Handling, per `specs/203-codify-proposal-tasks/contracts/file-list.md` and `specs/203-codify-proposal-tasks/research.md` R9. The record saves Summary, Description, Acceptance Criteria, Diagram, and Tasks as accepted, with no Components, Current state, Day, or Means. `architecture` stays the accepted architecture. The file list writes the executor's files first, tagged `[Executor]` in `code/[ID]/executor/`, then each proposal task's own files, tagged `[Task N]` in `code/[ID]/task-N/`, only when its method needs its own artifact. The README is last. Keep standard matching by file pattern, unavailable and duplicate rows, test lines only for `Tests: required`, the all-or-nothing write, resume at the first open task, and stop at a task that cannot be finished. Replace the component-subfolder sentences in `code` and Outputs with the executor and task folders
- [X] T011 [US3] In `.highway/skills/highway-adr/SKILL.md` `close`, per `specs/203-codify-proposal-tasks/contracts/file-list.md`, replace ``that automation's `## Action` is this decision's title`` with `that automation's title is this decision's title`. Also update the `code/[ID]/codify.md` input line if it names the Action section. Bump `metadata.version` from 5.0.0 to 5.0.1. Change nothing else
- [X] T012 [US3] In `.highway/skills/highway-codify/SKILL.md`, bump `metadata.version` from 3.0.0 to 4.0.0. Update Purpose as one sentence covering suggestions, the checks, the task-shaped proposal, and coding from the task list. Replace the Verification bullets that name components, current state, the day, means, and per-component subfolders with bullets for the opening name, action titles, the invitation, standards checked before sources, corrections named before the proposal, the six-section order, `flowchart TB`, task and diagram agreement, the executor-first file list, and no re-check when continuing. Keep "Do not invent a means that no accepted architecture describes." and apply it to the executor and providers. Add no MUST-level rule. Keep the frontmatter description and usage

**Checkpoint**: A task-shaped proposal is saved in the new order and coded from an executor-first file list

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Validate, publish, and prove the suite is green

- [X] T013 Run `.highway/tools/validate-skill.sh` on `.highway/skills/highway-codify` and `.highway/skills/highway-adr`, and `.highway/tools/validate-library.sh` on `codify-record.md` and `codify-tasks.md`. Confirm each `###` section of codify is 400 words or fewer. Repair only reported authoring-rule failures
- [X] T014 Run `.highway/tools/tests/codify-proposal-tasks.test.sh` and `.highway/tools/tests/highway-codify.test.sh`, and require exit 0 from both
- [X] T015 Run `.highway/tools/generate-library-catalog.sh`, `.highway/tools/generate-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh`
- [X] T016 Run `.highway/tools/tests/run-all.sh` once, with no other suite running, and require exit 0
- [X] T017 Execute the checks in `specs/203-codify-proposal-tasks/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup. T004 depends on T002 and T003. T005 depends on T004. Blocks every user story
- **User Stories (Phases 3 to 5)**: Depend on Foundational
- **Polish (Phase 6)**: Depends on every user story

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational. Owns `suggest` and the running-instance move
- **User Story 2 (P1)**: Starts after User Story 1. `start` loses the running-instance definition that T006 moves
- **User Story 3 (P1)**: Starts after User Story 2. `propose` is split out of `start`, and `align` sends to it

### Parallel Opportunities

- T002 and T003 edit different templates and can run together
- T011 edits `.highway/skills/highway-adr/SKILL.md` and can run alongside any codify task
- T006 through T010 and T012 edit `.highway/skills/highway-codify/SKILL.md` and stay in order
- Do not parallelize two tasks that edit the same skill

---

## Parallel Example: Foundational and User Story 3

```text
Task: "T002 Update codify-record.md to 3.0.0"
Task: "T003 Update codify-tasks.md to 2.0.0"
Task: "T011 Match ADR coverage on the automation title in .highway/skills/highway-adr/SKILL.md"
```

---

## Implementation Strategy

### MVP First (User Story 1)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Stop and read the suggestion list. It names the product, offers actions, and ends with the new invitation

### Incremental Delivery

1. User Story 1 changes the suggestion list
2. User Story 2 adds the standards and source checks before the proposal
3. User Story 3 shows and saves the task-shaped proposal, builds the executor-first file list, and moves ADR coverage to the title
4. Polish validates, regenerates, and requires a green suite

The new test passes only after all three stories, because it checks every story's strings.

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to a user story for traceability
- Do not commit unless asked
- Stop at any checkpoint to validate that story on its own
