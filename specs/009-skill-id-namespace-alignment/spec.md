# Feature Specification: Skill Id Namespace Alignment

**Feature Branch**: `009-skill-id-namespace-alignment`

**Created**: 2026-09-07

**Status**: Draft

**Input**: User description: "I want the .highway/skills/<skill name> to represent the same hyphened skill name the agents will use. This is causing ambiguity. I also want to update the Skill frontmatter Name to match the skill id (folder name) for both the agent SKILL.md file and the .highway/skills/<skill name>/SKILL.md. I want this to apply to all future skills created in this project."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Canonical skill directory already carries the agent-facing name (Priority: P1)

Today, a skill's canonical source lives at `.highway/skills/<bare-id>/` (e.g.
`.highway/skills/help/`), while the identifier every coding agent actually invokes is a separately
computed, namespaced form (`highway-<bare-id>`, e.g. `highway-help`), produced only at adapter-
generation time or help-output-render time. A developer working in `.highway/skills/` sees one
name; every agent surface shows a different one. The user wants the canonical directory itself to
already be named with the exact, agent-facing identifier, so there is only ever one name for a
skill, visible everywhere, with no separate computation step to keep in sync.

**Why this priority**: This is the structural fix that removes the ambiguity at its source —
every other change in this feature (frontmatter alignment, future-skill convention) depends on
the canonical directory being the single source of truth for the skill's name.

**Independent Test**: Can be fully tested by inspecting `.highway/skills/`, resolving the
catalog, and confirming the directory name, the catalog `id`, and every generated agent adapter's
target path basename are all the same literal string, with no separate prefixing step observable
anywhere in the pipeline.

**Acceptance Scenarios**:

1. **Given** the `help` skill currently lives at `.highway/skills/help/`, **When** this feature is
   applied, **Then** its canonical source lives at `.highway/skills/highway-help/`, and its
   catalog `id` reads `highway-help`.
2. **Given** the canonical directory is now `.highway/skills/highway-help/`, **When** agent
   adapters are regenerated, **Then** each generated target's basename (e.g.
   `.github/skills/highway-help/`, `.claude/skills/highway-help/`, `.cursor/rules/highway-help.mdc`)
   is produced without any separate namespace-prefix computation — the generator copies/transforms
   using the id it already finds on disk.
3. **Given** a brand-new skill is authored after this feature ships, **When** its directory is
   created, **Then** the directory is named with the full agent-facing identifier from the start
   (no bare, unprefixed id is ever registered).
4. **Given** the `help` skill's catalog `id` is now `highway-help`, **When** the help skill's own
   registration is requested by declaring that id, **Then** the invocation is
   `/highway-help highway-help` (not `/highway-help help`), and this same rule holds for every
   other registered skill's `Help:` line and `## Example` invocation — the declared-identifier
   argument is always the full, agent-facing id, never a bare, unprefixed one.

---

### User Story 2 - Frontmatter Name matches the directory-derived id exactly (Priority: P1)

A skill's frontmatter `name` field is currently free-form and never required to match its
directory name. This let the `help` skill display `Name: Help` in earlier output while its
directory and generated adapters used a completely different, lowercase, namespaced string. The
user wants `name` required to match the directory-derived id exactly, in the canonical
`.highway/skills/<id>/SKILL.md` file and in every generated agent adapter file, so that reading a
skill's own file always shows the same name it is invoked by, with no drift possible.

**Why this priority**: Equal in importance to User Story 1 — a correctly-named directory with a
mismatched `name` field still leaves a visible inconsistency to anyone reading the file directly.

**Independent Test**: Can be fully tested by running the skill validator against every skill and
confirming it fails any skill whose frontmatter `name` does not exactly equal its
directory-derived id, then confirming every currently-registered skill passes.

**Acceptance Scenarios**:

1. **Given** the `help` skill's directory is `.highway/skills/highway-help/`, **When** its
   frontmatter is inspected, **Then** `name: highway-help` — matching the directory exactly, not
   a free-text label.
2. **Given** an agent adapter is generated for a skill, **When** that adapter's frontmatter is
   inspected (for adapter shapes that carry a `name` field), **Then** it shows the same value as
   the canonical file's `name`, since adapters are produced from the canonical file, never
   authored separately.
3. **Given** a skill's frontmatter `name` does not match its directory-derived id, **When** the
   skill validator is run against it, **Then** validation fails, naming the mismatch.

---

### User Story 3 - Convention is enforced for every future skill (Priority: P2)

The user wants this pairing — directory already namespaced, `name` matching the directory — to be
the standard, checked convention for every skill authored from now on, not a one-time cleanup
applied only to `help`.

**Why this priority**: Without an enforced, documented rule, the next authored skill could easily
reintroduce the exact ambiguity this feature removes.

**Independent Test**: Can be fully tested by authoring a new, otherwise-valid skill whose
frontmatter `name` deliberately does not match its directory name, and confirming the validator
rejects it with an explicit, actionable error before it can be registered.

**Acceptance Scenarios**:

1. **Given** the authoring standard document, **When** it is read, **Then** it states `name`
   MUST match the directory-derived id exactly, as a validated requirement rather than a
   recommendation.
2. **Given** a new skill directory is added with a `name` that does not match, **When**
   `.highway/tools/validate-skill.sh` is run against it, **Then** it fails with an explicit,
   actionable error naming the mismatch, and the skill is excluded from the catalog and adapter
   generation until fixed.

---

### Edge Cases

- What happens to the `help` skill's already-generated adapters at `.github/skills/highway-help/`,
  `.claude/skills/highway-help/`, and `.cursor/rules/highway-help.mdc` (produced by
  specs/008-help-output-namespacing's compute-at-generation-time approach)? Their paths are
  already correct under this feature's convention (the computed and the now-canonical form are the
  same literal string), so regeneration updates their content (to match the corrected frontmatter
  `name`) without needing to remove or relocate them.
- What happens to the help skill's own rendered output (`Name:`, `Usage:`, `Help:`, `Example:`
  fields) that specs/008 made a computed function of the catalog id specifically so it would never
  need to trust frontmatter `name`? Since this feature makes `name` a validated, guaranteed match
  for the id, reading `name` directly and computing from `id` now always produce an identical
  result — the fields' displayed values are unaffected, only the source-of-truth reasoning
  simplifies.
- What happens if a future agent's own adapter shape cannot carry a `name` field at all (for
  example, Cursor's `.mdc` rule format only supports `description`, `globs`, and `alwaysApply`)?
  Out of scope for that adapter shape — the requirement applies only to adapter formats that
  already carry a `name`-equivalent field; an adapter format with no such field is unaffected and
  is not a violation.
- What happens to a skill id that, after this change, must satisfy both the existing kebab-case
  id-format rule and this feature's match-the-agent-facing-name rule? No new character-set rule is
  introduced; the agent-facing identifier is itself already kebab-case, so it satisfies the
  existing id-format rule without modification.
- What happens to any other document, test, or tool reference that still names the skill's old,
  unprefixed directory (`.highway/skills/help/`)? Every such reference MUST be updated to the new
  directory name as part of this feature; none may keep pointing at a path that no longer exists.
- What happens to the previously-documented self-invocation `/highway-help help` (the help
  skill's own `## Example` line and any doc that quotes it)? It changes to
  `/highway-help highway-help`, since the declared-identifier argument is now always the full,
  agent-facing id (FR-009) and the help skill's own id is now `highway-help`; every place that
  quotes the old form MUST be updated, not left as a second, stale valid form.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Every skill's canonical source directory under `.highway/skills/` MUST be named
  identically to the full, agent-facing identifier that skill is exposed as — no bare,
  unprefixed directory name may be registered going forward.
- **FR-002**: The `help` skill's canonical directory MUST be renamed from
  `.highway/skills/help/` to `.highway/skills/highway-help/`, and every reference to its old
  path (catalog, tests, tooling, documentation) MUST be updated accordingly.
- **FR-003**: A skill's frontmatter `name` field MUST match its directory-derived id exactly
  (byte-for-byte), for every registered skill.
- **FR-004**: `.highway/tools/validate-skill.sh` MUST fail, with an explicit and actionable error,
  any skill whose frontmatter `name` does not exactly equal its directory-derived id.
- **FR-005**: Every generated agent adapter whose target format carries a `name`-equivalent field
  MUST show the same value as the canonical file's `name`, achieved by continuing to produce
  adapters from the canonical file rather than by authoring adapters separately.
- **FR-006**: No adapter-generation or help-output-rendering step may compute or inject a
  namespace prefix that is not already present on the canonical skill's own directory name — the
  namespace is authored once, at the canonical source, and carried through unchanged everywhere
  else.
- **FR-007**: `.highway/skills/_authoring-standard.md` MUST document this pairing (directory
  already namespaced; `name` matches the directory) as a required, validated rule for every
  skill authored from this point forward, not merely a recommendation.
- **FR-008**: This behavior applies uniformly to every skill registered in
  `.highway/catalog/index.json`; no skill is exempted or special-cased.
- **FR-009**: Every declared-identifier argument the help skill renders or accepts (the
  All-Skills `Help: /highway-help <id>` line, and each skill's own `## Example` invocation) MUST
  use the full, agent-facing id — the same string as the canonical directory name — never a bare,
  unprefixed id. For the `help` skill itself, this makes the correct self-invocation
  `/highway-help highway-help`, replacing the current `/highway-help help`.

### Key Entities

- **Canonical Skill Directory**: The single directory under `.highway/skills/` that is the source
  of truth for a skill's content; its name is now, by this feature, always identical to the full
  agent-facing identifier used everywhere else (catalog `id`, generated adapter paths, help
  output).
- **Skill Frontmatter Name**: The `name` field inside a skill's `SKILL.md` frontmatter; now
  required to match its Canonical Skill Directory's name exactly, for every skill.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of registered skills' canonical directory names, catalog ids, and generated
  adapter path basenames are the identical literal string, with zero separate namespace-prefix
  computation observable anywhere in the pipeline.
- **SC-002**: 100% of registered skills' frontmatter `name` fields match their directory-derived
  id exactly; the validator rejects 100% of introduced mismatches.
- **SC-003**: A newly authored skill that already follows this convention passes validation and
  is registered with zero additional configuration; a newly authored skill that violates the
  convention is rejected with an explicit, actionable error before registration.
- **SC-004**: Zero remaining references anywhere in the repository (documentation, tests,
  tooling) to the `help` skill's old, unprefixed directory path.
- **SC-005**: Requesting the `help` skill's own registration details (`/highway-help
  highway-help`) succeeds and reproduces the Single-Skill mode success shape; the old form
  (`/highway-help help`) is no longer a registered id and returns the unrecognized-identifier
  error.

## Assumptions

- The full, agent-facing identifier for each currently-registered skill is the same
  `highway-<bare-id>` form already established by specs/007-highway-skill-namespace and
  specs/008-help-output-namespacing; this feature does not change what that identifier is, only
  where it is authored (at the canonical directory itself, instead of computed downstream).
- `help` is the only skill currently registered under `.highway/skills/`, so it is the only
  migration this feature performs; the enforced convention applies automatically to any skill
  authored afterward.
- This feature supersedes specs/007-highway-skill-namespace's and
  specs/008-help-output-namespacing's compute-the-namespace-at-generation-or-render-time
  mechanism, in favor of authoring the namespace once at the canonical source and validating that
  the frontmatter `name` agrees with it — it does not change the resulting agent-facing identifier
  itself, only when and where it is established as a single source of truth.
- Adapter formats without a `name`-equivalent field (for example Cursor's `.mdc` rules, which
  specs/001 already limited to `description`, `globs`, and `alwaysApply`) are unaffected by
  FR-005; only formats that already carry such a field are in scope.
