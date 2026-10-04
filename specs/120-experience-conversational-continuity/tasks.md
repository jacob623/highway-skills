---
description: "Task list for Experience Conversational Continuity"
---

# Tasks: Experience Conversational Continuity

**Input**: Design documents from `specs/120-experience-conversational-continuity/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `quickstart.md`

**Tests**: Required. Feature 120 explicitly requires repository checks, preservation assertions, and full-suite validation. Test tasks precede the corresponding Experience Standard edits.

**Organization**: Tasks are grouped by the four prioritized user stories. The implementation is limited to the Experience Standard, directly affected checks/examples/version records, and Feature 120 design artifacts. No individual skill or shared output template is in scope.

## Phase 1: Setup

**Purpose**: Establish the baseline and confirm the authoritative Experience Standard version and affected check surface.

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` and record the baseline result in `specs/120-experience-conversational-continuity/quickstart.md`.
- [X] T002 [P] Run `bash .highway/tools/tests/experience-standard-amendment.test.sh` and record the baseline X2.8/version result in `specs/120-experience-conversational-continuity/quickstart.md`.
- [X] T003 [P] Inventory X2.8, Contextual Guidance, Interaction model, Constructive Advisory, examples, and version metadata in `.highway/governance/experience-standard.md` and affected checks under `.highway/tools/tests/`.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish test-first preservation and scope checks before changing the shared contract.

**Checkpoint**: Baseline is recorded, X2.8 is confirmed at 6.0.0, and protected files are explicit.

- [X] T004 [P] Add a protected-scope assertion for unchanged Profile, Objectives, Controls, NFRs, Setup, Highway Identity, and `profile-record.md` paths in `.highway/tools/tests/experience-standard-amendment.test.sh`.
- [X] T005 [P] Add a version and rule-inventory assertion for the expected MAJOR transition from 6.0.0 to 7.0.0 while retaining 39 X rules and X2.8 in `.highway/tools/tests/experience-standard-amendment.test.sh`.
- [X] T006 [P] Add a focused fixture or assertion for first-person conversational examples, continuous-conversation guidance, and non-normative labeling in `.highway/tools/tests/highway-ux-alignment.test.sh`.

## Phase 3: User Story 1 - Speak as One Highway Advisor (Priority: P1) MVP

**Goal**: Add first-person conversational voice guidance while preserving the Highway product boundary and non-human distinction.

**Independent Test**: Run the UX alignment and Experience Standard amendment contracts and verify first-person examples, product-boundary language, non-normative labels, and no changes to Highway Identity.

### Tests for User Story 1

- [X] T007 [P] [US1] Add failing assertions for the `#### Conversational Voice (Non-Normative Guidance)` section and its placement in `.highway/tools/tests/experience-standard-amendment.test.sh`.
- [X] T008 [P] [US1] Add failing assertions for first-person examples, Highway product-boundary wording, non-human limits, and one-advisor continuity in `.highway/tools/tests/highway-ux-alignment.test.sh`.

### Implementation for User Story 1

- [X] T009 [US1] Add the `#### Conversational Voice (Non-Normative Guidance)` section after Contextual Guidance and before Constructive Advisory in `.highway/governance/experience-standard.md`.
- [X] T010 [US1] Add first-person voice guidance, Highway boundary guidance, non-human limits, and one-informed-advisor continuity to `.highway/governance/experience-standard.md`.

**Checkpoint**: First-person Highway voice is documented as non-normative conversational guidance and product references remain distinct.

## Phase 4: User Story 2 - Acknowledge Meaningful Accepted Information (Priority: P1)

**Goal**: Redefine X2.8 so meaningful accepted changes are acknowledged in the next response and distinguish that requirement from optional advisory contribution.

**Independent Test**: Run focused X2.8 checks and inspect the source to confirm the stable identifier/tier, strengthened obligation/Observable, removal of superseded wording, and preserved one-question behavior.

### Tests for User Story 2

- [X] T011 [P] [US2] Add failing assertions for the strengthened X2.8 rule, Observable, and `[agent-checkable]` tier in `.highway/tools/tests/experience-standard-amendment.test.sh`.
- [X] T012 [P] [US2] Add failing assertions for the Contextual Guidance distinction between required acknowledgment and conditional Constructive Advisory in `.highway/tools/tests/highway-ux-alignment.test.sh`.

### Implementation for User Story 2

- [X] T013 [US2] Replace the X2.8 rule and Observable in `.highway/governance/experience-standard.md` with the meaningful accepted-information acknowledgment requirement.
- [X] T014 [US2] Update Contextual Guidance in `.highway/governance/experience-standard.md` to distinguish acknowledgment from optional advisory contribution and document the accepted-contribution interaction shape.
- [X] T015 [US2] Update the Interaction model in `.highway/governance/experience-standard.md` to acknowledge changed understanding before recommendation evaluation while preserving one-question behavior.

**Checkpoint**: X2.8 requires demonstrated understanding when meaningful accepted context changes the next behavior, without requiring advisory filler.

## Phase 5: User Story 3 - Add Useful Advisory Depth Without Filler (Priority: P1)

**Goal**: Make Constructive Advisory and continuous conversation useful, conditional, and explicitly non-normative.

**Independent Test**: Run UX and Experience Standard contracts against grounded and insufficient-grounding examples; verify optional advisory contribution, omission when it adds no value, and continuing-conversation guidance.

### Tests for User Story 3

- [X] T016 [P] [US3] Add failing assertions for the revised Constructive Advisory pattern and decision-value boundary in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T017 [P] [US3] Add failing assertions for the continuous-conversation principle and updated interaction examples in `.highway/tools/tests/experience-standard-amendment.test.sh`.
- [X] T018 [P] [US3] Add a failing assertion for the less-transactional single-recommendation example in `.highway/tools/tests/highway-ux-alignment.test.sh`.

### Implementation for User Story 3

- [X] T019 [US3] Revise the Constructive Advisory conversational pattern and add decision-value guidance in `.highway/governance/experience-standard.md`.
- [X] T020 [US3] Add the continuous-conversation principle immediately after the Constructive Advisory pattern in `.highway/governance/experience-standard.md`.
- [X] T021 [US3] Add explicitly non-normative Conversational identity and Conversational continuity examples to the Interaction Examples section in `.highway/governance/experience-standard.md`.
- [X] T022 [US3] Replace the single-recommendation example with accuracy-oriented, less-transactional wording in `.highway/governance/experience-standard.md`.

**Checkpoint**: The standard supports richer grounded conversation without manufacturing commentary, increasing verbosity by rule, or adding questions.

## Phase 6: User Story 4 - Preserve Shared Interaction Boundaries (Priority: P2)

**Goal**: Preserve neighboring X rules, user ownership, Decision Context, machine-result suppression, completion synthesis, scope boundaries, and major version evidence.

**Independent Test**: Run all affected contracts and the full suite, inspect version/amendment metadata, and confirm only Experience Standard-owned artifacts and directly affected checks changed.

### Tests for User Story 4

- [X] T023 [P] [US4] Add failing preservation assertions for X1.7, X2.9, X2.13, X2.33, X2.34, and X2.35 in `.highway/tools/tests/experience-standard-amendment.test.sh`.
- [X] T024 [P] [US4] Add failing assertions that Profile, Objectives, Controls, NFRs, Setup, Highway Identity, and `profile-record.md` are unchanged in `.highway/tools/tests/experience-standard-amendment.test.sh`.
- [X] T025 [P] [US4] Add failing assertions for the MAJOR sync-impact report, 7.0.0 footer, 39-rule inventory, stable X2.8 identifier, and self-application review in `.highway/tools/tests/highway-ux-alignment.test.sh`.

### Implementation for User Story 4

- [X] T026 [US4] Update the Experience Standard sync-impact report, version footer, amendment date, rule inventory, and self-application review for the X2.8 MAJOR amendment in `.highway/governance/experience-standard.md`.
- [X] T027 [US4] Update affected repository version expectations and remove superseded X2.8 wording from `.highway/tools/tests/experience-standard-amendment.test.sh` and `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T028 [US4] Verify no changes are made to individual skills, Highway Identity, shared output templates, or unrelated governance documents, recording the scope result in `specs/120-experience-conversational-continuity/quickstart.md`.

**Checkpoint**: The amendment is versioned as a MAJOR X2.8 change and all preserved interaction/ownership boundaries remain represented.

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate only affected records if required, validate the complete feature, and record evidence.

- [X] T029 [P] Run `bash .highway/tools/tests/experience-standard-amendment.test.sh`, `bash .highway/tools/tests/highway-ux-alignment.test.sh`, and `bash .highway/tools/tests/feature-092-contract.test.sh`; record results in `specs/120-experience-conversational-continuity/quickstart.md`.
- [X] T030 [P] Run `bash .highway/tools/tests/run-all.sh` and record the final result in `specs/120-experience-conversational-continuity/quickstart.md`.
- [X] T031 Run `git diff --check` and review the final diff for out-of-scope files; record the result in `specs/120-experience-conversational-continuity/quickstart.md`.
- [X] T032 Confirm FR-001 through FR-032 and SC-001 through SC-010 have implementation or verification evidence in `specs/120-experience-conversational-continuity/quickstart.md`.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup**: T001-T003 establish baseline and the affected contract inventory.
- **Foundational**: T004-T006 establish scope, version, and voice assertions; depends on Setup.
- **US1**: T007-T010; depends on Foundational and is the MVP.
- **US2**: T011-T015; depends on US1 because X2.8 acknowledgment follows conversational voice guidance.
- **US3**: T016-T022; depends on US2 because advisory behavior follows required acknowledgment.
- **US4**: T023-T028; depends on US3 and owns version/preservation boundaries.
- **Polish**: T029-T032; depends on all story checkpoints.

### Parallel Opportunities

- T002-T003 can run in parallel after T001.
- T004-T006 can run in parallel because they affect separate assertion surfaces.
- T007-T008 can run in parallel before the US1 source edit.
- T011-T012 can run in parallel before the US2 source edits.
- T016-T018 can run in parallel before the US3 source edits.
- T023-T025 can run in parallel before the US4 source/version edits.
- T029-T031 can run in parallel after all story checkpoints.

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational phases.
2. Complete User Story 1 with first-person Conversational Voice guidance.
3. Run the independent US1 contracts before proceeding.

### Incremental Delivery

1. Establish baseline and protected-scope assertions.
2. Add first-person conversational identity.
3. Redefine X2.8 and acknowledgment continuity.
4. Add conditional advisory depth and continuous-conversation examples.
5. Apply MAJOR version/preservation evidence.
6. Run focused and full validation, then map evidence to all requirements and success criteria.
