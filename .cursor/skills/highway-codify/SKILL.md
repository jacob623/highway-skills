---
name: highway-codify
description: "Manages one functional artifact for one accepted implementation."
usage: "Invoke as /highway-codify with one implementation name."
compatibility: all
metadata:
  version: 7.0.0
---

# highway-codify

## Purpose

Suggests actions worth automating for one accepted implementation, checks the chosen action against the organization's coding standards and current vendor documentation, writes the task-by-task proposal the person accepts, and codes it from a task list that follows those standards.

## When to use

- The person invokes `/highway-codify` with an implementation title.
- The person invokes `/highway-codify` without an implementation title.
- The person invokes `/highway-codify catalog`, or asks to show the code catalog, to see recent automations and discuss one.

## When not to use

Do not run the automation.
Do not change the implementation, its architecture, its decision, the request, the assessment finding, Controls, or NFRs.
Do not change `library/coding-standards/codify-platforms.md`. `/highway-codify-config` changes it.
Do not create a skill for a particular means.
Do not put lifecycle activities on the implementation record.
Do not create, edit, or remove a coding standard or a row of `library/coding-standards/coding-standards.md`. `/highway-codify-config` changes them.
Do not report Status, Summary, Next Action, Blocking Reason, Missing, Complete, or Blocked.

## Inputs

- An implementation title, a description, or an implementation id, and one optional action, when the person supplies them.
- `implementations/implementations.md` and the accepted implementation records.
- `architectures/architectures.md` and the accepted architecture records.
- `code/code.md` and `code/[ID]/codify-tasks.md` when present.
- `library/coding-standards/coding-standards.md` and the standards it names, when present.
- `library/coding-standards/codify-platforms.md` when present.
- The vendor's current public documentation for each product, API, plugin, module, or library a draft proposal names.
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
- The Provider's files in `code/[ID]/executor/`, and each proposal task's own files in `code/[ID]/task-N/`, produced by the task list.
- One `code/[ID]/README.md` with two parts, produced by the last task.
- When every task is done, a completion message that names the files path `code/[ID]/` and the README path `code/[ID]/README.md`. When a task could not be finished, a close that names the automation, the task list, and that task. Both say the automation was not run.
- A read-only code catalog view after `/highway-codify catalog`.
- No automation when the implementation is missing, not accepted, the proposal is declined, or a write fails.

## Procedure

Emit only the active template. `catalog` runs alone. Otherwise follow this order: `choose` when no implementation is named; `suggest` when no action is named; then `start`, `standards`, `align`, `propose`, `identifier`, `title` when needed, `write`, `code`, and `close`. Follow `.highway/governance/experience-standard.md` for attribution and acceptance wording. A current implementation is an accepted row in `implementations/implementations.md`. A removed row does not match and does not block a new automation.

### Entry

1. When `.highway/` cannot be found, stop. Say the project root cannot be located. Write nothing.
2. When the invocation is the word `configure`, or asks to change platforms or coding standards, say: To configure platforms and coding standards, run /highway-codify-config. Write nothing.
3. When the invocation is the word `catalog`, or asks to show the code catalog, go to `catalog`. Do not resume a task list or select an implementation.
4. Read the invocation for an implementation title, a description, an implementation id, and one optional action.
5. When the invocation names an automation in `code/code.md` by title or `CDY` id and its task list has an open task, go to `code` at the first open task.
6. When an implementation id matches one accepted implementation, select it and show its title.
7. When an exact title matches one accepted implementation, select it. Compare without regard to case.
8. After a selection, go to `start` when the invocation named one action. Otherwise go to `suggest`.
9. When a description is present, go to `choose` and suggest at most five matches.
10. When nothing is named and one to five accepted implementations exist, go to `choose` and list each one.
11. When nothing is named and more than five accepted implementations exist, go to `choose` and list none.
12. When no accepted implementation exists, say so. Write nothing.

### catalog

Read the accepted rows of `code/code.md`. Rows are in acceptance order, so the last rows are the most recent. Take the last five accepted rows. Emit one numbered line per row, starting at 1, newest first. Read the implementation title from `implementations/implementations.md` and the progress from `code/[ID]/codify-tasks.md`. Do not use an id as the label. Do not list or count a removed row.

**1. [Automation title]:** [Implementation title]. [Task [T###] is next. Or, when no task is open: Every task is done.]

When more than five accepted rows exist, add `[N] more automations are not shown.`, or `1 more automation is not shown.` when one is not shown.

**Which automation would you like to discuss?** [When some are not shown: You can name or describe any automation.]

When no accepted row exists, say `No automation has been created yet.` Ask nothing.

- A listed number, or an accepted title compared without regard to case, shown or not: select that automation.
- A description that matches one accepted automation: select it.
- A description that matches several: list those matches the same way, newest first, at most five. Ask again.
- A description that matches none: say no automation matches. Ask again.
- `decline`: stop. Write nothing.

A selection emits:

**[Automation title]**

- **Files:** `code/[ID]/`
- **Setup and Usage Instructions:** `code/[ID]/README.md` [Or, when the README task is open: The instructions are not written yet.]

**What would you like to know about it?**

Write nothing. Do not enter `choose`, `suggest`, `start`, or `code`. Do not resume a task list.

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

On `propose`, "looks good" is `accept`.

### suggest

Read the selected implementation record. An instance is running when Context or Implementation Summary contains `instance is running` or `instances are running`, compared without regard to case.

Each suggestion comes from one realized capability. A capability title containing `establish`, compared without regard to case, is establishing. Every other title runs, changes, or recovers. When no instance is running, establishing comes first. When an instance is running, the other kind comes first. Within a kind, keep Realized Capabilities order. When the leading kind has no title, put `Establish [implementation title]` or `Run [implementation title]` first, drawn from the Implementation Summary. Keep at most five. Drop items from the end.

Write each title as the action the automation will take. It starts with a verb and names its target. An establishing title starts with `Establish`. The summary is one sentence that expands on that action, grounded in the capability's Realized By and the first sentence of its evidence. Do not use an id as a label. Write nothing.

The name is the `Choice:` of the record's one Technology Choice. When the record has none or several, the name is the implementation title.

**Based on the current state of [Name], automating these tasks may be worth visiting:**

1. **[Action title]:**

   [One sentence that expands on the action.]

**Would you like to explore any of these options?**

If you have another idea, provide a brief description and we'll work through it together.

When the list is empty, say no suggestion is grounded in this implementation. Then emit the last line above.

- `select`: a listed number, title, or summary selects that suggestion. The person's own idea selects that automation, even when they also name a listed item. Its title is the person's action, starting with a verb, and its summary is one sentence that expands on it. When the reply names two actions, keep one and say the other waits for another run. Go to `start`.
- A number that is not on the list: say so. Re-emit this list. Write nothing. Stay on `suggest`.
- `unknown`: re-emit this list. Stay on `suggest`.
- `question`: answer, then re-emit this list. Stay on `suggest`.
- `decline`: stop. Write nothing.

### start

Read the selected implementation record and the accepted architecture it names. When that architecture is missing or not accepted, say before the proposal that no accepted architecture describes this automation.

The title and summary are the ones selected on `suggest`. When the invocation or the accepted request named one action, the title is that action and the summary is one sentence that expands on it.

Draft the proposal. Emit nothing except the Provider lines below.

- Description: what this one automation does, for whom, and what it returns.
- At least one acceptance criterion.
- The Provider: the one platform that executes this automation. Every task names that same Provider. The implementation being automated is a target, not the Provider.
- The tasks, in order. Each task is one action against one platform, object, or API, and its action starts with a verb. A step with two targets is two tasks.
- Scope says what the task does. Provider is the Provider. Method says how, naming the plugins, modules, libraries, MCP servers, or APIs it uses. Assumptions list what the task relies on that is not an earlier task, such as network access, an access level, an authentication method, or a credential source, or `None`.

Read `library/coding-standards/codify-platforms.md` when present. Its When to use and When not to use cells hold entries separated by `; `. The Provider is the platform the person named. Otherwise it is the earliest row whose When to use fits this action and whose When not to use does not. A row with both cells blank is not chosen by fit. Otherwise it is this implementation, when it has a row. Otherwise it is the first row. When the catalog has no rows and the person named none, leave the Provider unset.

When the named platform has no row, emit before the proposal:

[Platform] is not included as a platform that can start automation. To add it, run /highway-codify-config.

When the Provider is unset, emit before the proposal:

A platform that can start automation is needed. Run /highway-codify-config.

Go to `standards`.

### standards

Read `library/coding-standards/coding-standards.md` when present. Its When to use, When not to use, and Inherits From cells hold entries separated by `; `. A row whose standard file is absent is unavailable.

For each task, propose an ordered list of Standard Titles:

1. Take each available row whose File Patterns match a file the task's method names, or whose Technology names the method or the Provider, and whose When to use fits the task.
2. Drop a row whose When not to use matches the task.
3. Put a standard before every standard it inherits from, and a platform standard before the language standards it builds on.
4. Add each inherited standard once, after the standard that inherits it. Stop at a title already listed, so a cycle adds nothing twice.

A task with no row says `No coding standard applies.` An earlier standard wins a disagreement with a later one. The person can add, remove, or reorder the list on `propose`.

Go to `align`.

### align

Check the draft before the person sees it: coding standards first, then current vendor documentation. Write nothing. Save no check result.

For each task, read every standard on its Standards list, in order. When two disagree, the earlier one wins. Correct the method, library, module, or pattern so the draft fits the standard's provider boundaries, accepted libraries or modules, and required patterns. Keep the action. Do not replace the Provider.

Then, for each product, API, plugin, module, or library the corrected draft names, read the vendor's current public documentation, product pages, or release notes. Send only that name and the vendor name. When the vendor says it is deprecated, retired, or no longer offered, correct the draft and cite the source. When vendor pages conflict, correct the draft and cite both. A blog, forum, or comparison, no source, or a check that cannot be completed is inconclusive. It changes nothing and is not confirmation.

Before the proposal, emit one line for each result that applies.

- [Standard title] applies to [Provider or task action]. [What changed.]
- No coding standard applies to this automation.
- A standard named by the catalog was not found at [path].
- [Vendor] says [name] is no longer offered. [What changed.] Source: [source].
- [Name] could not be confirmed from [vendor]'s documentation.

When no correction keeps the action, emit `[Standard title] cannot be met for **[Action title]**.` Do not show the proposal. Return to `suggest`. When the invocation named the action, ask for a different action.

Do not run `align` when continuing an automation that already has a task list. Otherwise go to `propose`.

### propose

The diagram is one logical flow that starts at the Provider. Each task adds one arrow from the Provider, labeled with its action, to a new node for its target, in task order. No arrow leaves a target. The Provider is not a task. Every target has its own node. Arrow labels and task actions are the same text.

**Here is a proposed starting point for your automation:**

**Title:** [Selected title.]

**Summary:** [Selected summary.]

**Description:** [What this one automation does, for whom, and what it returns.]

**Acceptance criteria:**

- [One observable result of this automation.]

**Diagram:**

```flowchart
flowchart TB
  P["[Provider]"] -->|[First action]| T1["[First target]"]
  P -->|[Next action]| T2["[Next target]"]
```

**Tasks:**

1. **[First action]:**
   - **Scope:** [What the task does.]
   - **Provider:** [The platform executing this automation.]
   - **Method:** [How it is done.]
   - **Standards:**
     1. [Standard Title. Or, when none applies: No coding standard applies.]
   - **Assumptions:**
     - [What it relies on that is not an earlier task, or None.]

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: emit one consequence sentence. An edit that names a different Provider sets it on every task and in the diagram, then goes to `standards`. An edit that changes a method goes to `standards`, then `align`, for that task. An edit that adds, removes, or reorders a task's Standards changes only that list, then goes to `align` for that task. A title not in the coding standards catalog is left out, and the rest of the list is kept. Say: [Title] is not a listed coding standard. To add it, run /highway-codify-config. Re-emit this block with the diagram and tasks still matching. A second action is removed. Say it waits for another run. The person can switch to another accepted architecture by title. An architecture that is not accepted is not added. A preparation-only request stays one self-service action. Removing the last task or the last acceptance criterion says at least one is needed. Stay on `propose`.
- `accept`: go to `identifier` when the proposal has one action, a Provider, at least one task, at least one acceptance criterion, and an accepted architecture. Otherwise stay on `propose`.
- `unknown`: re-emit this block. Stay on `propose`.
- `question`: answer, then re-emit this block. Stay on `propose`.
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

Write `code/[ID]/codify.md`, `code/[ID]/codify-tasks.md`, and `code/code.md` together. Write none of them until all are valid. A failed write leaves every existing automation byte unchanged and leaves no partial folder. Say what failed in terms the person can act on. Stay on `write`. Do not write the README or any executor or task file here.

The record follows `.highway/library/templates/output/codify-record.md`.

- `id` is the derived `CDY` id.
- `implementation` is the accepted implementation id.
- `architecture` is the accepted architecture this automation follows.
- `status` is `accepted`.
- The title is the one action.
- Summary, Description, Acceptance Criteria, Diagram, and Tasks are the accepted proposal text, in that order.

The task list follows `.highway/library/templates/output/codify-tasks.md`.

- The Provider's files come first, tagged `[Executor]`. They are written once.
- A proposal task adds files, tagged `[Task N]`, only when its method needs an artifact of its own. A task carried entirely by the Provider adds none. A task never gets another task's file. Lines follow proposal task order.
- Each line produces one file and names the Standard Paths of the accepted Standards list, in order, or says `Standards: No coding standard applies.` A `[Task N]` line uses task N's list. An `[Executor]` line uses the list of the first task with a standard whose File Patterns match the file.
- When the first standard on a line says `Tests: required`, add one test task directly after it, naming the same standards. Add no other test task.
- The README task is last.

The catalog follows `.highway/library/templates/output/codify-catalog.md`. The catalog path is `code/code.md`.

- The index columns are Automation ID, Implementation ID, Automation Title, Automation Path, and Status.
- Automation Path is `code/<id>/codify.md`. Status is `accepted`.
- Keep rows in acceptance order. Append the new row as the last row. A row whose status changes keeps its position.
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

1. Read every standard the task names, in order.
2. Write the task's file so it follows every one of them. When two disagree, the earlier one wins. The accepted proposal, architecture, and implementation decide what is built. The standards decide how it is written.
3. Mark the task `[X]`.
4. Go to the next open task.

The Provider's files go in `executor/`. A proposal task's own files go in `task-N/`, where N is its task number. Write no other subfolder. Do not run any file.

The README task writes two parts, in this order. Head the first part `## Setup Instructions` and the second part `## User Guide`. Setup Instructions says what is put in place, where it goes, and how to enable it, including the preparation this automation needs. User Guide says how a non-technical person starts this one automation, what they provide, and what they receive, using the interface of the Provider. User Guide does not ask that person to edit the generated files or read the implementation record.

When a task cannot be finished, stop at that task. Leave it and every later task open. Start no later task. Keep the files that finished tasks wrote. Go to `close`.

When every task is done, go to `close`.

### close

First emit the coding standards notices that apply, then one close.

[No coding standards catalog was found. A standard named by the catalog was not found at [path]. Include only the sentences that apply.]

When every task is done, emit this message exactly, as rendered markdown, with the automation id in place of `[ID]`:

```markdown
### The codify stage is complete.

This code is now part of your Highway knowledge base. Like your architectures, implementations, and other accepted knowledge, it remains available for future context. Highway can help you understand, configure, extend, troubleshoot, and use any code it has helped you create.

The automation was not run.

**The files can be found here:**

`code/[ID]/`

If you'd like to review the files together, just say so.

**Setup and Usage Instructions** can be found here:

`code/[ID]/README.md`

If you'd like to review the instructions together, just say so.

**Questions?**

If you have questions in the future, just ask highway to show your code catalog. You can always discuss any of the code highway helps you build.

**Where would you like to go next?**

Run /highway-help to explore what Highway can help you do.
```

When a task could not be finished, emit:

**Automation recorded**

- **Automation record:** `code/[ID]/codify.md`
- **Task list:** `code/[ID]/codify-tasks.md`
- **Title:** [Title]
- **Implementation:** [Implementation title]

Task [T###] could not be finished because [reason]. The next run starts there.

The automation was not run.

## Verification

- An exact title selects that accepted implementation, and the title is what the person sees.
- A supplied id selects the matching accepted implementation, and the title is shown afterward.
- A list shows a title and the implementation summary. It does not use an id as the label.
- One to five accepted implementations are listed when the person names nothing. More than five lists none until the person gives a title or a description, then at most five.
- No accepted implementation writes nothing.
- With no named action, the suggestion list appears once before any proposal. It opens with the one Technology Choice, or the implementation title, and says automating these tasks may be worth visiting.
- Each suggestion title is an action that starts with a verb, and its one summary sentence expands on it. The list holds at most five items, uses no id as a label, and ends with the invitation to describe another idea.
- Suggestions of the kind that fits whether an instance is running come first, then the other kind, each in Realized Capabilities order.
- A named action skips the suggestion list and opens the proposal for that action.
- Before any proposal, coding standards are checked first and vendor documentation second. Corrections and inconclusive results are named before the proposal and are not saved. The checks keep the selected action.
- A standard that cannot be met for the selected action shows no proposal and returns to suggestions.
- The proposal shows Title, Summary, Description, Acceptance criteria, Diagram, and Tasks, in that order. It shows no components, current state, separate action, day, or means.
- The diagram is one logical flow, top to bottom, from the Provider. Each arrow leaves the Provider, is one task's action, starts with a verb, and points to that task's target, in task order. No arrow leaves a target.
- Every task names the same Provider, the platform executing the automation. The implementation being automated is a target. A Shopify proposal can use Cursor when Cursor is included, even though the Shopify records do not name it.
- A named platform with no catalog row stays the Provider and the proposal says `/highway-codify-config` can add it. With no row and no named platform, the proposal says a platform is needed and accept stays on `propose`.
- With no named platform, the Provider is the earliest row whose When to use fits the action and whose When not to use does not. A row with blank guidance is not chosen by fit. Otherwise this implementation's row, then the first row.
- Each task shows Standards as an ordered list, or `No coding standard applies.` A standard whose When not to use matches is dropped. A standard comes before the standards it inherits from, and each inherited standard appears once.
- A Standards edit re-emits the proposal with one consequence sentence. A title not in the catalog is left out and points to `/highway-codify-config`.
- `align` corrects the method, library, module, or pattern against every standard on the task's list and keeps the Provider.
- An invocation of the word `configure` points to `/highway-codify-config` and writes nothing.
- `/highway-codify catalog` lists at most five accepted automations, newest first, with each implementation title and progress, says how many more exist, and writes nothing. A selection shows the files path and the README path.
- A new row in `code/code.md` is appended as the last row.
- The README is headed `## Setup Instructions`, then `## User Guide`.
- A finished run closes with the completion message, both paths, and the sentence that the automation was not run. A stopped run names the stopped task and does not say the codify stage is complete.
- Each task is one action against one target and shows Scope, Provider, Method, Standards, and Assumptions.
- A second action waits for another run. Declining writes nothing. Accepting is the only confirmation.
- Acceptance writes `codify.md`, `codify-tasks.md`, and the catalog row together, before any executor or task file or the README.
- The task list starts with the Provider's files, adds files for a proposal task only when it has its own artifact, and ends with the README. Each line names its Standard Paths in order or says `No coding standard applies.` A test task follows a file only when its first standard says `Tests: required`.
- Coding starts with no question after acceptance. Every standard a task names is read before its file is written, the earlier one winning a disagreement, and each task is marked `[X]` before the next begins.
- A task that cannot be finished stops the run with that task and every later task open. The next run starts at the first open task, redoes no finished task, and runs no check.
- Codify creates, edits, and removes no coding standard and no row of the coding standards catalog.
- Acceptance and coding run the automation zero times and leave the implementation, architecture, decision, request, and finding unchanged.
- Each id is `CDY` plus eight hex digits derived from the title.
- A taken id names the conflicting titles, says a title change is appropriate, and shows a new title. The write waits until the person accepts that title.
- That message does not mention identifiers, hex, sampling, or the catalog.
- A failed write leaves no partial folder and leaves existing catalog bytes unchanged.

## Error Handling

- A missing `.highway/` root stops the skill and writes nothing.
- A missing record, catalog, or task list template stops the skill, names the template path, and writes nothing.
- A missing coding standards catalog leaves every task with `No coding standard applies.` The close says no catalog was found.
- A standard that cannot be met for the selected action returns to `suggest` and writes nothing.
- A task that cannot be finished stops coding at that task, leaves it open, and keeps the files finished tasks wrote.
- An implementation that is not accepted stops the skill and writes nothing.
- No accepted architecture for this automation keeps the proposal open and says so.
- A failed write leaves no partial folder and leaves existing catalog bytes unchanged.
- Declining a proposal writes nothing.
- Removing the last task or the last acceptance criterion keeps the proposal open and writes nothing.

## Example

Illustrative.

`/highway-codify Restart the worker`
