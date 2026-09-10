# Contract: Highway Objective Workflow

## Supported Actions

The skill accepts exactly: `setup`, `configure`, `view`, `show`, `describe`, `add`, `new`,
`update`, `remove`, and `reset`. An unsupported or ambiguous action stops and asks for
clarification without writing.

## Read-Only Output

`view`, `show`, and `describe` are equivalent. The response reports:

- Current baseline version
- Objective count
- Each objective identifier, title, and status
- Absence of a baseline when no objective artifact exists

No file is modified.

## Creation Interview

`setup`, `configure`, `add`, and `new` ask three separate prompts:

1. `Describe the objective.` -> statement
2. `What are the success measures?` -> success_measures
3. Show the proposed rationale and ask: `Accept, modify, or replace?`

The proposal includes the derived title, allocated identifier, status, record content, catalog
change, and resulting version before confirmation.

## Mutation Report

Every mutation response contains:

```text
Action
File
Summary
Affected Entries
Confirmation Status
Resulting Version
```

## Destructive Confirmation

- `remove` names the affected identifier and title before confirmation.
- `reset` lists every identifier and title that would be removed before confirmation.
- Declined, ambiguous, malformed, or aborted operations report no write and preserve all affected
  bytes.

## Retained Artifacts

- Objective records: `library/objectives/OBJXXXXXX.md`
- Objective catalog: `library/governance/objectives.md`
- No objective record is written under `.highway`.

## Version Contract

| Confirmed action | Version change |
|---|---|
| Add/New | MINOR |
| Update | PATCH |
| Remove/Reset | MAJOR |

Only one increment occurs per confirmed action. Failed or declined actions do not change the
version.