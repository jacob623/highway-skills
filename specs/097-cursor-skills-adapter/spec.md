# Feature Specification: Deliver Highway Skills to Cursor as Skills, Not Rules

**Feature Branch**: `097-cursor-skills-adapter`

**Created**: 2026-09-29

**Status**: Draft

**Input**: User description: "create a new spec for updating the current cursor rules to cursor skills."

## Background

Every Highway skill is authored once under `.highway/skills/<id>/SKILL.md` and delivered to each
supported coding agent through a generated adapter. Two of the three adapters (GitHub Copilot and
Claude Code) deliver a skill as a skill: a `SKILL.md` file carrying the skill's complete
frontmatter and body. The Cursor adapter is the exception. It converts each skill into a Cursor
*rule* (`.cursor/rules/<id>.mdc`), keeping only the `description` line, discarding `name`,
`usage`, `compatibility` and `metadata`, and marking the file as agent-requestable.

As a result, Cursor lists every Highway skill under Rules rather than Skills, the skill's
declared usage and version never reach Cursor, and the Cursor deliverable differs in kind from
the other two agents'. Cursor now supports a native skills location that accepts the same
`SKILL.md` format the other adapters already produce, so the conversion to a rule is no longer
needed. Separately, the Spec Kit `cursor-agent` integration now installs its own `speckit-*`
skills into that same native location, which confirms the location is the one Cursor reads.

## Clarifications

### Session 2026-09-29

- Q: If Cursor reads a Highway skill from both `.cursor/skills/` and the Claude-compatible `.claude/skills/`, must the feature still be judged done when the skill shows up twice in Cursor's Skills list? → A: Done when every skill has a `.cursor/skills/` copy and none appears as a rule; a duplicate from the compatibility path is acceptable and is recorded as an observation.
- Q: When the migration finds a tracked Highway rule file that someone edited by hand, should it stop the whole migration, skip only that file, or delete it anyway? → A: Skip only that file. Remove every unedited rule file, leave the edited one in place, name it in the report as still needing a decision, and exit non-zero while any remain.
- Q: Should retiring the old rule files be a one-time step run only in this repository, or a permanent behavior of the generator that also cleans up old rule files in any checkout where it's run? → A: One-time migration. No cleanup script is retained after it completes, and the generator stays non-pruning.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Highway skills appear as Cursor skills (Priority: P1)

As a Highway user working in Cursor, I want each Highway skill to be listed and invoked as a
skill, so that it behaves the way it does in Claude Code and GitHub Copilot and is discoverable
where I expect skills to be.

**Why this priority**: This is the whole purpose of the feature. Without it the reported problem
persists, and nothing else in this spec has value.

**Independent Test**: Regenerate the adapters, open the repository in Cursor, and confirm that
every Highway skill appears under Skills and none appears under Rules.

**Acceptance Scenarios**:

1. **Given** the skill sources under `.highway/skills/`, **When** the adapters are generated,
   **Then** each skill has a Cursor deliverable at `.cursor/skills/<id>/SKILL.md`.
2. **Given** a generated Cursor deliverable, **When** it is compared with the same skill's Claude
   Code deliverable, **Then** the two are byte-identical.
3. **Given** the repository opened in Cursor, **When** the user lists rules and skills, **Then**
   every Highway skill is listed as a skill and no Highway skill is listed as a rule. A skill
   that also appears a second time through the Claude-compatible `.claude/skills/` path does not
   fail this scenario; the duplicate is recorded as an observation.
4. **Given** a Highway skill with a `usage` value and a version, **When** it is delivered to
   Cursor, **Then** its `name`, `description`, `usage`, `compatibility` and `metadata` frontmatter
   fields are all present, not only `description`.

---

### User Story 2 - Retire the superseded Cursor rule files safely (Priority: P1)

As a maintainer, I want the existing `.cursor/rules/<id>.mdc` files removed and no longer
tracked, so that no skill is delivered to Cursor as both a rule and a skill and no stale rule
copy can drift from its source.

**Why this priority**: Leaving both forms in place would present every skill twice and let the
rule copy silently go stale. The generator also refuses to overwrite files it did not produce,
and it never prunes, so retirement has to be a deliberate, verifiable step rather than a side
effect.

**Independent Test**: After migration, confirm no Highway `.mdc` file remains under
`.cursor/rules/`, the adapter manifest has no row for one, and a full regeneration produces no
diff.

**Acceptance Scenarios**:

1. **Given** the repository before migration, **When** the migration is complete, **Then** no
   `.cursor/rules/<id>.mdc` file exists for any Highway skill, and the leftover rule file for the
   sourceless `test-catalog-fixture-20649` skill (which has no adapter manifest row) is gone too.
2. **Given** the migrated repository, **When** the adapter manifest is read, **Then** it holds no
   row naming a `.cursor/rules/` path, and holds one row per skill for the new Cursor location.
3. **Given** the migrated repository, **When** the generator is run twice in succession, **Then**
   the second run produces no diff, and neither run refuses to write a Cursor target.
4. **Given** a `.cursor/rules/` file that is not a Highway adapter (for example a rule the
   maintainer wrote by hand), **When** the migration runs, **Then** that file is left untouched.
5. **Given** a tracked Highway rule file whose content differs from what the generator last
   produced, **When** the migration runs, **Then** every unedited rule file is still removed, the
   edited file is left in place and named in the report as needing a decision, and the migration
   exits non-zero.
6. **Given** the migration previously exited non-zero for an edited file, **When** the maintainer
   resolves that file and re-runs the migration, **Then** it completes, removes the remainder, and
   exits zero.
7. **Given** the migration is complete, **When** the repository is inspected, **Then** no
   migration or cleanup script remains in the tree, and the generator still removes no files.

---

### User Story 3 - Spec Kit skills and Highway skills coexist in the Cursor skills location (Priority: P1)

As a maintainer, I want the Highway generator and the Spec Kit integration to share
`.cursor/skills/` without interfering with each other, so that neither tool overwrites, prunes or
mis-classifies the other's files.

**Why this priority**: `.cursor/skills/` already contains ten `speckit-*` skills owned by Spec
Kit. A generator that touched them, or a distribution step that shipped them, would corrupt
tooling or leak development-only content to users.

**Independent Test**: With both sets present, run the generator and confirm every `speckit-*`
file is byte-identical to before, and confirm the distribution contains no `speckit-*` skill.

**Acceptance Scenarios**:

1. **Given** `.cursor/skills/speckit-*` directories present, **When** the generator runs,
   **Then** none of them is created, modified or removed.
2. **Given** a target path under `.cursor/skills/` that exists but was not produced by the
   generator and is not a Highway skill, **When** the generator runs, **Then** it does not touch
   it; and if it collides with a Highway skill id, the generator refuses to overwrite and names
   the file.
3. **Given** the distribution manifest, **When** the user-facing distribution is produced,
   **Then** every Highway skill's Cursor deliverable is included, no `speckit-*` skill is
   included, and every path under `.cursor/` is classified, none left unclassified.

---

### User Story 4 - Tests and documentation describe the skills delivery (Priority: P2)

As a contributor, I want the tests and every document that names the Cursor deliverable to say
that Cursor receives skills, so that nothing tells me to look for a rule and no test enforces the
old behavior.

**Why this priority**: Correct behavior with stale documentation sends contributors to a
location that no longer exists. It is required for completion but does not affect users of the
skills.

**Independent Test**: Search live documentation and the test suite for references to the Cursor
rules location and the rule conversion; each remaining hit is intentional and explained.

**Acceptance Scenarios**:

1. **Given** the live documentation (`README.md`, the tools README, `.highway/DISTRIBUTION.md`,
   and the constitution's declared-agent-tree text), **When** it is read after the change,
   **Then** it names the Cursor deliverable as a skill at `.cursor/skills/<id>/SKILL.md`.
2. **Given** the tools README statement that the generator never touches the Spec Kit skill
   folders, **When** it is read after the change, **Then** it covers the Spec Kit skills under
   `.cursor/skills/` as well as those under `.github/skills/`.
3. **Given** the test suite, **When** it is run, **Then** it passes, and it contains at least one
   test that fails if the Cursor deliverable reverts to a rule, drops frontmatter, or differs
   from the Claude Code deliverable.
4. **Given** historical feature specs under `specs/` that describe the earlier rule behavior,
   **When** this feature completes, **Then** they are left unchanged as a record of what was
   true when they were written.

---

### Edge Cases

- A maintainer has hand-edited a `.cursor/rules/<id>.mdc` file: the migration must not delete or
  overwrite it. It skips that file, names it in the report, removes the unedited rule files, and
  exits non-zero until the maintainer resolves it.
- A Highway skill id matches a `speckit-*` name: the generator refuses to overwrite and names the
  file.
- A skill is removed from the source: the generator does not prune its adapters (unchanged
  behavior), and the existing correspondence checks between sources and adapters still flag the
  orphan.
- The Spec Kit `cursor-agent` integration is reinstalled or upgraded and rewrites
  `.cursor/skills/speckit-*`: the Highway deliverables must be unaffected.
- The test fixture skill is generated into every agent tree during the test suite: the Cursor
  fixture deliverable must be created and cleaned up like the others, with no stray
  `.cursor/rules/` file left behind.
- A user has an older distribution installed with `.cursor/rules/<id>.mdc` files: the
  distribution documentation states that these are superseded and may be deleted.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The adapter generator MUST deliver each Highway skill to Cursor as
  `.cursor/skills/<id>/SKILL.md`.
- **FR-002**: The Cursor deliverable MUST be a byte-for-byte copy of the skill source, identical
  to the Claude Code and GitHub Copilot deliverables for the same skill.
- **FR-003**: The generator MUST NOT write any Highway skill to `.cursor/rules/`, and the rule
  conversion (dropping frontmatter and adding `alwaysApply`) MUST be removed rather than left
  unused.
- **FR-004**: The generator MUST continue to validate every skill before writing any adapter,
  MUST continue to write no partial adapter set on a validation failure, and MUST continue to
  refuse to overwrite a target it did not produce.
- **FR-005**: The generator MUST NOT create, modify, or remove any `speckit-*` skill under
  `.cursor/skills/` or `.github/skills/`.
- **FR-006**: The existing Highway `.cursor/rules/<id>.mdc` files (12, one per source skill) MUST
  be removed, and their rows MUST be replaced in the adapter manifest by one row per skill for
  the new Cursor location. The one leftover rule file that has no manifest row and no source
  skill, `.cursor/rules/test-catalog-fixture-20649.mdc`, MUST also be removed, because it would
  otherwise still be listed as a rule.
- **FR-007**: Migration MUST NOT delete a `.cursor/rules/` file other than the tracked Highway
  adapters and the single named leftover in FR-006. For either kind whose content differs from
  what was last produced or recorded, it MUST leave that file in place, name it in its report,
  still remove every unedited one, and exit non-zero until no such file remains. A re-run after
  the maintainer resolves the file MUST complete and exit zero.
- **FR-008**: Two consecutive generator runs on unchanged inputs MUST produce no difference in
  any generated file.
- **FR-009**: The distribution manifest MUST include each Highway skill's Cursor deliverable,
  MUST exclude the `speckit-*` skills, MUST leave no path under `.cursor/` unclassified, and MUST
  no longer list `.cursor/rules/` entries.
- **FR-010**: A distribution produced after this change MUST pass its existing verifications
  (no reference to a development-only location, all cross-references resolve, the distribution's
  own validator succeeds).
- **FR-011**: The correspondence checks between skill sources, catalog, adapters, adapter
  manifest and distribution manifest MUST treat `.cursor/skills/<id>/SKILL.md` as the Cursor
  adapter for a skill and MUST fail when one is missing or orphaned.
- **FR-012**: The test suite MUST cover the new Cursor deliverable: its location, byte-identity
  with the Claude Code deliverable, presence of full frontmatter, absence of any `.cursor/rules/`
  Highway file, and non-interference with `speckit-*` skills. Existing assertions about the rule
  form MUST be replaced with assertions about the skill form, each with a recorded reason naming
  the superseded behavior.
- **FR-013**: Every live document that names the Cursor deliverable MUST be updated in the same
  change to name the skill location, and every path it cross-references MUST resolve.
- **FR-014**: The declared agent trees recognised by the constitution MUST continue to include
  Cursor, and the description of where its adapters live MUST match the new location.
- **FR-015**: After the change, all generated artifacts (catalog, adapters, adapter manifest)
  MUST be regenerated so that re-running every declared generator leaves no diff.
- **FR-016**: The distribution documentation MUST tell existing users that any previously
  installed `.cursor/rules/<id>.mdc` Highway file is superseded by the skill and can be removed.
- **FR-017**: The retirement of the rule files (FR-006, FR-007) MUST be a one-time migration. Any
  script used to perform it MUST be removed once the migration is complete, and the generator
  MUST NOT gain any behavior that removes files.

### Key Entities

- **Skill source**: The authored `.highway/skills/<id>/SKILL.md`; the single origin of every
  deliverable.
- **Cursor deliverable**: The generated per-skill file Cursor reads. Currently a rule; after this
  change a skill identical to the other agents' deliverables.
- **Adapter manifest**: The record of every generated adapter path, its skill id, version and
  content hash, used to detect hand edits and refuse unsafe overwrites.
- **Distribution manifest**: The single declaration of which repository paths ship to users.
- **Spec Kit skill**: A `speckit-*` skill installed by the Spec Kit integration, owned by that
  tool, present in the same Cursor skills location and never shipped.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of Highway skills (12 today) have a `.cursor/skills/`
  copy and are listed under Skills in Cursor, and 0 are listed under Rules. A duplicate listing
  of the same skill through the `.claude/skills/` compatibility path is not a failure.
- **SC-002**: 100% of Cursor deliverables are byte-identical to their Claude Code counterparts;
  0 frontmatter fields present in the source are missing from the Cursor deliverable.
- **SC-003**: Once any hand-edited rule file is resolved, 0 Highway files remain under
  `.cursor/rules/`, and 0 adapter manifest rows name a `.cursor/rules/` path.
- **SC-004**: Regenerating all artifacts twice in a row produces 0 differences on the second run.
- **SC-005**: All 10 existing `speckit-*` skills under `.cursor/skills/` are byte-identical before
  and after generation, and 0 appear in a produced distribution.
- **SC-006**: The full automated test suite passes, both before the first change and after the
  last.
- **SC-007**: A produced distribution passes all three of its verifications on the first run.
- **SC-008**: 0 live documents name `.cursor/rules/` as where Highway skills are delivered.

## Assumptions

- Cursor reads `.cursor/skills/<id>/SKILL.md` natively and accepts the existing Highway
  `SKILL.md` frontmatter unchanged, as it does for the `speckit-*` skills already installed
  there. If Cursor rejects any Highway frontmatter field, that would be handled as a separate
  finding rather than by reintroducing a conversion step.
- Cursor also reads `.claude/skills/` for compatibility, so Highway skills may currently be
  visible to Cursor through that path as well. This feature does not remove or depend on that
  behavior; the dedicated Cursor location is added so delivery to Cursor is explicit and
  independent of the Claude Code tree. Because the `.claude/skills/` tree must remain for Claude
  Code, a duplicate Cursor listing caused by that compatibility path is accepted and recorded as
  an observation, not resolved by this feature.
- Retiring the rule files is preferred over keeping them as a fallback, because keeping both would
  present each skill twice. Other checkouts and existing users are served by the documentation in
  FR-016, not by a retained cleanup tool.
- The Cursor adapter follows the same "copy unchanged" delivery as the other two agents, so no
  Cursor-specific transformation is needed.
- Historical feature specs under `specs/` are records and are not rewritten.
- The Spec Kit changes currently uncommitted in the working tree (the `cursor-agent` integration
  and its `speckit-*` skills) are a separate concern from this feature and are neither reverted
  nor modified by it.
- `test-catalog-fixture-20649` is committed residue from an earlier test run: it has adapter files
  in all three agent trees but no source skill, no catalog entry and no adapter manifest row. Only
  its Cursor rule file is in scope, because that file is what Cursor lists as a rule. Its
  `.github/skills/` and `.claude/skills/` copies are a pre-existing, separate defect and are left
  as they are.
- Skill content, versions and the skill catalog are unchanged by this feature; only the Cursor
  delivery form changes, so no skill's version is bumped.
- Dependencies: the shared authoring framework under `.highway/tools/`, the adapter and
  distribution manifests, and the constitution's generated-artifact and documentation-currency
  rules (D4.1–D4.7, D6.1, D6.2, and D1.6).
