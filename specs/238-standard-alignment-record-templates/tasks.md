---

description: "Task list for Standard Alignment Record Templates in Their Skills (Phase 9)"
---

# Tasks: Standard Alignment Record Templates in Their Skills

**Input**: Design documents from `specs/238-standard-alignment-record-templates/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Requested by the spec (FR-007 to FR-009, FR-014); new checks are seeded before they are counted (D3.6).

**Organization**: Grouped by user story. US1 is P1; US2 and US3 are P2. Phase 2 moves the files every story depends on.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

- [X] T001 Confirm the baseline bash suite passed (`/tmp/hw-baseline-238.log`), then run the harness TypeScript tests in `harness/` and record the count
- [X] T002 Record every skill's and fixture's `framework/validate-skill.sh --no-cache` verdict to `/tmp/hw238-verdicts-before.txt` (D3.4)

---

## Phase 2: Foundational (blocking)

- [X] T003 Copy the 11 templates to `/tmp/hw238-templates/`, then `mv` each from `.highway/library/templates/output/` to its owner's `assets/` (research R1), and `cmp` each against its copy
- [X] T004 Point the 11 `hw_template` arms in `framework/lib/paths.sh` at `$HW_SKILLS/<owner>/assets/<file>.md`

**Checkpoint**: `hw_template` resolves every moved name to an existing file; `.highway/library/templates/output/` holds exactly three files.

---

## Phase 3: User Story 1 — Each record template lives with the skill that creates the record (P1)

**Goal**: the 8 owning skills name their templates as `assets/<file>.md`, with no behavior change.

**Independent Test**: `rg 'templates/output/' skills` lists only highway-adr, highway-architecture, highway-implementation, and highway-onboarding; each owner validates.

- [X] T005 [P] [US1] In `skills/highway-codify/SKILL.md`, replace the four codify template paths with `assets/<file>.md`; MINOR version
- [X] T006 [P] [US1] In `skills/highway-codify-config/SKILL.md`, replace the `coding-standard.md` path; MINOR version
- [X] T007 [P] [US1] In `skills/highway-controls/SKILL.md`, `skills/highway-nfrs/SKILL.md`, and `skills/highway-objectives/SKILL.md`, replace the record template paths; MINOR version each
- [X] T008 [P] [US1] In `skills/highway-discovery/SKILL.md` and `skills/highway-request/SKILL.md`, replace the record template paths; MINOR version each
- [X] T009 [US1] In `skills/highway-profile/SKILL.md`, replace the `profile-record.md` path (US2 edits the same file); MINOR version
- [X] T010 [US1] Run `framework/validate-skill.sh --no-cache` on the 8 owners

**Checkpoint**: no skill names a moved template under `.highway/`.

---

## Phase 4: User Story 2 — highway-profile stops guarding a location that no longer exists (P2)

**Goal**: no skill names `.highway/library/knowledge/`.

**Independent Test**: `rg '\.highway/library/knowledge/' skills` finds nothing; `tests/profile-template-migration.test.sh` passes.

- [X] T011 [US2] Remove the two guard sentences from `skills/highway-profile/SKILL.md` (research R2), keeping the `library/knowledge/` creation sentence
- [X] T012 [US2] Update `tests/profile-template-migration.test.sh`: require no guard, and no `profile-record.md` row under `.highway/` in the distribution manifest

---

## Phase 5: User Story 3 — The checks follow the templates to their new homes (P2)

**Goal**: every check that covered a moved template still covers it; the skill validator checks complete templates in `assets/`; skeletons are compared exactly.

**Independent Test**: `tests/record-templates.test.sh`, `tests/catalog-seeding.test.sh`, and every repointed test pass; each seeded probe fails as expected.

- [X] T013 [US3] Add `--asset <file>` to `framework/validate-library.sh` (contract `asset-template-check.md`): skip containment and type detection, treat the file as a template
- [X] T014 [US3] In `framework/validate-skill.sh`, check each complete template in `<skill-dir>/assets/` with `validate-library.sh --asset`, reporting findings as `ERROR: [<tag>] assets/<file>: ...` and failing the skill; verdict lines stay computed from `SKILL.md`
- [X] T015 [US3] In `framework/lib/validation-cache.sh`, make `vc_key` hash the skill's `assets/` files and add `validate-library.sh` to the environment hash
- [X] T016 [US3] Write `tests/record-templates.test.sh` (research R7), and observe its validator and cache probes failing against the pre-T014/T015 behavior before counting it
- [X] T017 [P] [US3] Create `tests/fixtures/catalog-seeding/skeletons/` with a copy of each of the 12 skeletons, and add the reference comparison, the `Mode: Local` check, and a column-removal probe to `tests/catalog-seeding.test.sh` (contract `skeleton-reference.md`)
- [X] T018 [US3] Repoint the tests that join `$HW_OUTPUT_TEMPLATES` with a moved name to `hw_template`: `highway-codify`, `codify-config-skill`, `codify-proposal-tasks`, `adr-span-progression`, `codify-closing-guide`, `codify-file-layout`, `code-project`, `codify-products`, `codify-platform-catalog`, `codify-feature-wording`, and any other `OUTPUT=` user that names a moved file
- [X] T019 [US3] Update `tests/output-template.test.sh`: citations to `assets/<file>.md`, skill-validator checks on the four owners in place of the library-validator checks, the citing count 12 → 4 with its loop, the probe citation strings, and the fixture copies through `hw_template`
- [X] T020 [US3] Update `tests/codify-feature-wording.test.sh` literal citations and `tests/harness-path-map.test.sh` (asset path, reason, `adr-record.md` probe)
- [X] T021 [US3] Update `harness/test/select.test.ts` to select with `skills/highway-codify/assets/codify-plan.md`
- [X] T022 [US3] Remove the `objective-record.md`, `request-record.md`, and `profile-record.md` rows from `framework/.distribution-manifest`

**Checkpoint**: each touched test passes on its own.

---

## Phase 6: Polish & Cross-Cutting Concerns

- [X] T023 Regenerate `.highway/catalog/index.json` and the agent adapters, twice, and confirm the second run changes nothing
- [X] T024 [P] Update `README.md`, `framework/README.md`, `framework/authoring-standard.md`, `harness/README.md`, and `standard-alignment.md` (Phase 9 complete, with a status note)
- [X] T025 Compare validator verdicts with `/tmp/hw238-verdicts-before.txt` (D3.4); sweep for stale references to the moved templates' old paths
- [X] T026 Run the full bash suite (expect 84), then the harness TypeScript tests and tsc; build the distribution and confirm each moved template ships inside its skill

## Dependencies

- Phase 2 blocks every story. T004 blocks T010 and every test task.
- US1 (T005–T010) before US2's T011, which edits the same profile file as T009.
- US3's T013 → T014 → T015 → T016. T017–T022 can follow T004 in any order.
- Polish follows all stories.

## Parallel Example

```text
T005, T006, T007, T008 edit different skills and can run together.
T017 and T018 touch different tests.
```

## Implementation Strategy

1. Setup and Phase 2, then US1: the move with citations, validated (MVP).
2. US2: the profile guards.
3. US3: validator, cache, the new test, the skeleton comparison, repointed tests, harness, manifest.
4. Polish: regenerate, documents, verdicts, full suite, harness, distribution.
