# Contract: Checks Before the Proposal

Owner: `highway-codify`, `### align`. Runs after `start` drafts the proposal and before `propose` shows it. Writes nothing.

## 1. Coding standard check (first)

- Read `library/coding-standards/coding-standards.md` when present.
- For the executor and for each task, find the row whose Technology names that provider or method, or whose File Patterns match a file the method names. The first matching row applies. A row whose standard file is absent is unavailable.
- Read that standard. Compare the provider with any boundary the standard sets, each named library or module with any the standard accepts, and the method with any pattern the standard requires.
- Correct the provider, method, library, module, or pattern so the draft is congruent. Keep the action.
- Do not edit the standard or the catalog.

Lines shown before the proposal, one per result that applies:

- `[Standard title] applies to [executor or task action]. [What changed].`
- `No coding standard applies to this automation.`
- `A standard named by the catalog was not found at [path].`

When no correction keeps the action:

- `[Standard title] cannot be met for **[Action title]**.` Do not show the proposal. Return to `suggest`. When the invocation named the action, ask for another action.

## 2. Source check (second)

- For each named product, API, plugin, module, or library in the corrected draft, read the vendor's current public documentation, product pages, or release notes. Send only that name and the vendor name.
- Deprecated, retired, or no longer offered: correct the draft and cite the source. Conflicting vendor pages: correct the draft and cite both.
- Blog, forum, comparison, no source, or check not completed: inconclusive. Leave the draft unchanged. A result is not confirmation and is not accepted repository evidence.

Lines shown before the proposal:

- `[Vendor] says [name] is no longer offered. [What changed]. Source: [source].`
- `[Name] could not be confirmed from [vendor]'s documentation.`

## Re-run

An edit in `propose` that changes a provider or method runs both checks on that task, then shows the proposal again. Other edits do not run them.

## Never

- Change the selected title or summary.
- Save a check result.
- Run the checks when continuing an automation that already has a task list.
