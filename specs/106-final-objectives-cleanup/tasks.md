---

description: "Task list for completing the highway-objectives 3.0.0 contract"
---

# Tasks: Final Objectives Cleanup

**Input**: Design documents from `specs/106-final-objectives-cleanup/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required. The specification changes live Objective terminology and Rationale behavior. Each new or replaced assertion must fail against the current source before the source edit that makes it pass.

**Organization**: The source Objectives skill is shared by all stories, so source edits remain sequential. Focused test files can be amended in parallel when they do not overlap.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel when files and dependencies are independent
- **[Story]**: User story label
- Setup, foundational, and polish tasks have no story label

## Phase 1: Setup

**Purpose**: Confirm the current 3.0.0 source and its remaining legacy wording.

- [X] T001 Confirm `.highway/skills/highway-objectives/SKILL.md` is version 3.0.0, still contains the old Profile Blocked wording, remaining Outcome/Significance terminology, and the malformed or legacy Rationale behavior. Confirm `.highway/library/templates/output/objective-record.md` remains unchanged with version 1.0.0, `## Statement`, `## Success Measures`, and `## Rationale`. Do not edit the record template, governance documents, Profile skill, or generators.

## Phase 2: Foundational

**Purpose**: Establish a passing baseline before test changes.

- [X] T002 Run `.highway/tools/tests/run-all.sh` with unrestricted filesystem access from the repository root and record exit 0 before editing this feature. Do not edit the Objectives skill or record template in this task.

**Checkpoint**: The full suite is green before focused contract changes.

## Phase 3: User Story 1 - Profile and discovery terminology are consistent (Priority: P1) 🎯 MVP

**Goal**: Correct Profile result wording and remove remaining legacy discovery terminology.

**Independent Test**: Focused tests require the exact Profile-owned Blocked sentence, distinguish unavailable Profile, use Business Objective terminology, and reject Significance as a discovery requirement.

### Tests for User Story 1

- [X] T003 [US1] Amend `.highway/tools/tests/objective-management.test.sh` to require the exact Profile-owned Blocked sentence, `recommendations, Highway Relevance, or Rationale`, Business Objective evidence, and the corrected overlap terminology; reject remaining Significance discovery requirements and the old Outcome evidence wording. Run it and confirm it fails before the source skill is edited.
- [X] T004 [P] [US1] Amend `.highway/tools/tests/highway-ux-alignment.test.sh` to require Business Objective and Highway Relevance wording for `highway-objectives` while preserving the existing Success and review checks. Comment that Outcome evidence was superseded. Run it and confirm it fails before the source skill is edited.

### Implementation for User Story 1

- [X] T005 [US1] Update `.highway/skills/highway-objectives/SKILL.md` so Profile context says recommendations, Highway Relevance, and Rationale; replace the blocked wording with `A Profile-owned Blocked result blocks Objective behavior that depends on accepted Profile evidence.`; keep unavailable Profile distinct; replace Outcome evidence and staged Outcome/Success/Significance wording with Business Objective, Success, and Highway Relevance; remove every Significance collection requirement. Re-run the focused tests and confirm they pass.

**Checkpoint**: No legacy discovery dimension remains, and the skill remains version 3.0.0.

## Phase 4: User Story 2 - Business Objective and Success make review ready (Priority: P1)

**Goal**: Make Business Objective plus Success sufficient for review unless one useful Highway Relevance question remains.

**Independent Test**: The skill presents review after Statement and at least one Success Measure, asks Highway Relevance only when useful, and never blocks creation solely because Highway Relevance is absent.

### Tests for User Story 2

- [X] T006 [US2] Amend `.highway/tools/tests/objective-management.test.sh` to require the exact review-ready condition, non-blocking Highway Relevance wording, and absence of a separate Rationale requirement. Run it and confirm it fails before the source skill is edited.

### Implementation for User Story 2

- [X] T007 [US2] Update `.highway/skills/highway-objectives/SKILL.md` so the proposal-ready condition is `When Business Objective evidence supports a Statement and Success evidence supports at least one Success Measure, present the Objective review.` Ask Highway Relevance only when unresolved information would improve downstream use. Synthesize Rationale and proceed when no useful relevance question is warranted. Keep Highway Relevance non-persisted and the record template unchanged. Re-run the focused Objective test and confirm it passes.

**Checkpoint**: Business Objective and Success are the required retained-content evidence.

## Phase 5: User Story 3 - Rationale is synthesized and presented correctly (Priority: P1)

**Goal**: Synthesize Rationale from accepted evidence and use the exact review structure.

**Independent Test**: The exact captured-content review is present, malformed `Why it matters` formatting is absent, and no separate Rationale question is required.

### Tests for User Story 3

- [X] T008 [US3] Amend `.highway/tools/tests/objective-management.test.sh` to require the exact captured-content review, synthesized Rationale wording, accepted-evidence-only sourcing, and the absence of a fourth `Why it matters` discovery dimension or separate Rationale question. Run it and confirm it fails before the source skill is edited.
- [X] T009 [P] [US3] Add or amend focused assertions in `.highway/tools/tests/objective-management.test.sh` for rejection of `**Why it matters:**[` and preservation of `## Rationale` in the unchanged record template. Run it and confirm the malformed-format assertion fails before the source skill is edited.

### Implementation for User Story 3

- [X] T010 [US3] Update `.highway/skills/highway-objectives/SKILL.md` so Rationale is synthesized only from accepted Business Objective, Success, Highway Relevance, and applicable accepted Profile evidence; exclude Highway Identity, Highway Vision, and Highway Platform Objectives as organizational facts; use concise supported rationale without another question; and render the exact review with `**Why it matters:**` followed by Rationale. Remove malformed formatting and keep the selected-recommendation review exemption. Re-run focused tests and confirm they pass.

**Checkpoint**: Rationale remains retained but is no longer a discovery dimension.

## Phase 6: User Story 4 - Recommendation-created Objectives use accepted evidence (Priority: P1)

**Goal**: Capture selected recommendations without redundant confirmation or a separate Rationale question.

**Independent Test**: Selected recommendations produce Statement, Success Measures, and Rationale only from recommendation evidence; missing required Success causes only a Success question.

### Tests for User Story 4

- [X] T011 [US4] Amend `.highway/tools/tests/objective-management.test.sh` to require recommendation-created Rationale sourcing, no redundant confirmation, no separate Rationale question, and a Success-only follow-up when a recommendation lacks required Success evidence. Run it and confirm it fails before the source skill is edited.

### Implementation for User Story 4

- [X] T012 [US4] Update `.highway/skills/highway-objectives/SKILL.md` so selected recommendations create Statement, Success Measures, and Rationale only from the recommendation and its grounding evidence; skip confirmation and separate Rationale questioning; ask only unresolved Success information when required; and preserve the user-authored alternative. Re-run focused Objective tests and confirm they pass.

**Checkpoint**: Recommendation selection remains acceptance under the Experience Standard.

## Phase 7: Polish and Cross-Cutting Validation

**Purpose**: Validate the completed contract, generated artifacts, and repository-wide suite.

- [X] T013 Run `.highway/tools/validate-skill.sh .highway/skills/highway-objectives` and confirm no skill rules are unchecked.
- [X] T014 Run `.highway/tools/generate-agent-adapters.sh` twice and confirm the second run is byte-stable. Regenerate the declared catalogs and confirm `highway-objectives` remains version 3.0.0. Do not hand-edit generated copies.
- [X] T015 [P] Walk steps 3 through 5 of `specs/106-final-objectives-cleanup/quickstart.md`. Confirm the Objective record template, Experience Standard, Skills Constitution, development constitution, Profile skill, and Objective catalog template are unchanged.
- [X] T016 Run `.highway/tools/tests/run-all.sh` with unrestricted filesystem access and confirm exit 0.

## Dependencies and Execution Order

### Phase Dependencies

- Setup T001 precedes Foundational T002.
- Foundational T002 blocks all user-story work.
- User Stories 1–4 proceed sequentially because they edit the same Objectives skill and focused contract test.
- Polish begins after User Story 4.

### User Story Dependencies

- US1 is the MVP and starts after T002.
- US2 follows US1 because it changes the same discovery and review-ready section.
- US3 follows US2 because it changes the same review and Rationale behavior.
- US4 follows US3 because recommendation-created Rationale depends on the finalized synthesis rules.

### Parallel Opportunities

- T003 and T004 can run in parallel.
- T008 and T009 can run in parallel after US2.
- T015 can run in parallel with T014 and T016 after source implementation.

## Parallel Example: User Story 1

```text
Task: Amend .highway/tools/tests/objective-management.test.sh for Profile and discovery terminology
Task: Amend .highway/tools/tests/highway-ux-alignment.test.sh for Business Objective and Highway Relevance
```

## Implementation Strategy

### MVP First

1. Complete T001 and T002.
2. Complete US1.
3. Validate that Profile wording and discovery terminology are corrected.

### Incremental Delivery

1. Add US2 for the Business Objective + Success review boundary.
2. Add US3 for synthesized Rationale and exact review presentation.
3. Add US4 for recommendation-created Objectives.
4. Run validation, regenerate adapters and catalogs, and run the full suite.

## Notes

- Every task has a checkbox, sequential ID, required story label where applicable, and an exact file path.
- Do not bump highway-objectives beyond 3.0.0.
- Do not edit `objective-record.md`; its Statement, Success Measures, and Rationale structure remains authoritative.
