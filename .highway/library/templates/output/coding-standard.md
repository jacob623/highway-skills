---
name: coding-standard
description: "Complete output skeleton for one coding standard."
metadata:
  version: 2.0.0
---

## Body

```markdown
# <Standard Title>

## Scope

<the language or platform this standard covers, and the files it applies to>

## File and Folder Structure

1. `<relative path>`

## Rules

1. <one rule written as an imperative; at most ten rules>

## Tests

Tests: required

<one sentence on how tests are written>

Test path: `<relative path>`
```

The file is `library/coding-standards/<file>.md`, named by the Standard Path of its catalog row.

The File and Folder Structure section is an ordered list of at least one path, relative to the automation folder. A path does not begin with `/` or `code/`. A placeholder in angle brackets, such as `<module>` or `<name>`, is filled for each automation.

The Tests section says `Tests: required`, then one sentence on how tests are written, then the test path, which is a path from the File and Folder Structure. Or it says `Tests: not required` with no sentence and no test path.
