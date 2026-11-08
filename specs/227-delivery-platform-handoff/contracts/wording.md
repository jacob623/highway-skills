# Wording Contract

## highway-codify `provider`

Replaced step 2: `2. When that value is `Needed`, empty, or names a platform with no row, emit before the proposal: [Field] is needed. Name it on the implementation. Write nothing else. Stay on `provider`.`

New steps 2 and 3:

```text
2. When this run holds a named platform, it is the Executor. When this run holds a coding standard, it is Language for this run.
3. When the Executor is `Needed`, empty, or names a platform with no row, go to `platforms needed`. Do not show the proposal. Write nothing.
```

Message (exact):

```text
**[Product Title]'s implementation record does not list preferred delivery platforms.**

Without these, Codify is unable to make proposals for [Product title].

**Would you like to set the preferred delivery platforms now?**

If you'd prefer to name the delivery platform for this single codify run, just say so. Future highway-codify runs for [Product title] will result in this same message.
```

The message and replies live in a new step, `### platforms needed`, reached from `provider` step 3. `codify-deterministic-steps.test.sh` caps `provider` at 250 words and bans "prefer" there; the exact message contains "If you'd prefer".

`[Product Title]` is the selected implementation title.

Replies:

```text
- A yes that names no platform: emit: Let's set the preferred delivery platforms for [Product Title]. Follow `highway-implementation` for [RI id], with the return step `provider` in `highway-codify`.
- A platforms-catalog row, named with or without a yes: hold it for this run. Return to `provider`.
- Any other platform name: hold it for this run. When it is an accepted implementation, emit: Let's configure how highway-codify uses [Platform]. Follow `highway-codify-config` for [Platform], with the return step `provider` in `highway-codify`. Otherwise emit: Let's onboard [Platform]. Follow `highway-onboarding` for [Platform], with the return step `provider` in `highway-codify`.
- A listed coding-standard title: hold it for this run. Re-emit the message.
- A request to name a platform with no name: ask **Which platform would you like this codify run to use?**
- `decline`, or a no: stop. Write nothing.
- `question`: answer, then re-emit the message. `unknown`: re-emit the message.

A held platform or coding standard is never written to the implementation. A return to `provider` keeps the selected implementation, the action, and the draft, and reads the record again.
```

## highway-implementation

Entry, new step 2:

`2. When the invocation names an accepted implementation and a return step, and names no realized capabilities, go to `delivery platforms`.`

New section `### delivery platforms`:

```text
1. Hold the return step for this visit. Keep it while configuration or onboarding runs from this step.
2. Read `implementations/[RI id].md` and its architecture.
3. Emit:

**Product Title:** [Title]

**Architecture Reference:** [RA id] — [Architecture title]

**Deployed by:** [Platform. Or: Needed.]

**Managed by:** [Platform. Or: Needed.]

**Language:** [Standard Title. Or: None.]

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: follow `field` for each named field, with the return step `delivery platforms` in `highway-implementation`. Re-emit this view.
- `accept`: when Deployed by or Managed by is Needed, name that field and re-emit this view. Otherwise rewrite the three Execution lines. Change no other byte. A failed write leaves the record unchanged. Say what failed. Re-emit this view. On success, emit: The preferred delivery platforms for [Title] are set. Picking up your highway-codify run. Go to the held step.
- `decline`: emit: Leaving the preferred delivery platforms for [Title] unset. Picking up your highway-codify run. Write nothing. Go to the held step.
- `question`: answer, then re-emit this view.
- `unknown`: re-emit this view.

Do not create an implementation. Do not run `platforms` or `close`.
```

## highway-onboarding

Implementation paragraph, new sentence: `Its Execution is `Deployed by: Needed`, `Managed by: Needed`, and `Language: None`.`

New sentence after the `execution` return rule: `When the caller named the return step `provider` in `highway-codify`, go to that step after the platform row is written.`

## Versions

`highway-codify` 12.3.0. `highway-implementation` 7.6.0. `highway-onboarding` 10.5.0.
