# Implementation Plan: Profile and Setup Contract Hardening

**Branch**: `092-profile-setup-contract-hardening` | **Date**: 2026-09-25 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/092-profile-setup-contract-hardening/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Harden the Experience Standard, Profile, and Setup contracts so user-visible workflows omit
unrequested mechanics, Profile owns readiness and declared Repository Context consumption, Setup
orchestrates only through validated owner contracts, and the retained Markdown Profile remains
deterministic and self-contained. The implementation updates the governing documents and affected
skills, renames the shared output template to `profile-record.md`, removes obsolete `profile.md` and
`profile.yaml` output-template artifacts, updates validators and fixtures, and regenerates only the
corresponding derived artifacts identified by repository generation and correspondence mechanisms.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown contracts and POSIX-style shell; Bash 3.2.57 compatibility for scripts

**Primary Dependencies**: Existing Highway governance documents, shell utilities in the declared
toolchain, and existing catalog/adapter generators; no new runtime dependency

**Storage**: User-owned Markdown file `.highway/library/knowledge/profile.md`; no new persistence technology

**Testing**: `.highway/tools/tests/run-all.sh`, focused shell contract tests, `validate-profile.sh`,
`validate-skill.sh`, correspondence checks, and deterministic disposable fixtures

**Target Platform**: macOS and packaged Highway distributions; scripts must run with default Bash 3.2

**Project Type**: Documentation-led skill distribution with shell validators and generated adapters/catalogs

**Performance Goals**: Deterministic local contract validation; no service latency or throughput target

**Constraints**: Preserve owner boundaries; no runtime development-history dependencies; no new external
service or package; maintain Bash 3.2 and declared-toolchain compatibility; do not hand-edit generated
artifacts; retain accepted Profile bytes on failed or declined mutations

**Scale/Scope**: Four foundational Setup owners, five Profile domains, the repository's discovered
Interactive Workflows, and generated/distributed dependents of changed sources

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The plan changes shipped skills, library templates, governance documents, validators, fixtures, and
generator inputs. The following gates therefore apply:

| Gate | Verdict | Evidence / plan obligation |
|---|---|---|
| Packaging Gate | PASS | Shipped references and distribution classification are updated; packaged validation runs with `.specify/` and `specs/` absent. |
| Toolchain Gate | PASS | Any shell changes use Bash 3.2 syntax and only the declared utilities. |
| Generator Gate | N/A | No generator script is changed; changed generator inputs trigger Correspondence Gate. |
| Correspondence Gate | PASS | Catalogs, adapters, manifests, and distribution entries are inventoried and regenerated only when their declared sources changed. |
| Validation Gate | PASS | New or amended checks retain seeded probes and are evaluated against existing fixtures before enablement. |
| Skill Content Gate | PASS | Profile, Setup, template, and affected skill changes are checked against the Highway Skills Constitution by rule ID. |

Applicable development rules include D1.1-D1.6, D2.1-D2.4, D3.1-D3.8, D4.1-D4.7, D5.3,
D6.1-D6.2, D7.3, and D8.1. Skill-content review must cover the applicable Highway Skills
Constitution rules, especially P11/P12 context participation, P14 deterministic output, P16
completion claims, and the Experience Standard X2 rules named by the feature specification.

## Project Structure

### Documentation (this feature)

```text
specs/092-profile-setup-contract-hardening/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
.highway/
├── governance/
│   ├── constitution.md
│   └── experience-standard.md
├── skills/
│   ├── highway-profile/SKILL.md
│   ├── highway-setup/SKILL.md
│   ├── highway-objectives/SKILL.md
│   ├── highway-controls/SKILL.md
│   └── highway-nfrs/SKILL.md
├── library/
│   ├── knowledge/
│   │   ├── highway-identity.md
│   │   └── profile.md
│   └── templates/output/
│       └── profile-record.md
└── tools/
  ├── validate-profile.sh
  ├── validate-skill.sh
  ├── generate-*.sh
  └── tests/

.github/skills/, .claude/skills/, .cursor/rules/
└── Generated agent adapters derived from source skills
```

**Structure Decision**: Preserve the repository's documentation-led `.highway/` distribution.
Source governance, skills, templates, and validators remain authoritative; generated catalogs,
adapters, manifests, and distribution entries are derived outputs. Feature design artifacts remain
under `specs/092-profile-setup-contract-hardening/` and are excluded from shipped runtime behavior.

## Post-Design Constitution Check

| Rule area | Verdict | Design evidence |
|---|---|---|
| Layer separation and shippability | PASS | Runtime contracts cite shipped paths and durable governance only; Feature 092 artifacts remain under `specs/`. |
| Environment and dependency discipline | PASS | No new interpreter, package, service, or persistence technology; shell changes remain Bash 3.2-compatible. |
| Verification before and after | PASS | Focused fixtures cover static and executed behavior, preserve seeded probes, and run before final suite validation. |
| Generated artifact integrity | PASS | Changed sources are inventoried, identified dependents are regenerated, and correspondence checks verify outputs. |
| Documentation currency | PASS | Governance, skills, templates, validators, tests, and affected live documentation are included in scope. |
| Shared library dependency review | PASS | Profile and Setup are revalidated against the renamed shared template and generated/distributed dependents. |
| Highway Skills Constitution skill-content gate | PASS | Profile, Setup, template, and participating workflow changes are reviewed against applicable P-rules and X2 rules. |

No constitution violation requires complexity justification. The Technical Context and Phase 0
research decisions contain no unresolved technical unknowns.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | The feature fits the existing single distribution tree and does not add a project or persistence layer. | No additional application structure is required. |
