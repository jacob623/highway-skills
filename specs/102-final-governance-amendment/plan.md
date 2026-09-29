# Implementation Plan: Final Governance Amendment

**Branch**: `102-final-governance-amendment` | **Date**: 2026-09-29 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/102-final-governance-amendment/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Amend `.highway/governance/constitution.md` from 4.1.0 to 5.0.0 so an oversized skill is reduced until it meets the existing size limits. P7.4 and P7.5 stay. P7.3 stays. Every other current constitution rule stays, and the older sync reports stay.

Amend `.highway/governance/experience-standard.md` from 3.0.0 to 4.0.0 so Decision Context uses the label `**Why it matters:**`, and so Profile enrichment, Objectives, Controls, and Non-Functional Requirements share a recommendation meaning that does not require a numbered list. Replace the accumulated Experience Standard sync reports with the single current report.

Update the tests and the live authoring citation that still require a split, the previous Decision Context wording, a numbered recommendation list, or the removed history. Do not rewrite skill domain workflows.

The target rows are in [contracts/constitution-size-rule.md](./contracts/constitution-size-rule.md) and [contracts/experience-standard-amendment.md](./contracts/experience-standard-amendment.md).

## Technical Context

**Language/Version**: Markdown governance documents. Existing Bash 3.2 tests. No new script and no parser change.

**Primary Dependencies**: Each document's own versioning policy, the Skills Constitution clarity rules for the redefined P7.6 row, and the existing rule parser. No new dependency.

**Storage**: Two shipped governance files. The constitution prepends one report and keeps older reports. The Experience Standard replaces its opening history comment with one report.

**Testing**: `.highway/tools/tests/run-all.sh` exits 0 before any edit in this feature and again after the final edit. The tests named in research are updated first and observed failing before the governance text changes. Replaced assertions name the superseded behavior. The full suite writes temporary directories and is run with unrestricted filesystem access.

**Target Platform**: The shipped Highway tree. Both documents already ship under `.highway/governance`.

**Project Type**: Runtime governance amendment for a repository-distributed skill suite

**Performance Goals**: None. This is a document change.

**Constraints**: P7.6 keeps one keyword, one obligation, and no more than 25 words, and stays `[agent-checkable]`. The authoring citation does not copy that rule sentence. Experience Standard rows keep the tier column. Neither shipped governance file contains `.specify/` or `specs/`. Skill domain workflows, shared templates, generators, the specimen check, and the development constitution stay unchanged. Constitution history stays. Experience Standard history does not.

**Scale/Scope**: One major Skills Constitution amendment and one major Experience Standard amendment, plus the tests and the one live citation those amendments invalidate.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

This feature edits the two governance documents, the tests that pin the superseded sentences or the removed Experience Standard history, and the authoring citation that still tells an author to split a skill. It does not edit a generator, a shared template, a skill domain workflow, the specimen check, or the development constitution.

### Process gates

| Gate | Verdict | Evidence / scope |
|---|---|---|
| Packaging Gate (D1.1, D1.2, D6.2) | PASS | Both governance documents already ship. The amendments must not introduce `.specify/` or `specs/`. The authoring citation still names P7.4, P7.5, and P7.6. |
| Toolchain Gate (D2.1–D2.4) | PASS | Test edits stay in the existing shell toolchain. No new dependency or non-portable construct is added. |
| Generator Gate (D4.1–D4.4) | N/A | No `generate-*.sh` script is edited. |
| Correspondence Gate (D4.5–D4.7) | N/A | No skill directory is added, removed, or modified, and no declared-generator input changes. The authoring standard is not a generated skill. |
| Validation Gate (D3.4, D3.5) | N/A | No validation check is added or retargeted. P7.6 stays `[agent-checkable]`. |
| D3.1 | PASS | The suite exits 0 before the first edit of this feature. |
| D3.2 | PASS | The suite exits 0 after the final edit. |
| D3.3 | PASS | `highway-ux-alignment.test.sh`, `experience-standard-amendment.test.sh`, and `constitution-inventory.test.sh` are edited. |
| D3.5 | PASS | Assertions that stop requiring removed history, or that stop requiring the old rule sentences, name that superseded behavior in a comment. |
| D3.6 | PASS | Each updated test is observed failing on the current text before the governance edit that makes it pass. |
| D6.1 | PASS | `.highway/skills/_authoring-standard.md` stops teaching a split. The three tests stop requiring the superseded sentences and the removed Experience Standard history. |

Process result: PASS. No gate is left as an exception.

### Skill content gates

The Skill Content Gate triggers because `.highway/skills/_authoring-standard.md` is edited. No `SKILL.md` domain workflow is edited.

| Rule | Verdict | Evidence |
|---|---|---|
| P7.3 | PASS | The authoring citation names P7.4, P7.5, and P7.6. It does not copy the redefined P7.6 sentence. |
| P7.4, P7.5 | PASS | The existing limits stay the limits. The citation still names them. |
| P7.6 | PASS | The citation describes reduction of the same skill. It does not require additional skills. |

Other Skills Constitution rules are unchanged by that citation. The amended constitution still records its own self-application review against P1.1, P1.2, P1.3, P1.4, P6.4, P6.6, and P7.3.

**Post-design re-check**: PASS. The target rows, the history boundary, the test list, and the citation wording are fixed in the contracts and in [research.md](./research.md).

## Project Structure

### Documentation (this feature)

```text
specs/102-final-governance-amendment/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── constitution-size-rule.md
│   └── experience-standard-amendment.md
├── checklists/requirements.md
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/governance/constitution.md
.highway/governance/experience-standard.md
.highway/skills/_authoring-standard.md
.highway/tools/tests/constitution-inventory.test.sh
.highway/tools/tests/experience-standard-amendment.test.sh
.highway/tools/tests/highway-ux-alignment.test.sh
```

**Structure Decision**: The Skills Constitution and the Experience Standard remain the governance sources. Three tests follow the new sentences and the history boundary. The authoring standard changes one citation. Skill domain files, generated adapters, shared templates, and the development constitution stay untouched.

## Complexity Tracking

No constitution gate is violated. Tests and the authoring citation are in this change, so the verification and documentation gates pass without leaving skill domain workflows in scope.
