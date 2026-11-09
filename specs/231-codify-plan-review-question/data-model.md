# Data Model: Codify Plan Review Question

No stored data changes. The feature changes the conversation states after the plan is written.

## States

| State | Shown | Next |
|---|---|---|
| `menu` | The plan is complete line, **Review the plan?**, **Continue to code the solution?** | `1` to `review`. A stated edit to `check`. `2` to `tasks`. `decline` stops |
| `review` | Every section of `plan.md`, then **What would you add, correct, or remove?** and "If this is accurate, just say so." | `accept` to `menu`. `edit` to `check`. `question` and `unknown` stay. `decline` stops |
| `check` | Gap questions, when any | `menu` |

## Rules

- `review` writes nothing unless the reply is `edit`.
- The menu is never shown in the same message as the review question.
- On `review`, "no", "nothing", and "looks good" are `accept`.
- A resumed feature with a plan and no task list enters at `menu`, not `review`.
