---

description: "Task list for Standard Alignment Catalog Seeding (Phase 8)"
---

# Tasks: Standard Alignment Catalog Seeding

**Input**: Design documents from `specs/237-standard-alignment-catalog-seeding/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Requested by the spec (FR-005, FR-006, FR-013, FR-014, FR-020); new checks are seeded before they are counted (D3.6).

**Organization**: Grouped by user story. US1–US3 are P1; US4–US6 are P2. Phase 2 moves the files every story depends on.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

- [X] T001 Confirm the baseline bash suite passed (`/tmp/hw-baseline-237.log`), then run the harness TypeScript tests in `harness/` and record the count
- [X] T002 Record every skill's and fixture's `framework/validate-skill.sh --no-cache` verdict to `/tmp/hw237-verdicts-before.txt` (D3.4)

---

## Phase 2: Foundational (blocking)

- [X] T003 Create `skills/highway-setup/assets/` and write the 11 catalog skeletons from the templates' empty baselines, plus `storage.md` (contract `seeding.md`); verify each holds no `<placeholder>` and no data row
- [X] T004 [P] `mv` `objective-catalog.md`, `control-catalog.md`, and `nfr-catalog.md` from `.highway/library/templates/output/` to the `assets/` of highway-objectives, highway-controls, and highway-nfrs
- [X] T005 Update `framework/lib/paths.sh`: add `HW_SETUP` and `hw_seeded`; point the 11 catalog arms and a new `storage` arm of `hw_template` at `$HW_SETUP/assets/`, and the three governance arms at their skills' `assets/`; remove `HW_KNOWLEDGE` and `hw_doc assessment-findings`
- [X] T006 Update `harness/bin/template-check.sh` with skeleton mode (research R8), and probe it with a skeleton copy missing a header column
- [X] T007 Update `rc_check_P9_1` in `framework/lib/rule-checks.sh` to accept the skill's own `assets/` and seeded-only Outputs (research R7)

**Checkpoint**: `hw_template` resolves every name; the template check passes each skeleton against itself.

---

## Phase 3: User Story 1 — Setup leaves every catalog in place (P1)

**Goal**: highway-setup seeds the 12 files at the start of every run, silently.

- [X] T008 [US1] Update `skills/highway-setup/SKILL.md`: `### Seed` before `### Welcome`, the asset-to-path table, Purpose, Inputs, Outputs (citing `assets/`), Verification, Error Handling; MINOR version
- [X] T009 [US1] Update `harness/scenarios/highway-setup/setup-smoke.scenario` and `chain-setup.scenario`: `writes:` for the seeded paths, and `template` expectations for all 12 in setup-smoke

**Checkpoint**: setup's text matches contract `seeding.md`.

---

## Phase 4: User Story 3 — Skills edit the seeded files instead of creating them (P1)

**Goal**: nine skills check at entry; no skill creates a seeded file.

- [X] T010 [US3] Write `tests/catalog-seeding.test.sh` (contract `entry-check.md` and `seeding.md`), and observe it failing on the unchanged skills
- [X] T011 [US3] Add the entry check to highway-request, highway-discovery, highway-adr, highway-architecture, highway-implementation, highway-onboarding, highway-codify, highway-codify-config, and highway-assessment
- [X] T012 [US3] Remove create-when-absent and write-whole-file-from-template steps for seeded files (highway-implementation `platforms`, highway-codify-config `accept` and standards write)

---

## Phase 5: User Story 2 — Each catalog's rules live in the skills that write it (P1)

- [X] T013 [US2] Create `framework/shared-rules/capability-title.txt` and `adr-id-cell.txt` (contract `shared-rules.md`); write `tests/shared-rules.test.sh` and observe it failing
- [X] T014 [US2] Move each seeded template's rule prose into its writing skills, replacing "The catalog follows `<template>`." (research R5): request, discovery, adr, architecture, implementation (catalog, capabilities, platforms), codify (catalog, integrations), codify-config (platforms, standards), assessment (findings)
- [X] T015 [US2] Put the capability title rule line in highway-architecture and highway-implementation and the ADR ID cell rule line in highway-architecture and highway-adr; replace every "Title rule in `<template>`" reference

---

## Phase 6: User Story 4 — Catalog ownership follows Phase 1 (P2)

- [X] T016 [US4] highway-codify-config: drop the capability template and the title check (step 5 and its Verification line); edit codify-platforms and coding-standards rows in place
- [X] T017 [US4] highway-onboarding: drop the ADR catalog and codify-platforms templates from Inputs; its ADR row edits the existing file
- [X] T018 [US4] highway-adr: drop the architecture catalog template; it edits only the ADR ID cell

---

## Phase 7: User Story 5 — Governance catalogs and the findings file (P2)

- [X] T019 [P] [US5] highway-objectives, highway-controls, highway-nfrs: name `assets/<name>-catalog.md` in Inputs, Outputs, Procedure, and Verification; MINOR version
- [X] T020 [US5] highway-assessment: read and write `library/knowledge/assessment-findings.md`, drop the template, state the findings rules; remove `.highway/library/knowledge/`
- [X] T021 [US5] Remove the 11 seeded catalog templates from `.highway/library/templates/output/` and their `framework/.distribution-manifest` rows

---

## Phase 8: User Story 6 — Checks compare against the skeletons (P2)

- [X] T022 [US6] Harness `shows:` key: `harness/src/scenario.ts`, `checks.ts`, `runner.ts`, tests in `harness/test/`, `tests/harness-scenarios.test.sh` KEYS, `harness/README.md` (contract `harness-shows.md`)
- [X] T023 [US6] Add `harness/scenarios/highway-request/request-setup-needed.scenario`
- [X] T024 [US6] Add the seeded files to each stage fixture; map `library/knowledge/assessment-findings.md` and `library/knowledge/storage.md` in `harness/fixtures/templates.map`; repoint `assessment-smoke.scenario`
- [X] T025 [US6] Repoint every bash test that read a catalog template to the skill or skeleton that now holds the text; update `tests/output-template.test.sh`, `harness-path-map.test.sh`, and `path-construction.test.sh` for the new locations

---

## Phase 9: Polish & Cross-Cutting

- [X] T026 Bump the MINOR version of every changed skill; regenerate `.highway/catalog/index.json` and the agent adapters; confirm a second run changes nothing
- [X] T027 Amend `framework/constitution.md` to 10.3.0 (P9.1 Observable) with its Sync Impact Report
- [X] T028 [P] Update `README.md`, `framework/README.md`, `framework/authoring-standard.md`, `harness/README.md`, and `standard-alignment.md` (Phase 8 complete; Phase 1 and 8 text per the Clarifications)
- [X] T029 Compare validator verdicts with `/tmp/hw237-verdicts-before.txt` (D3.4); sweep for stale references to the removed templates and `.highway/library/knowledge/`
- [X] T030 Run the full bash suite, the harness TypeScript tests, and tsc; build the distribution and confirm the skeletons and governance assets ship and no removed template does

## Dependencies

- Phase 2 blocks every story. T005 blocks T006, T009, T024, T025.
- US1 (T008) and US3 (T010–T012) can proceed in parallel; US2 (T013–T015) edits the same skills as US3, so it runs after.
- US4 and US5 follow US2. US6 follows US1, US3, and US5.
- Polish follows everything.
