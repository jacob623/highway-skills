---
description: "Implementation tasks for Experience Compliance and Interaction Guidance"
---

# Tasks: Experience Compliance and Interaction Guidance

**Input**: Design documents from `/specs/079-experience-compliance-interaction/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/review-output.md`, and `quickstart.md`

**Tests**: Focused shell validation is required by FR-020, the plan validation gate, and the existing repository test conventions.

**Organization**: Tasks are grouped by user story so each governance increment can be implemented and validated independently after the shared foundation.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Confirm the existing shipped governance and test surfaces before editing them.

- [X] T001 Inspect the repository paths `.highway/governance/constitution.md`, `.highway/governance/experience-standard.md`, `.highway/tools/lib/constitution.sh`, `.highway/tools/lib/rule-checks.sh`, and `.highway/tools/tests/` to identify the existing rule-loading, verdict, version-history, and fixture patterns
- [X] T002 [P] Record the pre-change focused validation baseline using `.highway/tools/tests/constitution-inventory.test.sh`, `.highway/tools/tests/coverage-summary.test.sh`, `.highway/tools/tests/rule-checks.test.sh`, and `.highway/tools/tests/run-all.sh`

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish shared review-output behavior and test vocabulary before story-specific governance amendments.

- [X] T003 Amend `.highway/tools/lib/constitution.sh` and `.highway/tools/lib/rule-checks.sh` only as needed to load applicable P and X rule inventories through the existing parser without creating a second enforcement path
- [X] T004 [P] Add or amend shared review-output assertions in `.highway/tools/tests/coverage-summary.test.sh` for the five groups `CHECKED`, `FAILED`, `N/A`, `DEFERRED`, and `UNCHECKED`, the verdicts `PASS`, `FAIL`, and `N/A`, one-group-only coverage, evidence requirements, and named N/A condition tokens for X rules
- [X] T005 [P] Add or amend inventory assertions in `.highway/tools/tests/constitution-inventory.test.sh` for stable P/X namespace loading, X2.2-X2.6 discoverability, and unchanged-skill grandfathering behavior

**Checkpoint**: Shared parser, inventory, and review-output expectations are explicit; user-story work can proceed in priority order.

## Phase 3: User Story 1 - Experience Compliance Is Governed (Priority: P1) [MVP]

**Goal**: Make Experience Standard compliance a constitutional obligation and report applicable X results alongside constitutional results without changing the existing review vocabulary.

## Independent Test: In `.highway/governance/constitution.md`, run `.highway/tools/tests/constitution-inventory.test.sh`, `.highway/tools/tests/coverage-summary.test.sh`, and `.highway/tools/tests/rule-checks.test.sh`; verify the definition, Principle X, P10.1/P10.2, precedence rank 9, review obligations, governance gate, X/N/A output, and no duplicated X2 rule text.

### Tests for User Story 1

- [X] T006 [P] [US1] Extend `.highway/tools/tests/constitution-inventory.test.sh` with assertions for the Experience Standard definition, `X. Experience Compliance` placement after `IX. Shared Output Contracts`, P10.1/P10.2 fields, precedence rank 9, and constitutional version-impact entries
- [X] T007 [P] [US1] Extend `.highway/tools/tests/coverage-summary.test.sh` with constitutional review-output fixtures that report applicable X results beside P results, report X2.5/X2.6 as N/A when no long-running activity exists, and reject additional verdict or group names
- [X] T008 [P] [US1] Extend `.highway/tools/tests/rule-checks.test.sh` with assertions that every applicable X FAIL blocks merge, every N/A result names its permitted condition, P10.1/P10.2 use the agent-checkable tier, and constitutional rule sentences do not duplicate X2.2-X2.6 text

### Implementation for User Story 1

- [X] T009 [US1] Amend `.highway/governance/constitution.md` to define Experience Standard as the Highway user-visible interaction standard with the X namespace and insert `X. Experience Compliance` after `IX. Shared Output Contracts`
- [X] T010 [US1] Add P10.1 and P10.2 to `.highway/governance/constitution.md` with the required agent-checkable tier, observables, compliance obligation, and X-rule exception-condition accountability without restating X2 normative rules
- [X] T011 [US1] Update the Principle Precedence, Compliance Review Protocol, and Governance sections of `.highway/governance/constitution.md` to assign Experience Compliance rank 9, require applicable X-rule review and resolution of every FAIL, define P/X result reporting and X N/A conditions, and require both protocols before merge
- [X] T012 [US1] Update the Sync Impact Report and version history in `.highway/governance/constitution.md` according to the authoritative Constitution Versioning Policy, recording the additive Experience Compliance amendment and baseline reconciliation

**Checkpoint**: User Story 1 is independently reviewable and reports constitutional and applicable Experience Standard results through one contract.

## Phase 4: User Story 2 - Interactive Workflows Prioritize the Next User Action (Priority: P1)

**Goal**: Add concrete X2.2-X2.6 interaction rules governing opening responses, implementation-detail boundaries, single-question collection, and activity-focused progress messages.

## Independent Test: In `.highway/governance/experience-standard.md`, run `.highway/tools/tests/rule-checks.test.sh`; verify every X2.2-X2.6 row has the exact rule contract, applicability, N/A behavior, tier, and sample value, including interactive workflow and long-running activity cases.

### Tests for User Story 2

- [X] T013 [P] [US2] Add focused X2.2-X2.6 row and applicability assertions to `.highway/tools/tests/rule-checks.test.sh` for exact rule IDs, observables, `[agent-checkable]` tiers, sample values, Interactive Workflow scope, and X2.5/X2.6 N/A conditions
- [X] T014 [P] [US2] Add representative compliant, non-compliant, read-only N/A, and no-long-running-activity N/A fixtures to `.highway/tools/tests/coverage-summary.test.sh` without introducing new verdict vocabulary

### Implementation for User Story 2

- [X] T015 [US2] Add X2.2 and X2.3 to the X2 Interaction section of `.highway/governance/experience-standard.md`, including next-action-first opening behavior and the requested prohibition on unrequested implementation details
- [X] T016 [US2] Add X2.4 to `.highway/governance/experience-standard.md` with the single unresolved collection-question rule, Observable, `[agent-checkable]` tier, and sample value `one`
- [X] T017 [US2] Add X2.5 and X2.6 to `.highway/governance/experience-standard.md` with activity-focused progress requirements, explicit no-long-running-activity N/A conditions, `[agent-checkable]` tiers, and sample value `one`

**Checkpoint**: User Story 2 is independently reviewable against the five interaction rules and their applicability boundaries.

## Phase 5: User Story 3 - Experience Guidance Is Concrete and Versioned (Priority: P2)

**Goal**: Make the interaction amendment auditable through rationale, non-normative examples, N/A coverage, and the required version records.

## Independent Test: In `.highway/governance/experience-standard.md` and `.highway/governance/constitution.md`, verify rationale placement after X2.1, compliant/non-compliant interactive and progress examples, at least one X2.5/X2.6 N/A example, minor Experience Standard increment, constitutional synchronization record, and no stale or contradictory applicability wording.

### Tests for User Story 3

- [X] T018 [P] [US3] Extend `.highway/tools/tests/rule-checks.test.sh` to verify X2.2-X2.6 rationale follows X2.1, examples remain non-normative, required compliant/non-compliant boundaries are present, and at least one example records X2.5/X2.6 as N/A
- [X] T019 [P] [US3] Extend `.highway/tools/tests/constitution-inventory.test.sh` to verify the Experience Standard minor version increment, Constitution version-impact record, synchronization entry, and consistency of applicability language across governance documents

### Implementation for User Story 3

- [X] T020 [US3] Append the X2.2-X2.6 rationale after the existing X2.1 rationale in `.highway/governance/experience-standard.md`, covering next-action focus, implementation-detail boundaries, single-question collection, and activity-focused progress
- [X] T021 [US3] Add non-normative compliant and non-compliant examples for interactive collection and long-running activity to `.highway/governance/experience-standard.md`, including a valid no-long-running-activity N/A example for X2.5 and X2.6
- [X] T022 [US3] Apply the required minor version increment and preserve the version history in `.highway/governance/experience-standard.md`, keeping all new guidance in the existing X namespace and excluding examples from normative rule tables

**Checkpoint**: User Story 3 is independently auditable and the two canonical governance documents describe one consistent contract.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Validate the complete feature, correspondence, portability, and grandfathering behavior.

- [X] T023 [P] Run the focused Feature 079 checks from `specs/079-experience-compliance-interaction/quickstart.md` against `.highway/tools/tests/constitution-inventory.test.sh`, `.highway/tools/tests/coverage-summary.test.sh`, and `.highway/tools/tests/rule-checks.test.sh`
- [X] T024 [P] Run `.highway/tools/tests/run-all.sh` and confirm no existing skill is forced to change solely because of Feature 079's adoption, preserving grandfathering for unchanged skills
- [X] T025 [P] Verify the final governance documents and tests against `specs/079-experience-compliance-interaction/spec.md`, `specs/079-experience-compliance-interaction/contracts/review-output.md`, and `specs/079-experience-compliance-interaction/quickstart.md` for FR-001-FR-020A, SC-001-SC-010, and applicability/N/A consistency
- [X] T026 [P] Run `git diff --check` for `.highway/tools/tests/run-all.sh` and confirm all changed paths remain Bash 3.2-compatible and contain no development-only references

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; T001 and T002 can begin immediately, with T002 depending only on the repository being available.
- **Foundational (Phase 2)**: Depends on Setup; T003-T005 establish the shared parser, inventory, and review-output contract and block story implementation.
- **User Story 1 (Phase 3)**: Depends on Foundational; delivers the MVP constitutional gate and shared X reporting contract.
- **User Story 2 (Phase 4)**: Depends on Foundational and uses the reporting contract from US1; its implementation can begin after T003-T005, but final validation should include US1's protocol changes.
- **User Story 3 (Phase 5)**: Depends on US1 and US2 because it versions and documents the completed constitutional and interaction amendments.
- **Polish (Phase 6)**: Depends on all desired user stories.

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Phase 2 only; no dependency on another user story. This is the MVP.
- **User Story 2 (P1)**: Depends on Phase 2 for shared X loading/reporting and should be validated with US1's constitutional output contract.
- **User Story 3 (P2)**: Depends on US1 and US2 so rationale, examples, and version records describe the implemented rules without contradiction.

### Within Each User Story

- Focused tests are authored before the corresponding governance implementation and must expose missing behavior before implementation is considered complete.
- Governance structure and rule rows precede rationale/examples and version-history updates.
- A story is complete only after its independent test criteria pass.

## Parallel Execution Examples

### User Story 1

```text
Task T006: Constitution inventory assertions in .highway/tools/tests/constitution-inventory.test.sh
Task T007: Review-output fixtures in .highway/tools/tests/coverage-summary.test.sh
Task T008: Rule-check assertions in .highway/tools/tests/rule-checks.test.sh
```

After the shared tests are prepared, T009-T012 should be applied sequentially to `.highway/governance/constitution.md` to avoid conflicting edits.

### User Story 2

```text
Task T013: X2 row and applicability assertions in .highway/tools/tests/rule-checks.test.sh
Task T014: Interaction fixtures in .highway/tools/tests/coverage-summary.test.sh
```

T015-T017 should then be applied sequentially to `.highway/governance/experience-standard.md`.

### User Story 3

```text
Task T018: Rationale and example assertions in .highway/tools/tests/rule-checks.test.sh
Task T019: Version and synchronization assertions in .highway/tools/tests/constitution-inventory.test.sh
```

T020-T022 should be applied sequentially because they update the same canonical Experience Standard and its related constitutional record.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 and Phase 2.
2. Implement and validate User Story 1.
3. Stop and verify constitutional review reports applicable X results with PASS/FAIL/N/A and named conditions.
4. Proceed to User Story 2 only after the MVP gate is passing.

### Incremental Delivery

1. Establish the shared parser and review-output contract.
2. Deliver User Story 1 as the constitutional compliance MVP.
3. Deliver User Story 2 as the interaction-rule amendment.
4. Deliver User Story 3 as the rationale, examples, and versioning audit layer.
5. Run the focused and full validation suite, then `git diff --check`.

### Parallel Team Strategy

1. Complete Setup and Foundational tasks together because they define shared files and vocabulary.
2. Once the foundation is ready, assign T006-T008 to separate test owners where possible.
3. Assign T013-T014 and T018-T019 in parallel with their respective story test work, but serialize edits to each canonical governance document.
4. Keep final suite and diff validation centralized in Phase 6.

## Notes

- Every implementation task names the canonical file or validation artifact it changes.
- `[P]` marks tasks that can run in parallel without editing the same file or depending on incomplete story work.
- X2.5 and X2.6 use existing `N/A` reporting with explicit conditions; no new verdict or coverage group is introduced.
- Unchanged existing skills are grandfathered; only newly created or amended skills are evaluated against the new applicable Experience Standard rules.
