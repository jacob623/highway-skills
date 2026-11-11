---

description: "Task list for Standard Alignment Path Indirection"
---

# Tasks: Standard Alignment Path Indirection

**Input**: Design documents from `specs/234-standard-alignment-path-indirection/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/paths-helper.md, quickstart.md

**Tests**: The spec requires one new check (FR-010) and changes to existing tests. No other test
tasks are generated.

**Organization**: Tasks are grouped by user story. The helper, shims, and check are foundational
because User Stories 2, 3, and 4 all need them, and the check must be seen failing before the
conversion completes (D3.6).

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

- [X] T001 Run the full bash suite outside the sandbox with `.highway/tools/tests/run-all.sh` and confirm 88 of 88 pass before any edit (D3.1)
- [X] T002 Run the harness TypeScript tests with `npm test` in `harness/` and confirm they pass before any edit (FR-015)

---

## Phase 2: User Story 1 - Retire the regression-only tests (Priority: P1)

**Goal**: No regression-only test and no exact version check remains; every dropped assertion is recorded.

**Independent Test**: quickstart scenarios 2 and 3, then the full suite.

- [X] T003 [P] [US1] Delete `profile-yaml.test.sh`, `path-integrity.test.sh`, `feature-092-correspondence.test.sh`, `profile-adaptive.test.sh`, and `runtime-contract-hygiene.test.sh` from `.highway/tools/tests/`, and the fixtures `.highway/tools/tests/fixtures/profile-092/dependent-artifact-inventory.tsv`, `.highway/tools/tests/fixtures/profile-092/impact-review.tsv`, and `.highway/tools/tests/fixtures/profile-091/adaptive-corpus.md` (research R1)
- [X] T004 [US1] Consolidate the current Experience Standard checks into `.highway/tools/tests/experience-standard-convergence.test.sh` and delete `experience-standard-amendment.test.sh` and `feature-141-experience-standard-refactor.test.sh` (research R2)
- [X] T005 [P] [US1] Remove the consolidated 64-rule count from `.highway/tools/tests/highway-ux-alignment.test.sh`
- [X] T006 [P] [US1] Reduce `.highway/tools/tests/constitution-experience-alignment.test.sh`: drop the version line, the removed-text loops, and the consolidated Experience Standard checks (research R2)
- [X] T007 [P] [US1] Reduce `.highway/tools/tests/profile-template-migration.test.sh` to its current-behavior checks and update its header comment (research R2)
- [X] T008 [US1] Remove every exact skill, template, Highway Skills Constitution, and Experience Standard version check from the remaining `.highway/tools/tests/*.test.sh`, keeping lists intact and keeping fixture text and record-content values (research R3)
- [X] T009 [US1] Write `specs/234-standard-alignment-path-indirection/dropped-assertions.md` from the diff, marking each entry kept, consolidated, or superseded (FR-004)
- [X] T010 [US1] Run the full suite and confirm every remaining test passes

**Checkpoint**: the test count is final for conversion.

---

## Phase 3: Foundational - helper, shims, and check

**Purpose**: the pieces User Stories 2 to 4 depend on.

- [X] T011 Create `.highway/tools/lib/paths.sh` per `contracts/paths-helper.md`: variables, `hw_paths_init`, `hw_template` with one arm per output template, `hw_doc` with one arm per governance and knowledge document, `hw_at`, `hw_rel`
- [X] T012 [P] Create the test shim `.highway/tools/tests/paths.sh` that sources the helper
- [X] T013 [P] Create the harness shim `harness/bin/lib/paths.sh` that sources the helper
- [X] T014 Create `.highway/tools/tests/path-construction.test.sh` with rules 1 to 4 (research R8), artifact class `source-document`, `--probe` and `--neutralise`; run it against the unconverted tree and confirm it fails with file and line (D3.6)

---

## Phase 4: User Story 2 - Find every location through one paths helper (Priority: P1)

**Goal**: every bash test and framework script gets its locations from the helper.

**Independent Test**: quickstart scenario 5, then the full suite.

- [X] T015 [US2] Convert the 12 shared libraries in `.highway/tools/lib/` to take the repository root and resolve files through `hw_at`, `hw_doc`, and the helper variables (research R6)
- [X] T016 [US2] Convert the 7 tools in `.highway/tools/` (`generate-agent-adapters.sh`, `generate-catalog.sh`, `generate-distribution.sh`, `generate-instructions.sh`, `validate-library.sh`, `validate-profile.sh`, `validate-skill.sh`) to source the helper and pass `HW_ROOT` to libraries
- [X] T017 [US2] Convert every `.highway/tools/tests/*.test.sh`, `run-all.sh`, and fixture script to source the shim and use helper variables, `hw_template`, and `hw_doc` (mechanical pass for the common forms)
- [X] T018 [US2] Convert the remaining constructions by hand, including disposable-copy tests through `hw_at`, until `path-construction.test.sh` reports nothing under `.highway/tools/` (research R7)
- [X] T019 [US2] Run the full suite; then run quickstart scenario 5 in a disposable copy (skills folder and one template moved, one helper edit each)

---

## Phase 5: User Story 3 - The harness reads the same locations (Priority: P2)

**Goal**: the harness path map and scripts take locations from the helper; the runner asks the path map.

**Independent Test**: quickstart scenario 6 and the harness TypeScript tests.

- [X] T020 [US3] Convert `harness/bin/path-map.sh` to the shim and helper locations, and add `--location <skills|tools>` (research R9)
- [X] T021 [P] [US3] Convert `harness/bin/inventory.sh`, `harness/bin/template-check.sh`, and `harness/bin/fixture-check.sh` to the shim and helper lookups
- [X] T022 [US3] Change `harness/src/select.ts` (`skillsAtRef`) and `harness/src/project.ts` to take the skills and tools locations from `path-map.sh --location`
- [X] T023 [US3] Run `harness-path-map.test.sh`, the other harness bash tests, `path-construction.test.sh`, and `npm test` in `harness/`

---

## Phase 6: User Story 4 - A check keeps paths going through the helper (Priority: P2)

**Goal**: the check is a constitutional rule.

**Independent Test**: quickstart scenario 4 and `constitution-inventory.test.sh`.

- [X] T024 [US4] Amend `.specify/memory/constitution.md` to 3.1.0: add D2.5 `[auto]`, its Enforcement Map row naming `path-construction.test.sh`, the Toolchain Gate evaluating D2.1–D2.5 and covering `harness/bin/`, and a Sync Impact Report with the self-application review (research R10)
- [X] T025 [US4] Run `constitution-inventory.test.sh` and `path-construction.test.sh` with its probe pair, and the manual seeded-line check from quickstart scenario 4

---

## Phase 7: Polish & Cross-Cutting Concerns

- [X] T026 [P] Describe the helper and the shims in `.highway/tools/README.md` and `README.md` where they describe how scripts and tests find files (FR-013)
- [X] T027 [P] Mark Phase 5 complete in `standard-alignment.md` with a status note, and set `specs/234-standard-alignment-path-indirection/spec.md` status to Complete
- [X] T028 Re-run every generator and confirm no diff in `.claude/`, `.cursor/`, `.github/`, `.agents/`, `.highway/catalog/`, `AGENTS.md`, and the manifests (FR-012)
- [X] T029 Run the full bash suite outside the sandbox and `npm test` in `harness/`; confirm all pass, including `distribution-packaging.test.sh` (FR-015, SC-005)
- [X] T030 Run the quickstart scenarios 2, 3, 4, and 6 and confirm the expected results

---

## Dependencies & Execution Order

- Setup (T001–T002) before any edit.
- User Story 1 (T003–T010) before the foundational phase, so no removed test is converted.
- Foundational (T011–T014) before User Stories 2, 3, and 4.
- User Story 2 (T015–T019): libraries before tools before tests, because tools pass the new root to libraries and tests call both.
- User Story 3 (T020–T023) after T013; independent of User Story 2 except that the full check passes only when both are done.
- User Story 4 (T024–T025) after User Stories 2 and 3, because the rule is `[auto]` and its test must pass.
- Polish last.

## Parallel Opportunities

- T003, T005, T006, T007 touch different files.
- T012 and T013.
- T021 alongside T020.
- T026 and T027.

## Implementation Strategy

User Story 1 alone is a complete, shippable cleanup. The helper, conversion, harness, and rule then
land together, because the check only passes once every script is converted.
