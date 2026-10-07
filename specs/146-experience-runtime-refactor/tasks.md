# Tasks: Experience Runtime Refactor

**Input**: Design documents from `/specs/146-experience-runtime-refactor/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Focused document-contract tests and the full repository suite are required because the feature changes a shared runtime governance contract.

## Phase 1: Setup

**Purpose**: Confirm the existing document and validation surface before editing.

- [X] T001 Inspect `.highway/governance/experience-standard.md` and record the current X-rule inventory, amendment metadata, protected sections, and development-governance references in `specs/146-experience-runtime-refactor/research.md`
- [X] T002 [P] Inspect `.highway/tools/tests/experience-standard-amendment.test.sh`, `.highway/tools/tests/experience-standard-convergence.test.sh`, and `.highway/tools/tests/feature-141-experience-standard-refactor.test.sh` for assertions that must be amended in `specs/146-experience-runtime-refactor/quickstart.md`

## Phase 2: Foundational

**Purpose**: Establish the document-contract validation expectations before the story edits.

- [X] T003 Add the Feature 146 expected runtime-boundary, rule-ID, version, and forbidden-token assertions to `.highway/tools/tests/experience-standard-amendment.test.sh`
- [X] T004 [P] Add the Feature 146 convergence and short-path assertions to `.highway/tools/tests/experience-standard-convergence.test.sh`
- [X] T005 [P] Update stale Feature 141 Experience Standard expectations in `.highway/tools/tests/feature-141-experience-standard-refactor.test.sh` while preserving its historical contract purpose
- [X] T006 Run the focused Experience Standard tests and record the expected pre-implementation failures for the changed contract in the implementation notes

**Checkpoint**: Validation expectations are explicit and fail for the unamended Experience Standard.

## Phase 3: User Story 1 - Runtime authority is self-contained (Priority: P1) [MVP]

**Goal**: Make the Experience Standard independently usable at runtime without the Highway Skills Constitution or development/test machinery.

**Independent Test**: Review and run the focused amendment contract without loading the Highway Skills Constitution; it passes with no Constitution, P namespace, tier, or self-application runtime dependency.

- [X] T007 [US1] Rewrite scope, runtime authority boundaries, and precedence in `.highway/governance/experience-standard.md` so security/safety, owning skills, accepted knowledge, active correction, and generic interaction are the only relevant runtime authorities
- [X] T008 [US1] Remove Constitution references, Tier Definitions, tier columns/labels, self-application mechanics, and detailed runtime versioning policy from `.highway/governance/experience-standard.md`
- [X] T009 [US1] Retain and simplify the epistemic, ownership, acceptance, and persistence definitions in `.highway/governance/experience-standard.md` without moving owner semantics into Experience
- [X] T010 [US1] Set the Experience Standard amendment metadata to version `9.0.0` and record the major refactor and stable-ID retirement mapping in `.highway/governance/experience-standard.md`
- [X] T011 [US1] Run `bash .highway/tools/tests/experience-standard-amendment.test.sh` and verify User Story 1 independently

**Checkpoint**: The runtime standard is self-contained and the MVP contract passes.

## Phase 4: User Story 2 - Highway contributes useful grounded perspective (Priority: P1)

**Goal**: Make constructive advisory reasoning a normal runtime behavior while preserving epistemic restraint.

**Independent Test**: Review advisory examples and rules with accepted evidence that supports a non-obvious observation; verify it remains a Working Idea until acceptance and does not force commentary when no useful contribution exists.

- [X] T012 [US2] Rewrite Constructive Advisory and related context guidance in `.highway/governance/experience-standard.md` to permit useful observant-outsider reasoning without asserting organizational fact
- [X] T013 [US2] Rationalize X2.2 and X2.13 separately in `.highway/governance/experience-standard.md` so evidence reuse and useful grounded reasoning precede questions without duplicating X2.4
- [X] T014 [US2] Preserve flexible recommendation behavior, user-authored alternatives, epistemic restraint, and mature-input short paths in `.highway/governance/experience-standard.md`
- [X] T015 [US2] Run `bash .highway/tools/tests/experience-standard-convergence.test.sh` and verify User Story 2 independently

## Phase 5: User Story 3 - Corrections cause meaningful re-evaluation (Priority: P1)

**Goal**: Make substantive corrections alter active understanding and the next user-visible behavior.

**Independent Test**: Review correction scenarios and confirm that material changes trigger re-evaluation while internal re-evaluation need not be narrated.

- [X] T016 [US3] Consolidate X2.8 into X2.38 and retire X2.8 in `.highway/governance/experience-standard.md`, preserving changed-understanding output behavior
- [X] T017 [US3] Consolidate X2.38 explanatory guidance and correction examples in `.highway/governance/experience-standard.md` so material corrections consider prior interpretation, newly visible distinctions, implications, and affected context
- [X] T018 [US3] Run `bash .highway/tools/tests/feature-141-experience-standard-refactor.test.sh` and the focused correction/convergence checks to verify User Story 3 independently

## Phase 6: User Story 4 - Convergence precedes acceptance (Priority: P1)

**Goal**: Prevent artifact completeness or acceptance questions from bypassing useful grounded development.

**Independent Test**: Review complete-candidate scenarios and confirm that useful non-redundant reasoning keeps development active, while optional or low-value enrichment does not block a mature short path.

- [X] T019 [US4] Strengthen X2.41 in `.highway/governance/experience-standard.md` so available grounded non-redundant reasoning, not merely an active change, prevents convergence
- [X] T020 [US4] Keep X2.37 separate while allowing an equivalent substantive interaction to satisfy Contribution Opportunity without a ceremonial extra turn in `.highway/governance/experience-standard.md`
- [X] T021 [US4] Rewrite the Interaction Model in `.highway/governance/experience-standard.md` around adaptive context, advisory reasoning, re-evaluation, consequential clarification, convergence, acceptance, and owner action
- [X] T022 [US4] Verify the acceptance boundary and persistence distinction in `.highway/governance/experience-standard.md`, including Setup presentation rules that remain user-visible rather than orchestration mechanics
- [X] T023 [US4] Run `bash .highway/tools/tests/experience-standard-convergence.test.sh` and the full focused Experience Standard test set to verify User Story 4 independently

## Phase 7: User Story 5 - Questions resolve consequential user-owned uncertainty (Priority: P2)

**Goal**: Make X2.4 the single questioning/clarification rule without unnecessary ceremony or duplicate questions.

**Independent Test**: Review ambiguous and clear-input scenarios and confirm that only consequential, result-changing, user-owned uncertainty produces one unresolved question.

- [X] T024 [US5] Consolidate X2.14, X2.39, and X2.40 into X2.4 and retire those IDs in `.highway/governance/experience-standard.md`
- [X] T025 [US5] Rewrite X2.4 and Conversational Clarification guidance in `.highway/governance/experience-standard.md` to distinguish clarification from advisory Working Ideas and prohibit schema-filling or restatement questions
- [X] T026 [US5] Run the focused Experience Standard tests and verify User Story 5 independently

## Phase 8: Polish & Cross-Cutting Validation

**Purpose**: Validate traceability, protected-file boundaries, and complete repository health.

- [X] T027 [P] Audit `.highway/governance/experience-standard.md` for `Highway Skills Constitution`, `Skills Constitution`, `P namespace`, `Tier`, tier labels, `Versioning Policy`, `Self-Application`, and other forbidden runtime terms from the feature spec
- [X] T028 [P] Verify that `constitution.md`, `highway-identity.md`, Setup, Profile, Objectives, Controls, NFRs, Clarify, output templates, and other skills are unchanged with `git diff --name-only`
- [X] T029 Run `bash .highway/tools/tests/run-all.sh` and record the suite result separately from requirement coverage
- [X] T030 Run `git diff --check`, validate all task/spec requirement references, and update `specs/146-experience-runtime-refactor/quickstart.md` only if the final validation commands differ

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: T001-T002 have no dependencies and can run in parallel.
- **Foundational (Phase 2)**: T003-T006 depend on the setup inspection; T006 must complete before implementation edits.
- **User Stories (Phases 3-7)**: Depend on the foundational validation contract. Because the same Experience Standard is edited, execute the story phases sequentially even though their behavioral concerns are separable.
- **Polish (Phase 8)**: Depends on all story phases and focused validation completing.

### User Story Dependencies

- **US1 (P1)**: First implementation increment and MVP; establishes the runtime authority boundary.
- **US2 (P1)**: Depends on US1's definitions and runtime scope; adds advisory behavior.
- **US3 (P1)**: Depends on US2's advisory/reasoning vocabulary; consolidates re-evaluation.
- **US4 (P1)**: Depends on US3's re-evaluation semantics; strengthens convergence and acceptance ordering.
- **US5 (P2)**: Depends on US2 and US3 vocabulary; consolidates questioning around the resulting advisory/re-evaluation model.

### Parallel Opportunities

- T001 and T002 can run in parallel.
- T004 and T005 can run in parallel after T003's contract direction is known.
- T027 and T028 can run in parallel after implementation; T029 follows both.
- Story implementation tasks are intentionally sequential because they edit the same Markdown artifact.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete setup and foundational validation tasks.
2. Complete US1 to remove runtime Constitution/development-governance dependencies.
3. Run the amendment contract and stop for an independently validated runtime-boundary MVP.

### Incremental Delivery

1. Add constructive advisory behavior (US2).
2. Add substantive correction re-evaluation (US3).
3. Add convergence-before-acceptance behavior (US4).
4. Consolidate questioning and clarification (US5).
5. Run the full suite and protected-file audit.

### Notes

- Every task includes an exact repository path.
- No external API, persistence schema, generated artifact, or `contracts/` file is expected.
- Retired X IDs must never be reused; the final document must preserve traceability in its amendment record.
