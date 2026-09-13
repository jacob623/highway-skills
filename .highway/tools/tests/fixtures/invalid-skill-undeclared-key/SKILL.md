---
name: invalid-skill-undeclared-key
description: "A fully conformant fixture skill used only by the tests to validate the authoring framework."
usage: "Not invoked directly; used only as fixture input to the test suite."
compatibility: all
licence: MIT
metadata:
  version: 1.0.0
---

## Purpose
Provide a fixture whose frontmatter declares an undeclared top-level key (`licence`), to test
the closed-key-set failure path.

## When to use
- Use when a test needs a skill that fails only the undeclared-key check.

## When not to use
Never reference this fixture from a real skill or from any generated catalog or adapter shipped
to users.

## Inputs
None.

## Outputs
A confirmation message.

## Verification
`.highway/tools/validate-skill.sh .highway/tools/tests/fixtures/invalid-skill-undeclared-key`
exits 1.

## Error Handling
- If validation exits non-zero, abort and report the failing rule id.
- If the fixture file is missing, escalate to the maintainer.

## Example
```text
.highway/tools/validate-skill.sh .highway/tools/tests/fixtures/invalid-skill-undeclared-key
```
