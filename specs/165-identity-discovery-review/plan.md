# Implementation Plan: Identity Discovery Contribution Opportunity

**Branch**: `165-identity-discovery-review` | **Date**: 2026-10-13 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from [spec.md](spec.md)

## Summary

Update `highway-profile` with an optional Identity Discovery Contribution Opportunity that presents evidence-grounded
organizational expressions before Identity convergence, treats corrections as transient proposed
Identity evidence, and re-presents the review while meaningful changes continue. Preserve the existing
Identity Converged Proposal, acceptance boundary, retained narrative, readiness, domain ownership, and
setup prompt behavior. Add focused static contract coverage, regenerate the four agent adapters from
the source skill, and run the existing full suite.

## Technical Context

**Language/Version**: Markdown skill contract and Bash 3.2-compatible verification scripts

**Primary Dependencies**: Highway Experience Standard, Highway Identity, Profile record contract,
Highway Skills Constitution, existing Profile tests, and adapter generators; no new dependency

**Storage**: Existing retained Markdown Profile at `.highway/library/knowledge/profile.md`; no new
stored review artifact, field, or readiness dimension

**Testing**: New Feature 165 static contract test, existing Profile lifecycle/convergence/behavior
contracts, generated adapter correspondence checks, and `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill trees and macOS/POSIX-like shells using Bash 3.2-compatible scripts

**Project Type**: Documentation-defined agent skill suite with generated adapters and shell validation

**Performance Goals**: Deterministic repository-local validation; no runtime latency or throughput target

**Constraints**: Source-first editing; preserve Profile ownership, acceptance, persistence, readiness,
retained schema, setup orchestration, and shared interaction rules; no external service, runtime state,
new schema, or durable discovery-contribution artifact; keep generated adapters byte-identical to source

**Scale/Scope**: One source skill, four generated adapters, one focused contract test, and existing
Profile/full-suite validation

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The pre-design gate passes. The feature is a documentation-led skill change with no new runtime
dependency, persisted schema, external interface, or governance amendment.

- **Layer separation and shippability (D1.1-D1.6)**: PASS. Shipped behavior remains in the source
  skill and generated adapters; Feature 165 planning artifacts remain under `specs/`.
- **Environment and dependency discipline (D2.1-D2.4)**: PASS. Existing Markdown and Bash 3.2-compatible
  tooling is reused; no package, service, or non-portable shell construct is added.
- **Verification before and after (D3.1-D3.8)**: PASS. The focused contract will be observed failing
  before the source wording is complete, then the full suite will be run after regeneration.
- **Generated artifact integrity (D4.5-D4.7)**: PASS. The source skill is authoritative and all four
  adapters will be regenerated and compared after the source change.
- **Documentation and completion integrity (D6.1-D7.3)**: PASS. The live skill, focused test, adapters,
  plan artifacts, and task coverage will remain aligned and separately reported.
- **Shared artifact dependency (D8.1)**: N/A. The Profile record template and shared governance files
  are read-only dependencies and are not changed.

No constitution violation requires a complexity exception.

## Phase 0: Research

Research decisions are recorded in [research.md](research.md). The key decisions are:

- Keep the source skill as the sole authoring surface and regenerate adapters.
- Represent the discovery review as transient proposed evidence and a Contribution Opportunity,
  not as a persisted artifact or acceptance boundary.
- Use static document-contract validation for wording, ordering, lifecycle boundaries, and adapter identity.

## Phase 1: Design and Contracts

- [data-model.md](data-model.md) defines the transient review, findings, correction loop, stability
  transition, and final proposal relationship.
- No `contracts/` directory is needed because the feature exposes no API, command schema, or external
  integration; the user-visible contract is the Profile skill text and focused test.
- [quickstart.md](quickstart.md) defines focused, adjacent, and full-suite validation commands.

## Project Structure

### Documentation (this feature)

```text
specs/165-identity-discovery-review/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── checklists/requirements.md
└── tasks.md             # Phase 2 output; created by /speckit-tasks
```

### Source and validation paths

```text
.highway/skills/highway-profile/SKILL.md
.highway/tools/tests/feature-165-identity-discovery-review.test.sh
.highway/tools/tests/feature-134-profile-contribution-opportunity.test.sh
.highway/tools/tests/feature-136-profile-substantive-re-evaluation.test.sh
.highway/tools/tests/profile-behavior.test.sh
.highway/tools/tests/profile-lifecycle.test.sh
.highway/tools/tests/run-all.sh
.highway/tools/generate-agent-adapters.sh
.github/skills/highway-profile/SKILL.md
.claude/skills/highway-profile/SKILL.md
.cursor/skills/highway-profile/SKILL.md
.agents/skills/highway-profile/SKILL.md
```

**Structure Decision**: This is a documentation-only source skill change. The authoritative Profile
skill remains `.highway/skills/highway-profile/SKILL.md`; generated adapters are refreshed through the
existing generator; focused validation remains under `.highway/tools/tests/`. No external API contract,
runtime module, retained field, or durable review store is introduced.

## Post-Design Constitution Check

- **Layer and dependency gates**: PASS. The design stays within the existing shipped skill and shell
  validation paths with no new dependency or external interface.
- **Verification gate**: PASS. The focused test covers review shape, correction-loop behavior, stable
  transition, setup guidance, protected boundaries, and adapter identity; adjacent and full suites follow.
- **Generated artifact gate**: PASS pending implementation. All four adapters are regenerated from the
  source and checked byte-identical.
- **Documentation and ownership gates**: PASS. The review remains transient, Profile-owned, and separate
  from the retained Profile narrative and existing acceptance boundary.

No complexity exception is required.
