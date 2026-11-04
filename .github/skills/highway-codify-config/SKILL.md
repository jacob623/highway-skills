---
name: highway-codify-config
description: "Manages the repository-wide guidance used by highway-codify."
usage: "Invoke as /highway-codify-config, or with one implementation name."
compatibility: all
metadata:
  version: 3.0.0
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
- `highway-onboarding`.
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

On a platform proposal and a standard proposal, each When to use entry and each When not to use entry is one sentence that names a condition and the required outcome. The next line is **Why it matters:** and one sentence. The entry does not say should, consider, prefer, usually, or where appropriate. The catalog view, a conflict quote, and the saved cell keep the rule only.

Picking a menu option, and every `edit`, begins with one sentence that states its consequence. Every proposal ends with:

**What would you add or correct?**

If you'd like to cancel, just say so.

A cancel writes nothing and returns to `menu`.

### Entry

1. When `.highway/` cannot be found, stop. Say the project root cannot be located. Write nothing.
2. When the invocation names a platform, go to `platforms` with that name as an add or update. Do not show the menu.
3. Otherwise go to `menu`.

### Classify

Classify the latest reply before any other action.

- `select`: names a listed option, conflict, platform, or standard by number or title.
- `edit`: adds, removes, corrects, or replaces proposal text, or names a record to add, correct, or remove.
- `accept`: affirms the proposal or answers yes, and adds no fact.
- `unknown`: the person says they do not know.
- `question`: asks for an explanation.
- `decline`: answers no, stops, or cancels.

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
- `decline`: stop. Write nothing.

### platforms

Read `library/coding-standards/codify-platforms.md` when present. Emit one item per row, in file order. Do not use an id as the label.

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
  - `decline`: re-emit this list and question.
- A listed platform to remove: go to `platform proposal` as a remove.
- A name to correct or remove that has no row: say it is not included. Re-emit this list and question.
- `question`: answer, then re-emit this list and question.
- `unknown`: re-emit this list and question.
- `decline`: go to `menu`.

### current

Read the technology's current public documentation. Write nothing.

A capability the documentation describes is captured. A capability it no longer describes is not proposed. For a platform, a documented capability is proposed only when the accepted implementation realizes it.

When the documentation cannot be read, say: The current documentation could not be read. Add no capability as current. Continue from the accepted implementation and the catalogs already present.

Then go to the proposal named with this step.

### platform proposal

Ground When to use and When not to use in `current`, the implementation's Technology Choice, Runtime Components, and Realized Capabilities, and the other platform rows. An update starts from the current values after `current`. A remove shows the current values and does not run `current`.

[One sentence stating the consequence of this change.]

**Platform:** [Platform]

**Implementation ID:** [RI id]

**When to use:**
1. [Entry]

**When not to use:**
1. [Entry]

**Consequences:**
- **[Consequence]:** [What changes for the automations highway proposes.]

**Conflicts:**
1. **[Conflict]:** [Description quoting both entries and naming both records.] Recommendation: [One change that removes it.]

Assess conflicts as `conflicts` does, against the catalogs as they would be after acceptance. With none, show `None`. When any exist, add: You can accept this proposal with these conflicts and resolve them afterward.

Then emit the closing question and the cancel line.

- `edit`: emit one consequence sentence. Re-emit this proposal with the change. Stay on `platform proposal`.
- `accept`: write the whole file from `.highway/library/templates/output/codify-platforms.md`, changing only this row. An add appends it, an update replaces it, and a remove drops it. Create `library/coding-standards/` when it is absent. A failed write leaves the file unchanged. Say what failed and stay. After a write:
  1. When the proposal listed conflicts, ask **Would you like help resolving these conflicts?** `accept` goes to `conflicts`.
  2. Otherwise, when the platform works with code or configuration files, ask **Would you like to configure coding standards for [Platform]?** `accept` goes to `standards` with [Platform] as the standard to add or update.
  3. Otherwise, or after `decline`, go to `platforms`.
- `question`: answer, then re-emit this proposal.
- `unknown`: re-emit this proposal.
- `decline`: go to `menu`.

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

### standard proposal

When no standard file exists, propose at most ten rules from the documentation `current` read. Each rule contains the word must and names a condition and the required outcome. Use the file and folder structure that documentation recommends. Otherwise start from the standard file after `current`, including a standard re-added after removal. A platform standard inherits from the language standards its files use. A remove shows the current values and does not run `current`. One rule keeps encoded or encrypted credentials outside this standard's files. When the documentation names a supported way to encrypt or store them, the rule requires that way. When it names none, the rule names no product. Include it once. When ten current rules lack it, leave out the last rule the documentation no longer describes, or the last rule when all are still described, and name it in Consequences.

Every structure path is relative to the automation folder. A placeholder in angle brackets, such as `<module>`, is filled for each automation. The structure covers only this standard's own files. A component the platform calls, such as a module, keeps its own standard.

[One sentence stating the consequence of this change.]

**Standard Title:** [Language or platform] Coding Standard

**Technology:** [Language or platform]

**File Patterns:** [`*.ext`, `*.ext`]

**File and Folder Structure:**
1. `[relative path]`

**Coding Standards:**
1. [Rule]

**Tests:** [required. One sentence on how tests are written. Test path: `[relative path]`. Or: not required.]

**When to use:**
1. [Entry]

**When not to use:**
1. [Entry]

**Inherits From:**
1. [Standard Title]

**Consequences:**
- **[Consequence]:** [What changes for the files highway codes.]

**Conflicts:**
1. **[Conflict]:** [Description quoting both entries and naming both records.] Recommendation: [One change that removes it.]

Assess conflicts as `platform proposal` does. A remove's Consequences say `[Standard Path]` remains and is no longer used. Its Conflicts list each standard whose Inherits From names it.

Then emit the closing question and the cancel line.

- `edit`: emit one consequence sentence. Re-emit this proposal with the change. Stay on `standard proposal`.
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
3. When the proposal listed conflicts, ask **Would you like help resolving these conflicts?** `accept` goes to `conflicts`. Otherwise state the consequence of the accepted change in one sentence and go to `menu`.

### conflicts

Read both catalogs. Judge overlap by meaning, not exact wording. Assess platforms first, then standards, each in catalog order. A conflict is:

- Two platforms whose When to use entries overlap.
- One platform or standard with a When to use entry whose meaning also appears in its When not to use.
- Two standards whose File Patterns overlap and whose When to use entries overlap, when neither inherits from the other.
- Two standards whose structures name the same relative path, when neither inherits from the other.
- An Inherits From title that no row lists.
- A standard that inherits from itself through any chain.

Each description quotes both entries and names both records. Emit each conflict as an ordered list item.

1. **[Conflict]:** [Description.] Recommendation: [One change that removes it.]

**Which conflict would you like to resolve?**

If you'd like to cancel, just say so.

When none exist, emit `Highway found no conflicts between your platforms and coding standards.` Then ask **What inconsistencies have you noticed?** Assess what the person describes against the catalogs, then re-emit this step.

- `select`: go to `resolve` for that conflict.
- `question`: answer, then re-emit this list and question.
- `unknown`: re-emit this list and question.
- `decline`: go to `menu`.

### resolve

Propose the fewest changes that remove the selected conflict, starting from its recommendation. Each record appears once, in bold, with a lettered list of its changes.

[One sentence stating the consequence of these changes.]

1. **[Standard Title or Platform]**
   a. [One change to one field.]
   b. [Another change.]

Then emit the closing question and the cancel line.

- `edit`: emit one consequence sentence. Re-emit this proposal with the change. Stay on `resolve`.
- `accept`: write only these changes, each catalog from its template. A failed write leaves that catalog unchanged. Say what failed and stay. After a write, reassess and go to `conflicts`.
- `question`: answer, then re-emit this proposal.
- `unknown`: re-emit this proposal.
- `decline`: go to `menu`.

## Verification

- `/highway-codify-config` shows the three-option menu. A platform name skips the menu and opens that platform's add or update.
- Picking an option and every edit begin with one consequence sentence.
- Platforms and coding standards views show each catalog with list fields as ordered lists, and ask what to add, correct, or remove.
- Every proposal shows its fields as bold labels, list fields as ordered lists, then Consequences and Conflicts, and ends with **What would you add or correct?** and the cancel line.
- A platform is added only from an accepted implementation. Any other name offers onboarding, which ends by pointing back here.
- Accepting a platform writes only its row. Accepting a standard writes its file, then its row. Removing a standard keeps its file.
- A standard proposal shows its File and Folder Structure as relative paths. Accepting one with no path, a path beginning with `/` or `code/`, or a required test path outside the structure writes nothing and says what is needed.
- No coding standard is seeded. The first accepted standard creates the catalog with its row.
- Conflicts quote both entries and name both records. With none, the person is asked what inconsistencies they noticed.
- A resolution lists each record in bold with lettered changes, writes only those changes, and returns to the reassessed list.
- A cancel writes nothing and returns to the menu.
- `current` is read before an add or update, and a removal does not run it.
- A proposal use entry is one sentence, with **Why it matters:** on the next line, and the saved catalog does not keep that line.
- Each coding rule contains the word must, and one rule keeps encoded or encrypted credentials outside the files.
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
