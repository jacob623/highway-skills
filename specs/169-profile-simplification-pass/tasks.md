---

# Tasks: Profile Simplification Pass

**Input**: Design documents from `/specs/169-profile-simplification-pass/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/profile-simplification-pass.md, quickstart.md

**Tests**: Focused static contract validation and existing Profile contracts are required by the implementation plan.

## Phase 1: Setup

**Purpose**: Confirm current Profile section boundaries and coupled verification assertions.

- [X] T001 Inspect the current Profile source headings, four Discovery Contribution Opportunity sections, verification block, and coupled tests in `.highway/skills/highway-profile/SKILL.md`, `.highway/tools/tests/feature-152-profile-conversation-conformance.test.sh`, and `.highway/tools/tests/feature-153-delivery-sites.test.sh`

## Phase 2: Foundational

**Purpose**: Establish the focused static contract before changing the guidance.

- [X] T002 [P] Create `.highway/tools/tests/feature-169-profile-simplification.test.sh` to assert removal of the five standalone sections, preservation of Interpretation confidence, required structure guidance in all four opportunities, removal of obsolete verification claims, protected boundaries, and generated adapter correspondence

## Phase 3: User Story 1 - Use Discovery Contribution Opportunities as the dominant model (Priority: P1) MVP

**Goal**: Remove the five competing standalone guidance sections while retaining the four domain-specific opportunities and their existing proposal-first flow.

**Independent Test**: The Feature 169 focused contract confirms the five section headings are absent and the four Discovery Contribution Opportunity headings and reaction paths remain present.

### Implementation

- [X] T003 [US1] Remove the standalone Advisory question scaffolding, Contribution in practice, Possibility-list Contribution Opportunities, Structure-revealing contributions, and Organizational expression sections from `.highway/skills/highway-profile/SKILL.md` without changing the retained Interpretation confidence guidance or domain boundaries

**Checkpoint**: The Profile source has one dominant development model and no competing standalone sections.

## Phase 4: User Story 2 - Preserve proposal-first interpretation and grounded structure (Priority: P1)

**Goal**: Keep Interpretation confidence unchanged and fold the useful structure-revealing concept into each active domain opportunity.

**Independent Test**: The focused contract finds the preserved Interpretation confidence statements and exactly one required structure sentence in each Identity, Vision, Competitive Path, and Guiding Principles opportunity.

### Implementation

- [X] T004 [US2] Add `Use the proposed starting point to reveal relationships, patterns, structure, tensions, tradeoffs, implications, dependencies, and organizing principles already supported by accepted evidence.` to the Identity, Vision, Competitive Path, and Guiding Principles Discovery Contribution Opportunity sections in `.highway/skills/highway-profile/SKILL.md`
- [X] T005 [US2] Verify and preserve the existing Interpretation confidence guidance in `.highway/skills/highway-profile/SKILL.md`, including the fallback for evidence that cannot support a responsible starting point

**Checkpoint**: Grounded reasoning remains available only through the proposed starting point and existing focused clarification fallback.

## Phase 5: User Story 3 - Remove obsolete verification claims while preserving boundaries (Priority: P2)

**Goal**: Align verification guidance and directly coupled static contracts with the surviving Discovery Contribution Opportunity model.

**Independent Test**: Focused and existing Profile contracts reject obsolete worked-example and acknowledgment claims while preserving acceptance, persistence, readiness, ownership, attribution, convergence, and schema assertions.

### Implementation

- [X] T006 [US3] Remove the three worked-exemplar, counter-example, per-contribution acknowledgment, and acknowledgment-beyond-restatement verification bullets from the Profile verification section in `.highway/skills/highway-profile/SKILL.md`
- [X] T007 [US3] Update directly coupled obsolete assertions in `.highway/tools/tests/feature-152-profile-conversation-conformance.test.sh` and `.highway/tools/tests/feature-153-delivery-sites.test.sh` while preserving unrelated protected-boundary checks

**Checkpoint**: Verification describes the active model without weakening retained Profile lifecycle or ownership guarantees.

## Phase 6: Polish & Cross-Cutting Validation

**Purpose**: Regenerate distributed artifacts and execute all validation gates.

- [X] T008 Regenerate Profile adapters, catalog indexes, and adapter manifest with `.highway/tools/generate-agent-adapters.sh` and `.highway/tools/generate-catalog.sh`
- [X] T009 Run `.highway/tools/validate-skill.sh .highway/skills/highway-profile`, `.highway/tools/tests/feature-169-profile-simplification.test.sh`, all directly coupled Profile contracts, `.highway/tools/tests/run-all.sh`, and `git diff --check`
- [X] T010 Review the final diff against FR-001 through FR-013 and mark this task list complete after all validation passes

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: T001 has no dependency.
- **Foundational (Phase 2)**: T002 depends on T001 and blocks implementation validation.
- **User Stories (Phase 3+)**: T003 depends on T002. T004 and T005 depend on T003 and must remain sequential because they edit the same source. T006 and T007 depend on the updated source and focused contract.
- **Polish (Phase 6)**: T008 depends on T003-T007. T009 depends on T008. T010 depends on T009.

### Parallel Opportunities

- T002 can be prepared after T001 independently of source implementation.
- T004 and T005 are sequential because they share the authoritative Profile file.
- T007 can update the two coupled test files in parallel if independently staffed.
- Adapter and catalog generation in T008 are independent generator operations after source changes.

## Implementation Strategy

### MVP First

1. Complete T001-T002.
2. Complete T003 for User Story 1.
3. Run the focused contract to verify the dominant model.

### Incremental Delivery

1. Remove competing sections and validate User Story 1.
2. Fold structure guidance into all four opportunities and validate User Story 2.
3. Align verification claims and coupled contracts for User Story 3.
4. Regenerate delivery artifacts.
5. Run the Profile validator and full repository suite.

## Notes

- The authoritative source remains `.highway/skills/highway-profile/SKILL.md`.
- No new runtime service, lifecycle state, persisted artifact, readiness dimension, retained field, or schema change is permitted.
- Static contracts establish document evidence only; they do not prove live conversational behavior.
