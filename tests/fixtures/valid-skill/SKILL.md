---
name: valid-skill
description: "A fully conformant fixture skill used only by the tests to validate the authoring framework. Use when the tests exercise the validator."
license: Apache-2.0
metadata:
  version: 1.0.0
  usage: "Not invoked directly; used only as fixture input to the test suite."
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
The validator exits 0 for this directory.

## Error Handling
- If validation exits non-zero, abort and report the failing rule id.
- If the fixture file is missing, escalate to the maintainer.

## Example
```text
framework/validate-skill.sh tests/fixtures/valid-skill
```
