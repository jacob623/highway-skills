# Implementation Plan: Repository Controls

**Branch**: `019-repository-controls` | **Date**: 2026-09-08 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/019-repository-controls/spec.md`

## Summary

Ship a `highway-controls` skill that manages a repository-wide Control baseline in
`library/governance/` at the **project root** — user-owned content that Highway writes but does not
govern — and tighten the library validator so that containment is structural rather than dependent
on how a path is typed.

Two findings from Phase 0 shape the work. The obvious implementation of the containment fix would
break every library test, because fixtures live under `.highway/tools/tests/fixtures/library/`
rather than `.highway/library/`. And the skill is close enough to `P7.4`'s twelve-rule cap that
whether it stays one skill is a decision to measure rather than assume.

## Technical Context

**Language/Version**: Markdown for the skill; Bash 3.2.57 for the one validator change, per `D2.1`.

**Primary Dependencies**: None new.

**Storage**: User Controls at `<project>/library/governance/`. The skill itself under
`.highway/skills/highway-controls/`.

**Testing**: `.highway/tools/tests/run-all.sh`. One new test for the containment boundary.

**Target Platform**: The skill ships; the Controls it writes belong to the user and never ship.

**Constraints**:

- No Highway rule may judge a Control's content (`FR-004`)
- Containment must not depend on the invocation form (`FR-003`)
- The catalog carries no timestamp (`FR-008`, `X6.1`)
- Nothing is destroyed without each loss being named (`FR-018`, `X2.1`)
- The skill's own text obeys the Skills Constitution and the Experience Standard

**Scale/Scope**: 1 new skill, 1 validator change, 1 new test, 4 actions, 31 requirements.

## Constitution Check

*GATE: evaluated before Phase 0, re-evaluated after Phase 1.*

### Process gates

| Gate | Trigger | Verdict |
|---|---|---|
| **Packaging Gate** | Touches a shipped path — yes | **PASS** — the skill ships; `D1.1` no development path; `D6.2` no new cross-reference |
| **Toolchain Gate** | Touches `.highway/tools/` — yes | **PASS** — `D2.1` no bash-4 constructs; `D2.2` no new utility; `D2.3` no new flags |
| **Generator Gate** | Touches a `generate-*.sh` — no | **N/A** |
| **Correspondence Gate** | Adds a directory under `.highway/skills/` — **yes** | **PASS on completion** — `D4.5` needs catalog entry, three adapters, adapter manifest rows, and **distribution manifest rows**; `D4.7` needs regeneration |
| **Validation Gate** | Modifies a validation check — yes | **PASS** — `D3.4` pre-evaluation against every fixture; `D3.5` no assertion weakened |
| **Spec Record Gate** | Touches `specs/` — yes | **PASS** — `D5.1` no completed spec edited; `D5.4` 019 follows 018 |
| **Skill Content Gate** | Creates a file under `.highway/skills/` — **yes** | **Delegated per D1.5**, below |

### Skill content gate — against the Highway Skills Constitution

| Rule | Relevance | Verdict |
|---|---|---|
| `P7.1` | Exactly one Purpose sentence | **Check at implementation** |
| `P7.4` | At most 12 MUST-level rules | **The binding constraint** — see research R2 and Complexity Tracking |
| `P7.6` | A skill exceeding `P7.4` must be split | **Conditional** — decided by measurement, not in advance |
| `P7.5` | Normative section ≤ 400 words | **Check at implementation** — this skill has more to say than either existing one |
| `P8.7` | No relative link targets | **PASS** — the skill names paths as prose, not as links |
| `P5.2` | Every failure condition names one of four next actions | **Check** — the ambiguity and confirmation paths are numerous here |

### Rules this feature is itself subject to

| Rule | Verdict |
|---|---|
| `D3.1` passing suite before | **PASS** — 17/17 on 2026-09-08 |
| `D3.3` behavioral change adds a test | **PASS** — a containment test is added |
| Layer 3 containment (governance plan §2) | **PASS by design** — Controls are written outside `.highway/`, and `FR-003` makes that structural |

**Gate result**: proceed. One conditional (`P7.6`), resolved by measurement during implementation.

## Project Structure

### Documentation (this feature)

```text
specs/019-repository-controls/
├── spec.md
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/
│   └── controls-skill.md
├── checklists/
│   └── requirements.md
└── tasks.md             # Phase 2 output
```

### Source Code (repository root)

```text
.highway/
├── skills/highway-controls/SKILL.md     # NEW: the skill
└── tools/
    ├── validate-library.sh              # declines files outside the framework root
    └── tests/
        └── library-containment.test.sh  # NEW: proves the boundary holds

library/governance/                      # NEW, user-owned, never shipped, never validated
├── controls.md                          # generated index, baseline version, next identifier
└── controls/CTLXXXXXX.md                # one file per Control
```

**Structure Decision**: the user's directory is a sibling of `.highway/`, not inside it. That is
the whole containment argument — Highway governs the container, the user governs the contents — and
it is what lets a Control state an obligation in the user's own words without Highway objecting to
its length or its keyword count.

## Implementation Approach

### Ordering

1. **Tighten the validator first**, with its test. The containment boundary should exist before
   anything writes user content, not after.
2. **Author the skill**, measuring the `MUST` count as it is written rather than at the end.
3. **Register it properly** — catalog, three adapters, adapter manifest rows, and distribution
   manifest rows. The last of these is what feature 015 missed.
4. **Regenerate**, discharging the Correspondence Gate.

### The containment fix, concretely

The validator classifies a library file by matching a path glob. Scope it to the **framework
root** — the directory the validator itself lives under — so:

| File | Verdict |
|---|---|
| `.highway/library/templates/*.md` | classified, validated |
| `.highway/tools/tests/fixtures/library/**` | classified, validated — **fixtures must keep working** |
| `<project>/library/governance/*.md` | **declined**, whatever path form is used |

Research R1 records why the narrower reading — under `.highway/library/` — is wrong: it declines
every fixture.

### What the skill must not become

Three failure modes, each with a precedent in this repository:

- **A skill that overrules its user.** `FR-026` prohibits refusing a Control the user still wants.
  `highway-inquiry` states the reason: a skill that overrules gets bypassed, and then the files are
  hand-edited, which loses the identifiers, the versioning, and the catalog at once.
- **A confirmation that does not inform.** `FR-019` rejects a bare count. `X2.1` requires the loss
  to be named, because a user cannot decide from a number.
- **A catalog that drifts.** No timestamp, so an unchanged baseline regenerates identically and
  staleness is detectable rather than invisible.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|---|---|---|
| **The skill may exceed `P7.4`'s twelve-rule cap** | Four actions, identifier guarantees, confirmation obligations, and advisory behaviour are all genuinely required by the spec | Splitting pre-emptively guesses at a number nobody has measured. The budget is larger than it appears, because artifact-shape requirements belong in Outputs as description rather than as `MUST` rules — `highway-help` states zero. If the measured count exceeds twelve, split along the **Set** seam. |
| A change to a shipped validator to serve containment | Containment currently depends on whether a path is written relative or absolute, which is not containment | Documenting the convention instead leaves the boundary to discipline. `FR-003` makes it structural. |
| A second governance location in the repository | The user's content must live where Highway's rules cannot reach it | Keeping it under `.highway/library/governance/` is the exact defect the governance plan's first containment guard names, and it was measured: thirteen Controls fail `P7.4`, a long Control fails `P1.3`. |

## Post-Design Constitution Re-check

Re-run after Phase 1. No verdict changed.

- The design adds one script change and one test, so the Toolchain and Validation gates stand.
- `P7.6` remains conditional and is now a recorded decision point in the contract rather than a
  risk noted in passing.
- The Correspondence Gate discharges on completion, and its full obligation list is enumerated in
  research R5 rather than left to memory.
