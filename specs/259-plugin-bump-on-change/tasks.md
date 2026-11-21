# Tasks: Plugin Bump on Change

**Input**: Design documents from `specs/259-plugin-bump-on-change/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Spec requires suite guards; test tasks are included for US1/US2.

**Organization**: By user story (US1 finish order / suite flags, US2 version-bump guard, US3 docs + constitution).

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: [US1], [US2], [US3]

## Phase 1: Setup

**Purpose**: Confirm design paths and closed list names

- [x] T001 Confirm closed list names `plugin-version-bump.test.sh` and `agent-plugin.test.sh` match `specs/259-plugin-bump-on-change/contracts/suite-plugin-gen-list.md`

---

## Phase 2: Foundational

**Purpose**: Suite runner support for exclude/only (needed by US1 and polish)

- [x] T002 Extend `tests/run-all.sh` with mutually exclusive `--exclude-plugin-gen` and `--plugin-gen-only` using the closed list from `contracts/suite-plugin-gen-list.md`

**Checkpoint**: `bash tests/run-all.sh --help` or usage error documents both flags; dry invocation with `--plugin-gen-only` attempts only those two files once they exist

---

## Phase 3: User Story 1 - Finish order / suite flags (P1) 🎯 MVP

**Goal**: Maintainers can run excluded full suite and plugin-gen-only per finish order

**Independent Test**: `bash tests/run-all.sh --exclude-plugin-gen` skips closed list; `--plugin-gen-only` runs only closed list

- [x] T003 [US1] Document finish-order commands in `framework/README.md` linking exclude → bump → regenerate → `--plugin-gen-only` (promote separate; harness only if already required)
- [x] T004 [US1] Verify `tests/run-all.sh --exclude-plugin-gen` and `--plugin-gen-only` against the closed list once both tests exist (depends on T002, T005)

**Checkpoint**: US1 suite flags usable

---

## Phase 4: User Story 2 - Version-bump guard (P1)

**Goal**: Suite fails when covered inputs change without a greater semver; drift remains in `agent-plugin.test.sh`

**Independent Test**: Seed covered-input change without bump → `plugin-version-bump.test.sh` fails; bump → passes version condition; version-only exempt; missing `main` fail-closed

- [x] T005 [US2] Implement `tests/plugin-version-bump.test.sh` per `contracts/version-bump-guard.md` and `data-model.md` (merge-base, working tree+index, covered paths, semver, version-only exempt, fail closed)
- [x] T006 [US2] Ensure `tests/plugin-version-bump.test.sh` is discovered by default `tests/run-all.sh` (no exclude)
- [x] T007 [US2] Confirm `tests/agent-plugin.test.sh` remains the package-currency member (existing `--check`); no open-ended extra members

**Checkpoint**: US2 guards enforceable

---

## Phase 5: User Story 3 - Docs and Spec Kit constitution (P2)

**Goal**: Highway docs + `.specify/memory/constitution.md` encode finish order

**Independent Test**: Readme + constitution state finish order; no change to `framework/constitution.md` or Spec Kit upstream skills

- [x] T008 [P] [US3] Complete finish-order and closed-list prose in `framework/README.md` (if not fully done in T003)
- [x] T009 [US3] Amend `.specify/memory/constitution.md` (MINOR) for finish-order / plugin version currency; Sync Impact Report; do not amend `framework/constitution.md`

**Checkpoint**: US3 docs/constitution complete

---

## Phase 6: Polish

- [x] T010 Run `bash tests/plugin-version-bump.test.sh` and `bash tests/run-all.sh --plugin-gen-only`
- [x] T011 Run `bash tests/run-all.sh --exclude-plugin-gen` (spot-check skips closed list)
- [x] T012 Walk `specs/259-plugin-bump-on-change/quickstart.md` and fix drift

---

## Dependencies & Execution Order

- T001 → T002 → T005 → T006/T007 → T004
- T003/T008 can parallel with T005 after T002
- T009 after design lock (can parallel with T005)
- T010–T012 after T002–T009

### User Story dependencies

- US1: T002–T004
- US2: T005–T007 (MVP with US1)
- US3: T008–T009

### MVP

T001–T007 (suite flags + version-bump guard + closed list)

## Parallel opportunities

- T003 ∥ T005 after T002
- T008 ∥ T009

## Implementation strategy

1. Foundational run-all flags  
2. Version-bump test  
3. Docs + Spec Kit constitution  
4. Quickstart validation  
