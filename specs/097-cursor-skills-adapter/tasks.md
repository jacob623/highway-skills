# Tasks: Deliver Highway Skills to Cursor as Skills, Not Rules

**Input**: Design documents from `specs/097-cursor-skills-adapter/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/cursor-adapter-contract.md`, `contracts/migration-contract.md`, `quickstart.md`

**Tests**: Required by the specification (FR-012) and the development constitution (D3.3, D3.5, D3.6). Each new or amended assertion is observed failing before the change that satisfies it. Static-contract evidence and executed-behavior evidence stay distinct (D3.8).

**Organization**: Tasks are grouped by user story. Amended tests that must fail first are written in the Foundational phase, following the feature 096 precedent, so each story phase starts from a recorded failure.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependency on an incomplete task)
- **[Story]**: The user story the task serves (US1 to US4)
- All paths are relative to the repository root

## Path Conventions

- Generator, manifests and tests: `.highway/tools/`
- Generated Cursor deliverables: `.cursor/skills/<id>/SKILL.md`
- Evidence for this feature: `specs/097-cursor-skills-adapter/evidence.md` (created in T001)

## Phase 1: Setup

**Purpose**: Establish a passing baseline and the snapshots later checks compare against.

- [X] T001 Run `.highway/tools/tests/run-all.sh` (allow up to 240 seconds) and record the exit status, the pass count, and `git diff --stat .highway/tools/.adapter-manifest` in a new `specs/097-cursor-skills-adapter/evidence.md` under a "Baseline (D3.1)" heading; stop if the suite does not exit 0
- [X] T002 Record in `specs/097-cursor-skills-adapter/evidence.md` the sha256 of every `.cursor/skills/speckit-*/SKILL.md` (expect 10), the sha256 of `.cursor/rules/test-catalog-fixture-20649.mdc` (expect `60826b120becb64a3a2b971b30b3230250da19719cc14dd2750fce5f03527392`), and the 12 `.cursor/rules/` rows and 12 `.mock-agent-4` rows currently in `.highway/tools/.adapter-manifest`

## Phase 2: Foundational

**Purpose**: Amend the tests so they describe the skill delivery and fail against the current generator, before any generator change (D3.6).

- [X] T003 Repoint the correspondence helpers in `.highway/tools/tests/adapter-coverage.test.sh`: `adapter_paths` to `.cursor/skills/$id`, `adapter_files` to `.cursor/skills/$id/SKILL.md`, and the orphan `case` arm `.cursor/rules/*.mdc` to `.cursor/skills/*`; leave every seeded probe and the `.github/`/`.claude/` logic unchanged
- [X] T004 In `.highway/tools/tests/generate-agent-adapters.test.sh`, change `CURSOR_TARGET` to `$REPO_ROOT/.cursor/skills/$TMP_ID/SKILL.md`, change the cleanup and the residue sweep to remove `.cursor/skills/$TMP_ID` and `.cursor/skills/test-adapter-fixture-*`, and replace the four rule-form assertions (`alwaysApply`, `globs`, description-only, body-below-frontmatter) with byte-identity checks of the Cursor file against the source and against `$CLAUDE_TARGET`, plus a check that every source frontmatter key (`name`, `description`, `usage`, `compatibility`, `metadata`) is present; record the superseded behavior as a comment naming the removed rule conversion (D3.5)
- [X] T005 In `.highway/tools/tests/generate-agent-adapters.test.sh`, add an assertion that no `.cursor/rules/$TMP_ID.mdc` exists after generation, and add a Spec Kit non-interference sentinel: capture the sha256 of `.cursor/skills/speckit-tasks/SKILL.md` before and after generation alongside the existing `.github/skills/speckit-tasks/SKILL.md` sentinel
- [X] T006 In `.highway/tools/tests/generate-agent-adapters.test.sh`, add an untracked-collision case: create `.cursor/skills/$TMP_ID/SKILL.md` with different content and no manifest row before generation, then assert the generator exits non-zero, names that file, leaves its content unchanged, and writes no `.github/` or `.claude/` adapter for `$TMP_ID`
- [X] T007 [P] Change the expected distribution-manifest path from `.cursor/rules/highway-new.mdc` to `.cursor/skills/highway-new` in `.highway/tools/tests/highway-new.test.sh`
- [X] T008 [P] Change the cleanup path `$REPO_ROOT/.cursor/rules/$TMP_ID.mdc` to `$REPO_ROOT/.cursor/skills/$TMP_ID` in `.highway/tools/tests/new-agent-extensibility.test.sh`
- [X] T009 [P] Change the residue sweep glob `.cursor/rules/test-adapter-fixture-*.mdc` to `.cursor/skills/test-adapter-fixture-*` in `.highway/tools/tests/run-all.sh`
- [X] T010 [P] Change the `cursor` key value from `.cursor/rules/` to `.cursor/skills/` in `feature_038_source_path` in `.highway/tools/tests/feature-038-helpers.sh`
- [X] T011 Run `generate-agent-adapters.test.sh`, `adapter-coverage.test.sh` and `highway-new.test.sh` against the unchanged generator and manifests, and record each failing run and its message in `specs/097-cursor-skills-adapter/evidence.md` under "Failing before change (D3.6)"; the deliverable, collision and correspondence assertions must fail, and any that pass must be explained

**Checkpoint**: The amended tests fail because the Cursor skill deliverable does not exist yet, not because a test is broken. Existing `.github/` and `.claude/` assertions still pass.

## Phase 3: User Story 1 - Highway skills appear as Cursor skills (Priority: P1) MVP

**Goal**: Each Highway skill is delivered to Cursor as `.cursor/skills/<id>/SKILL.md`, byte-identical to the other agents' deliverables, with no rule conversion left in the generator.

**Independent Test**: Run `.highway/tools/tests/generate-agent-adapters.test.sh` and quickstart step 1: every `.cursor/skills/highway-*/SKILL.md` matches the source and the Claude Code file byte for byte, and the generator contains no `mdc-transform` or `transform_mdc`. `adapter-coverage.test.sh` is not part of this story's test: it needs the distribution rows from US3.

### Implementation for User Story 1

- [X] T012 [US1] In `.highway/tools/generate-agent-adapters.sh`, change the Cursor entry of `AGENT_TARGET_TEMPLATES` to `.cursor/skills/%s/SKILL.md` and of `AGENT_TRANSFORMS` to `identity-copy`; delete `transform_mdc` and the `mdc-transform` arm of the `case`; update the header comment that names `.cursor/rules/<id>.mdc`; keep each of the three `AGENT_*` arrays on a single line, and keep the `identity-copy` and unknown-transform arms
- [X] T013 [US1] Run `.highway/tools/generate-agent-adapters.sh`, then run the quickstart step 1 checks and record the results in `specs/097-cursor-skills-adapter/evidence.md`: 12 `.cursor/skills/highway-*` directories, no `cmp` difference from the Claude Code or source file, `usage:` present in `.cursor/skills/highway-help/SKILL.md`, and zero `mdc-transform` or `transform_mdc` matches in the generator
- [X] T014 [US1] Run `.highway/tools/tests/generate-agent-adapters.test.sh` and `.highway/tools/tests/new-agent-extensibility.test.sh`; both must exit 0; record the results in `specs/097-cursor-skills-adapter/evidence.md`

**Checkpoint**: Cursor receives skills. The old rule files still exist and both forms are present until US2 runs.

## Phase 4: User Story 2 - Retire the superseded Cursor rule files safely (Priority: P1)

**Goal**: The 12 tracked Highway rule files and the one untracked fixture leftover are removed through a one-time, hash-checked migration that skips hand-edited files, and no Highway rule is ever produced again.

**Independent Test**: Quickstart steps 2 and 3: the seeded temporary-copy cases behave as the migration contract states, and after the real run `.cursor/rules/` holds no Highway file, the manifest holds no `.cursor/rules/` row, and a repeat generation produces no diff.

### Tests for User Story 2

- [X] T015 [US2] In `.highway/tools/tests/generate-agent-adapters.test.sh`, add a permanent regression guard: after generation, assert that no `.cursor/rules/highway-*.mdc` file exists and that `.highway/tools/.adapter-manifest` contains no row whose path begins `.cursor/rules/`; run it and record that it fails now, because the 12 rule files and rows still exist, in `specs/097-cursor-skills-adapter/evidence.md`

### Implementation for User Story 2

- [X] T016 [US2] Write `specs/097-cursor-skills-adapter/migrate-cursor-rules.sh` exactly per `specs/097-cursor-skills-adapter/contracts/migration-contract.md`: Bash 3.2 and the declared toolchain only, no `git`; resolve the repository root from the script location; read every manifest row beginning `.cursor/rules/`; classify each file as `TRACKED_CLEAN`, `TRACKED_EDITED`, `TRACKED_MISSING`, `ORPHAN_CLEAN`, `ORPHAN_EDITED` or `ORPHAN_ABSENT` per `specs/097-cursor-skills-adapter/data-model.md` before changing anything; emit the `REMOVED`, `EDITED`, `ROW-DROPPED`, `ABSENT` and final `MIGRATION COMPLETE`/`MIGRATION INCOMPLETE`/`ERROR` lines; rewrite the manifest through `mktemp` and `mv` only when a row changes; never open any other `.cursor/rules/` file; preserve every other manifest row byte for byte; exit 0 or 1 as the contract states
- [X] T017 [US2] Prove the script against a temporary copy of the tree (`mktemp -d`, copy `.highway`, `.cursor` and `specs`, run from the copy) for all eight quickstart step 2 cases: clean, edited adapter, re-run after resolving, foreign rule untouched and unnamed, edited leftover, manifest-row preservation including the `.mock-agent-4` rows, idempotent second run, missing manifest; record each case's exit status and output in `specs/097-cursor-skills-adapter/evidence.md` under "Migration scenarios", then delete the copy
- [X] T018 [US2] Run `bash specs/097-cursor-skills-adapter/migrate-cursor-rules.sh` in the real tree; if any file is reported `EDITED`, stop and ask the maintainer for a decision on that file, then re-run; when it exits 0, confirm that `.cursor/rules/` holds no `highway-*` or `test-catalog-fixture-*` file, that the manifest holds zero `.cursor/rules/` rows, 12 `.cursor/skills/highway-` rows and the 12 `.mock-agent-4` rows, and record the output in `specs/097-cursor-skills-adapter/evidence.md`
- [X] T019 [US2] Run `.highway/tools/tests/generate-agent-adapters.test.sh` to show the T015 guard now passes, then run `generate-catalog.sh`, `generate-library-catalog.sh` and `generate-agent-adapters.sh` twice and confirm the two runs leave identical `git status --short .highway .cursor` output and identical `.cursor/skills/highway-*/SKILL.md` checksums (quickstart step 3); record the results in `specs/097-cursor-skills-adapter/evidence.md`

**Checkpoint**: Each Highway skill reaches Cursor once, as a skill. No Highway rule remains, and hand-written rules are untouched.

## Phase 5: User Story 3 - Spec Kit skills and Highway skills coexist in the Cursor skills location (Priority: P1)

**Goal**: The generator, the manifests and the distribution treat `.cursor/skills/` correctly: Highway skills ship, `speckit-*` skills never do, and neither tool touches the other's files.

**Independent Test**: Quickstart steps 4 and 5: every `speckit-*` checksum is unchanged, an untracked collision is refused and named, and a produced distribution holds 12 `highway-*` and zero `speckit-*` skills under `.cursor/skills/`.

### Implementation for User Story 3

- [X] T020 [US3] In `.highway/tools/.distribution-manifest`, replace the 12 `include<TAB>.cursor/rules/highway-<id>.mdc<TAB>-` rows with 12 `include<TAB>.cursor/skills/highway-<id><TAB>-` directory rows in the same order, keep `exclude<TAB>.cursor<TAB>-`, keep every tab delimiter, and update the section comment if it names the rule form
- [X] T021 [US3] Run `.highway/tools/tests/adapter-coverage.test.sh`, `.highway/tools/tests/distribution-packaging.test.sh` and `.highway/tools/tests/shipped-tree-independence.test.sh`; all must exit 0; record the results, including the `adapter-coverage.test.sh` result that failed in T011, in `specs/097-cursor-skills-adapter/evidence.md`
- [X] T022 [US3] Produce a distribution into a temporary directory with `.highway/tools/generate-distribution.sh`, then confirm exit 0, 12 `highway-*` and 0 `speckit-*` entries under its `.cursor/skills/`, no `migrate-cursor-rules.sh` anywhere in it, and that the SC-007 verifications passed on the first run (quickstart step 5); record the results in `specs/097-cursor-skills-adapter/evidence.md`
- [X] T023 [US3] Recompute the sha256 of every `.cursor/skills/speckit-*/SKILL.md` and diff against the T002 snapshot to show all 10 unchanged after generation and migration (quickstart step 4); record `UNCHANGED` or the differing files in `specs/097-cursor-skills-adapter/evidence.md`

**Checkpoint**: All three P1 stories hold. The correspondence checks pass again, and nothing development-only ships.

## Phase 6: User Story 4 - Tests and documentation describe the skills delivery (Priority: P2)

**Goal**: Every live document that names the Cursor deliverable says Cursor receives skills, existing users are told the old rule files are superseded, and no live document still points to `.cursor/rules/`.

**Independent Test**: Quickstart step 6: the `rg` search over the three documents reports only the deliberate FR-016 note, and the path-integrity and packaging tests pass.

### Implementation for User Story 4

- [X] T024 [P] [US4] In `README.md`, change the adapter description that names `.cursor/rules/` to `.cursor/skills/`
- [X] T025 [P] [US4] In `.highway/DISTRIBUTION.md`, change `.cursor/rules/` to `.cursor/skills/` in the adapter sentence, and add one short note that any `.cursor/rules/<id>.mdc` Highway file from an earlier install is superseded by the skill and can be deleted (FR-016); the file ships as the distribution `README.md`, so the wording must contain neither `specs/` nor `.specify/` (D1.1)
- [X] T026 [P] [US4] In `.highway/tools/README.md`, change the Cursor target to `.cursor/skills/<id>/SKILL.md` in the `generate-agent-adapters.sh` section, and widen the sentence that says the generator never reads or writes the `speckit-*` folders under `.github/skills/` to cover `.cursor/skills/speckit-*` as well
- [X] T027 [US4] Run `rg -n '\.cursor/rules|\.mdc' README.md .highway/DISTRIBUTION.md .highway/tools/README.md` and confirm only the FR-016 note remains; run `rg -n 'specs/|\.specify/' .highway/DISTRIBUTION.md` and confirm no match; run `.highway/tools/tests/path-integrity.test.sh` and `.highway/tools/tests/distribution-packaging.test.sh`; record the results in `specs/097-cursor-skills-adapter/evidence.md`

**Checkpoint**: Documentation and tests agree with the generator.

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Whole-feature verification, cleanup of the one-time script, and the completion report.

- [X] T028 Run every declared generator (`generate-catalog.sh`, `generate-library-catalog.sh`, `generate-agent-adapters.sh`) and confirm the second run leaves no diff apart from the recorded catalog timestamp (D4.4, D4.7, FR-015); record the result in `specs/097-cursor-skills-adapter/evidence.md`
- [X] T029 Run `.highway/tools/tests/run-all.sh` and confirm exit 0 (D3.2, SC-006); compare `git diff --stat .highway/tools/.adapter-manifest` with the T001 baseline and confirm the only manifest change is the 12 rows swapped, with no stray rows; record the result
- [X] T030 Delete `specs/097-cursor-skills-adapter/migrate-cursor-rules.sh`, confirm it is gone (`test ! -e`), and confirm the generator still contains no code path that removes a file (FR-017); update `specs/097-cursor-skills-adapter/contracts/migration-contract.md` with a one-line note that the script was removed on completion
- [ ] T031 Open the repository in Cursor, confirm every `highway-*` skill is listed under Skills and none under Rules, and record any duplicate listing through `.claude/skills/` as an observation, not a failure (SC-001, clarification Q1); record the result in `specs/097-cursor-skills-adapter/evidence.md`
- [X] T032 Write the completion report in `specs/097-cursor-skills-adapter/evidence.md` with requirement coverage (FR-001 to FR-017 and SC-001 to SC-008, each mapped to the evidence section that proves it) stated separately from check results (D7.3), and list the out-of-scope observations from `research.md`: the `.github/` and `.claude/` fixture orphans and the `.mock-agent-4` manifest rows

## Dependencies & Execution Order

### Phase dependencies

- **Setup (T001-T002)**: no dependencies; T001 must pass before any edit.
- **Foundational (T003-T011)**: depends on Setup. T003 to T006 edit two files sequentially (T004 to T006 share one file). T007 to T010 are independent of each other and of T003 to T006. T011 needs T003 to T010.
- **US1 (T012-T014)**: depends on Foundational.
- **US2 (T015-T019)**: depends on US1, because the generator must already write the new manifest rows, and the guard in T015 is only meaningful once the Cursor deliverable exists.
- **US3 (T020-T023)**: depends on US1 and US2. `adapter-coverage.test.sh` fails between US1 and T020 by design, because the distribution rows have not moved yet.
- **US4 (T024-T027)**: documentation edits can begin after Foundational; T027 needs T024 to T026 and the US3 checks.
- **Polish (T028-T032)**: depends on every story. T030 must follow T029, so the suite runs while the script exists only if a re-migration is needed.

### Within each story

- Tests before implementation; record the failure, then the pass.
- Edits to the same file are never marked [P]: `generate-agent-adapters.test.sh` is touched by T004, T005, T006 and T015 in that order.

### Parallel opportunities

```text
Foundational:  T007, T008, T009, T010            (four different files)
US4:           T024, T025, T026                  (three different documents)
Cross-phase:   US4 documentation (T024-T026) can proceed alongside US3 (T020-T023)
```

## Implementation Strategy

### MVP

User Story 1 alone delivers Cursor skills, but it leaves the old rules in place, so each skill
appears as both a skill and a rule. The smallest state that solves the reported problem is **US1
plus US2** (T001 to T019): Cursor receives skills and the Highway rules are gone. Stop and validate
there with quickstart steps 1 to 3 and step 8.

### Incremental delivery

1. Setup and Foundational: baseline plus recorded failures.
2. US1: Cursor skill deliverable exists.
3. US2: rules retired, guard in place. **MVP validation point.**
4. US3: distribution and Spec Kit coexistence proven; correspondence checks green again.
5. US4: documentation current.
6. Polish: regeneration, full suite, script deletion, manual Cursor observation, completion report.

### Notes

- Do not commit the Spec Kit `cursor-agent` changes with this feature; they are a separate concern.
- Do not touch `.github/skills/test-catalog-fixture-20649` or `.claude/skills/test-catalog-fixture-20649`.
- Do not edit `fixtures/profile-092/*.tsv`, historical specs, `.specify/memory/constitution.md` or `.highway/skills/_authoring-standard.md`; the reasons are in `research.md`.
- If any task reports an `EDITED` rule file, stop and ask the maintainer; do not delete it.
