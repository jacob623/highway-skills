---
description: "Task list for Claude Bash Failures (F33 recovery)"
---

# Tasks: Claude Bash Failures

**Input**: Design documents from `specs/255-claude-bash-failures/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required (FR-006, D3.3–D3.6). Observe each new test failing before the code that
makes it pass.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

- [X] T001 Run baseline `bash tests/run-all.sh` and `npm --prefix harness test` before the first code edit (D3.1); record totals in Notes.
- [X] T002 Create `specs/255-claude-bash-failures/harness/` for committed logs.

**Checkpoint**: Baseline green; log folder ready.

## Phase 2: Foundational (blocks every story)

- [X] T003 Confirm `models.claude` stays `claude-haiku-5-5` and judge stays Cursor/Luna in `harness/harness.config.json` (FR-003); note any drift here.
- [X] T004 Confirm deny-all-Bash and fatal refuse path remain the locked Phase 8 behavior in `harness/src/drivers/claude.ts` (FR-001); no Codex continue-after-refuse.

**Checkpoint**: Model/judge unchanged; enforcement lock confirmed.

## Phase 3: User Story 1 - Throwaway-home no-Bash guidance (P1) 🎯 MVP

**Goal**: Each Claude attempt writes Local-mode / no-Bash guidance into the throwaway home and
loads it via `settingSources: ["user"]` without weakening Bash refuse.

**Independent Test**: Unit tests for `prepareClaudeAgentHome` + drive `settingSources`; Bash
deny still fatal. Later live smokes (Phase 5).

### Tests (write first; observe fail)

- [X] T005 [P] [US1] Add failing tests in `harness/test/claude.test.ts` for: `prepareClaudeAgentHome` writes `join(home, ".claude", "CLAUDE.md")` with file-tool / no-Bash markers; drive `query` options use `settingSources: ["user"]`; `claudeAsk` still uses `settingSources: []` (contracts/claude-guidance.md, R1).
- [X] T006 [P] [US1] Keep/extend Bash deny coverage in `harness/test/claude.test.ts` so refuse stays denied and storage-fatal semantics are unchanged (FR-001); optionally assert clearer deny message naming file tools if that wording is added (R3).

### Implementation

- [X] T007 [US1] Add `CLAUDE_LOCAL_GUIDANCE` and `prepareClaudeAgentHome` in `harness/src/drivers/claude.ts` (R1–R2); call prepare once per attempt before `query`.
- [X] T008 [US1] Change Claude drive sessions to `settingSources: ["user"]` in `harness/src/drivers/claude.ts`; leave `claudeAsk` on `[]`; do not enable `"project"` or `"local"`.
- [X] T009 [US1] Optionally improve Bash deny `message` in `harness/src/drivers/claude.ts` to name Read/Write/Edit/Glob/Grep (not an exit gate; R3).
- [X] T010 [US1] Make T005–T006 pass; `npm --prefix harness test` and typecheck green.

**Checkpoint**: Guidance ships in throwaway home and loads; Bash still always refused.

## Phase 4: User Story 3 - Maintainer docs (P3)

**Goal**: README names throwaway-home guidance beside deny-all-Bash.

**Independent Test**: Read Claude section of `harness/README.md`.

- [X] T011 [P] [US3] Update `harness/README.md` Claude section: throwaway-home `.claude/CLAUDE.md` Local-mode / no-Bash guidance + `settingSources: ["user"]`; every Bash request still refused (FR-009).

**Checkpoint**: Docs match behavior.

## Phase 5: User Story 2 - Confirmation, findings, pass bar (P1)

**Goal**: Two smokes ≥14/16, one codify log, F33 updated/closed from evidence.

**Independent Test**: Logs under `specs/255-claude-bash-failures/harness/` and findings F33.

- [X] T012 Run final `npm --prefix harness test` and `npm --prefix harness run typecheck`.
- [X] T013 Run final `bash tests/run-all.sh` (D3.2); record totals in Notes.
- [X] T014 [US2] Run `--agent claude --smoke` → `specs/255-claude-bash-failures/harness/smoke-1.log` (≥14/16 or document miss).
- [X] T015 [US2] Run second smoke → `smoke-2.log` (≥14/16 or document miss).
- [X] T016 [US2] Run `--agent claude --skills highway-codify` → `codify.log` (no numeric floor).
- [X] T017 [US2] Redact secrets / raw temp absolute paths in the three logs (FR-008).
- [X] T018 [US2] Update `harness-model-findings.md` F33 (and new findings if needed): close only if both smokes ≥14/16 and Bash-driven `rejected-request` fails are fewer than Phase 8 baseline; else update Runs / Basis / Proposed resolution (FR-007).
- [X] T019 [US2] Mark Phase Status in `rollout-plan.md` from the confirming evidence.

**Checkpoint**: Confirmation complete; F33 closed or explicitly left open with evidence.

## Dependencies

T001 → T002 → T003/T004 → US1 (T005–T010) → US3 (T011) → polish/live US2 (T012–T019).
Live runs require green suite. T005–T006 before T007–T010. T009 optional.

## Parallel examples

- T005 and T006 (different test focuses).
- T003 and T004 (read-only confirmations).

## Implementation strategy

MVP: US1 guidance + settingSources + unit tests. Then README (US3). Then live confirmation and
findings (US2). Do not commit unless asked.

## Notes

**T001 / T012–T013**: harness tests 192→194 passed; typecheck clean; suite 87 passed, 0 failed
(after clearing interrupted probe leftovers in adapter trees).

**T003**: `models.claude` = `claude-haiku-5-5`; judge cursor / `gpt-5.6-luna`.

**T009**: Added `CLAUDE_BASH_DENY_MESSAGE` naming file tools (optional lever).

**T014–T019**: Live on `claude-haiku-5-5`, judge Cursor/Luna. Every attempt installed `highway`
(16 skills). Smoke 12/16 and 11/16 (missed ≥14/16); codify 18/28. `denied: shell` 8 and 10 vs
Phase 8 baseline 5 and 5 — not fewer. F33 left open with follow-up on guidance load path
(`systemPrompt` append). Logs scrubbed of `/private/var/folders` leaks in codify.log.
