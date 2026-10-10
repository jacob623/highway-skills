# Tasks: Profile Response Support Text

**Input**: Design documents from `/specs/157-profile-response-support-text/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Static-document-contract regression coverage is required by the feature success criteria. These checks do not claim runtime conversational evidence.

## Phase 1: Setup

**Purpose**: Establish the focused validation surface and preserve the clean baseline.

- [X] T001 Record the Feature 157 baseline and target paths in `.highway/tools/tests/feature-157-profile-response-support-text.test.sh` test comments, including the static-document-contract instrument class and declared artifact classes.

## Phase 2: Foundational

**Purpose**: Create the shared static assertions that all user-story slices rely on.

- [X] T002 [P] Add source-document and generated-artifact probe handling plus shared assertion helpers in `.highway/tools/tests/feature-157-profile-response-support-text.test.sh`.
- [X] T003 [P] Add assertions in `.highway/tools/tests/feature-157-profile-response-support-text.test.sh` that the Experience Standard remains unchanged and that Feature 155/156 Profile guidance and X2.69 remain present.

**Checkpoint**: The focused test structure is ready to detect missing source contracts, generated-adapter drift, and protected behavior changes.

---

## Phase 3: User Story 1 - Review a candidate with consistent support text (Priority: P1) 🎯 MVP

**Goal**: Centralize and render the candidate review elements in the required order with only the Validation Question emphasized.

**Independent Test**: The focused static contract passes its candidate-review assertions and fails when the support section, ordering, emphasis, or default question is removed or changed.

### Tests for User Story 1

- [X] T004 [US1] Add candidate-review assertions to `.highway/tools/tests/feature-157-profile-response-support-text.test.sh` for the `Response Support Text` section, default Validation Question, capture heading, ordering, applicable reassurance placement, and single emphasis rule.

### Implementation for User Story 1

- [X] T005 [US1] Insert the authoritative `##### Response Support Text` section and replace the candidate-review formatting guidance in `.highway/skills/highway-profile/SKILL.md` immediately between `##### Domain completeness` and `##### Advisory question scaffolding`.

**Checkpoint**: Profile candidate review has one authoritative rendering contract and remains independently statically verifiable.

---

## Phase 4: User Story 2 - Receive the appropriate discovery reassurance (Priority: P1)

**Goal**: Select Discovery, Acceptance, or Combined Reassurance according to whether the person is originating information or reacting to a meaningful starting point.

**Independent Test**: The focused static contract passes all reassurance-selection assertions, including Working Ideas and imported website evidence.

### Tests for User Story 2

- [X] T006 [P] [US2] Add reassurance-selection assertions to `.highway/tools/tests/feature-157-profile-response-support-text.test.sh` for no meaningful starting point, grounded Working Ideas, Acceptance Reassurance, Combined Reassurance, and the imported-evidence exception.

### Implementation for User Story 2

- [X] T007 [US2] Replace the first-Substantive-Contribution reassurance logic in `.highway/skills/highway-profile/SKILL.md` with the meaningful-starting-point rules and define the Acceptance, Discovery, and Combined Reassurance text in the authoritative support section.

**Checkpoint**: Reassurance selection no longer depends solely on whether a user Substantive Contribution has occurred.

---

## Phase 5: User Story 3 - Maintain one authoritative support-text owner (Priority: P1)

**Goal**: Remove duplicated behavioral definitions while preserving literal support wording in examples and protecting unrelated Profile behavior.

**Independent Test**: The focused static contract verifies canonical labels, retained literal examples, absent duplicated behavioral definitions, and unchanged out-of-scope guidance.

### Tests for User Story 3

- [X] T008 [US3] Add canonical-label, literal-example, duplicate-definition, and protected-boundary assertions to `.highway/tools/tests/feature-157-profile-response-support-text.test.sh`.

### Implementation for User Story 3

- [X] T009 [US3] Replace repeated behavioral definitions with the canonical Validation Question, Acceptance Reassurance, and Discovery Reassurance labels in `.highway/skills/highway-profile/SKILL.md`, retaining literal worked examples, transcript-style examples, illustrations, and example outputs.

**Checkpoint**: Profile has one maintainable support-text owner without changing advisory, structure-revealing, possibility-list, convergence, acceptance-boundary, or domain reasoning guidance.

---

## Phase 6: Polish & Cross-Cutting Concerns

- [X] T010 Regenerate all Profile adapters from `.highway/skills/highway-profile/SKILL.md` with `.highway/tools/generate-agent-adapters.sh` and verify `.github/skills/highway-profile/SKILL.md`, `.claude/skills/highway-profile/SKILL.md`, `.cursor/skills/highway-profile/SKILL.md`, and `.agents/skills/highway-profile/SKILL.md` are byte-identical.
- [X] T011 Run `.highway/tools/tests/feature-157-profile-response-support-text.test.sh` and record the passing static-document-contract result in the implementation completion notes.
- [X] T012 Run `.highway/tools/tests/run-all.sh` and confirm the final suite passes with no unrelated test weakening.
- [X] T013 Review `.highway/skills/highway-profile/SKILL.md`, generated adapters, and `.highway/tools/tests/feature-157-profile-response-support-text.test.sh` against `specs/157-profile-response-support-text/spec.md`, `plan.md`, and `quickstart.md`; verify no Experience Standard edit or protected behavior change was introduced.
- [X] T014 Align the Feature 157 specification, focused contract, and quickstart with the exact support-section placement and candidate-review ordering in `specs/157-profile-response-support-text/spec.md`, `.highway/tools/tests/feature-157-profile-response-support-text.test.sh`, and `.highway/skills/highway-profile/SKILL.md`.

## Dependencies

- T001 precedes T002-T003.
- T002-T003 precede the user-story test tasks.
- T004 precedes T005; T006 precedes T007; T008 precedes T009.
- T005, T007, and T009 must complete before T010.
- T010 precedes T011-T013.
- User stories are sequential because each updates the same Profile source and focused test; their validation remains independently scoped by assertion group.

## Parallel Opportunities

- T002 and T003 can proceed in parallel after T001 because they add independent assertion groups to the focused test.
- T006 can be prepared in parallel with T004 after the shared harness exists, provided edits are kept in distinct assertion sections.
- T010's adapter correspondence checks and the documentation review in T013 can be prepared in parallel after the source implementation is complete, while T011 and T012 remain sequential validation commands.

## Implementation Strategy

1. Establish the focused static contract and baseline protections.
2. Deliver User Story 1 as the MVP: centralized review ordering and emphasis.
3. Add User Story 2's reassurance selection rules.
4. Remove duplicated behavioral definitions for User Story 3 while preserving literal examples.
5. Regenerate adapters, run focused validation, run the full suite, and perform the protected-boundary review.
