---
name: invalid-skill-nondeterministic-criterion
description: "Fixture whose decision criteria depend on when they are read, to test the P6.4 failure path."
usage: "Not invoked directly; used only as fixture input to the test suite."
compatibility: all
metadata:
  version: 1.0.0
---

## Purpose
Provide a fixture that fails exactly one rule: a decision criterion references a prohibited token.

## When to use
- Use when a test needs to confirm P6.4 rejects a criterion that depends on when it is read.
- Use when the catalog is currently stale — this criterion is the seeded violation.

## When not to use
Never reference this fixture from a real skill or from any generated catalog or adapter shipped
to users.

## Inputs
None.

## Outputs
A confirmation message naming the rule that rejected the seeded criterion.

## Verification
`.highway/tools/validate-skill.sh .highway/tools/tests/fixtures/invalid-skill-nondeterministic-criterion`
exits 1, naming P6.4 and the offending token.

## Error Handling
- If validation exits zero, abort and report the missed detection.
- If the fixture file is missing, escalate to the maintainer.

## Example
```text
.highway/tools/validate-skill.sh .highway/tools/tests/fixtures/invalid-skill-nondeterministic-criterion
```
