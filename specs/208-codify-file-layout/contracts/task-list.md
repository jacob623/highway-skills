# Contract: Task List

```markdown
# Tasks: <automation title>

- [ ] T001 [Executor] <work the Provider needs that no feature writes>. Files: `<path>`. Standards: `library/coding-standards/<a>.md`.
- [ ] T002 [Task 1] Test <behavior>. Files: `<test path>`. Standards: `library/coding-standards/<a>.md`.
- [ ] T003 [Task 1] <work>. Files: `<path>`, `<path>`. Standards: `library/coding-standards/<a>.md`.
- [ ] T004 [Task 2] <work>. Files: `<path>`. Standards: No coding standard applies.
- [ ] T005 [README] Write the Setup Instructions and User Guide parts. Files: `README.md`. Standards: No coding standard applies.
```

- Groups follow proposal task order. A feature's lines are contiguous.
- Every path is relative and has no unfilled placeholder. No path is under `executor/` or `task-N/`.
- A path in a standard's structure that no feature delivers has no line.
- Several features can name the same path. A later step names the existing file it changes.
- A test line is first in its feature, only when that feature's first standard says `Tests: required`.
- `[Executor]` lines are optional and come before every feature.
