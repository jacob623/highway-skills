# Implementation Plan: Auto-Tier Honesty

**Branch**: `013-auto-tier-honesty` | **Date**: 2026-09-08 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/013-auto-tier-honesty/spec.md`

## Summary

Two rules in the Highway Skills Constitution are tagged `[auto]` while no script decides them, so
the tier tag makes a promise the toolchain does not keep. P6.4 gains a real check, backed by a
token list declared in the constitution rather than buried in a script. P2.3 is retagged as
judgement-requiring, because deciding whether an example is technology-specific is semantic and no
mechanical proxy covers it honestly.

The approach is not newly invented. Feature 003 analysed both rules and deferred them to an
amendment that never happened; its two tasks are still open. This feature is that amendment,
arriving under a different version number.

A guard is added so the tier cannot drift out of honesty again: the set of rules tagged `[auto]`
minus the set of registered checks must be empty, asserted by the test suite.

## Technical Context

**Language/Version**: Bash 3.2.57, the macOS system shell (D2.1)

**Primary Dependencies**: None. The check reads its token list through `con_token_list()`, which
already exists and already serves the Prohibited Vagueness List.

**Storage**: The token list is a section of `.highway/governance/constitution.md`, formatted as a
heading followed by a blockquote — the shape `con_token_list()` already parses.

**Testing**: The existing harness at `.highway/tools/tests/`, currently 15 tests. One test is
extended; one is amended.

**Target Platform**: macOS and Linux; every flag accepted by both variants (D2.3).

**Project Type**: Governance document plus the toolchain that enforces it. No application
structure.

**Performance Goals**: Not applicable. One additional per-skill text scan.

**Constraints**: The five-group coverage summary is a contract and must not change shape. The
constitution ships, so any change to it must survive packaging and remain resolvable inside the
distribution.

**Scale/Scope**: Two rules. One new check, one retag, one new constitution section, one registry
row, one exemption entry, one new test assertion.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-checked after Phase 1 design.*

Evaluated against `.specify/memory/constitution.md` v1.0.0. Gates whose trigger is false are
recorded N/A.

### Process gates

**Packaging Gate** — triggered: the change touches shipped paths, both the constitution and the
rule-check library.

| Rule | Verdict | Evidence |
|---|---|---|
| D1.1 | PASS | No development-path token is introduced; `shipped-tree-independence.test.sh` covers both changed files. |
| D1.2 | PASS | The token list lives inside the constitution, which ships, so the check resolves in a distribution. Quickstart S11 verifies the distribution still builds. |
| D6.2 | PASS | No new cross-reference is added. |

**Toolchain Gate** — triggered: the change touches files under `.highway/tools/`.

| Rule | Verdict | Evidence |
|---|---|---|
| D2.1 | PASS | The check uses `awk` and `grep` in the style of the twelve existing checks; no Bash 4 construct. |
| D2.2 | PASS | No utility outside the Declared Toolchain. |
| D2.3 | PASS | No new flag. |
| D2.4 | PASS | No new dependency; the token-list mechanism already exists. |

**Generator Gate** — **N/A: no `generate-*.sh` script is touched.**

**Validation Gate** — triggered: the change adds a validation check.

| Rule | Verdict | Evidence |
|---|---|---|
| D3.4 | PASS | Research R6 requires every fixture's verdict under the new check to be recorded before it is registered. This is the gate's whole purpose and the specific failure that nearly shipped in feature 009. |
| D3.5 | PASS | No assertion is removed or loosened. The inventory test gains an assertion; nothing is relaxed. |

**Spec Record Gate** — triggered: the change touches `specs/`.

| Rule | Verdict | Evidence |
|---|---|---|
| D5.1 | PASS | `specs/003-constitution-enforcement/` is **not** edited. It carries two open tasks, so it is not a completed spec by the constitution's definition, but leaving it untouched is the correct treatment regardless. |
| D5.2 | PASS | This feature is the new spec that carries the correction, rather than an edit to feature 003. |
| D5.3 | PASS | Research R4 names both superseded elements, T046 and T047, explicitly. |
| D5.4 | PASS | `013` follows `012`. |

**Skill Content Gate** — **triggered**, corrected after task decomposition. An earlier version of
this plan recorded N/A on the basis that only the constitution and the toolchain were touched.
Decomposing the work showed that P6.4 and its token list must be cited from
`.highway/skills/_authoring-standard.md` — otherwise an author learns the constraint by failing,
which is the exact defect Phase 2b of the governance plan existed to close. That file is under
`.highway/skills/`, so the trigger is true.

### Skill content gates

Evaluated against `.highway/governance/constitution.md` v2.1.0, for the one skill-tree file this
feature modifies.

| Rule | Verdict | Evidence |
|---|---|---|
| P7.3 | PASS | The authoring standard cites `P6.4` by id and restates no rule text; `authoring-standard.test.sh` asserts both and is re-run by T023. |
| P8.7 | PASS | The citation is by rule id, not a relative link, so no link target is introduced. |
| P1.1 | PASS | No development-only path is referenced; `shipped-tree-independence.test.sh` covers the file. |

No other rule in that document constrains the authoring standard, which is guidance rather than a
skill: it carries no frontmatter and is not validated by `validate-skill.sh`.

### A gate-trigger gap, recorded not exploited

The Skill Content Gate triggers on changes under `.highway/skills/` or `.highway/library/`. It
does **not** trigger on a change to the constitution those paths are validated against, which is
at least as consequential.

That gap is real and remains. It is worth noting that this feature only satisfies the gate by
accident — through the authoring-standard citation, not through amending the constitution itself.
Had P6.4 needed no citation, a MINOR amendment to the governing document would have proceeded with
no skill-content verdict recorded at all.

It is not fixed here. Widening a gate trigger is a change to the development constitution and
belongs in its own amendment, not bundled into a feature about a different document.

### The guard covers one document, and says so

The development constitution has the identical defect this feature fixes: ten `D` rules tagged
`[auto]`, and only three `D` ids appearing anywhere in the toolchain — all three as comment
citations, not checks.

The guard added by FR-015 is therefore **scoped explicitly to the Highway Skills Constitution**,
with its scope stated in the failure message. An unscoped guard reading only `con_file()` would
pass while half the problem stood, which is worse than no guard: it turns an open gap into an
apparently closed one.

The `D` side is assigned to **Phase 4b** of `governance-plan.md` rather than left as a
`TODO(...)`. That choice is evidence-based — of the four gap-tracking mechanisms in this
repository, numbered phases in that document have been executed, while `TODO` entries went stale
(feature 011 found three already satisfied but never removed) and deferred spec tasks went
unnoticed for the life of the project (feature 003's T046 and T047, found only by grep).

**Result: PASS on every triggered gate. No violations. Complexity Tracking is empty.**

## Project Structure

### Documentation (this feature)

```text
specs/013-auto-tier-honesty/
├── plan.md                          # This file
├── spec.md                          # Feature specification
├── research.md                      # Phase 0 output
├── data-model.md                    # Phase 1 output
├── quickstart.md                    # Phase 1 output
├── contracts/
│   └── coverage-summary.md          # Phase 1 output — an invariance contract
├── checklists/
│   └── requirements.md              # 16/16
└── tasks.md                         # Created by /speckit.tasks, not here
```

### Source Code (repository root)

```text
.highway/
├── governance/
│   └── constitution.md                      # AMENDED — 2.1.0 → 2.2.0 (MINOR)
│                                           #   P2.3 retagged [agent-checkable]
│                                           #   token list section added
│                                           #   follow-up entry removed
└── tools/
    ├── lib/
    │   └── rule-checks.sh                   # AMENDED — rc_check_P6_4, registry
    │                                       #   row, library exemption
    └── tests/
        ├── constitution-inventory.test.sh   # AMENDED — tier-honesty guard
        ├── rule-checks.test.sh             # AMENDED — P6.4 cases
        ├── validate-skill.test.sh          # AMENDED — fixture assertions
        └── fixtures/
            └── invalid-skill-nondeterministic-criterion/  # NEW

.highway/skills/
└── _authoring-standard.md                   # AMENDED — cites P6.4 by id
```

**Structure Decision**: Nothing new is introduced. The check joins twelve others in
`rule-checks.sh`, the fixture joins eight others, and the token list joins the Prohibited
Vagueness List in the constitution using the same heading-plus-blockquote shape that
`con_token_list()` already parses. The one judgement call is placing the tier-honesty guard in
`constitution-inventory.test.sh` rather than `rule-checks.test.sh`: the inventory test already
asserts that what the constitution says about itself is true, and "every rule claiming automation
has one" is that same assertion.

## Complexity Tracking

No Constitution Check violations. This section is intentionally empty.
