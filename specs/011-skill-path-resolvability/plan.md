# Implementation Plan: Skill Path Resolvability Rule

**Branch**: `011-skill-path-resolvability` | **Date**: 2026-09-08 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/011-skill-path-resolvability/spec.md`

## Summary

Add a rule to the Highway Skills Constitution requiring that a skill reference no path that fails
to resolve for whoever receives it, and enforce it with a check registered in the rule-check
library so the verdict is reported by rule identifier alongside every other rule. Cite the rule by
identifier from the authoring standard, add a governance section to the repository front page, and
remove three follow-up entries whose work is already complete.

Research established that the rule reduces to a stronger and simpler form than the description
assumed: because a `SKILL.md` is copied byte-identically into three other trees, **no relative link
in a skill body can resolve anywhere except the source tree**. The rule therefore prohibits
relative link targets outright rather than attempting per-tree resolution.

## Technical Context

**Language/Version**: Bash 3.2.57 (the macOS default `/bin/bash`)

**Primary Dependencies**: None beyond the Declared Toolchain

**Storage**: Flat files

**Testing**: The existing Bash harness, `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS and Linux shells

**Project Type**: Single internal tooling project

**Performance Goals**: N/A

**Constraints**:

- Bash 3.2 compatible; Declared Toolchain only
- The new check must be evaluated against every fixture before it is enabled (D3.4)
- The new rule must not restate D6.2, which governs a different artifact class
- No skill content changes, so no skill version increments and no derived artifact is regenerated

**Scale/Scope**: One rule added; one check registered; two documents amended; three follow-up
entries removed; one new fixture

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-checked after Phase 1 design.*

First plan evaluated under the Highway Development Constitution v1.0.0, using its Constitution
Check Output Shape.

### Part 1 — Process gates

| Gate | Trigger | Verdict |
|---|---|---|
| **Packaging Gate** | Triggered — changes `.highway/governance/`, `.highway/skills/`, `.highway/tools/` | See below |
| **Toolchain Gate** | Triggered — changes files under `.highway/tools/` | See below |
| **Generator Gate** | Not triggered — no `generate-*.sh` is touched | N/A |
| **Validation Gate** | Triggered — adds a validation check | See below |
| **Spec Record Gate** | Triggered — creates `specs/011-…` | See below |
| **Skill Content Gate** | Triggered — modifies `.highway/skills/_authoring-standard.md` | Delegated, Part 2 |

| Rule | Verdict | Basis |
|---|---|---|
| D1.1 | PASS | No development-path reference is added. The rule is phrased without naming a development directory, which is the point of the feature. |
| D1.2 | PASS | The check resolves paths relative to the framework root and reads no development directory. |
| D6.2 | PASS | The front-page links added are verified to resolve; the authoring standard's citation is by identifier, not path. |
| D2.1 | PASS | The check uses no associative array, `mapfile`, `readarray`, `${var^^}`, or `&>>`. |
| D2.2 | PASS | The check invokes only `grep`, `sed`, and `awk`, all on the Declared Toolchain. |
| D2.3 | PASS | No flag outside the portable set is used. |
| D2.4 | PASS | No dependency is added. |
| D3.4 | PASS | research.md R7 records the expected verdict of every existing fixture under the new check before it is enabled. This gate is the reason that section exists. |
| D3.5 | PASS | No assertion is removed or loosened. Assertions are added. |
| D5.1 | PASS | No completed spec directory is edited. |
| D5.2 | PASS | This ships as its own numbered spec. |
| D5.3 | PASS | The constitution amendment names the rule added; nothing is superseded. |
| D5.4 | PASS | `011` follows `010`. |

### Part 2 — Skill content gates

The Skill Content Gate triggered because `.highway/skills/_authoring-standard.md` sits under
`.highway/skills/`. That file is not a skill, so most rules governing skill content do not apply
to it.

| Rule | Verdict | Basis |
|---|---|---|
| P7.3 | PASS | The authoring standard cites the new rule by identifier and restates no rule text, which is what the rule requires of it. |
| All other `P` rules | N/A | No `SKILL.md` is created or modified by this feature. |

**Gate-trigger imprecision, recorded not resolved**: the Skill Content Gate triggers on any file
under `.highway/skills/`, but `_authoring-standard.md` is not a skill. The gate is correct to
draw attention here and the delegation is answerable, so nothing is blocked. Narrowing the trigger
to `SKILL.md` files would be a MINOR amendment to the development constitution and is out of scope
for this feature.

**Result**: PASS. No violation requires justification, so Complexity Tracking is empty.

## Project Structure

### Documentation (this feature)

```text
specs/011-skill-path-resolvability/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
│   ├── skill-reference-contract.md
│   └── governance-documentation-contract.md
├── checklists/
│   └── requirements.md  # Written by /speckit.specify
└── tasks.md             # Phase 2 output (/speckit.tasks — not created here)
```

### Source Code (repository root)

```text
.highway/
├── governance/
│   └── constitution.md                 # new rule P8.7; MINOR bump; 3 TODOs removed
├── skills/
│   └── _authoring-standard.md          # cites P8.7 by id
└── tools/
    ├── lib/
    │   └── rule-checks.sh              # registry gains P8.7; rc_check_P8_7 added
    └── tests/
        ├── rule-checks.test.sh         # seeded P8.7 violation case
        ├── validate-skill.test.sh      # new fixture assertions
        └── fixtures/
            └── invalid-skill-relative-link/   # NEW fixture

README.md                               # governance section added
```

**Structure Decision**: Single project, existing layout. The check is registered in the existing
rule-check library rather than added as a standalone test, so that its verdict appears in the
coverage summary under its own rule identifier like every other rule. A standalone test would
enforce the rule while leaving the rule invisible in the validator's own report, which is the
class of problem this feature exists to remove.

## Complexity Tracking

No Constitution Check violation. This section is intentionally empty.
