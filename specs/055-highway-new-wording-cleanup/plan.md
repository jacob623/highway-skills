# Implementation Plan: Highway New Wording Cleanup

**Branch**: `055-highway-new-wording-cleanup` | **Date**: 2026-09-20 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/055-highway-new-wording-cleanup/spec.md`

## Summary

Correct the requester-facing `highway-new` wording introduced by Feature 054. Consolidate the
`allowed_solution_classes` rule, explicitly describe the three valid states for other list-shaped
fields, simplify the Solution Constraints field-error sentence, and use `No business constraints`
for explicit Business Constraints absence. The implementation updates the authoritative skill,
focused assertions, and generated adapters/catalog, then runs existing validation.

## Technical Context

**Language/Version**: Markdown skill instructions; Bash 3.2.57-compatible repository tooling

**Primary Dependencies**: Existing `highway-new` focused tests, output-template tests, skill and
library validators, catalog and adapter generators, distribution checks, and full test suite; no
new runtime dependency

**Storage**: Plain Markdown source, shared output templates, generated adapters/catalogs, and
user-owned Request records; no new storage

**Testing**: `.highway/tools/tests/highway-new.test.sh`,
`.highway/tools/tests/output-template.test.sh`, `validate-skill.sh`, `validate-library.sh`,
adapter coverage, shipped-tree independence, distribution packaging, and `run-all.sh`

**Target Platform**: macOS and Linux repository environments; generated adapters for GitHub Copilot,
Claude Code, and Cursor

**Project Type**: Internal agent skill and repository governance tooling

**Performance Goals**: Preserve one-question-per-turn behavior; no service latency or throughput
target

**Constraints**: Preserve evidence order, durable empty-state compatibility, `unknown` distinction,
generated correspondence, privacy behavior, transaction semantics, and Discovery/ADR ownership
boundaries

**Scale/Scope**: One Request conversation, seven evidence domains, eight existing Solution
Constraints fields, and four wording corrections; no external service scale requirement

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Rule | Requirement | How this feature satisfies it |
|---|---|---|
| D1.5 | Plans modifying skill or library files record a Constitution Check | This plan names the development and generated-artifact gates governing the change. |
| D2.1-D2.4 | Tooling remains Bash 3.2-compatible and adds no undeclared dependency | Changes use existing Markdown and shell tooling only. |
| D3.1-D3.6 | Baseline, behavioral tests, and observed failure evidence are maintained | Focused assertions cover each wording correction before and after implementation; the full suite is rerun. |
| D3.8 | Static contract checks are not presented as behavioral evidence | Wording assertions remain distinct from executable intake and validation checks. |
| D4.5-D4.7 | Generated catalog and adapters correspond to authoritative inputs | Both generators and correspondence checks run after source changes. |
| D6.1-D6.2 | Live documentation and references remain current and resolvable | Feature contracts and quickstart describe the corrected wording and validation commands. |
| D8.1 | Shared-library changes trigger dependent skill validation | The Request template is not changed, and its dependent validation remains part of the gate. |

Result: PASS. No unjustified constitution violations or new runtime dependencies.

## Project Structure

### Documentation (this feature)

```text
specs/055-highway-new-wording-cleanup/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

### Source Code (repository root)

```text
.highway/
├── skills/highway-new/SKILL.md
├── library/templates/output/request-record.md
├── tools/tests/highway-new.test.sh
├── tools/tests/output-template.test.sh
├── tools/validate-skill.sh
├── tools/validate-library.sh
├── tools/generate-catalog.sh
└── tools/generate-agent-adapters.sh

.github/skills/highway-new/SKILL.md
.claude/skills/highway-new/SKILL.md
.cursor/rules/highway-new.mdc
```

**Structure Decision**: Update the existing authoritative skill and focused validation surfaces;
regenerate distributed copies and catalogs. No runtime service, package, persistence layer, or new
evidence domain is introduced.

## Phase 0: Research Summary

Research is complete in [research.md](research.md). Decisions resolve the only design questions:

- Keep `allowed_solution_classes` as the sole non-empty-list exception.
- State populated list, explicit empty array, and `unknown` only for the other list-shaped fields.
- Use one concise field-error sentence with field, accepted shape, and replacement guidance.
- Use `No business constraints` for intake wording while preserving durable state compatibility.

## Phase 1: Design Summary

Design artifacts:

- [data-model.md](data-model.md) defines corrected value-state and wording boundaries.
- [contracts/wording-contract.md](contracts/wording-contract.md) defines the requester-facing intake contract.
- [contracts/durable-state-contract.md](contracts/durable-state-contract.md) defines compatibility and ownership boundaries.
- [quickstart.md](quickstart.md) defines focused, generated-artifact, and repository-wide validation.

No external API contract is required; the contracts document repository-owned skill and Request
record interfaces.

## Post-Design Constitution Re-check

| Gate | Result | Evidence planned |
|---|---|---|
| D2 toolchain discipline | PASS | No new utility, interpreter, package, or shell feature is introduced. |
| D3 behavioral evidence | PASS | Focused wording and regression checks run before the full suite. |
| D4 generated correspondence | PASS | Catalog and adapter generators plus coverage checks run after source changes. |
| D6 documentation currency | PASS | Contracts, quickstart, and source wording describe the same corrected states. |
| D8 shared-library review | PASS | Request template validation remains in the story gate even though the template is unchanged. |

**Post-design result**: PASS. No constitution amendment is required.
