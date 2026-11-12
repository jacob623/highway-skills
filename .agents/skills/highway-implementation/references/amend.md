# Amend

### add capabilities

1. Hold the return step for this visit.
2. Read `implementations/[RI id].md` and `implementations/capabilities.md`. When the implementation is not accepted, say it is not accepted. Write nothing. Go to the held step.
3. Leave out a passed capability whose title Realized Capabilities already lists.
4. Derive each capability id as `write` does. When a title breaks the capability title rule, or `write` would ask for a wording change, leave that capability out.
5. Append each remaining capability to Realized Capabilities, in the order passed, with its Title, Realized By, and Evidence. Change no other byte of the record.
6. Rewrite this Parent's rows in `implementations/capabilities.md` as `write` does, with the new capabilities. Leave other Parents unchanged.
7. Write the record and the catalog together. A failed write leaves both unchanged. Say what failed. Go to the held step.
8. Emit **New capabilities recorded for [Title]:** and list each recorded title. Name each capability left out in step 4.
9. Go to the held step. Do not ask a question. Do not run `platforms` or `close`.

### delivery platforms

1. Hold the return step for this visit. Keep it while configuration or onboarding runs from this step.
2. Read `implementations/[RI id].md` and its architecture.
3. Hold the record's value for each Execution field. Deployed by and Managed by are unset when `Needed`, empty, or naming a platform with no row. Language is unset when `Needed`, empty, or naming a standard with no row. Hold the `execution` value for each unset field. A value the person named in this visit replaces the held value.
4. Emit:

**Here is the proposed Deployed by, Managed by and Language for [Product Title]**

**Product Title:** [Title]

**Architecture Reference:** [RA id] — [Architecture title]

**Deployed by:** [Platform. Or: Needed.]

**Why it matters:** [From `why it matters`.]

**Managed by:** [Platform. Or: Needed.]

**Why it matters:** [From `why it matters`.]

**Language:** [Standard Title. Or: None.]

**Why it matters:** [From `why it matters`.]

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: follow `field` for each named field, with the return step `delivery platforms` in `highway-implementation`. Re-emit this view.
- `accept`: when Deployed by, Managed by, or Language is Needed, name that field and re-emit this view. Otherwise rewrite the three Execution lines with the held fields. Change no other byte. A failed write leaves the record unchanged. Say what failed. Re-emit this view. On success, emit: The preferred delivery platforms for [Title] are set. Picking up your highway-codify run. Go to the held step.
- `decline`: go to `delivery decline`.
- `question`: answer, then re-emit this view.
- `unknown`: re-emit this view.

Do not create an implementation. Do not run `platforms` or `close`.

### delivery decline

Write nothing. Emit:

Leaving the preferred delivery platforms for [Title] unset. highway-codify needs these details before it can make proposals for [Title].

**Would you like to return and provide these details now?**

- A yes: re-emit the `delivery platforms` view.
- A no, or `decline`: go to the held step.
- `question`: answer, then re-emit this question.
- `unknown`: re-emit this question.

## Verification

- An invocation from `highway-codify-config` naming an accepted implementation, new realized capabilities, and a return step goes to `add capabilities`. It appends them to Realized Capabilities and to this Parent's capability rows, changes no other record byte, asks no question, and goes to the held step. A passed title that breaks the capability title rule is left out and named.
- An invocation from `highway-codify` naming an accepted implementation and a return step goes to `delivery platforms`. It opens with "Here is the proposed Deployed by, Managed by and Language for [Product Title]", then shows Product Title, Architecture Reference, Deployed by, Managed by, and Language, each field followed by its Why it matters line. Accept stays on the view while a field is Needed. Acceptance rewrites only the three Execution lines, emits "The preferred delivery platforms for [Title] are set. Picking up your highway-codify run.", and goes to the held step.
- The delivery platforms view holds the record's fields, then the `execution` value for each unset one: Deployed by or Managed by that is `Needed`, empty, or has no row, and Language that is `Needed`, empty, or has no row. A stored `None` is shown as stored. A value the person named in the visit replaces it. This implementation's row is never a candidate.
- A decline writes nothing, emits "Leaving the preferred delivery platforms for [Title] unset. highway-codify needs these details before it can make proposals for [Title].", and asks whether to return. A yes shows the view again. A no goes to the held step.
