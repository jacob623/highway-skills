# Contract: Product Steps

Skills stay imperative. They do not add the keywords MUST or SHOULD. `project` is the numbered step below. No step exceeds 400 words.

## Order

`suggest`, with `codified`, when no action is named; then `start`, `standards`, `align`, `project`, `layout`, `propose`, `revise`, `identifier`, `title` when needed, `write`, `index`, `code`, and `close`.

## `codified`

Replace the step that opens `codify.md`.

```markdown
Read the accepted rows of `code/code.md` whose Implementations include the selected implementation. Skip removed rows. With no catalog, leave nothing out. Do not open a product folder. Write nothing.

1. When a recorded feature's `<action>` is the same words, in the same order, as its title, compared without regard to case or hyphens, leave it out. Do not open that record.
2. Otherwise, when a feature sentence or the product Summary means this suggestion, leave it out.
3. Keep every other suggestion. An integration row does not leave a suggestion out.
```

## `project`

Insert before `layout`. 395 words.

```markdown
### project

Read the accepted rows of `code/code.md` and `code/integrations.md`. Skip removed rows. Do not open a product folder. Write nothing.

1. When the person named a folder, use it.
2. When a recorded feature's `<action>` is this action's title, compared without regard to case or hyphens, resume that feature. Go to `code` when it has an open task, or to `close` when every task is done.
3. When a feature sentence or a product Summary means this same action, join that product.
4. Read the matching coding standard. When one of its rules names where this action lives, that rule replaces the decision below.
5. For a composition row, when only one side has a product, join that folder and list both implementations.
6. For a composition row, when both sides have products, join the folder of the implementation being codified. Leave the other folder in place. List both implementations on the joined product.
7. For a composition row, when neither side has a product, start one folder and list both implementations.
8. For a capability row whose From is the selected implementation, join the product that lists From. Add To to its implementations.
9. When a product Summary means the same consumer and outcome and this action is new, join that folder.
10. Otherwise start a folder from the product title: lowercase words, hyphens.
11. When that folder is already a catalog path, say it is taken and ask for another name.

Stop at the first of steps 1 to 3 that applies. Otherwise use the first of steps 5 to 10 that fits, unless a rule read in step 4 replaced it. Step 11 applies to every new folder.

A new product's title names what it serves in at most four words, such as Worker. Its Summary is one sentence that says who it is for and what it returns. A joined product keeps its title and Summary.

When this action connects the selected implementation to another accepted implementation and no accepted row holds that pair, hold From, To, Kind, and one summary sentence. Accepting the proposal records it.

Hold **Proposed project:** `New <folder>` or `Existing <folder>`, then **Rationale:**. The first sentence says in plain words why this folder is the right home. When a standard or integration replaced the decision, cite it after that sentence. Name a pair held here. Go to `layout`.
```

## `propose`

Keep the diagram rules, including `No arrow leaves a target.` Add these two lines before **What would you add, correct, or remove?**:

```markdown
**Proposed project:** [From `project`.]

**Rationale:** [From `project`.]
```

Then go to `revise`.

## `revise`

Move the `edit`, `accept`, `unknown`, `question`, and `decline` lines here. Each edit stays its own line. A line that stayed on `propose` stays on `revise`. Add this line with the other edits:

```markdown
An edit that changes the proposed project uses that folder. Say a removed product's folder is taken.
```

The person's edit is what `write` uses. `accept` still goes to `identifier` when the proposal is complete.

## `write`

Write `code/<folder>/.highway/metadata.md` once, from `codify-metadata.md`. Write `code/<folder>/.highway/features/<number>-<action>/codify.md` and `codify-tasks.md`, together with the rows in `index`. Product files and the README stay at the folder root and are not written here. `write` stays at or under 250 words.

## `index`

The rows `write` writes with the files. Update `code/code.md`: append a new product as the last row, or update the joined product's row. Write a new integrations row only when that From, To, and Kind is not already accepted.

Add `<number>-<action> | one sentence` to Features only when the feature starts the product, adds an implementation, records an integration, changes the summary, or is open. When a finished feature did none of those, remove it from the cell and keep the directory.

## Templates

`codify-catalog.md` 3.0.0 columns: ID, Folder, Title, Summary, Implementations, Features, Status.

`codify-integrations.md` 1.0.0 columns: From, To, Kind, Summary, Status. The file is `code/integrations.md`.

`codify-metadata.md` 1.0.0 frontmatter field: `id`.

`codify-record.md` 8.0.0 includes **Proposed project:** and **Rationale:**.

`codify-tasks.md` 5.0.0: the list lives in the feature directory. `Files:` paths are relative to the product folder.
