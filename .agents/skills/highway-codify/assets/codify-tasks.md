---
name: codify-tasks
description: "Complete output skeleton for the ordered task list of one accepted automation."
metadata:
  version: 6.0.0
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

## Story 1: <story title from plan.md>

Independent test: <how this story is tested on its own>

- [ ] T002 [Task N] Test <behavior>. Files: `<test path>`. Standards: `library/coding-standards/<standard>.md`.
- [ ] T003 [Task N] <one line of work>. Files: `<path>`, `<path>`. Standards: `library/coding-standards/<standard>.md`.

## <proposal task action>

Independent test: <how this task is tested on its own>

- [ ] T004 [Task N] <one line of work>. Files: `<path>`. Standards: `library/coding-standards/<standard>.md`.

## README

- [ ] T005 [README] Write the Setup Instructions and User Guide parts. Files: `README.md`. Standards: No coding standard applies.
```

`product` is the `CDY` id of the product this feature belongs to. The list sits beside `codify.md` and `plan.md` in `code/<folder>/.highway/features/<number>-<action>/`. It is written when the person continues from the plan.

`[ ]` is open and `[X]` is done. Tasks are numbered from `T001` with no gaps, across every story.

The Provider is the first node of the accepted diagram. `[Executor]` lines are optional. They hold files the Provider needs that no story's line writes, and they come before every story.

Each `## Story N:` heading is a story from `plan.md`, in plan order. The `Independent test:` line under a heading says how that heading is tested on its own. Each line under a story is tagged `[Task N]` with the proposal task it carries out. Every story has at least one line. A proposal task that delivers no story has its own heading after the stories, taken from that task, with its line under it. The README task is last, under `## README`.

`Files:` names the files the line creates or changes, by paths relative to the product folder `code/<folder>/`, taken from the accepted Files of that proposal task. A path has no unfilled placeholder. A later line names an existing file it changes. A path no proposal task delivers has no line. Within a story, a file comes before any file that relies on it.

`Standards:` names the Standard Paths of the accepted Standards list, in the same order. A `[Task N]` line uses proposal task N's list. An `[Executor]` line uses the list of the first proposal task that has a standard whose File Patterns match the file. A line with no standard says `Standards: No coding standard applies.` When the first standard of a story's first `[Task N]` line says `Tests: required`, the story's first line is its test, at that standard's test path. A later story that does not change the tested behavior adds no test.

Every line names the executor, one proposal task, or the README. Every proposal task has a line. No line names a task the proposal does not list.
