# Implementation Plan: Help Skill

**Branch**: `006-help-skill` | **Date**: 2026-09-07 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/006-help-skill/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Author `.highway/skills/help/SKILL.md` — the first real skill under `.highway/skills/` (feature
001 shipped that directory framework-only) — which, given an optional skill identifier, prints
either a six-field Single-Skill response (Name, Description, Dependencies, Version, Usage,
Example) or an all-skills listing (Name, Usage, copy-able Help command), reading each target
skill's own `SKILL.md` for the single-skill response and the generated `catalog/index.json` for
the all-skills listing. This requires extending the skill-authoring contract with two new
required registration fields — a frontmatter `usage` field and a body `## Example` section —
enforced by `.highway/tools/validate-skill.sh` exactly like the existing `description` and
`Purpose` checks, and extending `.highway/tools/generate-catalog.sh` to carry the new `usage`
field. Per explicit instruction, the plan also requires running the existing
`.highway/tools/generate-agent-adapters.sh` so the `help` skill is materialized at all three
supported agent targets (`.github/skills/`, `.claude/skills/`, `.cursor/rules/`) before the
feature is considered done.

## Technical Context

**Language/Version**: Bash 3.2.57 (macOS default `/bin/bash`) — the entire `.highway/tools/`
toolchain is written against this floor; no `${var^}`, no associative arrays, no
`"${arr[@]}"` expansion on a possibly-empty array under `set -u`.

**Primary Dependencies**: None beyond POSIX-ish coreutils already used by `.highway/tools/`
(`awk`, `sed`, `grep`, `sha256sum`/`shasum`). No new runtime dependency.

**Storage**: Flat files only — `.highway/skills/help/SKILL.md` (source of truth),
`.highway/catalog/index.json`/`index.md` (generated cache), the three generated agent adapter
files. No database.

**Testing**: `.highway/tools/tests/*.test.sh`, a hand-rolled shell test harness (assert-style
functions, no external test framework), discovered and run by
`.highway/tools/tests/run-all.sh`. Fixtures live in `.highway/tools/tests/fixtures/`.

**Target Platform**: Local developer/agent CLI environment (macOS/Linux), consumed by GitHub
Copilot, Claude Code, and Cursor as installed skill/rule files — not a server or long-running
process.

**Project Type**: Single project — a bash-based authoring/validation/generation toolchain plus
one new authored skill artifact. No frontend/backend split.

**Performance Goals**: N/A — operates over a local skill catalog whose scale is bounded by how
many skills this repository's authors add by hand; no throughput target.

**Constraints**: Must keep `.highway/tools/validate-skill.sh`, `generate-catalog.sh`, and
`generate-agent-adapters.sh` exit-code and output-format contracts backward compatible for
every currently-passing test in `.highway/tools/tests/`; must not weaken any existing
`[auto]`-tier constitution check.

**Scale/Scope**: One new skill directory (`help`), two new registration requirements applied
repository-wide (`usage` field, `## Example` section), one extended catalog schema field, three
generated agent adapter files, no new top-level tool script.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

This feature authors a real skill for the first time (`help`), so the constitution's Skill
Authoring Workflow applies in full: all required body sections present, quality gate triggers
evaluated, Compliance Review Protocol run, every `FAIL` resolved before merge.

**Quality gate triggers for the `help` skill's own content**:

| Gate | Trigger evaluates | Rationale |
|---|---|---|
| Code Generation Gate | false (N1) | The skill instructs an agent to *read* skills and the catalog and print output; it does not create or modify a source file. |
| Testing Gate | false (N1), for the skill's own guidance | The skill's guidance defines no new executable behavior itself. (The *tooling* changes below — `validate-skill.sh`, `generate-catalog.sh` — are covered by the repository's existing shell test suite, not by this gate, which scopes to skill content.) |
| Security Gate | false (N1) | No authentication, authorization, secrets, network calls, file writes outside the working directory, deserialization of external data, cryptography, or dependency selection is involved; declared-input validation (unrecognized skill id) is handled under Principle V/VI (error handling, decision criteria), not this gate. |
| Maintainability Gate | false (N1) | The skill produces no retained file; it only prints to chat/terminal. |
| Performance Gate | **true** | Listing all skills is a file-system-scan-shaped operation (reading `catalog/index.json`, itself built from a scan of `.highway/skills/*/SKILL.md`). The skill's guidance MUST state this cost as O(n), n = catalog entry count, per the Performance Gate's requirement. Carried into the skill's `## Outputs`/`## Verification` text during authoring. |

**Applicable principles this feature must satisfy while authoring `help/SKILL.md`**:
- P7.1 (`## Purpose`, one sentence), P5.6 (`## When to use`, >= 2 scenarios), P1.5/P2.2
  (`## Inputs` names every dependency: the catalog file, the target skill directory convention),
  P8.3/P8.4 (`## Verification` names a checkable command/output), P5.1-P5.3 (`## Error Handling`
  gives the unrecognized-identifier and empty-catalog paths exactly one next action each).
- P7.2: `metadata.version` starts at `1.0.0` (new skill).
- P6.1/P6.2: the single-vs-all-skills branch is a two-way decision (identifier present or
  absent) with both branches covered — already the shape of spec.md's FR-003/FR-006.

**Gate result**: PASS. No violation requires a Complexity Tracking entry.

## Project Structure

### Documentation (this feature)

```text
specs/006-help-skill/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md         # Phase 1 output (/speckit-plan command)
├── quickstart.md         # Phase 1 output (/speckit-plan command)
├── contracts/            # Phase 1 output (/speckit-plan command)
│   ├── catalog.schema.json        # Supersedes specs/001's entry schema: adds "usage"
│   └── help-output-contract.md    # Exact single-skill / all-skills text formats
└── tasks.md              # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
# Option 1: Single project (this feature's actual layout)
.highway/
├── skills/
│   ├── _authoring-standard.md         # updated: document `usage` field + `## Example` section
│   └── help/
│       └── SKILL.md                   # NEW: the first real skill
├── tools/
│   ├── validate-skill.sh              # updated: enforce usage + Example like description/Purpose
│   ├── generate-catalog.sh            # updated: emit `usage` per entry
│   ├── generate-agent-adapters.sh     # unchanged; run against the new skill
│   ├── lib/
│   │   ├── frontmatter.sh             # unchanged (fm_get already reads arbitrary scalar keys)
│   │   └── schema-validate.sh         # updated: SV_REQUIRED_SECTIONS += "Example"; new sv_validate_usage
│   └── tests/
│       ├── fixtures/valid-skill/SKILL.md          # updated: add usage + Example so it still passes
│       ├── fixtures/invalid-skill-missing-usage/  # NEW fixture
│       ├── fixtures/invalid-skill-missing-example/# NEW fixture
│       ├── validate-skill.test.sh                 # updated: new fixture assertions
│       └── generate-catalog.test.sh               # updated: assert `usage` present in output
└── catalog/
    ├── index.json                     # regenerated: `help` entry + `usage` field on every entry
    └── index.md                       # regenerated

# Generated (by .highway/tools/generate-agent-adapters.sh, all 3 supported agents):
.github/skills/help/SKILL.md
.claude/skills/help/SKILL.md
.cursor/rules/help.mdc
```

**Structure Decision**: Single project, matching every prior feature in this repository (001-005).
No `src/`/`tests/` split exists or is introduced; all logic lives under `.highway/tools/` and its
`lib/`/`tests/` subdirectories, consistent with the existing toolchain. The only new
repository-root-visible artifacts are the three generated agent adapter files, produced by the
existing generator — not hand-authored — satisfying the explicit "implemented by all supported
coding agents" requirement without inventing a new mechanism.

## Complexity Tracking

> Fill ONLY if Constitution Check has violations that must be justified

No violations. Table intentionally omitted.

## Post-Design Constitution Check

*Re-evaluated after Phase 1 (data-model.md, contracts/, quickstart.md).*

- The new registration fields (`usage` frontmatter, `## Example` body section) are enforced by
  extending the same, already-`[auto]`/`[agent-checkable]`-tiered mechanism that enforces
  `description`/`## Purpose` today (research.md R7) — no new rule category, no new gate
  triggered.
- `contracts/catalog.schema.json` (superseding) and `contracts/help-output-contract.md` add no
  MUST-level rule to any *skill*; they constrain tooling and the `help` skill's own output
  format, which is where P7.4's 12-MUST-level-rule cap and P7.5's 400-word-per-section cap will
  be checked once `help/SKILL.md` is authored (task-level, not plan-level).
- Quickstart step 8 (empty-catalog rendering) and step 6 (unrecognized identifier) confirm the
  Error Handling section's two failure paths each resolve to one next action (P5.1-P5.3),
  satisfying Principle V without new gate exposure.
- **Gate result**: PASS, unchanged from the pre-design check. No Complexity Tracking entry
  required.
