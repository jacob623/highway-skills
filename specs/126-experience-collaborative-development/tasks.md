---
description: "Actionable task list for Feature 126"
---

# Tasks: Experience Standard Collaborative Development

**Input**: Design documents from `specs/126-experience-collaborative-development/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Tests**: Focused document-contract validation is required. No repository test file may be changed because the feature implementation boundary is one file.

## Phase 1: Setup

**Purpose**: Capture the current Experience Standard and implementation boundary.

- [X] T001 Read `specs/126-experience-collaborative-development/spec.md`, `plan.md`, `research.md`, `data-model.md`, and `quickstart.md`.
- [X] T002 Confirm the baseline rule inventory, current X2.8/X2.36 rows, version footer, interaction model, and cross-reference paths in `.highway/governance/experience-standard.md`.
- [X] T003 Confirm the implementation diff target is exactly `.highway/governance/experience-standard.md`; leave tests, skills, schemas, and other governance artifacts unchanged.

## Phase 2: Foundational

**Purpose**: Establish protected content and the version decision before editing the shared standard.

- [X] T004 Record the protected Experience Standard rules, guidance, examples, ownership boundaries, and unlisted-content carry-forward requirements in the implementation review for `.highway/governance/experience-standard.md`.
- [X] T005 Apply the versioning-policy compatibility review to the revised X2.8 obligation and record whether the final document remains `7.2.0` or becomes MAJOR `8.0.0` in `.highway/governance/experience-standard.md`.

**Checkpoint**: Protected content, scope, and version classification are explicit before the document edit.

## Phase 3: User Story 1 - Develop Ideas Collaboratively Before Capture (Priority: P1) 🎯 MVP

**Goal**: Make the shared standard support Working Ideas, Converged Proposals, inner and outer collaborative loops, and transient Active Reasoning Context.

**Independent Test**: Inspect `.highway/governance/experience-standard.md` and confirm an exploratory contribution may be interpreted, sharpened, connected, and developed without artifact persistence, while a complete candidate can converge without unnecessary turns.

### Implementation for User Story 1

- [X] T006 [US1] Add or revise the non-normative Collaborative Development, Active Reasoning Context, and Contextual Re-evaluation guidance in `.highway/governance/experience-standard.md`.
- [X] T007 [US1] Replace the explanatory interaction model and old acknowledgment pattern with the requested inner and post-acceptance outer loops in `.highway/governance/experience-standard.md`.
- [X] T008 [US1] Add working-agreement versus artifact-acceptance guidance and ensure the retained artifact schema does not dictate conversational field order in `.highway/governance/experience-standard.md`.

**Checkpoint**: User Story 1 is independently reviewable as the MVP document behavior.

## Phase 4: User Story 2 - Re-evaluate Context and Contribute Useful Perspective (Priority: P1)

**Goal**: Replace acknowledgment-as-paraphrase with contextual interpretation and useful grounded contribution while preserving natural conclusions.

**Independent Test**: Inspect X2.8 and the surrounding Conversational Presence, Constructive Advisory, and re-evaluation guidance in `.highway/governance/experience-standard.md`.

### Implementation for User Story 2

- [X] T009 [US2] Revise X2.8's rule, Observable, and tier in `.highway/governance/experience-standard.md` so changed understanding is reflected with relevant accumulated context and is not merely repeated or narrated.
- [X] T010 [US2] Add anti-paraphrase and readability guidance, compliant and non-compliant examples, and the clarification that collaborative turns need not contain a question in `.highway/governance/experience-standard.md`.
- [X] T011 [US2] Preserve or strengthen X2.36 and its supporting workflow-narration guidance without duplicating or renumbering the existing rule in `.highway/governance/experience-standard.md`.

**Checkpoint**: User Story 2 is independently reviewable against the revised X2.8 and no-workflow-narration contract.

## Phase 5: User Story 3 - Preserve Ownership, Focus, and Proportionality (Priority: P1)

**Goal**: Keep Highway contributions distinct from accepted organizational knowledge, preserve owner-controlled completeness, and ground advice in present reality with room for evolution.

**Independent Test**: Review ownership, artifact-completeness, recommendation, single-question, evolution-aware, scope, and versioning guidance in `.highway/governance/experience-standard.md`.

### Implementation for User Story 3

- [X] T012 [US3] Add or revise recommendation guidance so recommendations may be complete proposals or grounded starting points while preserving the user-authored alternative and acceptance boundary in `.highway/governance/experience-standard.md`.
- [X] T013 [US3] Add user-ownership and artifact-ownership guidance that defers domain completeness to the owning skill and keeps interpretations, implications, alternatives, and opinions unaccepted until the applicable boundary in `.highway/governance/experience-standard.md`.
- [X] T014 [US3] Add Evolution-Aware Guidance and the present-reality/plausible-evolution example without asserting unsupported organizational futures in `.highway/governance/experience-standard.md`.

**Checkpoint**: User Story 3 is independently reviewable without changing any retained schema or individual skill.

## Phase 6: Polish and Cross-Cutting Validation

**Purpose**: Validate the one-file amendment against the specification, plan, and repository evidence.

- [X] T015 Run the focused structural, exact-row, version, cross-reference, and scope checks from `specs/126-experience-collaborative-development/quickstart.md`.
- [X] T016 Review `git diff -- .highway/governance/experience-standard.md` against `spec.md`, `research.md`, and `data-model.md`; confirm no prohibited content or unrelated edits were introduced.
- [X] T017 Run `bash .highway/tools/tests/run-all.sh` and record the result separately from Feature 126 requirement coverage, preserving the known unrelated Constitution inventory failure if it remains.
- [X] T018 Confirm all Feature 126 requirements and acceptance scenarios are covered, all tasks are marked complete, and `git diff --check` passes.

## Dependencies and Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes the baseline.
- **Foundational (Phase 2)**: Depends on Setup; blocks document editing.
- **User Stories (Phases 3-5)**: Depend on Foundational. Because all stories edit one document, execute them sequentially in priority order even though their review criteria are independently testable.
- **Polish (Phase 6)**: Depends on all user-story work.

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Phase 2; establishes the collaborative model and interaction loops.
- **User Story 2 (P1)**: Starts after User Story 1; applies the revised response behavior to the established model.
- **User Story 3 (P1)**: Starts after User Story 2; preserves authority, ownership, and proportionality around the complete model.

### Parallel Opportunities

- No implementation tasks are marked `[P]` because every story task changes the same governance document.
- T015 and T017 can be run independently after the document edit, provided the focused validation is run before any repair.
- T016 and T018 are independent review tasks after T015 and T017 complete.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Complete User Story 1 in `.highway/governance/experience-standard.md`.
3. Run its independent review and focused checks.
4. Continue to User Stories 2 and 3 because the requested feature requires the complete shared model.

### Incremental Delivery

1. Establish protected content and version decision.
2. Add collaborative development and re-evaluation behavior.
3. Apply revised X2.8 and no-workflow-narration guidance.
4. Preserve ownership and evolution-aware boundaries.
5. Run focused validation, full-suite compatibility, and final scope review.

## Notes

- Every task names the target file or a concrete validation path.
- The implementation must not modify `.highway/tools/tests/constitution-inventory.test.sh` or other out-of-scope files.
- The full-suite result and Feature 126 requirement coverage are separate completion claims.
