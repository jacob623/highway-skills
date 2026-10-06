---

description: "Task list for Constitution and Experience Standard Alignment"
---

# Tasks: Constitution and Experience Standard Alignment

**Input**: Design documents from `specs/142-constitution-experience-alignment/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Tests**: Focused governance contract checks are required by FR-014 and SC-007; run them before the corresponding document edits where practical.

**Organization**: Tasks are grouped by user story. Tasks touching the same governance document or focused guard remain sequential.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the baseline and validation surface for the document-only amendment.

- [X] T001 [P] Record the current Constitution, Experience Standard, and applicable test paths in `specs/142-constitution-experience-alignment/quickstart.md` and verify the active branch is `142-constitution-experience-alignment`.
- [X] T002 [P] Identify existing guards that assert Principle XIII, P12A.1-P12A.4, Converged Proposal wording, or Experience Standard ownership in `.highway/tools/tests/`.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the single focused contract that protects the cross-document ownership boundary before story-specific edits.

- [X] T003 Create the focused alignment contract in `.highway/tools/tests/constitution-experience-alignment.test.sh`, covering required definitions, P12A.1-P12A.4, Principle XIII, lifecycle ownership, version metadata, and absence of duplicated Experience Standard mechanics.
- [X] T004 Run `.highway/tools/tests/constitution-experience-alignment.test.sh` against the current baseline and record the expected failures in the implementation work log before changing the Constitution.

**Checkpoint**: The focused contract exists, is executable with Bash 3.2-compatible syntax, and fails only for the behaviors this feature changes.

## Phase 3: User Story 1 - Preserve the authority boundary (Priority: P1) 🎯 MVP

**Goal**: Make the Constitution define authority and transience while delegating visible Working Idea development to the Experience Standard.

**Independent Test**: The focused alignment contract passes its authority-boundary checks, and the Constitution's definitions, Principle XIII introduction/rationale, and lifecycle contain no duplicate interaction model.

### Tests for User Story 1

- [X] T005 [US1] Add focused assertions for Working Idea authority, Active Reasoning Context retention, Principle XIII ownership language, and lifecycle non-duplication in `.highway/tools/tests/constitution-experience-alignment.test.sh`.

### Implementation for User Story 1

- [X] T006 [US1] Update the Working Idea definition and Principle XIII introductory prose in `.highway/governance/constitution.md` to preserve transient authority and delegate visible development/convergence to the Experience Standard.
- [X] T007 [US1] Replace the Principle XIII rationale and Collaborative knowledge lifecycle in `.highway/governance/constitution.md` with the minimal authority lifecycle from `specs/142-constitution-experience-alignment/spec.md`.

**Checkpoint**: User Story 1 is independently verifiable through the focused contract and the authority-state model in `specs/142-constitution-experience-alignment/data-model.md`.

## Phase 4: User Story 2 - Separate completeness from convergence (Priority: P1)

**Goal**: Ensure an owner-complete candidate becomes a Converged Proposal only after Experience Standard convergence requirements are satisfied.

**Independent Test**: P12A.2, the Converged Proposal definition, and lifecycle checks distinguish complete-but-developing from complete-and-settled scenarios.

### Tests for User Story 2

- [X] T008 [US2] Add assertions for the Converged Proposal definition, P12A.2 Observable, complete-but-developing behavior, complete-and-settled behavior, and Working Idea agreement in `.highway/tools/tests/constitution-experience-alignment.test.sh`.

### Implementation for User Story 2

- [X] T009 [US2] Update the Converged Proposal definition and P12A.2 Observable in `.highway/governance/constitution.md` so owner completeness and Experience Standard convergence are both required.
- [X] T010 [US2] Remove any remaining Constitution lifecycle wording that treats a complete candidate as automatically converged in `.highway/governance/constitution.md`, without copying X2.41 criteria.

**Checkpoint**: User Story 2's five-state transition rules are represented in `specs/142-constitution-experience-alignment/data-model.md` and pass the focused contract.

## Phase 5: User Story 3 - Preserve owner-controlled acceptance and persistence (Priority: P1)

**Goal**: Preserve owner mutation, declared result, persistence, and orchestration boundaries while updating only touched current-state wording.

**Independent Test**: P12A.1, P12A.3, P12A.4, Principle XII, acceptance-to-owner-result wording, and metadata checks pass without changing owner behavior.

### Tests for User Story 3

- [X] T011 [US3] Add assertions for unchanged P12A.1, P12A.3, and P12A.4 substance, the acceptance-to-owner-result boundary, Principle XII ownership, declared mutation wording, and MAJOR version metadata in `.highway/tools/tests/constitution-experience-alignment.test.sh`.

### Implementation for User Story 3

- [X] T012 [US3] Update Accepted User-Owned Artifact and touched mutation wording in `.highway/governance/constitution.md` from historical/comparative language to the owner's declared mutation path.
- [X] T013 [US3] Update the Constitution Sync Impact Report, Self-Application section, version, and Last Amended date in `.highway/governance/constitution.md` to describe the actual Feature 142 amendment and its preserved owner/orchestration rules.

**Checkpoint**: Acceptance authorization remains distinct from successful owner persistence, and the owner-result boundary remains explicit.

## Phase 6: User Story 4 - Verify cross-document non-duplication (Priority: P2)

**Goal**: Keep Constitution authority semantics and Experience Standard interaction semantics distinct and reviewable.

**Independent Test**: Cross-document ownership assertions pass and all applicable repository checks report zero failures.

### Tests for User Story 4

- [X] T014 [US4] Add cross-document assertions for Constitution-owned authority terms, Experience Standard-owned interaction terms, and absence of detailed X2.41 or duplicated collaborative lifecycle criteria in `.highway/tools/tests/constitution-experience-alignment.test.sh`.
- [X] T015 [P] [US4] Review existing downstream guards in `.highway/tools/tests/` for stale complete-candidate or old Principle XIII wording and update only assertions made invalid by Feature 142.

### Implementation for User Story 4

- [X] T016 [US4] Update any directly inconsistent downstream Constitution or skill references identified by T015, preserving unrelated principles and historical amendment records.
- [X] T017 [US4] Run the focused contract and the full `.highway/tools/tests/run-all.sh` suite, then record the observed results in `specs/142-constitution-experience-alignment/quickstart.md`.

**Checkpoint**: The Constitution and Experience Standard have one consistent path from Working Idea to accepted repository knowledge, with no competing interaction model.

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Complete the documented validation and ensure all feature artifacts are internally consistent.

- [X] T018 [P] Run `git diff --check` and verify the Feature 142 design artifacts contain no unresolved `NEEDS CLARIFICATION` markers in `specs/142-constitution-experience-alignment/`.
- [X] T019 Run every semantic regression scenario from `specs/142-constitution-experience-alignment/quickstart.md` and confirm SC-001 through SC-008 are satisfied.
- [X] T020 Update `specs/142-constitution-experience-alignment/quickstart.md` with final command results and confirm all task markers in `specs/142-constitution-experience-alignment/tasks.md` are `[X]`.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: T001 and T002 can run in parallel; both precede the focused contract.
- **Foundational (Phase 2)**: T003 precedes T004 and blocks all user stories.
- **User Stories (Phases 3-6)**: P1 stories should complete in order because they edit the same Constitution and focused test; US4 follows the authority, convergence, and persistence edits.
- **Polish (Phase 7)**: Depends on all user stories and the full-suite validation.

### User Story Dependencies

- **User Story 1 (P1)**: Depends on the foundational focused contract; MVP authority-boundary increment.
- **User Story 2 (P1)**: Depends on US1 because the lifecycle and Principle XIII ownership language are shared context.
- **User Story 3 (P1)**: Depends on US2 because metadata and persistence wording must describe the final convergence boundary.
- **User Story 4 (P2)**: Depends on US1-US3 and validates the completed cross-document contract.

### Parallel Opportunities

- T001 and T002 are parallel setup work in separate documentation/search surfaces.
- T015 can run in parallel with final review work because it is an independent read/update pass over downstream guards.
- T018 can run independently after implementation edits are complete.
- User stories are intentionally sequential after foundational work because the Constitution and focused contract are shared files.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete T001-T004.
2. Complete T005-T007.
3. Run the focused authority-boundary checks.
4. Continue to US2-US4 only after the authority ownership boundary is stable.

### Incremental Delivery

1. Establish the focused contract and baseline failure evidence.
2. Land the authority-boundary cleanup.
3. Add the complete-versus-converged distinction.
4. Preserve owner acceptance/persistence and update constitutional metadata.
5. Run cross-document and full-suite validation.

## Notes

- Every task uses the required checkbox, sequential ID, optional `[P]` marker, story label where applicable, and exact repository path format.
- No `contracts/` tasks are included because the feature has no external interface.
- Existing test intent should be preserved; only stale assertions caused by Feature 142 should change.
