# Implementation Plan: Controls Skill Update

**Branch**: `107-controls-skill-update` | **Date**: 2026-09-30 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/107-controls-skill-update/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Rewrite the canonical `highway-controls` skill as a concise Control-owned contract. The change
preserves durable Control mutations and readiness while replacing fixed discovery with evidence-first
classification, grounded recommendations, direct recommendation acceptance, explicit setup/configure
continuation, and a narrow NFR candidate-generation handoff. Generic interaction, governance, and
development rules remain in their authoritative shared documents. The Controls skill moves from
metadata version `3.0.0` to `4.0.0`; an optional `## Provenance` body section is added to the
Control record template, never to frontmatter.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill contracts with Bash 3.2-compatible validation scripts

**Primary Dependencies**: Existing Highway skills, shared templates, catalogs, and shell test suite

**Storage**: User-owned Markdown Control records and catalog under `library/governance/`

**Testing**: `.highway/tools/tests/run-all.sh` plus focused Controls, template, adapter, and setup/NFR contract tests

**Target Platform**: Highway distributed skill trees on macOS and GNU/BSD shell environments

**Project Type**: Documentation-driven governance skill suite

**Performance Goals**: No new runtime performance target; preserve deterministic, bounded interaction and catalog generation

**Constraints**: Bash 3.2 compatibility; generated adapters must be regenerated; shared-template dependents must be revalidated; no hand-edited generated artifacts; no duplicate Constitution or Experience Standard rules

**Scale/Scope**: Canonical Controls skill, four generated adapters, Control record template, Setup/NFR owner contracts, focused tests, and related catalogs/documentation

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates:

- **Skill Content Gate — PASS**: the change modifies `.highway/skills/highway-controls/SKILL.md`;
  the design cites applicable Highway Skills Constitution rules P1.1, P1.3, P1.5, P4.1,
  P5.1/P5.3/P5.12/P5.14, P6.1/P6.2/P6.5/P6.6, P7.2/P7.3/P7.4/P7.5/P7.7,
  P8.2/P8.3/P8.4, P9.1/P9.2/P9.3/P9.6/P9.7, P10.1, P11.1-P11.4, and
  P12.5-P12.12.
- **Correspondence Gate — PASS**: the canonical skill is a declared generator input; all four
  adapters and catalog/manifests will be regenerated and checked.
- **Packaging Gate — PASS**: shipped skill, library, catalog, and adapter paths are affected;
  distribution validation and cross-reference checks remain required.
- **Shared Library Dependency Review — PASS**: changing `control-record.md` requires revalidation
  of `highway-controls` and every other skill that cites the template.
- **Validation Gate — PASS**: existing focused tests will be amended or extended for the changed
  Control, Setup, NFR, template, adapter, and removal contracts.
- **Toolchain Gate — N/A**: no `.highway/tools/` implementation script is changed by the design.

## Project Structure

### Documentation (this feature)

```text
specs/107-controls-skill-update/
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
.highway/
├── skills/highway-controls/SKILL.md
├── skills/highway-setup/SKILL.md
├── skills/highway-nfrs/SKILL.md
├── library/templates/output/control-record.md
├── library/templates/output/control-catalog.md
└── tools/tests/

.github/skills/highway-controls/SKILL.md
.claude/skills/highway-controls/SKILL.md
.cursor/skills/highway-controls/SKILL.md
.agents/skills/highway-controls/SKILL.md
```

**Structure Decision**: This is a documentation-driven contract change. The canonical `.highway/`
files are authoritative; adapters are generated copies; user-owned records remain outside `.highway/`.

## Complexity Tracking

No Constitution violations require justification. The optional provenance body section is a
deliberate retained-record extension requested by the feature and does not add a frontmatter field,
new runtime dependency, or separate provenance artifact.

## Post-Design Constitution Check

PASS. The design keeps shared interaction and failure rules in the Experience Standard and Skills
Constitution, gives Controls explicit ordered decisions, preserves owner-controlled readiness and
handoff, declares all influencing context, keeps retained files frontmattered, and makes the
optional provenance body section derive only from accepted grounding. The version bump to `4.0.0`
satisfies the breaking-change rule. The collection contract removes `Created Control IDs` and
requires Setup to consume only the declared collection result and fresh readiness.
