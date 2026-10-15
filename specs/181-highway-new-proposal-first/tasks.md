---

description: "Task list for Highway New proposal-first Request development"
---

# Tasks: Highway New Proposal-First Request Development

**Input**: Design documents from `specs/181-highway-new-proposal-first/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, `quickstart.md`

**Tests**: Required by the specification for proposal triggering, evidence reuse, contribution and acceptance boundaries, no-write behavior, and preserved Request/Discovery contracts.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the canonical source, test, fixture, and generated-artifact surfaces.

- [X] T001 Confirm Feature 181 prerequisites, completed checklist, plan, research, data model, contract, and quickstart in `specs/181-highway-new-proposal-first/`
- [X] T002 [P] Inspect canonical `highway-new`, Request templates, focused tests, fixtures, generated adapters, catalog entries, and manifests in `.highway/`, `.github/`, `.claude/`, `.cursor/`, and `.agents/`
- [X] T003 [P] Run `bash .highway/tools/tests/run-all.sh` and record the passing baseline before implementation

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish failing contract coverage and preserve existing Request ownership before story implementation.

- [X] T004 Add Feature 181 source-document contract assertions to `.highway/tools/tests/highway-new.test.sh`
- [X] T005 Add proposal-first disposable fixtures under `.highway/tools/tests/fixtures/highway-new/` for grounded evidence, refinement, convergence, and incomplete evidence
- [X] T006 Add failing assertions for Response Support Text, Contribution Opportunity wording, and no-acceptance behavior to `.highway/tools/tests/highway-new.test.sh`
- [X] T007 Add failing assertions for evidence reuse, `Unknown` preservation, and consequential-missing-question behavior to `.highway/tools/tests/highway-new.test.sh`
- [X] T008 Add failing assertions for Request acceptance, seven-domain completeness, no-write behavior, Discovery/ADR boundaries, and existing Solution Constraint rules to `.highway/tools/tests/highway-new.test.sh`
- [X] T009 Run `bash .highway/tools/tests/highway-new.test.sh` and `bash .highway/tools/tests/output-template.test.sh` before canonical skill changes and record the expected Feature 181 failures

**Checkpoint**: Foundational tests fail on the new contract while existing Request/template behavior remains covered.

## Phase 3: User Story 1 - Review a Proposed Request Starting Point (Priority: P1) MVP

**Goal**: Present a grounded Request Discovery Contribution Opportunity before unnecessary questionnaire-first prompts.

**Independent Test**: A grounded initial Request description produces the exact starting-point prompt, provisional Request understanding, correction-oriented closing question, and no acceptance or persistence request.

### Tests for User Story 1

- [X] T010 [P] [US1] Add grounded initial-evidence fixture assertions for the Request Discovery Contribution Opportunity in `.highway/tools/tests/highway-new.test.sh`
- [X] T011 [P] [US1] Add no-grounded-interpretation assertions for one consequential missing-evidence question and no invented proposal in `.highway/tools/tests/highway-new.test.sh`
- [X] T012 [P] [US1] Add Response Support Text and emphasis assertions for validation, discovery, combined, suggestions, and Request Proposal reassurance in `.highway/tools/tests/highway-new.test.sh`

### Implementation for User Story 1

- [X] T013 [US1] Add the canonical Response Support Text section and exact validation/reassurance wording to `.highway/skills/highway-new/SKILL.md`
- [X] T014 [US1] Add the Request Discovery Contribution Opportunity contract, trigger, provisional Working Idea boundary, and exact opening/closing text to `.highway/skills/highway-new/SKILL.md`
- [X] T015 [US1] Replace questionnaire-first intake guidance with proposal-first initial evidence evaluation while preserving the seven-domain list in `.highway/skills/highway-new/SKILL.md`
- [X] T016 [US1] Define grounded interpretation, `Unknown` handling, no-acceptance behavior, and no-write behavior for the initial opportunity in `.highway/skills/highway-new/SKILL.md`

**Checkpoint**: User Story 1 presents a useful proposal-first starting point without creating or accepting a Request.

## Phase 4: User Story 2 - Refine the Request and Collect Only Missing Evidence (Priority: P1)

**Goal**: Reuse known evidence, reflect substantive corrections, and ask only consequential missing-evidence questions.

**Independent Test**: A substantive correction changes the active proposal, known evidence is not requested again, and the next question targets only unresolved evidence.

### Tests for User Story 2

- [X] T017 [P] [US2] Add multi-turn refinement fixtures and assertions for additions, corrections, removals, combinations, narrowings, and qualifications in `.highway/tools/tests/highway-new.test.sh`
- [X] T018 [P] [US2] Add evidence-reuse assertions proving already represented domains are not asked again in `.highway/tools/tests/highway-new.test.sh`
- [X] T019 [P] [US2] Add `Unknown`, privacy filtering, pause/cancel, and stop-response refinement assertions in `.highway/tools/tests/highway-new.test.sh`

### Implementation for User Story 2

- [X] T020 [US2] Add Request Proposal Refinement and Request Development Lifecycle sections to `.highway/skills/highway-new/SKILL.md`
- [X] T021 [US2] Add substantive-contribution re-evaluation and accepted-evidence reuse rules to `.highway/skills/highway-new/SKILL.md`
- [X] T022 [US2] Define consequential missing-evidence collection after a proposal and preserve one-question-at-a-time behavior in `.highway/skills/highway-new/SKILL.md`
- [X] T023 [US2] Preserve all eight Solution Constraint fields, valid shapes, `unknown`/empty distinctions, and field-specific recovery behavior in `.highway/skills/highway-new/SKILL.md`

**Checkpoint**: User Stories 1 and 2 support proposal review and refinement without repeated questions or invented evidence.

## Phase 5: User Story 3 - Accept a Converged Proposal and Create the Request (Priority: P1)

**Goal**: Establish the Converged Request Proposal review and preserve the existing creation boundary.

**Independent Test**: A complete proposal appears under the required heading, acceptance is requested only at the boundary, and creation occurs only after completeness and persistence validation.

### Tests for User Story 3

- [X] T024 [P] [US3] Add complete Converged Request Proposal fixture assertions for all eight review fields and required heading in `.highway/tools/tests/highway-new.test.sh`
- [X] T025 [P] [US3] Add acceptance-versus-contribution assertions proving draft approval, explanation requests, and partial responses do not create a Request in `.highway/tools/tests/highway-new.test.sh`
- [X] T026 [P] [US3] Add successful acceptance, incomplete evidence, allocation failure, validation failure, and write failure assertions in `.highway/tools/tests/highway-new.test.sh`

### Implementation for User Story 3

- [X] T027 [US3] Add the Converged Request Proposal contract and exact review format to `.highway/skills/highway-new/SKILL.md`
- [X] T028 [US3] Add the Request Development Lifecycle, acceptance boundary, and evidence completeness ordering to `.highway/skills/highway-new/SKILL.md`
- [X] T029 [US3] Preserve existing Request record/catalog ownership, allocation, validation, retry, privacy, and no-write creation behavior in `.highway/skills/highway-new/SKILL.md`
- [X] T030 [US3] Add post-creation synthesis and `/highway-discovery REQXXXXXX` handoff guidance to `.highway/skills/highway-new/SKILL.md`

**Checkpoint**: User Story 3 creates Requests only through the existing owner-controlled acceptance and persistence boundary.

## Phase 6: User Story 4 - Preserve Request Ownership and Downstream Boundaries (Priority: P1)

**Goal**: Preserve Request, Discovery, and ADR ownership while improving intake interaction.

**Independent Test**: Proposal, refinement, acceptance, and out-of-scope requests leave downstream artifacts and ownership boundaries unchanged.

### Tests for User Story 4

- [X] T031 [P] [US4] Add assertions that proposal and refinement create no Request, Discovery, ADR, identifier, or substitute artifact in `.highway/tools/tests/highway-new.test.sh`
- [X] T032 [P] [US4] Add assertions that Discovery, architecture, implementation, Control, NFR, and relationship requests route without downstream mutation in `.highway/tools/tests/highway-new.test.sh`

### Implementation for User Story 4

- [X] T033 [US4] Add explicit Request ownership, Working Idea, Contribution Opportunity, Converged Proposal, and downstream boundary language to `.highway/skills/highway-new/SKILL.md`
- [X] T034 [US4] Preserve the existing Discovery candidate-space handoff and ADR selection boundary in `.highway/skills/highway-new/SKILL.md`

**Checkpoint**: All four user stories preserve the established Request/Discovery/ADR ownership model.

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Validate, regenerate, and verify the complete Feature 181 contract.

- [X] T035 Update `.highway/tools/tests/output-template.test.sh` only if new shared Request-template tokens are introduced
- [X] T036 Validate `.highway/skills/highway-new`, `.highway/library/templates/output/request-record.md`, and `.highway/library/templates/output/request-catalog.md` with canonical validators
- [X] T037 Regenerate `.highway/catalog/`, `.highway/catalog/library-index.*`, `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, `.agents/skills/`, and `.highway/tools/.adapter-manifest` from canonical sources
- [X] T038 Verify every generated `highway-new` adapter matches `.highway/skills/highway-new/SKILL.md` byte-for-byte
- [X] T039 Run focused tests and all Feature 181 quickstart scenarios from `specs/181-highway-new-proposal-first/quickstart.md`
- [X] T040 Run `.highway/tools/tests/run-all.sh` and resolve only Feature 181 regressions
- [X] T041 Verify `git diff --check`, no design placeholders, no upstream Request/Discovery/ADR bytes changed, and no generated drift remains
- [X] T042 Confirm task-to-requirement coverage against `spec.md`, `plan.md`, `data-model.md`, and `contracts/highway-new-proposal-first.md`

## Dependencies & Execution Order

- Setup T001-T003 precedes foundational work.
- Foundational T004-T009 must pass before user-story source edits.
- US1 T010-T016 establishes the proposal-first MVP.
- US2 T017-T023 depends on US1 interaction vocabulary and extends it with refinement/evidence reuse.
- US3 T024-T030 depends on US1/US2 and adds convergence, acceptance, and completion behavior.
- US4 T031-T034 verifies ownership boundaries after the story behaviors exist.
- Polish T035-T042 follows all story checkpoints and regeneration prerequisites.

## Parallel Opportunities

- T002 and T003 can run in parallel.
- T004-T008 can be developed as independent test sections before implementation.
- T010-T012, T017-T019, T024-T026, and T031-T032 can run in parallel within their story phases.
- T035 and T036 can run in parallel after source edits.
- T037 must precede T038; T039 and T040 run after regeneration.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup T001-T003.
2. Complete Foundational T004-T009 and observe the expected failures.
3. Complete User Story 1 T010-T016.
4. Validate the focused `highway-new` contract independently.
5. Continue with User Stories 2-4 to preserve the complete acceptance and ownership contract.

### Incremental Delivery

1. Add proposal-first starting-point behavior.
2. Add refinement and evidence reuse.
3. Add Converged Proposal acceptance and completion handoff.
4. Verify Request/Discovery/ADR ownership boundaries.
5. Regenerate derived artifacts and run focused plus full validation.
