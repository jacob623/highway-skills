---

description: "Task list for Standard Alignment Onboarding Handoffs (Phase 10)"
---

# Tasks: Standard Alignment Onboarding Handoffs

**Input**: Design documents from `specs/239-standard-alignment-onboarding-handoffs/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Requested by the spec (FR-015, FR-016, FR-020). New checks are seeded before they are counted (D3.6).

**Organization**: Grouped by user story. US1 and US2 are P1, US3 and US4 are P2, and US5 is P3. Phase 2 moves the templates every story depends on.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

- [X] T001 Run the baseline bash suite to `/tmp/hw-baseline-239.log` and the harness TypeScript tests in `harness/`; record both counts (D3.1)
- [X] T002 Record every skill's and fixture's `framework/validate-skill.sh --no-cache` verdict to `/tmp/hw239-verdicts-before.txt` with `/tmp/hw238-verdicts.sh` (D3.4)

---

## Phase 2: Foundational (blocking)

- [X] T003 Copy the 3 templates to `/tmp/hw239-templates/`, then `mv` each from `.highway/library/templates/output/` to `skills/highway-adr/assets/`, `skills/highway-architecture/assets/`, and `skills/highway-implementation/assets/`, and `cmp` each against its copy (research R6)
- [X] T004 Point the 3 `hw_template` arms in `framework/lib/paths.sh` at `$HW_SKILLS/<owner>/assets/<file>.md`

**Checkpoint**: `hw_template` resolves all 14 record names to existing files; `.highway/library/templates/output/` holds no file.

---

## Phase 3: User Story 1 — Onboarding hands each record to its owner (P1)

**Goal**: each owner has an `onboarding` entry step, and highway-onboarding hands off ADR → RA → RI and holds no record rules.

**Independent Test**: `tests/onboarding-handoffs.test.sh` passes, and its seeded probe (the routing sentence removed from a copy of highway-adr) fails.

- [X] T005 [US1] Write `tests/onboarding-handoffs.test.sh` per research R9, with the instrument, artifact, and probe header lines. Run it and record the failure before any skill edit (D3.6)
- [X] T006 [P] [US1] In `skills/highway-adr/SKILL.md`, add the routing sentence, the When to use line, the procedure order, the `### onboarding` step per contracts/onboarding-entry-steps.md, the `highway` Discovery ID exemption, and the Verification bullets. Bump MINOR to 6.3.0
- [X] T007 [P] [US1] In `skills/highway-architecture/SKILL.md`, add the routing sentence, the When to use line, the procedure order, the `### onboarding` step with the FR-021 title-question limit and decline, and the Verification bullets. Bump MINOR to 5.4.0
- [X] T008 [P] [US1] In `skills/highway-implementation/SKILL.md`, add the routing sentence, the When to use line, the procedure order, the `### onboarding` step (Execution `Needed`, `platforms`, return only to onboarding), and the Verification bullets. Bump MINOR to 7.12.0
- [X] T009 [US1] In `skills/highway-onboarding/SKILL.md`:
  - rewrite `orchestrate` as hand-offs with one retry and a decline stop;
  - drop the ADR rules, the id derivation, the architecture and implementation rules, "Do not use highway-adr", and the template input and Outputs citation;
  - keep the execution return, the included line, the configure question, and review edits;
  - move the record Verification and Error Handling bullets to the owners;
  - bump MINOR to 10.9.0.
- [X] T010 [US1] Repoint the moved onboarding assertions to their owners (research R9): `tests/adr-record-completeness.test.sh`, `tests/multiple-reference-implementations.test.sh`, `tests/code-project.test.sh`, `tests/delivery-platform-handoff.test.sh`, and `tests/codify-platform-catalog.test.sh`
- [X] T011 [US1] Run `onboarding-handoffs`, the five repointed tests, `configure-handoff`, `codify-config-skill`, `establish-from-record`, `single-noun-capabilities`, `static-highway-capability`, and `onboarding-*`. Validate the four skills with `framework/validate-skill.sh --no-cache`

**Checkpoint**: the four skills validate. highway-onboarding names no template and no id derivation.

---

## Phase 4: User Story 2 — Templates live only with their owners (P1)

**Goal**: no skill, script, test, or harness file names `.highway/library/`, and the folder is gone.

**Independent Test**: `tests/record-templates.test.sh` passes for 14 owners and fails on its seeded probes; `rg '\.highway/library' skills framework/lib harness/bin harness/src` finds nothing.

- [X] T012 [P] [US2] Name `assets/<file>.md` in the Inputs, Outputs, and `write` of `skills/highway-adr/SKILL.md`, `skills/highway-architecture/SKILL.md`, and `skills/highway-implementation/SKILL.md`. Drop highway-architecture's adr-record input and highway-adr's architecture-record input (FR-007)
- [X] T013 [US2] Extend `tests/record-templates.test.sh` to 14 owners, with `.highway/library` absent and no skill naming `.highway/library/`. Drop `HW_OUTPUT_TEMPLATES`
- [X] T014 [US2] Remove `HW_LIBRARY` and `HW_OUTPUT_TEMPLATES` from `framework/lib/paths.sh`, and update their last users:
  - `framework/lib/validation-cache.sh`;
  - `tests/library-containment.test.sh`;
  - `tests/profile-convergence-behavior.test.sh`;
  - `tests/adr-span-progression.test.sh`, `tests/establish-from-record.test.sh`, `tests/record-purpose-titles.test.sh`, and `tests/single-noun-capabilities.test.sh` (`hw_template`).
- [X] T015 [US2] Update `tests/output-template.test.sh`: adr names `assets/adr-record.md`, and no skill cites `.highway/library/templates/output/`
- [X] T016 [US2] Remove the P9.1 library branch in `framework/lib/rule-checks.sh` and fix its message. Remove `tests/fixtures/output-template/`. Seed-check P9.1 against a skill citing the old path (D3.6)
- [X] T017 [US2] In `harness/bin/path-map.sh`, remove `REL_LIBRARY` and its arm. Update `tests/harness-path-map.test.sh` and `harness/test/select.test.ts` per research R8
- [X] T018 [US2] Remove the `.highway/library` rows from `framework/.distribution-manifest`, then remove the empty `.highway/library/` folders

**Checkpoint**: `record-templates`, `output-template`, `harness-path-map`, `rule-checks`, and `path-construction` pass.

---

## Phase 5: User Story 3 — The ADR catalog names the architecture (P2)

**Goal**: `name` sets the ADR's Reference Architecture field and its catalog Architecture ID on every path.

**Independent Test**: the `name` assertions in `tests/onboarding-handoffs.test.sh` pass, and `tests/catalog-seeding.test.sh` sees `adrs/adrs.md` in highway-architecture's seeded check.

- [X] T019 [US3] In `skills/highway-architecture/SKILL.md`:
  - `name` sets the field and the ADR catalog Architecture ID in one write;
  - the seeded check adds `adrs/adrs.md`;
  - update When not to use, Outputs, Verification, and Error Handling.
  Update `tests/adr-record-completeness.test.sh` and `tests/catalog-seeding.test.sh` to match.

---

## Phase 6: User Story 4 — The execution chain returns to the original visit (P2)

**Goal**: the inner implementation step returns to onboarding, and onboarding returns to `execution`.

**Independent Test**: the nested-return assertions in `tests/onboarding-handoffs.test.sh` pass.

- [X] T020 [US4] Confirm that the nested-return sentence in `skills/highway-implementation/SKILL.md` `onboarding` and the `execution` return in `skills/highway-onboarding/SKILL.md` `orchestrate` match contracts/onboarding-entry-steps.md. Confirm the `establish-from-record` and `onboarding-handoffs` assertions hold

---

## Phase 7: User Story 5 — Checks and scenarios cover the handoffs (P3)

**Goal**: the harness covers the three records, the catalog id, and the execution chain.

**Independent Test**: `tests/harness-scenarios.test.sh` and `tests/harness-fixtures.test.sh` pass, and the harness TypeScript tests pass.

- [X] T021 [P] [US5] Update `harness/scenarios/highway-onboarding/onboarding-smoke.scenario`: add three `through:` lines, three `template` expects, and `expect: row adrs/adrs.md :: RA0`
- [X] T022 [P] [US5] Add `expect: row adrs/adrs.md :: RA0` to `harness/scenarios/highway-architecture/chain-architecture.scenario`
- [X] T023 [P] [US5] Add `harness/scenarios/highway-implementation/implementation-onboards-platform.scenario` per research R10
- [X] T024 [US5] Run `tests/harness-scenarios.test.sh`, `tests/harness-fixtures.test.sh`, and the harness TypeScript tests

---

## Phase 8: Polish & Cross-Cutting

- [X] T025 Regenerate with `bash framework/generate-catalog.sh && bash framework/generate-agent-adapters.sh`, then check that a second run leaves no diff
- [X] T026 [P] Update `README.md`, `framework/README.md`, `framework/authoring-standard.md`, and `harness/README.md` for the new arrangement (FR-019)
- [X] T027 Sweep `rg '\.highway/library' skills framework harness tests` and `rg 'templates/output' skills`. Only history and absence guards may remain
- [X] T028 Record verdicts after to `/tmp/hw239-verdicts-after.txt` and diff against before. Only the removed orphan fixtures and the four changed skills may differ, with no new FAIL (D3.4)
- [X] T029 Run the full suite (85 expected), the harness TypeScript tests, and `tsc`, then build the distribution to `/tmp/hw-dist-239` and confirm each template ships inside its skill
- [X] T030 Mark Phase 10 complete in `standard-alignment.md` with a status note, and mark these tasks `[X]`

---

## Dependencies

- Phase 2 blocks every story.
- US1 (T005–T011) comes before US2's skill edits (T012), because both edit the same skills.
- US3 (T019) and US4 (T020) follow US1.
- US5 (T021–T024) needs US1, so the scenario steps match the skill text.
- Polish comes last.

## Parallel Opportunities

- T006, T007, and T008 edit different files.
- T021, T022, and T023 edit different scenarios.
- T026's document edits are independent of each other.

## Implementation Strategy

MVP: Phase 2 with US1, which delivers the handoffs. US2 then empties the library, US3 and US4 tighten the chain, and US5 adds harness coverage. Validate at each checkpoint.
