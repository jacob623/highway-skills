# Tasks: Cursor Experience Order

**Input**: Design documents from `/specs/250-cursor-experience-order/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Required by FR-007 / FR-008 (observe failing before complete).

**Organization**: Grouped by user story (US1 activation mapping, US2 install/load proof, US3 live + findings).

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: US1 / US2 / US3
- Include exact file paths in descriptions

## Phase 1: Setup

**Purpose**: Baseline before harness edits

- [x] T001 Run `bash tests/run-all.sh` and record the pass count before edits
- [x] T002 Run `npm --prefix harness test` and record the pass count before edits

---

## Phase 2: Foundational

**Purpose**: Shared helpers the stories use; no story complete until wired into the driver

**⚠️ CRITICAL**: Finish helper stubs + failing tests before marking US1 implementation done

- [x] T003 Add exported stubs `skillIdFromCursorTool` and `normalizeCursorPluginPath` in `harness/src/drivers/cursor.ts` (empty/wrong behavior until US1)
- [x] T004 [P] Add failing unit tests for skill-id extraction and path normalization in `harness/test/cursor.test.ts` per `contracts/activation-mapping.md` (observe fail before T007–T009)

**Checkpoint**: Foundation helpers exist; new tests fail for the right reason

---

## Phase 3: User Story 1 - Cursor records highway-experience before output (P1) 🎯 MVP

**Goal**: Map Cursor plugin reads / skill ids into `skillsBeforeOutput` so experience-order can pass when highway-experience activates first.

**Independent Test**: Fake Cursor stream: approved read of `highway-experience/SKILL.md` (including a workspace-rooted plugin path) before assistant text → experience-order passes; output-first still fails; `/highway/skills/` does not become skill `skills`.

### Tests for User Story 1

- [x] T005 [P] [US1] Failing test: `skillIdFromCursorTool` returns `highway-experience` from `…/highway/skills/highway-experience/SKILL.md`, not `skills`, in `harness/test/cursor.test.ts`
- [x] T006 [P] [US1] Failing driver test: fake `tool_call` read of experience SKILL.md before assistant text yields `skillsBeforeOutput` containing `highway-experience`; assistant-first still fails experience invariant path in `harness/test/cursor.test.ts`

### Implementation for User Story 1

- [x] T007 [US1] Implement `skillIdFromCursorTool` in `harness/src/drivers/cursor.ts`
- [x] T008 [US1] Implement `normalizeCursorPluginPath` and use it in `noteTool` before `permissionPolicy` in `harness/src/drivers/cursor.ts`
- [x] T009 [US1] Wire corrected skill recording into `noteTool` (replace false regex) in `harness/src/drivers/cursor.ts`
- [x] T010 [US1] Map `glob` / `grep` / `ls` to path-scoped `read` in `toolCallToAccessRequest` in `harness/src/drivers/cursor.ts`
- [x] T011 [US1] Confirm T005–T006 pass; keep Copilot tests green via `npm --prefix harness test`

**Checkpoint**: US1 unit-proven; no live runs required yet

---

## Phase 4: User Story 2 - Install still proves skills are present (P1)

**Goal**: Install checks stay strict; load remains proven (16 skills); path fix does not weaken install.

**Independent Test**: Existing install unit tests still require name `highway` and exact skill count; normalization only remaps plugin-suffix paths onto the install read root.

### Tests for User Story 2

- [x] T012 [P] [US2] Test: normalize + policy approves a `<work>/.cursor/plugins/local/highway/skills/…` style path against the install read root in `harness/test/cursor.test.ts`
- [x] T013 [P] [US2] Test: install still fails when skill count is short in `harness/test/cursor.test.ts` (existing or extended)

### Implementation for User Story 2

- [x] T014 [US2] Verify `cursorPluginRpc` / `installPlugin` path unchanged except for read-path normalization consumers in `harness/src/drivers/cursor.ts`
- [x] T015 [US2] Run `npm --prefix harness test` — install and activation cases pass

**Checkpoint**: US2 satisfied without weakening install

---

## Phase 5: User Story 3 - Findings and live records close F29 (P2)

**Goal**: One confirmation cycle; update findings; resolve F29 only on zero `actual no skill`.

**Independent Test**: Three logs under `specs/250-cursor-experience-order/harness/`; F29 section matches the gate.

### Implementation for User Story 3

- [x] T016 [US3] Run `bash tests/run-all.sh` after harness changes (exit 0)
- [x] T017 [US3] Run `--agent cursor --smoke` → `specs/250-cursor-experience-order/harness/smoke-1.log`
- [x] T018 [US3] Run `--agent cursor --smoke` → `specs/250-cursor-experience-order/harness/smoke-2.log`
- [x] T019 [US3] Run `--agent cursor --skills highway-codify` → `specs/250-cursor-experience-order/harness/codify.log`
- [x] T020 [US3] Update `harness-model-findings.md` (F29 / F27 / residual per FR-010)
- [x] T021 [US3] Note Phase 7 Status follow-up in `rollout-plan.md` when F29 resolves
- [x] T022 [US3] Add a brief Cursor activation/mapping note to `harness/README.md` if the Cursor section still describes the broken regex path

**Checkpoint**: Confirmation cycle done; F29 resolved or left open with evidence

---

## Phase 6: Polish

- [x] T023 [P] Run `npm --prefix harness run typecheck`
- [x] T024 Confirm no skill/template/fixture/scenario edits; secrets absent from logs
- [x] T025 Validate `quickstart.md` checklist mentally against completed work

---

## Dependencies & Execution Order

### Phase Dependencies

- Setup → Foundational → US1 → US2 → US3 → Polish
- US2 overlaps US1 file (`cursor.ts` / `cursor.test.ts`) — run after US1 implementation
- US3 live runs require US1+US2 tests green and bash suite green

### Parallel Opportunities

- T005 / T006 in parallel before implementation
- T012 / T013 in parallel after US1
- T023 / T024 in parallel during polish

### MVP

US1 (T005–T011) is the MVP: mapping fix proven in unit tests.

---

## Implementation Strategy

1. Baseline suite + harness tests
2. Failing activation tests
3. Implement mapping + normalization + glob/grep/ls mapping
4. Install/path approval tests
5. Full suite + one live confirmation cycle + findings

## Notes

- No commit unless asked
- Do not chase a second live cycle for Copilot pass parity
- If live logs still show `actual no skill` after the fix, leave F29 open (do not won’t-fix)
