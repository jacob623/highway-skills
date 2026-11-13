---
name: highway-onboarding
description: "Manages one decision, one reference architecture, and one reference implementation. Use when the person wants to onboard one capability in a single pass, grounded in accepted setup or architecture records."
license: Apache-2.0
metadata:
  version: 10.13.0
  usage: "Run highway-onboarding."
---

# highway-onboarding

## Purpose

Brings existing platforms into Highway by validating capabilities, mapping them to providers, and orchestrating one decision, architecture, and implementation for each provider group.

## When to use

- The person invokes `highway-onboarding`.
- Accepted Profile, Objectives, Controls, NFRs, or existing architecture records can ground a capability.

## When not to use

Do not create a technology, platform, provider, or application inventory. `library/coding-standards/codify-platforms.md` lists only platforms that can start automation and is not that inventory.
Do not create a Request, Discovery, or synthetic `DISC` record.
Do not change Profile, Objectives, Controls, or NFRs.
Do not authorize deployment.
Do not authorize the agent platform to act on its own.
Do not report Status, Summary, Next Action, Blocking Reason, Missing, Complete, or Blocked.

## Inputs

- Accepted Profile, Objectives, Controls, NFRs, ADRs, architectures, and implementations when present.
- Material the person supplies, including a website when retrieval is available.
- `adrs/adrs.md`.
- `highway-adr`.
- `highway-architecture`.
- `highway-implementation`.
- `library/coding-standards/codify-platforms.md`.
- The highway-experience skill, activated first.

## Outputs

- One accepted ADR, Reference Architecture, and Reference Implementation per provider group, written by `highway-adr`, `highway-architecture`, and `highway-implementation`.
- One lineage that lists every completed provider, then one summary.
- One row in `library/coding-standards/codify-platforms.md`, with blank When to use and When not to use, written by `highway-implementation` for each implementation that can start automation.
- No inventory file. The capability queue and the provider queue are not written.

## Procedure

Activate the highway-experience skill before any output the person sees, and follow it for Highway's identity, the Experience Standard, and the storage contract.

Before the first question, confirm these seeded files exist: `adrs/adrs.md`, `architectures/architectures.md`, `implementations/implementations.md`, `implementations/capabilities.md`, `library/coding-standards/codify-platforms.md`.
When any is absent, emit the message below exactly, stop, and write nothing.

**Oops... we need to setup your repository.**

Highway needs to gather your organizational preferences and set up your repository. Run highway-setup to get started.

Emit only the active template. Follow the steps in this order: `overview`, `capabilities`, `map`, `mapping`, `orchestrate`, `lineage`, `configure`, then `summary`. Review happens only when the person asks for it from the summary.

Onboarding keeps two queues. The capability queue holds accepted capabilities that still need a platform. The provider queue holds accepted providers that still need a decision. Neither queue is written. Queue membership is not an ADR, an architecture, or an implementation.

A capability may map to more than one provider. A provider may serve more than one capability. One mapping may be primary. A capability the person says does not exist is removed. A provider the person says does not exist is marked `Does not exist` and does not enter the provider queue.

Before a step in this table, read its file and follow it to the end.

| File | Steps |
| --- | --- |
| `references/proposal.md` | `overview`, `capabilities`, `map`, `mapping` |
| `references/orchestrate.md` | `orchestrate`, `lineage`, `configure` |

### Classify

Classify the latest reply before any other action.

- `edit`: adds, removes, corrects, splits, combines, or replaces substance.
- `accept`: affirms the current block and adds no fact.
- `unknown`: the person says they do not know.
- `question`: asks for an explanation.
- `decline`: the person stops or cancels.

On a starting point, "looks good" is `accept`.

### summary

List every completed provider group.

**Onboarding is now complete for [Name]**

1. **[Provider]:** [ADR id] → [RA id] → [RI id] ([capabilities])

If you'd like to review your Decision, Reference Architecture or Reference Implementation records, just say so.

**Where would you like to go next?**

`highway-assessment` is a good choice. Highway can perform an assessment of your current business context and provide recommendations you can act on today.

Run highway-help to explore what Highway can help you do.

[When `highway-codify-config` handed off this onboarding for a platform: Run `highway-codify-config [Platform]` to finish adding [Platform].]

When the person asks to review a record, go to `review`. When they choose a next step, follow that step. Do not start another record.

### review

When the person names a record, show that record.

When the person asks to review and names nothing, list every completed provider in the order they were created.

**[Provider]**
- Decision: [ADR id]
- Reference Architecture: [RA id]
- Reference Implementation: [RI id]

**Which would you like to review, or would you like to review all?**

- They name a record: show that record.
- They name a provider: show that provider's Decision, then its Reference Architecture, then its Reference Implementation.
- They ask to review all: for each provider, in creation order, show the Decision, then the Reference Architecture, then the Reference Implementation.
- `question`: answer, then re-emit the list and this question. Stay on `review`.
- `unknown`: re-emit the list and this question. Stay on `review`.
- `decline`: return to the summary question.

Show one record at a time. When the next record belongs to a different provider than the record just shown, emit this before that provider's first record:

Review the [provider] records Highway has prepared for you.

Before every record, including the first record and the next record for the same provider, emit this level of bold:

**Review the [record] Highway has prepared:**

[record] is Decision, Reference Architecture, or Reference Implementation. Then show that record. After the record, ask:

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: emit one consequence sentence. Update that record in its existing structure. Re-emit the record hand-off, that record, and this question. Stay on `review`.
- `accept`: when another record remains in this review, show the next record. When the next record belongs to a different provider, emit the provider hand-off first. When none remain, return to the summary question.
- `question`: answer, then re-emit the record hand-off, that record, and this question. Stay on `review`.
- `unknown`: re-emit the record hand-off, that record, and this question. Stay on `review`.
- `decline`: return to the summary question.

## Verification

- The provider queue starts only after the mapping is accepted.
- The summary tells the person they can review a Decision, Reference Architecture, or Reference Implementation.
- A review that names nothing lists each provider's Decision, Reference Architecture, and Reference Implementation, and asks which to review or whether to review all.
- Review all shows one record at a time: for each provider, the Decision, then the Reference Architecture, then the Reference Implementation.
- Each record is introduced with **Review the [record] Highway has prepared:**
- A later provider is introduced with "Review the [provider] records Highway has prepared for you."
- A shown record asks **What would you add, correct, or remove?**
- No Request or Discovery record is created.
- A failed architecture or implementation does not claim onboarding is complete.
- No inventory file is written.
- After lineage, each yes, in the order asked, emits "Let's configure how highway-codify uses [Platform]." and follows `highway-codify-config` for that platform with the return step `configure`. The summary follows the last return and has no `highway-codify-config [Platform]` configure pointer.
- An onboarding handed off by `highway-codify-config` does not ask to configure that platform, and its summary ends with the line to finish adding that platform.
- The summary recommends `highway-assessment`, then `highway-help`.

## Error Handling

- An unreadable website continues from accepted repository evidence and says the site could not be read.
- A failed ADR write leaves existing ADR bytes unchanged and does not create an architecture.
- A failed architecture or implementation write keeps earlier records and names the record that could not be written.
- A capability the person says does not exist is removed and is not mapped.
- A provider the person says does not exist is marked `Does not exist` and does not create a provider decision.

## Example

`/highway-onboarding`