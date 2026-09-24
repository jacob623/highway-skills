---

description: "Task list for Highway Setup UX Verification and Output Contract Clarification"
---

# Tasks: Highway Setup UX Verification and Output Contract Clarification

**Input**: Design documents from `specs/086-highway-setup-ux-verification/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/setup-verification-output.md, quickstart.md

**Project type**: Markdown skill and Bash validation suite; no application framework or persistence layer

## Phase 1: Setup

**Purpose**: Confirm the existing Feature 085 baseline and prepare the focused implementation surfaces.

- [X] T001 Review `specs/086-highway-setup-ux-verification/plan.md`, `specs/086-highway-setup-ux-verification/spec.md`, and `specs/086-highway-setup-ux-verification/contracts/setup-verification-output.md` to map requirements to the existing `highway-setup` skill and tests
- [X] T002 Run `.highway/tools/tests/run-all.sh` from the repository root and record the pre-change baseline for Feature 086 validation

## Phase 2: Foundational

**Purpose**: Establish the shared contract vocabulary and evidence boundaries before story-specific changes.

- [X] T003 [P] Update `specs/086-highway-setup-ux-verification/data-model.md` and `specs/086-highway-setup-ux-verification/contracts/setup-verification-output.md` if implementation findings require clarification of collection, status, completion, or prohibited-vocabulary invariants
- [X] T004 [P] Add a static-test fixture or assertion plan in `.highway/tools/tests/highway-setup.test.sh` for the closed prohibited vocabulary and the separation of static contract evidence from runtime behavior evidence

**Checkpoint**: Shared verification vocabulary and evidence boundaries are agreed before user-story work.

## Phase 3: User Story 1 - Verify the Guided Onboarding Opening (Priority: P1) 🎯 MVP

**Goal**: Verify welcome/resume greeting, active-owner introduction, owner context, and unresolved-question ordering without reordering owner content.

**Independent Test**: Run the focused static and executable setup tests and confirm new and resumed input-required fixtures show the required opening order and preserve owner-provided informational context before its question.

### Implementation for User Story 1

- [X] T005 [US1] Update `.highway/skills/highway-setup/SKILL.md` Purpose and collection-output wording to describe guided onboarding, the active owner's next unresolved question, and preserved owner-provided informational context without changing routing or question authority
- [X] T006 [US1] Extend `.highway/tools/tests/highway-setup.test.sh` to verify welcome/resume opening language, active-owner ordering, owner-content ordering, and the observable prohibition on orchestration-first or progress-first routine collection
- [X] T007 [US1] Extend `.highway/tools/tests/highway-setup-executable.test.sh` with deterministic new and resumed input-required fixtures that assert greeting, owner introduction, informational context, and question order

**Checkpoint**: User Story 1 is independently verifiable through the focused setup tests.

## Phase 4: User Story 2 - Distinguish Collection, Status, and Completion Output (Priority: P1)

**Goal**: Verify that routine collection, explicit status/non-success outcomes, and successful completion select only their applicable output contracts.

**Independent Test**: Run the executable setup test and confirm routine collection excludes the Explicit Status Contract, blocked/declined/aborted/explicit-status cases use it, and successful completion uses only the Completion Dashboard with no collection question.

### Implementation for User Story 2

- [X] T008 [US2] Update `.highway/skills/highway-setup/SKILL.md` output-contract wording to make owner questions, summaries, outputs, blocking reasons, and next actions owner-owned and to state exact Explicit Status Contract applicability and completion exclusivity
- [X] T009 [US2] Extend `.highway/tools/tests/highway-setup.test.sh` to verify FR-010 through FR-017 wording, including owner-owned questions and completion-versus-status distinctions
- [X] T010 [US2] Extend `.highway/tools/tests/highway-setup-executable.test.sh` with explicit-status, blocked, declined, aborted, and successful-completion fixtures that assert output-mode selection and absence of collection questions in completion

**Checkpoint**: User Story 2 is independently verifiable across all collection, status, and completion outcomes.

## Phase 5: User Story 3 - Verify Suppression of Workflow-Engine Narration (Priority: P1)

**Goal**: Prevent legacy workflow-engine narration during routine collection while permitting owner-selection reasoning only for explicit implementation-detail requests.

**Independent Test**: Run both focused setup tests and confirm all five prohibited phrases plus readiness, stage-selection, owner-selection, and orchestration explanations are rejected during routine collection, while the explicit implementation-detail exception remains allowed.

### Implementation for User Story 3

- [X] T011 [US3] Update `.highway/skills/highway-setup/SKILL.md` collection and suppression wording to use the closed Verification Prohibited Vocabulary and preserve the explicit implementation-detail exception
- [X] T012 [US3] Extend `.highway/tools/tests/highway-setup.test.sh` to assert every prohibited phrase and explanation category is excluded from routine collection and that the explicit-request exception is documented
- [X] T013 [US3] Extend `.highway/tools/tests/highway-setup-executable.test.sh` with routine-collection and explicit-implementation-detail fixtures that verify suppression and the narrow exception without changing owner routing

**Checkpoint**: User Story 3 is independently verifiable and does not regress User Stories 1 or 2.

## Phase 6: Polish and Cross-Cutting Validation

**Purpose**: Synchronize shipped artifacts, run focused and full validation, and confirm requirement coverage.

- [X] T014 Regenerate `.github/skills/highway-setup/SKILL.md`, `.claude/skills/highway-setup/SKILL.md`, `.cursor/rules/highway-setup.mdc`, `.highway/catalog/index.json`, `.highway/catalog/index.md`, and `.highway/tools/.adapter-manifest` from `.highway/skills/highway-setup/SKILL.md` when the source skill changes
- [X] T015 Run `.highway/tools/tests/highway-setup.test.sh` and `bash .highway/tools/tests/highway-setup-executable.test.sh`, then record static-contract and executed-behavior results separately in the implementation report
- [X] T016 Run `.highway/tools/tests/run-all.sh`, validate `specs/086-highway-setup-ux-verification/quickstart.md`, and confirm all Feature 086 requirements and success criteria are covered without changing owner authority, readiness order, terminality, safe-stop behavior, or completion destinations

## Dependencies and Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes the baseline.
- **Foundational (Phase 2)**: Depends on Setup; defines shared vocabulary and evidence boundaries.
- **User Story 1 (Phase 3)**: Depends on Foundational; delivers the MVP opening flow.
- **User Story 2 (Phase 4)**: Depends on Foundational; can proceed after shared boundaries, with skill/test file changes sequenced against User Story 1 when they touch the same files.
- **User Story 3 (Phase 5)**: Depends on Foundational; can proceed after shared boundaries, with skill/test file changes sequenced against earlier stories when they touch the same files.
- **Polish (Phase 6)**: Depends on all desired user stories and includes generated-artifact synchronization and full validation.

### User Story Dependencies

- **User Story 1 (P1)**: No dependency on another story after Foundational; recommended MVP.
- **User Story 2 (P1)**: No semantic dependency on User Story 1, but shared skill/test files require sequential edits if both are implemented in one workspace.
- **User Story 3 (P1)**: No semantic dependency on User Story 1 or 2, but shared skill/test files require sequential edits if both are implemented in one workspace.

### Parallel Opportunities

- T003 and T004 can run in parallel after T002 because they touch different design/test concerns.
- Within a story, static test edits and executable fixture edits can be prepared in parallel only when they do not overlap in the same file; in this repository they should be applied sequentially because both story phases touch the same focused test files.
- T014 is independent of contract drafting until a source skill change exists, but must occur after all source skill edits.
- T015 can run after focused test edits and T014; T016 follows T015.

## Parallel Example: User Story 1

```text
Task: "Update .highway/skills/highway-setup/SKILL.md collection wording for the ordered guided-onboarding opening"
Task: "Extend .highway/tools/tests/highway-setup.test.sh for opening and owner-content ordering"
Task: "Extend .highway/tools/tests/highway-setup-executable.test.sh with new and resumed opening fixtures"
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Implement User Story 1 and run its focused tests.
3. Stop and validate the guided opening independently.

### Incremental Delivery

1. Add User Story 1 for the onboarding opening.
2. Add User Story 2 for collection/status/completion output selection.
3. Add User Story 3 for narration suppression and explicit-detail exception.
4. Regenerate shipped artifacts and run the focused and full suites.
5. Report static contract evidence separately from executed behavior evidence.

## Notes

- Every task uses the required checkbox, sequential ID, optional parallel marker, story label where applicable, and an exact file path.
- No new runtime dependency, persistence store, or orchestration authority is planned.
- Existing owner workflows remain authoritative for questions, informational context, routing, readiness, outcomes, and artifact ownership.
