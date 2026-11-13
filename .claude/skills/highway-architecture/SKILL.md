---
name: highway-architecture
description: "Manages one reference architecture from one accepted adr. Use when an ADR is accepted and the person wants the reference architecture that realizes it, or when highway-onboarding hands off an accepted ADR."
license: Apache-2.0
metadata:
  version: 5.8.0
  usage: "Run highway-architecture with one adr id."
---

# highway-architecture

## Purpose

Creates one proposed Reference Architecture from an accepted ADR after the person accepts the proposed architecture.

## When to use

- The person invokes `highway-architecture` with one ADR id.
- The person invokes `highway-architecture` without an ADR id.
- `highway-onboarding` hands off an accepted ADR id.

## When not to use

Do not select an ADR by recency, filename, or batch.
Do not use an ADR whose status is not `accepted`.
Do not change the Discovery, Request, Profile, Objectives, Controls, or NFRs.
Do not change the ADR or its catalog row, except its Reference Architecture field and its Architecture ID.
Do not select a different ADR alternative.
Do not create a Reference Implementation or authorize implementation.
Do not create capability records or capability ids.
Do not report Status, Summary, Next Action, Blocking Reason, Missing, Complete, or Blocked.

## Inputs

- One ADR id that matches one row in `adrs/adrs.md`, when the person supplies one.
- `adrs/adrs.md` and `architectures/architectures.md`.
- The accepted ADR at `adrs/[ID].md`.
- Accepted Profile, Objectives, Controls, and NFRs when present.
- `architectures/architectures.md` and `architectures/RA*.md` when present.
- `assets/architecture-record.md`.
- `highway-implementation`.
- The highway-experience skill, activated first.

## Outputs

The complete structure is `assets/architecture-record.md`. `adrs/adrs.md` and `architectures/architectures.md` keep the structure highway-setup seeded.

- One architecture record at `architectures/[ID].md` after the person accepts the proposed architecture, or when `highway-onboarding` hands off an accepted ADR id.
- An updated `architectures/architectures.md` written with that record.
- The ADR's Reference Architecture field set to that architecture id, and the ADR's Architecture ID in `adrs/adrs.md` set to the same id.
- A closing message that names the architecture and the implementation command.
- No architecture when the ADR is missing, not accepted, or a write fails.

## Procedure

Activate the highway-experience skill before any output the person sees, and follow it for Highway's identity, the Experience Standard, and the storage contract.

Before the first question, confirm these seeded files exist: `adrs/adrs.md`, `architectures/architectures.md`.
When any is absent, emit the message below exactly, stop, and write nothing.

**Oops... we need to setup your repository.**

Highway needs to gather your organizational preferences and set up your repository. Run highway-setup to get started.

Emit only the active template. Follow this order: `onboarding` when `highway-onboarding` hands off an accepted ADR id; `choose` when no ADR id is supplied; otherwise `start`, then `identifier`, `title` when needed, `write`, `name`, and `close`. The ADR remains the decision. Inherit its decision, rationale, alternatives, consequences, and constraints without changing their meaning. Describe the architecture in conceptual terms. A platform, product, vendor, or specific technology stays in the inherited decision and is not part of the architecture. A missing Profile, Objective, Control, or NFR continues without invented evidence. A malformed one of those baselines stops the skill and writes nothing.

One accepted ADR produces at most one architecture. When the architecture catalog already has that ADR as Parent, show the recorded architecture and write no second one.

Before a step in this table, read its file and follow it to the end.

| File | Steps |
| --- | --- |
| `references/proposal.md` | `start` |
| `references/record.md` | `identifier`, `title`, `write`, `name` |

### Entry

When `highway-onboarding` hands off an accepted ADR id, go to `onboarding`.

1. Read the invocation for one ADR id. When it has no ADR id and contains the exact title of one waiting ADR, as `choose` defines it, that ADR's id is present. Compare without regard to case.
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

### onboarding

`highway-onboarding` hands off one accepted ADR id. Write the architecture as accepted without asking the person, except for the questions in step 4. Emit nothing else.

1. Resolve the ADR as Entry does from case 3. When Entry would stop, return to `highway-onboarding` and say why.
2. When the ADR's Reference Architecture field names an `RA` id, return that id to `highway-onboarding`. Write nothing. When the ADR already appears in an architecture catalog ADR ID cell and its field is still `None`, follow `name` for that architecture, then return its id.
3. Build the architecture as `start` does, without emitting it. Current Decisions is this ADR. Do not write Key Technologies. Do not copy the decision statement. Do not ask whether a decision replaces or runs beside another.
4. Derive the title and the id as `identifier` does. Ask only these: the purpose question, when `identifier` would ask it; the `title` message, when `identifier` would go to `title`. Write nothing until the person gives a usable title. A `decline` writes nothing and returns to `highway-onboarding` without an architecture.
5. When `identifier` reuses the existing record, go to step 6. Otherwise write as `write` does. The catalog ADR ID cell is this ADR id. A failed write leaves every existing architecture byte unchanged. Return to `highway-onboarding` and say the architecture could not be written.
6. Follow `name`. Do not go to `close`. Return the `RA` id to `highway-onboarding`. When the ADR could not be updated, say so with the id.

### Classify

Classify the latest reply before any other action.

- `edit`: adds, removes, corrects, or replaces architecture text.
- `accept`: affirms the proposed architecture and adds no fact.
- `unknown`: the person says they do not know.
- `question`: asks for an explanation.
- `decline`: the person stops or cancels.

On `start`, "looks good" is `accept`.

### close

**Reference Architecture accepted**

- **Architecture record:** `architectures/[RA id].md`
- **Title:** [Title]
- **Identifier:** `[RA id]`
- **ADR:** `[ADR id]`

Run `highway-implementation [RA id]` to create the Reference Implementation.

## Verification

- An ADR id for an accepted ADR opens the proposed architecture.
- An invocation without an ADR id lists the accepted ADRs whose ADR ID is absent from every architecture catalog row. Each line shows the ADR ID and its title. The list is numbered. A stated number selects that ADR. A removed architecture row keeps that ADR off the list.
- One accepted ADR produces at most one architecture.
- The proposed architecture is accepted before the record is written.
- The architecture does not change the ADR decision.
- The architecture remains conceptual. It names no platform, product, vendor, or specific technology. It has no Key Technologies section.
- The record identifier is an `RA` id. The record status is `accepted` after the person accepts the architecture. It does not use an `ARCH` identifier or status `proposed`.
- Context states when the architecture applies and what it leaves open. The style states why it was chosen.
- Variation, Responsibilities, Information, and each component's responsibility and interface are in the record.
- Relationship lines use `advances`, `bound by`, and `satisfies`, or `None`.
- Required capabilities name their component, follow the capability title rule, and have no capability ids.
- Implementation is not authorized.
- The closing message names `highway-implementation [RA id]`.
- The skill creates no Reference Implementation.
- A handoff from `highway-onboarding` writes an accepted architecture without a proposal, names it on the ADR and in the ADR catalog, and returns its `RA` id. It asks only the purpose question or the title message, when the title cannot be used. A `decline` writes nothing.

## Error Handling

- A missing or unknown ADR stops the skill and writes nothing.
- An ADR that is not accepted stops the skill and writes nothing.
- A second architecture for the same ADR stops the write and shows the existing architecture.
- A malformed present Profile, Objective, Control, or NFR baseline stops the skill and writes nothing.
- A failed write leaves existing architecture and catalog bytes unchanged.
- A failed ADR update keeps the architecture, says the ADR could not be updated, and does not call the chain complete.

## Example

`/highway-architecture ADRb7c41e20`