---
name: highway-architecture
description: "Manages one reference architecture from one accepted adr."
usage: "Invoke as /highway-architecture with one adr id."
compatibility: all
metadata:
  version: 4.0.0
---

# highway-architecture

## Purpose

Creates one proposed Reference Architecture from an accepted ADR after the person accepts the proposed architecture.

## When to use

- The person invokes `/highway-architecture` with one ADR id.
- The person invokes `/highway-architecture` without an ADR id.

## When not to use

Do not select an ADR by recency, filename, or batch.
Do not use an ADR whose status is not `accepted`.
Do not change the Discovery, Request, Profile, Objectives, Controls, or NFRs.
Do not change the ADR, except its Reference Architecture field.
Do not select a different ADR alternative.
Do not create a Reference Implementation or authorize implementation.
Do not create capability records or capability ids.
Do not report Status, Summary, Next Action, Blocking Reason, Missing, Complete, or Blocked.

## Inputs

- One ADR id that matches one row in `adrs/adrs.md`, when the person supplies one.
- `adrs/adrs.md` and `architectures/architectures.md`.
- The accepted ADR at `adrs/[ID].md`.
- `.highway/library/templates/output/adr-record.md`.
- Accepted Profile, Objectives, Controls, and NFRs when present.
- `architectures/architectures.md` and `architectures/RA*.md` when present.
- `.highway/library/templates/output/architecture-record.md`.
- `.highway/library/templates/output/architecture-catalog.md`.
- `.highway/governance/experience-standard.md`.
- A project root containing `.highway/`.

## Outputs

The complete structure is `.highway/library/templates/output/architecture-record.md` and `.highway/library/templates/output/architecture-catalog.md`.

- One architecture record at `architectures/[ID].md` after the person accepts the proposed architecture.
- An updated `architectures/architectures.md` written with that record.
- The ADR's Reference Architecture field set to that architecture id.
- A closing message that names the architecture and the implementation command.
- No architecture when the ADR is missing, not accepted, or a write fails.

## Procedure

Emit only the active template. Follow this order: `choose` when no ADR id is supplied; otherwise `start`, then `identifier`, `title` when needed, `write`, `name`, and `close`. The ADR remains the decision. Inherit its decision, rationale, alternatives, consequences, and constraints without changing their meaning. Describe the architecture in conceptual terms. A platform, product, vendor, or specific technology stays in the inherited decision and is not part of the architecture. A missing Profile, Objective, Control, or NFR continues without invented evidence. A malformed one of those baselines stops the skill and writes nothing.

One accepted ADR produces at most one architecture. When the architecture catalog already has that ADR as Parent, show the recorded architecture and write no second one.

### Entry

1. Read the invocation for one ADR id.
2. When none is present, go to `choose`.
3. When an ADR id is present, resolve it. When it matches no ADR, stop. Say the ADR was not found. Write nothing.
4. When that ADR status is not `accepted`, stop. Say the ADR is not accepted. Write nothing.
5. When the ADR's Reference Architecture field names an RA id, show that architecture and write nothing.
6. When that ADR already appears in an architecture catalog ADR ID cell, show the recorded architecture. When the ADR's Reference Architecture field is still `None`, go to `name`. Otherwise write nothing.
7. Otherwise go to `start`. Create an architecture only when the accepted ADR names none.

### choose

Read `adrs/adrs.md` and `architectures/architectures.md`. An ADR is waiting when its Status is `accepted`, its Architecture ID column is `None`, and its ADR ID does not appear as a whole id in any architecture catalog ADR ID cell. A removed architecture row still counts as that ADR already having an architecture. Do not open ADR records to build this list.

When none are waiting, say that no ADR is waiting for a Reference Architecture. Write nothing.

Otherwise emit one numbered line per waiting ADR, starting at 1, in ADR catalog order. Show the ADR ID and its title. A stated number selects that ADR.

**1. [ADR ID]:** [ADR Title]

**Which ADR would you like to turn into a Reference Architecture?**

- An ADR id, a listed ADR title, or its number: follow Entry from case 3.
- `unknown`: re-emit this list. Stay on `choose`.
- `decline`: stop. Write nothing.

### Classify

Classify the latest reply before any other action.

- `edit`: adds, removes, corrects, or replaces architecture text.
- `accept`: affirms the proposed architecture and adds no fact.
- `unknown`: the person says they do not know.
- `question`: asks for an explanation.
- `decline`: the person stops or cancels.

On `start`, "looks good" is `accept`.

### start

Build the proposed architecture from the accepted ADR. Keep it conceptual. Do not authorize implementation. Do not name a platform, product, vendor, or specific technology.

**Here is a proposed starting point for your architecture:**

**Summary:** [What this architecture is, in conceptual terms.]

**Applies:** [When this architecture applies.]

**Leaves open:** [What it leaves open.]

**Style:** [The conceptual style.]

**Why:** [Why this style was chosen.]

**Components:**
- **[Component]:** [Its responsibility.] Interface: [What other components rely on, or `None`.]

**Information:** [What it handles, who owns it, and what crosses a trust boundary, or `None`.]

**Must keep:** [What every implementation must keep.]

**May choose:** [What an implementation may choose, or `None`. A variation names no product.]

**Responsibilities:**
- [A responsibility a realization covers or marks not applicable.]

**Interactions:** [How the components communicate, without naming a product or platform.]

**Trust boundaries:** [Ownership and responsibility boundaries, or `None`.]

**Deployment:** [The conceptual deployment approach, or `None`.]

**Constraints:** [ADR, Control, and NFR constraints, or `None`.]

**Risks:** [Architecture risks, or `None`.]

**Capabilities:** [The component that offers each one, or `None`. No capability identifier.]

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: emit one consequence sentence. When the edit names a platform, product, vendor, or specific technology, say that it belongs on the Reference Implementation and leave it out of this architecture. Re-emit this block with the edit applied. Stay on `start`.
- `accept`: go to `identifier`.
- `unknown`: re-emit this block. Stay on `start`.
- `question`: answer, then re-emit this block. Stay on `start`.
- `decline`: stop. Write nothing.

### identifier

The architecture title is the ADR title unless the person supplied a title.

1. Lowercase the title. Remove hyphens and apostrophes. Split the rest into words.
2. Take eight letters: the first two of word 1, the first two of word 2, the first two of word 3, and the last two of the last word. When the title has only two words, the third sample is the first two of the last word.
3. When a word is shorter than two letters, continue into the next word. A one-word title repeats until there are eight letters.
4. Map each letter. Digits stay as they are.

a 0, b 1, c 2, d 3, e 4, f 5, g 6, h 7, i 8, j 9, k a, l b, m c, n d, o e, p f, q 0, r 1, s 2, t 3, u 4, v 5, w 6, x 7, y 8, z 9.

5. The id is `RA` plus those eight hex digits.

Compare that id with `architectures/architectures.md`, including removed rows.

- The same title already has that id: use the existing record. Do not write a second one. Go to `name`.
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

The record follows `.highway/library/templates/output/architecture-record.md`.

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
- Required Capabilities name the component that offers each one. Do not assign capability ids. The section is `None` when no capability applies.
- Traceability names the Request, Discovery, the current decisions, and this architecture.
- Reference Implementation Guidance does not authorize implementation.
- Empty optional evidence is `None`.
- Emit no timestamp, random value, or environment value.

The catalog follows `.highway/library/templates/output/architecture-catalog.md`.

- The index columns are Architecture ID, ADR ID, Architecture Title, Architecture Path, and Status.
- Architecture ID is the `RA` id. The ADR ID cell lists every current decision id in id order, separated by a comma and a space. At creation that cell is this ADR id. Architecture Path is `architectures/<RA id>.md`. Status is `accepted`.
- Order the index by ID.
- Do not allocate from `Next ID`.
- The first catalog version is `1.0.0`.
- Adding an architecture increments the minor version.
- One ADR id appears on at most one row. A removed row has no record file.

On success, go to `name`.

### name

Set the ADR's `Reference Architecture` field to this `RA` id. Change no other ADR byte. The decision statement, rationale, selected option, and status stay as they were.

When the ADR cannot be updated, keep the architecture record and catalog. Say the ADR could not be updated to name this architecture, and that running `/highway-architecture [ADR id]` again will name it. Do not call the decision, architecture, and implementation chain complete.

Then go to `close`.

### close

**Reference Architecture accepted**

- **Architecture record:** `architectures/[RA id].md`
- **Title:** [Title]
- **Identifier:** `[RA id]`
- **ADR:** `[ADR id]`

Run `/highway-implementation [RA id]` to create the Reference Implementation.

## Verification

- An ADR id for an accepted ADR opens the proposed architecture.
- An invocation without an ADR id lists the accepted ADRs whose ADR ID is absent from every architecture catalog row. Each line shows the ADR ID and its title. The list is numbered. A stated number selects that ADR. A removed architecture row keeps that ADR off the list.
- One accepted ADR produces at most one architecture.
- The proposed architecture is accepted before the record is written.
- The architecture does not change the ADR decision.
- After the architecture is written, the ADR's Reference Architecture field names it. No other ADR field changes.
- When that ADR update fails, the architecture remains and the chain is not called complete. A later invocation for the same ADR names it.
- The architecture remains conceptual. It names no platform, product, vendor, or specific technology. It has no Key Technologies section.
- The record identifier is an `RA` id. The record status is `accepted` after the person accepts the architecture. It does not use an `ARCH` identifier or status `proposed`.
- Context states when the architecture applies and what it leaves open. The style states why it was chosen.
- Variation, Responsibilities, Information, and each component's responsibility and interface are in the record.
- Current Decisions lists every current decision that names this architecture, and the catalog ADR ID cell lists those same ids. A decision statement is not copied.
- Relationship lines use `advances`, `bound by`, and `satisfies`, or `None`.
- Required capabilities name their component and have no capability ids.
- Implementation is not authorized.
- Each id is `RA` plus eight hex digits derived from the title.
- The catalog index columns are Architecture ID, ADR ID, Architecture Title, Architecture Path, and Status.
- A taken id names the conflicting titles, says a title change is appropriate, and shows a new title. The write waits until the person accepts that title.
- That message does not mention identifiers, hex, sampling, or the catalog.
- A failed write leaves existing architecture bytes unchanged.
- The closing message names `/highway-implementation [RA id]`.
- The skill creates no Reference Implementation.

## Error Handling

- A missing or unknown ADR stops the skill and writes nothing.
- An ADR that is not accepted stops the skill and writes nothing.
- A second architecture for the same ADR stops the write and shows the existing architecture.
- A malformed present Profile, Objective, Control, or NFR baseline stops the skill and writes nothing.
- A failed write leaves existing architecture and catalog bytes unchanged.
- A failed ADR update keeps the architecture, says the ADR could not be updated, and does not call the chain complete.

## Example

`/highway-architecture ADRb7c41e20`