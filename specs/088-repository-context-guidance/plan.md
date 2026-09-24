# Implementation Plan: Repository Context Guidance
**Branch**: `088-repository-context-guidance` | **Date**: 2026-09-24 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/088-repository-context-guidance/spec.md`

## Summary

Amend the Highway Skills Constitution and Highway Experience Standard to define authoritative
repository context, make context consumption conditional and reviewable, establish deterministic
Identity -> Vision -> Platform Objectives precedence, and add contextual guidance rules X2.7 and
X2.8. The implementation changes only the two governance documents and adds focused validation
for definitions, rule structure, precedence, no-context behavior, and experience guidance.

## Technical Context

**Language/Version**: Markdown governance documents; Bash 3.2.57-compatible repository tooling
**Primary Dependencies**: Existing repository test harness and POSIX shell utilities; no new dependency
**Storage**: Repository files under `.highway/governance/` and `.highway/library/knowledge/`
**Testing**: Focused governance and experience-standard checks plus `.highway/tools/tests/run-all.sh`
**Target Platform**: macOS and GNU-like environments supported by the existing Bash suite
**Project Type**: Repository governance and documentation
**Performance Goals**: No runtime performance requirement; governance checks complete in one local suite run
**Constraints**: Preserve existing rule identifiers and X2.1-X2.6 text; keep new rules observable,
single-keyword, tiered, and within normative-section limits; do not amend existing skills
**Scale/Scope**: Two governance documents, three named context documents, two new X rules, and
focused validation of the constitutional and experience contracts

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-checked after Phase 1 design.*

- **D1.5 PASS**: The plan names the retained governance documents and their validation surfaces.
- **D2.1 PASS**: The implementation uses Markdown and Bash 3.2-compatible checks only.
- **D2.2/D2.4 PASS**: No runtime or external dependency is introduced.
- **D3.1/D3.2 REQUIRED**: Run focused governance checks and the full repository suite after edits.
- **D3.8 REQUIRED**: Separate static document-contract evidence from executed validation results.
- **D5.3 REQUIRED**: This feature directory and its artifacts retain Feature 088 identity.
- **D6.1/D6.2 PASS**: New design references target existing governance and knowledge paths.
- **D8.1 REQUIRED**: Review skills that cite changed shared governance artifacts; unchanged skills
  remain outside this feature's implementation scope.
- **Code Generation Gate N/A**: No source code is created or modified.
- **Testing Gate N/A**: No executable behavior is changed; documentation and governance validation
  checks are required by the feature's acceptance criteria.
- **Security Gate N/A**: The feature introduces no security, credential, network, or external-data
  behavior.
- **Maintainability Gate PASS**: Retained governance documents are the intended outputs; no code
  comments are required.
- **Performance Gate N/A**: No loop, network call, database query, or filesystem scan is introduced
  by the feature behavior.

No constitution violation requires a complexity exception.

## Project Structure

### Documentation (this feature)

```text
specs/088-repository-context-guidance/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── checklists/
│   └── requirements.md
└── tasks.md                  # Created later by /speckit-tasks
```

### Source and validation paths

```text
.highway/governance/
├── constitution.md
└── experience-standard.md
.highway/library/knowledge/
├── highway-identity.md
├── highway-platform-objectives.md
└── highway-vision.md
.highway/tools/tests/
├── constitution-inventory.test.sh
└── highway-ux-alignment.test.sh
```

**Structure Decision**: This is a governance-document amendment. The two existing governance
documents are edited in place, the three existing knowledge documents provide the named context
sources, and existing focused tests plus the full suite validate structure and experience rules.
No application source tree, service layer, database, or external contracts directory is introduced.

## Phase 0: Research Decisions

Research is recorded in [research.md](research.md). The resolved decisions are:

1. Amend the two existing governance documents only; affected skills are follow-up work.
2. Treat the three knowledge files as authoritative repository context, with accepted artifacts as
   supplements that cannot replace or reinterpret them.
3. Resolve overlapping context deterministically as Identity -> Vision -> Platform Objectives.
4. Require context declaration before selective context consumption, and select documents from the
   declared purpose, inputs, outputs, and workflow decisions.
5. Add X2.7 and X2.8 without changing X2.1-X2.6.
6. Validate constitutional rule structure, Observables, tiers, counts, and section lengths before
   completion.
7. Skip `contracts/` because no external interface is introduced.

## Phase 1: Design Outputs

- [data-model.md](data-model.md) defines governance entities, authority relationships, precedence,
  participation, relevance, and validation invariants.
- [quickstart.md](quickstart.md) defines focused document checks, no-context and precedence probes,
  and full-suite validation.
- No `contracts/` artifact is required because the feature changes repository governance documents,
  not an API, CLI schema, endpoint, or protocol.

## Implementation Approach

1. Amend `.highway/governance/constitution.md` with repository-context definitions, locations,
   authority boundaries, selective input rules, deterministic precedence, and verification guidance.
2. Amend `.highway/governance/experience-standard.md` with Repository Context, Contextual Guidance,
   X2.7, X2.8, context-awareness guidance, and the non-promotional acknowledgment boundary.
3. Preserve all existing rule identifiers and text outside the explicitly added content, especially
   X2.1-X2.6 and existing authority precedence.
4. Add or extend focused validation for unique rule identifiers, rule shape, precedence ordering,
   absent-context behavior, and experience-standard alignment.
5. Run the focused checks and `.highway/tools/tests/run-all.sh`; record static and executable evidence
   separately.

## Complexity Tracking

No violations or complexity exceptions are present.
