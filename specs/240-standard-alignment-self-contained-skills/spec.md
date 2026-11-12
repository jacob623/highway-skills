# Feature Specification: Standard Alignment Self-Contained Skills

**Feature Branch**: `feature/std-alignment-phase11`

**Created**: 2026-11-11

**Status**: Draft

**Input**: User description: "create a new spec to implement phase 11 of standard-alignment.md". Phase 11 (Self-Contained Skills) makes every Highway skill read only files inside its own folder, removes `.highway/`, and proves the skills are self-contained before Phase 14 packages them. highway-help's index moves to its `assets/index.json`, with each skill's dependencies and Example (Phase 2); highway-help stops reading other skills' folders, and the generator checks that each skill's `name` matches its folder. `validate-library.sh` merges into `validate-skill.sh`, which checks each skill's `references/` and `assets/`. Each skill names every bundled file by a path relative to its own folder, one level deep. `highway-setup` copies no shipped material into the project. `.highway/` is removed. The harness test project gets the skill folders from `skills/` and holds no shipped material. Exit: `.highway/` does not exist, no skill reads a file outside its own folder, and the full suite and harness pass.

## Clarifications

### Session 2026-11-11

- Q: With `.highway/` gone, how does a Highway skill decide it is in a Highway project, and what does it do when it is not? → A: The repository root the agent runs in is the project root. Each skill drops its `.highway/` input line and the "project root cannot be located" stop. A missing seeded file shows the fixed setup message and writes nothing. No new project marker is added.
- Q: Does a code product's own `code/<folder>/.highway/` folder keep its name now that the repository-level `.highway/` is removed? → A: Yes. It keeps its name and paths as the person's records. Checks exempt that one pattern, and highway-codify's sentence that it "does not make the product folder a Highway project" may be reworded.
- Q: What happens to `metadata.dependencies`, which today resolves under `.highway/`? → A: Keep the field. A declared path resolves inside the declaring skill's own folder, the help index carries each skill's dependencies, and highway-help's `Dependencies:` line stays. Phase 12 decides the field's future.
- Q: Are the two constitutions' version bumps for this phase fixed at MINOR, or classified by each constitution's own Versioning Policy? → A: Each amendment is classified under that constitution's own Versioning Policy, with the reasoning in its Sync Impact Report. Skill versions stay MINOR.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - highway-help answers from its own folder (Priority: P1)

A person runs `/highway-help` to list every Highway skill, or `/highway-help highway-adr` to see one skill's details. They get the same output as today. Behind that, highway-help reads one file, its own `assets/index.json`, instead of a catalog under `.highway/catalog/` and the other skill's `SKILL.md`. The generator writes that index into highway-help's folder from every skill's frontmatter and `## Example`, and refuses to build it when a skill's `name` differs from its folder.

**Why this priority**: highway-help is the one skill that still reads files outside its own folder: the shared catalog and every other skill's `SKILL.md`. A plugin skill cannot rely on a sibling's files, so until highway-help answers from its own folder, the skills are not self-contained and `.highway/` cannot be removed.

**Independent Test**: Run `/highway-help` and `/highway-help highway-adr` before and after the change and compare the output. Read highway-help's inputs. Regenerate the index from a skill set where one skill's `name` differs from its folder.

**Acceptance Scenarios**:

1. **Given** the repository after this change, **When** a maintainer reads highway-help, **Then** its only file input is `assets/index.json`, and it names no path under `.highway/`, no other skill's folder, and no other skill's `SKILL.md`.
2. **Given** `/highway-help highway-adr`, **When** highway-help answers, **Then** it prints the same six lines as today, `Name:`, `Description:`, `Dependencies:`, `Version:`, `Usage:`, `Example:`, with the same values, read only from `assets/index.json`.
3. **Given** `/highway-help` with no identifier, **When** highway-help answers, **Then** it prints one block per skill in the index, in index order, exactly as today.
4. **Given** an identifier that is not in the index, or a missing or unreadable index, **When** highway-help runs, **Then** it prints the fixed error line for that case and nothing else, as today, with the index named by its path inside highway-help's folder.
5. **Given** the index generator, **When** it builds the index, **Then** it writes `skills/highway-help/assets/index.json` with each skill's id, name, description, usage, version, dependencies, and Example invocation, and the same sources always build the same bytes.
6. **Given** a skill whose frontmatter `name` differs from its folder name, **When** the generator runs, **Then** it fails, names that skill, and writes no index.
7. **Given** a change to any skill's frontmatter or `## Example`, **When** the drift check runs without regenerating, **Then** it fails on highway-help's `assets/index.json`.

---

### User Story 2 - A Highway project has no `.highway/` folder (Priority: P1)

A person installs Highway's skills and runs `/highway-setup` in their repository. Setup seeds the project's catalogs from its own `assets/`, as it does today, and copies nothing else into the project. Nothing in the project, and nothing in this repository, is named `.highway/`. Every skill works from the repository root it is run in, and a skill that needs a seeded file it cannot find still tells the person to run `/highway-setup`.

**Why this priority**: This is the phase's exit condition. The installed skills, not a shared folder in the project, carry everything Highway needs. A person's project holds only the person's records.

**Independent Test**: List this repository and a freshly built distribution and look for `.highway/`. Run `/highway-setup` in an empty project and list every file written. Search every skill for `.highway/`. Run `/highway-request`, `/highway-codify`, and `/highway-codify-config` in a project that has not run setup.

**Acceptance Scenarios**:

1. **Given** this repository after this change, **When** a maintainer lists it, **Then** `.highway/` does not exist.
2. **Given** a freshly built distribution, **When** a maintainer lists it, **Then** it holds no `.highway/` folder; the skills ship only in the agent skill folders, each with its own `references/` and `assets/`, until Phase 14 replaces the distribution.
3. **Given** an empty project, **When** the person runs `/highway-setup`, **Then** it writes only the seeded files from its own `assets/`, and writes no skill, template, reference, governance file, index, or `.highway/` folder.
4. **Given** any Highway skill, **When** a maintainer reads it, **Then** it does not name `.highway/` as the project root or as a place it reads or writes, and it does not require a `.highway/` folder to run. A code product's own `code/<folder>/.highway/` records, which highway-codify writes for the person, are not affected.
5. **Given** a project that has not run setup, **When** the person runs `/highway-request`, `/highway-codify`, or `/highway-codify-config`, **Then** the skill shows the fixed setup message and writes nothing, as it does today when a seeded file is missing, instead of the old "project root cannot be located" stop.
6. **Given** a project that has run setup, **When** the person runs any Highway skill, **Then** it reads and writes the same project files as before, at the same paths relative to the repository root.

---

### User Story 3 - One validator checks every file a skill bundles (Priority: P2)

A maintainer edits a file in a skill's `references/` or `assets/` and runs the skill validator on that skill. It checks every bundled file with the same checks the library validator applied to that kind of file, and reports any problem against the skill. There is no separate library validator. A separate check fails when a skill names a bundled file by anything other than a path relative to its own folder, one level deep, or names a file that is not there.

**Why this priority**: With the shared library gone, every file the library validator judged now sits in a skill folder. One validator per skill keeps that coverage and is what Phase 12 extends with the Agent Skills rules. It ranks below the user-facing stories because it changes no skill's behavior.

**Independent Test**: Run the skill validator on each skill. Seed a defect into a template in `assets/` and into a file in `references/` and confirm each fails the skill. Seed a skill text that names `references/sub/file.md`, `../highway-adr/assets/adr-record.md`, or a bundled file that does not exist, and confirm the path check fails.

**Acceptance Scenarios**:

1. **Given** the repository after this change, **When** a maintainer lists `framework/`, **Then** `validate-library.sh` is gone and no script, test, document, or harness file calls it.
2. **Given** a skill with files in `references/`, **When** the skill validator runs on it, **Then** each reference file is checked with the checks the library validator applied to a knowledge file, and a reference with a seeded defect fails the skill, naming `references/<file>`.
3. **Given** a skill with a complete template in `assets/`, **When** the skill validator runs on it, **Then** the template is checked as it is today, and a seeded defect fails the skill, naming `assets/<file>`. A seeded skeleton is still not checked as a complete template.
4. **Given** every Highway skill, **When** the path check runs, **Then** every bundled file the skill names is written as `references/<file>`, `assets/<file>`, or `scripts/<file>`, relative to its own folder and one level deep, and exists.
5. **Given** every Highway skill, **When** the path check runs, **Then** every file in its `references/`, `assets/`, and `scripts/` is named by that skill, so nothing ships that no skill reads.
6. **Given** a skill that names a path into another skill's folder, `.highway/`, `framework/`, `tests/`, or `harness/`, **When** the path check runs, **Then** it fails and names the skill and the path.
7. **Given** a skill that declares `metadata.dependencies`, **When** the skill validator runs, **Then** each dependency path resolves inside that skill's own folder, and a missing path or stale pinned version is reported as today.

---

### User Story 4 - The harness tests the skills as they will be installed (Priority: P2)

A maintainer runs a harness scenario. The test project gets the skill folders straight from `skills/`, placed where the harness's agent finds skills, then the scenario's fixture on top. It holds no distribution build, no `.highway/`, no framework README, and no other shipped material. The skills run with only their own folders, as they will in the plugin.

**Why this priority**: It is how the phase proves the skills are self-contained before Phase 14. A skill that still reached for a file outside its folder would find nothing in the test project and fail its scenario. It ranks below User Story 2 because the skills must be self-contained first.

**Independent Test**: Build a harness test project for a scenario and list it. Run the harness TypeScript tests and the fixture check. Run one live scenario when a token is available.

**Acceptance Scenarios**:

1. **Given** a scenario, **When** the harness builds its test project, **Then** the project holds a copy of every skill folder from `skills/` in the agent's skill location, plus the fixture, and nothing else from this repository.
2. **Given** a test project, **When** a maintainer lists it before the conversation, **Then** it holds no `.highway/` folder and no file from `framework/`, `tests/`, or `harness/`.
3. **Given** a fixture or stage snapshot that holds an agent skill folder, **When** the fixture check runs, **Then** it fails, because fixtures hold project files only and the harness supplies the skills.
4. **Given** a chain scenario, **When** a stage's output becomes the next stage's starting project, **Then** the snapshot excludes the skill folders, as it excluded the distribution before.
5. **Given** the harness coverage report, **When** it reads highway-codify's Verification, **Then** it has no waiver for a missing `.highway/` root, because no skill checks for one.

---

### User Story 5 - Checks, constitutions, and documents follow the change (Priority: P3)

Every bash check that read `.highway/catalog/index.json`, called the library validator, or relied on `.highway/` reads the new location or checks the new rule. Each new check is shown to fail on a seeded defect. The constitutions and the live documents describe a repository without `.highway/`.

**Why this priority**: Without it, the removal would silently switch off coverage or leave documents describing a folder that no longer exists. It adds no behavior of its own.

**Independent Test**: Run the bash suite and the harness TypeScript tests. Search the repository, outside `specs/`, for `.highway/` and `validate-library`.

**Acceptance Scenarios**:

1. **Given** the paths helper, **When** a script asks for highway-help's index, **Then** it gets `skills/highway-help/assets/index.json`, and the helper defines no `.highway/` location.
2. **Given** the help output tests, the catalog generation test, and the adapter coverage test, **When** they run, **Then** they read highway-help's `assets/index.json`, and each fails on a seeded defect.
3. **Given** a search of the repository outside `specs/`, **When** it looks for `.highway/`, **Then** it finds only a code product's `code/<folder>/.highway/` records, history in the constitutions' Sync Impact Reports, and the plan records in `standard-alignment.md` and `governance-plan.md`.
4. **Given** the Highway Skills Constitution and the development constitution, **When** a maintainer reads them, **Then** no current rule, definition, or gate names `.highway/` or the library validator, and each change is recorded in its Sync Impact Report.

---

### Edge Cases

- A code product's `code/<folder>/.highway/metadata.md` and `features/` are the person's records, written by highway-codify inside the product folder (Phase 2). They are not shipped material, keep their paths, and are not part of the `.highway/` this phase removes. highway-codify's sentence that this folder "does not make the product folder a Highway project" may be reworded, because `.highway/` no longer marks any project.
- A person whose repository has a `.highway/` folder from an earlier Highway install is not migrated. Highway is unreleased, and no skill reads or removes that folder.
- highway-help's index lists only Highway skills, not the speckit skills beside them in the agent folders, as today.
- highway-help's own entry is in its own index. Bumping highway-help's version changes the index, and the drift check sees it like any other change.
- A skill with no `## Example` section, or no dependencies, gets an index entry the generator can still build. Today every Highway skill has an Example and none declares dependencies, so `Dependencies:` reads `none` for every skill.
- The Agent Skills specification allows `metadata` to hold only string values, and `metadata.dependencies` is a list. Phase 12 decides its future. This phase only keeps it resolving inside the skill's own folder.
- The library validator's containment rule kept it from judging a person's file by its path. The skill validator judges only the folder it is given, so that rule is not carried over, and the test that guarded it is retired or reduced to what still applies.
- A reference has no frontmatter, and Agent Skills requires frontmatter only in `SKILL.md`. The library validator's frontmatter checks (`name`, `description`, `metadata.version`) therefore do not apply to `references/`. Nor do the rule-shape rules (P1.1, P1.3, P7.4, P7.5) or P7.1, which judge a skill's own instructions: the Experience Standard is a reference that defines rules for others in table rows. Citations (P3.5) and the remaining body rules apply.
- The library validator's governance file type has no remaining files once the library is empty. Its checks are carried over only for the file kinds that still exist in skill folders.
- Seeded skeletons in highway-setup's `assets/` are named by setup's Seed table and are checked against their reference copies by the catalog seeding test, as today, not as complete templates.
- The four agent skill folders in this repository (`.cursor/skills/`, `.claude/skills/`, `.github/skills/`, `.agents/skills/`) are generated copies of `skills/`. Each copy includes highway-help's `assets/index.json`.
- The distribution's record of the files it generated currently sits under `.highway/`. It moves to a location outside `.highway/` in the distribution, chosen in the plan.
- The distribution keeps shipping `framework/README.md` as its `README.md` until Phase 14. The harness test project does not include it.
- Test fixtures under `tests/fixtures/` that no test reads and that name `.highway/` are out of scope, as in Phases 9 and 10.
- Specs under `specs/` name `.highway/` as history and do not change.
- `rollout-plan.md` stays gitignored and excluded in the distribution manifest.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The index generator MUST write highway-help's index to `skills/highway-help/assets/index.json` instead of `.highway/catalog/index.json`. Each entry MUST hold the skill's id, name, description, usage, version, dependencies, and `## Example` invocation. It MUST NOT hold a path to another skill's folder. The same sources MUST always build the same bytes.
- **FR-002**: The index generator MUST fail, naming the skill, and write no index when any skill's frontmatter `name` differs from its folder name.
- **FR-003**: highway-help MUST read only its own `assets/index.json` in both modes. It MUST NOT read `.highway/`, another skill's folder, or another skill's `SKILL.md`, and MUST drop the run-time check that a skill's `name` equals its id. Its six-line Single-Skill output, its All-Skills listing, and its error cases MUST be unchanged except that the error for a missing or unreadable index names `assets/index.json`.
- **FR-004**: The drift check MUST compare highway-help's `assets/index.json` with a fresh build, so a change to any skill's frontmatter or `## Example` without regenerating fails.
- **FR-005**: `framework/validate-library.sh` MUST be removed. `framework/validate-skill.sh` MUST check each file in a skill's `references/` with the rule checks the library validator applied to a knowledge file's body, and each complete template in its `assets/` with the checks it applies today. A finding MUST name the file as `references/<file>` or `assets/<file>`. Every check the library validator applied to a file kind that still exists in skill folders MUST still run on that kind, except that references are exempt from the rule-shape rules (P1.1, P1.3, P7.4, P7.5) and P7.1 (see the edge case on references; refined during implementation, research R4).
- **FR-006**: The validation cache key MUST cover each skill's `references/` and `assets/`, so a change to any bundled file invalidates that skill's cached result.
- **FR-007**: Every Highway skill MUST name each bundled file as `references/<file>`, `assets/<file>`, or `scripts/<file>`, relative to its own folder and one level deep. Every named bundled file MUST exist, and every file in a skill's `references/`, `assets/`, and `scripts/` MUST be named by that skill.
- **FR-008**: A Highway skill MUST NOT name a path into another skill's folder, `.highway/`, `framework/`, `tests/`, or `harness/`. A code product's `code/<folder>/.highway/` records are project files, not this `.highway/`, and are allowed. A bash check MUST enforce FR-007 and FR-008 and fail on a seeded violation of each.
- **FR-009**: A skill's `metadata.dependencies` path MUST resolve inside that skill's own folder. The skill validator MUST report a missing path or a stale pinned version as it does today.
- **FR-010**: A Highway skill MUST NOT require or name `.highway/` as the project root. Each skill MUST work from the repository root it is run in, as the storage contract states. Each skill MUST drop its "Project root containing `.highway/`" input line, and no new project marker MAY replace it. highway-request, highway-codify, and highway-codify-config MUST drop their "project root cannot be located" stop, and rely on their existing seeded-file check, which shows the fixed setup message and writes nothing. Every other read and write MUST keep its path relative to the repository root.
- **FR-011**: highway-setup MUST write only the seeded files, each from its own `assets/`, and MUST NOT copy any skill, template, reference, governance file, index, or `.highway/` folder into the project. A bash check MUST verify this in setup's text and fail on a seeded violation.
- **FR-012**: `.highway/` MUST be removed from this repository. The paths helper MUST define no `.highway/` location, and a script, test, harness file, or manifest MUST NOT name `.highway/`, except a code product's `code/<folder>/.highway/` records.
- **FR-013**: The distribution MUST ship no `.highway/` folder. The skills MUST ship in the agent skill folders with their own `references/` and `assets/`, and the distribution's generation record MUST sit outside `.highway/`. The distribution manifest MUST drop its `.highway` rows, and `rollout-plan.md` MUST stay excluded.
- **FR-014**: The harness MUST build each test project from the skill folders in `skills/`, copied to the location the harness's agent discovers skills from, then the scenario's fixture or previous stage. The test project MUST hold no `.highway/` folder, no distribution build, and no file from `framework/`, `tests/`, or `harness/`. Chain snapshots MUST exclude the skill folders.
- **FR-015**: The harness fixture check MUST fail on a fixture or stage snapshot holding an agent skill folder, because the harness supplies the skills. The coverage waiver for a missing `.highway/` root MUST be removed with the Verification bullet it waives.
- **FR-016**: Every bash check that read `.highway/catalog/index.json`, called `validate-library.sh`, or relied on `.highway/` MUST check the same behavior at the new location or under the new rule. Each new or changed check MUST have a seeded failure that proves it fails. A test whose only subject was removed MUST be retired, and each assertion it held MUST be recorded as kept elsewhere or superseded.
- **FR-017**: Each changed Highway skill MUST increment its version MINOR.
- **FR-018**: Where the Highway Skills Constitution or the development constitution names `.highway/`, the library, or `validate-library.sh` in a current rule, definition, or gate, it MUST follow the new arrangement in an amendment classified under that constitution's own Versioning Policy, with the classification's reasoning recorded in its Sync Impact Report and, for the development constitution, with its self-application review. History in Sync Impact Reports MUST NOT change.
- **FR-019**: Live documents MUST describe the new arrangement in the same change: `README.md`, `framework/README.md`, `framework/authoring-standard.md`, `harness/README.md`, the statements in `governance-plan.md` that describe the current layout, and `standard-alignment.md`, which also marks Phase 11 complete with a status note.
- **FR-020**: Regenerating every generated artifact MUST leave no diff, and the generated agent skill folders MUST match `skills/`.
- **FR-021**: The full bash suite and the harness TypeScript tests MUST pass before the first edit and after the last.

### Key Entities

- **Bundled file**: a file inside a skill's own folder, in `references/`, `assets/`, or `scripts/`, named by that skill by a path relative to its folder, one level deep.
- **Help index**: highway-help's `assets/index.json`, generated from every Highway skill's frontmatter and `## Example`. highway-help's only file input.
- **Shipped material**: anything Highway supplies rather than the person writes: skill folders and their bundled files, the help index, templates, references, and governance text. A Highway project holds none of it outside the installed skills.
- **Seeded file**: an empty project file highway-setup writes from a skeleton in its own `assets/` when the file is absent. A project record, not shipped material.
- **Test project**: the temporary project the harness builds for one scenario attempt: the skill folders from `skills/` in the agent's skill location, plus the fixture.
- **Code product records**: a code product's `code/<folder>/.highway/metadata.md` and `features/`, written by highway-codify for the person. Not affected by this phase.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: `.highway/` exists in 0 places in this repository, in a freshly built distribution, and in a freshly built harness test project.
- **SC-002**: 0 Highway skills read or name a file outside their own folder, other than project files at paths relative to the repository root, and the path check passes for 100% of skills.
- **SC-003**: `/highway-help` and `/highway-help <id>` print the same output as before for 100% of skills, and highway-help has exactly 1 file input.
- **SC-004**: 0 scripts named `validate-library.sh` exist, and 100% of the files in skills' `references/` and complete templates in `assets/` are checked by the skill validator, each with a seeded defect that fails it.
- **SC-005**: `/highway-setup` in an empty project writes only the seeded files, and 0 other files.
- **SC-006**: Every harness test project holds 0 files from `framework/`, `tests/`, or `harness/`, and every scenario passes the harness's static checks.
- **SC-007**: Regenerating every generated artifact changes 0 files, and the full bash suite and the harness TypeScript tests pass.

## Assumptions

- The project root is the repository root the agent is run in, as the storage contract already states. With `.highway/` gone, nothing marks a Highway project. The seeded-file check, which already shows the fixed setup message in every skill that edits a seeded file, is enough to tell a person to run setup.
- The "No [record] is written beneath `.highway`" lines in the governance skills are removed or reworded, because nothing is beneath `.highway` any more.
- highway-help's index keeps the fields its output uses. `source_path` is dropped because highway-help no longer opens another skill's file, and `compatibility` is kept or dropped as the plan decides, since highway-help does not print it.
- The harness's agent is GitHub Copilot, which finds skills in the project's agent skill folders. The plan chooses which folder the harness copies `skills/` into.
- The distribution keeps its four agent skill folders and its `README.md` until Phase 14 replaces the distribution with the plugin.
- Live harness runs need an agent token. Scenarios and the test project are changed and statically checked in this phase, and run when a token is available, as in earlier phases.
- Only highway-codify is gated by harness coverage, so new Verification bullets in other changed skills are reported, not required to be covered.
- Highway is unreleased, so there is no backward compatibility to keep and no migration of projects made under the old arrangement.
- Historical specs and the Sync Impact Report history keep the old paths.
- Nothing is committed until the maintainer asks.
