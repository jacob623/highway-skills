---
name: highway-implementation
description: "Manages one reference implementation from one accepted reference architecture."
usage: "Invoke as /highway-implementation with one architecture id."
compatibility: all
metadata:
  version: 4.0.0
---

# highway-implementation

## Purpose

Creates one proposed Reference Implementation from an accepted Reference Architecture after the person accepts the proposed realization.

## When to use

- The person invokes `/highway-implementation` with one Reference Architecture id.
- The person invokes `/highway-implementation` without a Reference Architecture id.

## When not to use

Do not select an architecture by recency, filename, or batch.
Do not use a Reference Architecture whose status is not `accepted`.
Do not change the architecture, Discovery, Request, Profile, Objectives, Controls, or NFRs.
Do not change the ADR.
Do not create plans, tasks, source code, or infrastructure definitions.
Do not authorize deployment.
Do not create a capability record file or a capability workflow.
Do not report Status, Summary, Next Action, Blocking Reason, Missing, Complete, or Blocked.

## Inputs

- One Reference Architecture id that matches one row in `architectures/architectures.md`, when the person supplies one.
- The accepted architecture at `architectures/[ID].md`.
- Accepted Profile, Objectives, Controls, and NFRs when present.
- `clarifications/clarifications.md` when present, for `CLAR-[RA id]` only.
- `architectures/architectures.md` and `implementations/implementations.md`.
- `.highway/library/templates/output/implementation-record.md`.
- `.highway/library/templates/output/implementation-catalog.md`.
- `.highway/library/templates/output/capability-catalog.md`.
- `implementations/capabilities.md` when present.
- `.highway/governance/experience-standard.md`.
- A project root containing `.highway/`.

## Outputs

The complete structure is `.highway/library/templates/output/implementation-record.md`, `.highway/library/templates/output/implementation-catalog.md`, and `.highway/library/templates/output/capability-catalog.md`.

- One implementation record at `implementations/[ID].md` after the person accepts the proposed realization.
- An updated `implementations/implementations.md` written with that record.
- An updated `implementations/capabilities.md` written with that record.
- A closing message that names the implementation.
- No implementation when the architecture is missing, not accepted, incompatible, or a write fails.

## Procedure

Emit only the active template. Follow this order: `choose` when no architecture id is supplied; otherwise `start`, then `identifier`, `title` when needed, `write`, and `close`. The accepted Reference Architecture remains authoritative. A realization cannot redesign it or override the ADR. A missing Profile, Objective, Control, or NFR continues without invented evidence. A malformed one of those baselines stops the skill and writes nothing. Clarification is read-only. An open finding can inform a risk. It cannot block the proposal.

One accepted architecture can have more than one current implementation. A current implementation is an accepted implementation-catalog row for that architecture. A removed row does not count and does not block a new one. Creating another leaves every existing implementation in place and does not change the decision or the architecture.

### Entry

1. Read the invocation for one Reference Architecture id.
2. When none is present, go to `choose`.
3. When an id is present, resolve it. When it matches no architecture, stop. Say the architecture was not found. Write nothing.
4. When that architecture status is not `accepted`, stop. Say the architecture is not accepted. Write nothing.
5. When that architecture already has current implementations, show each current implementation, then go to `start`. A new implementation can still be proposed.
6. Otherwise go to `start`.

### choose

Read `architectures/architectures.md` and `implementations/implementations.md`. Every architecture whose Status is `accepted` can be chosen, including one that already has current implementations. Count current implementations from accepted rows for that Architecture ID. A removed row does not count. Do not open architecture records to build this list.

When none are accepted, say that no accepted Reference Architecture is available. Write nothing.

Otherwise emit one numbered line per accepted architecture, starting at 1, in architecture catalog order. Show the Architecture ID, its title, and how many current implementations it has. A stated number selects that architecture.

**1. [Architecture ID]:** [Architecture Title] — [count] current implementations

**Which Reference Architecture would you like to realize?**

- A Reference Architecture id, a listed architecture title, or its number: follow Entry from case 3.
- `unknown`: re-emit this list. Stay on `choose`.
- `decline`: stop. Write nothing.

### Classify

Classify the latest reply before any other action.

- `edit`: adds, removes, corrects, or replaces realization text.
- `accept`: affirms the proposed realization and adds no fact.
- `unknown`: the person says they do not know.
- `question`: asks for an explanation.
- `decline`: the person stops or cancels.

On `start`, "looks good" is `accept`.

### start

Build the proposed realization from the accepted architecture. Cover every responsibility the architecture states. Mark a row `not applicable` only when that stated responsibility does not apply to this realization. Do not add a responsibility the architecture does not state. For each thing the architecture left free, state the choice this realization made, or `None` when nothing may vary. State the realized interface for each architecture interface, how conformance was shown, and the limitations of this realization, each or `None`. State one technology choice, with its intent, its reason, and its evidence. When evidence does not support a technology, use `Unknown` rather than inventing one.

When a proposed realization contradicts the architecture, name the requirement, the conflict, and the impact. Offer `Resolve implementation` or `Revisit architecture`. Do not write.

**Here is a proposed starting point for your implementation:**

**Summary:** [What this realization does.]

**Realizations:**
- **[Component]:** [Technology or mechanism, and the responsibility it covers.]

**Deployment:** [Where and how it runs.]

**Data:** [How data is stored and moved, or `None`.]

**Security:** [How accepted Controls are realized, or `None`.]

**Operations:** [How accepted NFRs are met in operation, or `None`.]

**Capabilities:**
- **[Business capability]:** Realized by [provider or mechanism]. A capability is a business outcome, not a component name.

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: emit one consequence sentence. Re-emit this block with the edit applied. Stay on `start`.
- `accept`: when a stated responsibility is neither covered nor marked not applicable, name it and stay on `start`. Otherwise go to `identifier`.
- `unknown`: re-emit this block. Stay on `start`.
- `question`: answer, then re-emit this block. Stay on `start`.
- `decline`: stop. Write nothing.

### identifier

The implementation title is the architecture title unless the person supplied a title.

1. Lowercase the title. Remove hyphens and apostrophes. Split the rest into words.
2. Take eight letters: the first two of word 1, the first two of word 2, the first two of word 3, and the last two of the last word. When the title has only two words, the third sample is the first two of the last word.
3. When a word is shorter than two letters, continue into the next word. A one-word title repeats until there are eight letters.
4. Map each letter. Digits stay as they are.

a 0, b 1, c 2, d 3, e 4, f 5, g 6, h 7, i 8, j 9, k a, l b, m c, n d, o e, p f, q 0, r 1, s 2, t 3, u 4, v 5, w 6, x 7, y 8, z 9.

5. The id is `RI` plus those eight hex digits.

Compare that id with `implementations/implementations.md`, including removed rows.

- The same title already has that id: use the existing record. Do not write a second one. Go to `close`.
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

The record follows `.highway/library/templates/output/implementation-record.md`.

- `id` is the derived `RI` id.
- `architecture` is the Reference Architecture id.
- `status` is `accepted`.
- The title is the accepted implementation title.
- Include Variation Choices, Coverage, Realized Interfaces, Conformance Evidence, Limitations, Technology Choice, Context, Implementation Summary, Realized Capabilities, Runtime Components, Data Realization, Integration Realization, Security Control Realization, NFR Realization, Assumptions, Risks, Constraints, Dependencies, and Traceability.
- Coverage has one row per responsibility the architecture states. Status is covered or not applicable.
- When every row is covered or not applicable, Conformance is `compatible`. Do not write a gap section or a conflict section.
- When a stated responsibility is uncovered, Conformance is `incomplete` and the gap is stated.
- A technology choice is stated once, with its intent, its reason, and its evidence.
- The architecture is named once, in Architecture Reference.
- Security Control Realization and NFR Realization project the accepted Controls and NFRs. Do not change those records.
- Traceability names the Request, Discovery, the decision this realization came from, and this implementation. Do not name the architecture again.
- Each realized capability has a business-readable title and one or more Realized By values.

`implementations/capabilities.md` follows `.highway/library/templates/output/capability-catalog.md`.

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

The catalog follows `.highway/library/templates/output/implementation-catalog.md`.

- The index columns are Implementation ID, Architecture ID, Implementation Title, Implementation Path, and Status.
- Implementation ID is the `RI` id. Architecture ID is the `RA` id. Implementation Path is `implementations/<RI id>.md`. Status is `accepted`.
- Order the index by ID.
- Do not allocate from `Next ID`.
- The first catalog version is `1.0.0`.
- Adding an implementation increments the minor version.
- More than one row may name the same Architecture ID.

On success, go to `close`.

### close

**Reference Implementation recorded**

- **Implementation record:** `implementations/[RI id].md`
- **Title:** [Title]
- **Identifier:** `[RI id]`
- **Architecture:** `[RA id]`

This is a realization blueprint. It does not authorize deployment.

## Verification

- A Reference Architecture id for an accepted architecture opens the proposed realization.
- An invocation without an id lists every accepted architecture. Each line shows the Architecture ID, its title, and how many current implementations it has. The list is numbered. A stated number selects that architecture. A removed implementation row does not count as current.
- When an architecture already has current implementations, those implementations are shown and a new one can still be proposed.
- Declining a proposal writes nothing, and existing implementations stay as they were.
- An architecture that is not accepted writes nothing.
- One accepted architecture can have more than one current implementation. Creating another leaves the existing ones in place.
- The proposed realization is accepted before the record is written.
- A contradiction with the architecture writes nothing.
- Coverage rows are the architecture's stated responsibilities. Conformance is `compatible` when every row is covered or not applicable, and that record has no gap section and no conflict section. An uncovered responsibility is `incomplete` and states the gap.
- The architecture is named once. A technology choice is stated once.
- The record status is `accepted`. The parent is an `RA` id.
- `implementations/capabilities.md` is written in the same step, with ID, Parent, Title, and Realized By.
- A capability id is `CAP` plus eight hex digits. The same Parent and title reuse that id. No capability record file is written.
- The record contains no plans, tasks, source code, or infrastructure definitions.
- Each id is `RI` plus eight hex digits derived from the title.
- The catalog index columns are Implementation ID, Architecture ID, Implementation Title, Implementation Path, and Status.
- A taken id names the conflicting titles, says a title change is appropriate, and shows a new title. The write waits until the person accepts that title.
- That message does not mention identifiers, hex, sampling, or the catalog.
- A failed write leaves existing implementation, implementation-catalog, and capability-catalog bytes unchanged.
- The skill does not change the Reference Architecture, the decision statement, the rationale, the selected option, or the decision status.
- The skill does not write an implementation id onto the ADR.

## Error Handling

- A missing or unknown architecture stops the skill and writes nothing.
- An architecture that is not accepted stops the skill and writes nothing.
- A realization that contradicts the architecture stops the write and names the conflict.
- A malformed present Profile, Objective, Control, or NFR baseline stops the skill and writes nothing.
- A failed write leaves the architecture and every other implementation unchanged, and leaves existing implementation, implementation-catalog, and capability-catalog bytes unchanged.
- Declining a proposal writes nothing.

## Example

`/highway-implementation RAb7c41e20`