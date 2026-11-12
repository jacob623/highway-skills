---
name: highway-codify-config
description: "Manages the repository-wide guidance used by highway-codify. Use when the person wants to set up or update the platforms highway-codify writes for, or when another highway skill directs the person here."
license: Apache-2.0
metadata:
  version: 3.11.0
  usage: "Run highway-codify-config, or with one implementation name."
---

# highway-codify-config

## Purpose

Configures the platforms Highway considers for automation, the coding standards it uses for coding, and the conflicts between them, so `highway-codify` proposals stay accurate and consistent.

## When to use

- The person invokes `highway-codify-config`.
- The person invokes `highway-codify-config` with a platform name to add or update that platform.
- `highway-codify`, `highway-implementation`, or `highway-onboarding` directs the person here.

## When not to use

Do not create, change, or run an automation or its task list.
Do not change an implementation, its architecture, its decision, Controls, or NFRs.
Do not add a platform that has no accepted implementation.
Do not delete a coding standard file.
Do not report Status, Summary, Next Action, Blocking Reason, Missing, Complete, or Blocked.

## Inputs

- `library/coding-standards/codify-platforms.md`.
- `library/coding-standards/coding-standards.md` and the standard files it names.
- `implementations/implementations.md` and the accepted implementation records.
- `assets/coding-standard.md`.
- `highway-onboarding`.
- `highway-implementation`.
- The highway-experience skill, activated first.

## Outputs

The complete structure is `assets/coding-standard.md`. `library/coding-standards/codify-platforms.md` and `library/coding-standards/coding-standards.md` keep the structure highway-setup seeded.

- An updated `library/coding-standards/codify-platforms.md` after an accepted platform change.
- A standard file in `library/coding-standards/`, then an updated `library/coding-standards/coding-standards.md`, after an accepted standard change.
- Only the accepted changes after an accepted conflict resolution.
- Nothing after a cancel.

## Procedure

Activate the highway-experience skill before any output the person sees, and follow it for Highway's identity, the Experience Standard, and the storage contract.

Before the first question, confirm these seeded files exist: `library/coding-standards/codify-platforms.md`, `library/coding-standards/coding-standards.md`.
When any is absent, emit the message below exactly, stop, and write nothing.

**Oops... we need to setup your repository.**

Highway needs to gather your organizational preferences and set up your repository. Run highway-setup to get started.

Emit only the active template. Start at `Entry`. Follow the Highway Experience Standard for attribution and acceptance wording. Write only after `accept`.

A list field is stored in one table cell, with entries separated by `; `. A blank cell is an empty list. Every proposal and every catalog view presents When to use, When not to use, Inherits From, and Coding Standards as an ordered list under its bold label, one entry per item. An empty list shows `None`. Writing joins the accepted items with `; `.

Picking a menu option, and every `edit`, begins with one sentence that states its consequence. Every proposal ends with:

**What would you add or correct?**

If you'd like to cancel, just say so.

A cancel writes nothing and returns to `menu`.

Before a step in this table, read its file and follow it to the end.

| File | Steps |
| --- | --- |
| `references/platforms.md` | `platforms`, `kind`, `platform proposal`, `platform rules`, `platform written` |
| `references/standards.md` | `standards`, `standard rules`, `rule shape`, `standard proposal`, `standard write` |
| `references/conflicts.md` | `conflicts`, `resolve` |

### Entry

1. When the invocation names a return step, hold it for this visit.
2. When the invocation names a platform, go to `platforms` with that name as an add or update. Do not show the menu.
3. Otherwise go to `menu`.

### Classify

Classify the latest reply before any other action. Test the classes in this order and stop at the first match.

1. `edit`: adds, removes, corrects, or replaces proposal text, or names a record to add, correct, or remove.
2. `decline`: answers no, stops, or cancels.
3. `question`: asks for an explanation.
4. `select`: names a listed option, conflict, platform, or standard by number or title.
5. `unknown`: the person says they do not know.
6. `accept`: affirms the proposal or answers yes, and adds no fact.

On a proposal, "looks good" is `accept`.

### menu

Emit this menu exactly, as rendered markdown:

```markdown
### How would you like to configure Highway Codify?

1. **View or Update Platforms** highway-codify can use in proposals.
2. **View or Update Coding Standards** highway uses for coding.
3. **Resolve Codify Conflicts** so highway can provide more accurate and consistent proposals.
```

- `select` 1: emit `Changes here decide which platform carries out each automation highway proposes.` Go to `platforms`.
- `select` 2: emit `Changes here decide how highway writes each file it codes.` Go to `standards`.
- `select` 3: emit `Resolving conflicts makes highway's choice of platform and coding standards predictable.` Go to `conflicts`.
- `question`: answer, then re-emit the menu.
- `unknown`: re-emit the menu.
- `decline`: when a return step is held, go to that step in its skill. Otherwise stop. Write nothing.

### current

1. Read the technology's current public documentation. Write nothing.
2. For a standard, capture each capability the documentation describes.
3. For a platform, capture each automation capability the documentation describes. Do not capture a capability unrelated to automation.
4. Group captured platform capabilities that perform the same automation. Judge sameness by meaning.
5. Title that automation. Put a product name and a handoff, such as a pull request, a comment, or a ticket, in the evidence.
6. For a platform, mark each grouped capability that the implementation's Realized Capabilities do not already mean as a new realized capability. Judge that by meaning.
7. Do not propose a capability the documentation no longer describes.
8. When the documentation cannot be read, say: The current documentation could not be read. Add no capability as current. Mark no new realized capability. Continue from the accepted implementation and the catalogs already present.
9. Then go to the proposal named with this step.

### entry level

1. Propose each entry as a class of automation for the type `use entries` took. A class names what the type is for.
2. Propose a class only when `current` describes it for this type. When `current` describes none, or could not read the documentation, propose one When to use class and one When not to use class at the level of steps 3 and 4.
3. For an agent, propose from classes such as Agentic automation, Local machine execution, Human in the loop, MCP integration, Sensitive data handling, and Autonomous automation.
4. For a pipeline, propose from classes such as Continuous integration, Continuous delivery, File-based triggers, and Workflow orchestration.
5. For a coding standard, and for any other type, propose classes at the level of steps 3 and 4.
6. A task is not an entry. Code change proposals, Pull request review, Bug investigation, and Test authoring are tasks.
7. Propose at most four When to use entries and at most four When not to use entries.
8. Take no class from this organization's customers, products, data, or decisions.
9. Return to `use entries`.

### use entries

1. For a platform, take its type from the implementation's Technology Choice and `current`. For a standard, take the type of its language or platform.
2. On an add or update of a standard whose Technology is a platforms-catalog title, the whole value, compared without regard to case, follow `platform entries`. Do not follow `entry level`. On another add, follow `entry level`, then write the entries it returned. On another update, start from the saved entries. Do not follow `entry level`.
3. Do not take an entry from the implementation's Realized Capabilities or Runtime Components.
4. Write each entry as one condition or one outcome, in five words or fewer. Count a hyphenated term as one word.
5. Do not join two things with "and", "or", a comma, or a slash. Write two things as two entries.
6. Give When to use and When not to use at least one entry each.
7. On an update, keep each saved entry. Rewrite a saved entry that breaks step 4 or step 5, and state the rewrite in its **Why it matters:** sentence.
8. Keep each entry distinct from the other rows' entries.
9. Under each entry, emit **Why it matters:** and one sentence stating the consequence of that entry for the work Highway proposes. Name no customer, product, or decision of this organization. The catalog view, a conflict quote, and the saved cell keep the entry only.
10. Return to the proposal that followed this step.

### platform entries

1. When to use is `[Platform] is used`.
2. When not to use is `[Platform] is not used`. `[Platform]` is that row's title.
3. Do not follow `entry level`. Do not keep other saved entries.
4. Do not split these entries. Do not rewrite them.
5. Return to the proposal that followed `use entries`.

## Verification

- `highway-codify-config` shows the three-option menu. A platform name skips the menu and the platform list, and opens that platform's add or update or the onboard question.
- `Classify` tests `edit`, `decline`, `question`, `select`, `unknown`, then `accept`, and the first match wins.
- Each yes or no question answers a `question` and asks again, asks again after `unknown`, and names where `decline` goes.
- A return step named by `highway-onboarding` or `highway-implementation` is held for the visit. Declining the menu goes to that step. With none held, declining the menu stops.
- Picking an option and every edit begin with one consequence sentence.
- Platforms and coding standards views show each catalog with list fields as ordered lists, and ask what to add, correct, or remove.
- Every proposal shows its fields as bold labels, list fields as ordered lists, then Conflicts, and ends with **What would you add or correct?** and the cancel line.
- Accepting a platform writes only its row. Accepting a standard writes its file, then its row. Removing a standard keeps its file.
- A cancel writes nothing and returns to the menu.
- `current` is read before an add or update, and a removal does not run it.
- On an add, `entry level` proposes one to four classes of automation for each of When to use and When not to use, from what `current` describes, and no task. `use entries` writes each as one condition or one outcome in five words or fewer, and keeps saved entries on an update. Each proposal entry has a blank line, then **Why it matters:** stating its consequence, and the saved catalog does not keep that line.
- An add or update proposal with no edit yet, for a platform or a standard, shows the starting-point line after the consequence sentence. An edited proposal and a remove do not.
- `current` groups the automation capabilities the platform documentation describes by meaning. Each group the implementation does not already mean appears once under New Realized Capabilities, with the product and the handoff in the evidence. After the write, configuration follows `highway-implementation` to record them, with the return step `platform written`.

## Error Handling

- A missing template stops the change, names the template path, and writes nothing.
- A failed write leaves the existing file unchanged and keeps the proposal open.
- A failed standard file write writes no catalog row.
- A standard with no structure path, a path that is not relative, or a required test path outside the structure writes nothing and keeps the proposal open.
- A name that is not an accepted implementation is not added and offers onboarding.

## Example

Illustrative.

`/highway-codify-config`
