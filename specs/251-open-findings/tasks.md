---
description: "Task list for Open Findings (F18, F20, F23, F28)"
---

# Tasks: Open Findings

**Input**: Design documents from `specs/251-open-findings/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required for F23/F28 (FR-005). Observe each new test failing before the code that makes it pass (D3.6).

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

- [X] T001 Create `specs/251-open-findings/harness/` for committed confirmation logs.
- [X] T002 Run baseline `bash tests/run-all.sh` and `npm --prefix harness test` before the first product edit (D3.1); record totals in Notes.

---

## Phase 2: Foundational

**Purpose**: No shared schema work; keep a light gate so stories stay ordered.

- [X] T003 Confirm research decisions R1–R6 in `specs/251-open-findings/research.md` match the planned file edits (no further research blockers).

**Checkpoint**: Log folder ready; baseline recorded; research locked.

---

## Phase 3: User Story 1 - Discovery template header (F18) (P1) 🎯 MVP

**Goal**: Skill text requires keeping the Example Realization Matrix header row when empty.

**Independent Test**: Read `skills/highway-discovery/references/options.md`; regenerate; suite green.

- [X] T004 [US1] Add the F18 bullet after the keep-every-heading guidance in `skills/highway-discovery/references/options.md` (FR-001, FR-002 wording).
- [X] T005 [US1] Bump `skills/highway-discovery/SKILL.md` metadata.version MINOR `5.8.0` → `5.9.0`.
- [X] T006 [US1] Run `framework/generate-agent-adapters.sh` and `framework/generate-agent-plugin.sh` so generated trees and `highway-agent-plugin/` match; confirm a second plugin `--check` is clean (Correspondence).

**Checkpoint**: Source + generated copies carry the Example Realization Matrix rule.

---

## Phase 4: User Story 2 - Harness text checks (F23, F28) (P1)

**Goal**: `shows:` ignores backticks; `contains-any` ignores case.

**Independent Test**: New unit tests in `harness/test/checks.test.ts` pass; README updated.

### Tests (write first; observe fail)

- [X] T007 [P] [US2] Add failing unit test in `harness/test/checks.test.ts` that backtick-wrapped skill text satisfies plain `shows:` and different words still fail (F23, FR-003, FR-005).
- [X] T008 [P] [US2] Add failing unit test in `harness/test/checks.test.ts` that `contains-any` matches across capitalization (F28, FR-004, FR-005).

### Implementation

- [X] T009 [US2] Update `showsFailures` in `harness/src/checks.ts` to strip backticks (F23).
- [X] T010 [US2] Update `contains-any` in `harness/src/checks.ts` to compare case-insensitively; leave `contains` unchanged (F28).
- [X] T011 [US2] Make T007–T008 pass; run `npm --prefix harness test` and typecheck.
- [X] T012 [P] [US2] Document `contains-any` case-insensitivity (and backtick stripping for `shows` if needed) in `harness/README.md` (FR-005).

**Checkpoint**: F23/F28 unit evidence green; no scenario file changes.

---

## Phase 5: User Story 3 - Shorter attempt paths (F20) (P2)

**Goal**: Shorter work/home/project paths without weakening isolation or deny rules.

**Independent Test**: Harness unit tests still pass; path rewriter still redacts new roots.

- [X] T013 [US3] Change work-root prefix and home directory layout in `harness/src/runner.ts` per `contracts/path-layout.md` (`hh-`, `h/`, short attempt labels).
- [X] T014 [US3] Change project directory layout in `harness/src/project.ts` per `contracts/path-layout.md` (`p/`, short labels).
- [X] T015 [US3] Adjust any harness tests that hard-code `homes/` / `projects/` / `highway-harness-` path segments if they break; keep `npm --prefix harness test` green.

**Checkpoint**: Layout shortened; isolation and rewriter still valid.

---

## Phase 6: User Story 4 - Suite, live confirmation, findings (P3)

**Goal**: Green suite; confirmation logs; findings closed or updated per clarify rules.

**Independent Test**: Logs under `specs/251-open-findings/harness/`; Harness Failures section matches evidence.

- [X] T016 Run final `npm --prefix harness test` and `npm --prefix harness run typecheck`.
- [X] T017 Run final `bash tests/run-all.sh` (D3.2); record totals in Notes.
- [X] T018 [US4] Copilot `--smoke` → `specs/251-open-findings/harness/smoke-copilot.log` (FR-010).
- [X] T019 [US4] Cursor `--agent cursor --smoke` → `smoke-cursor-1.log`.
- [X] T020 [US4] Second Cursor `--smoke` → `smoke-cursor-2.log`.
- [X] T021 [US4] Cursor targeted `--paths` for discovery-smoke, codify-configure, objectives-smoke, request-smoke, setup-smoke scenario files → `targeted-cursor.log`.
- [X] T022 [US4] Update `harness-model-findings.md`: remove F23/F28 when unit evidence holds; remove F18 only if smokes clear the header check; resolve or update F20 per count comparison; add unexplained new findings (FR-011).
- [X] T023 [P] [US4] Optionally note follow-up Status in `rollout-plan.md` (FR-012). Confirm committed logs hold no secrets or tmp absolute paths (SC-006).

---

## Dependencies

T001–T003 → US1 (T004–T006) and US2 (T007–T012) can proceed in parallel after foundation → US3 (T013–T015) → polish/live (T016–T023). Live runs require green suite (T016–T017).

## Parallel examples

- T007 and T008 (both add tests in checks.test.ts — prefer sequential if same file conflicts; marked [P] only if split carefully).
- US1 (skill) and US2 (harness checks) after T003.
- T023 docs alongside findings edit if desired.

## Implementation strategy

MVP: F18 skill text + regenerate. Then F23/F28 harness checks with TDD. Then F20 path layout. Then suite + full confirmation matrix + findings.

## Notes

_(Baseline and final suite totals recorded during implement.)_

**T002/T017**: harness unit tests 163 passed; bash suite 87 passed, 0 failed after regenerate.

**Live (T018–T023)**: Copilot smoke 16/16; Cursor smoke-1 14/16 (1 flaky); Cursor smoke-2 13/16; targeted 5/5 (2 flaky). Closed F18/F20/F23/F28; opened F30. Logs scrubbed of raw tmp paths.
