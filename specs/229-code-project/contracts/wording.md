# Wording Contract: Code Project

## highway-codify

### Purpose (replaced)

Suggests actions worth automating for one accepted implementation, checks the chosen action against the organization's coding standards and current vendor documentation, writes the task-by-task proposal the person accepts, and codes it from a task list that follows those standards, writing the product's own code when the implementation names a Language.

### Procedure order (replaced clause)

Old: `` `choose` when no implementation is named; `rank`, with `codified`, when no action is named; then `suggest`, `draft`, `provider`, `platforms needed` when needed, `standards`, ``

New: `` `choose` when no implementation is named; `record check`; `code project` for a code project, or `rank`, with `codified`, when no action is named; then `suggest`, `draft`, `code tasks` for a code project, `provider`, `standards`, ``

### Entry step 8 (replaced)

8. After a selection, go to `record check`.

### choose (replaced sentence)

A number, a title, or a description selects one. Show the title. Go to `record check`.

### record check (new, after `choose`)

```
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
```

### codified (replaced last sentence)

Old: Return to `rank`.

New: Return to the step that named this one.

### code project (new, after `codified`)

```
The product is a code project when the selected implementation's Language names a coding standard. That standard is the Language standard. Read `code/code.md` when present. Write nothing.

1. An Establish feature is recorded when an accepted row lists this implementation and a Features entry's `<action>` starts with `establish`.
2. With none recorded, the only suggestion is `Establish [implementation title]`, even when an instance is running. Its summary is: Starts the [Language standard] code for [implementation title]. When another action is selected or named, say Establish comes first. Go to `suggest`.
3. With one recorded, go to `draft` when an action is selected or the invocation named one.
4. Otherwise take one suggestion per item, in this order: each Realized Capability, each Realized Interface, each Coverage row marked covered, then each NFR Realization item.
5. Each title is a change to the product code. It starts with a verb and names what it changes. Its summary is one sentence grounded in that item.
6. Follow `codified`. Keep at most five. Drop items from the end. Go to `suggest`.
```

### draft (new line before `Go to `provider`.`)

For a code project, follow `code tasks`.

### code tasks (new, after `draft`)

```
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
```

### provider (replaced steps)

```
1. The Executor is Deployed by when the action is establishing or the product is a code project. Otherwise the Executor is Managed by.
2. When the Executor names a platform with no row, go to `record check`. Do not show the proposal. Write nothing.
3. Do not copy the Executor onto a task's Provider.
4. Do not take this implementation's row or the first catalog row.
```

### platforms needed

Removed.

### Pointer sentences

- `standards`, before `Go to `align`.`: For a code project, `code tasks` decides a code task's list.
- `join`, before `Use the first of steps 2 to 6`: When this implementation, or an implementation a product lists, is a code project, `code tasks` decides the join.
- `folder`, after the new product title sentence: For a code project, `code tasks` decides the title.
- `layout` step 3, appended: For a code project, `code tasks` decides the folders.
- `propose`, after the diagram paragraph: For a code project, `code tasks` decides the diagram and the **Language:** line.
- `code`, after the README paragraph: For a code project, `code tasks` decides both parts.
- `close`, after its first line: For a code project, `code tasks` decides the not-run line.

### revise accept (replaced clause)

Old: `a Provider, at least one task`

New: `a Provider or a Language standard, at least one task`

### Verification (replaced)

Old bullets "An Executor that is `Needed`…", "A yes to that message…", and "A platform named at that message…" are replaced by:

- After a selection, a record whose Deployed by or Managed by is `Needed`, empty, or has no row, or whose Language is `Needed`, empty, or has no row, emits the missing critical detail line and "Let's set those details now for [Product Title].", then follows `highway-implementation` with the return step `record check`. It asks no question and holds no platform for one run.
- A return with the record still incomplete stops and writes nothing.
- An implementation whose Language names a coding standard is a code project. Until an Establish feature is recorded, `Establish [implementation title]` is the only suggestion, even when an instance is running. Later suggestions come from Realized Capabilities, Realized Interfaces, covered Coverage rows, then NFR Realization, at most five.
- A code project's Establish proposes the project structure, the build file, the entry point, the configuration, and a health check, plus pipeline tasks when Deployed by is a pipeline. A code task shows Language in place of Provider. The Executor is Deployed by.
- A code project's product is titled from the implementation, lists only that implementation, and its close says the code was not run.

## highway-implementation

### Procedure clause (replaced)

Old: `` `delivery platforms` when `highway-codify` hands off an accepted implementation; ``

New: `` `delivery platforms`, with `delivery decline`, when `highway-codify` hands off an accepted implementation; ``

### delivery platforms step 3 (replaced sentence)

Old: Language is unset when `None` or empty.

New: Language is unset when `Needed`, empty, or naming a standard with no row.

### delivery platforms view (replaced)

```
**Here is the proposed Deployed by, Managed by and Language for [Product Title]**

**Product Title:** [Title]

**Architecture Reference:** [RA id] — [Architecture title]

**Deployed by:** [Platform. Or: Needed.]

**Why it matters:** [highway-codify will use [codify platform] to get [Product title] up and running. Or, when Needed: highway-codify needs a codify platform to get [Product title] up and running.]

**Managed by:** [Platform. Or: Needed.]

**Why it matters:** [highway-codify will use [codify platform] for managing [Product title] once its running. Or, when Needed: highway-codify needs a codify platform for managing [Product title] once its running.]

**Language:** [Standard Title. Or: None.]

**Why it matters:** [highway-codify will treat [Product title] as a [Language] coding project. Or, when None: highway-codify will treat this as a Platform to manage as opposed to a coding project to write.]
```

### why it matters (follow-up, version 7.9.0)

The three Why it matters lines move to a new `### why it matters` step after `### field`, one bullet per case. `start` and the `delivery platforms` view each show `**Why it matters:** [From `why it matters`.]` under Deployed by, Managed by, and Language.

### delivery platforms replies (replaced)

- `accept`: when Deployed by, Managed by, or Language is Needed, name that field and re-emit this view. (rest unchanged)
- `decline`: go to `delivery decline`.

### delivery decline (new, after `delivery platforms`)

```
Write nothing. Emit:

Leaving the preferred delivery platforms for [Title] unset. highway-codify needs these details before it can make proposals for [Title].

**Would you like to return and provide these details now?**

- A yes: re-emit the `delivery platforms` view.
- A no, or `decline`: go to the held step.
- `question`: answer, then re-emit this question.
- `unknown`: re-emit this question.
```

### Verification (replaced)

- An invocation from `highway-codify` naming an accepted implementation and a return step goes to `delivery platforms`. It opens with "Here is the proposed Deployed by, Managed by and Language for [Product Title]", then shows Product Title, Architecture Reference, Deployed by, Managed by, and Language, each field followed by its Why it matters line. Accept stays on the view while a field is Needed. Acceptance rewrites only the three Execution lines, emits "The preferred delivery platforms for [Title] are set. Picking up your highway-codify run.", and goes to the held step.
- The delivery platforms view holds the record's fields, then the `execution` value for each unset one: Deployed by or Managed by that is `Needed`, empty, or has no row, and Language that is `Needed`, empty, or has no row. A stored `None` is shown as stored. A value the person named in the visit replaces it. This implementation's row is never a candidate.
- A decline writes nothing, emits "Leaving the preferred delivery platforms for [Title] unset. highway-codify needs these details before it can make proposals for [Title].", and asks whether to return. A yes shows the view again. A no goes to the held step.

## highway-onboarding

- Old: Its Execution is `Deployed by: Needed`, `Managed by: Needed`, and `Language: None`.
- New: Its Execution is `Deployed by: Needed`, `Managed by: Needed`, and `Language: Needed`.
- Removed: When the caller named the return step `provider` in `highway-codify`, go to that step after the platform row is written.
- Old Verification: An onboarded implementation stores Deployed by and Managed by as `Needed` and Language as `None`.
- New Verification: An onboarded implementation stores Deployed by, Managed by, and Language as `Needed`.

## Templates

- `implementation-record.md`: `Language: <Standard Title or None>` becomes `Language: <Standard Title, None, or Needed>`.
- `codify-record.md`, after the task paragraph: In a code project, a code task shows **Language:** with the Language standard in place of **Provider:**, and its target is the product.
- `codify-record.md`, after the diagram paragraph: In a code project, each code task's arrow points to the product.
- `codify-record.md`, after the Readme paragraph: In a code project, Setup Instructions say how to build, configure, and run the product, and User Guide says how to use its interfaces.
