# Implementation Plan: Highway Experience Standard

**Branch**: `017-experience-standard` | **Date**: 2026-09-08 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/017-experience-standard/spec.md`

## Summary

Author `.highway/governance/experience-standard.md` as Layer 2, holding `X`-namespace rules that
govern what Highway skills emit and how they interact, then have both existing skills cite the
rules they satisfy.

The whole document turns on one boundary settled in Phase 0: **`P` constrains what a `SKILL.md`
declares; `X` constrains the form of what the skill emits.** Without that line the standard would
have restated `P1.7` almost exactly, because "ask rather than guess when the input is ambiguous" is
already a `P` rule. What is admissible is not *that* a skill asks, but what the asking must contain.

No rule is tagged `[auto]` in this phase. Phase 6 builds enforcement; tagging before a check exists
is the defect features 013 and 014 spent two features removing.

## Technical Context

**Language/Version**: Markdown. No code is written in this phase.

**Primary Dependencies**: None. The standard is a document.

**Storage**: `.highway/governance/experience-standard.md`, a shipped path.

**Testing**: `.highway/tools/tests/run-all.sh`. This phase adds no checker — Phase 6 owns that —
but the suite must stay green and `adapter-coverage.test.sh` must pass after the skill edits.

**Target Platform**: Ships in the distribution, so it must be self-contained.

**Project Type**: Governance document plus two skill edits.

**Constraints**:

- Ships, so it must reference no development-only path (`D1.1`)
- Must restate no rule text from either constitution (`D1.4`)
- Every cross-reference must resolve inside the shipped tree (`D6.2`)
- Editing either skill requires regeneration in the same change (`D4.7`)
- A normative section stays within 400 words (`P7.5`) — verified to have headroom

**Scale/Scope**: One new document, two skills edited, six rule families considered, a subset
admitted.

## Constitution Check

*GATE: evaluated before Phase 0, re-evaluated after Phase 1.*

### Process gates

| Gate | Trigger | Verdict |
|---|---|---|
| **Packaging Gate** | Change touches a shipped path — yes, `.highway/governance/` and both skills | **PASS** — D1.1 the standard names no development path; D1.2 unaffected; D6.2 cross-references resolve inside the shipped tree |
| **Toolchain Gate** | Change touches `.highway/tools/` — **no** | **N/A** |
| **Generator Gate** | Change touches a `generate-*.sh` — **no** | **N/A** |
| **Correspondence Gate** | Change modifies a directory under `.highway/skills/` — **yes** | **PASS on completion** — D4.5 and D4.6 unaffected; **D4.7 requires regeneration of the catalog and all adapters**, done in T012 |
| **Validation Gate** | Change adds or modifies a validation check — **no** | **N/A** — Phase 6 owns enforcement |
| **Spec Record Gate** | Change touches `specs/` — yes | **PASS** — D5.1 no completed spec edited; D5.4 017 follows 016 contiguously |
| **Skill Content Gate** | Change modifies a file under `.highway/skills/` — **yes** | **Delegated per D1.5**, below |

### Skill content gate — against the Highway Skills Constitution

| Rule | Relevance | Verdict |
|---|---|---|
| `P7.3` | A skill must not restate a normative rule defined elsewhere | **PASS** — skills cite `X` ids, restating no rule text |
| `P7.5` | Normative section ≤ 400 words | **PASS** — verified empirically 2026-09-08; the validator accepted a citation line added to `highway-inquiry`'s Outputs |
| `P7.7` | Breaking contract change increments MAJOR | **N/A** — no contract changes; both edits are PATCH |
| `P8.7` | No relative link targets | **PASS** — citations are rule ids, not links |

### Rules this feature is itself subject to

| Rule | Verdict |
|---|---|
| `D1.3`, `D1.4` — no restatement | **PASS**, and this is the feature's central risk. Phase 0 identified `P1.7`, `P5.2` and `P4.6` as near-collisions and drew the `P`/`X` line to avoid them. |
| `D3.1` — passing suite before | **PASS** — 17/17 verified 2026-09-08 |
| `D3.3` — behavioral change adds a test | **N/A** — no behaviour changes; no script is modified |

**Gate result**: proceed. No violations. One gate discharges only on completion (D4.7 via T012).

## Project Structure

### Documentation (this feature)

```text
specs/017-experience-standard/
├── spec.md
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/
│   └── experience-standard.md
├── checklists/
│   └── requirements.md
└── tasks.md             # Phase 2 output (/speckit.tasks)
```

### Source Code (repository root)

```text
.highway/
├── governance/
│   ├── constitution.md              # unchanged
│   └── experience-standard.md       # NEW: Layer 2, X namespace
├── skills/
│   ├── highway-help/SKILL.md        # Outputs cites X rules; version PATCH
│   └── highway-inquiry/SKILL.md     # Outputs cites X rules; version PATCH
├── catalog/                         # regenerated (D4.7)
└── tools/.adapter-manifest          # regenerated (D4.7)

.github/skills/, .claude/skills/, .cursor/rules/   # adapters regenerated (D4.7)
```

**Structure Decision**: A separate document rather than a section inside the Skills Constitution.
The two govern different artifacts, ship together, and version independently; merging them would
make every Layer 2 addition an amendment to Layer 1 and would blur the boundary Phase 0 just drew.

## Implementation Approach

### Ordering

1. **Author the standard first**, complete with its scope, precedence, non-goal, and tier
   definitions — before any rule is written. The framing decides what is admissible.
2. **Admit rules one family at a time**, each traced to behaviour an existing skill already
   exhibits, each checked against the `P` inventory for restatement.
3. **Record candidates** that cannot be given an Observable today, so a later reader knows they
   were considered rather than missed.
4. **Then** edit the skills to cite, bump versions, and regenerate.

Editing the skills last means the standard is settled before anything cites it, so no citation
points at a rule id that later moves.

### The rule families, and what each contributes

| Family | Admitted | Basis | Sample |
|---|---|---|---|
| X1 Output structure | Yes | Both skills declare the shape of what they emit | Two skills |
| X2 Interaction | Yes, narrowly | Confirmation must state what is lost, not merely ask | **One skill** |
| X3 Terminology | **No — candidate** | Needs a glossary to check against; none exists | — |
| X4 Artifact placement | Yes | The written path is declared, or the skill declares it writes nothing | **One skill** |
| X5 Provenance | Yes, narrowly | A message names what its reader can act on | Two skills, **from their disagreement** |
| X6 Determinism | Yes | An unchanged input set produces an unchanged artifact | **One skill** |

Four of the six rest on a single skill. The standard must say so per FR-010, so a later reader
knows which rules are generalisations from one example rather than from agreement.

### The precedence and non-goal statements

Both are load-bearing rather than boilerplate:

- **Precedence** — the Skills Constitution outranks the standard, and security-affecting rules
  outrank everything. Without this, a future conflict between a `P` rule and an `X` rule has no
  resolution.
- **Non-goal** — the standard governs only the *form* of generated content and states no
  obligation about the content of a user's own governance artifacts. Phase 7 builds
  `highway-nfrs`; without this sentence the standard could be read as licence to validate a user's
  NFR text against Highway's rules, which would fail a user for the prose style of their own
  policy.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|---|---|---|
| A third governing document | The three layers govern different artifacts and version independently | Folding Layer 2 into the Skills Constitution makes every Layer 2 addition a Layer 1 amendment, and erases the boundary that keeps `P1.7` and its `X` counterpart distinct |
| Rules admitted on a single skill's evidence | The Gate delivered a second skill, but `highway-help` writes no file, asks nothing, and confirms nothing — so interaction, placement, and determinism have one example each | Waiting for a third skill defers the standard indefinitely; Phase 7's skills are themselves gated on it. Marking the single-sample rules is the honest middle. |
| No `[auto]` rules in a document that will need them | Phase 6 owns enforcement | Tagging `[auto]` now would restate the exact defect features 013 and 014 removed, in a document with no inventory to contradict it |

## Post-Design Constitution Re-check

Re-run after Phase 1 artifacts were written. No verdict changed.

- The design adds no script, so the Toolchain, Generator and Validation gates stay `N/A`.
- The restatement risk identified in Phase 0 is now a written constraint in the contract, so
  `D1.4` is checkable at implementation time rather than left to judgement.
- The Correspondence Gate still discharges on completion via regeneration; it is the first time
  `D4.7` governs a feature other than its own.
