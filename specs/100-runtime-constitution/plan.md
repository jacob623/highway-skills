# Implementation Plan: Revise the Runtime Skills Constitution

**Branch**: `100-runtime-constitution` | **Date**: 2026-09-29 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/100-runtime-constitution/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Amend `.highway/governance/constitution.md` from 3.0.1 to 4.0.0 so it governs a shipped skill at runtime. Remove the development-only gates, review procedure, authoring workflow, and merge decision. Replace per-step failure rules and post-write completion checks with one common failure model and an owner/orchestrator contract. Keep runtime safety, ownership, determinism, portability, versioning, shared templates, and Experience Standard compliance.

The confirmed boundary is this file only. Shipped skill text and development governance stay unchanged. The amendment record, identifier map, and acceptance checks are in [research.md](./research.md) and [contracts/skills-constitution-amendment.md](./contracts/skills-constitution-amendment.md).

## Technical Context

**Language/Version**: Markdown governance document. No script changes.

**Primary Dependencies**: The Skills Constitution's own versioning policy and self-application rules. No new dependency.

**Storage**: One file, `.highway/governance/constitution.md`. Existing sync-impact history stays in that file. The new report is prepended.

**Testing**: Document review described in [quickstart.md](./quickstart.md). No test file is edited. `constitution-inventory.test.sh` is expected to fail after the edit because it hardcodes the current Principle XII set, the version footer, and the compliance-review evidence line.

**Target Platform**: The shipped Highway tree. The constitution already ships under `.highway/governance`.

**Project Type**: Runtime governance amendment for a repository-distributed skill suite

**Performance Goals**: None. This is a document change.

**Constraints**: One file. Retired identifiers are not reused. Each new or redefined rule has one keyword, one obligation, and no more than 25 words. The shipped file contains neither `.specify/` nor `specs/`. Skill files and `.specify/memory/constitution.md` stay byte-identical. No runtime rule is added to keep a historical test green.

**Scale/Scope**: One major amendment. The identifier map in the contract is the full set of removals, redefinitions, and new rules.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

This feature edits `.highway/governance/constitution.md` only. That path ships. It does not edit `.highway/tools/`, a generator, `.highway/skills/`, or `.highway/library/`.

### Process gates

| Gate | Verdict | Evidence / scope |
|---|---|---|
| Packaging Gate (D1.1, D1.2, D6.2) | PASS | The constitution already ships. The amendment must not introduce `.specify/` or `specs/`. It adds no cross-reference to a missing path. Skill files are unchanged, so the packaged skill validator still sees the same skills. |
| Toolchain Gate (D2.1–D2.4) | N/A | No file under `.highway/tools/` is edited. |
| Generator Gate (D4.1–D4.4) | N/A | No `generate-*.sh` script is edited. |
| Correspondence Gate (D4.5–D4.7) | N/A | No skill directory and no generator input is edited. |
| Validation Gate (D3.4, D3.5) | N/A | No validation check is added or modified. |
| D3.1 | PASS | Implementation starts from the current green suite. |
| D3.2 | EXCEPTION | The suite cannot exit 0 after a constitution-only edit. `constitution-inventory.test.sh` requires P12.1 through P12.5, the N6 mapping, the current precedence labels, `**Version**: 3.0.1`, `**Last Amended**: 2026-09-25`, and a Compliance Review Protocol evidence line. The confirmed scope forbids editing that test. See Complexity Tracking. |
| D3.3 | EXCEPTION | A behavioral change would normally edit a file under `.highway/tools/tests/`. The confirmed scope forbids that edit. The follow-on tooling change owns it. |
| D6.1 | EXCEPTION | Live docs that describe the removed gates become stale. The confirmed scope forbids editing them in this change. |

Process result: PASS for every triggered gate whose trigger this change can satisfy inside the confirmed file. D3.2, D3.3, and D6.1 are recorded exceptions, not silent omissions.

### Skill content gates

N/A: Skill Content Gate not triggered.

The amended document still has to satisfy its own self-application review: P1.1 through P1.4, P6.4, P6.6, and P7.3. That review is part of the amendment record. It is not a Skill Content Gate verdict, because no file under `.highway/skills/` or `.highway/library/` changes.

**Post-design re-check**: PASS with the same three exceptions. Phase 1 adds no second file, no skill edit, and no test edit. The identifier map and the prohibited-token rule are fixed in [contracts/skills-constitution-amendment.md](./contracts/skills-constitution-amendment.md).

## Project Structure

### Documentation (this feature)

```text
specs/100-runtime-constitution/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── skills-constitution-amendment.md
├── checklists/requirements.md
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/governance/constitution.md                        # version 4.0.0
.highway/tools/tests/constitution-inventory.test.sh        # assertions follow the amended constitution
```

**Structure Decision**: The runtime constitution is already the shipped governance document. This amendment revises that document in place. Skill bodies, the development constitution, validators, and other docs stay untouched until a later change.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|---|---|---|
| D3.2 for every test except `constitution-inventory.test.sh` | That inventory test is updated in this change. Other tests still encode the pre-amendment rules, and this change does not edit them. | Editing every validator test would widen the change into the deferred tooling update. |
| D3.3 is satisfied by `constitution-inventory.test.sh` only | The behavioral change amends that one test. No other test file is edited. | A new test file is unnecessary. The existing inventory test is the check that reads this document. |
| D6.1: docs outside the constitution and the inventory test are not updated here | Those docs are not the runtime constitution. | Updating them now would change artifacts left unchanged by the confirmed boundary. |

A plan that records a FAIL does not proceed to tasks under the development constitution. These three items are recorded as exceptions with that consequence named: `/speckit-tasks` may decompose the constitution edit only if this exception is accepted. Widening the feature to include the inventory test and the stale docs removes the exception.
