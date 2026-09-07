# Feature Specification: Help Output Namespacing

**Feature Branch**: `008-help-output-namespacing`

**Created**: 2026-09-07

**Status**: Draft

**Input**: User description: "The help skill still shows a name with upper case Help. I want it to match the skill casing. The Usage field should show /highway.help. Currently shows /help. The Help field should also state /highway.help help. Currently shows /help. The Example value is supposed to be copy-able. All skills should implement these same behaviors." Amended after compatibility research: use a hyphen separator (`highway-<id>`), not a dot, across every agent, since GitHub Copilot's Agent Skills spec disallows dots in skill directory/name values; keep this consistent for every subsequent skill unless a specific agent documents an incompatibility with hyphens.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Namespace separator is a hyphen, not a dot (Priority: P1)

Feature 007 shipped the agent-facing namespace prefix using a dot separator (`highway.<id>`,
e.g. `highway.help`). Research into GitHub Copilot's published Agent Skills spec found that a
skill's `name` field must consist of lowercase letters, numbers, and hyphens only, must contain
no dots, and must exactly match its parent directory name — a rule a dotted directory name can
never satisfy. No equivalent research found any documented incompatibility or anti-pattern for a
hyphen separator on any of the three supported agents (github-copilot, claude-code, cursor). The
user wants the separator changed to a hyphen (`highway-<id>`) across every agent, consistently,
so the namespace prefix is spec-compliant everywhere rather than compliant on some agents and
not others.

**Why this priority**: This is the foundational correction everything else in this feature
depends on — the Name, Usage, Help, and Example fields (User Stories 2-4) all display whatever
separator this story establishes, so it must be decided first.

**Independent Test**: Can be fully tested by regenerating the agent adapters and confirming
every generated path under `.github/skills/`, `.claude/skills/`, and `.cursor/rules/` uses the
form `highway-<id>` (hyphen), with no `highway.<id>` (dot) path remaining anywhere.

**Acceptance Scenarios**:

1. **Given** the `help` skill is registered with catalog id `help`, **When** agent adapters are
   regenerated, **Then** the produced paths are `.github/skills/highway-help/SKILL.md`,
   `.claude/skills/highway-help/SKILL.md`, and `.cursor/rules/highway-help.mdc` — never a
   dot-separated equivalent.
2. **Given** the dot-separated artifacts already exist from feature 007
   (`.github/skills/highway.help/`, `.claude/skills/highway.help/`, `.cursor/rules/highway.help.mdc`),
   **When** agent adapters are regenerated under this feature, **Then** those dot-separated
   artifacts are removed and replaced by their hyphen-separated equivalents, the same way feature
   007 itself retired the original unprefixed paths.
3. **Given** a new agent is added later via the existing extensibility mechanism, **When** its
   target path pattern is defined, **Then** it defaults to the hyphen separator unless that
   agent's own documented skill-authoring spec explicitly states hyphens are unsupported or an
   anti-pattern for it, in which case the exception and its rationale are recorded alongside the
   pattern definition.

---

### User Story 2 - Name matches the agent-facing skill identifier (Priority: P1)

A user requests help for a specific skill (or a listing of all skills) and sees a `Name:` field.
Today that field shows a free-text label such as `Help`, which does not match the namespaced,
lowercase, hyphenated identifier (`highway-help`) that coding agents actually use to invoke the
skill. The user wants the displayed `Name:` to match that agent-facing identifier exactly, so
what they see is what they can type.

**Why this priority**: This is the specific defect the user called out first, and it is the
foundation the other two output fields (Usage, Help) build on — all three must agree on the same
namespaced identifier.

**Independent Test**: Can be fully tested by requesting help for the `help` skill (single-skill
mode) and for the full catalog (all-skills mode), and confirming every `Name:` line reads
`highway-<id>` rather than any free-text or unprefixed label.

**Acceptance Scenarios**:

1. **Given** the `help` skill is registered with catalog id `help`, **When** a user requests
   single-skill help for `help`, **Then** the response's `Name:` line reads exactly
   `Name: highway-help`.
2. **Given** the catalog has one or more registered skills, **When** a user requests the
   all-skills listing, **Then** every entry's `Name:` line reads `highway-<id>` for that entry's
   catalog id, with no entry showing a differently-cased or unprefixed label.

---

### User Story 3 - Usage and Help lines reference the namespaced command (Priority: P1)

The `Usage:` field (single-skill mode) and the per-entry `Help:` field (all-skills mode)
currently tell the user to invoke the bare, unprefixed command (`/help`). Since the coding agent
only recognizes the namespaced command (`/highway-help`), following the displayed instructions
verbatim fails. The user wants both fields to instruct the namespaced form.

**Why this priority**: Equal in importance to User Story 2 — showing the right name but the
wrong invocation instructions still leaves the user unable to act on what they read.

**Independent Test**: Can be fully tested by requesting single-skill help for `help` and
confirming the `Usage:` line reads using `/highway-help`, and by requesting the all-skills
listing and confirming every entry's `Help:` line reads `/highway-help <id>`.

**Acceptance Scenarios**:

1. **Given** a user requests single-skill help for `help`, **When** the response is printed,
   **Then** the `Usage:` line instructs invocation as `/highway-help` (for all skills) or
   `/highway-help <skill-id>` (for one named skill), with no remaining bare `/help` reference.
2. **Given** the all-skills listing contains an entry with catalog id `<id>`, **When** the
   listing is printed, **Then** that entry's `Help:` line reads exactly `Help: /highway-help <id>`.

---

### User Story 4 - Example invocation is copy-able (Priority: P2)

The `Example:` field is meant to give the user a ready-to-run invocation, but its value is
currently presented as plain text appended after the `Example:` label, indistinguishable from
surrounding prose. The user wants the example's invocation text presented as a distinct,
copy-able token, so they can select and paste it without editing out the label or any trailing
punctuation.

**Why this priority**: A convenience/usability improvement on top of Stories 1-2; the invocation
text is already correct once those are fixed, this story only affects how it is presented.

**Independent Test**: Can be fully tested by requesting single-skill help for any registered
skill and confirming the `Example:` line's value is wrapped as its own inline code span
containing only the runnable invocation, with no leading/trailing prose captured alongside it.

**Acceptance Scenarios**:

1. **Given** a user requests single-skill help for `help`, **When** the response is printed,
   **Then** the `Example:` line's value is wrapped in inline code formatting containing exactly
   `/highway-help help` and nothing else.
2. **Given** any other registered skill's `SKILL.md` documents its own `## Example` section,
   **When** that section is authored, **Then** its invocation line is wrapped in inline code
   formatting matching the same copy-able convention.

---

### Edge Cases

- What happens when a skill's catalog id itself already contains a `.`, a `-`, or unusual
  characters? The namespaced identifier is still formed as `highway-<id>` verbatim; no
  additional escaping or transformation is applied beyond the existing id-format rule already
  enforced at registration time.
- How does the all-skills listing behave when it lists the `help` skill's own entry? The `help`
  skill's own `Name:` and `Help:` lines follow the same rule as every other entry
  (`Name: highway-help`, `Help: /highway-help help`) — it is not special-cased.
- How does an empty catalog behave? Unchanged from existing behavior — the exact line
  `No skills are registered yet.` is still printed, with no `Name:`/`Usage:`/`Help:` fields to
  namespace.
- How does an unresolvable declared skill id behave? Unchanged from existing behavior — the
  exact line `ERROR: no skill registered with id '<declared-id>'` is still printed.
- What happens to the dot-separated artifacts already generated by feature 007 before this
  feature runs? They are treated as stale pre-hyphen artifacts and removed on regeneration, the
  same drift-safety-guarded mechanism feature 007 already established for retiring the original
  unprefixed paths.
- What if a future agent's own documented skill-authoring spec forbids both dots and hyphens?
  Out of scope for this feature — the extensibility procedure requires recording the exception
  and its rationale at the time that agent is added, per User Story 1's third acceptance
  scenario; no such agent is known to exist today.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Every agent-facing adapter path (github-copilot, claude-code, cursor) MUST use a
  hyphen (`-`) as the separator between the `highway` prefix and the skill id (`highway-<id>`),
  replacing the dot separator (`highway.<id>`) shipped by specs/007-highway-skill-namespace.
- **FR-002**: The hyphen separator MUST apply identically across all supported agents; no agent
  may use a different separator unless that agent's own documented skill-authoring spec
  explicitly states hyphens are unsupported or an anti-pattern for it, in which case the
  exception and its rationale MUST be recorded alongside that agent's target path definition.
- **FR-003**: Any agent added later via the existing extensibility mechanism MUST default to the
  hyphen separator without requiring a special case, consistent with FR-002's exception process.
- **FR-004**: Dot-separated artifacts already generated by specs/007-highway-skill-namespace
  MUST be removed on regeneration and replaced by their hyphen-separated equivalents, using the
  same drift-safety-guarded stale-artifact removal already established for retiring the original
  unprefixed paths.
- **FR-005**: Single-skill help output's `Name:` line MUST display the fully-namespaced,
  agent-facing identifier (`highway-<id>`) for the requested skill, replacing the current
  free-text frontmatter-authored label.
- **FR-006**: All-skills help output MUST display the same fully-namespaced identifier
  (`highway-<id>`) on each entry's `Name:` line, for every registered skill.
- **FR-007**: Single-skill help output's `Usage:` line MUST instruct invocation using the
  namespaced command form (`/highway-help` for all-skills mode, `/highway-help <skill-id>` for
  single-skill mode), replacing any remaining unprefixed (`/help`) reference.
- **FR-008**: All-skills help output's per-entry `Help:` line MUST read exactly
  `Help: /highway-help <id>`, replacing the current `Help: /help <id>` form.
- **FR-009**: Single-skill help output's `Example:` line MUST present its invocation value as a
  distinct, copy-able inline code span containing only the runnable invocation text (no label
  text or surrounding prose inside the span).
- **FR-010**: Every registered skill's own `SKILL.md` `## Example` section MUST present its
  documented invocation the same way — as a distinct, copy-able inline code span — so newly
  registered skills comply automatically without a special case for `help`.
- **FR-011**: These four output fields (`Name:`, `Usage:`, `Help:`, `Example:`) MUST stay
  internally consistent with each other for a given skill: the identifier used in `Name:` MUST
  be the same identifier referenced by `Usage:`, `Help:`, and `Example:` for that skill.
- **FR-012**: This behavior applies uniformly to every skill registered in
  `.highway/catalog/index.json`; no skill is exempted or special-cased.

### Key Entities

- **Help Output**: The rendered response to a help request, in either single-skill mode (six
  labeled fields: `Name:`, `Description:`, `Dependencies:`, `Version:`, `Usage:`, `Example:`) or
  all-skills mode (one `Name:`/`Usage:`/`Help:` block per registered skill).
- **Namespaced Skill Identifier**: The agent-facing identifier of the form `highway-<id>`, where
  `<id>` is the skill's plain catalog id (e.g. `help`), used consistently across every agent
  adapter path and across `Name:`, `Usage:`, `Help:`, and `Example:` in help output.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of generated agent adapter paths, across all three supported agents, use the
  hyphen-separated namespace form; zero dot-separated (`highway.<id>`) artifacts remain anywhere
  in the repository after regeneration.
- **SC-002**: 100% of help responses (single-skill and all-skills modes, across every registered
  skill) show a `Name:` value matching that skill's namespaced, agent-facing identifier, with
  zero mismatched casing, missing prefix, or wrong separator.
- **SC-003**: 100% of `Usage:` and `Help:` lines in help responses reference the namespaced
  command form; zero remaining unprefixed or dot-separated invocation references appear in
  generated output.
- **SC-004**: A user can copy a skill's example invocation from help output in a single
  select-and-copy action, with no manual edits needed to remove label text or stray characters.
- **SC-005**: A newly registered skill, and a newly added agent, both automatically display and
  use all of the above conventions with no additional per-skill or per-agent configuration
  beyond normal registration.

## Assumptions

- The namespaced identifier is computed as `highway-<id>` from the skill's existing catalog
  `id` field; it is not a new field authored separately per skill, avoiding a second source of
  truth that could drift from the `id` used elsewhere in the catalog.
- The underlying catalog `id` and each skill's source directory name under `.highway/skills/`
  remain unprefixed (unchanged from the existing convention) — only the generated agent adapter
  paths and the rendered help output change to show the namespaced, hyphenated form.
- This feature supersedes the dot separator (`highway.<id>`) introduced by
  specs/007-highway-skill-namespace, based on compatibility research: GitHub Copilot's published
  Agent Skills spec requires a skill's `name`/directory to use only lowercase letters, numbers,
  and hyphens (dots are disallowed and the name must match the parent directory exactly), while
  no equivalent research found any documented incompatibility or anti-pattern for a hyphen
  separator on github-copilot, claude-code, or cursor.
- "Copy-able" is satisfied by presenting the invocation as inline code (backtick-wrapped) text,
  consistent with how invocation syntax is already partially formatted elsewhere in this
  project's documentation.
- External tooling skills outside `.highway/skills/` (for example `speckit-*`) are not registered
  in `.highway/catalog/index.json` and are therefore unaffected by this feature, consistent with
  their existing out-of-scope status.
