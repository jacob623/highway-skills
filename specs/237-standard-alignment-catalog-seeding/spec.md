# Feature Specification: Standard Alignment Catalog Seeding

**Feature Branch**: `feature/std-alignment-phase8`

**Created**: 2026-11-11

**Status**: Draft

**Input**: User description: "create a new spec to implement phase 8 in standard-alignment.md". Phase 8 (Catalog Seeding) makes highway-setup guarantee that every catalog exists, following the Phase 1 catalog rule, and moves each catalog's rules into the skills that write it. highway-setup's `assets/` holds the skeletons of the 11 seeded catalogs and of the storage record. Setup writes each one once, only when it is absent, and never overwrites it. The catalog templates' rules move into the skills that write each catalog. Two rules are shared between skills: the capability title rule and the ADR ID cell format. A generator inserts each shared rule into every skill that states it, from one source, and a drift check fails when a copy differs. Skills drop their "create the catalog when absent" steps; a skill that must edit a seeded file that is still absent follows highway-setup's seeding step for it, then continues. The Phase 1 ownership changes for `codify-platforms.md`, `capability-catalog.md`, `adr-catalog.md`, and `architecture-catalog.md` take effect. The three governance catalog templates move to the `assets/` of highway-objectives, highway-controls, and highway-nfrs, and are not seeded. The findings file moves to the project's `library/knowledge/assessment-findings.md` and is seeded (Phase 2). The bash fixture checks and the harness template assertions compare project files against the skeletons. Exit: a fresh highway-setup run leaves every catalog in place, no catalog template remains in `.highway/library/templates/`, and the full suite and harness pass.

The Clarifications below change two points of that summary: a skill that finds a seeded file absent stops and directs the person to `/highway-setup` instead of following a seeding step, and each shared rule is kept in step by a check against one source instead of a generator.

## Clarifications

### Session 2026-11-11

- Q: When should highway-setup write the empty catalogs and the storage record into the project? → A: At the start of every setup run, before the welcome and Profile, without showing the person anything.
- Q: When a skill needs to edit a seeded file that is missing, what should it do? → A: Stop and tell the person to run `/highway-setup` first, without writing anything. The check runs before the skill's first question, so no answers are lost.
- Q: Should the "Highway is not set up" stop be worded as one fixed instruction that is identical in every skill that has the check? → A: Yes. Each skill names the seeded files it can edit, then uses one identical instruction that shows this message exactly, which the bash test matches: a bold line `**Oops... we need to setup your repository.**`, a blank line, then `Highway needs to gather your organizational preferences and set up your repository. Run /highway-setup to get started.`
- Q: How should the two shared rules (the capability title rule and the ADR ID cell format) be kept identical across the skills that state them? → A: One source file per rule in the repository, with no generator. A bash check fails when either skill's copy differs from the source.
- Q: Should the harness add a scenario that runs a writing skill in a project with no catalogs and checks the "Oops" message? → A: Yes, one scenario: highway-request runs in a project with no seeded files, and the scenario checks the exact message, that the skill asks no question, and that no file is written.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Setup leaves every catalog in place (Priority: P1)

A person runs `/highway-setup` in a new project. Alongside the Profile and the three governance baselines, the project now holds every catalog Highway uses, each empty and ready, plus the storage record that names Local mode. Later skills add rows to files that already exist instead of each one deciding how to create its catalog.

**Why this priority**: This is the phase's purpose. A plugin skill cannot read another skill's folder, so a catalog template that several skills share cannot stay in `.highway/library/templates/`. Once setup has written the empty file into the project, that file is the only copy any skill reads or edits.

**Independent Test**: Run highway-setup in an empty project and list the project files. Run it again in a project whose catalogs hold rows, and compare the files before and after.

**Acceptance Scenarios**:

1. **Given** the repository after this change, **When** a maintainer lists highway-setup's `assets/`, **Then** it holds exactly 12 skeletons: the 11 seeded catalogs and the storage record.
2. **Given** an empty project, **When** highway-setup runs, **Then** the project holds `requests/requests.md`, `discoveries/discoveries.md`, `adrs/adrs.md`, `architectures/architectures.md`, `implementations/implementations.md`, `implementations/capabilities.md`, `code/code.md`, `code/integrations.md`, `library/coding-standards/codify-platforms.md`, `library/coding-standards/coding-standards.md`, `library/knowledge/assessment-findings.md`, and `library/knowledge/storage.md`, each identical to its skeleton.
3. **Given** a seeded catalog, **When** a maintainer reads it, **Then** it holds only the structure (any frontmatter, the heading, the version line where the catalog has one, and the table header) and no data rows or placeholder rows.
4. **Given** the seeded storage record, **When** a maintainer reads it, **Then** it names Local as the mode.
5. **Given** a project where some seeded files already exist, with or without rows, **When** highway-setup runs, **Then** it writes only the absent ones and leaves every existing file byte-identical.
6. **Given** a setup run where an owner stops without `Finished`, **When** the run ends, **Then** every seeded file still exists, because seeding happens before Profile.
7. **Given** a setup run, **When** the person reads the conversation, **Then** nothing about seeding is shown: the welcome, transitions, and conclusion are unchanged.
8. **Given** a project whose storage record names a mode other than Local, **When** highway-setup runs, **Then** it stops before seeding, as the storage contract directs.

---

### User Story 2 - Each catalog's rules live in the skills that write it (Priority: P1)

A skill that writes a catalog states that catalog's rules in its own text: row order, status values, id formats, removed rows, version changes, and cell formats. It no longer reads a template to learn them. Where two skills write the same rule, both state it in identical words, and the repository fails a check when the copies drift.

**Why this priority**: Once the empty file is in the project, the template's rules have nowhere else to live. A skill that does not state them would write rows that drift from what other skills and checks expect.

**Independent Test**: For each seeded catalog, compare the rules in the retired template with the text of each skill that writes that catalog. Run the shared-rule check, then change one copy and run the check again.

**Acceptance Scenarios**:

1. **Given** each of the 11 seeded catalogs, **When** a maintainer compares its retired template's rules with the skills that write it, **Then** every rule about what that skill writes is stated in that skill's own text.
2. **Given** highway-architecture and highway-implementation, **When** a maintainer reads them, **Then** both state the capability title rule in identical words: a capability title is one noun phrase of five words or fewer, with no `and`, `or`, `&`, `/`, `+`, or comma, and a title that joins two things becomes two capabilities.
3. **Given** highway-architecture and highway-adr, **When** a maintainer reads them, **Then** both state the ADR ID cell format in identical words: ids in id order, separated by a comma and a space; a superseded or removed decision is not in the cell; an ADR id is on at most one row, except a span decision, which is on the row of each architecture it names.
4. **Given** each shared rule, **When** a maintainer looks for its source, **Then** one file in the repository holds the rule, and each skill that states it holds the same words. No generator writes the rule into a skill.
5. **Given** a copy of a shared rule edited by hand so that it differs from its source, **When** the bash suite runs, **Then** a check fails and names the skill and the rule.
6. **Given** any Highway skill, **When** a maintainer searches it, **Then** it names none of the 14 catalog templates by a path under `.highway/library/templates/`.

---

### User Story 3 - Skills edit the seeded files instead of creating them (Priority: P1)

A skill that adds a row to a catalog edits the file that is already in the project and follows its structure. It does not create the catalog or its folder when absent, and it does not rewrite the whole file from a template. If a seeded file it edits is still absent, for example because setup has not run, the skill stops before asking the person anything, writes nothing, and tells the person to run `/highway-setup` first.

**Why this priority**: highway-setup is the only path that writes a seeded file, so every project's catalogs have the same shape whichever skill touches them first. Stopping before the first question means the person never loses answers to a write that cannot happen.

**Independent Test**: Read each writing skill for its write step and its entry check. Run a writing skill against a project with no catalogs and confirm it stops before its first question, writes nothing, and directs the person to `/highway-setup`.

**Acceptance Scenarios**:

1. **Given** any Highway skill, **When** a maintainer reads it, **Then** it has no step that creates a seeded catalog, or its folder, when absent, and no step that writes a seeded catalog whole from a template.
2. **Given** a skill that can edit a seeded file, and a project where that file is absent, **When** the skill runs, **Then** after activating highway-experience and before its first question to the person, it stops, writes no file, and shows exactly the setup-needed message:

   ```markdown
   **Oops... we need to setup your repository.**

   Highway needs to gather your organizational preferences and set up your repository. Run /highway-setup to get started.
   ```
3. **Given** a skill that only reads a seeded file that is absent, **When** it runs, **Then** it treats the file as empty, as it does today, and does not stop.
4. **Given** a project where the person ran `/highway-setup` after such a stop, **When** they run the skill again, **Then** the seeded files exist and the skill proceeds as normal.
5. **Given** a harness scenario that runs highway-request in a project with no seeded files, **When** the run is checked, **Then** it shows the setup-needed message exactly, asks no question, and writes no file, and a run that asks a question or writes a file fails.

---

### User Story 4 - Catalog ownership follows Phase 1 (Priority: P2)

Each shared catalog has the owner Phase 1 decided. highway-implementation adds platform rows, and highway-codify-config alone configures them. highway-implementation is the only writer of capabilities. highway-adr owns the ADR catalog. highway-architecture owns the architecture catalog, and highway-adr touches only an existing row's ADR ID cell.

**Why this priority**: Without one writer per change, two skills could each rewrite a catalog from their own copy of its rules. It ranks below seeding because it narrows existing behavior rather than adding any.

**Independent Test**: Read the four catalogs' writing skills for their inputs and write steps. Run the existing tests for codify platforms, capabilities, ADRs, and architectures.

**Acceptance Scenarios**:

1. **Given** `library/coding-standards/codify-platforms.md`, **When** highway-implementation records an implementation, **Then** it adds one row per Implementation ID with Kind, When to use, and When not to use blank, and changes no other row.
2. **Given** `library/coding-standards/codify-platforms.md`, **When** highway-codify-config accepts a change, **Then** it adds, updates, or removes that one row in the existing file and changes no other byte. It is the only skill that sets Kind and the two guidance lists.
3. **Given** highway-onboarding and highway-codify, **When** a maintainer reads them, **Then** they read `codify-platforms.md` and do not write it, and highway-onboarding does not name its template.
4. **Given** `implementations/capabilities.md`, **When** any skill writes it, **Then** it is highway-implementation, and each write replaces only that implementation's rows.
5. **Given** highway-codify-config, **When** it titles a platform's new capabilities, **Then** it does not check the capability title rule and does not name the capability template; it passes the new capabilities to highway-implementation, which leaves out any title that breaks the rule.
6. **Given** `adrs/adrs.md`, **When** highway-adr writes it, **Then** it adds rows and marks replaced decisions `superseded` in the existing file, following the rules in its own text.
7. **Given** highway-onboarding, **When** a maintainer reads it, **Then** it does not name the ADR catalog template and still reads `adrs/adrs.md`. Until Phase 10 hands ADR creation to highway-adr, onboarding adds its ADR row by editing the existing file in the file's structure.
8. **Given** `architectures/architectures.md`, **When** highway-architecture writes it, **Then** it adds a row in the existing file, following the rules in its own text.
9. **Given** highway-adr, **When** a decision replaces, runs beside, reuses an implemented architecture, or spans architectures, **Then** it edits only the ADR ID cell of each existing row it names and does not name the architecture catalog template.

---

### User Story 5 - Governance catalogs and the findings file move to their skills and the project (Priority: P2)

highway-objectives, highway-controls, and highway-nfrs each carry their own catalog template in their `assets/` and write their catalog from it when setup runs them, as today. These three are not seeded, so an absent catalog still means the baseline was never set up. highway-assessment keeps its findings in the project at `library/knowledge/assessment-findings.md`, which setup seeds, and no longer touches `.highway/`.

**Why this priority**: Each of these templates has one reader, so it moves next to that reader. The findings file is project data and does not belong in shipped material.

**Independent Test**: List the three governance skills' `assets/`. Run setup and confirm the governance catalogs are not seeded. Run highway-assessment and confirm where it reads and writes findings.

**Acceptance Scenarios**:

1. **Given** highway-objectives, highway-controls, and highway-nfrs, **When** a maintainer lists each skill's `assets/`, **Then** it holds that skill's catalog template, and the skill names it by a path relative to its own folder.
2. **Given** a fresh highway-setup run where the person declines a governance baseline, **When** the run ends, **Then** that baseline's catalog is written empty by its owning skill, and a project where setup never ran that owner has no such catalog.
3. **Given** highway-assessment, **When** it reads or writes findings, **Then** it uses `library/knowledge/assessment-findings.md` in the project and names no path under `.highway/`.
4. **Given** highway-assessment's text, **When** a maintainer reads it, **Then** it states the findings table's rules: the `F` id derived from the observation, rows ordered by ID, the Category, Domain, and Status values, the revision rule, and no fingerprint column.
5. **Given** `.highway/library/knowledge/` after this change, **When** a maintainer lists it, **Then** `assessment-findings.md` is gone.

---

### User Story 6 - The checks compare project files against the skeletons (Priority: P2)

The bash fixture checks and the harness template assertions compare project files with the skeleton in highway-setup's `assets/` for a seeded file, and with the template in the owning skill's `assets/` for a governance catalog. A skill that drifts from the structure is still caught. The harness fixtures reflect a project that setup has seeded.

**Why this priority**: Without this, moving the templates would silently turn off the structural checks.

**Independent Test**: Run the template check on each seeded file against its skeleton, then on a copy with a header column removed. Run the harness tests and the scenario template assertions.

**Acceptance Scenarios**:

1. **Given** a project file and its skeleton, **When** the template check runs, **Then** it reports any missing frontmatter key, heading, or table header row in the skeleton, and nothing else.
2. **Given** a seeded file with a header column removed, **When** the template check runs, **Then** it reports the missing row and fails.
3. **Given** the harness scenarios, **When** a maintainer reads their template assertions, **Then** each names a skeleton or a template by its new location, and the assessment scenario checks `library/knowledge/assessment-findings.md`.
4. **Given** the harness stage fixtures, **When** a maintainer lists them, **Then** each holds the seeded files a setup run would leave, identical to their skeletons unless the stage added rows.
5. **Given** the setup harness scenario, **When** it runs, **Then** it asserts that every seeded file exists and matches its skeleton.
6. **Given** the generators, **When** every generated artifact is regenerated, **Then** highway-setup's skeletons and the governance skills' templates appear in each agent copy and manifest wherever their skills ship, the removed templates appear nowhere, and a second regeneration changes no file.

---

### Edge Cases

- A seeded file exists but its structure is wrong or it holds rows the writing skill does not expect. Setup never overwrites it. The writing skill handles it as it does today, and the template check reports the drift.
- A person deletes a seeded catalog after setup. The next skill that can edit it stops and directs the person to `/highway-setup`, which seeds it again without touching the other files. A skill that only reads it treats it as empty.
- A skill runs before setup has ever run. A reading skill sees no catalog and treats it as empty. A skill that can edit a seeded file stops before its first question and directs the person to `/highway-setup`.
- A skill can edit a seeded file only on some paths, such as highway-adr editing an architecture row's ADR ID cell. It checks every seeded file it can edit at entry, so it never stops partway through after the person has answered questions.
- The setup-needed message comes after highway-experience is activated, so the harness order check still holds. Its wording is fixed by the maintainer. If an Experience Standard check flags it, the plan resolves that without changing the words.
- Seeding creates folders a project may never use, such as `code/`. Phase 1 accepted that.
- The governance catalogs are not seeded, so the meaning of an absent catalog (never set up) and an empty one (declined) stays distinct.
- The storage record is absent in a project that predates seeding. Absent still means Local; setup seeds the record on its next run.
- A storage record that names a mode other than Local stops setup before it seeds, as it stops every skill.
- `codify-platforms.md` has frontmatter and no version line. `assessment-findings.md` has frontmatter with `revision: 0`. The other catalogs have a heading, a `Version: 1.0.0` line, and an index header. Each skeleton keeps exactly the structure its template's empty baseline describes.
- highway-onboarding still writes ADR, architecture, and implementation rows until Phase 10 hands them to their owners. In this phase it edits the existing seeded files, in their structure, instead of naming the catalog templates.
- Record templates (for example `adr-record.md` and `request-record.md`) stay in `.highway/library/templates/output/` until Phases 9 and 10, so the folder is not empty after this phase.
- Specs under `specs/` name the old locations as history and do not change.
- `rollout-plan.md` stays gitignored and excluded in the distribution manifest.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: highway-setup's `assets/` MUST hold one skeleton for each of the 11 seeded catalogs and one for the storage record, and nothing else. Each catalog skeleton MUST be the empty project file its template describes: the frontmatter where the catalog has one, the heading, the `Version: 1.0.0` line where the catalog has one, and the table header, with no data rows and no placeholder rows. The storage record skeleton MUST name Local as the mode.
- **FR-002**: At the start of every highway-setup run, after reading the storage record and before the welcome and Profile, highway-setup MUST write each seeded file that is absent from its skeleton, at its project path, and MUST NOT change a file that exists. Seeding MUST show nothing to the person.
- **FR-003**: highway-setup MUST be the only skill that writes a seeded file that is absent. It MUST NOT offer a separate seeding entry for other skills; a person who needs a missing seeded file runs `/highway-setup`.
- **FR-004**: The 11 seeded catalog templates MUST be removed from `.highway/library/templates/output/`. Each rule they state (row order, status values, id formats, removed rows, version changes, cell formats, and the empty baseline) MUST be stated in the text of each skill that writes the part of the catalog the rule governs.
- **FR-005**: The capability title rule MUST appear, word for word, in highway-architecture and highway-implementation, and the ADR ID cell format MUST appear, word for word, in highway-architecture and highway-adr. Each shared rule MUST have one source file in the repository, outside `skills/` so it does not ship. No generator writes a shared rule into a skill; a maintainer who changes a rule edits the source and each skill. A bash check MUST fail, naming the skill and the rule, when a skill's copy differs from its source.
- **FR-006**: A Highway skill MUST NOT create a seeded file or its folder when absent, and MUST NOT write a seeded file whole from a template. A skill that can edit a seeded file MUST check, after activating highway-experience and before its first question to the person, that every seeded file it can edit exists. When one is absent, it MUST stop, write no file, and show the setup-needed message exactly: the bold line `**Oops... we need to setup your repository.**`, a blank line, then `Highway needs to gather your organizational preferences and set up your repository. Run /highway-setup to get started.` Each such skill MUST name the seeded files it can edit and then state one instruction, identical in every such skill, that shows this message. A skill that only reads an absent seeded file MUST treat it as empty. A bash test MUST fail when a skill that can edit a seeded file lacks the identical instruction or the exact message.
- **FR-007**: For `library/coding-standards/codify-platforms.md`: highway-implementation MUST add one row per Implementation ID with Kind, When to use, and When not to use blank, and change no other row. highway-codify-config MUST add, update, or remove one row in the existing file, and MUST be the only skill that sets Kind and the two guidance lists. highway-onboarding and highway-codify MUST only read the file, and highway-onboarding MUST drop the template from its inputs.
- **FR-008**: For `implementations/capabilities.md`: highway-implementation MUST be the only writer, and each write MUST replace only that implementation's rows. highway-codify-config MUST stop checking the capability title rule, drop the template from its inputs, and pass new capabilities to highway-implementation. highway-assessment MUST only read the file.
- **FR-009**: For `adrs/adrs.md`: highway-adr MUST add rows and mark replaced decisions `superseded` in the existing file and state the catalog's rules in its own text. highway-onboarding MUST drop the template from its inputs and edit the existing file in its structure. highway-architecture and highway-assessment MUST only read it.
- **FR-010**: For `architectures/architectures.md`: highway-architecture MUST add rows in the existing file and state the catalog's rules in its own text. highway-adr MUST edit only an existing row's ADR ID cell, in the cases Phase 1 names, and MUST drop the template from its inputs. highway-implementation, highway-codify, and highway-assessment MUST only read it.
- **FR-011**: `objective-catalog.md`, `control-catalog.md`, and `nfr-catalog.md` MUST move to the `assets/` of highway-objectives, highway-controls, and highway-nfrs, with their content unchanged. Each skill MUST name its template by a path relative to its own folder. highway-setup MUST NOT seed these three catalogs, and each owning skill's absent-catalog behavior MUST be unchanged.
- **FR-012**: The findings file MUST live in the project at `library/knowledge/assessment-findings.md`, seeded by highway-setup. highway-assessment MUST read and write it there, MUST state the findings table's rules in its own text, and MUST name no path under `.highway/`. `.highway/library/knowledge/assessment-findings.md` and the findings template MUST be removed.
- **FR-013**: The template check MUST compare a project file with a skeleton (its frontmatter keys, its headings, and its table header rows) and with a template in a skill's `assets/`, and MUST report missing parts as it does today. The bash fixture checks and the harness template assertions MUST name the new locations, and each MUST have a seeded failure that proves it still fails.
- **FR-014**: The harness stage fixtures MUST hold the seeded files a setup run leaves, and the setup scenario MUST assert that every seeded file exists and matches its skeleton. The assessment scenario MUST check `library/knowledge/assessment-findings.md`. A new harness scenario MUST run highway-request in a project with no seeded files and assert the exact setup-needed message, no question to the person, and no file written.
- **FR-015**: highway-setup's Purpose, When to use, Inputs, Outputs, Procedure, and Verification MUST describe seeding, and MUST no longer say that Setup writes no repository file. Its other behavior, including the welcome, the owner order, the transitions, and the conclusion, MUST NOT change.
- **FR-016**: Every skill whose text changes MUST increment its version MINOR. Content edits MUST be limited to seeding, the entry check in FR-006, the catalog rules each skill now states, the ownership changes in FR-007 to FR-010, the moved templates, and the version change. Other skill behavior MUST NOT change.
- **FR-017**: The paths helper, the generators, the adapter and distribution manifests, and highway-help's catalog MUST follow the new arrangement: highway-setup's skeletons and the governance skills' templates ship as part of those skills wherever skills ship, and the removed templates are not listed. Regenerating every generated artifact MUST then leave no diff.
- **FR-018**: Where the Highway Skills Constitution or the development constitution names the catalog templates' location or the checks, it MUST follow the new arrangement as a MINOR amendment, recorded in its Sync Impact Report and, for the development constitution, with its self-application review.
- **FR-019**: Live documents MUST describe the new arrangement in the same change: `README.md`, `framework/README.md`, `framework/authoring-standard.md`, `harness/README.md`, and `standard-alignment.md`, which also marks Phase 8 complete. In `standard-alignment.md`, Phase 8 steps 2 and 3, the Phase 1 "Seeded by highway-setup" bullets, and the `capability-catalog.md` and `architecture-catalog.md` resolutions MUST be updated to match the Clarifications: a skill finding a seeded file absent directs the person to `/highway-setup`, and each shared rule is kept in step by a check against one source rather than inserted by a generator.
- **FR-020**: The full bash suite and the harness TypeScript tests MUST pass before the first edit and after the last.

### Key Entities

- **Seeded file**: a project file highway-setup writes once, when absent, from a skeleton: the 11 catalogs and the storage record.
- **Skeleton**: the empty project file kept in highway-setup's `assets/`, with frontmatter, heading, version line, and table header as the catalog requires, and no rows. highway-setup is its only reader.
- **Catalog rule**: a rule about a catalog's content (row order, status values, id formats, removed rows, version changes, cell formats), stated in the text of each skill that writes the part it governs.
- **Shared rule**: a catalog rule two skills both apply, kept in one source file in the repository and stated word for word in each skill, with a bash check against drift: the capability title rule and the ADR ID cell format.
- **Entry check**: the step in each skill that can edit a seeded file, run before its first question. It names the seeded files that skill can edit and, when one is absent, stops the skill with the setup-needed message.
- **Setup-needed message**: the fixed two-part message every entry check shows, word for word, directing the person to `/highway-setup`.
- **Governance catalog template**: the objective, control, or NFR catalog template, kept in its owning skill's `assets/` and not seeded.
- **Findings file**: `library/knowledge/assessment-findings.md` in the project, seeded by highway-setup and read and written only by highway-assessment.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: After a fresh highway-setup run in an empty project, 12 of 12 seeded files exist and each matches its skeleton.
- **SC-002**: A second highway-setup run changes 0 bytes in any existing seeded file, whether it holds rows or not.
- **SC-003**: 0 catalog templates remain in `.highway/library/templates/`, and 0 Highway skills name a catalog template by a path under `.highway/`.
- **SC-004**: 0 Highway skills contain a step that creates a seeded catalog or its folder when absent, or that writes a seeded catalog whole from a template, and every skill that can edit a seeded file has the entry check. In the harness, highway-request run without seeded files shows the setup-needed message and writes 0 files.
- **SC-005**: Each of the 2 shared rules appears identically in its 2 skills, and a hand-edited copy fails the bash suite.
- **SC-006**: highway-assessment names 0 paths under `.highway/`, and `.highway/library/knowledge/assessment-findings.md` does not exist.
- **SC-007**: Every template assertion and fixture check that compared a catalog before this change still runs against its new location, and each still fails on a seeded structural defect.
- **SC-008**: Regenerating every generated artifact produces 0 changed files, and the full bash suite and the harness TypeScript tests pass.

## Assumptions

- Seeding is not narrated. The files hold no person's information, and the Experience Standard keeps persistence details out of user-visible output.
- The storage record skeleton holds only the mode, Local. The Remote settings Phase 1 mentions arrive with Remote mode in `rollout-plan.md`.
- Skeletons are project files, not templates, so they carry no template frontmatter (`name`, `description`, `metadata.version`). The library validator does not check skill `assets/` until Phase 11 merges it into the skill validator.
- No generator is added, so the declared-generator list, the Generator gates (D4.1 to D4.4), and the regeneration order in `adapter-coverage.test.sh` are unchanged. The plan decides where the shared-rule source files live under `framework/` or `tests/`.
- Record templates move in Phase 9 and Phase 10. highway-onboarding's own ADR, architecture, and implementation writing moves in Phase 10, along with closing the ADR catalog gap between onboarding and highway-architecture's `name` step.
- The distribution keeps placing skills under `.highway/skills/` until Phase 14, so highway-setup's skeletons and the governance skills' templates ship there with their agent copies.
- Each skill's `SKILL.md` grows by the catalog rules it now states. Phase 13 deals with skill size.
- Highway is unreleased through the remaining phases and `rollout-plan.md`, so there is no backward compatibility to keep: no migration of `.highway/library/knowledge/assessment-findings.md` or of projects made by an earlier arrangement, and no change counted as breaking.
- Historical specs keep the old paths.
- Nothing is committed until the maintainer asks.
