# Tasks: Controls and NFR Review Output Contracts

## Phase 1: Setup

- [X] T001 Confirm Feature 078 implementation scope and existing Feature 077 baseline in `specs/078-controls-nfr-review-output/spec.md` and `specs/077-controls-nfr-onboarding/spec.md`
- [X] T002 [P] Inventory canonical skill, focused test, fixture, generated-artifact, and governance paths in `specs/078-controls-nfr-review-output/plan.md`
- [X] T003 [P] Record the no-new-persistence/no-new-runtime-model constraint in `specs/078-controls-nfr-review-output/research.md`

## Phase 2: Foundational

- [X] T004 Add Feature 078 review-output fixture markers for populated and empty Control/NFR reviews in `.highway/tools/tests/fixtures/controls-nfr-onboarding/`
- [X] T005 Add shared contract assertion helpers for exact empty-review fields and decision lists in `.highway/tools/tests/test-helpers.sh`
- [X] T006 Run the existing Feature 077 focused tests and capture the pre-change baseline in `specs/078-controls-nfr-review-output/quickstart.md`
- [X] T007 [P] Define the canonical review-output field inventory and ownership mapping in `specs/078-controls-nfr-review-output/data-model.md`

## Phase 3: User Story 1 - Explicit Control Review Output (P1)

**Goal:** Make populated and empty Control Review output, proposal-state non-persistence, and existing-baseline routing explicit and testable.

**Independent test:** Run the Control onboarding and routing focused tests; verify every populated entry has Category, Proposed Title, Statement, and the four decisions, empty output has `Status: Empty` and `Entry Count: 0`, pre-completion bytes remain unchanged, and a valid baseline suppresses collection prompts.

- [X] T008 [US1] Add the Control Review output contract with populated-entry fields, decisions, stable ordering, and empty-review shape to `.highway/skills/highway-controls/SKILL.md`
- [X] T009 [US1] Clarify proposal-state-only titles and the no-write boundary before Control `Review Complete` in `.highway/skills/highway-controls/SKILL.md`
- [X] T010 [US1] Clarify valid existing-baseline setup/configure routing and suppression of onboarding state in `.highway/skills/highway-controls/SKILL.md`
- [X] T011 [US1] Add populated and empty Control Review contract assertions to `.highway/tools/tests/highway-controls-onboarding.test.sh`
- [X] T012 [US1] Add proposal-byte preservation and existing-baseline routing assertions to `.highway/tools/tests/governance-routing.test.sh`
- [X] T013 [US1] Run `.highway/tools/tests/highway-controls-onboarding.test.sh` and `.highway/tools/tests/governance-routing.test.sh` and repair only Feature 078 failures in the touched Control contract slice

## Phase 4: User Story 2 - Explicit NFR Review and Readiness Output (P1)

**Goal:** Make populated and empty NFR candidate review, deterministic ordering, readiness ownership, and duplicate-failure preservation explicit and testable.

**Independent test:** Run NFR onboarding, candidate, readiness, and routing tests; verify all six candidate fields and four decisions, explicit empty output, stable ordering, readiness changes only after successful completion, and duplicate failure occurs before allocation with no partial write.

- [X] T014 [US2] Add the NFR Candidate Review output contract with populated-entry fields, decisions, ordering, and empty-review shape to `.highway/skills/highway-nfrs/SKILL.md`
- [X] T015 [US2] Clarify that successful NFR `Review Complete` is the only readiness-reflected outcome and all listed failures preserve readiness-consumed state in `.highway/skills/highway-nfrs/SKILL.md`
- [X] T016 [US2] Clarify duplicate detection before NFR creation and identifier allocation with no partial write in `.highway/skills/highway-nfrs/SKILL.md`
- [X] T017 [US2] Add populated and empty NFR Review output assertions to `.highway/tools/tests/highway-nfr-onboarding.test.sh`
- [X] T018 [US2] Add deterministic repeated-ordering and duplicate-failure preservation assertions to `.highway/tools/tests/control-derived-nfr.test.sh`
- [X] T019 [US2] Add successful-completion and failure-path readiness ownership assertions to `.highway/tools/tests/readiness-owner-states.test.sh`
- [X] T020 [US2] Run `.highway/tools/tests/highway-nfr-onboarding.test.sh`, `.highway/tools/tests/control-derived-nfr.test.sh`, and `.highway/tools/tests/readiness-owner-states.test.sh` and repair only Feature 078 failures in the touched NFR contract slice

## Phase 5: User Story 3 - Consistent Deterministic Review Presentation (P2)

**Goal:** Keep review contracts discoverable in their owning canonical skill sections, synchronized with existing workflow contracts, and free from unstable output inputs.

**Independent test:** Inspect both canonical skills and run the focused contract suite; verify each review field and decision list is stated once in the owning section and repeated identical candidate inputs produce identical field and candidate ordering.

- [X] T021 [P] [US3] Align the Control review contract wording with the owner-local contract artifact in `.highway/skills/highway-controls/SKILL.md` and `specs/078-controls-nfr-review-output/contracts/control-review-output.md`
- [X] T022 [P] [US3] Align the NFR review contract wording with the owner-local contract artifact in `.highway/skills/highway-nfrs/SKILL.md` and `specs/078-controls-nfr-review-output/contracts/nfr-review-output.md`
- [X] T023 [US3] Add assertions that review output excludes timestamps, randomness, environment values, filesystem ordering, and session state in `.highway/tools/tests/highway-controls-onboarding.test.sh` and `.highway/tools/tests/highway-nfr-onboarding.test.sh`
- [X] T024 [US3] Verify canonical skill ownership and absence of duplicate review-output declarations in `.highway/tools/tests/governance-routing.test.sh`

## Phase 6: Polish and Cross-Cutting Validation

- [X] T025 Regenerate catalogs and distributed adapters after canonical skill changes using `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh`
- [X] T026 Validate generated correspondence and shipped-tree independence with `.highway/tools/tests/adapter-coverage.test.sh` and `.highway/tools/tests/shipped-tree-independence.test.sh`
- [X] T027 [P] Update the implementation validation scenarios and expected outputs in `specs/078-controls-nfr-review-output/quickstart.md`
- [X] T028 Run the complete focused Feature 078 test set from `specs/078-controls-nfr-review-output/quickstart.md`
- [X] T029 Run `.highway/tools/tests/run-all.sh` and record any Feature 078-specific result in `specs/078-controls-nfr-review-output/quickstart.md`
- [X] T030 Run `git diff --check` and confirm every changed canonical skill has synchronized generated artifacts in `specs/078-controls-nfr-review-output/quickstart.md`

## Dependencies and Execution Order

- Setup tasks T001-T003 precede all implementation work.
- Foundational tasks T004-T007 precede User Story 1 and establish the shared evidence surface.
- User Story 1 is the MVP and can complete independently after the foundational phase.
- User Story 2 depends on the Feature 077 candidate and readiness behavior but can be tested independently after the foundational phase; it does not require User Story 1 source edits.
- User Story 3 depends on the review contracts from User Stories 1 and 2 and should follow both P1 stories.
- Polish tasks T025-T030 follow all canonical skill and focused test changes.

Dependency graph:

```text
T001-T003 -> T004-T007 -> T008-T013 -> T014-T020 -> T021-T024 -> T025-T030
                         \-> T014-T020 can proceed in parallel with T008-T013 after T004-T007
```

## Parallel Execution Examples

- After setup, T002 and T003 can run in parallel.
- After foundational work, User Story 1 tasks T008-T012 and User Story 2 tasks T014-T019 can be split across workers because they own different canonical skills and focused test slices.
- Within User Story 3, T021 and T022 can run in parallel because they update different owner-local contracts; T023 and T024 follow those edits.
- During polish, T026 and T027 can run in parallel after T025; T028-T030 remain final validation tasks.

## Implementation Strategy

Deliver the MVP as User Story 1: explicit Control Review output, empty-review behavior, proposal-state write boundaries, and existing-baseline routing. Then add User Story 2 for NFR review/readiness/duplicate-failure contracts, followed by User Story 3 for cross-owner consistency. Finish by regenerating correspondence and running focused then full validation. No new runtime model or persistence artifact is permitted.

## Completion Criteria

- Every task uses the required `- [ ] T###` checklist format.
- Story tasks carry exactly one `[US#]` label and identify concrete repository paths.
- Populated and empty Control/NFR output, write boundaries, ordering, readiness ownership, and duplicate-failure preservation are each covered by focused evidence.
- Canonical source changes are synchronized to distributed artifacts before completion.
