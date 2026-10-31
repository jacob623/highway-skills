---
name: codify-tasks
description: "Complete output skeleton for the ordered task list of one accepted automation."
metadata:
  version: 1.0.0
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

- [ ] T001 [<component>] <one line of work>. File: `code/<id>/<component>/<file>`. Standard: `library/coding-standards/<standard>.md`.
- [ ] T002 [<component>] Test <file>. File: `code/<id>/<component>/<test file>`. Standard: `library/coding-standards/<standard>.md`.
- [ ] T003 [README] Write the Implement and Use parts. File: `code/<id>/README.md`. Standard: No coding standard applies.
```

`automation` is the `CDY` id of the automation this list serves. The list sits beside `codify.md` in the same folder.

Each task produces one file. `[ ]` is open and `[X]` is done. Tasks are numbered from `T001` with no gaps.

Tasks follow the component order of the accepted proposal. Within a component, a file comes before any file that relies on it. A test task directly follows the file it tests, and only when that file's standard says `Tests: required`. A file with no available standard says `Standard: No coding standard applies.` The README task is last.

Every component the accepted proposal names has at least one task. No task names a component the proposal does not name.
