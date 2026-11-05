# Step Matches

## Order

`choose` when no implementation is named; `rank`, with `codified`, when no action is named; then `suggest`, `draft`, `provider`, `standards`, `align`, `govern`, `resume`, `join`, `folder`, `layout`, `propose`, `revise`, `identifier`, `title` when needed, `write`, `index`, `plan`, `check`, `menu`, `tasks`, `code`, and `close`.

`codified` returns to `rank`. Entry step 8 goes to `draft` when an action was named, and to `rank` otherwise. `govern` goes to `resume`.

## `rank`

The current ranking text of `suggest`, through "Drop items from the end." Then go to `suggest`. `codified` still removes suggestions before the five are kept. Its "means" test is unchanged.

## `suggest`

The current list, the empty-list lines, and the reply branches. Stay on `suggest`.

## `draft`

The current draft text of `start`, through the task fields. Go to `provider`. Emit nothing except what `provider` emits.

## `provider`

A platform the person named is the Provider. When that name has no row, emit the current not-included line. When none is named, read `library/coding-standards/codify-platforms.md`. Split When to use and When not to use on `; `.

1. A row matches when it has a When to use entry, every such entry appears on its own in the action or the method, and no When not to use entry appears on its own there.
2. The Provider is the earliest matching row.
3. When no row matches, use this implementation's row, then the first row.
4. When the catalog has no rows, leave the Provider unset and emit the current platform-needed line.

Go to `standards`.

## `standards`

1. A row is a candidate when its File Patterns match a file the method names, or its Technology names the method or the Provider, and its standard file is present.
2. Drop a candidate whose When to use is blank, whose When to use entry does not appear on its own in the action, the method, or the Provider, or whose When not to use entry does appear there.
3. Put a standard before every standard it inherits from, and a platform standard before the language standards it builds on.
4. Add each inherited standard once, after the standard that inherits it.

The earlier standard wins a disagreement. Go to `align`.

## `govern`

Replace the cover test with: a Control or NFR applies when its statement contains, ignoring case, the task's target, a file name or path written in the task, or the mechanism that realization names for it. The rest of `govern` stays. Go to `resume`.

## `resume`

The current project read, then:

1. When the person named a folder, use it.
2. When a recorded feature's action is this action's title, ignoring case and hyphens, resume that feature: `menu` with no task list, `code` with an open task, or `close` when every task is done.
3. When a feature sentence or a product Summary means this same action, join that product.

Stop at the first that applies. Otherwise go to `join`.

## `join`

1. Read the matching coding standard. When one of its rules names where this action lives, that rule replaces the decision below.
2. The current composition, capability, and Summary "means" rules, in the same order.

Use the first that fits, unless the standard rule replaced it. Otherwise go to `folder`.

## `folder`

1. Otherwise start a folder from the product title: lowercase words, hyphens.
2. When that folder is already a catalog path, say it is taken and ask for another name.

The current title, Summary, integration hold, Proposed project, and Rationale text stay here. Go to `layout`.

## `layout`

After the files are placed, apply the `govern` match to each placed path. Add a new match. Do not drop a match already held. Go to `propose`.

## `plan`

Remove "The accepted proposal is not copied." The plan holds one story per proposal task, so a review of it is the whole plan.

1. One story per proposal task, in task order. The title is that task's action. When an acceptance criterion contains that action, ignoring case, Done when is the earliest such criterion. Otherwise Done when is the task's Scope sentence. Copy no scope, method, standards, or files.

`codify-plan.md` states this same rule and moves to version 2.0.0.

## `check`

1. When the plan contradicts the accepted proposal, or a proposal task has no story, correct the plan.
2. When accepted material answers a gap, record the answer and ask nothing.
3. A gap is a story with no Done when, a repeated story title, or an applied Control or NFR that no story names. Walk stories in plan order, then the applied titles in proposal order.
4. Ask the first five, one at a time. Write each answer into the plan. Record each later gap as an assumption.
5. When none qualify, go to `menu`. Do not say the check ran.

## `tasks`

Place each proposal task under the story whose title is that task's action, in proposal order. When no story has that title, give the task a heading from that task. When a story title is not a proposal task's action, add a task for it. Leave out a line that names work the proposal does not list.

## Verification

Delete a bullet whose rule a step already states. Keep a bullet whose rule no step states. A test that required the moved sentence requires it in the step.
