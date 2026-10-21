---
name: highway-implementation
description: "Manages one reference implementation from one accepted reference architecture."
usage: "Invoke as /highway-implementation with one architecture id."
compatibility: all
metadata:
  version: 2.0.0
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
Do not change the architecture, ADR, Discovery, Request, Profile, Objectives, Controls, or NFRs.
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

One accepted architecture produces at most one implementation. When the implementation catalog already has that architecture as Parent, show the recorded implementation and write nothing.

### Entry

1. Read the invocation for one Reference Architecture id.
2. When none is present, go to `choose`.
3. When an id is present, resolve it. When it matches no architecture, stop. Say the architecture was not found. Write nothing.
4. When that architecture status is not `accepted`, stop. Say the architecture is not accepted. Write nothing.
5. When that architecture is already Parent of an implementation, show the recorded implementation. Write nothing.
6. Otherwise go to `start`.

### choose

Read `architectures/architectures.md` and `implementations/implementations.md`. An architecture is waiting when its Status is `accepted` and its Architecture ID does not appear on any implementation catalog row. A removed implementation row still counts as that architecture already having an implementation. Do not open architecture records to build this list.

When none are waiting, say that no Reference Architecture is waiting for an implementation. Write nothing.

Otherwise emit one numbered line per waiting architecture, starting at 1, in architecture catalog order. Show the Architecture ID and its title. A stated number selects that architecture.

**1. [Architecture ID]:** [Architecture Title]

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

Build the proposed realization from the accepted architecture. Cover every responsibility the architecture includes. Use `Not applicable` only when the architecture does not include that responsibility. When evidence does not support a technology, use `Unknown` rather than inventing one.

The responsibilities are Compute, Messaging, Persistence, Identity, Networking, Security, Observability, Recovery, Deployment, and Operations.

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
- `accept`: when any included responsibility is still unsatisfied, name it and stay on `start`. Otherwise go to `identifier`.
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
- Include Context, Implementation Summary, Technology Realization, Runtime Components, Deployment Topology, Environment Strategy, Data Realization, Integration Realization, Security Control Realization, NFR Realization, Lifecycle Activities, Assumptions, Risks, Constraints, Dependencies, and Traceability.
- Lifecycle Activities are design, build, test, deploy, operate, monitor, and improve.
- Security Control Realization and NFR Realization project the accepted Controls and NFRs. Do not change those records.
- Traceability names the Request, Discovery, ADR, Reference Architecture, and this implementation.
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
- One Reference Architecture id appears as Parent on at most one row.

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
- An invocation without an id lists the accepted architectures whose Architecture ID is absent from every implementation catalog row. Each line shows the Architecture ID and its title. The list is numbered. A stated number selects that architecture. A removed implementation row keeps that architecture off the list.
- An architecture that is not accepted writes nothing.
- One accepted architecture produces at most one implementation.
- The proposed realization is accepted before the record is written.
- A contradiction with the architecture writes nothing.
- The record status is `accepted`.
- `implementations/capabilities.md` is written in the same step, with ID, Parent, Title, and Realized By.
- A capability id is `CAP` plus eight hex digits. The same Parent and title reuse that id. No capability record file is written.
- The record contains no plans, tasks, source code, or infrastructure definitions.
- Each id is `RI` plus eight hex digits derived from the title.
- The catalog index columns are Implementation ID, Architecture ID, Implementation Title, Implementation Path, and Status.
- A taken id names the conflicting titles, says a title change is appropriate, and shows a new title. The write waits until the person accepts that title.
- That message does not mention identifiers, hex, sampling, or the catalog.
- A failed write leaves existing implementation, implementation-catalog, and capability-catalog bytes unchanged.
- The skill does not change the Reference Architecture.

## Error Handling

- A missing or unknown architecture stops the skill and writes nothing.
- An architecture that is not accepted stops the skill and writes nothing.
- A second implementation for the same architecture stops the write and shows the existing implementation.
- A realization that contradicts the architecture stops the write and names the conflict.
- A malformed present Profile, Objective, Control, or NFR baseline stops the skill and writes nothing.
- A failed write leaves existing implementation, implementation-catalog, and capability-catalog bytes unchanged.

## Example

`/highway-implementation RAb7c41e20`