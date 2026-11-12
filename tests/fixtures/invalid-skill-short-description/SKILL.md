---
name: invalid-skill-short-description
description: ""
license: Apache-2.0
metadata:
  version: 1.0.0
  usage: "Not invoked directly; used only as fixture input to the test suite."
---

## Purpose
Provide a fixture whose `description` field is below the minimum length constraint, to test the
length lower-bound failure path.

## When to use
- Use when a test needs a skill that fails only the description length check.

## When not to use
Never reference this fixture from a real skill or from any generated catalog or adapter shipped
to users.

## Inputs
None.

## Outputs
A confirmation message.

## Verification
The validator, run on this directory,
exits 1.

## Error Handling
- If validation exits non-zero, abort and report the failing rule id.
- If the fixture file is missing, escalate to the maintainer.

## Example
```text
framework/validate-skill.sh tests/fixtures/invalid-skill-short-description
```
