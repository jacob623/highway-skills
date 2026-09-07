# Implementation Plan: Skill Id Namespace Alignment

**Branch**: `009-skill-id-namespace-alignment` | **Date**: 2026-09-07 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/009-skill-id-namespace-alignment/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Rename the `help` skill's canonical source directory from `.highway/skills/help/` to
`.highway/skills/highway-help/` and its frontmatter `name` from `Help` to `highway-help`, so the
canonical directory name, the catalog `id`, and every generated agent adapter's target basename
are the same literal string with no separate namespace-prefix computation anywhere. Retire the
prefix-injection this repository's tooling used since specs/007/008 (`AGENT_TARGET_TEMPLATES`
substituting `highway-%s` against a bare id) in favor of a plain `%s` substitution against an
already-namespaced id — the generated adapter paths are byte-identical before and after, since the
static `highway-` the templates used to inject is now carried by the id itself. Add a new,
`[SCHEMA]`-tier check to `validate-skill.sh` that fails any skill whose frontmatter `name` does
not exactly equal its directory-derived id, and document the now-mandatory pairing in
`_authoring-standard.md` so every future skill is authored already-compliant.

## Technical Context

**Language/Version**: Bash 3.2.57 (macOS default `/bin/bash`) — no associative arrays, no `mapfile`; indexed arrays and `[[ ]]` only. Unchanged constraint from every prior `.highway/tools/` feature.

**Primary Dependencies**: None beyond coreutils already used by `.highway/tools/` (`sha256sum`/`shasum`, `awk`, `grep`, `sed`). No new dependency introduced.

**Storage**: Flat files only — `.highway/skills/highway-help/SKILL.md` (renamed source of truth), `.highway/catalog/index.json`/`index.md` (regenerated), `.highway/tools/.adapter-manifest` (regenerated rows), generated agent adapter files. N/A otherwise.

**Testing**: Existing bash test scripts under `.highway/tools/tests/`, run via `.highway/tools/tests/run-all.sh`. No new test framework.

**Target Platform**: macOS/Linux shell (development tooling only; not a runtime service).

**Project Type**: Single internal framework/tooling project (`.highway/` skill-authoring and adapter-generation tooling). No frontend/backend split.

**Performance Goals**: N/A — file-count-bound (currently one skill), not a performance-sensitive path.

**Constraints**: MUST remain Bash 3.2-compatible. MUST NOT change the resulting agent-facing identifier for the `help` skill (still `highway-help`) — only where that identifier is authored and validated. MUST NOT leave the generator able to double-prefix an already-namespaced id.

**Scale/Scope**: One skill migrated (`help` → `highway-help`); one new validation rule; applies to all skills registered in `.highway/catalog/index.json`, present and future.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **P7.7** (breaking change MUST increment MAJOR per Skill Versioning Policy): The `help` skill's
  contract changes in a way the Skill Versioning Policy classifies as a breaking change — the
  previously valid self-invocation `/highway-help help` becomes an unrecognized-identifier error,
  and the `Name:` field's computation source changes from a `highway-<id>` string-concatenation to
  a verbatim catalog `id` read. Both redefine/narrow an existing behavioral guarantee (Definitions:
  Breaking change). **Gate**: the `help` skill's `metadata.version` MUST increment MAJOR
  (2.0.0 → 3.0.0). Planned; satisfied in Phase 1 (data-model.md) and enforced in tasks.md.
- **P7.3** (rule text lives only in the constitution; other docs cite rule ids): This feature adds
  a new `[SCHEMA]`-tagged check (not a constitution principle) to `validate-skill.sh`, following
  the existing precedent of `sv_validate_id`/`sv_validate_description`/`sv_validate_usage` — no
  constitution amendment needed, no rule-id citation drift risk. PASS.
- **No other gate is implicated**: this feature touches tooling (`validate-skill.sh`,
  `generate-agent-adapters.sh`), one skill's content, and documentation
  (`_authoring-standard.md`); it does not add a new normative constitution rule, does not touch
  Security Gate triggers, and does not introduce a new agent target.

**Result**: PASS. No unjustified violation; Complexity Tracking is not needed.

## Project Structure

### Documentation (this feature)

```text
specs/009-skill-id-namespace-alignment/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
│   ├── skill-authoring-contract.md
│   ├── agent-adapter-contract.md
│   └── help-output-contract.md
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/
├── skills/
│   ├── _authoring-standard.md        # name-field row rewritten to a MUST-match rule
│   └── highway-help/                 # renamed from help/ (git mv)
│       └── SKILL.md                  # name: highway-help; Example/Outputs/Verification updated
├── catalog/
│   ├── index.json                    # regenerated: id/source_path become highway-help
│   └── index.md                      # regenerated
└── tools/
    ├── validate-skill.sh             # calls new sv_validate_name check
    ├── lib/schema-validate.sh        # new sv_validate_name function
    ├── generate-agent-adapters.sh    # AGENT_TARGET_TEMPLATES drop the "highway-" static prefix;
    │                                 # AGENT_OLD_TARGET_TEMPLATES / stale-removal retired
    ├── .adapter-manifest             # rows re-keyed to highway-help on next generation
    └── tests/
        ├── validate-skill.test.sh
        ├── generate-agent-adapters.test.sh
        ├── new-agent-extensibility.test.sh
        ├── generate-catalog.test.sh
        ├── authoring-standard.test.sh
        ├── coverage-summary.test.sh
        └── path-integrity.test.sh

.github/skills/highway-help/SKILL.md  # regenerated in place (path unchanged)
.claude/skills/highway-help/SKILL.md  # regenerated in place (path unchanged)
.cursor/rules/highway-help.mdc        # regenerated in place (path unchanged)
```

**Structure Decision**: No new top-level directories. This feature renames one existing skill
directory (`git mv .highway/skills/help .highway/skills/highway-help`), edits four tool/library
files, edits one documentation file, and regenerates two derived artifacts (catalog, adapters) —
all within the existing `.highway/` tooling layout established by specs/002 and used by every
feature since.

## Complexity Tracking

*No violations — section intentionally left without entries.*

