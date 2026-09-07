# Skill Authoring Contract: Directory/Id/Name Alignment

**Supersedes**: `.highway/skills/_authoring-standard.md`'s prior `name` field row ("Free-form
display name. Never required to match the directory-derived id."), for that row only. Every
other row and section of the authoring standard is carried forward unchanged.

Defines the rule `.highway/tools/lib/schema-validate.sh`'s new `sv_validate_name` function and
`.highway/skills/_authoring-standard.md`'s `name` row MUST both state, for every skill under
`.highway/skills/`, present and future.

## Rule

- A skill's directory name (its id) MUST already be the full, agent-facing identifier that
  skill is exposed as by every generated adapter — no bare, unprefixed directory name may be
  registered.
- A skill's frontmatter `name` field MUST equal its directory-derived id exactly, byte-for-byte.
  Case, whitespace, and punctuation all count — `Help` does not equal `help`, and `highway-help `
  (trailing space) does not equal `highway-help`.

## Validation

- Function: `sv_validate_name(name, id)` in `.highway/tools/lib/schema-validate.sh`.
- Tier: `[SCHEMA]` — a direct, decidable string-equality check, following the same precedent as
  `sv_validate_id`/`sv_validate_description`/`sv_validate_usage`/`sv_validate_compatibility`. Not
  tied to a constitution principle id; no constitution amendment required (research.md R4).
- Called from `.highway/tools/validate-skill.sh` alongside the other schema-level checks, before
  any rule-level (`[auto]`/`[agent-checkable]`/`[human-review]`) checks run.
- Failure output (exact form): `ERROR: [SCHEMA] frontmatter 'name' ('<name>') does not match
  directory-derived id '<id>'`.
- A skill failing this check fails `validate-skill.sh` with exit 1, and is therefore excluded
  from `generate-catalog.sh`'s catalog and `generate-agent-adapters.sh`'s adapter generation
  (both already abort entirely on any invalid skill — unchanged, pre-existing behavior).

## Non-goals

- This contract does not change the kebab-case character-set rule (`sv_validate_id`'s
  `^[a-z0-9]+(-[a-z0-9]+)*$` regex is unchanged) — a fully-namespaced id such as `highway-help`
  already satisfies it.
- This contract does not require every agent adapter format to carry a `name`-equivalent field.
  Cursor's `.mdc` transform carries only `description` and `alwaysApply` (specs/001); an adapter
  format with no `name`-equivalent field is unaffected and is not a violation (spec.md Edge
  Cases).
