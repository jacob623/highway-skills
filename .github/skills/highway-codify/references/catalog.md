# Catalog

### catalog

Read the accepted rows of `code/code.md`. Rows are in acceptance order, so the last rows are the most recent. Take the last five accepted rows. Emit one numbered line per row, starting at 1, newest first. Read each implementation title from `implementations/implementations.md` and the progress from the `codify-tasks.md` of the open feature its Features cell names. Do not use an id as the label. Do not list or count a removed row.

**1. [Product title]:** [Implementation titles]. [Task [T###] is next. Or, when the open feature has no task list: The plan is ready. Or, when no feature is open: Every task is done.]

When more than five accepted rows exist, add `[N] more automations are not shown.`, or `1 more automation is not shown.` when one is not shown.

**Which automation would you like to discuss?** [When some are not shown: You can name or describe any automation.]

When no accepted row exists, say `No automation has been created yet.` Ask nothing.

- A listed number, or an accepted title compared without regard to case, shown or not: select that automation.
- A description that matches one accepted automation: select it.
- A description that matches several: list those matches the same way, newest first, at most five. Ask again.
- A description that matches none: say no automation matches. Ask again.
- `decline`: stop. Write nothing.

A selection emits:

**[Product title]**

- **Files:** `code/<folder>/`
- **Setup and Usage Instructions:** `code/<folder>/README.md` [Or, when the README task is open or no task list exists: The instructions are not written yet.]

**What would you like to know about it?**

Write nothing. Do not enter `choose`, `suggest`, `draft`, or `code`. Do not resume a task list.

## Verification

- `highway-codify catalog` lists at most five accepted automations, newest first, with each implementation title and progress, says how many more exist, and writes nothing. A selection shows the files path and the README path.
