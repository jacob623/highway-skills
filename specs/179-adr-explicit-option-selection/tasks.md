---

description: "Implementation tasks for explicit user-owned ADR option selection"
---

# Tasks: Explicit ADR Option Selection

**Input**: Design documents from `specs/179-adr-explicit-option-selection/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/adr-explicit-selection.md`, `quickstart.md`

**Tests**: Focused contract tests are required because this feature changes invocation grammar, decision ownership, failure mutation behavior, and shared output wording.

## Phase 1: Setup

- [x] T001 Verify Feature 179 plan, research, data model, contract, quickstart, and checklist are complete and placeholder-free
- [x] T002 [P] Inspect canonical ADR skill, ADR record/catalog templates, ADR tests, output-template tests, and generated adapter correspondence
- [x] T003 [P] Confirm Feature 075/076 ADR ownership, catalog allocation, accepted status, and source-preservation behavior remain the baseline

## Phase 2: Foundational Contract Tests

- [x] T004 Add explicit-selection fixture helpers and exact identifier cases to `.highway/tools/tests/highway-adr.test.sh`
- [x] T005 Add failing assertions for one Discovery plus one option invocation and rejection of missing, duplicate, malformed, and cross-Discovery options in `.highway/tools/tests/highway-adr.test.sh`
- [x] T006 Add failing assertions for the missing-option prompt, all-option summaries, advisory recommendation, and no-allocation/no-write behavior in `.highway/tools/tests/highway-adr.test.sh`
- [x] T007 Add failing assertions that automatic recommendation, score, architecture-match, and lower-identifier selection language is absent from the ADR decision contract
- [x] T008 Run the focused ADR and output-template tests before source changes and record the expected failures

**Checkpoint**: Contract tests define explicit selection and no-write behavior before implementation edits.

## Phase 3: User Story 1 - Make an Explicit Architecture Decision (Priority: P1)

**Goal**: Require and retain the user's explicit option selection while preserving existing ADR output and ownership.

**Independent Test**: Inspect the canonical skill/template and run the focused ADR test with a valid Discovery and option; verify `Selected Option` is user-provided and all existing ADR sections remain required.

- [x] T009 [US1] Change the canonical invocation usage and Inputs in `.highway/skills/highway-adr/SKILL.md` to require exactly one `DISC######` and one `OPT######` for ADR creation
- [x] T010 [US1] Replace automatic option-selection behavior in the decision contract and workflow of `.highway/skills/highway-adr/SKILL.md` with explicit user-owned selection
- [x] T011 [US1] Add selected-option ownership and rationale wording to `.highway/library/templates/output/adr-record.md`
- [x] T012 [US1] Add explicit-selection, recommendation-divergence, and retained-record assertions to `.highway/tools/tests/highway-adr.test.sh`
- [x] T013 [US1] Run the focused ADR contract and existing ADR onboarding checks

**Checkpoint**: Valid explicit selection independently produces the existing ADR decision shape without inferred selection.

## Phase 4: User Story 2 - Choose from Discovery Options (Priority: P1)

**Goal**: Present a useful missing-option decision prompt without allocating or writing anything.

**Independent Test**: Exercise a valid Discovery with one and multiple options without an option argument; verify the prompt content and byte-preserving no-write behavior.

- [x] T014 [US2] Add the exact `Architecture Decision Required` missing-option prompt and no-write contract to `.highway/skills/highway-adr/SKILL.md`
- [x] T015 [US2] Add prompt structure and scalar no-allocation examples to `.highway/library/templates/output/adr-record.md` or the canonical ADR output contract where appropriate
- [x] T016 [US2] Add one-option, multiple-option, all-summary, recommendation-advisory, and no-catalog-write assertions to `.highway/tools/tests/highway-adr.test.sh`
- [x] T017 [US2] Run the focused missing-option tests and verify no identifier allocation occurs before the prompt

**Checkpoint**: The missing-option path is independently useful and cannot create an ADR.

## Phase 5: User Story 3 - Reject Invalid or Ambiguous Decisions (Priority: P1)

**Goal**: Reject unsupported or ambiguous invocations before any ADR or catalog mutation.

**Independent Test**: Exercise malformed, duplicate, unknown, cross-Discovery, unavailable, and non-accepted inputs and compare all pre-operation bytes.

- [x] T018 [US3] Add selected-option membership validation and exact abort/no-write wording to `.highway/skills/highway-adr/SKILL.md`
- [x] T019 [US3] Preserve and clarify existing accepted-Discovery, catalog uniqueness, allocation conflict, atomic publication, and source-byte failure contracts in `.highway/skills/highway-adr/SKILL.md`
- [x] T020 [US3] Add unsupported-option and ambiguous-input fixture assertions to `.highway/tools/tests/highway-adr.test.sh`
- [x] T021 [US3] Add no-write byte comparison coverage for invalid option and missing-option paths to `.highway/tools/tests/highway-adr.test.sh`
- [x] T022 [US3] Run focused invalid-input and no-partial-write checks

**Checkpoint**: Every invalid or unsupported selection stops before allocation and publication.

## Phase 6: User Story 4 - Preserve Advisory Discovery Guidance (Priority: P2)

**Goal**: Keep Discovery recommendations, rationale, scores, and comparison evidence advisory and unchanged.

**Independent Test**: Verify the canonical ADR skill continues to name Discovery-owned recommendation outputs while no ADR rule can use them for automatic selection.

- [x] T023 [US4] State Discovery ownership of candidate generation, scoring, comparison, recommendation, and rationale while stating ADR ownership of selection in `.highway/skills/highway-adr/SKILL.md`
- [x] T024 [US4] Add advisory-vs-decision ownership and recommendation-divergence assertions to `.highway/tools/tests/highway-adr.test.sh`
- [x] T025 [US4] Confirm the shared ADR template records the explicit selected option without changing Discovery recommendation fields in `.highway/library/templates/output/adr-record.md`
- [x] T026 [US4] Run focused recommendation-preservation and generated-source checks

**Checkpoint**: Discovery remains advisory and ADR records explicit user choice, including when it differs from the recommendation.

## Phase 7: Cross-Cutting Validation and Regeneration

- [x] T027 Update `.highway/tools/tests/output-template.test.sh` for any changed ADR shared-template citation or complete-output assertions
- [x] T028 Validate `.highway/skills/highway-adr` and `.highway/library/templates/output/adr-record.md` with canonical validators
- [x] T029 Regenerate `.highway/catalog/`, `.highway/catalog/library-index.*`, `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, and `.agents/skills/`
- [x] T030 Run `.highway/tools/tests/highway-adr.test.sh`, output-template checks, adapter correspondence, and all Feature 179 quickstart scenarios
- [x] T031 Run `.highway/tools/tests/run-all.sh` and resolve any Feature 179 regressions without weakening unrelated tests
- [x] T032 Verify `git diff --check`, no unresolved placeholders, generated adapters match the canonical ADR source, and all upstream Discovery bytes remain untouched
- [x] T033 Mark this task list complete after final focused and full-suite validation

## Dependencies and Execution Order

- Setup precedes foundational tests.
- Foundational tests T004-T008 precede all source or template implementation edits.
- US1 establishes explicit selection before US2 and US3 refine missing and invalid paths.
- US2 and US3 can proceed independently after US1, but shared skill/template edits should be coordinated sequentially.
- US4 depends on the ownership language introduced by US1 and must pass before regeneration.
- Cross-cutting validation begins after all story checkpoints pass.

## Parallel Opportunities

- T002 and T003 can run in parallel.
- T004, T005, and T007 can be developed in separate test sections before implementation.
- T027 and T028 can run in parallel after source/template edits.
- T029 and focused tests can run sequentially because generators validate source inputs first; T030 and T031 can run in parallel after regeneration.

## Implementation Strategy

1. Establish failing explicit-selection and no-write contract assertions.
2. Change canonical ADR invocation and decision ownership.
3. Add the missing-option prompt and membership rejection behavior.
4. Preserve Discovery advisory evidence and update shared output assertions.
5. Validate, regenerate, run focused checks, then run the full suite.
