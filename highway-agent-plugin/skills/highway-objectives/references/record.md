# Record

### identifier

Derive each id from its title.

1. Lowercase the title. Remove hyphens and apostrophes. Split the rest into words.
2. Take eight letters: the first two of word 1, the first two of word 2, the first two of word 3, and the last two of the last word. When the title has only two words, the third sample is the first two of the last word.
3. When a word is shorter than two letters, continue into the next word. A one-word title repeats until there are eight letters.
4. Map each letter. Digits stay as they are.

a 0, b 1, c 2, d 3, e 4, f 5, g 6, h 7, i 8, j 9, k a, l b, m c, n d, o e, p f, q 0, r 1, s 2, t 3, u 4, v 5, w 6, x 7, y 8, z 9.

5. The id is `OBJ` plus those eight hex digits.

Compare that id with the catalog, including removed rows, and with the other held titles in this write.

- The same title already has that id: use the existing record. Do not write a second one.
- The id is taken for a different title: go to `title`.
- The id is free: use it.

### title

Name each conflicting title. Say that a title change is appropriate. Then show the new title for acceptance.

The existing Objective Title, **[Existing title]** and this new Objective Title, **[this title]**, are too similar. A title change is appropriate. I would recommend:

**[New title]**

**What would you add, correct, or remove?**

If this is accurate, just say so.

The new title is a small change the person can recognize. Its derived id must be free. Do not mention identifiers, hex, sampling, or the catalog.

- `accept`: replace the held title with the new title. Return to `identifier` for that Objective.
- `edit`: use the person's title. Return to `identifier` for that Objective.
- `question`: answer in one sentence. Re-emit this message.
- `unknown`: re-emit this message.

Do not write until every held Objective has a free id or reuses its existing record.

### write

Resolve every id in `identifier` before writing. Write the held Objectives and the catalog together. Write no record until this step. A failed write leaves the baseline as it was before the step. Say what failed in terms the person can act on. Stay on `write`. Do not return `Finished`.

On success, go to `close`.

For each held Objective, write `library/objectives/[ID].md` in the shape required by `assets/objective-record.md`.

- `id` is the derived `OBJ` id.
- Keep an existing id when the title is unchanged.
- `title` is the accepted title.
- `status` is `active`.
- `capabilities` is `[]`.
- `## Statement` is the statement shown with the title.
- `## Success Measures` are the measures shown under **Success looks like:**.
- `## Rationale` is the line shown with **Why it matters:**.
- Do not show the stored records.

Write `library/governance/objectives.md` in the shape required by `assets/objective-catalog.md`.

- Order the index by identifier.
- Do not allocate from `Next ID`.
- The first catalog version is `1.0.0`.
- A review that adds a record increments the minor version.
- A review that changes a record increments the patch version.
- A review that removes a record increments the major version.
- Emit no timestamp, random value, or environment value.
- An empty held set writes the catalog with version `1.0.0` and no index rows.
- A removed Objective keeps its catalog row with status `removed`.

## Verification

- Each id is `OBJ` plus eight hex digits derived from the title.
- A taken id for a different title names the conflicting titles, says a title change is appropriate, and shows a new title. The write waits until the person accepts that title.
- That message does not mention identifiers, hex, sampling, or the catalog.
- A successful guided write goes to `close` and does not show the stored records.
