---
name: highway-setup
description: "Orchestrates initial Highway setup through the owning governance skills."
usage: "Invoke as `/highway-setup` to assess readiness and complete missing foundational setup in order."
compatibility: all
metadata:
  version: 8.0.0
---

## Purpose

Orchestrates Profile, Objectives, Controls, and NFR owners in order while consuming their declared results.

## When to use

Use this skill to begin setup, continue owner collection, or resume setup from fresh owner readiness.

## When not to use

Do not use this skill to perform owner discovery, recommendations, interpretation, persistence, or artifact updates.

## Inputs

- Project root containing `.highway/`.
- `/highway-profile` owner contract.
- `/highway-objectives` owner contract.
- `/highway-controls` owner contract.
- `/highway-nfrs` owner contract.
- `.highway/governance/experience-standard.md`.
- active user request.

Setup does not list or inspect owner-internal artifacts, state, records, catalogs, relationships,
candidate state, identifiers, or persistence results.

Owner order is Profile, Objectives, Controls, NFRs.

- Profile readiness
- Objectives readiness
- Controls readiness
- NFR readiness

## Outputs

Setup consumes owner readiness and collection results, delegates owner-provided actions, emits
concise domain transitions, and emits the following conclusion once after all owners complete:

```text
**Your foundational Highway context is now in place.**

Highway now has organizational context, business objectives, safeguards, and operational expectations it can build on in future work.

**Where would you like to go next?**

Run `/highway-help` to explore what Highway can help you do.
```

## Workflow

1. Request readiness from the current owner in this order: Profile readiness, Objectives readiness, Controls readiness, NFR readiness.
2. If readiness is terminal with `Next Action: None`, advance to the next owner.
3. If readiness is `Blocked`, stop and report the owner-provided reason.
4. If readiness supplies a supported `Next Action`, emit the domain transition when entering a new domain and delegate only that action.
5. Render the delegated owner interaction without reinterpretation and consume its declared result.
6. If the owner result says `Action Status: Succeeded` and `Collection Result: Continue|Finished`, remain with that owner while collection continues.
7. If the owner result says collection finished, request fresh readiness from that owner.
8. Advance only when fresh readiness permits it; otherwise stop on a malformed or unsupported result.
9. A new Setup interaction begins by requesting fresh owner readiness in Setup order.

Use this same loop for Profile, Objectives, Controls, and NFRs. Setup does not derive readiness,
inspect owner artifacts, or infer interaction need from a status alone.

### Domain transitions

Use a Markdown horizontal rule before each visible transition into a new Setup domain. Do not add
owner labels or duplicate an owner's opening.

**Let's identify some outcomes worth pursuing.**

These give Highway something concrete to connect future decisions back to.

**Now let's establish the safeguards that should guide future technology decisions.**

These help Highway keep future recommendations aligned with what needs to remain true.

**Now let's consider the operational expectations future solutions should meet.**

These help connect your safeguards to how solutions need to behave in practice.

## Experience

User-visible interaction follows the Highway Experience Standard.

## Resume

A new Setup interaction begins by requesting fresh owner readiness in Setup order. Setup does not
persist a checkpoint or restore owner conversational state.

## Completion

Setup completes only after Profile, Objectives, Controls, and NFRs have each returned the terminal
result required by their current owner contract. Emit the conclusion in Outputs once.

## Error Handling

Rely on the Constitution common failure model. Setup-specific exceptions are:

- malformed or unsupported owner result: stop without invoking a later owner;
- owner `Blocked`: stop and report the owner-provided reason;
- owner `Declined` or `Aborted`: stop without advancing;
- unsupported owner `Next Action`: stop and identify the unsupported action.

## Verification

- Owner order is Profile → Objectives → Controls → NFRs.
- Setup consumes owner readiness and delegates only owner-provided actions.
- Setup advances only from owner-declared terminal results.
- Owner `Blocked`, `Declined`, `Aborted`, malformed, or unsupported results do not advance.
- Controls collection uses its declared four-field owner result.
- NFR routing does not inspect candidate state, counts, records, or relationships.
- Collection `Continue` remains with the active owner; `Finished` triggers fresh readiness.
- Transitions are concise, horizontally separated, and do not duplicate owner openings.
- Setup writes no owner artifact and persists no wizard or checkpoint state.
- A new interaction starts from fresh owner readiness.
- Completion occurs only after every required owner reaches its declared terminal result.
- Generic Constitution and Experience Standard requirements are not restated.

## Example

`/highway-setup`
