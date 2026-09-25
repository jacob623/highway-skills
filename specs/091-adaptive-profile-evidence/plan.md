# Implementation Plan: Adaptive Organizational Profile Evidence
**Branch**: `091-adaptive-profile-evidence` | **Date**: 2026-09-24 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/091-adaptive-profile-evidence/spec.md`
## Summary
Replace the fixed YAML and technical questionnaire owned by `highway-profile` with adaptive,
five-domain organizational evidence collection. Persist accepted evidence as deterministic,
human-readable Markdown at `.highway/library/knowledge/profile.md`, expose readiness through the
owner contract, route Setup through that contract, and amend the constitutional Repository Context
model. The implementation is documentation-led and validated by shell-based deterministic fixtures.
**Language/Version**: Markdown instruction contracts; POSIX-compatible shell with macOS Bash 3.2 constraints
**Primary Dependencies**: Existing Highway Skills Constitution, Experience Standard, shell helpers, and test harness
**Storage**: Repository files; authoritative Profile at `.highway/library/knowledge/profile.md`
**Testing**: `.highway/tools/tests/run-all.sh` plus focused Profile, Setup, readiness, template, and governance tests
**Target Platform**: Distributed Highway Skills repositories on macOS and POSIX-like shells
**Project Type**: Instruction-skill and governance artifact distribution
**Performance Goals**: Deterministic local validation with no network or service dependency
**Constraints**: Preserve user-owned bytes on declined or failed operations; no legacy YAML fallback; no duplicated complete template; no inferred organizational facts; remain within constitutional MUST-level and shell portability rules
**Scale/Scope**: Two primary skills, one shared Profile template and artifact path, governance/identity documents, deterministic fixtures, and repository compliance tests
## Constitution Check
*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*
The plan passes the pre-design gate. The change is documentation-led, keeps generated artifacts
under their existing ownership boundaries, uses the declared shell toolchain, and adds no runtime
dependency or external service. Profile remains user-owned context; Setup remains orchestration-only.
The implementation must preserve D1 layer separation, D2 dependency discipline, D3 verification,
D4 generated-artifact integrity, D6 documentation currency, and the repository's constitutional
amendment/compliance requirements. No violation requires a Complexity Tracking entry.
**Structure Decision**: Keep behavior in the owning skill documents, reusable structure in the
shared output template, retained context in the knowledge library, constitutional ownership in
governance documents, and deterministic evidence in `.highway/tools/tests`. Do not introduce a
new application source tree or a second Profile store.
| None | N/A | The feature fits the existing skill, library, governance, and shell-test boundaries. |

## Project Structure

### Documentation (this feature)

```text
specs/091-adaptive-profile-evidence/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

### Source and validation artifacts

```text
.highway/
├── governance/constitution.md
├── library/knowledge/highway-identity.md
├── library/knowledge/profile.md
├── library/templates/output/profile.md
├── skills/highway-profile/SKILL.md
├── skills/highway-setup/SKILL.md
└── tools/{lib,tests}/
```

**Structure Decision**: Keep behavior in the owning skill documents, reusable structure in the
shared output template, retained context in the knowledge library, constitutional ownership in
governance documents, and deterministic evidence in `.highway/tools/tests`. Do not introduce a
new application source tree or a second Profile store.

## Phase 0 Research Summary

- Existing Profile behavior is YAML-based and readiness depends on `organization.name`; the rewrite must remove both dependencies.
- Setup already consumes owner readiness in a fixed order; Feature 091 changes only the Profile owner contract and preserves orchestration ownership.
- The repository uses shell-based static and executable contract tests, including disposable fixtures and byte-stability assertions.
- Constitutional and identity changes are normative/descriptive respectively and must be applied in the ordered sequence stated by the specification.

## Phase 1 Design Summary

The data model defines proposal versus accepted evidence, five closed domain outcomes, deterministic
Markdown rendering, readiness, and mutation transitions. Contracts document the Profile owner
command/readiness output and Setup routing boundary. Quickstart scenarios invoke focused tests and
the full suite without requiring a service or network.

## Post-Design Constitution Check

PASS. The design preserves layer separation, uses no new dependency, centralizes the complete
structural template, keeps generated artifacts synchronized through existing checks, and makes
validation executable. Constitutional amendment work is explicitly ordered and its semantic version
is determined from the actual amendment rather than preselected here.
