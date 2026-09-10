# Implementation Plan: Control-Derived NFR Generation

**Branch**: `030-control-derived-nfr-generation` | **Date**: 2026-09-09 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/030-control-derived-nfr-generation/spec.md`

## Summary

Activate the reserved `Control.nfrs` and `NFR.controls` fields through a one-way, review-first
workflow owned by `highway-controls`. A newly accepted Control produces deterministic NFR
proposals; the author accepts, modifies, replaces, or rejects each proposal before any NFR write.
Accepted candidates use the existing NFR allocator and catalog, write both identifier-only
relationship fields, and preserve direct `highway-nfrs` authoring with `controls: []`.

No reverse generation, automatic reconciliation, deletion coupling, broken-link repair, or new
relationship store is introduced.

## Technical Context

**Language/Version**: Markdown skill contracts and Bash 3.2.57-compatible repository tests

**Primary Dependencies**: Existing `highway-controls` and `highway-nfrs` skills, governance record templates, catalog/adapter generators, validators, and shell test harness

**Storage**: User-owned Control and NFR records/catalogs under `<project>/library/governance/`; existing `nfrs` and `controls` frontmatter fields remain the only relationship storage

**Testing**: Focused Control-derived workflow tests, deterministic proposal fixtures, write-order and rejection tests, relationship assertions, validators, generated correspondence, packaging, and `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway tree on macOS Bash 3.2.57 and compatible shell utilities

**Project Type**: Agent-skill governance authoring workflow

**Performance Goals**: Candidate generation and review complete within one interactive workflow; repeated generation for identical Control content produces identical proposal output

**Constraints**: User review precedes every derived NFR write; no timestamps, randomness, environment inputs, or catalog ordering in proposal generation; immutable identifiers; root-level user-data preservation; no record-format change; no Phase 4 reconciliation behavior

**Scale/Scope**: Two existing skills, two reserved relationship fields, one deterministic proposal contract, focused fixtures/tests, generated registration artifacts, and user-owned governance outputs

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process Gates

| Gate | Trigger | Verdict |
|---|---|---|
| Packaging Gate | Touches shipped skills and generated adapters | PASS on completion: shipped content will contain no development-only paths, and root-level governance remains outside the package |
| Toolchain Gate | Touches `.highway/tools/` tests | PASS: Bash 3.2.57 and the declared utility set only; no runtime dependency |
| Generator Gate | Registration regenerates catalogs/adapters | PASS on completion: declared generators will be run and outputs compared |
| Correspondence Gate | Modifies inputs under `.highway/skills/` | PASS on completion: source skills, catalogs, adapters, adapter manifest, and distribution manifest will correspond |
| Validation Gate | Adds behavioral tests | PASS: new fixtures are evaluated before the check is enabled and existing assertions are preserved |
| Spec Record Gate | Adds `specs/030` | PASS: sequential feature record; prior completed specifications remain untouched |
| Skill Content Gate | Modifies `.highway/skills/` | PASS on completion: validate against the Highway Skills Constitution and Experience Standard, including deterministic workflow and declared outputs |

### Applicable Skill-Content Obligations

- `P1.1-P1.7`: Keep proposal, review, write, and failure rules atomic and explicit.
- `P5.1-P5.6`: Name the next action for invalid baselines, cancelled review, rejection, and ambiguous decisions.
- `P6.1-P6.6`: Make action selection and candidate handling deterministic.
- `P8.1-P8.7`: Number the workflow, state write ordering, and include verification.
- `X2.1`: Preserve user ownership and avoid writes before review.
- `X4.1`: Declare proposal, record, catalog, and relationship outputs.
- `X6.1`: Keep generated proposal/catalog output deterministic and timestamp-free.

**Gate result**: PASS; the feature has no unresolved clarification and remains bounded to initial
Control-derived creation.

## Project Structure

### Documentation (this feature)

```text
specs/030-control-derived-nfr-generation/
├── plan.md              # This file
├── research.md          # Phase 0 decisions
├── data-model.md        # Phase 1 entities and invariants
├── quickstart.md        # Phase 1 validation guide
├── contracts/
│   └── derived-nfr-workflow.md
└── tasks.md             # Created later by /speckit.tasks
```

### Source and Test Surface

```text
.highway/skills/highway-controls/SKILL.md
.highway/skills/highway-nfrs/SKILL.md
.highway/library/templates/output/control-record.md
.highway/library/templates/output/nfr-record.md
.highway/tools/tests/control-derived-nfr.test.sh
.highway/tools/tests/fixtures/control-derived-nfr/
.highway/catalog/
.github/skills/highway-controls/SKILL.md
.github/skills/highway-nfrs/SKILL.md
.claude/skills/highway-controls/SKILL.md
.claude/skills/highway-nfrs/SKILL.md
.cursor/rules/highway-controls.mdc
.cursor/rules/highway-nfrs.mdc
.highway/tools/.adapter-manifest
.highway/tools/.distribution-manifest
```

User-owned output remains outside `.highway/`:

```text
library/governance/controls/CTLXXXXXX.md
library/governance/controls.md
library/governance/nfrs/NFRXXXXXX.md
library/governance/nfrs.md
```

**Structure Decision**: Extend the existing Controls workflow and reuse the existing NFR creation
and catalog rules. Candidate generation and review are expressed in the Controls skill; NFR skill
text is updated only to activate the accepted relationship input and preserve empty relationships
for direct authoring. Tests use temporary user-governance trees and fixture Controls/NFRs so no live
root-level governance data is created.

## Implementation Sequence

1. Capture the existing reserved-field behavior, baseline allocation rules, and root-level user-data
   state; evaluate every existing governance fixture against the proposed contract.
2. Define the deterministic Control-to-candidate mapping and proposal/review contract in the
   focused test and design documents before enabling writes.
3. Add the review-first derived-NFR workflow to `highway-controls`, preserving the existing Control
   creation semantics and stopping cleanly on rejection or cancellation.
4. Update `highway-nfrs` and the two record templates to describe accepted relationships while
   retaining `controls: []` for direct NFR authoring.
5. Add relationship write-back for accepted candidates using the existing fields and allocator;
   reject partial writes when the NFR baseline/catalog is invalid.
6. Regenerate catalogs, adapters, and manifests, then run focused tests, validators, packaging,
   and the full suite.

## Phase 0: Research Summary

- The existing templates already reserve the exact fields needed: Controls use `nfrs: []` and NFRs
  use `controls: []`; no schema migration or relationship database is needed.
- Controls are the correct initiation point because `highway-controls` creates the originating
  immutable identifier and already owns the add workflow. `highway-nfrs` remains the direct-authoring
  owner and should not independently infer Controls.
- Candidate generation will use a stable ordered rule table based only on normalized Control content.
  Each matched rule emits a fixed title/statement/rationale template; an unmatched Control emits no
  candidate. The rule table is a repository-owned contract, while final wording remains user-owned
  after review.
- Review is a hard write barrier. Proposal rendering occurs before NFR allocation, record creation,
  catalog regeneration, or relationship mutation; accepted candidates are then processed in stable
  candidate order.
- Tests will use disposable root-level governance trees and compare snapshots before and after
  rejected/cancelled/invalid runs. No live `library/governance/` content is created by focused tests.

## Phase 1: Design Decisions

### Candidate Mapping

Normalize only the Control statement and title for rule matching; do not use timestamps, environment
values, random values, existing catalog order, or current baseline contents. Rules are evaluated in a
fixed documented order. Each match produces a candidate with a stable title, statement, rationale,
and originating Control identity. A valid unmatched Control produces an explicit zero-candidate
result and remains valid.

### Review and Write Boundary

The workflow displays all candidates with Control ID/title and candidate title/statement/rationale.
The author chooses Accept, Modify, Replace, or Reject per candidate. Modify and Replace require the
resulting user-owned wording before acceptance. No NFR allocation or write occurs until the review
result is complete. A cancelled or incomplete review leaves all NFR-side state unchanged.

### Relationship and Allocation Rules

Accepted candidates use the existing NFR catalog `next_id` allocation and preserve immutable
identifiers. The new NFR receives `controls: [CTL...]`; the originating Control receives the new
NFR ID in `nfrs`. Existing relationships are preserved and duplicate IDs are not added. Direct
NFR creation continues to initialize `controls: []`.

### Failure and Transaction Boundary

Invalid Control input fails before derivation. Missing or malformed NFR catalog state, unsafe
allocation, or a write failure stops the derived operation before partial governance output is
accepted. Focused tests snapshot all affected user-owned files and assert rejection/cancellation
leave them byte-identical or absent.

## Post-Design Constitution Re-check

The Phase 1 design leaves all initial verdicts unchanged:

- **Packaging Gate**: PASS on completion; shipped skills remain self-contained and user governance is outside the distribution.
- **Toolchain Gate**: PASS; tests use existing Bash 3.2.57-compatible utilities and no new dependency.
- **Generator Gate**: PASS on completion; catalogs and adapters are regenerated rather than hand-edited.
- **Correspondence Gate**: PASS on completion; both changed skills and all generated registration surfaces are checked.
- **Validation Gate**: PASS; proposal, write-order, deterministic, rejection, and relationship fixtures are evaluated.
- **Spec Record Gate**: PASS; Feature 030 is sequential and prior records are not edited.
- **Skill Content Gate**: PASS on completion; both skills are validated against their complete contracts and generated adapters.

No complexity violation or new abstraction is required.

## Complexity Tracking

No constitution violations or new abstractions are required. The feature extends two existing skill
contracts and their established test/generator surfaces; it does not introduce a separate service,
relationship store, schema, or runtime dependency.
