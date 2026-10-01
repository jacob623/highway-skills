---
description: "Executable task list for Feature 115"
---

# Tasks: Update Profile Skill

**Input**: Design documents from `/specs/115-update-profile-skill/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Tests**: Required by the feature specification. Amend focused Profile contract tests before implementation, then run the full suite.

## Phase 1: Setup

**Purpose**: Establish the baseline and confirm the existing Profile artifact boundaries.

- [X] T001 Run the baseline repository suite with `bash .highway/tools/tests/run-all.sh` and record the starting result for Feature 115 validation.
- [X] T002 [P] Verify the authoritative Profile skill, all four distributed copies, the retained Profile template, and Profile test paths in `.highway/skills/highway-profile/SKILL.md`, `.github/skills/highway-profile/SKILL.md`, `.claude/skills/highway-profile/SKILL.md`, `.cursor/skills/highway-profile/SKILL.md`, `.agents/skills/highway-profile/SKILL.md`, and `.highway/library/templates/output/profile-record.md`.

## Phase 2: Foundational

**Purpose**: Prepare the shared verification surface before story implementation.

- [X] T003 [P] Document the Feature 115 test contract and preserved schema boundary in `.highway/tools/tests/profile-structure.test.sh` and `.highway/tools/tests/profile-context-contract.test.sh` without changing the four-domain or schema 3.0.0 invariants.
- [X] T004 [P] Replace superseded question-first assertions with recommendation-first, save-before-result, question-before-explanation, and synthesis expectations in `.highway/tools/tests/profile-behavior.test.sh`.

**Checkpoint**: Focused tests express the new contract and are expected to fail against the current Profile skill.

## Phase 3: User Story 1 - Website Acceptance Grounds the Next Recommendation (Priority: P1) MVP

**Goal**: Make accepted website evidence trigger cross-domain grounding and useful recommendations before a generic Vision question.

**Independent Test**: Run `bash .highway/tools/tests/profile-behavior.test.sh` and confirm accepted website evidence is proposed/accepted correctly, immediately re-evaluates Vision, and suppresses the generic Vision question when a useful recommendation exists.

### Tests for User Story 1

- [X] T005 [US1] Add assertions for Repository Name ordering, direct URL acceptance, proposed website facts, and recommendation-first Vision behavior in `.highway/tools/tests/profile-behavior.test.sh`.

### Implementation for User Story 1

- [X] T006 [US1] Rewrite the acquisition and website-acceptance sections in `.highway/skills/highway-profile/SKILL.md` so accepted evidence is re-evaluated across all four domains before any unresolved canonical question.
- [X] T007 [US1] Add Profile-specific grounding rules for Vision, Competitive Path, and Guiding Principles to `.highway/skills/highway-profile/SKILL.md`, keeping grounding categories internal and referencing Experience Standard 5.0.0 for generic interaction behavior.

**Checkpoint**: Website acceptance produces grounded recommendations before canonical questions and the focused behavior contract passes for User Story 1.

## Phase 4: User Story 2 - Recommendations Before Canonical Questions (Priority: P1)

**Goal**: Replace fixed four-question sequencing with compounding accepted evidence, explicit readiness transitions, and recommendation-first choices.

**Independent Test**: Run the focused behavior and structure tests; verify one response can affect multiple domains, displayed recommendations count as acceptance, explicit boundaries become `bounded`, and optional enrichment does not change readiness or require another question.

### Tests for User Story 2

- [X] T008 [US2] Add assertions for cross-domain re-evaluation, singular versus multiple recommendation wording, implicit recommendation acceptance, multi-domain evidence, and optional enrichment in `.highway/tools/tests/profile-behavior.test.sh`.
- [X] T009 [US2] Add assertions for `discussed` and `bounded` readiness transitions and the absence of persisted grounding-category names in `.highway/tools/tests/profile-structure.test.sh`.

### Implementation for User Story 2

- [X] T010 [US2] Update readiness, evidence lifecycle, recommendation acceptance, and canonical-question fallback rules in `.highway/skills/highway-profile/SKILL.md` to preserve exactly four domains and the three allowed domain states.
- [X] T011 [US2] Remove obsolete question-first and post-question enrichment wording from `.highway/skills/highway-profile/SKILL.md` while retaining canonical question text and Profile ownership boundaries.

**Checkpoint**: Recommendation-first sequencing and readiness transitions are independently verified without changing the retained schema.

## Phase 5: User Story 3 - Accepted Evidence Is Saved Before Results (Priority: P1)

**Goal**: Ensure every accepted retained mutation is persisted before dependent readiness or owner results, and close guided completion with one user-relevant synthesis.

**Independent Test**: Run the focused behavior test and verify mutation construction, persistence-before-result ordering, hidden machine fields in normal conversation, direct readiness availability, and exactly one completion synthesis.

### Tests for User Story 3

- [X] T012 [US3] Add assertions for save-before-result ordering, recommendation/discovery mutation paths, no post-write verification requirement, completion synthesis constraints, hidden machine fields, and question-before-why-it-matters ordering in `.highway/tools/tests/profile-behavior.test.sh`.

### Implementation for User Story 3

- [X] T013 [US3] Amend mutation and result timing instructions in `.highway/skills/highway-profile/SKILL.md` so accepted evidence is constructed and persisted before dependent readiness or owner results are returned.
- [X] T014 [US3] Add guided completion synthesis and orchestrator/direct-readiness presentation rules to `.highway/skills/highway-profile/SKILL.md`, excluding machine status fields and new questions from the synthesis.

**Checkpoint**: Accepted evidence cannot be reported as current before persistence, and guided completion produces the required synthesis.

## Phase 6: User Story 4 - A Bounded Major Profile Update (Priority: P2)

**Goal**: Version the skill to 5.0.0, synchronize distributed copies, preserve schema 3.0.0, and keep generic governance rules referenced rather than duplicated.

**Independent Test**: Inspect the source and all distributed copies, run Profile structural/context/template tests, and confirm the deferred documents and unrelated governance artifacts are unchanged.

### Tests for User Story 4

- [X] T015 [US4] Add assertions for Profile version 5.0.0, Experience Standard 5.0.0 reference, absence of copied generic interaction rules, unchanged schema 3.0.0, and required stale-follow-up boundaries in `.highway/tools/tests/profile-behavior.test.sh` and `.highway/tools/tests/profile-structure.test.sh`.

### Implementation for User Story 4

- [X] T016 [US4] Set the authoritative Profile skill version to 5.0.0 and finalize its Experience Standard and constitution references in `.highway/skills/highway-profile/SKILL.md`.
- [X] T017 [P] [US4] Synchronize the completed Profile skill byte-for-byte to `.github/skills/highway-profile/SKILL.md`.
- [X] T018 [P] [US4] Synchronize the completed Profile skill byte-for-byte to `.claude/skills/highway-profile/SKILL.md`.
- [X] T019 [P] [US4] Synchronize the completed Profile skill byte-for-byte to `.cursor/skills/highway-profile/SKILL.md`.
- [X] T020 [P] [US4] Synchronize the completed Profile skill byte-for-byte to `.agents/skills/highway-profile/SKILL.md`.
- [X] T021 [US4] Verify `.highway/library/templates/output/profile-record.md`, Highway Profile Intent Summary, Brownfield Onboarding Idea, Setup, and other governance artifacts remain unchanged and the retained template remains schema 3.0.0.

**Checkpoint**: All Profile copies match, version and schema boundaries pass, and no out-of-scope document was modified.

## Phase 7: Polish & Cross-Cutting Validation

**Purpose**: Validate the complete implementation and update task completion state.

- [X] T022 [P] Run all focused Profile checks from `specs/115-update-profile-skill/quickstart.md` and resolve any regressions without weakening existing assertions.
- [X] T023 [P] Compare all five Profile skill copies with `diff` and run `git diff --check` for the changed artifacts.
- [X] T024 Run `bash .highway/tools/tests/run-all.sh` and confirm the complete repository suite passes after Feature 115.
- [X] T025 Mark every completed task in this file `[X]` and confirm implementation coverage against `spec.md`, `plan.md`, `data-model.md`, and `quickstart.md`.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes baseline and artifact boundaries.
- **Foundational (Phase 2)**: Depends on Setup; blocks story implementation because tests must express the new contract first.
- **User Story 1 (Phase 3)**: Depends on Foundational and is the recommended MVP.
- **User Story 2 (Phase 4)**: Depends on Foundational; builds on the acquisition behavior from US1.
- **User Story 3 (Phase 5)**: Depends on Foundational; integrates with accepted recommendation/discovery paths from US1 and US2.
- **User Story 4 (Phase 6)**: Depends on the completed skill behavior from US1-US3 before synchronizing copies and finalizing version assertions.
- **Polish (Phase 7)**: Depends on all desired user stories.

### User Story Dependencies

- **US1 (P1)**: Can start after Phase 2; MVP foundation for the new acquisition behavior.
- **US2 (P1)**: Can start after Phase 2, but its implementation should follow US1 because it extends the same Profile acquisition path.
- **US3 (P1)**: Can start after Phase 2, but its implementation should follow US1-US2 because it governs their accepted mutation paths.
- **US4 (P2)**: Follows US1-US3 because versioning and synchronization finalize the complete skill contract.

### Parallel Opportunities

- T002 and T003 can run in parallel after T001.
- T017-T020 can run in parallel after T016 because each changes a different distributed copy.
- T022 and T023 can run in parallel after the story checkpoints.

## Parallel Example: User Story 4

```text
After T016 completes, run T017, T018, T019, and T020 in parallel because each updates a separate distributed Profile copy.
After synchronization, run T022 and T023 in parallel before T024.
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Implement website acceptance and recommendation-first Vision behavior for US1.
3. Run the US1 focused test checkpoint.
4. Continue to US2 and US3 for the complete P1 contract before treating the feature as release-ready.

### Incremental Delivery

1. Establish the baseline and contract tests.
2. Deliver US1 website grounding.
3. Deliver US2 compounding recommendations and readiness transitions.
4. Deliver US3 persistence timing and completion synthesis.
5. Deliver US4 versioning, synchronization, and full validation.

## Notes

- Every task uses the required checkbox, sequential ID, optional `[P]` marker, story label where required, and concrete file path.
- No `contracts/` directory is needed because this repository exposes no external API or runtime service.
- The retained Profile template and stale follow-up documents are validation boundaries, not implementation targets.
