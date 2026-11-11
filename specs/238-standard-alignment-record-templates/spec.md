# Feature Specification: Standard Alignment Record Templates in Their Skills

**Feature Branch**: `feautre/std-alignment-phase9`

**Created**: 2026-11-11

**Status**: Draft

**Input**: User description: "create a new spec for implementing phase 9 in standard-alignment.md". Phase 9 (Record Templates in Their Skills) moves each single-consumer record template into the `assets/` of the skill that creates the record, following the Phase 2 resolutions. `codify-metadata.md`, `codify-plan.md`, `codify-record.md`, and `codify-tasks.md` move to highway-codify. `coding-standard.md` moves to highway-codify-config. `control-record.md`, `nfr-record.md`, and `objective-record.md` move to their governance skills. `discovery-record.md`, `request-record.md`, and `profile-record.md` move to their skills, and highway-profile drops its guards against `.highway/library/knowledge/profile.md`. Each skill names its asset by a path relative to its own folder. Exit: only `adr-record.md`, `architecture-record.md`, and `implementation-record.md` remain in `.highway/library/templates/`, and the full suite and harness pass.

## Clarifications

### Session 2026-11-11

- Q: How should the four moved templates the library validator checks today keep that validation once they live in skill `assets/`? → A: The skill validator checks the templates in each skill's own `assets/` from this phase on, bringing that part of Phase 11 forward. The library validator keeps checking only what remains under `.highway/library/`.
- Q: Which files in a skill's `assets/` should the skill validator check as templates? → A: Only complete templates, meaning files with a `## File Frontmatter`, `## Body`, or `## Catalog Structure` section: the 11 moved record templates and the 3 governance catalog templates. highway-setup's skeletons are not validator-checked. Instead, `tests/catalog-seeding.test.sh` gains exact-content checks for each skeleton, so a dropped heading or table column fails, and `storage.md` must say `Mode: Local`.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Each record template lives with the skill that creates the record (Priority: P1)

A maintainer opens a skill folder and finds the template for every record that skill creates in its own `assets/`, next to its `SKILL.md`. The skill names that template by a path relative to its own folder. A person using Highway sees no difference: each skill writes the same records, at the same paths, at the same moments, in the same structure as before.

**Why this priority**: This is the phase's purpose. A plugin skill cannot read files outside its own folder, so a template that only one skill uses must travel with that skill. Each of these 11 templates has exactly one reader, so moving it changes nothing else.

**Independent Test**: List each owning skill's `assets/` and compare every moved file with its pre-change content. Search every Highway skill for `.highway/library/templates/`. Run each owning skill's harness smoke scenario and confirm the records it writes still pass their template assertions.

**Acceptance Scenarios**:

1. **Given** the repository after this change, **When** a maintainer lists the skills' `assets/`, **Then** they hold these templates, each byte-identical to its pre-change content:

   | Skill | Templates |
   | --- | --- |
   | highway-codify | `codify-metadata.md`, `codify-plan.md`, `codify-record.md`, `codify-tasks.md` |
   | highway-codify-config | `coding-standard.md` |
   | highway-controls | `control-record.md` |
   | highway-nfrs | `nfr-record.md` |
   | highway-objectives | `objective-record.md` |
   | highway-discovery | `discovery-record.md` |
   | highway-request | `request-record.md` |
   | highway-profile | `profile-record.md` |

2. **Given** each owning skill, **When** a maintainer reads its Inputs, Outputs, procedure steps, and Verification, **Then** every mention of a moved template is `assets/<file>.md`, and the skill names no path under `.highway/library/templates/`.
3. **Given** `.highway/library/templates/output/` after this change, **When** a maintainer lists it, **Then** it holds exactly `adr-record.md`, `architecture-record.md`, and `implementation-record.md`.
4. **Given** any owning skill and a project in the same state as before, **When** the skill runs, **Then** it writes the same files, at the same paths, at the same points in its flow, in the same structure, as before the change.
5. **Given** any Highway skill other than a template's owner, **When** a maintainer reads it, **Then** it does not name that template.

---

### User Story 2 - highway-profile stops guarding a location that no longer exists (Priority: P2)

highway-profile reads and writes the Profile at `library/knowledge/profile.md` from the repository root, as it does today. Its two sentences forbidding it from reading, copying, reviewing, or writing `.highway/library/knowledge/profile.md` are removed. No such file ships, and `.highway/` no longer holds project data.

**Why this priority**: The guards defend against a file that Phase 8 already removed the folder for. They cost words and point at a location Phase 11 deletes. Removing them is part of Phase 9's step 4, but it does not change which file the skill uses.

**Independent Test**: Search highway-profile for `.highway/library/knowledge/`. Run the profile harness scenario and the profile bash tests.

**Acceptance Scenarios**:

1. **Given** highway-profile after this change, **When** a maintainer searches it, **Then** it does not contain `.highway/library/knowledge/`.
2. **Given** highway-profile, **When** it reads or writes the Profile, **Then** it uses `library/knowledge/profile.md` from the repository root, as before.
3. **Given** every Highway skill, **When** a maintainer searches it, **Then** none names `.highway/library/knowledge/`.

---

### User Story 3 - The checks follow the templates to their new homes (Priority: P2)

Every structural check that compared a record against one of the moved templates still runs, now against the template in the owning skill's `assets/`. The bash fixture checks, the harness template assertions, the validator checks that apply to templates, and the harness scenario selection all find each template at its new location. A record that drifts from its template's structure is still caught.

**Why this priority**: Without it, moving the templates would silently switch off the checks that keep records in shape. It ranks below the move because it adds no new behavior, only keeps existing coverage.

**Independent Test**: Run the template check for each moved template against a matching record and against a copy with a required heading removed. Validate each moved template that the library validator checks today. Ask the harness which scenarios a change to each moved template selects. Build the distribution and list what it ships.

**Acceptance Scenarios**:

1. **Given** a record and its moved template, **When** the template check runs, **Then** it reads the template from the owning skill's `assets/` and reports missing parts as it does today.
2. **Given** a record with a required heading removed, **When** the template check runs against its moved template, **Then** it fails.
3. **Given** the harness scenarios and fixtures, **When** a maintainer runs the fixture check and the scenario template assertions, **Then** each finds the moved template at its new location, and every check that passed before still passes.
4. **Given** each moved template that the library validator checks today (`nfr-record.md`, `control-record.md`, `objective-record.md`, and `request-record.md`), **When** the skill validator runs on the owning skill, **Then** it applies the same frontmatter and content checks to that template, and a template that breaks one of them makes the skill fail validation and the bash suite fail.
5. **Given** a change to a moved template, **When** the harness selects scenarios for that path, **Then** it selects the owning skill's scenarios, as a change to the old path did.
6. **Given** the distribution, **When** a maintainer builds it, **Then** each moved template ships inside its skill's folder, the manifest lists none of them under `.highway/library/templates/output/`, and the three remaining record templates still ship.
7. **Given** the generators, **When** every generated artifact is regenerated, **Then** each moved template appears in every agent copy of its skill, and a second regeneration changes no file.
8. **Given** the three governance catalog templates in the `assets/` of highway-objectives, highway-controls, and highway-nfrs, **When** the skill validator runs on each skill, **Then** it checks that catalog template the same way as the skill's record template.
9. **Given** highway-setup's skeletons, **When** the skill validator runs on highway-setup, **Then** it does not check them as templates, because they have no `## File Frontmatter`, `## Body`, or `## Catalog Structure` section.
10. **Given** a copy of a seeded skeleton with one heading, version line, frontmatter key, or table header column removed or changed, **When** the catalog seeding test runs on it, **Then** the test fails and names the skeleton and the difference.
11. **Given** highway-setup's storage skeleton, **When** the catalog seeding test runs, **Then** it fails unless the skeleton says `Mode: Local`.

---

### Edge Cases

- `adr-record.md`, `architecture-record.md`, and `implementation-record.md` have more than one reader until Phase 10 hands onboarding's records to their owners. They stay in `.highway/library/templates/output/`, and their readers do not change.
- highway-codify writes records under `code/<folder>/.highway/`. Those are the person's project records, not shipped material, and their paths do not change.
- highway-codify creates `codify-tasks.md` only when the person continues from the plan, and it creates `metadata.md` only for a new product; a joined product keeps its file. Those conditions do not change.
- highway-codify-config writes a standard from `coding-standard.md` only when the person accepts the standard proposal. Its catalog row still goes in the seeded `library/coding-standards/coding-standards.md`.
- highway-profile still creates `library/knowledge/` when it is absent, because highway-profile can run before highway-setup has seeded that folder.
- The library validator accepts only files under `library/templates/`, `library/knowledge/`, or `library/governance/`. It keeps checking what remains there, the three shared record templates. The skill validator takes over the checks for templates in a skill's own `assets/` now; Phase 11 still merges the rest of the library validator into it.
- Test fixtures under `tests/fixtures/` that model other skills, such as the Profile participation fixtures, are not Highway skills. The plan decides whether they change.
- Each moved template keeps its own frontmatter (`name`, `description`, `metadata.version`), as the governance catalog templates did when Phase 8 moved them.
- The skeletons are checked today only for presence, placeholders, and data rows, and the fixture check only confirms that fixtures contain each skeleton's parts. A skeleton that lost a heading or column would still pass. FR-009 closes that gap. `assessment-findings.md` and `codify-platforms.md` carry project frontmatter, which the exact-content check covers as frontmatter keys rather than as template frontmatter.
- The three governance catalog templates were unchecked by any validator after Phase 8 moved them. FR-008 now covers them, so a defect they already hold could surface when this phase lands; the plan records any such finding.
- The Highway Skills Constitution already accepts a template in a skill's own `assets/` (P9.1, 10.3.0), so no rule changes for the citation itself.
- Specs under `specs/` name the old locations as history and do not change.
- `rollout-plan.md` stays gitignored and excluded in the distribution manifest.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The 11 record templates MUST move from `.highway/library/templates/output/` to the `assets/` of their owning skills, as listed in User Story 1, with their content unchanged.
- **FR-002**: Each owning skill MUST name each moved template by the path `assets/<file>.md`, relative to its own folder, everywhere it names it, and MUST NOT name any path under `.highway/library/templates/`.
- **FR-003**: After this change, `.highway/library/templates/output/` MUST hold exactly `adr-record.md`, `architecture-record.md`, and `implementation-record.md`, and every skill that reads those three MUST be unchanged in how it reads them.
- **FR-004**: Each owning skill MUST write the same records, at the same paths, under the same conditions, in the same structure, as before the change. Content edits MUST be limited to the moved template paths, the profile guards in FR-005, and the version change.
- **FR-005**: highway-profile MUST remove its sentences forbidding it from reading, copying, reviewing, or writing `.highway/library/knowledge/profile.md`, and MUST keep reading and writing `library/knowledge/profile.md` from the repository root. A Highway skill MUST NOT name `.highway/library/knowledge/`.
- **FR-006**: Every skill whose text changes MUST increment its version MINOR.
- **FR-007**: The paths helper MUST resolve each moved template at its new location, and every script, test, harness check, and scenario that names a moved template MUST find it there. A test or harness file MUST NOT name a moved template by its old path.
- **FR-008**: Every check that applied to a moved template or compared a record against it before this change MUST still apply at the new location. The skill validator MUST check each complete template in a skill's own `assets/`, meaning a file with a `## File Frontmatter`, `## Body`, or `## Catalog Structure` section, with the same frontmatter and content checks the library validator applies to a template today, including its exemption from the keyword checks. This covers the 11 moved record templates and the 3 governance catalog templates, so `nfr-record.md`, `control-record.md`, `objective-record.md`, and `request-record.md` keep their coverage. The skill validator MUST NOT check highway-setup's skeletons as templates. A template that fails those checks MUST make its skill fail validation. Each structural check, and the new validator check, MUST have a seeded failure that proves it fails.
- **FR-009**: `tests/catalog-seeding.test.sh` MUST check each of highway-setup's 12 skeletons against its exact expected structure: its frontmatter keys, every heading, the `Version: 1.0.0` line where the catalog has one, and every table header row. A skeleton with any of these removed, added, or changed MUST fail the test, which names the skeleton and the difference. The storage skeleton MUST say `Mode: Local`. Each new check MUST have a seeded failure that proves it fails.
- **FR-010**: A change to a moved template MUST select its owning skill's harness scenarios, as a change to its old path did.
- **FR-011**: The distribution manifest, the generators, the agent copies, and highway-help's catalog MUST follow the new arrangement: each moved template ships inside its skill's folder wherever skills ship, and the manifest lists none of them under `.highway/library/templates/output/`. Regenerating every generated artifact MUST then leave no diff.
- **FR-012**: Where the Highway Skills Constitution or the development constitution names these templates' location, it MUST follow the new arrangement as a MINOR amendment, recorded in its Sync Impact Report and, for the development constitution, with its self-application review.
- **FR-013**: Live documents MUST describe the new arrangement in the same change: `README.md`, `framework/README.md`, `framework/authoring-standard.md`, `harness/README.md`, and `standard-alignment.md`, which also marks Phase 9 complete with a status note.
- **FR-014**: The full bash suite and the harness TypeScript tests MUST pass before the first edit and after the last.

### Key Entities

- **Record template**: the complete structure of one kind of record a skill creates, with its own frontmatter. After this phase, each single-reader record template lives in its owning skill's `assets/`.
- **Owning skill**: the one skill that creates a kind of record and the only skill that reads its template.
- **Remaining shared record template**: `adr-record.md`, `architecture-record.md`, or `implementation-record.md`, which stays in `.highway/library/templates/output/` until Phase 10 because highway-onboarding also reads it.
- **Complete template**: a file in a skill's `assets/` with a `## File Frontmatter`, `## Body`, or `## Catalog Structure` section, checked by the skill validator.
- **Skeleton**: one of highway-setup's 12 empty project files in its `assets/`, with no such section. The catalog seeding test checks its exact structure, and the skill validator does not check it as a template.
- **Profile guard**: a sentence in highway-profile forbidding use of `.highway/library/knowledge/profile.md`, removed by this phase.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 11 of 11 moved templates are in their owning skills' `assets/`, each byte-identical to its pre-change content.
- **SC-002**: `.highway/library/templates/output/` holds exactly 3 files, and 0 Highway skills name a moved template by a path under `.highway/`.
- **SC-003**: 0 Highway skills name `.highway/library/knowledge/`.
- **SC-004**: Every check that covered a moved template before this change still runs against it, and each structural check still fails on a seeded defect. The skill validator checks 14 of 14 complete templates in skill `assets/` and 0 of 12 skeletons.
- **SC-005**: For each of the 12 skeletons, removing or changing one heading, version line, frontmatter key, or table header column fails the bash suite, and the storage skeleton fails unless it says `Mode: Local`.
- **SC-006**: Each owning skill's harness smoke scenario writes the same records as before and passes its template assertions.
- **SC-007**: Regenerating every generated artifact produces 0 changed files, the distribution ships each moved template inside its skill, and the full bash suite and the harness TypeScript tests pass.

## Assumptions

- The move uses `mv`, so each template's content and frontmatter stay as they are.
- The owning skills are highway-codify, highway-codify-config, highway-controls, highway-nfrs, highway-objectives, highway-discovery, highway-request, and highway-profile. Each takes one MINOR version.
- No skill's behavior changes, so no harness scenario's expected conversation changes. Scenarios change only where they name a template's location.
- The harness stage fixtures hold project records, whose structure does not change, so their content does not change.
- The distribution keeps placing skills under `.highway/skills/` until Phase 14, so the moved templates ship there with their skills and their agent copies.
- highway-onboarding's ADR, architecture, and implementation writing, and the three remaining templates, move in Phase 10.
- Highway is unreleased, so there is no backward compatibility to keep and no migration of projects made under the old arrangement.
- Historical specs keep the old paths.
- Nothing is committed until the maintainer asks.
