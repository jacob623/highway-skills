---

description: "Implementation tasks for Experience Profile Presentation Rhythm"
---

# Tasks: Experience Profile Presentation Rhythm

**Input**: Design documents from `/specs/123-experience-profile-presentation-rhythm/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Included because the specification requires focused contracts and the repository constitution requires tests for behavioral changes.

## Phase 1: Setup

**Purpose**: Establish the baseline and identify the canonical source and derived outputs.

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` from the repository root and record the passing baseline before implementation
- [X] T002 [P] Confirm `.highway/skills/highway-profile/SKILL.md` and `.highway/governance/experience-standard.md` are the only behavior-owning shipped sources for this feature
- [X] T003 [P] Confirm `profile-record.md`, Highway Identity, the Constitution, schema 3.0.0, and unrelated skills are protected from edits

## Phase 2: Foundational

**Purpose**: Establish failing focused contracts and the ownership boundaries required by every story.

- [X] T004 [P] Add failing X2.36, amendment metadata, protected-rule, and workflow-narration assertions to `.highway/tools/tests/experience-standard-amendment.test.sh`
- [X] T005 [P] Add failing subject-heading, acknowledgment-intent, transient-presentation, and no-workflow-narration assertions to `.highway/tools/tests/profile-behavior.test.sh`
- [X] T006 [P] Add failing subject-rhythm and protected-retention assertions to `.highway/tools/tests/profile-structure.test.sh`
- [X] T007 [P] Add failing save-before-result and transient-commentary assertions to `.highway/tools/tests/profile-lifecycle.test.sh`
- [X] T008 Run the focused amended tests and record their expected failures before changing the Experience Standard or Profile source

**Checkpoint**: Focused contracts fail for the missing Feature 123 behavior and existing protected invariants remain identifiable.

## Phase 3: User Story 1 - Keep Internal Workflow Mechanics Silent (Priority: P1) MVP

**Goal**: Add the global X2.36 rule and supporting Experience Standard guidance without changing protected rules.

**Independent Test**: The Experience Standard contract confirms exactly one X2.36 after X2.35, version 7.2.0, required amendment metadata, the interaction-model guidance, and compliant/non-compliant narration examples.

### Tests for User Story 1

- [X] T009 [US1] Complete the X2.36 assertions in `.highway/tools/tests/experience-standard-amendment.test.sh`, including rule count, rule ordering, tier, protected rule text, and amendment metadata
- [X] T010 [US1] Add the specified workflow narration example assertions to `.highway/tools/tests/experience-standard-amendment.test.sh`

### Implementation for User Story 1

- [X] T011 [US1] Amend `.highway/governance/experience-standard.md` with X2.36 after X2.35, Conversational Presence guidance, interaction-model guidance, workflow narration example, and version 7.2.0 MINOR metadata
- [X] T012 [US1] Run `bash .highway/tools/tests/experience-standard-amendment.test.sh` and verify the global narration contract passes without changes to protected rules

**Checkpoint**: The global no-workflow-narration behavior is independently complete and testable.

## Phase 4: User Story 2 - Guide Profile Subjects Naturally (Priority: P1)

**Goal**: Make Profile synthesis use subject headings, natural introductions, grounded recommendations, validation, and acknowledgment before the next subject.

**Independent Test**: Profile contract checks find all three prescribed headings and the `Introduce -> Suggest -> Validate` plus `Acknowledge -> Introduce next subject` rhythm without internal domain or workflow narration.

### Tests for User Story 2

- [X] T013 [P] [US2] Add exact subject heading and rhythm assertions to `.highway/tools/tests/profile-behavior.test.sh`
- [X] T014 [P] [US2] Add X2.8 acknowledgment and no-progression-narration assertions to `.highway/tools/tests/profile-structure.test.sh`

### Implementation for User Story 2

- [X] T015 [US2] Update `.highway/skills/highway-profile/SKILL.md` Enrichment guidance with the subject-oriented rhythm, prescribed headings, natural introductions, and cohesive grounded recommendations
- [X] T016 [US2] Update `.highway/skills/highway-profile/SKILL.md` Operations and Verification guidance with acknowledgment intent, the final-domain completion exception, and the X2.36 citation boundary
- [X] T017 [US2] Run `bash .highway/tools/tests/profile-behavior.test.sh` and `bash .highway/tools/tests/profile-structure.test.sh` and repair only local Feature 123 contract failures

**Checkpoint**: Vision, Competitive Path, and Guiding Principles presentation is independently verifiable.

## Phase 5: User Story 3 - Preserve Grounding, Acceptance, and Retention (Priority: P1)

**Goal**: Preserve accepted-evidence grounding, acceptance boundaries, transient commentary, readiness, persistence ordering, and canonical fallback.

**Independent Test**: Profile lifecycle and behavior contracts confirm no presentation text is retained, accepted mutations remain persisted before dependent results, and unsupported recommendations fall back to canonical questions.

### Tests for User Story 3

- [X] T018 [P] [US3] Add transient heading/introduction/acknowledgment and canonical-fallback assertions to `.highway/tools/tests/profile-lifecycle.test.sh`
- [X] T019 [P] [US3] Add correction/replacement, explanation-not-acceptance, readiness, and completion-preservation assertions to `.highway/tools/tests/profile-behavior.test.sh`

### Implementation for User Story 3

- [X] T020 [US3] Refine `.highway/skills/highway-profile/SKILL.md` Enrichment, Operations, Verification, and Error Handling text to preserve all accepted-evidence and transient-boundary requirements
- [X] T021 [US3] Verify `.highway/library/templates/output/profile-record.md` remains byte-identical and schema 3.0.0, documenting any protected-file check result in the implementation record
- [X] T022 [US3] Run `bash .highway/tools/tests/profile-lifecycle.test.sh` and the focused Profile contract tests

**Checkpoint**: Profile presentation changes do not alter retained data semantics or readiness behavior.

## Phase 6: User Story 4 - Amend the Shared Standard Without Breaking Profile Scope (Priority: P2)

**Goal**: Preserve ownership boundaries, generated correspondence, Profile version 5.1.0, and the complete repository contract.

**Independent Test**: Source, generated adapters, catalogs, and focused checks agree; X2.36 is global and Profile-specific behavior remains local.

### Tests for User Story 4

- [X] T023 [P] [US4] Add ownership-boundary and no-duplicate-X2.36 assertions to `.highway/tools/tests/experience-standard-amendment.test.sh`
- [X] T024 [P] [US4] Add Profile version, protected artifact, and adapter-source assertions to `.highway/tools/tests/profile-behavior.test.sh`

### Implementation for User Story 4

- [X] T025 [US4] Confirm `.highway/skills/highway-profile/SKILL.md` remains version 5.1.0 and cites the Experience Standard without duplicating the global narration rule
- [X] T026 [US4] Run the declared catalog and adapter generators after the Profile source change and refresh all derived Profile adapters and manifests
- [X] T027 [US4] Run `bash .highway/tools/tests/adapter-coverage.test.sh`, `bash .highway/tools/validate-skill.sh .highway/skills/highway-profile`, and all focused Feature 123 contracts

**Checkpoint**: Shared governance, Profile source, generated outputs, and ownership checks agree.

## Phase 7: Polish and Cross-Cutting Verification

**Purpose**: Complete traceability, validate the quickstart, and prove the final repository state.

- [X] T028 [P] Review `specs/123-experience-profile-presentation-rhythm/plan.md`, `research.md`, `data-model.md`, `contracts/experience-profile-presentation.md`, and `quickstart.md` for unresolved placeholders and requirement traceability
- [X] T029 [P] Compare the final diff against protected paths and confirm no `profile-record.md`, Highway Identity, Constitution, or unrelated skill file changed
- [X] T030 Run `bash .highway/tools/tests/run-all.sh` and record separate requirement coverage and check results for Feature 123
- [X] T031 Run every validation command in `specs/123-experience-profile-presentation-rhythm/quickstart.md` and confirm the expected zero-failure outcomes

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes baseline and scope.
- **Foundational (Phase 2)**: Depends on Setup; blocks all user-story implementation.
- **User Story 1 (Phase 3)**: Depends on Foundational; MVP for the global standard.
- **User Story 2 (Phase 4)**: Depends on Foundational and the X2.36 ownership established by US1.
- **User Story 3 (Phase 5)**: Depends on Foundational and the presentation contract from US2.
- **User Story 4 (Phase 6)**: Depends on source changes from US1-US3; regenerates derived outputs.
- **Polish (Phase 7)**: Depends on all desired stories and generated artifacts.

### User Story Dependencies

- **US1 (P1)**: Independent after Foundational; MVP.
- **US2 (P1)**: Requires X2.36 ownership from US1 but remains independently testable through Profile contracts.
- **US3 (P1)**: Builds on US2 presentation guidance while preserving existing Profile data semantics.
- **US4 (P2)**: Integrates all source and generated-artifact checks.

### Parallel Opportunities

- T004-T007 can run in parallel because they modify separate focused test files.
- T013-T014, T018-T019, and T023-T024 can run in parallel within their story phases.
- T028-T029 can run in parallel before the final suite.
- User Story 1's standard work can proceed alongside the initial Profile contract authoring after Foundational, but final Profile implementation should use the established X2.36 ownership.

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational phases.
2. Complete User Story 1 and run its focused contract.
3. Stop at the US1 checkpoint if an early demonstration is needed.

### Incremental Delivery

1. Add the global standard rule.
2. Add subject-oriented Profile presentation.
3. Verify retained-data and lifecycle preservation.
4. Regenerate adapters and run the full suite.

## Notes

- Every task uses the required checkbox, sequential ID, optional parallel marker, story label where applicable, and an exact repository path.
- New contract assertions must be observed failing before the corresponding implementation is marked complete.
- Generated adapters and manifests are outputs; edit only the canonical Profile source.
