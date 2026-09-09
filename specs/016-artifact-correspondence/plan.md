# Implementation Plan: Generated Artifact Correspondence

**Branch**: `016-artifact-correspondence` | **Date**: 2026-09-08 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/016-artifact-correspondence/spec.md`

## Summary

Write three obligations into the Highway Development Constitution — every skill has its generated
artifacts (`D4.5`), no generated artifact names a skill that is gone (`D4.6`), and a change to a
generator's input is followed by regeneration (`D4.7`) — and enforce all three by extending
`adapter-coverage.test.sh`.

The technical approach turns on one finding from Phase 0: the generators resolve every path from
their own location, so they can be run inside a copy of the tree. Currency is therefore checked by
regenerating into a temporary directory and comparing against the committed artifacts, which makes
"leaves the working tree untouched" a property of the design rather than a discipline the test has
to maintain.

**Phase 0 also found a live violation.** The committed library catalog is stale: feature 015 added
the requirements questionnaire and never regenerated it, so `library-index.json` records
`"entries": []`. The suite passes 17/17 with that defect present. It must be repaired before D4.7
is enabled, or the amendment becomes MAJOR rather than MINOR.

## Technical Context

**Language/Version**: Bash 3.2.57 (macOS system bash), per `D2.1`

**Primary Dependencies**: None beyond the Declared Toolchain in the Development Constitution. This
feature adds no utility not already used.

**Storage**: Files in the repository. No database.

**Testing**: `.highway/tools/tests/run-all.sh`, which auto-discovers `*.test.sh`

**Target Platform**: macOS and Linux, per `D2.3` — every flag must work on both GNU coreutils and
the Apple/BSD variants

**Project Type**: Shell toolchain plus governance documents

**Performance Goals**: The currency check copies `.highway/` and runs three generators. This must
stay fast enough that the suite remains a habit rather than a chore; target under two seconds
added to total suite time.

**Constraints**:

- The currency check MUST leave the working tree byte-identical, pass or fail (FR-012)
- No check may depend on `.adapter-manifest` row ordering (FR-011)
- No enumerated list of skills anywhere in the checks (FR-008)
- The test file must not contain literal development-path tokens, or it trips
  `shipped-tree-independence` — assemble at runtime, per the precedent from features 012 and 014

**Scale/Scope**: 2 skills, 3 agent trees, 3 generators in scope, 1 constitution amendment adding
3 rules, 1 test file extended.

## Constitution Check

*GATE: evaluated before Phase 0, re-evaluated after Phase 1.*

### Process gates

| Gate | Trigger | Verdict |
|---|---|---|
| **Packaging Gate** | Change touches a shipped path — yes, `.highway/tools/tests/` and the library catalog | **PASS** — D1.1 satisfied by assembling development-path tokens at runtime; D1.2 unaffected; D6.2 no new cross-references |
| **Toolchain Gate** | Change touches `.highway/tools/` — yes | **PASS** — D2.1 no bash-4 constructs; D2.2 no new utility; D2.3 `cp -R`, `diff`, `mktemp`, `grep` all portable; D2.4 no new dependency |
| **Generator Gate** | Change touches a `generate-*.sh` — **no**, generators are read and run, never modified | **N/A** |
| **Validation Gate** | Change adds validation checks — yes | **PASS** — D3.4 satisfied by T005 evaluating against every fixture before enabling; D3.5 no assertion weakened |
| **Spec Record Gate** | Change touches `specs/` — yes | **PASS** — D5.1 no completed spec edited; D5.4 016 follows 015 contiguously |
| **Skill Content Gate** | Change creates or modifies a file under `.highway/skills/` or `.highway/library/` — **no** | **N/A: Skill Content Gate not triggered.** The library *catalog* is regenerated, but no library or skill source file is authored. |

### Rules this feature is itself subject to

| Rule | Relevance | Verdict |
|---|---|---|
| `D1.3`, `D1.4` | The new rules must not restate existing rule text | **PASS** — D4.7 and D4.1 state different obligations; see research R-note in spec FR-006 |
| `D1.6` | The distributed path set declared once | **PASS** — checks read `dist_classify` rather than re-deriving |
| `D3.1` / `D3.2` | Passing suite before and after | **PASS before** — verified 17/17 on 2026-09-08 |
| `D4.7` (the rule being added) | Must pass on enablement | **CONDITIONAL** — fails today against the library catalog. Repaired in T001 before enablement; see Complexity Tracking |

**Gate result**: proceed. One conditional, tracked below and discharged by the first task.

### Post-design re-evaluation (2026-09-08)

Re-run after Phase 1. No verdict changed. Confirmed by measurement:

- `shipped-tree-independence.test.sh` passes — the three spec artifacts that name `.specify/` all
  live under `specs/`, which is itself development-only, so `D1.1` is not engaged.
- Suite is 17/17.
- The design added no generator change, so the Generator Gate stays `N/A`.
- The `D4.7` conditional is unchanged and still discharged by the repair task. The repair is
  already applied in the working tree and verified current.

## Project Structure

### Documentation (this feature)

```text
specs/016-artifact-correspondence/
├── spec.md              # Phase -1 output
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/
│   └── correspondence-check.md
├── checklists/
│   └── requirements.md
└── tasks.md             # Phase 2 output (/speckit.tasks — not created here)
```

### Source Code (repository root)

```text
.specify/memory/constitution.md          # amended: +D4.5 +D4.6 +D4.7, Enforcement Map, 1.1.0 -> 1.2.0

.highway/
├── catalog/
│   ├── library-index.json               # repaired: stale entries[] refreshed
│   └── library-index.md                 # repaired
└── tools/
    └── tests/
        └── adapter-coverage.test.sh     # extended: correspondence + currency checks
```

**Structure Decision**: Extend one existing test rather than add new files, per FR-007.
`adapter-coverage.test.sh` already iterates the skills present, already derives adapter paths from
the skill id, and already carries the zero-skills vacuity guard — the three things the new checks
need. Adding a second test file would duplicate all three and create a second mechanism asserting
an overlapping property.

No generator is modified. FR-018 settled that generators do not prune, so they need no change at
all; the checks report orphans and a person removes them.

## Implementation Approach

### Ordering

1. **Repair before enabling.** Regenerate the library catalog first, so D4.7 is enabled against a
   conforming tree and the amendment stays MINOR. This must be a separate, verifiable step rather
   than a side-effect of later work.
2. **Amend the constitution.** Three rules, three Enforcement Map rows, Sync Impact Report.
3. **Extend the test**, one correspondence at a time, each with its failure proof.
4. **Prove every failure by round trip**, using `highway-inquiry` as the subject.

### The five checks

| # | Rule | Question asked | Order-dependent? |
|---|---|---|---|
| 1 | D4.5 | Does each skill have a catalog entry? | No |
| 2 | D4.5 | Does each skill have an adapter in each of the three declared trees? | No |
| 3 | D4.5 | Is each adapter classified `include`? | No — already implemented |
| 4 | D4.6 | Does any catalog entry, adapter file, or manifest row name a skill with no source? | No |
| 5 | D4.7 | Does regenerating into a temp tree reproduce the committed artifacts? | No — manifest excluded |

### The currency check, concretely

```text
tmp := mktemp -d
copy .highway/ -> tmp/.highway/
run the three generators from inside tmp
compare, ignoring a recorded generation timestamp:
    tmp/.highway/catalog/index.{json,md}
    tmp/.highway/catalog/library-index.{json,md}
    tmp/.github|.claude|.cursor adapter files
remove tmp
```

`.adapter-manifest` is deliberately not compared — see research R4. The real tree is never written
to, so FR-012 holds even if the check exits early.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|---|---|---|
| D4.7 does not pass against the tree as committed | The rule is correct; the tree is wrong. The library catalog went stale in feature 015 and nothing detected it. | Classifying the amendment MAJOR would treat a repairable defect as a redefinition of the rule, and would leave the stale catalog in place. Repairing costs one regeneration. |
| The currency check copies the framework tree on every suite run | It is the only way to regenerate without writing to the repository. | Regenerating in place and restoring afterwards leaves the tree dirty whenever the test is interrupted between the two steps — a silent failure landing on the next person. |
| `adapter-coverage.test.sh` duplicates the generator's agent path list | Pre-existing; the test already hard-codes the three adapter paths. | Unifying them is a latent `D1.6` improvement that touches a shipped generator, widening this feature's blast radius. Recorded in research R5 for a future feature. |
