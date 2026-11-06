# Data Model: Configure Handoff

## Platforms to configure

- Kept in the conversation by `highway-onboarding`. Not written.
- Gains a platform on a yes in `orchestrate`, in the order asked.
- Loses its first platform each time `configure` hands off.
- Empty: `configure` goes to `summary`.

## Return step

- A skill and one of its steps: `configure` in `highway-onboarding`, or `close` in `highway-implementation`.
- Named by the caller in the handoff.
- Held by `highway-codify-config` from Entry for the rest of that visit.
- Used once, by the `menu` decline.

## Configuration visit

| State | Event | Next |
|---|---|---|
| Entry with a platform | invocation names a platform | `platforms` for that platform |
| Any step | `decline` other than the menu | `menu` |
| `menu` | `decline` with a held return step | that step in its skill |
| `menu` | `decline` with none held | stop, write nothing |
