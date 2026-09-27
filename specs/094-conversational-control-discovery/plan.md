# Implementation Plan: Conversational Control Discovery

**Branch**: `094-conversational-control-discovery` | **Date**: 2026-09-25 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/094-conversational-control-discovery/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Replace category-driven Control onboarding with an adaptive, context-aware conversation owned by
`highway-controls`, while `highway-setup` remains an orchestrator. Setup will consume distinct
Controls action and readiness results; each accepted conversational Control remains one atomic Add
transaction; deterministic NFR candidates are generated immediately after verified Control
persistence, while NFR review remains deferred until explicit collection finish. The implementation
will update canonical Markdown skill contracts, generated copies, owner-boundary contracts, and
focused Bash fixtures without adding runtime dependencies or retained Concern/Condition/Obligation
fields.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill contracts; Bash 3.2.57-compatible validation scripts

**Primary Dependencies**: Existing `.highway` skill contracts, shared output templates, Spec Kit
validation scripts, and the existing Bash test harness; no new dependency

**Storage**: User-owned Markdown artifacts under `library/governance/`; no new storage model

**Testing**: `.highway/tools/tests/run-all.sh` plus focused Controls, Setup, NFR, readiness, UX,
correspondence, and fixture checks

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux; default Bash/toolchain

**Project Type**: Markdown-based governance skill suite with Bash validation and generated adapters

**Performance Goals**: Deterministic bounded interaction decisions and validation; no runtime
latency target is introduced by this documentation/contract feature

**Constraints**: Preserve existing artifact schemas and owner boundaries; Bash 3.2 compatibility;
no generated-artifact drift; no transient discovery restoration; no new runtime dependency; no
user-visible orchestration bookkeeping

**Scale/Scope**: Canonical Controls, Setup, NFR, and shared UX/output contracts; generated copies;
focused fixtures for adaptive discovery, persistence, interruption, candidate generation, direct
actions, compliance, and organizational-language variation

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

All applicable gates pass for planning:

- **D1.1/D1.2**: Development-only planning artifacts remain under `specs/`; shipped skill files
  must not reference `.specify/` or `specs/`.
- **D1.5**: This plan explicitly records the Constitution Check because it modifies shipped skill
  and library-facing contracts.
- **D2.1-D2.4**: No script or runtime dependency is added; any amended Bash test remains compatible
  with Bash 3.2.57 and the declared toolchain.
- **D3.1-D3.8**: Begin/end suite checks, focused behavioral fixtures, observed failure before
  completion, and separate contract-versus-runtime evidence are required in the task breakdown.
- **D4.1-D4.7**: Canonical source edits require regeneration and correspondence checks for all
  generated adapters/catalog/manifest artifacts.
- **D6.1-D6.2**: Controls, Setup, NFR, UX, and related live documentation are updated together;
  all plan/contract links must resolve.

No violation or complexity exception is required. The Phase 1 re-check will confirm that the
contract artifacts preserve these gates and that no implementation task introduces a new runtime
dependency or shipped reference to development artifacts.

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
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
.highway/skills/highway-controls/SKILL.md       # canonical Controls owner contract
.highway/skills/highway-setup/SKILL.md          # canonical Setup orchestration contract
.highway/skills/highway-nfrs/SKILL.md           # candidate readiness/review owner contract
.highway/library/templates/output/             # retained artifact/output templates
.highway/tools/tests/                           # Bash contract and behavior fixtures
specs/094-conversational-control-discovery/    # plan/design artifacts
.github/skills/                                  # development-time Spec Kit skills
```

**Structure Decision**: Preserve the repository's canonical `.highway/skills/` and
`.highway/tools/tests/` ownership boundaries. Feature design artifacts remain in the Feature 094
development directory. Generated artifacts are refreshed through the existing generators rather
than hand-edited. No application source tree or new package is introduced.

## Phase 0 Research Summary

Research decisions are recorded in [research.md](research.md). The material unknowns are resolved:

1. Candidate generation occurs immediately after each verified Control persistence; only NFR
   candidate review is deferred.
2. Controls owns deterministic derivation; NFRs own candidate classification/readiness/review and
   accepted NFR persistence, subject to explicit dependent-contract reconciliation.
3. Controls action results and four-field Controls readiness results are distinct contracts.
4. `setup`/`configure` are multi-Control collection; direct `add` is one-Control creation.
5. Concern, Condition, Obligation, suggestions, proposals, and collection provenance remain
   interaction state and are not restored on a new invocation.

## Phase 1 Design Outputs

- [data-model.md](data-model.md) defines transient interaction state, durable Control state,
  candidate-generation state, and owner-result transitions.
- [contracts/controls-action-result.md](contracts/controls-action-result.md) defines collection
  status, cumulative created IDs, terminal finish, and direct-action scope.
- [contracts/controls-readiness.md](contracts/controls-readiness.md) preserves the exact four-field
  readiness contract and Setup sequencing.
- [contracts/controls-nfr-candidate.md](contracts/controls-nfr-candidate.md) defines immediate
  candidate generation, durable readiness, deferred review, zero-candidate, and failure paths.
- [contracts/context-and-ux.md](contracts/context-and-ux.md) defines context priority, relevant
  connections, user-facing proposal framing, and no-restoration behavior.
- [quickstart.md](quickstart.md) defines runnable validation scenarios and expected outcomes.

## Verification Strategy

The implementation task breakdown must add or amend focused tests for Setup handoff/result ordering,
adaptive branching, Profile blocking, direct `configure`/`add`, proposal override, persistence and
version semantics, immediate candidate generation, interruption recovery, NFR readiness failure,
zero candidates, relevant connections, and generated correspondence. Static contract checks must be
reported separately from executed behavior checks. The final run must include
`.highway/tools/tests/run-all.sh`, focused fixtures, prerequisite validation, and generated-artifact
correspondence checks.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
