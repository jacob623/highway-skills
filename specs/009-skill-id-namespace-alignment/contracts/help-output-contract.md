# Help Skill: Output Contract (Verbatim Id, Post-Alignment)

**Supersedes**: `specs/008-help-output-namespacing/contracts/help-output-contract.md`, for the
`Name:` field's computation source, and every declared-identifier argument's expected value
(the `Help:` line and `## Example` invocation), only. Mode resolution, error shapes, field
order, and stability guarantees are carried forward unchanged and re-stated here for a single
authoritative reference.

Defines the exact, byte-level-stable text shape the `help` skill
(`.highway/skills/highway-help/`) MUST produce, for the two modes described in spec.md. This is
the contract `## Outputs` and `## Verification` in `highway-help/SKILL.md` cite.

## Mode resolution

- A skill identifier is declared (as the skill's argument/input) -> **Single-Skill mode**.
- No skill identifier is declared -> **All-Skills mode**.

## Single-Skill mode

### Success shape

Exactly six lines, one field per line, in this order, each a label, a colon, a space, then the
value:

```text
Name: <name>
Description: <description>
Dependencies: <dependency-list-or-none>
Version: <version>
Usage: <usage>
Example: <example>
```

- `<name>` is the target skill's catalog `id`, read verbatim. **Changed from specs/008**, which
  computed `<name>` as `highway-<id>` string concatenation against a bare id; now the id itself
  is already the full, agent-facing form (this feature's User Story 1), so no concatenation is
  needed or performed. The resulting displayed value is unchanged for `highway-help`
  specifically (`highway-help` either way) — only the computation mechanism simplifies.
- `<dependency-list-or-none>` is the literal word `none` when `metadata.dependencies` is empty,
  otherwise a comma-separated `path@version` list. Unchanged from specs/006/008.
- `<usage>` is the target skill's authored frontmatter `usage` text verbatim. Unchanged from
  specs/008.
- `<example>` is the target skill's `## Example` section, rendered so its invocation line is an
  inline code span (backtick-wrapped) containing only the runnable invocation. Unchanged
  mechanism from specs/008; the `help` skill's own `<example>` value changes from
  `` `/highway-help help` `` to `` `/highway-help highway-help` ``, since the declared-identifier
  argument MUST now be the full agent-facing id (skill-authoring-contract.md; the old, bare-id
  argument `help` no longer names any registered skill).
- Every field is always non-blank. Unchanged from specs/006/008.

### Error shape (unrecognized identifier)

```text
ERROR: no skill registered with id '<declared-id>'
```

- MUST NOT be followed by the All-Skills mode listing. Unchanged from specs/006/008.
- The declared id `help` (the pre-migration bare id) now falls into this error shape, since no
  skill is registered under that id after this feature's migration.

## All-Skills mode

### Success shape (one or more skills registered)

One three-line block per catalog entry, in `catalog/index.json` entry order, each block
followed by a blank line:

```text
Name: <name>
Usage: <usage>
Help: /highway-help <id>
```

- `<name>` and `<usage>` follow the same rules as Single-Skill mode above.
- `<id>` is the catalog entry's `id`, already the full agent-facing form after this feature —
  for `help`/`highway-help`, this line now reads `Help: /highway-help highway-help`. **Changed
  from specs/008**, which read `Help: /highway-help help` (bare id argument against a
  namespaced invocation prefix).

### Empty shape (zero skills registered)

```text
No skills are registered yet.
```

Unchanged from specs/006/008.

## Stability

- Field labels and field order within each mode are fixed and MUST NOT vary. Unchanged from
  specs/006/008.
- Adding a new field to either shape is a breaking change to this contract and MUST increment
  the `help` skill's version per the constitution's Skill Versioning Policy (P7.7). This
  feature's own field-source and declared-identifier-value changes are themselves classified
  MAJOR (research.md R5): `2.0.0` → `3.0.0`.
