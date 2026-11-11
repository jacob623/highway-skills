# Skill Authoring Standard

Practical guide for writing a skill at `skills/<id>/SKILL.md`.

This document does not restate the rules. The constitution at
[framework/constitution.md](constitution.md) is the only place rule
text lives; everything below cites rule ids so the two cannot drift apart (P7.3). Run
`framework/validate-skill.sh <skill-dir>` to see which rules are checked automatically and
which are left to you.

This repository shipped **framework only** at first (FR-011 of feature 001), with
`skills/highway-help/` as the first authored skill (feature 006; renamed from
`help` by feature 009). Additional skill topics are added by separate,
follow-on work.

Owner action results and readiness results are distinct contracts. A collection action may report
`Continue` or `Finished`; readiness reports only persisted-baseline state. Owner output places the
next action first for human interaction, while machine-consumable result fields remain in their
declared order. Continuation is explicit, transient interaction state is not restored, and an owner
must verify retained outputs before claiming completion.

## Directory layout

```text
skills/<id>/SKILL.md
```

The `<id>` is the directory name, kebab-case, unique across `skills/`, and is already
the full agent-facing identifier (e.g. `highway-help`) -- no namespace prefix is injected later.
A skill's id is derived solely from its directory name; the `name` field MUST equal that id
exactly, byte-for-byte (see the `name` row below).

## Required frontmatter

```yaml
---
name: skill-id
description: "One-line purpose AND when to use (<= 500 characters)."
usage: "One-line guidance on how to invoke/use the skill (<= 500 characters)."
compatibility: all # or one of: github-copilot | claude-code | cursor | codex
metadata:
  version: 1.0.0
  # agent_exceptions: # optional, only for a declared, isolated agent-specific deviation
  #   - agent: cursor
  #     deviation: "Exact, isolated deviation for this agent only."
---
```

| Field | Required | Governing rule | Notes |
|---|---|---|---|
| `name` | Yes | SCHEMA | MUST equal the directory-derived id exactly, byte-for-byte (case, whitespace, and punctuation all count). Enforced by `sv_validate_name`. |
| `description` | Yes | — | Non-empty, <= 500 characters. Sole carrier of applicability in the generated catalog. Keep "when not to use" detail in the body. |
| `usage` | Yes | — | Non-empty, <= 500 characters. One-line guidance on how to invoke/use the skill; carried into the generated catalog for discovery (the help skill's all-skills listing). |
| `compatibility` | No | — | One of `all`, `github-copilot`, `claude-code`, `cursor`, `codex`. Defaults to `all`. |
| `metadata.version` | Yes | P7.2 | Semantic version. See the Skill Versioning Policy in the constitution's Governance section. |
| `metadata.agent_exceptions` | No | P2.2 | List of `{agent, deviation}`, each naming one supported agent. |
| `metadata.dependencies` | No | DEPENDENCY | List of `{path, version}` pins into the shared content library; each path must exist and its target's `metadata.version` must match the pinned `version`, enforced by `dc_validate_dependencies`. |

The permitted key set, required/optional status, and value constraints above are declared once in
`framework/.frontmatter-contract` (see `contracts/frontmatter-contract-shape.md`); this table
restates that manifest for authoring convenience and MUST NOT drift from it (`P7.3`).

## Required body sections

Eight sections, each non-empty:

| Section | Governing rule | What it holds |
|---|---|---|
| `## Purpose` | P7.1 | Exactly one sentence stating what the skill is for. |
| `## When to use` | P5.6 | Two or more triggering scenarios. |
| `## When not to use` | — | Where the skill does not apply. |
| `## Inputs` | P1.5, P2.2 | Every value, file, tool, and precondition the skill depends on. |
| `## Outputs` | — | What exists after the skill is followed. |
| `## Verification` | P8.3, P8.4, P4.2 | At least one command, file state, or output string to check. |
| `## Error Handling` | P5.13 | Unexpected failures include actionable user-facing context. |
| `## Example` | — | Exactly one copy-able example: the literal invocation MUST be an inline code span (backtick-wrapped, not solely a fenced block), so it can be selected and copied on its own; a fenced block MAY still show accompanying sample output below it. |

## Linking out of a skill

Governed by P8.7. Your `SKILL.md` is copied verbatim into every agent's own directory, and nothing
else travels with it, so a Markdown link to a relative path resolves only where you wrote it and
is dead everywhere the skill is actually read.

Name a path in prose or in a command example as much as you like — those are instructions, not
links, and the check ignores them. An absolute URL is fine too. What P8.7 rejects is a Markdown
link target that is a relative path. To point at another document in this framework, name it
instead of linking it.

`framework/validate-skill.sh` decides this for you and reports it under P8.7.

## Stating when your skill applies

Governed by P6.4. Your `When to use` and `When not to use` sections are where an agent decides
whether to run your skill at all, so a criterion there that depends on when it is read, on chance,
or on taste makes the same input produce different decisions on different days.

The vocabulary this rejects is not left to interpretation. It is declared in the constitution as
the Prohibited Nondeterministic Criterion Tokens list, in three groups — time, randomness, and
agent preference — and the check reads that list rather than carrying its own copy. If you think a
term belongs there, or does not, amend the list; that is a governance change, not a code change.

The rule is scoped to those two sections. Describing your skill's output as reporting the latest
entry is prose, not a decision criterion, and is not flagged. Saying to use your skill when
something is *currently* stale is a criterion, and is.

`framework/validate-skill.sh` decides this for you and reports it under P6.4.

## Reaching the repository

Governed by P2.6. Your skill reads and writes the repository through four operations: read a file,
check a file exists, list a folder, and write a group of files together. They are defined once, in
the highway-experience skill's `references/storage-contract.md`, which says what each one does in
each storage mode. A skill written against them keeps working when the repository is reached
another way.

Open your skill's Procedure with the activation step every Highway skill shares, exactly as it
appears in the other skills. It loads highway-experience, which brings the storage contract, the
Experience Standard, and Highway's identity. Do not name their files yourself.

So the agent following your skill runs no script and no `git` command, names no path that starts
at the filesystem root or the home folder, and decides nothing from a file's modified or created
time. List a folder only when no index or record already holds the answer.

The rule limits what the agent does, not what it writes. A pipeline, product code, or a README
your skill writes may run scripts and `git` steps, and a fenced block showing such content is not
examined. A slash command such as `/highway-help` and a URL are not absolute paths.

`framework/validate-skill.sh` decides this for you and reports it under P2.6.

## Editing a seeded file

Governed by P9.1. highway-setup seeds the organization catalogs, the findings file, and the
storage record from its own `assets/`, and `hw_seeded` in `framework/lib/paths.sh` lists them. A
skill that writes one of them does not cite a template for it:

- Place the entry check every such skill shares right after the activation step, exactly as it
  appears in the other skills, naming the seeded files your skill edits. When one is absent, the
  skill shows the fixed setup message, asks nothing, and writes nothing.
- Edit the file in its existing structure, and state its rules (row order, status values, id
  formats, cell formats) in your skill's own text.
- In Outputs, say the file keeps the structure highway-setup seeded.
- A rule two skills share has one source in `framework/shared-rules/`. Copy its `rule:` line into
  your skill as one whole line; `tests/shared-rules.test.sh` fails when a copy differs.

A file only your skill creates still cites its template, either a shared output template or a
file in your skill's own `assets/`.

## Writing the rules inside a skill

Cited rules, not restated. Read the rule text in the constitution.

- One obligation per line, one keyword per line, 25 words or fewer: **P1.1, P1.2, P1.3**
- No vague qualifier without a countable condition: **P1.4** and the Prohibited Vagueness List
- No unstated tool, file, or step dependency: **P1.5**
- Cite an external source only for an asserted external requirement, using the Citation Format:
  **P3.2, P3.3, P3.5**
- Do not use "secure", "performant", or "maintainable" as an acceptance criterion: **P4.2**
- Record unexpected failure handling with actionable user-facing context: **P5.13**
- Make every choice deterministic, with an explicit default branch: **P6.1, P6.2, P6.4**
- Stay within 12 MUST-level rules and 400 words per normative section; reduce the skill until
  both limits hold: **P7.4, P7.5, P7.6**
- Declare ordering only where it changes behavior, ownership, safety, mutation, or output: **P8.2**

## Before merge

1. Run `framework/validate-skill.sh skills/<id>` and resolve every `ERROR:` line.
2. Read the `DEFERRED` and `UNCHECKED` groups in the output. Those rules were not verified for
   you; check them yourself against the constitution.
3. A SHOULD you cannot satisfy needs a written exception naming the condition that displaces it.
   An Experience Standard rule you cannot satisfy names the X rule and that condition (P10.2).
4. Run the overlap review below.

## Manual overlap review

Required by FR-005 of feature 001, and governed by **P7.3**.

1. Run `framework/generate-catalog.sh` to produce the current catalog.
2. Compare the new skill's `description` against every existing entry's `description`.
3. Count the new skill's MUST-level rules that restate a MUST-level rule in an existing skill,
   and divide by the new skill's MUST-level rule count. Above 0.50, consolidate the two skills;
   otherwise replace the restated rules with a cross-reference naming the other skill's id. The
   threshold and the ordered decision live in the constitution's Skill Authoring Workflow.

Automated overlap detection across the catalog is performed by a separate, external application
outside this codebase.
