# Tasks: Highway UX Standard Alignment

**Input**: Design documents from `/specs/083-highway-ux-standard-alignment/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`; no external `contracts/` directory is required.

**Organization**: Tasks are grouped by user story. This feature changes governance and skill Markdown plus shell validation; no runtime service, persistence store, or external API is introduced.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the implementation baseline and preserve repository invariants before changing shipped documents.

- [X] T001 Record the current repository test baseline with `.highway/tools/tests/run-all.sh` and `git diff --check` from the repository root.
- [X] T002 [P] Inspect `.highway/governance/experience-standard.md` and capture the X2.2-X2.6 normative text for preservation checks in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T003 [P] Inspect the eight in-scope skill files under `.highway/skills/` and map their existing output and ownership sections for additive edits.
- [X] T004 [P] Inspect generated catalog, adapter, and distribution correspondence paths required by `.highway/tools/tests/adapter-coverage.test.sh` and `.highway/tools/tests/distribution-packaging.test.sh`.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the single shared contract and its focused validation before skill-specific alignment begins.

- [X] T005 Add the authoritative Interactive Workflow UX Contract to `.highway/governance/experience-standard.md` without modifying X2.2-X2.6 normative text or adding an X identifier.
- [X] T006 Amend the Experience Standard version and amendment record in `.highway/governance/experience-standard.md` as the documented MINOR section addition.
- [X] T007 Create mixed static/executable contract validation in `.highway/tools/tests/highway-ux-alignment.test.sh` covering contract uniqueness, X2.2-X2.6 preservation, valid references, duplicate-authority rejection, and declared artifact classes.
- [X] T008 Add disposable negative probes to `.highway/tools/tests/highway-ux-alignment.test.sh` for duplicate contracts, missing references, invalid progress fields, outcome collisions, unsupported resume claims, and ownership violations; ensure probes are cleaned up.
- [X] T009 Register the focused validation automatically through the existing `.highway/tools/tests/run-all.sh` discovery convention and verify Bash 3.2-compatible syntax in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T010 [P] Review the foundational contract and test against `.highway/governance/constitution.md` P10.1-P10.2 and `.specify/memory/constitution.md` D1.5, D2.1-D2.4, D3.3-D3.8, D4.1-D4.7, D6.1-D6.2, and D8.1; record any explicit N/A conditions in `.highway/tools/tests/highway-ux-alignment.test.sh`.

**Checkpoint**: The shared contract exists once, its preservation/uniqueness checks fail on seeded defects, and the focused test is ready to validate skill alignment.

## Phase 3: User Story 1 - Interactive Skills Lead With the Next Action (Priority: P1) 🎯 MVP

**Goal**: Make next-action priority, implementation-detail boundaries, and ownership routing explicit across all in-scope interactive skills.

**Independent Test**: Run `bash .highway/tools/tests/highway-ux-alignment.test.sh` and inspect the first user-facing contract sections in all eight in-scope `.highway/skills/*/SKILL.md` files for next-action priority, implementation-detail avoidance, and owner routing.

### Tests for User Story 1

- [X] T011 [P] [US1] Add next-action, implementation-detail, and ownership-reference assertions for Profile and Objectives in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T012 [P] [US1] Add next-action, implementation-detail, and ownership-reference assertions for Controls and NFRs in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T013 [P] [US1] Add next-action, implementation-detail, and ownership-reference assertions for New, Discovery, ADR, and Clarify in `.highway/tools/tests/highway-ux-alignment.test.sh`.

### Implementation for User Story 1

- [X] T014 [P] [US1] Add the Interactive Workflow UX Contract reference, next-action priority, implementation-detail boundary, and owner-routing wording to `.highway/skills/highway-profile/SKILL.md`.
- [X] T015 [P] [US1] Add the Interactive Workflow UX Contract reference, next-action priority, implementation-detail boundary, and owner-routing wording to `.highway/skills/highway-objectives/SKILL.md`.
- [X] T016 [P] [US1] Add the Interactive Workflow UX Contract reference, next-action priority, implementation-detail boundary, and owner-routing wording to `.highway/skills/highway-controls/SKILL.md`.
- [X] T017 [P] [US1] Add the Interactive Workflow UX Contract reference, next-action priority, implementation-detail boundary, and owner-routing wording to `.highway/skills/highway-nfrs/SKILL.md`.
- [X] T018 [P] [US1] Add the Interactive Workflow UX Contract reference, next-action priority, implementation-detail boundary, and owner-routing wording to `.highway/skills/highway-new/SKILL.md`.
- [X] T019 [P] [US1] Add the applicability-aware Interactive Workflow UX Contract reference and activity-focused next-action wording to `.highway/skills/highway-discovery/SKILL.md`.
- [X] T020 [P] [US1] Add the applicability-aware Interactive Workflow UX Contract reference and activity-focused next-action wording to `.highway/skills/highway-adr/SKILL.md`.
- [X] T021 [P] [US1] Add the Interactive Workflow UX Contract reference, next-action priority, implementation-detail boundary, and owner-routing wording to `.highway/skills/highway-clarify/SKILL.md`.

**Checkpoint**: All eight in-scope skills lead with the next required user action, omit internal mechanics in normal output, and preserve owner routing.

## Phase 4: User Story 2 - Guided Collection Is Focused and Observable (Priority: P1)

**Goal**: Align guided collection sequencing and applicable progress fields without forcing wizard behavior onto analytical workflows.

**Independent Test**: Inspect and validate Profile, Objectives, Controls, NFRs, New, and Clarify collection contracts; verify one unresolved question or decision at a time, required progress fields, and N5 applicability for workflows without meaningful ordered activity.

### Tests for User Story 2

- [X] T022 [P] [US2] Add guided-collection single-question and progress-field assertions for Profile, Objectives, and New in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T023 [P] [US2] Add guided-collection single-question and progress-field assertions for Controls and NFRs in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T024 [P] [US2] Add guided-collection single-question and progress-field assertions for Clarify plus analytical N/A checks for Discovery and ADR in `.highway/tools/tests/highway-ux-alignment.test.sh`.

### Implementation for User Story 2

- [X] T025 [P] [US2] Add Profile Setup Progress and one-question collection wording to `.highway/skills/highway-profile/SKILL.md`.
- [X] T026 [P] [US2] Add the ordered three-prompt objective flow and activity-focused position progress to `.highway/skills/highway-objectives/SKILL.md`.
- [X] T027 [P] [US2] Add Guided Control Collection, Review Workflow, and NFR Proposal Review progress fields to `.highway/skills/highway-controls/SKILL.md`.
- [X] T028 [P] [US2] Add single-candidate decision flow and candidate progress fields to `.highway/skills/highway-nfrs/SKILL.md`.
- [X] T029 [P] [US2] Add domain-ordered evidence collection, current activity, and first-incomplete-domain sequencing to `.highway/skills/highway-new/SKILL.md`.
- [X] T030 [P] [US2] Add one-open-finding sequencing and finding progress fields to `.highway/skills/highway-clarify/SKILL.md`.
- [X] T031 [P] [US2] Add activity-focused, non-wizard progress applicability wording to `.highway/skills/highway-discovery/SKILL.md` and `.highway/skills/highway-adr/SKILL.md`.

**Checkpoint**: Guided workflows expose only the current unresolved question or decision and meaningful ordered progress; non-wizard workflows do not manufacture stages.

## Phase 5: User Story 3 - Resume and Outcomes Are Understandable (Priority: P1)

**Goal**: Distinguish User Exits from Owner Outcomes and declare honest resume behavior for every in-scope workflow.

**Independent Test**: Run focused validation against pause, cancel, stop responding, declined, aborted, blocked, and resume declarations; confirm no skill claims unsupported unanswered-question, draft, cancellation-marker, or checkpoint persistence.

### Tests for User Story 3

- [X] T032 [P] [US3] Add User Exit versus Owner Outcome vocabulary and collision assertions for all eight in-scope skills in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T033 [P] [US3] Add one-of-four Resume Applicability assertions and unsupported-persistence negative probes in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T034 [P] [US3] Add first-incomplete evidence/domain/finding resume assertions for Profile, New, and Clarify in `.highway/tools/tests/highway-ux-alignment.test.sh`.

### Implementation for User Story 3

- [X] T035 [P] [US3] Declare User Exits, Owner Outcomes, resume applicability, and first-incomplete evidence behavior in `.highway/skills/highway-profile/SKILL.md`.
- [X] T036 [P] [US3] Declare applicable User Exits, Owner Outcomes, resume behavior, and no-hidden-state boundaries in `.highway/skills/highway-objectives/SKILL.md`.
- [X] T037 [P] [US3] Declare applicable User Exits, Owner Outcomes, resume behavior, and owner authority in `.highway/skills/highway-controls/SKILL.md`.
- [X] T038 [P] [US3] Declare applicable User Exits, Owner Outcomes, resume behavior, and owner authority in `.highway/skills/highway-nfrs/SKILL.md`.
- [X] T039 [P] [US3] Declare User Exits, Owner Outcomes, first-incomplete-domain resume behavior, and no-hidden-state boundaries in `.highway/skills/highway-new/SKILL.md`.
- [X] T040 [P] [US3] Declare applicable activity-workflow outcomes and Resume Applicability in `.highway/skills/highway-discovery/SKILL.md`.
- [X] T041 [P] [US3] Declare applicable decision-workflow outcomes and Resume Applicability in `.highway/skills/highway-adr/SKILL.md`.
- [X] T042 [P] [US3] Declare User Exits, Owner Outcomes, first-incomplete-finding resume behavior, and no-hidden-state boundaries in `.highway/skills/highway-clarify/SKILL.md`.

**Checkpoint**: Every in-scope workflow reports user-directed exits separately from owner-directed outcomes and makes later invocation behavior explicit.

## Phase 6: User Story 4 - Maintainers Can Apply One Shared UX Contract (Priority: P2)

**Goal**: Prove that one shared contract is referenced consistently while domain ownership and legacy output contracts remain intact.

**Independent Test**: Run the focused alignment test, generated correspondence checks, and the full repository suite; verify exactly one authoritative contract and unchanged Help/Relationships scope.

### Tests for User Story 4

- [X] T043 [P] [US4] Add exact-one-contract and no-duplicate-authority assertions across `.highway/governance/experience-standard.md`, `.highway/skills/`, and `.highway/library/` in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T044 [P] [US4] Add X2.2-X2.6 normative-text preservation and no-new-X-identifier assertions in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T045 [P] [US4] Add output-contract, owner-boundary, Help/Relationships-scope, and generated-correspondence assertions in `.highway/tools/tests/highway-ux-alignment.test.sh`.

### Implementation for User Story 4

- [X] T046 [US4] Reconcile all eight skill references and remove any duplicated authoritative contract wording from `.highway/skills/` while preserving domain-specific fields.
- [X] T047 [US4] Regenerate catalog and agent adapter outputs with `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-agent-adapters.sh` only if source changes require it, then verify `.highway/catalog/`, `.github/skills/`, `.claude/skills/`, `.cursor/rules/`, and `.highway/tools/.adapter-manifest` correspondence.
- [X] T048 [US4] Verify `.highway/tools/.distribution-manifest` and existing output templates remain unchanged except for intentional Feature 083 UX wording.

**Checkpoint**: The shared contract remains unique and authoritative, all references are valid, generated outputs correspond, and unaffected workflows retain their scope.

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Complete end-to-end validation and record requirement coverage separately from check results.

- [X] T049 [P] Run the Feature 083 quickstart scenarios from `specs/083-highway-ux-standard-alignment/quickstart.md`.
- [X] T050 Run `.highway/tools/tests/run-all.sh` from the repository root and record the final suite result in the implementation report.
- [X] T051 Run `git diff --check` and inspect `git status --short` for generated residue or unintended files.
- [X] T052 Review all FR-001 through FR-025 and SC-001 through SC-012 against the changed files and record requirement coverage separately from test results in the Feature 083 completion record.
- [X] T053 Confirm `.specify/extensions.yml` remains absent or, if introduced during implementation, execute applicable `hooks.after_tasks` and `hooks.after_implement` procedures before reporting completion.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: T001 is the baseline; T002-T004 can run in parallel after the baseline.
- **Foundational (Phase 2)**: Depends on Phase 1; T005-T009 establish the shared contract and focused test, while T010 is a parallel governance review after those files exist.
- **User Stories (Phases 3-6)**: Depend on Phase 2. US1 enables the cross-skill references; US2 and US3 can proceed in parallel after US1's reference work, while US4 validates and reconciles all prior work.
- **Polish (Phase 7)**: Depends on all desired user stories.

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Foundational; MVP story and prerequisite for consistent cross-skill references.
- **User Story 2 (P1)**: Depends on Foundational and the references established by US1; each skill's progress edits are independently parallelizable.
- **User Story 3 (P1)**: Depends on Foundational and the references established by US1; outcome/resume edits are independently parallelizable.
- **User Story 4 (P2)**: Depends on US1-US3 because it verifies the complete shared contract and correspondence surface.

### Parallel Opportunities

- T002-T004 can run in parallel after T001.
- T014-T021 are parallel by file; T025-T031 are parallel by file; T035-T042 are parallel by file.
- T011-T013, T022-T024, T032-T034, and T043-T045 are parallel assertion groups only if they edit non-overlapping sections or are combined before implementation.
- US2 and US3 can be staffed in parallel after US1 references are present.
- T049-T051 can run in parallel only after all implementation work is complete; T052 follows their results.

## Parallel Example: User Story 1

```text
Task: T014 [P] [US1] Update .highway/skills/highway-profile/SKILL.md
Task: T015 [P] [US1] Update .highway/skills/highway-objectives/SKILL.md
Task: T016 [P] [US1] Update .highway/skills/highway-controls/SKILL.md
Task: T017 [P] [US1] Update .highway/skills/highway-nfrs/SKILL.md
Task: T018 [P] [US1] Update .highway/skills/highway-new/SKILL.md
Task: T019 [P] [US1] Update .highway/skills/highway-discovery/SKILL.md
Task: T020 [P] [US1] Update .highway/skills/highway-adr/SKILL.md
Task: T021 [P] [US1] Update .highway/skills/highway-clarify/SKILL.md
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 baseline and Phase 2 shared contract/focused validation.
2. Complete Phase 3 next-action and ownership alignment across the eight skills.
3. Run the US1 independent test and stop for review if the shared contract and references are sound.

### Incremental Delivery

1. Establish the shared contract and focused validation.
2. Deliver US1 next-action and ownership alignment as the first usable increment.
3. Add US2 guided collection progress and single-question behavior.
4. Add US3 outcome and resume declarations.
5. Complete US4 uniqueness, generated correspondence, and scope checks.
6. Run the full quickstart and repository suite before completion.

### Parallel Team Strategy

1. One maintainer completes the Experience Standard contract and foundational test.
2. After the shared reference wording is stable, separate maintainers can update Profile/Objectives/Controls/NFRs/New/Discovery/ADR/Clarify in parallel by file.
3. A validation maintainer can prepare focused assertions while skill edits proceed, then run correspondence and full-suite checks after integration.

## Notes

- Every implementation task includes a concrete repository path.
- `[P]` marks only tasks that can safely operate on separate files or independent validation sections.
- No task creates a runtime dependency, hidden persistence store, or external contract.
- Tests are included because FR-023 explicitly requires focused static or executable validation.
