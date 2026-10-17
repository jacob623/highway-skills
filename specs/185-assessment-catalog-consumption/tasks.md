---

description: "Implementation tasks for assessment catalog consumption"
---

# Tasks: Assessment Catalog Consumption

**Input**: Design documents from `/specs/185-assessment-catalog-consumption/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/catalog-consumption-contract.md, quickstart.md

**Tests**: Required by the feature specification and the development constitution. Focused shell contract tests are added or amended before the skill contract is changed.

## Phase 1: Setup

**Purpose**: Establish the baseline and confirm the existing artifact generation path.

- [X] T001 Run the existing `.highway/tools/tests/run-all.sh` from the repository root and record the passing baseline before implementation
- [X] T002 Inspect the current `.highway/skills/highway-assessment/SKILL.md`, `.highway/tools/tests/highway-assessment.test.sh`, and declared generator inputs without overwriting existing user changes
- [X] T003 [P] Verify the four catalog paths and their current generated/indexed status in `adrs/adrs.md`, `architectures/architectures.md`, `implementations/implementations.md`, and `implementations/capabilities.md`

---

## Phase 2: Foundational

**Purpose**: Define the contract assertions that all three user stories depend on.

- [X] T004 Add failing catalog-first, selective-source, direct-Realized-By, deterministic-order, and no-mutation assertions to `.highway/tools/tests/highway-assessment.test.sh`
- [X] T005 [P] Add the catalog-first input, authority split, fallback, and determinism expectations to `specs/185-assessment-catalog-consumption/contracts/catalog-consumption-contract.md`
- [X] T006 [P] Confirm the focused test fixture strategy covers valid, unavailable, conflicting, repeated-provider, and reordered catalog entries in `.highway/tools/tests/highway-assessment.test.sh`

**Checkpoint**: The focused test fails for missing catalog guidance and establishes the acceptance evidence before the shipped contract is modified.

---

## Phase 3: User Story 1 - Start Assessment from Authoritative Catalogs (Priority: P1) MVP

**Goal**: Make all four catalogs the first navigation context and make source-record access selective and evidence-driven.

**Independent Test**: Run the focused assessment contract test with valid catalogs, sufficient catalog-only evidence, missing supporting records, and conflicting source detail; verify catalog-first navigation, selective source fallback, preserved uncertainty, and no invented inventory.

### Tests for User Story 1

- [X] T007 [US1] Run `.highway/tools/tests/highway-assessment.test.sh` and capture the failing assertions for catalog inputs and selective source access before editing the skill

### Implementation for User Story 1

- [X] T008 [US1] Add the four catalog paths and catalog-first navigation guidance to `.highway/skills/highway-assessment/SKILL.md`
- [X] T009 [US1] Add the catalog-index/source-record authority precedence, selective lookup, conflict handling, and unavailable-evidence behavior to `.highway/skills/highway-assessment/SKILL.md`
- [X] T010 [US1] Add catalog-first verification coverage and increment the assessment skill version from `1.0.0` to `1.1.0` in `.highway/skills/highway-assessment/SKILL.md`
- [X] T011 [US1] Run `.highway/tools/tests/highway-assessment.test.sh` and verify User Story 1 passes without changing findings persistence or ownership rules

**Checkpoint**: The assessment contract can navigate from every catalog and open only the source record needed for additional evidence.

---

## Phase 4: User Story 2 - Assess Capabilities, Providers, and Implementation Patterns (Priority: P1)

**Goal**: Use Capability Catalog rows and `Realized By` values directly for capability coverage, provider concentration, shared realization, reuse, distribution, and landscape analysis across the existing domains.

**Independent Test**: Run the focused contract test against repeated providers, multiple RI parents, shared capabilities, a capability without architecture representation, and implementation dependencies; verify findings use only existing categories and do not create a technology inventory.

### Tests for User Story 2

- [X] T012 [US2] Extend `.highway/tools/tests/highway-assessment.test.sh` with direct Capability Catalog provider, architecture coverage, implementation reuse, distribution, and dependency assertions

### Implementation for User Story 2

- [X] T013 [US2] Add portfolio guidance for capability coverage, technology adoption, provider patterns, and repository landscape correlation to `.highway/skills/highway-assessment/SKILL.md`
- [X] T014 [US2] Add architecture guidance for comparing realized capabilities with architecture representation and identifying coverage gaps or shared realization reuse in `.highway/skills/highway-assessment/SKILL.md`
- [X] T015 [US2] Add implementation guidance for Implementation Catalog lookup, provider concentration, shared realization, reuse, distribution, and accepted implementation dependencies to `.highway/skills/highway-assessment/SKILL.md`
- [X] T016 [US2] Run `.highway/tools/tests/highway-assessment.test.sh` and verify direct catalog evidence satisfies the User Story 2 assertions without adding an artifact family

**Checkpoint**: Portfolio, architecture, and implementation assessment can use direct capability and implementation catalog evidence independently of architecture traversal.

---

## Phase 5: User Story 3 - Preserve Assessment Ownership and Determinism (Priority: P1)

**Goal**: Preserve the existing finding lifecycle and advisory boundary while guaranteeing order-independent, read-only assessment behavior.

**Independent Test**: Run assessment twice with identical accepted catalogs and findings state, once with catalog rows reordered; compare finding identities and equivalent observations and verify all owner artifact bytes remain unchanged.

### Tests for User Story 3

- [X] T017 [US3] Add reordered-catalog, repeated-run, owner-mutation-routing, existing-category, status, fingerprint, and revision assertions to `.highway/tools/tests/highway-assessment.test.sh`

### Implementation for User Story 3

- [X] T018 [US3] Add deterministic normalization/order-independent result guidance and preserve existing fingerprint, display ID, status, revision, and retained-findings rules in `.highway/skills/highway-assessment/SKILL.md`
- [X] T019 [US3] Add explicit read-only routing for capability, provider, implementation, architecture, and catalog mutation requests to `.highway/skills/highway-assessment/SKILL.md`
- [X] T020 [US3] Run `.highway/tools/tests/highway-assessment.test.sh` and verify all User Story 3 assertions pass with no owner artifact mutation

**Checkpoint**: Repeated equivalent inputs produce deterministic advisory findings and assessment remains outside every owner publication boundary.

---

## Phase 6: Polish and Cross-Cutting Validation

**Purpose**: Regenerate product artifacts, validate the complete contract, and confirm requirement coverage.

- [X] T021 [P] Regenerate `.github/skills/highway-assessment/SKILL.md`, `.claude/skills/highway-assessment/SKILL.md`, `.cursor/skills/highway-assessment/SKILL.md`, and `.agents/skills/highway-assessment/SKILL.md` from the canonical skill using the declared generator
- [X] T022 [P] Regenerate `.highway/catalog/index.json` and `.highway/catalog/index.md` from the changed skill input using the declared catalog generator
- [X] T023 Run `.highway/tools/validate-skill.sh .highway/skills/highway-assessment` and the applicable adapter/catalog correspondence checks
- [X] T024 Run the full `.highway/tools/tests/run-all.sh` suite and confirm no unrelated test regressions
- [X] T025 Review `specs/185-assessment-catalog-consumption/quickstart.md`, `plan.md`, and all task completion markers against the implemented files and record requirement coverage separately from test results

---

## Dependencies and Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No implementation dependency; establishes the baseline and current-file context.
- **Foundational (Phase 2)**: Depends on Setup; the focused failing assertions block story implementation.
- **User Stories (Phases 3-5)**: Depend on Foundational. They touch the same canonical skill/test files and therefore execute sequentially in story order.
- **Polish (Phase 6)**: Depends on all user stories; adapter and catalog regeneration must follow the final canonical skill content.

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Phase 2; no dependency on another story.
- **User Story 2 (P1)**: Starts after User Story 1 because it extends the same catalog-input contract and canonical skill.
- **User Story 3 (P1)**: Starts after User Story 2 because it finalizes the shared finding and ownership guarantees.

### Parallel Opportunities

- T003, T005, and T006 can run in parallel after the baseline is captured.
- T021 and T022 can run in parallel after the canonical skill is complete.
- Validation commands T023 and T024 can run after regeneration, subject to the repository test harness's normal sequencing.

## Implementation Strategy

### MVP First

1. Complete Phase 1 baseline and Phase 2 failing contract assertions.
2. Complete User Story 1 to establish catalog-first navigation and selective source access.
3. Run the focused test as the MVP checkpoint.

### Incremental Delivery

1. Add User Story 2 direct capability and implementation analysis.
2. Add User Story 3 determinism and ownership protections.
3. Regenerate adapters/catalogs and run the full suite.

### Completion Requirements

Every task must be marked `[X]` only after its command or file-level validation succeeds. The final report must state requirement coverage separately from the focused and full test results.
