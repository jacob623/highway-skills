# Implementation Plan: Highway Setup UX Verification and Output Contract Clarification

**Branch**: `086-highway-setup-ux-verification` | **Date**: 2026-09-23 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/086-highway-setup-ux-verification/spec.md`

## Summary

Complete the `highway-setup` verification contract for the Feature 085 interaction by making
collection, status, and completion modes explicit and independently testable. Amend the shipped
skill wording and focused static and executable tests so opening order, owner-content ordering,
prohibited narration, status applicability, and completion-dashboard exclusivity are verified
without changing owner routing, readiness order, terminality, safe-stop behavior, or destinations.

## Technical Context

**Language/Version**: Markdown skill instructions; Bash 3.2.57-compatible validation scripts

**Primary Dependencies**: Existing Highway owner skills and `.highway/tools/tests/test-helpers.sh`

**Storage**: N/A; no setup persistence or new artifact store

**Testing**: `.highway/tools/tests/highway-setup.test.sh`, `.highway/tools/tests/highway-setup-executable.test.sh`, and `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU-like environments

**Project Type**: Agent skill and governance-document suite

**Performance Goals**: Preserve the existing single-question interaction and readiness ordering; no runtime performance target applies

**Constraints**: Preserve owner authority, question wording, content ordering, and output destinations; remain Bash 3.2 compatible; add no runtime dependency or persistence; keep the Completion Dashboard unchanged

**Scale/Scope**: One shipped skill, two focused tests, three design artifacts, one verification contract, and four owner workflows

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates:

| Gate | Verdict | Basis |
|---|---|---|
| Packaging Gate | PASS | D1.1, D1.2, and D6.2 apply because `.highway/skills/` is shipped and the feature artifacts cross-reference repository paths. |
| Toolchain Gate | PASS | D2.1-D2.4 apply to the amended Bash tests; no new utility, interpreter, package, or runtime dependency is planned. |
| Generator Gate | N/A | No `generate-*.sh` file changes. |
| Correspondence Gate | PASS | `.highway/skills/highway-setup/SKILL.md` is an input to declared generators; generated adapters, catalogs, and manifests will be regenerated and checked if the source changes. |
| Validation Gate | PASS | D3.1-D3.8 apply; existing fixtures remain covered, static and executable evidence stay distinct, and no assertion is weakened. |
| Skill Content Gate | PASS | P1.1, P1.3, P1.5, P4.1, P5.1-P5.5, P6.1-P6.6, P7.1-P7.5, P7.7, P8.1-P8.4, P10.1, and P10.2 will be reviewed against the clarified output modes. |

The output-contract clarification may require the existing `metadata.version` increment under P7.7
if the shipped skill contract changes. The Experience Standard remains the authority; no new X rule
is introduced. Generated outputs must remain synchronized with the source skill.

## Project Structure

### Documentation (this feature)

```text
specs/086-highway-setup-ux-verification/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── setup-verification-output.md
└── tasks.md              # Phase 2 output (/speckit-tasks command; not created here)
```

### Source Code (repository root)

```text
.highway/
├── skills/highway-setup/SKILL.md
└── tools/tests/
    ├── highway-setup.test.sh
    └── highway-setup-executable.test.sh
```

**Structure Decision**: Keep behavior and ownership in the existing shipped
`.highway/skills/highway-setup/SKILL.md` and extend its two focused Bash tests. Use the Feature 086
research, data model, verification contract, and quickstart to document the contract and evidence
boundaries. Regenerate declared adapters and catalogs when the source skill changes; no application
source tree, persistence layer, or new runtime dependency is introduced.

## Phase 0: Research

Research is recorded in [research.md](./research.md). It resolves the evidence boundary between
static document-contract checks and executable behavior checks, preserves the existing
conversational contract, defines the closed prohibited vocabulary, and records generated-artifact
synchronization requirements.

## Phase 1: Design and Contracts

- [data-model.md](./data-model.md) defines collection, status, and completion verification states,
  relationships, transitions, and invariants.
- [contracts/setup-verification-output.md](./contracts/setup-verification-output.md) defines the
  user-visible collection, status, completion, and prohibited-vocabulary contract.
- [quickstart.md](./quickstart.md) defines focused, full-suite, and manual validation scenarios.

## Validation Plan

1. Run the existing full suite before implementation and record the baseline result.
2. Amend the static setup test to cover the closed vocabulary, output-mode applicability, owner
   content ownership, completion exclusivity, and observable onboarding wording.
3. Amend the executable setup test with deterministic input-required, resumed, status, blocked,
   declined, aborted, and complete fixtures; record seeded failures before enabling new assertions.
4. Update `.highway/skills/highway-setup/SKILL.md` only where its Purpose and output contract lack
   the clarified wording; preserve owner routing, question text, ordering, terminality, safe-stop
   behavior, and completion destinations.
5. Regenerate declared adapters, catalogs, and manifests if the source skill changes, then verify
   generated correspondence.
6. Run both focused tests and `.highway/tools/tests/run-all.sh`; distinguish static contract
   evidence from executed-behavior evidence in the completion report.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|---|---|---|
| None | N/A | The feature stays within the existing skill, focused tests, generated-artifact workflow, and specification artifact boundaries. |
