---
description: "Task list for promoting the rewritten Highway skills"
---

# Tasks: Promote Rewritten Skills

**Input**: Design documents from `/specs/186-promote-skill-rewrites/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Invariant checks are required by FR-015. They are written and observed failing before the drafts replace the current skills.

**Organization**: Tasks are grouped by user story. Task IDs follow execution order.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prove the suite is green before any promotion edit

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing summary in `specs/186-promote-skill-rewrites/baseline.txt`. Stop if it exits non-zero
- [X] T002 [P] Confirm the twelve skill drafts and nine catalog drafts named in `specs/186-promote-skill-rewrites/contracts/skill-promotion.md` and `specs/186-promote-skill-rewrites/contracts/catalog-templates.md` exist in the sibling folder `highway-skills-v2`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Record the superseded behaviors and observe the new invariant checks failing on the current skills

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T003 Create `specs/186-promote-skill-rewrites/retirements.md` with one entry per superseded behavior in `specs/186-promote-skill-rewrites/contracts/check-retirement.md`
- [X] T004 [P] Add `.highway/tools/tests/promotion-invariants.test.sh` covering identifier shape, same-title reuse, collision wording, one Decision per Discovery, a conceptual Reference Architecture, and the catalog statuses in `specs/186-promote-skill-rewrites/data-model.md`
- [X] T005 Run `.highway/tools/tests/promotion-invariants.test.sh` against the current skills, save the failing output in `specs/186-promote-skill-rewrites/invariant-failure.txt`, and do not edit a skill to make it pass

**Checkpoint**: The invariant check has been seen failing, and the retirement register exists

---

## Phase 3: User Story 1 - Use the rewritten skills (Priority: P1) 🎯 MVP

**Goal**: The twelve drafted skills and their catalog templates are the repository sources, and `highway-new` no longer collects a request

**Independent Test**: Diff each source skill against its draft in `highway-skills-v2`. Invoke Discovery, the Decision skill, the architecture skill, and the implementation skill with no identifier and confirm a numbered list whose lines show the identifier and the title

### Implementation for User Story 1

- [X] T006 [P] [US1] Copy `highway-skills-v2/profile.md` to `.highway/skills/highway-profile/SKILL.md`
- [X] T007 [P] [US1] Copy `highway-skills-v2/objectives.md` to `.highway/skills/highway-objectives/SKILL.md`
- [X] T008 [P] [US1] Copy `highway-skills-v2/controls.md` to `.highway/skills/highway-controls/SKILL.md`
- [X] T009 [P] [US1] Copy `highway-skills-v2/nfrs.md` to `.highway/skills/highway-nfrs/SKILL.md`
- [X] T010 [P] [US1] Copy `highway-skills-v2/setup.md` to `.highway/skills/highway-setup/SKILL.md`
- [X] T011 [P] [US1] Copy `highway-skills-v2/request.md` to `.highway/skills/highway-request/SKILL.md`
- [X] T012 [P] [US1] Copy `highway-skills-v2/discovery.md` to `.highway/skills/highway-discovery/SKILL.md`
- [X] T013 [P] [US1] Copy `highway-skills-v2/adr.md` to `.highway/skills/highway-adr/SKILL.md`
- [X] T014 [P] [US1] Copy `highway-skills-v2/architecture.md` to `.highway/skills/highway-architecture/SKILL.md`
- [X] T015 [P] [US1] Copy `highway-skills-v2/implementation.md` to `.highway/skills/highway-implementation/SKILL.md`
- [X] T016 [P] [US1] Copy `highway-skills-v2/onboarding.md` to `.highway/skills/highway-onboarding/SKILL.md`
- [X] T017 [P] [US1] Copy `highway-skills-v2/assessment.md` to `.highway/skills/highway-assessment/SKILL.md`
- [X] T018 [P] [US1] Replace `.highway/skills/highway-new/SKILL.md` so the name stays reserved, the skill writes nothing, and it directs the person to `/highway-request`
- [X] T019 [P] [US1] Replace `.highway/library/templates/output/objective-catalog.md` with the content of `highway-skills-v2/objectives-catalog.md`
- [X] T020 [P] [US1] Replace `.highway/library/templates/output/control-catalog.md` with the content of `highway-skills-v2/controls-catalog.md`
- [X] T021 [P] [US1] Replace `.highway/library/templates/output/nfr-catalog.md` with the content of `highway-skills-v2/nfrs-catalog.md`
- [X] T022 [P] [US1] Replace `.highway/library/templates/output/request-catalog.md` with the content of `highway-skills-v2/request-catalog.md`
- [X] T023 [P] [US1] Replace `.highway/library/templates/output/discovery-catalog.md` with the content of `highway-skills-v2/discovery-catalog.md`
- [X] T024 [P] [US1] Replace `.highway/library/templates/output/adr-catalog.md` with the content of `highway-skills-v2/adr-catalog.md`
- [X] T025 [P] [US1] Replace `.highway/library/templates/output/architecture-catalog.md` with the content of `highway-skills-v2/architecture-catalog.md`
- [X] T026 [P] [US1] Replace `.highway/library/templates/output/implementation-catalog.md` with the content of `highway-skills-v2/implementation-catalog.md`
- [X] T027 [P] [US1] Replace `.highway/library/templates/output/assessment-findings.md` with the content of `highway-skills-v2/assessment-findings.md`
- [X] T028 [US1] Update `.highway/library/templates/output/capability-catalog.md` to the columns and identifier rules in `.highway/skills/highway-implementation/SKILL.md`, removing `Next ID` and sequential `CAP######` allocation
- [X] T029 [US1] Compare each record template under `.highway/library/templates/output/` cited by a promoted skill and update only the templates whose written shape no longer matches that skill
- [X] T030 [US1] Run `.highway/tools/validate-skill.sh` for the twelve promoted skills and `.highway/skills/highway-new/SKILL.md`, and repair only the reported authoring-rule failures in those `SKILL.md` files

**Checkpoint**: The drafted skills are the sources. User Story 1 can be checked by diff and by invoking a skill with no identifier

---

## Phase 4: User Story 2 - Retire obsolete interaction checks (Priority: P2)

**Goal**: Checks that only lock the previous interaction are gone, each retirement names that behavior, and governance checks remain

**Independent Test**: Read `specs/186-promote-skill-rewrites/retirements.md` and confirm every removed assertion maps to a superseded behavior in `specs/186-promote-skill-rewrites/contracts/check-retirement.md`. Constitution, experience-standard, authoring, and generator tests are still present

### Implementation for User Story 2

- [X] T031 [US2] Classify every `.highway/tools/tests/*.test.sh` against `specs/186-promote-skill-rewrites/contracts/check-retirement.md` and record each retired check in `specs/186-promote-skill-rewrites/retirements.md`
- [X] T032 [P] [US2] Delete the profile interaction tests classified as retired, including the `feature-1*.test.sh` profile files and `profile-*.test.sh` files named in that register, under `.highway/tools/tests/`
- [X] T033 [P] [US2] Delete the objectives, controls, and non-functional-requirement interaction tests classified as retired under `.highway/tools/tests/`
- [X] T034 [P] [US2] Delete the setup and readiness interaction tests classified as retired, including `.highway/tools/tests/readiness-contract.test.sh`, `.highway/tools/tests/readiness-executable.test.sh`, `.highway/tools/tests/readiness-owner-states.test.sh`, and `.highway/tools/tests/readiness-ownership.test.sh` when the register names them
- [X] T035 [P] [US2] Delete the request, discovery, decision, architecture, implementation, onboarding, and assessment interaction tests classified as retired under `.highway/tools/tests/`
- [X] T036 [US2] Edit mixed checks so only superseded assertions are removed, including `.highway/tools/tests/output-template.test.sh`, `.highway/tools/tests/capability-catalog.test.sh`, and `.highway/tools/tests/highway-new.test.sh`, and make `highway-new.test.sh` assert that `.highway/skills/highway-new/SKILL.md` writes no request
- [X] T037 [US2] Confirm `.highway/tools/tests/constitution-experience-alignment.test.sh`, `.highway/tools/tests/experience-standard-convergence.test.sh`, `.highway/tools/tests/authoring-standard.test.sh`, `.highway/tools/tests/generate-agent-adapters.test.sh`, `.highway/tools/tests/highway-clarify.test.sh`, and `.highway/tools/tests/relationship-integrity.test.sh` were not deleted

**Checkpoint**: Obsolete interaction checks are retired with a named reason. Governance checks remain

---

## Phase 5: User Story 3 - Confirm the lasting invariants (Priority: P3)

**Goal**: The invariant check that failed before promotion now passes because the promoted skills and templates satisfy it

**Independent Test**: `.highway/tools/tests/promotion-invariants.test.sh` exits 0, and `specs/186-promote-skill-rewrites/invariant-failure.txt` still records the earlier failure

### Implementation for User Story 3

- [X] T038 [US3] Re-run `.highway/tools/tests/promotion-invariants.test.sh` and confirm it exits 0
- [X] T039 [US3] When T038 fails, correct only the invariant mismatch in the promoted skill under `.highway/skills/` or the matching template under `.highway/library/templates/output/`, without redesigning the drafted interaction, then re-run the check

**Checkpoint**: Identifier, Decision, architecture, and catalog-status invariants pass

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Publish matching copies and prove the full suite is green

- [X] T040 Run `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, `.highway/tools/generate-agent-adapters.sh`, and `.highway/tools/generate-instructions.sh` from the repository root
- [X] T041 Confirm `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, and `.agents/skills/` each contain `highway-request` and match the source skills, with no hand edits left in those trees
- [X] T042 [P] Confirm `.highway/governance/constitution.md`, `.specify/memory/constitution.md`, and `.highway/governance/experience-standard.md` have no content change from the pre-promotion versions
- [X] T043 Run `.highway/tools/tests/run-all.sh` and require exit 0
- [X] T044 Execute the manual scenarios in `specs/186-promote-skill-rewrites/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup. Blocks every user story
- **User Story 1 (Phase 3)**: Depends on Foundational. Does not depend on User Story 2 or User Story 3
- **User Story 2 (Phase 4)**: Depends on Foundational. T036 depends on the User Story 1 template updates
- **User Story 3 (Phase 5)**: Depends on User Story 1, because the invariants are confirmed against the promoted skills
- **Polish (Phase 6)**: Depends on User Stories 1, 2, and 3

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational. MVP without the check retirement
- **User Story 2 (P2)**: Classification can start after Foundational. Mixed-check edits wait for the new templates
- **User Story 3 (P3)**: The failing check is created in Foundational. The passing confirmation waits for User Story 1

### Within Each User Story

- Skill and catalog copies touch different files and run in parallel
- `validate-skill.sh` runs after those copies
- Check classification finishes before deletions
- The invariant failure log is not overwritten when the check later passes

### Parallel Opportunities

- T002 can run with T001
- T004 can run with T003
- T006 through T027 can run together
- T032 through T035 can run together after T031

---

## Parallel Example: User Story 1

```bash
# Copy the twelve skill drafts and the catalog drafts together:
Task: "Copy highway-skills-v2/profile.md to .highway/skills/highway-profile/SKILL.md"
Task: "Copy highway-skills-v2/objectives.md to .highway/skills/highway-objectives/SKILL.md"
Task: "Replace .highway/library/templates/output/objective-catalog.md with highway-skills-v2/objectives-catalog.md"
Task: "Replace .highway/library/templates/output/adr-catalog.md with highway-skills-v2/adr-catalog.md"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational, including the recorded invariant failure
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Diff the sources against the drafts and invoke one identifier-seeking skill
5. Continue to User Story 2 before expecting `.highway/tools/tests/run-all.sh` to pass

### Incremental Delivery

1. Setup and Foundational produce the failure evidence and the retirement register
2. User Story 1 makes the drafted skills the sources
3. User Story 2 removes the checks that would reject those sources
4. User Story 3 confirms the invariants now pass
5. Polish regenerates published copies and runs the full suite

### Parallel Team Strategy

1. One person completes Setup and Foundational
2. After that, one person copies skills while another copies catalog templates
3. Check retirement starts once classification is done, and mixed edits wait for the new templates
4. Invariant confirmation and generator regeneration are last

---

## Notes

- [P] tasks use different files and have no ordering dependency
- Do not promote `highway-skills-v2/fullsuite-copilot-gemini.md`
- Do not edit `.highway/governance/constitution.md`, `.specify/memory/constitution.md`, or `.highway/governance/experience-standard.md`
- Do not hand-edit generated adapters
- Repair a `validate-skill.sh` failure only for the reported rule
