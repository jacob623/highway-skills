# Implementation Plan: Experience Conversational Continuity

**Branch**: `120-experience-conversational-continuity` | **Date**: 2026-10-01 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/120-experience-conversational-continuity/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Amend the shared Highway Experience Standard so interactive workflows use first-person conversational identity and visibly acknowledge meaningful accepted context, while keeping Constructive Advisory conditional and preserving existing one-question, grounding, ownership, Decision Context, completion, and machine-result boundaries. The implementation is a focused Markdown contract amendment plus affected repository checks, fixtures, examples, snapshots, and version records. No individual skill or shared output template changes.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown contract; Bash 3.2.57-compatible validation scripts

**Primary Dependencies**: Existing Highway Experience Standard, Highway Identity, Skills Constitution, and repository test harness

**Storage**: N/A; this feature changes governance and verification documents only

**Testing**: Existing Bash contract tests, Markdown assertions, version checks, correspondence checks, `git diff --check`, and full `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS development environment with POSIX-oriented shell checks; distributed Markdown artifacts

**Project Type**: Internal governance/documentation contract with executable repository checks

**Performance Goals**: Validation remains a bounded repository check; no runtime latency or throughput target applies

**Constraints**: Update only Experience Standard-owned artifacts and directly affected checks; preserve X-rule identifiers except the X2.8 obligation/Observable redefinition; do not modify Profile, Objectives, Controls, NFRs, Setup, Highway Identity, or shared output templates; preserve X1.7, X2.4, X2.7, X2.9, X2.11, X2.13, X2.17-X2.22, X2.29-X2.35; use deterministic Bash 3.2-compatible checks

**Scale/Scope**: One shared Experience Standard, one stable X2.8 rule, affected development checks/examples/version records, and the complete existing validation suite

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

*GATE: PASS* — The change has one owning shared contract and does not create a new runtime component (P1.1, P1.3, P6.4).

*GATE: PASS* — The amendment preserves user ownership, proposal boundaries, and existing interaction ownership; X2.8 is explicitly redefined as a MAJOR Experience Standard amendment (P7.3, P10.1, P10.2).

*GATE: PASS* — No retained output, migration, external service, or persistence behavior is introduced; P12 rules are unaffected and no exception is required.

*GATE: PASS* — The spec identifies affected checks, preservation checks, version metadata, and self-application review. No complexity exception is needed.

### Post-Design Constitution Check

*GATE: PASS* — Research confirms the change remains limited to the Experience Standard owner and directly affected development evidence; no individual skill, retained output, or external interface is introduced.

*GATE: PASS* — The design preserves proposal ownership, grounding, one-question behavior, Decision Context, completion synthesis, and machine-result suppression while redefining only X2.8.

*GATE: PASS* — The design uses existing deterministic Bash 3.2-compatible checks, records the required MAJOR version change and self-application review, and requires final scope validation.

## Project Structure

### Documentation (this feature)

```text
specs/120-experience-conversational-continuity/
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
 .highway/
 ├── governance/
 │   └── experience-standard.md       # authoritative shared interaction contract
 └── tools/tests/
   ├── experience-standard-amendment.test.sh
   ├── highway-ux-alignment.test.sh
   ├── feature-092-contract.test.sh
   └── run-all.sh

 .github/skills/                      # generated distributed instruction copies
 specs/120-experience-conversational-continuity/
 ├── spec.md
 ├── plan.md
 ├── research.md
 ├── data-model.md
 └── quickstart.md
```

**Structure Decision**: Keep the authoritative Experience Standard in `.highway/governance/experience-standard.md`, update only its directly affected development checks and generated records, and keep Feature 120 design artifacts under its existing `specs/` directory. No `contracts/` directory is needed because the project exposes no external API or CLI wire contract for this amendment.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The amendment fits the existing governance document and shell-contract structure. |
