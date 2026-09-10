# Implementation Plan: Highway Setup Compliance Hardening

**Branch**: `034-highway-setup-compliance` | **Date**: 2026-09-10 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/034-highway-setup-compliance/spec.md`

## Summary

Strengthen Feature 033's compliance evidence by replacing prose-only assertions with executable disposable-tree behavior fixtures, resolving the NFR status transition, making dashboard whitespace canonical and byte-significant, measuring a defined 20-case first-time routing matrix against a 19/20 threshold, and recording ownership review evidence separately from automated results and requirement coverage.

## Technical Context

**Language/Version**: Markdown skill contracts; Bash 3.2-compatible verification fixtures

**Primary Dependencies**: Existing Highway owner skills, `.highway/tools/tests/run-all.sh`, and existing catalog/adapter generators

**Storage**: Disposable temporary repository trees for tests; Feature 034 contracts and evidence records under `specs/034-highway-setup-compliance/`; no new shipped artifact store

**Testing**: Focused behavioral fixture test, output contract comparison, routing matrix scorer, ownership checklist review, `.highway/tools/validate-skill.sh`, and the full repository suite

**Target Platform**: macOS Bash 3.2-compatible development environment and the distributed Highway skill trees

**Project Type**: Governance skill verification and compliance documentation

**Performance Goals**: Complete the 20-case routing matrix deterministically in one test invocation; no service latency target

**Constraints**: Preserve Feature 033 ownership boundaries, use the original canonical dashboard bytes, do not weaken existing assertions, keep generated artifacts derived, and keep development-only evidence outside shipped paths

**Scale/Scope**: One setup skill, two dashboard states, five readiness entry states, four owner-result classes, 20 routing cases, and six ownership boundaries

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Highway Development Constitution

- **D3.1**: PASS by plan. Record a passing repository suite before the first behavioral edit.
- **D3.2**: PASS by plan. Run the repository suite after the final edit.
- **D3.3**: PASS by plan. Amend the focused test under `.highway/tools/tests/`.
- **D3.4**: PASS by plan. Evaluate the new behavioral checks against existing Feature 033 fixtures before enabling them.
- **D3.5**: PASS by review. Preserve existing assertions and record any superseded expectation explicitly.
- **D3.6**: PASS by plan. Capture a failing run for each newly claimed behavior before marking its implementation task complete.
- **D4.1, D4.5-D4.7**: PASS by plan. Regenerate and correspondence-check all derived artifacts after source changes; do not hand-edit generated files.
- **D7.1**: PASS by plan. Every completed task will name an artifact containing the described change.
- **D7.2**: PASS by plan. Create one exact-once coverage mapping for FR-001 through FR-012.
- **D7.3**: PASS by plan. Report suite results, routing coverage, requirement coverage, and manual review as separate claims.

### Highway Skills Constitution

- **P4.1-P4.3**: PASS by design. Every behavioral claim has a named fixture, byte comparison, hash comparison, or checklist check.
- **P5.1-P5.6**: PASS by preservation. Feature 034 tests Feature 033's existing failure paths without changing owner workflow semantics.
- **P6.1-P6.6**: PASS by design. The NFR state table and routing matrix define ordered, exhaustive choices with an explicit default failure branch.
- **P8.1-P8.4**: PASS by design. Verification commands and expected outputs are recorded in quickstart.md.
- **P9.1**: N/A. Feature 034 emits no user-owned governance file and introduces no shipped file-output template.

**Gate status**: PASS for planning. Post-design review must confirm the contracts, fixture matrix, and evidence records remain consistent.

## Project Structure

### Documentation (this feature)

```text
specs/034-highway-setup-compliance/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── coverage.md              # Phase 2 completion artifact
├── contracts/
│   ├── dashboard-output.md
│   ├── routing-matrix.md
│   └── ownership-review.md
├── checklists/
│   └── requirements.md
└── tasks.md                 # Phase 2 output from /speckit-tasks
```

### Source and Test Artifacts

```text
.highway/
├── skills/highway-setup/SKILL.md
└── tools/tests/highway-setup.test.sh
```

Generated registration outputs remain the responsibility of the existing generators when the source skill or its metadata changes; Feature 034 does not hand-edit them.

**Structure Decision**: Keep the remediation in the existing Feature 033 skill and focused test, while storing the canonical dashboard, routing matrix, ownership review, data model, and completion records under the development-only Feature 034 directory.

## Phase 0: Research

Resolve the current Feature 033 output contract, existing fixture conventions, and repository completion-evidence rules. Record decisions in `research.md` before design artifacts are finalized.

## Phase 1: Design and Contracts

Create the state model, exact dashboard contract, 20-case routing matrix, ownership-review contract, and executable quickstart. Re-run the constitution gate after these artifacts are complete.

## Complexity Tracking

No constitution violation or complexity exception is required.
