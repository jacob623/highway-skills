---
name: highway-inquiry
description: "Manages the requirements discovery questionnaire that Highway skills ask from, adding, changing, removing and reordering its questions on request."
usage: "Invoke as `/highway-inquiry` and state what to change, for example `/highway-inquiry add a question about data retention`."
compatibility: all
metadata:
  version: 1.0.0
---

## Purpose

Maintain the requirements discovery questionnaire so its questions can be changed without editing
any skill.

## When to use

- Use when a question must be added, changed, removed, or moved.
- Use when the questionnaire must be read back in the order the questions are asked.
- Use when the whole question set is being replaced.
- Use when a question's wording needs a second opinion before it is adopted.

## When not to use

- Do not use to answer the questions. This skill maintains them.
- Do not use to change a Highway skill. It writes one file and no others.
- Do not use to record governance rules. Those belong to the constitution.

## Inputs

The file `.highway/library/templates/requirements-inquiry.md`, which holds the questions, their
sections, and their order. It ships in the library, so it is present in the user's own workspace.

A stated intent from the user. Supported intents are: view, replace the whole questionnaire, add,
update, remove, reorder, move a question before another, move a question after another, and insert
a question at a stated position.

## Outputs

The same file, rewritten, plus a statement of what changed.

The file's shape MUST be preserved on every write:

- Frontmatter carrying `name`, `description`, and `metadata.version`.
- A `## Purpose` section of exactly one sentence.
- A non-empty `## Verification` section.
- Sections as `## <name>` headings, in order.
- Each question as a bold number and its text, numbered from 1 across the whole file.

Numbering MUST be contiguous, with no gap and no duplicate.

Numbering MUST NOT restart in each section, because it states one sequence.

Question text MUST be unique within the file. A future skill will record answers against question
text, and duplicate text makes that record ambiguous.

Content MUST be a function of the questions, their sections, and their order. No timestamp is
written, so an unchanged question set produces an unchanged file.

### Steps for any change

1. Read the file and identify the intended action.
2. Resolve which question or position is meant, and ask where that is not decidable.
3. Where the action discards a question, state what is lost and get confirmation.
4. Apply the change, then renumber every question from 1.
5. Rewrite the file, preserving the shape stated above.
6. Check the file, and repair it where needed, per Error Handling.
7. Report what changed and the resulting numbering.

Step 4 follows step 3 so that nothing is discarded before the user has agreed to lose it.

### Resolving a numbered instruction

A question's number is its position, so a number names a different question after any change.

- Resolve each instruction against the file as it stands when that instruction is applied.
- Where an instruction has several parts, apply each to the result of the part before it.
- Where the number used differs from the number the user stated, say which was used.

### Judging a question before adopting it

Assess a new or changed question for clarity, whether it can be answered, whether it collects
something a later artifact can use, and whether it repeats an existing question.

Where a question falls short:

1. State what is wrong with it.
2. Offer at least one improved alternative.
3. Let the user take an alternative, supply their own, or keep theirs unchanged.

This skill advises and MUST NOT refuse a question the user still wants after step 2. A skill that
overrules its user gets bypassed, and the file is edited by hand instead.

Where a question repeats an existing one, name the existing question rather than reporting a
duplicate in the abstract.

## Verification

- Run `.highway/tools/validate-library.sh .highway/library/templates/requirements-inquiry.md` and
  confirm exit 0.
- Confirm the numbers run from 1 to the question count with no gap and no duplicate.
- Confirm no two questions carry identical text.
- Confirm an unchanged question set rewrites to an identical file.
- Confirm the report names the resulting numbering.

## Error Handling

- The intended action is not decidable: abort, ask which action is meant, and write nothing.
- The question meant is not decidable: abort, naming every candidate question.
- No question matches the description: abort and say so. Do not add one instead.
- A move could change a question's section: abort, naming both readings.
- The whole questionnaire is being replaced: abort until the user confirms the loss.
- A question is being removed: abort until the user confirms, naming it by its text.
- Frontmatter, Purpose, or Verification fails its check: repair, then retry the write at most 1 time.
- The file still fails after repair: abort, naming what could not be repaired.
- The file is absent: abort and offer to create it with the questions this skill ships with.

A replacement confirmation states how many questions are lost and that they are absent from the
new set. "Are you sure?" is not enough, because the user cannot decide from it.

Repair MUST NOT change a question's text, a section's name, or the order of either.

A repaired file is rewritten without reporting a rule identifier. Those parts are not written by
the user, so an identifier names nothing they can act on.

This departs from the pattern in `highway-help`, which aborts and prints an error. The reason is
that a platform user managing questions does not own the frontmatter or the two required sections,
so a rule identifier tells them nothing they can use. Loud about their content, quiet about the
framework's.

## Example

Add a question and see where it lands:

`/highway-inquiry add a question about how long backups are retained`

```text
Added as question 30, in Operations.

  30. How long are backups retained, and who verifies they can be restored?

Numbering is unchanged for questions 1 to 29.
```
