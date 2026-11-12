# Record

### identifier

The implementation title is the product in the title of the decision this realization came from, unless the person supplied a title.

- Remove a leading "Adopt", without regard to case. The product is the text before the first " for ", without regard to case. Capitalize its first letter. Keep every other word as written, so joined products and a named mechanism stay whole.
- When the decision title has no " for ", use the decision's Selected Option when it is a name that appears in the title. Otherwise use the rest of the title.

Deriving the id from that title:

1. Lowercase the title. Remove hyphens and apostrophes. Split the rest into words.
2. Take eight letters: the first two of word 1, the first two of word 2, the first two of word 3, and the last two of the last word. When the title has only two words, the third sample is the first two of the last word.
3. When a word is shorter than two letters, continue into the next word. A one-word title repeats until there are eight letters.
4. Map each letter. Digits stay as they are.

a 0, b 1, c 2, d 3, e 4, f 5, g 6, h 7, i 8, j 9, k a, l b, m c, n d, o e, p f, q 0, r 1, s 2, t 3, u 4, v 5, w 6, x 7, y 8, z 9.

5. The id is `RI` plus those eight hex digits.

Compare that id with `implementations/implementations.md`, including removed rows.

- The same title already has that id under this architecture: use the existing record. Do not write a second one. Go to `platforms`.
- The same title already has that id under a different architecture: the title becomes "[Product] for [purpose]". The purpose is the text after the first " for ", as written. Derive the id again. When the decision title has no purpose, go to `title`.
- The id is taken for a different title: go to `title`.
- The id is free: go to `write`.

### title

Name each conflicting title. Say that a title change is appropriate. Then show the new title for acceptance.

The existing Implementation Title, **[Existing title]** and this new Implementation Title, **[this title]**, are too similar. A title change is appropriate. I would recommend:

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

Write `implementations/[ID].md`, `implementations/implementations.md`, and `implementations/capabilities.md` together. Write none of them until all are valid. A failed write leaves every existing implementation and capability-catalog byte unchanged. Say what failed in terms the person can act on. Stay on `write`.

The record follows `assets/implementation-record.md`.

- `id` is the derived `RI` id.
- `architecture` is the Reference Architecture id.
- `status` is `accepted`.
- The title is the accepted implementation title.
- Include Variation Choices, Coverage, Realized Interfaces, Conformance Evidence, Limitations, Technology Choice, Execution, Context, Implementation Summary, Realized Capabilities, Runtime Components, Data Realization, Integration Realization, Security Control Realization, NFR Realization, Assumptions, Risks, Constraints, Dependencies, and Traceability.
- Coverage has one row per responsibility the architecture states. Status is covered or not applicable.
- When every row is covered or not applicable, Conformance is `compatible`. Do not write a gap section or a conflict section.
- When a stated responsibility is uncovered, Conformance is `incomplete` and the gap is stated.
- A technology choice is stated once, with its intent, its reason, and its evidence.
- The architecture is named once, in Architecture Reference.
- Security Control Realization and NFR Realization project the accepted Controls and NFRs. Do not change those records.
- Traceability names the Request, Discovery, the decision this realization came from, and this implementation. Do not name the architecture again.
- Each realized capability title follows the capability title rule, and each capability has one or more Realized By values.

Capability title rule: a capability title is one noun phrase of five words or fewer. A hyphenated word counts as one word. Modifiers can precede the noun. A title does not contain `and`, `or`, `&`, `/`, `+`, or a comma. A title that joins two things is two capabilities, one per part. Each part keeps its own words and repeats a shared noun when there is one.

Edit `implementations/capabilities.md` in its existing structure.

The catalog is written with its owning Reference Implementation. It has no `Next ID` field. The columns are ID, Parent, Title, and Realized By.

Parent is the implementation id. Title is one capability and follows the capability title rule. Realized By lists the providers or mechanisms, in alphabetical order. The id is CAP plus eight hex digits derived from the title. The same Parent and title reuse that id. A removed row is not used; rows for one Parent are replaced on each write, and other Parents stay unchanged.

- The columns are ID, Parent, Title, and Realized By.
- Parent is this `RI` id. Title is the business capability. Realized By lists the providers or mechanisms, in alphabetical order.
- Derive each capability id with the same letter steps, using the prefix `CAP` and the capability title. Reuse that id when this Parent and title already have a row.
- When that id is taken by the same title under a different Parent, derive it again with the Parent id as the last word.
- When that id is taken by a different title, name both titles, say a wording change is appropriate, and show a small change. Write only after the wording is free.
- Replace this Parent's rows on each write. Leave other Parents unchanged. Remove a row for this Parent that is no longer in the accepted capabilities.
- Do not write a `CAP` record file.
- Do not allocate from `Next ID`.
- Empty optional evidence is `None`.
- Emit no timestamp, random value, or environment value.
- Do not write plans, tasks, source code, or infrastructure definitions.

Edit `implementations/implementations.md` in its existing structure.

The catalog owns the baseline version and the implementation index. It has no `Next ID` field. The index columns are Implementation ID, Architecture ID, Implementation Title, Implementation Path, and Status.

Each Implementation ID appears once. Rows are ordered by Implementation ID. The Implementation ID is `RI` plus the eight hex digits derived from the title. Architecture ID is the accepted Reference Architecture this implementation realizes. More than one row may name the same Architecture ID. A removed row does not count as a current implementation. Status is `accepted` or `removed`.

`accepted` has a record at `implementations/<id>.md`. `removed` has no record file. A removed row stays in the index, keeps the title that last held that id, and leaves the id taken.

- The index columns are Implementation ID, Architecture ID, Implementation Title, Implementation Path, and Status.
- Implementation ID is the `RI` id. Architecture ID is the `RA` id. Implementation Path is `implementations/<RI id>.md`. Status is `accepted`.
- Order the index by ID.
- Do not allocate from `Next ID`.
- The first catalog version is `1.0.0`.
- Adding an implementation increments the minor version.
- More than one row may name the same Architecture ID.

On success, go to `platforms`.

### platforms

When `onboarding` follows this step, return to `highway-onboarding` instead of going to `close`. Do not emit the included line or ask the question.

Read the accepted implementation's Technology Choice, Runtime Components, and Realized By. It can start automation when they describe a pipeline, an orchestrator, a self-service platform, a desired-state or GitOps tool, or an agent that starts the work. A store, a newsletter, a records product, or a backup cannot. When it cannot, write nothing, say nothing, and go to `close`.

Otherwise edit `library/coding-standards/codify-platforms.md` in its existing structure. Every row comes from an accepted implementation. There is one row per Implementation ID. Rows stay in the order they were added. Platform is the implementation title. Implementation ID is its `RI` id. Kind is blank. When to use and When not to use are blank. Keep one row for this Implementation ID: when present, replace its Platform and keep its Kind, When to use, and When not to use; otherwise append it. Leave every other row unchanged. A failed write leaves the existing file unchanged. Say what failed, then go to `close`.

On success, emit:

**[Platform] is included as a platform highway can use in highway-codify proposals**

**Would you like to configure how highway-codify uses [Platform]?**

- `accept`, or a yes: emit: Let's configure how highway-codify uses [Platform]. Follow `highway-codify-config` for [Platform], with the return step `close` in `highway-implementation`.
- `decline`, or a no: go to `close`.
- `question`: answer, then re-emit the question.
- `unknown`: go to `close`.

Opening, listing, or declining does not enter `platforms`.

## Verification

- The record status is `accepted`. The parent is an `RA` id.
- `implementations/capabilities.md` is written in the same step, with ID, Parent, Title, and Realized By.
- A capability id is `CAP` plus eight hex digits. The same Parent and title reuse that id. No capability record file is written.
- Each id is `RI` plus eight hex digits derived from the title.
- The catalog index columns are Implementation ID, Architecture ID, Implementation Title, Implementation Path, and Status.
- A taken id names the conflicting titles, says a title change is appropriate, and shows a new title. The write waits until the person accepts that title.
- That message does not mention identifiers, hex, sampling, or the catalog.
- A failed write leaves existing implementation, implementation-catalog, and capability-catalog bytes unchanged.
- An accepted implementation that can start automation, such as an agent that starts the work, gets one row in `library/coding-standards/codify-platforms.md` with blank When to use and When not to use. The person is told it is included and asked whether to configure how highway-codify uses it. A yes emits "Let's configure how highway-codify uses [Platform]." and follows `highway-codify-config` for that platform with the return step `close`. A no goes to `close`. Under `onboarding`, the step returns to highway-onboarding after the write, without the included line or the question.
- A store, a newsletter, a records product, or a backup gets no row and no message. Opening, listing, or declining writes no row.
