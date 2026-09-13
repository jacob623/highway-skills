# Contract: Lexicon Library Interface

**Feature**: [../spec.md](../spec.md) | **Date**: 2026-09-12

The public surface of `.highway/tools/lib/frontmatter-lexicon.sh`. This contract records what callers
may rely on. Every function listed here exists today; this feature changes the implementation of
three of them and adds none to the public surface.

## Stability guarantee

The observable behaviour of every function below is **unchanged** by this feature. Findings must be
byte-identical in text, order, and exit status. Any difference is a defect, not an improvement.

## `fl_file <highway_root>`

**Status**: Unchanged.

Prints the resolved lexicon path, preferring `FRONTMATTER_LEXICON_FILE` when set.

- Returns 0 always.
- Callers inside the hot path MUST stop invoking this per word. It remains available for the shape
  check and for tests.

## `fl_validate_lexicon <highway_root>`

**Status**: Unchanged.

Validates that the lexicon is present, sorted, free of duplicates, and contains only
`^[a-z0-9-]+$` lines.

- Returns 0 when well-formed; 1 otherwise.
- Prints one `ERROR: [SCHEMA] …` line per problem.
- This check MUST continue to run and MUST NOT be bypassed by the in-memory blob (FR-011). A
  malformed lexicon must still be reported rather than silently changing what gets checked.

## `fl_word_in_lexicon <highway_root> <word>`

**Status**: Implementation changed; contract identical.

Returns 0 if the word is present in the lexicon, 1 otherwise. The word must already be lowercase.

- MUST NOT spawn a subprocess (FR-007).
- MUST match whole words only. `check` MUST NOT match `checks`.
- MUST treat the word operand literally. A word containing a glob metacharacter MUST NOT match
  anything it does not literally equal.
- A missing lexicon file MUST continue to yield 1 rather than an error.

## `fl_resolve_rule_id <highway_root> <token>`

**Status**: Implementation changed; contract identical.

Returns 0 if the token is a rule id present in the shipped Highway Skills Constitution or the
Experience Standard.

- MUST NOT re-read the governing documents per token (FR-008).
- MUST accept only tokens matching `^[A-Z][0-9]+\.[0-9]+$`.
- MUST resolve `P6.4` and `X1.4`.
- MUST NOT resolve `D1.1`. The development constitution is never consulted; this is a D1.1
  obligation, not a convenience.

## `fl_resolve_skill_id <highway_root> <token>`

**Status**: Unchanged.

Returns 0 if the token is kebab-case and names an existing directory under `skills/`.

## `fl_check_field <highway_root> <field_label> <value>`

**Status**: Implementation changed; contract identical.

Checks one free-form field value, printing one `ERROR: [SCHEMA] …` line per unrecognised word.

- Returns 0 silently when every word is accepted; 1 when any word is not.
- An empty value MUST return 0 without output.
- Each unrecognised word MUST be reported **individually**, naming its originating field. A count
  MUST NOT be substituted (FR-010).
- Report order MUST follow field order, then word order within the field.
- A token that reduces to nothing after punctuation stripping MUST produce no finding.
- Tokens MUST be tested as rule id, then skill id, then lexicon words — in that order. The order is
  observable because it determines which findings appear for ambiguous tokens.
- MUST NOT spawn a process per word or per token (FR-007, FR-009).

## Environment overrides

| Variable | Effect | Used by |
|---|---|---|
| `FRONTMATTER_LEXICON_FILE` | Substitutes an alternative lexicon path | Tests |
| `FRONTMATTER_CONTRACT_FILE` | Substitutes an alternative contract manifest path | Tests, including the new required-key proof |

Both MUST continue to work. The required-key proof depends on the second, and it is what keeps the
tracked manifest unwritten.

## Prohibited constructs

Enforced by D2.1 and verified against `bash` 3.2.57:

- Associative arrays — unavailable.
- `mapfile` / `readarray` — unavailable.
- `${var^^}` / `${var,,}` — `bad substitution` on 3.2.57.
- `&>>` — unavailable.
- Unquoted expansion on the right-hand side of `[[ == ]]` — a verified glob-injection hazard.
