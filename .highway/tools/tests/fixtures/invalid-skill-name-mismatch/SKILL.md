---
name: Not This Directory
description: "Otherwise-conformant fixture whose frontmatter name deliberately does not match its directory id, to test the name-equals-id failure path."
usage: "Not invoked directly; used only as fixture input to the test suite."
compatibility: all
metadata:
  version: 1.0.0
---

## Purpose
Provide a fixture that fails exactly one rule: frontmatter `name` does not equal the
directory-derived id.

## When to use
- Use when a test needs to confirm `sv_validate_name` rejects a mismatched `name`.

## When not to use
Never reference this fixture from a real skill or from any generated catalog or adapter shipped
to users.

## Inputs
None.

## Outputs
A confirmation message.

## Verification
`.highway/tools/validate-skill.sh .highway/tools/tests/fixtures/invalid-skill-name-mismatch`
exits 1, naming the `name`/id mismatch.

## Error Handling
- If validation exits non-zero, abort and report the failing rule id.
- If the fixture file is missing, escalate to the maintainer.

## Example
```text
.highway/tools/validate-skill.sh .highway/tools/tests/fixtures/invalid-skill-name-mismatch
```
