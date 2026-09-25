# Tasks: Profile and Setup Contract Hardening

**Input**: Design documents from `/specs/092-profile-setup-contract-hardening/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/](contracts/), [quickstart.md](quickstart.md)

**Tests**: Required by FR-028 and the user stories. Each focused fixture must be observed failing for the new behavior before implementation is marked complete, where the development constitution requires a seeded failing probe.

**Organization**: Tasks are grouped by user story after shared setup and foundational contract work. Paths refer to repository-relative files.

## Phase 1: Setup

**Purpose**: Establish the implementation baseline and fixture locations.

- [X] T001 Run the baseline suite and record its result in `specs/092-profile-setup-contract-hardening/quickstart.md` before implementation.
- [X] T002 [P] Create the Feature 092 disposable fixture root and fixture README at `.highway/tools/tests/fixtures/profile-092/README.md` describing cleanup, artifact classes, and seeded probes.
- [X] T003 [P] Add the Feature 092 focused test registration and naming conventions to `.highway/tools/tests/README.md` without changing existing test dispatch behavior.
- [X] T004 Inventory Feature 092 changed sources and correspondence dependents in `.highway/tools/tests/fixtures/profile-092/dependent-artifact-inventory.tsv` before any regeneration.

## Phase 2: Foundational Contracts and Test Infrastructure

**Purpose**: Establish shared paths, schemas, fixture helpers, and governance references before story-specific changes.

- [X] T005 [P] Add reusable Profile fixture construction and cleanup helpers in `.highway/tools/tests/fixtures/profile-092/profile-fixtures.sh` using Bash 3.2-compatible syntax.
- [X] T006 [P] Add owner readiness response fixtures for valid, malformed, unsupported-action, terminal, non-terminal, and NFR `In Progress` cases in `.highway/tools/tests/fixtures/profile-092/readiness-fixtures.sh`.
- [X] T007 [P] Add schema-version fixture files for valid `2.0.0`, absent, malformed, and unsupported values under `.highway/tools/tests/fixtures/profile-092/schema/`.
- [X] T008 [P] Add runtime hygiene probe fixtures containing known and generalized development identifiers under `.highway/tools/tests/fixtures/profile-092/runtime-hygiene/`.
- [X] T009 Update `.highway/tools/validate-profile.sh` to validate the retained Profile against the shared `profile-record.md` structure, supported schema, canonical domain order, and state-to-narrative invariants.
- [X] T010 Add template-path, retained-artifact, and obsolete-artifact assertions to `.highway/tools/tests/profile-template-migration.test.sh`.
- [X] T011 Add the Feature 092 contract-test launcher entry to `.highway/tools/tests/run-all.sh` and preserve the existing Bash 3.2 and seeded-probe conventions.
- [X] T012 [P] Record the applicable Highway Skills Constitution and Experience Standard rule IDs in `.highway/tools/tests/fixtures/profile-092/governance-rules.txt` for fixture traceability.

**Checkpoint**: Shared fixtures, validation helpers, and test dispatch are available; user-story work can proceed in dependency order.

## Phase 3: User Story 1 - Suppress Unrequested Implementation Details (Priority: P1) - MVP

**Goal**: Make X2.3 interaction-wide while preserving required context, acknowledgments, Decision Context, Relevant Examples, progress, and substantive technical answers.

**Independent Test**: Run normal and explicit-detail Setup/Profile fixtures and verify unrequested mechanics are absent while requested technical content and required X2.7-X2.10 outputs remain available.

### Tests for User Story 1

- [X] T013 [P] [US1] Add normal interaction fixtures with forbidden routing, validation, evaluation-order, artifact, and orchestration language in `.highway/tools/tests/fixtures/profile-092/interaction/normal/`.
- [X] T014 [P] [US1] Add explicit implementation-detail request fixtures proving requested mechanics are allowed without ownership or persistence changes in `.highway/tools/tests/fixtures/profile-092/interaction/explicit-details/`.
- [X] T015 [P] [US1] Add an X2.3/X2.7-X2.10 cross-rule fixture covering acknowledgment, Decision Context, Relevant Examples, and user-relevant progress without internal mechanics in `.highway/tools/tests/fixtures/profile-092/interaction/cross-rule/`.
- [X] T016 [US1] Implement assertions for the interaction fixtures in `.highway/tools/tests/experience-x23-contract.test.sh`.

### Implementation for User Story 1

- [X] T017 [US1] Amend X2.3, its Observable, and its UX Contract in `.highway/governance/experience-standard.md` to prohibit unrequested Implementation details throughout the interaction and classify the amendment under its Versioning Policy.
- [X] T018 [US1] Update `.highway/skills/highway-setup/SKILL.md` to emit only user-relevant acknowledgments, owner context, questions, results, and actionable errors while preserving required context outputs.
- [X] T019 [US1] Update `.highway/skills/highway-profile/SKILL.md` to remove development-history leakage, clarify technical-content allowance, and preserve user-relevant progress without question-count behavior.
- [X] T020 [US1] Apply the minimum X2.3 conformance repairs to discovered Interactive Workflow skills in `.highway/skills/highway-objectives/SKILL.md`, `.highway/skills/highway-controls/SKILL.md`, and `.highway/skills/highway-nfrs/SKILL.md` where the impact inventory requires them.
- [X] T021 [US1] Record the discovered Interactive Workflow inventory, X2.3 verdict, required change, and version classification in `.highway/tools/tests/fixtures/profile-092/interactive-workflow-inventory.tsv`.

**Checkpoint**: Normal and explicit-detail interaction fixtures pass independently, with required user-facing context intact.

## Phase 4: User Story 2 - Route Setup Through Owner Results (Priority: P1)

**Goal**: Make Setup validate and consume owner readiness contracts, delegate only declared actions, and advance only from fresh terminal readiness.

**Independent Test**: Run absent, incomplete, complete, malformed response, unsupported action, blocked, declined, aborted, failed, status-only, and NFR `In Progress` fixtures and verify the decision table.

### Tests for User Story 2

- [X] T022 [P] [US2] Add Profile readiness fixtures for absent, incomplete, complete, malformed, schema-invalid, and invalid Status/Next Action combinations in `.highway/tools/tests/fixtures/profile-092/readiness/profile/`.
- [X] T023 [P] [US2] Add owner-loop fixtures for supported action delegation, status-only reporting, NFR `In Progress`, blocked, unknown, declined, aborted, and failed results in `.highway/tools/tests/fixtures/profile-092/readiness/setup/`.
- [X] T024 [P] [US2] Add malformed owner response fixtures for missing, duplicated, reordered, and unrecognized fields in `.highway/tools/tests/fixtures/profile-092/readiness/malformed/`.
- [X] T025 [US2] Implement response-shape, action-vocabulary, terminality, and no-later-owner assertions in `.highway/tools/tests/setup-owner-loop-contract.test.sh`.

### Implementation for User Story 2

- [X] T026 [US2] Update `.highway/skills/highway-profile/SKILL.md` with conditional readiness classification, exact four-field output order, Profile action vocabulary, and malformed/schema behavior.
- [X] T027 [US2] Rewrite the numbered workflow, response validation boundary, delegation algorithm, status-only behavior, and owner decision table in `.highway/skills/highway-setup/SKILL.md`.
- [X] T028 [US2] Update `.highway/skills/highway-nfrs/SKILL.md` and the other owner readiness contracts to expose declared Next Actions and preserve NFR `In Progress` as non-terminal.
- [X] T029 [US2] Add readiness and owner-loop contract assertions to `.highway/tools/tests/readiness-contract.test.sh` and `.highway/tools/tests/highway-setup.test.sh`.
- [X] T030 [US2] Add executable resume and malformed-response coverage to `.highway/tools/tests/highway-setup-executable.test.sh`.

**Checkpoint**: Setup routes solely from validated owner responses and never recomputes Profile state or writes owner artifacts.

## Phase 5: User Story 3 - Use Declared Repository Context (Priority: P1)

**Goal**: Make Profile consume declared foundational context before dependent decisions without promoting context into organizational facts or making Setup a context consumer.

**Independent Test**: Run present, absent, conflicting, and non-promoting Identity/Vision/Platform Objectives fixtures and verify semantic roles, workflow-input precedence, and no fabricated Profile evidence.

### Tests for User Story 3

- [X] T031 [P] [US3] Add present and absent foundational context fixtures under `.highway/tools/tests/fixtures/profile-092/repository-context/`.
- [X] T032 [P] [US3] Add workflow-input conflict and context non-promotion fixtures under `.highway/tools/tests/fixtures/profile-092/repository-context/conflicts/`.
- [X] T033 [P] [US3] Add a reference Participating Skill fixture that declares Profile context and a negative fixture that does not under `.highway/tools/tests/fixtures/profile-092/participation/`.
- [X] T034 [US3] Implement context-consumption, role, precedence, absence, and non-promotion assertions in `.highway/tools/tests/profile-context-contract.test.sh`.

### Implementation for User Story 3

- [X] T035 [US3] Add the three foundational Repository Context Inputs, role semantics, first-dependent-decision consultation, missing-context evidence, and non-promotion boundary to `.highway/skills/highway-profile/SKILL.md`.
- [X] T036 [US3] Synchronize the Repository Context definition, four-document list, and overlap semantics in `.highway/governance/constitution.md`.
- [X] T037 [US3] Synchronize the descriptive context list and semantic roles in `.highway/library/knowledge/highway-identity.md`.
- [X] T038 [US3] Keep Setup orchestration-only and remove any accidental Repository Context dependency from `.highway/skills/highway-setup/SKILL.md`.
- [X] T039 [US3] Update the reference participation fixture in `.highway/tools/tests/fixtures/profile-091/reference-participant/SKILL.md` and add its negative declaration case.

**Checkpoint**: Profile consumes only declared context, workflow-specific input remains authoritative, and foundational context contributes no unsupported organizational facts.

## Phase 6: User Story 4 - Maintain a Durable, Conforming Markdown Profile (Priority: P1)

**Goal**: Establish `profile-record.md` as the complete output template, remove legacy output templates, and preserve deterministic accepted Profile persistence.

**Independent Test**: Validate representative accepted, incomplete, bounded, empty, malformed, schema-invalid, no-op, and persistence-mismatch fixtures byte-for-byte and verify the old template paths are absent.

### Tests for User Story 4

- [X] T040 [P] [US4] Add canonical template and retained-record fixtures for all five domains and state/narrative combinations under `.highway/tools/tests/fixtures/profile-092/profile-record/`.
- [X] T041 [P] [US4] Add metadata-separation and no-placeholder-write fixtures under `.highway/tools/tests/fixtures/profile-092/profile-record/persistence/`.
- [X] T042 [P] [US4] Add no-op, interrupted, declined, malformed, and persistence-mismatch fixtures under `.highway/tools/tests/fixtures/profile-092/profile-record/mutations/`.
- [X] T043 [US4] Update `.highway/tools/tests/profile-markdown-contract.test.sh` to use `profile-record.md`, verify canonical order, state invariants, deterministic bytes, and metadata separation.
- [X] T044 [US4] Replace the obsolete YAML parser test with removal and no-fallback assertions in `.highway/tools/tests/profile-yaml.test.sh` or its replacement test path.
- [X] T045 [US4] Update `.highway/tools/tests/profile-lifecycle.test.sh` for the retained Profile path, no-write first-question behavior, no-op mutations, and inert legacy YAML fixture.

### Implementation for User Story 4

- [X] T046 [US4] Rename `.highway/library/templates/output/profile.md` to `.highway/library/templates/output/profile-record.md` while preserving the complete five-domain structural skeleton and deterministic metadata boundary.
- [X] T047 [US4] Remove `.highway/library/templates/output/profile.yaml` and ensure no replacement YAML fallback or migration path is introduced.
- [X] T048 [US4] Update `.highway/tools/validate-profile.sh` and all Profile rendering/persistence checks to cite `.highway/library/templates/output/profile-record.md`.
- [X] T049 [US4] Update `.highway/skills/highway-profile/SKILL.md` Inputs, Outputs, Verification, and persistence wording to cite `profile-record.md` as template and `profile.md` as retained artifact.
- [X] T050 [US4] Update `.highway/tools/.distribution-manifest` to include `profile-record.md` and remove the obsolete Markdown and YAML template entries.

**Checkpoint**: The retained Profile validates against the renamed template, legacy output templates are absent, and all mutation invariants pass.

## Phase 7: User Story 5 - Keep Runtime Contracts Self-Contained (Priority: P2)

**Goal**: Remove development-history dependencies from all affected runtime contracts and verify metadata syntax independently from semantic version classification.

**Independent Test**: Scan modified production skills, templates, generated adapters, and distributed artifacts for prohibited runtime identifiers while allowing explicitly historical records.

### Tests for User Story 5

- [X] T051 [P] [US5] Expand runtime hygiene fixtures for known leaks and generalized feature, branch, plan, and task identifiers under `.highway/tools/tests/fixtures/profile-092/runtime-hygiene/`.
- [X] T052 [P] [US5] Add malformed and repaired skill metadata fixtures under `.highway/tools/tests/fixtures/profile-092/metadata/`.
- [X] T053 [US5] Implement scoped runtime-hygiene and metadata SemVer assertions in `.highway/tools/tests/runtime-contract-hygiene.test.sh`.

### Implementation for User Story 5

- [X] T054 [US5] Remove Feature 091, requirement, branch, plan, and task identifiers from runtime Profile, Setup, template, and affected skill contracts while preserving allowed governance and historical references in `.highway/tools/runtime-identifier-allowlist` or its existing equivalent.
- [X] T055 [US5] Repair malformed `metadata.version` syntax and validate separate skill names in `.highway/skills/highway-profile/SKILL.md`, `.highway/skills/highway-setup/SKILL.md`, and every amended Interactive Workflow skill.
- [X] T056 [US5] Classify Profile, Setup, and every X2.3-affected skill under the applicable Skill Versioning Policy and update only the required `metadata.version` fields in the amended `.highway/skills/*/SKILL.md` files.
- [X] T057 [US5] Regenerate affected adapter files under `.github/skills/`, `.claude/skills/`, and `.cursor/rules/` only after source/version changes are classified and recorded.

**Checkpoint**: Runtime contracts are self-contained, metadata parses independently, and generated adapters match amended source skills.

## Phase 8: User Story 6 - Complete Governance and Compliance Records (Priority: P2)

**Goal**: Ratify synchronized governance amendments, record impact/version evidence, and verify all affected workflows and generated artifacts.

**Independent Test**: Run applicable governance, skill, template, routing, context, hygiene, correspondence, and full-suite checks with no unresolved failure.

### Tests for User Story 6

- [X] T058 [P] [US6] Add constitutional consistency assertions for definition, Principle XI, overlap roles, Highway Identity, and conflicting statements in `.highway/tools/tests/constitution-profile-context.test.sh`.
- [X] T059 [P] [US6] Add Experience Standard X2.3 versioning and self-application assertions in `.highway/tools/tests/experience-standard-amendment.test.sh`.
- [X] T060 [P] [US6] Add generated/dependent artifact inventory and correspondence assertions in `.highway/tools/tests/feature-092-correspondence.test.sh`.
- [X] T061 [US6] Add all discovered Interactive Workflow verdicts, affected-skill version classifications, and completion evidence to `.highway/tools/tests/fixtures/profile-092/impact-review.tsv`.

### Implementation for User Story 6

- [X] T062 [US6] Amend `.highway/governance/experience-standard.md` with the ratified X2.3 interaction-wide rule, X2.7-X2.10 compatibility, Sync Impact Report, self-application review, footer, and version classification.
- [X] T063 [US6] Amend `.highway/governance/constitution.md` with synchronized Repository Context definition/list/overlap semantics, amendment metadata, self-application review, footer, and actual-diff version classification.
- [X] T064 [US6] Update `.highway/library/knowledge/highway-identity.md` and all directly affected live documentation for governance and template correspondence.
- [X] T065 [US6] Regenerate identified catalog, adapter, manifest, and distribution outputs using the existing generators and record each action or `None` in `.highway/tools/tests/fixtures/profile-092/dependent-artifact-inventory.tsv`.

**Checkpoint**: Governance records, source contracts, tests, and identified generated dependents are synchronized and reviewable.

## Phase 9: Polish and Cross-Cutting Validation

**Purpose**: Complete correspondence, run the full validation matrix, and preserve auditable evidence.

- [X] T066 [P] Run every focused Feature 092 test and record PASS/FAIL results in `specs/092-profile-setup-contract-hardening/quickstart.md`.
- [X] T067 [P] Run `.highway/tools/tests/run-all.sh` and record the final suite result in `specs/092-profile-setup-contract-hardening/quickstart.md`.
- [X] T068 [P] Run `.highway/tools/validate-skill.sh` against every amended shipped skill and record results in `specs/092-profile-setup-contract-hardening/quickstart.md`.
- [X] T069 [P] Run `.highway/tools/validate-profile.sh` against valid, incomplete, malformed, and schema-invalid disposable fixtures and record results in `specs/092-profile-setup-contract-hardening/quickstart.md`.
- [X] T070 Verify all generated/distributed correspondence and package-independence checks after regeneration in `.highway/tools/tests/feature-092-correspondence.test.sh`.
- [X] T071 Review changed runtime contracts for prohibited development identifiers and user-visible implementation-detail leakage, recording the result in `specs/092-profile-setup-contract-hardening/quickstart.md`.
- [X] T072 Run `git diff --check` and record the clean result in `specs/092-profile-setup-contract-hardening/quickstart.md`.
- [X] T073 Confirm all Feature 092 functional requirements and success criteria are covered by tasks and test evidence in `specs/092-profile-setup-contract-hardening/quickstart.md`.

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 Setup**: Starts immediately; establishes baseline and fixture locations.
- **Phase 2 Foundational**: Depends on Phase 1; blocks all user-story implementation.
- **US1 and US2**: Depend on Phase 2 and can proceed in parallel when they touch separate contracts/tests.
- **US3**: Depends on the owner contracts from US2 and can proceed alongside US4 after the readiness boundary is stable.
- **US4**: Depends on Phase 2; its template path changes must land before final correspondence work.
- **US5**: Depends on US1-US4 source contracts so hygiene and version classification inspect final runtime text.
- **US6**: Depends on US1-US5 and owns final governance ratification, impact evidence, and regeneration.
- **Polish**: Depends on all desired user stories and the final identified-dependent inventory.

### User Story Dependencies

- **US1 (P1)**: Phase 2 only; MVP interaction boundary, with no dependency on later stories.
- **US2 (P1)**: Phase 2; uses shared readiness fixtures and may proceed alongside US1.
- **US3 (P1)**: Phase 2 plus stable owner boundary from US2; no dependency on template implementation.
- **US4 (P1)**: Phase 2; independent retained-artifact/template increment.
- **US5 (P2)**: Depends on the final runtime text from US1-US4.
- **US6 (P2)**: Depends on all contract changes and impact inventories.

### Parallel Opportunities

- T002, T003, T005-T008, and T012 can run in parallel after T001.
- US1 fixture creation (T013-T015), US2 fixture creation (T022-T024), US3 fixture creation (T031-T033), and US4 fixture creation (T040-T042) can proceed in parallel after foundational setup.
- T017 and T036 can proceed in parallel because they amend different governance documents; T018/T019/T037 are separate source files after their contract inputs are agreed.
- T051 and T052 can proceed in parallel; T058-T060 can proceed in parallel after source changes stabilize.
- T066-T069 can run in parallel after implementation; T070-T073 are final evidence and quality gates.

## Parallel Execution Examples

### User Story 1

```text
Task: T013 - Add normal interaction fixtures in .highway/tools/tests/fixtures/profile-092/interaction/normal/
Task: T014 - Add explicit-detail fixtures in .highway/tools/tests/fixtures/profile-092/interaction/explicit-details/
Task: T015 - Add X2.3/X2.7-X2.10 cross-rule fixtures in .highway/tools/tests/fixtures/profile-092/interaction/cross-rule/
```

### User Story 2

```text
Task: T022 - Add Profile readiness fixtures in .highway/tools/tests/fixtures/profile-092/readiness/profile/
Task: T023 - Add Setup owner-loop fixtures in .highway/tools/tests/fixtures/profile-092/readiness/setup/
Task: T024 - Add malformed response fixtures in .highway/tools/tests/fixtures/profile-092/readiness/malformed/
```

### User Story 3

```text
Task: T031 - Add context presence/absence fixtures in .highway/tools/tests/fixtures/profile-092/repository-context/
Task: T032 - Add conflict/non-promotion fixtures in .highway/tools/tests/fixtures/profile-092/repository-context/conflicts/
Task: T033 - Add participation fixtures in .highway/tools/tests/fixtures/profile-092/participation/
```

### User Story 4

```text
Task: T040 - Add Profile record fixtures in .highway/tools/tests/fixtures/profile-092/profile-record/
Task: T041 - Add metadata/no-placeholder fixtures in .highway/tools/tests/fixtures/profile-092/profile-record/persistence/
Task: T042 - Add mutation fixtures in .highway/tools/tests/fixtures/profile-092/profile-record/mutations/
```

## Implementation Strategy

### MVP First

1. Complete Phase 1 and Phase 2.
2. Complete US1: X2.3 interaction boundary and focused fixtures.
3. Run US1's independent test and the existing suite.
4. Use the result as the first demonstrable increment before adding owner routing and persistence changes.

### Incremental Delivery

1. Add US2 owner-result routing and verify the Setup decision table.
2. Add US3 context participation and non-promotion evidence.
3. Add US4 template replacement, legacy artifact removal, and deterministic persistence checks.
4. Add US5 runtime hygiene and generated adapter synchronization.
5. Add US6 governance ratification, correspondence evidence, and final compliance checks.
6. Complete Phase 9 and confirm every declared applicable check is resolved.

### Parallel Team Strategy

1. One contributor establishes Phase 1-2 fixtures and validators.
2. After the foundation is stable, separate contributors can work on US1, US3, and US4 in separate source/test files; US2 owns readiness and Setup contracts.
3. US5 performs the consolidated runtime hygiene/version review after story contracts stabilize.
4. US6 and Phase 9 close governance, generated artifacts, and suite evidence.

## Notes

- Every task uses the required checkbox, sequential ID, optional parallel marker, story label where applicable, and an exact repository path.
- Tests are included because the feature specification explicitly requires fixtures and regression coverage.
- Generated artifacts are regenerated only after the dependent inventory is recorded.
- Do not create a new persistence technology, new Profile domain, new Setup stage, or unrelated downstream Profile participant.
