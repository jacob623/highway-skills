---
description: "Actionable task list for Feature 124"
---

# Tasks: Collaborative Knowledge Development

**Input**: Design documents from `specs/124-collaborative-knowledge/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Tests**: Focused shell validation is included because the feature changes constitutional rule inventory, coverage, and generated outputs.

## Phase 1: Setup

**Purpose**: Confirm the existing governance and validation surfaces before mutation.

- [X] T001 Read the canonical Constitution, development Constitution, and Feature 124 design artifacts in `.highway/governance/constitution.md`, `.specify/memory/constitution.md`, and `specs/124-collaborative-knowledge/`
- [X] T002 [P] Inspect the constitutional validation and adapter-generation paths in `.highway/tools/tests/constitution-inventory.test.sh`, `.highway/tools/tests/coverage-summary.test.sh`, `.highway/tools/tests/rule-checks.test.sh`, and `.highway/tools/tests/generate-agent-adapters.test.sh`

## Phase 2: Foundational

**Purpose**: Establish amendment invariants before story-specific edits.

- [X] T003 Record the baseline Constitution version, precedence order, P12.5-P12.15 rule text, and generated-output state from `.highway/governance/constitution.md` and existing validation tests
- [X] T004 [P] Define the Feature 124 acceptance-boundary, non-persistence, owner-mutation, and downstream-synchronization invariants in the implementation notes at `specs/124-collaborative-knowledge/plan.md`

## Phase 3: User Story 1 - Develop Ideas Without Premature Authority (Priority: P1) MVP

**Goal**: Establish the authority distinction between accepted repository knowledge, transient Active Reasoning Context, and Working Ideas.

**Independent Test**: Review the Constitution definitions, `XII-A` principle text, and P12A.1 against contribution, interpretation, alternative, recommendation, conflict, and discarded-idea examples; none become accepted repository knowledge before acceptance.

- [X] T005 [US1] Add definitions for Active Reasoning Context, Working Idea, and accepted-knowledge distinctions in `.highway/governance/constitution.md`
- [X] T006 [US1] Add Principle `XII-A` and rule `P12A.1` with one normative obligation, one observable, one tier, and no conversational-technique prescription in `.highway/governance/constitution.md`
- [X] T007 [US1] Add the non-normative lifecycle and governance authority-boundary explanation covering discarded, corrected, replaced, split, combined, and abandoned Working Ideas in `.highway/governance/constitution.md`
- [X] T008 [US1] Validate P12A.1 and the non-authoritative Working Idea constraints with `.highway/tools/tests/rule-checks.test.sh` and `.highway/tools/tests/constitution-inventory.test.sh`

## Phase 4: User Story 2 - Converge Complete Proposals Before Acceptance (Priority: P1)

**Goal**: Distinguish an evolving Working Idea from a complete Converged Proposal at the existing acceptance boundary.

**Independent Test**: Review incomplete, complete, explanatory, comparative, and unsupported-inference examples; only a complete candidate at the applicable boundary is eligible for acceptance, without literal acceptance wording.

- [X] T009 [US2] Add the Converged Proposal definition and owning-workflow completeness boundary in `.highway/governance/constitution.md`
- [X] T010 [US2] Add rule `P12A.2` and its observable for complete candidate acceptance without prescribing literal wording in `.highway/governance/constitution.md`
- [X] T011 [US2] Preserve existing acceptance-to-owner-result and owner mutation ordering text while integrating the lifecycle explanation in `.highway/governance/constitution.md`
- [X] T012 [US2] Validate P12A.2 and unchanged P12.13-P12.15 behavior with `.highway/tools/tests/rule-checks.test.sh` and `.highway/tools/tests/coverage-summary.test.sh`

## Phase 5: User Story 3 - Preserve Relevant Working Context During an Interaction (Priority: P1)

**Goal**: Keep relevant Active Reasoning Context available during the active interaction without adding durable conversational state.

**Independent Test**: Trace multiple related Working Ideas through refinement, overlap, divergence, resolution, and interaction end; relevant context remains available while unresolved and no new retained artifact is introduced.

- [X] T013 [US3] Add rule `P12A.3` requiring relevant Active Reasoning Context to remain available until task resolution or interaction end in `.highway/governance/constitution.md`
- [X] T014 [US3] State the transient-only boundary and prohibit conversation-state files, Working Idea files, reasoning logs, hidden reasoning artifacts, thread catalogs, and cross-interaction restoration in `.highway/governance/constitution.md`
- [X] T015 [US3] Validate P12A.3, the no-durable-state constraint, and the absence of new retained artifact types with `.highway/tools/tests/body-scan.test.sh`, `.highway/tools/tests/rule-checks.test.sh`, and `.highway/tools/tests/constitution-inventory.test.sh`

## Phase 6: User Story 4 - Re-evaluate Context After Accepted Knowledge Changes the Task (Priority: P2)

**Goal**: Require relevant context re-evaluation after accepted knowledge changes the active task while preserving repository-context precedence.

**Independent Test**: Trace an accepted owner mutation followed by context-dependent behavior and confirm the updated accepted knowledge is used with relevant declared context, without invented organizational facts.

- [X] T016 [US4] Add rule `P12A.4` requiring relevant context re-evaluation after accepted knowledge changes the active task in `.highway/governance/constitution.md`
- [X] T017 [US4] Update the Repository Context principle to subordinate Active Reasoning Context and Working Ideas to accepted user evidence and authoritative repository state in `.highway/governance/constitution.md`
- [X] T018 [US4] Add the requested downstream synchronization impact and rollout order for the Experience Standard, `highway-profile`, `highway-objectives`, `highway-controls`, `highway-nfrs`, and future Architecture/ADR workflows in the Constitution Sync Impact Report at `.highway/governance/constitution.md`
- [X] T019 [US4] Validate P12A.4, Repository Context precedence, and synchronization completeness with `.highway/tools/tests/constitution-profile-context.test.sh` and `.highway/tools/tests/rule-checks.test.sh`

## Phase 7: Polish and Cross-Cutting Validation

**Purpose**: Complete self-application, generated outputs, and end-to-end validation.

- [X] T020 [P] Review P12A.1-P12A.4 for one normative keyword, one obligation, one observable, one tier, rule-length compliance, and prohibited vagueness in `.highway/governance/constitution.md`
- [X] T021 [P] Reconcile Constitution semantic version, amendment date, rule counts, tier counts, precedence metadata, and Sync Impact Report in `.highway/governance/constitution.md`
- [X] T022 Regenerate required agent adapters and manifests from the amended Constitution using the existing tooling and validate `.highway/tools/.adapter-manifest`
- [X] T023 Run the complete repository validation from `specs/124-collaborative-knowledge/quickstart.md` with `.highway/tools/tests/run-all.sh`
- [X] T024 Review the final diff for unchanged P12.5-P12.15 semantics and absence of prohibited durable conversational-state or prescribed conversational-technique requirements across `.highway/governance/constitution.md` and `specs/124-collaborative-knowledge/`

## Dependencies and Execution Order

### Phase dependencies

- Phase 1 -> Phase 2 -> User Stories 1 and 2 -> User Story 3 -> User Story 4 -> Phase 7.
- User Stories 1 and 2 share the constitutional authority boundary and should complete before the transient-context and re-evaluation rules.
- Phase 7 depends on all constitutional edits and is the completion gate.

### Parallel opportunities

- T002 and T004 can run in parallel after T001.
- T005-T007 are sequential constitutional edits; T008 follows them.
- T009 and T010 can be prepared together, with T011 and T012 following the integrated amendment.
- T020 and T021 can be reviewed in parallel after T016-T019.

## Implementation Strategy

1. Deliver the MVP by completing User Story 1 and its focused validation, establishing the authority boundary.
2. Add proposal completeness and transient-context rules as independent constitutional increments.
3. Add re-evaluation, precedence, synchronization reporting, generated outputs, and the full suite.
4. Claim completion only after every required owner-related guarantee remains present and the full validation command passes.

## Completion Criteria

- All tasks are checked.
- P12A.1-P12A.4 are present exactly once and P12.5-P12.15 remain unchanged.
- The final Constitution version classification is justified by compatibility review.
- Generated adapters and manifests are aligned.
- `.highway/tools/tests/run-all.sh` passes.
