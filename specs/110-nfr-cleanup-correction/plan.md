# Implementation Plan: Final NFR Contract Cleanup

**Branch**: `110-nfr-cleanup-correction` | **Date**: 2026-09-30 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/110-nfr-cleanup-correction/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Correct the NFR 11.0.0 runtime contract without changing its version or the NFR record template's
2.0.0 structure. Update the captured-NFR review wording and direct-capture boundary, clarify
persisted candidate-state ownership and discovery ordering, preserve owner-result/readiness and
relationship invariants, amend focused contract tests, and regenerate derived outputs.

## Technical Context

**Language/Version**: Markdown contracts and Bash 3.2-compatible shell tests

**Primary Dependencies**: Existing Highway Skills Constitution, Experience Standard, validators,
and generator scripts

**Storage**: Markdown skill/template/catalog files and persisted candidate-state documentation

**Testing**: Focused `.highway/tools/tests/*.test.sh` contract tests and
`.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway repository trees on macOS and Linux

**Project Type**: Documentation and shell-based governance framework

**Performance Goals**: Preserve existing validator and full-suite runtime behavior; no new runtime
dependency or scale target

**Constraints**: Keep `highway-nfrs` at 11.0.0, `nfr-record.md` at 2.0.0, preserve Bash 3.2
compatibility, avoid generic governance restatement, and regenerate all derived outputs

**Scale/Scope**: One canonical skill, one record template, one candidate-state document, focused
tests, and generated adapters/catalogs

## Constitution Check

*GATE: PASS before Phase 0 research and after Phase 1 design.*

- D1.1/D1.3/D1.4: PASS — shipped documents contain no development-path references or copied
  Constitution/Experience rule text.
- D1.5: PASS — this plan records the applicable Constitution checks.
- D3.3/D3.5: PASS — focused tests are amended for the approved superseding contract; unrelated
  assertions are preserved.
- D4.5/D4.7: PASS — generated adapters and catalogs will be regenerated and checked for currency.
- D6.1/D8.1: PASS — affected runtime documentation and every skill citing the changed template
  will be revalidated.
- Packaging, Correspondence, Validation, and Skill Content gates: PASS.

## Project Structure

### Documentation (this feature)

```text
specs/110-nfr-cleanup-correction/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

```text
.highway/skills/highway-nfrs/SKILL.md
.highway/catalog/nfr-candidate-state.md
.highway/library/templates/output/nfr-record.md
.highway/tools/tests/nfr-management.test.sh
.highway/tools/tests/highway-nfr-onboarding.test.sh
.highway/tools/tests/control-derived-nfr.test.sh
.highway/tools/tests/readiness-owner-states.test.sh
.highway/tools/tests/output-template.test.sh
.highway/tools/tests/setup-owner-loop-contract.test.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-library-catalog.sh
.highway/catalog/index.json
.highway/catalog/library-index.json
.github/skills/highway-nfrs/SKILL.md
.claude/skills/highway-nfrs/SKILL.md
.cursor/skills/highway-nfrs/SKILL.md
.agents/skills/highway-nfrs/SKILL.md
```

**Structure Decision**: This is a documentation-and-contract change. Canonical Highway source
documents are edited first, focused shell contract tests are updated alongside them, and declared
generators produce the distributed adapters/catalogs. No application source tree is involved.

## Implementation Phases

1. **Contract correction**: Update the canonical NFR skill wording and exact captured-NFR review;
   remove the obsolete candidate-state schema sentence and correct the persisted-state description.
2. **Focused verification**: Amend NFR management, onboarding, relationship, readiness, template,
   and setup tests to assert the cleanup without restoring generic governance prose.
3. **Derived artifacts**: Regenerate agent adapters and catalogs from canonical sources.
4. **Validation**: Run canonical validators, focused quickstart checks, linter diagnostics, and the
   full repository suite.

## Testing Strategy

- Static contract assertions verify exact review formatting, direct-capture safeguards, candidate
  ordering, result fields, versions, and forbidden lineage/verification material.
- Existing relationship and readiness fixtures verify behavior remains unchanged.
- Generated-artifact currency checks verify all declared adapters and catalogs match their sources.
- The full suite is the completion gate; no new application runtime is introduced.

## Complexity Tracking

No violations. Complexity tracking is not required.

