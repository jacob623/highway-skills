# Help Skill: Output Contract

Defines the exact, byte-level-stable text shape the `help` skill (`.highway/skills/help/`)
MUST produce, for the two modes described in spec.md. This is the contract `## Outputs` and
`## Verification` in `help/SKILL.md` cite.

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

- `<dependency-list-or-none>` is the literal word `none` when `metadata.dependencies` is empty,
  otherwise a comma-separated `path@version` list, e.g. `library/foo.md@1.0.0,
  library/bar.md@2.1.0`.
- `<example>` may itself span multiple lines (e.g. a fenced code block copied verbatim from the
  target skill's `## Example` section); it is still exactly one `Example:` field.
- Every field is always non-blank (FR-004 through FR-005; a skill missing any source field
  already fails `validate-skill.sh`, so a valid, registered skill can never produce a blank
  field here).

### Error shape (unrecognized identifier)

```text
ERROR: no skill registered with id '<declared-id>'
```

- MUST NOT be followed by the All-Skills mode listing (FR-007). No other output is produced.

## All-Skills mode

### Success shape (one or more skills registered)

One three-line block per catalog entry, in `catalog/index.json` entry order, each block
followed by a blank line:

```text
Name: <name>
Usage: <usage>
Help: /help <id>
```

- `<id>` is the catalog entry's `id`; `/help <id>` run verbatim MUST reproduce that same skill's
  Single-Skill mode success shape above (SC-003).

### Empty shape (zero skills registered)

```text
No skills are registered yet.
```

- MUST NOT render an empty table or an empty list of blocks (FR-008).

## Stability

- Field labels and field order within each mode are fixed and MUST NOT vary across invocations
  or across which skill(s) are shown (FR-009, SC-006).
- Adding a new field to either shape is a breaking change to this contract and MUST increment
  the `help` skill's version per the constitution's Skill Versioning Policy (P7.7).
