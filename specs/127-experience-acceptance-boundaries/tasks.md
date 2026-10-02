---
description: "Actionable task list for Feature 127"
---

# Tasks: Experience Acceptance Boundaries

**Input**: Design documents from `specs/127-experience-acceptance-boundaries/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Tests**: Existing focused document-contract tests may be amended only where they assert superseded immediate-acceptance or acknowledgment-sequencing behavior. No new runtime test framework is needed.

## Phase 1: Setup

**Purpose**: Establish the current document and test baseline.

- [X] T001 Read `specs/127-experience-acceptance-boundaries/spec.md`, `plan.md`, `research.md`, `data-model.md`, and `quickstart.md`.
- [X] T002 Capture the current X2.18, X2.19, X2.21, X2.22, X2.25, Contextual Guidance, Contextual Re-evaluation, Constructive Advisory, examples, and Recommendation sets in `.highway/governance/experience-standard.md`.
- [X] T003 Run `bash .highway/tools/tests/experience-standard-amendment.test.sh` and `bash .highway/tools/tests/highway-ux-alignment.test.sh`; record stale assertion failures without changing the target document.

## Phase 2: Foundational

**Purpose**: Protect unchanged lifecycle and governance boundaries before the cleanup.

- [X] T004 Confirm the implementation inventory in `.highway/governance/experience-standard.md`: X2.8, X2.36, Contextual Acknowledgment definition, current Interaction model, Collaborative Development guidance, first two Contextual Re-evaluation paragraphs, readability guidance, Evolution-Aware Guidance, stable X IDs, and version `8.0.0` remain protected.
- [X] T005 Confirm no individual skill, retained template, schema, or unrelated governance artifact is in scope for `.highway/governance/experience-standard.md`.
- [X] T006 Record the current full-suite baseline with `bash .highway/tools/tests/run-all.sh`, separating existing failures from Feature 127 coverage.

**Checkpoint**: Protected content, test baseline, and one-file scope are explicit.

## Phase 3: User Story 1 - Distinguish Working Ideas from Accepted Candidates (Priority: P1) 🎯 MVP

**Goal**: Align the acceptance rules with the Working Idea to Converged Proposal lifecycle.

**Independent Test**: Review X2.18, X2.21, X2.22, and X2.25 in `.highway/governance/experience-standard.md` and verify that only a displayed complete candidate crosses an acceptance boundary.

### Implementation for User Story 1

- [X] T007 [US1] Replace X2.18 and its Observable in `.highway/governance/experience-standard.md` so selecting a displayed Converged Proposal accepts the complete candidate while agreement with a Working Idea remains collaborative development.
- [X] T008 [US1] Replace X2.21 and its Observable in `.highway/governance/experience-standard.md` so only materially interpreted Converged Proposals receive the artifact-review heading and acceptance request.
- [X] T009 [US1] Replace X2.22 and its Observable in `.highway/governance/experience-standard.md` so direct domain-complete input or a selected complete candidate bypasses redundant interpretation review under owner-controlled completeness.
- [X] T010 [US1] Replace X2.25 and its Observable in `.highway/governance/experience-standard.md` with the collaborative recommendation model and preserved user-authored alternative without requiring a choice prompt for every recommendation.
- [X] T011 [US1] Update the X2.19 Observable in `.highway/governance/experience-standard.md` so explanation, comparison, refinement, and additional-information requests do not cross acceptance for a Working Idea or Converged Proposal.

**Checkpoint**: User Story 1 is independently reviewable against all four acceptance-boundary rules and X2.19.

## Phase 4: User Story 2 - Re-evaluate Context Without Acknowledgment Ceremony (Priority: P1)

**Goal**: Make contextual re-evaluation the visible continuity pattern while preserving X2.8 and X2.36.

**Independent Test**: Review the contextual guidance, Contextual Re-evaluation, and Constructive Advisory sections in `.highway/governance/experience-standard.md`.

### Implementation for User Story 2

- [X] T012 [US2] Replace the stale Contextual Guidance acknowledgment sentences in `.highway/governance/experience-standard.md` with focused changed-understanding guidance governed by X2.8.
- [X] T013 [US2] Replace only the listed acknowledgment-specific Contextual Re-evaluation material in `.highway/governance/experience-standard.md` with the new contextual re-evaluation sequence, preserving the first two existing paragraphs.
- [X] T014 [US2] Update the Constructive Advisory conversational pattern in `.highway/governance/experience-standard.md` to interpret, sharpen, contribute, continue Working Idea development, present a Converged Proposal, and ask only when needed.
- [X] T015 [US2] Verify and preserve X2.8, X2.36, the current Interaction model, Collaborative Development guidance, readability guidance, and Evolution-Aware Guidance in `.highway/governance/experience-standard.md`.

**Checkpoint**: User Story 2 is independently reviewable without requiring a fixed acknowledgment formula or workflow narration.

## Phase 5: User Story 3 - Align Examples and Recommendation Sketches (Priority: P1)

**Goal**: Make non-normative examples and recommendation sets demonstrate the same lifecycle as the normative rules.

**Independent Test**: Review the examples and recommendation sketches in `.highway/governance/experience-standard.md` and classify each as Working Idea development or Converged Proposal acceptance.

### Implementation for User Story 3

- [X] T016 [US3] Replace the Workflow narration, Owner result, and Conversational continuity compliant examples in `.highway/governance/experience-standard.md` with interpretation, useful meaning, accepted context, and grounded continuation.
- [X] T017 [US3] Add Working Idea versus Converged Proposal and Mature contribution examples to the Interaction Examples section of `.highway/governance/experience-standard.md`.
- [X] T018 [US3] Update Recommendation sets in `.highway/governance/experience-standard.md` with Working Idea and Converged Proposal examples while retaining multi-candidate choices and the user-authored alternative.
- [X] T019 [US3] Review `.highway/governance/experience-standard.md` for stale immediate-acceptance wording, prohibited acknowledgment sequencing, numeric length targets, and accidental changes to protected content.

**Checkpoint**: User Story 3 is independently reviewable as a consistent shared contract.

## Phase 6: Polish and Cross-Cutting Validation

**Purpose**: Update only superseded test assertions and validate the completed cleanup.

- [X] T020 [P] Update only superseded X2.18/X2.19/X2.21/X2.22/X2.25 and acknowledgment-sequencing assertions in `.highway/tools/tests/experience-standard-amendment.test.sh`.
- [X] T021 [P] Update only superseded interaction-model assertions in `.highway/tools/tests/highway-ux-alignment.test.sh`; preserve all meaningful coverage and document superseded behavior comments.
- [X] T022 Run `bash .highway/tools/tests/experience-standard-amendment.test.sh` and `bash .highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T023 Run the focused structural, preservation, version, scope, and whitespace checks from `specs/127-experience-acceptance-boundaries/quickstart.md`.
- [X] T024 Review `git diff -- .highway/governance/experience-standard.md .highway/tools/tests/experience-standard-amendment.test.sh .highway/tools/tests/highway-ux-alignment.test.sh` against the spec and research; confirm no unrelated files changed.
- [X] T025 Run `bash .highway/tools/tests/run-all.sh` and report the full-suite result separately from Feature 127 requirement coverage.
- [X] T026 Confirm all requirements and acceptance scenarios are covered, all tasks are marked complete, and focused checks pass.

## Dependencies and Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; captures the baseline.
- **Foundational (Phase 2)**: Depends on Setup; protects unchanged content and scope.
- **User Stories (Phases 3-5)**: Depend on Foundational and edit one shared document, so execute sequentially in priority order.
- **Polish (Phase 6)**: Depends on all story work; test assertions may be updated only after the target document behavior is complete.

### User Story Dependencies

- **User Story 1 (P1)**: Establishes acceptance-boundary semantics.
- **User Story 2 (P1)**: Depends on the lifecycle vocabulary established by User Story 1.
- **User Story 3 (P1)**: Depends on the finalized lifecycle and continuity semantics from User Stories 1 and 2.

### Parallel Opportunities

- T020 and T021 can run in parallel after document implementation because they touch different test files.
- T022 and T023 can run independently after T020/T021 complete, but focused checks should run before any repair.
- No document implementation tasks are marked `[P]` because all stories modify the same governance document.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Implement the acceptance-boundary rule changes in User Story 1.
3. Review the result independently against X2.18, X2.19, X2.21, X2.22, and X2.25.
4. Continue through User Stories 2 and 3 because the requested cleanup requires the complete lifecycle alignment.

### Incremental Delivery

1. Protect unchanged rules and establish the baseline.
2. Align normative acceptance rules.
3. Replace stale acknowledgment continuity guidance.
4. Align examples and recommendation sketches.
5. Update only stale test assertions.
6. Run focused checks, scope review, and the full suite.

## Notes

- The implementation target is one shipped document. Test files are amended only to remove assertions of explicitly superseded behavior.
- X2.8, X2.36, the Contextual Acknowledgment definition, stable X IDs, and version `8.0.0` remain unchanged.
- No contracts directory or runtime implementation is required.
