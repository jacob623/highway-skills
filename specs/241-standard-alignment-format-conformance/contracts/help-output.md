# Contract: Help Index and highway-help Output

This changes `specs/240-standard-alignment-self-contained-skills/contracts/help-index.md`.

## Index

`skills/highway-help/assets/index.json`:

```json
{
  "entries": [
    {
      "id": "highway-adr",
      "name": "highway-adr",
      "description": "<description>",
      "usage": "<metadata.usage>",
      "version": "<metadata.version>",
      "example": "<first inline-code line under ## Example>"
    }
  ]
}
```

- `usage` is read from `metadata.usage`.
- `dependencies` is removed.
- The generator still validates every skill first and writes nothing when one fails, and it
  writes the same bytes from unchanged sources.

## Single-skill output

```text
Name: highway-help
Description: <description>
Version: 3.4.0
Usage: Run highway-help for all skills, or highway-help <skill-id> for one named skill's registration details.
Example: `/highway-help highway-help`
```

Five lines, in this order. `Dependencies:` is removed.

## All-skills output

One block per entry:

```text
Name: <id>
Description: <description>
Help: highway-help <id>
```

The empty-index line `No skills are registered yet.` and both error lines are unchanged.
