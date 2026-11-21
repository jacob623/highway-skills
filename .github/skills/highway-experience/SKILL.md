---
name: highway-experience
description: "Holds highway identity, the experience standard, and the storage contract. Use when another highway skill loads it as its first step, or when the person asks what highway is. Not for a request unrelated to highway."
license: Apache-2.0
metadata:
  version: 1.4.0
  usage: "Loaded by every other highway skill. Run highway-experience directly for a summary of highway."
---

# highway-experience

## Purpose

Gives every Highway skill one shared source for Highway's identity, the Experience Standard, and the storage contract — including effective knowledge-root resolution and the setup-or-pointer gate.

## When to use

- Another Highway skill activates it as the first step of its Procedure.
- The person invokes `highway-experience` to learn what Highway is.

## When not to use

- Do not use for a request unrelated to Highway.
- Do not use as a workflow that collects evidence or writes Highway knowledge records (pointer files in the open project are allowed only during the gate below).

## Inputs

- `references/experience-standard.md`: the Highway Experience Standard.
- `references/storage-contract.md`: the Highway Storage Contract.
- `references/highway-identity.md`: the Highway Identity.
- `assets/repository-gate.md`: shared copy for the repository gate.

## Outputs

- When activated by a skill and ready: nothing of its own beyond establishing the effective knowledge root. The activating skill's output follows these references.
- When activated and not-ready: only the active block from `assets/repository-gate.md`, then stop for the activating skill (except setup-here inside `highway-setup`, or continue after a successful bind).
- When invoked directly: a summary of what Highway is, in at most five sentences, ending with `highway-help`.

## Procedure

### Activated by a skill

Read `references/experience-standard.md` before any output the person sees, and apply it to that output.

Read `references/storage-contract.md` before the first repository read or write. Reach the repository only through its operations.

Resolve the effective Highway knowledge root using the storage contract's resolution order, then read the mode record under that root when a root exists.

#### Ready

When a usable effective knowledge root exists (usable local pointer or open project is a knowledge root), establish that root for the run. Read `references/highway-identity.md` when the work explains what Highway is or why it exists. Treat these references as authoritative. When a Highway skill applies, defer the workflow, artifact ownership, inputs, outputs, persistence, and decisions to that skill. Do not treat Highway identity or experience guidance as organizational facts. Show nothing of its own. Return **ready** to the activating skill.

#### Not ready — gate

When resolution does not yield a usable Local knowledge root, use only `assets/repository-gate.md`:

1. **Committed URL only** (no usable local path, open project not a knowledge root): emit **URL only**. Return **not-ready**. Activating skill writes nothing and ends.
2. **Otherwise**: emit **Dual offer**. Classify the reply.
   - **Setup in this project** and activating skill is not `highway-setup`: emit **Setup next action**. Return **not-ready**. Do not run setup inside this skill.
   - **Setup in this project** and activating skill is `highway-setup`: set effective root to the open project (setup-here override). Return **ready** so setup continues in the same invocation.
   - **Folder path** (optional repository URL): if the path is not a usable knowledge root, emit **Invalid path** and stay in the gate. If it is usable, optionally ask **Persist local path** and/or **Persist URL**. Persist local only when the person accepts storing it **and** listing `hw-repository.local.md` in the project's ignore file (write the pointer and ensure the ignore entry together). Persist URL when accepted into `hw-repository.md` without adding that file to the ignore file. Do not clone. Then return **ready** in the **same** invocation so the activating skill proceeds (**Bound ready** — no user-visible text).
   - Decline or unclear: ask one clarifying question from the dual offer; do not write Highway catalogs into the open non-knowledge project.

Pointer file writes use storage operations against the **open project** paths `hw-repository.md`, `hw-repository.local.md`, and the project's ignore file as needed for the ignore entry.

### Invoked directly

Read `references/highway-identity.md` and `references/experience-standard.md`.

Summarize what Highway is and why it exists, in at most five sentences. End with `highway-help` as the next action.

Start no repository gate. Write no file.

## Verification

- Every other Highway skill activates this skill before its first output.
- The activating skill's output follows the Experience Standard.
- Every repository read and write goes through the storage contract's operations under the effective knowledge root.
- Resolve-root and the setup-or-pointer gate run only here; owning skills do not re-offer that gate.
- A direct invocation shows at most five sentences, names `highway-help`, and writes no file.

## Error Handling

- A reference or `assets/repository-gate.md` is missing or unreadable: stop, and say which file could not be read.

## Example

`/highway-experience`

```text
Highway connects business intent, governance, architecture, and engineering in your repository, so each piece of work stays traceable to the decisions behind it.
Run /highway-help to see what Highway can help you do.
```
