---
name: codify-tasks
description: "Complete output skeleton for the ordered task list of one accepted automation."
metadata:
  version: 2.0.1
---

## File Frontmatter

```yaml
---
automation: CDYXXXXXX
---
```

## Body

```markdown
# Tasks: <automation title>

- [ ] T001 [Executor] <one line of work>. File: `code/<id>/executor/<file>`. Standard: `library/coding-standards/<standard>.md`.
- [ ] T002 [Task N] <one line of work>. File: `code/<id>/task-N/<file>`. Standard: `library/coding-standards/<standard>.md`.
- [ ] T003 [Task N] Test <file>. File: `code/<id>/task-N/<test file>`. Standard: `library/coding-standards/<standard>.md`.
- [ ] T004 [README] Write the Implement and Use parts. File: `code/<id>/README.md`. Standard: No coding standard applies.
```

`automation` is the `CDY` id of the automation this list serves. The list sits beside `codify.md` in the same folder.

Each task produces one file. `[ ]` is open and `[X]` is done. Tasks are numbered from `T001` with no gaps.

The Provider is the first node of the accepted diagram, and its files are the executor's files. Its files come first, are written once, and go in `executor/`. `[Task N]` names proposal task N. A proposal task adds lines in `task-N/` only when its method needs an artifact of its own. A task carried entirely by the executor adds none. Lines follow proposal task order. Within one tag, a file comes before any file that relies on it. A test task directly follows the file it tests, and only when that file's standard says `Tests: required`. A file with no available standard says `Standard: No coding standard applies.` The README task is last.

Every line names the executor, one proposal task, or the README. No line names a task the proposal does not list.
