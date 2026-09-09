# Contract: Correspondence Check

**Feature**: 016-artifact-correspondence | **Date**: 2026-09-08

The interface this feature exposes is the behaviour of `adapter-coverage.test.sh` as invoked by
`run-all.sh`. This document is the contract that behaviour must meet.

## Invocation

```text
.highway/tools/tests/adapter-coverage.test.sh
```

No arguments. No environment variables. Run from any working directory — the script resolves its
own root, per the existing pattern.

## Exit codes

| Code | Meaning |
|---|---|
| `0` | Every skill present corresponds to its generated artifacts, no artifact names an absent skill, and every generated artifact is current |
| `1` | At least one correspondence or currency assertion failed; every failure has been printed |

The check reports **all** failures before exiting, never stopping at the first. A maintainer who
has removed a skill needs the whole list of orphans, not the first one alphabetically.

## Output format

One line per failure, on stdout, each beginning `FAIL: ` and naming both the skill and the specific
artifact:

```text
FAIL: skill 'highway-inquiry' has no entry in the catalog
FAIL: skill 'highway-inquiry' has no adapter at .cursor/rules/highway-inquiry.mdc
FAIL: skill 'highway-inquiry' would not reach users; .github/skills/highway-inquiry is not included by the distribution manifest
FAIL: catalog entry 'highway-ghost' names a skill with no directory under skills/
FAIL: adapter .claude/skills/highway-ghost/SKILL.md names a skill with no directory under skills/
FAIL: adapter manifest row names skill 'highway-ghost', which has no directory under skills/
FAIL: distribution manifest row .github/skills/highway-ghost names a skill with no directory under skills/
FAIL: .highway/catalog/index.json is stale; regenerating from current sources produces a different file
```

The third message is the existing one and is preserved verbatim, so this feature adds messages
without changing any that already exist.

Silence on success. The harness prints the pass line.

## Guarantees

| ID | Guarantee | Why it matters |
|---|---|---|
| G1 | The working tree is byte-identical after the run, whether it passed or failed | FR-012. Achieved structurally: the real tree is never written to |
| G2 | No temporary directory survives a normal exit | Housekeeping; an interrupted run may leave one under `/tmp`, which is acceptable |
| G3 | The verdict does not depend on whether other tests ran first | FR-011. The manifest's unstable ordering is excluded from comparison |
| G4 | The verdict does not depend on the current time | `generated_at` excluded from every comparison |
| G5 | Adding a skill requires no edit to this test for it to be covered | FR-008. The skill set is read from disk at run time |
| G6 | An empty skills directory fails rather than passing vacuously | FR-013. The existing `skill_count` guard, extended to the new assertions |
| G7 | Every failure names the skill and the artifact | FR-009 |
| G8 | The file contains no literal development-path token | `D1.1`. Assemble at runtime where such a token is needed |

## Anti-guarantees

Stated so a later reader does not assume them:

- **Does not check `.adapter-manifest` byte content.** Owned by `D4.3` and
  `generate-agent-adapters.test.sh`.
- **Does not check the distribution output tree.** Owned by `D1.2`, `D4.3` and
  `distribution-packaging.test.sh`.
- **Does not prune.** Settled by FR-018: orphans are reported, never removed.
- **Does not validate skill content.** Owned by `validate-skill.sh`.

## Failure proof obligations

The contract is met only when each guarantee has been observed failing, not merely passing. For
each of the five correspondences, break it for `highway-inquiry`, confirm the check fails with the
expected message, restore, and confirm it passes again.

| Proof | Break | Expected |
|---|---|---|
| P1 | Remove its catalog entry | Exit 1, names the missing entry |
| P2 | Remove one adapter file | Exit 1, names the missing adapter path |
| P3 | Remove its adapter manifest rows | Exit 1 or pass — record which, since the manifest is excluded from currency but in scope for D4.6 |
| P4 | Remove a distribution manifest row | Exit 1, names the unclassified path |
| P5 | Change its description without regenerating | Exit 1, names the stale catalog |

P3 is written as an open observation rather than an expected verdict, because the answer depends on
whether removing a row is an orphan (D4.6, which asks about rows naming absent skills) or a gap
(D4.5, which asks about skills lacking rows). Removing a row for a skill that still exists is the
latter. The implementation must decide this deliberately and record it.
