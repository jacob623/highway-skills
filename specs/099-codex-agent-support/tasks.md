# Tasks: Add Codex as a Supported Agent

**Input**: Design documents from `specs/099-codex-agent-support/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/codex-skill-contract.md`, `contracts/codex-guidance-contract.md`, `quickstart.md`

**Tests**: Required by the plan. Extend the existing publisher and coverage tests in the same change as the files they check. Do not add a check that fails on a Codex path before that path exists.

**Organization**: Tasks are grouped by user story. User Story 1 publishes skills. User Story 2 publishes `AGENTS.md`. User Story 3 ships both and turns on correspondence. User Story 4 records the agent name.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependency on an incomplete task)
- **[Story]**: The user story the task serves (US1 to US4)
- Paths are relative to the repository root

## Phase 1: Setup

**Purpose**: Record a passing suite and the files Codex must not disturb.

- [X] T001 Run `.highway/tools/tests/run-all.sh` (allow up to 240 seconds) and record the exit status and pass count in `specs/099-codex-agent-support/evidence.md` under "Baseline (D3.1)". Stop if it does not exit 0
- [X] T002 Record in `specs/099-codex-agent-support/evidence.md` the sha256 of every `.cursor/skills/speckit-*/SKILL.md` and `.github/skills/speckit-*/SKILL.md`. Confirm `.agents/skills/` does not yet exist

## Phase 2: Foundational

**Purpose**: Confirm the skill publisher can gain one agent row without breaking the extensibility test.

- [X] T003 Confirm the `AGENT_IDS`, `AGENT_TARGET_TEMPLATES`, and `AGENT_TRANSFORMS` assignments in `.highway/tools/generate-agent-adapters.sh` are each one physical line, and record that fact in `specs/099-codex-agent-support/evidence.md`. Stop if any assignment is wrapped

**Checkpoint**: The suite is green and the three arrays can take a `codex` row on the same line.

## Phase 3: User Story 1 - Codex receives every Highway skill (Priority: P1) MVP

**Goal**: Each Highway skill is published to `.agents/skills/<id>/SKILL.md` as a byte-identical copy, and no canonical skill changes.

**Independent Test**: `.highway/tools/generate-agent-adapters.sh` exits 0. Each of the 12 `.agents/skills/highway-<id>/SKILL.md` files matches `.highway/skills/highway-<id>/SKILL.md`. No `speckit-*` path exists under `.agents/skills/`.

### Implementation for User Story 1

- [X] T004 [US1] Add the `codex` row to `.highway/tools/generate-agent-adapters.sh` per `specs/099-codex-agent-support/contracts/codex-skill-contract.md`. Keep each of the three arrays on one line. Transform is `identity-copy`. Target is `.agents/skills/%s/SKILL.md`
- [X] T005 [P] [US1] In `.highway/tools/tests/generate-agent-adapters.test.sh`, remove `.agents/skills/$TMP_ID` on cleanup, require `.agents/skills/$TMP_ID/SKILL.md` to be byte-identical to the source, and fail if a `speckit-*` path was created under `.agents/skills/`
- [X] T006 [P] [US1] In `.highway/tools/tests/new-agent-extensibility.test.sh`, remove `.agents/skills/$TMP_ID` on cleanup
- [X] T007 [P] [US1] In `.highway/tools/tests/run-all.sh`, sweep abandoned `.agents/skills/test-adapter-fixture-*` and `.agents/skills/test-newagent-fixture-*` directories the same way the other agent trees are swept
- [X] T008 [US1] Run `.highway/tools/generate-agent-adapters.sh`, then `cmp` each `.highway/skills/highway-<id>/SKILL.md` with `.agents/skills/highway-<id>/SKILL.md` for all 12 ids named in `specs/099-codex-agent-support/data-model.md`. Record 12 matches and zero `speckit-*` paths in `specs/099-codex-agent-support/evidence.md`
- [X] T009 [US1] Run `.highway/tools/tests/generate-agent-adapters.test.sh` and `.highway/tools/tests/new-agent-extensibility.test.sh`. Both must exit 0. Record the results in `specs/099-codex-agent-support/evidence.md`

**Checkpoint**: Codex has the 12 Highway skills. Canonical `SKILL.md` files are unchanged. Correspondence coverage is not switched on yet.

## Phase 4: User Story 2 - Codex receives repository guidance (Priority: P1)

**Goal**: `AGENTS.md` at the repository root matches the guidance Claude Code and Copilot already receive.

**Independent Test**: `.highway/tools/generate-instructions.sh` exits 0. `AGENTS.md`, `.claude/CLAUDE.md`, and `.github/copilot-instructions.md` are byte-identical, and `# Highway Agent Context` is in `AGENTS.md`.

### Implementation for User Story 2

- [X] T010 [US2] In `.highway/tools/generate-instructions.sh`, write the merged-body bytes to `AGENTS.md` per `specs/099-codex-agent-support/contracts/codex-guidance-contract.md`. Add the instruction-manifest row. Apply the same drift refusal as the other merged files. Zero instructions write one newline and delete nothing
- [X] T011 [P] [US2] In `.highway/tools/tests/generate-instructions.test.sh`, require `AGENTS.md` to match `.claude/CLAUDE.md` for one instruction, for two instructions joined in filename order, and for the empty set's single newline
- [X] T012 [US2] Run `.highway/tools/generate-instructions.sh`, `cmp` `AGENTS.md` against `.claude/CLAUDE.md` and `.github/copilot-instructions.md`, confirm the Highway Agent Context heading, run the publisher again, and record unchanged checksums in `specs/099-codex-agent-support/evidence.md`
- [X] T013 [US2] Run `.highway/tools/tests/generate-instructions.test.sh` and record exit 0 in `specs/099-codex-agent-support/evidence.md`

**Checkpoint**: Codex repository guidance matches the other two merged files. Skill files were not deleted.

## Phase 5: User Story 3 - Codex output ships (Priority: P2)

**Goal**: The distribution contains the 12 Codex skill directories and `AGENTS.md`, and correspondence checks know those paths.

**Independent Test**: `generate-distribution.sh` exits 0. The distribution contains `.agents/skills/highway-help` and `AGENTS.md`, contains no `speckit-*` path, and passes its existing verifications.

### Implementation for User Story 3

- [X] T014 [P] [US3] In `.highway/tools/.distribution-manifest`, `exclude` `.agents`, `include` `.agents/skills/highway-<id>` for the 12 ids in `specs/099-codex-agent-support/data-model.md`, and `include` `AGENTS.md`. Do not include the whole `.agents` tree
- [X] T015 [P] [US3] In `.highway/tools/tests/adapter-coverage.test.sh`, expect `.agents/skills/$id` and `.agents/skills/$id/SKILL.md`, treat a `.agents/skills/*` distribution include as a skill path, and treat an adapter-manifest path under `.agents/` as a file that must exist on disk
- [X] T016 [P] [US3] In `.highway/tools/tests/highway-new.test.sh`, require `.agents/skills/highway-new` in the distribution manifest beside the other three agent paths
- [X] T017 [P] [US3] In `.highway/tools/tests/instruction-coverage.test.sh`, require an `AGENTS.md` instruction-manifest row whose id matches the other merged rows, and an `include` distribution row for `AGENTS.md`
- [X] T018 [US3] Run `.highway/tools/tests/adapter-coverage.test.sh`, `.highway/tools/tests/instruction-coverage.test.sh`, `.highway/tools/tests/highway-new.test.sh`, `.highway/tools/tests/distribution-packaging.test.sh`, and `.highway/tools/tests/shipped-tree-independence.test.sh`. Produce a distribution with `.highway/tools/generate-distribution.sh` into a temporary directory and confirm exit 0, the Codex skill directory and `AGENTS.md` present and matching the repository, and zero `speckit-*` paths. Record the results in `specs/099-codex-agent-support/evidence.md`

**Checkpoint**: A recipient of the distribution gets the Codex skills and `AGENTS.md`.

## Phase 6: User Story 4 - Codex is a named supported agent (Priority: P2)

**Goal**: `codex` is a legal compatibility value and a declared agent, and the live docs name both Codex locations. No `SKILL.md` is edited.

**Independent Test**: `git diff` under `.highway/skills/` is limited to `.highway/skills/_authoring-standard.md`. That file and `.highway/tools/.frontmatter-contract` list `codex`. `.specify/memory/constitution.md` is 2.2.0 and its declared agent trees include `codex`.

### Implementation for User Story 4

- [X] T019 [P] [US4] In `.highway/tools/.frontmatter-contract`, add `codex` to the `compatibility` enum. Do not edit any `SKILL.md`
- [X] T020 [P] [US4] In `.highway/skills/_authoring-standard.md`, add `codex` to the documented compatibility list. Change no other rule text
- [X] T021 [P] [US4] Amend `.specify/memory/constitution.md` from 2.1.0 to 2.2.0 (MINOR). Add `codex` to the declared agent trees. Add a sync impact report listing the version line, the last-amended date, and that sentence. Do not edit D4.5 or D4.6 rule text
- [X] T022 [P] [US4] In `README.md` and `.highway/tools/README.md`, name Codex, `.agents/skills/<id>/SKILL.md`, and `AGENTS.md` beside the existing agents
- [X] T023 [P] [US4] In `.highway/DISTRIBUTION.md`, state that `.agents/skills/<id>/SKILL.md` and `AGENTS.md` are published Codex outputs and ship with the distribution. Do not use the strings `specs/` or `.specify/`

**Checkpoint**: Codex is named in the agent list, the compatibility enum, and the docs. Existing skill bodies are unchanged.

## Phase 7: Polish

**Purpose**: Whole-suite verification and the completion report.

- [X] T024 Run `.highway/tools/tests/run-all.sh` and record exit 0 and the pass count in `specs/099-codex-agent-support/evidence.md` (D3.2)
- [X] T025 Walk quickstart steps 1 through 6 in `specs/099-codex-agent-support/quickstart.md` and record each result in `specs/099-codex-agent-support/evidence.md`. Leave step 7, the in-Codex observation, for a person
- [X] T026 Write the completion report in `specs/099-codex-agent-support/evidence.md` with FR-001 through FR-011 and SC-001 through SC-007 mapped to evidence, stated separately from the suite result

## Dependencies & Execution Order

### Phase dependencies

- **Setup (T001–T002)**: no dependencies. T001 must pass before any edit.
- **Foundational (T003)**: depends on Setup.
- **US1 (T004–T009)**: depends on Foundational. T005, T006, and T007 edit different files and can run in parallel. T008 needs T004. T009 needs T004 through T007.
- **US2 (T010–T013)**: depends on Foundational. It does not require US1. T012 needs T010. T013 needs T011.
- **US3 (T014–T018)**: depends on US1 and US2, so the Codex files exist to classify. T014 through T017 edit different files and can run in parallel. T018 needs all four.
- **US4 (T019–T023)**: depends on US1, so the Codex skill copies exist before the declared-agent sentence is enabled. T019 through T023 edit different files and can run in parallel.
- **Polish (T024–T026)**: depends on US3 and US4.

### Parallel opportunities

```text
US1:  T005, T006, T007
US3:  T014, T015, T016, T017
US4:  T019, T020, T021, T022, T023
```

US1 and US2 can proceed together after Foundational. They touch different publishers.

### User story order

US1 is the MVP. US2 adds repository guidance. US3 ships both and enables correspondence. US4 records the name.

## Implementation Strategy

### MVP

User Story 1 (T001 through T009). Codex receives the 12 Highway skills. Stop there before adding `AGENTS.md`.

### Incremental delivery

1. Setup and Foundational: baseline and the one-line array check.
2. US1: Codex skills.
3. US2: `AGENTS.md`.
4. US3: distribution and correspondence.
5. US4: enum, constitution, docs.
6. Polish: full suite and completion report.

## Notes

- Do not edit any `SKILL.md`. The only file under `.highway/skills/` that changes is `_authoring-standard.md`.
- Do not give either publisher a delete path.
- Do not write a Codex-specific transform or an `agents/openai.yaml`.
- Personal Codex directories under a home directory are out of scope.
- A Cursor session that also shows `AGENTS.md` is recorded by a person. It does not fail a task.
