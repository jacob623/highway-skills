---
description: "Task list for Experience Conversational Presence"
---

# Tasks: Experience Conversational Presence

**Input**: Design documents from `specs/121-profile-experience-synchronization/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Tests**: Contract assertions are included because the specification explicitly requires repository verification and a test-first implementation sequence.

## Phase 1: Setup

- [X] T001 Record the 7.0.0 Experience Standard baseline, protected rule text, and protected-path scope in `specs/121-profile-experience-synchronization/quickstart.md`.
- [X] T002 [P] Inspect the current Conversational Voice, Contextual Guidance, Interaction model, Constructive Advisory, Interaction Examples, version metadata, and affected contracts in `.highway/governance/experience-standard.md` and `.highway/tools/tests/`.
- [X] T003 [P] Confirm no extension hooks, external contracts, runtime storage, or new dependencies are required for Feature 121 in `specs/121-profile-experience-synchronization/plan.md` and `specs/121-profile-experience-synchronization/quickstart.md`.

---

## Phase 2: Foundational

- [X] T004 Add a protected-scope assertion covering individual skills, Profile, Objectives, Controls, NFRs, Setup, Highway Identity, shared output templates, and unrelated governance artifacts in `.highway/tools/tests/experience-standard-amendment.test.sh`.
- [X] T005 [P] Add preservation assertions for X1.7, X2.3, X2.4, X2.5, X2.6, X2.8, X2.9, X2.26, X2.33, X2.34, and X2.35 rule text and Observables in `.highway/tools/tests/experience-standard-amendment.test.sh`.
- [X] T006 [P] Add version-policy and rule-inventory assertions for the applicable MINOR amendment from 7.0.0, unchanged X-rule identifiers, and unchanged rule count in `.highway/tools/tests/experience-standard-amendment.test.sh`.

**Checkpoint**: Test-first preservation and scope checks fail only for the not-yet-added Conversational Presence amendment.

---

## Phase 3: User Story 1 - Make Useful Conversation Explicit (Priority: P1) 🎯 MVP

**Goal**: Make useful conversational depth, adaptive response length, and natural conclusion explicit without requiring a question or next action.

**Independent Test**: The focused UX contract finds the new Presence section and both non-normative no-question examples, while rejecting numeric verbosity quotas and filler-oriented guidance.

### Tests for User Story 1

- [X] T007 [P] [US1] Add failing assertions for the corrected Voice heading, Presence section placement, useful conversational depth, adaptive detail, multiple short paragraphs, natural conclusion, and anti-filler guardrails in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T008 [P] [US1] Add failing assertions for the Conversational Presence and No-question conversational turn examples in `.highway/tools/tests/highway-ux-alignment.test.sh`.

### Implementation for User Story 1

- [X] T009 [US1] Change the Conversational Voice heading to level four and add the non-normative Conversational Presence section in `.highway/governance/experience-standard.md`.
- [X] T010 [US1] Add adaptive conversational-depth, multiple-paragraph, natural-conclusion, and no-filler guidance to the Conversational Presence section in `.highway/governance/experience-standard.md`.
- [X] T011 [US1] Add non-normative Conversational presence and No-question conversational turn examples to the Interaction Examples section in `.highway/governance/experience-standard.md`.

**Checkpoint**: User Story 1 focused assertions pass and useful conversational turns may end without a question when no unresolved need remains.

---

## Phase 4: User Story 2 - Distinguish the Three Conversational Concepts (Priority: P1)

**Goal**: Separate Voice, Presence, and Constructive Advisory so each concept has a clear non-normative role.

**Independent Test**: The Experience Standard contains the three-concept distinction and Constructive Advisory retains conditional intellectual contribution without duplicating Presence guidance.

### Tests for User Story 2

- [X] T012 [P] [US2] Add failing assertions for the Voice, Presence, and Constructive Advisory conceptual distinction in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T013 [P] [US2] Add failing assertions for conversational, explanatory, or decision value and the early-stop conversational pattern in `.highway/tools/tests/highway-ux-alignment.test.sh`.

### Implementation for User Story 2

- [X] T014 [US2] Add the non-normative three-concept distinction immediately after Conversational Presence and before Constructive Advisory in `.highway/governance/experience-standard.md`.
- [X] T015 [US2] Broaden Constructive Advisory's value statement and rationalize its guidance around conditional intellectual contribution in `.highway/governance/experience-standard.md`.
- [X] T016 [US2] Update the Constructive Advisory conversational pattern to allow the sequence to stop at any earlier point in `.highway/governance/experience-standard.md`.

**Checkpoint**: User Story 2 focused assertions pass without a new X-rule or duplicated Highway Identity philosophy.

---

## Phase 5: User Story 3 - Preserve Interaction Boundaries While Allowing Natural Turns (Priority: P1)

**Goal**: Clarify the interaction model and Contextual Guidance while preserving all existing normative rules and Observables.

**Independent Test**: Preserved-rule contracts pass, the Interaction model allows natural conclusion, one-question constraints are explicitly maximum/necessity constraints, and the existing continuity example remains intact.

### Tests for User Story 3

- [X] T017 [P] [US3] Add failing assertions that one-question constraints do not require every response to contain a question and that no unresolved need permits a question-free response in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T018 [P] [US3] Add failing assertions for the revised Interaction model sequence, natural conclusion, Contextual Presence middle concept, and optional sequence elements in `.highway/tools/tests/experience-standard-amendment.test.sh`.
- [X] T019 [P] [US3] Add failing preservation assertions for X2.8, X2.9, X2.26, X2.33, X2.34, X2.35, implementation-detail suppression, progress discipline, and recommendation rationale in `.highway/tools/tests/experience-x23-contract.test.sh`.

### Implementation for User Story 3

- [X] T020 [US3] Update the Interaction model with natural response, optional contribution, necessary-question, and natural-conclusion language while preserving its explanatory status in `.highway/governance/experience-standard.md`.
- [X] T021 [US3] Add the one-question clarification immediately after the Interaction model in `.highway/governance/experience-standard.md` without modifying X1.7 or X2.4.
- [X] T022 [US3] Update Contextual Guidance with Conversational Presence, the revised interaction shape, and the statement that not every element is required on every turn in `.highway/governance/experience-standard.md`.
- [X] T023 [US3] Confirm the existing conversational-continuity example retains contribution, acknowledgment, optional useful observation, and grounded continuation in `.highway/governance/experience-standard.md`.

**Checkpoint**: User Story 3 preserved-rule and focused interaction contracts pass with no normative rule or Observable drift.

---

## Phase 6: User Story 4 - Keep the Amendment Non-Normative and Scoped (Priority: P2)

**Goal**: Apply version metadata and final scope evidence without changing individual skills or protected artifacts.

**Independent Test**: Version and scope contracts pass, the applicable MINOR increment from 7.0.0 is recorded, and the final diff contains only permitted files and Feature 121 artifacts.

### Tests for User Story 4

- [X] T024 [P] [US4] Add failing assertions for the applicable MINOR version, Last Amended metadata, unchanged rule inventory, and self-application review in `.highway/tools/tests/experience-standard-amendment.test.sh`.
- [X] T025 [P] [US4] Add failing assertions that no individual skill, Highway Identity, Profile record, shared template, or unrelated governance file changes in `.highway/tools/tests/experience-standard-amendment.test.sh`.

### Implementation for User Story 4

- [X] T026 [US4] Update the Experience Standard sync-impact report, version footer, amendment date, rule inventory, and self-application review according to the existing Versioning Policy in `.highway/governance/experience-standard.md`.
- [X] T027 [US4] Update directly affected repository version expectations and remove any superseded conversational-presence or version wording from `.highway/tools/tests/experience-standard-amendment.test.sh` and `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T028 [US4] Record final focused-contract, protected-scope, version, and full-suite evidence in `specs/121-profile-experience-synchronization/quickstart.md`.

**Checkpoint**: User Story 4 scope and version checks pass, with all protected paths unchanged.

---

## Phase 7: Polish & Cross-Cutting Validation

- [X] T029 Run `bash .highway/tools/tests/experience-standard-amendment.test.sh`, `bash .highway/tools/tests/highway-ux-alignment.test.sh`, `bash .highway/tools/tests/experience-x23-contract.test.sh`, and `bash .highway/tools/tests/feature-092-contract.test.sh` and record results in `specs/121-profile-experience-synchronization/quickstart.md`.
- [X] T030 Run `bash .highway/tools/tests/run-all.sh` and record the final result in `specs/121-profile-experience-synchronization/quickstart.md`.
- [X] T031 Run `git diff --check` and review the final changed-path list against the protected scope in `specs/121-profile-experience-synchronization/quickstart.md`.
- [X] T032 Confirm FR-001 through FR-032 and SC-001 through SC-009 have implementation or verification evidence in `specs/121-profile-experience-synchronization/quickstart.md`.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup and blocks story work.
- **User Stories (Phases 3-6)**: Depend on Foundational; US1, US2, and US3 share the Experience Standard and should be implemented sequentially to avoid same-file conflicts. US4 follows the content amendment.
- **Polish (Phase 7)**: Depends on all story phases.

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational; establishes the Presence section and examples.
- **User Story 2 (P1)**: Depends on US1 section placement; rationalizes adjacent Constructive Advisory guidance.
- **User Story 3 (P1)**: Depends on US1 and US2 terminology; updates shared interaction guidance and preservation assertions.
- **User Story 4 (P2)**: Depends on US1-US3; applies version and final scope evidence.

### Parallel Opportunities

- T002 and T003 can run in parallel during Setup.
- T005 and T006 can run in parallel during Foundational.
- T007 and T008 can run in parallel before US1 implementation.
- T012 and T013 can run in parallel before US2 implementation.
- T017, T018, and T019 can run in parallel before US3 implementation.
- T024 and T025 can run in parallel before US4 implementation.
- No implementation tasks touching `experience-standard.md` are parallelized because they share one file.

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational phases.
2. Complete User Story 1 to establish Conversational Presence and no-question examples.
3. Run the US1 focused contract checkpoint.
4. Continue with the remaining stories because the amendment's preserved-rule and version boundaries are part of the shippable contract.

### Incremental Delivery

1. Add Presence guidance and examples.
2. Add the three-concept distinction and rationalize Constructive Advisory.
3. Update Interaction model and Contextual Guidance while preserving normative rules.
4. Apply version metadata and protected-scope evidence.
5. Run focused and full validation.
