# Tasks: Capability Catalog

**Input**: Design documents from `/specs/184-capability-catalog/`
**Prerequisites**: plan.md, research.md, data-model.md, contracts/capability-catalog-contract.md, quickstart.md

## Phase 1: Setup

- [ ] T001 Confirm the 184 Capability Catalog output paths and generated-artifact ownership in `.highway/library/templates/output/implementation-record.md`, `.highway/library/templates/output/implementation-catalog.md`, and `.highway/library/templates/output/capability-catalog.md`
- [ ] T002 [P] Add the Capability Catalog contract fixture path and probe registration in `.highway/tools/tests/capability-catalog.test.sh`

## Phase 2: Foundational Contract Changes

- [ ] T003 Add the `Realized Capabilities` evidence section and business-outcome validation rules to `.highway/library/templates/output/implementation-record.md`
- [ ] T004 Add the `capabilities.md` catalog shape, CAP identifier rules, parent integrity, realization requirements, and deterministic ordering to `.highway/library/templates/output/capability-catalog.md`
- [ ] T005 Extend `.highway/skills/highway-implementation/SKILL.md` with capability evidence inputs, ownership boundaries, identity matching, and catalog output responsibilities
- [ ] T006 [P] Add the Capability Catalog entity and publication contract assertions to `.highway/tools/tests/capability-catalog.test.sh`
- [ ] T007 [P] Extend `.highway/tools/tests/highway-implementation-onboarding.test.sh` to require the realized-capability record section and capability catalog template contract

## Phase 3: User Story 1 - Publish Capabilities from Implementation Evidence

**Goal**: An accepted RI publishes explicit business capabilities and one or more realization values into the derived catalog.

**Independent Test**: Run the capability-catalog contract test with valid RI evidence for one capability, multiple capabilities, and multiple Realized By values; verify the expected output contract and no standalone CAP record files.

- [ ] T008 [US1] Define the RI capability evidence fields and required validation behavior in `.highway/skills/highway-implementation/SKILL.md`
- [ ] T009 [US1] Define generation of one catalog row per `(Parent RI, normalized Title)` with canonical multiple Realized By rendering in `.highway/skills/highway-implementation/SKILL.md`
- [ ] T010 [US1] Add valid, empty, component-named, and multi-provider fixtures to `.highway/tools/tests/capability-catalog.test.sh`
- [ ] T011 [US1] Add acceptance probes for RI evidence projection and absence of `CAP######.md` files to `.highway/tools/tests/capability-catalog.test.sh`

## Phase 4: User Story 2 - Navigate Capabilities and Providers

**Goal**: Stakeholders and assessment can navigate from a business capability to its RI parent and direct realization providers without a separate technology inventory.

**Independent Test**: Load a fixture catalog containing repeated capability titles across RIs and repeated providers across capabilities; verify parent and provider references are direct and unambiguous.

- [ ] T012 [US2] Document assessment-readable Parent and Realized By references in `.highway/skills/highway-implementation/SKILL.md`
- [ ] T013 [US2] Add cross-RI duplicate-title and repeated-provider fixtures to `.highway/tools/tests/capability-catalog.test.sh`
- [ ] T014 [US2] Add assertions that capability navigation does not create or require a technology inventory in `.highway/tools/tests/capability-catalog.test.sh`
- [ ] T015 [US2] Update `specs/184-capability-catalog/quickstart.md` with the provider-navigation verification scenario

## Phase 5: User Story 3 - Preserve Deterministic and Atomic Publication

**Goal**: Regeneration preserves stable identities and ordering, removes stale derived rows, and never leaves partial RI/catalog state.

**Independent Test**: Run deterministic, malformed, duplicate, allocation-conflict, and write-failure probes and compare all pre-operation bytes and repeated outputs.

- [ ] T016 [US3] Define prior-catalog identity matching, stable CAP reuse, sequential Next ID allocation, and stale-row removal in `.highway/skills/highway-implementation/SKILL.md`
- [ ] T017 [US3] Define validation-before-persistence and atomic RI, implementation-catalog, and capability-catalog publication behavior in `.highway/skills/highway-implementation/SKILL.md`
- [ ] T018 [US3] Add duplicate ID, orphan parent, missing realization, invalid ordering, stale-row, and no-RI fixtures to `.highway/tools/tests/capability-catalog.test.sh`
- [ ] T019 [US3] Add repeated-run byte comparison and stable-ID allocation probes to `.highway/tools/tests/capability-catalog.test.sh`
- [ ] T020 [US3] Add failure-preserves-bytes and no-partial-publication probes to `.highway/tools/tests/capability-catalog.test.sh`

## Phase 6: Polish and Cross-Cutting Validation

- [ ] T021 Update `.highway/tools/tests/highway-implementation-onboarding.test.sh` for the final skill/template output contract and generated catalog path
- [ ] T022 Regenerate `.github/skills/highway-implementation/SKILL.md`, `.claude/skills/highway-implementation/SKILL.md`, `.cursor/rules/highway-implementation.mdc`, and `.highway/tools/.adapter-manifest` with `.highway/tools/generate-agent-adapters.sh`
- [ ] T023 Run `.highway/tools/validate-skill.sh .highway/skills/highway-implementation` and both relevant `validate-library.sh` checks, resolving all contract errors
- [ ] T024 Run `.highway/tools/tests/capability-catalog.test.sh`, `.highway/tools/tests/highway-implementation-onboarding.test.sh`, and `.highway/tools/tests/run-all.sh`
- [ ] T025 Run `.highway/tools/generate-catalog.sh`, regenerate adapters if required, and verify generated catalog correspondence and `git diff --check`
- [ ] T026 Update `specs/184-capability-catalog/quickstart.md` with the final commands and observed validation outcomes

## Dependencies and Execution Order

- Phase 1 precedes Phase 2.
- Phase 2 precedes all user story phases.
- User Story 1 precedes User Story 2 because provider navigation consumes the published capability row shape.
- User Story 2 and User Story 3 can proceed in parallel after User Story 1's row shape and evidence contract exist.
- Phase 6 follows all story phases and owns generated artifact synchronization and full validation.

## Parallel Execution Examples

- **Phase 1**: T002 can run in parallel with T001.
- **Phase 2**: T006 and T007 can run in parallel after T003-T005 establish the contract.
- **User Story 1**: T010 and T011 can run in parallel after T008-T009.
- **User Story 2**: T013 and T014 can run in parallel after T012.
- **User Story 3**: T018, T019, and T020 can run in parallel after T016-T017.

## Implementation Strategy

1. Establish the RI evidence and catalog contracts.
2. Deliver User Story 1 as the MVP: explicit capability evidence and valid catalog rows.
3. Add direct provider and assessment navigation for User Story 2.
4. Add stable identity, deterministic regeneration, and atomic failure behavior for User Story 3.
5. Regenerate adapters and catalogs, then run focused and full validation.
