# Tasks: Experience Governance Wording Corrections

## Dependencies

- Setup and foundational tasks must complete before story work.
- User Story 1 and User Story 2 both modify `experience-standard.md` and therefore execute sequentially.
- User Story 3 modifies `constitution.md` and may proceed after foundational validator review, but final validation is shared.
- Polish tasks run after all three stories.

## Phase 1: Setup

- [X] T001 Confirm Feature 090 design artifacts and governing-document paths in `specs/090-experience-governance-wording-corrections/plan.md`
- [X] T002 [P] Record the current Experience Standard and Constitution identifier, tier, N/A, precedence, and amendment metadata baselines in `specs/090-experience-governance-wording-corrections/quickstart.md`

## Phase 2: Foundational Validation

- [X] T003 Inspect existing governance parsing and assertion helpers in `.highway/tools/lib/constitution.sh`, `.highway/tools/lib/rule-checks.sh`, and `.highway/tools/tests/test-helpers.sh` before adding Feature 090 checks
- [X] T004 [P] Define focused Feature 090 validation expectations for authority wording, X2.9 five-category alignment, preserved boundaries, and amendment history in `.highway/tools/tests/highway-ux-alignment.test.sh`
- [X] T005 [P] Define focused Feature 090 validation expectations for Principle XII placement, affected ranks, duplicate rationale count, and version classification in `.highway/tools/tests/constitution-inventory.test.sh`

## Phase 3: User Story 1 - Clear Experience Contract Authority

**Goal**: Make the Interactive Workflow UX Contract identify the X2 namespace as the sole normative authority, generalize its disclaimer, and remove the orphaned rationale.

**Independent test**: `bash .highway/tools/tests/highway-ux-alignment.test.sh` confirms both authority passages and the absence of the orphaned Repository Context/X2.7-X2.8 rationale.

- [X] T006 [US1] Update the Interactive Workflow UX Contract authority statement and interpretive-scope wording in `.highway/governance/experience-standard.md`
- [X] T007 [US1] Generalize the contract disclaimer to normative rule text and X identifiers without limiting protection to X2.2-X2.6 in `.highway/governance/experience-standard.md`
- [X] T008 [US1] Remove the incomplete Repository Context/X2.7-X2.8 bump rationale and preserve surrounding amendment history in `.highway/governance/experience-standard.md`
- [X] T009 [US1] Record the resulting Experience Standard semantic version, changed wording, unchanged boundaries, and self-application review in `.highway/governance/experience-standard.md`
- [X] T010 [US1] Run the focused UX alignment validator and confirm User Story 1 assertions pass in `.highway/tools/tests/highway-ux-alignment.test.sh`

## Phase 4: User Story 2 - Precise Decision Context Applicability

**Goal**: Align X2.9's trigger with its Observable's five downstream outcome categories while preserving its identity, Tier, Sample classification convention, N7 condition, and intended applicability boundary.

**Independent test**: The focused UX alignment validator confirms recommendations, decisions, artifacts, governance interpretations, and workflow actions occur in both X2.9 trigger and Observable without changing rule metadata.

- [X] T011 [US2] Update only the minimum X2.9 trigger wording needed to name all five downstream outcome categories in `.highway/governance/experience-standard.md`
- [X] T012 [US2] Preserve X2.9's identifier, Tier, Sample classification convention, Observable boundary, N7 condition, and normative rule shape in `.highway/governance/experience-standard.md`
- [X] T013 [US2] Record the X2.9 wording alignment, unchanged applicability boundary, and self-application review in the Experience Standard amendment history in `.highway/governance/experience-standard.md`
- [X] T014 [US2] Run the focused UX alignment validator and confirm User Story 2 assertions pass in `.highway/tools/tests/highway-ux-alignment.test.sh`

## Phase 5: User Story 3 - Correct Constitutional Precedence and History

**Goal**: Move Principle XII directly after Principle V, preserve unaffected ordering and sequential ranks, remove the duplicate Principle XI rationale, and explicitly classify the conflict-resolution impact under the Constitution Versioning Policy.

**Independent test**: The focused constitution inventory validator confirms the precedence sequence, rank continuity, one complete Principle XI rationale, preserved rule metadata, and explicit semantic-version classification.

- [X] T015 [US3] Move Principle XII directly after Principle V and before Principle VIII while renumbering affected precedence ranks sequentially in `.highway/governance/constitution.md`
- [X] T016 [US3] Remove the duplicate Principle XI bump rationale while retaining one complete authoritative rationale in `.highway/governance/constitution.md`
- [X] T017 [US3] Classify the Principle XII precedence change under the Constitution Versioning Policy and record the semantic version, conflict-resolution rationale, changed elements, unchanged boundaries, and self-application review in `.highway/governance/constitution.md`
- [X] T018 [US3] Run the focused constitution inventory validator and confirm User Story 3 assertions pass in `.highway/tools/tests/constitution-inventory.test.sh`

## Phase 6: Polish and Cross-Cutting Validation

- [X] T019 [P] Update focused validator assertions only as needed to prove FR-012 and SC-001 through SC-008 without modifying individual skill files in `.highway/tools/tests/highway-ux-alignment.test.sh` and `.highway/tools/tests/constitution-inventory.test.sh`
- [X] T020 Run `.highway/tools/tests/run-all.sh` and confirm zero failures across the repository
- [X] T021 Run `git diff --check` and verify the diff is limited to the Feature 090 governing documents, required validators, and feature artifacts
- [X] T022 Mark all completed tasks `[X]` in `specs/090-experience-governance-wording-corrections/tasks.md` and record final validation results in `specs/090-experience-governance-wording-corrections/quickstart.md`

## Parallel Opportunities

- T002, T004, and T005 can be prepared in parallel after setup.
- T019 is validator-only work and can be prepared alongside review of the final document changes, but execution must precede T020.
- Constitution work in T015-T018 can proceed independently of the Experience Standard edits once T003-T005 are complete.

## Implementation Strategy

Deliver the correction in three independently reviewable slices: authority and history cleanup, X2.9 alignment, then constitutional precedence and versioning. Use the focused validators after each slice, followed by the complete suite and whitespace/scope checks. The MVP is the governing-document corrections plus focused proof for User Story 1; the complete feature requires all three stories and the cross-cutting validation phase.
