---
name: highway-codify
description: "Manages one functional artifact for one accepted implementation."
usage: "Invoke as /highway-codify with one implementation name."
compatibility: all
metadata:
  version: 14.1.0
---

# highway-codify

## Purpose

Suggests actions worth automating for one accepted implementation, checks the chosen action against the organization's coding standards and current vendor documentation, writes the task-by-task proposal the person accepts, and codes it from a task list that follows those standards, writing the product's own code when the implementation names a Language.

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
- `code/code.md` and `code/integrations.md` when present.
- The product's `code/<folder>/.highway/metadata.md` when a proposal joins an existing product.
- The open feature's `plan.md` and `codify-tasks.md` under `code/<folder>/.highway/features/` when present.
- `library/coding-standards/coding-standards.md` and the standards it names, when present.
- `library/governance/controls.md`, `library/governance/nfrs.md`, and the active records they name, when present.
- `library/coding-standards/codify-platforms.md` when present.
- The vendor's current public documentation for each product, API, plugin, module, or library a draft proposal names.
- `.highway/library/templates/output/codify-record.md`.
- `.highway/library/templates/output/codify-catalog.md`.
- `.highway/library/templates/output/codify-plan.md`.
- `.highway/library/templates/output/codify-tasks.md`.
- `.highway/library/templates/output/codify-metadata.md`.
- `.highway/library/templates/output/codify-integrations.md`.
- `.highway/governance/experience-standard.md`.
- A project root containing `.highway/`.

## Outputs

The complete structure is `.highway/library/templates/output/codify-record.md`, `.highway/library/templates/output/codify-catalog.md`, `.highway/library/templates/output/codify-plan.md`, `.highway/library/templates/output/codify-tasks.md`, `.highway/library/templates/output/codify-metadata.md`, and `.highway/library/templates/output/codify-integrations.md`.

- One product folder `code/<folder>/`, with `.highway/metadata.md` written when the product is new. Each accepted feature adds one row to its Features table.
- One saved proposal at `code/<folder>/.highway/features/<number>-<action>/codify.md` after the person accepts the proposal.
- One plan, `plan.md`, beside that proposal, written after it.
- One task list, `codify-tasks.md`, beside that plan, written when the person continues from the plan.
- An updated `code/code.md`, and `code/integrations.md` when the accepted proposal includes a new integration, written with that proposal.
- The files each task list line names, at their relative paths in `code/<folder>/`.
- One `code/<folder>/README.md` with two parts, produced by the last task.
- When every task is done, a completion message that names the files path `code/<folder>/` and the README path `code/<folder>/README.md`. When a task could not be finished, a close that names the automation, the task list, and that task. Both say the automation was not run.
- A read-only code catalog view after `/highway-codify catalog`.
- No automation when the implementation is missing, not accepted, the proposal is declined, or a write fails.

## Procedure

Emit only the active template. `catalog` runs alone. Otherwise follow this order: `choose` when no implementation is named; `record check`; `code project` for a code project, or `rank`, with `codified`, when no action is named; then `suggest`, `draft`, `code tasks` for a code project, `provider`, `standards`, `align`, `govern`, `resume`, `join`, `folder`, `layout`, `propose`, `revise`, `identifier`, `title` when needed, `write`, `index`, `plan`, `check`, `menu`, `review` when chosen, `tasks`, `code`, and `close`. Follow `.highway/governance/experience-standard.md` for attribution and acceptance wording. A current implementation is an accepted row in `implementations/implementations.md`. A removed row does not match and does not block a new automation.

### Entry

1. When `.highway/` cannot be found, stop. Say the project root cannot be located. Write nothing.
2. When the invocation is the word `configure`, or asks to change platforms or coding standards, say: To configure platforms and coding standards, run /highway-codify-config. Write nothing.
3. When the invocation is the word `catalog`, or asks to show the code catalog, go to `catalog`. Do not resume a task list or select an implementation.
4. Read the invocation for an implementation title, a description, an implementation id, and one optional action.
5. When the invocation names a product in `code/code.md` by title, folder, or `CDY` id and its open feature has an open task, go to `code` at the first open task. When that feature has a plan and no task list, go to `menu`.
6. When an implementation id matches one accepted implementation, select it and show its title.
7. When an exact title matches one accepted implementation, select it. Compare without regard to case.
8. After a selection, go to `record check`.
9. When a description is present, go to `choose` and suggest at most five matches.
10. When nothing is named and one to five accepted implementations exist, go to `choose` and list each one.
11. When nothing is named and more than five accepted implementations exist, go to `choose` and list none.
12. When no accepted implementation exists, say so. Write nothing.

### catalog

Read the accepted rows of `code/code.md`. Rows are in acceptance order, so the last rows are the most recent. Take the last five accepted rows. Emit one numbered line per row, starting at 1, newest first. Read each implementation title from `implementations/implementations.md` and the progress from the `codify-tasks.md` of the open feature its Features cell names. Do not use an id as the label. Do not list or count a removed row.

**1. [Product title]:** [Implementation titles]. [Task [T###] is next. Or, when the open feature has no task list: The plan is ready. Or, when no feature is open: Every task is done.]

When more than five accepted rows exist, add `[N] more automations are not shown.`, or `1 more automation is not shown.` when one is not shown.

**Which automation would you like to discuss?** [When some are not shown: You can name or describe any automation.]

When no accepted row exists, say `No automation has been created yet.` Ask nothing.

- A listed number, or an accepted title compared without regard to case, shown or not: select that automation.
- A description that matches one accepted automation: select it.
- A description that matches several: list those matches the same way, newest first, at most five. Ask again.
- A description that matches none: say no automation matches. Ask again.
- `decline`: stop. Write nothing.

A selection emits:

**[Product title]**

- **Files:** `code/<folder>/`
- **Setup and Usage Instructions:** `code/<folder>/README.md` [Or, when the README task is open or no task list exists: The instructions are not written yet.]

**What would you like to know about it?**

Write nothing. Do not enter `choose`, `suggest`, `draft`, or `code`. Do not resume a task list.

### choose

Read `implementations/implementations.md`. Open an accepted implementation record to read its summary and its realized capability titles. Do not open a removed row. Do not use an id as the label of a choice.

When the person named nothing and one to five accepted implementations exist, emit one numbered line per accepted implementation, starting at 1, in catalog order.

**1. [Implementation title]:** [Implementation summary]

**Which implementation should this automation serve?**

When the person named nothing and more than five accepted implementations exist, list none. Say they can give a title or a description.

When a description is present, keep at most five. Put exact titles first, then a realized capability title that appears in full in the person's words, then a title that appears in full in those words or words that appear in full in the summary. Within each group, keep catalog order. Compare without regard to case.

A number, a title, or a description selects one. Show the title. Go to `record check`.

- `unknown`: re-emit this list. Stay on `choose`.
- `decline`: stop. Write nothing.
- No match: say so. Write nothing. Stay on `choose` only when the person can still name one. When none exist, stop.

### record check

[Product Title] is the selected implementation title. Read its record's Execution. Read `library/coding-standards/codify-platforms.md` and `library/coding-standards/coding-standards.md` when present. Write nothing.

1. The record is incomplete when Deployed by or Managed by is `Needed`, empty, or names a platform with no row.
2. The record is incomplete when Language is `Needed`, empty, or names a standard with no row.
3. When `highway-implementation` returned here and the record is still incomplete, stop.
4. When the record is incomplete, emit:

**[Product Title]'s implementation record is missing critical detail required for highway-codify proposals.**

Let's set those details now for [Product Title].

5. Then follow `highway-implementation` for [RI id], with the return step `record check` in `highway-codify`. Ask nothing.
6. When Language names a coding standard, go to `code project`.
7. Otherwise, when an action is selected or the invocation named one, go to `draft`. Otherwise go to `rank`.

A return keeps the selected implementation and any selected action, and reads the record again.

### Classify

Classify the latest reply before any other action.

- `select`: names a listed suggestion by number, title, or summary, or names the person's own automation.
- `edit`: adds, removes, corrects, or replaces proposal text.
- `accept`: affirms the proposal and adds no fact.
- `unknown`: the person says they do not know.
- `question`: asks for an explanation.
- `decline`: the person stops or cancels.

On `revise`, "looks good" is `accept`.
On `review`, a change to the plan is `edit`, and "no", "nothing", or "looks good" is `accept`.

### rank

Read the selected implementation record. An instance is running when Context or Implementation Summary contains `instance is running` or `instances are running`, compared without regard to case.

When no instance is running, the first suggestion is `Establish [implementation title]`, drawn from the Implementation Summary. When an instance is running, do not suggest it. Each other suggestion comes from one realized capability, in Realized Capabilities order. When an instance is running and Realized Capabilities is empty, the only suggestion is `Run [implementation title]`.

Write each title as the action the automation will take. It starts with a verb and names its target. A title from a realized capability does not start with `Establish`. The summary is one sentence that expands on that action, grounded in the capability's Realized By and the first sentence of its evidence. Do not use an id as a label. Write nothing.

Leave out each suggestion `codified` removes, then keep at most five. Drop items from the end. Go to `suggest`.

### codified

Read the accepted rows of `code/code.md` whose Implementations include the selected implementation. Skip removed rows. With no catalog, leave nothing out. Do not open a product folder. Write nothing.

For each suggestion, in order:

1. When a recorded feature's `<action>` is the same words, in the same order, as its title, compared without regard to case or hyphens, leave it out. Do not open that record.
2. Otherwise, when a feature sentence or the product Summary means this suggestion, leave it out.
3. Keep every other suggestion. An integration row does not leave a suggestion out.

This check does not refuse a named action or the person's own idea. Return to the step that named this one.

### code project

The product is a code project when the selected implementation's Language names a coding standard. That standard is the Language standard. Read `code/code.md` when present. Write nothing.

1. An Establish feature is recorded when an accepted row lists this implementation and a Features entry's `<action>` starts with `establish`.
2. With none recorded, the only suggestion is `Establish [implementation title]`, even when an instance is running. Its summary is: Starts the [Language standard] code for [implementation title]. When another action is selected or named, say Establish comes first. Go to `suggest`.
3. With one recorded, go to `draft` when an action is selected or the invocation named one.
4. Otherwise take one suggestion per item, in this order: each Realized Capability, each Realized Interface, each Coverage row marked covered, then each NFR Realization item.
5. Each title is a change to the product code. It starts with a verb and names what it changes. Its summary is one sentence grounded in that item.
6. Follow `codified`. Keep at most five. Drop items from the end. Go to `suggest`.

### suggest

The name is the `Choice:` of the record's one Technology Choice. When the record has none or several, the name is the implementation title.

**Based on the current state of [Name], automating these tasks may be worth visiting:**

1. **[Action title]:**

   [One sentence that expands on the action.]

**Would you like to explore any of these options?**

If you have another idea, provide a brief description and we'll work through it together.

When the list is empty, say no suggestion is grounded in this implementation. When `codified` removed every grounded suggestion, say `Each action grounded in this implementation is already codified.` instead. Then emit the last line above.

- `select`: a listed number, title, or summary selects that suggestion. The person's own idea selects that automation, even when they also name a listed item. Its title is the person's action, starting with a verb, and its summary is one sentence that expands on it. When the reply names two actions, keep one and say the other waits for another run. Go to `draft`.
- A number that is not on the list: say so. Re-emit this list. Write nothing. Stay on `suggest`.
- `unknown`: re-emit this list. Stay on `suggest`.
- `question`: answer, then re-emit this list. Stay on `suggest`.
- `decline`: stop. Write nothing.

### draft

Read the selected implementation record and the accepted architecture it names. When that architecture is missing or not accepted, say before the proposal that no accepted architecture describes this automation.

The title and summary are the ones selected on `suggest`. When the invocation or the accepted request named one action, the title is that action and the summary is one sentence that expands on it.

Draft the proposal. Emit nothing here.

- Description: what this one automation does, for whom, and what it returns.
- At least one acceptance criterion.
- The Executor is chosen in `provider`. A task's Provider is the platform that task uses and may differ from the Executor. Method names how, including a tool such as Helm, Terraform, or CloudFormation. The implementation being automated is a target, not the Executor.
- The tasks, in order. Each task is one action against one platform, object, or API, and its action starts with a verb. A step with two targets is two tasks.
- Scope says what the task does. Provider is the Provider. Method says how, naming the plugins, modules, libraries, MCP servers, or APIs it uses. Assumptions list what the task relies on that is not an earlier task, such as network access, an access level, an authentication method, or a credential source, or `None`.

For a code project, follow `code tasks`.

Go to `provider`.

### code tasks

Follow these steps for a code project. The Language standard is the one `code project` names.

1. Until an Establish feature is recorded, another action waits. Say Establish comes first. Re-emit the `suggest` list.
2. A code task writes or changes the product's source code. Its target is the product. It shows **Language:** [Language standard] in place of **Provider:**.
3. Establish proposes code tasks for the project structure, the build file, the entry point, the configuration, and a health check. It proposes no Realized Capability. The person adds scope on `revise`.
4. When Deployed by's row has Kind `pipeline`, Establish adds tasks that write that pipeline. Each shows **Provider:** [Deployed by].
5. Every other action proposes code tasks that change the product code.
6. A code task's Standards are the Language standard, each standard it inherits, then each standard whose Technology appears on its own in the Technology Choice `Choice:`. A pipeline task's Standards follow `standards`. A standard whose file is absent is left out.
7. The Language standard places the source files. The pipeline's platform standard places only the pipeline files.
8. The diagram starts at the Executor. Each code task's arrow points to the product.
9. A new product's title is the implementation title. After Establish, each action joins the product whose Features hold the Establish feature. No other implementation joins it, and it joins no other product.
10. Setup Instructions say how to build, configure, and run the product. User Guide says how to use its interfaces.
11. The close says `The code was not run.` in place of `The automation was not run.`

Return to the step that named this one.

### provider

Read the selected implementation record's Execution. The action is establishing when its title contains `establish`, compared without regard to case.

1. The Executor is Deployed by when the action is establishing or the product is a code project. Otherwise the Executor is Managed by.
2. When the Executor names a platform with no row, go to `record check`. Do not show the proposal. Write nothing.
3. Do not copy the Executor onto a task's Provider.
4. Do not take this implementation's row or the first catalog row.

Go to `standards`.

### standards

Read `library/coding-standards/coding-standards.md` when present. Its When to use, When not to use, and Inherits From cells hold entries separated by `; `. A row whose standard file is absent is unavailable.

For each task, propose an ordered list of Standard Titles:

1. A row is a candidate when its File Patterns match a file the method names, or its Technology names the method or the Provider, and its standard file is present.
2. Drop a candidate whose When to use is blank. An entry appears on its own when a boundary sits on each side: the start or end of the text, or a character that is not a letter or digit. Drop a candidate when a When to use entry does not appear on its own in the action, the method, or the Provider, or a When not to use entry does.
3. Put a standard before every standard it inherits from, and a platform standard before the language standards it builds on.
4. Add each inherited standard once, after the standard that inherits it. Stop at a title already listed, so a cycle adds nothing twice.
5. A missing When to use entry does not remove Language from a task whose Provider or Method names that standard's Technology on its own, and does not remove the standard whose Technology appears on its own in the task's Provider.

A task with no row says `No coding standard applies.` An earlier standard wins a disagreement with a later one. The person can add, remove, or reorder the list on `revise`.

For a code project, `code tasks` decides a code task's list.

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

Do not run `align` when continuing a feature that already has a plan. Otherwise go to `govern`.

### govern

Read `library/governance/controls.md` and `library/governance/nfrs.md` when present. Read each active record. Skip a removed row. Read the selected implementation's Security Control Realization and NFR Realization. Write nothing.

1. When both catalogs are absent, hold `No Control or NFR applies.` Go to `resume`.
2. A Control or NFR applies when its statement contains, ignoring case, the task's target, a file name or path written in the task, or the mechanism that realization names for it.
3. Correct the draft so each task abides by each one that applies. When the task touches this implementation, use the mechanism that realization names.
4. When a coding standard disagrees, the Control or NFR wins. Hold the standard title that gave way.
5. When two Controls disagree, or two NFRs disagree, apply the earlier catalog row. When a Control and an NFR disagree, apply the Control. Hold the title that gave way.
6. When no correction meets one for this action, emit `[Title] cannot be met for **[Action title]**.` Show no proposal. Return to `suggest`. When the invocation named the action, ask for a different action.
7. Hold the applied titles, Controls first, in catalog order, or `No Control or NFR applies.` Hold each conflict as `[Applied title] is applied. [Other title] disagrees.`

Before the proposal, emit one line for each standard that gave way: `[Standard title] gives way to [Control or NFR title].` Go to `resume`.

### resume

Read the accepted rows of `code/code.md` and `code/integrations.md`. Skip removed rows. Do not open a product folder. Write nothing.

1. When the person named a folder, use it.
2. When a recorded feature's `<action>` is this action's title, compared without regard to case or hyphens, resume that feature: at `menu` with no task list, `code` with an open task, or `close` when every task is done.
3. When a feature sentence or a product Summary means this same action, join that product.

Stop at the first that applies. Otherwise go to `join`.

### join

1. Read the matching coding standard. When one of its rules names where this action lives, that rule replaces the decision below.
2. For a composition row, when only one side has a product, join that folder and list both implementations.
3. For a composition row, when both sides have products, join the folder of the implementation being codified. Leave the other folder in place. List both implementations on the joined product.
4. For a composition row, when neither side has a product, start one folder and list both implementations.
5. For a capability row whose From is the selected implementation, join the product that lists From. Add To to its implementations.
6. When a product Summary means the same consumer and outcome and this action is new, join that folder.

When this implementation, or an implementation a product lists, is a code project, `code tasks` decides the join.

Use the first of steps 2 to 6 that fits, unless a rule read in step 1 replaced it. Otherwise go to `folder`.

### folder

1. Otherwise start a folder from the product title: lowercase words, hyphens.
2. When that folder is already a catalog path, say it is taken and ask for another name. This applies to every new folder.

A new product's title names what it serves in at most four words, such as Worker. For a code project, `code tasks` decides the title. Its Summary is one sentence that says who it is for and what it returns. A joined product keeps its title and Summary.

When this action connects the selected implementation to another accepted implementation and no accepted row holds that pair, hold From, To, Kind, and one summary sentence. Accepting the proposal records it.

Hold **Proposed project:** `New <folder>` or `Existing <folder>`, then **Rationale:**. The first sentence says in plain words why this folder is the right home. When a standard or integration replaced the decision, cite it after that sentence. Name a pair held here. Go to `layout`.

### layout

For each task, place the files it creates or changes. Read the File and Folder Structure of each standard on its Standards list. Write nothing.

1. Place each file at a path from the first standard on the list whose structure has a path for that kind of file.
2. Fill each placeholder in angle brackets from the task, such as the module or resource it names. While a placeholder is unfilled, `accept` stays on `revise`.
3. The platform standard decides the folders. An inherited language standard's file names apply only where the platform standard names none. For a code project, `code tasks` decides the folders.
4. A component the task calls, such as a module, is placed from its own standard on the list.
5. A file no structure places, or a task with no standard, goes at the root of the product folder, named from the task.
6. A later task that changes a file an earlier task placed names that same path.

Every path is relative to the product folder and does not begin with `/`, `code/`, or `.highway/`.

When a listed standard has no File and Folder Structure, emit before the proposal:

[Standard Title] has no file and folder structure. To add one, run /highway-codify-config.

Place that standard's files as if it were absent. Apply the match in step 2 of `govern` to each placed path. Add a new match. Do not drop a match already held. Go to `propose`.

### propose

The diagram is one logical flow that starts at the Executor. Each task adds one arrow from the Executor, labeled with its action, to a new node for its platform, in task order. No arrow leaves a target. Every target has its own node.

For a code project, `code tasks` decides the diagram and the **Language:** line.

**Here is a proposed starting point for your codify feature:**

**Title:** [Selected title.]

**Summary:** [Selected summary.]

**Description:** [What this one automation does, for whom, and what it returns.]

**Acceptance criteria:**

- [One observable result of this automation.]

**Executor:** [Executor.]

**Diagram:**

```flowchart
flowchart TB
  P["[Executor]"] -->|[First action]| T1["[First task platform]"]
  P -->|[Next action]| T2["[Next task platform]"]
```

**Tasks:**

1. **[First action]:**
   - **Scope:** [What the task does.]
   - **Provider:** [The platform this task uses.]
   - **Method:** [How it is done.]
   - **Standards:**
     1. [Standard Title. Or, when none applies: No coding standard applies.]
   - **Files:**
     1. `[relative path]`
   - **Assumptions:**
     - [What it relies on that is not an earlier task, or None.]

**Controls and NFRs:**

- [Applied title. Or: No Control or NFR applies.]

**Conflicts:**

- [Applied title] is applied. [Other title] disagrees. [Omit this section when nothing disagrees.]

**Proposed project:** [From `folder`.]

**Rationale:** [From `folder`.]

**What would you add, correct, or remove?**

If this is accurate, just say so. Highway will use this specification to build out the solution.

Go to `revise`.

### revise

Classify the reply to the proposal.

- `edit`: emit one consequence sentence. Re-emit the proposal with the diagram and tasks still matching. Stay on `revise`.
An edit that names a different Executor sets the Executor and the diagram start. It does not change a task's Provider.
An edit that names a different Provider sets it on that task, then goes to `standards`.
An edit that changes a method goes to `standards`, then `align`, for that task.
An edit that adds, removes, or reorders a task's Standards changes only that list, then goes to `align` for that task.
A Files edit changes only this automation and leaves out a path that is not relative.
A title not in the coding standards catalog is left out, and the rest of the list is kept. Say: [Title] is not a listed coding standard. To add it, run /highway-codify-config.
A second action is removed. Say it waits for another run.
The person can switch to another accepted architecture by title. An architecture that is not accepted is not added.
A preparation-only request stays one self-service action.
Removing the last task or the last acceptance criterion says at least one is needed.
An edit that changes the proposed project uses that folder. Say a removed product's folder is taken.
An edit that would break a listed Control or NFR is not applied. Say: [Title] stays in effect. To change a Control, run /highway-controls. To change an NFR, run /highway-nfrs.
- `accept`: go to `identifier` when the proposal has one action, a Provider or a Language standard, at least one task, at least one acceptance criterion, and an accepted architecture. Otherwise stay on `revise`.
- `unknown`: re-emit the proposal. Stay on `revise`.
- `question`: answer, then re-emit the proposal. Stay on `revise`.
- `decline`: stop. Write nothing.

### identifier

When `join` joined a product, keep its `CDY` id and go to `write`. Otherwise derive the id from the new product's title.

1. Lowercase the title. Remove hyphens and apostrophes. Split the rest into words.
2. Take eight letters: the first two of word 1, the first two of word 2, the first two of word 3, and the last two of the last word. When the title has only two words, the third sample is the first two of the last word.
3. When a word is shorter than two letters, continue into the next word. A one-word title repeats until there are eight letters.
4. Map each letter. Digits stay as they are.

a 0, b 1, c 2, d 3, e 4, f 5, g 6, h 7, i 8, j 9, k a, l b, m c, n d, o e, p f, q 0, r 1, s 2, t 3, u 4, v 5, w 6, x 7, y 8, z 9.

5. The id is `CDY` plus those eight hex digits.

Compare that id with `code/code.md`, including removed rows.

- An accepted row with the same product title has that id: join that product. Go to `write`.
- The id is taken for a different title, or by a removed row: go to `title`.
- The id is free: go to `write`.

### title

Name each conflicting title. Say that a title change is appropriate. Then show the new title for acceptance.

The existing product title, **[Existing title]** and this new product title, **[this title]**, are too similar. A title change is appropriate. I would recommend:

**[New title]**

**What would you add, correct, or remove?**

If this is accurate, just say so.

The new title is a small change the person can recognize. Its derived id must be free. Do not mention identifiers, hex, sampling, or the catalog.

- `accept`: replace the held product title. Return to `identifier`.
- `edit`: use the person's title. Return to `identifier`.

A new title does not rename the folder. The person can name another folder on `revise`.
- `question`: answer in one sentence. Re-emit this message.
- `unknown`: re-emit this message.

Do not write until the id is free or an accepted product is joined.

### write

Write the files below and the rows in `index` together. Write none of them until all are valid. A failed write leaves every existing product byte unchanged and leaves no partial folder. Say what failed in terms the person can act on. Stay on `write`. Do not write the README or any file the task list names here.

The folder is `code/<folder>/` from the accepted proposal. `<number>` is `001` for a new product. For a joined product, it is the next integer after the last ID in the Features table of `code/<folder>/.highway/metadata.md`. Do not list `code/<folder>/.highway/features/`. `<action>` is the title in lowercase words separated by hyphens.

For a new product, write `code/<folder>/.highway/metadata.md` from `.highway/library/templates/output/codify-metadata.md`. A joined product keeps its file. Append this feature's row to its Features table.

The record is `code/<folder>/.highway/features/<number>-<action>/codify.md` and follows `.highway/library/templates/output/codify-record.md`.

- `id` is the product's `CDY` id.
- `implementation` is the accepted implementation id.
- `architecture` is the accepted architecture this automation follows.
- `status` is `accepted`.
- The title is the one action.
- Summary, Description, Acceptance Criteria, Diagram, Tasks, **Controls and NFRs:**, Conflicts, Proposed project, and Rationale are the accepted proposal text, in that order.

Do not write `codify-tasks.md` here. Go to `index`.

### index

Write these rows with the files in `write`. The catalog follows `.highway/library/templates/output/codify-catalog.md` at `code/code.md`. The first catalog version is `1.0.0`. Each change increments the minor version.

1. For a new product, write one row. Append the new row as the last row. ID is the `CDY` id. Folder is `code/<folder>`. Title and Summary come from `folder`. Status is `accepted`.
2. For a joined product, update its row in place. Add each implementation the proposal lists that Implementations lacks.
3. In Features, add `<number>-<action> | one sentence` when this feature starts the product, adds an implementation, records an integration, changes the summary, or is open. A feature is open while it has no task list or its task list has an open task. When a finished feature did none of those, remove its entry and keep its directory.
4. When the accepted proposal includes an integration, write it to `code/integrations.md` from `.highway/library/templates/output/codify-integrations.md`. When an accepted row already has that From, To, and Kind, write no second row. Ask nothing more.

A row whose status changes keeps its position. Do not allocate from `Next ID`. More than one row may name the same Implementation ID. A removed row keeps its id and has no folder. Emit no timestamp, random value, or environment value. Do not change the implementation, its architecture, its decision, the request, the assessment finding, Controls, or NFRs.

On success, go to `plan` without asking a question.

### plan

Write `code/<folder>/.highway/features/<number>-<action>/plan.md` from `.highway/library/templates/output/codify-plan.md`. The plan holds one story per proposal task, so a review of it is the whole plan.

1. One story per proposal task, in task order. The title is that task's action. When an acceptance criterion contains that action, ignoring case, Done when is the earliest such criterion. Otherwise Done when is the task's Scope sentence. Copy no scope, method, standards, or files.
2. An edge case names a situation the proposal's acceptance criteria do not.
3. A functional requirement comes from the accepted proposal, an applied Control or NFR, or a coding standard on a task. Leave out any other. Each applied Control or NFR names the story that carries it.
4. Record a decision only when the proposal, the standards, and the Controls leave a choice. State what was chosen, why, and what was rejected.
5. Add a data shape only when the feature has state. Add an interface shape only when the proposal names an endpoint, a file format, or a command.

On success, go to `check`. A failed write says what failed. Stay on `plan`.

### check

Compare the plan with the accepted proposal, the standards, the Controls, the NFRs, and the implementation record.

1. When the plan contradicts the accepted proposal, or a proposal task's outcome has no story, correct the plan.
2. When accepted material answers a question, record the answer as a decision. Ask nothing.
3. A story with no Done when, a repeated story title, or an applied Control or NFR that no story names is a gap. Walk stories in plan order, then the applied titles in proposal order. When accepted material answers a gap, record the answer and ask nothing.
4. Ask the first five, one at a time. Write each answer into the plan. Record each later gap as an assumption.
5. When none qualify, go to `menu`. Do not say the check ran.

After the last answer, go to `menu`.

### menu

Emit:

The plan is complete for feature <number>-<action>. **Would you like to:**

1. Review the plan?
2. Continue to code the solution?

- `1`: go to `review`.
- A stated edit: regenerate the plan. Go to `check`.
- `2`: go to `tasks`.
- `decline`: stop. Write nothing.

### review

Read every section of `plan.md` with the person. Answer each question they ask along the way. Write nothing. After the last section, ask:

**What would you add, correct, or remove?**

If this is accurate, just say so.

Do not emit the menu with this question.

- `accept`: emit the menu. Go to `menu`.
- `edit`: emit one consequence sentence. Regenerate the plan. Go to `check`.
- `question`: answer, then ask this question again. Stay on `review`.
- `unknown`: ask this question again. Stay on `review`.
- `decline`: stop. Write nothing.

### tasks

Emit this sentence once: Highway is now building out this solution. We can review, discuss, and revise it afterward, and continue refining it as requirements evolve.

Write `codify-tasks.md` beside the plan from `.highway/library/templates/output/codify-tasks.md`.

1. Order the lines by story, then by each proposal task that delivers no story. Under each heading, state how it is tested on its own.
2. Each task names its file. Keep the line shape, the Provider, and `Tests: required`.
3. Place each proposal task under the story whose title is that task's action, in proposal order. When no story has that title, give the task a heading from that task. When a story title is not a proposal task's action, add a task for it. Leave out a line that names work the proposal does not list.
4. When a question remains that changes a story and nothing accepted decides it, ask it. Write nothing further until it is answered.
5. On success, go to `code` without asking a question.

A failed write leaves the plan and says what failed. Stay on `tasks`. Do not emit the sentence again.

### code

Open the feature's `codify-tasks.md`. Start at the first open task. For each open task, in list order:

1. Read every standard the task names, in order, including its File and Folder Structure, and each file the task names that already exists. Read each Control and NFR the record lists whose catalog row is active. Skip a removed one. Read no other file in the product folder.
2. Write the task's files at their relative paths in `code/<folder>/` so they follow every one of them and abide by each Control and NFR read. When two disagree, the earlier one wins. The accepted proposal, architecture, and implementation decide what is built. The standards decide how it is written.
3. Mark the task `[X]`.
4. Go to the next open task.

Write only the paths the task names. Do not run any file.

The README task writes two parts, in this order. Head the first part `## Setup Instructions` and the second part `## User Guide`. Setup Instructions says what is put in place, where it goes, and how to enable it, including the preparation this automation needs. User Guide says how a non-technical person starts this one automation, what they provide, and what they receive, using the interface of the Provider. User Guide does not ask that person to edit the generated files or read the implementation record.

For a code project, `code tasks` decides both parts.

When a task cannot be finished, stop at that task. Leave it and every later task open. Start no later task. Keep the files that finished tasks wrote. Go to `close`.

When every task is done, apply step 3 of `index` to this feature's entry, then go to `close`.

### close

First emit the coding standards notices that apply, then one close.

For a code project, `code tasks` decides the not-run line.

[No coding standards catalog was found. A standard named by the catalog was not found at [path]. Include only the sentences that apply.]

When every task is done, emit this message exactly, as rendered markdown, with the product folder in place of `<folder>`:

```markdown
### The codify stage is complete.

This code is now part of your Highway knowledge base. Like your architectures, implementations, and other accepted knowledge, it remains available for future context. Highway can help you understand, configure, extend, troubleshoot, and use any code it has helped you create.

The automation was not run.

**The files can be found here:**

`code/<folder>/`

If you'd like to review the files together, just say so.

**Setup and Usage Instructions** can be found here:

`code/<folder>/README.md`

If you'd like to review the instructions together, just say so.

**Questions?**

To revisit this in the future, just ask Highway to show your Code Catalog. We can review, discuss, and revise any of your solutions, and continue refining them as requirements evolve.

**Where would you like to go next?**

Run /highway-help to explore what Highway can help you do.
```

When a task could not be finished, emit:

**Automation recorded**

- **Automation record:** `code/<folder>/.highway/features/<number>-<action>/codify.md`
- **Task list:** `code/<folder>/.highway/features/<number>-<action>/codify-tasks.md`
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
- With no instance running, `Establish [implementation title]` comes first. Every other suggestion comes from one realized capability, in Realized Capabilities order.
- A suggestion already in a product that lists this implementation is left out before the list keeps five: by a recorded feature with the same words, ignoring case, or by a feature sentence or product Summary with that meaning. No product folder is opened. Removed rows and integration rows leave nothing out.
- The proposal shows **Proposed project:** as `New <folder>` or `Existing <folder>`, then **Rationale:**. Its first sentence is plain language. A standard or integration is cited only when it replaced the decision.
- The person's project edit is written. The folder stays unique, including removed rows, the `CDY` id is in `.highway/metadata.md`, the feature is under `.highway/features/`, and paths are relative to the folder.
- Each accepted action is the next numbered feature directory in its product, numbered from the last row of the Features table in `.highway/metadata.md`. No features folder is listed. Earlier directories stay.
- Each accepted feature adds one Features row with its number, folder, title, and Summary. A row is never removed.
- Features keeps an entry only when that feature starts the product, adds an implementation, records an integration, changes the summary, or is open.
- Accepting a proposal that includes an integration writes one row to `code/integrations.md`, and a pair already accepted writes none.
- A named action skips the suggestion list and opens the proposal for that action.
- Before any proposal, coding standards are checked first and vendor documentation second. Corrections and inconclusive results are named before the proposal and are not saved. The checks keep the selected action.
- A standard that cannot be met for the selected action shows no proposal and returns to suggestions.
- The proposal shows Title, Summary, Description, Acceptance criteria, Diagram, and Tasks, in that order. It shows no components, current state, separate action, day, or means.
- The diagram is one logical flow, top to bottom, from the Provider. Each arrow leaves the Provider, is one task's action, starts with a verb, and points to that task's target, in task order. No arrow leaves a target.
- Every task names the same Provider, the platform executing the automation. The implementation being automated is a target. A Shopify proposal can use Cursor when Cursor is included, even though the Shopify records do not name it.
- A named platform with no catalog row stays the Provider and the proposal says `/highway-codify-config` can add it. With no row and no named platform, the proposal says a platform is needed and accept stays on `revise`.
- After a selection, a record whose Deployed by or Managed by is `Needed`, empty, or has no row, or whose Language is `Needed`, empty, or has no row, emits the missing critical detail line and "Let's set those details now for [Product Title].", then follows `highway-implementation` with the return step `record check`. It asks no question and holds no platform for one run.
- A return with the record still incomplete stops and writes nothing.
- An implementation whose Language names a coding standard is a code project. Until an Establish feature is recorded, `Establish [implementation title]` is the only suggestion, even when an instance is running. Later suggestions come from Realized Capabilities, Realized Interfaces, covered Coverage rows, then NFR Realization, at most five.
- A code project's Establish proposes the project structure, the build file, the entry point, the configuration, and a health check, plus pipeline tasks when Deployed by is a pipeline. A code task shows Language in place of Provider. The Executor is Deployed by.
- A code project's product is titled from the implementation, lists only that implementation, and its close says the code was not run.
- Each task shows Standards as an ordered list, or `No coding standard applies.` A standard whose When not to use matches is dropped. A standard comes before the standards it inherits from, and each inherited standard appears once.
- A Standards edit re-emits the proposal with one consequence sentence. A title not in the catalog is left out and points to `/highway-codify-config`.
- `align` corrects the method, library, module, or pattern against every standard on the task's list and keeps the Provider.
- An invocation of the word `configure` points to `/highway-codify-config` and writes nothing.
- `/highway-codify catalog` lists at most five accepted automations, newest first, with each implementation title and progress, says how many more exist, and writes nothing. A selection shows the files path and the README path.
- A new row in `code/code.md` is appended as the last row.
- The README is headed `## Setup Instructions`, then `## User Guide`.
- A finished run closes with the completion message, both paths, and the sentence that the automation was not run. A stopped run names the stopped task and does not say the codify stage is complete.
- Each task is one action against one target and shows Scope, Provider, Method, Standards, Files, and Assumptions.
- Files lists relative paths placed from the File and Folder Structure of the task's standards. A listed standard with no structure is named before the proposal with a pointer to `/highway-codify-config`. A Files edit changes only this automation. An unfilled placeholder keeps the proposal open.
- A second action waits for another run. Declining writes nothing. Accepting is the only confirmation.
- Acceptance writes `codify.md`, the product's `metadata.md` with the new Features row, the catalog row, and any new integrations row together, then `plan.md`. It writes no task list, no file the task list names, and no README.
- The proposal heading is `Here is a proposed starting point for your codify feature:`. `Highway will use this specification to build out the solution.` follows `If this is accurate, just say so.`
- The menu offers Review the plan and Continue to code the solution. A feature with a plan and no task list resumes at the menu.
- Reviewing the plan reads every section, then asks **What would you add, correct, or remove?** and "If this is accurate, just say so." before the menu returns. Accepting emits the menu, and a change regenerates the plan and runs `check`. Continuing to code asks no review question.
- Continuing emits the building sentence once, then writes the task list ordered by story, each heading with its independent test.
- The task list follows `codify-tasks.md`. A story's test line comes first only when its first standard says `Tests: required`.
- Coding starts with no question after the task list is written. Every standard a task names, and each existing file it names, is read before its files are written, and no other automation file is read, the earlier one winning a disagreement, and each task is marked `[X]` before the next begins.
- A task that cannot be finished stops the run with that task and every later task open. The next run starts at the first open task, redoes no finished task, and runs no check.
- Codify creates, edits, and removes no coding standard and no row of the coding standards catalog.
- Acceptance and coding run the automation zero times and leave the implementation, architecture, decision, request, and finding unchanged.
- Each id is `CDY` plus eight hex digits derived from the product title. A joined product keeps its id.
- A taken id names the conflicting titles, says a title change is appropriate, and shows a new title. The write waits until the person accepts that title.
- That message does not mention identifiers, hex, sampling, or the catalog.
- A failed write leaves no partial folder and leaves existing catalog bytes unchanged.

## Error Handling

- A missing `.highway/` root stops the skill and writes nothing.
- A missing record, catalog, plan, or task list template stops the skill, names the template path, and writes nothing.
- Missing Controls and NFRs catalogs leave the proposal with `No Control or NFR applies.`
- A Control or NFR that cannot be met for the selected action returns to `suggest` and writes nothing.
- A missing coding standards catalog leaves every task with `No coding standard applies.` The close says no catalog was found.
- A standard that cannot be met for the selected action returns to `suggest` and writes nothing.
- A task that cannot be finished stops coding at that task, leaves it open, and keeps the files finished tasks wrote.
- An implementation that is not accepted stops the skill and writes nothing.
- No accepted architecture for this automation keeps the proposal open and says so.
- A failed write leaves no partial folder and leaves existing catalog bytes unchanged.
- Declining a proposal writes nothing.
- A folder already in the catalog, including a removed row, is not started. The person names another.
- Removing the last task or the last acceptance criterion keeps the proposal open and writes nothing.

## Example

Illustrative.

`/highway-codify Restart the worker`
