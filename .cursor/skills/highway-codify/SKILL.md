---
name: highway-codify
description: "Manages one functional artifact for one accepted implementation."
usage: "Invoke as /highway-codify with one implementation name."
compatibility: all
metadata:
  version: 3.0.0
---

# highway-codify

## Purpose

Suggests self-service automations for one accepted implementation, writes the one automation the person accepts, and codes it from a task list that follows the organization's coding standards.

## When to use

- The person invokes `/highway-codify` with an implementation title.
- The person invokes `/highway-codify` without an implementation title.

## When not to use

Do not run the automation.
Do not change the implementation, its architecture, its decision, the request, the assessment finding, Controls, or NFRs.
Do not invent a means that no accepted architecture describes.
Do not create a skill for a particular means.
Do not put lifecycle activities on the implementation record.
Do not create, edit, or remove a coding standard or a row of `library/coding-standards/coding-standards.md`.
Do not report Status, Summary, Next Action, Blocking Reason, Missing, Complete, or Blocked.

## Inputs

- An implementation title, a description, or an implementation id, and one optional action, when the person supplies them.
- `implementations/implementations.md` and the accepted implementation records.
- `architectures/architectures.md` and the accepted architecture records.
- `code/code.md` and `code/[ID]/codify-tasks.md` when present.
- `library/coding-standards/coding-standards.md` and the standards it names, when present.
- `.highway/library/templates/output/codify-record.md`.
- `.highway/library/templates/output/codify-catalog.md`.
- `.highway/library/templates/output/codify-tasks.md`.
- `.highway/governance/experience-standard.md`.
- A project root containing `.highway/`.

## Outputs

The complete structure is `.highway/library/templates/output/codify-record.md`, `.highway/library/templates/output/codify-catalog.md`, and `.highway/library/templates/output/codify-tasks.md`.

- One saved proposal at `code/[ID]/codify.md` after the person accepts the proposal.
- One task list at `code/[ID]/codify-tasks.md` written with that proposal.
- An updated `code/code.md` written with that proposal.
- One subfolder for each component the accepted proposal names, holding the files its tasks produce.
- One `code/[ID]/README.md` with two parts, produced by the last task.
- A closing message that names the automation and the task list, says whether every task is done, and says it was not run.
- No automation when the implementation is missing, not accepted, the proposal is declined, or a write fails.

## Procedure

Emit only the active template. Follow this order: `choose` when no implementation is named; `suggest` when no action is named; then `start`, `identifier`, `title` when needed, `write`, `code`, and `close`. Follow `.highway/governance/experience-standard.md` for attribution and acceptance wording. A current implementation is an accepted row in `implementations/implementations.md`. A removed row does not match and does not block a new automation.

### Entry

1. When `.highway/` cannot be found, stop. Say the project root cannot be located. Write nothing.
2. Read the invocation for an implementation title, a description, an implementation id, and one optional action.
3. When the invocation names an automation in `code/code.md` by title or `CDY` id and its task list has an open task, go to `code` at the first open task.
4. When an implementation id matches one accepted implementation, select it and show its title.
5. When an exact title matches one accepted implementation, select it. Compare without regard to case.
6. After a selection, go to `start` when the invocation named one action. Otherwise go to `suggest`.
7. When a description is present, go to `choose` and suggest at most five matches.
8. When nothing is named and one to five accepted implementations exist, go to `choose` and list each one.
9. When nothing is named and more than five accepted implementations exist, go to `choose` and list none.
10. When no accepted implementation exists, say so. Write nothing.

### choose

Read `implementations/implementations.md`. Open an accepted implementation record to read its summary and its realized capability titles. Do not open a removed row. Do not use an id as the label of a choice.

When the person named nothing and one to five accepted implementations exist, emit one numbered line per accepted implementation, starting at 1, in catalog order.

**1. [Implementation title]:** [Implementation summary]

**Which implementation should this automation serve?**

When the person named nothing and more than five accepted implementations exist, list none. Say they can give a title or a description.

When a description is present, keep at most five. Put exact titles first, then a realized capability title that appears in full in the person's words, then a title that appears in full in those words or words that appear in full in the summary. Within each group, keep catalog order. Compare without regard to case.

A number, a title, or a description selects one. Show the title. Go to `start` when the invocation named one action. Otherwise go to `suggest`.

- `unknown`: re-emit this list. Stay on `choose`.
- `decline`: stop. Write nothing.
- No match: say so. Write nothing. Stay on `choose` only when the person can still name one. When none exist, stop.

### Classify

Classify the latest reply before any other action.

- `select`: names a listed suggestion by number, title, or summary, or names the person's own automation.
- `edit`: adds, removes, corrects, or replaces proposal text.
- `accept`: affirms the proposal and adds no fact.
- `unknown`: the person says they do not know.
- `question`: asks for an explanation.
- `decline`: the person stops or cancels.

On `start`, "looks good" is `accept`.

### suggest

Read the selected implementation record. Use the current state and day that `start` defines. Each suggestion is one realized capability title. Its summary is the first sentence of that capability's evidence, or `None`.

A title containing `establish`, compared without regard to case, is establishing. Every other title runs, changes, or recovers. When no instance is running, establishing comes first. When an instance is running, the other kind comes first. Within a kind, keep Realized Capabilities order. When the leading kind has no title, put `Establish [implementation title]` or `Run [implementation title]` first. Its summary is the first sentence of the Implementation Summary, or `None`. Keep at most five. Drop items from the end. Do not use an id as a label. Write nothing.

**Based on the current state of this implementation, these may be worth visiting:**

1. **[Title]:**

   [One-sentence summary.]

**Would you like to explore any of these options?**

You can also provide your own.

When the list is empty, say no suggestion is grounded in this implementation and that they can provide their own.

- `select`: a listed number, title, or summary selects that suggestion. The person's own automation selects that automation, even when they also name a listed item. Its title is the person's words, and its summary is one sentence for it. When the reply names two actions, keep one and say the other waits for another run. Go to `start`.
- A number that is not on the list: say so. Re-emit this list. Write nothing. Stay on `suggest`.
- `unknown`: re-emit this list. Stay on `suggest`.
- `question`: answer, then re-emit this list. Stay on `suggest`.
- `decline`: stop. Write nothing.

### start

Read the selected implementation record. An instance is running when Context or Implementation Summary contains `instance is running` or `instances are running`, compared without regard to case. The current state is that sentence, or `None` when neither phrase is present. Day 2 when an instance is running. Day 1 when it is not.

The title and summary are the ones selected on `suggest`. When the invocation or the accepted request named one action, the title is that action and the summary is one sentence for it. The action is that same automation.

The means is the accepted architecture named by the implementation. Show that architecture's title. When that architecture is missing or not accepted, say that no accepted architecture describes a means. Do not name a tool the architecture does not describe.

The diagram has one node per component, in the order of Components. Each arrow goes to the next component and is labeled with the action. When components are `None`, the diagram has one node, the action title, and no arrow. State at least one acceptance criterion.

**Here is a proposed starting point for your automation:**

**Title:** [Selected title.]

**Summary:** [Selected summary.]

**Description:** [What this one automation does, for whom, and what it returns.]

**Diagram:**

```flowchart
flowchart LR
  C1["[First component]"] -->|[Action]| C2["[Next component]"]
```

**Acceptance criteria:**

- [One observable result of this automation.]

**Components:**

- **[Component]:** Responsibility: [Its part of this automation.] Boundary: [Where that part starts and stops.]

**Current state:** [Sentence, or None.]

**Action:** [One action.]

**Day:** [Day 1 or Day 2.]

**Means:** [Architecture title.]

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: emit one consequence sentence. Re-emit this block with the edit applied. A second action is removed. Say it waits for another run. A means that is not an accepted architecture is not added. The person can switch the means to another accepted architecture by title. A preparation-only request stays one self-service action. Removing the last acceptance criterion says at least one is needed. Stay on `start`.
- `accept`: when the proposal still contains two actions, keep one and stay on `start`. When no acceptance criterion remains, stay on `start`. When no accepted architecture is the means, stay on `start`. Otherwise go to `identifier`.
- `unknown`: re-emit this block. Stay on `start`.
- `question`: answer, then re-emit this block. Stay on `start`.
- `decline`: stop. Write nothing.

### identifier

The automation title is the one action.

1. Lowercase the title. Remove hyphens and apostrophes. Split the rest into words.
2. Take eight letters: the first two of word 1, the first two of word 2, the first two of word 3, and the last two of the last word. When the title has only two words, the third sample is the first two of the last word.
3. When a word is shorter than two letters, continue into the next word. A one-word title repeats until there are eight letters.
4. Map each letter. Digits stay as they are.

a 0, b 1, c 2, d 3, e 4, f 5, g 6, h 7, i 8, j 9, k a, l b, m c, n d, o e, p f, q 0, r 1, s 2, t 3, u 4, v 5, w 6, x 7, y 8, z 9.

5. The id is `CDY` plus those eight hex digits.

Compare that id with `code/code.md`, including removed rows.

- The same title already has that id: use the existing record. Do not write a second one. Go to `code` at the first open task, or to `close` when every task is done.
- The id is taken for a different title: go to `title`.
- The id is free: go to `write`.

### title

Name each conflicting title. Say that a title change is appropriate. Then show the new title for acceptance.

The existing Automation Title, **[Existing title]** and this new Automation Title, **[this title]**, are too similar. A title change is appropriate. I would recommend:

**[New title]**

**What would you add, correct, or remove?**

If this is accurate, just say so.

The new title is a small change the person can recognize. Its derived id must be free. Do not mention identifiers, hex, sampling, or the catalog.

- `accept`: replace the held title. Return to `identifier`.
- `edit`: use the person's title. Return to `identifier`.
- `question`: answer in one sentence. Re-emit this message.
- `unknown`: re-emit this message.

Do not write until the id is free or the existing record is reused.

### write

Write `code/[ID]/codify.md`, `code/[ID]/codify-tasks.md`, and `code/code.md` together. Write none of them until all are valid. A failed write leaves every existing automation byte unchanged and leaves no partial folder. Say what failed in terms the person can act on. Stay on `write`. Do not write the README or any component file here.

The record follows `.highway/library/templates/output/codify-record.md`.

- `id` is the derived `CDY` id.
- `implementation` is the accepted implementation id.
- `architecture` is the accepted architecture used as the means.
- `status` is `accepted`.
- The title is the one action.
- Summary, Description, Diagram, and Acceptance Criteria are the accepted proposal text.
- Components state Responsibility and Boundary for each component, or `None`.
- Current state is the sentence used for the day, or `None`.
- Day is `Day 1` or `Day 2`.
- Means is the architecture title.

The task list follows `.highway/library/templates/output/codify-tasks.md`. Read `library/coding-standards/coding-standards.md` when present.

- Each task produces one file for one component the accepted proposal names, or the README.
- Every named component has at least one task. No task names another component.
- A file uses the first catalog row whose File Patterns match its name. A row whose standard file is absent is unavailable. A second row for the same technology is a duplicate, and the first row applies.
- A file with an available standard names that Standard Path. Any other file says `Standard: No coding standard applies.`
- When that standard's Tests section says `Tests: required`, add one test task directly after the file's task, naming the same standard. Add no other test task.
- The README task is last.

The catalog follows `.highway/library/templates/output/codify-catalog.md`. The catalog path is `code/code.md`.

- The index columns are Automation ID, Implementation ID, Automation Title, Automation Path, and Status.
- Automation Path is `code/<id>/codify.md`. Status is `accepted`.
- Order the index by Automation ID.
- Do not allocate from `Next ID`.
- The first catalog version is `1.0.0`.
- Adding an automation increments the minor version.
- More than one row may name the same Implementation ID.
- A removed row keeps its id and has no folder.
- Emit no timestamp, random value, or environment value.
- Do not change the implementation, its architecture, its decision, the request, the assessment finding, Controls, or NFRs.

On success, go to `code` without asking a question.

### code

Open `code/[ID]/codify-tasks.md`. Start at the first open task. For each open task, in list order:

1. Read the standard the task names, when it names one.
2. Write the task's file so it follows that standard. The accepted architecture and implementation decide what is built. The standard decides how it is written.
3. Mark the task `[X]`.
4. Go to the next open task.

Component files go in that component's subfolder. Lowercase the component name and write spaces as hyphens. Write no subfolder the proposal does not name. Do not run any file.

The README task writes two parts, in this order. Head the first part `## Implement` and the second part `## Use`. Implement says what is put in place, where it goes, and how to enable it, including the preparation this automation needs. Use says how a non-technical person starts this one automation, what they provide, and what they receive, using the interface of the accepted means. Use does not ask that person to edit the generated files or read the implementation record.

When a task cannot be finished, stop at that task. Leave it and every later task open. Start no later task. Keep the files that finished tasks wrote. Go to `close`.

When every task is done, go to `close`.

### close

**Automation recorded**

- **Automation record:** `code/[ID]/codify.md`
- **Task list:** `code/[ID]/codify-tasks.md`
- **Title:** [Title]
- **Implementation:** [Implementation title]

[Every task is done. Or: Task [T###] could not be finished because [reason]. The next run starts there.]

[No coding standards catalog was found. A standard named by the catalog was not found at [path]. [Technology] has more than one catalog row, and the first row was used. Include only the sentences that apply.]

The automation was not run.

## Verification

- An exact title selects that accepted implementation, and the title is what the person sees.
- A supplied id selects the matching accepted implementation, and the title is shown afterward.
- A list shows a title and the implementation summary. It does not use an id as the label.
- One to five accepted implementations are listed when the person names nothing. More than five lists none until the person gives a title or a description, then at most five.
- No accepted implementation writes nothing.
- With no named action, the suggestion list appears once before any proposal. It holds at most five items, each a title and one summary sentence, and uses no id as a label.
- Suggestions of the kind that fits the current state come first, then the other kind, each in Realized Capabilities order.
- A named action skips the suggestion list and opens the proposal for that action.
- A listed number, title, or summary, or the person's own automation, selects one automation. A number that is not on the list asks again.
- The proposal keeps the selected title and summary and states a description, one flowchart, at least one acceptance criterion, each component's Responsibility and Boundary, the current state, one action, Day 1 or Day 2, and one architecture title.
- An instance is running only when Context or Implementation Summary contains `instance is running` or `instances are running`.
- A second action waits for another run. Declining writes nothing. Accepting is the only confirmation.
- The saved record contains the summary, description, diagram, acceptance criteria, and component responsibilities and boundaries.
- Acceptance writes `codify.md`, `codify-tasks.md`, and the catalog row together, before any component file or the README.
- Each task produces one file and names a Standard Path or says `No coding standard applies.` A test task follows a file only when its standard says `Tests: required`. The README task is last.
- Coding starts with no question after acceptance. Each task's standard is read before its file is written, and each task is marked `[X]` before the next begins.
- A task that cannot be finished stops the run with that task and every later task open. The next run starts at the first open task and redoes no finished task.
- After coding, the folder contains `codify.md`, `codify-tasks.md`, `README.md`, and one subfolder per named component.
- Codify creates, edits, and removes no coding standard and no row of the coding standards catalog.
- Acceptance and coding run the automation zero times and leave the implementation, architecture, decision, request, and finding unchanged.
- Each id is `CDY` plus eight hex digits derived from the title.
- A taken id names the conflicting titles, says a title change is appropriate, and shows a new title. The write waits until the person accepts that title.
- That message does not mention identifiers, hex, sampling, or the catalog.
- A failed write leaves no partial folder and leaves existing catalog bytes unchanged.

## Error Handling

- A missing `.highway/` root stops the skill and writes nothing.
- A missing record, catalog, or task list template stops the skill, names the template path, and writes nothing.
- A missing coding standards catalog leaves every task with `Standard: No coding standard applies.` The close says no catalog was found.
- A task that cannot be finished stops coding at that task, leaves it open, and keeps the files finished tasks wrote.
- An implementation that is not accepted stops the skill and writes nothing.
- No accepted architecture for the means stops the write and says so.
- A failed write leaves no partial folder and leaves existing catalog bytes unchanged.
- Declining a proposal writes nothing.
- Removing the last acceptance criterion keeps the proposal open and writes nothing.

## Example

Illustrative.

`/highway-codify Restart the worker`
