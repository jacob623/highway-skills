---
description: "Task list for Codex Driver (rollout Phase 9)"
---

# Tasks: Codex Driver

**Input**: Design documents from `specs/252-codex-driver/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required (FR-008, driver/registry tests, D3.3–D3.6). Observe each new test failing
before the code that makes it pass.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

- [X] T001 Run baseline `bash tests/run-all.sh` and `npm --prefix harness test` before the first code edit (D3.1); record totals in Notes.
- [X] T002 Add `@openai/codex-sdk` in `harness/package.json` and run `npm --prefix harness install` (R10).

## Phase 2: Foundational (blocks every story)

- [X] T003 Create `specs/252-codex-driver/harness/` for committed logs.
- [X] T004 Choose `models.codex` via Codex model list with the API key; prefer `gpt-5.6-luna` or closest Luna/GPT-5.6 id; set in `harness/harness.config.json` and document mapping in `specs/252-codex-driver/research.md` if not exact (FR-004, R6).
- [X] T005 Set `judge.agent` to `cursor` and judge model to Luna in `harness/harness.config.json` (FR-005a).

**Checkpoint**: Dependency installed; model pinned; judge Cursor/Luna; log folder ready.

## Phase 3: User Story 2 - Registry plug-in (P1) 🎯 MVP core

**Goal**: One Codex driver file and registry entry; runner unchanged aside from accepting `codex`.

**Independent Test**: `npm --prefix harness test` with fake Codex SDK; `--agent codex` resolves.

### Tests (write first; observe fail)

- [X] T006 [P] [US2] Add failing tests in `harness/test/codex.test.ts` for: AccessRequest mapping, install PluginRpc (success/short/warning/disabled), classifier (retryable/rate-limit/no-access), versions, and registry acceptance of `codex` in `harness/test/agents.test.ts`.
- [X] T007 [P] [US2] Add failing test that `codexAsk` uses no plugin / throwaway home (FR-005).

### Implementation

- [X] T008 [US2] Implement `harness/src/drivers/codex.ts`: PluginRpc install under throwaway `CODEX_HOME`/`HOME`, thread options (workspace-write, network off, skipGitRepoCheck), stream mapping stubs, `classifyCodexError`, `codexVersions`, `codexAsk`, `codexDriver` core (R1–R7, R9).
- [X] T009 [US2] Register `codex` in `harness/src/agents.ts` per data-model.md.
- [X] T010 [US2] Make T006–T007 pass; confirm Copilot/Cursor tests still pass; typecheck.

**Checkpoint**: `--agent codex` is registered; unit tests green for registry/install/ask/classifier.

## Phase 4: User Story 3 - Storage enforcement (P1)

**Goal**: Effects-based enforcement + storage-contract MINOR for shell-as-file-tool.

**Independent Test**: Unit tests for allow/fail table; regenerated plugin after skill bump.

### Tests

- [X] T011 [P] [US3] Extend `harness/test/codex.test.ts` for: allowed project read; allowed project write; allowed in-project build/test; outside write fails; `git` fails; network-facing install fails (FR-008).

### Implementation

- [X] T012 [US3] Complete effects classification + sandbox/approval wiring in `harness/src/drivers/codex.ts` (FR-001, R3).
- [X] T013 [US3] Add Local-mode shell-as-file-tool wording to `skills/highway-experience/references/storage-contract.md`; MINOR bump highway-experience; regenerate adapters/plugin/catalog (FR-002).
- [X] T014 [US3] Make T011 pass.

**Checkpoint**: Enforcement covered by unit tests; storage contract regenerated.

## Phase 5: User Story 1 - Smoke-capable driver (P1)

**Goal**: Driver can complete smoke attempts under enforcement with install checks.

**Independent Test**: Fake SDK end-to-end attempt path; later live smoke (Phase 8).

- [X] T015 [US1] Finish event→transcript / skills / usage mapping in `harness/src/drivers/codex.ts` so smoke can run (R4, FR-006, FR-007).
- [X] T016 [US1] Add/adjust tests if needed for skill activation via SKILL.md path and usage; make them pass.

**Checkpoint**: Driver ready for live smoke.

## Phase 6: User Story 4 - Questions and turns (P2)

**Goal**: Reply loop answers questions; each reply is one send + wait.

**Independent Test**: Fake SDK turn/question tests.

- [X] T017 [P] [US4] Add failing tests in `harness/test/codex.test.ts` for reply-loop question handling and one send/wait per turn (FR-010, R5).
- [X] T018 [US4] Finish turn loop in `harness/src/drivers/codex.ts`; make T017 pass.

**Checkpoint**: Question path covered without interactive ask tool.

## Phase 7: User Story 5 - Docs and governance (P3)

- [X] T019 [P] [US5] Update `harness/README.md` with Codex key(s), model, install, enforcement notes, likely-cause rows.
- [X] T020 [P] [US5] Amend `.specify/memory/constitution.md` Harness Toolchain for `@openai/codex-sdk` with MINOR bump to 3.9.0.

## Phase 8: Polish, suite, live runs, findings (US1 + US4 + US5)

- [X] T021 Run final `npm --prefix harness test` and `npm --prefix harness run typecheck`.
- [X] T022 Run final `bash tests/run-all.sh` (D3.2); record totals.
- [X] T023 [US1] Run `--agent codex --smoke` → `specs/252-codex-driver/harness/smoke-1.log`.
- [X] T024 [US1] Run second smoke → `smoke-2.log`.
- [X] T025 [US4] Run `--agent codex --skills highway-codify` → `codify.log`.
- [X] T026 [US4] Update `harness-model-findings.md` with Codex smoke section and Runs/new findings.
- [X] T027 [US5] Mark Phase 9 Status in `rollout-plan.md`; record outcome in `standard-alignment.md`.

## Dependencies

T001 → T002 → T003/T004/T005 → US2 (T006–T010) → US3 (T011–T014) → US1 mapping (T015–T016) →
US4 (T017–T018) → US5 docs (T019–T020) → polish/live (T021–T027). Live runs require green suite.

## Parallel examples

- T006 and T007 (different test focuses).
- T019 and T020 (different docs).

## Implementation strategy

MVP: US2 registry + driver skeleton with install/ask. Then enforcement + storage-contract (US3),
smoke mapping (US1), questions (US4), docs (US5), then live US1/US4 exit.

## Notes

**T001 baseline**: harness tests 163 passed (pre-Codex); suite later green at 87/87 after cleanup of
accidental root `package.json`/`node_modules` from a mis-scoped npm install.

**T004**: Pinned `models.codex` = `gpt-5.6-luna` (exact Luna id; no remap).

**T021–T022**: harness tests 175 passed; typecheck clean; suite 87 passed, 0 failed.

**T023–T027**: Live runs on `gpt-5.6-luna`, judge Cursor/Luna, parallel 4. Every attempt installed
`highway` (16 skills). Smoke 0/16 then 0/16; codify 0/28 — dominant F31 (`git` via `/bin/zsh -lc`).
Phase 9 Status written; F31 opened in findings.
