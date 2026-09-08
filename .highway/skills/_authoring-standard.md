# Skill Authoring Standard

Practical guide for writing a skill at `.highway/skills/<id>/SKILL.md`.

This document does not restate the rules. The constitution at
[.highway/governance/constitution.md](../governance/constitution.md) is the only place rule
text lives; everything below cites rule ids so the two cannot drift apart (P7.3). Run
`.highway/tools/validate-skill.sh <skill-dir>` to see which rules are checked automatically and
which are left to you.

This repository shipped **framework only** at first (FR-011 of feature 001), with
`.highway/skills/highway-help/` as the first authored skill (feature 006; renamed from
`.highway/skills/help/` by feature 009). Additional skill topics are added by separate,
follow-on work.

## Directory layout

```text
.highway/skills/<id>/SKILL.md
```

The `<id>` is the directory name, kebab-case, unique across `.highway/skills/`, and is already
the full agent-facing identifier (e.g. `highway-help`) -- no namespace prefix is injected later.
A skill's id is derived solely from its directory name; the `name` field MUST equal that id
exactly, byte-for-byte (see the `name` row below).

## Required frontmatter

```yaml
---
name: skill-id
description: "One-line purpose AND when to use (<= 500 characters)."
usage: "One-line guidance on how to invoke/use the skill (<= 500 characters)."
compatibility: all # or one of: github-copilot | claude-code | cursor
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
| `compatibility` | No | — | One of `all`, `github-copilot`, `claude-code`, `cursor`. Defaults to `all`. |
| `metadata.version` | Yes | P7.2 | Semantic version. See the Skill Versioning Policy in the constitution's Governance section. |
| `metadata.agent_exceptions` | No | P2.2 | List of `{agent, deviation}`, each naming one supported agent. |

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
| `## Error Handling` | P5.1, P5.2, P5.3 | One list item per failure condition, each naming one next action. |
| `## Example` | — | Exactly one copy-able example: the literal invocation MUST be an inline code span (backtick-wrapped, not solely a fenced block), so it can be selected and copied on its own; a fenced block MAY still show accompanying sample output below it. |

## Linking out of a skill

Governed by P8.7. Your `SKILL.md` is copied verbatim into every agent's own directory, and nothing
else travels with it, so a Markdown link to a relative path resolves only where you wrote it and
is dead everywhere the skill is actually read.

Name a path in prose or in a command example as much as you like — those are instructions, not
links, and the check ignores them. An absolute URL is fine too. What P8.7 rejects is a Markdown
link target that is a relative path. To point at another document in this framework, name it
instead of linking it.

`.highway/tools/validate-skill.sh` decides this for you and reports it under P8.7.

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

`.highway/tools/validate-skill.sh` decides this for you and reports it under P6.4.

## Writing the rules inside a skill

Cited rules, not restated. Read the rule text in the constitution.

- One obligation per line, one keyword per line, 25 words or fewer: **P1.1, P1.2, P1.3**
- No vague qualifier without a countable condition: **P1.4** and the Prohibited Vagueness List
- No unstated tool, file, or step dependency: **P1.5**
- Cite an Approved Authority Source for each MUST-level rule, using the Citation Format:
  **P3.1, P3.2, P3.5**
- Pair every quality claim with a check; never use "secure", "performant", or "maintainable" as
  an acceptance criterion: **P4.1, P4.2**
- Give every failure condition exactly one next action from retry, abort, escalate, fall back;
  state a maximum attempt count for a retry: **P5.2, P5.3**
- Make every choice deterministic, with an explicit default branch: **P6.1, P6.2, P6.4**
- Stay within 12 MUST-level rules and 400 words per normative section; split the skill rather
  than exceeding either: **P7.4, P7.5, P7.6**
- Number workflow steps and state their ordering dependencies: **P8.1, P8.2**

## Before merge

1. Run `.highway/tools/validate-skill.sh .highway/skills/<id>` and resolve every `ERROR:` line.
2. Read the `DEFERRED` and `UNCHECKED` groups in the output. Those rules were not verified for
   you; check them yourself against the constitution.
3. Review the skill against the constitution's Compliance Review Protocol. Any rule you cannot
   satisfy needs a written exception in the skill file naming the rule id, per the constitution's
   Governance section.
4. Run the overlap review below.

## Manual overlap review

Required by FR-005 of feature 001, and governed by **P7.3**.

1. Run `.highway/tools/generate-catalog.sh` to produce the current catalog.
2. Compare the new skill's `description` against every existing entry's `description`.
3. Count the new skill's MUST-level rules that restate a MUST-level rule in an existing skill,
   and divide by the new skill's MUST-level rule count. Above 0.50, consolidate the two skills;
   otherwise replace the restated rules with a cross-reference naming the other skill's id. The
   threshold and the ordered decision live in the constitution's Skill Authoring Workflow.
4. Record any residual overlap in `.highway/catalog/index.json`'s `overlap_flags` array:
   `{"skill_a": "<id>", "skill_b": "<id>", "reason": "<why they overlap>"}`.
   `.highway/tools/generate-catalog.sh` preserves these across regenerations.

Automated overlap detection across the catalog is performed by a separate, external application
outside this codebase.
