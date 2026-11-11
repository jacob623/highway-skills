# Contract: Scenario File

One file per conversation at `harness/scenarios/<skill>/<id>.scenario`. Lines are `key: value`.
Blank lines and lines starting with `#` are ignored. A key may repeat where the data model allows.

## Example

```text
id: codify-plan-review
skill: highway-codify
fixture: implementation
smoke: no
open: /highway-codify Northwind Order Service
ask: Would you like to explore any of these options?
say: [select] 1
ask: What would you add, correct, or remove?
say: [accept] Looks good.
ask: Would you like to:
say: [select] 1
ask: What would you add, correct, or remove?
say: [accept] Looks good.
ask: Would you like to:
say: [decline] Stop here.
writes: code/**
expect: exists code/code.md
expect: template code/*/.highway/metadata.md :: codify-metadata.md
expect: heading code/*/.highway/features/*/plan.md :: ## User Stories
expect: absent code/*/.highway/features/*/codify-tasks.md
covers: 0123456789ab Reviewing the plan reads every section, then asks ...
reaches: review
```

## Keys

- `ask: <text>`: the exact question text the skill defines. Matching ignores `**`, case, and runs of
  whitespace. The next `say:` line is its reply.
- `ask-pattern: <regex>`: for a question the skill does not spell out.
- `say: [kind] <reply>`: kind is optional; one of accept, edit, question, unknown, decline, select.
- `writes: <glob>`: `*` matches within one folder and `**` across folders.
- `expect: <assertion> <path-glob>[ :: <argument>]`. The glob must match at least one file, except
  for `absent`.

| Assertion | Argument | Passes when |
|---|---|---|
| `exists` | — | a file matches |
| `absent` | — | no file matches |
| `heading` | heading line | each match has that line |
| `field` | `Name=Value` | a line `Name: Value`, `**Name:** Value`, or `- **Name:** Value` exists |
| `row` | cell text | a table row contains the text |
| `contains` | text | the text appears |
| `template` | template file name | the structural template check passes |

- `covers: <hash> <text>`: hash from `harness/bin/inventory.sh`; text is the bullet when tagged.
- `reaches: <step>`: a `###` step the conversation reaches.
- `chain: <1-6>`: chain position. In a full run, position 1 starts from an empty project and each
  later position starts from the previous stage's output.
