# Tasks: Discovery Contract Alignment

**Input**: Design documents from `specs/061-discovery-contract-alignment/`
**Prerequisites**: `plan.md`, `research.md`, `data-model.md`, `quickstart.md`

## Phase 1: Setup

- [X] T001 [P] Confirm Feature 061 source, design, and validation paths in `specs/061-discovery-contract-alignment/plan.md`
- [X] T002 [P] Record the current Discovery source/template and generated-artifact baseline in `specs/061-discovery-contract-alignment/quickstart.md`

## Phase 2: Foundational Contract Test Infrastructure

- [X] T003 Inspect the existing Discovery assertions and seeded probe classes in `.highway/tools/tests/highway-discovery.test.sh`
- [X] T004 Add shared temporary-fixture helpers and canonical-byte snapshots to `.highway/tools/tests/highway-discovery.test.sh`
- [X] T005 Add valid and invalid fixture definitions, with independent invalid cases, for the deterministic contract rules in `.highway/tools/tests/highway-discovery.test.sh`
- [X] T006 Run the focused test in `.highway/tools/tests/highway-discovery.test.sh` and record the pre-implementation fixture failures before enabling the new assertions

## Phase 3: User Story 1 - Synchronize Discovery Section Contracts (P1)

**Goal**: Keep the Discovery skill, Verification section, and shared record template synchronized with identical section names and order without duplicating the canonical section list in the feature requirement.

**Independent Test**: The focused Discovery test accepts the synchronized section contract, rejects the former `## Request` heading, and confirms the three canonical artifacts expose identical section names and order.

- [X] T007 [US1] Rename the shared template heading from `## Request` to `## Request Reference` in `.highway/library/templates/output/discovery-record.md`
- [X] T008 [US1] Update the Discovery skill Outputs and Verification contracts to declare identical section names and ordering in `.highway/skills/highway-discovery/SKILL.md`
- [X] T009 [US1] Add independent section-order valid and former-heading invalid assertions to `.highway/tools/tests/highway-discovery.test.sh`
- [X] T010 [US1] Run `.highway/tools/tests/highway-discovery.test.sh --probe source-document` and its neutralized form to verify the source-document probe remains effective in `.highway/tools/tests/highway-discovery.test.sh`

## Phase 4: User Story 2 - Produce Deterministic Constraint Output (P1)

**Goal**: Emit only `Fully Compliant` for retained candidates and validate Desired Change, Objective, and Constraints alignment as integer values from 0 through 100 inclusive.

**Independent Test**: Valid fixtures with boundary values 0 and 100 pass; independent invalid fixtures for `Satisfied`, decimal, negative, and above-100 values fail for their targeted rule.

- [X] T011 [P] [US2] Replace retained-candidate `Satisfied` compliance wording with `Fully Compliant` in `.highway/skills/highway-discovery/SKILL.md`
- [X] T012 [P] [US2] Define integer `<0-100>` alignment fields and `Fully Compliant` retained-candidate compliance wording in `.highway/library/templates/output/discovery-record.md`
- [X] T013 [US2] Add valid boundary and independent invalid compliance/alignment assertions to `.highway/tools/tests/highway-discovery.test.sh`
- [X] T014 [US2] Run the focused compliance and alignment fixture checks and verify each invalid fixture fails independently in `.highway/tools/tests/highway-discovery.test.sh`

## Phase 5: User Story 3 - Explain Traceability and Elimination Ordering (P1)

**Goal**: Document Required Platform Match as traceability-only at 100 for retained candidates and define deterministic Candidate Elimination Log ordering.

**Independent Test**: Valid fixtures confirm required-platform filtering precedes scoring, retained Required Platform Match is 100, and elimination entries sort by Candidate Identifier, Constraint Category, then Constraint Identifier or Value; independent malformed-ordering and traceability invalid fixtures fail.

- [X] T015 [P] [US3] Add Required Platform Match traceability-only wording and pre-scoring filtering verification to `.highway/skills/highway-discovery/SKILL.md`
- [X] T016 [P] [US3] Add Candidate Elimination Log ordering and Required Platform Match traceability fields to `.highway/library/templates/output/discovery-record.md`
- [X] T017 [US3] Add independent traceability and elimination-ordering fixture assertions to `.highway/tools/tests/highway-discovery.test.sh`
- [X] T018 [US3] Run the focused traceability and elimination-ordering checks in `.highway/tools/tests/highway-discovery.test.sh`

## Phase 6: Regeneration and Cross-Cutting Validation

- [X] T019 Regenerate the generated GitHub Copilot, Claude Code, and Cursor Discovery adapters with `.highway/tools/generate-agent-adapters.sh`
- [X] T020 Regenerate generated skill and library catalogs with `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-library-catalog.sh`
- [X] T021 Run `.highway/tools/validate-skill.sh .highway/skills/highway-discovery` and `.highway/tools/validate-library.sh .highway/library/templates/output/discovery-record.md`
- [X] T022 Run `.highway/tools/tests/adapter-coverage.test.sh` and confirm generated Discovery artifacts are current and correspond to canonical sources
- [X] T023 Run `.highway/tools/tests/output-template.test.sh` and confirm shared-template citations and validation remain valid
- [X] T024 Run the full-suite validation with `.highway/tools/tests/run-all.sh` and confirm the complete repository suite passes
- [X] T025 Run `git diff --check` and verify disposable-fixture execution left canonical source, template, adapters, and catalogs unchanged except for intended generated updates

## Dependencies and Execution Order

### Story Completion Order

```text
Setup (T001-T002)
  -> Foundational test infrastructure (T003-T006)
  -> US1: section contracts (T007-T010)
  -> US2: compliance/alignment (T011-T014)
  -> US3: traceability/elimination (T015-T018)
  -> Regeneration and cross-cutting validation (T019-T025)
```

US2 and US3 share the foundational fixture harness and should begin after Phase 2. Their canonical
source edits can proceed in parallel once US1's section-authority decisions are established, but
regeneration and full validation must wait until all three stories are complete.

## Parallel Execution Examples

### User Story 1

```text
Parallel: T007, T009
Sequential: T008 after T007; T010 after T007-T009
```

### User Story 2

```text
Parallel: T011, T012, T013
Sequential: T014 after T011-T013
```

### User Story 3

```text
Parallel: T015, T016, T017
Sequential: T018 after T015-T017
```

### Cross-Cutting Phase

```text
Sequential: T019 -> T020 -> T021 -> T022 -> T023 -> T024 -> T025
```

## Implementation Strategy

1. **MVP**: Complete US1 so the canonical section contract is synchronized and independently tested.
2. **Increment 2**: Complete US2 for deterministic compliance and alignment validation.
3. **Increment 3**: Complete US3 for traceability and elimination ordering.
4. **Release hardening**: Regenerate generated adapters/catalogs and run focused, correspondence,
   validator, and full-suite validation checks before claiming completion.

## Completion Criteria

- All tasks are checked only after their file-scoped implementation or validation succeeds.
- Each user story passes its independent test criteria before the next story is accepted.
- Generated artifacts are regenerated from canonical inputs and pass correspondence checks.
- The full repository suite and `git diff --check` pass.
