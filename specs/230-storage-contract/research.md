# Research: Storage Contract

## R1. Where the rule lives, and its version effect

- **Decision**: Add `P2.6` to Principle II (Technology-Agnostic Portability) of `.highway/governance/constitution.md`, tier `[auto]`. Rule text: "A skill MUST reach the repository only through the operations `.highway/governance/storage.md` declares." The constitution moves from 9.1.0 to 10.0.0 (MAJOR), with a Sync Impact Report.
- **Rationale**: Storage independence is a portability property: a skill that names a local script or an absolute path stops working when the storage mode is replaced, which is Principle II's stated concern. The versioning policy calls a new obligation that makes a previously conforming artifact fail MAJOR. Today `highway-help` and every test fixture would fail the new rule, so the bump is MAJOR even though they are fixed in the same change.
- **Alternatives considered**: A new Principle XIII. Rejected: it needs a new precedence rank and a new rationale for one rule. MINOR 9.2.0. Rejected: previously conforming artifacts fail.

## R2. What the check detects

- **Decision**: `rc_check_P2_6` scans body lines outside fenced blocks and reports one finding per line for each of four kinds:
  1. **Script**: a `.highway/tools/` path, or a file name ending `.sh`, `.bash`, `.ps1`, or `.py`.
  2. **git**: the word `git` on its own, not preceded by a letter, digit, `_`, `.`, `/`, or `-`, and followed by a space, a backtick, or the line end. `.gitignore`, `GitHub`, and `git-` names do not match.
  3. **Absolute path**: a token that starts at a space, a backtick, a quote, a parenthesis, or the line start, and is `~/` or `/<segment>/`. A Windows drive path `X:\` also matches. A slash command such as `/highway-help` has no second slash and does not match. A URL's slashes follow `:` or `/` and do not match.
  4. **File time**: `modified time`, `modification time`, `created time`, `creation time`, `access time`, the same with `date`, `last modified`, `mtime`, `file timestamp`, or `timestamp of the/a/each file`, ignoring case. P9.8's "Emit no timestamp" does not match.

  The check always applies (N/A condition `-`). It is added to `rc_library_exempt_ids`, so a library file reports N/A with N2.
- **Rationale**: Clarification 2 limits the rule to the agent's own actions. A fenced block in a skill holds a specimen of content: an output template, a diagram, or an example invocation, the same reasoning P8.7 uses. Inline prose is where a skill instructs the agent, so it is scanned. A library file is content a skill reads or copies, not an instruction to an agent.
- **Alternatives considered**: Detecting only imperative verbs ("run", "execute"). Rejected: not decidable without parsing meaning. Scanning fenced blocks. Rejected: every skill's Example and every template specimen would need an exemption.

## R3. Existing artifacts under the new check (D3.4)

A simulation of R2's patterns over every skill and fixture before wiring the check in:

| Artifact | Before | After the check, unchanged | After this change |
|---|---|---|---|
| `highway-help` (Inputs line 35, Error Handling line 83) | PASS | FAIL (script) | PASS: both lines reworded |
| `valid-skill` fixture (Verification) | PASS | FAIL (script) | PASS: Verification reworded |
| 13 `invalid-*` fixtures (Verification) | FAIL for their own defect | FAIL for their own defect and P2.6 | FAIL for their own defect only: Verification reworded |
| Every other shipped skill | PASS | PASS | PASS |
| `rule-checks.test.sh` base skill | PASS | PASS (the validator path is inside its fenced Example) | PASS |

No test pins the fixture Verification wording, an exact N/A list, or a finding count.

## R4. The storage contract document

- **Decision**: `.highway/governance/storage.md`, with no frontmatter and a version line, like the Experience Standard. Sections: Scope, Paths, Modes, Operations (one table, four rows, columns Local, Remote (Option A), Chat (Option B)), and What a skill does not do. It ships through the existing `include .highway/governance` manifest row.
- **Rationale**: It is a runtime contract that agents read through the always-on instructions, like the Experience Standard. A table makes "each operation has three entries" checkable by row.
- **Alternatives considered**: Placing it under `.highway/library/knowledge/`. Rejected: the library holds reference material, and governance holds contracts that bind every skill.

## R5. The Features table

- **Decision**: `codify-metadata.md` 1.0.0 to 2.0.0 gains a `## Features` table with columns ID, Folder, Title, and Summary, and defines each column. highway-codify `write` numbers from the table's last ID, says not to list the features folder, and appends one row. The column definitions live in the template, not the skill.
- **Rationale**: P9.1 keeps a template's structure out of the skill. `write` is 184 words with a 250-word cap in `codify-write-refactor.test.sh`, so the skill gains only three short sentences. `codify.md` is written once, in `write`, and never rewritten, so a copied Title and Summary cannot drift.
- **Alternatives considered**: A status column. Rejected in Clarification 1: progress lives in `codify-tasks.md`.

## R6. highway-help

- **Decision**: Inputs names `.highway/catalog/index.json` without the generator. Error Handling: "Catalog file `.highway/catalog/index.json` is missing or unreadable: abort and print exactly `ERROR: the skill catalog '.highway/catalog/index.json' is missing or unreadable`." Version 3.0.4 to 3.1.0.
- **Rationale**: The item still names one next action, abort (P5.2). Phase 3 leaves `.highway/tools/` out of the plugin, so a pointer to the generator would name a file the person does not have.

## R7. Agent context

- **Decision**: `.highway/instructions/highway-agent-context.md` gains one bullet: "Read and write the repository only through the operations in `.highway/governance/storage.md`." Run `generate-instructions.sh` to refresh `AGENTS.md`, `.claude/CLAUDE.md`, `.github/copilot-instructions.md`, and `.cursor/rules/highway-agent-context.mdc`.

## R8. Versions and moved pins (D3.5)

| Artifact | From | To | Reason |
|---|---|---|---|
| Skills constitution | 9.1.0 | 10.0.0 | R1 |
| `highway-codify` | 13.0.0 | 14.0.0 | MAJOR: Outputs no longer says `metadata.md` is written once |
| `highway-help` | 3.0.4 | 3.1.0 | The error output changes; Inputs, Outputs, and Verification hold |
| `codify-metadata.md` | 1.0.0 | 2.0.0 | MAJOR: a required Features table is added, and "written once" is redefined |

Moved pins, each superseding the old version only:

- `version: 13.0.0` for highway-codify in `code-project`, `codify-platform-catalog`, `codify-config-skill`, `delivery-platform-handoff`, `codify-feature-wording`, `codify-deterministic-steps`, `codify-products`, `codify-write-refactor`, `codify-file-layout`, `establish-from-record`, `propose-edit-lines` (2), `single-noun-capabilities`, and `codify-closing-guide`.
- Constitution footer pins in `constitution-inventory.test.sh` and `constitution-experience-alignment.test.sh`: 9.1.0 and 2026-10-22 become 10.0.0 and 2026-11-09.
- `codify-products.test.sh`: `codify-metadata` `version: 1.0.0` becomes `version: 2.0.0`.
- `constitution-experience-alignment.test.sh`: the rule-row count 73 becomes 74 for P2.6.
- `rule-checks.test.sh`: the P8.7 false-positive case named `.highway/tools/validate-skill.sh`, which P2.6 now reports. It names `.highway/governance/constitution.md` instead, and still proves an inline path is not a link.

## R9. Live documentation (D6.1)

- `_authoring-standard.md` gains a section "Reaching the repository", governed by P2.6, in the same form as the P8.7 and P6.4 sections.
- `.highway/DISTRIBUTION.md` tree line for `governance/` names the storage contract.
