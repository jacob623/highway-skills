# Feature Specification: Highway Skill Namespace

**Feature Branch**: `007-highway-skill-namespace`

**Created**: 2026-09-07

**Status**: Draft

**Input**: User description: "all skills created in this project should be namespaced for the coding agent as highway.<skill name>."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A coding agent lists this project's skill distinctly from unrelated skills (Priority: P1)

A developer using a coding agent (GitHub Copilot, Claude Code, or Cursor) that has this
project's skills installed, alongside skills from other projects or tools, opens the agent's
skill/tool listing. Every skill this project produced is identified with a `highway.` prefix
(e.g. `highway.help`), so the developer can immediately tell which skills came from this
project without opening any file.

**Why this priority**: Without a namespace, a skill id like `help` can collide with, or be
confused for, a same-named skill from an unrelated project or tool installed in the same agent.
This is the entire value of the feature and must work for the feature to be worth shipping.

**Independent Test**: Generate the agent adapters for this project's existing `help` skill and
confirm the identifier the coding agent would display or invoke reads `highway.help`, not `help`.

**Acceptance Scenarios**:

1. **Given** the `help` skill authored under `.highway/skills/help/`, **When** the agent
   adapters are generated, **Then** the GitHub Copilot and Claude Code adapter files present the
   skill's coding-agent-facing name as `highway.help`.
2. **Given** the same `help` skill, **When** the Cursor adapter is generated, **Then** the
   generated `.mdc` artifact identifies the skill as `highway.help` in whatever way Cursor
   surfaces a rule's identity (e.g. its file name or an explicit field).
3. **Given** a newly authored skill with directory id `<new-id>`, **When** its agent adapters are
   generated for the first time, **Then** every generated adapter identifies it as
   `highway.<new-id>` with no additional authoring step required from the skill's author.

---

### User Story 2 - Existing internal tooling and behavior keep working unchanged (Priority: P1)

A maintainer running this project's existing validation, catalog, and adapter-generation
commands (`validate-skill.sh`, `generate-catalog.sh`, `generate-agent-adapters.sh`) after the
namespace change gets the same exit codes and the same internal ids as before. Only the
coding-agent-facing identifier in the generated adapter artifacts changes.

**Why this priority**: The namespace must not break any of the ~10 currently-passing test files,
the catalog's `id` field (used for lookups, e.g. by the `help` skill), or drift detection in
`generate-agent-adapters.sh`. Breaking any of these would regress a previously shipped, tested
feature.

**Independent Test**: Run the full existing test suite (`.highway/tools/tests/run-all.sh`) after
the namespace change and confirm it still exits 0, with the catalog's `id` field and every
skill's directory name still unprefixed.

**Acceptance Scenarios**:

1. **Given** the namespace change is implemented, **When** `.highway/tools/tests/run-all.sh` is
   run, **Then** it exits 0 with no regression to any previously-passing assertion.
2. **Given** the namespace change is implemented, **When** `.highway/catalog/index.json` is
   regenerated, **Then** each entry's `id` field remains the skill's plain directory-derived id
   (e.g. `help`), not the namespaced form.
3. **Given** the namespace change is implemented, **When** `generate-agent-adapters.sh` is run
   twice in a row, **Then** the second run reports no drift, exactly like before this feature.

---

### Edge Cases

- What happens when a skill's directory id is itself `highway` (producing `highway.highway`)? The
  namespace prefix is still applied; no special-casing is introduced, since the constitution's
  existing id format (kebab-case, no dots) makes this merely an unusual but valid id, not a
  collision with the separator.
- How does the system handle the Cursor adapter format, which has no `name` frontmatter field
  today? The namespaced identifier must still be discoverable from the generated `.mdc` artifact
  (mechanism left to the implementation plan).
- What happens to a skill's human-readable `name` field (e.g. `Help`) inside the *source*
  `.highway/skills/<id>/SKILL.md` file? It is unaffected — the namespace is applied only to the
  coding-agent-facing identifier in the *generated* adapter artifacts, not to the authoring
  source file.
- Could the generated, namespaced identifier end up mixed-case (e.g. `highway.Help`) if it were
  built from the source `name` field instead of the id? No — FR-001 defines the namespaced
  identifier as built from the lowercase, kebab-case skill id, not from the free-form `name`
  field, so the generated adapter's coding-agent-facing identifier value is always fully
  lowercase (e.g. `highway.help`), even though the source `name` field may itself be
  mixed-case display text.
- What happens to skills that are not produced by this project's own authoring workflow (for
  example, the vendored `speckit-*` command skills already present under `.github/skills/`,
  installed and managed by the external github-spec-kit tool)? They are out of scope: this
  feature only namespaces skills authored under `.highway/skills/` and exposed through
  `generate-agent-adapters.sh` (currently just `help`). The `speckit-*` command skills are left
  untouched, since renaming their identifiers could affect how spec-kit's own slash-command
  hooks resolve them.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Every skill authored under `.highway/skills/` MUST be exposed to each supported
  coding agent (GitHub Copilot, Claude Code, Cursor) with a coding-agent-facing identifier of the
  form `highway.<skill-id>`, where `<skill-id>` is that skill's directory-derived id.
- **FR-010**: The resulting namespaced identifier MUST be entirely lowercase. This is already
  guaranteed by two existing, unaffected constraints: the literal prefix `highway` is lowercase,
  and every skill id is already required to be lowercase kebab-case (enforced separately by
  `.highway/tools/lib/schema-validate.sh`'s existing id format check, which this feature does not
  change per FR-003/FR-004). No new casing transformation is required to satisfy this.
- **FR-002**: The namespace prefix MUST be applied automatically by the existing generation
  tooling (`generate-agent-adapters.sh`) at the point each adapter artifact is produced; a skill
  author MUST NOT need to hand-author the prefix into their skill.
- **FR-003**: The namespace prefix MUST NOT change any internal id used by
  `.highway/tools/validate-skill.sh`, `.highway/tools/generate-catalog.sh`, or the catalog's
  `id`/`source_path` fields — those remain the plain, unprefixed, directory-derived id.
- **FR-004**: The namespace prefix MUST NOT be written into the source
  `.highway/skills/<id>/SKILL.md` file; it is applied only to the generated adapter copies under
  `.github/skills/`, `.claude/skills/`, and `.cursor/rules/`.
- **FR-005**: Re-running `generate-agent-adapters.sh` after this feature ships MUST regenerate
  every adapter artifact in the namespaced form; this project is still in development, so no
  migration path or backward-compatible handling of pre-existing, non-namespaced adapter files is
  required — they are simply overwritten.
- **FR-006**: Re-running `generate-agent-adapters.sh` a second consecutive time after the update
  MUST report no drift, preserving the tool's existing idempotency guarantee.
- **FR-007**: The namespace requirement MUST apply uniformly to every current and future skill
  authored under `.highway/skills/`, with no per-skill opt-out.
- **FR-008**: The full existing test suite (`.highway/tools/tests/run-all.sh`) MUST continue to
  pass after the namespace change, with no regression to a previously-passing assertion.
- **FR-009**: The namespace requirement MUST NOT apply to skills not authored under
  `.highway/skills/` — in particular, the pre-existing, vendored `speckit-*` command skills
  under `.github/skills/` are out of scope and MUST remain unmodified by this feature.

### Key Entities

- **Skill (source)**: Authored at `.highway/skills/<id>/SKILL.md`. Its directory-derived `<id>`
  is unaffected by this feature.
- **Catalog Entry**: The entry for a skill in `.highway/catalog/index.json`. Its `id` field is
  unaffected by this feature.
- **Generated Adapter Artifact**: One of the three files `generate-agent-adapters.sh` produces
  per skill (`.github/skills/<id>/SKILL.md`, `.claude/skills/<id>/SKILL.md`,
  `.cursor/rules/<id>.mdc`). Each now carries a coding-agent-facing identifier of the form
  `highway.<id>` instead of the bare `<id>`.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of generated adapter artifacts, across all three supported coding agents and
  all skills authored under `.highway/skills/`, present a coding-agent-facing identifier that
  begins with the literal prefix `highway.`.
- **SC-002**: A developer can distinguish this project's skills from any unrelated, same-named
  skill in the same coding agent's listing with zero ambiguity, by the presence of the
  `highway.` prefix alone.
- **SC-003**: The full existing test suite continues to report the same pass count (0 failures)
  after the namespace change is applied.
- **SC-004**: Running `generate-agent-adapters.sh` twice in immediate succession after the
  namespace change reports zero drift on the second run, for every skill. No migration or
  backward-compatibility handling for pre-existing, non-namespaced adapter files is required or
  measured, since this project is still in development.

## Assumptions

- "This project" refers to skills authored through this repository's own skill-authoring
  workflow under `.highway/skills/` and exposed via `generate-agent-adapters.sh` — currently just
  `help`. Confirmed with the user: the pre-existing, vendored `speckit-*` command skills under
  `.github/skills/` (managed by the external github-spec-kit tool) are explicitly out of scope
  and are left unmodified, since renaming their identifiers could affect how the spec-kit
  tooling's own slash-command invocations resolve them.
- The coding-agent-facing identifier is the value each agent's skill-discovery mechanism reads to
  name/list/invoke a skill (e.g. a `name` frontmatter field for GitHub Copilot and Claude Code
  adapters). The exact mechanism for Cursor's `.mdc` format, which has no such field today, is
  left to the implementation plan.
- Applying the prefix is a purely additive, generation-time transformation; it does not require
  any change to how a skill author writes a skill under `.highway/skills/`.
- The separator character is a literal dot (`.`), matching the user's exact wording
  (`highway.<skill name>`), not a hyphen or slash.
- "`<skill name>`" in the user's wording refers to the skill's directory-derived id (kebab-case,
  e.g. `help`), not its human-readable `name` frontmatter field (e.g. `Help`), since the
  directory-derived id is what the coding agent already uses to invoke or resolve a skill (e.g.
  `/help <id>` command syntax, `.cursor/rules/<id>.mdc` file naming).
- This project is still in development. No backward compatibility, migration path, or
  preservation of previously generated (non-namespaced) adapter artifacts is required; existing
  generated files under `.github/skills/`, `.claude/skills/`, and `.cursor/rules/` may be freely
  overwritten when adapters are regenerated.
