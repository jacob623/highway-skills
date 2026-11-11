# Feature Specification: Standard Alignment Removals

**Feature Branch**: `feature/std-alignment-phase4`

**Created**: 2026-11-11

**Status**: Complete

**Input**: User description: "create a new spec for implementing phase 4 in standard-alignment.md". Phase 4 (Removals) removes the files that Phases 2 and 3 of `standard-alignment.md` drop and that nothing else depends on, before any file moves, so later phases convert and move fewer files. It removes the shared library index and its generator; the three library READMEs and the catalog README; the skill catalog's `index.md`, its `overlap_flags` field, and its `generated_at` field, with highway-help's line about `overlap_flags`; the finished one-off audits, the rename allowlist, and the library seeding script, with their tests; and the `.DS_Store` files. The always-on instructions wait for Phase 7, and `validate-library.sh` waits for Phase 11. Exit: the removed files are gone, nothing references them, and the full suite passes.

## Clarifications

### Session 2026-11-11

- Q: Should the stale-reference checks inside the two migration audits be kept as permanent checks, or dropped with the audits? → A: Drop both with their audits, and record each as superseded, naming the behavior it covered: the objective rename audit's scan for stale singular "objective" references, and the profile audit's scan for the former Profile path. Both migrations are finished, and Phases 6 to 11 rewrite or remove every path they scan.
- Q: With no generator writing a timestamp after this change, should the development constitution's two "no diff after regeneration" rules drop their timestamp exception? → A: Yes. Remove the timestamp exception from D4.2 and D4.7, and from their Enforcement Map notes, in this change, with a MAJOR version bump.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Remove the shared library index (Priority: P1)

A maintainer preparing the move to standard skill folders no longer has to keep a second catalog that indexes the shared library. The library index, the generator that writes it, and the test for that generator are gone, and nothing in the repository refers to them. The development constitution no longer lists that generator among the generators that must leave no diff.

**Why this priority**: The shared library is emptied by later phases, so its index has no future. It is also the largest removal, touching four tests, a fixture inventory, two READMEs, and the development constitution. Removing it first means Phase 5 converts fewer tests.

**Independent Test**: Run the full bash suite and search the repository for the library index and its generator. The suite passes and the search finds them only in `specs/`, `standard-alignment.md`, and `rollout-plan.md`.

**Acceptance Scenarios**:

1. **Given** the repository after this change, **When** a maintainer lists `.highway/catalog/` and `.highway/tools/`, **Then** neither `library-index.json`, `library-index.md`, `generate-library-catalog.sh`, nor its test exists.
2. **Given** the tests that referred to the library index (`adapter-coverage`, `distribution-packaging`, `feature-092-correspondence`, and the `profile-092` fixture inventories), **When** the suite runs, **Then** each passes without naming the library index.
3. **Given** the development constitution, **When** a maintainer reads its declared generators, **Then** `generate-library-catalog.sh` is not listed, and the amendment is recorded under the constitution's versioning policy.
4. **Given** the development constitution, **When** a maintainer reads D4.2, D4.7, and their Enforcement Map notes, **Then** none allows a generation timestamp difference, and the version is bumped MAJOR.
5. **Given** a distribution built after this change, **When** a maintainer lists it, **Then** it holds no library index.

---

### User Story 2 - Simplify the skill catalog (Priority: P1)

A maintainer regenerates the skill catalog and gets one machine-readable file whose bytes depend only on the skill sources. The human-readable `index.md` copy, the unused `overlap_flags` field, and the `generated_at` timestamp are gone. highway-help no longer points readers at `overlap_flags`, and its answers are otherwise unchanged.

**Why this priority**: Phase 11 moves this catalog into highway-help's own folder as its index. A catalog that builds the same bytes every time is what makes the later drift check and the reproducible plugin build possible.

**Independent Test**: Run the skill catalog generator twice and compare the outputs, then ask highway-help for all skills and for one named skill before and after the change.

**Acceptance Scenarios**:

1. **Given** unchanged skill sources, **When** the catalog generator runs twice, **Then** the two outputs are identical in every byte, with no timestamp exception.
2. **Given** the regenerated catalog, **When** a maintainer reads it, **Then** it has no `generated_at` field and no `overlap_flags` field, and `.highway/catalog/index.md` does not exist.
3. **Given** highway-help, **When** a maintainer reads its "When not to use" section, **Then** it no longer mentions `overlap_flags`, and the skill's version is bumped.
4. **Given** the all-skills listing and the single-skill details for every skill, **When** they are produced from the new catalog, **Then** they are the same as before the change.
5. **Given** the authoring standard, the catalog generator's test, and the root README, **When** a maintainer reads them, **Then** none describes `index.md`, `overlap_flags`, or `generated_at` as current behavior.
6. **Given** the generated agent copies of highway-help, **When** the adapter generator runs, **Then** each copy matches the changed source.

---

### User Story 3 - Remove READMEs for folders that are going away (Priority: P2)

A maintainer no longer finds README files describing the shared library folders and the catalog folder, whose contents later phases move into skills or drop. Nothing that listed those READMEs fails.

**Why this priority**: These files carry no behavior, but they describe a layout that is being retired. Leaving them invites edits to documents that will be deleted.

**Independent Test**: Confirm the four READMEs are gone, then run the bash suite and the harness checks that read the harness selection list.

**Acceptance Scenarios**:

1. **Given** the repository after this change, **When** a maintainer lists `.highway/library/governance/`, `.highway/library/knowledge/`, `.highway/library/templates/`, and `.highway/catalog/`, **Then** none holds a `README.md`.
2. **Given** the harness selection list, **When** it is read, **Then** it names none of the removed READMEs, and every path it names exists.
3. **Given** the skill catalog generator, **When** it runs, **Then** it neither reads nor links to the catalog README.

---

### User Story 4 - Remove finished one-off tooling (Priority: P2)

A maintainer no longer carries scripts for migrations that are finished, or a script that copies source files that no longer exist. The objective rename audit and its allowlist, the profile migration audit, and the library seeding script are gone, with the tests that exercised only them. Any check in those tests that still guards current behavior is kept elsewhere.

**Why this priority**: These scripts ship to users today and run against nothing current. Removing them shrinks the tools that Phase 6 moves.

**Independent Test**: Confirm the scripts, the allowlist, and their tests are gone, the distribution manifest has no rows for them, and the suite passes.

**Acceptance Scenarios**:

1. **Given** the repository after this change, **When** a maintainer lists `.highway/tools/`, **Then** `audit-objective-rename.sh`, `.objective-rename-allowlist`, `audit-profile-migration.sh`, and `seed-library-context.sh` do not exist.
2. **Given** the tests `objective-rename-contract`, `profile-migration`, and `seed-library-context`, **When** a maintainer reviews the change, **Then** each is removed, and each of its assertions that covers still-present behavior is either kept in another test or recorded as superseded with the behavior it covered.
3. **Given** the distribution manifest, **When** a maintainer reads it, **Then** it has no row for a removed file.

---

### Edge Cases

- A test asserts on a removed file indirectly, through a fixture inventory such as the `profile-092` inventory files. The fixture rows for removed files are removed with the reason, and the test still passes.
- A test that is removed also checks behavior that stays. That check moves to a test that remains, or is recorded as superseded with the behavior it covered. No assertion is dropped silently.
- A stale singular "objective" reference or a reference to the former Profile path reappears after this change. No check catches it, because those scans are recorded as superseded. Later phases rewrite or remove the paths they covered.
- The catalog generator's test currently allows a timestamp difference between two runs. With no timestamp, the test requires identical output, which makes it stricter rather than weaker.
- A stale `index.md` or library index already exists in a project installed from an earlier distribution. Backward compatibility is not required, so the distribution generator does not clean it up.
- The harness path map lists `.highway/catalog/index.md`. That entry is removed so the path map names only files that exist.
- A `.DS_Store` file appears again later. It is untracked and already ignored, and the distribution manifest keeps excluding it.
- Files Phase 4 does not remove stay in place and keep working: the always-on instructions and their generator (Phase 7), `validate-library.sh` (Phase 11), and the skill catalog's `index.json` (moved in Phase 11).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The repository MUST NOT contain `.highway/catalog/library-index.json`, `.highway/catalog/library-index.md`, `.highway/tools/generate-library-catalog.sh`, or `.highway/tools/tests/generate-library-catalog.test.sh`.
- **FR-002**: No file outside `specs/`, `standard-alignment.md`, and `rollout-plan.md` MUST name the library index or its generator. This covers the tests `adapter-coverage`, `distribution-packaging`, and `feature-092-correspondence`, the `profile-092` fixture inventories, the catalog and tools READMEs, and the development constitution.
- **FR-003**: The development constitution MUST NOT list `generate-library-catalog.sh` among its declared generators. D4.2, D4.7, their Enforcement Map notes, and the declared generators note MUST NOT allow a generation timestamp difference. The amendment MUST be a MAJOR version bump, recorded with its self-application review.
- **FR-004**: The skill catalog generator MUST write only `.highway/catalog/index.json`, with no `generated_at` field and no `overlap_flags` field, and `.highway/catalog/index.md` MUST NOT exist.
- **FR-005**: Two runs of the skill catalog generator over unchanged skill sources MUST produce byte-identical output, and its test MUST assert that identity with no timestamp exception.
- **FR-006**: highway-help MUST NOT mention `overlap_flags`, MUST bump its version, and MUST produce the same all-skills listing and single-skill details as before for every registered skill.
- **FR-007**: The authoring standard, the root README, the tools README, and the harness path map MUST NOT describe `index.md`, `overlap_flags`, or `generated_at` as current behavior.
- **FR-008**: The repository MUST NOT contain `README.md` in `.highway/library/governance/`, `.highway/library/knowledge/`, `.highway/library/templates/`, or `.highway/catalog/`, and no generator, test, or harness selection entry MUST name them.
- **FR-009**: The repository MUST NOT contain `audit-objective-rename.sh`, `.objective-rename-allowlist`, `audit-profile-migration.sh`, `seed-library-context.sh`, or the tests `objective-rename-contract.test.sh`, `profile-migration.test.sh`, and `seed-library-context.test.sh`.
- **FR-010**: Every assertion in a removed test that covers behavior still present MUST be kept in a remaining test, or recorded as superseded with the behavior it covered. The objective rename audit's stale singular "objective" reference scan and the profile audit's former Profile path scan are recorded as superseded, not kept.
- **FR-011**: The distribution manifest MUST have no row for a removed file, and a distribution built after this change MUST contain none of the removed files.
- **FR-012**: The generated agent copies MUST be regenerated so that no generator leaves a diff against the committed artifacts.
- **FR-013**: Local `.DS_Store` files under `.highway/` MUST be deleted. They are untracked and ignored, so the change records no repository diff for them, and the distribution manifest keeps its `.DS_Store` exclusion.
- **FR-014**: The change MUST NOT remove or alter the always-on instructions or their generator, `validate-library.sh`, or the skill catalog's `index.json` beyond the two removed fields.
- **FR-015**: The full bash suite MUST pass before the first edit and after the last.

### Key Entities

- **Skill catalog**: the generated, machine-readable list of registered skills that highway-help reads. After this change it is one file whose bytes depend only on the skill sources.
- **Library index**: the generated index of the shared library. Removed with its generator.
- **Distribution manifest**: the declaration of which files ship. It loses its rows for removed files.
- **Declared generators**: the development constitution's list of generators that must leave no diff after regeneration. It loses the library index generator, and no generator may differ by a timestamp.
- **Harness selection list and path map**: the harness's lists of shared files and paths. They lose their entries for removed files.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A search of the repository, outside `specs/`, `standard-alignment.md`, and `rollout-plan.md`, finds 0 references to any removed file, to `overlap_flags`, or to `generated_at` in the skill catalog.
- **SC-002**: The full bash suite passes, and the number of test files drops by exactly 4 (the library catalog, objective rename, profile migration, and library seeding tests), with no other test file removed.
- **SC-003**: Two consecutive runs of every declared generator over unchanged sources differ in 0 bytes, and the development constitution states no timestamp exception.
- **SC-004**: For all 15 registered skills, highway-help's single-skill details, and its all-skills listing, are identical before and after the change.
- **SC-005**: A distribution built after the change contains 0 of the removed files, and the packaged tree validates.
- **SC-006**: Every path named in the harness selection list and path map exists.
- **SC-007**: Every assertion dropped with a removed test is accounted for: 100% are either kept in a remaining test or recorded as superseded.

## Assumptions

- Backward compatibility is not required. A project installed from an earlier distribution keeps any stale catalog or library index files, and nothing cleans them up.
- The `.DS_Store` files are untracked and already ignored, so deleting them is local housekeeping with no repository diff.
- The highway-help change is a patch-level version bump, because only the "When not to use" line changes and no output changes.
- The development constitution amendment is MAJOR, because removing the timestamp exception strengthens D4.2 and D4.7. Every generator already meets the stricter rules once `generated_at` is gone, so no current work fails them.
- `index.json` stays at `.highway/catalog/` until Phase 11 moves it into highway-help's folder.
- Phase 4 removes only what `standard-alignment.md` assigns to it. Every later removal stays in its own phase.
