---

description: "Implementation tasks for the highway-new business request intake skill"
---

# Tasks: Business Request Intake

**Input**: Design documents from `specs/047-business-request-intake/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, and `quickstart.md`

**Tests**: Focused behavioral tests are included because the implementation plan and quickstart require validation of intake, privacy, transactions, determinism, and generated correspondence.

**Organization**: Tasks are grouped by the three P1 user stories so each increment has an independent test criterion.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the source, template, and test paths required by the implementation plan.

- [X] T001 Review `specs/047-business-request-intake/spec.md` and `specs/047-business-request-intake/plan.md`, then create `.highway/skills/highway-new/`, `.highway/library/templates/output/`, and the focused test path `.highway/tools/tests/highway-new.test.sh` without adding runtime dependencies.
- [X] T002 [P] Add the new skill and template paths to `.highway/tools/.distribution-manifest` so the source skill, request templates, and generated highway-new adapters are deliberately classified for packaging.
- [X] T003 [P] Add temporary-workspace setup and cleanup helpers to `.highway/tools/tests/highway-new.test.sh` using Bash 3.2-compatible syntax.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Define the shared artifact skeletons and validation fixtures required before story work.

**CRITICAL**: User story implementation depends on these output contracts and test helpers.

- [X] T004 Create the complete request record skeleton, including front matter, six evidence sections, and terminal completeness section, in `.highway/library/templates/output/request-record.md`.
- [X] T005 Create the complete request catalog skeleton, including version, next-ID field, and request index table, in `.highway/library/templates/output/request-catalog.md`.
- [X] T006 [P] Add valid, incomplete, invalid-identifier, and privacy-sensitive request fixtures to `.highway/tools/tests/fixtures/highway-new/` for focused behavioral checks.
- [X] T007 [P] Add assertions to `.highway/tools/tests/highway-new.test.sh` that request output remains outside `.highway`, excludes development-only references, and does not modify the shipped source tree.
- [X] T008 Run `.highway/tools/validate-library.sh` against `.highway/library/templates/output/request-record.md` and `.highway/library/templates/output/request-catalog.md`, then repair any template contract failures before story implementation.

**Checkpoint**: Shared output contracts and temporary test infrastructure are ready for the three independent story increments.

---

## Phase 3: User Story 1 - Start a Business Request (Priority: P1) 🎯 MVP

**Goal**: Accept an incomplete initial business description, read repository context only for examples, evaluate all six domains, and ask one question for the first incomplete domain.

**Independent Test**: Provide an initial description that satisfies some domains and verify that all six domains are evaluated, the first incomplete domain is selected in order, exactly one question is asked, and no artifact is created for empty input.

### Tests for User Story 1

- [X] T009 [US1] Add initial-input, empty-input, all-domain-evaluation, and first-incomplete-domain assertions to `.highway/tools/tests/highway-new.test.sh` before implementing the corresponding skill workflow.

### Implementation for User Story 1

- [X] T010 [US1] Author `name`, `description`, `usage`, compatibility, version, Purpose, When to use, When not to use, and Inputs in `.highway/skills/highway-new/SKILL.md`.
- [X] T011 [US1] Implement the numbered intake workflow in `.highway/skills/highway-new/SKILL.md` to accept incomplete initial context, read Profile/Objectives/Controls/NFRs only as example sources, evaluate all six domains, and ask exactly one question for the first incomplete domain.
- [X] T012 [US1] Add empty-input failure handling and the no-artifact guarantee to `.highway/skills/highway-new/SKILL.md` and cover the exact failure output in `.highway/tools/tests/highway-new.test.sh`.
- [X] T013 [US1] Add the US1 verification commands, output checks, and bounded failure actions to `.highway/skills/highway-new/SKILL.md`, then run `.highway/tools/validate-skill.sh .highway/skills/highway-new`.

**Checkpoint**: User Story 1 independently starts an intake conversation without creating a request for empty input.

---

## Phase 4: User Story 2 - Complete Evidence Conversationally (Priority: P1)

**Goal**: Collect exactly six evidence domains one response at a time, select the next incomplete domain deterministically, present one to three contextual examples, and keep examples/context separate from user evidence.

**Independent Test**: Walk through responses that complete the six domains in a non-sequential way and verify prescribed domain order, one question per turn, one to three examples, explicit completeness states, and privacy replacement prompts.

### Tests for User Story 2

- [X] T014 [US2] Add ordered-domain, one-question, example-count, example-precedence, incomplete-state, and privacy-exclusion assertions to `.highway/tools/tests/highway-new.test.sh` before implementing the evidence workflow.

### Implementation for User Story 2

- [X] T015 [US2] Add the six-domain evidence completeness predicates and `Complete`/`Incomplete` state rules to `.highway/skills/highway-new/SKILL.md`.
- [X] T016 [US2] Add the ordered question loop and re-evaluation-after-each-response behavior to `.highway/skills/highway-new/SKILL.md`, preserving the Problem, Actors, Current Process, Desired Change, Success Measure, Business Constraints order.
- [X] T017 [US2] Add contextual example generation to `.highway/skills/highway-new/SKILL.md` with the existing-evidence, Profile, Objectives, Controls, and NFR precedence order and one-to-three example limit.
- [X] T018 [US2] Add privacy screening, exclusion, replacement prompting, and non-promotion rules for secrets and regulated personal data to `.highway/skills/highway-new/SKILL.md`.
- [X] T019 [US2] Add the US2 Outputs and Verification sections to `.highway/skills/highway-new/SKILL.md`, citing the two shared output templates and proving that examples/context are not stored as user evidence.
- [X] T020 [US2] Run `.highway/tools/tests/highway-new.test.sh` and `.highway/tools/validate-skill.sh .highway/skills/highway-new`, repairing failures in the conversational slice before starting artifact generation.

**Checkpoint**: User Story 2 independently collects and evaluates all six evidence domains with deterministic examples and privacy behavior.

---

## Phase 5: User Story 3 - Produce a Durable Request Record (Priority: P1)

**Goal**: Generate a deterministic request record and catalog entry with authoritative identifiers, correct status/completeness, bootstrap behavior, and no partial writes.

**Independent Test**: Complete an intake in a temporary `requests/` workspace and verify one `REQXXXXXX` record, one catalog index entry, deterministic title, preserved catalog version, correct next ID, and unchanged bytes after a forced failure.

### Tests for User Story 3

- [X] T021 [US3] Add bootstrap, identifier grammar, title precedence, status, catalog authority, transaction ordering, catalog-conflict retry, and no-partial-write assertions to `.highway/tools/tests/highway-new.test.sh` before implementing artifact creation.

### Implementation for User Story 3

- [X] T022 [US3] Add deterministic title rules and request record rendering to `.highway/skills/highway-new/SKILL.md`, using an explicit requester title before Problem-derived generation.
- [X] T023 [US3] Add request catalog bootstrap and authoritative `REQ` plus six-digit allocation rules to `.highway/skills/highway-new/SKILL.md`, rejecting invalid catalog next-ID values and ignoring filenames.
- [X] T024 [US3] Add the ordered read, allocate, build request, build catalog, validate, and write transaction to `.highway/skills/highway-new/SKILL.md` with no-write preservation on any failure.
- [X] T025 [US3] Add exclusive catalog allocation retry behavior and the Version 1 `proposed` status rule to `.highway/skills/highway-new/SKILL.md`.
- [X] T026 [US3] Add the request record and catalog artifact assertions to `.highway/tools/tests/highway-new.test.sh`, including `requests/REQXXXXXX.md`, bootstrap `requests/REQ000001.md`, `requests/requests.md`, six evidence sections, completeness, catalog index, preserved version, and next-ID advancement.
- [X] T027 [US3] Add the US3 Error Handling and Verification sections to `.highway/skills/highway-new/SKILL.md`, including allocation failures, validation failures, transaction failures, and exact output file checks.
- [X] T028 [US3] Run `.highway/tools/validate-skill.sh .highway/skills/highway-new`, `.highway/tools/validate-library.sh .highway/library/templates/output/request-record.md`, and `.highway/tools/validate-library.sh .highway/library/templates/output/request-catalog.md` before regeneration.

**Checkpoint**: User Story 3 independently creates durable request and catalog artifacts or leaves every existing artifact byte-for-byte unchanged on failure.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate derived artifacts, verify distribution correspondence, and record final feature validation.

- [X] T029 [P] Regenerate `.highway/catalog/library-index.json` and `.highway/catalog/library-index.md` with `.highway/tools/generate-library-catalog.sh` after the shared templates are valid.
- [X] T030 [P] Regenerate `.highway/catalog/index.json` and `.highway/catalog/index.md` with `.highway/tools/generate-catalog.sh` after `highway-new/SKILL.md` is valid.
- [X] T031 [P] Regenerate `.github/skills/highway-new/SKILL.md`, `.claude/skills/highway-new/SKILL.md`, and `.cursor/rules/highway-new.mdc` with `.highway/tools/generate-agent-adapters.sh`.
- [X] T032 Run `.highway/tools/tests/highway-new.test.sh` and confirm the focused behavior scenarios pass without creating repository-owned `requests/` fixtures.
- [X] T033 Run `.highway/tools/tests/adapter-coverage.test.sh` and `.highway/tools/tests/distribution-packaging.test.sh`, resolving Feature 047 correspondence or classification failures while preserving unrelated baseline diagnostics.
- [X] T034 Update `.highway/tools/README.md` and any affected authoring documentation to describe the request output templates and regeneration dependencies introduced by Feature 047.
- [X] T035 Run `.highway/tools/tests/run-all.sh` and record whether the two baseline failures remain unchanged or whether any new failure is attributable to Feature 047.
- [X] T036 Run every command in `specs/047-business-request-intake/quickstart.md` and verify the generated source, templates, `.highway/catalog/` catalog, catalog/adapters, generated adapters, focused test, and distribution checks agree.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; T001-T003 establish paths and packaging classification.
- **Foundational (Phase 2)**: Depends on Setup; T004-T008 define and validate shared templates and test infrastructure.
- **User Story 1 (Phase 3)**: Depends on Foundational; delivers the MVP intake entry point.
- **User Story 2 (Phase 4)**: Depends on US1's source skill and focused test harness; extends the same workflow with evidence collection and privacy.
- **User Story 3 (Phase 5)**: Depends on US2's completeness model and shared templates; adds durable artifact creation and transaction behavior.
- **Polish (Phase 6)**: Depends on all desired stories; generated outputs must follow the final valid source and templates.

### User Story Dependencies

- **US1**: Depends on Phase 2 only; independently testable as the MVP.
- **US2**: Depends on US1 because it extends the same `SKILL.md` workflow, but its evidence loop is independently testable with the US1 intake precondition.
- **US3**: Depends on US2 because artifact completeness and privacy rules consume the evidence model; its temporary-workspace artifact test is independently testable after that foundation.

### Within Each User Story

- Write the story's focused assertions before the corresponding implementation tasks.
- Complete source workflow behavior before running the story checkpoint validation.
- Run the story validator and focused test before beginning the next story.
- Regenerate catalog and adapters only after all source and template edits are complete.

## Parallel Opportunities

- T002, T003, and T006-T007 can proceed in parallel after the paths are created because they touch separate manifests, fixtures, and test helper regions.
- T004 and T005 can proceed in parallel because they create separate shared template files.
- T029, T030, and T031 can proceed in parallel only after all source and template changes are complete; each writes a distinct generated artifact family.
- T032-T033 can proceed in parallel after regeneration because focused behavior and correspondence/package checks use separate test paths.

## Parallel Example: Foundation and Polish

```bash
# After T001 establishes the directories:
Task: "Create request record template in .highway/library/templates/output/request-record.md"
Task: "Create request catalog template in .highway/library/templates/output/request-catalog.md"
Task: "Add temporary request-workspace helpers in .highway/tools/tests/highway-new.test.sh"

# After T028 validates the final source and templates:
Task: "Generate library catalog with .highway/tools/generate-library-catalog.sh"
Task: "Generate skill catalog with .highway/tools/generate-catalog.sh"
Task: "Generate GitHub Copilot, Claude Code, and Cursor adapters with .highway/tools/generate-agent-adapters.sh"
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 Setup and Phase 2 Foundational tasks.
2. Complete Phase 3 User Story 1.
3. Run the US1 focused test and source validator.
4. Stop for an independently testable intake MVP before adding artifact persistence.

### Incremental Delivery

1. Add US1 initial intake and first-incomplete-domain selection.
2. Add US2 six-domain conversational evidence, examples, completeness, and privacy.
3. Add US3 deterministic title, catalog allocation, transaction, and durable artifacts.
4. Regenerate all derived outputs and run the full quickstart and suite.

## Completion Criteria

- All tasks are checked only after their named file changes and validation command complete.
- Every task follows `- [ ] T###`, optional `[P]`, optional story label, and an exact file path.
- Each user story has a goal, independent test criterion, focused test tasks, implementation tasks, and checkpoint.
- Final reporting includes total task count, story counts, parallel opportunities, independent tests, MVP scope, and the baseline comparison.
