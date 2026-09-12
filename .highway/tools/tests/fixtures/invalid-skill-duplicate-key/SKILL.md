---
name: invalid-skill-duplicate-key
description: "A fully conformant fixture skill used only by the tests to validate the authoring framework."
description: "A fully conformant fixture skill used only by the tests to validate the authoring framework."
usage: "Not invoked directly; used only as fixture input to the test suite."
compatibility: all
metadata:
  version: 1.0.0
---

## Purpose
Provide a fixture whose frontmatter declares the `description` key twice, to test the
duplicate-key failure path.

## When to use
- Use when a test needs a skill that fails only the duplicate-key check.

## When not to use
Never reference this fixture from a real skill or from any generated catalog or adapter shipped
to users.

## Inputs
None.

## Outputs
A confirmation message.

## Verification
`.highway/tools/validate-skill.sh .highway/tools/tests/fixtures/invalid-skill-duplicate-key`
exits 1.

## Error Handling
- If validation exits non-zero, abort and report the failing rule id.
- If the fixture file is missing, escalate to the maintainer.

## Example
```text
.highway/tools/validate-skill.sh .highway/tools/tests/fixtures/invalid-skill-duplicate-key
```
