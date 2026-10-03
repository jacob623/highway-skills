# Tasks: Profile Substantive Re-evaluation and Fuller Identity

**Input**: Design documents from `specs/136-profile-substantive-re-evaluation/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Tests**: Required by FR-028 and the success criteria. Contract tests are static-document checks and must cover source and generated artifacts without introducing runtime state.

## Phase 1: Setup

**Purpose**: Establish the focused contract-test surface and source ownership.

- [X] T001 Review Feature 136 protected paths and current Profile contract assertions in `.highway/tools/tests/feature-136-profile-substantive-re-evaluation.test.sh` and `.highway/skills/highway-profile/SKILL.md`
- [X] T002 [P] Record the Feature 136 validation command set and artifact boundaries in `specs/136-profile-substantive-re-evaluation/quickstart.md`

## Phase 2: Foundational

**Purpose**: Add failing, deterministic contract coverage before changing the Profile source.

- [X] T003 Add Feature 136 static contract test scaffolding, source/generated correspondence checks, version 5.3.0 expectation, schema 3.0.0 protection, and protected-path checks in `.highway/tools/tests/feature-136-profile-substantive-re-evaluation.test.sh`
- [X] T004 [P] Add substantive re-evaluation, selective clarification, one-question, transient reasoning, and acceptance-plus-new-information assertions in `.highway/tools/tests/feature-136-profile-substantive-re-evaluation.test.sh`
- [X] T005 [P] Add fuller Identity, technology exclusion, full-Identity Vision, relationship-oriented Vision/Competitive Path, and Guiding Principles assertions in `.highway/tools/tests/feature-136-profile-substantive-re-evaluation.test.sh`

**Checkpoint**: The new contract test fails against the unchanged 5.2.0 Profile source and is ready to guide implementation.

## Phase 3: User Story 1 - Re-evaluate Every Profile Contribution (Priority: P1) MVP

**Goal**: Make X2.38-X2.40 explicit for every substantive Profile response while preserving acceptance and one-question behavior.

**Independent Test**: The Feature 136 contract test finds explicit re-evaluation before routing, direct incorporation for a supported interpretation, focused clarification only for consequential uncertainty, and acceptance-plus-new-information handling across all four domains.

### Tests for User Story 1

- [X] T006 [US1] Run the focused Feature 136 contract test against the unchanged source and confirm its expected pre-implementation failures in `.highway/tools/tests/feature-136-profile-substantive-re-evaluation.test.sh`

### Implementation for User Story 1

- [X] T007 [US1] Update the collaborative-development, Working Idea, Acquisition, Enrichment, shared inner-loop, acceptance-plus-new-information, one-question, and clarification/Contribution Opportunity guidance in `.highway/skills/highway-profile/SKILL.md`
- [X] T008 [US1] Add Guiding Principles substantive re-evaluation and verification assertions to `.highway/skills/highway-profile/SKILL.md`

**Checkpoint**: User Story 1 behavior is explicit in the source skill and its focused assertions pass for the source contract.

## Phase 4: User Story 2 - Establish Fuller Organizational Identity (Priority: P1)

**Goal**: Provide provisional meaningful Identity facets when Profile materially assembles or interprets organizational evidence, while allowing direct complete Identity and preserving the existing accuracy boundary.

**Independent Test**: Identity contract assertions cover provisional facets, Contribution Opportunity distinction, selective clarification, cohesive synthesis, direct complete contributions, technology exclusion, and unchanged retained schema.

### Tests for User Story 2

- [X] T009 [US2] Run the Identity-focused assertions in `.highway/tools/tests/feature-136-profile-substantive-re-evaluation.test.sh` and confirm they fail before the Identity source amendment.

### Implementation for User Story 2

- [X] T010 [US2] Replace the Identity validation and convergence guidance and add provisional-facet, organizational-breadth, and clarification-versus-Contribution-Opportunity guidance in `.highway/skills/highway-profile/SKILL.md`
- [X] T011 [US2] Add Identity-specific verification assertions for direct convergence, provisional facets, transient content, and technology exclusion in `.highway/skills/highway-profile/SKILL.md`

**Checkpoint**: User Story 2 Identity behavior is source-defined and independently covered without adding retained fields.

## Phase 5: User Story 3 - Ground Vision and Competitive Path in Full Identity (Priority: P1)

**Goal**: Make Vision and Competitive Path reason over accepted Identity breadth and useful relationships before fallback questions.

**Independent Test**: The contract test finds full-Identity grounding, relationship-oriented Vision behavior, relationship-oriented Competitive Path behavior, and selective clarification language.

### Tests for User Story 3

- [X] T012 [US3] Run the Vision and Competitive Path assertions in `.highway/tools/tests/feature-136-profile-substantive-re-evaluation.test.sh` and confirm they fail before implementation.

### Implementation for User Story 3

- [X] T013 [US3] Strengthen Vision grounding and add relationship-oriented Vision reasoning in `.highway/skills/highway-profile/SKILL.md`
- [X] T014 [US3] Strengthen Competitive Path grounding and add relationship-oriented Competitive Path reasoning in `.highway/skills/highway-profile/SKILL.md`

**Checkpoint**: User Story 3 downstream reasoning is explicit and remains transient until existing acceptance.

## Phase 6: User Story 4 - Preserve Profile Boundaries and Verify the New Behavior (Priority: P1)

**Goal**: Preserve ownership, persistence, schema, and protected artifacts while making the new contract executable in the repository suite.

**Independent Test**: Source and generated copies agree at version 5.3.0, the retained template remains schema 3.0.0 with four domains, transient reasoning is excluded from retained output, and all relevant tests pass.

### Tests for User Story 4

- [X] T015 [US4] Execute `.highway/tools/tests/feature-136-profile-substantive-re-evaluation.test.sh`, the focused Profile tests, and the adapter/catalog correspondence checks after implementation.

### Implementation for User Story 4

- [X] T016 [US4] Bump the Profile skill metadata to version 5.3.0 and ensure the source Verification section covers all Feature 136 behavior in `.highway/skills/highway-profile/SKILL.md`
- [X] T017 [US4] Regenerate distributed Profile adapters and catalog metadata with `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, and `.highway/tools/generate-library-catalog.sh`
- [X] T018 [US4] Register the Feature 136 contract test through the repository's existing test discovery conventions in `.highway/tools/tests/feature-136-profile-substantive-re-evaluation.test.sh`

**Checkpoint**: Profile source, generated outputs, schema boundary, and focused contract checks agree.

## Phase 7: Polish & Cross-Cutting Validation

- [X] T019 [P] Run `bash .highway/tools/tests/profile-behavior.test.sh`, `bash .highway/tools/tests/profile-context-contract.test.sh`, `bash .highway/tools/tests/profile-structure.test.sh`, and `bash .highway/tools/tests/feature-134-profile-contribution-opportunity.test.sh`
- [X] T020 [P] Run `bash .highway/tools/tests/run-all.sh` and record the zero-failure result against Feature 136 success criteria
- [X] T021 [P] Run `git diff --check` and verify protected artifacts remain unchanged in `.highway/governance/experience-standard.md`, `.highway/library/templates/output/profile-record.md`, `.highway/skills/highway-setup/SKILL.md`, `.highway/skills/highway-clarify/SKILL.md`, and `.highway/governance/constitution.md`
- [X] T022 Update the Feature 136 quickstart and plan completion notes with final commands and generated artifact paths in `specs/136-profile-substantive-re-evaluation/quickstart.md` and `specs/136-profile-substantive-re-evaluation/plan.md`

## Dependencies & Execution Order

### Phase Dependencies

- Setup precedes Foundational.
- Foundational contract coverage precedes all user story implementation.
- User Story 1 establishes shared inner-loop language before Identity and downstream reasoning are amended.
- User Story 2 precedes User Story 3 because Vision depends on fuller accepted Identity context.
- User Story 4 follows the source behavior work and owns generated outputs and repository-wide verification.
- Polish follows all implementation phases.

### User Story Dependencies

- **US1**: Independent after Foundational; MVP.
- **US2**: Depends on US1's shared re-evaluation model for Identity-specific application.
- **US3**: Depends on US2's fuller Identity model.
- **US4**: Depends on US1-US3 source amendments; protects all shared boundaries.

### Parallel Opportunities

- T002 can run in parallel with T001.
- T004 and T005 can be authored in parallel after T003 scaffolding, but changes to the same test file must be merged sequentially.
- T019, T020, and T021 can run in parallel after generated artifacts are complete.

## Parallel Example: Final Validation

```sh
bash .highway/tools/tests/feature-136-profile-substantive-re-evaluation.test.sh
bash .highway/tools/tests/profile-behavior.test.sh
bash .highway/tools/tests/profile-context-contract.test.sh
bash .highway/tools/tests/profile-structure.test.sh
```

## Implementation Strategy

### MVP First

Complete Setup, Foundational, and User Story 1. Validate the shared re-evaluation behavior independently before adding fuller Identity and downstream relationship reasoning.

### Incremental Delivery

Complete US2 after US1 to establish fuller Identity, then US3 to consume it in Vision and Competitive Path, then US4 to regenerate artifacts and prove all protected boundaries. Finish with the full suite and protected-path validation.
