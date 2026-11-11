---

description: "Task list for Standard Alignment highway-experience (Phase 7)"
---

# Tasks: Standard Alignment highway-experience

**Input**: Design documents from `specs/236-standard-alignment-experience/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Requested by the spec (FR-008, FR-010, FR-019); test tasks are included and seeded before they are counted (D3.6).

**Organization**: Grouped by user story. US1–US3 are P1 and share the move in Phase 2; US4 is P2.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

- [X] T001 Confirm the baseline bash suite passed (`/tmp/hw236-baseline.log`: 82 passed, exit 0), then run the harness TypeScript tests in `harness/` and record the count
- [X] T002 Record every skill's and fixture's `framework/validate-skill.sh --no-cache` verdict to `/tmp/hw236-verdicts-before.txt` (D3.4)

---

## Phase 2: Foundational (blocking)

- [X] T003 Create `skills/highway-experience/references/` and `mv` `.highway/library/knowledge/highway-identity.md` and `.highway/governance/experience-standard.md` into it unchanged
- [X] T004 `mv` `.highway/governance/storage.md` to `skills/highway-experience/references/storage-contract.md` and remove the empty `.highway/governance/`
- [X] T005 Update `framework/lib/paths.sh`: add `HW_EXPERIENCE`; point the `experience-standard`, `storage`, and `highway-identity` arms of `hw_doc` at its references; remove `HW_GOVERNANCE`, `HW_INSTRUCTIONS`, `HW_CURSOR_RULES`, `HW_CLAUDE_MD`, `HW_COPILOT_MD`, `HW_AGENTS_MD`
- [X] T006 Update `framework/lib/validation-cache.sh` to hash `hw_doc experience-standard` in place of the governance folder
- [X] T007 Update `tests/path-construction.test.sh` rules R2 and R4 for the removed and added variables (R8)

**Checkpoint**: the validator still reads the Experience Standard's rules; `bash tests/path-construction.test.sh` passes.

---

## Phase 3: User Story 1 — Every skill gets Highway's guidance from highway-experience (P1)

**Goal**: highway-experience exists, and every other skill activates it first.

**Independent Test**: `bash tests/experience-activation.test.sh`; harness tests show the order check.

- [X] T008 [US1] Write `skills/highway-experience/SKILL.md` per [contracts/highway-experience.md](contracts/highway-experience.md), version 1.0.0
- [X] T009 [US1] Write `tests/experience-activation.test.sh` with the seeded probe; observe it fail on the current skills before T010
- [X] T010 [US1] For each of the 15 skills in `skills/*/SKILL.md`: insert the activation sentence as the first Procedure line (add `## Procedure` to highway-help), replace the old-path Inputs and attribution lines, and bump MINOR per research R3 (with highway-help's Example version)
- [X] T011 [P] [US1] Add `skillsBeforeOutput` to `harness/src/driver.ts` (R5)
- [X] T012 [P] [US1] Add `experienceInvariant` to `harness/src/checks.ts`, and the `experience-order` kind and cause to `harness/src/failure.ts`
- [X] T013 [US1] Apply the invariant in `harness/src/runner.ts` and set `skillsBeforeOutput` in the fallback result
- [X] T014 [US1] Add tests in `harness/test/checks.test.ts` and `harness/test/runner.test.ts` (seeded failure) and update fixtures that build a `DriveResult`
- [X] T015 [P] [US1] Add `harness/scenarios/highway-experience/experience-smoke.scenario` (R7)

**Checkpoint**: the activation test passes; the harness tests pass, including the seeded failure.

---

## Phase 4: User Story 2 — The storage rules ship with the skills (P1)

**Goal**: the storage contract carries the bundled-file exemption, the mode record, and the stop.

**Independent Test**: `bash tests/storage-contract.test.sh`.

- [X] T016 [US2] Edit `skills/highway-experience/references/storage-contract.md` per [contracts/storage-contract.md](contracts/storage-contract.md), version 1.1.0
- [X] T017 [US2] Update `tests/storage-contract.test.sh`: new location and wording, the added sentences, the agent-context section removed, the shipped-path classification

**Checkpoint**: the storage-contract test passes.

---

## Phase 5: User Story 3 — The always-on instructions are gone (P1)

**Goal**: no instruction source, generator, manifest, generated file, or test remains.

**Independent Test**: the quickstart's layout and distribution steps.

- [X] T018 [US3] Remove `.highway/instructions/`, `framework/generate-instructions.sh`, `framework/.instruction-manifest`, `AGENTS.md`, `.cursor/rules/highway-agent-context.mdc`, `.claude/CLAUDE.md`, `.github/copilot-instructions.md`
- [X] T019 [US3] Remove `tests/generate-instructions.test.sh` and `tests/instruction-coverage.test.sh`; drop the instruction sweep from `tests/run-all.sh`
- [X] T020 [US3] Update `framework/.distribution-manifest`: remove the six always-on and governance rows; add highway-experience rows for the four agent trees

**Checkpoint**: the files are absent and the distribution builds without them.

---

## Phase 6: User Story 4 — The repository's checks follow the new owner (P2)

**Goal**: generators, selection, tests, constitutions, and documents follow highway-experience.

**Independent Test**: regenerate with no diff; full suite; path map on each reference.

- [X] T021 [US4] Extend `framework/generate-agent-adapters.sh` to copy every file in a skill folder, with one manifest row and a drift check per file (R4)
- [X] T022 [US4] Update `tests/generate-agent-adapters.test.sh` (fixture `references/sample.md`, instruction guards) and `tests/adapter-coverage.test.sh` (per-file expectations, no instruction currency)
- [X] T023 [P] [US4] Update `harness/selection/shared.txt`, `harness/bin/path-map.sh`, and `tests/harness-path-map.test.sh` (R6)
- [X] T024 [P] [US4] Amend `framework/constitution.md` to 10.2.0 (P2.6, P10.1, the identity note, the Sync Impact Report)
- [X] T025 [P] [US4] Amend `.specify/memory/constitution.md` to 3.3.0 with its self-application review (R11)
- [X] T026 [P] [US4] Update `README.md`, `framework/README.md`, `framework/authoring-standard.md`, `harness/README.md`, and `governance-plan.md` (R12)
- [X] T027 [US4] Run `framework/generate-catalog.sh` and `framework/generate-agent-adapters.sh`; run them again to confirm no diff

**Checkpoint**: regeneration is stable.

---

## Phase 7: Polish & Cross-Cutting

- [X] T028 Sweep the repository (excluding `specs/` and history) for `.highway/governance`, `.highway/instructions`, `generate-instructions`, `instruction-manifest`, `HW_GOVERNANCE`, and `HW_INSTRUCTIONS`, and fix any live reference
- [X] T029 Compare the `--no-cache` verdicts against `/tmp/hw236-verdicts-before.txt` (only version lines differ)
- [X] T030 Run `bash tests/run-all.sh` (81 passed), then the harness TypeScript tests, and the quickstart's distribution check
- [X] T031 Mark Phase 7 complete in `standard-alignment.md` with a Status paragraph, and set the spec's Status to Complete

---

## Dependencies & Execution Order

- Phase 1 → Phase 2 → US1, US2, US3 (any order after Phase 2) → US4 → Polish.
- T009 precedes T010 so the test is seen failing first.
- T021 precedes T022 and T027; T020 precedes T027's distribution check in T030.
- T011 and T012 touch different files and can run together; T013 follows both.

## Parallel Example: User Story 4

```text
T023 harness selection   T024 skills constitution   T025 development constitution   T026 documents
```

## Implementation Strategy

US1–US3 are all P1 and land together: the move in Phase 2 breaks the old paths, so the suite is only
expected green after US4's regeneration. Validate at the Phase 6 checkpoint, then run the polish phase.
