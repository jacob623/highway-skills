# Implementation Plan: Discovery Contract Consolidation

**Branch**: `052-discovery-contract-consolidation` | **Date**: 2026-09-19 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/052-discovery-contract-consolidation/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Consolidate the duplicated Verification and Error Handling contracts in the authoritative
Discovery skill, and make Workflow step 10 delegate equal-score tie handling to the existing
Recommendation Tie-Break Evaluation section. Preserve every existing behavioral invariant,
regenerate the three agent adapters, and extend focused contract validation without changing
runtime behavior, output templates, or governance ownership.

## Technical Context

**Language/Version**: Markdown skill contract; Bash-compatible validation scripts

**Primary Dependencies**: `.highway/skills/highway-discovery/SKILL.md`, generated adapter
targets, `.highway/tools/generate-agent-adapters.sh`, and the existing shell test harness

**Storage**: Retained Markdown skill, adapter, specification, and validation artifacts; no
user-owned Discovery records or catalogs are modified by this feature

**Testing**: `.highway/tools/tests/highway-discovery.test.sh`, adapter generation and coverage
checks, skill validation, and `.highway/tools/tests/run-all.sh`

**Target Platform**: Repository skill tree consumed by GitHub Copilot, Claude Code, and Cursor;
validation must work on macOS and supported shell environments

**Project Type**: Repository governance and workflow skill suite

**Performance Goals**: Preserve the existing bounded Discovery workflow; this feature adds no
runtime evaluation, network call, or unbounded scan

**Constraints**: Preserve score, confidence, ranking, traceability, no-output, byte-preservation,
and ADR ownership semantics; remove only duplicate headings and embedded tie-break wording; do
not modify templates, manifests, generators, or governance baselines

**Scale/Scope**: One authoritative Discovery skill, three generated adapters, one focused test,
and the existing full repository test suite

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The feature changes a retained skill contract and its validation evidence. It does not add
executable behavior, dependencies, external services, packaging rules, or governance decisions.

| Gate | Verdict | Basis |
|---|---|---|
| Packaging Gate | N/A | No distribution manifest, package, or packaged tree changes. |
| Toolchain Gate | PASS | Existing validation and generation commands are used; no new tool is introduced. |
| Generator Gate | PASS | The existing adapter generator is run after the authoritative source change. |
| Correspondence Gate | PASS | Generated adapters are regenerated and checked for currency and coverage. |
| Validation Gate | PASS | Focused Discovery assertions and the full shell suite are planned. |
| Skill Content Gate | PASS | The merged sections retain the existing contract and Workflow ordering. |
| Security Gate | N/A | No new security-affecting behavior or dependency selection is introduced. |
| Maintainability Gate | PASS | The change removes duplicate contract surfaces and keeps one authoritative tie-break reference. |
| Performance Gate | N/A | No new loop, filesystem scan, network call, or database query is introduced. |

The plan satisfies P4.1 and P4.3 through named focused and full validation commands, P6.1,
P6.2, P6.5, and P6.6 by preserving the existing ordered tie-break contract, and P9.1 by
leaving shared output-template citations untouched. No constitution violation requires a
complexity exception.

## Project Structure

### Documentation (this feature)

```text
specs/052-discovery-contract-consolidation/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

```text
.highway/skills/highway-discovery/SKILL.md       # authoritative source contract
.github/skills/highway-discovery/SKILL.md        # generated GitHub Copilot adapter
.claude/skills/highway-discovery/SKILL.md        # generated Claude Code adapter
.cursor/rules/highway-discovery.mdc              # generated Cursor adapter
.highway/tools/tests/highway-discovery.test.sh   # focused Discovery contract test
.highway/tools/tests/adapter-coverage.test.sh    # adapter correspondence and currency test
.highway/tools/tests/run-all.sh                  # full repository validation
.highway/tools/generate-agent-adapters.sh        # adapter regeneration command
specs/052-discovery-contract-consolidation/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/
    └── discovery-contract-consolidation.md
```

## Structure Decision

Keep the authoritative skill under `.highway/skills/`, treat the three agent-facing copies as
generated artifacts, and extend the existing focused shell test rather than introducing a new
test framework. Store Feature 052 design evidence in its numbered `specs/` directory. No
application source tree, runtime module, or user-owned output is added.

## Post-Design Re-evaluation

PASS. Phase 0 and Phase 1 produce planning evidence only. The implementation remains limited to
one authoritative skill, its generated adapters, and focused contract assertions. Existing
generator, correspondence, validation, and skill-content gates remain satisfied; packaging and
security triggers remain false.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The feature uses the existing skill, adapter generator, and shell harness without new projects, services, or dependencies. |
