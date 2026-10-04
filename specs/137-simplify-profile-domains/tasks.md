---
description: "Task list for simplifying Profile domain meaning"
---

# Tasks: Simplify Profile Domain Meaning

**Input**: Design documents from `/specs/137-simplify-profile-domains/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/profile-skill.md, quickstart.md

**Tests**: Included because the specification requires executable contract checks for acquisition, expression, domain boundaries, persistence, and protected paths.

**Organization**: Tasks are grouped by user story so each story can be implemented and tested independently after the shared skill baseline is in place.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to
- Include exact file paths in descriptions

## Path Conventions

- Authoritative skill: `.highway/skills/highway-profile/SKILL.md`
- Generated adapters: `.agents/skills/highway-profile/SKILL.md`, `.claude/skills/highway-profile/SKILL.md`, `.github/skills/highway-profile/SKILL.md`, `.cursor/skills/highway-profile/SKILL.md`
- Contract tests: `.highway/tools/tests/`

## Phase 1: Setup

**Purpose**: Confirm the amendment baseline before changing contracts.

- [x] T001 Confirm `.highway/skills/highway-profile/SKILL.md` is version 5.3.0 and record the sections named by `specs/137-simplify-profile-domains/spec.md`

---

## Phase 2: Foundational

**Purpose**: Establish the breaking-change version and heading contract shared by every story.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [x] T002 Set `metadata.version` to `6.0.0` in `.highway/skills/highway-profile/SKILL.md`
- [x] T003 Change the skill heading in `.highway/skills/highway-profile/SKILL.md` from `## highway-profile` to `# highway-profile`

**Checkpoint**: The source skill identifies the breaking amendment.

---

## Phase 3: User Story 1 - Start from what the organization already has (Priority: P1)

**Goal**: Offer existing organizational material or a public website once, then reason from accepted evidence without exposing unavailable retrieval or retaining acquisition state.

**Independent Test**: A first-time repository offers existing material or a public website once; unavailable retrieval stays hidden; accepted evidence can inform unresolved domains without a retained acquisition record.

### Tests for User Story 1

- [x] T004 [P] [US1] Add acquisition contract assertions to `.highway/tools/tests/feature-137-profile-acquisition-expression-persistence.test.sh`

### Implementation for User Story 1

- [x] T005 [US1] Add user-supplied existing material and public website inputs in `.highway/skills/highway-profile/SKILL.md`
- [x] T006 [US1] Replace the Acquisition opening and website-only prompt in `.highway/skills/highway-profile/SKILL.md` with the one-opportunity existing-material offer
- [x] T007 [US1] Add imported-material reasoning, multi-source reasoning, and organizational acquisition scope in `.highway/skills/highway-profile/SKILL.md`
- [x] T008 [US1] Add the acquisition verification outcome in `.highway/skills/highway-profile/SKILL.md`

**Checkpoint**: User Story 1 is independently testable from the source skill text.

---

## Phase 4: User Story 2 - Describe where the organization is going (Priority: P1)

**Goal**: Vision asks for future direction, uses grounded evidence, and does not require category coverage.

**Independent Test**: Vision development produces a grounded future direction and does not require Future State, Impact, Offering, Market, Differentiation, or Capability coverage.

### Tests for User Story 2

- [x] T009 [P] [US2] Add Vision boundary assertions to `.highway/tools/tests/feature-137-profile-acquisition-expression-persistence.test.sh`

### Implementation for User Story 2

- [x] T010 [US2] Replace the Vision opening, Working Idea, multi-facet, and alternatives paragraphs in `.highway/skills/highway-profile/SKILL.md`
- [x] T011 [US2] Remove the enrichment-category coverage contract from `.highway/skills/highway-profile/SKILL.md`
- [x] T012 [US2] Add the Vision verification outcome in `.highway/skills/highway-profile/SKILL.md`

**Checkpoint**: User Story 2 is independently testable from the source skill text.

---

## Phase 5: User Story 3 - Separate direction, approach, and guidance (Priority: P1)

**Goal**: Competitive Path and Guiding Principles stay broad and do not become safeguards, NFRs, architecture, implementation requirements, or Controls.

**Independent Test**: Competitive Path does not elicit safeguards; volunteered downstream detail is not retained as a downstream requirement; Guiding Principles are not converted into Controls.

### Tests for User Story 3

- [x] T013 [P] [US3] Add Competitive Path and Guiding Principles boundary assertions to `.highway/tools/tests/feature-137-profile-acquisition-expression-persistence.test.sh`

### Implementation for User Story 3

- [x] T014 [US3] Replace the Competitive Path bullet and add the volunteered-detail boundary in `.highway/skills/highway-profile/SKILL.md`
- [x] T015 [US3] Replace the Guiding Principles opening and add the Control boundary in `.highway/skills/highway-profile/SKILL.md`
- [x] T016 [US3] Add Competitive Path and Guiding Principles verification outcomes in `.highway/skills/highway-profile/SKILL.md`

**Checkpoint**: User Story 3 is independently testable from the source skill text.

---

## Phase 6: User Story 4 - Build a recognizable organization description (Priority: P1)

**Goal**: Identity uses broad organizational evidence, includes imported material in substantive review, and does not use a standalone validation shortcut.

**Independent Test**: Materially assembled Identity includes imported material in its substantive path, while a directly supplied complete Identity does not receive unnecessary substantive review.

### Tests for User Story 4

- [x] T017 [P] [US4] Add Identity breadth assertions to `.highway/tools/tests/feature-137-profile-acquisition-expression-persistence.test.sh`

### Implementation for User Story 4

- [x] T018 [US4] Include Identity in the Contribution Opportunity scope in `.highway/skills/highway-profile/SKILL.md`
- [x] T019 [US4] Replace Identity substantive-review and breadth wording, and remove the standalone validation bullet, in `.highway/skills/highway-profile/SKILL.md`
- [x] T020 [US4] Add the Identity verification outcome in `.highway/skills/highway-profile/SKILL.md`

**Checkpoint**: User Story 4 is independently testable from the source skill text.

---

## Phase 7: User Story 5 - Do not advance on unsaved Profile work (Priority: P1)

**Goal**: Accepted mutations succeed before dependent behavior, and failure blocks a terminal result.

**Independent Test**: A dependent result is not available after a failed accepted mutation, and final synthesis does not proceed before the final domain mutation succeeds.

### Tests for User Story 5

- [x] T021 [P] [US5] Add persistence-boundary assertions to `.highway/tools/tests/feature-137-profile-acquisition-expression-persistence.test.sh`

### Implementation for User Story 5

- [x] T022 [US5] Replace the Operations persistence opening in `.highway/skills/highway-profile/SKILL.md` with mutation-success-before-dependent-behavior behavior
- [x] T023 [US5] Add the failed-mutation stop in `.highway/skills/highway-profile/SKILL.md` Error Handling
- [x] T024 [US5] Add persistence verification outcomes in `.highway/skills/highway-profile/SKILL.md`

**Checkpoint**: User Story 5 is independently testable from the source skill text.

---

## Phase 8: User Story 6 - Use organizational expression without retaining it (Priority: P2)

**Goal**: Expression can guide the active Profile interaction and is not persisted or propagated.

**Independent Test**: Terminology and wording guidance affect the active interaction only and do not create a retained style or propagate to another owner.

### Tests for User Story 6

- [x] T025 [P] [US6] Add transient expression assertions to `.highway/tools/tests/feature-137-profile-acquisition-expression-persistence.test.sh`

### Implementation for User Story 6

- [x] T026 [US6] Add transient organizational expression guidance after the Enrichment opening in `.highway/skills/highway-profile/SKILL.md`
- [x] T027 [US6] Add the expression verification outcome in `.highway/skills/highway-profile/SKILL.md`

**Checkpoint**: User Story 6 is independently testable from the source skill text.

---

## Phase 9: User Story 7 - Keep the amendment inside Profile's contract (Priority: P1)

**Goal**: Protected artifacts and retained Profile fields remain unchanged, and superseded assertions record why they changed.

**Independent Test**: Protected paths and schema 3.0.0 remain intact, and superseded assertions name the behavior they no longer lock.

### Tests for User Story 7

- [x] T028 [P] [US7] Add protected-path assertions to `.highway/tools/tests/feature-137-profile-acquisition-expression-persistence.test.sh`
- [x] T029 [P] [US7] Retarget superseded Profile assertions in `.highway/tools/tests/feature-092-contract.test.sh`, `.highway/tools/tests/feature-122-profile-experience-synchronization.test.sh`, `.highway/tools/tests/feature-134-profile-contribution-opportunity.test.sh`, `.highway/tools/tests/feature-136-profile-substantive-re-evaluation.test.sh`, `.highway/tools/tests/profile-behavior.test.sh`, and `.highway/tools/tests/profile-structure.test.sh` with recorded D3.5 reasons

### Implementation for User Story 7

- [x] T030 [US7] Confirm `.highway/skills/highway-profile/SKILL.md` does not add retained acquisition, expression, facet, dimension, safeguard, or reasoning fields and does not modify protected paths

**Checkpoint**: User Story 7 is independently testable without changing protected artifacts.

---

## Phase 10: Polish & Cross-Cutting Concerns

**Purpose**: Refresh generated artifacts and validate the full contract.

- [x] T031 Regenerate adapters and catalog metadata with `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/generate-instructions.sh`
- [x] T032 Run `bash .highway/tools/tests/feature-137-profile-acquisition-expression-persistence.test.sh` and `bash .highway/tools/tests/run-all.sh` as specified in `specs/137-simplify-profile-domains/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- Setup (Phase 1) precedes Foundational (Phase 2).
- Foundational version and heading changes precede all user stories.
- User Stories 1 through 5 and 7 are P1. User Story 6 is P2 and can follow expression-independent stories, but it edits the same source skill, so source edits are sequential.
- Polish begins after source skill edits and superseded test retargeting.

### User Story Dependencies

- **US1**: Depends on the versioned source skill.
- **US2**: Depends on US1 only for shared Acquisition evidence; its Vision text is otherwise independent.
- **US3**: Depends on accepted evidence behavior from US1; its path and principles text is otherwise independent.
- **US4**: Depends on the Contribution Opportunity section shared with later domain stories.
- **US5**: Depends on accepted-domain behavior from US2 through US4.
- **US6**: Depends on Enrichment existing; it does not depend on persistence success.
- **US7**: Depends on the final source contract and can validate protected paths in parallel with story-specific assertions once those files are stable.

### Parallel Opportunities

- Story-specific assertion blocks can be drafted in parallel before they are merged into the shared feature-137 test.
- Superseded assertion retargeting in separate existing test files can run in parallel after the source wording is final.
- Generator refresh and full-suite validation are sequential.

---

## Parallel Example: User Story 7

```bash
# After the source skill text is final, retarget separate contract files together:
# .highway/tools/tests/feature-092-contract.test.sh
# .highway/tools/tests/feature-122-profile-experience-synchronization.test.sh
# .highway/tools/tests/profile-structure.test.sh
```

---

## Implementation Strategy

### MVP First (User Story 1)

1. Complete Setup and Foundational.
2. Complete User Story 1 acquisition behavior and its assertions.
3. Stop and validate that existing material or a public website is offered once.

### Incremental Delivery

1. Add Vision, then Competitive Path and Guiding Principles, then Identity breadth.
2. Add the persistence boundary before any dependent terminal result.
3. Add transient expression.
4. Retarget superseded assertions, regenerate adapters and catalog metadata, and run the full suite.

### Sequential Source Edits

All stories edit `.highway/skills/highway-profile/SKILL.md`. Implement source edits in story order even where their behavioral outcomes are independently testable. Do not hand-edit generated adapters.

---

## Notes

- Superseded assertions must record the behavior they no longer lock.
- Do not add MUST or SHOULD keywords to the source skill.
- Do not restore post-write read-back or add retained Profile fields.
