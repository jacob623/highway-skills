# Help Skill: Output Contract (Hyphen-Namespaced)

**Supersedes**: `specs/006-help-skill/contracts/help-output-contract.md`, for the `Name:`,
`Usage:`, `Help:`, and `Example:` fields' source/value only. Mode resolution, error shapes, field
order, and stability guarantees are carried forward unchanged and re-stated here for a single
authoritative reference.

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

- `<name>` is `highway-<id>` — computed from the target skill's catalog `id`, **not** copied from
  its frontmatter `name` field (data-model.md, research.md R2). **Changed from specs/006**, which
  copied frontmatter `name` verbatim.
- `<dependency-list-or-none>` is the literal word `none` when `metadata.dependencies` is empty,
  otherwise a comma-separated `path@version` list, e.g. `library/foo.md@1.0.0,
  library/bar.md@2.1.0`. Unchanged from specs/006.
- `<usage>` is the target skill's authored frontmatter `usage` text verbatim; that text's own
  invocation token MUST read `/highway-<id>` wherever it names the skill's own invocation
  (research.md R3). **Changed from specs/006** only in the expected token value, not the
  field's source mechanism.
- `<example>` is the target skill's `## Example` section, rendered so its invocation line is an
  inline code span (backtick-wrapped) containing only the runnable invocation — no label text or
  surrounding prose inside the span (research.md R5). **Changed from specs/006**, which allowed
  prose-wrapped rendering.
- Every field is always non-blank (a skill missing any source field already fails
  `validate-skill.sh`, so a valid, registered skill can never produce a blank field here).

### Error shape (unrecognized identifier)

```text
ERROR: no skill registered with id '<declared-id>'
```

- MUST NOT be followed by the All-Skills mode listing. No other output is produced. Unchanged
  from specs/006.

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
- `<id>` is the catalog entry's `id`; `/highway-help <id>` run verbatim MUST reproduce that same
  skill's Single-Skill mode success shape above. **Changed from specs/006**, which used
  `/help <id>`.

### Empty shape (zero skills registered)

```text
No skills are registered yet.
```

- MUST NOT render an empty table or an empty list of blocks. Unchanged from specs/006.

## Stability

- Field labels and field order within each mode are fixed and MUST NOT vary across invocations
  or across which skill(s) are shown. Unchanged from specs/006.
- Adding a new field to either shape is a breaking change to this contract and MUST increment the
  `help` skill's version per the constitution's Skill Versioning Policy (P7.7). Unchanged rule;
  this feature's own field-source changes are themselves classified MAJOR (research.md R6).
