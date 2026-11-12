# Record

### identifier

The ADR title is the selected option title unless the person supplied a title.

1. Lowercase the title. Remove hyphens and apostrophes. Split the rest into words.
2. Take eight letters: the first two of word 1, the first two of word 2, the first two of word 3, and the last two of the last word. When the title has only two words, the third sample is the first two of the last word.
3. When a word is shorter than two letters, continue into the next word. A one-word title repeats until there are eight letters.
4. Map each letter. Digits stay as they are.

a 0, b 1, c 2, d 3, e 4, f 5, g 6, h 7, i 8, j 9, k a, l b, m c, n d, o e, p f, q 0, r 1, s 2, t 3, u 4, v 5, w 6, x 7, y 8, z 9.

5. The id is `ADR` plus those eight hex digits.

Compare that id with `adrs/adrs.md`, including removed rows.

- The same title already has that id: use the existing record. Do not write a second one. Go to `close`.
- The id is taken for a different title: go to `title`.
- The id is free: go to `write`.

### title

Name each conflicting title. Say that a title change is appropriate. Then show the new title for acceptance.

The existing ADR Title, **[Existing title]** and this new ADR Title, **[this title]**, are too similar. A title change is appropriate. I would recommend:

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

Write `adrs/[ID].md` and `adrs/adrs.md` together. Write neither file until both are valid. A failed write leaves every existing ADR byte unchanged. Say what failed in terms the person can act on. Stay on `write`.

The record follows `assets/adr-record.md`.

- `id` is the derived `ADR` id.
- `request` is the Discovery's Request id.
- `discovery` is the Discovery id.
- `status` is `accepted`.
- `supersedes` is the replaced ADR id, or `None`.
- `superseded_by` is `None`.
- The title is the accepted ADR title.
- Copy the Discovery comparison, recommendation, confidence, and Reference Architecture matches into `## Discovery Reference` and `## Decision Confidence` without recalculation.
- `## Context` states the problem this decision responds to and the forces that make it necessary, in prose, and the evidence-resolution record or `None`.
- `## Decision` records the selected option, `User-provided explicit selection`, the decision statement, the rationale, and this authorization: Proceed to Reference Architecture. Implementation is not authorized.
- `## Decision Scope` states what the decision covers and what it leaves open, or `None` for what it leaves open.
- `## Revisit When` states the condition that should cause the decision to be reopened, or `None` when no condition is known.
- When the selected option differs from the Discovery recommendation, write `## Recommendation Override` with both options and the override rationale. Omit that section when they are the same.
- `## Alternatives Considered` lists every Discovery option, headed by its option id, with its definition, one outcome, and a reason. The selected option is `Selected`. Every other option is `Evaluated` when it remained viable, or `Rejected` when the Discovery excluded it.
- Each Objective relationship is the Objective id and `advances`. Each Control relationship is the Control id and `bound by`. Each NFR relationship is the NFR id and `satisfies`. A section with no relationship is `None`.
- `## Reference Architecture Handoff` names the architecture direction or `None`, the required architecture work or `None`, Reference Architecture as the reused RA id or `None`, and authorization to proceed to Reference Architecture. Do not write an implementation entry. Do not repeat the selected option or the matches there.
- Emit no timestamp, random value, or environment value.

Status is `superseded` in the record and in the catalog exactly when `superseded_by` names an ADR. Otherwise it is `accepted`. A superseded record keeps its file and its id. Do not treat it as removed.

Edit `adrs/adrs.md` in its existing structure.

The catalog owns the baseline version and the ADR index. It has no `Next ID` field. The index columns are ADR ID, Discovery ID, Request ID, ADR Title, ADR Path, Architecture ID, and Status.

Each ADR ID appears once. Rows are ordered by ADR ID. The ADR ID is `ADR` plus the eight hex digits derived from the title. Discovery ID is the Discovery this decision records. Each Discovery ID appears on at most one row, except `highway`, which every onboarding ADR uses. Architecture ID is the one reference architecture this decision names, or `None` before that architecture exists. A decision that runs beside the current decision of several architectures lists every architecture it names, in id order, separated by a comma and a space. `None` means a new architecture will follow. Status is `accepted`, `superseded`, or `removed`.

`accepted` has a record at `adrs/<id>.md`. `superseded` has a record at `adrs/<id>.md` whose `superseded_by` names the replacing ADR, and its id stays taken. `removed` has no record file. A removed row stays in the index, keeps the title that last held that id, and leaves the id taken.

- Add one index row with the ADR ID, Discovery ID, Request ID, ADR Title, ADR Path, Architecture ID, and Status `accepted`. Architecture ID is the reused RA id, every RA id in a span, or `None` when a new architecture will follow.
- Order the index by ADR id.
- Do not allocate from `Next ID`.
- The first catalog version is `1.0.0`.
- Adding an ADR increments the minor version.
- One Discovery id appears on at most one row, except `highway`.

Edit `architectures/architectures.md` in its existing structure, and change only a row's ADR ID cell.

ADR ID cell rule: the architecture catalog ADR ID cell lists every current decision that names the architecture, in id order, separated by a comma and a space. One id is used when only one current decision names it. A superseded or removed decision is not in that cell. An ADR id appears on at most one row. A decision whose ADR catalog Architecture ID cell lists several architectures is the exception: it appears on the row of each architecture it names.

When this decision replaces a matched decision, set that decision's `superseded_by` to this ADR id and its status to `superseded` in the record and the catalog. Keep its file. Remove it from the architecture's Current Decisions and from that architecture's catalog ADR ID cell. Add this ADR id to that list and that cell, in id order. Do not change the architecture's conceptual body. Do not create an architecture.

When this decision runs beside a matched decision, add this ADR id to that architecture's Current Decisions and catalog ADR ID cell. Leave the earlier decision on the list. Do not change the architecture's conceptual body. Do not create an architecture.

When the selected option already has a current implementation, name that architecture in the handoff and add this ADR id to its Current Decisions and catalog ADR ID cell when it is not already there. Do not create an architecture.

When a span is accepted, list every RA id in the set, in id order, separated by a comma and a space, in the catalog Architecture ID cell and the handoff's Reference Architecture. `supersedes` is `None`. Decision Scope covers every architecture in the set by title. Architecture Direction says this decision runs beside the current decision of each named architecture. Required Architecture Work is `None`. Add this ADR id to each architecture's Current Decisions and catalog ADR ID cell, in id order. Supersede nothing. Do not change an architecture's conceptual body. Do not create an architecture.

When an architecture is reused, replaced, already implemented for this option, or in a span, the decision record, the decision catalog, the architecture's Current Decisions, and the architecture catalog ADR ID cell are updated in the same write. When nothing matches, do not change an architecture record or an architecture catalog. A failed write leaves every existing byte unchanged.

On success, go to `close`.

## Verification

- Recommendation Override is written only when the selection differs from the recommendation.
- Status is `superseded` in the record and catalog exactly when `superseded_by` names an ADR, and the record file remains.
- Each id is `ADR` plus eight hex digits derived from the title.
- A taken id names the conflicting titles, says a title change is appropriate, and shows a new title. The write waits until the person accepts that title.
- That message does not mention identifiers, hex, sampling, or the catalog.
- A failed write leaves existing ADR bytes unchanged.
- Replacing a decision sets it to `superseded`, keeps its file, and removes it from the architecture's current decisions. Running beside adds this decision and leaves the earlier one. The architecture record and the architecture catalog show the same current decisions.
