# Tasks: Remove Repository Name

**Input**: Design documents from `specs/262-remove-repository-name/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/remove-repository-name-instructions.md, quickstart.md

**Tests**: Included. Constitution D3.3 requires a test edit for this behavioral change. The test checks instruction presence. It is not executed agent behavior (D3.8).

**Organization**: Tasks follow user-story order. Profile skill edits share one file, so those tasks stay sequential where they touch the same path.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1–US4)

## Phase 1: Setup

**Purpose**: Confirm the files the contract names are the ones to edit.

- [x] T001 Confirm the contract paths in `specs/262-remove-repository-name/contracts/remove-repository-name-instructions.md` match `skills/highway-profile/SKILL.md`, `skills/highway-profile/assets/profile-record.md`, `skills/highway-onboarding/references/proposal.md`, `skills/highway-objectives/SKILL.md`, `skills/highway-controls/SKILL.md`, and `skills/highway-nfrs/SKILL.md`

---

## Phase 2: Foundational

**Purpose**: The instruction check that must fail before skill text changes.

**⚠️ CRITICAL**: No skill wording task is complete until this test has been seen failing.

- [x] T002 Add `tests/remove-repository-name.test.sh` with instrument class `static-document-contract` and artifact class `source-document`, requiring each sentence in `specs/262-remove-repository-name/contracts/remove-repository-name-instructions.md`, and record that the test fails before those sentences exist

**Checkpoint**: The test fails on missing instructions.

---

## Phase 3: User Story 1 - Profile opens with the organization name (Priority: P1) 🎯 MVP

**Goal**: The first guided question asks for the organization's name. Decline and unknown re-ask. Offer uses Organization Name and routes to Identity without a post-offer organization-name step.

**Independent Test**: `skills/highway-profile/SKILL.md` has the first-question wording, re-ask rules, and offer routes without Repository Name or a post-offer `organization-name` hop.

### Implementation for User Story 1

- [x] T003 [US1] Replace the repository-name `name` step with the organization-name first question, decline/unknown re-ask, offer `[Organization Name]` routes to Identity, remove `### organization-name`, and set `metadata.version` to `14.7.0` in `skills/highway-profile/SKILL.md`

**Checkpoint**: Guided Profile opens on the organization name.

---

## Phase 4: User Story 2 - The Profile record keeps no Repository Name (Priority: P1)

**Goal**: The record skeleton and write path omit Repository Name and store Organization Name from the first question.

**Independent Test**: `skills/highway-profile/assets/profile-record.md` has no `### Repository Name`. Profile write instructions omit Repository Name.

### Implementation for User Story 2

- [x] T004 [P] [US2] Remove `### Repository Name` from `skills/highway-profile/assets/profile-record.md` and set template `metadata.version` to `3.2.0`
- [x] T005 [US2] Update write and verification lines in `skills/highway-profile/SKILL.md` so a guided write stores Organization Name and omits Repository Name

**Checkpoint**: New Profile records have no Repository Name.

---

## Phase 5: User Story 3 - Later skills name the organization only (Priority: P1)

**Goal**: Onboarding, objectives, controls, and NFRs use Organization Name only.

**Independent Test**: Those files contain no Repository Name fallback.

### Implementation for User Story 3

- [x] T006 [P] [US3] Remove the Repository Name fallback from `skills/highway-onboarding/references/proposal.md` and set `metadata.version` to `10.15.0` in `skills/highway-onboarding/SKILL.md`
- [x] T007 [P] [US3] Remove the Repository Name fallback from `skills/highway-objectives/SKILL.md` and set `metadata.version` to `8.10.0`
- [x] T008 [P] [US3] Remove the Repository Name fallback from `skills/highway-controls/SKILL.md` and set `metadata.version` to `8.9.0`
- [x] T009 [P] [US3] Remove the Repository Name fallback from `skills/highway-nfrs/SKILL.md` and set `metadata.version` to `9.10.0`

**Checkpoint**: Naming skills use Organization Name only.

---

## Phase 6: User Story 4 - Profile review stays ordinary (Priority: P2)

**Goal**: Review keeps show-and-validate behavior with no Organization Name migration prompt.

**Independent Test**: `skills/highway-profile/SKILL.md` `### review` has no migration prompt for a missing Organization Name.

### Implementation for User Story 4

- [x] T010 [US4] Confirm `### review` in `skills/highway-profile/SKILL.md` remains ordinary show-and-validate with no migration prompt, and add a verification line that review has no organization-name migration prompt

**Checkpoint**: Review is unchanged for migration.

---

## Phase 7: Polish & Cross-Cutting

**Purpose**: Align related tests, bump the plugin, regenerate, and run the finish order.

- [x] T011 [P] Update `tests/org-offering-boundary.test.sh` for Profile `14.7.0` and remove Repository Name instruction requirements that no longer apply
- [x] T012 [P] Update `tests/harness-failure-resolutions.test.sh` offer and error-handling routes to Identity without `organization-name`
- [x] T013 [P] Update `tests/output-template.test.sh` so Context headings omit `### Repository Name`
- [x] T014 Set `framework/plugin/plugin.json` version to `0.1.4`, regenerate catalog, adapters, and plugin, then run `bash tests/run-all.sh --exclude-plugin-gen` and `bash tests/run-all.sh --plugin-gen-only`

---

## Dependencies & Execution Order

### Phase Dependencies

- Setup → Foundational (failing test) → US1 → US2 → US3 (parallel across files) → US4 → Polish

### User Story Dependencies

- **US1**: After Foundational
- **US2**: After US1 (shared Profile skill write lines) for T005; T004 can parallel after US1
- **US3**: After Foundational; independent of US1/US2 file-wise once Profile naming line is settled; can run after US1
- **US4**: After US1 Profile edits

### Parallel Opportunities

- T006–T009 in parallel
- T011–T013 in parallel after skill edits
- T004 parallel with US3 once US1 done

## Implementation Strategy

1. T001–T002: observe failing instruction test
2. T003: Profile first question (MVP)
3. T004–T005: record and write
4. T006–T009: naming skills
5. T010: review verification
6. T011–T014: tests, plugin finish order
