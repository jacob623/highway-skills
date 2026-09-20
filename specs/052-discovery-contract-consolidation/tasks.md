# Tasks: Discovery Contract Consolidation

**Input**: Design documents from `/specs/052-discovery-contract-consolidation/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [quickstart.md](quickstart.md), and [contracts/discovery-contract-consolidation.md](contracts/discovery-contract-consolidation.md)

**Tests**: Required by the feature scope. Extend the existing focused Discovery contract test before changing the source contract, then run the existing repository suites.

**Organization**: Tasks are grouped by the two P1 user stories. Both stories use the same authoritative skill and focused test, so their implementation phases are ordered to avoid same-file conflicts.

## Phase 1: Setup

**Purpose**: Confirm the existing repository surfaces and Feature 052 design baseline.

- [X] T001 Confirm the Feature 052 source, adapter, test, generator, and suite paths in `specs/052-discovery-contract-consolidation/plan.md` and `.highway/tools/tests/highway-discovery.test.sh`

## Phase 2: Foundational

**Purpose**: Add executable contract assertions shared by both user stories before implementation.

- [X] T002 Add exact-heading, Expectations-heading absence, tie-break-reference, forbidden-wording, matrix-order, and preserved-invariant assertions to `.highway/tools/tests/highway-discovery.test.sh`

**Checkpoint**: The focused test expresses the complete Feature 052 acceptance boundary before the source contract is changed.

## Phase 3: User Story 1 - Consolidate verification and failure contracts (Priority: P1) MVP

**Goal**: Leave one complete Verification section and one complete Error Handling section without dropping any Feature 051 requirements.

**Independent Test**: `.highway/tools/tests/highway-discovery.test.sh` passes its exact-heading and preserved-requirement assertions against `.highway/skills/highway-discovery/SKILL.md`.

### Implementation for User Story 1

- [X] T003 [US1] Merge `## Verification Expectations` into `## Verification` and preserve all Verification requirements in `.highway/skills/highway-discovery/SKILL.md`
- [X] T004 [US1] Merge `## Error Handling Expectations` into `## Error Handling` and preserve all Error Handling requirements in `.highway/skills/highway-discovery/SKILL.md`
- [X] T005 [US1] Run `/usr/bin/perl -e 'alarm shift; exec @ARGV' 300 ./.highway/tools/tests/highway-discovery.test.sh` and resolve any consolidation failures reported for `.highway/tools/tests/highway-discovery.test.sh`

**Checkpoint**: User Story 1 is independently complete when the authoritative source has exactly one Verification and one Error Handling heading, no Expectations headings, and the focused test passes.

## Phase 4: User Story 2 - Make Workflow tie-break authority explicit (Priority: P1)

**Goal**: Make Workflow step 10 delegate equal-score handling to Recommendation Tie-Break Evaluation while retaining matrix-before-Recommendation ordering.

**Independent Test**: `.highway/tools/tests/highway-discovery.test.sh` passes its Workflow assertions against `.highway/skills/highway-discovery/SKILL.md`, including the direct section reference and forbidden-wording check.

### Implementation for User Story 2

- [X] T006 [US2] Replace Workflow step 10's embedded `prefer a matched architecture` rule with a direct `Recommendation Tie-Break Evaluation` reference in `.highway/skills/highway-discovery/SKILL.md`
- [X] T007 [US2] Run `/usr/bin/perl -e 'alarm shift; exec @ARGV' 300 ./.highway/tools/tests/highway-discovery.test.sh` and resolve any Workflow or invariant failures reported for `.highway/tools/tests/highway-discovery.test.sh`

**Checkpoint**: User Story 2 is independently complete when Workflow step 10 directly references the authoritative tie-break section, preserves matrix-before-Recommendation ordering, and the focused test passes.

## Phase 5: Polish and Cross-Cutting Validation

**Purpose**: Synchronize generated artifacts and prove repository-wide integrity without changing excluded surfaces.

- [ ] T008 Regenerate `.github/skills/highway-discovery/SKILL.md`, `.claude/skills/highway-discovery/SKILL.md`, and `.cursor/rules/highway-discovery.mdc` with `.highway/tools/generate-agent-adapters.sh`
- [ ] T009 Run `.highway/tools/tests/adapter-coverage.test.sh` and confirm generated Discovery adapters remain synchronized with `.highway/skills/highway-discovery/SKILL.md`
- [ ] T010 Run `/usr/bin/perl -e 'alarm shift; exec @ARGV' 300 ./.highway/tools/tests/run-all.sh` and confirm the full repository suite passes
- [ ] T011 Review `.highway/skills/highway-discovery/SKILL.md` and the three generated adapters against `specs/052-discovery-contract-consolidation/contracts/discovery-contract-consolidation.md` and confirm no ADR, decision, authorization, or governance baseline mutation was introduced

## Dependencies and Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: T001 has no implementation dependency and establishes the concrete paths.
- **Foundational (Phase 2)**: T002 depends on T001 and blocks both user stories because both rely on the shared focused test.
- **User Story 1 (Phase 3)**: T003 and T004 depend on T002; T005 depends on T003 and T004.
- **User Story 2 (Phase 4)**: T006 depends on T005 because both stories edit the same authoritative skill; T007 depends on T006.
- **Polish (Phase 5)**: T008 depends on T007; T009 and T010 depend on T008; T011 follows T009 and T010.

### User Story Dependencies

- **User Story 1 (P1)**: Starts after T002 and is the MVP increment.
- **User Story 2 (P1)**: Follows User Story 1 because both change `.highway/skills/highway-discovery/SKILL.md` and its shared focused test; its acceptance criteria remain independently testable after the foundation.

### Parallel Opportunities

- T003 and T004 can be performed as separate logical edits within the same source file, but should be applied sequentially by one implementer to preserve the merged section boundaries.
- After T008 completes, T009 and T010 can run in parallel because they read different validation surfaces and do not edit source files.
- T011 is not parallelizable with T009 or T010 because it is the final cross-artifact review.

## Parallel Example: Final Validation

```text
Task: Run `.highway/tools/tests/adapter-coverage.test.sh` after T008.
Task: Run `/usr/bin/perl -e 'alarm shift; exec @ARGV' 300 ./.highway/tools/tests/run-all.sh` after T008.
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete T001 and T002.
2. Complete T003 through T005.
3. Stop and validate the consolidated Verification and Error Handling contracts independently.

### Incremental Delivery

1. Add the shared assertions.
2. Deliver User Story 1 with its focused test checkpoint.
3. Deliver User Story 2 with its focused test checkpoint.
4. Regenerate adapters and run correspondence and full-suite validation.
5. Perform the final ADR and governance-boundary review.

## Notes

- Every task is an unchecked checklist item with a sequential ID and an exact repository path.
- No task changes output templates, generators, packaging manifests, or governance baselines.
- No task creates an ADR or records a decision; those remain outside Discovery ownership.
