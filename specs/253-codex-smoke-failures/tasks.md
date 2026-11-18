# Tasks: Codex Smoke Failures

**Input**: Design documents from `/specs/253-codex-smoke-failures/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by FR-007 (unit coverage for refuse/guidance/load without a live key).

**Organization**: Tasks grouped by user story (US1 git pre-refuse, US2 skill load, US3 confirmation).

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: US1 / US2 / US3
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Baseline and feature folders before edits

- [X] T001 Run `bash tests/run-all.sh` and `npm --prefix harness test` from repo root; record baseline green before driver edits
- [X] T002 [P] Ensure `specs/253-codex-smoke-failures/harness/` exists for live logs

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Shared helpers and exports needed by US1/US2

**⚠️ CRITICAL**: No user story work until this phase is complete

- [X] T003 Add throwaway-home prep helpers (write `rules/default.rules` forbidding `git`, write Local-mode `AGENTS.md`) in `harness/src/drivers/codex.ts` (or a small colocated helper module under `harness/src/drivers/` if cleaner)
- [X] T004 Export or unit-testable surfaces for git fatal-vs-nonfatal classification from `harness/src/drivers/codex.ts` for harness tests

**Checkpoint**: Foundation ready — US1/US2 can proceed

---

## Phase 3: User Story 1 - Codex stops failing smoke on forbidden git (Priority: P1) 🎯 MVP

**Goal**: Pre-refuse git via Codex rules + non-fatal denial; completed git still fatal; throwaway guidance required

**Independent Test**: Unit tests for rules/guidance files and git completed vs non-completed fatal; compare behavior to [contracts/git-pre-refuse.md](contracts/git-pre-refuse.md)

### Tests for User Story 1

- [X] T005 [P] [US1] Add failing unit tests for throwaway `rules/default.rules` and `AGENTS.md` content in `harness/test/codex.test.ts`
- [X] T006 [P] [US1] Add failing unit tests: git + non-completed → non-fatal; git + completed → fatal in `harness/test/codex.test.ts`

### Implementation for User Story 1

- [X] T007 [US1] Wire throwaway-home rules + `AGENTS.md` into attempt setup in `harness/src/drivers/codex.ts` before thread start
- [X] T008 [US1] Implement git pre-refuse vs completed-fatal semantics in `harness/src/drivers/codex.ts` (`noteAccess` / classification) so runner fatal filter matches the contract
- [X] T009 [US1] Make T005–T006 pass; keep outside-path and network-install effects-fatal unchanged in `harness/src/drivers/codex.ts`

**Checkpoint**: US1 unit-testable without a live key

---

## Phase 4: User Story 2 - Highway skills usable in the Codex attempt (Priority: P1)

**Goal**: Fix install/load if staging alone is insufficient so skills are discoverable mid-attempt

**Independent Test**: Install path still passes shared checks; `readRoots` / plugin enablement documented or fixed in `harness/src/drivers/codex.ts`; unit coverage where possible

### Tests for User Story 2

- [X] T010 [P] [US2] Add or extend unit tests for plugin install/load expectations after FR-003 fix in `harness/test/codex.test.ts`

### Implementation for User Story 2

- [X] T011 [US2] Verify/fix Codex plugin staging under throwaway home in `harness/src/drivers/codex.ts` (CLI `plugin marketplace add` / `plugin add` if filesystem staging insufficient; keep name `highway`, 16 skills, enabled)
- [X] T012 [US2] Ensure experience skill reads under install `readRoots` are recorded in `harness/src/drivers/codex.ts` (shell-as-file-tool paths included)

**Checkpoint**: US2 load path ready for live confirmation

---

## Phase 5: User Story 3 - Confirmation, findings, and pass bar (Priority: P2)

**Goal**: Two smokes ≥9/16, one codify log, findings/F31 updated

**Independent Test**: Logs under `specs/253-codex-smoke-failures/harness/` and Harness Failures section per [contracts/live-runs.md](contracts/live-runs.md)

### Implementation for User Story 3

- [X] T013 [US3] Run suite + harness tests green after US1/US2 (`bash tests/run-all.sh`, `npm --prefix harness test`, `npm --prefix harness run typecheck`)
- [X] T014 [US3] Run live `--agent codex --smoke` → `specs/253-codex-smoke-failures/harness/smoke-1.log` (redact secrets/temp abs paths); require ≥9/16 or document miss
- [X] T015 [US3] Run live `--agent codex --smoke` → `specs/253-codex-smoke-failures/harness/smoke-2.log` (same bar)
- [X] T016 [US3] Run live `--agent codex --skills highway-codify` → `specs/253-codex-smoke-failures/harness/codify.log` (no numeric floor; map failures)
- [X] T017 [US3] Update `harness-model-findings.md` (F31 close or refresh; new findings if needed) from confirming logs vs Phase 9 baseline
- [X] T018 [P] [US3] Update `harness/README.md` and `rollout-plan.md` Status for this phase as needed

**Checkpoint**: Confirmation artifacts and findings match FR-005–FR-008

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Docs and final validation

- [X] T019 [P] Align `specs/253-codex-smoke-failures/quickstart.md` with actual commands if they drifted
- [X] T020 Confirm FR-009 on committed logs (no secrets, no raw temp absolute paths) under `specs/253-codex-smoke-failures/harness/`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup — BLOCKS US1/US2
- **US1 (Phase 3)**: After Foundational — MVP
- **US2 (Phase 4)**: After Foundational; can follow or parallelize carefully with US1 (same `codex.ts` — prefer sequential after US1)
- **US3 (Phase 5)**: After US1 + US2 + green tests
- **Polish (Phase 6)**: After US3 logs exist

### User Story Dependencies

- **US1 (P1)**: No dependency on US2
- **US2 (P1)**: Independent goal; shares `codex.ts` with US1 → implement after US1 to avoid merge conflicts
- **US3 (P2)**: Depends on US1 + US2 for meaningful live results

### Parallel Opportunities

- T002 || baseline note; T005 || T006; T018 || findings; T019 || T020 after logs

---

## Parallel Example: User Story 1

```bash
# Tests in parallel:
Task: "Add failing unit tests for rules/AGENTS.md in harness/test/codex.test.ts"
Task: "Add failing unit tests for git fatal vs non-fatal in harness/test/codex.test.ts"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Setup + Foundational
2. US1 tests → implementation → unit green
3. Validate contract semantics without live key

### Incremental Delivery

1. US1 → pre-refuse + guidance
2. US2 → skill load fix
3. US3 → live smokes + codify + findings
4. Polish log hygiene / quickstart

---

## Notes

- No commit unless a person asks
- Do not weaken Local bans; pre-refuse git only
- Skill content edits out of scope by default
- Close F31 only when both smokes ≥9/16 and git-driven fails < Phase 9 baseline
