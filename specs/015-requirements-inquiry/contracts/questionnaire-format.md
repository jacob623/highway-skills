# Contract: Questionnaire Format and Skill Behaviour

**Feature**: `015-requirements-inquiry` | **Date**: 2026-09-08

Two contracts. The questionnaire's format is consumed by a future presenting skill, so its shape
is binding. The skill's behaviour is a contract with the user about when it acts and when it asks.

---

## The questionnaire file

```text
---
name: requirements-inquiry
description: "The requirements discovery questions Highway skills ask, maintained by highway-inquiry."
metadata:
  version: 1.0.0
---

## Purpose
This questionnaire holds the requirements discovery questions Highway skills ask.

## Verification
Run `.highway/tools/validate-library.sh` against this file; it exits 0.

## Business Context
1. What problem is this system intended to solve?
2. Who are its users, and what outcome does each need?

## Security and Compliance
3. What regulatory obligations apply?
```

| Element | Constraint |
|---|---|
| Frontmatter | `name`, `description` under 500 chars, `metadata.version` as MAJOR.MINOR.PATCH |
| `## Purpose` | Exactly one sentence |
| `## Verification` | Present, non-empty |
| Section headings | `## <name>`, ordered as they appear |
| Questions | Ordered list, numbered contiguously from 1 **across the whole file** |
| Question text | Unique within the file |

**A reader can consume this by reading top to bottom.** No index, no cross-references, no
identifiers to resolve. That is the property the future presenting skill depends on, and it is why
the format carries no machinery beyond ordering.

---

## Skill behaviour

### Acts without asking

| Instruction | Because |
|---|---|
| Names one question unambiguously and one action | Nothing to resolve |
| Adds a question whose text does not duplicate an existing one | Nothing is lost |
| Views the questionnaire | Reads nothing away |

### Asks first, changes nothing until answered

| Situation | What the skill says |
|---|---|
| Several questions match the description | Names the candidates |
| No question matches | Says so, rather than adding one |
| A destination is unclear | Names the positions it is choosing between |
| A move crosses a section boundary and may not be intended | Names both readings |

### Confirms before destroying

| Action | Confirmation must state |
|---|---|
| Replace the whole questionnaire | How many questions are lost, and that they are not in the new set |
| Remove a question | Which question, by its text |

"Are you sure?" does not satisfy this. The user must be able to make the decision from what they
are told.

### Advises, never vetoes

On judging a question weak, the skill explains the problem and offers at least one alternative.
The user may take an alternative, supply their own, or proceed unchanged. **A skill that can
refuse a question its owner wants will be worked around by editing the file directly**, which
defeats its purpose.

### Repairs quietly, reports honestly

After every write the skill checks the questionnaire against the library validator.

| Situation | Behaviour |
|---|---|
| A framework-owned element fails — frontmatter, Purpose, Verification | Repair, rewrite, say nothing |
| Repair would require changing a question's text or a section's name | Do not change it |
| The file still fails after repair | Report, naming what could not be fixed |

The rule behind the table: **loud about their content, quiet about our plumbing**. A platform user
managing questions has no use for a rule id, and the elements those rules govern are ones they
never wrote. Every rule a library file is checked against today is framework structure, so quiet
repair never reaches user content.

---

## Reporting after a change

Every action that changes numbering ends with the resulting numbering. A user's next instruction
is given against what the file now holds, and they can only do that if they have been told.

Where a multi-step instruction was resolved step by step, and the numbering used differs from what
the user named, the skill says which numbering it used.

---

## Guarantees

| # | Guarantee | Requirement |
|---|---|---|
| G1 | Every action is possible without editing a skill file | FR-021, SC-001 |
| G2 | Numbering is contiguous after every action | FR-006, SC-002 |
| G3 | No two questions share text | FR-005a, SC-002a |
| G4 | An ambiguous instruction leaves the file byte-identical | FR-009, SC-004 |
| G5 | Destructive actions confirm, naming what is lost | FR-011, SC-005 |
| G6 | Quality checks advise and can be overridden | FR-014, SC-007 |
| G7 | Every write passes the library validator | FR-017, SC-008 |
| G8 | Two writes of unchanged questions are identical | FR-018, SC-009 |
| G9 | The skill validates against the Skills Constitution | FR-020, SC-010 |

---

## Out of scope

Reading the questionnaire, presenting the questions, and recording answers. A skill that does
those is planned separately. This contract's job is to make that skill easy to write: read in
order, key answers by text.
