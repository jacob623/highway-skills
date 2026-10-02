# Implementation Plan: Experience Standard Collaborative Development

**Branch**: `126-experience-collaborative-development` | **Date**: 2026-10-02 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from [spec.md](spec.md)

## Summary

Amend the canonical Experience Standard at `.highway/governance/experience-standard.md` so
user-visible Highway interaction supports collaborative development before artifact capture and
contextual re-evaluation after acceptance. The implementation is a one-document governance
change: revise X2.8, add the requested non-normative guidance and examples, preserve existing
rules and ownership boundaries, add the specified X2.36 behavior if still present, and record the
version decision required by the Experience Standard policy.

## Technical Context

**Language/Version**: Markdown governance document; no runtime language

**Primary Dependencies**: Existing Highway Constitution, Highway Identity, and Experience Standard only

**Storage**: N/A; no retained data, schema, or persistence change

**Testing**: Focused structural/content checks; `.highway/tools/tests/run-all.sh` for repository compatibility

**Target Platform**: Distributed Highway repository and its user-visible agent workflows

**Project Type**: Governance and documentation artifact

**Performance Goals**: N/A; no executable behavior or runtime path is introduced

**Constraints**: Modify only `.highway/governance/experience-standard.md`; do not modify tests,
skills, schemas, Profile, Objectives, Controls, NFRs, Setup, Constitution, or generated artifacts

**Scale/Scope**: One shipped governance document; 40 existing Experience Standard rules remain
stable except the requested X2.8 revision and any explicitly added X2.36 rule

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates

| Gate | Rules | Verdict | Evidence / action |
|---|---|---|---|
| Packaging Gate | D1.1, D1.2, D6.2 | PASS | The target is shipped under `.highway/`; the final document will contain no `.specify/` or `specs/` references, and all referenced `.highway/` paths will be checked. |
| Toolchain Gate | D2.1-D2.4 | N/A | No file under `.highway/tools/` changes and no runtime dependency is added. |
| Generator Gate | D4.1-D4.4 | N/A | No generator or generated artifact changes. |
| Correspondence Gate | D4.5-D4.7 | N/A | No skill, generator input, or generated catalog changes. |
| Validation Gate | D3.4-D3.5 | N/A | No validation check changes are permitted by the feature scope. |
| Verification baseline | D3.1 | BLOCKED BY PRE-EXISTING FAILURE | The current full suite has a known unrelated `constitution-inventory.test.sh` failure for former Constitution precedence. This feature cannot amend that test under FR-025; focused validation will be authoritative for this one-document change and the incompatibility will remain reported. |
| Verification completion | D3.2 | BLOCKED BY PRE-EXISTING FAILURE | Same known unrelated failure is expected to remain after implementation; no test weakening or unrelated repair is allowed. |

### Self-application and documentation review

- **D1.3/D1.4**: PASS. The plan cites Constitution rule IDs and does not restate their rule text.
- **D5.3**: PASS for the Experience Standard amendment. The implementation record will name the
  changed X2.8, added or retained X2.36, interaction model, collaborative guidance, examples,
  ownership guidance, and version footer; all unlisted content carries forward.
- **D6.2**: PASS condition. Research and final validation will resolve every path cited by the
  updated Experience Standard within the shipped `.highway/` tree.
- **D8.1**: N/A. No shared library artifact changes.

The pre-existing D3.1/D3.2 incompatibility is intentionally documented rather than repaired because
the feature explicitly permits only `experience-standard.md` as an implementation target.

## Phase 0: Research Decisions

1. Confirm the current Experience Standard rule inventory, X2.8/X2.36 state, interaction model,
   versioning policy, and existing static contract expectations.
2. Determine the version classification from the current policy. The revised X2.8 changes the
   normative obligation from acknowledging changed understanding to reflecting updated
   understanding with relevant context, so the plan treats this as a MAJOR compatibility review;
   the implementation will record `8.0.0` only if the policy review confirms previously conforming
   behavior would fail. No version bump will be inferred from non-normative guidance alone.
3. Confirm no external interface, data model, contract, runtime dependency, or generated adapter is
   introduced. The result is a governance-document amendment with focused static validation.

## Phase 1: Design and Validation Artifacts

- `research.md`: decisions, rationale, alternatives, version classification, and compatibility risks.
- `data-model.md`: conceptual Working Idea, Converged Proposal, accepted knowledge, and ownership
  boundaries; explicitly records that no persisted data model changes.
- `quickstart.md`: focused checks for headings, X2.8/X2.36 exact rows, guidance, versioning,
  cross-references, one-file scope, and the full-suite compatibility result.
- `contracts/`: omitted because this is an internal governance document with no external API,
  command, storage, or runtime contract.

## Project Structure

### Documentation (this feature)

```text
specs/126-experience-collaborative-development/
├── spec.md
├── checklists/requirements.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── tasks.md                 # generated by /speckit-tasks
```

### Implementation surface

```text
.highway/governance/experience-standard.md
```

**Structure Decision**: This is a single shipped governance-document amendment. No source-code,
test, contract, generated, schema, or skill directory is added or modified.

## Implementation Strategy

1. Capture the current Experience Standard baseline and resolve version compatibility.
2. Apply the smallest coherent edit to the one target document, preserving unrelated rules and
   existing terminology unless the requested collaborative model requires a change.
3. Run focused structural and content checks, then run the full suite and report the known
   pre-existing incompatibility without changing out-of-scope tests.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|---|---|---|
| D3.1/D3.2 cannot reach a green full-suite verdict | The repository begins with an unrelated Constitution inventory failure and FR-025 forbids changing that test or unrelated files. | Silently claiming a green suite or modifying the stale test would violate verification honesty or the one-file feature boundary. |

## Post-Design Constitution Check

- **Packaging Gate (D1.1, D1.2, D6.2)**: PASS in design. The planned implementation surface is
   one shipped document, and the quickstart checks all authoritative cross-reference paths.
- **Toolchain, Generator, Correspondence, and Validation Gates**: N/A. The design adds no tools,
   generators, generated artifacts, or validation checks.
- **D1.3/D1.4**: PASS. The research and design artifacts cite authoritative documents and avoid
   copying Constitution rule text.
- **D5.3**: PASS in design. The research and quickstart identify every requested Experience
   Standard element that may change and preserve all unlisted content.
- **D3.1/D3.2**: Remain blocked by the documented pre-existing `constitution-inventory.test.sh`
   failure. No design decision expands the implementation boundary to repair it.

The design is ready for task generation with the known repository compatibility limitation carried
forward explicitly.
