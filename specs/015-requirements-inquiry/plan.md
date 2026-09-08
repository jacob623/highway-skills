# Implementation Plan: Requirements Inquiry Skill

**Branch**: `015-requirements-inquiry` | **Date**: 2026-09-08 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/015-requirements-inquiry/spec.md`

## Summary

A second Highway skill, `highway-inquiry`, lets a platform user manage the requirements discovery
questionnaire without editing skill code. It maintains
`.highway/library/templates/requirements-inquiry.md`, which ships in the library so a recipient
finds it in their own workspace.

The skill is prose an agent follows, not a program — which reframes most of the specification.
Asking rather than guessing, confirming before destroying, and challenging a weak question are
instructions whose quality is the precision of the skill's text. The mechanically testable surface
is conformance: the skill validates, the questionnaire validates, numbering is contiguous, text is
unique, and the skill actually reaches users.

That last one uncovered a defect. **A new skill's adapters are silently excluded from the
distribution**, because the manifest classifies them by exact path and only `highway-help` has
rows. Packaging succeeds and the recipient's agent cannot see the skill. This feature adds the
rows and a test so the next skill cannot repeat it.

## Technical Context

**Language/Version**: None. A skill is Markdown. Bash 3.2.57 applies only to the one test added.

**Primary Dependencies**: None. No script is written and no library changes.

**Storage**: Two Markdown files — the skill and the questionnaire — plus three manifest rows.

**Testing**: The existing harness, currently 16 tests. One test is added.

**Target Platform**: macOS and Linux, for the added test only (D2.3).

**Project Type**: Skill authoring. The toolchain validates and distributes skills; it does not run
them.

**Constraints**: The questionnaire must satisfy the library validator on every write, including a
`## Purpose` of exactly one sentence. The skill must satisfy the Skills Constitution, notably P8.7
(no relative links) and P6.4 (no nondeterministic vocabulary in decision criteria). Output must
carry no timestamp, or every write becomes a diff.

**Scale/Scope**: One skill, one questionnaire, three manifest rows, one test, two generators re-run.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-checked after Phase 1 design.*

Evaluated against `.specify/memory/constitution.md` v1.1.0.

### Process gates

**Packaging Gate** — triggered: the change adds shipped files under `.highway/skills/` and
`.highway/library/`, and edits the distribution manifest.

| Rule | Verdict | Evidence |
|---|---|---|
| D1.1 | PASS | Neither new file references a development-only location; `shipped-tree-independence.test.sh` covers both. |
| D1.2 | PASS | The distribution's own validator runs against its skills, which will include this one. |
| D6.2 | PASS | The skill names the questionnaire's path rather than linking to it, which P8.7 requires anyway, so no new cross-reference is introduced. |

**Toolchain Gate** — triggered: the manifest and a test live under `.highway/tools/`.

| Rule | Verdict | Evidence |
|---|---|---|
| D2.1 | PASS | The added test uses `awk` and `grep` in the style of the existing suite. |
| D2.2 | PASS | No utility outside the Declared Toolchain. |
| D2.3 | PASS | No new flag. |
| D2.4 | PASS | No new dependency. |

**Generator Gate** — **N/A: no `generate-*.sh` script is modified.** Two generators are *run*, and
D4.4 requires exactly that after content changes; their outputs are regenerated rather than
hand-written.

**Validation Gate** — triggered: a test asserting adapter coverage is added.

| Rule | Verdict | Evidence |
|---|---|---|
| D3.4 | PASS | The new test reads the manifest and the skills directory. It touches no fixture, so no existing fixture verdict can change — confirmed during implementation rather than assumed. |
| D3.5 | PASS | An assertion is added; none is removed or loosened. |

**Spec Record Gate** — triggered: the change touches `specs/`.

| Rule | Verdict | Evidence |
|---|---|---|
| D5.1 | PASS | No completed spec directory is edited. |
| D5.2 | PASS | New work in its own numbered directory. |
| D5.3 | PASS | The ordering decision names what it supersedes in the description. |
| D5.4 | PASS | `015` follows `014`; `spec-record.test.sh` decides this automatically now. |

**Skill Content Gate** — **triggered**: the change creates a file under `.highway/skills/` and one
under `.highway/library/`.

### Skill content gates

Evaluated against `.highway/governance/constitution.md` v2.2.0, per D1.5. The automatically
decided rules are listed because `validate-skill.sh` and `validate-library.sh` will decide them;
the judgement rules listed are those this feature is most likely to breach.

**The skill** — `.highway/skills/highway-inquiry/SKILL.md`:

| Rule | Verdict | Evidence |
|---|---|---|
| P7.1 | PASS | Exactly one Purpose sentence. Decided automatically. |
| P7.2 | PASS | `metadata.version` present, starting at 1.0.0. |
| P8.3 | PASS | Verification section present and non-empty. |
| P8.7 | PASS | The questionnaire is **named**, never linked. A relative link would resolve only in the source tree and is dead in all three adapter copies. |
| P6.4 | PASS | The `When to use` and `When not to use` sections avoid the prohibited nondeterministic vocabulary. Decided automatically since feature 013. |
| P1.1, P1.3 | PASS | One keyword per normative line, 25 words or fewer. Decided automatically. |
| P3.5, P4.2, P5.2 | PASS | Decided automatically; the plan commits to running the validator, not to predicting it. |
| P8.2 | PASS | Each dependent step names the step it follows — relevant because the skill describes ordered actions. |
| P8.4 | PASS | The Verification section names a checkable command. |

**The questionnaire** — `.highway/library/templates/requirements-inquiry.md`:

| Rule | Verdict | Evidence |
|---|---|---|
| P7.1 | PASS | Exactly one Purpose sentence. The most fragile requirement here, because the skill rewrites the file on every action. |
| P7.2 | PASS | `metadata.version` present. |
| P8.3 | PASS | Verification section present. |

A library file is decided against these three plus the schema fields; the prose rules, including
the vagueness list, are deferred. **A user's question wording is therefore not judged against
Highway's writing rules**, which is what makes it acceptable for users to author content here.

### A defect this gate does not catch

The Skill Content Gate asks whether skill content conforms. It does not ask whether the skill
*reaches anyone*. Adding a skill whose adapters are silently excluded passes every gate above and
still ships a skill no agent can see. The test added by this feature closes that, but the gap is
worth naming: conformance and delivery are different properties, and only one of them was gated.

**Result: PASS on every triggered gate. No violations. Complexity Tracking is empty.**

## Project Structure

### Documentation (this feature)

```text
specs/015-requirements-inquiry/
├── plan.md                              # This file
├── spec.md                              # Feature specification
├── research.md                          # Phase 0 output
├── data-model.md                        # Phase 1 output
├── quickstart.md                        # Phase 1 output
├── contracts/
│   └── questionnaire-format.md          # Phase 1 output
├── checklists/
│   └── requirements.md                  # 16/16
└── tasks.md                             # Created by /speckit.tasks, not here
```

### Source Code (repository root)

```text
.highway/
├── skills/
│   └── highway-inquiry/
│       └── SKILL.md                     # NEW — the skill, eight required sections
├── library/templates/
│   └── requirements-inquiry.md          # NEW — the questionnaire, with starting content
├── catalog/                             # REGENERATED — generate-catalog.sh
└── tools/
    ├── .distribution-manifest           # AMENDED — three adapter rows
    └── tests/
        └── adapter-coverage.test.sh     # NEW — every skill's adapters are included

.github/skills/highway-inquiry/          # GENERATED — generate-agent-adapters.sh
.claude/skills/highway-inquiry/          # GENERATED
.cursor/rules/highway-inquiry.mdc        # GENERATED
```

**Structure Decision**: The skill joins `highway-help` under `.highway/skills/`, and the
questionnaire joins the library it is distributed in. Neither placement is a choice — the skill
validator and the catalog generator both scan those directories, and the user asked for the
questionnaire to be visible in their library.

The one real decision is the **new test**. It could have been folded into
`distribution-packaging.test.sh`, which already reasons about the manifest. It is separate because
the property it asserts is about skills rather than about packaging: *every skill in the catalog
reaches an agent*. A packaging test that happened to notice would be the right check filed under
the wrong concern, and the next person adding a skill would not think to look there.

## Complexity Tracking

No Constitution Check violations. This section is intentionally empty.
