---
name: highway-implementation
description: "Manages one reference implementation from one accepted reference architecture. Use when a reference architecture is accepted and the person wants the implementation that realizes it, or when another highway skill hands one off."
license: Apache-2.0
metadata:
  version: 7.16.0
  usage: "Run highway-implementation with one architecture id."
---

# highway-implementation

## Purpose

Creates one proposed Reference Implementation from an accepted Reference Architecture after the person accepts the proposed realization, and records new realized capabilities on an accepted implementation when `highway-codify-config` passes them, and sets the preferred delivery platforms on an accepted implementation when `highway-codify` hands it off.

## When to use

- The person invokes `highway-implementation` with one Reference Architecture id.
- The person invokes `highway-implementation` without a Reference Architecture id.
- `highway-codify-config` names an accepted implementation, new realized capabilities, and a return step.
- `highway-codify` names an accepted implementation and a return step.
- `highway-onboarding` hands off an accepted Reference Architecture id, a provider, and the capabilities it serves.

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
- `assets/implementation-record.md`.
- `implementations/capabilities.md` and `library/coding-standards/codify-platforms.md`.
- The highway-experience skill, activated first.

## Outputs

The complete structure is `assets/implementation-record.md`. `implementations/implementations.md`, `implementations/capabilities.md`, and `library/coding-standards/codify-platforms.md` keep the structure highway-setup seeded.

- One implementation record at `implementations/[ID].md` after the person accepts the proposed realization, or when `highway-onboarding` hands off an accepted Reference Architecture id.
- An updated `implementations/implementations.md` written with that record.
- An updated `implementations/capabilities.md` written with that record.
- One row in `library/coding-standards/codify-platforms.md`, with blank When to use and When not to use, when the accepted implementation can start automation.
- A closing message that names the implementation.
- New realized capabilities appended to an accepted implementation and to its rows in `implementations/capabilities.md`, when `highway-codify-config` passes them.
- Rewritten Execution lines on an accepted implementation, when `highway-codify` hands it off and the person accepts.
- No implementation when the architecture is missing, not accepted, incompatible, or a write fails.

## Procedure

Activate the highway-experience skill before any output the person sees, and follow it for Highway's identity, the Experience Standard, and the storage contract.

Before the first question, confirm these seeded files exist: `implementations/implementations.md`, `implementations/capabilities.md`, `library/coding-standards/codify-platforms.md`.
When any is absent, emit the message below exactly, stop, and write nothing.

**Oops... we need to setup your repository.**

Highway needs to gather your organizational preferences and set up your repository. Run highway-setup to get started.

Emit only the active template. Follow this order: `onboarding` when `highway-onboarding` hands off an accepted Reference Architecture id; `add capabilities` when `highway-codify-config` passes new realized capabilities; `delivery platforms`, with `delivery decline`, when `highway-codify` hands off an accepted implementation; `choose` when no architecture id is supplied; otherwise `start`, which follows `execution`, then `identifier`, `title` when needed, `write`, `platforms`, and `close`. The accepted Reference Architecture remains authoritative. A realization cannot redesign it or override the ADR. A missing Profile, Objective, Control, or NFR continues without invented evidence. A malformed one of those baselines stops the skill and writes nothing. Clarification is read-only. An open finding can inform a risk. It cannot block the proposal.

One accepted architecture can have more than one current implementation. A current implementation is an accepted implementation-catalog row for that architecture. A removed row does not count and does not block a new one. Creating another leaves every existing implementation in place and does not change the decision or the architecture.

Before a step in this table, read its file and follow it to the end.

| File | Steps |
| --- | --- |
| `references/proposal.md` | `start` |
| `references/record.md` | `identifier`, `title`, `write`, `platforms` |
| `references/amend.md` | `add capabilities`, `delivery platforms`, `delivery decline` |

### Entry

When `highway-onboarding` hands off an accepted `RA` id, a provider, and the capabilities it serves, go to `onboarding`.

1. When the invocation names an accepted implementation, new realized capabilities, and a return step, go to `add capabilities`.
2. When the invocation names an accepted implementation and a return step, and names no realized capabilities, go to `delivery platforms`.
3. Read the invocation for one Reference Architecture id. When it has none and contains the exact title of one accepted architecture, that architecture's id is present. Compare without regard to case.
4. When none is present, go to `choose`.
5. When an id is present, resolve it. When it matches no architecture, stop. Say the architecture was not found. Write nothing.
6. When that architecture status is not `accepted`, stop. Say the architecture is not accepted. Write nothing.
7. When that architecture already has current implementations, show each current implementation, then go to `start`. A new implementation can still be proposed.
8. Otherwise go to `start`.

### choose

Read `architectures/architectures.md` and `implementations/implementations.md`. Every architecture whose Status is `accepted` can be chosen, including one that already has current implementations. Count current implementations from accepted rows for that Architecture ID. A removed row does not count. Do not open architecture records to build this list.

When none are accepted, say that no accepted Reference Architecture is available. Write nothing.

Otherwise emit one numbered line per accepted architecture, starting at 1, in architecture catalog order. Show the Architecture ID, its title, and how many current implementations it has. A stated number selects that architecture.

**1. [Architecture ID]:** [Architecture Title] — [count] current implementations

**Which Reference Architecture would you like to realize?**

Classify the reply:

- A Reference Architecture id, a listed architecture title, or its number: follow Entry from case 4.
- `unknown`: re-emit this list. Stay on `choose`.
- `decline`: stop. Write nothing.

### onboarding

`highway-onboarding` hands off one accepted `RA` id, the provider, and the capabilities it serves. Write the implementation as accepted without asking the person, except for the question in step 4. Emit nothing else. This visit returns only to `highway-onboarding`. Do not go to a step another `highway-implementation` visit holds.

1. Resolve the architecture as Entry does from case 5. When Entry would stop, return to `highway-onboarding` and say why. Do not show current implementations.
2. Build the realization as `start` does, without emitting it. Do not follow `execution`. The technology choice is the provider. Follow `capability title` for each capability the provider serves. When the realization would contradict the architecture, write nothing. Return to `highway-onboarding` and say the implementation could not be written.
3. Execution is `Deployed by: Needed`, `Managed by: Needed`, and `Language: Needed`.
4. Derive the title and the id as `identifier` does. Ask only the `title` message, when `identifier` would go to `title`. Write nothing until the person gives a usable title. A `decline` writes nothing and returns to `highway-onboarding` without an implementation.
5. When `identifier` reuses the existing record, go to step 6. Otherwise write as `write` does. A failed write leaves every existing implementation and capability-catalog byte unchanged. Return to `highway-onboarding` and say the implementation could not be written.
6. Follow `platforms`. Return the `RI` id to `highway-onboarding`, and whether `platforms` included the platform.

### Classify

Classify the latest reply before any other action.

- `edit`: adds, removes, corrects, or replaces realization text.
- `accept`: affirms the proposed realization and adds no fact.
- `unknown`: the person says they do not know.
- `question`: asks for an explanation.
- `decline`: the person stops or cancels.

On `start`, "looks good" is `accept`.

### execution

Read `library/coding-standards/codify-platforms.md` when present. A row with a blank Kind is not a candidate. This implementation's row is not a candidate. Read `library/coding-standards/coding-standards.md` when present.

1. Deployed by is the earliest candidate whose Kind is `pipeline`. When none, the earliest `orchestrator`. When none, the earliest `desired-state`. When none, the earliest `agent`.
2. Managed by is the earliest candidate whose Kind is `self-service`. When none, the earliest `agent`. When none, the Deployed by row.
3. Language is the earliest standard whose Technology appears on its own in a Technology Choice `Choice:`. Compare without regard to case. A boundary on each side makes an entry appear on its own. When none match, Language is None.
4. When Deployed by or Managed by has no row, hold `Needed`. Do not take the first catalog row.
5. Return to the step that named this one.

### field

1. A platforms-catalog row replaces Deployed by or Managed by. Show its title.
2. When the name has an accepted implementation and no row, emit "Let's configure [Platform]." Then follow `highway-codify-config` for [Platform], with the return step `execution` in `highway-implementation`.
3. When the name has no accepted implementation, emit "Let's onboard [Platform]." Then follow `highway-onboarding` for [Platform], with the return step `execution` in `highway-implementation`.
4. A listed coding-standard title, or None, replaces Language. Any other title is left out. Say: [Title] is not a listed coding standard. To add it, run highway-codify-config.
5. Re-emit the proposal. Stay on `start`.

### why it matters

[Product title] is the implementation title. [codify platform] is the platform the field names. [Language] is the standard Language names. Emit the line that fits each field:

- Deployed by names a platform: highway-codify will use [codify platform] to get [Product title] up and running.
- Deployed by is Needed: highway-codify needs a codify platform to get [Product title] up and running.
- Managed by names a platform: highway-codify will use [codify platform] for managing [Product title] once its running.
- Managed by is Needed: highway-codify needs a codify platform for managing [Product title] once its running.
- Language names a standard: highway-codify will treat [Product title] as a [Language] coding project.
- Language is None: highway-codify will treat this as a Platform to manage as opposed to a coding project to write.

### capability title

1. Each capability title follows the capability title rule.
2. Split a title that joins two things into one capability per part, in its place in the list. Do not ask first. Each part keeps every other value of the entry it came from.
3. Shorten a title of six or more words to five words or fewer. Keep its meaning.
4. Leave out a part that matches a capability already listed.
5. When step 2 changed an edit, its consequence sentence is: [Entry] is now [Part] and [Part]. If one is later done apart from the other, one joined capability would compound the effect of that change.
6. When step 3 changed an edit, its consequence sentence is: [Entry] is now [Title].
7. Return to the step that named this one.

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
- Each capability title follows the capability title rule. A title that joins two things becomes two capabilities without a question, and the consequence sentence names the compounding effect.
- The record contains no plans, tasks, source code, or infrastructure definitions.
- The skill does not change the Reference Architecture, the decision statement, the rationale, the selected option, or the decision status.
- The skill does not write an implementation id onto the ADR.
- A handoff from `highway-onboarding` writes an accepted implementation without a proposal and returns its `RI` id to highway-onboarding, never to a step another visit holds. It asks only the title message, when the title cannot be used. A `decline` writes nothing.
- An onboarded implementation stores Deployed by, Managed by, and Language as `Needed`.
- The `start` proposal and the delivery platforms view follow Deployed by, Managed by, and Language each with its Why it matters line from `why it matters`.

## Error Handling

- A missing or unknown architecture stops the skill and writes nothing.
- An architecture that is not accepted stops the skill and writes nothing.
- A realization that contradicts the architecture stops the write and names the conflict.
- A malformed present Profile, Objective, Control, or NFR baseline stops the skill and writes nothing.
- A failed write leaves the architecture and every other implementation unchanged, and leaves existing implementation, implementation-catalog, and capability-catalog bytes unchanged.
- Declining a proposal writes nothing.

## Example

`/highway-implementation RAb7c41e20`