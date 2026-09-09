# Implementation Plan: Shared Output Templates

**Branch**: `022-shared-output-templates` | **Date**: 2026-09-09 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from [spec.md](spec.md)

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Add shared complete output skeletons for retained file artifacts, require file-emitting skills to
cite those templates, and require frontmatter on retained files. The feature adds the planned
`P9.1` authoring rule, `X1.5` experience rule, and `D8.1` dependent-review rule; migrates
`highway-nfrs` and `highway-controls` without changing their emitted contracts; then regenerates
the catalog and agent adapters. Research confirms that template citation is Layer 1, frontmatter
is Layer 2, and shared-artifact drift review is Layer 0.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Bash 3.2.57-compatible shell scripts and Markdown/YAML governance artifacts

**Primary Dependencies**: Existing Highway validators, rule-check library, generators, and test harness

**Storage**: Repository files under `.highway/` and feature records under `specs/022-shared-output-templates/`

**Testing**: `.highway/tools/tests/run-all.sh`, focused validator tests, adapter correspondence checks, and agent review

**Target Platform**: macOS and GNU/Linux environments supporting the declared Bash-compatible toolchain

**Project Type**: Packaged agent-skill framework with shell governance tooling

**Performance Goals**: Validation and correspondence checks complete within the existing full-suite execution envelope

**Constraints**: Preserve user-owned NFR/Control semantics; keep output templates separate from the questionnaire template; remain compatible with Bash 3.2.57; do not add runtime dependencies; do not edit completed specs 001-021

**Scale/Scope**: Two existing file-emitting skills, two new output templates, three governance amendments, generated catalog/adapters, and focused regression coverage

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates

| Gate | Rules | Verdict | Reason |
|---|---|---|---|
| Packaging Gate | D1.1, D1.2, D6.2 | PASS | The feature adds only distributed, self-contained library/templates and governance content; packaging validation remains required. |
| Toolchain Gate | D2.1-D2.4 | PASS | No new executable dependency is planned; existing Bash/toolchain constraints remain in force. |
| Validation Gate | D3.4, D3.5 | PASS | New P/X checks will be evaluated against existing fixtures before registration, and no assertion is weakened. |
| Spec Record Gate | D5.1-D5.4 | PASS | Feature 022 is a new sequential spec; completed specs 001-021 remain untouched. |
| Documentation Currency | D6.1-D6.2 | PASS | Governance plan and affected authoring/output documentation are updated with the rule decision and paths. |
| Skill Content Gate | D1.5 | PASS | The plan identifies the Highway Skills Constitution rules affected by skill/library changes and delegates content conformance to that constitution. |
| Generated Artifact Correspondence | D4.1-D4.7 | PASS | Source skills are updated first, then catalog/adapters/manifests are regenerated and checked for drift. |

### Skill-content gates

| Documented rule | Verdict | Evidence planned |
|---|---|---|
| P9.1 | PASS after amendment | Both file-emitting skills cite complete templates under `.highway/library/templates/output/` and remove duplicate structure prose. |
| X1.5 | PASS after amendment | Both retained output templates and emitted records begin with frontmatter; transient messages are excluded. |
| X1.1, X1.2, X4.1, X6.1 | PASS after migration | Outputs remain fully declared, match their templates, declare paths, and contain no undeclared runtime values. |
| Layer 3 containment | PASS | Templates govern structure only; user-owned record content remains outside Highway semantic validation. |

### Post-design re-check

The Phase 1 design introduces no unresolved clarification. It keeps `D8.1` agent-checkable rather
than inventing an automatic semantic comparison, and it adds the frontmatter obligation to the
Experience Standard rather than treating it as an authoring or development rule. No complexity
exception is required.

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Not created: no external API or command contract
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/
├── governance/
│   ├── constitution.md              # P9.1 amendment
│   └── experience-standard.md       # X1.5 amendment
├── library/templates/
│   └── output/
│       ├── nfr-record.md
│       └── control-record.md
├── skills/
│   ├── highway-nfrs/SKILL.md
│   └── highway-controls/SKILL.md
└── tools/
    ├── lib/rule-checks.sh           # P9.1/X1.5 registration as applicable
    ├── generate-catalog.sh
    ├── generate-agent-adapters.sh
    └── tests/
        ├── run-all.sh
        ├── adapter-coverage.test.sh
        └── focused template/experience tests

.specify/memory/constitution.md       # D8.1 amendment and enforcement map
.github/skills/                        # Generated adapters
.claude/skills/                        # Generated adapters
.cursor/rules/                         # Generated adapters
specs/022-shared-output-templates/     # Feature design records
```

**Structure Decision**: Extend the existing governance, library, skill, generator, adapter, and
test paths. No application source tree or external contract directory is needed because this is a
repository-internal shell-and-markdown governance feature.

## Complexity Tracking

No constitution violations require justification. The feature adds one new shared-template
subdirectory and extends existing governance documents and checks; it does not add a parallel
enforcement mechanism or external dependency.
