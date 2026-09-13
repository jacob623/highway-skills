# Data Model: Contract Proof and Lexicon Speed

**Feature**: [spec.md](spec.md) | **Date**: 2026-09-12

This feature introduces no persistent entity and no new file format. What it does introduce is
in-memory state inside a single process, which has a lifecycle worth stating explicitly because the
correctness of the performance work depends on it.

## Entity: Lexicon Blob

**Representation**: A single shell string variable, `FL_LEX_BLOB`.

**Shape**: The lexicon's contents with a leading newline prepended and a trailing newline present, so
that every word in the list is bracketed by newlines on both sides. Measured size: 1277 bytes for
172 words.

**Fields**: None. It is an opaque delimited string, not a structured record.

**Lifecycle**:

| State | Trigger | Note |
|---|---|---|
| Unset | Process start | Empty string. |
| Loaded | First call to the field checker | Read via `$(<file)`; zero forks. |
| Reused | Every subsequent word test | No I/O, no fork. |

**Validation rules**:

- Membership is tested as `[[ "$FL_LEX_BLOB" == *$'\n'"$word"$'\n'* ]]`. The word operand MUST be
  quoted; unquoted it is glob-interpreted (see research Decision 2).
- The load MUST be idempotent — a second call must not re-read the file or append a second copy.
- If the lexicon file is absent or malformed, the existing shape check reports it. The blob is not a
  substitute for that check and MUST NOT suppress it.

**Relationship to existing state**: Replaces the per-call `grep` inside `fl_word_in_lexicon`. The
file at `library/knowledge/frontmatter-lexicon.txt` remains the single source of truth and is read
only.

## Entity: Rule ID Blob

**Representation**: A single shell string variable, `FL_RULE_BLOB`, with a companion flag
`FL_RULE_LOADED`.

**Shape**: Newline-delimited rule identifiers extracted from the first column of the rule tables in
the two governing documents. Measured: 60 identifiers, 301 bytes.

**Lifecycle**:

| State | Trigger | Note |
|---|---|---|
| Unset | Process start | Flag is 0. |
| Loaded | First token matching `[A-Z][0-9]*.[0-9]*` | Lazy. Across all 8 skills this never fires. |
| Reused | Subsequent rule-shaped tokens | No I/O. |

The separate flag exists because an empty blob is a legitimate loaded state — if the governing
documents contained no rule rows, an emptiness test would re-read them on every token and reintroduce
the cost this entity removes.

**Validation rules**:

- The blob MUST be derived only from the shipped governing documents. The development constitution
  MUST NOT contribute, so `D1.1` must remain unresolvable — this is asserted by an existing test and
  was reconfirmed against the prototype.
- Membership testing follows the same quoted-pattern rule as the Lexicon Blob.

## Entity: Contract Manifest Copy (test-only)

**Representation**: A temporary file created by the required-key proof, referenced through the
`FRONTMATTER_CONTRACT_FILE` override.

**Shape**: A byte copy of the tracked manifest, plus one appended TAB-delimited row declaring a
required key that no skill or fixture provides.

**Lifecycle**:

| State | Trigger | Note |
|---|---|---|
| Created | Test start | Via `mktemp`, outside the repository tree. |
| Read | Validator invocation under override | The validator sees only the copy. |
| Removed | Test end, including failure paths | Cleanup must run on the failure path too (FR-005). |

**Validation rules**:

- The tracked manifest MUST NOT be written at any point. It is a copy source only.
- The appended row MUST name a key absent from every skill and fixture, so the expected finding is
  attributable to the manifest and not to unrelated frontmatter.
- Both scopes — top-level and `metadata` — MUST be exercised (FR-003).

## Non-entities

Recorded to prevent misreading the scope:

- **The contract manifest itself** is unchanged. No row is added, removed, or reordered in the
  tracked file.
- **The lexicon word list** is unchanged. FR-014 forbids adding a word to make a check pass; the 9
  fixture-derived words added during Feature 045 are explicitly out of scope for this feature.
- **Finding records** are unchanged in text, order, and exit status. There is no new finding type,
  no new tag, and no change to the `[SCHEMA]` stratum.
