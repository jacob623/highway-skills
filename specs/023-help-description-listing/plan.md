# Implementation Plan: Help Description Listing

**Branch**: `023-help-description-listing` | **Date**: 2026-09-09 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from [spec.md](spec.md)

## Summary

Change the no-argument `highway-help` listing to render each catalog entry's description under
`Description:` instead of `Usage:`. Keep the named-skill six-line response unchanged, update the
source skill contract at `.highway/skills/highway-help/SKILL.md` and focused regression coverage,
then regenerate the generated catalogs and generated adapters.

## Technical Context

**Language/Version**: Bash 3.2.57-compatible shell scripts and Markdown/YAML governance artifacts

**Primary Dependencies**: Existing Highway skill validator, catalog generator, adapter generator, and shell test harness

**Storage**: Repository files under `.highway/` and design records under `specs/023-help-description-listing/`

**Testing**: `.highway/tools/validate-skill.sh`, focused shell tests, adapter correspondence checks, and `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS and GNU/Linux environments supporting the declared Bash-compatible toolchain

**Project Type**: Packaged agent-skill framework with shell governance tooling

**Performance Goals**: Preserve the existing O(n) catalog listing behavior and current suite execution envelope

**Constraints**: Change only All-Skills presentation; preserve Single-Skill, empty-catalog, and unknown-identifier contracts; regenerate derived artifacts; avoid runtime dependencies and Bash-incompatible constructs

**Scale/Scope**: One source skill, its focused regression coverage, generated catalog/adapters, and Feature 023 design records

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Development gates

| Gate | Rules | Verdict | Reason |
|---|---|---|---|
| Shippability | D1.1, D1.2, D1.5 | PASS | The source skill and generated outputs remain self-contained and the plan records the Layer 1 check. |
| Toolchain | D2.1-D2.4 | PASS | No new dependency or shell feature is planned. |
| Verification | D3.1-D3.6 | PASS | Start and end with the full suite, add focused regression coverage, and observe the behavior check fail before implementation. |
| Generated correspondence | D4.1-D4.7 | PASS | Source changes are followed by catalog and adapter regeneration and correspondence validation. |
| Spec integrity | D5.1-D5.4 | PASS | Feature 023 is the next sequential record and completed prior specs remain untouched. |
| Completion integrity | D7.1-D7.3 | PASS | Implementation tasks will name artifacts, map requirements exactly, and report coverage separately from test results. |

### Shipped skill gates

| Rule | Verdict | Evidence planned |
|---|---|---|
| P7.1, P7.2 | PASS | `highway-help` retains one Purpose and a valid semantic version. |
| P9.1 | PASS | This change does not emit a retained file; its output is transient help text. |
| X1.1-X1.3, X5.1 | PASS after change | All-Skills and Single-Skill output shapes, empty results, and useful help commands remain explicit. |

### Post-design re-check

The Phase 1 design has no unresolved clarifications or constitution violations. The change is a
label/value-source correction within an existing transient response contract; no complexity
exception is required and no external contract directory is needed.

## Project Structure

### Documentation (this feature)

```text
specs/023-help-description-listing/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── checklists/requirements.md
└── tasks.md                 # Phase 2 output; not created by /speckit-plan
```

### Source and validation paths

```text
.highway/
├── skills/highway-help/SKILL.md       # source contract
├── catalog/                            # generated registry outputs
├── tools/tests/                        # focused and full validation
├── tools/generate-catalog.sh           # catalog generator
└── tools/generate-agent-adapters.sh    # adapter generator

.github/skills/                         # generated adapter tree
.claude/skills/                         # generated adapter tree
.cursor/rules/                          # generated adapter tree
```

**Structure Decision**: Extend the existing Markdown skill contract and shell test/generator
paths. This is a repository-internal documentation and governance change with generated
distribution artifacts at `.highway/catalog/`, `.github/skills/`, `.claude/skills/`, and
`.cursor/rules/`, not an application or external API feature.

## Complexity Tracking

No constitution violations require justification. The plan reuses the existing catalog, adapter,
validator, and test mechanisms and changes one presentation label in one source skill.
