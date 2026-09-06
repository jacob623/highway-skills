---
name: Bad Id Fixture
description: "Fixture whose directory name is not kebab-case, to test the id failure path."
compatibility: all
metadata:
  version: 1.0.0
---

## Purpose
Provide a deliberately invalid fixture that exercises one validation failure path.

## When to use
- Use when a test needs a skill that fails exactly one rule.
- Use when confirming the failure path names the offending field.

## When not to use
Never reference this fixture from a real skill.

## Inputs
None.

## Outputs
An error message naming the offending field.

## Verification
`.highway/tools/validate-skill.sh <this-dir>` exits non-zero.

## Error Handling
- If validation exits zero, abort and report the missed detection.
