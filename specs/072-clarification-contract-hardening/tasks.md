# Tasks: Clarification Contract Hardening

**Input**: Design documents from `specs/072-clarification-contract-hardening/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/clarification-contract-hardening.md`, and `quickstart.md`

**Tests**: Included because the feature specification requires executable verification of version alignment, source filtering, precedence, conflict states, traceability, lifecycle, ownership, immutability, and no-partial-write behavior.

**Organization**: Tasks are grouped by the three P1 user stories. The stories share the canonical skill, output template, and focused contract test, so implementation proceeds in dependency order while each story retains an independent acceptance checkpoint.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the implementation baseline and identify the canonical and generated contract surfaces.

- [X] T001 Record the current baseline for `.highway/tools/tests/highway-clarify.test.sh`, `.highway/tools/validate-skill.sh`, `.highway/tools/validate-library.sh`, and `.highway/tools/tests/run-all.sh` before changing the Clarification contract.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Prepare disposable fixtures and shared assertions required by all three stories.

- [X] T002 [P] Inventory the canonical, shared-template, generated-adapter, catalog, and focused-test paths for Feature 072 in `.highway/skills/highway-clarify/SKILL.md`, `.highway/library/templates/output/clarification-record.md`, `.github/skills/highway-clarify/SKILL.md`, `.claude/skills/highway-clarify/SKILL.md`, `.cursor/rules/highway-clarify.mdc`, and `.highway/tools/tests/highway-clarify.test.sh`.
- [X] T003 [P] Add disposable fixture helpers and reusable assertions for version, fingerprint/category identity, source traceability, ownership boundaries, and no-partial-write behavior in `.highway/tools/tests/highway-clarify.test.sh` without weakening existing Feature 071 probes.

**Checkpoint**: Canonical paths and isolated assertions are ready; user-story work can proceed without touching user-owned artifacts.

## Phase 3: User Story 1 - Read a Consistent Clarification Record (Priority: P1)

**Goal**: Align the retained record version with the skill contract and make finding category/fingerprint identity consistent.

**Independent Test**: Generate representative open and resolved findings, then verify both canonical metadata declarations are `2.0.0`, category `missing_input` matches its fingerprint category segment, and invalid mismatches produce no partial write.

### Tests for User Story 1

- [X] T004 [US1] Add focused probes for skill/template version alignment, resolved-guidance retention, matching `missing_input` fingerprint identity, and rejected category/fingerprint mismatch in `.highway/tools/tests/highway-clarify.test.sh`.

### Implementation for User Story 1

- [X] T005 [US1] Update the retained record metadata and representative finding examples to version `2.0.0` and matching `missing_input|requirements|REQ000001:field` identity in `.highway/library/templates/output/clarification-record.md`.
- [X] T006 [US1] Update the canonical version and identity-validation wording, while preserving Feature 071 guidance and lifecycle behavior, in `.highway/skills/highway-clarify/SKILL.md`.
- [X] T007 [US1] Run `.highway/tools/tests/highway-clarify.test.sh`, `.highway/tools/validate-skill.sh .highway/skills/highway-clarify`, and `.highway/tools/validate-library.sh .highway/library/templates/output/clarification-record.md` and repair only User Story 1 defects.

**Checkpoint**: User Story 1 is independently testable as the compatible retained contract and stable finding identity MVP.

## Phase 4: User Story 2 - Trace and Resolve Recommendations Deterministically (Priority: P1)

**Goal**: Filter artifact-specific sources before precedence, distinguish absent evidence from conflicting evidence, and retain structured traceability.

**Independent Test**: Exercise REQ, DISC, ADR, and RA fixtures with eligible, ineligible, absent, and conflicting evidence, then verify deterministic recommendation state, alternatives, rationale, and Evidence Sources structure.

### Tests for User Story 2

- [X] T008 [US2] Add focused probes for two-stage source selection, all four artifact-specific source sets, global precedence after filtering, ignored non-member sources, `Unknown`, `Unknown / Escalate for Decision`, conflicting alternatives, and Evidence Sources fields in `.highway/tools/tests/highway-clarify.test.sh`.

### Implementation for User Story 2

- [X] T009 [US2] Define source-set filtering, post-filter Recommendation Precedence, absent-evidence `Unknown`, conflicting-evidence `Unknown / Escalate for Decision`, and deterministic evidence selection in `.highway/skills/highway-clarify/SKILL.md`.
- [X] T010 [US2] Add the Evidence Sources structure, source identifiers, reasons used, and absent/conflict recommendation examples to `.highway/library/templates/output/clarification-record.md`.
- [X] T011 [US2] Run `.highway/tools/tests/highway-clarify.test.sh` and repair only User Story 2 contract or fixture defects until source filtering, precedence, conflict, and traceability probes pass.

**Checkpoint**: Stories 1 and 2 are independently testable as compatible records and auditable deterministic recommendations.

## Phase 5: User Story 3 - Preserve Decision Ownership Across Consumers (Priority: P1)

**Goal**: Make escalation routing, option-selection lifecycle, consumer restrictions, and ownership prohibitions explicit without changing Clarification authority.

**Independent Test**: Exercise A/B/C/D/None selection, candidate and accepted responses, all four escalation-owner mappings, downstream consumer field restrictions, and source immutability; verify only accepted responses resolve open findings.

### Tests for User Story 3

- [X] T012 [US3] Add focused probes for REQ/DISC/ADR/RA escalation ownership, informational selection, response acceptance, open-to-resolved-only transition, consumer restrictions, governance/architecture/Discovery/ADR ownership prohibitions, and source-byte preservation in `.highway/tools/tests/highway-clarify.test.sh`.

### Implementation for User Story 3

- [X] T013 [US3] Define escalation-owner mapping, advisory-only escalation, consumer-readable fields, prohibited authoritative interpretations, and the five ownership verification rules in `.highway/skills/highway-clarify/SKILL.md`.
- [X] T014 [US3] Align Selected Option, Response, escalation owner, and retained resolved-finding examples with the explicit option-selection lifecycle in `.highway/library/templates/output/clarification-record.md`.
- [X] T015 [US3] Run `.highway/tools/tests/highway-clarify.test.sh` and repair only User Story 3 contract or fixture defects until lifecycle, ownership, consumer, immutability, and no-partial-write probes pass.

**Checkpoint**: All three P1 stories are independently testable and preserve user decision authority and downstream ownership boundaries.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Synchronize derived artifacts and complete cross-contract validation.

- [X] T016 [P] Regenerate the Clarification catalogs, library catalogs, and all declared agent adapters with `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh` after canonical contract changes.
- [X] T017 [P] Revalidate `.highway/skills/highway-clarify`, `.highway/library/templates/output/clarification-record.md`, and every generated adapter and dependent skill that cites the changed shared template under D8.1.
- [X] T018 Run the complete validation in `specs/072-clarification-contract-hardening/quickstart.md`, including `.highway/tools/tests/run-all.sh` and `git diff --check`, and report suite results separately from Feature 072 requirement coverage.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: T001 has no implementation dependency and establishes the pre-edit baseline.
- **Foundational (Phase 2)**: T002 and T003 depend on T001 and may run in parallel because they inventory and extend the focused test surface.
- **User Story 1 (Phase 3)**: T004 follows T002/T003; T005/T006 follow the failing probes; T007 completes the version and identity checkpoint.
- **User Story 2 (Phase 4)**: T008 follows Story 1; T009/T010 follow the failing probes; T011 completes the recommendation checkpoint.
- **User Story 3 (Phase 5)**: T012 follows Story 2; T013/T014 follow the failing probes; T015 completes the ownership checkpoint.
- **Polish (Phase 6)**: T016 and T017 follow all implementation stories and may run in parallel; T018 follows both and is the final validation gate.

### User Story Dependencies

- **User Story 1 (P1)**: Depends only on Foundational tasks; delivers the compatible retained contract and identity guard.
- **User Story 2 (P1)**: Depends on Story 1 because it extends the same guidance record and canonical skill.
- **User Story 3 (P1)**: Depends on Stories 1 and 2 because lifecycle and consumer ownership rules consume the versioned recommendation and evidence structures.

### Parallel Opportunities

- T002 and T003 can run in parallel after T001.
- Within the implementation stories, test-probe review and canonical template/skill review can be performed in parallel when they do not edit the same file.
- T016 and T017 can run in parallel after Stories 1-3; T018 must wait for both.

## Parallel Example: Foundational Work

```text
Task: "Inventory Feature 072 canonical and generated contract surfaces in .highway/skills/, .highway/library/, .github/, .claude/, .cursor/, and .highway/tools/tests/highway-clarify.test.sh"
Task: "Add reusable Feature 072 disposable fixture assertions in .highway/tools/tests/highway-clarify.test.sh"
```

## Parallel Example: Final Cross-Cutting Work

```text
Task: "Regenerate catalogs and agent adapters with .highway/tools/generate-catalog.sh, .highway/tools/generate-library-catalog.sh, and .highway/tools/generate-agent-adapters.sh"
Task: "Revalidate highway-clarify, clarification-record.md, generated adapters, and dependent skills under D8.1"
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete T001-T003.
2. Complete T004-T007.
3. Stop and validate version alignment, finding identity consistency, resolved-guidance retention, and no-partial-write behavior independently.

### Incremental Delivery

1. Add Story 1 for a compatible retained contract and stable finding identity.
2. Add Story 2 for source-set filtering, precedence, deterministic recommendation states, and evidence traceability.
3. Add Story 3 for escalation ownership, selection lifecycle, consumer restrictions, and ownership verification.
4. Regenerate derived artifacts and run all cross-cutting checks.

### Completion Criteria

- All 18 tasks use the required checkbox, sequential ID, optional `[P]` marker, story label where required, and exact file path format.
- Every user story has an independent test criterion and a focused test task before implementation tasks.
- Every contract and data-model decision maps to at least one implementation or validation task.
- Final suite results and Feature 072 requirement coverage are reported as separate claims.
