---
name: highway-codify-config
description: "Manages the repository-wide guidance used by highway-codify."
usage: "Invoke as /highway-codify-config, or with one implementation name."
compatibility: all
metadata:
  version: 3.4.0
---

# highway-codify-config

## Purpose

Configures the platforms Highway considers for automation, the coding standards it uses for coding, and the conflicts between them, so `highway-codify` proposals stay accurate and consistent.

## When to use

- The person invokes `/highway-codify-config`.
- The person invokes `/highway-codify-config` with a platform name to add or update that platform.
- `highway-codify`, `highway-implementation`, or `highway-onboarding` directs the person here.

## When not to use

Do not create, change, or run an automation or its task list.
Do not change an implementation, its architecture, its decision, Controls, or NFRs.
Do not add a platform that has no accepted implementation.
Do not delete a coding standard file.
Do not report Status, Summary, Next Action, Blocking Reason, Missing, Complete, or Blocked.

## Inputs

- `library/coding-standards/codify-platforms.md` when present.
- `library/coding-standards/coding-standards.md` and the standard files it names, when present.
- `implementations/implementations.md` and the accepted implementation records.
- `.highway/library/templates/output/codify-platforms.md`.
- `.highway/library/templates/output/coding-standards-catalog.md`.
- `.highway/library/templates/output/coding-standard.md`.
- `.highway/library/templates/output/capability-catalog.md`.
- `highway-onboarding`.
- `highway-implementation`.
- `.highway/governance/experience-standard.md`.
- A project root containing `.highway/`.

## Outputs

The complete structure is `.highway/library/templates/output/codify-platforms.md`, `.highway/library/templates/output/coding-standards-catalog.md`, and `.highway/library/templates/output/coding-standard.md`.

- An updated `library/coding-standards/codify-platforms.md` after an accepted platform change.
- A standard file in `library/coding-standards/`, then an updated `library/coding-standards/coding-standards.md`, after an accepted standard change. The first accepted standard creates the catalog.
- Only the accepted changes after an accepted conflict resolution.
- Nothing after a cancel.

## Procedure

Emit only the active template. Start at `Entry`. Follow `.highway/governance/experience-standard.md` for attribution and acceptance wording. Write only after `accept`.

A list field is stored in one table cell, with entries separated by `; `. A blank cell is an empty list. Every proposal and every catalog view presents When to use, When not to use, Inherits From, and Coding Standards as an ordered list under its bold label, one entry per item. An empty list shows `None`. Writing joins the accepted items with `; `.

Picking a menu option, and every `edit`, begins with one sentence that states its consequence. Every proposal ends with:

**What would you add or correct?**

If you'd like to cancel, just say so.

A cancel writes nothing and returns to `menu`.

### Entry

1. When `.highway/` cannot be found, stop. Say the project root cannot be located. Write nothing.
2. When the invocation names a return step, hold it for this visit.
3. When the invocation names a platform, go to `platforms` with that name as an add or update. Do not show the menu.
4. Otherwise go to `menu`.

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

1. **View or Update Platforms** highway considers for automation and self-service.
2. **View or Update Coding Standards** highway uses for coding.
3. **Resolve Codify Conflicts** so highway can provide more accurate and consistent proposals.
```

- `select` 1: emit `Changes here decide which platform carries out each automation highway proposes.` Go to `platforms`.
- `select` 2: emit `Changes here decide how highway writes each file it codes.` Go to `standards`.
- `select` 3: emit `Resolving conflicts makes highway's choice of platform and coding standards predictable.` Go to `conflicts`.
- `question`: answer, then re-emit the menu.
- `unknown`: re-emit the menu.
- `decline`: when a return step is held, go to that step in its skill. Otherwise stop. Write nothing.

### platforms

1. When Entry carried a platform name, apply the name bullets below to that name. Do not emit the list or its question.
2. Otherwise read `library/coding-standards/codify-platforms.md` when present. Emit one item per row, in file order. Do not use an id as the label.

1. **[Platform]**
   - **When to use:**
     1. [Entry]
   - **When not to use:**
     1. [Entry]

When the file is absent or has no rows, say no platform is included yet.

**What would you add, correct, or remove?**

If you'd like to cancel, just say so.

- A name to add or correct that is an accepted implementation title, compared without regard to case: go to `current`, then `platform proposal`, as an update when it has a row and as an add otherwise.
- A name to add that is not an accepted implementation: emit `[Platform] is not in the implementation catalog. Highway adds a platform from an accepted implementation.` Then ask **Would you like to onboard [Platform]?**
  - `accept`: follow `highway-onboarding` from `overview`, for [Platform]. Its summary ends with: Run `/highway-codify-config [Platform]` to finish adding [Platform].
  - `decline`: emit this list and its question.
  - `question`: answer, then ask **Would you like to onboard [Platform]?** again.
  - `unknown`: ask **Would you like to onboard [Platform]?** again.
- A listed platform to remove: go to `platform proposal` as a remove.
- A name to correct or remove that has no row: say it is not included. Re-emit this list and question.
- `question`: answer, then re-emit this list and question.
- `unknown`: re-emit this list and question.
- `decline`: go to `menu`.

### current

1. Read the technology's current public documentation. Write nothing.
2. For a standard, capture each capability the documentation describes.
3. For a platform, capture each automation capability the documentation describes. Do not capture a capability unrelated to automation.
4. Group captured platform capabilities that perform the same automation. Judge sameness by meaning.
5. Title that automation under the Title rule in `.highway/library/templates/output/capability-catalog.md`. Put a product name and a handoff, such as a pull request, a comment, or a ticket, in the evidence.
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

### kind

1. Take the type `use entries` named for this platform.
2. Store `agent`, `pipeline`, `orchestrator`, `self-service`, or `desired-state`. A self-service platform is `self-service`. A desired-state or GitOps tool is `desired-state`.
3. Return to `platform proposal`.

### platform entries

1. When to use is `[Platform] is used`.
2. When not to use is `[Platform] is not used`. `[Platform]` is that row's title.
3. Do not follow `entry level`. Do not keep other saved entries.
4. Do not split these entries. Do not rewrite them.
5. Return to the proposal that followed `use entries`.

### platform proposal

1. For an add or update, follow `kind`, then `use entries`. Start an update from the current values after `current`.
2. For a remove, show the current values. Do not run `current` or `use entries`. Leave out New Realized Capabilities.
3. Fill this proposal.

[One sentence stating the consequence of this change.]

[On an add or update with no edit yet: **Here is a proposed starting point for configuring [Platform] as a platform capable of executing automation**]

**Platform:** [Platform]

**Implementation ID:** [RI id]

**Kind:** [Kind.]

**When to use:**
1. [Entry]

   **Why it matters:** [One sentence stating the consequence of this entry.]

**When not to use:**
1. [Entry]

   **Why it matters:** [One sentence stating the consequence of this entry.]

**New Realized Capabilities:**
1. **[Title]:** Realized By: [Platform].

   **Evidence:** [What the current documentation describes.]

**Conflicts:**
1. **[Conflict]:** [Description quoting both entries and naming both records.]

   **Recommendation:** [One change that removes it.]

4. Assess conflicts as `conflicts` does, against the catalogs as they would be after acceptance. With none, show `None`. When any exist, add: You can accept this proposal with these conflicts and resolve them afterward.
5. List each capability `current` marked new under New Realized Capabilities. With none, show `None`.
6. Emit this proposal, then the closing question and the cancel line.

- `edit`: emit one consequence sentence. Re-emit this proposal with the change and without the starting-point line. Stay on `platform proposal`.
- `accept`: write the whole file from `.highway/library/templates/output/codify-platforms.md`, changing only this row. An add appends it, an update replaces it, and a remove drops it. Create `library/coding-standards/` when it is absent. A failed write leaves the file unchanged. Say what failed and stay. After a write, when the proposal listed new realized capabilities, emit: Let's record the new capabilities for [Platform]. Follow `highway-implementation` for [RI id], with those capabilities and the return step `platform written` in `highway-codify-config`. Otherwise go to `platform written`.
- `question`: answer, then re-emit this proposal.
- `unknown`: re-emit this proposal.
- `decline`: go to `menu`.

### platform written

1. When the accepted proposal listed conflicts, ask **Would you like help resolving these conflicts?** `accept` goes to `conflicts`. `question` answers, then asks again. `unknown` asks again.
2. Otherwise, when the platform works with code or configuration files, ask **Would you like to configure coding standards for [Platform]?** `accept` goes to `standards` with [Platform] as the standard to add or update. `question` answers, then asks again. `unknown` asks again.
3. Otherwise, or after `decline`, go to `platforms`.

### standards

Read `library/coding-standards/coding-standards.md` when present. Emit one item per row, in file order.

1. **[Standard Title]:** [Summary]
   - **File Patterns:** [File Patterns]
   - **When to use:**
     1. [Entry]
   - **When not to use:**
     1. [Entry]
   - **Inherits From:**
     1. [Standard Title]

When the file is absent or has no rows, say no coding standard is listed yet.

**What would you add, correct, or remove?**

If you'd like to cancel, just say so.

- A language or platform to add, or a listed standard to correct: go to `current`, then `standard proposal`, as an update when it has a row and as an add otherwise.
- A listed standard to remove: go to `standard proposal` as a remove.
- A standard to correct or remove that has no row: say it is not listed. Re-emit this list and question.
- `question`: answer, then re-emit this list and question.
- `unknown`: re-emit this list and question.
- `decline`: go to `menu`.

### standard rules

1. When no standard file exists, suggest at most fifteen rules from the documentation `current` read. Use the file and folder structure that documentation recommends.
2. Otherwise start from the standard file after `current`, including a standard re-added after removal.
3. Follow `rule shape`, then write the rules it returned. When the suggestions exceed fifteen, keep the credentials rule, leave out the later suggestions, and name each left-out suggestion in the consequence sentence that opens the proposal. Do not leave out a rule the person provided.
4. For a platform standard, inherit from the language standards its files use.
5. Include one rule, once, that keeps encoded or encrypted credentials outside this standard's files. When the documentation names a supported way to encrypt or store them, require that way in its own rule. Both follow `rule shape`. When it names none, name no product.
6. When fifteen suggestions lack the credentials rule, leave out the last suggestion the documentation no longer describes, or the last suggestion when all are still described. Name it in the consequence sentence that opens the proposal. Do not leave out a rule the person provided.
7. Write every structure path relative to the automation folder. Fill a placeholder in angle brackets, such as `<module>`, for each automation.
8. Cover only this standard's own files in the structure. Leave a component the platform calls, such as a module, to its own standard.
9. Return to `standard proposal`.

### rule shape

1. Write one rule with must once, one condition, and one outcome, in eight words or fewer. Count a path, a hyphenated word, and a placeholder as one word.
2. A second outcome joined by and, or, or a comma is a separate rule. A slash that is part of a path stays inside that one word.
3. When a rule the person provides, or a saved rule, lacks must, has more than eight words, or combines rules, rewrite it to conform before the proposal is presented. State that rewrite in the consequence sentence that opens the proposal. Keep a saved rule that conforms.
4. Under each rule, emit **Why it matters:** and one sentence stating the consequence of that rule. Name no customer, product, or decision of this organization. The catalog view, a conflict quote, and the saved cell keep the rule only.
5. Return to `standard rules`.

### standard proposal

1. For an add or update, follow `standard rules`.
2. For an add or update, follow `use entries`.
3. For a remove, show the current values. Do not run `current`, `standard rules`, or `use entries`.
4. Fill this proposal.

[One sentence stating the consequence of this change.]

[On an add or update with no edit yet: **Here is a proposed starting point for the [Language or platform] coding standards**]

**Standard Title:** [Language or platform] Coding Standard

**Technology:** [Language or platform]

**File Patterns:** [`*.ext`, `*.ext`]

**File and Folder Structure:**
1. `[relative path]`

**Coding Standards:**
1. [Rule]

   **Why it matters:** [One sentence stating the consequence of this rule.]

**Tests:** [required. One sentence on how tests are written. Test path: `[relative path]`. Or: not required.]

**When to use:**
1. [Entry]

   **Why it matters:** [One sentence stating the consequence of this entry.]

**When not to use:**
1. [Entry]

   **Why it matters:** [One sentence stating the consequence of this entry.]

**Inherits From:**
1. [Standard Title]

**Conflicts:**
1. **[Conflict]:** [Description quoting both entries and naming both records.]

   **Recommendation:** [One change that removes it.]

5. Assess conflicts as `conflicts` does, against the catalogs as they would be after acceptance. With none, show `None`. When any exist, add: You can accept this proposal with these conflicts and resolve them afterward.
6. For a remove, open the proposal with a consequence sentence saying `[Standard Path]` remains and is no longer used. List in Conflicts each standard whose Inherits From names it.
7. Emit this proposal, then the closing question and the cancel line.

- `edit`: emit one consequence sentence. Re-emit this proposal with the change and without the starting-point line. Stay on `standard proposal`.
- `accept` on an add or update: go to `standard write`.
- `accept` on a remove: write the catalog without this row. Keep the standard file. Then go to `standard write` step 3.
- `question`: answer, then re-emit this proposal.
- `unknown`: re-emit this proposal.
- `decline`: go to `menu`.

### standard write

1. Check the accepted proposal. When a check fails, say its sentence, write nothing, and return to `standard proposal`.
   - The structure has no path: `A file and folder structure is needed.`
   - A path begins with `/` or `code/`: `Paths are relative to the automation folder.`
   - Tests are required and the test path is not in the structure: `The test path must be part of the file and folder structure.`
2. Write the standard file from `.highway/library/templates/output/coding-standard.md` at its Standard Path, creating `library/coding-standards/` when it is absent. A new Standard Path is `library/coding-standards/[technology in lowercase, with hyphens].md`. Then write `library/coding-standards/coding-standards.md` from `.highway/library/templates/output/coding-standards-catalog.md`, changing only this row. When the catalog is absent, create it with this row only. When the standard file write fails, write no catalog. Say what failed and return to `standard proposal`.
3. When the proposal listed conflicts, ask **Would you like help resolving these conflicts?** `accept` goes to `conflicts`. `question` answers, then asks again. `unknown` asks again. `decline` states the consequence of the accepted change in one sentence and goes to `menu`. Otherwise state the consequence of the accepted change in one sentence and go to `menu`.

### conflicts

1. Read both catalogs.
2. Assess platforms first, then standards, each in catalog order. Judge overlap by meaning, not exact wording. A conflict is:
   - Two platforms whose When to use entries overlap.
   - One platform or standard with a When to use entry whose meaning also appears in its When not to use.
   - Two standards whose File Patterns overlap and whose When to use entries overlap, when neither inherits from the other.
   - Two standards whose structures name the same relative path, when neither inherits from the other.
   - An Inherits From title that no row lists.
   - A standard that inherits from itself through any chain.
3. When none exist, emit `Highway found no conflicts between your platforms and coding standards.` Then ask **What inconsistencies have you noticed?** Assess what the person describes against the catalogs, then re-emit this step.
4. Otherwise quote both entries and name both records in each description. Emit each conflict as an ordered list item, then the question and the cancel line.

1. **[Conflict]:** [Description.]

   **Recommendation:** [One change that removes it.]

**Which conflict would you like to resolve?**

If you'd like to cancel, just say so.

- `select`: go to `resolve` for that conflict.
- `question`: answer, then re-emit this list and question.
- `unknown`: re-emit this list and question.
- `decline`: go to `menu`.

### resolve

1. Propose the fewest changes that remove the selected conflict, starting from its recommendation.
2. List each record once, in bold, with a lettered list of its changes.
3. Fill this proposal.

[One sentence stating the consequence of these changes.]

1. **[Standard Title or Platform]**
   a. [One change to one field.]
   b. [Another change.]

4. Emit this proposal, then the closing question and the cancel line.

- `edit`: emit one consequence sentence. Re-emit this proposal with the change. Stay on `resolve`.
- `accept`: write only these changes, each catalog from its template. A failed write leaves that catalog unchanged. Say what failed and stay. After a write, reassess and go to `conflicts`.
- `question`: answer, then re-emit this proposal.
- `unknown`: re-emit this proposal.
- `decline`: go to `menu`.

## Verification

- `/highway-codify-config` shows the three-option menu. A platform name skips the menu and the platform list, and opens that platform's add or update or the onboard question.
- `Classify` tests `edit`, `decline`, `question`, `select`, `unknown`, then `accept`, and the first match wins.
- Each yes or no question answers a `question` and asks again, asks again after `unknown`, and names where `decline` goes.
- A return step named by `highway-onboarding` or `highway-implementation` is held for the visit. Declining the menu goes to that step. With none held, declining the menu stops.
- Picking an option and every edit begin with one consequence sentence.
- Platforms and coding standards views show each catalog with list fields as ordered lists, and ask what to add, correct, or remove.
- Every proposal shows its fields as bold labels, list fields as ordered lists, then Conflicts, and ends with **What would you add or correct?** and the cancel line.
- A platform is added only from an accepted implementation. Any other name offers onboarding, which ends by pointing back here.
- Accepting a platform writes only its row. Accepting a standard writes its file, then its row. Removing a standard keeps its file.
- A standard proposal shows its File and Folder Structure as relative paths. Accepting one with no path, a path beginning with `/` or `code/`, or a required test path outside the structure writes nothing and says what is needed.
- No coding standard is seeded. The first accepted standard creates the catalog with its row.
- Conflicts quote both entries and name both records. With none, the person is asked what inconsistencies they noticed.
- A resolution lists each record in bold with lettered changes, writes only those changes, and returns to the reassessed list.
- A cancel writes nothing and returns to the menu.
- `current` is read before an add or update, and a removal does not run it.
- On an add, `entry level` proposes one to four classes of automation for each of When to use and When not to use, from what `current` describes, and no task. `use entries` writes each as one condition or one outcome in five words or fewer, and keeps saved entries on an update. Each proposal entry has a blank line, then **Why it matters:** stating its consequence, and the saved catalog does not keep that line.
- An add or update proposal with no edit yet, for a platform or a standard, shows the starting-point line after the consequence sentence. An edited proposal and a remove do not.
- A standard add or update follows `standard rules`, then `use entries`. A remove runs neither.
- `current` groups the automation capabilities the platform documentation describes by meaning. Each group the implementation does not already mean appears once under New Realized Capabilities, titled under the capability catalog Title rule, with the product and the handoff in the evidence. After the write, configuration follows `highway-implementation` to record them, with the return step `platform written`.
- Each coding rule is one must, one condition, and one outcome in eight words or fewer. The model suggests at most fifteen, and one keeps encoded or encrypted credentials outside the files. A provided rule that does not conform is rewritten, and the opening consequence sentence names the rewrite. Each rule shows **Why it matters:** on the proposal only.
- A standard write with no conflicts states one consequence sentence and returns to the menu.

## Error Handling

- A missing `.highway/` root stops the skill and writes nothing.
- A missing template stops the change, names the template path, and writes nothing.
- A failed write leaves the existing file unchanged and keeps the proposal open.
- A failed standard file write writes no catalog row.
- A standard with no structure path, a path that is not relative, or a required test path outside the structure writes nothing and keeps the proposal open.
- A name that is not an accepted implementation is not added and offers onboarding.

## Example

Illustrative.

`/highway-codify-config`
