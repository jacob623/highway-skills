---
description: "Task list for Feature 161 Objectives Synthesis Lifecycle"
---

# Tasks: Objectives Synthesis Lifecycle

**Input**: Design documents from `specs/161-objectives-synthesis-lifecycle/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Organization**: Tasks are grouped by user story. This feature changes an authored skill contract and its generated identity-copy adapters; there is no new runtime service or durable data schema.

## Dependency Order

- Phase 1 and Phase 2 are prerequisites for all story work.
- User Story 1 establishes the lifecycle and proposal-first contract.
- User Story 2 extends that contract with Success Measure proposal and discovery-exception behavior.
- User Story 3 adds queue and capture boundaries and depends on the lifecycle wording from User Story 1.
- User Story 4 adds one-review and exception-path regression coverage and depends on the complete lifecycle contract from User Stories 1-3.
- Phase 7 regenerates adapters and runs the complete validation suite after all source/test edits.

## Parallel Opportunities

- T004 and T005 can run in parallel because they edit separate new test and source sections only after the shared baseline is understood.
- T009 and T011 can run in parallel because they add independent source guidance sections.
- T014 can run in parallel with T015 because the focused contract test and adapter regeneration operate on separate artifacts after source edits are complete.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Confirm the existing authoring and validation surfaces before changing the skill contract.

- [x] T001 Confirm Feature 161 plan, spec, research, data model, and quickstart paths and record the source skill and adapter paths in the implementation notes at `specs/161-objectives-synthesis-lifecycle/plan.md`.
- [x] T002 Inspect existing Objective structural, advisory, management, and full-suite test entry points in `.highway/tools/tests/` and preserve their invocation paths in `specs/161-objectives-synthesis-lifecycle/quickstart.md`.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the focused static-document contract shape before story-specific guidance is added.

- [x] T003 Define the Feature 161 focused contract-test skeleton, source path, adapter comparison loop, and failure aggregation in `.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh`.
- [x] T004 [P] Add the required lifecycle, proposal-field, and protected-contract assertion inventory to `.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh` based on FR-001 through FR-022.

**Checkpoint**: The focused test harness exists and expresses the Feature 161 contract before the source guidance is complete.

## Phase 3: User Story 1 - Receive a complete grounded Objective proposal (Priority: P1) MVP

**Goal**: Make Objective development proposal-first and explicitly synthesize a complete first-pass Objective from accepted Profile evidence.

**Independent Test**: Run `.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh` and verify the source contains the lifecycle heading, complete proposal fields, user refinement paths, and no rediscovery-first wording.

- [x] T005 [US1] Add `### Objective Development Lifecycle` immediately after `### Recommendation Development` in `.highway/skills/highway-objectives/SKILL.md`, including the recommendation-to-proposal-to-review-to-capture-to-next-Objective sequence and complete first-pass proposal fields.
- [x] T006 [US1] State in `.highway/skills/highway-objectives/SKILL.md` that the person refines, corrects, approves, replaces, or rejects the grounded proposal and is not required to recreate Profile-supported information from scratch.
- [x] T007 [US1] Add the Feature 161 lifecycle and complete-proposal assertions for User Story 1 to `.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh`.

**Checkpoint**: A grounded Profile-supported Objective is presented as a complete proposal before unnecessary discovery.

## Phase 4: User Story 2 - Develop Success Measures from grounded evidence (Priority: P1)

**Goal**: Make proposed Success Measures part of the default Objective proposal while preserving focused discovery for unsupported measures.

**Independent Test**: Run the focused contract test and verify proposed measures are supplied with the Objective, remain user-refinable, and trigger discovery only when evidence cannot support reasonable measures.

- [x] T008 [US2] Add proposal-first discovery exception guidance to the lifecycle section in `.highway/skills/highway-objectives/SKILL.md`, covering missing Objective support, missing reasonable Success Measures, and consequential ambiguity.
- [x] T009 [P] [US2] Add default Success Measure proposal guidance to `.highway/skills/highway-objectives/SKILL.md`, including approve, modify, replace, and remove paths and the prohibition on a Success-question chain before the Objective is visible.
- [x] T010 [US2] Add focused assertions for proposal-first discovery, proposed Success Measures, and all four measure refinement paths to `.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh`.

**Checkpoint**: Supported measures are proposed with the Objective; unsupported measures use only the necessary discovery question.

## Phase 5: User Story 3 - Process selected recommendations as development work (Priority: P1)

**Goal**: Make recommendation selection enter a transient ordered queue and prevent selection-to-capture shortcuts.

**Independent Test**: Run the focused contract test and verify selection creates development order only, multiple recommendations are processed one at a time, and capture requires proposal plus review plus owner capture.

- [x] T011 [US3] Add explicit queue boundary guidance to `.highway/skills/highway-objectives/SKILL.md`, distinguishing selection, active queue membership, development order, and Objective capture.
- [x] T012 [US3] Add the mandatory Converged Objective proposal fields and direct selection-to-capture prohibition to `.highway/skills/highway-objectives/SKILL.md`.
- [x] T013 [US3] Add the illustrative multi-selection queue example and sequential processing assertions to `.highway/skills/highway-objectives/SKILL.md` and `.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh`.

**Checkpoint**: Multiple selected recommendations remain un-captured until each current item completes proposal, review, and owner capture.

## Phase 6: User Story 4 - Use discovery and review as bounded exceptions (Priority: P2)

**Goal**: Preserve discovery as an exception and enforce one Converged Objective proposal review before capture.

**Independent Test**: Run the focused contract test and verify the default path is proposal -> one review -> capture -> next Objective, with no second proposal/review cycle.

- [x] T014 [US4] Add one-review guidance and the prohibited second-proposal/second-review comparison to `.highway/skills/highway-objectives/SKILL.md`.
- [x] T015 [US4] Add regression assertions for the one-review path, discovery exception, accepted advisory boundary, and preservation of existing owner-controlled contracts to `.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh`.

**Checkpoint**: Sufficient evidence follows one review-to-capture path; insufficient evidence remains focused and grounded.

## Phase 7: Polish & Cross-Cutting Validation

**Purpose**: Distribute the source contract and prove compatibility across the repository.

- [x] T016 Regenerate all identity-copy adapters from `.highway/skills/highway-objectives/SKILL.md` using `.highway/tools/generate-agent-adapters.sh`.
- [x] T017 Run the focused Feature 161, Feature 160, Feature 159, Objective management, and full repository suites from `.highway/tools/tests/` and record successful commands in `specs/161-objectives-synthesis-lifecycle/quickstart.md`.
- [x] T018 Verify `.github/skills/highway-objectives/SKILL.md`, `.claude/skills/highway-objectives/SKILL.md`, `.cursor/skills/highway-objectives/SKILL.md`, and `.agents/skills/highway-objectives/SKILL.md` are byte-identical to the source and run `git diff --check`.

## Implementation Strategy

Deliver the MVP through User Story 1 first: establish a complete proposal-first lifecycle and verify it with the focused contract test. Add measure behavior, queue boundaries, and one-review exceptions incrementally, regenerating adapters only after source guidance stabilizes. Finish with the existing Objective regression suites and full repository suite.
