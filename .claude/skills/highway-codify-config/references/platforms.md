# Platforms

### platforms

1. When Entry carried a platform name, apply the name bullets below to that name. Do not emit the list or its question.
2. Otherwise read `library/coding-standards/codify-platforms.md` when present. Emit one item per row, in file order. Do not use an id as the label.

1. **[Platform]**
   - **When to use:**
     1. [Entry]
   - **When not to use:**
     1. [Entry]

When the file has no rows, say no platform is included yet.

**What would you add, correct, or remove?**

If you'd like to cancel, just say so.

- A name to add or correct that is an accepted implementation title, compared without regard to case: go to `current`, then `platform proposal`, as an update when it has a row and as an add otherwise.
- A name to add that is not an accepted implementation: emit `[Platform] is not in the implementation catalog. Highway adds a platform from an accepted implementation.` Then ask **Would you like to onboard [Platform]?**
  - `accept`: follow `highway-onboarding` from `overview`, for [Platform]. Its summary ends with: Run `highway-codify-config [Platform]` to finish adding [Platform].
  - `decline`: emit this list and its question.
  - `question`: answer, then ask **Would you like to onboard [Platform]?** again.
  - `unknown`: ask **Would you like to onboard [Platform]?** again.
- A listed platform to remove: go to `platform proposal` as a remove.
- A name to correct or remove that has no row: say it is not included. Re-emit this list and question.
- `question`: answer, then re-emit this list and question.
- `unknown`: re-emit this list and question.
- `decline`: go to `menu`.

### kind

1. Take the type `use entries` named for this platform.
2. Store `agent`, `pipeline`, `orchestrator`, `self-service`, or `desired-state`. A self-service platform is `self-service`. A desired-state or GitOps tool is `desired-state`.
3. Return to `platform proposal`.

### platform proposal

1. For an add or update, follow `kind`, then `use entries`. Start an update from the current values after `current`.
2. For a remove, show the current values. Do not run `current` or `use entries`. Leave out New Realized Capabilities.
3. Fill this proposal.

[One sentence stating the consequence of this change.]

[On an add or update with no edit yet: **Here is a proposed starting point for configuring how highway-codify uses [Platform]**]

**Platform:** [Platform]

**Implementation ID:** [RI id]

**Kind:** [Kind.]

**When to use:**
1. [Entry]

   **Why it matters:** [One sentence stating the consequence of this entry.]

**When not to use:**
1. [Entry]

   **Why it matters:** [One sentence stating the consequence of this entry.]

**New Realized Capabilities:**
1. **[Title]:** Realized By: [Platform].

   **Evidence:** [What the current documentation describes.]

**Conflicts:**
1. **[Conflict]:** [Description quoting both entries and naming both records.]

   **Recommendation:** [One change that removes it.]

4. Assess conflicts as `conflicts` does, against the catalogs as they would be after acceptance. With none, show `None`. When any exist, add: You can accept this proposal with these conflicts and resolve them afterward.
5. List each capability `current` marked new under New Realized Capabilities. With none, show `None`.
6. Emit this proposal, then the closing question and the cancel line.

- `edit`: emit one consequence sentence. Re-emit this proposal with the change and without the starting-point line. Stay on `platform proposal`.
- `accept`: edit `library/coding-standards/codify-platforms.md` in its existing structure, under `platform rules`, changing only this row. An add appends it, an update replaces it, and a remove drops it. A failed write leaves the file unchanged. Say what failed and stay. After a write, when the proposal listed new realized capabilities, emit: Let's record the new capabilities for [Platform]. Follow `highway-implementation` for [RI id], with those capabilities and the return step `platform written` in `highway-codify-config`. Otherwise go to `platform written`.
- `question`: answer, then re-emit this proposal.
- `unknown`: re-emit this proposal.
- `decline`: go to `menu`.

### platform rules

The file is `library/coding-standards/codify-platforms.md`. It lists platforms that can start automation: a pipeline, an orchestrator, a self-service platform, a desired-state or GitOps tool, or an agent that starts the work. It is not a roster of every implementation. A store, a newsletter, a records product, or a backup has no row.

Every row comes from an accepted implementation. There is one row per Implementation ID.

Kind is `agent`, `pipeline`, `orchestrator`, `self-service`, `desired-state`, or blank. A row added by an implementation keeps Kind blank until the person configures it. GitOps is stored as `desired-state`.

When to use and When not to use each hold a list. Entries are separated by `; `. An empty list is a blank cell. A row added by an implementation has both cells blank until the person configures it. A proposal presents each list as an ordered list, one entry per item.

Rows stay in the order they were added. A blank Kind is not chosen as Deployed by or Managed by.

### platform written

1. When the accepted proposal listed conflicts, ask **Would you like help resolving these conflicts?** `accept` goes to `conflicts`. `question` answers, then asks again. `unknown` asks again.
2. Otherwise, when the platform works with code or configuration files, ask **Would you like to configure coding standards for [Platform]?** `accept` goes to `standards` with [Platform] as the standard to add or update. `question` answers, then asks again. `unknown` asks again.
3. Otherwise, or after `decline`, go to `platforms`.

## Verification

- A platform is added only from an accepted implementation. Any other name offers onboarding, which ends by pointing back here.
