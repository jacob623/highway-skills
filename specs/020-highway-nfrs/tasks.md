# Tasks: Highway NFR Management

**Input**: Design documents from `/specs/020-highway-nfrs/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/nfrs-skill.md`, and `quickstart.md`

**Organization**: Tasks are grouped by user story so each story can be implemented and validated as an independent increment after the foundational work.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the files and test entry points needed to add the new shipped skill without disturbing existing generated artifacts.

- [X] T001 Create the `highway-nfrs` source directory at `.highway/skills/highway-nfrs/` and reserve the implementation target `.highway/skills/highway-nfrs/SKILL.md`.
- [X] T002 [P] Add the focused NFR behavior test entry point at `.highway/tools/tests/nfr-management.test.sh` using the existing test conventions.
- [X] T003 [P] Add the focused reciprocal routing test entry point at `.highway/tools/tests/governance-routing.test.sh` using the existing test conventions.
- [X] T004 [P] Add temporary-fixture cleanup names for NFR probes to `.highway/tools/tests/run-all.sh` if the new tests create residue-prone paths.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Define the shared artifact model, root boundary, and deterministic mutation contract before action-specific behavior is authored.

**Checkpoint**: The baseline paths, invariants, and test fixtures are established; user-story implementation can proceed in priority order.

- [X] T005 Write the NFR artifact model and invariants in `.highway/skills/highway-nfrs/SKILL.md`, including root `library/governance/`, `nfrs.md`, `nfrs/NFRXXXXXX.md`, YAML frontmatter, Markdown body, `controls: []`, no per-NFR version, and no timestamps.
- [X] T006 Define the project-root discovery and containment decision path in `.highway/skills/highway-nfrs/SKILL.md`, requiring `.highway/` as the anchor and aborting without writes when it is absent.
- [X] T007 Define catalog invariants in `.highway/skills/highway-nfrs/SKILL.md`, including semantic baseline version, authoritative `next_id`, complete index, generated prose, and deterministic regeneration.
- [X] T008 Define shared identifier and mutation invariants in `.highway/skills/highway-nfrs/SKILL.md`, including six-digit IDs, immutable non-reused identifiers, exactly one version increment per successful action, and no increment on aborted actions.
- [X] T009 Add the shared temporary NFR record and catalog fixtures needed by later tests in `.highway/tools/tests/fixtures/` without placing user-owned governance under `.highway/library/`.
- [X] T010 Run `.highway/tools/validate-skill.sh .highway/skills/highway-nfrs` against the foundational draft and repair any applicable Constitution or Experience Standard violations before story work continues.

## Phase 3: User Story 1 (US1) - Add a Global NFR (Priority: P1) MVP

**Goal**: A maintainer can add an NFR to an empty or existing baseline and receive a correctly identified, indexed record with an empty Control relationship field.

**Independent Test**: Add the first NFR and a subsequent NFR in an isolated fixture; verify record shape, catalog contents, `next_id`, and one MINOR version increment per Add.

### Tests for User Story 1

- [X] T011 [P] [US1] Add empty-baseline and first-Add assertions to `.highway/tools/tests/nfr-management.test.sh` for `NFR000001.md`, catalog creation, frontmatter, statement, rationale, and MINOR versioning.
- [X] T012 [P] [US1] Add subsequent-Add assertions to `.highway/tools/tests/nfr-management.test.sh` proving allocation consumes catalog `next_id` and advances it rather than scanning the highest present file.

### Implementation for User Story 1 (US1)

- [X] T013 [US1] Implement the Add workflow in `.highway/skills/highway-nfrs/SKILL.md`, including title, status, statement, rationale, empty `controls: []`, file creation, catalog regeneration, and one MINOR increment.
- [X] T014 [US1] Define the generated `library/governance/nfrs.md` content contract in `.highway/skills/highway-nfrs/SKILL.md`, including global applicability, `/highway-nfrs` ownership, direct-edit warning, baseline version, `next_id`, and an index of all NFRs.
- [X] T015 [US1] Run `.highway/tools/tests/nfr-management.test.sh` for User Story 1 and repair Add or catalog behavior until the isolated empty-baseline and existing-baseline scenarios pass.

**Checkpoint** (US1): A working Add flow is independently demonstrable and provides the MVP baseline.

## Phase 4: User Story 2 (US2) - Preserve the User Governance Boundary (Priority: P1)

**Goal**: Root-level user NFRs are managed by the new skill but never judged, swept, or indexed as Highway library content.

**Independent Test**: Invoke the library validator on a temporary root-level NFR by relative and absolute paths, run catalog generation, and verify the NFR is declined by framework validation and absent from Highway catalogs while framework fixtures still pass.

### Tests for User Story 2

- [X] T016 [P] [US2] Add relative-path and absolute-path root containment assertions to `.highway/tools/tests/nfr-management.test.sh` for a temporary `library/governance/nfrs/NFR000001.md`.
- [X] T017 [P] [US2] Add user-content exclusion assertions to `.highway/tools/tests/nfr-management.test.sh` proving Highway catalog generators omit root-level NFR files and existing `.highway/` library fixtures retain their prior verdicts.

### Implementation for User Story 2 (US2)

- [X] T018 [US2] Extend `.highway/skills/highway-nfrs/SKILL.md` with the explicit user-owned boundary and the rule that Highway prose rules do not apply to NFR content.
- [X] T019 [US2] Verify `.highway/tools/validate-library.sh` resolves and rejects root-level NFR paths without regressing `.highway/tools/tests/fixtures/library/` classification; modify it only if the focused tests expose a gap.
- [X] T020 [US2] Run the containment and catalog-exclusion tests plus `.highway/tools/tests/validate-library.test.sh` and repair only the NFR boundary slice if needed.

**Checkpoint** (US2): User-owned NFR content is structurally outside the Highway library boundary and existing library fixtures remain valid.

## Phase 5: User Story 3 (US3) - Change the Baseline Without Unnamed Loss (Priority: P1)

**Goal**: Set and Remove name every NFR that would be lost, require confirmation, preserve `next_id`, and perform exactly one MAJOR increment only after confirmation.

**Independent Test**: Execute declined and accepted Remove and Set scenarios in isolated fixtures; compare file trees, catalog values, loss notices, and versions before and after confirmation.

### Tests for User Story 3

- [X] T021 [P] [US3] Add Remove confirmation tests to `.highway/tools/tests/nfr-management.test.sh` proving identifier-and-title loss naming, no-write refusal, file deletion after confirmation, unchanged `next_id`, and MAJOR versioning.
- [X] T022 [P] [US3] Add Set replacement tests to `.highway/tools/tests/nfr-management.test.sh` proving every absent NFR is named before confirmation, simultaneous additions/removals are handled, and refusal leaves the tree byte-identical.
- [X] T023 [P] [US3] Add identifier high-water tests to `.highway/tools/tests/nfr-management.test.sh` proving removal of the highest-numbered NFR never makes its ID available again.

### Implementation for User Story 3 (US3)

- [X] T024 [US3] Implement the Remove workflow in `.highway/skills/highway-nfrs/SKILL.md`, including named confirmation, file/catalog deletion, untouched `next_id`, and one MAJOR increment after confirmation.
- [X] T025 [US3] Implement the Set workflow in `.highway/skills/highway-nfrs/SKILL.md`, including complete loss enumeration, pre-write confirmation, replacement application, catalog regeneration, and one MAJOR increment.
- [X] T026 [US3] Add the no-write confirmation contract and exact loss-notice output shape to `.highway/skills/highway-nfrs/SKILL.md`, ensuring counts never replace identifier-and-title names.
- [X] T027 [US3] Run the declined and accepted Set/Remove tests and repair only destructive-action behavior until tree, catalog, version, and high-water assertions pass.

**Checkpoint** (US3): No accepted destructive action loses an NFR without naming it, and refusal is mutation-free.

## Phase 6: User Story 4 (US4) - Update an NFR Without Changing Its Identity (Priority: P2)

**Goal**: A maintainer can update an existing NFR while preserving its ID and untouched metadata and applying one PATCH increment when the obligation is unchanged.

**Independent Test**: Update statement, title, and rationale variants in isolated fixtures and verify ID preservation, metadata preservation, catalog regeneration, and version behavior.

### Tests for User Story 4

- [X] T028 [P] [US4] Add update-preservation assertions to `.highway/tools/tests/nfr-management.test.sh` for immutable ID, untouched metadata, and regenerated catalog index.
- [X] T029 [P] [US4] Add PATCH version assertions to `.highway/tools/tests/nfr-management.test.sh` for an obligation-preserving edit and exactly one increment per Update.

### Implementation for User Story 4 (US4)

- [X] T030 [US4] Implement the Update workflow in `.highway/skills/highway-nfrs/SKILL.md`, preserving ID and unrequested metadata while updating the requested definition.
- [X] T031 [US4] Define Update handling for obligation-preserving edits and route obligation-changing or ambiguous requests through the skill's clarification path in `.highway/skills/highway-nfrs/SKILL.md`.
- [X] T032 [US4] Run `.highway/tools/tests/nfr-management.test.sh` for User Story 4 and repair only identity, metadata, catalog, or PATCH behavior exposed by those tests.

**Checkpoint** (US4): Update is independently testable and never reassigns an NFR identity.

## Phase 7: User Story 5 (US5) - Classify and Advise Without Overruling (Priority: P2)

**Goal**: The skill distinguishes outcomes from Controls, advises on vague or similar NFRs, preserves author choice, and routes each misclassified statement to the other skill.

**Independent Test**: Submit outcome-shaped, Control-shaped, vague, and similar statements to both skills and verify the named advice, alternatives, destinations, and accepted author choice.

### Tests for User Story 5

- [X] T033 [P] [US5] Add NFR classification and advisory assertions to `.highway/tools/tests/governance-routing.test.sh` for outcome examples, Control-like examples, vague wording, and similar existing NFR naming.
- [X] T034 [P] [US5] Add reciprocal routing assertions to `.highway/tools/tests/governance-routing.test.sh` proving `/highway-controls` names `/highway-nfrs` for outcome-shaped statements.

### Implementation for User Story 5 (US5)

- [X] T035 [US5] Add the ordered NFR-versus-Control classification table and Control routing response to `.highway/skills/highway-nfrs/SKILL.md`.
- [X] T036 [US5] Add vague-NFR advice, at least one improved alternative, similar-NFR identifier/title naming, and explicit author-choice continuation to `.highway/skills/highway-nfrs/SKILL.md`.
- [X] T037 [US5] Add reciprocal NFR routing guidance to `.highway/skills/highway-controls/SKILL.md`, naming `/highway-nfrs` without populating relationship fields.
- [X] T038 [US5] Run `.highway/tools/validate-skill.sh` against both governance skills and the focused routing tests; repair normative count, citation, decision-table, or output-shape failures in this slice.

**Checkpoint** (US5): Classification is reciprocal and advisory; it does not become an unrequested relationship-management feature or refuse the author's chosen NFR.

## Phase 8: User Story 6 (US6) - Abort Ambiguous Requests Without Partial Writes (Priority: P1)

**Goal**: Ambiguous actions, missing references, missing catalogs, inconsistent state, and missing project roots abort with an explanation and no mutation.

**Independent Test**: Exercise each ambiguity and missing-input case in isolated fixtures and compare the complete tree before and after each request.

### Tests for User Story 6

- [X] T039 [P] [US6] Add ambiguous-action, ambiguous-target, and update-versus-replace no-write assertions to `.highway/tools/tests/nfr-management.test.sh`.
- [X] T040 [P] [US6] Add missing-reference and missing-catalog-with-existing-files assertions to `.highway/tools/tests/nfr-management.test.sh`, including the searched identifier/path in the response.
- [X] T041 [P] [US6] Add missing-project-root and inconsistent-catalog no-write assertions to `.highway/tools/tests/nfr-management.test.sh`.

### Implementation for User Story 6 (US6)

- [X] T042 [US6] Add the ordered ambiguity decision table and explicit abort-and-ask behavior to `.highway/skills/highway-nfrs/SKILL.md`.
- [X] T043 [US6] Add missing-reference, absent-catalog, missing-root, and inconsistent-state error handling to `.highway/skills/highway-nfrs/SKILL.md` without implicit creation or high-water-mark reconstruction.
- [X] T044 [US6] Run `.highway/tools/tests/nfr-management.test.sh` for User Story 6 and repair only the affected error-path wording or mutation guard behavior.

**Checkpoint** (US6): Every unresolved input condition is explicit, safely aborting, and independently verifiable.

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Complete distribution correspondence, verify generated outputs, validate the quickstart, and close all gates.

- [X] T045 [P] Regenerate the Highway catalog from `.highway/skills/highway-nfrs/SKILL.md` and `.highway/skills/highway-controls/SKILL.md` into `.highway/catalog/` and verify both entries are current.
- [X] T046 [P] Generate the `highway-nfrs` adapters under `.github/skills/highway-nfrs/`, `.claude/skills/highway-nfrs/`, and `.cursor/rules/highway-nfrs.mdc`.
- [X] T047 [P] Add or regenerate adapter manifest rows in `.highway/tools/.adapter-manifest` for all `highway-nfrs` adapters.
- [X] T048 [P] Add or regenerate distribution manifest rows in `.highway/tools/.distribution-manifest` for all `highway-nfrs` adapters and source artifacts.
- [X] T049 [P] Verify all generated paths and root-level governance paths are classified correctly in `.highway/tools/.distribution-manifest` and no user NFR file is included in the package.
- [X] T050 Run `.highway/tools/adapter-coverage.test.sh` and the generator correspondence checks, repairing stale generated artifacts rather than hand-editing them.
- [X] T051 Run the complete `.highway/tools/tests/run-all.sh` suite and record the final pass count and any unrelated pre-existing failures without weakening assertions.
- [X] T052 Run every applicable command in `specs/020-highway-nfrs/quickstart.md` against isolated temporary fixtures and remove all temporary user governance paths afterward.
- [X] T053 Run `.highway/tools/validate-skill.sh` on every changed skill and confirm P1-P8, X-rule, output-shape, and MUST-count requirements are satisfied.
- [X] T054 Confirm `.specify/feature.json` still points to `specs/020-highway-nfrs` and update no completed spec artifact after implementation begins.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependency; establishes source and focused-test entry points.
- **Foundational (Phase 2)**: Depends on Setup; blocks all user-story work because every story uses the shared artifact and mutation contract.
- **User Story 1 (Phase 3)**: Depends on Foundational; provides the MVP Add path and baseline artifacts.
- **User Story 2 (Phase 4)**: Depends on Foundational and can run alongside US1 after shared fixtures exist; validates the boundary independently.
- **User Story 3 (Phase 5)**: Depends on US1's catalog and identifier model; destructive actions require the Add-created baseline.
- **User Story 4 (Phase 6)**: Depends on US1's record model and catalog; can follow US3 or run in parallel with it when isolated fixtures are used.
- **User Story 5 (Phase 7)**: Depends on the skill skeleton from Foundational; reciprocal Controls routing is independent of mutation implementation but shares the governance test entry point.
- **User Story 6 (Phase 8)**: Depends on the shared mutation contract and catalog model; should follow the core actions so every abort path can be compared against a known mutation path.
- **Polish (Phase 9)**: Depends on all desired stories; generated artifacts must be refreshed only after both skills are final.

### User Story Dependencies

- **US1 (P1)**: Foundational only; MVP and first implementation target.
- **US2 (P1)**: Foundational only; independent containment slice.
- **US3 (P1)**: US1 for baseline fixtures and allocation semantics.
- **US4 (P2)**: US1 for record and catalog semantics.
- **US5 (P2)**: Foundational for skill text; US1 is useful for similar-NFR fixture data, but not structurally required.
- **US6 (P1)**: Foundational plus the action model from US1; isolated no-write scenarios prevent cross-story state coupling.

### Within Each User Story

- Focused tests are added before implementation and must fail for the missing behavior before the implementation task is considered complete.
- Shared artifact and state rules precede action-specific workflow text.
- Implementation precedes focused test execution and repair.
- A story checkpoint must pass before dependent stories begin.

## Parallel Execution Examples (Parallel Examples)

### After Foundational Phase

```text
Task T002: NFR behavior test entry point
Task T003: reciprocal routing test entry point
Task T009: shared temporary fixtures
```

These touch different files and can proceed in parallel.

### User Story 1

```text
Task T011: empty-baseline Add tests
Task T012: next_id Add tests
```

The tests can be written in parallel before T013; T015 remains sequential after implementation.

### User Story 3

```text
Task T021: Remove confirmation tests
Task T022: Set replacement tests
Task T023: high-water identifier tests
```

The isolated destructive scenarios can be authored in parallel; T024-T026 then implement their shared contract.

### User Story 5

```text
Task T033: NFR advice tests
Task T034: reciprocal Controls routing tests
Task T035: highway-nfrs classification table
Task T037: highway-controls reciprocal guidance
```

The two test files and two skill-file edits are separable until T038 validates both skills together.

### Final correspondence

```text
Task T045: catalog regeneration
Task T046: adapter generation
Task T047: adapter manifest rows
Task T048: distribution manifest rows
```

These generated-output tasks can proceed in parallel only when their generators do not target the
same files; otherwise run the repository generator once and validate all outputs together.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Implement Add, catalog generation, and high-water identifier handling.
3. Run the isolated US1 tests and validate the skill draft.
4. Stop at the US1 checkpoint for an independently demonstrable NFR baseline.

### Incremental Delivery

1. Add the containment boundary and verify existing fixtures remain green.
2. Add confirmed Set/Remove behavior and identifier retirement.
3. Add Update behavior and PATCH versioning.
4. Add classification advice and reciprocal routing.
5. Add ambiguity guards and no-write verification.
6. Regenerate all correspondence artifacts and run the complete suite.

### Parallel Team Strategy

1. One owner completes Setup and Foundational because those files define shared contracts.
2. After the foundation, one owner can implement US1 while another validates US2 containment.
3. A third owner can prepare US5 routing tests and the Controls guidance while US3/US4 use isolated fixtures.
4. Integrate all stories before running generator correspondence and the full suite.

## Notes

- Every task uses the required checkbox, sequential ID, optional `[P]` marker, story label where applicable, and an exact repository path.
- Tests are included because the feature plan and success criteria explicitly require focused governance/routing checks and a passing full suite.
- Root-level `library/governance/` artifacts are user-owned test fixtures and must be cleaned after validation; they are never added to Highway's distributed tree.
