# Tasks: Repository Context Guidance

**Input**: Design documents from `specs/088-repository-context-guidance/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `quickstart.md`

**Tests**: Validation tasks are included because the specification requires constitutional review,
focused governance checks, and full-suite verification.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Confirm the existing governance targets and validation surfaces before editing.

- [X] T001 Confirm Feature 088 design artifacts and target paths in `specs/088-repository-context-guidance/plan.md`
- [X] T002 [P] Confirm the three authoritative context files exist under `.highway/library/knowledge/`
- [X] T003 [P] Record the current constitution rule inventory and Experience Standard X2.1-X2.6 baseline in `.highway/governance/constitution.md` and `.highway/governance/experience-standard.md`

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the amendment boundaries and preservation checks before user-story edits.

- [X] T004 Preserve the existing authority precedence, workflow-specific ownership, user-owned content boundaries, and amendment metadata baseline in `.highway/governance/constitution.md`
- [X] T005 Preserve the existing X2.1-X2.6 identifiers, text, Observables, tiers, and applicability baseline in `.highway/governance/experience-standard.md`
- [X] T006 [P] Define the Feature 088 static review checklist for rule keywords, Observables, tiers, rule counts, and normative-section lengths in `specs/088-repository-context-guidance/quickstart.md`

## Phase 3: User Story 1 - Establish Authoritative Repository Context (Priority: P1) 🎯 MVP

**Goal**: Define the three authoritative Repository Context Documents, their authority boundary,
location, precedence, absence behavior, and distinction from workflow-specific and user-owned content.

**Independent Test**: Review `.highway/governance/constitution.md` and confirm the three paths,
authority boundary, deterministic precedence, future-amendment path, and no-context protection are
explicit and structurally valid.

### Tests for User Story 1

- [X] T007 [US1] Add the three named context paths, Repository Context Documents definition, authority boundary, and future-extension rule to `.highway/governance/constitution.md`
- [X] T008 [US1] Add deterministic Identity -> Vision -> Platform Objectives precedence and absent-document protection to `.highway/governance/constitution.md`
- [X] T009 [US1] Review the amended constitution against FR-001 through FR-003, FR-017, FR-018, FR-021, and FR-022 using `.highway/tools/tests/constitution-inventory.test.sh`

**Checkpoint**: The constitution independently establishes authoritative repository context without changing existing ownership boundaries.

## Phase 4: User Story 2 - Declare Context as a Skill Input (Priority: P1)

**Goal**: Define when participating skills declare context, consume only relevant documents, preserve
workflow-specific authority, and support verification without forcing unrelated skills to declare context.

**Independent Test**: Review the constitutional Inputs and verification rules and confirm declaration,
selective relevance, workflow-specific authority, and non-relevant-skill exceptions are all explicit.

### Tests for User Story 2

- [X] T010 [US2] Add Behavior, Participating Skill, Relevant Repository Context, and Material Influence definitions to `.highway/governance/constitution.md`
- [X] T011 [US2] Add context declaration, relevant-only consumption, pre-generation use, workflow-specific authority, and verification requirements to `.highway/governance/constitution.md`
- [X] T012 [US2] Update constitution amendment metadata, rule counts, self-application records, and non-restatement records for Feature 088 in `.highway/governance/constitution.md`
- [X] T013 [US2] Review the amended constitution against FR-004 through FR-007 and FR-019 using `.highway/tools/tests/constitution-inventory.test.sh`

**Checkpoint**: The constitutional contract independently makes context-aware skill inputs inspectable while leaving unrelated skills out of scope.

## Phase 5: User Story 3 - Make Interactive Guidance Context-Aware (Priority: P1)

**Goal**: Add Repository Context and Contextual Guidance to the Experience Standard, including X2.7
and X2.8, concise material acknowledgments, context-aware examples, and no-promotional boundaries.

**Independent Test**: Review `.highway/governance/experience-standard.md` and confirm relevant context
grounds recommendations, material influence triggers concise acknowledgments, irrelevant or absent
context adds no noise, and X2.1-X2.6 remain unchanged.

### Tests for User Story 3

- [X] T014 [US3] Add Repository Context and Contextual Guidance definitions and section placement beneath X2 Interaction in `.highway/governance/experience-standard.md`
- [X] T015 [US3] Add X2.7 for context-grounded recommendations and X2.8 for material contextual acknowledgments in `.highway/governance/experience-standard.md`
- [X] T016 [US3] Add Context Awareness guidance, generic-versus-context-aware contrast, reduced-effort guidance, and non-promotional acknowledgment boundaries to `.highway/governance/experience-standard.md`
- [X] T017 [US3] Update Experience Standard amendment metadata, rule counts, self-application records, and non-restatement records for Feature 088 in `.highway/governance/experience-standard.md`
- [X] T018 [US3] Run `.highway/tools/tests/highway-ux-alignment.test.sh` and verify X2.1-X2.6 preservation plus X2.7/X2.8 structure

**Checkpoint**: Interactive guidance is context-aware and concise without rewriting the established X2 interaction contract.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Validate the complete feature and keep static and executable evidence distinct.

- [X] T019 [P] Run `git diff --check` and inspect only the two governance-document diffs for unintended changes
- [X] T020 [P] Run the static review in `specs/088-repository-context-guidance/quickstart.md`, including precedence, relevance, absence, and no-promotion checks
- [X] T021 Run `.highway/tools/tests/run-all.sh` and record the complete repository validation result
- [X] T022 Confirm the final implementation changes only the two governance documents and the focused `.highway/tools/tests/highway-ux-alignment.test.sh` validator outside Feature 088 planning artifacts

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; confirms the feature inputs and baselines.
- **Foundational (Phase 2)**: Depends on Setup; blocks all governance amendments.
- **User Story 1 (Phase 3)**: Depends on Foundational; establishes the shared context authority.
- **User Story 2 (Phase 4)**: Depends on User Story 1; uses its definitions and authority model.
- **User Story 3 (Phase 5)**: Depends on User Story 1 and User Story 2; applies the context model to interaction guidance.
- **Polish (Phase 6)**: Depends on all three user stories.

### User Story Dependencies

- **User Story 1 (P1)**: First implementation story; no dependency on another story beyond Foundational.
- **User Story 2 (P1)**: Depends on User Story 1 definitions and precedence.
- **User Story 3 (P1)**: Depends on User Story 1 authority and User Story 2 participation/relevance definitions.

### Parallel Opportunities

- T002, T003, and T006 can run in parallel during setup/foundation.
- Within User Story 1, path/authority content and precedence/absence content can be drafted separately, then reviewed together.
- Within User Story 3, guidance definitions and the illustrative contrast can be drafted alongside rule metadata, provided the final document review is serialized.
- T019 and T020 can run in parallel after implementation; T021 follows them.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Implement User Story 1 in the constitution.
3. Run its focused constitution check and review the checkpoint.
4. Continue to User Stories 2 and 3 for the complete feature.

### Incremental Delivery

1. Establish authoritative context and deterministic precedence.
2. Add inspectable declaration and selective consumption rules.
3. Add context-aware interactive guidance and acknowledgments.
4. Run focused checks, static review, and the full suite.

## Notes

- `[P]` marks tasks that can operate on different files or independent evidence.
- Every story task names an exact repository path.
- No `contracts/` directory is created because Feature 088 adds no external interface.
- Existing skills are intentionally not modified; their follow-up migration is out of scope.
