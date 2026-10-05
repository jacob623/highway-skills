# Tasks: Experience Convergence Discipline

**Input**: Design documents from `/specs/139-experience-convergence-discipline/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `quickstart.md`

**Tests**: Focused static document-contract tests are included because the feature specification requires verifiable Experience Standard coverage.

**Organization**: Tasks are grouped by user story to keep the amendment and its validation traceable.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the baseline and focused contract-test surface.

- [X] T001 Inspect `.highway/governance/experience-standard.md`, `.highway/library/knowledge/highway-identity.md`, and `.highway/governance/constitution.md` to confirm current version 8.2.0, latest rule X2.40, protected boundaries, and amendment conventions.
- [X] T002 [P] Create the focused Experience Standard contract test scaffold in `.highway/tools/tests/experience-standard-convergence.test.sh` with source-path setup, `require_text`, `require_absent`, and failure aggregation helpers.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish shared invariants before story-specific amendments.

- [X] T003 Add baseline assertions to `.highway/tools/tests/experience-standard-convergence.test.sh` for exactly one current Sync Impact Report, version metadata, X-rule identifier continuity through X2.40, and protected-file stability.
- [X] T004 [P] Add source and generated-tree independence checks to `.highway/tools/tests/experience-standard-convergence.test.sh` so the test rejects edits to `.highway/governance/constitution.md` and `.highway/skills/highway-profile/SKILL.md` for this feature's validation fixture.

**Checkpoint**: The focused contract test can detect the pre-amendment standard and remains scoped to shared Experience Standard behavior.

---

## Phase 3: User Story 1 - Prevent premature convergence (Priority: P1) 🎯 MVP

**Goal**: Distinguish a complete candidate from a substantively converged Working Idea and prevent premature acceptance presentation.

**Independent Test**: Run `.highway/tools/tests/experience-standard-convergence.test.sh` and confirm the definition, X2.13 Observable, X2.41 rule, and mature-contribution safeguards are all present.

### Tests for User Story 1

- [X] T005 [US1] Add assertions in `.highway/tools/tests/experience-standard-convergence.test.sh` for the revised Converged Proposal definition, revised X2.13 Observable, and exact X2.41 Rule/Observable/Tier wording.

### Implementation for User Story 1

- [X] T006 [US1] Amend the Definitions, X2.13 Observable, and X2 rule table in `.highway/governance/experience-standard.md` to distinguish domain completeness from conversational convergence and add X2.41 without renumbering existing rules.
- [X] T007 [US1] Update the Interaction model in `.highway/governance/experience-standard.md` so a complete candidate does not automatically require convergence, while preserving mature and directly domain-complete exceptions and one-question behavior.

**Checkpoint**: User Story 1 is independently verifiable through the focused contract test.

---

## Phase 4: User Story 2 - Support recursive user-Highway development (Priority: P1)

**Goal**: Make Highway contributions, user responses, re-evaluation, advisory uncertainty, and continued development an explicit adaptive loop.

**Independent Test**: Verify the amended standard describes a Highway contribution becoming new reasoning material after the person's response and continuing only while substantive understanding improves.

### Tests for User Story 2

- [X] T008 [P] [US2] Add assertions in `.highway/tools/tests/experience-standard-convergence.test.sh` for recursive Collaborative Development, visible advisory grounding, updated Constructive Advisory sequence, and updated Contextual Re-evaluation flow.

### Implementation for User Story 2

- [X] T009 [US2] Amend Collaborative Development and Constructive Advisory guidance in `.highway/governance/experience-standard.md` to describe recursive user-Highway contributions, visible uncertainty, conversational advisory possibilities, and the revised development pattern.
- [X] T010 [US2] Amend Contextual Re-evaluation guidance in `.highway/governance/experience-standard.md` to include user response, re-evaluation of the changed Working Idea, further useful contribution, continued development, and natural conclusion.

**Checkpoint**: User Story 2 is independently verifiable by the focused recursive-guidance assertions.

---

## Phase 5: User Story 3 - Preserve distinct acceptance and contribution boundaries (Priority: P1)

**Goal**: Keep Contribution Opportunity, Converged Proposal, acceptance, persistence, and over-conversation safeguards distinct while allowing substantive responses to re-enter development.

**Independent Test**: Confirm the standard says a materially changing Contribution Opportunity response can continue development, while a settled non-substantive response can proceed to the Converged Proposal.

### Tests for User Story 3

- [X] T011 [P] [US3] Add assertions in `.highway/tools/tests/experience-standard-convergence.test.sh` for Contribution Opportunity behavior, contextual boundaries, recommendation-set guidance, interaction examples, and preserved over-conversation safeguards.

### Implementation for User Story 3

- [X] T012 [US3] Amend Contribution Opportunity guidance in `.highway/governance/experience-standard.md` so it is part of Working Idea development rather than a checkout lane, and preserve the no-recurring-ceremonial-question safeguard.
- [X] T013 [US3] Add the premature-convergence and complete-candidate-but-developing-idea examples to the Interaction Examples section of `.highway/governance/experience-standard.md` while preserving the Mature contribution example.
- [X] T014 [US3] Refine Recommendation sets guidance in `.highway/governance/experience-standard.md` so recommendations remain Working Ideas while their meaning is changing and only settled meaning with a complete candidate is suitable for Converged Proposal treatment.

**Checkpoint**: User Story 3 is independently verifiable without changing acceptance, persistence, or owner authority.

---

## Phase 6: User Story 4 - Make the shared standard actionable without expanding scope (Priority: P2)

**Goal**: Complete versioning, self-application, Constitution compatibility, and cross-document validation for the focused amendment.

**Independent Test**: Run the focused test, existing Experience Standard tests, UX alignment test, and full suite with zero failures and no protected-file changes.

### Tests for User Story 4

- [X] T015 [US4] Add assertions in `.highway/tools/tests/experience-standard-convergence.test.sh` for version 8.3.0, the updated Last Amended date, self-application review, non-restatement boundaries, and unchanged protected owner documents.

### Implementation for User Story 4

- [X] T016 [US4] Add the 8.2.0-to-8.3.0 Sync Impact Report, update Version and Last Amended metadata, and record the self-application and Constitution compatibility review in `.highway/governance/experience-standard.md`.
- [X] T017 [US4] Run the focused contract, existing Experience Standard, UX alignment, and full-suite commands from `specs/139-experience-convergence-discipline/quickstart.md`, and resolve any amendment-specific failures without changing protected owner files.

**Checkpoint**: All four user stories are independently covered by the document contract and repository suite.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Final consistency and scope verification.

- [X] T018 [P] Run `git diff --check` and inspect `git diff --stat` for `.highway/governance/experience-standard.md`, `.highway/tools/tests/experience-standard-convergence.test.sh`, and feature 139 artifacts.
- [X] T019 Verify `.highway/governance/constitution.md` and `.highway/skills/highway-profile/SKILL.md` are unchanged by this feature, and confirm no `contracts/` directory is needed for the document-only scope.
- [X] T020 Run `bash .highway/tools/tests/run-all.sh` and record the passing result in the implementation completion report.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes the focused test surface.
- **Foundational (Phase 2)**: Depends on Setup; blocks story work until invariants and scope checks exist.
- **User Story 1 (Phase 3)**: Depends on Foundational; MVP and prerequisite for the remaining amendment sections.
- **User Story 2 (Phase 4)**: Depends on Foundational; can proceed after the source anchors are understood, but integrates with the Interaction model from US1.
- **User Story 3 (Phase 5)**: Depends on US1 and the shared model; preserves boundaries around the new convergence rule.
- **User Story 4 (Phase 6)**: Depends on US1-US3; finalizes metadata and cross-document validation.
- **Polish (Phase 7)**: Depends on all user stories.

### User Story Dependencies

- **US1 (P1)**: Foundational only; MVP.
- **US2 (P1)**: Foundational, with source-section coordination after US1.
- **US3 (P1)**: US1 and US2 guidance are available before boundary examples and recommendation guidance are finalized.
- **US4 (P2)**: Depends on all preceding amendment content.

### Parallel Opportunities

- T002 and T004 can be developed in parallel because they affect separate test regions.
- T008 and T011 can be prepared in parallel because they add separate assertion groups to the focused test.
- T009 and T010 can be implemented in parallel only when edits are applied to separate anchored sections and then validated together.
- T018 and T019 can be reviewed in parallel after implementation.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Implement US1: revised definition, X2.13 Observable, X2.41, and Interaction model guardrails.
3. Run the focused contract test and the existing Experience Standard contract.
4. Continue to US2-US4 only after the premature-convergence behavior is independently verified.

### Incremental Delivery

1. Add recursive development guidance in US2.
2. Add Contribution Opportunity, examples, and recommendation boundary guidance in US3.
3. Complete versioning, self-application, protected-path checks, and full-suite validation in US4.
4. Finish with whitespace, scope, and full-suite checks.

## Notes

- Every task uses the required checkbox, sequential ID, optional parallel marker, story label where applicable, and exact file path format.
- The implementation must not modify `highway-profile`, the Highway Skills Constitution, owner schemas, or persistence behavior.
- No external interface contracts are required.
