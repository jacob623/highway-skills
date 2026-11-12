# Record

### identifier

Derive the id from the accepted title.

1. Lowercase the title. Remove hyphens and apostrophes. Split the rest into words.
2. Take eight letters: the first two of word 1, the first two of word 2, the first two of word 3, and the last two of the last word. When the title has only two words, the third sample is the first two of the last word.
3. When a word is shorter than two letters, continue into the next word. A one-word title repeats until there are eight letters.
4. Map each letter. Digits stay as they are.

a 0, b 1, c 2, d 3, e 4, f 5, g 6, h 7, i 8, j 9, k a, l b, m c, n d, o e, p f, q 0, r 1, s 2, t 3, u 4, v 5, w 6, x 7, y 8, z 9.

5. The id is `REQ` plus those eight hex digits.

Compare that id with `requests/requests.md`, including removed rows.

- The same title already has that id: use the existing record. Do not write a second one. Go to `close`.
- The id is taken for a different title: go to `title`.
- The id is free: go to `write`.

### title

Name each conflicting title. Say that a title change is appropriate. Then show the new title for acceptance.

The existing Request Title, **[Existing title]** and this new Request Title, **[this title]**, are too similar. A title change is appropriate. I would recommend:

**[New title]**

**What would you add, correct, or remove?**

If this is accurate, just say so.

The new title is a small change the person can recognize. Its derived id must be free. Do not mention identifiers, hex, sampling, or the catalog.

- `accept`: replace the held title. Return to `identifier`.
- `edit`: use the person's title. Return to `identifier`.
- `question`: answer in one sentence. Re-emit this message.
- `unknown`: re-emit this message.

Do not write until the id is free or the existing record is reused.

### write

Write `requests/[ID].md` and `requests/requests.md` together. Write neither file until both are valid. A failed write leaves every existing request byte unchanged. Say what failed in terms the person can act on. Stay on `write`.

The record follows `assets/request-record.md`.

- `id` is the derived `REQ` id.
- `status` is `accepted`.
- The title is the accepted title.
- The seven domain sections hold the accepted evidence.
- `## Completeness` is `Complete`.
- Do not write relationship sections.

Edit `requests/requests.md` in its existing structure.

The catalog owns the baseline version and the request index. It has no `Next ID` field.

Each ID appears once. Rows are ordered by ID. The id is `REQ` plus the eight hex digits derived from the title. Status is `accepted` or `removed`.

`accepted` has a record at `requests/<id>.md`. `removed` has no record file. A removed row stays in the index, keeps the title that last held that id, and leaves the id taken.

- Add one index row for this request.
- Order the index by identifier.
- Do not allocate from `Next ID`.
- The first catalog version is `1.0.0`.
- Adding a request increments the minor version.
- Emit no timestamp, random value, or environment value.

On success, go to `close`.

## Verification

- Each id is `REQ` plus eight hex digits derived from the title.
- A taken id for a different title names the conflicting titles, says a title change is appropriate, and shows a new title. The write waits until the person accepts that title.
- That message does not mention identifiers, hex, sampling, or the catalog.
- A failed write leaves existing request and catalog bytes unchanged.
