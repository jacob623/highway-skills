---
name: coding-standard
description: "Complete output skeleton for one coding standard."
metadata:
  version: 3.0.1
---

## Body

```markdown
# <Standard Title>

## Scope

<the language or platform this standard covers, and the files it applies to>

## File and Folder Structure

1. `<relative path>`

## Rules

1. <one rule with must once, one condition, and one outcome, in eight words or fewer; the model suggests at most fifteen>

## Tests

Tests: required

<one sentence on how tests are written>

Test path: `<relative path>`
```

The file is `library/coding-standards/<file>.md`, named by the Standard Path of its catalog row.

The File and Folder Structure section is an ordered list of at least one path, relative to the automation folder. A path does not begin with `/` or `code/`. A placeholder in angle brackets, such as `<module>` or `<name>`, is filled for each automation.

The Tests section says `Tests: required`, then one sentence on how tests are written, then the test path, which is a path from the File and Folder Structure. Or it says `Tests: not required` with no sentence and no test path.

One rule keeps encoded or encrypted credentials outside the files this standard covers. When the technology's current documentation names a supported way to encrypt or store them, that rule names that way. This file does not contain a Why it matters line.
