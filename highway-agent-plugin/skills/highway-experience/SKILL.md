---
name: highway-experience
description: "Holds highway identity, the experience standard, and the storage contract. Use when another highway skill loads it as its first step, or when the person asks what highway is. Not for a request unrelated to highway."
license: Apache-2.0
metadata:
  version: 1.2.0
  usage: "Loaded by every other highway skill. Run highway-experience directly for a summary of highway."
---

# highway-experience

## Purpose

Gives every Highway skill one shared source for Highway's identity, the Experience Standard, and the storage contract.

## When to use

- Another Highway skill activates it as the first step of its Procedure.
- The person invokes `highway-experience` to learn what Highway is.

## When not to use

- Do not use for a request unrelated to Highway.
- Do not use as a workflow. It collects no evidence and writes no record.

## Inputs

- `references/experience-standard.md`: the Highway Experience Standard.
- `references/storage-contract.md`: the Highway Storage Contract.
- `references/highway-identity.md`: the Highway Identity.

## Outputs

- When activated by a skill: nothing of its own. The activating skill's output follows these references.
- When invoked directly: a summary of what Highway is, in at most five sentences, ending with `highway-help`.

## Procedure

### Activated by a skill

Read `references/experience-standard.md` before any output the person sees, and apply it to that output.

Read `references/storage-contract.md` before the first repository read or write. Reach the repository only through its operations.

Read `references/highway-identity.md` when the work explains what Highway is or why it exists.

Treat these references as authoritative for their concerns. Do not restate or reinterpret them.

When a Highway skill applies, defer the workflow, artifact ownership, inputs, outputs, persistence, and decisions to that skill.

Do not treat Highway identity or experience guidance as organizational facts, or as a substitute for a workflow's own inputs.

Show nothing of its own. Return to the activating skill.

### Invoked directly

Read `references/highway-identity.md` and `references/experience-standard.md`.

Summarize what Highway is and why it exists, in at most five sentences. End with `highway-help` as the next action.

Start no workflow. Write no file.

## Verification

- Every other Highway skill activates this skill before its first output.
- The activating skill's output follows the Experience Standard.
- Every repository read and write goes through the storage contract's operations.
- A direct invocation shows at most five sentences, names `highway-help`, and writes no file.

## Error Handling

- A reference is missing or unreadable: stop, and say which reference could not be read.

## Example

`/highway-experience`

```text
Highway connects business intent, governance, architecture, and engineering in your repository, so each piece of work stays traceable to the decisions behind it.
Run /highway-help to see what Highway can help you do.
```
