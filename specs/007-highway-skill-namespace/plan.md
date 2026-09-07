# Implementation Plan: Highway Skill Namespace

**Branch**: `007-highway-skill-namespace` | **Date**: 2026-09-07 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/007-highway-skill-namespace/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Every skill authored under `.highway/skills/` (currently just `help`) must be identified to each
supported coding agent as `highway.<id>` instead of the bare `<id>`. Empirical evidence gathered
in this planning phase (research.md R1) shows the coding-agent-facing identifier is read from the
generated adapter artifact's **directory/file path segment**, not from the frontmatter `name:`
field — so the mechanism is a one-line-per-agent change to `generate-agent-adapters.sh`'s
`AGENT_TARGET_TEMPLATES`, prefixing each generated path's `<id>` component with `highway.`
(`.github/skills/highway.<id>/SKILL.md`, `.claude/skills/highway.<id>/SKILL.md`,
`.cursor/rules/highway.<id>.mdc`), plus removing any stale, previously-generated non-namespaced
artifact so it doesn't linger as a duplicate, unprefixed listing. No skill source content,
internal id, or catalog field changes (FR-003/FR-004).

## Technical Context

**Language/Version**: Bash 3.2.57 (macOS default `/bin/bash`) — same floor as the rest of
`.highway/tools/`; no `${var^}`, no associative arrays, no unguarded `"${arr[@]}"` under `set -u`.

**Primary Dependencies**: None beyond the coreutils already used by `.highway/tools/`
(`awk`, `sed`, `grep`, `sha256sum`/`shasum`, `mktemp`). No new runtime dependency.

**Storage**: Flat files only — the manifest at `.highway/tools/.adapter-manifest` (tab-separated
rel_path/id/version/hash rows) and the three generated adapter artifacts per skill. No database.

**Testing**: `.highway/tools/tests/*.test.sh`, the existing hand-rolled shell test harness, run
by `.highway/tools/tests/run-all.sh`. Two existing files directly assert generated target paths
and must be updated: `generate-agent-adapters.test.sh` and `new-agent-extensibility.test.sh`.

**Target Platform**: Local developer/agent CLI environment (macOS/Linux), consumed by GitHub
Copilot, Claude Code, and Cursor as installed skill/rule files.

**Project Type**: Single project — a bash-based generation toolchain change. No frontend/backend
split, no new skill authored.

**Performance Goals**: N/A — same bounded-by-skill-count scan the generator already performs.

**Constraints**: MUST NOT change `validate-skill.sh`, `generate-catalog.sh`, or the catalog's
`id`/`source_path` fields (FR-003). MUST NOT write the prefix into any source
`.highway/skills/<id>/SKILL.md` file (FR-004). MUST preserve idempotency: a second consecutive
run reports zero drift (FR-006). MUST NOT touch the vendored `speckit-*` skills under
`.github/skills/` (FR-009).

**Scale/Scope**: One tool file (`generate-agent-adapters.sh`) changed, one superseding contract
doc, two test files updated, one fixture regenerated at its new namespaced path, zero new skills.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

This feature changes no skill's content — `.highway/skills/help/SKILL.md` is untouched (FR-004)
— so the constitution's Skill Authoring Workflow and its five Quality Gates (Code Generation,
Testing, Security, Maintainability, Performance) apply to skill *content* and are **N/A (N1)**
here: there is no skill body, Purpose, or rule text being authored or modified by this feature.

The change is to generation tooling only, validated the same way every prior tooling change in
this repository has been validated: the existing shell test suite (`run-all.sh`) must continue to
exit 0 (FR-008), plus new/updated assertions for the namespaced paths and the stale-path cleanup
behavior. This is a test-suite obligation, not a constitution gate.

**Gate result**: PASS (N/A). No Complexity Tracking entry required.

## Project Structure

### Documentation (this feature)

```text
specs/007-highway-skill-namespace/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
│   └── agent-adapter-contract.md  # Supersedes specs/001's contract: namespaced target paths
└── tasks.md              # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
# Option 1: Single project (this feature's actual layout)
.highway/
└── tools/
    ├── generate-agent-adapters.sh     # updated: AGENT_TARGET_TEMPLATES gain "highway." prefix;
    │                                   new stale-old-path removal step
    └── tests/
        ├── generate-agent-adapters.test.sh   # updated: expect highway.<id> target paths
        └── new-agent-extensibility.test.sh   # updated: expect highway.<id> target paths

# Generated (regenerated by .highway/tools/generate-agent-adapters.sh, replacing the
# non-namespaced files at the OLD paths shown, which are removed):
.github/skills/highway.help/SKILL.md   # was .github/skills/help/SKILL.md
.claude/skills/highway.help/SKILL.md   # was .claude/skills/help/SKILL.md
.cursor/rules/highway.help.mdc         # was .cursor/rules/help.mdc
```

**Structure Decision**: Single project, matching every prior feature in this repository
(001-006). No `src/`/`tests/` split exists or is introduced. Only `generate-agent-adapters.sh`
and its two directly-affected test files change; `validate-skill.sh`, `generate-catalog.sh`, the
catalog, and every skill source file are untouched, per FR-003/FR-004.

## Complexity Tracking

> Fill ONLY if Constitution Check has violations that must be justified

No violations. Table intentionally omitted.

## Post-Design Constitution Check

*Re-evaluated after Phase 1 (data-model.md, contracts/, quickstart.md).*

- `contracts/agent-adapter-contract.md` (superseding) adds no MUST-level rule to any *skill* — it
  constrains generation tooling only, so it does not trigger the Skill Authoring Workflow.
- The stale-old-path removal step (research.md R3) reuses the existing drift-detection safety
  invariant (`check_no_drift`-equivalent guard) before deleting anything, so it introduces no new
  unguarded file-system write.
- **Gate result**: PASS (N/A), unchanged from the pre-design check. No Complexity Tracking entry
  required.
