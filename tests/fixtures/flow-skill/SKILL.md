---
name: flow-skill
description: "A fixture skill split into a router and flow files, used only by the tests. Use when the tests exercise the flows table, the flow file kind, or the inventory."
license: Apache-2.0
metadata:
  version: 1.0.0
  usage: "Not invoked directly; used only as fixture input to the test suite."
---

## Purpose
Provide a split skill that the framework's own tests can validate against.

## When to use
- Use when a test needs a skill whose steps live in flow files.
- Use when a test seeds a breach of a flow pattern boundary.

## When not to use
Never reference this fixture from a real skill or from any generated catalog or adapter shipped
to users.

## Inputs
None.

## Outputs
A confirmation message.

## Procedure

Follow the steps in order.

Before a step in this table, read its file and follow it to the end.

| File | Steps |
| --- | --- |
| `references/proposal.md` | `start`, `revise` |
| `references/record.md` | `identifier`, `write` |

### Entry

Go to `Classify`.

### Classify

1. When the request is new, go to `start`.
2. Otherwise, go to `identifier`.

### close

Confirm the record and stop.

## Verification
- The record exists after `close`.

## Error Handling
- If validation exits non-zero, abort and report the failing rule id.
- If the fixture file is missing, escalate to the maintainer.

## Example
```text
flow-skill 1.0.0
```
