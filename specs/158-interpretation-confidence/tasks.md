---

description: "Task list for implementing Profile interpretation confidence"
---

# Tasks: Interpretation Confidence

**Input**: Design documents from `/specs/158-interpretation-confidence/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), and [quickstart.md](quickstart.md)

**Tests**: Focused static document-contract validation is required by the feature's success criteria; full-suite regression validation is required before completion.

## Dependencies

- T001 enables the focused contract work.
- T002 must pass before source implementation tasks T003 and T005.
- T003 and T005 update the same authoritative source sequentially.
- T004 and T006 extend the same focused test sequentially after T002.
- T007 regenerates adapters after all source edits and before validation.
- T008 and T009 validate the completed implementation.

## Phase 1: Setup

- [X] T001 Confirm the Feature 158 source, generated adapter paths, test harness conventions, and existing protected Profile sections in `.highway/skills/highway-profile/SKILL.md`, `.highway/tools/generate-agent-adapters.sh`, and `.highway/tools/tests/`.

## Phase 2: Foundational Test Contract

- [X] T002 [US1] Add `.highway/tools/tests/feature-158-interpretation-confidence.test.sh` with executable static assertions for the requested subsection location, exact two-paragraph guidance, and absence of template placeholders.

## Phase 3: User Story 1 - Prefer a Grounded Interpretation (P1)

**Goal**: Profile prefers an evidence-supported interpretation over an unnecessary permission-seeking exploratory question.

**Independent test**: The focused contract passes the subsection placement and exact guidance assertions in T002.

- [X] T003 [US1] Insert the `##### Interpretation confidence` subsection between `##### Structure-revealing contributions` and `###### Organizational expression` in `.highway/skills/highway-profile/SKILL.md`, preserving existing structure-revealing guidance.

## Phase 4: User Story 2 - Clarify Consequential Uncertainty (P1)

**Goal**: The tie-breaker does not suppress clarification when accepted evidence and advisory reasoning cannot resolve consequential user-owned uncertainty.

**Independent test**: The focused contract proves the required verification statement and preserves the existing clarification-related Profile behavior.

- [X] T004 [US2] Extend `.highway/tools/tests/feature-158-interpretation-confidence.test.sh` with assertions for the required consequential-uncertainty verification statement and unchanged protected interaction references.
- [X] T005 [US2] Add the required verification statements to the authoritative Profile verification section in `.highway/skills/highway-profile/SKILL.md` without changing the Experience Standard or existing clarification contract.

## Phase 5: User Story 3 - Preserve Existing Profile Behavior (P1)

**Goal**: The change remains a Profile-local tie-breaker and preserves all named contribution, grounding, attribution, acceptance, convergence, and adapter contracts.

**Independent test**: The focused contract confirms protected sections/rules remain present and regenerated adapters match the authoritative source.

- [X] T006 [US3] Extend `.highway/tools/tests/feature-158-interpretation-confidence.test.sh` with protected-content assertions for Advisory Question Scaffolding, Contribution in Practice, Possibility-List Contribution Opportunities, Structure-Revealing Contributions, the bakery counter-example, and X2.4/X2.13/X2.42/X2.65/X2.68/X2.69 references.
- [X] T007 [US3] Regenerate `.github/skills/highway-profile/SKILL.md`, `.claude/skills/highway-profile/SKILL.md`, `.cursor/skills/highway-profile/SKILL.md`, and `.agents/skills/highway-profile/SKILL.md` using `.highway/tools/generate-agent-adapters.sh`.

## Phase 6: Polish and Validation

- [X] T008 Run `.highway/tools/tests/feature-158-interpretation-confidence.test.sh` and repair only Feature 158 failures until it passes.
- [X] T009 Run `.highway/tools/tests/run-all.sh` and confirm the full suite passes without changing unrelated user work.
- [X] T010 Verify all Feature 158 requirements and success criteria against the implementation, confirm the task list is complete, and run `git diff --check`.

## Parallel Opportunities

- T002 can be prepared independently of source editing after T001.
- No later tasks are parallelized because T004/T006 and T005/T007 touch shared files or have direct ordering dependencies.

## Implementation Strategy

1. Establish the focused static contract before changing the source.
2. Implement the Profile subsection and verification text while preserving all protected behavior.
3. Regenerate adapters from the authoritative source.
4. Run focused validation, then the full suite, and reconcile the requirements and task checklist.

**Suggested MVP**: User Story 1, including T001-T003 and the focused placement/guidance assertions.
