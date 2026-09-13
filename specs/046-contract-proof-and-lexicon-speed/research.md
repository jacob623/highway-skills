# Phase 0 Research: Contract Proof and Lexicon Speed

**Feature**: [spec.md](spec.md) | **Date**: 2026-09-12

Every decision below was verified by running code against the real `/bin/bash` on the target machine
(`3.2.57(1)-release`) before being recorded. Where a measurement is quoted, it came from a run, not
from arithmetic on an earlier figure. Two of the findings contradicted the intuition that motivated
the investigation, and both are recorded as such.

## Decision 1 — Lexicon membership by delimited blob match, not `grep` per word

**Decision**: Load the lexicon once per process into a single string bracketed and separated by
newlines, then test membership with `[[ "$FL_LEX_BLOB" == *$'\n'"$word"$'\n'* ]]`.

**Rationale**: The current `fl_word_in_lexicon` forks `fl_file` (a command substitution) plus a
`grep` for every word, and is called once per normalised word. The blob is 1277 bytes — small enough
that a substring match is effectively free, and the newline delimiters preserve whole-word semantics
exactly as `grep -Fxq` did. Verified: `checks` matches, `nfrz` does not, and `check` does **not**
match `checks`, confirming the delimiters prevent partial-word false positives.

**Alternatives considered**: An associative array keyed by word would be the obvious choice and is
what most languages would use — but D2.1 forbids it, and bash 3.2 has no associative arrays at all.
A `case` statement built from the lexicon would require code generation. Neither earns its
complexity over a 1277-byte string.

## Decision 2 — The pattern operand must be quoted (verified hazard, not theoretical)

**Decision**: The word being tested MUST appear as `"$word"` inside the pattern. Never unquoted.

**Rationale**: In `[[ a == b ]]` the right-hand side is a *pattern*, not a string. An unquoted
expansion is therefore glob-interpreted. This was tested rather than assumed: with `word='*'`, the
unquoted form **matched**, and the quoted form correctly did not. An unquoted operand would make any
field value containing `*` silently pass the lexicon check.

The practical exposure is limited, because normalisation reduces tokens to `[a-z0-9-]` before the
lookup — but that is a second line of defence, and relying on it would make the safety of this check
depend on a property of a different function. Quoting is the fix; the normalisation is a bonus.

**Alternatives considered**: Sanitising the word before the comparison — rejected, because it treats
the symptom and leaves the trap in place for the next person who adds a lookup.

## Decision 3 — Lowercasing by index arithmetic, guarded by a fast path

**Decision**: Replace `tr '[:upper:]' '[:lower:]'` with a builtin loop that maps each uppercase
character through a pair of constant alphabet strings, and skip the loop entirely when the token
contains no uppercase character (`[[ $s != *[A-Z]* ]]`). Return via a global, not command
substitution.

**Rationale**: `${v,,}` is bash 4.0+. Probed on 3.2.57 it fails outright with `bad substitution`, and
D2.1 independently bans the `${var^^}` family. The character loop is O(length) but runs entirely in
the shell. The fast path matters because the overwhelming majority of prose tokens are already
lowercase, so the loop is rarely entered.

The return-by-global detail is not cosmetic: writing `lower="$(fl_lc "$x")"` would fork a subshell
per word and reintroduce the exact cost this feature exists to remove.

**Alternatives considered**: Keeping `tr` — rejected, one fork per word. Doing the whole field in one
`tr` before tokenising — viable and cheaper than per-word, but still a fork per field, and it would
change where normalisation happens relative to rule-id detection, which is case-sensitive.

## Decision 4 — Rule ids loaded once, and lazily

**Decision**: Extract all rule ids from the two governing documents into one delimited blob via
`cat … | sed -n`, but only on first encountering a token shaped like a rule id.

**Rationale**: `fl_resolve_rule_id` currently forks two command substitutions plus up to two `grep`
runs *per token*, including for the vast majority of tokens that are ordinary words. Hoisting the
read to once per process is the obvious win. Making it lazy is the larger one: across all 8 skills,
**no** description or usage field contains a rule id, so the load never happens in the common case.

Measured contribution: eager loading cost 0.0055s per invocation; lazy loading removed it entirely
for all 8 skills. This is the difference between 0.0247s (marginally inside the 0.025s target) and
0.0126–0.0145s (comfortably inside it).

**Alternatives considered**: Eager loading — simpler, but as measured it consumed roughly a third of
the entire performance budget to answer a question that never gets asked.

## Decision 5 — `cat | sed` beats a pure-bash reader (contradicted the hypothesis)

**Decision**: Use `cat "$CON" "$EXP" | sed -n '…p'` for the one-time rule-id extraction. Do **not**
replace it with a fork-free bash `read` loop.

**Rationale**: The working assumption behind this feature is "forks are the cost". That assumption is
correct per-word and **wrong** for the one-time load. Measured over 5 iterations:

| Approach | Forks | Cost |
|---|---|---|
| `$(<file)` for the lexicon | 0 | 0.0037s |
| `cat … \| sed -n` for rule ids | 2 | **0.0055s** |
| Pure-bash `while read` loop for rule ids | 0 | 0.0119s |

The fork-free loop is **more than twice as slow**, because bash's line-by-line interpretation over a
few hundred lines costs more than two process spawns. Recorded explicitly so that a future reader
does not "optimise" this back into the slow version on principle.

**Alternatives considered**: The pure-bash loop, rejected on measurement. Note the rule is *not*
"forks don't matter" — the per-word forks are 94% of the cost. The rule is that a fork amortised once
per process is cheap, and a shell loop over many lines is not.

## Decision 6 — Punctuation stripping by expansion loop, without `extglob`

**Decision**: Strip leading and trailing non-alphanumerics with `while [[ $c == [^A-Za-z0-9]* ]]; do
c=${c#?}; done` and the trailing mirror. Split with `${lower//[^a-z0-9-]/ }` then `${words//-/ }`.

**Rationale**: Bracket-expression substitution was verified working on 3.2.57. The obvious
alternative, `${raw##+([^A-Za-z0-9])}`, needs `shopt -s extglob`, and a sourced library that flips a
global shell option changes parsing behaviour for every caller that sources it. The loop is bounded
by the punctuation actually present — one or two characters in practice.

**Alternatives considered**: Enabling `extglob` and restoring it — possible, but the save/restore
dance is more code than the loop and fails badly if an error path skips the restore.

## Decision 7 — The required-key proof uses a copied manifest and a fixture, not a real skill

**Decision**: Copy the tracked manifest to a `mktemp` location, append a required row naming a key no
skill declares, point the validator at the copy via `FRONTMATTER_CONTRACT_FILE`, and assert both the
negative (finding present) and the positive (same target passes with the unmodified copy).

**Rationale**: This is the deferred question from clarification. The tracked manifest is never
written, so FR-005 holds with no revert step and a mid-test failure cannot corrupt the repository —
which is what makes this strictly better than the mutate-then-`git checkout --` pattern. Feature 045
already established the override for its malformed-manifest test, so the mechanism is proven.

The target should be a **fixture**, not a real skill: the spec's edge cases require the proof not to
depend on which skill it validates, and a fixture cannot later acquire the key through unrelated
editorial work on a real skill's frontmatter.

The positive assertion is the part that matters most. Without it, a validator that rejected
everything unconditionally would pass the test — the same vacuous-pass flaw that let the original
gap through.

**Alternatives considered**: Asserting on the manifest's text — rejected outright by D3.8, which
forbids a static document-contract test standing as evidence for a behavioural requirement. That is
precisely the error being corrected.

## Decision 8 — Byte-identical output is verified by captured diff, not exit status

**Decision**: Capture complete validator output for all 8 skills and every fixture before touching
`frontmatter-lexicon.sh`, store it outside the repository tree, and `diff` after.

**Rationale**: FR-010 requires identical text, order, and exit status. Exit status alone would not
catch a reordered or reworded finding, and reordering is a live risk because the rewrite changes the
order in which rule-id resolution and lexicon lookup are attempted.

The baseline must be captured **first**. Once the library is edited the original behaviour is no
longer observable, and the comparison silently degrades into "it looks right".

## Resolved unknowns

| Unknown from Technical Context | Resolution |
|---|---|
| Does bash 3.2 support the constructs required? | Yes, except `${v,,}`; all others probed working. |
| Is the 0.025s per-invocation target reachable? | Yes — 0.0126–0.0145s measured, but only with lazy rule loading. |
| Fixture or real skill for the proof? | Fixture (Decision 7). |
| How to avoid glob injection in the lookup? | Quote the pattern operand (Decision 2, verified hazard). |

No `NEEDS CLARIFICATION` items remain.
