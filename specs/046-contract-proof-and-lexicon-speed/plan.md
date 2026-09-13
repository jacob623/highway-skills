# Implementation Plan: Contract Proof and Lexicon Speed

**Branch**: `046-contract-proof-and-lexicon-speed` | **Date**: 2026-09-12 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/046-contract-proof-and-lexicon-speed/spec.md`

## Summary

Two independent repairs to work delivered in Feature 045.

The first converts a one-off manual proof into a permanent test. Feature 045 claimed that the
frontmatter contract manifest alone governs which keys are required, and demonstrated it once by
hand. Nothing in the suite defends that claim, so it can be lost silently. This feature adds an
executed-behaviour test that adds a required key to a throwaway manifest copy, runs the real
validator, and asserts the finding appears — and asserts the same skill passes without the added row,
so the test cannot pass vacuously.

The second removes the per-word subprocess cost from the lexicon check. The current implementation
forks roughly eight to ten processes per word. The replacement loads the lexicon once into a
newline-delimited string and tests membership with a quoted `[[ ]]` pattern match, loads rule ids
once and lazily, and normalises tokens with parameter expansion. Every technique was verified against
the real `bash` 3.2.57 and a working prototype before this plan was written.

Measured prototype result: the lexicon check's cost per validator invocation falls from **0.237s** to
**0.0126–0.0145s** across all 8 skills — a **93.9%** reduction, inside the 0.025s target — with
identical output.

## Technical Context

**Language/Version**: Bash 3.2.57 (the `/bin/bash` macOS actually ships). Confirmed by probe.

**Primary Dependencies**: None added. Existing libraries under `.highway/tools/lib/`.

**Storage**: Plain files — a TAB-delimited manifest and a newline-delimited word list.

**Testing**: The repository's own shell suite, `.highway/tools/tests/run-all.sh` (37 files).

**Target Platform**: macOS and Linux, via the Declared Toolchain only.

**Project Type**: Internal CLI validation tooling, distributed to users as a packaged tree.

**Performance Goals**: Lexicon cost per validator invocation at or below 0.025s, down from 0.237s.
Lexicon contribution to suite runtime down at least 90%. Total suite runtime recorded as an
observation against the 240 second interim ceiling, not gated (per Clarifications).

**Constraints**: No associative arrays, `mapfile`, `readarray`, or `${var^^}`/`${v,,}` (D2.1 — the
last confirmed a `bad substitution` by probe). No `jq`, no interpreter. Output must remain
byte-identical. No constitution rule added, removed, or retagged.

**Scale/Scope**: 172-word lexicon; 60 resolvable rule ids; 24–36 free-form words per skill; 8 skills
plus fixtures; hundreds of validator invocations per suite run.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-checked after Phase 1 design — see below.*

| Rule | Requirement | How this feature satisfies it |
|------|-------------|-------------------------------|
| D1.1 | Shipped artifact must not reference a development artifact | The new test lives under `.highway/tools/tests/`, which ships. It must contain neither prohibited token. Feature 045 tripped exactly this; `shipped-tree-independence.test.sh` will catch a regression. |
| D1.5 | A plan modifying a skill or library file must check against the Highway Skills Constitution | **Not triggered.** No skill and no file under `.highway/library/` is modified. FR-014 forbids editing lexicon words, which is the only library file in scope. Recorded rather than skipped silently. |
| D2.1 | Must run under Bash 3.2.57 | Every construct probed against the real 3.2.57 shell. `${v,,}` rejected and replaced with an index-arithmetic lowercaser guarded by a `*[A-Z]*` fast path. |
| D2.2, D2.4 | Declared Toolchain only; no new runtime dependency | Uses `cat` and `sed` for the one-time load; both declared. Nothing added. |
| D3.1, D3.2 | Suite green before the first edit and after the last | Recorded at both ends. |
| D3.3 | A behavioural change must add or amend a test | Both stories touch `.highway/tools/tests/`. |
| D3.6 | A test must be observed failing before the behaviour is marked complete | Governs US1 directly: the seeded defect must be run and its message recorded before the implementation that makes it pass. |
| D3.8 | A static document-contract test must not be recorded as evidence for a behavioural requirement | Directly on point. The US1 proof must execute the validator, not assert on manifest file text. This is the precise failure being repaired. |
| D6.1 | Live documentation updated in the same change | `governance-plan.md` Phase 14 note updated with the measured runtime outcome. |
| D7.3 | Completion report states requirement coverage separately from check results | The final report keeps suite result and requirement coverage distinct. |

**Result**: PASS. No violations; Complexity Tracking is empty.

### Post-design re-check (after Phase 1)

Re-evaluated against the generated artifacts. Still PASS, with two gates sharpened by what the
research turned up:

- **D3.8** moved from "relevant" to *load-bearing*. It is the rule that rejects the tempting shortcut
  of asserting on the manifest's text, and it is recorded as obligation RK-1 in
  [contracts/required-key-proof.md](contracts/required-key-proof.md).
- **D2.1** gained a concrete failure the probe found rather than a theoretical one: `${v,,}` returns
  `bad substitution` on 3.2.57. The design uses an index-arithmetic lowercaser instead.
- One hazard surfaced that no constitution rule covers: an unquoted operand on the right-hand side of
  `[[ == ]]` is glob-interpreted, which was **verified** to match where it must not. It is recorded
  in the library contract's prohibited-constructs list so it is checkable during review.

No new rule is proposed. The hazard is specific to this library's lookup and does not warrant a
repository-wide rule on the strength of one occurrence.

## Project Structure

### Documentation (this feature)

```text
specs/046-contract-proof-and-lexicon-speed/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
├── checklists/
│   └── requirements.md
└── spec.md
```

### Source Code (repository root)

```text
.highway/
├── library/
│   └── knowledge/
│       └── frontmatter-lexicon.txt        # read only; not edited (FR-014)
├── governance/
│   ├── constitution.md                    # read only; source of P-rule ids
│   └── experience-standard.md             # read only; source of X-rule ids
└── tools/
    ├── .frontmatter-contract              # read only; copied, never written (FR-005)
    ├── validate-skill.sh                  # unchanged unless wiring requires it
    ├── lib/
    │   ├── frontmatter-contract.sh        # unchanged
    │   └── frontmatter-lexicon.sh         # MODIFIED — US2, the whole hot path
    └── tests/
        ├── frontmatter-lexicon.test.sh    # AMENDED — US2 output-equivalence
        └── frontmatter-contract-required-keys.test.sh   # NEW — US1 proof
```

**Structure Decision**: No new directories. US2 is confined to one library file; US1 adds one test
file. The tracked manifest and lexicon are inputs only — neither is written by any new code, which is
what keeps FR-005 and FR-014 satisfiable without a revert step.

## Complexity Tracking

No Constitution Check violations. Section intentionally empty.
