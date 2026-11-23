# Implementation Plan: Organization and Offering Boundary

**Branch**: `261-org-offering-boundary` | **Date**: 2026-11-23 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/261-org-offering-boundary/spec.md`

## Summary

Keep the organization and each generalized offering as separate Identity findings. Name an offering
from the person's words for that kind of thing. Ask once when the subject is mixed or no category
word remains. Accept the split before write. Add one Experience Standard rule for a shared name.
Onboarding, objectives, and assessment stop and start Profile review when the person separates a
fused subject. Onboarding does not promote product behavior into a capability. Added text is
instructions. Follow the plugin finish order because `skills/` changes.

## Technical Context

**Language/Version**: Markdown skill content; Bash 3.2.57 suite tests.

**Primary Dependencies**: `skills/highway-profile/`, `skills/highway-experience/references/experience-standard.md`,
`skills/highway-onboarding/`, `skills/highway-objectives/`, `skills/highway-assessment/`, plugin and adapter generators.

**Storage**: Existing Profile record. No new section. Identity findings stay under `## Who We Are`.

**Testing**: New static instruction check `tests/org-offering-boundary.test.sh`. Update version pins
in `tests/harness-failure-resolutions.test.sh` and `tests/harness-failure-followups.test.sh`.
Finish order for plugin generation.

**Target Platform**: Coding agents loading the Highway skills.

**Project Type**: Skill instruction update.

**Performance Goals**: N/A.

**Constraints**: Instructions only, no explanatory prose. No new Profile section. Do not restate the
shared-name rule outside the Experience Standard and Profile's name-fill step. Do not rewrite an
existing Profile unprompted. Bash 3.2.57. Plugin finish order after `skills/` changes.

**Scale/Scope**: Five skill surfaces, one new X-rule, one test, version bumps, regenerate.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates

| Gate | Trigger | Verdict |
| --- | --- | --- |
| Packaging Gate | Shipped skill text | PASS: D1.1, D1.2, D6.2. No `.specify/` or `specs/` tokens in skill text. |
| Toolchain Gate | New bash test | PASS: D2.1–D2.5. Test uses the existing `tests/` helpers only. |
| Generator Gate | No generator edit | N/A |
| Correspondence Gate | `skills/` change | PASS: D4.5–D4.8 via catalog, adapters, plugin bump, and regenerate. |
| Validation Gate | New instruction check | PASS: D3.4, D3.5. The check asserts new sentences. It does not loosen an existing assertion. |
| Skill Content Gate | Skill edits | See below. |

### Skill content gates

| Rule | Verdict |
| --- | --- |
| P1.1, P1.2, P1.3 | PASS: X2.73 is one MUST, one obligation, 18 words. Skill additions are procedure lines, not extra MUST rows. |
| P6.1–P6.6 | PASS: Offering-name and mixed-subject choices are ordered steps with an otherwise branch. |
| P7.2, P7.7 | PASS: MINOR bumps. Record sections, `Finished`, and direct-invoke stay. |
| P7.3, P10.1 | PASS: The shared-name obligation is X2.73. Profile only chooses which name fills a sentence. Other skills do not copy it. |
| P8.3, P8.4 | PASS: Each edited skill gains one checkable verification line. |
| P10.2 | N/A: no Experience Standard exception. |
| D5.3 | PASS: Experience Standard provenance names X2.73 and retires nothing. |
| D3.3, D3.8 | PASS: New test is a static-document check of instruction presence. It is not recorded as executed agent behavior. |
| D8.1 | PASS: Skills that cite the Experience Standard already activate `highway-experience`. Re-validate by the suite after the standard edit. |

### Post-design re-check

Gates hold. Research resolves organization-name timing and the Profile review handoff. No gate moves to fail.

## Project Structure

### Documentation (this feature)

```text
specs/261-org-offering-boundary/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/org-offering-instructions.md
├── checklists/requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
skills/highway-experience/references/experience-standard.md  # X2.73; version 11.2.0
skills/highway-experience/SKILL.md                            # metadata 1.6.0
skills/highway-profile/SKILL.md                               # identity, vision, split, name; 14.6.0
skills/highway-onboarding/SKILL.md                            # stop and capability rule; 10.14.0
skills/highway-onboarding/references/proposal.md              # capability list rule
skills/highway-objectives/SKILL.md                            # stop; 8.9.0
skills/highway-assessment/SKILL.md                            # stop; 5.6.0
tests/org-offering-boundary.test.sh                           # instruction presence
tests/harness-failure-resolutions.test.sh                     # experience 1.6.0
tests/harness-failure-followups.test.sh                       # objectives 8.9.0
```

**Structure Decision**: Edit the owning skills in place. Do not add a Profile section or a new skill.

## Complexity Tracking

> None
