---
description: "Task list for Claude Code Driver (rollout Phase 8)"
---

# Tasks: Claude Code Driver

**Input**: Design documents from `specs/254-claude-code-driver/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required (FR-016–FR-018, driver/registry tests, D3.3–D3.6). Observe each new test
failing before the code that makes it pass.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

- [X] T001 Run baseline `bash tests/run-all.sh` and `npm --prefix harness test` before the first code edit (D3.1); record totals in Notes.
- [X] T002 Add `@anthropic-ai/claude-agent-sdk` in `harness/package.json` and run `npm --prefix harness install` (R10).

## Phase 2: Foundational (blocks every story)

- [X] T003 Create `specs/254-claude-code-driver/harness/` for committed logs.
- [X] T004 Pin `models.claude` to `claude-haiku-5-5` in `harness/harness.config.json` (FR-003, R8); if live listing rejects it, remap to the closest Haiku the key can use and note it here.
- [X] T005 Confirm `judge.agent` stays `cursor` and judge model Luna in `harness/harness.config.json` (no change unless drifted).

**Checkpoint**: Dependency installed; Haiku pinned; judge Cursor/Luna; log folder ready.

## Phase 3: User Story 2 - Registry plug-in (P1) 🎯 MVP core

**Goal**: One Claude driver file and registry entry; runner unchanged aside from accepting `claude`.

**Independent Test**: `npm --prefix harness test` with fake Claude Agent SDK; `--agent claude` resolves.

### Tests (write first; observe fail)

- [X] T006 [P] [US2] Add failing tests in `harness/test/claude.test.ts` for: AccessRequest mapping (Read/Write/Edit/Glob/Grep/Bash/WebFetch/other), install PluginRpc (success/short/warning/disabled), classifier (rate-limit/no-access/allowance), versions, and registry acceptance of `claude` in `harness/test/agents.test.ts` / `harness/test/config.test.ts`.
- [X] T007 [P] [US2] Add failing test that `claudeAsk` uses no plugin / throwaway home (FR-004).

### Implementation

- [X] T008 [US2] Implement `harness/src/drivers/claude.ts`: PluginRpc install under throwaway `CLAUDE_CONFIG_DIR`/`HOME`, `query()` options (`settingSources: []`, plugins local path, model, env), stream mapping stubs, `classifyClaudeError`, `claudeVersions`, `claudeAsk`, `claudeDriver` core (R1–R11).
- [X] T009 [US2] Register `claude` in `harness/src/agents.ts` per data-model.md.
- [X] T010 [US2] Make T006–T007 pass; confirm Copilot/Cursor/Codex tests still pass; typecheck.

**Checkpoint**: `--agent claude` is registered; unit tests green for registry/install/ask/classifier.

## Phase 4: User Story 2 continued - Permission enforcement (P1)

**Goal**: `canUseTool` enforces Local rules; every Bash denied.

**Independent Test**: Unit tests for allow/deny table including Bash always denied.

### Tests

- [X] T011 [P] [US2] Extend `harness/test/claude.test.ts` for: allowed project read; allowed project write; allowed plugin read; outside write denied; **Bash always denied**; WebFetch denied when web off (FR-010, FR-016).

### Implementation

- [X] T012 [US2] Complete `canUseTool` + tool→AccessRequest mapping in `harness/src/drivers/claude.ts` (FR-010, R3); effects backup if a forbidden tool runs without callback.
- [X] T013 [US2] Make T011 pass.

**Checkpoint**: Permission table covered by unit tests; Bash never allowed.

## Phase 5: User Story 1 - Smoke-capable driver (P1)

**Goal**: Driver can complete smoke attempts under enforcement with install checks.

**Independent Test**: Fake SDK end-to-end attempt path; later live smoke (Phase 8).

- [X] T014 [US1] Finish event→transcript / skills / usage mapping and resume-per-reply turns in `harness/src/drivers/claude.ts` so smoke can run (R5–R6, FR-005–FR-008).
- [X] T015 [US1] Add/adjust tests for Skill tool / `/highway:…` / experience SKILL.md path and usage; make them pass.

**Checkpoint**: Driver ready for live smoke.

## Phase 6: User Story 3 - Questions and turns (P2)

**Goal**: AskUserQuestion answered from scripted replies when present; otherwise reply loop; each reply is one resume send + wait.

**Independent Test**: Fake SDK AskUserQuestion + reply-loop tests.

- [X] T016 [P] [US3] Add failing tests in `harness/test/claude.test.ts` for AskUserQuestion answered on-session and unanswered question left to reply loop (FR-008, R4).
- [X] T017 [US3] Finish AskUserQuestion + turn/resume loop in `harness/src/drivers/claude.ts`; make T016 pass.

**Checkpoint**: Question paths covered.

## Phase 7: User Story 5 - Docs and governance (P3)

- [X] T018 [P] [US5] Update `harness/README.md` with Claude key, model (`claude-haiku-5-5`), install, policy notes (Bash always rejected), likely-cause rows.
- [X] T019 [P] [US5] Amend `.specify/memory/constitution.md` Harness Toolchain for `@anthropic-ai/claude-agent-sdk` with MINOR bump to 3.10.0.

## Phase 8: Polish, suite, live runs, findings (US1 + US4 + US5)

- [X] T020 Run final `npm --prefix harness test` and `npm --prefix harness run typecheck`.
- [X] T021 Run final `bash tests/run-all.sh` (D3.2); record totals.
- [X] T022 [US1] Run `--agent claude --smoke` → `specs/254-claude-code-driver/harness/smoke-1.log`.
- [X] T023 [US1] Run second smoke → `smoke-2.log`.
- [X] T024 [US4] Run `--agent claude --skills highway-codify` → `codify.log`.
- [X] T025 [US4] Update `harness-model-findings.md` with Claude Code driver section and Runs/new findings (no numeric pass floor).
- [X] T026 [US5] Mark Phase 8 Status in `rollout-plan.md`; record outcome in `standard-alignment.md`.

## Dependencies

T001 → T002 → T003/T004/T005 → US2 (T006–T013) → US1 mapping (T014–T015) → US3 (T016–T017) →
US5 docs (T018–T019) → polish/live (T020–T026). Live runs require green suite.

## Parallel examples

- T006 and T007 (different test focuses).
- T018 and T019 (different docs).

## Implementation strategy

MVP: US2 registry + driver skeleton with install/ask/permissions. Then smoke mapping (US1),
questions (US3), docs (US5), then live US1/US4 exit.

## Notes

**T001 baseline**: harness tests 179 passed; suite later confirmed green after implement.

**T002**: `@anthropic-ai/claude-agent-sdk` ^0.3.327 installed under `harness/`.

**T004**: Pinned `models.claude` = `claude-haiku-5-5` (exact current Haiku id; no remap).

**T020–T021**: harness tests 193 passed (after Bash tool_use ordering fix); typecheck clean;
suite 87 passed, 0 failed.

**T022–T026**: Live on `claude-haiku-5-5`, judge Cursor/Luna, parallel 4. Every attempt installed
`highway` (16 skills). Smoke 13/16 and 13/16; codify 18/28. Dominant F33 (Bash exploration →
rejected-request). Phase 8 Status written; F33 opened in findings.
