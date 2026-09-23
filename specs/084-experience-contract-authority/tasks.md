# Tasks: Experience Contract Authority Clarification

**Input**: Design documents from `/specs/084-experience-contract-authority/`

**Prerequisites**: `spec.md` and `plan.md`; Feature 083 governance and validation artifacts provide the implementation baseline. No `research.md`, `data-model.md`, `quickstart.md`, or `contracts/` artifacts are present.

**Organization**: Tasks are grouped by user story. This feature updates governance Markdown and Bash validation only; it adds no runtime service, persistence store, external API, or new X rule.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the preservation baseline and identify the exact Feature 083 contract surface before editing.

- [X] T001 Record the current repository test baseline with `.highway/tools/tests/run-all.sh`, `git diff --check`, and `git status --short` from the repository root.
- [X] T002 [P] Capture the current X2.2-X2.6 normative rows, N5 applicability, and Interactive Workflow UX Contract boundaries from `.highway/governance/experience-standard.md` for preservation assertions in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T003 [P] Inventory all references to `Interactive Workflow UX Contract` under `.highway/skills/`, `.highway/library/`, `.highway/catalog/`, `.github/skills/`, `.claude/skills/`, and `.cursor/rules/` to distinguish references from complete duplicate copies.
- [X] T004 [P] Review `.highway/governance/constitution.md` and `.specify/memory/constitution.md` for applicable layer-separation, generated-artifact, documentation, and verification constraints before changing governance content.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Prepare focused validation that protects the sole normative authority and existing Feature 083 behavior.

- [X] T005 Add a byte-preservation fixture or extraction assertion for the X2.2-X2.6 normative rows in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T006 Add exact-one-section and no-new-X-identifier assertions for the Interactive Workflow UX Contract in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T007 Add a duplicate-contract negative probe that rejects a second authoritative section and a complete contract reproduction in skill-owned files under `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T008 Add a reference-only validation probe that accepts skill references to the contract while rejecting skill files that reproduce the complete contract in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T009 Verify the focused test remains Bash 3.2-compatible and is discovered by `.highway/tools/tests/run-all.sh` without changing unrelated test registration behavior.

**Checkpoint**: Preservation, authority uniqueness, and reference-only validation are ready before contract wording changes begin.

## Phase 3: User Story 1 - Reviewers Can Identify the Contract's Authority (Priority: P1) MVP

**Goal**: Make the Interactive Workflow UX Contract explicitly interpretive and organizational while preserving X2.2-X2.6 as the sole normative interaction rules.

**Independent Test**: Inspect the contract in `.highway/governance/experience-standard.md` and run `bash .highway/tools/tests/highway-ux-alignment.test.sh`; confirm the authority statement names X2.2-X2.6, disclaims additional obligations and identifiers, and preserves skill-owned responsibility.

### Tests for User Story 1

- [X] T010 [P] [US1] Add assertions for the reusable-guidance declaration, X2.2-X2.6 scope, no-additional-obligation boundary, and no-new-X-identifier boundary in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T011 [P] [US1] Add assertions that skill ownership remains responsible for workflow contracts, artifact ownership, progress fields, terminality rules, and domain-specific behavior in `.highway/tools/tests/highway-ux-alignment.test.sh`.

### Implementation for User Story 1

- [X] T012 [US1] Rewrite the authority statement under `### Interactive Workflow UX Contract` in `.highway/governance/experience-standard.md` to identify the section as reusable interpretive guidance and organizational application of X2.2-X2.6 without changing normative rows.
- [X] T013 [US1] Add the explicit boundary in `.highway/governance/experience-standard.md` that the contract creates no additional X-rule obligations, modifies no X2.2-X2.6 normative text, and introduces no new X identifiers.
- [X] T014 [US1] Add skill ownership language to `.highway/governance/experience-standard.md` covering workflow contracts, artifact ownership, progress fields, terminality rules, and domain-specific behavior.
- [X] T015 [US1] Amend the Experience Standard version and amendment record in `.highway/governance/experience-standard.md` for the authority clarification without changing unrelated rules.

**Checkpoint**: The contract has one clear authority boundary and reviewers can distinguish it from the normative X2.2-X2.6 rules.

## Phase 4: User Story 2 - Guidance Does Not Read Like Duplicate Requirements (Priority: P1)

**Goal**: Attribute next-action, implementation-detail/activity, single-question, and ownership guidance to the applicable existing rules or interpretive conventions.

**Independent Test**: Compare the contract guidance in `.highway/governance/experience-standard.md` with X2.2-X2.6 and verify each guidance group has an explicit rule attribution or ownership boundary without introducing a second rule namespace.

### Tests for User Story 2

- [X] T016 [P] [US2] Add X2.2 attribution assertions for next-action guidance and X2.3/X2.6 attribution assertions for implementation-detail and activity guidance in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T017 [P] [US2] Add X2.4 attribution assertions for guided single-question guidance and ownership-convention assertions for owner authority in `.highway/tools/tests/highway-ux-alignment.test.sh`.

### Implementation for User Story 2

- [X] T018 [US2] Rephrase next-action guidance under the contract in `.highway/governance/experience-standard.md` as application of X2.2 rather than an independently normative requirement.
- [X] T019 [US2] Rephrase implementation-detail and activity guidance under the contract in `.highway/governance/experience-standard.md` as application of X2.3 and X2.6.
- [X] T020 [US2] Rephrase single-question guidance under the contract in `.highway/governance/experience-standard.md` as application of X2.4 while preserving supporting context and examples.
- [X] T021 [US2] Rephrase ownership guidance under the contract in `.highway/governance/experience-standard.md` as an interpretive convention that preserves authority within the owning workflow.
- [X] T022 [US2] Verify the contract does not add a new X rule identifier, duplicate an X2.2-X2.6 rule, or create an independent ownership-rule namespace in `.highway/governance/experience-standard.md`.

**Checkpoint**: Every shared guidance group is traceable to existing authority or clearly labeled as an interpretive convention.

## Phase 5: User Story 3 - Applicability and Examples Are Consistent (Priority: P1)

**Goal**: Make progress applicability, non-normative examples, and contract uniqueness objectively reviewable across workflows.

**Independent Test**: Run the focused alignment test and inspect `.highway/governance/experience-standard.md`; verify meaningful ordered work controls progress, no progress is manufactured when absent, examples are labeled and placed beneath the contract, and skill references do not reproduce the complete contract.

### Tests for User Story 3

- [X] T023 [P] [US3] Add meaningful-ordered-work and no-manufactured-progress assertions, including N5 applicability for X2.5/X2.6 where relevant, in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T024 [P] [US3] Add exact `Illustrative Examples (Non-Normative)` placement and value-list assertions for User Exit, Owner Outcome, and Resume Applicability in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T025 [P] [US3] Add validation for exactly one authoritative contract section, reference-only skill usage, and no complete-contract reproduction in `.highway/tools/tests/highway-ux-alignment.test.sh`.

### Implementation for User Story 3

- [X] T026 [US3] Clarify progress guidance in `.highway/governance/experience-standard.md` so meaningful ordered work or long-running activity controls applicable progress and workflows without meaningful ordered work do not manufacture stages.
- [X] T027 [US3] Add a subsection labeled exactly `Illustrative Examples (Non-Normative)` within or immediately beneath `### Interactive Workflow UX Contract` in `.highway/governance/experience-standard.md`.
- [X] T028 [US3] Add non-normative User Exit examples for `pause`, `cancel`, and `stop responding` plus Owner Outcome examples for `declined`, `aborted`, and `blocked` beneath the contract section in `.highway/governance/experience-standard.md`.
- [X] T029 [US3] Add non-normative Resume Applicability examples for `Persisted owner evidence`, `Transient interaction state`, `New interaction`, and `Not Applicable` beneath the contract section in `.highway/governance/experience-standard.md`.
- [X] T030 [US3] Add the exact uniqueness and reference-only contract validation coverage to `.highway/tools/tests/highway-ux-alignment.test.sh` and ensure no complete contract copy is introduced under `.highway/skills/` or generated adapter paths.

**Checkpoint**: Applicability and examples are explicit, non-normative, correctly placed, and uniqueness is objectively testable.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate only necessary correspondence and complete focused, repository-wide, and whitespace validation.

- [X] T031 [P] Regenerate catalog and agent adapter outputs with `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-agent-adapters.sh` only if source changes require correspondence refresh; verify `.highway/catalog/`, `.github/skills/`, `.claude/skills/`, `.cursor/rules/`, and `.highway/tools/.adapter-manifest` remain consistent.
- [X] T032 [P] Verify `.highway/tools/.distribution-manifest` and unaffected skill output contracts remain unchanged except for intentional Feature 084 wording in `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T033 Run `bash .highway/tools/tests/highway-ux-alignment.test.sh` and record the focused result against FR-001 through FR-016 and SC-001 through SC-008.
- [X] T034 Run `.highway/tools/tests/run-all.sh` from the repository root and record the full-suite result.
- [X] T035 Run `git diff --check`, inspect `git status --short`, and remove only generated residue attributable to Feature 084 under `.highway/`, `.github/skills/`, `.claude/skills/`, `.cursor/rules/`, and `specs/084-experience-contract-authority/`.
- [X] T036 Review every FR-001 through FR-016 and SC-001 through SC-008 against changed files, recording requirement coverage separately from test results in `specs/084-experience-contract-authority/coverage.md`.
- [X] T037 Confirm `.specify/extensions.yml` remains absent or, if introduced during implementation, execute applicable `hooks.after_tasks` and `hooks.after_implement` procedures before reporting completion.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: T001 establishes the baseline; T002-T004 can run in parallel afterward.
- **Foundational (Phase 2)**: Depends on Phase 1; T005-T009 prepare focused validation and must complete before story implementation.
- **User Stories (Phases 3-5)**: Depend on Phase 2. US1 establishes the authority wording, while US2 and US3 can proceed in parallel once the contract section boundaries are stable.
- **Polish (Phase 6)**: Depends on all desired user stories and focused validation completion.

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Foundational; MVP story and prerequisite for interpreting shared guidance.
- **User Story 2 (P1)**: Depends on Foundational and the contract boundary from US1; independently testable against X2.2-X2.6.
- **User Story 3 (P1)**: Depends on Foundational and the contract section from US1; independently testable through applicability, examples, and uniqueness assertions.

### Parallel Opportunities

- T002-T004 can run in parallel after T001.
- T010-T011 can run in parallel; T012-T015 are sequential edits to the same governance file.
- T016-T017 can run in parallel; T018-T021 should be applied as one ordered governance-file edit set.
- T023-T025 can run in parallel; T026-T030 should be applied as one ordered governance-file/test edit set.
- US2 and US3 can be staffed in parallel only after US1 establishes the contract section authority language.
- T031-T032 can run in parallel after all source edits; T033-T036 are validation/reporting tasks and should follow implementation.

## Parallel Example: User Story 1

```text
Task: T010 [P] [US1] Add authority-boundary assertions in .highway/tools/tests/highway-ux-alignment.test.sh
Task: T011 [P] [US1] Add skill-ownership assertions in .highway/tools/tests/highway-ux-alignment.test.sh
```

## Parallel Example: User Story 2

```text
Task: T016 [P] [US2] Add X2.2/X2.3/X2.6 attribution assertions in .highway/tools/tests/highway-ux-alignment.test.sh
Task: T017 [P] [US2] Add X2.4 and ownership-convention assertions in .highway/tools/tests/highway-ux-alignment.test.sh
```

## Parallel Example: User Story 3

```text
Task: T023 [P] [US3] Add progress applicability assertions in .highway/tools/tests/highway-ux-alignment.test.sh
Task: T024 [P] [US3] Add illustrative-example placement and value assertions in .highway/tools/tests/highway-ux-alignment.test.sh
Task: T025 [P] [US3] Add duplicate-contract and reference-only assertions in .highway/tools/tests/highway-ux-alignment.test.sh
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 baseline and Phase 2 preservation/uniqueness test preparation.
2. Complete Phase 3 authority clarification in the Experience Standard.
3. Run the US1 independent test and stop for review once the sole normative authority boundary is proven.

### Incremental Delivery

1. Establish preservation and authority validation.
2. Deliver US1 contract-authority wording as the MVP.
3. Add US2 rule-attributed interpretive guidance.
4. Add US3 applicability, examples, and objective uniqueness validation.
5. Regenerate correspondence only when source changes require it.
6. Run focused and full repository validation before completion.

### Parallel Team Strategy

1. One maintainer owns the ordered edits to `.highway/governance/experience-standard.md`.
2. A validation maintainer can prepare non-overlapping assertions in `.highway/tools/tests/highway-ux-alignment.test.sh`.
3. After the contract wording stabilizes, separate maintainers can review US2 and US3 against the same governance source, but final edits to the shared file should be integrated sequentially.

## Notes

- Every implementation task includes a concrete repository path.
- `[P]` marks only tasks that can safely operate on separate files or independent validation sections.
- Tests are included because FR-014 and SC-007 explicitly require focused validation.
- No task creates runtime dependencies, hidden persistence, external APIs, a new X rule, or a second authoritative contract.
- The existing `plan.md` is still the template placeholder; task execution should use this spec and Feature 083’s established implementation patterns until planning artifacts are completed.
