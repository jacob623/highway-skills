# Tasks: Controls Alignment Recommendation

**Input**: Design documents from `/specs/170-controls-alignment-recommendation/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Organization**: Tasks are grouped by user story so each story can be implemented and validated independently.

## Phase 1: Setup

- [X] T001 Confirm the Feature 170 baseline and current full-suite result with `.highway/tools/tests/run-all.sh`
- [X] T002 [P] Inventory the authoritative Controls skill, Objectives reference patterns, focused tests, and generator entry points in `.highway/skills/highway-controls/SKILL.md`, `.highway/skills/highway-objectives/SKILL.md`, and `.highway/tools/`

## Phase 2: Foundational

- [X] T003 Record the preserved Control ownership, persistence, classification, relationship, and Control-derived NFR boundaries in `.highway/skills/highway-controls/SKILL.md`
- [X] T004 [P] Add or amend shared Controls interaction-contract assertions in `.highway/tools/tests/highway-controls-onboarding.test.sh`
- [X] T005 [P] Add or amend preserved downstream behavior assertions in `.highway/tools/tests/control-derived-nfr.test.sh`

## Phase 3: User Story 1 - Develop Controls from grounded recommendations (Priority: P1) MVP

**Goal**: Make grounded recommendations the normal Control-development entry point while retaining discovery as an exception and preserving the user-authored path.

**Independent Test**: With accepted context available, verify that recommendations precede exploratory questions, selections form an ordered uncaptured queue, and a user-authored safeguard can enter development.

- [X] T006 [US1] Add response support text and interpretation-confidence guidance to `.highway/skills/highway-controls/SKILL.md`
- [X] T007 [US1] Define context-derived and Coverage Area recommendation-generation rules in `.highway/skills/highway-controls/SKILL.md`
- [X] T008 [US1] Define unified recommendation presentation and selection behavior in `.highway/skills/highway-controls/SKILL.md`
- [X] T009 [US1] Replace dominant Concern, Condition, and Obligation user-visible stages with recommendation-first workflow language in `.highway/skills/highway-controls/SKILL.md`
- [X] T010 [US1] Extend `.highway/tools/tests/highway-controls-onboarding.test.sh` to verify recommendation ordering, selection without capture, user-authored safeguards, and discovery fallback
- [X] T011 [US1] Run the focused onboarding test and repair only local Controls contract failures in `.highway/skills/highway-controls/SKILL.md` and `.highway/tools/tests/highway-controls-onboarding.test.sh`

## Phase 4: User Story 2 - Review and accept a complete Control proposal (Priority: P1)

**Goal**: Ensure every responsible selected or authored safeguard becomes a complete provisional proposal before explicit acceptance and owner capture.

**Independent Test**: Develop a selected or authored safeguard, correct or replace it, accept it, and verify that capture occurs only after acceptance while the existing retained record contract remains unchanged.

- [X] T012 [US2] Define the Converged Control Proposal fields, correction path, and acceptance boundary in `.highway/skills/highway-controls/SKILL.md`
- [X] T013 [US2] Define one-at-a-time queue processing and capture sequencing in `.highway/skills/highway-controls/SKILL.md`
- [X] T014 [US2] Preserve existing Control record and owner output contracts while integrating proposal-first development in `.highway/skills/highway-controls/SKILL.md`
- [X] T015 [US2] Extend `.highway/tools/tests/highway-controls-onboarding.test.sh` to verify proposal completeness, correction/replacement, acceptance-before-capture, and material-revision review
- [X] T016 [US2] Run focused Controls and persistence checks and repair local regressions in `.highway/skills/highway-controls/SKILL.md`, `.highway/tools/tests/highway-controls-onboarding.test.sh`, and `.highway/tools/tests/control-derived-nfr.test.sh`

## Phase 5: User Story 3 - Expand recommendation coverage without exposing internal categories (Priority: P2)

**Goal**: Add useful, context-adapted coverage-derived recommendations without exposing Coverage Areas or changing governance meaning.

**Independent Test**: With a meaningful coverage gap, verify that context-derived and coverage-derived safeguards appear together, category labels remain hidden, and additional suggestions stop when grounded non-duplicates are exhausted.

- [X] T017 [US3] Define the five internal Coverage Areas and their non-policy recommendation boundaries in `.highway/skills/highway-controls/SKILL.md`
- [X] T018 [US3] Define additional-suggestion evaluation across accepted context and the accepted Control portfolio in `.highway/skills/highway-controls/SKILL.md`
- [X] T019 [US3] Extend `.highway/tools/tests/highway-controls-onboarding.test.sh` to verify source ordering, hidden Coverage Areas, contextual adaptation, deduplication, and exhausted-suggestion behavior
- [X] T020 [US3] Run the focused coverage tests and repair local recommendation-contract failures in `.highway/skills/highway-controls/SKILL.md` and `.highway/tools/tests/highway-controls-onboarding.test.sh`

## Phase 6: User Story 4 - Continue collection with portfolio awareness (Priority: P2)

**Goal**: Continue Control collection after capture with concise portfolio awareness until explicit finish.

**Independent Test**: Capture multiple Controls, observe an advisory assessment and continuation invitation, request more suggestions, and explicitly finish without creating further recommendations.

- [X] T021 [US4] Define grounded one-at-a-time contributions and optional portfolio assessment guidance in `.highway/skills/highway-controls/SKILL.md`
- [X] T022 [US4] Define post-capture synthesis, additional-suggestion continuation, readiness independence, and explicit-finish behavior in `.highway/skills/highway-controls/SKILL.md`
- [X] T023 [US4] Extend `.highway/tools/tests/highway-controls-onboarding.test.sh` to verify portfolio advisory behavior, continuation, readiness independence, and explicit finish
- [X] T024 [US4] Run focused continuation tests and repair local Controls contract failures in `.highway/skills/highway-controls/SKILL.md` and `.highway/tools/tests/highway-controls-onboarding.test.sh`

## Phase 7: Polish and Cross-Cutting Validation

- [X] T025 Regenerate all derived agent adapters, catalogs, and manifests from `.highway/skills/highway-controls/SKILL.md` using the existing generator workflow
- [X] T026 Validate generated correspondence with `.highway/tools/tests/generate-agent-adapters.test.sh`, `.highway/tools/tests/generate-catalog.test.sh`, and `.highway/tools/tests/adapter-coverage.test.sh`
- [X] T027 [P] Run `git diff --check` and confirm no change was made to `.highway/skills/highway-profile/SKILL.md`
- [X] T028 Run the complete repository suite with `.highway/tools/tests/run-all.sh`
- [X] T029 [P] Validate the Feature 170 checklist and requirements traceability in `specs/170-controls-alignment-recommendation/checklists/requirements.md`
- [X] T030 Record final requirement coverage separately from executable check results and update the Feature 170 completion artifacts under `specs/170-controls-alignment-recommendation/`

## Dependencies and Execution Order

- **Setup (Phase 1)**: T001-T002; no implementation dependency.
- **Foundational (Phase 2)**: T003-T005 depend on Setup and block story work.
- **User Story 1 (Phase 3)**: T006-T011 depend on Foundational; this is the MVP increment.
- **User Story 2 (Phase 4)**: T012-T016 depend on the shared interaction model from US1 but remain independently testable.
- **User Story 3 (Phase 5)**: T017-T020 depend on US1 recommendation presentation and are independently testable.
- **User Story 4 (Phase 6)**: T021-T024 depend on US2 acceptance/capture and US3 additional suggestions.
- **Polish (Phase 7)**: T025-T030 depend on all intended story work and complete before reporting implementation.

### Parallel Opportunities

- T002 can run in parallel with T001.
- T004 and T005 can run in parallel after T003's boundary review.
- Within US3 and US4, documentation edits and their focused test edits can be prepared in parallel when they touch separate files, then validated together.
- T027 and T029 can run in parallel with each other after regeneration; T025 must finish before T026 and the final suite.

## Parallel Example: User Story 1

```text
Task T006: Add response support and interpretation guidance in the authoritative skill.
Task T010: Prepare focused onboarding assertions in the Controls test file.

After both complete:
Task T011: Run the focused onboarding test and repair the local contract.
```

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational phases.
2. Complete User Story 1.
3. Run its independent onboarding validation.
4. Continue to User Story 2 because explicit acceptance and capture are required for a usable proposal-first flow.

### Incremental Delivery

1. Add recommendation-first development and validate US1.
2. Add proposal acceptance boundaries and validate US2.
3. Add internal coverage guidance and validate US3.
4. Add continuation and portfolio awareness and validate US4.
5. Regenerate derived artifacts and run the complete suite.

## Notes

- Every task uses the required checkbox, sequential ID, optional parallel marker, story label where applicable, and an exact repository path.
- Static document-contract evidence remains distinct from executable behavior evidence.
- No task modifies `.highway/skills/highway-profile/SKILL.md`.
