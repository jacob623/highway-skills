---
description: "Task list for structure-revealing advisory contributions"
---

# Tasks: Structure-Revealing Advisory Contributions

**Input**: Design documents from `specs/156-structure-revealing-advisory-contributions/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `quickstart.md`

**Tests**: Required by the feature specification and implementation plan. Static-document evidence must remain distinct from runtime conversational evidence.

**Organization**: Tasks are grouped by user story and ordered so the focused test is written and observed failing before Profile guidance is implemented.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Confirm the existing source, generated-artifact, and test boundaries.

- [X] T001 [P] Confirm the Feature 156 source, adapter, generator, and test paths against `specs/156-structure-revealing-advisory-contributions/plan.md` and `.highway/tools/generate-agent-adapters.sh`.
- [X] T002 [P] Record the existing Profile guidance anchors that Feature 156 must preserve in `.highway/skills/highway-profile/SKILL.md` and `.highway/governance/experience-standard.md`.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the focused static-document contract before editing the shipped Profile source.

**Checkpoint**: The focused test exists, declares `static-document-contract`, and fails because the new guidance is absent.

- [X] T003 Create the Feature 156 focused static-document contract test in `.highway/tools/tests/feature-156-structure-revealing-advisory-contributions.test.sh`, covering structure preference, connected-chain behavior, rejection of branching and strategic leaps, and preservation of existing guidance.
- [X] T004 Run `bash .highway/tools/tests/feature-156-structure-revealing-advisory-contributions.test.sh` and record the expected failure before implementing the Profile guidance.

---

## Phase 3: User Story 1 - See Structure in Accepted Material (Priority: P1) 🎯 MVP

**Goal**: Profile prefers an existing contribution type that reveals supported structure instead of summarizing accepted evidence.

**Independent Test**: The focused contract test passes the structure-revelation assertions and rejects restatement, reorganization, relabeling, paraphrase, and synonym replacement as sufficient contributions.

### Implementation for User Story 1

- [X] T005 [US1] Add a separate structure-revealing guidance section to `.highway/skills/highway-profile/SKILL.md` that defines supported structure, prioritizes structure before extension, and states that the behavior uses existing contribution types.
- [X] T006 [US1] Add the structure-revealing examples and negative boundaries to `.highway/skills/highway-profile/SKILL.md` without changing the existing advisory scaffolding, ordering preference, anti-paraphrase guidance, tradeoff exemplar, contribution exemplars, or bakery counter-example.

**Checkpoint**: User Story 1 is independently testable through the focused static-document contract test.

---

## Phase 4: User Story 2 - Extend Through One Connected Chain (Priority: P1)

**Goal**: Profile may continue from revealed structure through directly derived implication, possibility, or tradeoff without branching or making a strategic leap.

**Independent Test**: The focused contract test passes for structure → implication, structure → implication → possibility/tradeoff, and rejects independent alternatives, recommendation sets, and detached extensions.

### Implementation for User Story 2

- [X] T007 [US2] Add connected advisory-chain guidance to `.highway/skills/highway-profile/SKILL.md`, requiring each step to derive from the immediately preceding step and permitting structure → implication → possibility or tradeoff as one move.
- [X] T008 [US2] Add explicit no-branching, no-recommendation-set, no-opportunity-catalog, and no-consultant-leap boundaries to the Feature 156 section in `.highway/skills/highway-profile/SKILL.md`.

**Checkpoint**: User Stories 1 and 2 are independently testable through the focused static-document contract test.

---

## Phase 5: User Story 3 - Preserve Existing Contracts (Priority: P1)

**Goal**: The new Profile guidance remains compatible with existing Experience Standard and Profile interaction contracts.

**Independent Test**: The focused test verifies the Experience Standard remains unchanged, named existing guidance remains present, Profile remains the sole source owner, and generated adapters match the source after regeneration.

### Implementation for User Story 3

- [X] T009 [US3] Verify and preserve the existing Experience Standard and named Profile guidance in `.highway/governance/experience-standard.md` and `.highway/skills/highway-profile/SKILL.md`; make no edits to those protected passages.
- [X] T010 [US3] Regenerate the declared Profile adapters from `.highway/skills/highway-profile/SKILL.md` using `.highway/tools/generate-agent-adapters.sh` and verify `.github/skills/highway-profile/SKILL.md`, `.claude/skills/highway-profile/SKILL.md`, `.cursor/skills/highway-profile/SKILL.md`, and `.agents/skills/highway-profile/SKILL.md` match the source.

**Checkpoint**: All three user stories are independently covered by focused static-document checks and generated-artifact correspondence.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Run the documented validation path and confirm requirement coverage without claiming runtime behavior evidence.

- [X] T011 [P] Run `bash .highway/tools/tests/feature-156-structure-revealing-advisory-contributions.test.sh` and confirm the focused delivery contract passes.
- [X] T012 Run `bash .highway/tools/tests/adapter-coverage.test.sh` and confirm generated-artifact correspondence passes.
- [X] T013 Run `bash .highway/tools/tests/run-all.sh` and confirm the full verification suite reports zero failed tests.
- [X] T014 [P] Run the commands in `specs/156-structure-revealing-advisory-contributions/quickstart.md` and confirm each expected validation outcome.
- [X] T015 [P] Review `git diff --check` and verify the final changed-file scope contains only Feature 156 artifacts, Profile source/adapters, the focused test, and required generated manifests.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No implementation dependency; establishes source and protected anchors.
- **Foundational (Phase 2)**: Depends on Setup; blocks Profile edits until the focused test has been observed failing.
- **User Story 1 (Phase 3)**: Depends on Foundational; provides the MVP structure-revelation guidance.
- **User Story 2 (Phase 4)**: Depends on User Story 1 because the connected chain extends the structure guidance.
- **User Story 3 (Phase 5)**: Depends on User Stories 1 and 2 because adapter regeneration and preservation checks cover the complete new section.
- **Polish (Phase 6)**: Depends on all user-story work and adapter regeneration.

### User Story Dependencies

- **User Story 1 (P1)**: Starts after T004; no dependency on another story.
- **User Story 2 (P1)**: Starts after T006; extends User Story 1's new guidance section.
- **User Story 3 (P1)**: Starts after T008; validates preservation and generated outputs for the complete feature.

### Parallel Opportunities

- T001 and T002 can run in parallel during Setup.
- T011, T012, T014, and T015 can run in parallel after T010, provided no command mutates generated artifacts during the checks.
- User stories are conceptually independently testable, but US2 edits the same Profile section introduced by US1 and therefore are sequenced to avoid file conflicts.

## Parallel Example: Setup

```text
Task T001: Confirm Feature 156 source, adapter, generator, and test paths.
Task T002: Record protected Profile and Experience Standard anchors.
```

## Parallel Example: Final Validation

```text
Task T011: Run the focused Feature 156 contract test.
Task T012: Run adapter-coverage.test.sh.
Task T014: Run quickstart.md validation commands.
Task T015: Review diff check and final file scope.
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Implement the separate structure-revealing guidance for User Story 1.
3. Run the focused contract test at the User Story 1 checkpoint.
4. Continue to User Story 2 because the connected chain is part of the requested advisor behavior.

### Incremental Delivery

1. Add structure-revelation guidance and validate it.
2. Add connected-chain and anti-branching guidance and validate it.
3. Preserve existing contracts, regenerate adapters, and run the full suite.
4. Report static-document verification separately from runtime conversational evidence.

## Notes

- Every task has a checkbox, sequential ID, required story label where applicable, and an exact file path.
- No contracts directory is required because this feature exposes no external API or command interface.
- Runtime transcript quality remains outside the evidence provided by static-document tests.
