---
description: "Task list for making the Profile structure visible and shortening highway-profile"
---

# Tasks: Visible Profile Structure

**Input**: Design documents from `/specs/138-visible-profile-structure/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/profile-record.md, contracts/profile-skill.md, quickstart.md

**Tests**: Included because the plan and constitution require amended contract checks before the template stops being a valid retained Profile and before the skill version becomes 7.0.0.

**Organization**: Tasks are grouped by user story so each story can be implemented and tested independently after the retained-fixture baseline is in place.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to
- Include exact file paths in descriptions

## Path Conventions

- Template: `.highway/library/templates/output/profile-record.md`
- Skill: `.highway/skills/highway-profile/SKILL.md`
- Retained artifact: `.highway/library/knowledge/profile.md`
- Contract tests: `.highway/tools/tests/`

## Phase 1: Setup

**Purpose**: Confirm the amendment baseline before changing contracts.

- [x] T001 Confirm `.highway/skills/highway-profile/SKILL.md` is version 6.0.0 and `.highway/library/templates/output/profile-record.md` has template metadata 3.0.0 and retained `schema_version: 3.0.0`

---

## Phase 2: Foundational

**Purpose**: Preserve a valid retained Profile fixture before the template becomes a skeleton.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [x] T002 Copy the current valid empty Profile from `.highway/library/templates/output/profile-record.md` to `.highway/tools/tests/fixtures/profile-092/profile-record/empty.md` before the template rewrite
- [x] T003 Retarget template-as-profile copies in `.highway/tools/tests/fixtures/profile-092/profile-fixtures.sh`, `.highway/tools/tests/profile-structure.test.sh`, `.highway/tools/tests/profile-behavior.test.sh`, `.highway/tools/tests/profile-lifecycle.test.sh`, `.highway/tools/tests/profile-markdown-contract.test.sh`, and `.highway/tools/tests/feature-092-contract.test.sh` to `.highway/tools/tests/fixtures/profile-092/profile-record/empty.md`, with a D3.5 reason that the template will no longer be a retained Profile

**Checkpoint**: Existing Profile validation uses a retained fixture, not the template file.

---

## Phase 3: User Story 1 - Reconstruct the retained Profile from the template (Priority: P1)

**Goal**: A reader can reconstruct retained frontmatter and body headings from the template alone.

**Independent Test**: Read `.highway/library/templates/output/profile-record.md` and list `schema_version`, the four `domains` keys, and the retained heading order without opening the skill.

### Tests for User Story 1

- [x] T004 [P] [US1] Add skeleton assertions for description, `## File Frontmatter`, `## Body`, `schema_version: 3.0.0`, and the four retained headings to `.highway/tools/tests/feature-138-visible-profile-structure.test.sh`

### Implementation for User Story 1

- [x] T005 [US1] Rewrite `.highway/library/templates/output/profile-record.md` as a visible skeleton with template metadata 3.1.0, `## File Frontmatter`, and `## Body` per `specs/138-visible-profile-structure/contracts/profile-record.md`
- [x] T006 [US1] Regenerate `.highway/catalog/library-index.md` and `.highway/catalog/library-index.json` with `generate-library-catalog.sh` so the Profile template description and version 3.1.0 are published

**Checkpoint**: User Story 1 is independently testable from the template file.

---

## Phase 4: User Story 2 - Render only accepted domain and context content (Priority: P1)

**Goal**: The template states when domain headings and Context children are omitted.

**Independent Test**: The template states discussed, bounded, and not_discussed rendering, and states that empty Context is omitted while all four domain keys remain.

### Tests for User Story 2

- [x] T007 [P] [US2] Add conditional-rendering and Context-omission assertions to `.highway/tools/tests/feature-138-visible-profile-structure.test.sh`

### Implementation for User Story 2

- [x] T008 [US2] Add the rendering sentences from `specs/138-visible-profile-structure/contracts/profile-record.md` to `.highway/library/templates/output/profile-record.md` and replace the superseded phrases in `.highway/tools/tests/profile-structure.test.sh` with a D3.5 reason

**Checkpoint**: User Story 2 is independently testable from the template semantics.

---

## Phase 5: User Story 3 - Complete a Profile without duplicated instructions (Priority: P1)

**Goal**: highway-profile 7.0.0 keeps acquisition, expression, domain meaning, reuse, and guided completion without restating the template skeleton.

**Independent Test**: The skill cites the template, keeps the canonical questions and conversational headings, and does not restate retained heading order.

### Tests for User Story 3

- [x] T009 [P] [US3] Add version 7.0.0, retained-path, and preserved-capability assertions to `.highway/tools/tests/feature-138-visible-profile-structure.test.sh` and observe the new check fail before the skill rewrite

### Implementation for User Story 3

- [x] T010 [US3] Rewrite `.highway/skills/highway-profile/SKILL.md` to version 7.0.0 using the preserved sentences in `specs/138-visible-profile-structure/contracts/profile-skill.md`, without adding MUST or SHOULD
- [x] T011 [US3] Regenerate highway-profile adapters and `.highway/catalog/index.md` plus `.highway/catalog/index.json` with the declared generators, without hand-editing adapter copies

**Checkpoint**: User Story 3 is independently testable from the source skill.

---

## Phase 6: User Story 4 - Project only broad Competitive Path meaning (Priority: P1)

**Goal**: Volunteered downstream detail changes Competitive Path only through broad strategic meaning, and acceptance is not treated as persistence.

**Independent Test**: The projection sentence and persistence sentence from the contract are present, and the duplicate website sentence, literal `<br>`, and malformed persistence fragment are absent.

### Tests for User Story 4

- [x] T012 [P] [US4] Add projection, persistence, and defect-absence assertions to `.highway/tools/tests/feature-138-visible-profile-structure.test.sh`

### Implementation for User Story 4

- [x] T013 [US4] Replace the Competitive Path projection and Operations persistence text in `.highway/skills/highway-profile/SKILL.md` and remove literal `<br>` separators without changing the surrounding meaning

**Checkpoint**: User Story 4 is independently testable from the source skill.

---

## Phase 7: Polish

**Purpose**: Align older version pins and confirm the full suite.

- [x] T014 Update superseded `version: 6.0.0` assertions in `.highway/tools/tests/profile-structure.test.sh`, `.highway/tools/tests/profile-behavior.test.sh`, `.highway/tools/tests/feature-092-contract.test.sh`, `.highway/tools/tests/feature-136-profile-substantive-re-evaluation.test.sh`, and `.highway/tools/tests/feature-137-profile-acquisition-expression-persistence.test.sh` to `version: 7.0.0` with a D3.5 reason
- [x] T015 Run `bash .highway/tools/tests/run-all.sh` and confirm protected files `experience-standard.md`, `constitution.md`, setup, objectives, controls, and NFRs are unchanged

---

## Dependencies

- Phase 2 blocks all user stories because the template rewrite invalidates template-as-profile copies.
- US2 depends on US1 because both edit `.highway/library/templates/output/profile-record.md`.
- US4 depends on US3 because both edit `.highway/skills/highway-profile/SKILL.md`.
- US3 may proceed after Phase 2 without waiting for US2.

## Parallel Example

```text
T004 template skeleton test and T009 skill capability test can be drafted in parallel
T007 rendering assertions can be added beside T004 once the test file exists
```

## Implementation Strategy

MVP is User Story 1: a visible template skeleton. User Story 2 completes the template contract. User Stories 3 and 4 then shorten the skill and repair the projection and persistence contract. Polish aligns older version pins and runs the full suite.

## Notes

- Do not relocate `.highway/library/knowledge/profile.md`.
- Do not change retained `schema_version` from `3.0.0`.
- If library-catalog regeneration changes only `generated_at`, restore that file.
- If adapter generation reorders unrelated manifest rows, restore the prior order of those unrelated rows.
