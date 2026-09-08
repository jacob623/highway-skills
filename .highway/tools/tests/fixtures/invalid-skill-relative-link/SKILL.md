---
name: invalid-skill-relative-link
description: "Fixture whose body carries a relative Markdown link target, to test the P8.7 failure path."
usage: "Not invoked directly; used only as fixture input to the test suite."
compatibility: all
metadata:
  version: 1.0.0
---

## Purpose
Provide a fixture that fails exactly one rule: a Markdown link target is a relative path.

## When to use
- Use when a test needs to confirm P8.7 rejects a relative link target.

## When not to use
Never reference this fixture from a real skill or from any generated catalog or adapter shipped
to users.

## Inputs
None.

## Outputs
A confirmation message. See [the authoring standard](../../../skills/_authoring-standard.md) for
detail — this link is the seeded violation.

## Verification
`.highway/tools/validate-skill.sh .highway/tools/tests/fixtures/invalid-skill-relative-link`
exits 1, naming P8.7 and the offending target.

## Error Handling
- If validation exits zero, abort and report the missed detection.
- If the fixture file is missing, escalate to the maintainer.

## Example
```text
.highway/tools/validate-skill.sh .highway/tools/tests/fixtures/invalid-skill-relative-link
```
