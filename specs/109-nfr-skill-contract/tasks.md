---

description: "Implementation tasks for NFR Skill Contract Simplification"
---

# Tasks: NFR Skill Contract Simplification

**Input**: Design documents from `/specs/109-nfr-skill-contract/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, and `quickstart.md`

**Tests**: Included because the specification requires focused contract coverage and a passing full suite.

## Phase 1: Setup

**Purpose**: Establish the current NFR artifacts, generated outputs, and test boundaries.

- [X] T001 Inventory current NFR skill/template/candidate-state references, generated adapters, catalogs, and dependent setup/control paths in `.highway/tools/tests/`
- [X] T002 [P] Confirm generator commands and output paths in `.highway/tools/generate-agent-adapters.sh` and `.highway/tools/generate-library-catalog.sh`
- [X] T003 [P] Inventory all current `highway-nfrs` terminology and legacy contract assertions in `.highway/tools/tests/nfr-management.test.sh`, `.highway/tools/tests/highway-nfr-onboarding.test.sh`, `.highway/tools/tests/readiness-executable.test.sh`, and `.highway/tools/tests/output-template.test.sh`

---

## Phase 2: Foundational

**Purpose**: Establish the single durable candidate-state authority and update shared contract assertions before runtime edits.

- [X] T004 Create `.highway/catalog/nfr-candidate-state.md` as the single NFR-owned durable candidate-state schema authority
- [X] T005 [P] Add candidate-state, owner-result, and NFR-record contract assertions to `.highway/tools/tests/nfr-management.test.sh` and `.highway/tools/tests/output-template.test.sh`
- [X] T006 [P] Update `.highway/tools/tests/highway-nfr-onboarding.test.sh` and `.highway/tools/tests/control-derived-nfr.test.sh` to reject `Created Control IDs`, verified/persistence-verified terminology, and the legacy NFR review shape

**Checkpoint**: Candidate state and focused assertions describe the intended NFR 11.0.0 and record-template 2.0.0 contracts.

---

## Phase 3: User Story 1 - Resolve Control-derived recommendations first (Priority: P1) 🎯 MVP

**Goal**: Make durable, ordered, resumable Control-derived NFR candidates NFR-owned and present them before open discovery.

**Independent Test**: Exercise candidate generation, durable state, ordered decisions, interruption/resume, exactly-once behavior, and the candidate-generation owner result.

### Tests for User Story 1

- [X] T007 [P] [US1] Add candidate-generation request/result assertions and exactly-once generation fixtures in `.highway/tools/tests/control-derived-nfr.test.sh`
- [X] T008 [P] [US1] Add ordered candidate persistence and first-unresolved resume scenarios in `.highway/tools/tests/highway-nfr-onboarding.test.sh`

### Implementation for User Story 1

- [X] T009 [US1] Define the originating Control, generation attempt, readiness/classification, ordered entries, decisions, resume, and blocking fields in `.highway/catalog/nfr-candidate-state.md`
- [X] T010 [US1] Rewrite the Control-derived candidate onboarding section of `.highway/skills/highway-nfrs/SKILL.md` to reference `.highway/catalog/nfr-candidate-state.md` instead of repeating its schema
- [X] T011 [US1] Update `.highway/skills/highway-nfrs/SKILL.md` to present pending Control-derived candidates before broad discovery and persist each decision before advancing
- [X] T012 [US1] Replace all `verified new Control`, `verified Control`, `persistence-verified`, and `Created Control IDs` dependencies in `.highway/skills/highway-nfrs/SKILL.md` with the approved successfully-created-Control boundary

**Checkpoint**: Candidate review is NFR-owned, ordered, durable, resumable, and independent of transient Controls collection state.

---

## Phase 4: User Story 2 - Discover and capture additional NFRs (Priority: P1)

**Goal**: Provide grounded additional recommendations, exact fallback discovery wording, direct capture, and materially interpreted NFR review.

**Independent Test**: Exercise grounded recommendations, fallback question, direct NFR capture, captured-NFR review, rationale synthesis, and Control routing.

### Tests for User Story 2

- [X] T013 [P] [US2] Add exact broad-question, grounded-recommendation, direct-capture, and captured-review assertions in `.highway/tools/tests/highway-nfr-onboarding.test.sh`
- [X] T014 [P] [US2] Add classification and `/highway-controls` routing assertions in `.highway/tools/tests/nfr-management.test.sh`

### Implementation for User Story 2

- [X] T015 [US2] Rewrite open NFR discovery in `.highway/skills/highway-nfrs/SKILL.md` to offer accepted-context recommendations before questions and use the exact fallback question
- [X] T016 [US2] Replace the legacy user-authored proposal shape in `.highway/skills/highway-nfrs/SKILL.md` with the captured-NFR review and bottom acceptance request
- [X] T017 [US2] Remove separate rationale questioning and incorrect Control-as-NFR examples from `.highway/skills/highway-nfrs/SKILL.md`, preserving transient classification and user-owned wording
- [X] T018 [US2] Preserve recommendation grounding boundaries in `.highway/skills/highway-nfrs/SKILL.md` without copying Control Recommendation Grounding into NFR records

**Checkpoint**: Additional NFR collection uses shared recommendation behavior, direct capture, materially interpreted review, and evidence-grounded rationale.

---

## Phase 5: User Story 3 - Keep readiness and collection completion distinct (Priority: P1)

**Goal**: Preserve owner-controlled readiness states and the separate setup/configure collection result without candidate-count inspection.

**Independent Test**: Exercise Not Applicable, In Progress, Complete, Blocked, Continue, Finished, explicit finish, and malformed-state paths.

### Tests for User Story 3

- [X] T019 [P] [US3] Update readiness state assertions and malformed-state fixtures in `.highway/tools/tests/readiness-contract.test.sh` and `.highway/tools/tests/readiness-owner-states.test.sh`
- [X] T020 [P] [US3] Update setup owner-result assertions to reject candidate-count inspection and created-NFR-ID lists in `.highway/tools/tests/highway-setup.test.sh` and `.highway/tools/tests/setup-owner-loop-contract.test.sh`

### Implementation for User Story 3

- [X] T021 [US3] Rewrite readiness and collection result sections in `.highway/skills/highway-nfrs/SKILL.md` to preserve both exact four-field contracts and their distinct state meanings
- [X] T022 [US3] Update `.highway/skills/highway-nfrs/SKILL.md` so readiness remains NFR-owner controlled and setup/configure continues until explicit finish even when readiness is Complete
- [X] T023 [US3] Update `.highway/skills/highway-setup/SKILL.md` and its focused tests to consume NFR owner results without inspecting candidate counts or depending on created-NFR IDs

**Checkpoint**: Readiness is independent of active collection, and Setup consumes declared owner results only.

---

## Phase 6: User Story 4 - Preserve accepted NFR records and relationships (Priority: P1)

**Goal**: Update the NFR record template and preserve direct/Control-derived identifier-only relationships with atomic persistence.

**Independent Test**: Validate template metadata/placeholders, direct `controls: []`, immutable originating Control IDs, and relationship mutation safety.

### Tests for User Story 4

- [X] T024 [P] [US4] Add NFR record version, accepted-placeholder, and origin-guidance assertions in `.highway/tools/tests/output-template.test.sh`
- [X] T025 [P] [US4] Add direct and Control-derived relationship assertions in `.highway/tools/tests/control-derived-nfr.test.sh` and `.highway/tools/tests/relationship-integrity.test.sh`

### Implementation for User Story 4

- [X] T026 [US4] Update `.highway/library/templates/output/nfr-record.md` from version `1.0.0` to `2.0.0` and replace body placeholders with accepted NFR content
- [X] T027 [US4] Document direct-authored, accepted materially interpreted, and explicitly selected recommendation origins in `.highway/library/templates/output/nfr-record.md` without adding frontmatter fields
- [X] T028 [US4] Preserve identifier-only `controls`, atomic record/catalog/relationship mutation, duplicate/overlap handling, non-reuse, and destructive safeguards in `.highway/skills/highway-nfrs/SKILL.md`

**Checkpoint**: NFR records distinguish accepted content origin while preserving direct and Control-derived relationship semantics.

---

## Phase 7: User Story 5 - Simplify the runtime NFR skill contract (Priority: P2)

**Goal**: Remove duplicated generic and historical runtime prose while retaining concise NFR-specific workflow, verification, and exceptions.

**Independent Test**: Scan the canonical skill for version 11.0.0, the short workflow, NFR-specific exceptions, and absence of obsolete runtime material.

### Tests for User Story 5

- [X] T029 [P] [US5] Add version, short-workflow, shared-governance, obsolete-prose, verification, and error-exception assertions in `.highway/tools/tests/nfr-management.test.sh`
- [X] T030 [P] [US5] Add runtime skill validation and dependent-template citation assertions in `.highway/tools/tests/output-template.test.sh` and `.highway/tools/tests/validate-skill.test.sh`

### Implementation for User Story 5

- [X] T031 [US5] Rewrite the Experience, Inputs, Workflow, Verification, and Error Handling sections of `.highway/skills/highway-nfrs/SKILL.md` around NFR-specific semantics and shared-governance references
- [X] T032 [US5] Remove Feature 094, FR/SC, Security Gate, Maintainability Gate, per-step error mappings, post-write verification, duplicated interaction rules, repeated candidate schemas, and `Next Action first` wording from `.highway/skills/highway-nfrs/SKILL.md`
- [X] T033 [US5] Set `.highway/skills/highway-nfrs/SKILL.md` metadata version to `11.0.0` and preserve action selection, classification, relationship, catalog, and persistence safeguards

**Checkpoint**: The runtime skill is concise, NFR-specific, and delegates generic interaction and failure behavior to authoritative shared governance.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate distributed artifacts and validate the complete implementation.

- [X] T034 [P] Regenerate `.github/skills/highway-nfrs/SKILL.md`, `.claude/skills/highway-nfrs/SKILL.md`, `.cursor/skills/highway-nfrs/SKILL.md`, and `.agents/skills/highway-nfrs/SKILL.md` with `.highway/tools/generate-agent-adapters.sh`
- [X] T035 [P] Regenerate `.highway/catalog/library-index.json` and `.highway/catalog/library-index.md` with `.highway/tools/generate-library-catalog.sh`
- [X] T036 Validate `.highway/skills/highway-nfrs`, `.highway/library/templates/output/nfr-record.md`, and `.highway/catalog/nfr-candidate-state.md` with the applicable validators
- [X] T037 Run focused tests covering NFR management, onboarding, Control-derived NFRs, readiness, setup, templates, relationships, and generated catalogs
- [X] T038 Run the full suite with `.highway/tools/tests/run-all.sh` and resolve regressions without changing the approved NFR 11.0.0 or record-template 2.0.0 contracts
- [X] T039 Run the validation scenarios in `specs/109-nfr-skill-contract/quickstart.md` and verify generated outputs match canonical sources

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes current artifact and generator boundaries.
- **Foundational (Phase 2)**: Depends on Setup; establishes candidate-state authority and test expectations.
- **US1 (Phase 3)**: Depends on Foundational; establishes the candidate lifecycle used by later stories.
- **US2 (Phase 4)**: Depends on US1 because open discovery follows pending candidate resolution.
- **US3 (Phase 5)**: Depends on US1 and US2 because readiness/collection route across both candidate and open discovery.
- **US4 (Phase 6)**: Depends on US1 for accepted candidate relationships and on Foundational for template assertions.
- **US5 (Phase 7)**: Depends on US1-US4 because it consolidates the final runtime contract.
- **Polish (Phase 8)**: Depends on all canonical skill/template/test changes.

### User Story Dependencies

- **US1 (P1)**: Can begin after Phase 2; MVP candidate-state and recommendation ordering slice.
- **US2 (P1)**: Depends on US1; open discovery must begin after pending candidates are resolved.
- **US3 (P1)**: Depends on US1 and US2; readiness and collection must route both paths.
- **US4 (P1)**: Depends on US1 for Control-derived relationship persistence but can edit the template in parallel with US2.
- **US5 (P2)**: Depends on all prior stories because it removes and consolidates their superseded runtime prose.

### Parallel Opportunities

- T002 and T003 can run in parallel with T001.
- T005 and T006 can run in parallel after T004.
- T007/T008, T013/T014, T019/T020, T024/T025, and T029/T030 can each run in parallel within their story phase.
- T034 and T035 can run in parallel after canonical edits.
- T036 and T037 can run in parallel after regeneration.

## Parallel Example: Candidate and Record Contract Work

```text
Task: Add candidate-generation and exactly-once fixtures in .highway/tools/tests/control-derived-nfr.test.sh
Task: Add ordered candidate resume scenarios in .highway/tools/tests/highway-nfr-onboarding.test.sh
Task: Update NFR record template assertions in .highway/tools/tests/output-template.test.sh
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 and Phase 2.
2. Complete US1 candidate-state and pending-recommendation work.
3. Validate exactly-once generation, ordered decisions, and resume behavior independently.

### Incremental Delivery

1. Establish candidate-state authority and contract tests.
2. Deliver US1 Control-derived recommendation handling.
3. Add US2 open discovery and captured-NFR review.
4. Add US3 readiness/collection separation.
5. Add US4 record and relationship contract.
6. Consolidate US5 runtime prose and versioning.
7. Regenerate outputs and run focused then full validation.

## Notes

- All tasks use the required checkbox, sequential ID, optional `[P]` marker, story label where applicable, and exact repository path.
- Generated adapters and catalogs must be regenerated, not hand-edited.
- No task restores `Created Control IDs`, moves Controls-owned derivation into NFRs, adds a persisted classification field, or adds post-write verification.
