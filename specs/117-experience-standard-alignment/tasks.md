---

description: "Task list for Experience Standard Alignment"
---

# Tasks: Experience Standard Alignment

**Input**: Design documents from `/specs/117-experience-standard-alignment/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Tests**: Existing shell contract tests are updated and run because the feature changes a shipped governance contract and its pinned observables.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel with other tasks in the same phase when they touch different files.
- **[Story]**: Maps the task to a user story from `spec.md`.
- Every task names the exact file or validation command it affects.

## Dependency Graph

```text
T001 -> T002 -> T003
T003 -> T004, T005, T006, T007
T004 -> T008
T005 -> T009
T006 -> T010
T007 -> T011
T008, T009, T010, T011 -> T012
T012 -> T013
T013 -> T014
T014 -> T015
T015 -> T016
T016 -> T017
T017 -> T018
T018 -> T019
T019 -> T020
T020 -> T021
```

## Phase 1: Setup

**Purpose**: Confirm the feature inputs and preserve the current validation baseline.

- [X] T001 Read `specs/117-experience-standard-alignment/spec.md`, `plan.md`, `research.md`, `data-model.md`, and `quickstart.md` and record the implementation scope in the working task context.
- [X] T002 [P] Capture the pre-change baseline by running `bash .highway/tools/tests/experience-standard-amendment.test.sh`, `bash .highway/tools/tests/highway-ux-alignment.test.sh`, and `bash .highway/tools/tests/experience-x23-contract.test.sh`.

## Phase 2: Foundational

**Purpose**: Establish the shared contract inventory before editing the standard.

- [X] T003 Inventory current X rule IDs, version metadata, amendment report, examples, and owner-boundary references in `.highway/governance/experience-standard.md`.
- [X] T004 [P] Compare the shared interaction obligations with `.highway/skills/highway-setup/SKILL.md` and record only Setup-owned transition and orchestration constraints for implementation.
- [X] T005 [P] Compare Profile compatibility requirements with `.highway/skills/highway-profile/SKILL.md`, including its four readiness domains and optional enrichment behavior.
- [X] T006 [P] Compare shared recommendation and review boundaries with `.highway/skills/highway-objectives/SKILL.md` and `.highway/skills/highway-controls/SKILL.md`.
- [X] T007 [P] Compare NFR recommendation, candidate, and review boundaries with `.highway/skills/highway-nfrs/SKILL.md` and verify the Constitution non-restatement boundary in `.specify/memory/constitution.md`.

## Phase 3: User Story 1 - Receive Grounded Help Before Questioning (Priority: P1) MVP

**Goal**: Make context reuse, recommendation-first behavior, unknown handling, and hidden implementation mechanics explicit and internally consistent in the shared standard.

**Independent Test**: The standard contains the context-first interaction model, accepted-information reuse, one unresolved question, recommendation-first evaluation, proposal boundaries, and implementation-detail suppression without contradicting the owner contracts.

### Implementation for User Story 1

- [X] T008 [US1] Amend the context-first and accepted-information rule observables in `.highway/governance/experience-standard.md` while preserving stable X identifiers.
- [X] T009 [US1] Align the unknown-information, proposed-information, implementation-detail, and recommendation-first guidance in `.highway/governance/experience-standard.md` with the current owner boundary.

**Checkpoint**: Context-first behavior is specified once in the shared standard and is ready for focused contract assertions.

## Phase 4: User Story 2 - Make and Review Recommendations Clearly (Priority: P1)

**Goal**: Make recommendation count, singular/plural wording, acceptance, alternatives, rationale, and material interpretation behavior unambiguous.

**Independent Test**: Single, multiple, explanation-only, duplicate, and materially interpreted cases are covered by the standard and its observable rule text.

### Implementation for User Story 2

- [X] T010 [US2] Amend recommendation-set and acceptance rules in `.highway/governance/experience-standard.md` to cap actionable choices at five, preserve alternatives, and distinguish selection from explanation.
- [X] T011 [US2] Correct material-interpretation review ordering, exclusion cases, and Decision Context ordering in `.highway/governance/experience-standard.md`.

**Checkpoint**: Recommendation and review behavior is coherent for Profile enrichment, Objectives, Controls, and NFRs without copying their domain workflows.

## Phase 5: User Story 3 - Review Interpretation and Decision Context in the Right Order (Priority: P1)

**Goal**: Replace stale examples and make the shared review and Decision Context examples conform to their normative rules.

**Independent Test**: Non-normative examples demonstrate question-first Decision Context, immediate proposal placement, one acceptance request, and no accidental second question.

### Implementation for User Story 3

- [X] T012 [US3] Update the Context Awareness, Interaction Examples, and Recommendation sets sections in `.highway/governance/experience-standard.md` to remove stale wording and support singular recommendations.
- [X] T013 [US3] Add or revise a non-normative material-interpretation and Decision Context example in `.highway/governance/experience-standard.md` without introducing new rule IDs.

**Checkpoint**: All standard examples are visibly subordinate to and consistent with the current rule observables.

## Phase 6: User Story 4 - Move Through Setup Without Machine-Result Leakage (Priority: P1)

**Goal**: Align Setup transition, separator, synthesis, final-block, and machine-result rules and examples with current orchestration ownership.

**Independent Test**: The standard describes one transition, no duplicate owner opening, optional concise synthesis, one final response-demanding block, hidden machine results, and direct-request visibility.

### Implementation for User Story 4

- [X] T014 [US4] Refine X1.7, X2.27, and X2.28 in `.highway/governance/experience-standard.md` for final-block, transition, separator, and receiving-owner behavior.
- [X] T015 [US4] Refine X2.33, X2.34, and X2.35 plus their explanatory prose in `.highway/governance/experience-standard.md` to keep synthesis user-relevant and suppress trailing machine results.

**Checkpoint**: Setup can consume owner results internally without exposing orchestration-only fields during normal conversation.

## Phase 7: User Story 5 - Keep Shared Rules Aligned With Domain Owners (Priority: P2)

**Goal**: Complete the cross-owner consistency pass without moving domain-specific ownership into the shared standard.

**Independent Test**: The standard explicitly remains compatible with Profile, Objectives, Controls, and NFRs while retaining owner-defined lifecycle, persistence, readiness, identifiers, derivation, and orchestration.

### Implementation for User Story 5

- [X] T016 [US5] Add concise owner-boundary references and Profile compatibility wording to `.highway/governance/experience-standard.md`, preserving the four readiness domains and non-blocking optional enrichment.
- [X] T017 [US5] Review the full `.highway/governance/experience-standard.md` against `.highway/skills/highway-setup/SKILL.md`, `.highway/skills/highway-profile/SKILL.md`, `.highway/skills/highway-objectives/SKILL.md`, `.highway/skills/highway-controls/SKILL.md`, and `.highway/skills/highway-nfrs/SKILL.md`; remove any duplicated domain workflow text.

**Checkpoint**: Shared presentation rules and owner-specific semantics have clear, non-competing boundaries.

## Phase 8: User Story 6 - Maintain a Coherent Versioned Standard (Priority: P2)

**Goal**: Record the MAJOR amendment, preserve identifiers, update focused tests, and make the release self-consistent.

**Independent Test**: Focused contract tests pass with version 6.0.0, current rule text, corrected examples, stable IDs, and a complete amendment report.

### Implementation for User Story 6

- [X] T018 [US6] Replace the sync impact report and footer metadata in `.highway/governance/experience-standard.md` with the 5.0.0 to 6.0.0 MAJOR amendment record dated 2026-10-01.
- [X] T019 [US6] Update pinned version, rule, observable, and superseded-wording assertions in `.highway/tools/tests/experience-standard-amendment.test.sh`.
- [X] T020 [US6] Update pinned X-rule alignment assertions in `.highway/tools/tests/highway-ux-alignment.test.sh` and add only necessary assertions for corrected examples or stable identifiers.

**Checkpoint**: The standard and its focused tests agree on version metadata, rules, observables, and examples.

## Phase 9: Polish & Cross-Cutting Validation

**Purpose**: Verify the complete feature and leave the repository with no generated-artifact drift or unresolved design residue.

- [X] T021 Run `bash .highway/tools/tests/experience-standard-amendment.test.sh`, `bash .highway/tools/tests/highway-ux-alignment.test.sh`, and `bash .highway/tools/tests/experience-x23-contract.test.sh`, then run `bash .highway/tools/tests/run-all.sh` and record the results.
- [X] T022 Verify `.highway/governance/experience-standard.md` has one sync impact report, stable unique X identifiers, no Constitution rule-text restatement, no stale example wording, and no unresolved `TODO`, `TBD`, or `[NEEDS CLARIFICATION]` markers.
- [X] T023 Run `git diff --check` and review the final diff against `specs/117-experience-standard-alignment/spec.md`, `plan.md`, and `quickstart.md` for requirement coverage.

## Parallel Execution Examples

- **Foundation**: T004, T005, T006, and T007 can run in parallel after T003 because they read separate owner or governance documents.
- **Early story work**: T008 and T009 can run in parallel after the inventory, provided edits are merged carefully in the same standard file.
- **Focused checks**: T019 and T020 can run in parallel after the standard wording is finalized.

## Implementation Strategy

1. Establish the baseline and owner-boundary inventory.
2. Deliver the P1 shared interaction and Setup behavior first, keeping the standard internally coherent.
3. Correct examples and complete the cross-owner review.
4. Apply the MAJOR version metadata and update focused assertions.
5. Run focused tests, the full suite, whitespace validation, and final requirement review.

**Suggested MVP scope**: Complete T001-T015, then validate the core context, recommendation, review, and Setup interaction contract before proceeding with P2 governance polish.
