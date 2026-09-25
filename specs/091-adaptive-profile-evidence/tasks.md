# Tasks: Adaptive Organizational Profile Evidence

## Dependencies and execution order

Phase 1 establishes fixtures and shared validation helpers. Phase 2 defines the Markdown artifact and rendering/readiness foundation. User Story 1 depends on Phases 1-2. User Stories 2 and 4 depend on the Profile artifact foundation; User Story 3 depends on the governance and participation contract. The final phase runs the full compliance suite.

## Phase 1: Setup

- [X] T001 Confirm the Feature 091 source paths and current YAML assumptions in `.highway/skills/highway-profile/SKILL.md`, `.highway/library/templates/output/profile.yaml`, `.highway/tools/tests/profile-behavior.test.sh`, and `.highway/tools/validate-profile.sh`.
- [X] T002 [P] Add a disposable Markdown Profile fixture directory and fixture helper conventions in `.highway/tools/tests/fixtures/profile-091/`.
- [X] T003 [P] Add Feature 091 evidence coverage notes linking FR-001 through FR-065 and SC-001 through SC-016 to planned tests in `specs/091-adaptive-profile-evidence/coverage.md`.

- [X] T004 Define the deterministic Markdown Profile skeleton, frontmatter order, five domain keys, and conditional narrative headings in `.highway/library/templates/output/profile.md`.
- [X] T005 Implement shared Markdown Profile parsing, rendering, state validation, and byte-stable comparison helpers in `.highway/tools/lib/profile.sh`.
- [X] T006 Replace the YAML-only structural validator with Markdown Profile validation, state-to-narrative invariants, and exact five-domain checks in `.highway/tools/validate-profile.sh`.
- [X] T007 [P] Add focused structural and deterministic rendering tests for the shared template and validator in `.highway/tools/tests/profile-markdown-contract.test.sh`.
- [X] T008 [P] Add proposal-versus-accepted, readiness, transition, no-op, conflict, and byte-preservation fixtures in `.highway/tools/tests/profile-lifecycle.test.sh`.
- [X] T009 Run the focused validator and lifecycle tests, repair shell portability issues for macOS Bash 3.2, and record results in `specs/091-adaptive-profile-evidence/quickstart.md`.

## Phase 3: User Story 1 - Discover Organizational Context Conversationally

**Goal**: Collect adaptive evidence across five domains, apply cross-domain evidence, ask at most one behavior-changing follow-up, and keep initial proposals transient.

**Independent test**: Run the adaptive corpus and verify broad Identity opening, multi-domain extraction, FR-005 follow-up decisions, explicit boundaries, proposal acceptance, and restart after interrupted first setup.

- [X] T010 [US1] Rewrite adaptive collection, domain evaluation, proposal acceptance, and five-domain lifecycle behavior in `.highway/skills/highway-profile/SKILL.md`.
- [X] T011 [US1] Add deterministic adaptive review corpus records for the four representative organization fixtures in `.highway/tools/tests/fixtures/profile-091/adaptive-corpus.md`.
- [X] T012 [US1] Add executable adaptive collection and setup-resume assertions in `.highway/tools/tests/profile-adaptive.test.sh`.
- [X] T013 [US1] Add explicit boundary, unanswered response, cross-domain evidence, and one-follow-up assertions to `.highway/tools/tests/profile-adaptive.test.sh`.

## Phase 4: User Story 2 - Build a Durable Human-Readable Profile

**Goal**: Persist accepted evidence as deterministic Markdown with faithful prose, conditional sections, structural metadata, and persistence-before-completion verification.

**Independent test**: Accept representative proposals, inspect the knowledge-library artifact, validate it, compare repeated renders byte-for-byte, and verify unsupported sections and claims are absent.

- [X] T014 [US2] Add deterministic Profile rendering and persistence-before-completion behavior to `.highway/skills/highway-profile/SKILL.md`.
- [X] T015 [US2] Add accepted Profile Markdown fixtures, bounded-without-evidence fixtures, and narrative fidelity fixtures in `.highway/tools/tests/fixtures/profile-091/accepted/`.
- [X] T016 [US2] Add artifact path, section ordering, schema version, deterministic bytes, and narrative fidelity checks in `.highway/tools/tests/profile-markdown-contract.test.sh`.
- [X] T017 [US2] Add obsolete YAML isolation checks proving `profile.yaml` is never migrated, read as fallback, or used for readiness in `.highway/tools/tests/profile-lifecycle.test.sh`.

## Phase 5: User Story 3 - Make Profile Context Available to Participating Skills

**Goal**: Amend Repository Context ownership and prove a reference Participating Skill can consume accepted Profile context without silently changing unrelated skills.

**Independent test**: Validate the constitutional amendment, identity synchronization, reference participant contract, precedence rules, and non-inference behavior.

- [X] T018 [US3] Amend the Repository Context Document definition, authoritative list, overlap language, and versioning record in `.highway/governance/constitution.md`.
- [X] T019 [US3] Synchronize the descriptive Repository Context document list and Profile ownership language in `.highway/library/knowledge/highway-identity.md`.
- [X] T020 [P] Add a reference Participating Skill fixture declaring Profile context and behavior categories in `.highway/tools/tests/fixtures/profile-091/reference-participant/SKILL.md`.
- [X] T021 [US3] Add constitutional, identity, participation, precedence, and non-inference assertions in `.highway/tools/tests/profile-participation.test.sh`.
- [X] T022 [US3] Update the constitutional Sync Impact Report and run the required self-application and compliance review evidence in `.highway/governance/constitution.md` and `specs/091-adaptive-profile-evidence/coverage.md`.

## Phase 6: User Story 4 - Manage Profile Through Existing Operations

**Goal**: Preserve supported Profile operations while moving them to the Markdown artifact and applying finalized mutation and readiness semantics.

**Independent test**: Exercise setup, configure, view, show, describe, readiness, add, update, remove, and reset against Markdown fixtures and verify every write/preview contract.

- [X] T023 [US4] Rewrite Profile Inputs, Outputs, operations, mutation previews, transitions, readiness, and error handling for Markdown in `.highway/skills/highway-profile/SKILL.md`.
- [X] T024 [US4] Update `highway-setup` to consume Profile readiness, use canonical Setup/Configure routing, resume from persisted outcomes, and advance to Objectives in `.highway/skills/highway-setup/SKILL.md`.
- [X] T025 [US4] Add Setup ownership and resume-routing assertions in `.highway/tools/tests/highway-setup.test.sh` and `.highway/tools/tests/highway-setup-executable.test.sh`.
- [X] T026 [US4] Add complete, incomplete, malformed, remove, reset, no-op, ambiguous-target, and interrupted-Configure cases in `.highway/tools/tests/profile-lifecycle.test.sh`.
- [X] T027 [US4] Remove obsolete YAML mutation assumptions and update focused Profile behavior checks in `.highway/tools/tests/profile-behavior.test.sh`.

## Phase 7: Polish and cross-cutting validation

- [X] T028 [P] Update generated catalog or adapter outputs after source skill changes using the repository generator in `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-agent-adapters.sh`.
- [X] T029 [P] Update Profile ownership and template references in distributed documentation and manifests in `.highway/DISTRIBUTION.md` and `.highway/catalog/` where required by correspondence checks.
- [X] T030 Run `.highway/tools/tests/run-all.sh` and repair all Feature 091 regressions without weakening the specified contracts.
- [X] T031 Run the constitutional and Experience Standard compliance checks, validate generated-artifact correspondence, and record final evidence in `specs/091-adaptive-profile-evidence/coverage.md`.
- [X] T032 Validate `spec.md`, `plan.md`, all design artifacts, task format, and the implementation against the Feature 091 completion criteria; record the final result in `specs/091-adaptive-profile-evidence/quickstart.md`.

## Parallel opportunities

- T002, T003 can run in parallel.
- T007, T008 can run in parallel after T005-T006.
- T020 can run in parallel with T018-T019.
- T028, T029 can run in parallel after source changes are complete.

## Implementation strategy

Deliver the Profile Markdown validator and lifecycle foundation first, then the adaptive owner workflow,
accepted rendering, governance participation, and Setup routing. The MVP is Phases 1-4 (adaptive
Profile collection and durable Markdown persistence); Phases 5-6 complete repository integration.
