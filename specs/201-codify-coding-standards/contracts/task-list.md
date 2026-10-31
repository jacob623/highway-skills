# Contract: Task List

## Location and timing

`code/<id>/codify-tasks.md` is written in `write`, together with `code/<id>/codify.md` and the `code/code.md` row. No component file and no README exists before it.

## Shape

The file follows `.highway/library/templates/output/codify-tasks.md`.

```markdown
---
automation: CDYXXXXXX
---

# Tasks: <automation title>

- [ ] T001 [<component>] <description>. File: `code/<id>/<component>/<file>`. Standard: `library/coding-standards/<file>.md`.
- [ ] T002 [<component>] Test <file>. File: `code/<id>/<component>/<test file>`. Standard: `library/coding-standards/<file>.md`.
- [ ] T003 [README] Write the Implement and Use parts. File: `code/<id>/README.md`. Standard: No coding standard applies.
```

## Rules

- One task produces one file.
- Every component the accepted proposal names has at least one task. No task names another component.
- A file whose standard says `Tests: required` gets one test task directly after it. No other file gets a test task.
- A file with no matching standard says `Standard: No coding standard applies.`
- The README task is last.
- Tasks are numbered `T001` upward with no gaps.
