---
name: codify-tasks
description: "Complete output skeleton for the ordered task list of one accepted automation."
metadata:
  version: 5.0.0
---

## File Frontmatter

```yaml
---
product: CDYXXXXXX
---
```

## Body

```markdown
# Tasks: <automation title>

- [ ] T001 [Executor] <work the Provider needs that no proposal task writes>. Files: `<path>`. Standards: `library/coding-standards/<platform standard>.md`, `library/coding-standards/<language standard>.md`.
- [ ] T002 [Task N] Test <behavior>. Files: `<test path>`. Standards: `library/coding-standards/<standard>.md`.
- [ ] T003 [Task N] <one line of work>. Files: `<path>`, `<path>`. Standards: `library/coding-standards/<standard>.md`.
- [ ] T004 [README] Write the Setup Instructions and User Guide parts. Files: `README.md`. Standards: No coding standard applies.
```

`product` is the `CDY` id of the product this feature belongs to. The list sits beside `codify.md` in `code/<folder>/.highway/features/<number>-<action>/`.

`[ ]` is open and `[X]` is done. Tasks are numbered from `T001` with no gaps.

The Provider is the first node of the accepted diagram. Each proposal task is one feature, tagged `[Task N]`. A feature's lines sit together, and features follow proposal task order. `[Executor]` lines are optional. They hold files the Provider needs that no feature writes, and they come before every feature. The README task is last.

`Files:` names the files the line creates or changes, by paths relative to the product folder `code/<folder>/`, taken from the accepted Files of that proposal task. A path has no unfilled placeholder. A later line names an existing file it changes. A path no feature delivers has no line. Within a feature, a file comes before any file that relies on it.

`Standards:` names the Standard Paths of the accepted Standards list, in the same order. A `[Task N]` line uses proposal task N's list. An `[Executor]` line uses the list of the first proposal task that has a standard whose File Patterns match the file. A line with no standard says `Standards: No coding standard applies.` When a feature's first standard says `Tests: required`, the feature's first line is its test, at that standard's test path. A later feature that does not change the tested behavior adds no test.

Every line names the executor, one proposal task, or the README. No line names a task the proposal does not list.
