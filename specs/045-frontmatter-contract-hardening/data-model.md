# Data Model: Frontmatter Contract Hardening

**Feature**: 045-frontmatter-contract-hardening | **Date**: 2026-09-11

This feature introduces one small, file-based data model — the declared frontmatter contract and
the lexicon — plus two derived concepts (constraint token, identifier token) that give the
validator vocabulary for what it reads from those files. There is no database and no in-memory
object model beyond what a bash script holds transiently while validating one `SKILL.md` at a time.

## Entities

### Frontmatter Contract Entry

One row of `.highway/tools/.frontmatter-contract`. Declares one permitted key.

| Attribute | Constraint |
|---|---|
| `scope` | `top` or `metadata` — whether the key is read at the frontmatter root or nested under `metadata:` |
| `key` | The exact key name, e.g. `description`, `version`, `dependencies`. Unique per `scope` — the manifest itself must contain no duplicate `(scope, key)` pair |
| `required` | `yes` or `no` |
| `constraint` | A Constraint Token (see below), or `-` if the key has no value-shape constraint beyond non-emptiness |

**Invariant:** every key `sv_validate_*` or `fm_get*` currently reads by a literal name (`name`,
`description`, `usage`, `compatibility`, `metadata.version`, `metadata.agent_exceptions`,
`metadata.dependencies`) has exactly one corresponding entry. A key read by the validator with no
manifest entry is the malformed-contract edge case the spec names — the validator MUST fail loudly
rather than silently permit or silently reject.

**Population at completion:** 7 entries — `top:name` (required, `kebab-case`), `top:description`
(required, `length:10-500`), `top:usage` (required, `length:10-500`), `top:compatibility`
(optional, `enum:all,github-copilot,claude-code,cursor`), `metadata:version` (required, `semver`),
`metadata:agent_exceptions` (optional, `-`), `metadata:dependencies` (optional, `-`).

### Constraint Token

A closed vocabulary of value-shape constraints a Frontmatter Contract Entry can carry. Not a free
string — parsed once into a token kind and its parameters.

| Token form | Meaning | Example |
|---|---|---|
| `-` | No shape constraint beyond required/optional and non-emptiness | `metadata.agent_exceptions` |
| `kebab-case` | Must match the existing `SV_ID_REGEX` pattern | `name` |
| `length:MIN-MAX` | Character count must fall in `[MIN, MAX]` inclusive | `length:10-500` |
| `enum:v1,v2,...` | Value must equal one comma-separated literal | `enum:all,github-copilot,claude-code,cursor` |
| `semver` | Must match the existing `SV_VERSION_REGEX` pattern | `metadata.version` |

**Invariant:** this set is closed. Adding a new constraint *kind* is a script change (a new case in
`frontmatter-contract.sh`'s dispatch), not a data-only change — the manifest can only ever
parameterize an existing kind (e.g. widen a `length:` range), never invent one implicitly.

### Lexicon Word

One line of `.highway/library/knowledge/frontmatter-lexicon.txt`.

| Attribute | Constraint |
|---|---|
| `word` | Lowercase, no whitespace, no punctuation |

**Invariants (FR-012):** the file is sorted (`sort -c` passes), contains no duplicate line
(`sort | uniq -d` produces no output), and contains exactly one word per line (no blank lines, no
multi-word lines).

**Population at completion:** seeded from the 126 unique words measured across the 8 existing
skills' `description`, `usage`, and body free-form text on 2026-09-11 (spec Key Entities), plus any
additional word introduced by this feature's own new content (e.g. words used in
`_authoring-standard.md`'s new row or this feature's own fixture files, to the extent those are
lexicon-checked). Re-measured at implementation time per `research.md` Risk 2.

### Identifier Token

A word in a free-form field that is exempt from lexicon membership because it resolves against a
governing document instead.

| Attribute | Constraint |
|---|---|
| `kind` | `skill-id` or `rule-id` |
| `value` | The literal token text |
| `resolved-against` | For `skill-id`: `.highway/skills/` (a directory of that name must exist). For `rule-id`: prefix-routed — `D*` against `.specify/memory/constitution.md`, `P*` against `.highway/governance/constitution.md`, `X*` against `.highway/governance/experience-standard.md` |

**Invariant:** a token that fails to resolve as either a skill id or a rule id falls back to
ordinary lexicon-membership checking — identifier resolution is an additional acceptance path, not
a replacement for the lexicon.

## Relationships

```text
Frontmatter Contract Entry ──constrains with──> Constraint Token
SKILL.md free-form field ──tokenized into──> word
word ──checked against──> Lexicon Word, unless it first resolves as──> Identifier Token
```

## State transitions

None of these entities have a lifecycle beyond "declared" — this feature does not model a
workflow with in-progress states. The one transition worth naming is the manifest's temporary,
proof-only mutation in plan.md step 9 (FR-016): a required key is added, one previously-conforming
skill is confirmed to fail, and the key is removed again before the feature is considered complete.
That entry never appears in the manifest's final, shipped content.
