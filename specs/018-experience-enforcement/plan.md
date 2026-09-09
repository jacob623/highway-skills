# Implementation Plan: Enforce the Experience Standard

**Branch**: `018-experience-enforcement` | **Date**: 2026-09-08 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/018-experience-enforcement/spec.md`

## Summary

Teach the existing rule loader to read the Experience Standard alongside the Skills Constitution,
so every `X` rule lands in exactly one coverage group and none can silently go unenforced. Register
the small number of `X` rules a script can honestly decide, and have each skill's Verification
section name the rules its own self-check exercises.

Phase 0 established the honest size of the automatable set: **one rule, plus one partial**. Seven
of eight `X` rules govern runtime output that no static check can see. That makes the *inventory*
the durable deliverable, not the automation — and it means the main risk in this feature is
overstating what has been enforced.

One decision is open. The strongest mechanically decidable property has no rule to enforce, and
closing that gap needs a scope extension the spec does not currently permit. See Complexity
Tracking.

## Technical Context

**Language/Version**: Bash 3.2.57, per `D2.1`

**Primary Dependencies**: None new. The rule-check library and coverage summary already exist.

**Storage**: Files. `lib/constitution.sh`, `lib/rule-checks.sh`, `validate-skill.sh`, both skills,
and the standard.

**Testing**: `.highway/tools/tests/run-all.sh`; the inventory test is extended rather than replaced.

**Target Platform**: Ships. Both governance documents and the loader are distributed.

**Constraints**:

- The five-group summary format is unchanged (`FR-008`)
- No second enforcement mechanism (`FR-009`)
- Existing single-document callers keep working (`FR-003`)
- `validate-library.sh` must not load the standard (research R2)
- No rule tagged `[auto]` without a check that decides it (`FR-010`)
- Any reader change needs a vacuity assertion (`FR-006`)

**Scale/Scope**: 8 `X` rules, 2 skills, 1 loader pattern widened, 1 caller looped, 1 test extended.

## Constitution Check

*GATE: evaluated before Phase 0, re-evaluated after Phase 1.*

### Process gates

| Gate | Trigger | Verdict |
|---|---|---|
| **Packaging Gate** | Touches a shipped path — yes | **PASS** — D1.1 no development path introduced; D1.2 the loader still resolves inside `.highway/`; D6.2 no new cross-reference |
| **Toolchain Gate** | Touches `.highway/tools/` — yes | **PASS** — D2.1 no bash-4 constructs; D2.2 no new utility; D2.3 no new flags; D2.4 no new dependency |
| **Generator Gate** | Touches a `generate-*.sh` — no | **N/A** |
| **Correspondence Gate** | Modifies a directory under `.highway/skills/` — yes | **PASS on completion** — `D4.7` discharged by regeneration after the skill edits |
| **Validation Gate** | Adds or modifies a validation check — yes | **PASS** — `D3.4` pre-evaluation against every fixture before enabling; `D3.5` no assertion weakened |
| **Spec Record Gate** | Touches `specs/` — yes | **PASS** — `D5.1` no completed spec edited; `D5.4` 018 follows 017 |
| **Skill Content Gate** | Modifies a file under `.highway/skills/` — yes | **Delegated per D1.5**, below |

### Skill content gate — against the Highway Skills Constitution

| Rule | Relevance | Verdict |
|---|---|---|
| `P7.3` | No restating a rule defined elsewhere | **PASS** — Verification sections cite `X` ids only |
| `P7.5` | Normative section ≤ 400 words | **Check at implementation** — Verification sections gain a line; smaller than the Outputs edit already proven safe in feature 017 |
| `P8.4` | Verification names a checkable item | **PASS** — both already do; this adds rule ids alongside |
| `P7.7` | Breaking change increments MAJOR | **N/A** — no contract changes; both edits are PATCH |

### Rules this feature is itself subject to

| Rule | Verdict |
|---|---|
| `D3.1` passing suite before | **PASS** — 17/17 on 2026-09-08 |
| `D3.3` behavioral change adds a test | **PASS** — the inventory test is extended |
| `D1.4` no restatement | **PASS** — no rule text is copied; the loader reads both documents rather than merging their text |

**Gate result**: proceed. One open decision, tracked below, which does not block Phases 1–2.

## Project Structure

### Documentation (this feature)

```text
specs/018-experience-enforcement/
├── spec.md
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/
│   └── merged-inventory.md
├── checklists/
│   └── requirements.md
└── tasks.md             # Phase 2 output
```

### Source Code (repository root)

```text
.highway/
├── governance/
│   └── experience-standard.md       # tier retags; possibly one added rule — see Complexity
├── skills/
│   ├── highway-help/SKILL.md        # Verification cites X rules; Example repaired; PATCH
│   └── highway-inquiry/SKILL.md     # Verification cites X rules; PATCH
└── tools/
    ├── lib/constitution.sh          # namespace pattern widened
    ├── lib/rule-checks.sh           # X checks registered
    ├── validate-skill.sh            # iterates a document list
    └── tests/constitution-inventory.test.sh   # asserts X rules are grouped
```

**Structure Decision**: extend four existing files rather than add any. `FR-009` forbids a second
mechanism, and research R1 found the loader is already document-agnostic in its signature — only
its matching pattern was namespace-bound.

## Implementation Approach

### Ordering

1. **Widen the pattern and loop the caller.** This alone delivers User Story 1: all eight `X` rules
   appear in `DEFERRED`, and `UNCHECKED` stays empty, with no check written. Research R5 confirms
   the grouping logic needs no change.
2. **Extend the inventory test**, with a vacuity assertion proving it matched rules from both
   documents. Without that, a pattern mistake passes silently — the precise failure feature 014 hit.
3. **Repair the stale Example**, then write the check that would have caught it.
4. **Register whatever is honestly decidable**, and retag only those.
5. **Cite from Verification**, regenerate, discharge `D4.7`.

Step 3 is ordered repair-then-enable for the reason feature 016 recorded: enabling a rule against a
tree that violates it is a strengthening rather than an addition.

### The scoping decision that must be explicit

`validate-library.sh` shares the loader and the registry. Once the pattern accepts `X`, the only
thing keeping `X` rules away from library content is **which documents each caller passes**. That
must be written where a reader will see it, not left as an accident of the call site — otherwise a
future caller picks up the standard by default and starts judging a questionnaire template against
rules about skill emissions.

### What "enforced" will honestly mean at the end

| Group | Expected `X` rules | Meaning |
|---|---|---|
| `CHECKED` / `FAILED` | 1, possibly 2 | A script decides it |
| `DEFERRED` | 6 or 7 | An agent or reviewer decides it; the tier says so |
| `UNCHECKED` | **0** | Nothing claims automation it does not have |

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|---|---|---|
| **The specimen-currency check needs one added `X` rule** — **approved 2026-09-08** | The strongest decidable property found, and it already fails on `highway-help`. It has no existing rule: `X1.2` is about shape rather than values, and `X6.1` is about emitted artifacts rather than a skill file | Enforcing it as a bare test leaves the obligation discoverable only by failing the suite (feature 011). Redefining `X1.2` makes the rule mean whatever the check does (features 013, 014, 016). Added as a MINOR amendment instead |
| Widening a shipped loader's matching pattern | The pattern is the only thing binding it to one namespace | A second loader is the parallel mechanism `FR-009` forbids |
| Most rules remain `[agent-checkable]` after a feature named "enforce" | Seven of eight govern runtime output no static check can see | Writing proxies that pass everything would satisfy the name and defeat the purpose |

## Post-Design Constitution Re-check

Re-run after Phase 1. No verdict changed.

- No script is added, so the Toolchain Gate verdicts stand on modified files only.
- The Validation Gate remains the binding one: `D3.4` requires pre-evaluation of each new check
  against every fixture, and the contract records that as an acceptance item.
- The Correspondence Gate still discharges on completion, as in feature 017.
- The open decision in Complexity Tracking affects the standard's version, not any gate verdict.
