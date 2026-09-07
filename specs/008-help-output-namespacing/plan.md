# Implementation Plan: Help Output Namespacing

**Branch**: `008-help-output-namespacing` | **Date**: 2026-09-07 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/008-help-output-namespacing/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Two coupled corrections. First, `generate-agent-adapters.sh`'s namespace prefix separator
changes from a dot (`highway.<id>`, shipped by specs/007-highway-skill-namespace) to a hyphen
(`highway-<id>`), across all three agents, because compatibility research (research.md R1) found
GitHub Copilot's Agent Skills spec requires a skill's directory/name to contain only lowercase
letters, numbers, and hyphens and to match exactly — a rule a dotted directory can never satisfy.
Second, the `help` skill's own output stops copying its `Name:` field verbatim from frontmatter
and instead computes it as `highway-<id>` from the catalog `id`, and its `Usage:`/`Help:`/
`Example:` fields are corrected to reference the same hyphen-namespaced invocation form, with the
`Example:` value presented as an inline code span so it is independently copy-able. No skill's
directory-derived `id` or catalog schema changes (FR-012); this feature only changes generated
adapter paths and the help skill's own authored/computed output.

## Technical Context

**Language/Version**: Bash 3.2.57 (macOS default `/bin/bash`) for the generator change — same
floor as the rest of `.highway/tools/`. The help-output change itself is agent-interpreted prose
(the `help` skill has no script; a coding agent constructs its response by following
`.highway/skills/help/SKILL.md`'s Inputs/Outputs instructions at request time), so it has no
language/runtime of its own beyond the Markdown+YAML the skill is authored in.

**Primary Dependencies**: None beyond the coreutils already used by `.highway/tools/`
(`awk`, `sed`, `grep`, `sha256sum`/`shasum`, `mktemp`). No new runtime dependency.

**Storage**: Flat files only — `.highway/tools/.adapter-manifest`, the three generated adapter
artifacts per skill, `.highway/catalog/index.json`, and `.highway/skills/help/SKILL.md`. No
database.

**Testing**: `.highway/tools/tests/*.test.sh`, run by `.highway/tools/tests/run-all.sh`. The same
two files feature 007 updated (`generate-agent-adapters.test.sh`,
`new-agent-extensibility.test.sh`) change again, this time asserting the hyphen form.

**Target Platform**: Local developer/agent CLI environment (macOS/Linux), consumed by GitHub
Copilot, Claude Code, and Cursor as installed skill/rule files.

**Project Type**: Single project — a bash generator correction plus a help-skill content/contract
correction. No frontend/backend split, no new skill authored.

**Performance Goals**: N/A — same bounded-by-skill-count scan the generator already performs;
help output construction is already O(1) (single-skill) or O(n) (all-skills, per specs/006 R1).

**Constraints**: MUST NOT change any skill's directory-derived `id` or `.highway/catalog/index.json`'s
schema (FR-012 carries forward specs/007's FR-003/FR-004 invariant). MUST NOT touch the vendored
`speckit-*` skills under `.github/skills/` (carried forward from specs/007's FR-009). MUST
preserve idempotency: a second consecutive generator run reports zero drift (carried forward from
specs/007's FR-006/FR-008).

**Scale/Scope**: One tool file (`generate-agent-adapters.sh`) re-changed, one superseding
generator contract doc, two test files re-updated, one skill (`help`) content-corrected, one
superseding help-output contract doc, one authoring-standard clarification for the `## Example`
section's copy-able formatting, zero new skills.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The generator-side change (namespace separator) changes no skill's content, exactly like specs/007:
**N/A (N1)**, no Purpose/rule text is authored or modified by that half of this feature.

The help-skill-side change edits `.highway/skills/help/SKILL.md`'s frontmatter `usage` field,
`## Example` section text, and the source used to construct the `Name:` output (frontmatter
`name` → computed `highway-<id>`) — this is skill content, so the constitution's Skill Authoring
Workflow does apply to that edit. Relevant gates:
- P7.7 (breaking change MUST increment MAJOR per the Skill Versioning Policy): this changes both
  `## Inputs` (what feeds the `Name:` field) and the literal, previously-documented value of
  `Name:`/`Usage:`/`Help:`/`Example:` for every existing caller — a breaking change per the
  constitution's Definitions, so `help`'s `metadata.version` bumps MAJOR (1.0.0 → 2.0.0), not
  PATCH (research.md R6).
- P1.3 (25 words or fewer per normative rule), P3.1 (Approved Authority Source citation per
  MUST-level rule): unaffected — the edited fields are descriptive text, not new normative rules.
- Five Quality Gates (Code Generation, Testing, Security, Maintainability, Performance): Testing
  applies (the existing shell test suite must still exit 0, plus updated assertions); the other
  four are **N/A (N1)** — no code is generated, no security-relevant behavior changes, and
  performance is unaffected.

**Gate result**: PASS. `help`'s version bump to 2.0.0 is recorded in data-model.md and executed
as a task; no Complexity Tracking entry required.

## Project Structure

### Documentation (this feature)

```text
specs/008-help-output-namespacing/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
│   ├── agent-adapter-contract.md   # Supersedes specs/007's contract: hyphen target paths
│   └── help-output-contract.md     # Supersedes specs/006's contract: computed Name, hyphen
│                                     Usage/Help, inline-code Example
└── tasks.md              # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
# Option 1: Single project (this feature's actual layout)
.highway/
├── skills/
│   └── help/
│       └── SKILL.md                  # updated: usage text + ## Example use highway-help
└── tools/
    ├── generate-agent-adapters.sh    # updated: AGENT_TARGET_TEMPLATES separator "." -> "-"
    └── tests/
        ├── generate-agent-adapters.test.sh   # updated: expect highway-<id> target paths
        └── new-agent-extensibility.test.sh   # updated: expect highway-<id> target paths

.highway/skills/_authoring-standard.md  # updated: ## Example row clarifies inline-code form

# Generated (regenerated by .highway/tools/generate-agent-adapters.sh, replacing the
# dot-namespaced files at the OLD paths shown, which are removed):
.github/skills/highway-help/SKILL.md   # was .github/skills/highway.help/SKILL.md
.claude/skills/highway-help/SKILL.md   # was .claude/skills/highway.help/SKILL.md
.cursor/rules/highway-help.mdc         # was .cursor/rules/highway.help.mdc
```

**Structure Decision**: Single project, matching every prior feature in this repository
(001-007). No `src/`/`tests/` split exists or is introduced. `generate-agent-adapters.sh`, its two
directly-affected test files, `.highway/skills/help/SKILL.md`, and
`.highway/skills/_authoring-standard.md` change; `validate-skill.sh`, `generate-catalog.sh`, the
catalog schema, and every other skill source file are untouched, per FR-012.

## Complexity Tracking

> Fill ONLY if Constitution Check has violations that must be justified

No violations. Table intentionally omitted.

## Post-Design Constitution Check

*Re-evaluated after Phase 1 (data-model.md, contracts/, quickstart.md).*

- `contracts/agent-adapter-contract.md` (superseding) adds no MUST-level rule to any *skill* — it
  constrains generation tooling only, so it does not trigger the Skill Authoring Workflow.
- `contracts/help-output-contract.md` (superseding) changes `help`'s own `## Inputs` (Name
  source), authored `usage` text, and `## Example` section content, plus its `metadata.version`
  MAJOR bump (P7.7) — within the Skill Authoring Workflow. No new normative rule is added to
  `help`'s body; the edited text is descriptive (usage guidance, an example), not a rule line, so
  P1.1-P1.4 and P3.1/P3.2 do not apply to it.

**Gate result**: PASS. No Complexity Tracking entry required.

