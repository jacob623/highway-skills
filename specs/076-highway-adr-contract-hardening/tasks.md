---

description: "Implementation tasks for Highway ADR Contract Hardening"
---

# Tasks: Highway ADR Contract Hardening

**Input**: Design documents from `specs/076-highway-adr-contract-hardening/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/adr-contract-hardening.md`, `quickstart.md`

**Tests**: Required by the feature specification; every invalid fixture must prove pre-write byte preservation.

## Phase 1: Setup

- [X] T001 Confirm Feature 076 design artifacts and existing ADR baseline paths in `specs/076-highway-adr-contract-hardening/plan.md` and `.highway/skills/highway-adr/SKILL.md`
- [X] T002 [P] Record the canonical/generated ADR artifact set in `specs/076-highway-adr-contract-hardening/quickstart.md`

## Phase 2: Foundational Contract and Test Baseline

- [X] T003 [P] Add Feature 076 contract invariants and required fixture classes to `.highway/tools/tests/highway-adr.test.sh`
- [X] T004 [P] Add ADR template shape assertions for scalar Clarification and handoff metadata to `.highway/tools/tests/output-template.test.sh`
- [X] T005 [P] Add the catalog allocation and uniqueness contract wording to `.highway/library/templates/output/adr-catalog.md`
- [X] T006 Update the canonical ADR output skeleton and section-order expectations in `.highway/library/templates/output/adr-record.md`
- [X] T007 Update the canonical ADR workflow ownership, allocation, failure, and verification contract in `.highway/skills/highway-adr/SKILL.md`

## Phase 3: User Story 1 - Complete Decision Confidence (Priority: P1) MVP

**Goal**: Every valid ADR has a mandatory Decision Confidence section with deterministic `None` behavior and invalid output is rejected before writes.

**Independent Test**: Run `.highway/tools/tests/highway-adr.test.sh` confidence fixtures and confirm present and unavailable confidence both render the required fields while missing/incomplete confidence preserves all bytes.

- [X] T008 [US1] Define mandatory Decision Confidence output and unavailable-evidence behavior in `.highway/library/templates/output/adr-record.md`
- [X] T009 [US1] Document confidence projection without rescoring and pre-write validation in `.highway/skills/highway-adr/SKILL.md`
- [X] T010 [US1] Add positive and negative Decision Confidence fixtures, including byte-preservation assertions, to `.highway/tools/tests/highway-adr.test.sh`
- [X] T011 [US1] Mirror the confidence contract in generated adapters by running the repository ADR generation workflow after canonical edits

**Checkpoint**: User Story 1 is independently testable through the focused ADR contract harness.

## Phase 4: User Story 2 - Discovery Uniqueness and Catalog Allocation (Priority: P1)

**Goal**: ADR publication uses the authoritative catalog for Discovery uniqueness and exact `Next ID` allocation with atomic failure behavior.

**Independent Test**: Run duplicate, successful allocation, malformed cursor, and three-conflict fixtures and verify exact catalog transitions or unchanged bytes.

- [X] T012 [P] [US2] Add duplicate Discovery, catalog cursor, allocation conflict, and no-partial-write fixtures to `.highway/tools/tests/highway-adr.test.sh`
- [X] T013 [US2] Specify authoritative ADR-to-Discovery uniqueness and exact pre-write `Next ID` use in `.highway/skills/highway-adr/SKILL.md`
- [X] T014 [US2] Specify one-entry/one-advance catalog transition and ordered index shape in `.highway/library/templates/output/adr-catalog.md`
- [X] T015 [US2] Add explicit uniqueness and allocation verification checks to the canonical `Verification` section in `.highway/skills/highway-adr/SKILL.md`
- [X] T016 [US2] Run focused catalog/ADR validation and repair any contract failures in `.highway/tools/tests/highway-adr.test.sh`

**Checkpoint**: User Story 2 is independently testable through catalog transition and byte-preservation fixtures.

## Phase 5: User Story 3 - Vocabulary and Projection Consistency (Priority: P1)

**Goal**: Alternatives, Clarification absence, supersession metadata, matrix projection, and Recommendation Override have one explicit contract.

**Independent Test**: Run output-template and ADR fixtures for selected/rejected/evaluated alternatives, semantic contradictions, scalar `None`, frontmatter-only supersession, matrix projection, and recommendation agreement/divergence.

- [X] T017 [P] [US3] Change Clarification Inputs to scalar `None` and remove handoff `Supersedes`/`Superseded By` from `.highway/library/templates/output/adr-record.md`
- [X] T018 [P] [US3] Define `Selected`, `Rejected`, and `Evaluated` semantics and exactly-one selection in `.highway/skills/highway-adr/SKILL.md`
- [X] T019 [P] [US3] Define verbatim Comparison Matrix projection and LF/canonical fixture comparison in `.highway/skills/highway-adr/SKILL.md`
- [X] T020 [P] [US3] Define Recommendation Override agreement omission and divergence placement/fields in `.highway/library/templates/output/adr-record.md`
- [X] T021 [US3] Add alternative semantic contradiction fixtures, scalar Clarification assertion, supersession duplication rejection, matrix projection comparison, and override agreement/divergence fixtures to `.highway/tools/tests/highway-adr.test.sh`
- [X] T022 [US3] Update shared output-template assertions for the final ADR section order and frontmatter-only supersession in `.highway/tools/tests/output-template.test.sh`
- [X] T023 [US3] Add all five required safeguards to the canonical ADR `Verification` section in `.highway/skills/highway-adr/SKILL.md`

**Checkpoint**: User Story 3 is independently testable through the focused ADR and template harnesses.

## Phase 6: Polish and Cross-Cutting Synchronization

- [X] T024 Regenerate `.highway/catalog/`, `.github/skills/`, `.claude/skills/`, and `.cursor/rules/` from canonical inputs using `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh`
- [X] T025 [P] Run `.highway/tools/tests/validate-skill.test.sh` and `.highway/tools/tests/validate-library.test.sh` against the updated canonical and generated artifacts
- [X] T026 [P] Run `.highway/tools/tests/adapter-coverage.test.sh` and `.highway/tools/tests/generate-agent-adapters.test.sh` to prove correspondence and regeneration integrity
- [X] T027 Run `.highway/tools/tests/highway-adr.test.sh` and `.highway/tools/tests/output-template.test.sh` and repair only Feature 076 contract failures
- [X] T028 Run `.highway/tools/tests/run-all.sh` and confirm zero failures
- [X] T029 Run `git diff --check` and review the Feature 076 diff for generated-artifact synchronization, no partial-write test evidence, and no unrelated changes

## Dependencies and Execution Order

- Setup (T001-T002) precedes foundational work.
- Foundational tasks T003-T007 precede all user stories.
- User Story 1, User Story 2, and User Story 3 all depend on the foundational contract baseline and can be developed in parallel by file ownership where practical; T006/T007 are shared canonical files, so their edits must be serialized.
- Regeneration T024 follows all canonical edits and focused tests.
- Validation T025-T028 follows regeneration; T029 is final review.

## Parallel Opportunities

- T002, T003, T004, and T005 can be prepared in parallel before the shared canonical template/skill edits.
- Within User Story 3, T017, T018, T019, and T020 are independently specifiable but edits to the same canonical files must be applied sequentially.
- T025 and T026 can run in parallel after regeneration.

## Independent Test Criteria

- **US1**: Confidence present/unavailable outputs pass; missing or malformed confidence fails before any write.
- **US2**: Duplicate Discovery fails unchanged; successful allocation uses the exact catalog cursor and advances once; conflicts exhaust at three retries without partial output.
- **US3**: Controlled alternative vocabulary and semantics, scalar Clarification `None`, frontmatter-only supersession, verbatim matrix, and conditional override all pass focused fixtures.

## Implementation Strategy

Deliver the MVP as User Story 1 after the foundational contract baseline. Complete catalog integrity next, then vocabulary/projection consistency, regenerate every derived artifact, and finish with focused plus full-suite validation.
