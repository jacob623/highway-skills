# Implementation Plan: Probe Reachability Correction

**Branch**: `042-probe-reachability-correction` | **Date**: 2026-09-10 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/042-probe-reachability-correction/spec.md`

## Summary

Feature 041 made every `[auto]` rule's check prove it can fail, and its coverage record reported
twelve mapped checks proved where the Enforcement Map has thirteen rows. Measurement on 2026-09-10
shows the harness also proves less than that report implies:
`D3.7` binds probes to artifact **classes** while the Enforcement Map binds tests to **rules**, and
nothing joins the two, so a test deciding several rules satisfies the harness by proving any one of
them. Four mapped rules — `D4.3`, `D5.5`, `D7.2`, `D7.4` — are not reached by any declared probe.

This feature adds the reach that is missing, asserts the one refusal path that is asserted nowhere
at all (`D4.3`'s modified-file case), replaces Feature 041's runtime claim with a measured range
and a named interim ceiling, corrects the "twelve" coverage record to thirteen, and records the
class-to-rule join as a measured contract so the next mapped rule cannot repeat the omission.

Approach: two new artifact classes (`generated-artifact` on `distribution-packaging`,
`disposable-fixture` on `completion-coverage`), one broadened existing probe (`spec-record`'s
`disposable-fixture` leg seeds both `D5.4` and `D5.5` defects), a superseding probe-mode contract,
and a mapping table whose every row is established by removing an enforcement and watching the
suite fail.

## Technical Context

**Language/Version**: Bash 3.2.57 — the macOS default `/bin/bash`. No associative arrays; `$(...)`
strips trailing newlines; zero-padded numeric comparison needs a `10#` prefix; `"${arr[@]}"` on an
empty array is unbound under `set -u`.

**Primary Dependencies**: the Declared Toolchain only — awk, basename, cat, comm, cp, cut, date,
diff, dirname, find, grep, head, mkdir, mktemp, mv, rm, sed, sha256sum, shasum, sort, tail, tr,
uniq, wc, xargs. `git` is deliberately excluded and may not be used for restoration.

**Storage**: files in the working tree. No database, no network.

**Testing**: the repository's own suite, `.highway/tools/tests/run-all.sh`, plus the probe-mode CLI
on individual test files.

**Target Platform**: macOS and Linux developer machines, offline.

**Project Type**: shell toolchain and governance artifacts. No application code.

**Performance Goals**: full suite under **180s**, retained from Feature 041 and knowingly unmet —
measured 175, 175, 176, 185, 190, 206s across six runs on 2026-09-10, before this feature adds any
leg. An interim ceiling of **240s** applies while Phase 14 of the governance plan is outstanding.

**Constraints**: restoration byte-exact and unconditional via `trap ... EXIT`; every file created on
disk named with `$$`; no literal `specs/` or `.specify/` token in `.highway/tools/tests/` (see
research R7); no constitution amendment; no assertion Feature 041 added may be removed or loosened;
no file under `specs/041-auto-check-integrity/` may be edited except its `coverage.md`.

**Scale/Scope**: 8 mapped test files, 13 Enforcement Map `[auto]` rows, 3 test files modified, 2
artifact classes added, 1 probe broadened.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Constitution version 1.6.0 (ratified 2026-09-08, last amended 2026-09-10).

| Gate | Triggered | Disposition |
|---|---|---|
| **Toolchain Gate** (D2.1–D2.4) | Yes — modifies `.highway/tools/tests/` | PASS. Declared Toolchain only; Bash 3.2 syntax; no `git`; no new dependency |
| **Validation Gate** (D3.4, D3.5) | Yes — modifies validation checks | PASS. Every added assertion round-trips (seeded then restored); no existing check is narrowed. `FR-019` makes the `D4.3` probe fail if *either* refusal is removed, which is the anti-narrowing condition stated positively |
| **Packaging Gate** (D1.1, D1.6) | Yes — `shipped-tree-independence.test.sh` scans `tools/tests` regardless of the manifest | PASS, conditional on research R7: path segments assembled at runtime |
| **Spec Record Gate** (D5.1–D5.5) | Yes — touches `specs/` | PASS. New directory `042-probe-reachability-correction`; `Feature Branch` matches the directory name; numbering is contiguous after 041. Feature 041's directory is edited only at `coverage.md`, which `D5.1`'s exception permits |
| **Completion Gate** (D7.2, D7.4, D7.5) | Yes — corrects a completed feature's record | PASS. `042` is registered `in-progress` with `Corrects` set to `-` pending `FR-018`'s fix; `FR-013` scopes the corrective set to `complete` features |
| **Generator Gate** | No | N/A: no `generate-*.sh` is modified. `generate-distribution.sh` is exercised, never edited |
| **Skill Content Gate** | No | N/A: no `SKILL.md` and no library file is touched |

**No violations to justify.** The one judgement call — that the class-to-rule join is recorded as a
contract rather than elevated to an `[auto]` constitution rule — is not a gate violation but a
scoping decision, recorded in research R6 and in the spec's fourth clarification as a declined
option rather than an oversight. `FR-015` forbids the amendment in this feature.

**Post-design re-check**: performed after Phase 1. Unchanged — the superseding contract adds no new
tool, no new dependency, no generator change and no constitution rule. The two added classes stay
inside the existing three-value vocabulary, so the harness interface is unchanged.

## Project Structure

### Documentation (this feature)

```text
specs/042-probe-reachability-correction/
├── plan.md              # This file
├── spec.md              # Clarified, session 2026-09-10, four questions
├── research.md          # Phase 0 output — R1..R7
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/
│   └── probe-mode.md    # Phase 1 output — supersedes 041's contract of the same name
└── tasks.md             # Phase 2 output (/speckit.tasks — NOT created here)
```

### Source Code (repository root)

```text
.highway/tools/
├── generate-distribution.sh              # exercised by the new probe; NOT modified
├── .distribution-manifest                # read only
└── tests/
    ├── distribution-packaging.test.sh    # + generated-artifact class (D4.3, both refusals)
    ├── spec-record.test.sh               # disposable-fixture probe broadened to reach D5.5
    ├── completion-coverage.test.sh       # + disposable-fixture class (D7.2/D7.4); line 540 fix
    ├── constitution-inventory.test.sh    # harness; read to confirm reach, modified only if needed
    ├── shipped-tree-independence.test.sh # constrains the above; NOT modified
    └── run-all.sh                        # $$ sweep and suite timing; NOT modified

.specify/memory/
├── constitution.md                       # read only — FR-015 forbids editing
└── completion-register.md                # 042 row; Corrects column after FR-018

specs/041-auto-check-integrity/
└── coverage.md                           # corrected twelve -> thirteen (D5.1 exception)

governance-plan.md                        # Phase 14 cost figures re-stated after measurement
```

**Structure Decision**: No new directory and no new tool. The change is confined to three test files
under `.highway/tools/tests/`, one corrected coverage record, one register column, and this
feature's own spec directory. Adding a tool to police the join was considered and rejected in
research R6 — the only mechanical proxy available cannot fail for the defect it would name.

## Phase 0 — Research

Complete. See [research.md](research.md). Seven findings, all measured 2026-09-10:

- **R1** the defect is a missing class-to-rule join, with the per-test reachability table
- **R2** three of the four rules *are* asserted in normal mode — the gap is provability, not
  defencelessness; only `D4.3`'s modified-file half is undefended. This narrows the spec's framing
  and is recorded rather than quietly dropped
- **R3** the class vocabulary is closed, so `spec-record`'s one class must carry two rules
- **R4** `completion-coverage` seeds the checked-in coverage fixture, which the contract already
  sanctions verbatim
- **R5** the `D4.3` class costs ~16s measured; the feature's total is left open until `FR-009`
- **R6** the join cannot honestly be `[auto]`; it is made falsifiable by `FR-024` instead
- **R7** `tools/tests` is excluded from the distribution but scanned anyway

**No NEEDS CLARIFICATION remain.** The spec's four clarifications settled scope, class count,
runtime policy and the corrective set.

## Phase 1 — Design

Complete. Artifacts:

- [data-model.md](data-model.md) — Artifact class, Probe leg, Class-to-rule join, Superseding
  contract, and the rule/probe-leg mapping's required shape
- [contracts/probe-mode.md](contracts/probe-mode.md) — supersedes
  `specs/041-auto-check-integrity/contracts/probe-mode.md`, naming every changed element per `D5.3`
- [quickstart.md](quickstart.md) — how to run a probe, seed a removal, and reproduce the timings

## Open measurements this plan schedules

These are obligations, not estimates. Each is a task input for `/speckit.tasks`.

| # | Measurement | Requirement | Why it cannot be inferred |
|---|---|---|---|
| M1 | Cost of the `completion-coverage` `disposable-fixture` legs | FR-009 | Never run; file-operation cost is not derivable from the build-dominated `D4.3` figure |
| M2 | Cost of the broadened `spec-record` leg | FR-009 | Adds seeding to an existing leg; the delta is unknown |
| M3 | Full-suite range after **all** classes exist | FR-009, FR-020 | `FR-009` requires measurement after the fact, explicitly not scaling from R5 |
| M4 | Every `[auto]` rule's enforcement removed, suite observed failing, detecting leg named | FR-023, FR-024, SC-009 | Reading probe source is what produced the original over-claim |

M4 is the expensive one: thirteen rows, each a remove-run-restore cycle against a ~180s suite. It is
also the only evidence that distinguishes this feature from the one it corrects.

## Known risks

| Risk | Handling |
|---|---|
| The 240s interim ceiling becomes a second permanent target | Governance plan Phase 14's Done-when already requires its removal once 180 is met; the spec's Assumptions say the same |
| A probe leaves an artifact behind on an early exit | `trap ... EXIT`, `$$` naming, and `run-all.sh`'s existing sweep |
| Seeding the coverage fixture corrupts it | Byte-exact restore; the fixture is checked in, so drift is visible |
| M4 tempts a shortcut back to source-reading | `FR-024` names the method; a mapping row without a recorded failure observation is not evidence |

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No violations. Table intentionally empty.
