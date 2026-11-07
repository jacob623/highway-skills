# Contract: Execution fields

## `execution` in `highway-implementation`

Read `library/coding-standards/codify-platforms.md` when present. A row with a blank Kind is not a candidate. Read `library/coding-standards/coding-standards.md` when present.

1. Deployed by is the earliest candidate whose Kind is `pipeline`. When none, the earliest `orchestrator`. When none, the earliest `desired-state`. When none, the earliest `agent`.
2. Managed by is the earliest candidate whose Kind is `self-service`. When none, the earliest `agent`. When none, the Deployed by row.
3. Language is the earliest standard whose Technology appears on its own in a Technology Choice `Choice:`. Compare without regard to case. A boundary on each side makes an entry appear on its own. When none match, Language is None.
4. When Deployed by or Managed by has no row, hold `Needed`. Do not take the first catalog row.
5. Return to `start`.

## Proposal lines

```markdown
**Deployed by:** [Platform. Or: Needed.]

**Managed by:** [Platform. Or: Needed.]

**Language:** [Standard Title. Or: None.]
```

## Record

```markdown
## Execution

Deployed by: <platform title> (<RI id>) or Needed
Managed by: <platform title> (<RI id>) or Needed
Language: <Standard Title or None>
```

## Replacement

- A platforms-catalog row replaces Deployed by or Managed by.
- An accepted implementation with no row follows `highway-codify-config` and returns to `execution`.
- No accepted implementation follows `highway-onboarding`. After the row exists, onboarding returns to `execution`.
- A listed coding-standard title, or None, replaces Language. Any other title is left out, and the person is told to add it with `/highway-codify-config`.
- Acceptance with `Needed` stays on `start`.

## Kind on the platform row

`kind` in `highway-codify-config` maps the type already chosen:

| Type | Kind |
|---|---|
| agent | `agent` |
| pipeline | `pipeline` |
| orchestrator | `orchestrator` |
| self-service platform | `self-service` |
| desired-state or GitOps | `desired-state` |

The platform proposal shows **Kind:**. The written row stores it. A row written before configuration keeps a blank Kind.

## Catalog header

```markdown
| Platform | Implementation ID | Kind | When to use | When not to use |
```
