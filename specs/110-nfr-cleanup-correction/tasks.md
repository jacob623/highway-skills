---
description: "Task list for feature implementation"
---

# Tasks: Final NFR Contract Cleanup

**Input**: Design documents from `/specs/110-nfr-cleanup-correction/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, and `quickstart.md`

**Tests**: Included because the specification explicitly requires exact contract verification and a passing full suite.

## Phase 1: Setup

**Purpose**: Confirm the canonical NFR and generated-artifact boundaries before editing.

- [X] T001 Inventory current NFR review, candidate-state, readiness, collection-result, and record-template assertions in `.highway/tools/tests/`.
- [X] T002 [P] Confirm generator commands and derived output paths in `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-library-catalog.sh`, `.highway/tools/generate-catalog.sh`, and `.highway/tools/generate-instructions.sh`.
- [X] T003 [P] Confirm the active feature documents and Constitution/Experience Standard references in `specs/110-nfr-cleanup-correction/plan.md` and `.highway/governance/constitution.md`.

---

## Phase 2: Foundational

**Purpose**: Establish the exact contract fixtures and ensure the existing record structure remains protected.

- [X] T004 Add the exact captured-NFR review, direct-capture boundary, candidate-state wording, and forbidden-legacy assertions to `.highway/tools/tests/nfr-management.test.sh`.
- [X] T005 [P] Add review-formatting, direct-capture, recommendation-ordering, and fallback-question assertions to `.highway/tools/tests/highway-nfr-onboarding.test.sh`.
- [X] T006 [P] Add version, unchanged-frontmatter, accepted-placeholder, and no-grounding-field assertions to `.highway/tools/tests/output-template.test.sh`.
- [X] T007 [P] Add candidate-state ownership, relationship boundary, and no-duplicated-grounding assertions to `.highway/tools/tests/control-derived-nfr.test.sh`.

**Checkpoint**: Focused assertions describe the requested cleanup and fail against any regression to the old contract.

---

## Phase 3: User Story 1 - Capture NFRs without redundant review (Priority: P1) 🎯 MVP

**Goal**: Correct the captured-NFR review shape and distinguish direct/selected capture from materially interpreted review.

**Independent Test**: Run `nfr-management.test.sh`, `highway-nfr-onboarding.test.sh`, and `output-template.test.sh`; verify exact labels and acceptance placement.

### Tests for User Story 1

- [X] T008 [P] [US1] Add a fixture assertion for the exact multiline captured-NFR review in `.highway/tools/tests/highway-nfr-onboarding.test.sh`.
- [X] T009 [P] [US1] Add a negative assertion that direct capture skips inferred-content review but retains validation/persistence safeguards in `.highway/tools/tests/nfr-management.test.sh`.

### Implementation for User Story 1

- [X] T010 [US1] Update the Discovery and recommendations section in `.highway/skills/highway-nfrs/SKILL.md` with the exact captured-NFR review formatting.
- [X] T011 [US1] Add the direct-capture validation sentence immediately after the direct-capture rule in `.highway/skills/highway-nfrs/SKILL.md`.
- [X] T012 [US1] Ensure `.highway/skills/highway-nfrs/SKILL.md` states that explicit recommendation selections and direct NFR statements do not receive redundant review.
- [X] T013 [US1] Preserve synthesized Rationale and transient NFR-versus-Control classification language in `.highway/skills/highway-nfrs/SKILL.md` without adding a rationale question.

**Checkpoint**: Direct and selected inputs bypass redundant review; materially interpreted user-authored input uses the exact review contract.

---

## Phase 4: User Story 2 - Preserve ordered durable candidate handling (Priority: P1)

**Goal**: Clarify persisted candidate-state ownership and retain ordering ahead of contextual recommendations and broad discovery.

**Independent Test**: Run candidate onboarding and Control-derived NFR tests; inspect the skill and candidate-state document for ordering, resume, and ownership boundaries.

### Tests for User Story 2

- [X] T014 [P] [US2] Add assertions for pending-candidate precedence, exact fallback discovery wording, and no separate rationale question in `.highway/tools/tests/highway-nfr-onboarding.test.sh`.
- [X] T015 [P] [US2] Add assertions that candidate state is limited to originating Control, ordered content, decisions, resume, and readiness in `.highway/tools/tests/control-derived-nfr.test.sh`.

### Implementation for User Story 2

- [X] T016 [US2] Change the candidate-state description in `.highway/skills/highway-nfrs/SKILL.md` to `authoritative persisted NFR-owned recovery state`.
- [X] T017 [US2] Remove the sentence claiming a separate candidate-state schema is defined elsewhere from `.highway/skills/highway-nfrs/SKILL.md`.
- [X] T018 [US2] Remove obsolete `Created Control IDs` wording from `.highway/catalog/nfr-candidate-state.md` while preserving its durable state limits and resume semantics.
- [X] T019 [US2] Preserve candidate ordering, recommendation acceptance, contextual recommendation timing, exact fallback question, concise examples, and synthesized Rationale in `.highway/skills/highway-nfrs/SKILL.md`.

**Checkpoint**: Pending Control-derived candidates are ordered, durable, resumable, and resolved before open discovery.

---

## Phase 5: User Story 3 - Preserve NFR record and relationship semantics (Priority: P1)

**Goal**: Keep `nfr-record.md` structurally unchanged while preserving direct and Control-derived relationship boundaries.

**Independent Test**: Run `output-template.test.sh`, `control-derived-nfr.test.sh`, and `relationship-integrity.test.sh`.

### Tests for User Story 3

- [X] T020 [P] [US3] Verify `nfr-record.md` remains version `2.0.0` with unchanged `id`, `title`, `status`, and `controls` frontmatter in `.highway/tools/tests/output-template.test.sh`.
- [X] T021 [P] [US3] Verify direct `controls: []`, immutable `CTLXXXXXX` relationships, and absence of copied Recommendation Grounding in `.highway/tools/tests/control-derived-nfr.test.sh`.

### Implementation for User Story 3

- [X] T022 [US3] Review `.highway/library/templates/output/nfr-record.md` against the requested unchanged 2.0.0 structure and make no unrelated structural edits.
- [X] T023 [US3] Ensure `.highway/skills/highway-nfrs/SKILL.md` explicitly preserves identifier-only Control relationships and excludes copied Recommendation Grounding.
- [X] T024 [US3] Keep the NFR template origin guidance limited to direct authored content, accepted materially interpreted content, and explicitly selected recommendations.

**Checkpoint**: The record template and relationship semantics remain unchanged and independently validated.

---

## Phase 6: User Story 4 - Keep owner results and safeguards concise (Priority: P2)

**Goal**: Preserve readiness/collection separation and the short NFR-specific workflow, verification, and error boundary.

**Independent Test**: Run readiness, setup-loop, NFR management, and full-suite checks.

### Tests for User Story 4

- [X] T025 [P] [US4] Verify readiness meanings, four-field collection result, explicit finish, and no created-NFR-ID list in `.highway/tools/tests/readiness-owner-states.test.sh` and `.highway/tools/tests/setup-owner-loop-contract.test.sh`.
- [X] T026 [P] [US4] Verify the short workflow and NFR-specific Error Handling contain no restored generic governance prose in `.highway/tools/tests/nfr-management.test.sh`.

### Implementation for User Story 4

- [X] T027 [US4] Preserve readiness, collection-result, persistence, relationship, and destructive-safeguard sections in `.highway/skills/highway-nfrs/SKILL.md` without post-write verification.
- [X] T028 [US4] Preserve the current short Workflow and NFR-specific Error Handling in `.highway/skills/highway-nfrs/SKILL.md` while removing only obsolete cleanup material.
- [X] T029 [US4] Keep `.highway/library/templates/output/nfr-record.md` unchanged after validation and document that no additional structure is required.

**Checkpoint**: Owner results and safeguards remain complete, concise, and separated from generic governance rules.

---

## Phase 7: Polish and Cross-Cutting Validation

**Purpose**: Regenerate outputs, validate all canonical artifacts, and run the complete suite.

- [X] T030 [P] Regenerate `.github/skills/highway-nfrs/SKILL.md`, `.claude/skills/highway-nfrs/SKILL.md`, `.cursor/skills/highway-nfrs/SKILL.md`, and `.agents/skills/highway-nfrs/SKILL.md` with `.highway/tools/generate-agent-adapters.sh`.
- [X] T031 [P] Regenerate `.highway/catalog/library-index.json` and `.highway/catalog/library-index.md` with `.highway/tools/generate-library-catalog.sh`.
- [X] T032 [P] Regenerate `.highway/catalog/index.json`, `.highway/catalog/index.md`, and instruction outputs with the declared generators.
- [X] T033 Validate `.highway/skills/highway-nfrs`, `.highway/library/templates/output/nfr-record.md`, and `.highway/catalog/nfr-candidate-state.md` with the applicable validators.
- [X] T034 Run the focused tests in `specs/110-nfr-cleanup-correction/quickstart.md` and verify generated outputs match canonical sources.
- [X] T035 Run `.highway/tools/tests/run-all.sh` with the required filesystem access and resolve any regressions without changing the approved versions.
- [X] T036 Run `ReadLints` on all changed canonical, test, generated, and feature-document paths; fix any introduced diagnostics.

---

## Dependencies and Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup and blocks all user stories.
- **US1 (Phase 3)**: Depends on Foundational; MVP slice.
- **US2 (Phase 4)**: Depends on Foundational and coordinates with US1's discovery assertions.
- **US3 (Phase 5)**: Depends on Foundational; can proceed in parallel with US1 and US2 because the record template remains unchanged.
- **US4 (Phase 6)**: Depends on Foundational and the contract decisions from US1/US2.
- **Polish (Phase 7)**: Depends on all story implementation and test tasks.

### User Story Dependencies

- **US1 (P1)**: Independent after Foundational; recommended MVP.
- **US2 (P1)**: Independent after Foundational; shares the NFR skill file with US1, so sequential edits are required.
- **US3 (P1)**: Independent after Foundational; template checks can run in parallel with skill edits.
- **US4 (P2)**: Depends on the preserved result and workflow contracts from US1-US3.

### Parallel Opportunities

- T002-T003 can run in parallel.
- T005-T007 can run in parallel after T004.
- T008-T009, T014-T015, T020-T021, and T025-T026 can run in parallel within their story phases.
- T030-T032 can run in parallel after canonical edits.
- T033-T034 can run in parallel after regeneration.

## Parallel Example: Contract Verification

```text
Task: Add exact captured-NFR review assertions in .highway/tools/tests/highway-nfr-onboarding.test.sh
Task: Add direct-capture safeguard assertions in .highway/tools/tests/nfr-management.test.sh
Task: Add unchanged NFR record assertions in .highway/tools/tests/output-template.test.sh
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Complete US1's review and direct-capture corrections.
3. Run US1 focused tests and validators.
4. Stop for independent review before continuing with candidate-state and cross-cutting cleanup.

### Incremental Delivery

1. Deliver US1 review/direct-capture behavior.
2. Deliver US2 candidate-state wording and ordering safeguards.
3. Validate US3's unchanged record/relationship boundary.
4. Deliver US4 readiness, collection, and safeguard preservation.
5. Regenerate derived outputs and run the full suite.

## Notes

- Every task uses the required checkbox, sequential ID, optional `[P]` marker, story label where required, and exact repository path.
- Generated adapters and catalogs must be regenerated, not hand-edited.
- No task changes `highway-nfrs` from 11.0.0 or `nfr-record.md` from 2.0.0.
- No task adds Recommendation Grounding or external-framework lineage to NFR records.
