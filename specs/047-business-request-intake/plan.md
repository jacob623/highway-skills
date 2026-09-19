# Implementation Plan: Business Request Intake

**Branch**: `047-business-request-intake` | **Date**: 2026-09-19 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/047-business-request-intake/spec.md`

## Summary

Add the `highway-new` natural-language skill as the repository's business-request intake boundary. The skill will collect six deterministic evidence domains conversationally, generate a deterministic request title, bootstrap and transactionally update the user-owned request catalog, and write request records without inferring downstream relationships. The source skill will be validated, cataloged, and regenerated into the three supported agent adapters.

## Technical Context

**Language/Version**: Markdown skill instructions governed by the Highway Skills Constitution; repository validation and generation scripts must run under Bash 3.2.57.

**Primary Dependencies**: Existing `.highway/tools/validate-skill.sh`, `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-agent-adapters.sh`, and the shared output-template validator. No new runtime dependency.

**Storage**: Plain Markdown files: `.highway/skills/highway-new/SKILL.md`, shared templates under `.highway/library/templates/output/`, generated catalog/adapters, and user-owned `requests/` artifacts.

**Testing**: New focused `.highway/tools/tests/highway-new.test.sh`, existing skill/library validators, catalog generation, adapter correspondence checks, and `.highway/tools/tests/run-all.sh`.

**Target Platform**: macOS and Linux repository environments using the declared shell/toolchain; generated adapters target GitHub Copilot, Claude Code, and Cursor.

**Project Type**: Internal agent skill and repository governance tooling; no network service or application runtime.

**Performance Goals**: Each intake response produces one question and one to three examples; no independent service latency or throughput target is required for Version 1.

**Constraints**: The source skill must satisfy P1-P9 authoring rules, cite approved authority sources, remain deterministic, avoid relationship discovery, exclude secrets and regulated personal data from output, and keep request/catalog writes transactional. Generated artifacts must be regenerated rather than hand-edited.

**Scale/Scope**: One request conversation at a time against one repository catalog; six evidence domains; four allowed request statuses; three generated agent adapter targets; no external service scale requirement.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design below.*

| Rule | Requirement | How this feature satisfies it |
|---|---|---|
| P1.1-P1.5 | Normative skill rules are atomic, bounded, dependency-declared, and non-vague | `highway-new/SKILL.md` will use one obligation per rule, explicit counts/order, named Inputs, and no unbounded qualifiers; validator output is reviewed. |
| P2.1-P2.5 | Skill remains technology-agnostic and labels technical examples | The skill names no implementation technology in normative behavior; any command/file examples are explicitly operational inputs or outputs. |
| P3.1-P3.5 | MUST rules cite approved authority sources | Rules cite the relevant repository policy/template paths with `[AS-6: ...]`; validator checks citation syntax. |
| P4.1-P4.6 | Quality and privacy claims have checks; no verification bypass | Verification names validators, focused tests, catalog/adapters, transaction byte checks, and privacy assertions. |
| P5.1-P5.6 | Every workflow step has one failure action and retry bounds | Numbered intake and creation steps map failures to abort/retry/escalate/fall back, with bounded catalog-conflict retries. |
| P6.1-P6.5 | Decisions are ordered, exhaustive, and deterministic | Six-domain order, title precedence, example precedence, completeness rules, ID format, and explicit default/error branches are included. |
| P7.1-P7.6 | Required sections, rule/word limits, and skill versioning | The source follows the authoring standard's eight sections, keeps normative sections within limits, and uses semantic version metadata. |
| P8.1-P8.7 | Ordered workflow, verification, configuration, and link rules | Steps are numbered and ordered; Inputs name repository paths; Verification names commands and file states; no relative Markdown links are used in the shipped skill. |
| P9.1 | File-emitting skill cites complete shared templates | Outputs will cite `.highway/library/templates/output/request-record.md` and `.highway/library/templates/output/request-catalog.md`; the skill will not duplicate their complete structure as a second contract. |
| D1.1-D1.2 | Shipped artifacts remain independent of development artifacts | The skill and shared templates will not reference `.specify/` or `specs/`; packaged-tree validation will be run. |
| D1.5 | Skill/library changes require a development Constitution Check | This plan records the check and names the relevant shipped and development rules. |
| D2.1-D2.4 | Existing toolchain and platform discipline | Tests and scripts use existing Bash 3.2-compatible tools; no package or runtime is added. |
| D3.1-D3.3 | Baseline, final suite, and behavioral tests | Baseline was captured before implementation with the two unrelated failures recorded below; add focused behavior tests; rerun the full suite after implementation and report unchanged versus feature-introduced failures. |
| D4.4-D4.7 | Regenerate and verify generated artifacts | Run catalog and adapter generators after source/template changes; adapter and catalog correspondence tests must pass. |
| D6.1-D6.2 | Keep live documentation and references current | Update relevant tooling/authoring documentation in the implementation change; validate all shipped references. |
| D7.3 | Separate requirement coverage from check results | The completion report will list FR coverage separately from validator/test outcomes. |

**Result**: PASS. No unjustified violations. Complexity Tracking is empty.

**Baseline note**: Before Feature 047 implementation, `.highway/tools/tests/run-all.sh` completed with 36 passes and 2 unrelated failures. `constitution-inventory.test.sh` reported that its D1.2 seeded-defect probes did not fail; `distribution-packaging.test.sh` reported an undeclared `.DS_Store` and additional packaging diagnostics. These failures are recorded as baseline conditions and are not attributed to this feature.

## Phase 0: Research Summary

Research is complete in [research.md](research.md). Decisions resolved:

- Use one source skill plus generated catalog/adapters.
- Express behavior as ordered, deterministic Markdown workflow rules.
- Validate both request artifacts before any write.
- Bootstrap the catalog from a fixed initial state.
- Keep Version 1 free of request-to-artifact relationships.
- Reuse the repository's existing validation, generation, and test toolchain.

## Phase 1: Design Summary

Design artifacts:

- [data-model.md](data-model.md) defines Request Record, Request Catalog, Evidence Domain, Contextual Example, states, and transaction invariants.
- [contracts/intake-conversation-contract.md](contracts/intake-conversation-contract.md) defines the agent-facing conversational protocol.
- [contracts/request-artifact-contract.md](contracts/request-artifact-contract.md) defines request and catalog output shape and transaction behavior.
- [quickstart.md](quickstart.md) defines runnable validation scenarios.

### Project Structure

```text
.highway/
├── library/templates/output/
│   ├── request-record.md                 # NEW shared request-record skeleton
│   └── request-catalog.md                # NEW shared request-catalog skeleton
├── skills/
│   └── highway-new/SKILL.md              # NEW source skill
├── catalog/
│   ├── index.json                        # REGENERATED
│   └── index.md                          # REGENERATED
└── tools/
    └── tests/
        └── highway-new.test.sh           # NEW focused behavior test

.github/skills/highway-new/SKILL.md       # GENERATED
.claude/skills/highway-new/SKILL.md       # GENERATED
.cursor/rules/highway-new.mdc             # GENERATED

requests/                                 # USER-OWNED runtime output, created by skill
├── requests.md
└── REQXXXXXX.md
```

**Structure Decision**: Add one shipped source skill, two shared output templates, and one focused test. Generate all catalog and adapter artifacts through existing generators. Runtime request files remain outside `.highway` and are never committed as framework artifacts by this feature.

### Design Constraints

- `highway-new` must cite both shared output templates in its Outputs section to satisfy P9.1.
- The test must exercise a temporary request workspace and prove bootstrap, valid allocation, invalid ID rejection, transaction no-write behavior, deterministic title/example selection, completeness states, and privacy exclusion.
- The test must not add request fixtures to the shipped tree.
- Generator outputs must be regenerated after the source skill is authored; no generated file is hand-edited.

## Post-Design Constitution Re-check

| Gate | Result | Evidence planned |
|---|---|---|
| P9.1 shared output contract | PASS | Two complete templates are named by the source skill; `validate-library.sh` and `validate-skill.sh` run. |
| P6 deterministic decisions | PASS | Conversation, title, examples, completeness, identifier, and transaction rules are ordered and tested. |
| P5 failure handling | PASS | Catalog conflict has bounded retry; invalid input and validation failure abort without writes. |
| D3 behavioral evidence | PASS | `highway-new.test.sh` executes the focused scenarios before final completion. |
| D4 generated correspondence | PASS | Catalog and adapter generators plus correspondence tests run after source creation. |
| D1 shippability | PASS | Distribution and shipped-tree checks confirm no development-path dependency. |

**Post-design result**: PASS. No new constitution amendment is required.

## Complexity Tracking

No Constitution Check violations require justification. The feature extends existing skill, template, generator, and test patterns without adding a parallel runtime or enforcement mechanism.
