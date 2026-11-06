# Contract: highway-codify-config 3.2.2 steps

Step order: `current`, `entry level`, `use entries`, `platform proposal`. Every other step keeps its 3.2.1 position.

## entry level

```markdown
1. Propose each entry as a class of automation for the type `use entries` took. A class names what the type is for.
2. Propose a class only when `current` describes it for this type. When `current` describes none, or could not read the documentation, propose one When to use class and one When not to use class at the level of steps 3 and 4.
3. For an agent, propose from classes such as Agentic automation, Local machine execution, Human in the loop, MCP integration, Sensitive data handling, and Autonomous automation.
4. For a pipeline, propose from classes such as Continuous integration, Continuous delivery, File-based triggers, and Workflow orchestration.
5. For a coding standard, and for any other type, propose classes at the level of steps 3 and 4.
6. A task is not an entry. Code change proposals, Pull request review, Bug investigation, and Test authoring are tasks.
7. Propose at most four When to use entries and at most four When not to use entries.
8. Take no class from this organization's customers, products, data, or decisions.
9. Return to `use entries`.
```

## use entries

Steps 1, 3, 5, 6, 8, and 10 keep their 3.2.1 text. Steps 2, 4, 7, and 9:

```markdown
2. On an add, follow `entry level`, then write the entries it returned. On an update, start from the saved entries. Do not follow `entry level`.
4. Write each entry as one condition or one outcome, in five words or fewer. Count a hyphenated term as one word.
7. On an update, keep each saved entry. Rewrite a saved entry that breaks step 4 or step 5, and state the rewrite in its **Why it matters:** sentence.
9. Under each entry, emit **Why it matters:** and one sentence stating the consequence of that entry for the work Highway proposes. Name no customer, product, or decision of this organization. The catalog view, a conflict quote, and the saved cell keep the entry only.
```

## Proposal shapes

`platform proposal` and `standard proposal`, When to use and When not to use:

```markdown
**When to use:**
1. [Entry]

   **Why it matters:** [One sentence stating the consequence of this entry.]

**When not to use:**
1. [Entry]

   **Why it matters:** [One sentence stating the consequence of this entry.]
```

Neither shape has a **Consequences:** section. **Conflicts:** follows the field before it.

## standard rules step 6

```markdown
6. When ten current rules lack the credentials rule, leave out the last rule the documentation no longer describes, or the last rule when all are still described. Name it in the consequence sentence that opens the proposal.
```

## standard proposal step 6

```markdown
6. For a remove, open the proposal with a consequence sentence saying `[Standard Path]` remains and is no longer used. List in Conflicts each standard whose Inherits From names it.
```

## Verification

```markdown
- Every proposal shows its fields as bold labels, list fields as ordered lists, then Conflicts, and ends with **What would you add or correct?** and the cancel line.
- On an add, `entry level` proposes one to four classes of automation for each of When to use and When not to use, from what `current` describes, and no task. `use entries` writes each as one condition or one outcome in five words or fewer, and keeps saved entries on an update. Each proposal entry has a blank line, then **Why it matters:** stating its consequence, and the saved catalog does not keep that line.
```

## Rejected text

- `**Consequences:**`
- `Name it in Consequences.`
- `Name each rewrite in Consequences.`
- `say in Consequences that`
- `such as Workflow orchestration, Web Service, Application Front-End, Desired State Configuration Management, GitOps, or Code Deployment`
- `Relate each entry to automation capabilities.`
