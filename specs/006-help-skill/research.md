# Phase 0 Research: Help Skill

No `[NEEDS CLARIFICATION]` markers remain in spec.md, so this phase records the design
decisions needed to move from spec to data model/contracts, each already implied by an
Assumption in spec.md but requiring a concrete mechanism.

## R1: Where does "usage guidance" live?

**Decision**: New required top-level frontmatter field `usage` (non-empty string, <= 500
characters — same size rule as the existing `description` field).

**Rationale**: Keeps the existing split in this repository's skills between compact,
catalog-embeddable scalar frontmatter facts (`name`, `description`, `compatibility`, `version`)
and longer free-form body prose (`## Purpose`, `## Inputs`, etc.). A frontmatter field can be
read with the existing `fm_get` helper (no new parser) and copied into
`catalog/index.json` exactly the way `description` already is, so the all-skills listing
(User Story 2) is one read of the existing generated catalog, not N reads of every skill file.

**Alternatives considered**: A new `## Usage` body section — rejected because it would force
the all-skills listing to open and parse every skill's body just to build a one-line-per-skill
summary, duplicating work `generate-catalog.sh` already avoids for `description`.

## R2: Where does the "copy-able example" live?

**Decision**: New required body section `## Example` (eighth required section, alongside the
existing seven), holding exactly one copy-able example (typically a fenced code block showing
a literal invocation). Read directly from the target skill's own `SKILL.md` only when a
single-skill help request names that skill; never embedded in the catalog.

**Rationale**: An example is naturally multi-line and code-block-shaped — awkward and lossy to
force into a single-line YAML scalar or a JSON string column that every catalog regeneration
would carry for every skill even when unrequested. Single-skill requests already read the
target file directly for `Dependencies` and `Version` (R3), so reading `Example` from the same
file at the same time adds no new I/O.

**Alternatives considered**: Frontmatter field (rejected: YAML scalar strings do not support
embedded fenced code blocks cleanly); embedding in the catalog (rejected: same duplication
concern as R1's alternative, at a larger size).

## R3: What does "Dependencies" mean?

**Decision**: The single-skill response's `Dependencies` field is the target skill's existing
`metadata.dependencies` list (introduced by feature 004, already parsed by
`.highway/tools/lib/frontmatter.sh`'s `fm_get_dependencies`), read directly from the target's
`SKILL.md`. An empty list renders as the literal text `none` (FR-005), never a blank line.

**Rationale**: Reuses an already-validated, already-parsed field with zero new parsing code.

**Alternatives considered**: none — this field already exists for exactly this purpose and no
second "dependency" concept exists in this repository's skill model.

## R4: How does the catalog schema change?

**Decision**: `specs/001-multi-agent-skill-suite/contracts/catalog.schema.json` is left
unmodified as a historical record (matching this repository's established practice of treating
completed feature specs as frozen — see feature 005's `library-catalog.schema.json`
precedent). This feature adds a new, superseding schema at
`specs/006-help-skill/contracts/catalog.schema.json`: identical to 001's entry schema, plus one
new required string field, `usage`. `.highway/tools/generate-catalog.sh` and
`.highway/catalog/index.json`/`index.md` are updated in place to match the superseding schema —
the catalog itself is a live, regenerated artifact, not a historical record.

**Rationale**: Directly mirrors the exact precedent already established when feature 005
superseded 001's catalog concept for the library catalog, so this repository now has one
consistent rule: historical spec directories' contract files are never edited after the fact;
a new feature's own `contracts/` directory carries the currently authoritative shape, and the
generator scripts always track the newest contract.

## R5: What does the copy-able "Help" command look like?

**Decision**: The `Help` field shown for each skill in the all-skills response is the literal
string `/help <id>`, substituting the skill's directory-derived id — the same
slash-plus-kebab-case-id convention this repository's own skills are already invoked with (for
example `/speckit-plan`). Computed at response time from the `id` field already present in
`catalog/index.json`; never stored as its own catalog column.

**Rationale**: A deterministic, one-line function of a field that already exists; storing a
derived string separately would risk silent drift if the invocation convention ever changes in
one place and not the other.

**Alternatives considered**: Per-agent-specific invocation syntax (e.g. differing between
GitHub Copilot, Claude Code, Cursor) — rejected: the help skill's own SKILL.md is authored once
and adapted verbatim (`identity-copy`) to two of the three agent targets and lightly
transformed for the third (`mdc-transform`, frontmatter only); the body text, including the
Help command convention, is identical across all three, consistent with every other skill in
this repository.

## R6: What counts as "a skill" for this feature?

**Decision**: An entry under `.highway/skills/`, exactly the set that
`.highway/tools/validate-skill.sh` and `.highway/tools/generate-catalog.sh` already operate
over. The separate Spec-Kit workflow skills under `.github/skills/` (`speckit-specify`,
`speckit-plan`, etc.) are out of scope — already recorded in spec.md's Assumptions.

**Rationale**: `help` is itself added under `.highway/skills/`, and only that directory has a
generated catalog and validation/adapter tooling for this feature to reuse.

## R7: How is registration enforcement implemented?

**Decision**: Extend `.highway/tools/lib/schema-validate.sh`'s parallel arrays
`SV_REQUIRED_SECTIONS`/`SV_SECTION_RULE_TAGS` with `"Example"` tagged `SCHEMA` (no single
constitution rule governs it, same tag already used for `When not to use` and `Outputs`); add a
new `sv_validate_usage` function mirroring the existing `sv_validate_description` (non-empty,
<= 500 characters); call it from `.highway/tools/validate-skill.sh` alongside the existing
`sv_validate_description` call. A skill missing `usage` or `## Example` then fails validation
by the same mechanism, and with the same one-error-per-cause guarantee, that a skill missing
`description` or `## Purpose` already does.

**Rationale**: Zero new validation architecture — reuses the exact pattern already proven for
the seven existing required sections and the existing required scalar fields.

## R8: Multi-agent implementation

**Decision**: After authoring `.highway/skills/help/SKILL.md`, run the existing
`.highway/tools/generate-agent-adapters.sh` (no new tool, no new per-agent logic) so the skill
is materialized at all three currently supported targets: `.github/skills/help/SKILL.md`,
`.claude/skills/help/SKILL.md` (both `identity-copy`), and `.cursor/rules/help.mdc`
(`mdc-transform`). `quickstart.md`'s validation steps confirm all three exist and that
re-running the generator reports no drift.

**Rationale**: This is exactly the mechanism feature 001 built for this purpose (`AGENT_IDS`,
`AGENT_TARGET_TEMPLATES`, `AGENT_TRANSFORMS` in `generate-agent-adapters.sh`); the explicit
instruction to "ensure the skill is implemented by all supported coding agents" is satisfied by
exercising existing infrastructure for the first time on a real skill, not by building anything
new.

## R9: Performance Gate satisfaction

**Decision**: The `help` skill's guidance states the all-skills scan's cost as O(n), where n is
the entry count in `catalog/index.json` (itself bounded and pre-generated), satisfying the
constitution's Performance Gate, which is triggered because listing all skills is a
file-system-scan-shaped operation.

**Rationale**: The gate requires an algorithmic-complexity expression or a measured number with
a unit; O(n) over an already-bounded, already-generated file satisfies this without inventing a
fabricated benchmark number.
