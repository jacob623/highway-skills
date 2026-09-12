# Frontmatter Contract Shape

**Feature**: 045-frontmatter-contract-hardening | **Date**: 2026-09-11

This file discharges `P7.3` for `.highway/skills/_authoring-standard.md`: the standard cites this
document by reference instead of restating the manifest's grammar or content inline. It names the
exact grammar of `.highway/tools/.frontmatter-contract` and the exact initial content the manifest
ships with, so the manifest's shape is reviewable independent of the implementation.

## Grammar

- Comment lines begin with `#` and are ignored by the loader (`lib/frontmatter-contract.sh`).
- Every other non-blank line has exactly 4 TAB-separated fields, in order: `scope`, `key`,
  `required`, `constraint`.
- `scope` is `top` or `metadata`.
- `key` is the exact frontmatter key name (no `metadata.` prefix — that is what `scope` encodes).
- `required` is `yes` or `no`.
- `constraint` is `-`, `kebab-case`, `semver`, `length:MIN-MAX`, or `enum:v1,v2,...` (see
  [data-model.md](../data-model.md)'s Constraint Token entity).
- No two data lines may share the same `(scope, key)` pair. A parser that finds a repeat MUST treat
  it as a malformed contract and fail loudly rather than silently prefer one occurrence.

## Initial content

```text
# Frontmatter contract. Read by lib/frontmatter-contract.sh and validate-skill.sh so the permitted
# key set, required/optional status, and value constraint for a SKILL.md's frontmatter is declared
# exactly once. Four tab-separated fields: scope, key, required, constraint.
#
# scope       top | metadata
# key         the exact key name (no "metadata." prefix; scope already encodes that)
# required    yes | no
# constraint  - | kebab-case | semver | length:MIN-MAX | enum:v1,v2,...
#
# A key read by the validator with no entry here, or a frontmatter key present in a SKILL.md with
# no entry here, is reported as undeclared. See _authoring-standard.md for the human-facing table
# this manifest is the authority behind.

top	name	yes	kebab-case
top	description	yes	length:10-500
top	usage	yes	length:10-500
top	compatibility	no	enum:all,github-copilot,claude-code,cursor
metadata	version	yes	semver
metadata	agent_exceptions	no	-
metadata	dependencies	no	-
```

## Seeded-defect verification matrix

The proof that this manifest is load-bearing, not decorative (spec US1 acceptance scenario): each
row below is one fixture under `.highway/tools/tests/fixtures/`, and the expected verdict before
and after this feature's implementation.

| Fixture | Seeded defect | Verdict before this feature | Verdict after |
|---|---|---|---|
| `invalid-skill-duplicate-key` | `description` key appears twice in frontmatter | PASS (incorrect — `fm_get` resolves first match silently) | FAIL, names `description` |
| `invalid-skill-undeclared-key` | A key not in the manifest present in frontmatter (e.g. `metadata.owner`) | PASS (incorrect — no closed-key-set check exists) | FAIL, names `owner` |
| `invalid-skill-short-description` | `description` is 9 characters | PASS (incorrect — no lower bound exists today) | FAIL, states the 10-character bound |
| `invalid-skill-unrecognized-word` | `description` contains a word absent from the lexicon and not resolvable as a skill id or rule id | PASS (incorrect — no lexicon check exists) | FAIL, names the word |
| `valid-skill` (existing) | None | PASS | PASS, unchanged |

## Required-key acceptance proof (FR-016, SC-004; plan.md step 9)

Not a permanent fixture. During implementation only: add one line to the manifest declaring a new
required key no existing skill sets, run the suite, confirm at least one previously-conforming
skill now fails naming that key, then delete the line again. This is the evidence that the
validator's behavior is *derived* from the manifest rather than hardcoded to today's key set — the
manifest's final, shipped content is the seven rows above, unchanged by this proof.
