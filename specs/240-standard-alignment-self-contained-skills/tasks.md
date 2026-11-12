---

description: "Task list for Standard Alignment Self-Contained Skills (Phase 11)"
---

# Tasks: Standard Alignment Self-Contained Skills

**Input**: Design documents from `specs/240-standard-alignment-self-contained-skills/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Requested by the spec (FR-016, FR-017). New checks are seeded before they are counted (D3.6).

**Organization**: Grouped by user story.

- US1 and US2 are P1, US3 and US4 are P2, and US5 is P3.
- Phase 2 moves the paths helper every story depends on.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

- [X] T001 Run the baseline bash suite to `/tmp/hw-baseline-240.log`, then the harness TypeScript tests in `harness/`, and record both counts (D3.1)
- [X] T002 Record every skill's and fixture's validator verdict to `/tmp/hw240-verdicts-before.txt` with `/tmp/hw238-verdicts.sh` (D3.4)

---

## Phase 2: Foundational (blocking)

- [X] T003 In `framework/lib/paths.sh`, add `HW_HELP_INDEX="$HW_SKILLS/highway-help/assets/index.json"` and remove `HW_HIGHWAY` and `HW_CATALOG` (R1)
- [X] T004 `mv .highway/catalog/index.json skills/highway-help/assets/index.json`, then `rmdir .highway/catalog .highway`

**Checkpoint**: `.highway/` does not exist, and `HW_HELP_INDEX` names an existing file.

---

## Phase 3: User Story 1 — highway-help reads its own index (P1)

**Goal**: the generator writes highway-help's `assets/index.json` with dependencies and Example, and highway-help reads only that file.

**Independent Test**: `tests/generate-catalog.test.sh`, `tests/help-output-single.test.sh`, and `tests/help-output-all.test.sh` pass, and each fails on a seeded defect.

- [X] T005 [US1] Update `tests/generate-catalog.test.sh`: read `HW_HELP_INDEX`, assert the seven entry fields and highway-help's `example`, and add the name-folder mismatch case (R2). Run it and record the failure before T006
- [X] T006 [US1] Rewrite `framework/generate-catalog.sh` to write `HW_HELP_INDEX` with `id, name, description, usage, version, dependencies, example` (R1)
- [X] T007 [US1] Rewrite highway-help's Inputs, Steps, Verification, and Error Handling in `skills/highway-help/SKILL.md` to read only `assets/index.json`, drop the AS-4 citation, and bump it to 3.3.0 with its Example (R3)
- [X] T008 [P] [US1] Point `tests/help-output-single.test.sh`, `tests/help-output-all.test.sh`, `tests/storage-contract.test.sh`, and `tests/adapter-coverage.test.sh` at `HW_HELP_INDEX`, and remove their `.highway` copies

**Checkpoint**: the four tests and `generate-catalog.test.sh` pass.

---

## Phase 4: User Story 2 — One validator checks bundled files (P1)

**Goal**: `validate-skill.sh` checks `assets/` templates and `references/`, and `validate-library.sh` is gone.

**Independent Test**: `tests/bundled-files.test.sh` passes, and each of its seeded fixtures produces its finding.

- [X] T009 [US2] `mv tests/fixtures/library tests/fixtures/bundled-files`. Write `tests/bundled-files.test.sh` (R11), which builds temporary skills holding the fixtures in `assets/` or `references/`, and record its failure before T010
- [X] T010 [US2] Add `check_bundled` to `framework/validate-skill.sh` for `assets/*.md` templates and `references/*.md`, and rename `rc_library_exempt_ids` to `rc_bundled_exempt_ids` in `framework/lib/rule-checks.sh` (R4)
- [X] T011 [US2] In `framework/lib/validation-cache.sh`, add `references/` to `vc_key` and drop `validate-library.sh` from the environment hash; add a references case to `tests/validation-cache.test.sh` (R5)
- [X] T012 [US2] Delete `framework/validate-library.sh`, `tests/validate-library.test.sh`, and `tests/library-containment.test.sh`, and record the superseded assertions in research R11
- [X] T013 [US2] Make `framework/lib/dependency-check.sh` resolve paths against the skill's folder, and point `tests/dependency-check.test.sh`'s target at the temporary skill's `references/` (clarification 3)

**Checkpoint**: every skill and fixture verdict matches T002, except that references are now checked and pass.

---

## Phase 5: User Story 3 — Skills read only their own folder (P2)

**Goal**: no skill names `.highway/` or a path outside its folder, and setup copies only seeded files.

**Independent Test**: `tests/self-contained-skills.test.sh` passes, and each probe fails.

- [X] T014 [US3] Write `tests/self-contained-skills.test.sh` per contracts/bundled-files.md, with a probe for each check. Run it and record the failure before T015 (D3.6)
- [X] T015 [US3] Remove the project-root input from the 14 skills; remove the missing-root stop and its error bullet from highway-request, highway-codify, and highway-codify-config, renumbering Entry; and remove the "beneath `.highway`" lines from highway-controls, highway-objectives, and highway-nfrs (R7)
- [X] T016 [US3] Bump each changed skill MINOR, update its Example's `Version:`, and regenerate the index and adapters
- [X] T017 [P] [US3] Reduce `tests/record-templates.test.sh`, `tests/profile-template-migration.test.sh`, and `tests/experience-activation.test.sh` by the `.highway` guards that R6 supersedes, and repoint the `tests/rule-checks.test.sh` probe (R11)

**Checkpoint**: `self-contained-skills.test.sh` passes, and every skill validates.

---

## Phase 6: User Story 4 — The harness builds from `skills/` (P2)

**Goal**: the test project holds the skill folders in `.github/skills/` and no `.highway/`.

**Independent Test**: the harness TypeScript tests and `tests/harness-fixtures.test.sh` pass, and the agent-skill-folder probe fails.

- [X] T018 [US4] Add `--location agent-skills` to `harness/bin/path-map.sh` and remove its catalog arm; update `tests/harness-path-map.test.sh` (R9)
- [X] T019 [US4] Replace `buildDistribution` with `buildSkills` in `harness/src/project.ts`, and rename `distDir` to `baseDir` in `project.ts`, `chain.ts`, `runner.ts`, `harness/test/runner.test.ts`, `harness/test/chain.test.ts`, and `harness/test/failure.test.ts`
- [X] T020 [US4] Make `harness/bin/fixture-check.sh` reject agent skill folders, and add a temporary-overlay probe to `tests/harness-fixtures.test.sh`
- [X] T021 [P] [US4] Remove codify's root waiver from `harness/coverage/treatments.txt` and reword the template waiver; update `harness/fixtures/templates.map` and `harness/README.md`

**Checkpoint**: harness tests pass, and `tsc` is clean.

---

## Phase 7: User Story 5 — Distribution, constitutions, and documents (P3)

**Goal**: the distribution ships skills only in the agent trees, and no live document names `.highway/`.

**Independent Test**: `tests/distribution-packaging.test.sh` and `tests/shipped-tree-independence.test.sh` pass, and a repository search finds only the allowed `.highway` mentions.

- [X] T022 [US5] Update `framework/.distribution-manifest` and `framework/generate-distribution.sh`: skills excluded, record at `.distribution-record`, and the verification tree built from `.agents/skills` (R8)
- [X] T023 [US5] Update `tests/distribution-packaging.test.sh`, `tests/shipped-tree-independence.test.sh`, and `tests/run-all.sh`'s cleanup for the new probe location, and assert that the distribution holds no `skills/` and no `.highway`
- [X] T024 [P] [US5] Drop the catalog arm from `tests/feature-038-helpers.sh`, and repoint any remaining `.highway` test reference found by the R6 search
- [X] T025 [US5] Amend `.specify/memory/constitution.md` to 3.4.0, with its Sync Impact Report and self-application review (R10)
- [X] T026 [P] [US5] Update `README.md`, `framework/README.md`, and `framework/authoring-standard.md` (R12)

**Checkpoint**: both distribution tests pass, and the generated distribution holds no `.highway` and no `skills/`.

---

## Phase 8: Polish

- [X] T027 Regenerate twice and confirm no diff on the second run (D4.7)
- [X] T028 Re-record verdicts to `/tmp/hw240-verdicts-after.txt` and compare them with T002 (D3.4)
- [X] T029 Run the full bash suite, then the harness tests and `tsc`
- [X] T030 Update `standard-alignment.md`: the Phase 11 status note, and the phase table rows for Phases 10 and 11

## Dependencies

- Phase 2 blocks everything.
- Within the stories:
  - US1: T006 precedes T007 and T008.
  - US2: T010 precedes T012.
  - US3: T015 and T016 precede the passing run of T014.
- US4 and US5 depend on Phase 2 only.
- Polish comes last.
