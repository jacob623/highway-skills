# Implementation Plan: Controls Record Lineage Cleanup

**Branch**: `108-controls-record-lineage` | **Date**: 2026-09-30 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/108-controls-record-lineage/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Correct the existing 4.0.0 Controls contract by renaming retained recommendation lineage to
Recommendation Grounding, removing one duplicated revalidation paragraph and one duplicated common
failure sentence, and preserving the four-field collection result and simplified NFR boundary.
Rename the optional retained Control-record body section and bump `control-record.md` metadata from
`1.0.0` to `2.0.0`; keep Control frontmatter and `highway-controls` at their existing contracts.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill and output-template contracts with Bash 3.2-compatible validation

**Primary Dependencies**: `highway-controls`, shared Control-record template, generated adapters/catalogs, and shell tests

**Storage**: User-owned Markdown Control records under `library/governance/`

**Testing**: Focused Controls/template/dependency tests and `.highway/tools/tests/run-all.sh`

**Target Platform**: Highway distributed skill trees on macOS and GNU/BSD shell environments

**Project Type**: Documentation-driven governance skill suite

**Performance Goals**: No new runtime performance target; preserve deterministic validation and generation

**Constraints**: No frontmatter schema addition; no restoration of `Created Control IDs`; generated artifacts regenerated from canonical sources; dependent template references updated; no duplicate shared-governance rules

**Scale/Scope**: Controls skill, Control-record template, dependent catalog metadata, generated adapters, and focused/full tests

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Skill Content Gate — PASS**: the change corrects `.highway/skills/highway-controls/SKILL.md`
  while preserving its `4.0.0` semantic version and shared governance ownership.
- **Shared Library Dependency Review — PASS**: changing `control-record.md` requires revalidation
  of every citing skill and update of its generated library catalog entry.
- **Correspondence Gate — PASS**: generated adapters and catalogs will be regenerated after canonical
  skill/template changes.
- **Packaging Gate — PASS**: shipped skill, library, catalog, and adapter paths are affected and
  will be validated as a distributed tree.
- **Validation Gate — PASS**: focused assertions will be updated for the intentional terminology,
  collection-result, and duplicate-rule corrections.
- **Toolchain Gate — N/A**: no implementation script or runtime dependency changes.

## Project Structure

### Documentation (this feature)

```text
specs/108-controls-record-lineage/
├── plan.md              # This file (/speckit-plan command output)
├── spec.md
├── checklists/requirements.md
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/skills/highway-controls/SKILL.md
.highway/library/templates/output/control-record.md
.highway/catalog/library-index.json
.highway/catalog/library-index.md
.highway/tools/tests/
.github/skills/highway-controls/SKILL.md
.claude/skills/highway-controls/SKILL.md
.cursor/skills/highway-controls/SKILL.md
.agents/skills/highway-controls/SKILL.md
```

**Structure Decision**: Canonical skill and template files are authoritative. Generated adapters and
catalogs are refreshed from those sources. User-owned Control records remain outside `.highway/`.

## Complexity Tracking

No Constitution violations require justification. The template version bump is an intentional
retained-record contract correction selected during clarification.

## Post-Design Constitution Check

PASS. The design keeps accepted Control content separate from Recommendation Grounding lineage,
adds no frontmatter field, keeps common failure behavior in the Constitution, preserves the
four-field collection result and 4.0.0 Controls version, and updates generated/template-dependent
artifacts through their declared generators.
