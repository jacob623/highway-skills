# Implementation Plan: Feature Completeness and Behavioral Evidence Enforcement

**Branch**: `032-feature-completeness-enforcement` | **Date**: 2026-09-10 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/032-feature-completeness-enforcement/spec.md`

## Summary

Restore completion accountability for Features 030 and 031 and replace static phrase-only evidence
with executable validation of their promised workflows. The plan adds authoritative requirement
coverage records, extends the existing Bash fixture harness with disposable-tree behavioral cases,
defines atomic commit and rollback expectations, documents duplicate and impact semantics, and
aligns lifecycle claims with the evidence actually available.

## Technical Context

**Language/Version**: Markdown governance records and Bash 3.2.57-compatible test scripts

**Primary Dependencies**: Existing `.highway/tools/tests` harness, governance record templates,
completion-coverage validator, Control/NFR skill contracts, and standard declared shell utilities

**Storage**: Development artifacts under `specs/`; disposable copies of `library/governance/` and
catalog files for behavioral tests; existing user-owned Control/NFR records remain authoritative

**Testing**: Focused Feature 030 and 031 behavioral tests, completion-coverage test, existing
validators, generated-surface checks, packaging checks, full `run-all.sh`, and `git diff --check`

**Target Platform**: macOS Bash 3.2.57 and the repository's compatible distributed-tree shell
environment

**Project Type**: Governance skill suite with Markdown contracts and fixture-driven shell validation

**Performance Goals**: Complete focused disposable-tree scenarios within the existing interactive
test-runner expectations; repeated deterministic cases must produce byte-identical outputs

**Constraints**: No new runtime dependency; preserve Bash 3.2 compatibility; keep tests isolated;
preserve user-owned bytes; distinguish structural, documentation-only, and executable evidence;
ensure accepted operations are all-or-nothing; do not add a second relationship store

**Scale/Scope**: Features 030 and 031 only; 36 historical functional requirements mapped by two
coverage records; focused tests for generation, review, inspection, repair, impact, determinism,
failure injection, preservation, and lifecycle consistency

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process Gates

| Gate | Trigger | Verdict |
|---|---|---|
| Layer Gate | Adds only development artifacts and test fixtures | PASS: no shipped artifact references development paths |
| Toolchain Gate | Adds or changes Bash tests | PASS: declared Bash-compatible utilities only; no runtime dependency |
| Verification Gate | Adds behavioral checks | PASS on completion: red-to-green evidence will be recorded and focused tests run before the full suite |
| Coverage Gate | Completes remediation of Features 030/031 | PASS on completion: both features receive one-to-one requirement coverage records |
| Task Correspondence Gate | Adds implementation tasks later | PASS on completion: each task will name an artifact containing its change |
| Preservation Gate | Exercises governed writes | PASS on completion: disposable baselines and byte-preservation assertions cover unrelated content |

### Applicable Development Rules

- `D1.1`, `D1.2`: keep development-only records and fixtures out of distributed paths.
- `D2.1`-`D2.4`: preserve Bash 3.2 and declared-toolchain compatibility with no new dependency.
- `D3.1`-`D3.6`: capture a passing baseline, add behavioral tests, record red-to-green evidence, and finish with the full suite.
- `D5.4`: retain sequential feature numbering.
- `D7.1`-`D7.3`: keep task/artifact correspondence, exact requirement coverage, and separate coverage from test results.

**Gate result**: PASS; all implementation choices are bounded by existing repository conventions and
the spec contains no unresolved clarification.

## Project Structure

### Documentation (this feature)

```text
specs/032-feature-completeness-enforcement/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── behavioral-evidence.md
├── checklists/
│   └── requirements.md
└── tasks.md                         # created by /speckit-tasks
```

### Validation and Existing Contract Surface

```text
.highway/tools/tests/control-derived-nfr.test.sh
.highway/tools/tests/relationship-integrity.test.sh
.highway/tools/tests/completion-coverage.test.sh
.highway/tools/tests/fixtures/control-derived-nfr/
.highway/tools/tests/fixtures/relationship-integrity/
specs/030-control-derived-nfr-generation/coverage.md
specs/031-relationship-reconciliation-integrity/coverage.md
```

User-owned data remains outside the framework and is accessed only through disposable test copies:

```text
library/governance/controls/CTLXXXXXX.md
library/governance/nfrs/NFRXXXXXX.md
.highway/catalog/
```

**Structure Decision**: Keep the remediation in development records and the existing focused test
surface. Extend the current contract tests into executable fixture-driven checks rather than adding
a parallel runner, service, or storage layer. Add one design contract to define the shared evidence,
atomicity, duplicate, and impact expectations used by both feature test suites.

## Implementation Sequence

1. Capture the current completion-coverage grammar, lifecycle conventions, Control/NFR field formats,
   fixture layout, and test-runner cleanup behavior.
2. Define the evidence status vocabulary, coverage-row rules, behavioral case shape, atomic operation
   boundary, duplicate normalization rule, and baseline-replacement impact input/output in the design
   artifacts.
3. Record red-to-green evidence for the missing coverage and behavioral cases before marking them
   complete; add coverage records for Features 030 and 031 with honest evidence statuses.
4. Replace phrase-only assertions in the Feature 030 test with disposable-tree execution of candidate
   generation, review outcomes, allocation, relationships, invalid baselines, and preservation.
5. Replace phrase-only assertions in the Feature 031 test with graph parsing/classification, repair
   proposals, confirmation states, subset decisions, duplicate handling, impact analysis, atomic
   failure, determinism, and preservation.
6. Align Feature 030/031 status and task/coverage wording with the observed evidence, then run focused
   checks, completion coverage, the full suite, and whitespace validation.

## Phase 0

### Research Summary

- The existing completion-coverage checker is the authoritative grammar: each completed feature needs
  one coverage row per functional requirement, with satisfied or explicitly deferred evidence.
- Behavioral evidence belongs in the existing Bash fixture harness because the repository targets a
  distributed tree with no runtime package dependency and already validates disposable copies.
- Atomicity must be tested at the operation boundary by snapshotting every affected file and comparing
  bytes after injected validation, staging, and write failures; a prose promise is insufficient.
- Duplicate relationship membership will be canonicalized as one occurrence per immutable identifier,
  preserving the record and all non-relationship fields.
- Baseline replacement impact will accept an explicit proposed artifact set, compare removed Controls
  and NFRs plus their relationship edges, and emit each affected artifact once in canonical order.
- Feature status will remain Draft until behavioral evidence is present; after all required evidence
  is complete, status will use the repository's established completed-state wording.

## Phase 1

### Design Decisions

#### Evidence and Coverage Model

Each historical feature receives a `coverage.md` table with one row per FR, an outcome of `satisfied`
or `deferred`, and evidence links. Evidence categories are recorded in the outcome detail: executable
behavior, structural check, documentation-only contract, or explicit deferral. Check results remain in
test evidence and are not substituted for requirement coverage.

#### Behavioral Case Model

Every focused case defines an isolated baseline, operation, expected report or write set, preservation
assertions, and cleanup assertion. Positive and negative cases use the same runner and leave no probe
files. Repeated cases compare normalized output and resulting bytes.

#### Atomic Operation Boundary

Before an accepted operation commits, validate the complete selected change set and capture affected
file snapshots. A simulated failure at validation, allocation/staging, or commit must restore all
snapshots and return a blocking result. No operation may expose a one-sided relationship or a partially
allocated NFR.

#### Relationship Semantics

Inspection classifies duplicate membership separately from malformed, orphaned, asymmetric, valid, and
blocked findings. Repair canonicalizes duplicate identifier membership to one occurrence, adds only a
missing reciprocal ID, removes only an invalid reference, and preserves all other content.

#### Impact Analysis Contract

Removal and replacement analysis receive a proposed artifact set and current baseline. The result lists
each removed artifact and every relationship edge lost, including immutable ID and title, once in
canonical source/target order. An empty impact set is explicit and requires no fabricated entries.

## Post-Design Constitution Re-check

The Phase 1 design leaves the initial gates unchanged:

- **Layer Gate**: PASS; all new records and fixtures remain development-only.
- **Toolchain Gate**: PASS; no dependency or non-portable Bash construct is introduced.
- **Verification Gate**: PASS on completion; focused tests include observable failure cases and the
  full suite remains the final check.
- **Coverage Gate**: PASS on completion; Features 030 and 031 receive exact FR mappings.
- **Task Correspondence Gate**: PASS on completion; generated tasks will name concrete artifacts.
- **Preservation Gate**: PASS on completion; snapshots and disposable copies cover unrelated content.

No complexity violation, schema migration, second relationship store, or shipped-surface change is
required.

## Complexity Tracking

No constitution violations or new abstractions are required. The feature extends existing fixture
tests and development records, adds no runtime dependency, and keeps ownership with the current
Control, NFR, relationship, and completion-coverage surfaces.
