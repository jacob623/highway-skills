---

description: "Implementation tasks for Objectives Lifecycle Canonicalization"
---

# Tasks: Objectives Lifecycle Canonicalization

**Input**: Design documents from `/specs/162-objectives-lifecycle-canonicalization/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Static document-contract tests and the full repository suite are required by the feature specification.

**Organization**: Tasks are grouped by user story, with source guidance edited before generated adapters and verification.

## Phase 1: Setup

**Purpose**: Confirm the source-first distribution surface and existing validation commands.

- [X] T001 [P] Confirm the source skill, four generated adapters, and focused contract test paths in `specs/162-objectives-lifecycle-canonicalization/plan.md` and `.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh`
- [X] T002 Confirm the existing instruction-generation command and adapter byte-identity expectations in `.highway/tools/generate-instructions.sh` and `.highway/tools/tests/adapter-coverage.test.sh`

---

## Phase 2: Foundational

**Purpose**: Establish the focused contract assertions before changing the source guidance.

- [X] T003 Update `.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh` to assert the canonical lifecycle sequence, exactly one authoritative proposal field definition, User Acceptance before capture, queue references, and rejection of the preliminary/double-review anti-pattern
- [X] T004 Run `.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh` against the current source and record the expected pre-implementation failures in the task execution notes

**Checkpoint**: Focused contract expresses Feature 162 requirements and fails against the pre-change guidance.

---

## Phase 3: User Story 1 - Use one canonical Objective lifecycle (Priority: P1) [MVP]

**Goal**: Replace the current lifecycle with one authoritative sequence from recommendation selection or direct contribution through proposal, User Acceptance, capture, and the next Objective.

**Independent Test**: The focused contract test finds the exact lifecycle order and no preliminary proposal stage in `.highway/skills/highway-objectives/SKILL.md`.

### Implementation for User Story 1

- [X] T005 [US1] Replace the lifecycle block in `.highway/skills/highway-objectives/SKILL.md` with the canonical Objective Development Lifecycle and its single Converged Objective proposal definition
- [X] T006 [US1] Keep proposal-first development and discovery-exception guidance directly under the lifecycle in `.highway/skills/highway-objectives/SKILL.md`
- [X] T007 [US1] Regenerate `.github/skills/highway-objectives/SKILL.md`, `.claude/skills/highway-objectives/SKILL.md`, `.cursor/skills/highway-objectives/SKILL.md`, and `.agents/skills/highway-objectives/SKILL.md` from the updated source
- [X] T008 [US1] Run `.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh` and verify the lifecycle story passes independently

**Checkpoint**: The source and all adapters communicate one lifecycle with no separate starting-point stage.

---

## Phase 4: User Story 2 - Use one authoritative proposal definition (Priority: P1)

**Goal**: Preserve Success Measure proposal behavior while making every other section reference the lifecycle definition rather than repeat proposal fields.

**Independent Test**: Search the source and adapters and confirm the four proposal fields are defined once in the lifecycle while Success Measure guidance remains proposal-first and user-refinable.

### Implementation for User Story 2

- [X] T009 [US2] Remove duplicate proposal field lists from queue and capture guidance in `.highway/skills/highway-objectives/SKILL.md` and replace them with references to the Objective Development Lifecycle definition
- [X] T010 [US2] Preserve proposed Success Measure approval, modification, replacement, removal, and discovery-exception guidance in `.highway/skills/highway-objectives/SKILL.md`
- [X] T011 [US2] Update the focused assertions in `.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh` for one proposal definition and preserved Success Measure behavior
- [X] T012 [US2] Regenerate all Objective adapters and run `.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh` to validate source-reference and adapter consistency

**Checkpoint**: Proposal completeness has one authority and Success Measure behavior remains unchanged.

---

## Phase 5: User Story 3 - Treat User Acceptance as the capture boundary (Priority: P1)

**Goal**: Replace workflow-event uses of Review with User Acceptance and make acceptance of the current proposal the explicit prerequisite for capture.

**Independent Test**: The focused contract confirms that presentation, discussion, or selection is not capture and that User Acceptance precedes owner-controlled capture.

### Implementation for User Story 3

- [X] T013 [US3] Replace review-boundary wording with User Acceptance wording in the Objective queue and capture section of `.highway/skills/highway-objectives/SKILL.md`
- [X] T014 [US3] Rewrite the double-review guidance in `.highway/skills/highway-objectives/SKILL.md` to describe one proposal presentation, user correction or acceptance, and the prohibited preliminary/review/second-proposal path
- [X] T015 [US3] Regenerate all Objective adapters and run `.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh` for the acceptance boundary and anti-pattern checks

**Checkpoint**: User Acceptance is the only workflow event named as the boundary before capture.

---

## Phase 6: User Story 4 - Keep queue processing aligned with the lifecycle (Priority: P2)

**Goal**: Process selected recommendations sequentially through the canonical proposal, User Acceptance, capture, and next-item path.

**Independent Test**: The focused contract confirms queue selection does not capture, queue processing references the lifecycle, and the example says the first item is accepted and captured before the second begins.

### Implementation for User Story 4

- [X] T016 [US4] Replace queue processing prose in `.highway/skills/highway-objectives/SKILL.md` with the canonical four-step sequential queue process
- [X] T017 [US4] Update the illustrative queue example in `.highway/skills/highway-objectives/SKILL.md` to say the first Objective is accepted and captured before the second is developed
- [X] T018 [US4] Regenerate all Objective adapters and run `.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh` for sequential queue behavior

**Checkpoint**: Queue processing derives entirely from the canonical lifecycle and preserves non-capture at selection.

---

## Phase 7: Polish and Cross-Cutting Validation

**Purpose**: Verify protected contracts, adapter identity, and complete repository behavior.

- [X] T019 [P] Confirm `.github/skills/highway-objectives/SKILL.md`, `.claude/skills/highway-objectives/SKILL.md`, `.cursor/skills/highway-objectives/SKILL.md`, and `.agents/skills/highway-objectives/SKILL.md` are byte-identical to `.highway/skills/highway-objectives/SKILL.md`
- [X] T020 Run `.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh` and `.highway/tools/tests/run-all.sh`, confirming zero failures and preservation of ownership, persistence, readiness, mutation output, non-write, duplicate, overlap, and revalidation contracts
- [X] T021 Run the scenarios in `specs/162-objectives-lifecycle-canonicalization/quickstart.md` and update no runtime or persistent Objective artifacts
- [X] T022 Mark completed implementation tasks in `specs/162-objectives-lifecycle-canonicalization/tasks.md` only after the focused and full validation commands pass

---

## Dependencies and Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; confirms paths and generation commands.
- **Foundational (Phase 2)**: Depends on Setup; updates the focused contract before source implementation.
- **User Stories (Phases 3-6)**: Depend on Foundational; stories are ordered because they edit the same source guidance and generated adapters.
- **Polish (Phase 7)**: Depends on all story changes; performs final adapter and repository validation.

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Foundational; establishes the lifecycle authority used by all later stories.
- **User Story 2 (P1)**: Depends on User Story 1; removes duplicate definitions while preserving lifecycle guidance.
- **User Story 3 (P1)**: Depends on User Story 2; applies acceptance terminology to the canonical proposal and capture boundary.
- **User Story 4 (P2)**: Depends on User Story 3; aligns queue prose and example with the completed lifecycle.

### Parallel Opportunities

- T001 and T002 can run in parallel during Setup.
- T019 can run in parallel with final manual inspection after all source regeneration is complete.
- The four adapter comparisons in T019 can run in parallel because they read independent generated files.
- Story implementation tasks remain sequential because they intentionally edit the same source skill and focused test contract.

## Parallel Example: Setup and Final Adapter Checks

```text
Task: "Confirm source, adapters, and focused test paths in the Feature 162 plan"
Task: "Confirm the existing instruction-generation command and adapter identity test"

Task: "Compare .github Objective adapter with the source"
Task: "Compare .claude Objective adapter with the source"
Task: "Compare .cursor Objective adapter with the source"
Task: "Compare .agents Objective adapter with the source"
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Replace the lifecycle and preserve proposal-first discovery guidance.
3. Regenerate adapters.
4. Run the focused lifecycle contract.
5. Continue to the remaining stories only after the canonical lifecycle passes.

### Incremental Delivery

1. Establish the canonical lifecycle and proposal definition.
2. Remove duplicate proposal definitions while retaining Success Measure behavior.
3. Make User Acceptance the explicit capture boundary.
4. Align queue processing and its example.
5. Run focused and full repository validation.

## Notes

- This feature changes skill guidance and verification artifacts only; it does not change Objective records or runtime persistence.
- The existing Feature 161 focused test is updated in place because it is the established contract harness for this Objective lifecycle surface.
- No `contracts/` directory is generated because the repository exposes no external API or machine protocol for this feature.
