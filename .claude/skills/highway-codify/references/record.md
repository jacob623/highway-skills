# Record

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

For a new product, write `code/<folder>/.highway/metadata.md` from `assets/codify-metadata.md`. A joined product keeps its file. Append this feature's row to its Features table.

The record is `code/<folder>/.highway/features/<number>-<action>/codify.md` and follows `assets/codify-record.md`.

- `id` is the product's `CDY` id.
- `implementation` is the accepted implementation id.
- `architecture` is the accepted architecture this automation follows.
- `status` is `accepted`.
- The title is the one action.
- Summary, Description, Acceptance Criteria, Diagram, Tasks, **Controls and NFRs:**, Conflicts, Proposed project, and Rationale are the accepted proposal text, in that order.

Do not write `codify-tasks.md` here. Go to `index`.

### index

Write these rows with the files in `write`. Edit `code/code.md` in its existing structure, under `index rules`. The first catalog version is `1.0.0`. Each change increments the minor version.

1. For a new product, write one row. Append the new row as the last row. ID is the `CDY` id. Folder is `code/<folder>`. Title and Summary come from `folder`. Status is `accepted`.
2. For a joined product, update its row in place. Add each implementation the proposal lists that Implementations lacks.
3. Apply the Features rule to this feature's entry.
4. When the accepted proposal includes an integration, edit `code/integrations.md` in its existing structure, under `index rules`, to add it. When an accepted row already has that From, To, and Kind, write no second row. Ask nothing more.

A row whose status changes keeps its position. Do not allocate from `Next ID`. More than one row may name the same Implementation ID. A removed row keeps its id and has no folder. Emit no timestamp, random value, or environment value. Do not change the implementation, its architecture, its decision, the request, the assessment finding, Controls, or NFRs.

On success, go to `plan` without asking a question.

### index rules

The catalog is `code/code.md`. It owns the baseline version and the product index. It has no `Next ID` field. The index columns are ID, Folder, Title, Summary, Implementations, Features, and Status.

Each ID appears once, and each row is one product. Rows are in acceptance order. A new row is appended as the last row. A new feature updates its product's row and adds no row. A row whose status changes keeps its position. The ID is `CDY` plus the eight hex digits derived from the product title. It is not the folder name. Status is `accepted` or `removed`.

Folder is `code/` plus the product title in lowercase words separated by hyphens, or the folder the person named. Each Folder appears once, including removed rows.

Summary is one sentence that says who the product is for and what it returns. Implementations lists the accepted implementation ids the product serves, separated by `; `. More than one row may name the same Implementation ID.

Features lists entries separated by `; `, in acceptance order. Each entry is `<number>-<action> | one sentence`. An entry is kept only when that feature starts the product, adds an implementation, records an integration, changes the summary, or is open. A finished feature that did none of those leaves the cell. Its directory remains.

`accepted` has a folder at its Folder path. `removed` has no folder. A removed row keeps its id and has no folder. A removed row stays in the index, keeps its Folder and recorded feature titles taken, and is not joined.

The integrations catalog is `code/integrations.md`. A row is written when the person accepts a proposal that includes that integration. No second acceptance is asked.

From and To are accepted implementation ids. Kind `composition` means the two implementations form one product, such as a frontend and its backend. Kind `capability` means From uses To as a feature of the product that serves From.

The same From, To, and Kind appears once. A proposal for a pair already accepted writes no second row. Rows are in acceptance order. A row whose status changes keeps its position. Status is `accepted` or `removed`.

A row records the connection only. It does not mean any feature is built.

### plan

Write `code/<folder>/.highway/features/<number>-<action>/plan.md` from `assets/codify-plan.md`. The plan holds one story per proposal task, so a review of it is the whole plan.

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

## Verification

- Each accepted action is the next numbered feature directory in its product, numbered from the last row of the Features table in `.highway/metadata.md`. No features folder is listed. Earlier directories stay.
- Each accepted feature adds one Features row with its number, folder, title, and Summary. A row is never removed.
- Accepting a proposal that includes an integration writes one row to `code/integrations.md`, and a pair already accepted writes none.
- A new row in `code/code.md` is appended as the last row.
- The menu offers Review the plan and Continue to code the solution. A feature with a plan and no task list resumes at the menu.
- Reviewing the plan reads every section, then asks **What would you add, correct, or remove?** and "If this is accurate, just say so." before the menu returns. Accepting emits the menu, and a change regenerates the plan and runs `check`. Continuing to code asks no review question.
- Each id is `CDY` plus eight hex digits derived from the product title. A joined product keeps its id.
- A taken id names the conflicting titles, says a title change is appropriate, and shows a new title. The write waits until the person accepts that title.
- That message does not mention identifiers, hex, sampling, or the catalog.
- A failed write leaves no partial folder and leaves existing catalog bytes unchanged.
