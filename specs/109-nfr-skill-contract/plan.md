# Implementation Plan: NFR Skill Contract Simplification

**Branch**: `109-nfr-skill-contract` | **Date**: 2026-09-30 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/109-nfr-skill-contract/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Rewrite the NFR runtime skill around NFR-owned candidate state, readiness, collection continuation,
recommendation grounding, relationship persistence, and the simplified Control/NFR ownership boundary.
Update the shared NFR record template to accepted-content placeholders and version `2.0.0`; increment
`highway-nfrs` from `10.0.0` to `11.0.0`. Preserve generated adapters, catalogs, relationship
semantics, and deterministic atomic persistence.

## Technical Context

**Language/Version**: Markdown skill/template contracts with Bash 3.2-compatible validation

**Primary Dependencies**: `highway-nfrs`, `nfr-record.md`, NFR catalog/candidate-state contracts,
`highway-controls`, `highway-setup`, relationship tooling, generated adapters/catalogs, shell tests

**Storage**: User-owned NFR records under `library/governance/`, NFR catalog under
`library/governance/nfrs.md`, and NFR-owned candidate state under `.highway/catalog/`

**Testing**: Focused NFR/template/relationship/readiness tests and `.highway/tools/tests/run-all.sh`

**Target Platform**: Highway distributed skill trees on macOS and GNU/BSD shell environments

**Project Type**: Documentation-driven governance skill suite

**Performance Goals**: No new runtime performance target; preserve deterministic ordering and atomic mutation

**Constraints**: Keep the Constitution and Experience Standard authoritative; do not restore `Created Control IDs`;
do not duplicate Controls-owned derivation; keep `controls` identifier-only; remove post-write verification
and obsolete development/runtime prose

**Scale/Scope**: NFR skill, candidate-state contract, NFR record template, dependent setup/control references,
generated adapters/catalogs, fixtures, focused tests, and full suite

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Skill Content Gate — PASS**: the change modifies `.highway/skills/highway-nfrs/SKILL.md` and
  `.highway/library/templates/output/nfr-record.md`; shared Constitution and Experience Standard ownership
  remains authoritative.
- **Shared Library Dependency Review — PASS**: every skill citing `nfr-record.md` will be revalidated after
  its placeholder and version changes.
- **Correspondence Gate — PASS**: the NFR skill, candidate-state input, generated adapters, and catalogs
  will be regenerated or validated after canonical changes.
- **Packaging Gate — PASS**: shipped NFR skill, template, catalog, and adapter paths are affected.
- **Validation Gate — PASS**: focused NFR, readiness, relationship, template, and ownership assertions will
  be updated for intentional contract changes.
- **Toolchain Gate — N/A**: no generator or shell-tool implementation changes are planned.

## Project Structure

### Documentation (this feature)

```text
specs/109-nfr-skill-contract/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/skills/highway-nfrs/SKILL.md
.highway/catalog/nfr-candidate-state.md
.highway/library/templates/output/nfr-record.md
.highway/library/templates/output/nfr-catalog.md
.highway/tools/tests/
.github/skills/highway-nfrs/SKILL.md
.claude/skills/highway-nfrs/SKILL.md
.cursor/skills/highway-nfrs/SKILL.md
.agents/skills/highway-nfrs/SKILL.md
```

**Structure Decision**: Canonical NFR skill, candidate-state contract, and NFR record template are
authoritative. Generated adapters and shared library catalogs are refreshed from canonical sources.
User-owned NFR records remain outside `.highway/`; candidate state remains framework-owned.

## Complexity Tracking

No Constitution violations require justification.

## Post-Design Constitution Check

PASS. The design keeps generic interaction and common failure behavior in the Constitution and
Experience Standard, defines NFR-owned candidate state once, preserves the Controls/NFR ownership
boundary and exact owner-result contracts, keeps NFR relationships identifier-only, updates every
shared-template dependency, and plans regeneration of all distributed outputs.
