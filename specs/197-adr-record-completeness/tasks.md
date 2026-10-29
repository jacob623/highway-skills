---
description: "Task list for ADR record completeness"
---

# Tasks: ADR Record Completeness

**Input**: Design documents from `/specs/197-adr-record-completeness/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: The specification does not request test-first work. The plan adds one contract check because the behavior change must be tested. No existing assertion is loosened or removed, so no retirements file is needed.

**Organization**: Tasks are grouped by user story. Task IDs follow execution order.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4, US5)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prove the suite is green before any edit

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing summary in `specs/197-adr-record-completeness/baseline.txt`. Stop if it exits non-zero

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Give the record and the catalog their new shape

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 [P] Update `.highway/library/templates/output/adr-record.md` to match `specs/197-adr-record-completeness/contracts/adr-record-shape.md`. Allow `status` of `accepted | superseded`. Remove Candidate Solution Options from Discovery Reference. Replace Context with Problem, Forces, and Evidence. Add `## Decision Scope` with Covers and Leaves Open, and `## Revisit When`, directly after `## Decision`. Give each alternative Definition, Outcome, and Reason, and remove Selection Status. Type the relationship lines as `advances`, `bound by`, and `satisfies`. Replace the handoff with Architecture Direction, Required Architecture Work, Reference Architecture, Reference Implementation, and Authorization to Proceed. Keep `Selected Option: OPTXXXXXX` and `Selection Source: User-provided explicit selection`. Bump to 2.0.0
- [X] T003 [P] Update `.highway/library/templates/output/adr-catalog.md` so the status is `accepted`, `superseded`, or `removed`, and a superseded row keeps its file and id. Bump to 3.0.0
- [X] T004 Confirm the Discovery, architecture record, and implementation record templates are not edited, and the authorization text is unchanged

**Checkpoint**: The templates define the new record

---

## Phase 3: User Story 1 - Read the decision on its own (Priority: P1)

**Goal**: A Discovery-backed ADR carries its own problem, forces, boundary, alternatives, and revisit condition

**Independent Test**: The `highway-adr` write rules produce every section in the contract without opening the Discovery, and the chosen option appears only in the Decision, the alternatives list as `Selected`, and Recommendation Override when present

### Implementation for User Story 1

- [X] T005 [US1] In `.highway/skills/highway-adr/SKILL.md`, update the `write` rules. Write Problem and Forces in prose. Write Decision Scope and Revisit When, with `None` when no condition is known. Write every option as an alternative, headed by its option id, with Definition, Outcome, and Reason, and the chosen option as `Selected`. Do not copy the chosen option or the matches into the handoff or the Discovery Reference. Keep the Recommendation Override rule. Update Verification

**Checkpoint**: A Discovery-backed ADR reads on its own

---

## Phase 4: User Story 2 - See what the decision produced (Priority: P1)

**Goal**: The ADR names its reference architecture and reference implementation

**Independent Test**: After each later write, only the matching handoff field changes. A failed ADR update keeps the later record and leaves the chain incomplete. Re-invoking fills a field that is still `None`

### Implementation for User Story 2

- [X] T006 [US2] In `.highway/skills/highway-adr/SKILL.md`, write Reference Architecture and Reference Implementation as `None`
- [X] T007 [P] [US2] In `.highway/skills/highway-architecture/SKILL.md`, narrow "Do not change the ADR" to allow only the Reference Architecture field. After the record and catalog are written, set that field. When the update fails, keep the architecture, say the ADR could not be updated, and do not call the chain complete. When the existing architecture for the same ADR is found and the field is still `None`, set it. Cite `adr-record.md` in Inputs. Update Verification
- [X] T008 [P] [US2] In `.highway/skills/highway-implementation/SKILL.md`, narrow "Do not change the ADR" to allow only the Reference Implementation field. After the implementation records are written, trace the architecture to its ADR and set that field. Apply the same failure and re-invocation rules as T007. Cite `adr-record.md` in Inputs. Update Verification

**Checkpoint**: The handoff names what the decision produced

---

## Phase 5: User Story 3 - Record an onboarding decision in the same shape (Priority: P1)

**Goal**: Onboarding writes the shared sections with no option id

**Independent Test**: The onboarding `orchestrate` rules write every shared section, the onboarding values in the contract, named alternatives, and both handoff ids as their records are written

### Implementation for User Story 3

- [X] T009 [US3] In `.highway/skills/highway-onboarding/SKILL.md`, update `orchestrate`. Write the shared sections from Provider, Capabilities, Decision, Alternatives, Why, and Limitations. Write Recommendation, Recommendation Rationale, Comparison Matrix, matches, and Decision Confidence as `None`. Write Selected Option as the provider name and Selection Source as `Accepted onboarding mapping`. Head alternatives by name, with the adopted provider as `Selected`. Write both handoff ids as `None`, and set each one after its record is written, trying a failed ADR update once more. Type the relationship lines. Update Verification

**Checkpoint**: Onboarding and Discovery ADRs share one shape

---

## Phase 6: User Story 4 - Tell a current decision from a superseded one (Priority: P2)

**Goal**: Superseded is its own status

**Independent Test**: An ADR with `superseded_by` set reads `superseded` in the record and catalog, and the file remains

### Implementation for User Story 4

- [X] T010 [US4] In `.highway/skills/highway-adr/SKILL.md`, state that status is `superseded` in the record and catalog exactly when `superseded_by` names an ADR, `accepted` otherwise, and that a superseded record file remains. Update Verification

**Checkpoint**: Superseded, accepted, and removed stay distinct

---

## Phase 7: User Story 5 - See the typed governance links (Priority: P2)

**Goal**: One named type per relationship section

**Independent Test**: Each relationship line uses the type for its section, and an empty section says `None`

### Implementation for User Story 5

- [X] T011 [US5] In `.highway/skills/highway-adr/SKILL.md`, write objective links as `advances`, control links as `bound by`, and NFR links as `satisfies`, with `None` for an empty section. Update Verification

**Checkpoint**: Governance links are typed

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Test, publish, and prove the suite is green

- [X] T012 Add `.highway/tools/tests/adr-record-completeness.test.sh` with instrument-class, artifact-class, and seeded-failure-probe comments, mode 644. Require the template sections and fields from the contract, the three catalog statuses, the write rules in `highway-adr` and `highway-onboarding`, and the handoff update rules in `highway-architecture` and `highway-implementation`. Fail when `Selection Status`, `Candidate Solution Options`, or a handoff `Selected Option` or `Reference Architecture Matches` remains in the ADR template
- [X] T013 Bump the four skill versions per `specs/197-adr-record-completeness/plan.md`
- [X] T014 Run `.highway/tools/validate-library.sh` and `.highway/tools/validate-skill.sh` on the four skills. Repair only reported authoring-rule failures
- [X] T015 Run `.highway/tools/generate-library-catalog.sh`, `.highway/tools/generate-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh`
- [X] T016 Run `.highway/tools/tests/run-all.sh` once, with no other suite running, and require exit 0
- [X] T017 Execute the checks in `specs/197-adr-record-completeness/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup. Blocks every user story
- **User Stories (Phases 3 to 7)**: Depend on Foundational. T005, T006, T010, and T011 all edit `highway-adr` and run in order. T007, T008, and T009 edit other files
- **Polish (Phase 8)**: Depends on every user story

### Parallel Opportunities

- T002 and T003 edit different templates
- T007, T008, and T009 edit three different skills and can run alongside the `highway-adr` tasks

---

## Parallel Example: User Stories

```text
Task: "T005 [US1] Update write rules in .highway/skills/highway-adr/SKILL.md"
Task: "T007 [US2] Update the ADR handoff in .highway/skills/highway-architecture/SKILL.md"
Task: "T008 [US2] Update the ADR handoff in .highway/skills/highway-implementation/SKILL.md"
Task: "T009 [US3] Update orchestrate in .highway/skills/highway-onboarding/SKILL.md"
```

---

## Implementation Strategy

### MVP First (User Stories 1 to 3)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phases 3, 4, and 5
4. Stop and confirm a Discovery ADR and an onboarding ADR share one shape and name their products

### Incremental Delivery

1. User Story 1 delivers a self-contained Discovery ADR
2. User Story 2 delivers the architecture and implementation ids
3. User Story 3 brings onboarding onto the same shape
4. User Story 4 adds the superseded status
5. User Story 5 types the governance links
6. Polish adds the test, publishes the skills, and requires a green suite

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to a user story for traceability
- Do not commit unless asked
- Stop at any checkpoint to validate that story on its own
