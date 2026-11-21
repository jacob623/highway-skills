# Tasks: Highway Repository Pointer

**Input**: Design documents from `specs/258-highway-repository-pointer/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Required by FR-015 / plan (suite + catalog-seeding + storage-contract updates).

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

**Purpose**: Confirm feature docs and baseline suite before edits

- [x] T001 Record D3.1 baseline by running `tests/run-all.sh` from repository root (note pass/fail)
- [x] T002 [P] Confirm feature docs exist under `specs/258-highway-repository-pointer/` (plan, spec, research, data-model, contracts, quickstart)

---

## Phase 2: Foundational

**Purpose**: Storage contract + gate asset that all stories depend on

- [x] T003 Update effective-root, resolution order, pointer files, and Local column wording in `skills/highway-experience/references/storage-contract.md` (bump to 1.4.0) per `contracts/storage-effective-root.md` and `contracts/pointer-files.md`
- [x] T004 Create shared gate copy in `skills/highway-experience/assets/repository-gate.md` per `contracts/experience-gate.md`
- [x] T005 Extend activated-by-a-skill procedure in `skills/highway-experience/SKILL.md` (resolve → mode → gate outcomes; bump metadata version MINOR); keep direct-invocation path free of the dual gate tour

**Checkpoint**: Experience + storage contract define resolution and gate; no owning-skill edits yet

---

## Phase 3: User Story 1 - Resolve knowledge root (P1) 🎯 MVP

**Goal**: Effective knowledge root resolution before other skill work

**Independent Test**: Storage contract + experience procedure text match FR-003/FR-004a; suite pins cover resolution order

### Tests

- [x] T006 [P] [US1] Add resolution/pointer schema assertions in `tests/repository-pointer.test.sh` (new) covering FR-003 order and FR-004a
- [x] T007 [P] [US1] Extend `tests/storage-contract.test.sh` for effective-root / pointer section presence and version 1.4.0

### Implementation

- [x] T008 [US1] Ensure `skills/highway-experience/references/storage-contract.md` and `SKILL.md` fully satisfy US1 acceptance (mode under effective root; no wrong-tree fallback)

**Checkpoint**: US1 contract testable via suite

---

## Phase 4: User Story 2 - Shared dual gate (P1)

**Goal**: One experience-owned setup-or-pointer gate; strip Oops blocks from owning skills

**Independent Test**: No Oops headline in owning skills; experience asset holds dual offer; catalog-seeding updated

### Tests

- [x] T009 [US2] Update `tests/catalog-seeding.test.sh` so owning skills must not embed Oops / old BODY; keep seeded-file confirm checks with domain-safe absent handling
- [x] T010 [P] [US2] Assert `skills/highway-experience/assets/repository-gate.md` dual-offer and setup-next-action blocks in `tests/repository-pointer.test.sh`

### Implementation

- [x] T011 [P] [US2] Strip Oops gate from `skills/highway-request/SKILL.md`; keep seeded-file check without dual gate
- [x] T012 [P] [US2] Strip Oops gate from `skills/highway-discovery/SKILL.md`
- [x] T013 [P] [US2] Strip Oops gate from `skills/highway-adr/SKILL.md`
- [x] T014 [P] [US2] Strip Oops gate from `skills/highway-architecture/SKILL.md`
- [x] T015 [P] [US2] Strip Oops gate from `skills/highway-implementation/SKILL.md`
- [x] T016 [P] [US2] Strip Oops gate from `skills/highway-onboarding/SKILL.md`
- [x] T017 [P] [US2] Strip Oops gate from `skills/highway-codify/SKILL.md`
- [x] T018 [P] [US2] Strip Oops gate from `skills/highway-codify-config/SKILL.md`
- [x] T019 [P] [US2] Strip Oops gate from `skills/highway-assessment/SKILL.md`
- [x] T020 [US2] Document setup-here vs non-setup handoff and bind-continue in `skills/highway-experience/SKILL.md` + `assets/repository-gate.md` (FR-007a–c)

**Checkpoint**: Dual gate only via experience; owning skills stop cleanly on not-ready

---

## Phase 5: User Story 3 - Persist URL and local path (P1)

**Goal**: Pointer persistence + gitignore rules + URL-only stop

**Independent Test**: Gate asset + storage contract pin persist/gitignore/URL-only; repository-pointer tests

### Tests

- [x] T021 [P] [US3] Add persist/gitignore/URL-only pins to `tests/repository-pointer.test.sh`

### Implementation

- [x] T022 [US3] Complete persist, gitignore, URL-only, and invalid-path copy/procedure in `skills/highway-experience/assets/repository-gate.md` and `SKILL.md`

**Checkpoint**: Persistence and URL-only behaviors specified and tested statically

---

## Phase 6: User Story 4 - Knowledge-only naming (P2)

**Goal**: Reserve pointer files for knowledge root only

**Independent Test**: Contract states knowledge-only; test asserts non-use for product code

- [x] T023 [P] [US4] Assert knowledge-only reservation wording in `tests/repository-pointer.test.sh` against `skills/highway-experience/references/storage-contract.md`
- [x] T024 [US4] Ensure storage-contract pointer section states Phase 16 / product-code exclusion in `skills/highway-experience/references/storage-contract.md`

---

## Phase 7: User Story 5 - Preserve cwd-as-root (P2)

**Goal**: Absent pointers keep today's behavior

**Independent Test**: Full suite passes; no forced dual gate when cwd is knowledge root

- [x] T025 [US5] Confirm `tests/run-all.sh` passes with existing fixtures (no pointer files required)
- [x] T026 [US5] Add cwd-as-root / absent-pointer regression pin in `tests/repository-pointer.test.sh` or `tests/storage-contract.test.sh`

---

## Phase 8: Polish

- [x] T027 Regenerate plugin with `framework/generate-agent-plugin.sh` so `highway-agent-plugin/skills/` matches
- [x] T028 [P] Update `tests/experience-activation.test.sh` if it lists experience assets/references that must include `assets/repository-gate.md`
- [x] T029 Run `tests/run-all.sh` and fix remaining failures
- [x] T030 Mark quickstart validation notes in `specs/258-highway-repository-pointer/quickstart.md` if commands differ

---

## Dependencies & Execution Order

- Phase 1 → Phase 2 (blocks all stories)
- US1 (Phase 3) before or with US2; US2 owns skill stripping
- US3 depends on gate asset from Phase 2 / US2
- US4/US5 after contract text stable
- Polish last (plugin regen + full suite)

### Parallel opportunities

- T011–T019 owning-skill strips in parallel after T009 contract for catalog-seeding is clear
- T006/T007, T010/T021 test file edits carefully (same `repository-pointer.test.sh` — serialize those)

## Implementation Strategy

MVP: Phase 1–3 (contract + experience resolve). Then US2 skill strips + tests. Then US3–5 + plugin regen + full suite.
