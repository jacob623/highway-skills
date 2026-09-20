# Tasks: Highway New Constraint Hardening

**Input**: Design documents from `specs/054-highway-new-constraint-hardening/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, and `quickstart.md`

**Tests**: Required by FR-013. Add focused assertions before implementing each behavior and observe the new cases fail.

**Organization**: Tasks are grouped by user story so each story can be implemented and validated independently.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Confirm the existing Request surfaces and establish the validation baseline.

- [X] T001 Review `specs/054-highway-new-constraint-hardening/spec.md`, `plan.md`, `research.md`, `data-model.md`, both contract files, and `quickstart.md` to confirm scope and ownership boundaries.
- [X] T002 [P] Inspect `.highway/skills/highway-new/SKILL.md`, `.highway/library/templates/output/request-record.md`, `.highway/tools/tests/highway-new.test.sh`, and `.highway/tools/tests/output-template.test.sh` to locate current Solution Constraints and Business Constraints wording.
- [X] T003 [P] Run `.highway/tools/validate-skill.sh .highway/skills/highway-new`, `.highway/tools/validate-library.sh .highway/library/templates/output/request-record.md`, `.highway/tools/tests/highway-new.test.sh`, and `.highway/tools/tests/output-template.test.sh` to record the pre-change baseline.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the shared validation vocabulary before story-specific behavior changes.

- [X] T004 Confirm the eight-field Solution Constraints order, list-versus-unknown states, existing empty-state representation, retry limit, and no-partial-write rules against `.highway/skills/highway-new/SKILL.md`, `specs/053-request-solution-constraints/data-model.md`, and `specs/054-highway-new-constraint-hardening/data-model.md`.
- [X] T005 [P] Add a focused test helper or assertion vocabulary for field-specific Solution Constraints errors in `.highway/tools/tests/highway-new.test.sh`, preserving existing Bash 3.2-compatible conventions.
- [X] T006 [P] Add shared wording and record-boundary assertions to `.highway/tools/tests/output-template.test.sh` for canonical `None known` intake wording and preservation of the existing persisted empty-state representation.

**Checkpoint**: Existing Request behavior is baselined and the focused tests have explicit vocabulary for the three Feature 054 changes.

## Phase 3: User Story 1 - Validate Allowed Solution Classes (Priority: P1) 🎯 MVP

**Goal**: Accept one or more allowed solution classes or `unknown`, and reject empty or malformed values with actionable recovery guidance.

**Independent Test**: Run `.highway/tools/tests/highway-new.test.sh` with single-value, multi-value, `unknown`, empty, blank, malformed-scalar, and empty-entry cases; valid values pass, invalid values name `allowed_solution_classes` and request one or more values or `unknown`.

### Tests for User Story 1

- [X] T007 [P] [US1] Add failing assertions for single-value, multi-value, and `unknown` `allowed_solution_classes` cases in `.highway/tools/tests/highway-new.test.sh`.
- [X] T008 [P] [US1] Add failing assertions for empty-list, blank, malformed-scalar, whitespace-only, and empty-entry `allowed_solution_classes` cases and exact recovery guidance in `.highway/tools/tests/highway-new.test.sh`.

### Implementation for User Story 1

- [X] T009 [US1] Update the Solution Constraints intake rules in `.highway/skills/highway-new/SKILL.md` so `allowed_solution_classes` requires one or more non-empty values or `unknown` and preserves multiple values without ranking.
- [X] T010 [US1] Add the `allowed_solution_classes` rejection and replacement behavior to the Solution Constraints error-handling section of `.highway/skills/highway-new/SKILL.md` without changing the durable record shape.
- [X] T011 [US1] Run `.highway/tools/tests/highway-new.test.sh` and `.highway/tools/validate-skill.sh .highway/skills/highway-new` to verify User Story 1 independently.

**Checkpoint**: User Story 1 accepts only the required cardinality and produces field-specific recovery guidance without changing Discovery or ADR behavior.

## Phase 4: User Story 2 - Standardize Business Constraints Absence Wording (Priority: P1)

**Goal**: Use `None known` consistently for explicit Business Constraints absence while preserving the existing persisted empty-state representation and distinction from `unknown`.

**Independent Test**: Run the focused wording and Request tests, then inspect the authoritative skill and output contract to confirm prompts/examples use `None known`, `unknown` remains distinct, and no new record literal is introduced.

### Tests for User Story 2

- [X] T012 [P] [US2] Add failing assertions for canonical `None known`, distinct `unknown`, and incomplete Business Constraints states in `.highway/tools/tests/highway-new.test.sh`.
- [X] T013 [P] [US2] Add failing shared-template assertions for `None known` wording and existing empty-state persistence boundaries in `.highway/tools/tests/output-template.test.sh`.

### Implementation for User Story 2

- [X] T014 [US2] Replace legacy or ambiguous Business Constraints absence wording with `None known` in `.highway/skills/highway-new/SKILL.md`, keeping `unknown` and incomplete input distinct.
- [X] T015 [US2] Update the Business Constraints examples and error-handling guidance in `.highway/skills/highway-new/SKILL.md` so `None known` is presentation-only and the existing persisted empty-state representation remains unchanged.
- [X] T016 [US2] Run `.highway/tools/tests/highway-new.test.sh`, `.highway/tools/tests/output-template.test.sh`, and `.highway/tools/validate-skill.sh .highway/skills/highway-new` to verify User Story 2 independently.

**Checkpoint**: User Story 2 standardizes the requester-facing wording without altering durable compatibility or downstream ownership.

## Phase 5: User Story 3 - Recover from Solution Constraints Errors (Priority: P1)

**Goal**: Provide field-specific validation and recovery for all Solution Constraints fields while preserving retry, privacy, and no-partial-write behavior.

**Independent Test**: Submit malformed list and scalar values, privacy-blocked replacements, exhausted retries, and valid replacements through the focused Request scenarios; errors identify the field and accepted shape, valid replacements continue, and invalid flows write nothing.

### Tests for User Story 3

- [X] T017 [P] [US3] Add failing assertions for malformed list-shaped and scalar Solution Constraints values, including field names and accepted value shapes, in `.highway/tools/tests/highway-new.test.sh`.
- [X] T018 [P] [US3] Add failing assertions for valid replacement continuation, bounded retry exhaustion, privacy-blocked replacement input, and Request/catalog byte preservation in `.highway/tools/tests/highway-new.test.sh`.

### Implementation for User Story 3

- [X] T019 [US3] Add field-specific Solution Constraints validation errors to `.highway/skills/highway-new/SKILL.md` for list-shaped fields, `allowed_solution_classes`, and scalar restrictions.
- [X] T020 [US3] Add replacement, retry, privacy, and no-partial-write rules to `.highway/skills/highway-new/SKILL.md` while preserving the existing evidence order and transaction behavior.
- [X] T021 [US3] Align `specs/054-highway-new-constraint-hardening/data-model.md`, `specs/054-highway-new-constraint-hardening/contracts/constraint-hardening-intake-contract.md`, and `specs/054-highway-new-constraint-hardening/contracts/constraint-hardening-record-contract.md` with the implemented error and recovery vocabulary.
- [X] T022 [US3] Run `.highway/tools/tests/highway-new.test.sh`, `.highway/tools/validate-skill.sh .highway/skills/highway-new`, and `.highway/tools/validate-library.sh .highway/library/templates/output/request-record.md` to verify User Story 3 independently.

**Checkpoint**: All three P1 stories are behaviorally covered, and invalid Solution Constraints input cannot create partial or privacy-violating output.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate derived artifacts, verify distribution correspondence, and execute the documented validation guide.

- [X] T023 [P] Regenerate `.highway/catalog/index.json` and `.highway/catalog/index.md` with `.highway/tools/generate-catalog.sh` after `.highway/skills/highway-new/SKILL.md` is valid.
- [X] T024 [P] Regenerate `.github/skills/highway-new/SKILL.md`, `.claude/skills/highway-new/SKILL.md`, and `.cursor/rules/highway-new.mdc` with `.highway/tools/generate-agent-adapters.sh` after authoritative source changes.
- [X] T025 [P] Run `.highway/tools/tests/adapter-coverage.test.sh`, `.highway/tools/tests/shipped-tree-independence.test.sh`, and `.highway/tools/tests/distribution-packaging.test.sh` to verify generated correspondence and shipped-tree independence.
- [X] T026 Run `.highway/tools/tests/run-all.sh` and record the complete result, including any timeout or baseline failure, without claiming success from a partial run.
- [X] T027 Review the final diff against `specs/054-highway-new-constraint-hardening/spec.md`, `data-model.md`, both contracts, and `quickstart.md`; confirm no Discovery or ADR implementation files changed and run `git diff --check`.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; T002 and T003 can run in parallel after T001's scope review.
- **Foundational (Phase 2)**: Depends on Setup; T005 and T006 can run in parallel, then the shared test vocabulary must be ready before story tests.
- **User Story 1 (Phase 3)**: Depends on Foundational; T007-T008 precede T009-T010, then T011 is the story gate.
- **User Story 2 (Phase 4)**: Depends on Foundational and can run after or alongside US1 only when edits to shared test/source files are coordinated; T012-T013 precede T014-T015, then T016 is the story gate.
- **User Story 3 (Phase 5)**: Depends on Foundational and the field vocabulary from US1; T017-T018 precede T019-T021, then T022 is the story gate.
- **Polish (Phase 6)**: Depends on all three story checkpoints; T023-T025 can run in parallel after source changes stabilize, then T026-T027 run in order.

### User Story Dependencies

- **User Story 1 (P1)**: No dependency on another story after Foundational; it is the MVP and owns allowed-class cardinality.
- **User Story 2 (P1)**: No behavioral dependency on US1 after Foundational, but it touches the same authoritative skill and focused test files and should be coordinated with US1.
- **User Story 3 (P1)**: Depends on the shared field vocabulary established by US1 and the existing Solution Constraints contract; it owns recovery behavior across all fields.

### Within Each User Story

- Tests MUST be added and observed failing before implementation tasks are marked complete.
- Source skill changes precede focused validation for that story.
- Contract/document updates must match the implemented value states and error vocabulary.
- Each story checkpoint must pass before broadening to cross-cutting regeneration.

### Parallel Opportunities

- T002 and T003 can run in parallel after T001.
- T005 and T006 can run in parallel because they touch separate test surfaces.
- T007 and T008 can run in parallel as coordinated additions to separate assertion groups in the focused test.
- T012 and T013 can run in parallel because they cover focused behavior and shared-template wording separately.
- T017 and T018 can run in parallel as separate assertion groups in the focused test.
- T023, T024, and T025 can run in parallel only after authoritative source changes are stable.

## Parallel Example: User Story 1

```text
Task T007: Add valid allowed_solution_classes assertions in .highway/tools/tests/highway-new.test.sh
Task T008: Add invalid allowed_solution_classes and recovery assertions in .highway/tools/tests/highway-new.test.sh
```

These are logically separable assertion groups but require coordination because they share one test file.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Add and observe the User Story 1 failing cases.
3. Implement non-empty-list-or-unknown validation and recovery guidance.
4. Run the User Story 1 focused validation gate.
5. Stop for MVP review before wording and broader recovery work.

### Incremental Delivery

1. Complete Setup + Foundational and record the baseline.
2. Deliver User Story 1 and validate allowed-class cardinality.
3. Deliver User Story 2 and validate canonical Business Constraints wording.
4. Deliver User Story 3 and validate field-specific recovery and transaction preservation.
5. Regenerate catalog/adapters and run distribution checks.
6. Run the full suite and report complete results separately from focused Feature 054 coverage.

## Notes

- `[P]` marks tasks that can proceed independently without depending on incomplete work in another file; shared-file tasks still require coordination.
- Every user-story task includes its story label and an exact repository path.
- Generated adapters and catalogs are outputs, not hand-edited implementation surfaces.
- Discovery and ADR remain out of scope.
