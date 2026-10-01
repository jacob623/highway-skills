# Implementation Plan: Amend Experience Standard

**Branch**: `114-amend-experience-standard` | **Date**: 2026-10-01 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/114-amend-experience-standard/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Amend `.highway/governance/experience-standard.md` from 4.0.0 to 5.0.0. Decision Context follows the question. Setup keeps one response-demanding question or decision in the final interaction block, and Decision Context may follow it. Grounded recommendations are evaluated before every unresolved guided-collection question. Recommendation wording matches the number shown. A completed guided Setup domain may close with one user-relevant synthesis. Machine-consumable owner results stay out of normal conversation.

Replace the single Sync Impact Report. Do not edit skills, output templates, or other governance baselines.

Update the repository checks that still require the superseded X1.7, X2.9, or 4.0.0 contract. Add assertions for the strengthened X2.13 observable, the X2.25 observable, and X2.32 through X2.35. Those checks stay development and review infrastructure. They are not runtime dependencies of the Experience Standard or shipped skills.

The target rows and the check inventory are in [contracts/experience-standard-amendment.md](./contracts/experience-standard-amendment.md) and [contracts/repository-review-checks.md](./contracts/repository-review-checks.md).

## Technical Context

**Language/Version**: Markdown governance document. Existing Bash 3.2 tests. No new script and no parser change.

**Primary Dependencies**: The Experience Standard versioning policy and the current single-report convention. No new dependency.

**Storage**: One shipped governance file, `.highway/governance/experience-standard.md`. Three existing test files under `.highway/tools/tests/`.

**Testing**: `.highway/tools/tests/run-all.sh` exits 0 before any edit in this feature and again after the final edit. The three named tests are updated first and observed failing before the governance text changes. Replaced assertions name the superseded behavior. The full suite writes temporary directories and is run with unrestricted filesystem access. These tests are static document-contract evidence. They do not execute a guided Setup conversation, and they are not wired into skill runtime.

**Target Platform**: The shipped Highway tree for the Experience Standard. Repository review checks remain outside the packaged runtime path.

**Project Type**: Runtime governance amendment plus development-only review checks.

**Performance Goals**: None. This is a document and review-check change.

**Constraints**: X1.7, X2.9, and X2.13 keep their identifiers. X2.13 and X2.25 keep their rule sentences. X2.32 through X2.35 are added at `[agent-checkable]`. Preserved rules in the spec stay byte-stable. The Experience Standard keeps exactly one Sync Impact Report and must not contain `.specify/` or `specs/`. Skill files, output templates, generators, and the development constitution stay unchanged. A skill `version: 4.0.0` assertion is not an Experience Standard version assertion.

**Scale/Scope**: One major Experience Standard amendment, from 35 rules to 39, plus the three review files that currently pin superseded Experience Standard wording.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

This feature edits the Experience Standard and the review checks that encode its superseded contract. It does not edit a skill, a library file, a generator, a shared template, or the development constitution.

### Process gates

| Gate | Verdict | Evidence / scope |
|---|---|---|
| Packaging Gate (D1.1, D1.2, D6.2) | PASS | The Experience Standard already ships. The amendment must not introduce `.specify/` or `specs/`. Existing identity and platform-objective citations stay resolvable. No packaging script changes. |
| Toolchain Gate (D2.1–D2.4) | PASS | Test edits stay in the existing shell toolchain. No new dependency, associative array, or non-portable flag is added. |
| Generator Gate (D4.1–D4.4) | N/A | No `generate-*.sh` script is edited. |
| Correspondence Gate (D4.5–D4.7) | N/A | No skill directory is added, removed, or modified, and no declared-generator input changes. |
| Validation Gate (D3.4, D3.5) | N/A | No registered `[auto]` validation check is added or retargeted. X2.32 through X2.35 stay `[agent-checkable]`. D3.5 is still applied below because existing tests are edited. |
| D3.1 | PASS | Implementation does not edit until `.highway/tools/tests/run-all.sh` exits 0. |
| D3.2 | PASS | The same suite exits 0 after the final edit. |
| D3.3 | PASS | `highway-ux-alignment.test.sh`, `experience-standard-amendment.test.sh`, and `feature-092-contract.test.sh` are edited. |
| D3.5 | PASS | Assertions that stop requiring the 4.0.0 order or version name that superseded behavior in a comment. They are replaced by the 5.0.0 contract, not deleted to make the old document pass. |
| D3.6 | PASS | Each updated test is observed failing on the current text before the governance edit that makes it pass. |
| D3.8 | PASS | The edited tests declare static document-contract evidence. They are not recorded as executed guided-interaction behavior. Skill runtime alignment is deferred. |
| D6.1 | PASS | No live README or authoring document currently names the superseded X1.7 or X2.9 sentences. Historical `specs/` records are not live documentation and are not rewritten. |

Process result: PASS. No gate is left as an exception.

### Skill content gates

N/A: Skill Content Gate not triggered.

**Post-design re-check**: PASS. The target rows, the history boundary, the preserved-rule list, and the three-file check inventory are fixed in the contracts and in [research.md](./research.md). No design artifact moves a check into a shipped skill or a runtime validator.

## Project Structure

### Documentation (this feature)

```text
specs/114-amend-experience-standard/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── experience-standard-amendment.md
│   └── repository-review-checks.md
├── checklists/requirements.md
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/governance/experience-standard.md
.highway/tools/tests/experience-standard-amendment.test.sh
.highway/tools/tests/feature-092-contract.test.sh
.highway/tools/tests/highway-ux-alignment.test.sh
```

**Structure Decision**: The Experience Standard remains the only shipped source for this amendment. Three existing review tests follow the new contract. Skill files, generated adapters, shared templates, and the development constitution stay untouched. Review tests are not added to skill runtime or to the packaged validator's required inputs.

## Complexity Tracking

No constitution gate is violated. Review-check edits are in this change so verification passes without leaving skill domain workflows in scope.
