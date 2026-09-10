# Tasks: Profile Setup Readiness and Zero-NFR Completion

**Input**: Design documents from `/specs/035-profile-setup-readiness/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, and `quickstart.md`

## Phase 1: Setup

- [X] T001 Record the current repository test baseline and identify the Feature 035 focused test commands in `.highway/tools/tests/run-all.sh` and `specs/035-profile-setup-readiness/quickstart.md`
- [X] T002 [P] Add a Feature 035 fixture matrix covering missing, empty, whitespace-only, valid, declined, malformed, zero-candidate, pending, accepted, unavailable, and contradictory states in `.highway/tools/tests/fixtures/feature-035/README.md`
- [X] T003 [P] Add a requirement-to-task traceability table mapping FR-001 through FR-014 and SC-001 through SC-007 to implementation and verification tasks in `specs/035-profile-setup-readiness/quickstart.md`

## Phase 2: Foundational

- [X] T004 Extend the shared test helpers with deterministic assertions for file-byte preservation, status values, and no-artifact creation in `.highway/tools/tests/test-helpers.sh`
- [X] T005 [P] Add a reusable Setup workflow parser that extracts declared numbered steps and `Step N` references in `.highway/tools/tests/highway-setup.test.sh`
- [X] T006 [P] Add a reusable NFR candidate outcome evaluator for unavailable, malformed, zero, available-pending, and accepted results in `.highway/tools/tests/highway-setup.test.sh`
- [X] T007 Run the new foundational checks before implementation, record each expected failure, and preserve the failure evidence in `specs/035-profile-setup-readiness/quickstart.md`

## Phase 3: User Story 1 - Establish Profile-owned organization readiness (Priority: P1)

**Goal**: Make `highway-profile` the only owner of user-supplied `organization.name`, Profile completeness, confirmation, and safe no-write behavior.

**Independent test**: Run `.highway/tools/tests/profile-structure.test.sh`, `.highway/tools/tests/profile-behavior.test.sh`, `.highway/tools/tests/profile-yaml.test.sh`, and `.highway/tools/tests/profile-migration.test.sh`; verify absent, empty, whitespace-only, valid, declined, and malformed cases against the Profile owner contract.

- [X] T008 [US1] Add the explicit organization identity question and `organization.name` completion rule to the setup/configure workflow in `.highway/skills/highway-profile/SKILL.md`
- [X] T009 [US1] Specify Profile-owned outcomes for absent, empty, whitespace-only, supplied, declined, and malformed organization identity without inferred values or writes in `.highway/skills/highway-profile/SKILL.md`
- [X] T010 [P] [US1] Add structure assertions for the organization identity question, required field, owner boundary, and no-inference rule in `.highway/tools/tests/profile-structure.test.sh`
- [X] T011 [P] [US1] Add behavior fixtures for valid completion, missing identity, whitespace-only identity, declined confirmation, malformed Profile, deterministic repeated input, and byte preservation in `.highway/tools/tests/profile-behavior.test.sh`
- [X] T012 [US1] Update Profile verification and error-handling contract text to identify `organization.name` or the malformed section and preserve original bytes on non-confirmed mutation in `.highway/skills/highway-profile/SKILL.md`
- [X] T013 [US1] Run `.highway/tools/tests/profile-structure.test.sh`, `.highway/tools/tests/profile-behavior.test.sh`, `.highway/tools/tests/profile-yaml.test.sh`, `.highway/tools/tests/profile-migration.test.sh`, and the Profile validators, then correct only Profile-slice failures until the User Story 1 independent test passes

## Phase 4: User Story 2 - Consume Profile readiness and enforce numbered Setup workflow (Priority: P1)

**Goal**: Make Setup consume Profile-owner readiness, remove duplicated Profile field semantics, and prove that its workflow numbering and references are structurally valid.

**Independent test**: Run `.highway/tools/tests/highway-setup.test.sh` and `.highway/tools/validate-skill.sh .highway/skills/highway-setup`; confirm steps 1 through 10 are unique and contiguous, every `Step N` reference resolves, and Setup does not define `organization.name` validity.

- [X] T014 [US2] Renumber the Setup workflow as ten unique sequential steps while preserving the existing readiness order and continuation destinations in `.highway/skills/highway-setup/SKILL.md`
- [X] T015 [US2] Replace Setup-owned empty-name semantics with a Profile-owner readiness result and preserve the Profile delegation and abort behavior in `.highway/skills/highway-setup/SKILL.md`
- [X] T016 [US2] Add the numbered workflow integrity check for unique contiguous steps and resolvable `Step N` references in `.highway/tools/tests/highway-setup.test.sh`
- [X] T017 [P] [US2] Add a negative workflow fixture covering missing, duplicate, non-sequential, and dangling step references in `.highway/tools/tests/highway-setup.test.sh`
- [X] T018 [US2] Add assertions that Setup routes incomplete Profile state to `/highway-profile`, does not duplicate Profile validity rules, and reaches the dashboard through valid Step 10 references in `.highway/tools/tests/highway-setup.test.sh`
- [X] T019 [US2] Run `.highway/tools/tests/highway-setup.test.sh` and `.highway/tools/validate-skill.sh .highway/skills/highway-setup`, then correct only Setup-slice failures until the User Story 2 independent test passes

## Phase 5: User Story 3 - Complete valid repositories with zero NFR candidates (Priority: P1)

**Goal**: Distinguish successful zero-candidate generation from unavailable, malformed, pending, and accepted outcomes, with `NFRs: Not Applicable` as a terminal state that creates no NFR artifact.

**Independent test**: Run `.highway/tools/tests/highway-setup.test.sh` against complete prerequisite fixtures for zero, pending, accepted, unavailable, and malformed candidate results; verify deterministic statuses, dashboard routing, and no NFR write for zero candidates.

- [X] T020 [US3] Add the zero-candidate terminal branch and `NFRs: Not Applicable` dashboard output after complete Profile, Objective, and Control readiness in `.highway/skills/highway-setup/SKILL.md`
- [X] T021 [US3] Add explicit Setup outcome rules distinguishing zero candidates from unavailable, malformed, pending, and accepted candidate results in `.highway/skills/highway-setup/SKILL.md`
- [X] T022 [P] [US3] Add zero-candidate, pending, accepted, unavailable, and malformed candidate fixtures with expected Setup and NFR states in `.highway/tools/tests/highway-setup.test.sh`
- [X] T023 [US3] Add assertions that zero-candidate completion does not invoke NFR authoring or create an NFR artifact and that repeated identical inputs produce identical output in `.highway/tools/tests/highway-setup.test.sh`
- [X] T024 [US3] Add assertions that candidate generation failure or malformed output is Blocked, pending candidates remain In Progress, and accepted artifacts remain Complete in `.highway/tools/tests/highway-setup.test.sh`
- [X] T025 [US3] Run the User Story 3 focused matrix and correct only NFR outcome-routing failures until every candidate state matches `contracts/nfr-candidate-outcomes.md`

## Phase 6: Polish & Cross-Cutting Concerns

- [X] T026 Regenerate the library catalog, distribution manifest, and agent adapters from the changed source skills using `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-distribution.sh`, and `.highway/tools/generate-agent-adapters.sh`
- [X] T027 [P] Validate the changed source skills and Profile artifact with `.highway/tools/validate-skill.sh .highway/skills/highway-profile`, `.highway/tools/validate-skill.sh .highway/skills/highway-setup`, and `.highway/tools/validate-profile.sh .highway/library/templates/output/profile.yaml`
- [X] T028 Run adapter correspondence and generated-artifact integrity checks in `.highway/tools/tests/adapter-coverage.test.sh` and verify `.highway/tools/.distribution-manifest` was regenerated rather than hand-edited
- [X] T029 Run the complete repository suite with `.highway/tools/tests/run-all.sh` and record separate Profile, Setup workflow, zero-candidate, generated-artifact, and full-suite results in `specs/035-profile-setup-readiness/quickstart.md`
- [X] T030 Run `git diff --check` and verify all Feature 035 requirements are covered exactly once in `specs/035-profile-setup-readiness/quickstart.md`

## Dependencies

- Phase 1 establishes the baseline and fixture locations.
- Phase 2 must complete before any user story because it supplies shared assertions and expected failing evidence.
- User Story 1 and User Story 2 can proceed in parallel after Phase 2; Story 2 consumes the Profile owner contract but does not require the Profile implementation to be complete to update its delegation rules.
- User Story 3 depends on the Setup routing helpers from Phase 2 and can proceed in parallel with Story 1 after those helpers exist; its terminal branch is implemented in the Setup skill.
- Phase 6 begins after all three user stories pass their independent tests.

### Dependency Graph

```text
Phase 1 -> Phase 2
Phase 2 -> US1
Phase 2 -> US2
Phase 2 -> US3
US1 -> Phase 6
US2 -> Phase 6
US3 -> Phase 6
```

## Parallel Execution Examples

### User Story 1

```text
T010 (profile structure assertions) || T011 (profile behavior fixtures)
T008 -> T009 -> T012 -> T013
```

### User Story 2

```text
T016 (workflow parser assertions) || T017 (negative workflow fixtures)
T014 -> T015 -> T018 -> T019
```

### User Story 3

```text
T020 -> T021
T022 (candidate fixtures) || T023 (zero-write assertions) || T024 (non-zero outcome assertions)
T021 + T022 + T023 + T024 -> T025
```

### Cross-cutting validation

```text
T027 || T028
T026 -> T027 + T028 -> T029 -> T030
```

## Implementation Strategy

1. Establish the fixture and assertion foundation, preserving the baseline and capturing expected failures.
2. Deliver the MVP as User Story 1 plus the minimum Setup delegation needed to consume Profile readiness.
3. Complete the numbered workflow contract and structural checks in User Story 2.
4. Add zero-candidate terminal routing and the remaining NFR outcome matrix in User Story 3.
5. Regenerate derived artifacts, run validators and the full suite, and record checks separately from requirement coverage.

## Traceability Summary

- FR-001 through FR-005: T008-T013
- FR-006 through FR-009: T014-T019
- FR-010 through FR-014: T020-T025
- SC-001 through SC-002: T010-T013
- SC-003: T016-T019
- SC-004 through SC-007: T022-T025
