---

description: "Task list for Highway Implementation Compatibility Assessment"
---

# Tasks: Highway Implementation Compatibility Assessment

**Input**: Design documents from `specs/178-highway-implementation-compatibility/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/implementation-compatibility.md`, `quickstart.md`

**Tests**: Add or amend focused contract tests because the feature changes accepted inputs, assessment outcomes, output sections, and RI generation gates.

## Phase 1: Setup

**Purpose**: Establish the existing implementation skill, shared template, tests, and generated surfaces.

- [x] T001 Verify Feature 178 plan, research, data model, contract, quickstart, constitution gates, and checklist in `specs/178-highway-implementation-compatibility/`
- [x] T002 [P] Inspect the authoritative implementation skill and shared output record template in `.highway/skills/highway-implementation/SKILL.md` and `.highway/library/templates/output/implementation-record.md`
- [x] T003 [P] Inspect implementation onboarding, shared output-template, readiness, and adapter correspondence tests under `.highway/tools/tests/`
- [x] T004 [P] Confirm Feature 176 ownership and current RI allocation/no-write behavior remain the baseline in `specs/176-highway-implementation/` and `.highway/skills/highway-implementation/SKILL.md`

---

## Phase 2: Foundational

**Purpose**: Establish the shared compatibility vocabulary and failing contract assertions before implementation edits.

- [x] T005 Add compatibility fixture helpers for normalized selections, architecture responsibilities, category coverage, gap analysis, conflict analysis, and deterministic ordering in `.highway/tools/tests/implementation-compatibility.test.sh`
- [x] T006 Add contract assertions for required Implementation Selections, exactly three outcomes, coverage statuses, no-generation gates, architecture authority, and traceability in `.highway/tools/tests/implementation-compatibility.test.sh`
- [x] T007 Add assertions for the six required output sections and technology realization rationale in `.highway/tools/tests/highway-implementation-onboarding.test.sh`
- [x] T008 Run the focused compatibility and onboarding tests before source changes and record the expected failing assertions

**Checkpoint**: Foundational tests define the Feature 178 contract without weakening Feature 176 checks.

---

## Phase 3: User Story 1 - Provide Implementation Selections (Priority: P1)

**Goal**: Require one or more user-owned Implementation Selections and normalize them deterministically.

**Independent Test**: Supply named components in multiple orders, duplicate/equivalent names, and no selections; verify acceptance, deterministic normalization, and the missing-input response.

- [x] T009 [US1] Define the Implementation Selections input contract, supported component kinds, missing-input response, and prohibited implicit technology invention in `.highway/skills/highway-implementation/SKILL.md`
- [x] T010 [US1] Add Implementation Selections input and normalized ordering fields to `.highway/library/templates/output/implementation-record.md`
- [x] T011 [US1] Run the focused compatibility and onboarding tests for supplied, reordered, duplicate, unsupported, and missing selections

**Checkpoint**: User Story 1 independently accepts explicit owner selections without generating an RI.

---

## Phase 4: User Story 2 - Assess Architecture Compatibility (Priority: P1)

**Goal**: Extract architecture responsibilities and produce exactly one deterministic compatibility result before RI generation.

**Independent Test**: Run compatible, incomplete, and incompatible fixtures and verify the result, source requirements, stable ordering, and pre-generation assessment boundary.

- [x] T012 [US2] Document extraction of Logical Components, Interaction Model, Trust Boundaries, Deployment Pattern, Required Capabilities, Constraints, Control Relationships, NFR Relationships, and Reference Implementation Guidance in `.highway/skills/highway-implementation/SKILL.md`
- [x] T013 [US2] Document the ordered realization categories and `Satisfied`/`Unsatisfied`/`Not Applicable` coverage model in `.highway/skills/highway-implementation/SKILL.md`
- [x] T014 [US2] Add the Architecture Compatibility Assessment and Coverage Summary sections to `.highway/library/templates/output/implementation-record.md`
- [x] T015 [US2] Add deterministic compatible, incomplete, incompatible, and reordered-input assertions to `.highway/tools/tests/implementation-compatibility.test.sh`
- [x] T016 [US2] Run `.highway/tools/tests/implementation-compatibility.test.sh` and confirm assessment occurs before RI allocation or persistence

**Checkpoint**: User Story 2 independently produces one of the three compatibility outcomes.

---

## Phase 5: User Story 3 - Resolve Implementation Gaps (Priority: P1)

**Goal**: Make non-contradictory missing responsibilities actionable and block RI generation until resolved.

**Independent Test**: Assess missing messaging, identity, observability, Controls, and NFR realization and verify complete gap fields, grounded recommendations, Unknown behavior, and no RI writes.

- [x] T017 [US3] Define `Incomplete` behavior, Implementation Gap Analysis fields, owner resolution actions, and reassessment boundary in `.highway/skills/highway-implementation/SKILL.md`
- [x] T018 [US3] Add Implementation Gaps section and required gap fields to `.highway/library/templates/output/implementation-record.md`
- [x] T019 [US3] Add evidence-backed recommendation and `Unknown` fixtures, including Controls/NFR gaps, to `.highway/tools/tests/implementation-compatibility.test.sh`
- [x] T020 [US3] Add incomplete no-RI/no-catalog-write assertions using existing test helpers in `.highway/tools/tests/implementation-compatibility.test.sh`
- [x] T021 [US3] Run `.highway/tools/tests/implementation-compatibility.test.sh` for unresolved, accepted, substituted, and supplemented gaps

**Checkpoint**: User Story 3 independently prevents incomplete RI generation and exposes resolution-ready gaps.

---

## Phase 6: User Story 4 - Resolve Implementation Conflicts (Priority: P1)

**Goal**: Report direct contradictions without silently repairing architecture and expose exactly two resolution paths.

**Independent Test**: Exercise event-driven versus scheduled batch, stateless versus stateful, and explicitly excluded self-hosted fixtures; verify structured conflicts, two paths, and no writes.

- [x] T022 [US4] Define `Incompatible` behavior, conflict fields, architecture authority, and exactly `Resolve Implementation`/`Revisit Architecture` paths in `.highway/skills/highway-implementation/SKILL.md`
- [x] T023 [US4] Add Implementation Conflicts section and conflict fields to `.highway/library/templates/output/implementation-record.md`
- [x] T024 [US4] Add direct contradiction fixtures, two-path assertions, architecture-preservation checks, and incompatible no-write checks in `.highway/tools/tests/implementation-compatibility.test.sh`
- [x] T025 [US4] Run `.highway/tools/tests/implementation-compatibility.test.sh` and verify incompatible inputs cannot allocate or publish an RI

**Checkpoint**: User Story 4 independently protects architecture authority during conflict handling.

---

## Phase 7: User Story 5 - Generate a Validated Reference Implementation (Priority: P1)

**Goal**: Permit existing RI generation only after compatibility succeeds and retain selection rationale and traceability.

**Independent Test**: Supply a compatible selection set and verify one proposed RI with all compatibility sections, rationale, Controls/NFR realization, and available traceability.

- [x] T026 [US5] Define the compatible generation gate and preserve existing RI allocation, atomic persistence, ownership, and traceability behavior in `.highway/skills/highway-implementation/SKILL.md`
- [x] T027 [US5] Add Technology Realization Rationale and complete compatible-output fields to `.highway/library/templates/output/implementation-record.md`
- [x] T028 [US5] Add compatible generation, selection-to-responsibility mapping, rationale, Controls/NFR realization, and `REQ -> DISC -> ADR -> ARCH -> RI` assertions in `.highway/tools/tests/implementation-compatibility.test.sh`
- [x] T029 [US5] Run the focused compatibility, implementation onboarding, and existing RI validation tests for a compatible fixture

**Checkpoint**: User Story 5 independently produces a validated proposed RI only from `Compatible`.

---

## Phase 8: User Story 6 - Review Deterministic Coverage and Ownership (Priority: P2)

**Goal**: Make coverage complete, deterministic, auditable, and architecture-authoritative.

**Independent Test**: Verify required categories receive one status, irrelevant categories are `Not Applicable`, no architecture requirement is omitted, and repeated runs are stable.

- [x] T030 [US6] Add explicit no-silent-omission, category applicability, stable ordering, and architecture/ADR authority requirements to `.highway/skills/highway-implementation/SKILL.md`
- [x] T031 [US6] Add coverage, unsupported selection, stable-order, and upstream-byte-preservation fixtures to `.highway/tools/tests/implementation-compatibility.test.sh`
- [x] T032 [US6] Run focused compatibility and source-preservation tests for repeated and reordered assessments

**Checkpoint**: User Story 6 independently proves reviewable deterministic coverage and ownership.

---

## Phase 9: User Story 7 - Align Future Brownfield Observations (Priority: P2)

**Goal**: Keep observed implementation components compatible with the same assessment input shape without implementing discovery.

**Independent Test**: Verify contract documentation accepts future observed components conceptually while no separate brownfield engine or workflow is added.

- [x] T033 [US7] Document the equivalent observed-component input boundary and explicit brownfield scope exclusion in `.highway/skills/highway-implementation/SKILL.md`
- [x] T034 [US7] Add a contract assertion that no separate brownfield validation model or workflow is introduced in `.highway/tools/tests/implementation-compatibility.test.sh`
- [x] T035 [US7] Run the focused compatibility contract and verify future observed inputs share the same outcome vocabulary and category model

**Checkpoint**: User Story 7 independently preserves a reusable future input boundary.

---

## Phase 10: Polish and Cross-Cutting Validation

**Purpose**: Regenerate derived surfaces, revalidate dependent skills/templates, and run the complete suite.

- [x] T036 Regenerate `.highway/catalog/`, `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, and `.agents/skills/` from authoritative inputs using the repository generators
- [x] T037 Revalidate every skill citing the changed implementation template and run shared output-template checks for D8.1 in `.highway/tools/tests/output-template.test.sh`
- [x] T038 [P] Run `.highway/tools/tests/highway-implementation-onboarding.test.sh` and `.highway/tools/tests/implementation-compatibility.test.sh` after regeneration
- [x] T039 [P] Run `.highway/tools/tests/run-all.sh` and record any unrelated failures without weakening tests
- [x] T040 Verify `git diff --check`, generated-source correspondence, no placeholder markers, unchanged Feature 176 artifacts, and complete task coverage
- [x] T041 Run all validation scenarios in `specs/178-highway-implementation-compatibility/quickstart.md` and mark this task list complete

---

## Dependencies and Execution Order

- Setup (Phase 1) precedes Foundational (Phase 2).
- Foundational contract tests (T005-T008) precede all implementation edits.
- US1 precedes US2 because assessment requires normalized selections.
- US2 precedes US3-US5 because gap, conflict, and generation behavior depend on the assessment boundary.
- US3 and US4 can proceed in parallel after US2 if they touch separate sections, but shared skill/template files must be edited sequentially.
- US5 depends on US3 and US4 because generation must be gated by both unresolved gaps and conflicts.
- US6 and US7 depend on the shared assessment vocabulary but do not change the generation gate.
- Polish begins after all story checkpoints pass.

## Parallel Opportunities

- T002-T004 can run in parallel.
- T005-T007 can run in parallel when each assertion group targets a distinct test section.
- US3 and US4 can be developed in parallel after US2 with coordinated edits to shared files.
- T038 and T039 can run in parallel after regeneration.

## Implementation Strategy

1. Establish failing compatibility contracts and preserve the existing Feature 176 baseline.
2. Add explicit selections and the three-outcome assessment boundary.
3. Add incomplete gap resolution and incompatible conflict handling.
4. Gate compatible RI generation and extend the output record.
5. Add deterministic coverage, ownership, and future brownfield input-boundary checks.
6. Regenerate all derived outputs and run focused plus full validation.
