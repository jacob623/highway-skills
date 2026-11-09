# Wording Contract: highway-codify

Each line below is pinned by `codify-plan-review.test.sh`.

## Procedure order line

Replace `` `check`, `menu`, `tasks`, `` with:

```text
`check`, `menu`, `review` when chosen, `tasks`,
```

## Classify

Add after `On `revise`, "looks good" is `accept`.`:

```text
On `review`, a change to the plan is `edit`, and "no", "nothing", or "looks good" is `accept`.
```

## menu

Replace `` - `1`: read every section of `plan.md` with the person. Write nothing. Answer, then emit this menu. `` with:

```text
- `1`: go to `review`.
```

The menu's emitted text, the stated-edit line, `2`, and `decline` do not change.

## review (new, between menu and tasks)

```markdown
### review

Read every section of `plan.md` with the person. Answer each question they ask along the way. Write nothing. After the last section, ask:

**What would you add, correct, or remove?**

If this is accurate, just say so.

Do not emit the menu with this question.

- `accept`: emit the menu. Go to `menu`.
- `edit`: emit one consequence sentence. Regenerate the plan. Go to `check`.
- `question`: answer, then ask this question again. Stay on `review`.
- `unknown`: ask this question again. Stay on `review`.
- `decline`: stop. Write nothing.
```

## Verification

Add after the menu bullet:

```text
- Reviewing the plan reads every section, then asks **What would you add, correct, or remove?** and "If this is accurate, just say so." before the menu returns. Accepting emits the menu, and a change regenerates the plan and runs `check`. Continuing to code asks no review question.
```

## Version

`version: 14.1.0`
