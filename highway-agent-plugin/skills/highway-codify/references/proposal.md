# Proposal

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

[Standard Title] has no file and folder structure. To add one, run highway-codify-config.

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
A title not in the coding standards catalog is left out, and the rest of the list is kept. Say: [Title] is not a listed coding standard. To add it, run highway-codify-config.
A second action is removed. Say it waits for another run.
The person can switch to another accepted architecture by title. An architecture that is not accepted is not added.
A preparation-only request stays one self-service action.
Removing the last task or the last acceptance criterion says at least one is needed.
An edit that changes the proposed project uses that folder. Say a removed product's folder is taken.
An edit that would break a listed Control or NFR is not applied. Say: [Title] stays in effect. To change a Control, run highway-controls. To change an NFR, run highway-nfrs. Then re-emit the proposal and stay on `revise`.
- `accept`: go to `identifier` when the proposal has one action, a Provider or a Language standard, at least one task, at least one acceptance criterion, and an accepted architecture. Otherwise stay on `revise`.
- `unknown`: re-emit the proposal. Stay on `revise`.
- `question`: answer, then re-emit the proposal. Stay on `revise`.
- `decline`: stop. Write nothing.

## Verification

- The proposal shows **Proposed project:** as `New <folder>` or `Existing <folder>`, then **Rationale:**. Its first sentence is plain language. A standard or integration is cited only when it replaced the decision.
- Before any proposal, coding standards are checked first and vendor documentation second. Corrections and inconclusive results are named before the proposal and are not saved. The checks keep the selected action.
- A standard that cannot be met for the selected action shows no proposal and returns to suggestions.
- The proposal shows Title, Summary, Description, Acceptance criteria, Diagram, and Tasks, in that order. It shows no components, current state, separate action, day, or means.
- The diagram is one logical flow, top to bottom, from the Provider. Each arrow leaves the Provider, is one task's action, starts with a verb, and points to that task's target, in task order. No arrow leaves a target.
- Every task names the same Provider, the platform executing the automation. The implementation being automated is a target. A Shopify proposal can use Cursor when Cursor is included, even though the Shopify records do not name it.
- A named platform with no catalog row stays the Provider and the proposal says `highway-codify-config` can add it. With no row and no named platform, the proposal says a platform is needed and accept stays on `revise`.
- A code project's Establish proposes the project structure, the build file, the entry point, the configuration, and a health check, plus pipeline tasks when Deployed by is a pipeline. A code task shows Language in place of Provider. The Executor is Deployed by.
- Each task shows Standards as an ordered list, or `No coding standard applies.` A standard whose When not to use matches is dropped. A standard comes before the standards it inherits from, and each inherited standard appears once.
- A Standards edit re-emits the proposal with one consequence sentence. A title not in the catalog is left out and points to `highway-codify-config`.
- `align` corrects the method, library, module, or pattern against every standard on the task's list and keeps the Provider.
- Each task is one action against one target and shows Scope, Provider, Method, Standards, Files, and Assumptions.
- Files lists relative paths placed from the File and Folder Structure of the task's standards. A listed standard with no structure is named before the proposal with a pointer to `highway-codify-config`. A Files edit changes only this automation. An unfilled placeholder keeps the proposal open.
- A second action waits for another run. Declining writes nothing. Accepting is the only confirmation.
- The proposal heading is `Here is a proposed starting point for your codify feature:`. `Highway will use this specification to build out the solution.` follows `If this is accurate, just say so.`
