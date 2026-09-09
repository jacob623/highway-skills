# Implementation Plan: Highway NFR Management

**Branch**: `020-highway-nfrs` | **Date**: 2026-09-08 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/020-highway-nfrs/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Ship a `highway-nfrs` skill that manages a repository-wide NFR baseline in
`library/governance/` at the project root, sibling to `.highway/`. The skill will mirror the
settled Controls model: individual Markdown records with YAML frontmatter, a deterministic prose
catalog carrying the baseline version and identifier high-water mark, and Set/Add/Update/Remove
actions. It will reserve `controls: []` without populating relationships, and the existing
`highway-controls` skill will gain reciprocal routing advice for NFR-shaped statements.

The design keeps user-owned governance outside Highway's library validation boundary while treating
the skill, its tests, catalogs, adapters, manifests, and routing change as Highway artifacts.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill instructions; Bash 3.2.57 for repository tests and any tool changes

**Primary Dependencies**: Existing Highway skill, catalog, adapter, distribution, and test tooling; no new runtime dependency

**Storage**: User NFR files under `<project>/library/governance/`; skill source under `.highway/skills/highway-nfrs/`

**Testing**: `.highway/tools/tests/run-all.sh` plus focused governance, routing, catalog, and registration checks

**Target Platform**: Distributed Highway tree running on macOS Bash 3.2.57 and compatible shell utilities

**Project Type**: Agent skill and repository governance authoring workflow

**Performance Goals**: Complete ordinary baseline mutations and catalog generation in one interactive invocation; no throughput target applies

**Constraints**: Root-level containment; no timestamp in the catalog; one baseline version; immutable non-reused identifiers; named confirmation before loss; no relationship writes in this phase; skill content must satisfy the Highway Skills Constitution and Experience Standard

**Scale/Scope**: One new skill, one reciprocal change to `highway-controls`, focused tests, generated catalog/adapters/manifests, and user-owned NFR artifacts

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates

| Gate | Trigger | Verdict |
|---|---|---|
| **Packaging Gate** | Touches shipped paths - yes | **PASS** - no development path may be referenced by shipped artifacts; generated and packaged paths will be checked |
| **Toolchain Gate** | Touches `.highway/tools/` - yes | **PASS** - changes use Bash 3.2.57 and the declared utility set; no runtime dependency is added |
| **Generator Gate** | Touches a `generate-*.sh` script - likely yes during registration | **PASS on completion** - every generated output will be regenerated and compared |
| **Correspondence Gate** | Adds/modifies `.highway/skills/` input - yes | **PASS on completion** - catalog, three adapters, adapter rows, and distribution rows will correspond to the new skill |
| **Validation Gate** | Adds or modifies validation checks - yes | **PASS** - new fixtures are evaluated before checks are enabled; existing assertions are not weakened |
| **Spec Record Gate** | Touches `specs/` - yes | **PASS** - feature 020 follows 019 and this completed spec record will not be edited during implementation |
| **Skill Content Gate** | Creates/modifies `.highway/skills/` - yes | **Delegated to the Highway Skills Constitution below; validate P1-P8 and Experience Standard X rules during implementation** |

### Skill content gate - implementation obligations

| Rule | Relevance | Planned control |
|---|---|---|
| `P1.1-P1.7` | The skill has many action and failure paths | Keep each normative rule atomic; name inputs and explicit error actions |
| `P3.1-P3.5` | Normative skill rules need approved grounding | Cite repository policy files using the approved citation format |
| `P5.1-P5.6` | Add, Set, Update, Remove, confirmation, and ambiguity paths fail differently | Map every step to one error action and keep retries bounded |
| `P6.1-P6.6` | Classification and action selection must be deterministic | Use ordered decision tables with explicit otherwise branches |
| `P7.1-P7.6` | The skill is behavior-rich | Measure MUST count and normative section sizes; split only if required |
| `P8.1-P8.7` | The workflow must be repeatable | Number steps, declare ordering, and include Verification |
| `X2.1`, `X4.1`, `X6.1` | Loss confirmation, declared output, and deterministic catalog | Name each lost NFR, declare artifacts, and omit timestamps |

**Gate result**: proceed to research. No unresolved clarification remains in the feature
specification; the implementation choices above are grounded in the existing Controls feature.

## Project Structure

### Documentation (this feature)

```text
specs/020-highway-nfrs/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
.highway/
├── skills/highway-nfrs/SKILL.md          # new shipped skill
├── skills/highway-controls/SKILL.md      # reciprocal routing guidance
└── tools/tests/                           # focused behavior and registration checks

library/governance/                       # user-owned, never shipped or library-validated
├── nfrs.md                                # generated NFR catalog
└── nfrs/NFRXXXXXX.md                      # individual NFR records

.github/skills/highway-nfrs/               # generated adapter
.claude/skills/highway-nfrs/               # generated adapter
.cursor/rules/highway-nfrs.mdc             # generated adapter
```

**Structure Decision**: Follow the existing `highway-controls` layout. The authoring skill and
its generated artifacts are shipped Highway content; the NFR catalog and records are written at
the project root and remain user-owned. Registration is complete only when source, catalog,
adapters, adapter manifest rows, and distribution manifest rows correspond.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | No constitution violation is currently known or accepted. If the skill exceeds the P7.4/P7.5 limits, split along the Set action and record the measured reason before implementation continues. |

## Post-Design Constitution Re-check

The design does not change the pre-design verdicts.

- **Packaging Gate**: PASS on completion. The planned shipped files contain no references to
  `.specify/` or `specs/`, and the user-owned NFR directory is outside the package.
- **Toolchain Gate**: PASS on completion. Any script or test changes remain within Bash 3.2.57
  and the declared utility set.
- **Generator Gate**: PASS on completion. Catalog, adapters, and manifests are regenerated in the
  same change and checked for correspondence.
- **Correspondence Gate**: PASS on completion. The plan names the catalog, three adapters, adapter
  manifest rows, and distribution manifest rows required by D4.5 and D4.7.
- **Validation Gate**: PASS on completion. Focused fixtures cover the new behavior and existing
  fixtures remain part of the full suite.
- **Spec Record Gate**: PASS. Feature 020 is the next sequential directory and this record is not
  edited after completion.
- **Skill Content Gate**: PASS on completion. The implementation will validate the skill against
  the Highway Skills Constitution and Experience Standard, including the P7.4/P7.5 measurement
  decision and verification output.

No complexity exception is approved at planning time. If implementation measures a limit breach,
the breach must be resolved by the planned Set split or another explicitly recorded design change,
not by weakening a requirement.
