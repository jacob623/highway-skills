# Tasks: Objectives Deduplication Pass

**Input**: Design documents from `specs/163-objectives-deduplication-pass/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `quickstart.md`

**Tests**: Static contract tests are required by the measurable ownership and adapter criteria in the feature specification.

## Phase 1: Setup

**Purpose**: Confirm the source-first skill layout and establish the focused contract-test target.

- [X] T001 Verify the Feature 163 source, adapter, generator, and test paths in `.highway/skills/highway-objectives/SKILL.md`, `.github/skills/highway-objectives/SKILL.md`, `.claude/skills/highway-objectives/SKILL.md`, `.cursor/skills/highway-objectives/SKILL.md`, `.agents/skills/highway-objectives/SKILL.md`, and `.highway/tools/tests/`
- [X] T002 [P] Record the Feature 163 ownership contract cases in `.highway/tools/tests/feature-163-objectives-deduplication.test.sh`

## Phase 2: Foundational

**Purpose**: Establish the focused assertions before changing the source skill.

- [X] T003 Complete the focused ownership, duplicate-absence, canonical-reference, protected-contract, and source/adapter identity assertions in `.highway/tools/tests/feature-163-objectives-deduplication.test.sh`
- [X] T004 Run `bash .highway/tools/tests/feature-163-objectives-deduplication.test.sh` and record the expected pre-implementation failures in the task notes or command output

**Checkpoint**: Focused checks exist and distinguish the current duplicated guidance from the desired ownership contract.

## Phase 3: User Story 1 - Follow one authoritative Objective lifecycle (Priority: P1) 🎯 MVP

**Goal**: Keep lifecycle mechanics, proposal contents, proposal-first behavior, Success Measure proposals, User Acceptance, capture, and sequence authoritative in the lifecycle only.

**Independent Test**: The focused contract test finds the complete canonical lifecycle and proposal fields in the lifecycle, finds no competing lifecycle blocks elsewhere, and preserves Feature 162 tests.

- [X] T005 [US1] Remove duplicate lifecycle, proposal-response, normal-path, and anti-pattern instructions from `## Objective Queue and Acceptance Boundaries` in `.highway/skills/highway-objectives/SKILL.md`, retaining queue ownership and lifecycle capture-boundary references
- [X] T006 [US1] Remove Objective-specific proposal-first restatements from `## Interpretation Confidence` and `## Recommendation Development` in `.highway/skills/highway-objectives/SKILL.md`, retaining confidence, grounding, relevance, and user-authored-path guidance
- [X] T007 [US1] Reduce duplicate Success Measure proposal and acceptance guidance outside `### Objective Development Lifecycle` to canonical references in `.highway/skills/highway-objectives/SKILL.md`
- [X] T008 [US1] Run `bash .highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh` and `bash .highway/tools/tests/feature-159-objectives-advisory.test.sh` after lifecycle deduplication

**Checkpoint**: User Story 1 preserves the Feature 162 lifecycle and removes competing lifecycle ownership.

## Phase 4: User Story 2 - Keep queue guidance limited to queue ownership (Priority: P1)

**Goal**: Make queue guidance own selection, membership, order, and capture-boundary reference without redefining lifecycle mechanics.

**Independent Test**: Queue-scoped checks find selection, active queue membership, development order, non-capture selection, and lifecycle references, with no duplicate normal-path or anti-pattern sequence.

- [X] T009 [US2] Preserve the illustrative queue example while rewriting `## Objective Queue and Acceptance Boundaries` in `.highway/skills/highway-objectives/SKILL.md` to remove lifecycle examples and person-response instructions
- [X] T010 [US2] Add or refine queue-scoped assertions for selection, membership, order, non-capture, lifecycle capture-boundary reference, and duplicate lifecycle absence in `.highway/tools/tests/feature-163-objectives-deduplication.test.sh`

**Checkpoint**: Queue guidance has one owner and remains independently testable.

## Phase 5: User Story 3 - Keep evidence collection focused on evidence evaluation (Priority: P1)

**Goal**: Keep Creation Workflow responsible for evidence evaluation and question selection while handing off to the lifecycle by reference.

**Independent Test**: Creation Workflow retains Business Objective, Success, Highway Relevance, classification, and correction re-evaluation, with no duplicate proposal, acceptance, capture, or queue-processing sequence.

- [X] T011 [US3] Rewrite Creation Workflow lifecycle handoff and queued-processing text in `.highway/skills/highway-objectives/SKILL.md` to reference the Objective Development Lifecycle while retaining evidence evaluation responsibilities
- [X] T012 [US3] Add Creation Workflow ownership and duplicate-workflow absence assertions to `.highway/tools/tests/feature-163-objectives-deduplication.test.sh`

**Checkpoint**: Creation Workflow owns evidence evaluation only and does not create a parallel lifecycle.

## Phase 6: User Story 4 - Preserve focused owners for recommendations, interpretation, and examples (Priority: P2)

**Goal**: Keep recommendation grounding, interpretation confidence, and examples focused on their own concerns and presentation output.

**Independent Test**: Focused checks find grounding and confidence ownership, Objective visibility before Success Measure questions, useful recommendation output, and no alternative lifecycle mechanics in examples.

- [X] T013 [US4] Simplify the illustrative Objective Development Example and Recommendation Presentation examples in `.highway/skills/highway-objectives/SKILL.md` so they demonstrate output without defining workflow mechanics
- [X] T014 [US4] Add recommendation, interpretation, example, Success Measure, and acceptance cross-reference assertions to `.highway/tools/tests/feature-163-objectives-deduplication.test.sh`

**Checkpoint**: Recommendation, interpretation, and example sections have focused ownership.

## Phase 7: Polish and Cross-Cutting Validation

**Purpose**: Regenerate distribution artifacts and validate the complete repository.

- [X] T015 Regenerate all agent adapters from `.highway/skills/highway-objectives/SKILL.md` using `.highway/tools/generate-agent-adapters.sh`
- [X] T016 Run `bash .highway/tools/tests/feature-163-objectives-deduplication.test.sh` and verify all ownership and adapter checks pass
- [X] T017 Run `bash .highway/tools/tests/run-all.sh` and verify the full repository suite passes
- [X] T018 Run `git diff --check` and verify no generated adapter differs from the source
- [X] T019 Mark all completed tasks `[X]` in `specs/163-objectives-deduplication-pass/tasks.md` after validation

## Dependencies & Execution Order

### Phase Dependencies

- Setup must complete before Foundational.
- Foundational must complete before user-story edits.
- User Story 1 establishes the lifecycle ownership boundary before queue and Creation Workflow cleanup.
- User Stories 2 and 3 depend on User Story 1's canonical references.
- User Story 4 depends on the lifecycle and cross-reference cleanup from User Stories 1-3.
- Polish depends on all story edits.

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational; MVP and prerequisite for the remaining stories.
- **User Story 2 (P1)**: Depends on User Story 1's canonical lifecycle references.
- **User Story 3 (P1)**: Depends on User Story 1's canonical lifecycle handoff.
- **User Story 4 (P2)**: Depends on User Story 1 and may follow User Stories 2 and 3 sequentially because all edits target the same source file.

### Parallel Opportunities

- T001 and T002 can run in parallel.
- T010 and T012 can be prepared in parallel only after the source sections they assert are agreed; T014 follows the final example wording.
- T016 and T017 can run in parallel after adapter generation; T018 follows either validation result.

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational phases.
2. Complete User Story 1 and validate the canonical lifecycle.
3. Continue through queue, Creation Workflow, and focused-owner cleanup.

### Incremental Delivery

Each user story is independently validated by the focused static contract test, while the final adapter regeneration and full suite protect all existing Objective behavior.
