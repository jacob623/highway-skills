# Record

### identifier

The architecture title is the purpose in the ADR title, unless the person supplied a title that names no product. Hold it before deriving the id.

- Remove a leading "Adopt", without regard to case. The purpose is the text after the first " for ", without regard to case. Capitalize its first letter. Keep every other word as written.
- When the ADR title has no " for ", use the rest of the title. When the decision's Selected Option is a name that appears in it, remove that name.
- When the title would be empty or would name a product, ask for a purpose title. Write nothing until the person gives one.

**What should this architecture be called? Describe what it is for, without naming a product.**

The reply is the held title. When it names a product, ask again.

Deriving the id from the held title:

1. Lowercase the title. Remove hyphens and apostrophes. Split the rest into words.
2. Take eight letters: the first two of word 1, the first two of word 2, the first two of word 3, and the last two of the last word. When the title has only two words, the third sample is the first two of the last word.
3. When a word is shorter than two letters, continue into the next word. A one-word title repeats until there are eight letters.
4. Map each letter. Digits stay as they are.

a 0, b 1, c 2, d 3, e 4, f 5, g 6, h 7, i 8, j 9, k a, l b, m c, n d, o e, p f, q 0, r 1, s 2, t 3, u 4, v 5, w 6, x 7, y 8, z 9.

5. The id is `RA` plus those eight hex digits.

Compare that id with `architectures/architectures.md`, including removed rows.

- The same title already has that id and its row lists this ADR: use the existing record. Do not write a second one. Go to `name`.
- The same title already has that id for a different ADR: go to `title`.
- The id is taken for a different title: go to `title`.
- The id is free: go to `write`.

### title

Name each conflicting title. Say that a title change is appropriate. Then show the new title for acceptance.

The existing Architecture Title, **[Existing title]** and this new Architecture Title, **[this title]**, are too similar. A title change is appropriate. I would recommend:

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

Write `architectures/[ID].md` and `architectures/architectures.md` together. Write neither file until both are valid. A failed write leaves every existing architecture byte unchanged. Say what failed in terms the person can act on. Stay on `write`.

The record follows `assets/architecture-record.md`.

- `id` is the derived `RA` id.
- `status` is `accepted`.
- The title is the accepted architecture title.
- Include Current Decisions, Context, Architecture Summary, Architecture Style, Logical Components, Information, Variation, Responsibilities, Interaction Model, Trust Boundaries, Deployment Pattern, Constraints, Objective Relationships, Control Relationships, NFR Relationships, Required Capabilities, Assumptions, Risks, Reference Implementation Guidance, and Traceability.
- Do not write a single `adr` frontmatter field. Do not write Key Technologies.
- Current Decisions lists this ADR. State what the architecture carries from it. Do not copy the decision statement.
- Context states when the architecture applies and what it leaves open.
- Architecture Style states why it was chosen.
- Architecture Summary, Logical Components, Interaction Model, and Deployment Pattern stay conceptual.
- Each logical component has its responsibility and the interface other components rely on, or `None`.
- Information states what this architecture handles, who owns it, and what crosses a trust boundary, or `None`.
- Variation states what every implementation must keep and what an implementation may choose, or `None` when nothing may vary. A variation names no product, platform, or vendor.
- Responsibilities are what a realization covers or marks not applicable.
- Each Objective relationship is the Objective id and `advances`. Each Control relationship is the Control id and `bound by`. Each NFR relationship is the NFR id and `satisfies`. A section with no relationship is `None`.
- Required Capabilities name the component that offers each one. Each capability title follows the capability title rule. Do not assign capability ids. The section is `None` when no capability applies.
- Traceability names the Request, Discovery, the current decisions, and this architecture.
- Reference Implementation Guidance does not authorize implementation.
- Empty optional evidence is `None`.
- Emit no timestamp, random value, or environment value.

Capability title rule: a capability title is one noun phrase of five words or fewer. A hyphenated word counts as one word. Modifiers can precede the noun. A title does not contain `and`, `or`, `&`, `/`, `+`, or a comma. A title that joins two things is two capabilities, one per part. Each part keeps its own words and repeats a shared noun when there is one.

Edit `architectures/architectures.md` in its existing structure.

The catalog owns the baseline version and the architecture index. It has no `Next ID` field. The index columns are Architecture ID, ADR ID, Architecture Title, Architecture Path, and Status.

Each Architecture ID appears once. Rows are ordered by Architecture ID. The Architecture ID is `RA` plus the eight hex digits derived from the title. Status is `accepted` or `removed`.

ADR ID cell rule: the architecture catalog ADR ID cell lists every current decision that names the architecture, in id order, separated by a comma and a space. One id is used when only one current decision names it. A superseded or removed decision is not in that cell. An ADR id appears on at most one row. A decision whose ADR catalog Architecture ID cell lists several architectures is the exception: it appears on the row of each architecture it names.

`accepted` has a record at `architectures/<id>.md`. `removed` has no record file. A removed row stays in the index, keeps the title that last held that id, and leaves the id taken.

- The index columns are Architecture ID, ADR ID, Architecture Title, Architecture Path, and Status.
- Architecture ID is the `RA` id. The ADR ID cell lists every current decision id in id order, separated by a comma and a space. At creation that cell is this ADR id. Architecture Path is `architectures/<RA id>.md`. Status is `accepted`.
- Order the index by ID.
- Do not allocate from `Next ID`.
- The first catalog version is `1.0.0`.
- Adding an architecture increments the minor version.
- One ADR id appears on at most one row. A removed row has no record file.

On success, go to `name`.

### name

Set the ADR's `Reference Architecture` field to this `RA` id, and that ADR's Architecture ID in `adrs/adrs.md` to the same id, in one write. Change no other ADR or ADR catalog byte. The decision statement, rationale, selected option, and status stay as they were. Do not set an implementation id.

When the ADR cannot be updated, keep the architecture record and catalog. Say the ADR could not be updated to name this architecture, and that running `highway-architecture [ADR id]` again will name it. Do not call the decision, architecture, and implementation chain complete.

Then go to `close`.

## Verification

- After the architecture is written, the ADR's Reference Architecture field and its Architecture ID in `adrs/adrs.md` name it, and the ADR does not name an implementation. No other ADR field or ADR catalog cell changes.
- When that ADR update fails, the architecture remains and the chain is not called complete. A later invocation for the same ADR names it.
- Current Decisions lists every current decision that names this architecture, and the catalog ADR ID cell lists those same ids. A decision statement is not copied.
- Each id is `RA` plus eight hex digits derived from the title.
- The catalog index columns are Architecture ID, ADR ID, Architecture Title, Architecture Path, and Status.
- A taken id names the conflicting titles, says a title change is appropriate, and shows a new title. The write waits until the person accepts that title.
- That message does not mention identifiers, hex, sampling, or the catalog.
- A failed write leaves existing architecture bytes unchanged.
