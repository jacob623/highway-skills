---
name: highway-new
description: "Does not use a request."
usage: "Invoke as /highway-new."
compatibility: all
metadata:
  version: 2.0.0
---

# highway-new

## Purpose

Reserve the highway-new name and direct request work to highway-request.

## When to use

- The person invokes `/highway-new`.
- A workflow still names highway-new for a new request.

## When not to use

Do not collect a business problem, idea, or desired change.
Do not write a request record or a request catalog row.
Do not change Profile, Objectives, Controls, or NFRs.

## Inputs

- The invocation `/highway-new`.
- `.highway/governance/experience-standard.md`.
- A project root containing `.highway/`.

## Outputs

- No request record.
- No catalog row.
- One direction to `/highway-request`.

## Procedure

User-visible interaction follows the Highway Experience Standard. Repository ownership stays with the person.

Emit exactly: The highway-new name is reserved. Run `/highway-request` to describe a business problem, idea, or change.

Write nothing.

## Verification

- Invoking `/highway-new` writes no file under `requests/`.
- The reply names `/highway-request`.

## Error Handling

- A missing `.highway/` directory stops the skill and writes nothing. Say the project root cannot be located.

## Example

`/highway-new`
