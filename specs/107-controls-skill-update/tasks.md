---
description: "Implementation tasks for the Controls Skill Update"
---

# Tasks: Controls Skill Update

**Input**: Design documents from `/specs/107-controls-skill-update/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, and `quickstart.md`

**Tests**: Contract and executable test updates are included because the specification requires verification of the changed runtime contracts.

## Phase 1: Setup

- [X] T001 Confirm the active feature paths and baseline test command from `specs/107-controls-skill-update/plan.md`
- [X] T002 [P] Inventory every shipped and generated file that cites `highway-controls` or `control-record.md` using `.highway/tools/tests/` contract helpers
- [X] T003 [P] Capture the pre-change focused and full-suite results in `specs/107-controls-skill-update/quickstart.md`

## Phase 2: Foundational

- [X] T004 Add failing contract fixtures for the `highway-controls` version bump, optional body-only provenance, and removal of `Created Control IDs` in `.highway/tools/tests/`
- [X] T005 [P] Add failing shared-template dependency assertions for the optional `## Provenance` body section in `.highway/tools/tests/output-template.test.sh`
- [X] T006 [P] Add failing Setup and NFR handoff assertions for collection-status routing and the single candidate-generation boundary in `.highway/tools/tests/`
- [X] T007 Define the canonical retained Control record shape, including optional body provenance and unchanged frontmatter, in `.highway/library/templates/output/control-record.md`
- [X] T008 Record the versioning, provenance, collection-result, and NFR ownership decisions in the implementation traceability notes under `specs/107-controls-skill-update/`

## Phase 3: User Story 1 - Evidence-first Control discovery (Priority: P1) 🎯 MVP

**Goal**: Replace fixed category collection with Control-specific, evidence-first discovery and bounded Control/NFR classification.

**Independent Test**: Complete and partial safeguard inputs reach the correct next action without requiring formal Concern, Condition, and Obligation phrasing, while NFR-shaped and ambiguous intent route correctly.

- [X] T009 [P] [US1] Add evidence-first discovery fixtures covering complete, partial, mixed-dimension, ordinary-language, and formal-language input in `.highway/tools/tests/`
- [X] T010 [P] [US1] Add Control-versus-NFR classification fixtures covering clear NFR, clear Control, and unresolved classification in `.highway/tools/tests/`
- [X] T011 [US1] Rewrite `.highway/skills/highway-controls/SKILL.md` Inputs, action selection, and discovery sections around accepted evidence and the rule “Ask for missing information, not missing phrasing.”
- [X] T012 [US1] Remove mandatory Concern, Condition, and Obligation questioning, user-visible discovery progress, and duplicated generic interaction material from `.highway/skills/highway-controls/SKILL.md`
- [X] T013 [US1] Preserve the bounded Control/NFR classification route and user-authored wording override in `.highway/skills/highway-controls/SKILL.md`
- [X] T014 [US1] Verify US1 focused fixtures pass and update the evidence-first contract assertions in `.highway/tools/tests/`

## Phase 4: User Story 2 - Grounded recommendations and acceptance (Priority: P1)

**Goal**: Offer bounded recommendations from accepted context or declared external expertise without creating unsupported policy, and capture selected recommendations directly.

**Independent Test**: Relevant context produces grounded recommendations and provenance; unsupported context produces no fabricated recommendation; selected recommendations require no redundant confirmation.

- [X] T015 [P] [US2] Add recommendation fixtures for Profile, Business Objective, existing Control, declared external expertise, missing context, and unsupported applicability in `.highway/tools/tests/`
- [X] T016 [P] [US2] Add recommendation-selection fixtures proving direct acceptance, missing-information-only follow-up, and user-authored alternative availability in `.highway/tools/tests/`
- [X] T017 [US2] Implement Control-specific recommendation grounding and provenance rules in `.highway/skills/highway-controls/SKILL.md`
- [X] T018 [US2] Replace the broad opening and recommendation loop in `.highway/skills/highway-controls/SKILL.md` with the specified evidence-first and grounded behavior
- [X] T019 [US2] Add optional recommendation provenance rendering and validation to `.highway/library/templates/output/control-record.md` without adding frontmatter
- [X] T020 [US2] Verify US2 recommendation and provenance fixtures pass and preserve the external-grounding boundary

## Phase 5: User Story 3 - Review, continuation, and ownership boundaries (Priority: P1)

**Goal**: Provide the exact user-authored review, direct recommendation capture, explicit setup/configure continuation, and single-Control direct add behavior.

**Independent Test**: Materially interpreted authoring uses the exact captured-Control review; selected recommendations bypass redundant review; setup/configure continues until explicit finish; direct add terminates after one Control.

- [X] T021 [P] [US3] Add exact review-format fixtures for title, statement, body-separated rationale, bottom acceptance, and recommendation bypass in `.highway/tools/tests/`
- [X] T022 [P] [US3] Add continuation fixtures for exact wording, immediate safeguard processing, suggestion/help requests, readiness Complete during active collection, explicit finish, and interruption in `.highway/tools/tests/`
- [X] T023 [US3] Replace proposal, continuation, and collection sections in `.highway/skills/highway-controls/SKILL.md` with the specified Control-owned contracts
- [X] T024 [US3] Remove `Next Action` proposal framing, redundant recommendation review, generic exit/error tables, and post-write verification wording from `.highway/skills/highway-controls/SKILL.md`
- [X] T025 [US3] Update `.highway/skills/highway-setup/SKILL.md` to consume collection status and fresh Controls readiness without `Created Control IDs`
- [X] T026 [US3] Verify US3 review, continuation, Setup routing, and direct-add fixtures pass

## Phase 6: User Story 4 - Durable Control baseline and readiness (Priority: P1)

**Goal**: Preserve Control record/catalog structure, readiness, deterministic mutation, overlap handling, identifier safety, and common failure behavior while removing post-write verification requirements.

**Independent Test**: Valid, missing, malformed, duplicate, overlap, destructive, and failed-mutation fixtures preserve the authoritative baseline and correct readiness outcomes.

- [X] T027 [P] [US4] Add readiness fixtures for Missing, Complete, and Blocked persisted-baseline states independent of collection completion in `.highway/tools/tests/`
- [X] T028 [P] [US4] Add duplicate, overlap, allocation, deterministic-catalog, destructive-action, and failed-mutation fixtures in `.highway/tools/tests/`
- [X] T029 [US4] Rewrite `.highway/skills/highway-controls/SKILL.md` Outputs, persistence flow, readiness, and Control-specific exceptions to preserve the required durable safeguards
- [X] T030 [US4] Rename the workflow step to `Revalidate and persist` and remove `verified`, `persistence-verified`, byte-preservation, generated-shell, and equivalent post-write verification requirements from `.highway/skills/highway-controls/SKILL.md`
- [X] T031 [US4] Update `.highway/library/templates/output/control-record.md` and dependent template checks so provenance is optional body content and frontmatter remains unchanged
- [X] T032 [US4] Verify US4 readiness and persistence fixtures pass without weakening existing mutation assertions

## Phase 7: User Story 5 - Control-derived NFR handoff (Priority: P2)

**Goal**: Invoke NFR-owned candidate generation once after successful new Control creation while keeping all NFR internals with the NFR owner.

**Independent Test**: Successful, zero-candidate, and Blocked candidate-generation results are consumed correctly without partial NFR relationships or duplicated Controls-owned NFR state.

- [X] T033 [P] [US5] Add candidate-generation fixtures for success, zero candidates, Blocked generation, reuse, update, rejection, and failed creation in `.highway/tools/tests/`
- [X] T034 [US5] Rewrite `.highway/skills/highway-controls/SKILL.md` Control-derived NFR section and workflow boundary to invoke only the declared NFR-owner action
- [X] T035 [US5] Reconcile `.highway/skills/highway-nfrs/SKILL.md` candidate-generation input/result language with the Controls handoff contract without moving NFR ownership
- [X] T036 [US5] Verify US5 handoff fixtures pass and candidate generation occurs exactly once for each successfully created new Control

## Phase 8: Polish and cross-cutting validation

- [X] T037 [P] Regenerate all agent adapters and catalogs from canonical inputs with `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, and `.highway/tools/generate-library-catalog.sh`
- [X] T038 [P] Update `.highway/tools/tests/highway-ux-alignment.test.sh` and related contract tests to remove obsolete Controls wording and assert the new Experience boundary
- [X] T039 [P] Update `.highway/tools/tests/output-template.test.sh` for Control provenance and revalidate every skill citing the changed shared template
- [X] T040 Run `bash .highway/tools/tests/run-all.sh`, resolve failures without weakening superseded-behavior assertions, and record the final result in `specs/107-controls-skill-update/quickstart.md`
- [X] T041 Review the final source, adapters, Setup/NFR contracts, templates, and tests against `specs/107-controls-skill-update/spec.md` and `specs/107-controls-skill-update/contracts/`

## Dependencies & Execution Order

### Phase Dependencies

- Setup (Phase 1) precedes Foundational (Phase 2).
- Foundational (Phase 2) blocks all user-story work.
- User Stories 1–4 are P1 and can proceed in parallel after foundational fixtures, except shared-file edits must be serialized.
- User Story 5 depends on the Control persistence boundary from User Story 4 and the NFR contract from the existing owner.
- Polish depends on all desired user stories and must end with the full suite passing.

### User Story Dependencies

- US1: independent after Phase 2; establishes evidence-first discovery.
- US2: independent after Phase 2; shares the canonical Controls skill and Control template with US1.
- US3: depends on the discovery and recommendation decisions from US1 and US2.
- US4: depends on the retained-record decision from US3 but preserves existing mutation behavior.
- US5: depends on US4's successful-creation boundary and the existing NFR owner contract.

### Parallel Opportunities

- T002–T003 can run in parallel.
- T005–T006 can run in parallel after T004.
- T009–T010, T015–T016, T021–T022, T027–T028, and T033 can run in parallel within their phases.
- T037–T039 can run in parallel after all story implementation changes are complete.
- Different story fixture work can be parallelized, but edits to the canonical Controls skill and shared Control template must be coordinated.

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational phases.
2. Complete User Story 1 evidence-first discovery.
3. Validate the focused discovery fixtures.
4. Continue to recommendation and review behavior before changing downstream handoffs.

### Incremental Delivery

1. Deliver evidence-first discovery.
2. Add grounded recommendations and optional provenance.
3. Add review, continuation, and Setup collection routing.
4. Preserve and verify durable readiness and persistence.
5. Reconcile the NFR candidate-generation boundary.
6. Regenerate artifacts and run the full suite.
