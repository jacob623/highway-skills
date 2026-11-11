# Feature Specification: Standard Alignment Relocation

**Feature Branch**: `feature/std-alignment-phase6`

**Created**: 2026-11-11

**Status**: Complete

**Input**: User description: "create a new spec to implement phase 6 in standard-alignment.md". Phase 6 (Relocate the Framework, Tests, and Skills) gives the repository the Phase 3 layout. The bash suite moves from `.highway/tools/tests/` to `tests/`. The rest of `.highway/tools/` moves to `framework/`, with the Highway Skills Constitution, the authoring standard (as `authoring-standard.md`), and the frontmatter word list. `.highway/DISTRIBUTION.md` becomes `framework/README.md`, with the tools README merged in. Each skill folder moves from `.highway/skills/<id>/` to `skills/<name>/`. The paths helper, the harness path map, the generators, highway-help's index, and the documents follow the moves. The move is mechanical: no `SKILL.md` content changes. Exit: `skills/`, `tests/`, and `framework/` hold their Phase 3 contents, no `SKILL.md` body changed, and the full suite passes.

## Clarifications

### Session 2026-11-11

- Q: Does the framework stop shipping in this phase, or keep shipping until Phase 14 replaces the distribution? → A: Stop now. The distribution carries the skills, the agent copies, the always-on instructions, and the shared files only, and packaging verifies its skills with the repository's framework validator.
- Q: What is the distribution's `README.md` now that `DISTRIBUTION.md` becomes the authoring guide? → A: Keep shipping the authoring guide, `framework/README.md`, as the distribution's `README.md` until Phase 14.
- Q: Which version class does the development constitution's relocation-only amendment take? → A: MINOR, 3.1.0 to 3.2.0: Observables change location, no obligation is added or strengthened, and no conforming work fails.
- Q: How does the Highway Skills Constitution handle the paths it names when it moves, including P2.6's tools path? → A: Every path is updated; P2.6's Observable and its check name `framework/` instead of `.highway/tools/`; MINOR, 10.0.0 to 10.1.0.
- Q: Should this phase remove the committed test leftovers, the `test-catalog-fixture-20649` adapter copies and the 15 `.mock-agent-4` adapter manifest rows? → A: Yes, and the tests that create such entries must remove them when they finish, pass or fail.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Skills live in a root `skills/` folder (Priority: P1)

A maintainer who opens the repository finds every Highway skill at `skills/<name>/`, and `skills/` holds nothing but skill folders. Every tool treats each child of `skills/` as a skill, which is the layout the Agent Plugins package expects in Phase 14. The skills themselves do not change: each `SKILL.md` is byte-identical before and after, so every agent copy generated from it is too.

**Why this priority**: The skills are the product. Every later phase (7 to 14) edits them in their final folders, and Phase 12's format checks and Phase 14's package both assume `skills/<name>/`.

**Independent Test**: List `skills/`, compare each `SKILL.md` with its pre-move version, regenerate the agent copies and the catalog, and run the skill validator on each folder.

**Acceptance Scenarios**:

1. **Given** the repository after this change, **When** a maintainer lists `skills/`, **Then** it holds exactly the 15 Highway skill folders and no other file.
2. **Given** any skill, **When** its `SKILL.md` is compared with the version before the move, **Then** the bytes are identical, and its folder name equals its `name`.
3. **Given** the moved skills, **When** every generator is re-run, **Then** the agent copies under `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, and `.agents/skills/` and the adapter manifest show no diff.
4. **Given** highway-help's index (`.highway/catalog/index.json`), **When** it is regenerated from `skills/`, **Then** each entry still resolves to that skill in the layout a user's project receives, and highway-help still finds every skill.
5. **Given** a user's project built from the distribution, **When** a skill reads a shipped template, governance document, or another skill's `SKILL.md`, **Then** it finds the file where it did before this change, because the distribution's layout for skills and shared files is unchanged.

---

### User Story 2 - The framework lives in `framework/` and the suite in `tests/` (Priority: P1)

A maintainer finds the authoring framework in one folder, `framework/`: the generators, validators, shared helpers, manifests, the Highway Skills Constitution, the authoring standard, the frontmatter word list, and one README that explains how to author, validate, and generate. The bash suite and its fixtures sit at `tests/`. Nothing about how a maintainer runs them changes except the path.

**Why this priority**: The framework and the suite are no longer part of the product. Separating them from the shipped files makes that visible and leaves `.highway/` holding only what later phases empty and remove.

**Independent Test**: List `framework/` and `tests/`, run `tests/run-all.sh`, run the skill validator from `framework/` on one skill, and confirm `.highway/tools/` no longer exists.

**Acceptance Scenarios**:

1. **Given** the repository after this change, **When** a maintainer lists `tests/`, **Then** it holds every bash test, `run-all.sh`, the shared test helpers, the test shim for the paths helper, and the fixtures, and `.highway/tools/tests/` no longer exists.
2. **Given** `framework/`, **When** a maintainer lists it, **Then** it holds every generator, every validator, `lib/` with the paths helper, the adapter, distribution, frontmatter, and instruction manifests, `constitution.md`, `authoring-standard.md`, `frontmatter-lexicon.txt`, and `README.md`, and `.highway/tools/` no longer exists.
3. **Given** `framework/README.md`, **When** a maintainer reads it, **Then** it is the authoring guide for this repository: it names `skills/`, `framework/`, and `tests/`, includes what the tools README said, and no longer has the per-agent adapter, always-on instruction, earlier Cursor rule, or "skills in this distribution are registered" sections.
4. **Given** `.highway/` after this change, **When** a maintainer lists it, **Then** it holds only `catalog/`, `governance/` (the Experience Standard and the storage rules), `instructions/`, and `library/`, which later phases empty and remove.
5. **Given** the skill validator in `framework/`, **When** it runs on a skill, **Then** it reads the Highway Skills Constitution, the authoring standard, and the word list from `framework/` and reports the same findings as before the move.
6. **Given** the Highway Skills Constitution and the authoring standard, **When** a maintainer reads them, **Then** every path they name to a skill, a tool, or each other is the new location.
7. **Given** P2.6 in the Highway Skills Constitution, **When** a skill names a path under `framework/`, **Then** the validator reports it under P2.6, as it reported a `.highway/tools/` path before, and every current skill's P2.6 verdict is unchanged.

---

### User Story 3 - Every reference follows the move (Priority: P1)

A maintainer who follows a path named in a script, test, harness file, or live document finds the file there. The paths helper declares the new locations, and because every script already gets its locations from it (Phase 5), the scripts follow by editing the helper. Literal paths that are data, such as the harness selection list, path-map test inputs, the distribution manifest, and the text a test checks inside a document, are updated to the new layout.

**Why this priority**: A move that leaves one stale path breaks a test, a scenario selection, or a maintainer's instructions. The full suite passing is the exit condition.

**Independent Test**: Search scripts, tests, the harness, and live documents for the old locations of every moved file, and run the full suite and the harness tests.

**Acceptance Scenarios**:

1. **Given** the paths helper, **When** a maintainer reads it, **Then** it declares `skills/`, `framework/`, `framework/lib/`, `tests/`, and `tests/fixtures/`, the Highway Skills Constitution at `framework/constitution.md`, and the word list at `framework/frontmatter-lexicon.txt`, and it resolves the repository root from its new position.
2. **Given** every script, test, and harness file, and every live document, **When** they are searched for `.highway/skills/`, `.highway/tools/`, `.highway/governance/constitution.md`, `.highway/skills/_authoring-standard.md`, `.highway/library/knowledge/frontmatter-lexicon.txt`, or `.highway/DISTRIBUTION.md` as a location in this repository, **Then** none is found. Text describing a user's project, where the distribution still places skills under `.highway/skills/`, is the exception.
3. **Given** the harness, **When** its path map classifies a changed file under `skills/`, `framework/`, or `tests/`, **Then** a skill file selects that skill's scenarios, and a framework or test file selects nothing because the bash suite covers it, as before the move.
4. **Given** the harness selection list, **When** the path map reads it, **Then** every path it names exists, and the Highway Skills Constitution and the word list are no longer listed as shipped files.
5. **Given** the path-construction check from Phase 5, **When** it runs, **Then** it scans `framework/`, `tests/`, and `harness/bin/`, and it passes.
6. **Given** the development constitution, **When** a maintainer reads it, **Then** every rule, definition, Enforcement Map row, and gate that names the suite, the tools, the skills, or the paths helper names the new location, and the version is 3.2.0 (MINOR) with the amendment and its self-application review recorded.

---

### User Story 4 - The distribution stops carrying the framework (Priority: P2)

A user who installs Highway from the distribution gets the skills, their agent copies, and the shared files the skills read. They do not get the authoring framework, which Phase 3 decided no longer ships: no generator, validator, shared helper, manifest, Highway Skills Constitution, authoring standard, or word list. Until Phase 14, the distribution's `README.md` is still the authoring guide, `framework/README.md`, as `DISTRIBUTION.md` is today.

**Why this priority**: The repository and the distribution should agree on what is framework. It ranks below the move itself because the distribution is replaced in Phase 14 either way.

**Independent Test**: Build the distribution, list what it contains, and run its verification.

**Acceptance Scenarios**:

1. **Given** the distribution built after this change, **When** a user lists it, **Then** the skills, the agent copies, the always-on instructions, and the shared library, governance (the Experience Standard and the storage rules), and catalog files are where they were before this change.
2. **Given** the distribution, **When** a user lists it, **Then** it contains no file from `framework/` other than `framework/README.md` as its `README.md`, and no file from `tests/`.
3. **Given** the distribution, **When** it is verified, **Then** the repository's skill validator passes every skill in it using the distribution's copies of the files the skills name, no distributed file references a development-only location, and every documentation cross-reference resolves inside the distribution.
4. **Given** the distribution, **When** a user opens its `README.md`, **Then** it is `framework/README.md`, and every link in it resolves inside the distribution.

---

### Edge Cases

- highway-help's `SKILL.md` names `.highway/skills/<id>/SKILL.md` as where it reads a skill's frontmatter. That describes a user's project, which still receives skills there, so the body does not change (Phase 6 forbids `SKILL.md` content changes).
- highway-help's index records each skill's source path relative to `.highway/`. The index must still resolve in a user's project after the source moves, so its paths describe the distribution's layout, not the repository's.
- A disposable copy made by a test copies the framework folder. After the move, the copy includes `framework/`, the skills, and whatever else the test needs, through the paths helper's alternate root.
- The validation cache is keyed on validator inputs, including the constitution and `lib/`. Moving them changes the keys once, so every skill revalidates on the first run after the move. That is expected.
- A test that adds a temporary skill or agent to the real tree fails partway. It still removes every adapter copy and adapter manifest row it added, so no test run leaves an entry behind.
- Specs under `specs/` name the old locations as history. They are development records and do not change.
- `rollout-plan.md` stays gitignored and excluded in the distribution manifest.
- The distribution's `README.md` is the authoring guide, but the framework it describes no longer ships. Until Phase 14 that mismatch is accepted. The guide's links must still resolve inside the distribution, so it names framework files as text rather than as links where they are absent.
- The Highway Skills Constitution no longer ships. No shipped file links to it today, so no shipped cross-reference breaks; the packaging verification would report one that did.
- A file is moved and edited in the same change. Each move is recorded as a rename, so its history is kept, and content edits are limited to path updates.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Each skill folder MUST move from `.highway/skills/<id>/` to `skills/<id>/`, and `skills/` MUST hold only skill folders. Every `SKILL.md` and every file inside a skill folder MUST be byte-identical before and after.
- **FR-002**: `.highway/tools/tests/` MUST move to `tests/`, with its fixtures, shared helpers, `run-all.sh`, and the paths-helper shim.
- **FR-003**: The rest of `.highway/tools/` MUST move to `framework/`: the generators, the validators, `lib/`, and the adapter, distribution, frontmatter, and instruction manifests. Files that later phases drop or merge (`generate-instructions.sh`, `.instruction-manifest`, `validate-library.sh`) move too.
- **FR-004**: `.highway/governance/constitution.md` MUST move to `framework/constitution.md`, `.highway/skills/_authoring-standard.md` to `framework/authoring-standard.md`, and `.highway/library/knowledge/frontmatter-lexicon.txt` to `framework/frontmatter-lexicon.txt`. Every path they name to a moved file MUST name its new location. P2.6's Observable and its check MUST name `framework/` in place of `.highway/tools/`, and the Highway Skills Constitution's amendment MUST be MINOR, 10.0.0 to 10.1.0, recorded in its Sync Impact Report.
- **FR-005**: `.highway/DISTRIBUTION.md` MUST become `framework/README.md`, with `.highway/tools/README.md` merged in, its paths changed to `skills/`, `framework/`, and `tests/`, and its per-agent adapter, always-on instruction, earlier Cursor rule, and "skills in this distribution are registered" sections removed. `.highway/tools/README.md` MUST NOT remain.
- **FR-006**: The paths helper MUST declare the new locations and resolve the repository root from its new position. Scripts MUST NOT need any other edit to find a moved location, apart from the one line in each shim that locates the helper.
- **FR-007**: The generators MUST read skills from `skills/`. Regenerating the agent copies, the catalog, and the always-on instruction files MUST leave no diff in the agent trees, the adapter manifest, the instruction outputs, or highway-help's index.
- **FR-008**: The harness path map MUST classify `skills/`, `framework/`, and `tests/` as it classified their old locations, and the harness selection list, harness tests, and harness README MUST name the new locations.
- **FR-009**: The path-construction check MUST scan `framework/`, `tests/`, and `harness/bin/`, and MUST pass.
- **FR-010**: The distribution MUST keep its layout for skills, agent copies, always-on instructions, and shared library, governance, and catalog files, so a user's project and the skills' references to `.highway/` paths work unchanged. The distribution manifest MUST classify every new top-level path.
- **FR-011**: The distribution MUST NOT include any file from `framework/` or `tests/`, except `framework/README.md` shipped as its `README.md` (FR-012). Packaging verification MUST run the repository's skill validator against every distributed skill and MUST fail when a skill does not pass, so the packaged tree still validates with the development folders absent (D1.2).
- **FR-012**: The distribution's `README.md` MUST be `framework/README.md` until Phase 14. Every Markdown link in it MUST resolve inside the distribution, and it MUST NOT name a development-only location.
- **FR-013**: The development constitution MUST name the new locations wherever it names the suite, the tools, the skills, or the paths helper, including D2.5, D3.1 to D3.3, D4.5, D4.6, the Definitions, the Enforcement Map, the Harness Toolchain note, and the gates. The Definitions' shipped artifact list and the Enforcement Map's D1.2 note MUST reflect that the framework no longer ships. The amendment MUST be MINOR, 3.1.0 to 3.2.0, recorded with its self-application review.
- **FR-014**: Live documents MUST name the new locations in the same change: `README.md`, `framework/README.md`, `framework/authoring-standard.md`, `framework/constitution.md`, `harness/README.md`, `governance-plan.md`, and `standard-alignment.md`, which also marks Phase 6 complete.
- **FR-015**: No `SKILL.md` body, shared library file, governance file other than the moved constitution, or catalog entry's meaning MUST change. Content edits MUST be limited to path updates, the README merge, the P2.6 location change, the packaging verification change, and the test-leftover cleanup.
- **FR-016**: The committed test leftovers MUST be removed: the `test-catalog-fixture-20649` adapter copies under `.claude/skills/` and `.github/skills/`, and the 15 `.mock-agent-4` rows in the adapter manifest. Every test that adds a temporary skill, adapter copy, or adapter manifest row to the real tree MUST remove it on exit, whether the test passes or fails.
- **FR-017**: The full bash suite and the harness TypeScript tests MUST pass before the first edit and after the last.

### Key Entities

- **Skills folder** (`skills/`): one folder per Highway skill and nothing else; the source the generators read.
- **Framework folder** (`framework/`): the authoring framework: generators, validators, shared helpers, manifests, the Highway Skills Constitution, the authoring standard, the word list, and the authoring README. It never ships.
- **Tests folder** (`tests/`): the bash suite, its shared helpers, and its fixtures.
- **Paths helper**: the one declaration of every repository location (Phase 5), now at `framework/lib/paths.sh`.
- **Distribution layout**: where each shipped file sits in a user's project. Unchanged by this phase for every file that still ships.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 15 of 15 skill folders sit under `skills/`, `skills/` holds 0 other files, and 0 `SKILL.md` files differ from their pre-move bytes.
- **SC-002**: `.highway/tools/` and `.highway/skills/` do not exist, and `.highway/` holds only `catalog/`, `governance/`, `instructions/`, and `library/`.
- **SC-003**: 0 scripts, tests, harness files, or live documents name an old location as a place in this repository.
- **SC-004**: Regenerating every generated artifact produces 0 changed files, and after a full suite run the agent trees and the adapter manifest hold 0 entries for a skill or agent that is not declared.
- **SC-005**: The full bash suite and the harness TypeScript tests pass, the path-construction check reports 0 violations, and the distribution builds and verifies.
- **SC-006**: A user's project built from the distribution has every skill and shared file at the same path as before this change, and 0 framework or test files apart from its `README.md`.

## Assumptions

- Skill folder names already equal each skill's `name` (`highway-adr`, and so on), so `skills/<id>/` and `skills/<name>/` are the same path.
- The distribution keeps placing skills under `.highway/skills/` in a user's project until Phase 14 replaces it with the plugin. The manifest's destination column maps `skills/` there, so highway-help's text and its index stay correct for users.
- `.highway/catalog/`, `.highway/governance/` (Experience Standard and storage rules), `.highway/instructions/`, and `.highway/library/` stay where they are. Phases 7 to 11 empty and remove them.
- The agent copy trees and `AGENTS.md` stay where they are; Phase 7 and Phase 14 remove them.
- The Highway Skills Constitution's rules do not change in this phase beyond the paths they name; Phase 12 reconciles them with the Agent Skills specification.
- Historical specs keep the old paths.
- Nothing is committed until the maintainer asks.
