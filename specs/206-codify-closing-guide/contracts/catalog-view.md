# Contract: Catalog View

Entered from `highway-codify` Entry when the invocation is the word `catalog` or asks to show the code catalog. Handled after `configure` and before resuming a task list or selecting an implementation. Writes nothing.

## List

```markdown
**1. [Automation title]:** [Implementation title]. [Every task is done. Or: Task [T###] is next.]

[[N] more automations are not shown. Or: 1 more automation is not shown.]

**Which automation would you like to discuss?** [You can name or describe any automation.]
```

- Only accepted rows of `code/code.md`. Removed rows are neither listed nor counted.
- The last five accepted rows, numbered from 1, newest first.
- No id is a label.
- The count line and the name-or-describe sentence appear only when more than five accepted rows exist.
- With no accepted row: "No automation has been created yet." and no question.

## Reply classification

| Reply | Result |
|---|---|
| A listed number | Select that automation |
| An exact accepted title, without regard to case | Select it, shown or not |
| A description matching one accepted automation | Select it |
| A description matching several | List those matches, newest first, at most five. Ask again |
| A description matching none | Say no automation matches. Ask again |
| `decline` | Stop. Write nothing |

## Selection

```markdown
**[Automation title]**

- **Files:** `code/[ID]/`
- **Setup and Usage Instructions:** `code/[ID]/README.md`

**What would you like to know about it?**
```

When the README task is open, the second line reads "**Setup and Usage Instructions:** The instructions are not written yet."

## Boundaries

- Writes no file.
- Does not enter `choose`, `suggest`, `start`, `code`, or `configure`.
- Does not resume a task list.
