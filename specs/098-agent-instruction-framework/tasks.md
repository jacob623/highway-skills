# Tasks: Distribute Always-On Agent Instructions from One Source

**Input**: Design documents from `specs/098-agent-instruction-framework/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/instruction-source-contract.md`, `contracts/instruction-output-contract.md`, `quickstart.md`

**Tests**: Required by the plan and by FR-012. New assertions are observed failing before the generator exists (D3.6). The narrowed leftover-rule assertion records the behavior it replaces (D3.5).

**Organization**: Tasks are grouped by user story. User Story 3 is sequenced before User Story 2 because `generate-agent-adapters.test.sh` fails on any `.cursor/rules/highway-*.mdc` until its guard is narrowed, and User Story 2 creates `highway-agent-context.mdc`.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependency on an incomplete task)
- **[Story]**: The user story the task serves (US1 to US4)
- Paths are relative to the repository root

## Phase 1: Setup

**Purpose**: Record a passing suite and confirm the documents the first instruction cites.

- [X] T001 Run `.highway/tools/tests/run-all.sh` (allow up to 240 seconds) and record the exit status and pass count in `specs/098-agent-instruction-framework/evidence.md` under "Baseline (D3.1)". Stop if it does not exit 0
- [X] T002 Confirm `.highway/library/knowledge/highway-identity.md` and `.highway/governance/experience-standard.md` exist, and record both paths in `specs/098-agent-instruction-framework/evidence.md`. Do not edit either file

## Phase 2: Foundational

**Purpose**: Add the tests that describe the generator, and record that they fail before the generator exists.

- [X] T003 [P] Add `.highway/tools/tests/generate-instructions.test.sh` covering a temporary instruction under `.highway/instructions/`: Cursor file `.cursor/rules/<id>.mdc` has `alwaysApply: true`, no `globs`, and a body equal to `fm_body` of the source; `.claude/CLAUDE.md` and `.github/copilot-instructions.md` are byte-identical to each other and, for one instruction, equal to that body; a second run changes nothing; a mismatched `name`, an unknown frontmatter key, or an empty body exits 1 and writes nothing; a hand-edited merged file is refused, named, and left unchanged; zero instructions in a temporary copy write both merged files as a single newline and write no `.mdc`. Clean up the temporary id on exit
- [X] T004 [P] Add `.highway/tools/tests/instruction-coverage.test.sh` that fails unless every `.highway/instructions/<id>.md` has `.cursor/rules/<id>.mdc`, a body present in both merged files, a `.highway/tools/.instruction-manifest` row whose Cursor id is `<id>` and whose merged-file id field lists every source id in `LC_ALL=C` filename order, and an `include` distribution row for the `.mdc` plus both merged paths. An instruction-manifest row or a `.cursor/rules/` distribution include whose id has no source fails the test
- [X] T005 Run `.highway/tools/tests/generate-instructions.test.sh` and `.highway/tools/tests/instruction-coverage.test.sh` against the tree before `generate-instructions.sh` exists, and record each non-zero exit and its message in `specs/098-agent-instruction-framework/evidence.md` under "Failing before the generator (D3.6)"

**Checkpoint**: Both new tests fail because the generator and the first instruction are absent. The existing suite's skill tests are unchanged.

## Phase 3: User Story 1 - Author an instruction once (Priority: P1) MVP

**Goal**: One `.highway/instructions/<id>.md` file is published to Cursor, Claude Code, and Copilot by `generate-instructions.sh`, with the body copied unchanged.

**Independent Test**: `.highway/tools/tests/generate-instructions.test.sh` exits 0. Quickstart steps 3 and 4 pass on a temporary copy: an invalid source writes nothing, and a hand-edited merged file is refused.

### Implementation for User Story 1

- [X] T006 [US1] Implement `.highway/tools/generate-instructions.sh` per `specs/098-agent-instruction-framework/contracts/instruction-output-contract.md` and `specs/098-agent-instruction-framework/data-model.md`. Use `lib/frontmatter.sh`. Bash 3.2 and the declared toolchain only. Validate every source before any write. Refuse a present target with no manifest row or a mismatched hash, and write nothing on failure. Do not delete files. Do not read or write `.highway/skills/`, skill adapter trees, or `speckit-*` files. Write `.highway/tools/.instruction-manifest` with columns path, id, and sha256
- [X] T007 [US1] Add a sweep in `.highway/tools/tests/run-all.sh` for abandoned `.highway/instructions/test-instruction-*` fixtures, their `.cursor/rules/test-instruction-*.mdc` files, and their `.instruction-manifest` rows, matching the existing `test-adapter-fixture` sweep
- [X] T008 [US1] Run `.highway/tools/tests/generate-instructions.test.sh` and record exit 0 in `specs/098-agent-instruction-framework/evidence.md`

**Checkpoint**: A temporary instruction publishes correctly. The repository does not yet contain `highway-agent-context`.

## Phase 4: User Story 3 - Instructions stay separate from skills (Priority: P1)

**Goal**: The instruction generator and the skill generator do not write each other's files, and `highway-agent-context.mdc` will not be reported as a leftover skill rule.

**Independent Test**: `.highway/tools/tests/generate-agent-adapters.test.sh` exits 0. A `.cursor/rules/highway-*.mdc` file with no `.instruction-manifest` row still fails that test. Checksums of `speckit-*` skill files are unchanged by `generate-instructions.sh`.

### Implementation for User Story 3

- [X] T009 [US3] In `.highway/tools/tests/generate-agent-adapters.test.sh`, change the `.cursor/rules/highway-*.mdc` loop so a file is a failure only when `.highway/tools/.instruction-manifest` has no row for that path. Keep the assertion that `.highway/tools/.adapter-manifest` has no `.cursor/rules/` row. Comment the superseded behavior: the loop previously failed on every `highway-*.mdc` because no instruction outputs existed (D3.5)
- [X] T010 [US3] Extend `.highway/tools/tests/generate-instructions.test.sh` so a run records checksums of `.cursor/skills/speckit-tasks/SKILL.md` and `.github/skills/speckit-tasks/SKILL.md` and of `.highway/tools/.adapter-manifest` before and after, and fails if any change. Extend `.highway/tools/tests/generate-agent-adapters.test.sh` so a run fails if `.claude/CLAUDE.md`, `.github/copilot-instructions.md`, or `.highway/tools/.instruction-manifest` changes
- [X] T011 [US3] Run `.highway/tools/tests/generate-agent-adapters.test.sh` and `.highway/tools/tests/generate-instructions.test.sh` and record both exits in `specs/098-agent-instruction-framework/evidence.md`

**Checkpoint**: The guard allows an instruction-owned `highway-*.mdc` and still rejects a skill leftover. Neither generator disturbs the other tree.

## Phase 5: User Story 2 - Highway Agent Context is the first instruction (Priority: P1)

**Goal**: `.highway/instructions/highway-agent-context.md` exists with the specified body, and all three agent outputs contain that body unchanged.

**Independent Test**: Quickstart step 1. The heading `# Highway Agent Context` is in the source, the Cursor rule, `.claude/CLAUDE.md`, and `.github/copilot-instructions.md`. The two merged files match the source body. The Cursor file has `alwaysApply: true` and no `globs`.

### Implementation for User Story 2

- [X] T012 [US2] Create `.highway/instructions/highway-agent-context.md` per `specs/098-agent-instruction-framework/contracts/instruction-source-contract.md`. `name` is `highway-agent-context`. `description` is `Ground an agent in Highway identity and the experience standard, and leave workflow to the applicable skill.` The body is the Highway Agent Context block in `specs/098-agent-instruction-framework/spec.md`, starting at `# Highway Agent Context` with no blank line between the closing `---` and that heading
- [X] T013 [US2] Run `.highway/tools/generate-instructions.sh`, then `cmp` the source body against `.cursor/rules/highway-agent-context.mdc` below its frontmatter, against `.claude/CLAUDE.md`, and against `.github/copilot-instructions.md`. Confirm `alwaysApply: true`, no `globs`, and a merged-file manifest id of `highway-agent-context`. Record the results in `specs/098-agent-instruction-framework/evidence.md`
- [X] T014 [US2] Run `.highway/tools/generate-instructions.sh` a second time and confirm `git status --short` for `.cursor/rules/highway-agent-context.mdc`, `.claude/CLAUDE.md`, `.github/copilot-instructions.md`, and `.highway/tools/.instruction-manifest` is unchanged. Record the result in `specs/098-agent-instruction-framework/evidence.md`
- [X] T015 [US2] Run `.highway/tools/tests/instruction-coverage.test.sh` and `.highway/tools/tests/generate-agent-adapters.test.sh`. Both must exit 0. Record the results in `specs/098-agent-instruction-framework/evidence.md`

**Checkpoint**: An agent that loads repository instructions receives Highway Agent Context from all three generated files. The cited identity and experience-standard files are unchanged.

## Phase 6: User Story 4 - Generated instructions ship (Priority: P2)

**Goal**: The three outputs are in the distribution, the new generator is declared, and the live docs tell a maintainer how to add an instruction.

**Independent Test**: Quickstart step 7. `generate-distribution.sh` exits 0, the distribution contains the three outputs and no `speckit-*` path, and `adapter-coverage.test.sh` still exits 0 after it also runs `generate-instructions.sh`.

### Implementation for User Story 4

- [X] T016 [US4] In `.highway/tools/.distribution-manifest`, add `include` rows for `.claude/CLAUDE.md`, `.github/copilot-instructions.md`, and `.cursor/rules/highway-agent-context.mdc`, keeping the existing `exclude` rows for `.claude`, `.cursor`, and `.github`. Do not add a ship flag to instruction sources
- [X] T017 [US4] In `.highway/tools/tests/adapter-coverage.test.sh`, run `.highway/tools/generate-instructions.sh` inside the existing temporary-tree regeneration and fail if any instruction output or `.instruction-manifest` differs from the real tree, aside from no timestamp because this generator writes none
- [X] T018 [US4] Amend `.specify/memory/constitution.md` from 2.0.0 to 2.1.0 (MINOR). Add `generate-instructions.sh` to the declared-generator list. Update the D4.7 enforcement-map cell so it names that generator as part of the `adapter-coverage.test.sh` regeneration. Add a sync impact report listing the version line, the last-amended date, the declared-generator list, and that map cell. Do not edit D4.5 or D4.6
- [X] T019 [P] [US4] In `README.md` and `.highway/tools/README.md`, document authoring `.highway/instructions/<id>.md` and publishing it with `.highway/tools/generate-instructions.sh`, including that Claude Code and Copilot receive one merged file and Cursor receives one always-on rule per instruction
- [X] T020 [P] [US4] In `.highway/DISTRIBUTION.md`, state that `.claude/CLAUDE.md`, `.github/copilot-instructions.md`, and `.cursor/rules/<id>.mdc` are generated instruction outputs and ship with the distribution. Do not use the strings `specs/` or `.specify/`
- [X] T021 [US4] Run `.highway/tools/tests/adapter-coverage.test.sh`, `.highway/tools/tests/distribution-packaging.test.sh`, and `.highway/tools/tests/shipped-tree-independence.test.sh`. Produce a distribution with `.highway/tools/generate-distribution.sh` into a temporary directory and confirm exit 0, the three outputs present and byte-identical to the repository, and zero `speckit-*` paths. Record the results in `specs/098-agent-instruction-framework/evidence.md`

**Checkpoint**: A recipient of the distribution gets Highway Agent Context. A body that names `.specify/` or `specs/` still fails distribution verification.

## Phase 7: Polish

**Purpose**: Whole-suite verification and the completion report.

- [X] T022 Run `.highway/tools/tests/run-all.sh` and record exit 0 and the pass count in `specs/098-agent-instruction-framework/evidence.md` (D3.2)
- [X] T023 Walk quickstart steps 1 through 7 in `specs/098-agent-instruction-framework/quickstart.md` and record each result in `specs/098-agent-instruction-framework/evidence.md`. Leave step 8, the in-agent observation, for a person
- [X] T024 Write the completion report in `specs/098-agent-instruction-framework/evidence.md` with FR-001 through FR-015 and SC-001 through SC-007 mapped to evidence, stated separately from the suite result (D7.3)

## Dependencies & Execution Order

### Phase dependencies

- **Setup (T001–T002)**: no dependencies. T001 must pass before any edit.
- **Foundational (T003–T005)**: depends on Setup. T003 and T004 edit different files and can run in parallel. T005 needs both.
- **US1 (T006–T008)**: depends on Foundational. T007 can be written with T006. T008 needs T006.
- **US3 (T009–T011)**: depends on US1, so the instruction manifest the guard reads exists. Must finish before US2 creates `highway-agent-context.mdc`.
- **US2 (T012–T015)**: depends on US1 and US3.
- **US4 (T016–T021)**: depends on US2, so the three outputs exist to classify and ship. T019 and T020 can run in parallel. T021 needs T016 through T020.
- **Polish (T022–T024)**: depends on US4.

### Parallel opportunities

```text
Foundational:  T003, T004
US4:           T019, T020
```

### User story order

US1 is the MVP mechanism, proven with temporary instructions. US3 lands the guard before US2 creates a `highway-*.mdc` file. US2 adds the real instruction. US4 ships it and declares the generator.

## Implementation Strategy

### MVP

User Story 1 (T001 through T008). A temporary instruction publishes to all three agents. Stop there to confirm the generator before adding the repository's real instruction.

### Incremental delivery

1. Setup and Foundational: baseline and recorded failures.
2. US1: generator.
3. US3: skill isolation and the narrowed guard.
4. US2: Highway Agent Context published. **First repository-visible increment.**
5. US4: distribution, constitution, docs.
6. Polish: full suite and completion report.

## Notes

- Do not edit `.highway/library/knowledge/highway-identity.md` or `.highway/governance/experience-standard.md`.
- Do not add `alwaysApply`, `globs`, `paths`, or `applyTo` to an instruction source.
- Do not give the generator a delete path. Orphans are reported by `instruction-coverage.test.sh`.
- Every instruction ships. Do not add a per-instruction exclude flag.
