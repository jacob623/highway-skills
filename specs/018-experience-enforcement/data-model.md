# Data Model: Enforce the Experience Standard

**Feature**: 018-experience-enforcement | **Date**: 2026-09-08

No persistent data. The entities below are what the tooling reads and the groups it sorts rules
into.

## Entities

### Governance document

A file holding rule rows. Two ship and are in scope; one does not and is not.

| Document | Namespace | Read by | In scope here |
|---|---|---|---|
| `.highway/governance/constitution.md` | `P` | `validate-skill.sh`, `validate-library.sh` | Unchanged |
| `.highway/governance/experience-standard.md` | `X` | `validate-skill.sh` **only** | **Added** |
| `.specify/memory/constitution.md` | `D` | Nothing in `.highway/` | Out of scope — does not ship |

The third row is the boundary feature 014 settled: shipped tooling does not read a document that
never reaches a user.

### Rule row

Emitted by the loader as a tab-separated record.

| Field | Source | Note |
|---|---|---|
| `id` | Column 2 | Currently matched as `P<n>.<n>`; widens to `P` or `X` |
| `tier` | Column 5 | One of `auto`, `agent-checkable`, `human-review`, brackets stripped |
| `text` | Column 3 | Rule text |
| `observable` | Column 4 | Used in failure messages |

The loader rejects a malformed row and exits non-zero, which is unchanged.

### Coverage group

Every rule id lands in exactly one. The assignment logic already exists and needs no change:

```text
tier != auto                 ->  DEFERRED
tier == auto, no check fn    ->  UNCHECKED
tier == auto, check exit 2   ->  N/A
tier == auto, check exit 1   ->  CHECKED + FAILED
tier == auto, otherwise      ->  CHECKED
```

### Registered check

A function in the rule-check library bound to a rule id, plus an optional `N/A` condition token.
Adding an `X` check means adding a registry row and a function — the same shape as every `P` check.

### Specimen

A skill's `## Example` section: a recorded example of its output. Becomes load-bearing after this
feature — an edit to it can fail the suite.

| Skill | Specimen | Shape |
|---|---|---|
| `highway-help` | 9 non-blank lines | A labelled field block, checkable against the declared field list |
| `highway-inquiry` | 7 non-blank lines | Not a field block; `N/A` for shape checks |

### Declared coverage

The `X` ids a skill's Verification section names as exercised by its own self-check. The fallback
for rules no script will decide.

## Relationships

```text
     ┌────────────────────────┐     ┌──────────────────────────┐
     │ Skills Constitution (P)│     │ Experience Standard (X)  │
     └───────────┬────────────┘     └────────────┬─────────────┘
                 │                                │
                 └────────────┬───────────────────┘
                              ▼
                    ┌───────────────────┐
                    │ merged inventory  │   id, tier, text, observable
                    └─────────┬─────────┘
                              ▼
                    ┌───────────────────┐
                    │ coverage grouping │   exactly one group per id
                    └─────────┬─────────┘
                              ▼
        CHECKED / FAILED / N/A / DEFERRED / UNCHECKED

     validate-library.sh reads only the P document — never the standard.
```

## Validation rules

| # | Constraint | Source |
|---|---|---|
| V1 | Every rule id appears in exactly one coverage group | FR-005, FR-008 |
| V2 | The inventory reader matched at least one rule from each document it claims to cover | FR-006 |
| V3 | `UNCHECKED` is empty for every skill | FR-013 |
| V4 | No rule is tagged `[auto]` without a registered check | FR-010 |
| V5 | Existing single-document callers behave identically | FR-003 |
| V6 | `validate-library.sh` never loads the standard | research R2 |
| V7 | Every `X` id cited by a skill exists in the standard | FR-017 |
| V8 | A specimen agrees with the metadata it repeats | FR-019 |

## Expected end state

| Group | `P` rules | `X` rules |
|---|---|---|
| `CHECKED` / `FAILED` | 13–14 | 1, possibly 2 |
| `N/A` | varies by skill | varies |
| `DEFERRED` | ~35 | 6–7 |
| `UNCHECKED` | 0 | **0** |

The `X` distribution is the honest measured outcome from research R3, not a target to hit.
