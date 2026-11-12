---
name: invalid-skill-relative-link
description: "Fixture whose body carries a relative Markdown link target, to test the P8.7 failure path. Use when the tests exercise the validator."
license: Apache-2.0
metadata:
  version: 1.0.0
  usage: "Not invoked directly; used only as fixture input to the test suite."
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
A confirmation message. See [the authoring standard](../../../framework/authoring-standard.md) for
detail — this link is the seeded violation.

## Verification
The validator, run on this directory,
exits 1, naming P8.7 and the offending target.

## Error Handling
- If validation exits zero, abort and report the missed detection.
- If the fixture file is missing, escalate to the maintainer.

## Example
```text
framework/validate-skill.sh tests/fixtures/invalid-skill-relative-link
```
