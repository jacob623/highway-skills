---
name: highway-adr
description: "Records one architecture decision for one discovery. Use when a discovery's options are ready and the person wants to choose one and record it as an ADR, or when highway-onboarding hands off a provider decision."
license: Apache-2.0
metadata:
  version: 6.8.0
  usage: "Run highway-adr with one discovery id."
---

# highway-adr

## Purpose

Records one accepted architecture decision for a Discovery after the person selects an option and accepts the proposed decision.

## When to use

- The person invokes `highway-adr` with one Discovery id and one option id.
- The person invokes `highway-adr` with one Discovery id.
- The person invokes `highway-adr` without a Discovery id or an option id.
- `highway-onboarding` hands off a provider, the capabilities it serves, and the decision to adopt it.

## When not to use

Do not generate new candidate options or change a Discovery.
Do not recalculate scores, reorder the comparison, or recompute Reference Architecture matches.
Do not change Requests, Clarifications, Profile, Objectives, Controls, or NFRs.
Do not authorize implementation.
Do not change the conceptual body of a reference architecture.
Do not report Status, Summary, Next Action, Blocking Reason, Missing, Complete, or Blocked.

## Inputs

- One Discovery id that matches one row in `discoveries/discoveries.md`, when the person supplies one.
- One option id contained in that Discovery, when the person supplies one.
- A provider, the capabilities it serves, the decision, the alternatives, the rationale, and the limitations, when `highway-onboarding` hands them off.
- The Discovery record at `discoveries/[ID].md`.
- `clarifications/clarifications.md` when present, for `CLAR-[REQ id]` and `CLAR-[DISC id]` only.
- Accepted Profile, Objectives, Controls, and NFRs when present.
- `discoveries/discoveries.md` and `adrs/adrs.md`.
- `architectures/architectures.md`, `implementations/implementations.md`, and the accepted architecture and implementation records they name.
- `code/code.md` and the accepted `code/<folder>/.highway/features/<number>-<action>/codify.md` records it names, when closing a span.
- `assets/adr-record.md`.
- The highway-experience skill, activated first.

## Outputs

The complete structure is `assets/adr-record.md`. `adrs/adrs.md` and `architectures/architectures.md` keep the structure highway-setup seeded.

- One ADR at `adrs/[ID].md` after the person accepts the proposed decision, or when `highway-onboarding` hands off a provider.
- An updated `adrs/adrs.md` written with that record.
- A closing message that names the ADR and exactly one next step.
- The architecture record's current-decision list and the architecture catalog, updated in the same write when this decision reuses or replaces an architecture, or runs beside each architecture in a span.
- No ADR when the person has not selected an option or a write fails.

## Procedure

Activate the highway-experience skill before any output the person sees, and follow it for Highway's identity, the Experience Standard, and the storage contract.

Before the first question, confirm these seeded files exist: `adrs/adrs.md`, `architectures/architectures.md`.
When any is absent, emit the message below exactly, stop, and write nothing.

**Oops... we need to setup your repository.**

Highway needs to gather your organizational preferences and set up your repository. Run highway-setup to get started.

User-visible interaction follows the Highway Experience Standard. Repository ownership stays with the person.

Emit only the active template. Follow this order: `onboarding` when `highway-onboarding` hands off a provider; `choose-discovery` when no Discovery id is supplied; `choose-option` when no option is supplied; otherwise `start`, or `span` when it applies, then `identifier`, `title` when needed, `write`, and `close`. Discovery owns the options, scores, recommendation, and matches. Copy those values. Do not change them. The person owns the selection. Do not select an option from the recommendation, a score, or alphabetical order.

One Discovery has one ADR. The onboarding Discovery ID `highway` is not a Discovery and is exempt. When `adrs/adrs.md` already has an ADR for that Discovery id, show that decision and write nothing.

Before a step in this table, read its file and follow it to the end.

| File | Steps |
| --- | --- |
| `references/proposal.md` | `start`, `span` |
| `references/record.md` | `identifier`, `title`, `write` |

### Entry

When `highway-onboarding` hands off a provider, go to `onboarding`.

1. Read the invocation for one Discovery id and one option id. When it has no Discovery id and contains the exact title of one waiting Discovery, as `choose-discovery` defines it, that Discovery's id is present. Compare without regard to case.
2. When neither is present, go to `choose-discovery`.
3. When a Discovery id is present, resolve it. When it matches no Discovery, stop. Say the Discovery was not found. Write nothing.
4. When that Discovery already has an ADR, show the recorded decision. Write nothing. When its catalog Architecture ID cell names more than one architecture, go to `close`.
5. When an option id is also present and it is one of that Discovery's options, go to `start` with that option selected.
6. When the option id is missing, unknown, or not in that Discovery, go to `choose-option`.

### choose-discovery

Read `discoveries/discoveries.md` and `adrs/adrs.md`. A Discovery is waiting when its Status is `accepted` and its Discovery ID does not appear on any ADR catalog row. A removed ADR row still counts as that Discovery already having a decision. Do not open Discovery records to build this list.

When none are waiting, say that no Discovery is waiting for a decision. Write nothing.

Otherwise emit one numbered line per waiting Discovery, starting at 1, in Discovery catalog order. Show the Discovery ID and its title. A stated number selects that Discovery.

**1. [Discovery ID]:** [Discovery Title]

**Which Discovery would you like to decide?**

- A Discovery id, a listed Discovery title, or its number: follow Entry from case 3.
- `unknown`: re-emit this list. Stay on `choose-discovery`.
- `decline`: stop. Write nothing.

### onboarding

`highway-onboarding` hands off one provider, the capabilities it serves, the decision to adopt it for them, each alternative with why it is weaker for this organization, the rationale grounded in accepted Profile, Objectives, Controls, and NFRs, and the limitations, or `None`. Write the ADR as accepted without asking the person. Emit nothing. Read no Discovery, Request, or Clarification.

1. The ADR title is the decision sentence. Derive the id as `identifier` does.
2. When the same title already has that id, return that id to `highway-onboarding`. Write nothing.
3. When the id is taken for a different title, add the provider name to the title and derive the id again. Do not ask.
4. Write `adrs/[ID].md` and `adrs/adrs.md` together, as `write` does, with the values below in place of the Discovery values. Do not go to `close`.
5. On success, return the ADR id to `highway-onboarding`. A failed write leaves every existing ADR byte unchanged. Return to `highway-onboarding` and say the ADR could not be written.

- `request` is `onboarding`. `discovery` is `highway`. `status` is `accepted`. `supersedes` is `None`. `superseded_by` is `None`.
- The record keeps every heading of a Discovery-backed ADR, as `write` says, including `## Decision Confidence`.
- Discovery, Request, Recommendation, Recommendation Rationale, Comparison Matrix, Reference Architecture Matches, and Discovery Confidence are `None`. Omit Recommendation Override.
- `## Context` states the problem and the forces in prose, from the capabilities this provider serves and the accepted evidence.
- `## Decision` records Selected Option as the provider name, Selection Source as `Accepted onboarding mapping`, the decision, and the rationale.
- `## Decision Scope` covers those capabilities and leaves open the limitations, or `None`. `## Revisit When` is the condition that should reopen this decision, or `None`.
- `## Alternatives Considered` lists the provider as `Selected`, then each alternative as `Evaluated` or `Rejected`. Head each alternative by its name, with its definition and reason. Do not write an option id.
- `## Reference Architecture Handoff` has Reference Architecture `None` and no implementation entry.
- The catalog row has Discovery ID `highway`, Request ID `onboarding`, Architecture ID `None`, and Status `accepted`.
- Do not ask whether a decision replaces or runs beside another. Do not change an architecture record or the architecture catalog.
- Do not create a Discovery record.

### choose-option

Emit one numbered line per option from the Discovery, starting at 1, in displayed order. Show the option id and its title. Put `(Recommended)` after the advisory option title. The why is the Discovery's one-sentence rationale for that option. A stated number selects that option.

**1. [Option id]:** [Option title] (Recommended) — [Why this option fits.]

**2. [Option id]:** [Option title] — [Why this option fits.]

**Which option would you like to select?**

- `select`: go to `start` with the named or numbered option. This is the person's selection.
- `unknown`: re-emit this block. Stay on `choose-option`.
- `decline`: stop. Write nothing.

### Classify

Classify the latest reply before any other action.

- `select`: names an option, or states its number, to select.
- `replace`: this decision replaces the matched decision.
- `beside`: this decision runs beside the matched decision.
- `edit`: adds, removes, corrects, or replaces decision text.
- `accept`: affirms the proposed decision and adds no fact.
- `unknown`: the person says they do not know.
- `question`: asks for an explanation.
- `decline`: the person stops or cancels.

On `start`, "looks good" is `accept`.

### close

**Architecture decision recorded**

- **ADR record:** `adrs/[ADR id].md`
- **Title:** [Title]
- **Identifier:** `[ADR id]`
- **Discovery:** `[DISC id]`
- **Selected option:** [Option title]

Suggest exactly one next step.

When no architecture is reused, run `highway-architecture [ADR id]` to create the Reference Architecture for this decision.

When an architecture is reused and the selected option has no current decision with the same exact title and a current implementation, run `highway-implementation [RA id]` to create the Reference Implementation for that architecture. A new architecture is not required.

When that exact-title decision and its current implementation exist, name that implementation. Do not suggest creating an architecture or another implementation.

When the decision is a span, use these lines instead. A current implementation is an accepted row in `implementations/implementations.md` whose Architecture ID is in the set. It is covered when an accepted row in `code/code.md` lists it in Implementations and a recorded feature's action is this decision's title, in lowercase words separated by hyphens.

Name each architecture in the set with no current implementation: **[Architecture title]** is not yet implemented.

Then suggest one of these:

- No current implementation in the set: run `highway-implementation [RA id]` to create the Reference Implementation for **[Architecture title]**, the first architecture in the set.
- Every current implementation is covered: say every implementation in this decision already has an automation for **[Decision title]**. Suggest no codify step.
- One uncovered: Run `highway-codify` for **[Implementation title]** to **[Decision title]**.
- Two to five uncovered: emit one numbered line per uncovered implementation, in catalog order, as **1. [Implementation title]**, then ask **Which implementation would you like to codify first?**
- More than five uncovered: list none. Ask **Which implementation would you like to codify first?** Say they can give its title.

A named or numbered uncovered implementation gives the one-uncovered line for it. A name outside the uncovered set is not offered. Ask again. Do not suggest creating an architecture.

## Verification

- A Discovery id and an option id open the proposed decision for that option.
- A Discovery id without an option id lists the options with numbers. Each line shows the option id and its title. A stated number selects that option.
- An invocation with neither id lists the accepted Discoveries whose Discovery ID is absent from every ADR catalog row. Each line shows the Discovery ID and its title. The list is numbered. A stated number selects that Discovery. A removed ADR row keeps that Discovery off the list.
- The proposed decision is accepted before the ADR is written.
- One Discovery produces at most one ADR.
- The selected option is the option the person named or numbered.
- Context states the problem and the forces. The record states what the decision covers, what it leaves open, and when to revisit it, or `None`.
- Alternatives Considered includes the selected option as `Selected`, and each alternative has a definition, one outcome, and a reason.
- The handoff does not repeat the selected option or the matches. The handoff contains no implementation entry. Reference Architecture is `None` when no architecture is reused, and the RA id when one is.
- Relationship lines use `advances`, `bound by`, and `satisfies`, or `None`.
- Authorization proceeds to Reference Architecture and does not authorize implementation.
- The closing message suggests exactly one next step: create the reference architecture, create the reference implementation, or the name of the implementation that already exists.
- Accepting a span writes one ADR whose Architecture ID lists every RA id in the set, adds it beside each current decision, supersedes nothing, and creates no architecture.
- A span close names each architecture that is not yet implemented and offers codify for one uncovered implementation at a time. A covered implementation is not offered. Opening a recorded span goes to that close and writes nothing.
- The skill does not change the Discovery.
- A handoff from `highway-onboarding` writes an accepted ADR without a question and returns its id. A taken id adds the provider name to the title without asking. The same title reuses the existing record.
- An onboarding ADR uses `request: onboarding`, `discovery: highway`, and Discovery ID `highway`, which may appear on more than one catalog row.
- An onboarding ADR uses the shared ADR sections. Discovery-only values are `None`, alternatives are headed by name, and the record contains no option id.
- An onboarding handoff does not ask whether a decision replaces or runs beside another, and changes no architecture.

## Error Handling

- A missing or unknown Discovery stops the skill and writes nothing.
- An option that is not in the Discovery returns to `choose-option` and writes nothing.
- A second ADR for the same Discovery stops the write and shows the existing decision.
- A malformed present Discovery stops the skill and writes nothing.
- A failed write leaves existing ADR and catalog bytes unchanged.

## Example

`/highway-adr DISC3f2a9c10 OPTa91c2b04`