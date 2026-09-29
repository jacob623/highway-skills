# Data Model: Always-On Agent Instructions

## Instruction source

Path: `.highway/instructions/<id>.md`

| Field | Rule |
|---|---|
| `id` | Filename without `.md`. Matches `^[a-z0-9]+(-[a-z0-9]+)*$`. |
| `name` | Frontmatter scalar. Equals `id`. |
| `description` | Frontmatter scalar. One non-empty line. No `"` character. |
| body | Every line after the closing `---`. Non-empty. Copied unchanged. |
| forbidden keys | `alwaysApply`, `globs`, `paths`, `applyTo`, and any key other than `name` and `description`. |

The first source is `highway-agent-context`. Its `description` is `Ground an agent in Highway identity and the experience standard, and leave workflow to the applicable skill.` Its body is the Highway Agent Context block in [spec.md](./spec.md), starting at `# Highway Agent Context` with no leading blank line.

## Cursor rule

Path: `.cursor/rules/<id>.mdc`

One per instruction. Frontmatter is `description` (quoted source value) then `alwaysApply: true`. No `globs`. The body follows the closing `---` immediately.

## Merged repository files

| File | Agent |
|---|---|
| `.claude/CLAUDE.md` | Claude Code, loaded with the repository |
| `.github/copilot-instructions.md` | Copilot, loaded with the repository |

Both contain the same bytes: each body in filename order (`LC_ALL=C`), each body keeping its trailing newline, one extra newline between bodies, and no added heading. Zero instructions produce a file of exactly one newline. One instruction produces a file equal to that body.

## Instruction manifest row

Path: `.highway/tools/.instruction-manifest`

Three tab-separated fields: `path`, `id`, `sha256`.

| Output | `id` value |
|---|---|
| `.cursor/rules/<id>.mdc` | That instruction's id |
| Either merged file, one or more instructions | Ids in filename order, joined by commas |
| Either merged file, no instructions | `-` |

A row exists only for a file this generator wrote. The skill adapter manifest never gains a `.cursor/rules/` row.

## Distribution row

The existing distribution manifest. Classification is include for every generated output. There is no source field that selects otherwise.

| Output | Distribution source |
|---|---|
| `.claude/CLAUDE.md` | One include row |
| `.github/copilot-instructions.md` | One include row |
| `.cursor/rules/<id>.mdc` | One include row per instruction |

`exclude` rows for `.claude`, `.cursor`, and `.github` stay, so a `speckit-*` skill or a hand-written rule is not included.

## State of a generated file

| State | Meaning | Generator |
|---|---|---|
| Absent | Safe to create, whether or not a row exists | Write the file and set the row |
| Present, hash matches row | Current | Rewrite the same bytes |
| Present, hash differs, or present with no row | Hand edit or foreign file | Exit non-zero, name the file, write nothing |

The generator does not delete. Removing a source leaves its Cursor file and its manifest row until a person removes them. The correspondence check reports that orphan. The merged files drop that body on the next successful run, and their row id changes, only when every target is safe to write.

## Relationships

- One instruction source has one Cursor rule, one distribution include for that rule, and one Cursor manifest row.
- Every instruction source appears, in filename order, in both merged files.
- Both merged files are byte-identical to each other.
- The instruction body inside each output equals the source body.
- Skill sources and skill adapters are not inputs or outputs of this model.
