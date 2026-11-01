# Contract: Configure

## Entry

When the invocation is the word `configure`, go to `configure` before an implementation is chosen and before an open task is resumed. An implementation whose title is that word is not selected.

## configure

Read `library/knowledge/codify-platforms.md` when it exists. Show one numbered line per row, in file order. The line shows the platform and whether it came from an implementation or from the person. Do not use an id as the label.

When the file is absent or has no rows, say nothing is included yet.

**What would you add, correct, or remove?**

- Add a name that is not already there: append an `own` row with Implementation ID `None`.
- Add a name that is already there: say it is already included. Write nothing else.
- Remove a listed platform: drop that row.
- Remove or correct a name that is absent: say it is not included. Write nothing else.
- Correct a listed row: replace that row's platform title. Keep its Implementation ID and Source.
- `decline`: stop. The file is unchanged.
- `unknown`: show the catalog again.

Write the whole file, or write nothing. A failed write leaves the existing file unchanged.

Do not start `choose`, `suggest`, `start`, or `code`. Do not change an automation, an implementation, an architecture, or a decision.
