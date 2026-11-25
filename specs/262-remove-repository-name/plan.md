# Implementation Plan: Remove Repository Name

**Branch**: `262-remove-repository-name` | **Date**: 2026-11-25 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/262-remove-repository-name/spec.md`

## Summary

Remove Repository Name from Profile acquisition and from the Profile record. Make the
organization-name question the first guided question. Route offer and later domains from that
accepted Organization Name. Replace every skill fallback that used Repository Name with
Organization Name only. No migration path for older Profiles. Instructions only. Follow the plugin
finish order because `skills/` changes.

## Technical Context

**Language/Version**: Markdown skill content; Bash 3.2.57 suite tests.

**Primary Dependencies**: `skills/highway-profile/`, `skills/highway-profile/assets/profile-record.md`,
`skills/highway-onboarding/references/proposal.md`, `skills/highway-objectives/`,
`skills/highway-controls/`, `skills/highway-nfrs/`, catalog/adapter/plugin generators.

**Storage**: Existing Profile record under `library/knowledge/profile.md`. Context keeps Organization
Name, Organization URL, and Organizational Context. Repository Name is omitted.

**Testing**: New or updated static instruction check for the first-question and naming rules. Update
`tests/output-template.test.sh` Context headings. Update
`tests/harness-failure-resolutions.test.sh` and `tests/org-offering-boundary.test.sh` for the new
order. Finish order for plugin generation.

**Target Platform**: Coding agents loading the Highway skills.

**Project Type**: Skill instruction update.

**Performance Goals**: N/A.

**Constraints**: Instructions only. No Repository Name. No backward-compatible migration. Decline and
unknown on the first question re-ask. Bash 3.2.57. Plugin finish order after `skills/` changes.

**Scale/Scope**: Profile skill and record, four naming fallbacks (onboarding proposal, objectives,
controls, NFRs), tests, version bumps, regenerate.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates

| Gate | Trigger | Verdict |
| --- | --- | --- |
| Packaging Gate | Shipped skill text | PASS: D1.1, D1.2, D6.2. No `.specify/` or `specs/` tokens in skill text. |
| Toolchain Gate | Bash test edits | PASS: D2.1–D2.5. Existing `tests/` helpers only. |
| Generator Gate | No generator edit | N/A |
| Correspondence Gate | `skills/` change | PASS: D4.5–D4.8 via catalog, adapters, plugin bump, and regenerate. |
| Validation Gate | Instruction checks | PASS: D3.4, D3.5. Assertions tighten to Organization Name only. |
| Skill Content Gate | Skill edits | See below. |

### Skill content gates

| Rule | Verdict |
| --- | --- |
| P1.1–P1.3 | PASS: No new Experience Standard MUST. Skill additions are procedure lines. |
| P6.1–P6.6 | PASS: First-question decline/unknown stays with an otherwise advance after a name. |
| P7.2, P7.7 | PASS: MINOR skill bumps. Record domain sections, `Finished`, and direct-invoke stay. Template drops an optional Context child. |
| P7.3, P10.1 | PASS: Naming stays Organization Name. No new Experience Standard copy. |
| P8.3, P8.4 | PASS: Verification lines updated for the first question and write. |
| P10.2 | N/A |
| D5.3 | N/A: Experience Standard unchanged. |
| D3.3, D3.8 | PASS: Static-document instruction checks only. |
| D8.1 | PASS: No Experience Standard edit. |

### Post-design re-check

Gates hold. Research resolves first-question placement, decline/unknown, review behavior, and
version bumps. No gate moves to fail.

## Project Structure

### Documentation (this feature)

```text
specs/262-remove-repository-name/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/remove-repository-name-instructions.md
├── checklists/requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
skills/highway-profile/SKILL.md                    # first question; drop Repository Name; 14.7.0
skills/highway-profile/assets/profile-record.md    # omit Repository Name; 3.2.0
skills/highway-onboarding/SKILL.md                 # version bump if proposal ships with skill; 10.15.0
skills/highway-onboarding/references/proposal.md   # Organization Name only
skills/highway-objectives/SKILL.md                 # Organization Name only; 8.10.0
skills/highway-controls/SKILL.md                   # Organization Name only; 8.9.0
skills/highway-nfrs/SKILL.md                       # Organization Name only; 9.10.0
tests/remove-repository-name.test.sh               # instruction presence
tests/org-offering-boundary.test.sh                # drop Repository Name sentences; profile 14.7.0
tests/harness-failure-resolutions.test.sh          # offer routes without organization-name step
tests/output-template.test.sh                      # Context headings without Repository Name
framework/plugin/plugin.json                       # 0.1.3 → 0.1.4
```

**Structure Decision**: Edit owning skills and the Profile record in place. No new skill.

## Complexity Tracking

> None
