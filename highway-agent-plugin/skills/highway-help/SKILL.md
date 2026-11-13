---
name: highway-help
description: "Prints registration details for one named skill, or a discovery listing of every registered skill when none is named. Use when the person wants to confirm a skill exists or find how to run it."
license: Apache-2.0
metadata:
  version: 3.4.0
  usage: "Run highway-help for all skills, or highway-help <skill-id> for one named skill's registration details."
---

## Purpose

Print a registered skill's own registration details, or list every registered skill, on request.

## When to use

- A skill identifier is declared: show that one skill's Name, Description, Version, Usage, and
  Example.
- No skill identifier is declared: list every registered skill's Name, Description, and a copy-able
  Help command.
- Confirming a skill exists, or discovering what a skill's exact invocation syntax is, before
  using it.

## When not to use

- Do not use to validate a skill file's authoring correctness; use the repository's authoring
  workflow instead.

## Inputs

- The optional declared skill identifier — the full agent-facing id of the target skill
  (e.g. `highway-help`), not a bare or abbreviated form.
- `assets/index.json` — the skill index, one entry per registered skill with its `id`,
  `description`, `usage`, `version`, and `example`. Read for both modes; nothing else is read.
- The highway-experience skill, activated first.

## Outputs

Satisfies `P9.2`, `P9.3`, `P9.4` and `X5.1` of the Highway Skills Constitution and the Highway Experience Standard.

- Single-Skill mode: exactly five labeled lines — `Name:`, `Description:`, `Version:`, `Usage:`,
  `Example:` — in that order, per the help output contract defined by feature 009 (skill id
  namespace alignment).
  `Name:` is the entry's `id`, read verbatim — already the full agent-facing
  identifier, so no prefix is concatenated. `Example:` presents the entry's `example` as an
  inline code span (backtick-wrapped), containing only the runnable invocation.
- All-Skills mode: one `Name:`/`Description:`/`Help: highway-help <id>` block per index entry, in
  index order, one entry per registered skill, or the exact line
  `No skills are registered yet.` when the index is empty. `Name:` is resolved the same way as
  Single-Skill mode.
- Listing all skills reads the whole index once: cost is O(n), where n is the number of
  registered skill entries.

## Procedure

Activate the highway-experience skill before any output the person sees, and follow it for Highway's identity, the Experience Standard, and the storage contract.

## Verification

This self-check exercises `P9.2`, `P9.3`, `P9.4` and `X5.1`.

- Request help for `highway-help` itself and confirm the response has exactly five fields in the
  order above, with a non-blank value on every line, `Name: highway-help`, and an `Example:`
  value wrapped in inline code.
- Request help with no identifier declared and confirm one block per entry currently in
  `assets/index.json`, matching entry count exactly, each with a `Help:` line reading
  `highway-help <id>`.
- See the checked scenarios recorded by feature 009 (skill id namespace alignment) for the
  full set.

## Error Handling

- Declared identifier matches no entry in `assets/index.json`: abort and print exactly
  `ERROR: no skill registered with id '<declared-id>'`; do not fall back to the All-Skills
  listing.
- No skill identifier declared and the index has zero entries: abort the listing and print
  exactly `No skills are registered yet.`; do not print an empty table.
- The skill index `assets/index.json` is missing or unreadable: abort and print exactly
  `ERROR: the skill index 'assets/index.json' is missing or unreadable`.

## Example

`/highway-help highway-help`

```text
Name: highway-help
Description: Prints registration details for one named skill, or a discovery listing of every registered skill when none is named. Use when the person wants to confirm a skill exists or find how to run it.
Version: 3.4.0
Usage: Run highway-help for all skills, or highway-help <skill-id> for one named skill's registration details.
Example: `/highway-help highway-help`
```
