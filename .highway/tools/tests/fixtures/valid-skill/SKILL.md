---
name: valid-skill
description: "A fully conformant fixture skill used only by the tests to validate the authoring framework."
usage: "Not invoked directly; used only as fixture input to the test suite."
compatibility: all
metadata:
  version: 1.0.0
---

## Purpose
Provide a conformant skill that the framework's own tests can validate against.

## When to use
- Use when a test needs a skill that passes every enforced constitution rule.
- Use when a test needs stable input for catalog or adapter generation.

## When not to use
Never reference this fixture from a real skill or from any generated catalog or adapter shipped
to users.

## Inputs
None.

## Outputs
A confirmation message.

## Verification
`.highway/tools/validate-skill.sh .highway/tools/tests/fixtures/valid-skill` exits 0.

## Error Handling
- If validation exits non-zero, abort and report the failing rule id.
- If the fixture file is missing, escalate to the maintainer.

## Example
```text
.highway/tools/validate-skill.sh .highway/tools/tests/fixtures/valid-skill
```
