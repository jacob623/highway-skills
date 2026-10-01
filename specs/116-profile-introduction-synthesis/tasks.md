---

description: "Task list for Profile 5.1.0 introduction and synthesis"
---

# Tasks: Profile Introduction and Synthesis

**Input**: Design documents from `/specs/116-profile-introduction-synthesis/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), and [quickstart.md](quickstart.md)

**Tests**: Contract tests are required because the feature specification explicitly requires verification updates and the repository constitution requires tests for behavioral changes.

## Phase 1: Setup

**Purpose**: Establish the existing contract baseline before changing the distributed Profile skill.

- [X] T001 Run the existing repository suite from `.highway/tools/tests/run-all.sh` and record the baseline result before implementation.
- [X] T002 Review the authoritative Profile contract and retained template in `.highway/skills/highway-profile/SKILL.md` and `.highway/library/templates/output/profile-record.md` against the Feature 116 data model.
- [X] T003 [P] Confirm the generated Profile copies and catalog inputs in `.github/skills/highway-profile/SKILL.md`, `.claude/skills/highway-profile/SKILL.md`, `.cursor/skills/highway-profile/SKILL.md`, `.agents/skills/highway-profile/SKILL.md`, and `.highway/catalog/index.md` are the current baseline.

---

## Phase 2: Foundational

**Purpose**: Lock the unchanged ownership, schema, and shared-interaction boundaries before story-specific changes.

- [X] T004 Add or amend invariant assertions in `.highway/tools/tests/profile-structure.test.sh` and `.highway/tools/tests/profile-context-contract.test.sh` for schema 3.0.0, four readiness domains, `not_discussed`/`discussed`/`bounded`, Profile ownership, and the exact Experience Standard sentence.
- [X] T005 [P] Add the Feature 116 version expectation and preserved canonical-question assertions to `.highway/tools/tests/feature-092-contract.test.sh` without duplicating generic Experience Standard rules.
- [X] T006 [P] Confirm `.highway/library/templates/output/profile-record.md`, `.highway/skills/highway-setup/SKILL.md`, `.highway/governance/experience-standard.md`, Highway Profile Intent Summary, and Brownfield Onboarding Idea remain out of scope in the implementation work.

**Checkpoint**: Existing retained structure and shared ownership boundaries are protected before the new interaction is implemented.

---

## Phase 3: User Story 1 - Explain Profile Collection Once (Priority: P1) MVP

**Goal**: Emit the exact Profile introduction once for first-time setup before the unchanged Repository Name question, while suppressing it for configure, resume, and later turns.

**Independent Test**: Run `.highway/tools/tests/profile-behavior.test.sh` and confirm the required heading/sentence precede the Repository Name question exactly once for an absent Profile and are absent for an existing Profile flow.

### Tests for User Story 1

- [X] T007 [US1] Add failing assertions for introduction content, ordering, one-time emission, and configure/resume suppression in `.highway/tools/tests/profile-behavior.test.sh`.

### Implementation for User Story 1

- [X] T008 [US1] Add the first-time introduction and its absent-Profile-only boundary to the `## Acquisition` section of `.highway/skills/highway-profile/SKILL.md` immediately before the existing Repository Name question.
- [X] T009 [US1] Verify the existing Repository Name question and supporting sentence remain byte-for-byte unchanged after the introduction in `.highway/skills/highway-profile/SKILL.md`.

**Checkpoint**: The first-time Profile introduction is independently testable without changing recommendation or retained-data behavior.

---

## Phase 4: User Story 2 - Review Cohesive Domain Recommendations (Priority: P1)

**Goal**: Replace multi-fragment enrichment guidance with one evidence-grounded paragraph recommendation for Vision, Competitive Path, and Guiding Principles, while preserving hidden categories and canonical fallback.

**Independent Test**: Run the focused behavior, structure, and Feature 092 contract tests and confirm all three paragraph lead-ins, evidence-only grounding, hidden categories, single review boundary, and canonical fallback are represented.

### Tests for User Story 2

- [X] T010 [P] [US2] Add failing assertions for the Vision, Competitive Path, and Guiding Principles paragraph lead-ins, one-paragraph shape, hidden grounding categories, and canonical fallback in `.highway/tools/tests/profile-behavior.test.sh`.
- [X] T011 [P] [US2] Amend category and non-persistence assertions for cohesive recommendations in `.highway/tools/tests/profile-structure.test.sh` and `.highway/tools/tests/feature-092-contract.test.sh`.

### Implementation for User Story 2

- [X] T012 [US2] Rewrite the Profile-specific enrichment guidance in `## Enrichment` of `.highway/skills/highway-profile/SKILL.md` to require one concise grounded paragraph per supported domain and preserve the internal category lists without exposing or retaining their names.
- [X] T013 [US2] Add the three semantic paragraph lead-ins and the evidence-only/canonical-fallback rules to `.highway/skills/highway-profile/SKILL.md`, referring generic acceptance and presentation behavior to the Experience Standard.

**Checkpoint**: Each enrichment domain has a cohesive, independently reviewable recommendation contract with a tested fallback.

---

## Phase 5: User Story 3 - Compound Accepted Evidence Safely (Priority: P1)

**Goal**: Preserve recommendation-first processing, accepted-evidence state transitions, save-before-result persistence, and completion synthesis while integrating accepted paragraph recommendations.

**Independent Test**: Run Profile behavior and context-contract tests to confirm accepted paragraph evidence establishes `discussed`, explicit boundaries establish `bounded`, unsupported proposals remain transient, persistence precedes dependent results, and completion emits the existing synthesis.

### Tests for User Story 3

- [X] T014 [P] [US3] Add failing assertions for paragraph acceptance, clarification-not-acceptance, `discussed`/`bounded` transitions, optional-enrichment behavior, and no repeated canonical question in `.highway/tools/tests/profile-behavior.test.sh`.
- [X] T015 [P] [US3] Extend `.highway/tools/tests/profile-context-contract.test.sh` with the Feature 116 evidence lifecycle and save-before-result assertions.

### Implementation for User Story 3

- [X] T016 [US3] Update `## Profile model`, `## Acquisition`, and `## Operations` in `.highway/skills/highway-profile/SKILL.md` so accepted paragraph recommendations participate in all-four-domain re-evaluation, preserve proposal boundaries, and persist before dependent results.
- [X] T017 [US3] Preserve and explicitly connect the existing completion synthesis, readiness-state semantics, optional-enrichment rules, and no-post-write-verification rule in `.highway/skills/highway-profile/SKILL.md`.

**Checkpoint**: Accepted evidence and paragraph recommendations compound safely without changing retained schema or readiness semantics.

---

## Phase 6: User Story 4 - Preserve the Retained Profile Contract (Priority: P2)

**Goal**: Publish Profile 5.1.0 with synchronized generated copies and catalogs while preserving the retained schema, shared Experience boundary, and out-of-scope documents.

**Independent Test**: Run all focused Profile checks, regenerate outputs, compare all copies, and run the full suite with no changes to the retained template or deferred governance artifacts.

### Tests for User Story 4

- [X] T018 [P] [US4] Update version and unchanged-schema assertions to 5.1.0 in `.highway/tools/tests/profile-behavior.test.sh`, `.highway/tools/tests/profile-structure.test.sh`, and `.highway/tools/tests/feature-092-contract.test.sh`.
- [X] T019 [P] [US4] Add verification assertions for synchronized copies, exact Experience wording, and unchanged out-of-scope artifacts in `.highway/tools/tests/profile-context-contract.test.sh`.

### Implementation for User Story 4

- [X] T020 [US4] Set the Profile frontmatter version to 5.1.0 and retain the exact Experience section in `.highway/skills/highway-profile/SKILL.md`.
- [X] T021 [US4] Run `.highway/tools/generate-agent-adapters.sh` to regenerate `.github/skills/highway-profile/SKILL.md`, `.claude/skills/highway-profile/SKILL.md`, `.cursor/skills/highway-profile/SKILL.md`, and `.agents/skills/highway-profile/SKILL.md` from the authoritative source.
- [X] T022 [US4] Run `.highway/tools/generate-catalog.sh` to update `.highway/catalog/index.md` and `.highway/catalog/index.json` for Profile 5.1.0.

**Checkpoint**: The Profile 5.1.0 source, generated copies, catalogs, tests, and retained contract are synchronized.

---

## Phase 7: Polish & Cross-Cutting Validation

**Purpose**: Prove the complete feature and leave no generated or formatting drift.

- [X] T023 [P] Run all focused Profile checks listed in `specs/116-profile-introduction-synthesis/quickstart.md`.
- [X] T024 [P] Compare every generated Profile copy with `.highway/skills/highway-profile/SKILL.md` using the four `diff` commands in `specs/116-profile-introduction-synthesis/quickstart.md`.
- [X] T025 Run `.highway/tools/tests/run-all.sh` and `git diff --check`, then record requirement coverage separately from check results.
- [X] T026 Confirm the final diff does not modify `.highway/library/templates/output/profile-record.md`, `.highway/skills/highway-setup/SKILL.md`, `.highway/governance/experience-standard.md`, or the two stale follow-up documents.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establish baseline first.
- **Foundational (Phase 2)**: Depends on Setup and protects unchanged contracts; blocks story implementation.
- **User Story 1 (Phase 3)**: Depends on Foundational; MVP and first interaction boundary.
- **User Story 2 (Phase 4)**: Depends on User Story 1 because both modify the authoritative Profile acquisition/enrichment contract.
- **User Story 3 (Phase 5)**: Depends on User Story 2 because persistence and state handling must integrate accepted paragraphs.
- **User Story 4 (Phase 6)**: Depends on User Story 3 before version bump and generated synchronization.
- **Polish (Phase 7)**: Depends on all implementation phases.

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational; no dependency on later stories.
- **User Story 2 (P1)**: Starts after US1 because both edit the same Profile skill, but its tests can be prepared in parallel with US1 implementation.
- **User Story 3 (P1)**: Starts after US2 because accepted paragraph recommendations must exist before their persistence/state contract is finalized.
- **User Story 4 (P2)**: Starts after US3 because generated artifacts must reflect the completed source contract.

### Parallel Opportunities

- T003, T005, and T006 can run in parallel during setup/foundation.
- T010 and T011 can run in parallel because they touch separate test surfaces.
- T014 and T015 can run in parallel because they touch separate test surfaces.
- T018 and T019 can run in parallel before the final source version update.
- T023 and T024 can run in parallel after generation; T025 follows both.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Add failing introduction assertions.
3. Implement the one-time first-time introduction.
4. Run the US1 focused test and stop for independent validation.

### Incremental Delivery

1. Add US1 introduction behavior.
2. Add US2 cohesive paragraph recommendations and fallback.
3. Add US3 evidence lifecycle and persistence integration.
4. Add US4 version, generated copies, and catalogs.
5. Run the complete quickstart and repository suite.

## Notes

- Every task has a checkbox, sequential ID, required story label where applicable, and an exact repository path.
- Tests are written before the corresponding implementation tasks and must be observed failing before behavior is marked complete.
- No external API contracts are generated because this feature changes an internal Markdown skill contract and its Bash verification only.
