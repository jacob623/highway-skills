# Implementation Plan: Conversation Delivery Hardening

**Branch**: `153-conversation-delivery-hardening` | **Date**: 2026-10-09 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/153-conversation-delivery-hardening/spec.md`

## Summary

Nineteen live requirements add or correct text in three places: the Experience Standard
(`.highway/governance/experience-standard.md`), the Profile workflow
(`.highway/skills/highway-profile/SKILL.md`), and the agent grounding source
(`.highway/instructions/highway-agent-context.md`). A twentieth, FR-005, is withdrawn: the setup
workflow's heading level is not changed, so `highway-setup` is untouched. Every requirement is a
property of delivered text. No requirement is evidence that an agent behaves differently at
runtime; FR-018 through FR-020 make that limit explicit, and the evaluation round is a separate
feature.

The technical approach is constrained before it begins by two facts measured during clarification.
First, `highway-profile` carries **zero** MUST-level keywords by design (Feature 150's contract,
restated here as FR-015), so every obligation this feature places on that skill must be delivered
as emitted literal text, procedure prose, or a Verification entry — never as a rule in the skill.
Second, because the word-limit check `P7.5` only inspects sections containing MUST-level keywords,
it does not decide `highway-profile` at all; its `### Acquisition` section already measures far
above the limit with nothing objecting. This feature adds to that same section, so FR-017 requires
measurement and recording rather than reliance on a check that will not fire.

## Technical Context

**Language/Version**: Bash 3.2.57 (tests and generators); Markdown with YAML frontmatter (all
shipped artifacts)

**Primary Dependencies**: `.highway/tools/tests/run-all.sh`; `generate-agent-adapters.sh`;
`generate-catalog.sh`; `generate-library-catalog.sh`; `generate-instructions.sh`

**Storage**: Files only. No database, no runtime state.

**Testing**: `.highway/tools/tests/run-all.sh`. Every new assertion in this feature is instrument
class `static-document-contract` over artifact class `source-document`.

**Target Platform**: macOS (BSD utilities) and Linux (GNU coreutils), per `D2.3`

**Project Type**: Governance and skill content repository with a shell toolchain

**Performance Goals**: The suite's added runtime is measured and recorded (SC-009). No target is
set, because no NFR in this repository bounds suite duration.

**Constraints**:

- `highway-profile` must end with zero MUST-level keywords (FR-015)
- No requirement owned by the Experience Standard may be restated in a skill (FR-014, `P7.3`)
- No shipped artifact may reference `specs/` or `.specify/` (`D1.1`)
- Every added Standard rule must satisfy `P1.1` (one keyword), `P1.3` (25 words or fewer), and
  carry an Observable

**Scale/Scope**: Four shipped source documents changed, four generated agent trees regenerated.
Five user stories, twenty functional requirements, ten success criteria.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-checked after Phase 1 design.*

### Process gates (Highway Skills Development Constitution v2.2.0)

| Gate | Trigger | Verdict |
|---|---|---|
| **Packaging Gate** | TRUE — the change touches `.highway/governance/` and `.highway/skills/` | PASS, conditional |
| **Toolchain Gate** | FALSE — no file under `.highway/tools/` other than tests | N/A |
| **Generator Gate** | FALSE — no `generate-*.sh` script is modified | N/A |
| **Correspondence Gate** | TRUE — `.highway/skills/` content changes, which is a declared generator input | PASS, conditional |
| **Validation Gate** | TRUE — new assertions are added to the test suite | PASS, conditional |
| **Skill Content Gate** | TRUE — files under `.highway/skills/` are modified | Delegated below per `D1.5` |

| Rule | Verdict | Basis |
|---|---|---|
| D1.1 | PASS, conditional | No added text may name `specs/` or `.specify/`. The FR-011 exemplars are drawn from observed conversations but must be written as domain content, never cited to a development path |
| D1.2 | PASS | No change makes the packaged tree depend on a development artifact |
| D1.3 | PASS | This plan cites rule IDs; it copies no Highway Skills Constitution rule sentence |
| D1.4 | PASS | Same |
| D1.5 | PASS | The Skill Content Gate verdict below names P-rule IDs |
| D1.6 | PASS | The distributed path set is untouched |
| D3.1 | PENDING | The suite must be observed exiting 0 before the first edit |
| D3.2 | PENDING | The suite must be observed exiting 0 after the final edit |
| D3.3 | PASS | Every requirement except FR-016 through FR-020 is a document property with a new or amended assertion |
| D3.4 | PASS, conditional | Each new assertion must be evaluated against the existing tree before being wired in, because several existing tests already assert over the same sections |
| D3.5 | **AT RISK** | Research item R6: the Feature 152 test asserts the validation question appears exactly once per domain. FR-002 and FR-011 both add text near that assertion. If an assertion must be loosened, `D3.5` requires a recorded reason naming the superseded behavior, and it is `[human-review]` |
| D3.6 | PASS, conditional | Each added assertion must be observed failing before the text satisfying it is written |
| D3.7 | PASS, conditional | Any check registered `[auto]` must declare artifact classes and prove a seeded failure |
| D3.8 | PASS | Every assertion here is a static document contract, and FR-018 states that no requirement in this feature is evidence of runtime behavior. This is the rule the spec's evidence rework was written to satisfy |
| D4.4 | N/A | No generator changes |
| D4.5 / D4.6 / D4.7 | PASS, conditional | Adapters and catalogs must be regenerated after the skill edits (FR-016); `adapter-coverage.test.sh` decides this |
| D6.1 | PASS, conditional | No live document currently describes the changed behavior; if one is found during implementation it is edited in the same change |
| D6.2 | PASS | No new cross-reference outside the shipped tree is introduced |
| D8.1 | PASS, conditional | The Experience Standard is cited by every skill. Adding rules to it obliges re-validation of each citing skill against the changed document. Scope is bounded in Phase 1 |

### Skill content gate (Highway Skills Constitution, P namespace)

| Rule | Verdict | Basis |
|---|---|---|
| P1.1 | PASS, conditional | Each added Standard rule carries exactly one keyword |
| P1.2 | **AT RISK** | The contribution rule as drafted in the assessment joins a condition and two permitted forms. Research item R3 must split or restructure it, because `P1.2` admits one obligation per rule |
| P1.3 | **AT RISK** | The drafted contribution rule exceeds 25 words. It must be reduced or split |
| P1.4 | PASS, conditional | "Useful", "materially", and "reachable" are vagueness candidates. FR-010's exclusion list supplies the countable condition and must appear in the Observable |
| P5.6 | PASS | No skill's trigger set changes |
| P7.3 | PASS, conditional | FR-014 is this rule. Profile delivers by literal, procedure, and Verification entry; it names the Standard rather than restating it |
| P7.4 | PASS | `highway-profile` holds zero MUST-level rules before and after (FR-015), so the twelve-rule ceiling is not approached |
| P7.5 | **DOES NOT DECIDE** | Measured: the check reads only sections containing MUST-level keywords, and `highway-profile` has none. Its largest section is already far above 400 words. FR-017 requires measurement and recording. Repairing the check was declined in clarification and is deferred |
| P7.7 | PASS, conditional | Both `highway-profile` and the Experience Standard are at `11.0.0`; each increment must match its change classification |
| P8.3 / P8.4 | PASS, conditional | New Verification entries must name checkable outcomes |
| P8.7 | PASS | No relative Markdown link is added to a skill body |
| P9.1 | PASS | No shared output template structure is repeated |
| P10.1 | PASS, conditional | Changed skills must comply with the amended Standard and must not restate its generic rules |
| P10.2 | N/A | No skill declares an exception to an X rule in this feature |

**Three findings are carried into Phase 0 rather than asserted PASS**: `P1.2` and `P1.3` against
the drafted contribution rule, and `D3.5` against the existing Feature 152 assertion. No gate is
recorded FAIL, so the plan proceeds; each is a named research item.

### Post-design re-check (after Phase 1)

| Rule | Before | After | Basis |
|---|---|---|---|
| P1.2 | AT RISK | **PASS** | The bound is split into its own rule (X2.69), so X2.68 states one obligation. Research R3 |
| P1.3 | AT RISK | **PASS** | Drafted word counts are 18, 13, 14, 15 and 15 against a limit of 25. Contract C1 |
| D3.5 | AT RISK | **PASS** | No assertion is weakened. The Feature 152 count-of-one assertion becomes a guard on FR-011 rather than an obstacle. Research R6 |
| P7.5 | DOES NOT DECIDE | **unchanged** | Still inert for this skill, now with the baseline measured at 1303 words in one `## Readiness` roll-up. FR-017 records the post-change figure |
| D1.1 | conditional | **PASS, conditional** | Unchanged obligation: the exemplars must carry domain content with no development path cited |
| D8.1 | conditional | **PASS, conditional** | Bounded in Quickstart Step 2: every skill citing the Experience Standard is evaluated against the five new rules before they are enabled |

**Two items were held for sign-off before implementation; both were decided on 2026-10-09:**

1. The reaction literal's wording (contract C2) — **accepted as drafted**:
   `**Here's a direction worth considering — what's missing from it?**`.
2. The heading level in `highway-setup` (research R5) — **no change**. The heading level is not
   the cause of the observed confusion at the Profile → Objectives seam. FR-005 is withdrawn,
   `highway-setup` is not touched, and no assertion is written for it.

No gate is recorded FAIL. The design proceeds to tasks.

## Project Structure

### Documentation (this feature)

```text
specs/153-conversation-delivery-hardening/
├── spec.md
├── plan.md                        # This file
├── research.md                    # Phase 0 output
├── data-model.md                  # Phase 1 output
├── quickstart.md                  # Phase 1 output
├── contracts/
│   └── delivery-sites.md          # Phase 1 output
├── checklists/
│   └── requirements.md            # Existing; re-validated during clarification
└── tasks.md                       # Phase 2 output, NOT created by /speckit-plan
```

### Source Code (repository root)

```text
.highway/
├── governance/
│   └── experience-standard.md     # New X2 rules; amended provenance; version bump
├── skills/
│   └── highway-profile/SKILL.md   # Candidate-before-retention, continuity, exemplars,
│                                  #   narration coverage, domain-boundary cue, reassurance
├── instructions/
│   └── highway-agent-context.md   # Source for the four grounding files
└── tools/tests/
    └── feature-153-delivery-sites.test.sh   # New assertions

.github/skills/   .claude/skills/   .cursor/skills/   .agents/skills/   # Regenerated adapters
.github/copilot-instructions.md   .claude/CLAUDE.md   AGENTS.md
.cursor/rules/highway-agent-context.mdc
.highway/catalog/                 # Regenerated catalogs
```

**Structure Decision**: No new directory is created. The feature edits four shipped source
documents and adds one test file, then regenerates the four declared agent trees and the catalogs.
The grounding files are generated from `.highway/instructions/highway-agent-context.md`, so FR-008
is satisfied by editing that source and regenerating — editing the four outputs directly would
violate `D4.1`.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|---|---|---|
| A section already far above the `P7.5` word limit grows further | FR-011's exemplars only work at the point of use; the assessment's conclusion is that the rule creates the obligation and the exemplar creates the behavior | Moving exemplars to the `## Example` section keeps the measured size down but separates them from the moment they apply, which is the property the evidence says matters. Research item R1 weighs this |
| Two documents change version in one feature | The Standard owns the obligation and the skill owns the delivery; FR-014 forbids collapsing them | Putting the obligation in the skill would violate `P7.3` and FR-015 |
