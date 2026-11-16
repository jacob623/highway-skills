---
description: "Task list for Cursor Driver (rollout Phase 7)"
---

# Tasks: Cursor Driver

**Input**: Design documents from `specs/249-cursor-driver/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required (FR-016–FR-018, D3.3–D3.6). Observe each new test failing before the code that
makes it pass.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

- [X] T001 Run baseline `bash tests/run-all.sh` and `npm --prefix harness test` before the first code edit (D3.1); record totals in Notes.
- [X] T002 Add `@cursor/sdk` ^1.4.0 in `harness/package.json` and run `npm --prefix harness install`.

## Phase 2: Foundational (blocks every story)

- [X] T003 Create `specs/249-cursor-driver/harness/` for committed logs.
- [X] T004 Choose `models.cursor` via `Cursor.models.list` with `CURSOR_API_KEY` and set it in `harness/harness.config.json` (FR-003, R6).

**Checkpoint**: Dependency installed; model pinned; log folder ready.

## Phase 3: User Story 2 - Registry plug-in (P1) 🎯 MVP core

**Goal**: One Cursor driver file and registry entry; runner unchanged aside from accepting `cursor`.

**Independent Test**: `npm --prefix harness test` with fake SDK; `--agent cursor` resolves.

### Tests (write first; observe fail)

- [X] T005 [P] [US2] Add failing tests in `harness/test/cursor.test.ts` for: AccessRequest mapping, install PluginRpc (success/short/warning/disabled), classifier (retryable/rate-limit/no-access), versions, and registry acceptance of `cursor` in `harness/test/agents.test.ts` (FR-016, FR-017).
- [X] T006 [P] [US2] Add failing test that `cursorAsk` uses no tools / throwaway home (FR-016).

### Implementation

- [X] T007 [US2] Implement `harness/src/drivers/cursor.ts`: PluginRpc copy-install, HOME mutex, hooks, stream mapping stubs, `classifyCursorError`, `cursorVersions`, `cursorAsk`, `cursorDriver` core (R1–R8, R10).
- [X] T008 [US2] Register `cursor` in `harness/src/agents.ts` per data-model.md.
- [X] T009 [US2] Make T005–T006 pass; confirm Copilot tests still pass; typecheck.

**Checkpoint**: `--agent cursor` is registered; unit tests green for registry/install/ask/classifier.

## Phase 4: User Story 1 - Smoke-capable driver (P1)

**Goal**: Driver enforces storage rules and can complete smoke attempts.

**Independent Test**: Fake SDK policy + effects tests; later live smoke (Phase 7).

### Tests

- [X] T010 [P] [US1] Extend `harness/test/cursor.test.ts` for hooks/policy decisions and effects-based failure when a forbidden `tool_call` completes (FR-010, FR-016).

### Implementation

- [X] T011 [US1] Complete permission hooks + effects enforcement and event→transcript mapping in `harness/src/drivers/cursor.ts` so smoke can run (R3, R5).
- [X] T012 [US1] Make T010 pass.

**Checkpoint**: Policy and effects covered by unit tests.

## Phase 5: User Story 3 - Questions and turns (P2)

**Goal**: Reply loop answers questions; each reply is one send + wait.

**Independent Test**: Fake SDK turn/question tests.

- [X] T013 [P] [US3] Add failing tests in `harness/test/cursor.test.ts` for reply-loop question handling and one send/wait per turn (R4, FR-008).
- [X] T014 [US3] Finish turn loop in `harness/src/drivers/cursor.ts`; make T013 pass.

**Checkpoint**: Question path covered without interactive ask tool.

## Phase 6: User Story 5 - Docs and governance (P3)

- [X] T015 [P] [US5] Update `harness/README.md` with Cursor key, model, install, policy notes, likely-cause rows (FR-022).
- [X] T016 [P] [US5] Amend `.specify/memory/constitution.md` Harness Toolchain for `@cursor/sdk` with MINOR bump to 3.8.0 (FR-023).

## Phase 7: Polish, suite, live runs, findings (US1 + US4 + US5)

- [X] T017 Run final `npm --prefix harness test` and `npm --prefix harness run typecheck`.
- [X] T018 Run final `bash tests/run-all.sh` (D3.2); record totals.
- [X] T019 [US1] Run `--agent cursor --smoke` → `specs/249-cursor-driver/harness/smoke-1.log` (FR-019).
- [X] T020 [US1] Run second smoke → `smoke-2.log`.
- [X] T021 [US4] Run `--agent cursor --skills highway-codify` → `codify.log`.
- [X] T022 [US4] Update `harness-model-findings.md` with “Cursor driver smoke for spec 249” and Runs/new findings (FR-021).
- [X] T023 [US5] Mark Phase 7 Status in `rollout-plan.md`; record outcome in `standard-alignment.md` (FR-024). Confirm Phase 20 remains.

## Dependencies

T001 → T002 → T003/T004 → US2 (T005–T009) → US1 policy (T010–T012) → US3 (T013–T014) → US5 docs
(T015–T016) → polish/live (T017–T023). Live runs require green suite.

## Parallel examples

- T005 and T006 (different test focuses).
- T015 and T016 (different docs).

## Implementation strategy

MVP: US2 registry + driver skeleton with install/ask. Then policy (US1), questions (US3), docs
(US5), then live US1/US4 exit.

## Notes

**T001 baseline (D3.1)**: `npm --prefix harness test` 147 passed, 0 failed; `bash tests/run-all.sh` 87 passed, 0 failed.

**T004**: Listed models with the key; maintainer chose `gpt-5.6-luna` (same as Copilot) for `models.cursor`.

**T017–T018**: harness tests 157 passed; typecheck clean; suite 87 passed, 0 failed.

**T019–T023**: Live runs on `gpt-5.6-luna`. Smoke 0/16 then 1/16; codify 4/28. Findings F27/F29.
Phase 7 Status written; Phase 20 remains.
