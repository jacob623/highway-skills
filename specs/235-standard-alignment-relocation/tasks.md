---

description: "Task list for Standard Alignment Relocation"
---

# Tasks: Standard Alignment Relocation

**Input**: Design documents from `specs/235-standard-alignment-relocation/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: no new test is required. Existing tests change where paths or literals move (FR-017),
and three tests gain cleanup (FR-016).

**Organization**: the moves are foundational: User Stories 1 to 3 are one physical change that
lands together, because a half-moved tree cannot pass the suite. Each story then has its own
checks and edits. User Story 4 (the distribution) follows.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

- [X] T001 Record the baseline: the full bash suite passed 82 of 82 and the harness TypeScript tests 75 of 75 on the unchanged tree (D3.1, FR-017)
- [X] T002 Save a byte snapshot of every file under `.highway/skills/` (path and SHA-256) to a temporary file for the SC-001 comparison

---

## Phase 2: Foundational (blocking)

**Purpose**: the helper rename and the physical moves. Nothing passes until all of this is done.

- [X] T003 Rename the paths helper variables in `.highway/tools/lib/paths.sh` per research R2 (`HW_FRAMEWORK` to `HW_HIGHWAY`, then `HW_TOOLS` to `HW_FRAMEWORK`), and apply the same rename to every use under `.highway/tools/` and `harness/bin/`
- [X] T004 Move the files with `mv` per the data model: `.highway/skills/<id>/` to `skills/<id>/`; `.highway/tools/tests/` to `tests/`; the rest of `.highway/tools/` to `framework/`; `.highway/governance/constitution.md`, `.highway/skills/_authoring-standard.md`, and `.highway/library/knowledge/frontmatter-lexicon.txt` to `framework/` (the second as `authoring-standard.md`); `.highway/DISTRIBUTION.md` to `framework/README.md`
- [X] T005 Update `framework/lib/paths.sh` to the new layout per contracts/paths-helper.md: root two folders up, `HW_SKILLS`, `HW_FRAMEWORK`, `HW_TESTS`, `HW_HIGHWAY`, and `hw_doc` entries for `constitution`, `authoring-standard`, and `frontmatter-lexicon`
- [X] T006 Point the shims at the moved helper: `tests/paths.sh` and `harness/bin/lib/paths.sh` (research R3)

**Checkpoint**: `bash -c 'source framework/lib/paths.sh; echo $HW_SKILLS $HW_TESTS'` prints the new folders.

---

## Phase 3: User Story 1 - Skills live in a root `skills/` folder (Priority: P1)

**Goal**: `skills/` holds only the 15 skills, byte-identical; generated artifacts unchanged.

**Independent Test**: quickstart scenarios 2, 3, and 4.

- [X] T007 [US1] Remove the committed leftovers: `.claude/skills/test-catalog-fixture-20649/`, `.github/skills/test-catalog-fixture-20649/`, and the `.mock-agent-4` rows in `framework/.adapter-manifest` (FR-016)
- [X] T008 [US1] Make the exit traps in `tests/new-agent-extensibility.test.sh`, `tests/generate-catalog.test.sh`, and `tests/generate-agent-adapters.test.sh` remove every adapter copy and adapter manifest row they could have added, including all `.mock-agent-4` rows (FR-016, research R12)
- [X] T009 [US1] Confirm `framework/generate-catalog.sh`, `framework/generate-agent-adapters.sh`, and `framework/generate-instructions.sh` read from the new locations and update their usage lines and comments; regenerate and confirm no diff in the agent trees, the adapter manifest, the instruction outputs, or `.highway/catalog/index.json` (FR-007)
- [X] T010 [US1] Compare every file under `skills/` with the T002 snapshot and confirm 0 differences (SC-001)

---

## Phase 4: User Story 2 - The framework lives in `framework/` and the suite in `tests/` (Priority: P1)

**Goal**: the framework and suite run from their new folders, and their documents name them.

**Independent Test**: run `tests/run-all.sh`; run `framework/validate-skill.sh` on one skill.

- [X] T011 [US2] Update usage lines, comments, and messages in `framework/*.sh` and `framework/lib/*.sh` that name `.highway/tools/` or `.highway/skills/` as a repository location
- [X] T012 [US2] Update every test under `tests/` for the new layout: literal repository paths that are data (classifier and path-map inputs, document-text checks, messages), copies of the tree made by a test (they must include `framework/` and `skills/`), and fixture Example lines naming the validator (research R11)
- [X] T013 [US2] Update `framework/authoring-standard.md` to name `skills/<id>/SKILL.md`, `framework/validate-skill.sh`, `framework/generate-catalog.sh`, and `framework/.frontmatter-contract`
- [X] T014 [US2] Amend `framework/constitution.md` to 10.1.0: path references in the body follow the moves; P2.6's Observable names `framework/`; record the Sync Impact Report with D1.3, D1.4, and D5.3 review. Change `rc_check_P2_6` in `framework/lib/rule-checks.sh` to flag `framework/` in place of `.highway/tools/`, and update `tests/storage-contract.test.sh` and any test that quotes P2.6's text
- [X] T015 [US2] Record the D3.4 evaluation in this file's notes: no skill or fixture names `framework/` outside a fenced block before T014, so no P2.6 verdict changes
- [X] T016 [US2] Write `framework/README.md` per research R7: the authoring guide, with `.highway/tools/README.md` merged in and then deleted, the four Phase 3 sections removed, paths naming `skills/`, `framework/`, and `tests/`, and no Markdown link to a file the distribution lacks

---

## Phase 5: User Story 3 - Every reference follows the move (Priority: P1)

**Goal**: no live file names an old location; the harness and the check follow.

**Independent Test**: quickstart scenarios 6 and 7; `tests/harness-path-map.test.sh`.

- [X] T017 [US3] Update `tests/path-construction.test.sh` per research R10: scan `$HW_FRAMEWORK`, `$HW_TESTS`, and `$HW_HARNESS/bin`; extend rule 2 to `/skills/`, `/framework/`, and `/tests/`; follow the variable rename in rules 2 and 4; run it with its probe pair
- [X] T018 [US3] Update `harness/bin/path-map.sh`: `REL_FRAMEWORK` replaces `REL_TOOLS`, add a `REL_TESTS` case that selects nothing, rename `--location tools` to `--location framework`; update `harness/src/project.ts` to `location("framework")`
- [X] T019 [US3] Update `harness/selection/shared.txt` (drop the constitution and word-list rows), `harness/test/*.test.ts` literals, and `harness/README.md` to the new paths
- [X] T020 [US3] Amend `.specify/memory/constitution.md` to 3.2.0 per research R8, with the Sync Impact Report and self-application review
- [X] T021 [US3] Update `README.md`, `governance-plan.md`, and `harness/README.md` to the new paths (FR-014)
- [X] T022 [US3] Run `tests/path-construction.test.sh`, `tests/constitution-inventory.test.sh`, `tests/harness-path-map.test.sh`, and the harness TypeScript tests

---

## Phase 6: User Story 4 - The distribution stops carrying the framework (Priority: P2)

**Goal**: users get the same layout without the framework; packaging still proves the skills validate.

**Independent Test**: quickstart scenario 5.

- [X] T023 [US4] Change `dist_destination` in `framework/lib/distribution.sh` to map by longest matching record with the rest of the path appended (research R4)
- [X] T024 [US4] Rewrite the `.highway` and front-page sections of `framework/.distribution-manifest`: `include skills .highway/skills`; `exclude framework` with `include framework/README.md README.md`; `exclude tests`; drop the `.highway/skills`, `.highway/tools`, tool carve-out, and `DISTRIBUTION.md` rows; keep `rollout-plan.md` excluded
- [X] T025 [US4] Replace `verify_self_validation` in `framework/generate-distribution.sh` with the verification tree per contracts/distribution.md, and update its messages
- [X] T026 [US4] Update `tests/distribution-packaging.test.sh`, `tests/shipped-tree-independence.test.sh`, and `tests/storage-contract.test.sh` for the new contents and message, and run them

---

## Phase 7: Polish

- [X] T027 Mark Phase 6 complete in `standard-alignment.md` with a status note, and set `specs/235-standard-alignment-relocation/spec.md` to Complete
- [X] T028 Run `bash -n` on every changed script, regenerate every generated artifact, and confirm no diff (SC-004)
- [X] T029 Run the full bash suite outside the sandbox and the harness TypeScript tests; confirm all pass (FR-017, SC-005)
- [X] T030 Run quickstart scenarios 2 to 7 and record the results
- [X] T031 Report the suite results and the requirement coverage as separate claims (D7.3). Do not commit

---

## Dependencies & Execution Order

- Phase 1, then Phase 2 (blocking).
- Phases 3, 4, and 5 follow Phase 2 and share files; run them in order.
- Phase 6 depends on Phase 2 and on T016 (the README it ships).
- Phase 7 last.

## Parallel Opportunities

- T013, T016, and T021 edit different documents and can run together.
- T018 and T019 edit different harness files.

## Implementation Strategy

The MVP is Phases 1 to 3 with the suite passing, but a partial move cannot pass, so Phases 2 to 5
land as one change before the suite runs in full. Targeted tests run after each phase.

## Notes

- D3.4 (T015): every skill and every fixture was validated before and after `rc_check_P2_6`
  changed; each reported 0 P2.6 findings both times. After the fixture rewrite, `framework/`
  appears in fixtures only inside fenced Example blocks and in one relative link
  (`../../../framework/authoring-standard.md`, in `invalid-skill-relative-link`). The check flags
  `framework/` only at the start of a path, so that link is not flagged and its P8.7 verdict
  stands. `tests/storage-contract.test.sh` gains a `framework/` path case and a nested
  `framework/` folder case.
- The move took the constitution and the lexicon out of the folders the validation cache key
  hashes. `framework/lib/validation-cache.sh` now hashes both by name, and VC-6 in
  `tests/validation-cache.test.sh` copies `framework/` into its tree.
- `framework/validate-library.sh` declined every library fixture as out of scope, because its
  boundary was `.highway/` and the fixtures left it. The boundary is now `.highway/` and
  `tests/fixtures/`; a user file such as the root `library/` is still declined.
- `tests/adapter-coverage.test.sh` regenerates in a copy that now also holds `skills/` and
  `framework/`. `tests/codify-config-skill.test.sh` writes its four manifest rows as literals, so
  the extended path-construction rule 2 does not read them as paths.
