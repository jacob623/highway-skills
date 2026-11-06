# Contract: Config and Implementation Steps

## highway-codify-config

Procedure: remove the paragraph beginning "On a platform proposal and a standard proposal, each When to use entry".

Inputs: add `highway-implementation`.

```text
### current

1. Read the technology's current public documentation. Write nothing.
2. For a standard, capture each capability the documentation describes.
3. For a platform, capture each automation capability the documentation describes. Do not capture a capability unrelated to automation.
4. For a platform, mark each captured capability that the implementation's Realized Capabilities do not list as a new realized capability.
5. Do not propose a capability the documentation no longer describes.
6. When the documentation cannot be read, say: The current documentation could not be read. Add no capability as current. Mark no new realized capability. Continue from the accepted implementation and the catalogs already present.
7. Then go to the proposal named with this step.
```

`platform proposal` opens with:

```text
1. For an add or update, follow `use entries`. Start an update from the current values after `current`.
2. For a remove, show the current values. Do not run `current` or `use entries`. Leave out New Realized Capabilities.
3. Emit this proposal.
```

Its shape adds, after the consequence sentence:

`[On an add or update with no edit yet: **Here is a proposed starting point for configuring [Platform] as a platform capable of executing automation**]`

Each `1. [Entry]` under When to use and When not to use is followed by `   **Why it matters:** [One sentence.]`. After When not to use:

```text
**New Realized Capabilities:**
1. **[Title]:** Realized By: [Platform]. Evidence: [What the current documentation describes.]
```

After the conflicts paragraph: `List each capability `current` marked new under New Realized Capabilities. With none, show `None`.`

`edit`: `Re-emit this proposal with the change and without the starting-point line.`

`accept` ends: `After a write, when the proposal listed new realized capabilities, emit: Let's record the new capabilities for [Platform]. Follow `highway-implementation` for [RI id], with those capabilities and the return step `platform written` in `highway-codify-config`. Otherwise go to `platform written`.`

```text
### platform written

1. When the accepted proposal listed conflicts, ask **Would you like help resolving these conflicts?** `accept` goes to `conflicts`.
2. Otherwise, when the platform works with code or configuration files, ask **Would you like to configure coding standards for [Platform]?** `accept` goes to `standards` with [Platform] as the standard to add or update.
3. Otherwise, or after `decline`, go to `platforms`.
```

`standard proposal` opens with `For an add or update, follow `use entries`.` Its shape gains the same Why it matters lines.

```text
### use entries

1. For a platform, take its type from the implementation's Technology Choice and `current`, such as a pipeline, an orchestrator, a self-service platform, a desired-state or GitOps tool, or an agent. For a standard, take the type of its language or platform.
2. Propose each entry from best practice for that type in automation. Relate each entry to automation capabilities. Do not propose an entry unrelated to automation.
3. Do not take an entry from the implementation's Realized Capabilities or Runtime Components.
4. Write each entry as one condition or one outcome, in five words or fewer, such as Workflow orchestration, Web Service, Application Front-End, Desired State Configuration Management, GitOps, or Code Deployment. Count a hyphenated term as one word.
5. Do not join two things with "and", "or", a comma, or a slash. Write two things as two entries.
6. Give When to use and When not to use at least one entry each.
7. On an update, rewrite each saved entry that breaks step 4 or step 5. Name each rewrite in Consequences.
8. Keep each entry distinct from the other rows' entries.
9. Under each entry, emit **Why it matters:** and one sentence. The catalog view, a conflict quote, and the saved cell keep the entry only.
10. Return to the proposal that followed this step.
```

`use entries` sits after `standard write` and before `conflicts`.

## highway-implementation

Entry gains step 1: `1. When the invocation names an accepted implementation, new realized capabilities, and a return step, go to `add capabilities`.` The following steps renumber.

```text
### add capabilities

1. Hold the return step for this visit.
2. Read `implementations/[RI id].md` and `implementations/capabilities.md`. When the implementation is not accepted, say it is not accepted. Write nothing. Go to the held step.
3. Leave out a passed capability whose title Realized Capabilities already lists.
4. Derive each capability id as `write` does. When `write` would ask for a wording change, leave that capability out.
5. Append each remaining capability to Realized Capabilities, in the order passed, with its Title, Realized By, and Evidence. Change no other byte of the record.
6. Rewrite this Parent's rows in `implementations/capabilities.md` as `write` does, with the new capabilities. Leave other Parents unchanged.
7. Write the record and the catalog together. A failed write leaves both unchanged. Say what failed. Go to the held step.
8. Emit **New capabilities recorded for [Title]:** and list each recorded title. Name each capability left out in step 4.
9. Go to the held step. Do not ask a question. Do not run `platforms` or `close`.
```

## Rejected

- `is one sentence that names a condition and the required outcome` in configuration
- `For a platform, a documented capability is proposed only when the accepted implementation realizes it.`
- `Ground When to use and When not to use in `current`, the implementation's Technology Choice, Runtime Components, and Realized Capabilities`
- so that, because, in order to, should, consider, prefer, usually, where appropriate in `current`, `platform proposal`, `platform written`, `use entries`, implementation Entry, and `add capabilities`

## Versions

`highway-codify-config` 3.2.0, `highway-implementation` 7.2.0.
