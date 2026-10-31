---
description: "Task list for multiple reference implementations"
---

# Tasks: Multiple Reference Implementations

**Input**: Design documents from `/specs/198-multiple-reference-implementations/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, retirements.md

**Tests**: The specification does not request test-first work. The plan adds one contract check and amends `adr-record-completeness.test.sh`. Each loosened assertion is recorded in `retirements.md`.

**Organization**: Tasks are grouped by user story. P1 stories come before P2 stories. Within one priority, stories stay in spec order. Task IDs follow execution order.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4, US5, US6, US7, US8, US9)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prove the suite is green before any edit

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing summary in `specs/198-multiple-reference-implementations/baseline.txt`. Stop if it exits non-zero

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Give the six records and catalogs their new shape

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 [P] Update `.highway/library/templates/output/adr-record.md` to match `specs/198-multiple-reference-implementations/contracts/record-and-catalog-shape.md`. Remove the Reference Implementation entry from Reference Architecture Handoff. Keep Architecture Direction, Required Architecture Work, Reference Architecture, and Authorization to Proceed. Bump to 3.0.0
- [X] T003 [P] Update `.highway/library/templates/output/adr-catalog.md`. Add an Architecture ID column after ADR Path. The value is one RA id or `None`. Keep one row per ADR. Bump to 4.0.0
- [X] T004 [P] Update `.highway/library/templates/output/architecture-record.md` to match `specs/198-multiple-reference-implementations/contracts/record-and-catalog-shape.md`. Set `id` to `RA` plus eight hex digits and `status` to `accepted`. Remove the single `adr` frontmatter field. Add `## Current Decisions` as the list of every current decision id. State Context applicability and what is left open. State why the style was chosen. Give each logical component `Responsibility` and `Interface`. Add Information, Variation (`Must Keep` and `May Choose`), and Responsibilities. Type relationship lines as `advances`, `bound by`, and `satisfies`. Required Capabilities name a component and have no capability id. Remove `## Key Technologies` and do not copy a decision statement. Bump to 2.0.0
- [X] T005 [P] Update `.highway/library/templates/output/architecture-catalog.md`. Keep one row per architecture. The ADR ID cell lists every current decision id in id order, separated by a comma and a space. An ADR id appears on at most one row. Bump to 3.0.0
- [X] T006 [P] Update `.highway/library/templates/output/implementation-record.md` to match `specs/198-multiple-reference-implementations/contracts/record-and-catalog-shape.md`. Set `id` to `RI` plus eight hex digits, `architecture` to an RA id, and `status` to `accepted`. Add Variation Choices, a Coverage table of architecture responsibilities, Conformance, Realized Interfaces, Conformance Evidence, and Limitations. State a technology choice once. Name the architecture once. A compatible skeleton has no gap section and no conflict section. Bump to 2.0.0
- [X] T007 [P] Update `.highway/library/templates/output/implementation-catalog.md`. Remove the rule that each Architecture ID appears on at most one row. Many rows may share one Architecture ID. Each implementation keeps its own row. Bump to 3.0.0
- [X] T008 Confirm `.highway/library/templates/output/discovery-record.md`, the Controls templates, and the NFR templates are not edited

**Checkpoint**: The templates define the new records and catalogs

---

## Phase 3: User Story 1 - Add another implementation (Priority: P1) 🎯 MVP

**Goal**: A second implementation can be accepted for an architecture that already has one

**Independent Test**: Start from an architecture that already has one implementation. Add a second and accept it. Both exist, both name that architecture, and the decision and the architecture are unchanged

### Implementation for User Story 1

- [X] T009 [US1] In `.highway/skills/highway-implementation/SKILL.md`, remove the stop that writes no second implementation. When creation starts for an architecture that already has implementations, show those implementations and still allow a new proposal. When the person chooses an architecture, show how many current implementations it has, and let them choose one that already has implementations. Declining a proposal writes nothing. A removed implementation does not count as current and does not block a new one. A failed write leaves the architecture and every other implementation unchanged. Update Verification and Error Handling

**Checkpoint**: Two current implementations can name one architecture

---

## Phase 4: User Story 2 - Find the implementations of an architecture (Priority: P1)

**Goal**: The decision names its architecture and names no implementation

**Independent Test**: A decision whose architecture has two implementations, one, or none names the architecture whenever it exists and contains no implementation entry. Both implementations are found from the architecture they name

### Implementation for User Story 2

- [X] T010 [P] [US2] In `.highway/skills/highway-adr/SKILL.md`, write Reference Architecture as `None` and do not write an implementation entry. Update the handoff sentence in Procedure and Verification
- [X] T011 [US2] In `.highway/skills/highway-implementation/SKILL.md`, remove the `name` step that sets the ADR Reference Implementation field, and remove that field from Outputs. Do not change the ADR. Each implementation names its one architecture. A reader finds every current implementation from the implementation catalog rows for that architecture. Update Verification and Error Handling

**Checkpoint**: The decision holds no implementation id

---

## Phase 5: User Story 4 - Conform to the architecture (Priority: P1)

**Goal**: The architecture states what is fixed, what may vary, its responsibilities, its information, and each component boundary

**Independent Test**: An architecture states the fixed parts, the variation points, the responsibilities, the information, and each component's responsibility and interface. An implementation covers those responsibilities or marks one not applicable

### Implementation for User Story 4

- [X] T012 [US4] In `.highway/skills/highway-architecture/SKILL.md`, write Variation with what every implementation must keep and what it may choose, or `None` when nothing may vary. A variation names no product, platform, or vendor. Write Responsibilities, and Information with what it handles, who owns it, and what crosses a trust boundary, or `None`. Write each component's responsibility and the interface other components rely on, or `None`. Remove Key Technologies from the include list. Update Verification
- [X] T013 [P] [US4] In `.highway/skills/highway-onboarding/SKILL.md`, write those same architecture sections in `orchestrate`. Do not ask the person to supply them

**Checkpoint**: A realization can conform to stated responsibilities

---

## Phase 6: User Story 6 - See what this realization chose (Priority: P1)

**Goal**: An implementation records its variation choices, coverage, realized interface, evidence, and limitations

**Independent Test**: Each free variation has a choice. Coverage rows are the architecture's responsibilities. The realized interface, conformance evidence, and limitations are present, or `None`. A technology choice appears once

### Implementation for User Story 6

- [X] T014 [US6] In `.highway/skills/highway-implementation/SKILL.md`, replace the fixed category coverage with one row per architecture responsibility, each covered or not applicable. Do not add a responsibility the architecture does not state. Write the choice for each free variation, or `None`. Write the realized interface for each architecture interface, how conformance was shown, and the limitations, each or `None`. Write one technology choice with intent, reason, and evidence. Name the architecture once. A conflict with the architecture writes nothing. Update Verification
- [X] T015 [P] [US6] In `.highway/skills/highway-onboarding/SKILL.md`, write those same implementation sections in `orchestrate`

**Checkpoint**: Two implementations of one architecture can show different choices

---

## Phase 7: User Story 8 - See an existing implementation during discovery (Priority: P1)

**Goal**: Discovery names an existing implementation before the options when the match is exact

**Independent Test**: A later request that matches by an exact link sees the implementation, the architecture, and the decision before the options. A wording resemblance does not

### Implementation for User Story 8

- [X] T016 [US8] In `.highway/skills/highway-discovery/SKILL.md`, on `start`, when a matched architecture has a current implementation, emit one notice before the numbered options. Name the implementation, the architecture, and the decision it came from. Keep the existing exact-match rule: identifier, exact title, capability id, Objective id, Control id, or NFR id. Do not match by wording resemblance. The notice does not ask for confirmation, and the person can still explore every option. Update Verification

**Checkpoint**: An exact match surfaces the existing implementation

---

## Phase 8: User Story 9 - Replace a decision or run beside it (Priority: P1)

**Goal**: A different option asks replace or beside once, and acceptance closes with one next step

**Independent Test**: A different option that matches an architecture asks the question inside the proposal and states the consequence. The same exact option title does not ask it. Acceptance suggests exactly one next step

### Implementation for User Story 9

- [X] T017 [US9] In `.highway/skills/highway-adr/SKILL.md`, follow `specs/198-multiple-reference-implementations/contracts/decision-flow.md` for the proposal. When the selected option title equals the selected option of a current decision for the matched architecture and that decision has a current implementation, say this uses that implementation and that architecture, and do not ask replace or beside. Ask replace or beside only for a different option that matches an architecture that already has a decision. Two matches list only those architectures; after a pick, show the proposal again with that architecture and one consequence sentence. A change of relationship or architecture shows the proposal again with one consequence sentence. Acceptance is the only confirmation
- [X] T018 [US9] In `.highway/skills/highway-adr/SKILL.md`, on acceptance, apply the chosen relationship in the same write. Replace sets the earlier decision to `superseded`, keeps its file, removes it from the architecture's current-decision list, and updates the architecture catalog. Beside adds the new decision to that list and leaves the earlier decision. No match leaves the decision standing alone. A reused architecture is written in the handoff and is not created again. The closing message suggests one next step from `specs/198-multiple-reference-implementations/data-model.md`: create the reference architecture, create the reference implementation and say a new architecture is not required, or name the implementation that already exists. Update Verification

**Checkpoint**: Acceptance produces one next step

---

## Phase 9: User Story 3 - Keep one architecture for the decision (Priority: P2)

**Goal**: One decision still has one architecture, and onboarding still writes one implementation

**Independent Test**: A second architecture for a decision is refused. Onboarding finishes with one decision, one architecture, and one implementation. The decision names the architecture and does not name the implementation

### Implementation for User Story 3

- [X] T019 [US3] In `.highway/skills/highway-architecture/SKILL.md`, keep one architecture per decision. When that decision already has an architecture, show it and write no second one. Create an architecture only when the accepted ADR names none. The `name` step still sets only the ADR Reference Architecture field. A failed ADR update keeps the architecture and does not treat the link as complete. Update Verification
- [X] T020 [P] [US3] In `.highway/skills/highway-onboarding/SKILL.md`, still create one decision, one architecture, and one implementation for the provider. Do not ask replace or beside. After the architecture is written, set only the ADR Reference Architecture field. Do not set an implementation id. When the implementation cannot be written, the ADR names the architecture and no implementation exists. Update Verification

**Checkpoint**: Onboarding and a second architecture request stay within one architecture per decision

---

## Phase 10: User Story 5 - Read a finished architecture record (Priority: P2)

**Goal**: A finished architecture uses an RA id and status accepted, and lists the same current decisions as its catalog

**Independent Test**: The identifier starts with RA, the status is accepted, and the catalog lists the same current decisions. Context, style rationale, and typed links are present. There is no Key Technologies section

### Implementation for User Story 5

- [X] T021 [US5] In `.highway/skills/highway-architecture/SKILL.md`, write an RA id and status `accepted`. Write Context applicability and what is left open, and why the style was chosen. List every current decision that names this architecture, and do not copy a decision statement. Write objective links as `advances`, control links as `bound by`, and NFR links as `satisfies`, or `None`. Each required capability names its component and has no id, or the section is `None`. The catalog ADR ID cell lists those same current decision ids in id order. A removed catalog row still has no record file. Update Verification
- [X] T022 [P] [US5] In `.highway/skills/highway-onboarding/SKILL.md`, write that same architecture id, status, current-decision list, and catalog cell for the one decision it creates

**Checkpoint**: The architecture record and the architecture catalog list the same current decisions

---

## Phase 11: User Story 7 - Read a finished implementation record (Priority: P2)

**Goal**: A finished implementation uses an RI id, an RA parent, and status accepted

**Independent Test**: A compatible implementation has a conformance result and no gap or conflict result. An uncovered responsibility is incomplete and states the gap. The architecture is named once

### Implementation for User Story 7

- [X] T023 [US7] In `.highway/skills/highway-implementation/SKILL.md`, write an RI id, an RA parent, and status `accepted`. When every responsibility is covered or not applicable, write Conformance `compatible` and omit gap and conflict sections. When a responsibility is uncovered, write Conformance `incomplete` and state the gap. A conflict writes nothing. Name the architecture once. Update Verification
- [X] T024 [P] [US7] In `.highway/skills/highway-onboarding/SKILL.md`, write those same implementation identifier, parent, status, and conformance sections

**Checkpoint**: A compatible record is distinct from an incomplete one

---

## Phase 12: Polish & Cross-Cutting Concerns

**Purpose**: Test, publish, and prove the suite is green

- [X] T025 Amend `.highway/tools/tests/adr-record-completeness.test.sh` so it no longer requires an implementation entry on the ADR template, the paired `None` handoff sentence, an onboarding write of a Reference Implementation field, or an implementation skill that changes the ADR. Record each removed assertion in `specs/198-multiple-reference-implementations/retirements.md`
- [X] T026 Add `.highway/tools/tests/multiple-reference-implementations.test.sh` with instrument-class, artifact-class, and seeded-failure-probe comments, mode 644. Require the handoff to have no implementation entry, the Architecture ID column on the ADR catalog, more than one decision id in an architecture-catalog cell, more than one implementation row for one architecture, the architecture and implementation sections in `specs/198-multiple-reference-implementations/contracts/record-and-catalog-shape.md`, the discovery notice, the three closing next steps, and onboarding writing no implementation id onto the ADR. Use `grep -Fq --`
- [X] T027 Bump `highway-discovery` to 4.0.0, `highway-adr` to 4.0.0, `highway-architecture` to 4.0.0, `highway-implementation` to 4.0.0, and `highway-onboarding` to 7.0.0 per `specs/198-multiple-reference-implementations/plan.md`
- [X] T028 Run `.highway/tools/validate-library.sh` on the six edited templates and `.highway/tools/validate-skill.sh` on the five skills. Repair only reported authoring-rule failures
- [X] T029 Run `.highway/tools/generate-library-catalog.sh`, `.highway/tools/generate-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh`
- [X] T030 Run `.highway/tools/tests/run-all.sh` once, with no other suite running, and require exit 0
- [X] T031 Execute the checks in `specs/198-multiple-reference-implementations/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup. Blocks every user story
- **User Stories (Phases 3 to 11)**: Depend on Foundational. Stories that share a skill file stay in phase order
- **Polish (Phase 12)**: Depends on every user story

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational. Edits `highway-implementation`
- **User Story 2 (P1)**: Starts after User Story 1 for `highway-implementation`. The ADR handoff edit can proceed beside User Story 1
- **User Story 4 (P1)**: Starts after Foundational. Edits `highway-architecture` and `highway-onboarding`
- **User Story 6 (P1)**: Starts after User Story 1 and User Story 2 for `highway-implementation`, and after User Story 4 for `highway-onboarding`
- **User Story 8 (P1)**: Starts after Foundational. Edits only `highway-discovery`
- **User Story 9 (P1)**: Starts after User Story 2 for `highway-adr`
- **User Story 3 (P2)**: Starts after User Story 4 for `highway-architecture` and after User Story 6 for `highway-onboarding`
- **User Story 5 (P2)**: Starts after User Story 3 for both of those skills
- **User Story 7 (P2)**: Starts after User Story 6 for `highway-implementation` and after User Story 5 for `highway-onboarding`

### Parallel Opportunities

- T002 through T007 edit six different templates
- T010 edits `highway-adr` and can run beside T009
- T013 can run beside T012. T015 can run beside T014. T020 can run beside T019. T022 can run beside T021. T024 can run beside T023
- T016 edits only `highway-discovery` and can run beside the other P1 stories
- Do not parallelize tasks that edit the same skill. `highway-implementation` is T009, T011, T014, T023. `highway-adr` is T010, T017, T018. `highway-architecture` is T012, T019, T021. `highway-onboarding` is T013, T015, T020, T022, T024

---

## Parallel Example: User Stories

```text
Task: "T009 [US1] Allow a second implementation in .highway/skills/highway-implementation/SKILL.md"
Task: "T010 [US2] Remove the implementation entry in .highway/skills/highway-adr/SKILL.md"
Task: "T012 [US4] Write architecture conformance sections in .highway/skills/highway-architecture/SKILL.md"
Task: "T016 [US8] Surface an existing implementation in .highway/skills/highway-discovery/SKILL.md"
```

---

## Implementation Strategy

### MVP First (User Story 1)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Stop and confirm a second implementation can be accepted for one architecture

### Incremental Delivery

1. User Story 1 delivers a second implementation
2. User Story 2 takes the implementation id off the decision
3. User Story 4 states what implementations share
4. User Story 6 records the choice each implementation made
5. User Story 8 surfaces an existing implementation during discovery
6. User Story 9 asks replace or beside and closes with one next step
7. User Story 3 keeps one architecture per decision, including onboarding
8. User Story 5 finishes the architecture record
9. User Story 7 finishes the implementation record
10. Polish adds the test, publishes the skills, and requires a green suite

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to a user story for traceability
- Do not commit unless asked
- Stop at any checkpoint to validate that story on its own
