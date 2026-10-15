---

description: "Task list for Discovery option review and implementation exploration"
---

# Tasks: Discovery Option Review and Implementation Exploration

**Input**: Design documents from `specs/180-discovery-option-review/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/discovery-option-review.md`, `quickstart.md`

**Tests**: Required by the specification for read-only mutation, advisory ownership, deterministic scoring, unsupported references, and generated correspondence.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Confirm the canonical source and generated-artifact surfaces before implementation.

- [x] T001 Inspect the Feature 180 plan, spec, research, data model, contract, quickstart, constitution, and completed quality checklist in `specs/180-discovery-option-review/`
- [x] T002 [P] Inspect the canonical Discovery skill, Discovery record/catalog templates, focused Discovery tests, output-template tests, and generated Discovery adapters in `.highway/skills/highway-discovery/SKILL.md`, `.highway/library/templates/output/`, `.highway/tools/tests/`, `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, and `.agents/skills/`
- [x] T003 [P] Confirm no extension hooks are registered in `.specify/extensions.yml` and resolve the active Feature 180 directory through `.specify/feature.json`

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the contract-test fixtures and preserve the existing Discovery/ADR boundaries before story implementation.

- [x] T004 Add reusable read-only fixture snapshots and option-resolution helpers to `.highway/tools/tests/highway-discovery.test.sh`
- [x] T005 Add failing assertions for supported `Describe`, `Review`, `Compare`, implementation-example, and cost interaction forms in `.highway/tools/tests/highway-discovery.test.sh`
- [x] T006 Add failing assertions for nine-section review structure, advisory labeling, accepted-alignment evidence, and unavailable-evidence handling in `.highway/tools/tests/highway-discovery.test.sh`
- [x] T007 Add failing assertions for no Discovery/catalog/identifier/ADR mutation and byte preservation across all exploration interactions in `.highway/tools/tests/highway-discovery.test.sh`
- [x] T008 Add failing assertions that implementation examples and costs do not change candidate scores, recommendation ranking, recommendation tie-breaking, or ADR selection in `.highway/tools/tests/highway-discovery.test.sh`
- [x] T009 Run `bash .highway/tools/tests/highway-discovery.test.sh` and `bash .highway/tools/tests/output-template.test.sh` before canonical-source changes, recording expected Feature 180 failures

**Checkpoint**: Foundational tests define the read-only advisory contract before implementation edits.

## Phase 3: User Story 1 - Review a Candidate Option (Priority: P1) MVP

**Goal**: Let a person review one generated option with complete, evidence-grounded, advisory context.

**Independent Test**: A valid `Describe OPT000001` or `Review OPT000001` produces all nine review sections, labels the review advisory, and leaves every source and identifier byte unchanged.

### Tests for User Story 1

- [x] T010 [P] [US1] Add valid single-option review fixture assertions for `Describe OPT000001` and `Review OPT000001` in `.highway/tools/tests/highway-discovery.test.sh`
- [x] T011 [P] [US1] Add missing Objective/Control/NFR relationship and unavailable-evidence assertions in `.highway/tools/tests/highway-discovery.test.sh`
- [x] T012 [P] [US1] Add malformed, unknown, duplicate, and cross-Discovery option rejection assertions in `.highway/tools/tests/highway-discovery.test.sh`

### Implementation for User Story 1

- [x] T013 [US1] Add Discovery option-review intent resolution, required nine-section response structure, evidence grounding, and advisory wording to `.highway/skills/highway-discovery/SKILL.md`
- [x] T014 [US1] Define invalid and unavailable single-option review handling with no-write behavior in `.highway/skills/highway-discovery/SKILL.md`
- [x] T015 [US1] Preserve the existing Discovery-to-ADR handoff and state that review never selects an option or creates an ADR in `.highway/skills/highway-discovery/SKILL.md`

**Checkpoint**: User Story 1 independently provides useful, read-only option review.

## Phase 4: User Story 2 - Compare Options and Explore Realizations (Priority: P1)

**Goal**: Let a person compare options and inspect advisory implementation examples and costs without changing Discovery analysis.

**Independent Test**: Valid two-option comparison, implementation-example, realization-matrix, and cost requests return qualified advisory evidence while score and recommendation outputs remain unchanged.

### Tests for User Story 2

- [x] T016 [P] [US2] Add two-distinct-option same-Discovery comparison assertions and duplicate/cross-Discovery rejection assertions in `.highway/tools/tests/highway-discovery.test.sh`
- [x] T017 [P] [US2] Add implementation-example and realization-matrix structure assertions in `.highway/tools/tests/highway-discovery.test.sh`
- [x] T018 [P] [US2] Add Low/Medium/High, bounded-range, and Unknown cost assertions plus advisory-label checks in `.highway/tools/tests/highway-discovery.test.sh`

### Implementation for User Story 2

- [x] T019 [US2] Add two-option comparison and implementation-example/cost exploration behavior to `.highway/skills/highway-discovery/SKILL.md`
- [x] T020 [US2] Add optional Example Reference Implementations, Example Realization Matrix, and Example Cost Considerations sections to `.highway/library/templates/output/discovery-record.md`
- [x] T021 [US2] State that examples and costs are informational, qualified, read-only, and excluded from scoring/ranking/tie-breaking in `.highway/skills/highway-discovery/SKILL.md`
- [x] T022 [US2] Preserve existing Discovery option, comparison, recommendation, and score fields while adding optional evidence sections in `.highway/library/templates/output/discovery-record.md`

**Checkpoint**: User Stories 1 and 2 independently support review and realization exploration without mutation or score drift.

## Phase 5: User Story 3 - Understand Recommendation and Continue to ADR (Priority: P1)

**Goal**: Make Discovery completion explicitly invite option exploration and identify ADR as the later decision boundary.

**Independent Test**: Completed Discovery output presents recommendation/rationale, review prompts, advisory status, and ADR next-step guidance without creating a decision.

### Tests for User Story 3

- [x] T023 [P] [US3] Add completion-guidance assertions for option review, comparison, implementation examples, and implementation costs in `.highway/tools/tests/highway-discovery.test.sh`
- [x] T024 [P] [US3] Add assertions for recommendation explainability through examples without recommendation-score changes in `.highway/tools/tests/highway-discovery.test.sh`

### Implementation for User Story 3

- [x] T025 [US3] Add completion guidance and supported review examples after the Recommendation Rationale in `.highway/skills/highway-discovery/SKILL.md`
- [x] T026 [US3] Add explicit Discovery-evaluates and ADR-selects ownership wording to `.highway/skills/highway-discovery/SKILL.md`
- [x] T027 [US3] Add optional evidence-section ordering and advisory wording to `.highway/library/templates/output/discovery-record.md`

**Checkpoint**: Completed Discovery clearly guides exploration and handoff without implying acceptance or selection.

## Phase 6: User Story 4 - Preserve Discovery and ADR Ownership Boundaries (Priority: P1)

**Goal**: Prove all exploration remains read-only, deterministic, and separate from ADR commitment.

**Independent Test**: Run every supported exploration fixture and compare all relevant pre-operation bytes, score outputs, recommendation outputs, and ADR/catalog state.

### Tests for User Story 4

- [x] T028 [P] [US4] Add complete byte-snapshot comparisons for Discovery, catalogs, identifiers, governance inputs, ADR records, and ADR catalogs in `.highway/tools/tests/highway-discovery.test.sh`
- [x] T029 [P] [US4] Add score/recommendation invariance fixtures with evidence present, absent, and changed in `.highway/tools/tests/highway-discovery.test.sh`
- [x] T030 [P] [US4] Add generated-adapter correspondence and no-ADR-creation assertions in `.highway/tools/tests/highway-discovery.test.sh`

### Implementation for User Story 4

- [x] T031 [US4] Consolidate no-write, no-allocation, deterministic, advisory, and ADR ownership rules in `.highway/skills/highway-discovery/SKILL.md`
- [x] T032 [US4] Add shared-template citations and optional-section contract wording without duplicating structural ownership in `.highway/skills/highway-discovery/SKILL.md`

**Checkpoint**: All four user stories preserve the established Discovery and ADR ownership contracts.

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Validate, regenerate, and verify the complete repository contract.

- [x] T033 Update `.highway/tools/tests/output-template.test.sh` for optional Discovery evidence sections and complete shared-template validation
- [x] T034 Validate `.highway/skills/highway-discovery` and `.highway/library/templates/output/discovery-record.md` with canonical validators
- [x] T035 Regenerate `.highway/catalog/`, `.highway/catalog/library-index.*`, `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, and `.agents/skills/` from canonical sources
- [x] T036 Run focused Discovery/output-template tests, generated correspondence checks, and all Feature 180 quickstart scenarios
- [x] T037 Run `.highway/tools/tests/run-all.sh` and resolve only Feature 180 regressions
- [x] T038 Verify `git diff --check`, no unresolved design placeholders, generated Discovery adapters match source, and upstream ADR/Request bytes remain untouched
- [x] T039 Confirm all tasks are marked complete and the implementation matches `spec.md`, `plan.md`, and `contracts/discovery-option-review.md`

## Dependencies and Execution Order

- Setup T001-T003 precedes foundational work.
- Foundational T004-T009 must pass before user-story source edits.
- US1 T010-T015 establishes the single-option review surface.
- US2 T016-T022 depends on the review vocabulary and extends it with comparison/evidence sections.
- US3 T023-T027 depends on the evidence interaction wording and adds completion guidance.
- US4 T028-T032 verifies cross-cutting ownership and determinism after the story behaviors exist.
- Polish T033-T039 follows all story checkpoints and regeneration prerequisites.

## Parallel Opportunities

- T002 and T003 can run in parallel.
- T004-T008 can be developed as independent test sections before implementation.
- T010-T012, T016-T018, T023-T024, and T028-T030 can run in parallel within their story phases because they target independent test sections.
- T033 and T034 can run in parallel after source edits.
- T036 and T037 can run sequentially after regeneration; T038 follows both.

## Implementation Strategy

1. Establish failing contract tests for review, evidence, no-write, and ownership invariants.
2. Deliver the MVP single-option review path.
3. Add comparison, implementation examples, realization matrix, and qualified cost evidence.
4. Add completion guidance and verify Discovery-to-ADR ownership.
5. Regenerate derived artifacts, run focused validation, then run the full suite.
