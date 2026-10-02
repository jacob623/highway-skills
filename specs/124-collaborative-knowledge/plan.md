# Implementation Plan: Collaborative Knowledge Development

**Branch**: `124-collaborative-knowledge` | **Date**: 2026-10-02 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/124-collaborative-knowledge/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Amend the canonical Highway Constitution with a `XII-A` Collaborative Knowledge Development
principle. The amendment adds definitions and four agent-checkable rules that keep Active
Reasoning Context and Working Ideas transient, distinguish complete Converged Proposals from
evolving ideas, preserve relevant context during an interaction, and require re-evaluation after
accepted knowledge changes the task. Existing acceptance boundaries, owner-controlled mutation,
and orchestration rules remain unchanged. The implementation is documentation and governance
validation only; it introduces no durable conversational-state artifact, runtime dependency, or
public interface.

## Technical Context

**Language/Version**: Markdown plus POSIX/Bash 3.2-compatible repository tests

**Primary Dependencies**: Existing Highway governance documents, shell test helpers, and generated
adapter tooling; no new dependency

**Storage**: Markdown governance artifacts only; no new storage or durable conversational state

**Testing**: `.highway/tools/tests/run-all.sh` plus focused constitution inventory, coverage,
rule-check, and adapter-generation tests

**Target Platform**: macOS/Linux development environments using the repository's shell tooling

**Project Type**: Governance/documentation and shell-test repository

**Performance Goals**: Preserve deterministic, repository-local validation; no runtime performance
target is introduced

**Constraints**: Keep P12.5-P12.15 identifiers and semantics unchanged; do not prescribe
conversation technique; do not persist transient reasoning; maintain Constitution rule and version
format invariants; keep tests compatible with macOS Bash 3.2

**Scale/Scope**: One Constitution amendment, its generated distribution copies/manifests if
required by repository tooling, and focused regression assertions for the new principle

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **P1/P3/P6**: PASS. The amendment is explicit, deterministic, and does not alter higher-ranked
  correctness, security, or decision rules.
- **P7**: PASS. The amendment is scoped to the canonical Constitution and keeps rule identifiers,
  wording constraints, and semantic-version policy explicit.
- **P8/P9**: PASS. Existing governance structure and generated distribution conventions remain the
  source of truth; no new output contract is introduced.
- **P10/P11**: PASS with synchronization documentation. The Experience Standard remains the
  authority for presentation, and repository context remains subordinate to accepted evidence and
  authoritative state.
- **P12**: PASS. P12.5-P12.15 remain unchanged; the new rules do not weaken owner mutation or
  dependent-result ordering.
- **Version gate**: Proposed MINOR amendment, pending self-application and compatibility review,
  because the new principle adds requirements without making currently conforming governed skills
  fail. Change to MAJOR if validation finds an existing conformance break.

## Project Structure

### Documentation (this feature)

```text
specs/124-collaborative-knowledge/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/
├── governance/
│   └── constitution.md
├── library/knowledge/
│   └── [existing context documents; impact recorded, not rewritten by this feature]
└── tools/tests/
  ├── constitution-inventory.test.sh
  ├── coverage-summary.test.sh
  ├── rule-checks.test.sh
  ├── generate-agent-adapters.test.sh
  └── run-all.sh
.specify/
└── memory/constitution.md       # planning-time development constitution
```

**Structure Decision**: This is a governance amendment in the existing Highway layout. The
canonical Constitution is edited first; repository tests validate its rule inventory, coverage,
self-application constraints, and generated distribution. Downstream skills and context documents
are synchronization targets recorded in the Constitution report, not implementation targets here.

## Protected Boundaries

- Preserve P12.5-P12.15 identifiers, semantics, and the acceptance-to-owner-result boundary.
- Keep Active Reasoning Context interaction-scoped and non-retained; do not add files, logs, thread
  catalogs, or restoration behavior.
- Leave the Experience Standard, `highway-profile`, `highway-objectives`, `highway-controls`,
  `highway-nfrs`, and future Architecture/ADR workflows unchanged in this feature.
- Do not add requirements for literal wording, turn counts, acknowledgment, visible reasoning, or
  conversational presentation mechanics.

## Implementation Phases

1. Research current Constitution structure, version policy, rule validators, adapter generation,
   and named downstream synchronization surfaces.
2. Design the four new rule records, definitions, lifecycle explanation, precedence placement,
   synchronization report, and focused validation scenarios.
3. Generate tasks from the design artifacts, then implement the Constitution amendment and any
   required generated outputs/tests through the repository's existing workflows.
4. Run focused checks followed by `.highway/tools/tests/run-all.sh` and inspect the final diff for
   prohibited durable-state or conversational-technique requirements.

## Test Strategy

Focused tests must prove the new rule IDs have valid structure and coverage, existing P12 rules are
unchanged, precedence and version metadata are coherent, and generated adapters remain aligned.
The quickstart then exercises those checks and the full suite. No runtime or external contract test
is applicable because the feature adds no runtime interface.

## Versioning Assessment

Start as MINOR because P12A adds additive constitutional obligations and the specification assumes
no currently conforming governed skill is invalidated. Reclassify to MAJOR if compatibility review
or tests show an existing conformance guarantee is broken. The final Sync Impact Report must record
the classification and the requested downstream rollout order.

## Complexity Tracking

No Constitution gate violations are currently identified; no complexity exception is required.
