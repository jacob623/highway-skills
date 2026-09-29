# Contract: Experience Standard Amendment

Source: `.highway/governance/experience-standard.md`

## Version

| Field | Value |
|---|---|
| From | 3.0.0 |
| To | 4.0.0 |
| Class | MAJOR |
| Ratified | 2026-09-08 |
| Last amended | 2026-09-29 |

The opening comment contains only this amendment's sync report. That report names the X2.9 strengthening and the X2.25 redefinition, states that both are major, and records that prior reports were removed from this document. It does not name test files, feature numbers, superseded rule counts, or the development constitution. The footer is `**Version**: 4.0.0 | **Ratified**: 2026-09-08 | **Last Amended**: 2026-09-29`.

## X2.9

| Column | Text |
|---|---|
| ID | X2.9 |
| Rule | Decision Context MUST use the label "**Why it matters:**" and explain why the answer matters to the person without asking a second question. |
| Observable | When Decision Context applies, the response shows the literal label `**Why it matters:**`, then a concise user-relevant explanation, then one unresolved question. It includes no implementation explanation, no second question, and no repetition when the implication was just established. The label is absent when Decision Context is not needed. |
| Tier | `[agent-checkable]` |

The standard pattern, when the rule applies, is the label, the concise explanation, then one unresolved question. The label is not emitted when no Decision Context is needed.

## X2.25

| Column | Text |
|---|---|
| ID | X2.25 |
| Rule | Profile enrichment, Objectives, Controls, and Non-Functional Requirements MUST use the shared recommendation interaction model. |
| Observable | The set shows concise grounding, one or more distinct actionable recommendations, a clear selection path, and a user-authored alternative. Selecting a shown recommendation follows X2.18. Numbering is permitted and is not required. |
| Tier | `[agent-checkable]` |

## Non-normative recommendation guidance

Add a short illustration near the existing non-normative examples. It shows grounding, more than one distinct recommendation, a way to select them, and a way to write something else. It states that a single recommendation, bullets, or numbers can carry the same meaning, and that the sketch is not a required layout.

## Rows that stay

X2.16 still caps a set at five. X2.17 through X2.20 still provide a user-authored alternative, treat selection as acceptance, refuse to treat an information request as acceptance, and stop further recommendations when useful grounded choices are exhausted. X2.21 and X2.22 stay. X2.27 and X2.28 stay. X2.29 through X2.31 stay. The X2.3 observable still begins with "Every user-visible response excludes Implementation details unless requested."

## Test assertions

`highway-ux-alignment.test.sh` requires the new X2.9 and X2.25 sentences. It stops requiring the numbered-list sentence and the old Decision Context sentence. It stops requiring the Repository Context bump rationale to appear once. A comment names that superseded history check. The current report token `3.0.0 → 4.0.0 (MAJOR)` is required, and that old rationale is absent. The existing `Why it matters:` assertion on `highway-objectives` stays, because that skill already contains the label and this feature does not rewrite the skill.

`experience-standard-amendment.test.sh` stops requiring `1.6.1 -> 2.0.0 (MAJOR)`. A comment names that superseded token. It requires `3.0.0 → 4.0.0 (MAJOR)`, exactly one `Sync Impact Report` heading, the X2.3 observable sentence, and the new X2.9 and X2.25 rows. The current rows it already requires, other than the removed history token, stay required.
