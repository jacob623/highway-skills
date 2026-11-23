# Tasks: Organization and Offering Boundary

**Input**: Design documents from `specs/261-org-offering-boundary/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/org-offering-instructions.md, quickstart.md

**Tests**: Included. Constitution D3.3 requires a test edit for this behavioral change. The test checks instruction presence. It is not executed agent behavior (D3.8).

**Organization**: Tasks follow user-story order. Profile edits share one file, so those tasks stay sequential.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1–US6)

## Phase 1: Setup

**Purpose**: Confirm the files the contract names are the ones to edit.

- [x] T001 Confirm the contract paths in `specs/261-org-offering-boundary/contracts/org-offering-instructions.md` match `skills/highway-profile/SKILL.md`, `skills/highway-experience/references/experience-standard.md`, `skills/highway-experience/SKILL.md`, `skills/highway-onboarding/SKILL.md`, `skills/highway-onboarding/references/proposal.md`, `skills/highway-objectives/SKILL.md`, and `skills/highway-assessment/SKILL.md`

---

## Phase 2: Foundational

**Purpose**: The instruction check that must fail before skill text changes.

**⚠️ CRITICAL**: No skill wording task is complete until this test has been seen failing.

- [x] T002 Add `tests/org-offering-boundary.test.sh` with instrument class `static-document-contract` and artifact class `source-document`, requiring each sentence in `specs/261-org-offering-boundary/contracts/org-offering-instructions.md`, and record that the test fails before those sentences exist

**Checkpoint**: The test fails on missing instructions.

---

## Phase 3: User Story 1 - Identity keeps the organization and its offerings apart (Priority: P1) 🎯 MVP

**Goal**: Identity states who the organization is in one finding and each generalized offering in its own finding.

**Independent Test**: `skills/highway-profile/SKILL.md` asks for the organization name once, names offerings from the person's category words, and does not pad findings to a count.

### Implementation for User Story 1

- [x] T003 [US1] Add the organization-name question, offering-name steps, and one-finding-per-subject rules to `skills/highway-profile/SKILL.md`, and set `metadata.version` to `14.6.0`

**Checkpoint**: Identity instructions are present. Vision, split, and later skills are still unchanged.

---

## Phase 4: User Story 2 - Vision names the organization or asks once (Priority: P1)

**Goal**: Future State names the organization. A mixed subject asks one question and emits no proposal in that message.

**Independent Test**: `skills/highway-profile/SKILL.md` contains the Future State rule and the mixed-subject exception to always-propose.

### Implementation for User Story 2

- [x] T004 [US2] Add the Future State and mixed-subject instructions to the domain rules in `skills/highway-profile/SKILL.md`

**Checkpoint**: Vision no longer always proposes when the subject is mixed.

---

## Phase 5: User Story 3 - A shared name does not collapse the subject (Priority: P1)

**Goal**: X2.73 requires the full organization name. Profile fills that token. No other skill copies the rule.

**Independent Test**: Experience Standard contains X2.73 at version `11.2.0`. Profile contains only the name-fill sentence.

### Implementation for User Story 3

- [x] T005 [P] [US3] Add X2.73, set version `11.2.0`, and name the addition in the provenance of `skills/highway-experience/references/experience-standard.md`; set `metadata.version` to `1.6.0` in `skills/highway-experience/SKILL.md`
- [x] T006 [US3] Add the organization-name and short-name fill sentence to `skills/highway-profile/SKILL.md`

**Checkpoint**: The shared-name obligation lives in the Experience Standard. Profile only chooses the name.

---

## Phase 6: User Story 4 - The split is accepted before the Profile is written (Priority: P1)

**Goal**: Profile restates the organization and each offering and writes only after acceptance.

**Independent Test**: `skills/highway-profile/SKILL.md` has a `split` step before `write`, and a merge that is not an explicit same-subject statement does not write.

### Implementation for User Story 4

- [x] T007 [US4] Add the `split` step before `write` in `skills/highway-profile/SKILL.md` and add one verification line for it

**Checkpoint**: A new Profile is not written until the split is accepted.

---

## Phase 7: User Story 5 - A later contradiction stops before more records (Priority: P2)

**Goal**: Onboarding, objectives, and assessment stop and, on accept, run Profile review before any other record.

**Independent Test**: Each of the three skills contains the stop, offer, accept, and decline instructions.

### Implementation for User Story 5

- [x] T008 [P] [US5] Add the contradiction instruction to `skills/highway-objectives/SKILL.md` and set `metadata.version` to `8.9.0`
- [x] T009 [P] [US5] Add the contradiction instruction to `skills/highway-assessment/SKILL.md` and set `metadata.version` to `5.6.0`
- [x] T010 [US5] Add the contradiction instruction to `skills/highway-onboarding/SKILL.md` and set `metadata.version` to `10.14.0`

**Checkpoint**: A fused Profile can be sent to Profile review before another record is added.

---

## Phase 8: User Story 6 - Onboarding does not turn the product into capabilities (Priority: P2)

**Goal**: Product behavior is not proposed as a capability unless the person says the organization operates it.

**Independent Test**: The capability step in `skills/highway-onboarding/references/proposal.md` and `skills/highway-onboarding/SKILL.md` both contain that instruction.

### Implementation for User Story 6

- [x] T011 [US6] Add the capability instruction to `skills/highway-onboarding/SKILL.md` and `skills/highway-onboarding/references/proposal.md`

**Checkpoint**: Onboarding capability proposals exclude product behavior the person has not claimed to operate.

---

## Phase 9: Polish

**Purpose**: Version pins, the instruction test, and the plugin finish order.

- [x] T012 Update the experience pin to `1.6.0` in `tests/harness-failure-resolutions.test.sh` and the objectives pin to `8.9.0` in `tests/harness-failure-followups.test.sh`
- [x] T013 Run `bash tests/org-offering-boundary.test.sh` and confirm exit 0
- [x] T014 Run `bash tests/run-all.sh --exclude-plugin-gen`, bump `framework/plugin/plugin.json` from `0.1.2` to `0.1.3`, run `bash framework/generate-catalog.sh`, `bash framework/generate-agent-adapters.sh`, and `bash framework/generate-agent-plugin.sh`, then run `bash tests/run-all.sh --plugin-gen-only`

---

## Dependencies & Execution Order

### Phase Dependencies

- Setup (Phase 1) has no dependencies.
- Foundational (Phase 2) depends on Setup and blocks story completion claims.
- US1 → US2 → US4 → US3's Profile sentence (T006) share `skills/highway-profile/SKILL.md` and run in that order. T005 may run beside T003.
- US5 objectives and assessment (T008, T009) may run beside Profile work. Onboarding T010 precedes T011.
- Polish depends on T003–T011.

### User Story Dependencies

- **US1 (P1)**: After the failing test exists. No dependency on other stories.
- **US2 (P1)**: After US1 in the same Profile file.
- **US3 (P1)**: Experience Standard file is independent. Profile name-fill follows US1.
- **US4 (P1)**: After the Profile domain rules from US1 and US2.
- **US5 (P2)**: Independent of Profile wording. Onboarding file then feeds US6.
- **US6 (P2)**: After T010 in the onboarding skill.

### Parallel Opportunities

- T005 beside T003–T004.
- T008 beside T009.

### Parallel Example: User Story 5

```bash
# Different files:
# T008 skills/highway-objectives/SKILL.md
# T009 skills/highway-assessment/SKILL.md
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Finish Phase 2 so the test fails.
2. Finish Phase 3.
3. Stop and read the Identity instructions in `skills/highway-profile/SKILL.md`.

### Incremental Delivery

1. US1 Identity split.
2. US2 Vision subject.
3. US3 Shared name.
4. US4 Write gate.
5. US5 Stop and revise.
6. US6 Capability limit.
7. Polish and plugin finish order.

---

## Notes

- Added skill text is an instruction. Do not add an explanation of why.
- Do not add a Profile section.
- Do not copy X2.73 into skills other than Profile's name-fill sentence.
- Do not rewrite a stored Profile as part of these edits.
