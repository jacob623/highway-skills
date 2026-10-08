# Implementation Plan: Profile Conversation Conformance

**Branch**: `152-profile-conversation-conformance` | **Date**: 2026-10-08 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/152-profile-conversation-conformance/spec.md`

## Summary

Thirteen conversational behaviors are specified, six of which have governing rules today that did
not hold in practice. Planning surfaced one organizing constraint that shapes everything else: the
runtime constitution forbids a skill from restating a requirement owned elsewhere, and the Profile
skill contains zero MUST statements today. So "point-of-use text" cannot mean copying rules into
skills. It means the skill carries the **literals it emits** and the **local procedure it owns**,
while the obligation itself stays in the Experience Standard.

That distinction is not a workaround. It is the actual explanation for the evidence: the one Feature
150 change that held was a literal the skill emits, and the three that failed were obligations the
skill never had to write down.

## Technical Context

**Language/Version**: Bash 3.2.57 for tools and tests; Markdown for governance documents and skills

**Primary Dependencies**: None beyond the Declared Toolchain in the development constitution. No
package manager, interpreter, or binary is added.

**Storage**: Files. `.highway/governance/experience-standard.md`,
`.highway/skills/highway-profile/SKILL.md`, and four generated adapter trees.

**Testing**: `.highway/tools/tests/run-all.sh`. New assertions use the existing helpers in
`test-helpers.sh` — `require_text`, `require_absent`, `require_flowed`, `require_flowed_absent`.

**Target Platform**: macOS and Linux, both supported by every utility flag used.

**Project Type**: Governance and skill authoring repository with shell validators. No application
source tree.

**Performance Goals**: The suite stays within the 250 s budget amended into Feature 151's SC-001.
This feature adds one test file and edits roughly a dozen existing ones; no measurable impact.

**Constraints**: Bash 3.2.57 — no associative arrays, `mapfile`, `readarray`, `${var^^}`, or `&>>`.
No utility outside the Declared Toolchain. Every flag must work on both GNU and BSD variants.

**Scale/Scope**: One governance document, one skill, four adapter trees, about twelve test files
touched, one new test file.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Recorded per D1.5, which requires a plan modifying a skill to check against the Highway Skills
Constitution.

### Runtime constitution (P namespace) — governs the skills and the standard

| Rule | Bearing on this feature | Verdict |
|---|---|---|
| P7.3 | A skill must not restate a requirement owned outside it. This binds the entire delivery pattern. | **PASS by design** — point-of-use text is emitted literals and skill-owned procedure, never a restated obligation. See Research D1. |
| P7.4 | At most 12 MUST-level rules per skill. Profile currently has zero. | PASS — no MUST statement is added to any skill. |
| P7.5 | At most 400 words per normative section. Several Profile sections grow. | **AT RISK** — the four domain subsections and `## Readiness` all gain text. Measured per section before and after. See Research D2. |
| P1.1 | Exactly one keyword per normative rule. | Constrains drafting: FR-008 and FR-019 each carry two obligations and split into two rules apiece. |
| P1.3 | At most 25 words per rule. | Constrains drafting. The normalized-identity test does not fit in a rule and belongs in the Observable. |
| P1.5 | A skill must name every tool, file, and prior step it depends on. | Supports FR-024 directly; naming the artifact Readiness reads is required regardless. |
| P5.7, P5.12, P5.13 | Obtain missing input; never report a failed mutation as success; stop with actionable context. | Supports FR-017 and FR-023. No conflict. |
| P7.2 | Semantic version on every skill. | `highway-profile` takes a MAJOR bump; rules are redefined. |

### Development constitution (D namespace) — governs this change

| Rule | Bearing | Verdict |
|---|---|---|
| D1.4 | No document here may restate constitution rule text. | PASS — spec, plan, and contracts cite IDs. Contracts quote only the new rows this feature authors. |
| D3.1, D3.2 | Suite passes before the first edit and after the last. | Scheduled as the first and last tasks. |
| D3.3 | A behavioral change adds or amends a test. | PASS — one new test file plus amendments. |
| D3.6 | A test must be observed failing before the behavior is marked complete. | Each new assertion is written and observed red first. |
| D3.7 | A registered `[auto]` check must fail for every declared artifact class. | The new test declares `source-document` and `generated-artifact` and implements `--probe` / `--neutralise`. |
| D3.8 | A static document-contract test must not be recorded as evidence for a behavioral requirement. | **PASS by scope** — clarification removed the behavioral claim. The spec's Evidence boundary states this. |
| D4.4, D4.7 | Regenerate every artifact after changing a generator's input. | A SKILL.md change is a generator input; all five generators re-run and must leave no diff. |
| D6.1, D6.2 | Live documentation updated in the same change; cross-references resolve. | `.highway/tools/README.md` and the catalog are checked. |
| D8.1 | A change to a shared library artifact requires re-validating every citing skill. | Not triggered — FR-031 freezes the output template and schema. |

### Gate result

**PASS with one tracked risk.** P7.5 is the only rule this design can plausibly breach, and it is
measurable rather than a matter of judgment. Research D2 records the mitigation.

No violation requires justification, so Complexity Tracking stays empty.

### Post-design re-evaluation

Re-checked after Phase 1. The design changed two verdicts:

| Rule | Change |
|---|---|
| P7.3 | Confirmed PASS. `contracts/profile-wording.md` contains no restated obligation — every entry is an emitted literal or a procedure Profile owns. |
| P1.1, P1.3 | Confirmed PASS. All ten added rows carry one keyword and sit at 7–15 words, verified per row in the contract. |
| P7.5 | Still **AT RISK**, now with a concrete measurement procedure in `quickstart.md`. `#### Domain completeness` absorbs the shared literals and is the section most likely to breach. |
| D4.4, D4.7 | Scope confirmed narrow — `highway-profile` is the only skill modified, so four adapter files regenerate. Task T068 asserts that boundary mechanically. |

No new violation appeared. Complexity Tracking remains empty.

### Post-implementation re-evaluation

Re-checked after Phase 9 against the implemented documents.

| Rule | Final verdict |
|---|---|
| P7.5 | **PASS** — risk closed by measurement. Every touched section is under the 400-word cap: `#### Domain completeness` 216, Identity 58, Vision 123, Competitive Path 120, Guiding Principles 103, `## Readiness` 162, `## Operations` 187, `## Verification` 297. The define-once-reference-four strategy from Research D2 held; no section needed splitting. |
| P7.3 | **PASS** — `highway-profile` still contains zero `MUST` occurrences and zero rule IDs, confirmed by grep. Point-of-use text stayed within emitted literals and skill-owned procedure. |
| P7.2 | **PASS** — `highway-profile` carries `version: 11.0.0`, the MAJOR bump the superseded validation questions require. |
| D4.4, D4.7 | **PASS** — `git diff --name-only -- .highway/skills/` names only `highway-profile/SKILL.md`; all four adapter trees regenerate byte-identical. |
| D3.2 | **PASS** — full suite 76 passed, 0 failed, above the 75-test baseline. |

Complexity Tracking remains empty. No rule moved to a failing verdict.

## Project Structure

### Documentation (this feature)

```text
specs/152-profile-conversation-conformance/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/
│   ├── rule-inventory.md     # Exact X-rule rows added and amended
│   └── profile-wording.md    # Exact point-of-use literals, per site
├── checklists/
│   └── requirements.md
└── tasks.md             # Phase 2 output (/speckit-tasks — NOT created here)
```

### Source Code (repository root)

```text
.highway/
├── governance/
│   └── experience-standard.md        # rules and observables; 10.0.0 → 11.0.0
├── skills/
│   └── highway-profile/SKILL.md      # the only skill modified; 10.0.0 → 11.0.0
└── tools/
    ├── generate-agent-adapters.sh    # regenerates the four adapter trees
    └── tests/
        ├── feature-152-profile-conversation-conformance.test.sh   # new
        ├── experience-standard-amendment.test.sh        # version + rule count
        ├── experience-standard-convergence.test.sh      # rule count
        ├── feature-141-experience-standard-refactor.test.sh
        ├── feature-150-collaborative-convergence.test.sh
        ├── highway-ux-alignment.test.sh
        └── (eight tests carrying a profile version string)

.github/skills/  .claude/skills/  .cursor/skills/  .agents/skills/   # generated adapters
```

**Structure Decision**: No application structure applies. The change set is one governance document,
one skill document, its generated adapters across four trees, and the test suite. Adapters are never
edited directly; they are produced by `generate-agent-adapters.sh` and verified byte-identical to
source.

## Complexity Tracking

> No Constitution Check violation requires justification. This section is intentionally empty.
