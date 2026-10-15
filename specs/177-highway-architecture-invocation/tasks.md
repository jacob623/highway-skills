---

description: "Task list for Highway Architecture and Implementation Invocation Guards"
---

# Tasks: Highway Architecture and Implementation Invocation Guards

**Input**: Design documents from `specs/177-highway-architecture-invocation/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/invocation-guards.md`, `quickstart.md`

**Tests**: Amend the existing onboarding contract tests because the feature specification defines exact user-visible behavior and no-write guarantees.

## Phase 1: Setup

**Purpose**: Establish the existing source and generated surfaces used by this feature.

- [X] T001 Verify the Feature 177 plan, research, data model, contract, quickstart, and constitution constraints in `specs/177-highway-architecture-invocation/`
- [X] T002 [P] Inspect the authoritative architecture and implementation skill contracts in `.highway/skills/highway-architecture/SKILL.md` and `.highway/skills/highway-implementation/SKILL.md`
- [X] T003 [P] Inspect the focused contract tests and generation entry points in `.highway/tools/tests/highway-architecture-onboarding.test.sh`, `.highway/tools/tests/highway-implementation-onboarding.test.sh`, and `.highway/tools/`

---

## Phase 2: Foundational

**Purpose**: Establish failing contract assertions and preserve the existing ownership boundary before skill edits.

- [X] T004 Record the current focused architecture and implementation onboarding test results and verify Feature 176 files remain outside the change scope in `.highway/tools/tests/` and `specs/176-*`
- [X] T005 [P] Add exact missing-input, explicit-identifier, no-selection, and no-write assertions for architecture invocation behavior in `.highway/tools/tests/highway-architecture-onboarding.test.sh`
- [X] T006 [P] Add exact missing-input, explicit-identifier, no-selection, and no-write assertions for implementation invocation behavior in `.highway/tools/tests/highway-implementation-onboarding.test.sh`

**Checkpoint**: Focused tests express the Feature 177 contract while existing checks remain intact.

---

## Phase 3: User Story 1 - Request the Missing Reference Architecture (Priority: P1)

**Goal**: `/highway-implementation` without an identifier requests the required architecture and performs no write or automatic selection.

**Independent Test**: The implementation onboarding test finds the exact next action, question, examples, and no-write/no-selection contract in the authoritative skill.

- [X] T007 [US1] Add the exact missing-ARCH response and zero-write/no-selection behavior to `.highway/skills/highway-implementation/SKILL.md`
- [X] T008 [US1] Run `.highway/tools/tests/highway-implementation-onboarding.test.sh` and confirm the missing-input contract passes in isolation

**Checkpoint**: User Story 1 is independently verifiable without an implementation artifact being generated.

---

## Phase 4: User Story 2 - Validate the Explicit Architecture Source (Priority: P1)

**Goal**: Explicit `ARCH######` input passes deterministic format, existence, uniqueness, completeness, and readiness checks before implementation processing.

**Independent Test**: The focused implementation test verifies accepted and rejected ARCH conditions, canonical validator reuse, and no partial writes.

- [X] T009 [US2] Document the exact explicit-ARCH validation order, canonical completeness/readiness validator reuse, and established failure outcomes in `.highway/skills/highway-implementation/SKILL.md`
- [X] T010 [US2] Run `.highway/tools/tests/highway-implementation-onboarding.test.sh` against valid, invalid-format, missing, duplicate, ambiguous, incomplete, and malformed ARCH contract assertions

**Checkpoint**: User Story 2 is independently testable and does not alter implementation-generation ownership.

---

## Phase 5: User Story 3 - Prevent Implicit Architecture Selection (Priority: P1)

**Goal**: The implementation workflow never selects an architecture from availability, ordering, timestamps, recency, context, environment, or session state.

**Independent Test**: The focused implementation test verifies explicit-source-only language, traceability preservation, and no-write behavior for missing or invalid input.

- [X] T011 [US3] Add explicit prohibitions on newest/only/filesystem/timestamp/recency/context/environment/session selection and preserve the `REQ -> DISC -> ADR -> ARCH -> RI` traceability boundary in `.highway/skills/highway-implementation/SKILL.md`
- [X] T012 [US3] Run `.highway/tools/tests/highway-implementation-onboarding.test.sh` and verify all implicit-selection and traceability assertions pass

**Checkpoint**: Implementation invocation behavior is complete and independently verifiable.

---

## Phase 6: User Story 4 - Request the Missing Architecture Decision (Priority: P1)

**Goal**: `/highway-architecture` without an identifier requests the required ADR and performs no write or automatic selection.

**Independent Test**: The architecture onboarding test finds the exact next action, question, examples, and no-write/no-selection contract in the authoritative skill.

- [X] T013 [US4] Add the exact missing-ADR response and zero-write/no-selection behavior to `.highway/skills/highway-architecture/SKILL.md`
- [X] T014 [US4] Run `.highway/tools/tests/highway-architecture-onboarding.test.sh` and confirm the missing-input contract passes in isolation

**Checkpoint**: User Story 4 is independently verifiable without an architecture artifact being generated.

---

## Phase 7: User Story 5 - Validate the Explicit Architecture Decision (Priority: P1)

**Goal**: Explicit `ADR######` input passes deterministic format, existence, uniqueness, completeness, and readiness checks before architecture processing.

**Independent Test**: The focused architecture test verifies accepted and rejected ADR conditions, canonical validator reuse, and no partial writes.

- [X] T015 [US5] Document the exact explicit-ADR validation order, canonical completeness/readiness validator reuse, and established failure outcomes in `.highway/skills/highway-architecture/SKILL.md`
- [X] T016 [US5] Run `.highway/tools/tests/highway-architecture-onboarding.test.sh` against valid, invalid-format, missing, duplicate, ambiguous, incomplete, and malformed ADR contract assertions

**Checkpoint**: User Story 5 is independently testable and does not alter architecture-generation ownership.

---

## Phase 8: User Story 6 - Prevent Implicit ADR Selection (Priority: P1)

**Goal**: The architecture workflow never selects an ADR from availability, ordering, timestamps, recency, context, environment, or session state.

**Independent Test**: The focused architecture test verifies explicit-source-only language, traceability preservation, and no-write behavior for missing or invalid input.

- [X] T017 [US6] Add explicit prohibitions on newest/only/filesystem/timestamp/recency/context/environment/session selection and preserve the `REQ -> DISC -> ADR -> ARCH` traceability boundary in `.highway/skills/highway-architecture/SKILL.md`
- [X] T018 [US6] Run `.highway/tools/tests/highway-architecture-onboarding.test.sh` and verify all implicit-selection and traceability assertions pass

**Checkpoint**: Architecture invocation behavior is complete and independently verifiable.

---

## Phase 9: Polish and Cross-Cutting Validation

**Purpose**: Regenerate derived artifacts and validate the complete feature without changing Feature 176.

- [X] T019 Regenerate `.highway/catalog/`, `.github/skills/`, `.claude/skills/`, and `.cursor/skills/` from the updated authoritative skills using the repository's existing generation commands
- [X] T020 [P] Run `.highway/tools/tests/highway-architecture-onboarding.test.sh` and `.highway/tools/tests/highway-implementation-onboarding.test.sh` after regeneration
- [X] T021 [P] Run `.highway/tools/tests/run-all.sh` and record any unrelated pre-existing failures without weakening tests
- [X] T022 Verify `git diff --check`, generated-source correspondence, no placeholder markers, and unchanged Feature 176 artifacts
- [X] T023 Run the Feature 177 quickstart scenarios from `specs/177-highway-architecture-invocation/quickstart.md` and confirm all tasks in this file are marked complete

---

## Dependencies and Execution Order

- Setup (Phase 1) precedes Foundational (Phase 2).
- Foundational test assertions (T005-T006) precede the two source-skill edits.
- US1-US3 share the implementation skill and execute in order; US4-US6 share the architecture skill and execute in order.
- The implementation story group and architecture story group can proceed in parallel after Phase 2, but tasks touching the same skill file remain sequential.
- Polish begins only after both story groups pass their focused tests.

## Parallel Opportunities

- T002 and T003 can run in parallel.
- T005 and T006 can run in parallel because they touch different test files.
- The implementation story group (US1-US3) and architecture story group (US4-US6) can be assigned in parallel after the foundational phase.
- T020 and T021 can run in parallel after regeneration.

## Implementation Strategy

1. Complete setup and establish the focused contract assertions.
2. Deliver the implementation invocation guard as the first P1 increment.
3. Deliver the architecture invocation guard as the second P1 increment.
4. Regenerate every derived surface and run focused plus full validation.
5. Preserve Feature 176 unchanged and report any unrelated existing failures separately.
