# Implementation Plan: Relationship Reconciliation and Integrity Management

**Branch**: `031-relationship-reconciliation-integrity` | **Date**: 2026-09-09 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/031-relationship-reconciliation-integrity/spec.md`

## Summary

Add a standalone `highway-relationships` skill that inspects the existing identifier-only
Control-to-NFR graph, classifies valid and invalid findings, produces deterministic repair and
impact proposals, and applies only explicitly approved relationship-field changes. The skill will
not create Controls or NFRs, alter governance wording, infer intent, or introduce another
relationship store. Existing Control and NFR workflows will call the relationship skill for
preflight impact analysis before destructive operations.

## Technical Context

**Language/Version**: Markdown skill contract and Bash 3.2.57-compatible repository tests

**Primary Dependencies**: Existing Control/NFR record formats, governance catalogs, validators, generated catalog and adapter tooling, and shell test harness

**Storage**: User-owned `library/governance/controls/` and `library/governance/nfrs/` records plus existing catalogs; `Control.nfrs` and `NFR.controls` remain the only relationship storage

**Testing**: Focused relationship-integrity contract test with disposable fixtures, skill/library validators, generated correspondence checks, packaging checks, full `.highway/tools/tests/run-all.sh`, and `git diff --check`

**Target Platform**: Distributed Highway tree on macOS Bash 3.2.57 and compatible shell utilities

**Performance Goals**: Inspect and sort a normal governance baseline within one interactive workflow; produce stable output for repeated identical inputs

**Constraints**: Read-only inspection; proposal-before-write repair; explicit confirmation; identifier-only relationship mutations; no timestamps, randomness, environment-derived values, or catalog-order dependence; no partial writes; preserve user-owned content; no Phase 5+ relationship types

**Scale/Scope**: One new relationship-management skill, two existing workflow preflight integrations, one focused fixture/test surface, generated registration artifacts, and existing Control/NFR records and catalogs

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process Gates

| Gate | Trigger | Verdict |
|---|---|---|
| Packaging Gate | Adds a shipped skill and generated adapters | PASS on completion: the new skill will be self-contained and development-only fixtures/tests remain excluded |
| Toolchain Gate | Adds `.highway/tools/` tests and fixtures | PASS: Bash 3.2.57-compatible utilities only; no runtime dependency or new package |
| Generator Gate | Adds a skill and changes generated registration inputs | PASS on completion: catalogs, adapters, and manifests will be regenerated and correspondence-tested |
| Correspondence Gate | Modifies `.highway/skills/` and generated surfaces | PASS on completion: source skill, catalog entries, adapter trees, and distribution declarations will agree |
| Validation Gate | Adds behavioral integrity tests | PASS: invalid, asymmetric, orphan, inspect, confirmation, atomicity, and deterministic fixtures are isolated before the test is enabled |
| Spec Record Gate | Adds `specs/031` | PASS: sequential append-only feature record; prior records remain untouched |
| Skill Content Gate | Adds `highway-relationships` and updates destructive-operation routing | PASS on completion: workflow, outputs, verification, errors, and user ownership are explicit |

### Applicable Skill-Content Obligations

- `P1.1-P1.7`: Keep inspect, proposal, confirmation, repair, and failure rules atomic.
- `P5.1-P5.6`: Name next actions for malformed baselines, empty findings, declined repair, and incomplete confirmation.
- `P6.1-P6.6`: Use canonical identifier ordering and deterministic finding classification.
- `P8.1-P8.7`: Number the workflow where applicable, declare verification, and avoid relative links.
- `X2.1`: Preserve user ownership and require confirmation before repair writes.
- `X4.1`: Declare reports, proposals, relationship-field changes, and catalog outputs.
- `X6.1`: Keep reports and repair proposals timestamp-free and deterministic.

**Gate result**: PASS; no unresolved clarification remains and the feature is limited to Control/NFR
relationship integrity.

## Project Structure

### Documentation (this feature)

```text
specs/031-relationship-reconciliation-integrity/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── relationship-integrity-workflow.md
└── checklists/requirements.md
```

### Source and Test Surface

```text
.highway/skills/highway-relationships/SKILL.md
.highway/skills/highway-controls/SKILL.md
.highway/skills/highway-nfrs/SKILL.md
.highway/tools/tests/relationship-integrity.test.sh
.highway/tools/tests/fixtures/relationship-integrity/
.highway/catalog/
.highway/tools/.adapter-manifest
.highway/tools/.distribution-manifest
.github/skills/highway-relationships/SKILL.md
.claude/skills/highway-relationships/SKILL.md
.cursor/rules/highway-relationships.mdc
```

User-owned data remains outside the framework:

```text
library/governance/controls/CTLXXXXXX.md
library/governance/controls.md
library/governance/nfrs/NFRXXXXXX.md
library/governance/nfrs.md
```

**Structure Decision**: Add an independent relationship-management skill because integrity validation
must be invocable without creating or deriving either artifact. Keep relationship data in the
existing frontmatter fields, use temporary governance trees for tests, and update Control/NFR
workflows only to route destructive operations through impact analysis.

## Implementation Sequence

1. Capture current Control/NFR field formats, catalog ownership, destructive-operation confirmation
   rules, generated-surface conventions, and user-data boundaries.
2. Define the canonical graph model, finding classifications, repair proposal shape, impact-analysis
   output, confirmation states, and atomicity rules in design artifacts and fixtures.
3. Add `highway-relationships` with inspect and repair modes, deterministic ordering, explicit
   confirmation, relationship-only writes, and safe-stop behavior.
4. Add Control/NFR destructive-operation preflight wording that invokes impact analysis without
   transferring artifact ownership or changing creation/derivation behavior.
5. Add focused fixtures/tests for valid, malformed, orphaned, asymmetric, declined, approved,
   partial-approval, destructive-impact, direct-NFR, deterministic, and failure scenarios.
6. Regenerate catalogs, adapters, and manifests, then run validators, packaging, correspondence,
   the full suite, quickstart scenarios, and whitespace validation.

## Phase 0

### Research Summary

- A standalone skill is the correct ownership boundary: validation and repair must be independently
  invocable and must not be coupled to Control/NFR creation or derivation.
- Existing `nfrs` and `controls` fields are sufficient; no schema migration or alternate relationship
  store is needed. Repair mutates only those lists and preserves all other frontmatter/body fields.
- Findings will be normalized into canonical edge keys, sorted by source type, source ID, target type,
  target ID, and finding class. This removes dependence on filesystem or catalog ordering.
- Inspection is always read-only. Repair first renders a complete recommendation, then requires
  explicit approval; rejection, cancellation, or incomplete decisions produce zero writes.
- Approved repairs will be staged and validated as a complete set before commit so an invalid baseline
  or failed relationship mutation cannot leave one-sided partial state.
- Destructive operations remain owned by `highway-controls` and `highway-nfrs`; those workflows call
  relationship impact analysis before confirmation rather than delegating artifact deletion.

## Phase 1

### Design Decisions

### Graph and Finding Model

Parse every Control `nfrs` value and NFR `controls` value as an identifier-only edge. Validate prefix,
format, target existence, target type, reciprocal membership, duplicate membership, and baseline
uniqueness. Classify findings as valid, malformed, orphaned, asymmetric, duplicate, or blocked by a
malformed baseline. A direct NFR with `controls: []` is valid and produces no inferred edge.

### Canonical Determinism

Sort records by type and immutable identifier, sort relationship values by immutable identifier for
reports and proposed output, and sort findings by source type/source ID/target type/target ID/class.
Reports and proposals contain no timestamps, random values, environment data, or catalog sequence
beyond the identifiers already present in the baseline.

### Proposal and Confirmation Contract

Each repair recommendation contains artifact path/type and immutable ID, current relationship state,
proposed relationship state, reason, and impact. Reciprocal repairs add only the missing ID; orphan
repairs remove only the invalid reference. Recommendations are independently selectable. The full
proposal is shown before any write, and explicit confirmation is required. Decline, cancel, or
incomplete confirmation leaves all files unchanged.

### Atomic Repair Boundary

Before committing, validate the baseline, every selected recommendation, both relationship sides,
identifier immutability, and the expected file snapshots. Apply the selected relationship-only
mutations as one approved operation and regenerate only existing catalog outputs required by the
repository. If any precondition or write cannot be satisfied safely, stop before partial writes.

### Destructive Impact Analysis

For Control removal, NFR removal, and baseline replacement, list every affected artifact by immutable
identifier and title, including all relationship edges that would be lost. A count is insufficient.
No destructive operation proceeds without explicit confirmation after the complete impact list is
shown. An empty impact set is reported explicitly and does not invent affected entries.

## Post-Design Constitution Re-check

The Phase 1 design leaves all initial verdicts unchanged:

- **Packaging Gate**: PASS on completion; the new skill is self-contained and test fixtures remain excluded.
- **Toolchain Gate**: PASS; tests use the declared Bash-compatible toolchain only.
- **Generator Gate**: PASS on completion; generated catalogs, adapters, and manifests are regenerated.
- **Correspondence Gate**: PASS on completion; source, catalog, adapter, and distribution surfaces are checked together.
- **Validation Gate**: PASS; graph classification, proposal ordering, confirmation, atomicity, impact, and preservation are covered.
- **Spec Record Gate**: PASS; Feature 031 is sequential and prior records are untouched.
- **Skill Content Gate**: PASS on completion; the new skill declares modes, outputs, verification, errors, and exclusions.

No complexity violation or new relationship store is required.

## Complexity Tracking

No constitution violations or new abstractions are required. The feature adds one ownership-aligned
skill and reuses existing record fields, catalogs, validators, and generated-surface conventions.
