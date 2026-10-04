---
description: "Actionable task list for Feature 125"
---

# Tasks: Constitution Collaborative Knowledge Cleanup

**Input**: Design documents from `specs/125-constitution-collaborative-knowledge-cleanup/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Tests**: Focused text and diff validation is required because the feature is a one-file governance cleanup.

## Phase 1: Setup

**Purpose**: Capture the existing Constitution boundaries before editing.

- [X] T001 Read `specs/125-constitution-collaborative-knowledge-cleanup/spec.md`, `plan.md`, `research.md`, `data-model.md`, and `quickstart.md`
- [X] T002 [P] Capture the current collaborative section, P12.5-P12.15 block, persistence boundary, precedence rows, and version footer from `.highway/governance/constitution.md`

## Phase 2: Foundational

**Purpose**: Establish protected content and implementation scope.

- [X] T003 Record the exact protected P12A.1, P12A.3, P12A.4, P12.5-P12.15, definition, lifecycle, governance, and version anchors in the implementation review for `.highway/governance/constitution.md`
- [X] T004 [P] Confirm the implementation scope contains exactly one target file: `.highway/governance/constitution.md`

## Phase 3: User Story 1 - Preserve the Collaborative Knowledge Model (Priority: P1)

**Goal**: Move and rename the complete collaborative knowledge section without changing its model or stable P12A identifiers.

**Independent Test**: Review `.highway/governance/constitution.md` and confirm the section order, heading, definitions, lifecycle, P12A.1-P12A.4 identifiers, protected rule text, and governance boundary.

- [X] T005 [US1] Move the complete collaborative knowledge section, including introduction, P12A.1-P12A.4, rationale, and lifecycle, to immediately after the acceptance-to-owner-result persistence boundary in `.highway/governance/constitution.md`
- [X] T006 [US1] Rename the moved heading and current rationale reference to `XIII. Collaborative Knowledge Development` while retaining P12A.1-P12A.4 in `.highway/governance/constitution.md`
- [X] T007 [US1] Verify the collaborative definitions, lifecycle, governance wording, P12A.1, P12A.3, and P12A.4 remain unchanged in `.highway/governance/constitution.md`

## Phase 4: User Story 2 - Make Authority Precedence Explicit (Priority: P1)

**Goal**: Make accepted Repository Context rank above transient collaborative reasoning.

**Independent Test**: Inspect the lower Principle Precedence table and Repository Context clarification in `.highway/governance/constitution.md`.

- [X] T008 [US2] Simplify only the P12A.2 Observable to `Artifact acceptance occurs only after a complete candidate result exists.` in `.highway/governance/constitution.md`
- [X] T009 [US2] Set Principle Precedence rank 11 to XI Repository Context with reason `Governs the authoritative accepted context that constrains context-dependent behavior.` in `.highway/governance/constitution.md`
- [X] T010 [US2] Set Principle Precedence rank 12 to XIII Collaborative Knowledge Development with reason `Governs transient collaborative reasoning within the boundaries established by accepted context and user authority.` in `.highway/governance/constitution.md`
- [X] T011 [US2] Verify ranks 1 through 10 and the Repository Context subordinate-context statements remain unchanged in `.highway/governance/constitution.md`

## Phase 5: User Story 3 - Preserve Version and Owner-Controlled Completion (Priority: P1)

**Goal**: Keep the owner mutation contract and unreleased Constitution version intact.

**Independent Test**: Compare the final `.highway/governance/constitution.md` against the protected P12.5-P12.15, persistence-boundary, governance, self-application, and version requirements.

- [X] T012 [US3] Verify P12.5-P12.15 and the acceptance-to-owner-result persistence boundary are unchanged in `.highway/governance/constitution.md`
- [X] T013 [US3] Update only a self-application principle-name reference from XII-A to XIII if such a current reference exists, preserving P12A.1-P12A.4 and the unchanged P12.5-P12.15 statement in `.highway/governance/constitution.md`
- [X] T014 [US3] Verify the Constitution version remains `6.1.0` and no evolution-aware or conversational-technique guidance was added in `.highway/governance/constitution.md`

## Phase 6: Polish and Cross-Cutting Validation

**Purpose**: Prove exact scope and repository compatibility without changing files outside the Constitution.

- [X] T015 [P] Run focused heading-order, exact-row, version, and protected-content checks from `specs/125-constitution-collaborative-knowledge-cleanup/quickstart.md`
- [X] T016 [P] Confirm the implementation diff names only `.highway/governance/constitution.md`
- [X] T017 Run `.highway/tools/tests/run-all.sh` and record the result for Feature 125
- [X] T018 Review the final diff against `spec.md` and confirm no parser, test, adapter, spec, or generated artifact was modified by implementation

## Dependencies and Execution Order

### Phase dependencies

- Phase 1 -> Phase 2 -> User Story 1 -> User Story 2 -> User Story 3 -> Phase 6.
- User Story 1 must establish the final section location before precedence rows are updated.
- User Story 2 must complete before final owner/version preservation checks.
- Phase 6 is the completion gate.

### Parallel opportunities

- T002 and T004 can run in parallel after T001.
- T015 and T016 can run in parallel after T014.

## Implementation Strategy

1. Establish the protected baseline and one-file scope.
2. Deliver the MVP by moving and renaming the collaborative section while preserving its content.
3. Apply the exact P12A.2 Observable and precedence corrections.
4. Verify owner-controlled completion, version, prohibited-content boundaries, diff scope, and full-suite compatibility.

## Completion Criteria

- Every task is checked.
- The final implementation diff contains only `.highway/governance/constitution.md`.
- The Constitution has the requested XI/XII/boundary/XIII order and precedence.
- P12A.2 has the exact simplified Observable.
- P12.5-P12.15, the persistence boundary, definitions, lifecycle, governance wording, and version `6.1.0` are preserved.
- The full repository validation command passes.
