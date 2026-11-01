# Contract: File List and Coverage

## `code/[ID]/codify-tasks.md` (codify-tasks 2.0.0)

```markdown
# Tasks: <automation title>

- [ ] T001 [Executor] <one line of work>. File: `code/<id>/executor/<file>`. Standard: `library/coding-standards/<standard>.md`.
- [ ] T002 [Task 2] <one line of work>. File: `code/<id>/task-2/<file>`. Standard: `library/coding-standards/<standard>.md`.
- [ ] T003 [Task 2] Test <file>. File: `code/<id>/task-2/<test file>`. Standard: `library/coding-standards/<standard>.md`.
- [ ] T004 [README] Write the Implement and Use parts. File: `code/<id>/README.md`. Standard: No coding standard applies.
```

- Executor files come first and are written once.
- A proposal task adds lines only when its method needs its own artifact. A task carried entirely by the executor adds none. A task never gets another task's file.
- Lines follow proposal task order. Within one tag, a file comes before any file that relies on it.
- Each line produces one file. The standard is matched by file pattern, exactly as in 1.0.0. A test line follows its file only when that standard says `Tests: required`.
- The README line is last.

### Examples

| Executor | Tasks | Lines |
|---|---|---|
| One agent instruction | All inside the instruction | `[Executor]` instruction file, `[README]` |
| A pipeline | Task 1 calls an API inside the pipeline. Task 2 applies Terraform | `[Executor]` pipeline file, `[Task 2]` Terraform files and the required test, `[README]` |
| A service or operator | Two tasks with their own handlers | `[Executor]` shared files, `[Task 1]` handler, `[Task 2]` handler, `[README]` |

## Coverage in `highway-adr`

A current implementation is covered when an accepted row in `code/code.md` names it and that automation's title is this decision's title, without regard to case.

Replaces: `that automation's `## Action` is this decision's title`.
