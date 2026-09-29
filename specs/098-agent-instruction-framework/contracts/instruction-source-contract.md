# Contract: Instruction Source

Defines a valid file under `.highway/instructions/`. The generator reads this shape and rejects anything else before it writes.

## File

`.highway/instructions/<id>.md`

`<id>` matches `^[a-z0-9]+(-[a-z0-9]+)*$`.

## Frontmatter

The file starts with `---`, then only these two keys, then `---`:

| Key | Rule |
|---|---|
| `name` | Equals `<id>` |
| `description` | One non-empty line, containing no `"` |

No other key is allowed. In particular the file does not contain `alwaysApply`, `globs`, `paths`, or `applyTo`.

## Body

Every line after the closing `---` is the body. It must contain at least one non-whitespace character. Those lines are the reusable artifact. The generator copies them unchanged and does not add a heading.

The Highway Agent Context source has no blank line between the closing `---` and `# Highway Agent Context`.

## Rejection

Any of the following rejects the file: the id pattern fails, `name` differs from the id, `description` is missing or invalid, an unknown key is present, or the body is empty. One rejection aborts the run before any output is written.

## First instruction

| Field | Value |
|---|---|
| `id` / `name` | `highway-agent-context` |
| `description` | `Ground an agent in Highway identity and the experience standard, and leave workflow to the applicable skill.` |
| body | The Highway Agent Context block in [../spec.md](../spec.md) |
