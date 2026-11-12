# Standards

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

When the file has no rows, say no coding standard is listed yet.

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
- `accept` on a remove: edit the catalog to drop this row. Keep the standard file. Then go to `standard write` step 3.
- `question`: answer, then re-emit this proposal.
- `unknown`: re-emit this proposal.
- `decline`: go to `menu`.

### standard write

The file is `library/coding-standards/coding-standards.md`. Standard Title names the language, such as Java or YAML, or the platform, such as Kubernetes or Terraform, followed by `Coding Standard`.

When to use, When not to use, and Inherits From each hold a list. Entries are separated by `; `. An empty list is a blank cell. Inherits From names the Standard Titles a standard builds on. A proposal presents each list as an ordered list, one entry per item.

Removing a row leaves its standard file in place. A standard file that no row names is not used.

1. Check the accepted proposal. When a check fails, say its sentence, write nothing, and return to `standard proposal`.
   - The structure has no path: `A file and folder structure is needed.`
   - A path begins with `/` or `code/`: `Paths are relative to the automation folder.`
   - Tests are required and the test path is not in the structure: `The test path must be part of the file and folder structure.`
2. Write the standard file from `assets/coding-standard.md` at its Standard Path. A new Standard Path is `library/coding-standards/[technology in lowercase, with hyphens].md`. Then edit `library/coding-standards/coding-standards.md` in its existing structure, changing only this row. When the standard file write fails, write no catalog. Say what failed and return to `standard proposal`.
3. When the proposal listed conflicts, ask **Would you like help resolving these conflicts?** `accept` goes to `conflicts`. `question` answers, then asks again. `unknown` asks again. `decline` states the consequence of the accepted change in one sentence and goes to `menu`. Otherwise state the consequence of the accepted change in one sentence and go to `menu`.

## Verification

- A standard proposal shows its File and Folder Structure as relative paths. Accepting one with no path, a path beginning with `/` or `code/`, or a required test path outside the structure writes nothing and says what is needed.
- No coding standard is seeded. The first accepted standard adds its row to the seeded catalog.
- A standard add or update follows `standard rules`, then `use entries`. A remove runs neither.
- Each coding rule is one must, one condition, and one outcome in eight words or fewer. The model suggests at most fifteen, and one keeps encoded or encrypted credentials outside the files. A provided rule that does not conform is rewritten, and the opening consequence sentence names the rewrite. Each rule shows **Why it matters:** on the proposal only.
- A standard write with no conflicts states one consequence sentence and returns to the menu.
