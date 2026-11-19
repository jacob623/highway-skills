---
description: "Task list for Claude Bash Prompt (F33 session-start guidance)"
---

# Tasks: Claude Bash Prompt

**Input**: Design documents from `specs/256-claude-bash-prompt/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required (FR-006, D3.3–D3.6). Observe each new test failing before the code that
makes it pass.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

- [X] T001 Run baseline `bash tests/run-all.sh` and `npm --prefix harness test` before the first code edit (D3.1); record totals in Notes.
- [X] T002 Create `specs/256-claude-bash-prompt/harness/` for committed logs.

**Checkpoint**: Baseline green; log folder ready.

## Phase 2: Foundational (blocks every story)

- [X] T003 Confirm `models.claude` stays `claude-haiku-5-5` and judge stays Cursor/Luna in `harness/harness.config.json` (FR-003).
- [X] T004 Confirm deny-all-Bash and fatal refuse path remain locked in `harness/src/drivers/claude.ts` (FR-001).

**Checkpoint**: Model/judge unchanged; enforcement lock confirmed.

## Phase 3: User Story 1 - Session-start no-Bash guidance (P1) 🎯 MVP

**Goal**: Drive sessions append Local-mode / no-Bash guidance via `systemPrompt` and use
`settingSources: []` so guidance reaches the model without relying on home-file load.

**Independent Test**: Unit tests for `systemPrompt` append + `settingSources: []`; Bash deny
still fatal. Later live smokes (Phase 5).

### Tests (write first; observe fail)

- [X] T005 [P] [US1] Add failing tests in `harness/test/claude.test.ts` for: drive `query` options include `systemPrompt` preset `claude_code` with append containing file-tool / no-Bash markers; drive `settingSources` is `[]` (contracts/claude-session-guidance.md, R1).
- [X] T006 [P] [US1] Keep Bash deny coverage in `harness/test/claude.test.ts` (FR-001); keep `prepareClaudeAgentHome` supporting-file coverage if the writer remains.

### Implementation

- [X] T007 [US1] Set drive `systemPrompt: { type: "preset", preset: "claude_code", append: CLAUDE_LOCAL_GUIDANCE }` in `harness/src/drivers/claude.ts` (R1–R2).
- [X] T008 [US1] Set drive `settingSources: []` in `harness/src/drivers/claude.ts`; leave `claudeAsk` on `[]`; keep `prepareClaudeAgentHome` as supporting write only.
- [X] T009 [US1] Make T005–T006 pass; `npm --prefix harness test` and typecheck green.

**Checkpoint**: Session-start guidance ships; Bash still always refused.

## Phase 4: User Story 3 - Maintainer docs (P3)

**Goal**: README names session-start guidance beside deny-all-Bash.

**Independent Test**: Read Claude section of `harness/README.md`.

- [X] T010 [P] [US3] Update `harness/README.md` Claude section: session-start `systemPrompt` append + supporting throwaway-home file; `settingSources: []`; every Bash request still refused (FR-009).

**Checkpoint**: Docs match behavior.

## Phase 5: User Story 2 - Confirmation, findings, pass bar (P1)

**Goal**: Two smokes ≥14/16, one codify log, F33 updated/closed from evidence.

**Independent Test**: Logs under `specs/256-claude-bash-prompt/harness/` and findings F33.

- [X] T011 Run final `npm --prefix harness test` and `npm --prefix harness run typecheck`.
- [X] T012 Run final `bash tests/run-all.sh` (D3.2); record totals in Notes.
- [X] T013 [US2] Run `--agent claude --smoke` → `specs/256-claude-bash-prompt/harness/smoke-1.log` (≥14/16 or document miss).
- [X] T014 [US2] Run second smoke → `smoke-2.log` (≥14/16 or document miss).
- [X] T015 [US2] Run `--agent claude --skills highway-codify` → `codify.log` (no numeric floor).
- [X] T016 [US2] Redact secrets / raw temp absolute paths in the three logs (FR-008).
- [X] T017 [US2] Update `harness-model-findings.md` F33 (and new findings if needed): close only if both smokes ≥14/16 and Bash-driven fails fewer than Phase 8 baseline; else update Runs / Basis / Proposed resolution (FR-007).
- [X] T018 [US2] Mark Phase Status in `rollout-plan.md` from the confirming evidence.

**Checkpoint**: Confirmation complete; F33 closed or explicitly left open with evidence.

## Dependencies

T001 → T002 → T003/T004 → US1 (T005–T009) → US3 (T010) → polish/live US2 (T011–T018).
Live runs require green suite. T005–T006 before T007–T009.

## Parallel examples

- T005 and T006 (different test focuses).
- T003 and T004 (read-only confirmations).

## Implementation strategy

MVP: US1 systemPrompt append + settingSources [] + unit tests. Then README (US3). Then live
confirmation and findings (US2). Do not commit unless asked.

## Notes

**T001 / T011–T012**: harness tests 194 passed; typecheck clean; suite 87 passed, 0 failed.

**T003**: `models.claude` = `claude-haiku-5-5`; judge cursor / `gpt-5.6-luna`.

**T013–T018**: Live on Haiku + Cursor/Luna. Smoke **16/16** and **16/16** (`denied: shell` 0 / 0).
Codify **27/28** (0 Bash denials; one assertion exists on `codify-code-project`). F33 closed.
Logs clean of secrets / temp absolute paths.
