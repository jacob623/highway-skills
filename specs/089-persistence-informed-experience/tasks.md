# Tasks: Persistence and Informed Experience

**Input**: Design documents from `/specs/089-persistence-informed-experience/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [quickstart.md](quickstart.md)

**Implementation constraint**: Do not modify individual skill files. Validation-tooling changes are limited to checks required for Feature 089 governance rules and metadata.

## Phase 1: Setup

**Purpose**: Confirm the existing governance and validation surfaces before changing them.

- [X] T001 Record the current Constitution and Experience Standard versions, rule counts, precedence rows, N1-N5/N3-N5 applicability, and focused test entry points in `specs/089-persistence-informed-experience/research.md`.
- [X] T002 [P] Verify the Feature 089 design artifacts and target paths in `specs/089-persistence-informed-experience/plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`.

## Phase 2: Foundational Validation

**Purpose**: Add focused checks before governance amendments so the new contracts fail before implementation and pass afterward.

- [X] T003 [P] Extend `.highway/tools/tests/constitution-inventory.test.sh` with deterministic assertions for Principle XII, P12 rule shape, N6-N9 registration, precedence, version reconciliation, and rule-count metadata.
- [X] T004 [P] Extend `.highway/tools/tests/highway-ux-alignment.test.sh` with deterministic assertions for X1.6, X2.9, X2.10, N7-N9 references, Interactive Workflow UX Contract guidance, and unchanged X2.1-X2.8 identifiers.
- [X] T005 Run `bash .highway/tools/tests/constitution-inventory.test.sh` and `bash .highway/tools/tests/highway-ux-alignment.test.sh` against the unamended documents and record the expected failures without changing governance files.

**Checkpoint**: Focused tests express the new contracts and fail only because the governing amendments are not yet present.

## Phase 3: User Story 1 - Trustworthy Retained-Output Completion (Priority: P1) 🎯 MVP

**Goal**: Add atomic Persistence and Completion Integrity rules, authoritative N6 registration, owner/orchestrator semantics, and reconciled Constitution version metadata.

**Independent Test**: Review the Constitution and run `bash .highway/tools/tests/constitution-inventory.test.sh`; verify P12 rules, N6 applicability, precedence, metadata, and multi-output completion semantics.

- [X] T006 [US1] Reconcile the Constitution footer with its latest completed Sync Impact Report and amend `.highway/governance/constitution.md` with the Feature 089 Sync Impact Report and resulting semantic version.
- [X] T007 [US1] Add Principle XII and atomic P12 rules for verification before a Verified Completion Claim, failure blocking, named failed output, multi-output coverage, and owner-result consumption in `.highway/governance/constitution.md`.
- [X] T008 [US1] Add the authoritative N6-N9 permitted-condition registrations, P12 per-rule N6 applicability notes, Principle XII precedence rank, rule/tier counts, self-application review, and non-restatement records in `.highway/governance/constitution.md`.
- [X] T009 [US1] Run `bash .highway/tools/tests/constitution-inventory.test.sh` and repair only Constitution-side rule-shape or metadata defects in `.highway/governance/constitution.md` until it passes.

**Checkpoint**: User Story 1 is independently reviewable and the constitutional inventory passes.

## Phase 4: User Story 2 - Informed Contextual Collection (Priority: P1)

**Goal**: Add Decision Context and Relevant Example obligations while preserving the one-unresolved-question contract and constitutional N/A ownership.

**Independent Test**: Review the Experience Standard and run `bash .highway/tools/tests/highway-ux-alignment.test.sh`; verify X2.9/X2.10 applicability, N7/N8 references, illustrative examples, and no additional response-demanding decision.

- [X] T010 [US2] Amend `.highway/governance/experience-standard.md` with the Feature 089 Sync Impact Report, reconciled version, Decision Context X2.9, Relevant Example X2.10, and N7/N8 references to the Constitution registry.
- [X] T011 [US2] Update the Interactive Workflow UX Contract and non-normative guidance in `.highway/governance/experience-standard.md` so context and examples support the one unresolved question without adding ceremony or a new X rule.
- [X] T012 [US2] Run `bash .highway/tools/tests/highway-ux-alignment.test.sh` and repair only Experience Standard rule, applicability, or contract defects in `.highway/governance/experience-standard.md` until it passes.

**Checkpoint**: User Story 2 is independently reviewable and informed collection remains compatible with X2.4.

## Phase 5: User Story 3 - Scan-Friendly and Honest Workflow Status (Priority: P1)

**Goal**: Add Presentation Label structure and persistence/status guidance without changing existing X2.1-X2.8 semantics or individual skills.

**Independent Test**: Review the Experience Standard's X1.6 and persistence/status guidance, then run the focused UX test and confirm ordinary prose remains N/A under N9.

- [X] T013 [US3] Add Presentation Label X1.6, Structured Information applicability N9, and persistence failure/completion presentation guidance in `.highway/governance/experience-standard.md`.
- [X] T014 [US3] Update `.highway/tools/tests/highway-ux-alignment.test.sh` to prove X1.6 and N9 behavior, preserve X2.1-X2.8 text and IDs, reject duplicate UX Contract copies, and verify no individual skill file is changed by the feature.
- [X] T015 [US3] Run `bash .highway/tools/tests/highway-ux-alignment.test.sh` and repair only the Feature 089 Experience Standard/test alignment defects until it passes.

**Checkpoint**: User Story 3 is independently reviewable and scan-friendly status behavior is governed without duplicating constitutional persistence rules.

## Phase 6: Polish and Cross-Cutting Validation

**Purpose**: Verify the complete feature against the specification, plan, and repository governance.

- [X] T016 [P] Verify that no individual skill file changed and that all Feature 089 validation-tooling changes are attributable to new rules, identifiers, N/A conditions, counts, precedence, or amendment metadata using `git diff --name-only` and the Feature 089 scope.
- [X] T017 [P] Run `git diff --check` and inspect the final diff for stale version metadata, duplicate N/A ownership, duplicate rules, or template placeholders.
- [X] T018 Run `.highway/tools/tests/run-all.sh` and resolve any Feature 089 regression before completion.
- [X] T019 Mark all completed tasks `[X]` in `specs/089-persistence-informed-experience/tasks.md` and record final validation results in `specs/089-persistence-informed-experience/quickstart.md` only if the documented expectations changed.

## Dependencies and Execution Order

- Setup (Phase 1) precedes Foundational Validation (Phase 2).
- Foundational Validation precedes all user stories.
- User Story 1 precedes User Stories 2 and 3 because the Constitution registry and precedence baseline are shared dependencies.
- User Story 2 precedes User Story 3 because both amend `experience-standard.md` and must not edit that file concurrently.
- Polish follows all three stories.

### Parallel opportunities

- T002, T003, and T004 can run in parallel after setup paths are confirmed.
- T016 and T017 can run in parallel after User Story 3.
- No governance-document implementation tasks are parallel because each governing file has ordered metadata and rule-count updates.

## Implementation Strategy

1. Establish failing focused checks.
2. Deliver User Story 1 as the MVP constitutional amendment.
3. Deliver User Story 2, then User Story 3, preserving shared Experience Standard file order.
4. Run focused checks after each story and the complete suite at the end.
5. Confirm the diff contains no skill-file migration and all task checkboxes are complete.

## Notes

- Every task has a sequential ID, required checkbox, story label where applicable, and an exact file path or command path.
- Tests are included because the specification requires measurable validation of governance rules, identifiers, N/A conditions, counts, metadata, precedence, and scope.
