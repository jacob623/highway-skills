# Implementation Plan: Development Tier Honesty

**Branch**: `014-dev-tier-honesty` | **Date**: 2026-09-08 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/014-dev-tier-honesty/spec.md`

## Summary

Ten `D` rules claim `[auto]` while no script decides any of them by name. The fix is not more
checks: six of the ten are already enforced by tests that simply never name the rule they enforce.
What is missing is a definition — `[auto]` was borrowed from a document whose machinery Layer 0
does not have.

So the document gets a stated meaning for its own tier tag: a test in `run-all.sh` decides the
rule, and an **Enforcement Map** records which one. Six rules are mapped, three that constrain
process across time are retagged, and D5.4 — unenforced and trivially checkable — gains a real
check. The guard from feature 013 then covers both documents, with a different rule per document
because the definitions genuinely differ.

## Technical Context

**Language/Version**: Bash 3.2.57, the macOS system shell (D2.1)

**Primary Dependencies**: None. The map is parsed with `awk` and `grep`, and the guard extends an
assertion that already exists.

**Storage**: A Markdown table inside `.specify/memory/constitution.md`. No new file format.

**Testing**: The existing harness, currently 15 tests. One test is extended; one is added.

**Target Platform**: macOS and Linux; every flag accepted by both variants (D2.3).

**Project Type**: Governance document plus the tests that enforce it. No application structure.

**Constraints**: Every file touched must live under `.highway/tools/tests/` or `.specify/`, both
excluded from the distribution. The guard must be extended only after the document satisfies the
new definition, or the suite goes red mid-feature.

**Scale/Scope**: Ten rules; one new section, three retags, one new test, one extended assertion.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-checked after Phase 1 design.*

Evaluated against `.specify/memory/constitution.md` v1.0.0 — the document this feature amends.
Gates whose trigger is false are recorded N/A.

### Process gates

**Packaging Gate** — **N/A: no shipped path is touched.** Every change lands under
`.highway/tools/tests/` or `.specify/`, both excluded by the distribution manifest. Research R7
records this as a design rule rather than an accident: if the work ever needs a file under
`lib/`, the packaging classification must be revisited in the same change.

**Toolchain Gate** — triggered: the change adds and modifies files under `.highway/tools/`.

| Rule | Verdict | Evidence |
|---|---|---|
| D2.1 | PASS | Map parsing uses `awk` and `grep` in the style of the existing tests; no Bash 4 construct. |
| D2.2 | PASS | No utility outside the Declared Toolchain. |
| D2.3 | PASS | No new flag. |
| D2.4 | PASS | No new dependency. |

**Generator Gate** — **N/A: no `generate-*.sh` script is touched.**

**Validation Gate** — triggered: the change adds validation checks.

| Rule | Verdict | Evidence |
|---|---|---|
| D3.4 | PASS | The D5.4 check acts on directory names under `specs/`, not on any fixture, so no fixture verdict can change. Confirmed rather than assumed during implementation. |
| D3.5 | PASS | The guard gains coverage; nothing is removed or loosened. Feature 013 scoped it to one document deliberately and said so — widening it is the completion of that intent, not a weakening. |

**Spec Record Gate** — triggered: the change touches `specs/`.

| Rule | Verdict | Evidence |
|---|---|---|
| D5.1 | PASS | No completed spec directory is edited. Feature 013's record is left as it stands. |
| D5.2 | PASS | New work in its own numbered directory. |
| D5.3 | PASS | Research R2 names every rule whose disposition changes. |
| D5.4 | PASS | `014` follows `013`; verified contiguous `001`–`014`. This feature also makes the rule self-enforcing, so its own compliance is checked by the work it delivers. |

**Skill Content Gate** — **N/A: Skill Content Gate not triggered.** No file under
`.highway/skills/` or `.highway/library/` is created or modified.

### Skill content gates

`N/A: Skill Content Gate not triggered.`

### A note on self-application

This plan is governed by the document it amends, and one rule it touches governs this plan's own
directory. D5.4 is currently unenforced; enabling its check must therefore not retroactively fail
the existing spec record. Verified: `001` through `014` are contiguous with no duplicate, so
enabling the check invalidates no conforming work and the amendment stays MINOR rather than
MAJOR. If that had not held, the classification would have had to change — which is why it was
checked rather than assumed.

**Result: PASS on every triggered gate. No violations. Complexity Tracking is empty.**

## Project Structure

### Documentation (this feature)

```text
specs/014-dev-tier-honesty/
├── plan.md                          # This file
├── spec.md                          # Feature specification
├── research.md                      # Phase 0 output
├── data-model.md                    # Phase 1 output
├── quickstart.md                    # Phase 1 output
├── contracts/
│   └── tier-honesty-guard.md        # Phase 1 output
├── checklists/
│   └── requirements.md              # 16/16
└── tasks.md                         # Created by /speckit.tasks, not here
```

### Source Code (repository root)

```text
.specify/memory/
└── constitution.md                          # AMENDED — 1.0.0 → 1.1.0 (MINOR)
                                            #   tier definition for Layer 0
                                            #   Enforcement Map section added
                                            #   D3.1, D3.2, D4.4 retagged
                                            #   follow-up entry removed

.highway/tools/tests/
├── constitution-inventory.test.sh           # AMENDED — guard covers both documents
└── spec-record.test.sh                      # NEW — enforces D5.4
```

**Structure Decision**: Nothing new is introduced and nothing shipped is touched. The new test
joins fifteen others and is discovered automatically by `run-all.sh`; the guard extends an
assertion feature 013 already wrote; the Enforcement Map is a Markdown table in the document it
describes.

The placement constraint is the one deliberate decision: **every file lives under
`.highway/tools/tests/` or `.specify/`**, both excluded by the distribution manifest. That keeps
the packaged tree byte-identical, satisfies FR-015 without a manifest change, and is why the
Packaging Gate is honestly N/A rather than N/A by oversight.

## Complexity Tracking

No Constitution Check violations. This section is intentionally empty.
