# Implementation Plan: Distribution Packaging

**Branch**: `012-distribution-packaging` | **Date**: 2026-09-08 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/012-distribution-packaging/spec.md`

## Summary

Produce the user-facing Highway distribution from the repository in one verified step, replacing
today's manual and unverified strip. Every repository path is classified in a single manifest that
the packaging step reads; the produced tree is then verified to contain no development-only
reference, to have every cross-reference resolve internally, and to validate itself using only its
own contents.

The approach follows the manifest and drift-refusal pattern already proven in
`generate-agent-adapters.sh`, copies artifacts rather than regenerating them so output is
byte-identical, and — the one non-obvious decision — runs the **distribution's own copy** of the
validator, because the repository's copy resolves its governing document relative to itself and so
cannot prove anything about self-containment.

## Technical Context

**Language/Version**: Bash 3.2.57, the macOS system shell (D2.1)

**Primary Dependencies**: None beyond the constitution's Declared Toolchain. No package manager,
interpreter, or new binary is introduced (D2.4).

**Storage**: Tab-delimited flat files. `.distribution-manifest` is hand-authored and version
controlled; `.distribution-record` is generated inside each distribution.

**Testing**: The existing harness at `.highway/tools/tests/`, run by `run-all.sh`. One new test
file joins the current fourteen.

**Target Platform**: macOS and Linux. Every utility flag must be accepted by both the GNU and
Apple/BSD variants (D2.3).

**Project Type**: Command-line toolchain within an existing repository. No application structure.

**Performance Goals**: Not applicable. The step copies a tree of a few hundred files; the suite
must stay fast enough to run on every change, which a copy-and-scan operation does not threaten.

**Constraints**: No version-control command may be invoked — a distribution is not a repository,
and the constitution deliberately omits `git` from the Declared Toolchain. Packaging must not
regenerate artifacts, because one generator records a timestamp.

**Scale/Scope**: Nine top-level repository paths; one directory requiring within-directory
distinctions; one new script, one new manifest, one new front page, one new test, one amended
test.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-checked after Phase 1 design.*

Evaluated against `.specify/memory/constitution.md` v1.0.0. Gates whose trigger is false are
recorded N/A, per the constitution's gate semantics.

### Process gates

**Packaging Gate** — triggered: the change touches shipped paths under `.highway/`.

| Rule | Verdict | Evidence |
|---|---|---|
| D1.1 | PASS | The front page and script carry no `.specify/` or `specs/` token; the independence check covers both. |
| D1.2 | PASS | Strengthened rather than merely met — the distribution's own validator runs against the distribution, which is what this rule describes. The mismatch logged while runtime-only was under consideration is resolved. |
| D6.2 | PASS | Cross-reference resolution becomes an enforced check (FR-008) rather than a convention. |

**Toolchain Gate** — triggered: the change adds a file under `.highway/tools/`.

| Rule | Verdict | Evidence |
|---|---|---|
| D2.1 | PASS | No associative array, `mapfile`, `readarray`, `${var^^}`, or `&>>`. Manifest parsing uses `grep -F` and `awk`, matching existing practice. |
| D2.2 | PASS | Utilities enumerated in the contract; all appear in the Declared Toolchain. |
| D2.3 | PASS | No flag outside the portable set already in use. `diff -r -x` and `cp -R` are accepted by both variants. |
| D2.4 | PASS | No new dependency. Notably no `git`, which the distribution could not rely on. |

**Generator Gate** — triggered: the change adds a `generate-*.sh` script.

| Rule | Verdict | Evidence |
|---|---|---|
| D4.1 | PASS | The production record makes a hand-edit detectable rather than silently overwritten. |
| D4.2 | PASS | Byte-identical output (FR-012), verified by S6. The timestamp exception is not invoked, because packaging copies rather than regenerates. |
| D4.3 | PASS | FR-013 and C6; scenario S8 exercises the refusal. |
| D4.4 | PASS | No existing generator changes, so nothing requires regeneration. |

The gate triggers on the `generate-*.sh` name. Research R4 records that the script was named to
match its substance rather than named around the trigger.

**Validation Gate** — triggered: the change adds verification checks.

| Rule | Verdict | Evidence |
|---|---|---|
| D3.4 | PASS | The new checks act on a produced distribution, not on skill or library files, so no existing fixture's verdict changes. The amendment to `shipped-tree-independence.test.sh` is the one place existing behavior is touched, and R2 records that its scope is preserved rather than narrowed. |
| D3.5 | PASS | No assertion is removed or loosened. See the note below. |

**Spec Record Gate** — triggered: the change touches `specs/`.

| Rule | Verdict | Evidence |
|---|---|---|
| D5.1 | PASS | Only `specs/012-distribution-packaging/` is written; no completed spec directory is edited. |
| D5.2 | PASS | Not applicable in substance — this is new work, not a correction. |
| D5.3 | PASS | The reversal from runtime-only names what changed and why, rather than overwriting the earlier answer. |
| D5.4 | PASS | `012` follows `011`. Verified contiguous. |

**Skill Content Gate** — **N/A: Skill Content Gate not triggered.** No file under
`.highway/skills/` or `.highway/library/` is created or modified. The distribution front page
lives at `.highway/DISTRIBUTION.md`, outside both.

### Skill content gates

`N/A: Skill Content Gate not triggered.`

### D3.5 note — why amending the independence check is not a weakening

`shipped-tree-independence.test.sh` currently declares its own target set. This plan has it read
the manifest instead, which would narrow its scope, because the manifest excludes
`.highway/tools/tests/` while the check deliberately scans fixtures with no exemption.

The plan therefore has the check read the manifest **and** add the test directory explicitly, with
the reason recorded inline. The scanned set is unchanged; only its declaration moves. No assertion
is removed or loosened, so D3.5 holds and no superseded behavior needs recording.

### D1.6 note — one declaration, two readers

D1.6 requires the distributed path set be declared in exactly one place. After this change the
manifest is that place, with two readers: the packaging step and the independence check. The
check's extra line is not a second declaration of what ships — it states that the check's scope
intentionally exceeds the distribution.

**Result: PASS on every triggered gate. No violations. Complexity Tracking is empty.**

## Project Structure

### Documentation (this feature)

```text
specs/012-distribution-packaging/
├── plan.md                              # This file
├── spec.md                              # Feature specification
├── research.md                          # Phase 0 output
├── data-model.md                        # Phase 1 output
├── quickstart.md                        # Phase 1 output
├── contracts/
│   └── generate-distribution.md         # Phase 1 output
├── checklists/
│   └── requirements.md                  # 16/16
└── tasks.md                             # Created by /speckit.tasks, not here
```

### Source Code (repository root)

```text
.highway/
├── DISTRIBUTION.md                       # NEW — front page; lands as README.md
└── tools/
    ├── .distribution-manifest            # NEW — the single classification
    ├── generate-distribution.sh          # NEW — produce and verify
    └── tests/
        ├── distribution-packaging.test.sh     # NEW — regression coverage
        └── shipped-tree-independence.test.sh  # AMENDED — reads the manifest
```

Produced, not committed:

```text
<target>/
├── README.md                             # from .highway/DISTRIBUTION.md
└── .highway/
    ├── skills/  library/  catalog/  governance/
    └── tools/                            # minus tests/
        └── .distribution-record          # what this run produced
```

**Structure Decision**: The feature adds to the existing `.highway/tools/` toolchain rather than
introducing a structure. The script sits beside the other generators, the manifest beside
`.adapter-manifest` whose format it mirrors, and the test beside the other fourteen. The one
placement worth noting is `.highway/DISTRIBUTION.md`: it is a distributed artifact, so it must
live under `.highway/`, and it cannot sit at the repository root because the repository's own
front page already occupies it. That single constraint is the entire reason the manifest carries
a destination column.

## Complexity Tracking

No Constitution Check violations. This section is intentionally empty.
