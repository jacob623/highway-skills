---
name: highway-codify
description: "Manages one functional artifact for one accepted implementation. Use when the person wants working code for an accepted reference implementation, or wants to see the code catalog and discuss one automation."
license: Apache-2.0
metadata:
  version: 14.8.0
  usage: "Run highway-codify with one implementation name."
---

# highway-codify

## Purpose

Suggests actions worth automating for one accepted implementation, checks the chosen action against the organization's coding standards and current vendor documentation, writes the task-by-task proposal the person accepts, and codes it from a task list that follows those standards, writing the product's own code when the implementation names a Language.

## When to use

- The person invokes `highway-codify` with an implementation title.
- The person invokes `highway-codify` without an implementation title.
- The person invokes `highway-codify catalog`, or asks to show the code catalog, to see recent automations and discuss one.

## When not to use

Do not run the automation.
Do not change the implementation, its architecture, its decision, the request, the assessment finding, Controls, or NFRs.
Do not change `library/coding-standards/codify-platforms.md`. `highway-codify-config` changes it.
Do not create a skill for a particular means.
Do not put lifecycle activities on the implementation record.
Do not create, edit, or remove a coding standard or a row of `library/coding-standards/coding-standards.md`. `highway-codify-config` changes them.
Do not report Status, Summary, Next Action, Blocking Reason, Missing, Complete, or Blocked.

## Inputs

- An implementation title, a description, or an implementation id, and one optional action, when the person supplies them.
- `implementations/implementations.md` and the accepted implementation records.
- `architectures/architectures.md` and the accepted architecture records.
- `code/code.md` and `code/integrations.md`.
- The product's `code/<folder>/.highway/metadata.md` when a proposal joins an existing product.
- The open feature's `plan.md` and `codify-tasks.md` under `code/<folder>/.highway/features/` when present.
- `library/coding-standards/coding-standards.md` and the standards it names, when present.
- `library/governance/controls.md`, `library/governance/nfrs.md`, and the active records they name, when present.
- `library/coding-standards/codify-platforms.md` when present.
- The vendor's current public documentation for each product, API, plugin, module, or library a draft proposal names.
- `assets/codify-record.md`.
- `assets/codify-plan.md`.
- `assets/codify-tasks.md`.
- `assets/codify-metadata.md`.
- The highway-experience skill, activated first.

## Outputs

The complete structure is `assets/codify-record.md`, `assets/codify-plan.md`, `assets/codify-tasks.md`, and `assets/codify-metadata.md`. `code/code.md` and `code/integrations.md` keep the structure highway-setup seeded.

- One product folder `code/<folder>/`, with `.highway/metadata.md` written when the product is new. Each accepted feature adds one row to its Features table.
- One saved proposal at `code/<folder>/.highway/features/<number>-<action>/codify.md` after the person accepts the proposal.
- One plan, `plan.md`, beside that proposal, written after it.
- One task list, `codify-tasks.md`, beside that plan, written when the person continues from the plan.
- An updated `code/code.md`, and `code/integrations.md` when the accepted proposal includes a new integration, written with that proposal.
- The files each task list line names, at their relative paths in `code/<folder>/`.
- One `code/<folder>/README.md` with two parts, produced by the last task.
- When every task is done, a completion message that names the files path `code/<folder>/` and the README path `code/<folder>/README.md`. When a task could not be finished, a close that names the automation, the task list, and that task. Both say the automation was not run.
- A read-only code catalog view after `highway-codify catalog`.
- No automation when the implementation is missing, not accepted, the proposal is declined, or a write fails.

## Procedure

Activate the highway-experience skill before any output the person sees, and follow it for Highway's identity, the Experience Standard, and the storage contract.

Before the first question, confirm these seeded files exist: `code/code.md`, `code/integrations.md`.
When any is absent, emit the message below exactly, stop, and write nothing.

**Oops... we need to setup your repository.**

Highway needs to gather your organizational preferences and set up your repository. Run highway-setup to get started.

Emit only the active template. `catalog` runs alone. Otherwise follow this order: `choose` when no implementation is named; `record check`; `code project` for a code project, or `rank`, with `codified`, when no action is named; then `suggest`, `draft`, `code tasks` for a code project, `provider`, `standards`, `align`, `govern`, `resume`, `join`, `folder`, `layout`, `propose`, `revise`, `identifier`, `title` when needed, `write`, `index`, `plan`, `check`, `menu`, `review` when chosen, `tasks`, `code`, and `close`. Follow the Highway Experience Standard for attribution and acceptance wording. A current implementation is an accepted row in `implementations/implementations.md`. A removed row does not match and does not block a new automation.

The Features rule: in Features, add `<number>-<action> | one sentence` when this feature starts the product, adds an implementation, records an integration, changes the summary, or is open. A feature is open while it has no task list or its task list has an open task. When a finished feature did none of those, remove its entry and keep its directory.

Before a step in this table, read its file and follow it to the end.

| File | Steps |
| --- | --- |
| `references/catalog.md` | `catalog` |
| `references/proposal.md` | `draft`, `code tasks`, `provider`, `standards`, `align`, `govern`, `resume`, `join`, `folder`, `layout`, `propose`, `revise` |
| `references/record.md` | `identifier`, `title`, `write`, `index`, `index rules`, `plan`, `check`, `menu`, `review` |
| `references/code.md` | `tasks`, `code`, `close` |

### Entry

1. When the invocation is the word `configure`, or asks to change platforms or coding standards, say: To configure platforms and coding standards, run highway-codify-config. Write nothing.
2. When the invocation is the word `catalog`, or asks to show the code catalog, go to `catalog`. Do not resume a task list or select an implementation.
3. Read the invocation for an implementation title, a description, an implementation id, and one optional action.
4. When the invocation names a product in `code/code.md` by title, folder, or `CDY` id and its open feature has an open task, go to `code` at the first open task. When that feature has a plan and no task list, go to `menu`.
5. When an implementation id matches one accepted implementation, select it and show its title.
6. When an exact title matches one accepted implementation, select it. Compare without regard to case.
7. After a selection, go to `record check`.
8. When a description is present, go to `choose` and suggest at most five matches.
9. When nothing is named and one to five accepted implementations exist, go to `choose` and list each one.
10. When nothing is named and more than five accepted implementations exist, go to `choose` and list none.
11. When no accepted implementation exists, say so. Write nothing.

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
2. The record is incomplete when Language is `Needed`, empty, or names a standard with no row. Language `None` names no standard and is complete.
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

The product is a code project when the selected implementation's Language names a coding standard. That standard is the Language standard. Read `code/code.md`. Write nothing.

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
- The person's project edit is written. The folder stays unique, including removed rows, the `CDY` id is in `.highway/metadata.md`, the feature is under `.highway/features/`, and paths are relative to the folder.
- Features keeps an entry only when that feature starts the product, adds an implementation, records an integration, changes the summary, or is open.
- A named action skips the suggestion list and opens the proposal for that action.
- After a selection, a record whose Deployed by or Managed by is `Needed`, empty, or has no row, or whose Language is `Needed`, empty, or has no row, emits the missing critical detail line and "Let's set those details now for [Product Title].", then follows `highway-implementation` with the return step `record check`. It asks no question and holds no platform for one run.
- A return with the record still incomplete stops and writes nothing.
- An implementation whose Language names a coding standard is a code project. Until an Establish feature is recorded, `Establish [implementation title]` is the only suggestion, even when an instance is running. Later suggestions come from Realized Capabilities, Realized Interfaces, covered Coverage rows, then NFR Realization, at most five.
- A code project's product is titled from the implementation, lists only that implementation, and its close says the code was not run.
- An invocation of the word `configure` points to `highway-codify-config` and writes nothing.
- Acceptance writes `codify.md`, the product's `metadata.md` with the new Features row, the catalog row, and any new integrations row together, then `plan.md`. It writes no task list, no file the task list names, and no README.
- Codify creates, edits, and removes no coding standard and no row of the coding standards catalog.
- Acceptance and coding run the automation zero times and leave the implementation, architecture, decision, request, and finding unchanged.

## Error Handling

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
