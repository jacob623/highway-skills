---

description: "Implementation tasks for Controls Record Lineage Cleanup"
---

# Tasks: Controls Record Lineage Cleanup

**Input**: Design documents from `/specs/108-controls-record-lineage/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, and `quickstart.md`

**Tests**: Included because the specification requires focused verification and a passing full suite.

## Phase 1: Setup

**Purpose**: Establish the current canonical/generated artifact and validation boundaries.

- [X] T001 Record the current canonical Controls skill, Control-record template, generated adapters, catalog entries, and focused test expectations in `.highway/tools/tests/` before editing
- [X] T002 [P] Confirm the regeneration commands and generated-output paths in `.highway/tools/generate-agent-adapters.sh` and `.highway/tools/generate-library-catalog.sh`

---

## Phase 2: Foundational

**Purpose**: Update shared validation expectations before changing the canonical artifacts.

- [X] T003 Update `.highway/tools/tests/output-template.test.sh` to validate the versioned Recommendation Grounding Control-record contract and unchanged frontmatter/nfrs semantics
- [X] T004 Update `.highway/tools/tests/highway-controls-onboarding.test.sh` to assert Recommendation Grounding terminology and reject the removed legacy Provenance expectation

**Checkpoint**: Shared template and Controls contract checks describe the feature's intended end state.

---

## Phase 3: User Story 1 - Recommendation Grounding accurately represents lineage (Priority: P1) 🎯 MVP

**Goal**: Replace Provenance with an optional, body-only Recommendation Grounding section that records only materially influential recommendation sources.

**Independent Test**: Inspect and validate `control-record.md`; records with and without grounding preserve the existing frontmatter and distinguish accepted Control content from lineage.

### Implementation for User Story 1

- [X] T005 [US1] Update `.highway/library/templates/output/control-record.md` from metadata version `1.0.0` to `2.0.0` and rename `## Provenance` to `## Recommendation Grounding`
- [X] T006 [US1] Replace the old Control-record grounding placeholder and add guidance in `.highway/library/templates/output/control-record.md` distinguishing accepted Title, Statement, and Rationale from optional lineage
- [X] T007 [US1] Document in `.highway/library/templates/output/control-record.md` the material-influence condition, body-only placement, eligible Profile/Objective/Highway artifact/external expertise references, and external-grounding boundary
- [X] T008 [US1] Validate `.highway/library/templates/output/control-record.md` with `.highway/tools/validate-library.sh` and update any dependent template assertions in `.highway/tools/tests/output-template.test.sh`

**Checkpoint**: The Control-record template is a valid version-2.0.0 body-lineage contract with unchanged `id`, `title`, `status`, and identifier-only `nfrs` frontmatter.

---

## Phase 4: User Story 2 - Controls 4.0.0 retains precise grounding and ownership terminology (Priority: P1)

**Goal**: Align the canonical Controls skill with Recommendation Grounding terminology and preserve the simplified NFR ownership boundary.

**Independent Test**: Scan `.highway/skills/highway-controls/SKILL.md` for the corrected terminology, collection-result fields, retained revalidation paragraph, and 4.0.0/NFR contracts.

### Implementation for User Story 2

- [X] T009 [US2] Replace retained-grounding `Provenance` references with `Recommendation Grounding` in `.highway/skills/highway-controls/SKILL.md`, including verification and record-section references
- [X] T010 [US2] Update `.highway/skills/highway-controls/SKILL.md` to state that Recommendation Grounding is optional lineage retained only for materially influential recommendation sources and never organizational policy, applicability, certification, or compliance
- [X] T011 [US2] Preserve the four-field Controls collection result in `.highway/skills/highway-controls/SKILL.md` as Action Status, Collection Result, Next Action, and Blocking Reason without restoring `Created Control IDs`
- [X] T012 [US2] Preserve the simplified NFR handoff in `.highway/skills/highway-controls/SKILL.md`: invoke candidate generation once after a successfully created new Control while leaving candidate lifecycle ownership with NFRs

**Checkpoint**: The canonical Controls skill remains version `4.0.0` and expresses the corrected grounding and NFR ownership contracts.

---

## Phase 5: User Story 3 - Controls 4.0.0 corrections remove duplicate or superseded rules (Priority: P1)

**Goal**: Remove duplicated revalidation and local common-failure wording without changing authoritative persistence behavior.

**Independent Test**: Focused Controls tests find one authoritative revalidation path, no local failed-mutation sentence, no restored transient IDs, and the expected 4.0.0 metadata.

### Implementation for User Story 3

- [X] T013 [US3] Delete the first duplicated revalidation paragraph beginning `Before allocation, revalidate the authoritative baseline...` under Proposal and Persistence in `.highway/skills/highway-controls/SKILL.md`
- [X] T014 [US3] Retain the later revalidation paragraph beginning `Revalidate the authoritative baseline, catalog, allocation state, and final-proposal overlap before persistence...` in `.highway/skills/highway-controls/SKILL.md`
- [X] T015 [US3] Remove `A failed mutation cannot report success.` from `.highway/skills/highway-controls/SKILL.md` while retaining the Constitution as the common failure authority
- [X] T016 [US3] Confirm `.highway/skills/highway-controls/SKILL.md` remains version `4.0.0` and contains no `Created Control IDs` collection-result field

**Checkpoint**: Controls 4.0.0 has one domain-specific revalidation path and no duplicated common-failure or legacy collection-result language.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate distributed artifacts and prove the complete contract.

- [X] T017 [P] Regenerate `.github/skills/highway-controls/SKILL.md`, `.claude/skills/highway-controls/SKILL.md`, `.cursor/skills/highway-controls/SKILL.md`, and `.agents/skills/highway-controls/SKILL.md` with `.highway/tools/generate-agent-adapters.sh`
- [X] T018 [P] Regenerate `.highway/catalog/library-index.json` and `.highway/catalog/library-index.md` with `.highway/tools/generate-library-catalog.sh`
- [X] T019 Run `.highway/tools/validate-library.sh` for `.highway/library/templates/output/control-record.md` and `.highway/tools/validate-skill.sh` for `.highway/skills/highway-controls`
- [X] T020 Run the focused tests `.highway/tools/tests/output-template.test.sh`, `.highway/tools/tests/highway-controls-onboarding.test.sh`, `.highway/tools/tests/control-derived-nfr.test.sh`, and `.highway/tools/tests/generate-library-catalog.test.sh`
- [X] T021 Run the full suite with `.highway/tools/tests/run-all.sh` and resolve any regressions without changing the approved 4.0.0 or 2.0.0 contracts
- [X] T022 Run the feature quickstart validation in `specs/108-controls-record-lineage/quickstart.md` and verify generated artifacts match their canonical sources

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes the artifact and generator boundaries.
- **Foundational (Phase 2)**: Depends on Setup; updates assertions before implementation.
- **User Story 1 (Phase 3)**: Depends on Foundational; updates the shared Control-record contract.
- **User Story 2 (Phase 4)**: Depends on User Story 1; updates the canonical Controls grounding and ownership language.
- **User Story 3 (Phase 5)**: Depends on User Story 2 because it edits the same canonical Controls skill.
- **Polish (Phase 6)**: Depends on all canonical changes; regenerates and validates distributed artifacts.

### User Story Dependencies

- **US1 (P1)**: Depends on T003; independent of the Controls-skill wording changes after shared assertions are ready.
- **US2 (P1)**: Depends on US1 for the finalized retained-section terminology.
- **US3 (P1)**: Depends on US2 because both modify `.highway/skills/highway-controls/SKILL.md`.

### Parallel Opportunities

- T002 can run in parallel with T001.
- T003 and T004 can run in parallel because they update different test files.
- T017 and T018 can run in parallel after all canonical source edits are complete.
- T019 and T020 can run in parallel after regeneration.

## Parallel Example: Final Artifact Generation

```text
Task: Regenerate distributed skill adapters with .highway/tools/generate-agent-adapters.sh
Task: Regenerate the library catalog with .highway/tools/generate-library-catalog.sh
```

## Implementation Strategy

### MVP First

1. Complete T001-T004.
2. Complete T005-T008 for the Control-record contract.
3. Validate the template independently at the US1 checkpoint.

### Incremental Delivery

1. Complete US1 to establish the durable lineage contract.
2. Complete US2 to align Controls terminology and NFR ownership.
3. Complete US3 to remove duplicate/superseded runtime rules.
4. Regenerate distributed artifacts and run focused tests.
5. Run the full suite and quickstart validation.

## Notes

- Every task uses the required checkbox, sequential ID, optional `[P]` marker, story label where applicable, and exact repository path.
- Generated adapters and catalogs are outputs of the declared generators and must not be hand-edited.
- No task changes Control frontmatter, restores `Created Control IDs`, bumps `highway-controls` beyond `4.0.0`, or changes the NFR owner contract.
