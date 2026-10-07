---
name: highway-setup
description: "Orchestrates initial Highway setup through the owning governance skills."
usage: "Invoke as `/highway-setup` to assess readiness and complete missing foundational setup in order."
compatibility: all
metadata:
  version: 8.1.0
---

# Purpose

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

## Welcome

When beginning initial Setup, before the first Profile-owned action, emit exactly once:

```text
## Welcome to Highway

*Turn organizational knowledge into connected decisions.*

**Your context stays yours.**

Highway builds on information you choose to accept into your repository. Your repository remains the authoritative source of truth, and you retain ownership of the context and artifacts created through Highway.

---

Let's get started.
```

Do not emit this welcome on a resumed Setup interaction.

## Outputs

Setup consumes owner readiness and owner-specific action results, delegates owner-provided actions,
and emits the following conclusion once after all four owners permit advancement in Setup order:

```text
**Your foundational Highway context is now in place.**

Highway now has organizational context, business objectives, safeguards, and operational expectations it can build on in future work.

**Where would you like to go next?**

Run /highway-help to explore what Highway can help you do.
```

## Workflow

1. Request readiness from the current owner.
2. If readiness is terminal with `Next Action: None`, advance.
3. If readiness is `Blocked`, stop with the owner-provided context.
4. If readiness supplies a supported `Next Action`, emit the applicable domain transition and delegate that action.
5. Render the owner interaction without reinterpretation and consume the result declared by that owner.
6. If that result requires additional owner interaction, remain with the owner and continue according to its contract.
7. If the owner reports its active collection/work finished, request fresh readiness.
8. Advance only when fresh owner readiness permits advancement.
9. Otherwise stop on malformed or unsupported owner output.

Owner order is Profile → Objectives → Controls → NFRs. Controls and NFRs use their declared
Collection Result contracts. Profile and Objectives use their own declared owner results. Setup does
not impose one shared collection-result shape.

### Domain transitions

Emit each block only when delegating the first active interaction for that domain. Do not emit a
transition when the owner is already terminal and skipped, repeat it while continuing, or duplicate
the owner opening. A transition is one short outcome-oriented statement and does not preview
internal routing or readiness mechanics.

```text
---

**Let's identify some outcomes worth pursuing.**

These give Highway something concrete to connect future decisions back to.
```

```text
---

**Now let's establish the safeguards that should guide future technology decisions.**

These help Highway keep future recommendations aligned with what needs to remain true.
```

```text
---

**Now let's consider the operational expectations future solutions should meet.**

These help connect your safeguards to how solutions need to behave in practice.
```

When Setup contributes presentation around a delegated owner interaction, keep at most one response-demanding question or decision in the final interaction block. Do not interfere with the owner's own interaction.

Use `---` to separate visible transitions between major Setup domains. When a completed guided owner domain has accepted context that can be meaningfully summarized, provide one concise user-relevant synthesis before moving onward unless the owner already emitted the required user-facing synthesis. Do not add a question merely to close the domain, reinterpret accepted owner content, or show machine readiness/result fields.

## Experience

User-visible interaction follows the Highway Experience Standard.

## Resume

A new Setup interaction begins by requesting fresh owner readiness in Setup order. Setup persists no checkpoint or owner conversational state.

## Completion

After all four owners permit advancement in Setup order, emit the final conclusion once.

## Error Handling

Setup's effective runtime failure behavior is:

- malformed or unsupported owner result: stop without invoking a later owner;
- owner `Blocked`: stop and report the owner-provided reason;
- owner `Declined` or `Aborted`: stop without advancing;
- unsupported owner `Next Action`: stop and identify the unsupported action;
- unexpected orchestration failure: stop without claiming Setup completion and provide actionable
  user-facing context.

Setup performs no artifact mutation, so it does not add mutation-recovery mechanics owned by the
current owner.

## Verification

- The skill contains exactly one `# Purpose` section with the declared Purpose sentence.
- Owner order is Profile → Objectives → Controls → NFRs.
- Owner-specific result contracts are consumed without imposing one common result schema.
- Controls and NFRs use their declared Collection Result contracts.
- Profile and Objectives use their own declared owner results.
- `Continue` remains with an owner when that owner's contract uses Collection Result.
- `Finished` triggers fresh readiness when that owner's contract uses Collection Result.
- Initial Setup emits the Highway welcome once; resumed Setup does not repeat it.
- Setup-added presentation contains at most one response-demanding question or decision in the final interaction block.
- Each active-domain transition occurs once, remains outcome-oriented, and does not expose routing or readiness mechanics.
- Visible domain transitions retain `---` separation.
- Owner openings are not duplicated.
- A completed guided domain receives at most one Setup synthesis.
- Setup does not add a synthesis when the owner already supplied the required user-facing synthesis.
- Domain closure does not add a ceremonial question.
- Normal orchestration does not expose machine-consumable owner-result fields.
- Failure does not permit invocation of a later owner or a Setup completion claim.
- Setup persists no checkpoint or owner artifact.
- A new interaction starts from fresh readiness.
- The final conclusion is emitted once and only after all four owners permit advancement.

## Example

`/highway-setup`
