---
name: highway-onboarding
description: "Manages one decision, one reference architecture, and one reference implementation. Use when the person wants to onboard one capability in a single pass, grounded in accepted setup or architecture records."
license: Apache-2.0
metadata:
  version: 10.11.0
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

### Classify

Classify the latest reply before any other action.

- `edit`: adds, removes, corrects, splits, combines, or replaces substance.
- `accept`: affirms the current block and adds no fact.
- `unknown`: the person says they do not know.
- `question`: asks for an explanation.
- `decline`: the person stops or cancels.

On a starting point, "looks good" is `accept`.

### overview

Emit the lines below once, before the first capability list. Emit "Let's get to know your technology landscape" as a level-3 heading. Emit every other line as written. [Name] is the accepted Organization Name. Use the Repository Name when no Organization Name has been accepted.

Let's get to know your technology landscape

We'll connect existing capabilities so future recommendations align with [Name]'s target direction.

During onboarding we'll:

- **Identify the technology capabilities** that support your business.
- **Understand the platforms and processes** that support those capabilities today.
- **Validate Highway's understanding** before any architecture knowledge is created.
- **Capture accepted knowledge** as connected architecture and implementation context.

You don't need to have everything documented in advance. We'll build that understanding together, one capability at a time.

Now, let's get started.

---

Then go to `capabilities`.

### capabilities

Build a starting point from accepted repository context. Do not ask the person to invent the list.

A technology capability is something software, a platform, a service, or infrastructure does for the organization. For each business activity that accepted context names, propose the technology capability that activity relies on, including when context names no system. Title it for what the technology does, such as Online Payments, not for the business function, such as Sales. The title is not a product or vendor. Leave out an activity that no technology supports. When two activities rely on one technology, propose each as its own capability. Follow `capability title` in `highway-implementation` for each title, then return to `capabilities`.

On an edit, re-emit only the starting point.

**Here are the capabilities Highway believes you have today:**

1. **AI-Augmented Technology Development:**

   Using AI systems to assist with research, planning, and implementation of technology solutions.

2. **[Capability title]:**

   [What the technology does for the organization.]

Include the AI-Augmented Technology Development line on the first capability list. Omit it when an accepted ADR already records this capability for the same agent-platform name. The person may correct or remove the line before accept. A removed AI-Augmented Technology Development line is not placed on the capability queue.

Emit one numbered item per other capability, numbered in order. Each item names one capability. When context joins two activities in one capability, propose each as its own item. Keep the person's own wording when they add or correct a capability. Do not include a provider.

**What would you add, correct, or remove?**

If this is accurate, just say so. If you don't know, say "I don't know" and we'll work through it together.

- `edit`: follow `capability title` in `highway-implementation` for each capability the edit adds or corrects, then return here. Emit one consequence sentence, or the one `capability title` gave. Re-emit the starting point with the edit applied. Stay on `capabilities`.
- `accept`: place the capabilities on the capability queue, in displayed order. Go to `map`.
- `unknown`: re-emit the starting point. Stay on `capabilities`.
- `question`: answer, then re-emit the starting point. Stay on `capabilities`.
- `decline`: stop. Write nothing.

### map

Take the first capability on the capability queue.

On the first capability, emit this before the block. Do not emit it again.

**We've identified the capabilities that matter to your organization. Now let's look at how those capabilities are provided today.**

For each capability, we'll identify the platforms, services, processes, or people that help deliver it.

---

**[Capability title]:**

[What the technology does for the organization.]

**Business Purpose:**

[Business purpose.]

**Provider:**

[observed platform, or `Unknown`]

When the capability title is AI-Augmented Technology Development and the session identifies the agent platform by name, that name is the provider. Cursor, VS Code, Claude, and Codex are names the session may identify. Do not guess a name. When no name is identified, the provider is `Unknown`. A corrected name replaces the provider. Do not assign this provider to a capability the platform does not operate.

When the provider is `Unknown`, emit this line immediately above the question:

Highway was unable to infer a platform for this capability. Please provide the application or platform. If you don't know, say "I don't know" and we'll work through it together.

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: emit one consequence sentence. Apply the edit and re-emit this block. When the person says the capability does not exist, remove it from the capability queue and do not include it in the mapping. When the person says the provider does not exist, set the provider to `Does not exist`. Stay on `map` until the person accepts a block whose provider is known or `Does not exist`.
- `accept`: when the provider is `Unknown`, re-emit this block, including the unable-to-infer line. Otherwise remove this capability from the capability queue. A provider marked `Does not exist` does not enter the provider queue. When the queue still has a capability, re-enter `map`. When it is empty, go to `mapping`.
- `unknown`: re-emit this block, including the unable-to-infer line. Stay on `map`.
- `question`: answer, then re-emit this block. Stay on `map`.
- `decline`: stop. Write nothing.

### mapping

Group the accepted mappings by provider. Do not create an inventory record.

**Here is the mapping of your capabilities by provider:**

**[Provider] (Primary):**
- [Capability]

**[Provider]:**
- [Capability]

A capability whose provider is `Does not exist` is omitted from this mapping and does not enter the provider queue. Emit this line immediately above the question:

If you notice something is missing, describe what you know and I'll add it.

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: emit one consequence sentence. Re-emit this block with the edit applied. Stay on `mapping`.
- `accept`: place each provider that has at least one capability on the provider queue. Put the primary provider first. Go to `orchestrate`.
- `unknown`: re-emit this block. Stay on `mapping`.
- `question`: answer, then re-emit this block. Stay on `mapping`.
- `decline`: stop. Write nothing.

### orchestrate

On the first provider, emit this before creating any records. Do not emit it again.

**Highway will now create your decision, reference architecture and implementation records.**

This is how Highway keeps track of your technology landscape.

Take the next provider on the provider queue. Hand it to each owner in this order, once each. Ask the person nothing yourself. Emit nothing else until every provider on the queue has its three records, except a title question an owner asks.

1. Follow `onboarding` in `highway-adr` with the provider, the capabilities it serves, the decision to adopt this provider for those capabilities, each alternative with why it is weaker for this organization, the rationale grounded in accepted Profile, Objectives, Controls, and NFRs, and what this provider does not cover, or `None`. Hold the ADR id it returns.
2. Follow `onboarding` in `highway-architecture` with that ADR id. Hold the `RA` id it returns.
3. Follow `onboarding` in `highway-implementation` with that `RA` id, the provider, and the capabilities it serves. Hold the `RI` id it returns.

When an owner says its record could not be written, or the ADR could not be updated to name the architecture, follow that owner's `onboarding` once more. When it still fails, keep the ADR and any earlier provider results. Say which record could not be written or named. Do not claim onboarding is complete. When the ADR cannot be written, do not hand off the architecture or the implementation. When the implementation cannot be written, the ADR names the architecture and no implementation exists.

When the person declines a title an owner asks for, keep the earlier records. Say which record was not written. Do not hand off the rest of this provider. Do not claim onboarding is complete.

When the caller named the return step `execution`, go to `execution` in `highway-implementation` after `highway-implementation` returns. Do not ask to configure. Do not continue the queue. When `highway-implementation` included the platform, emit:

**[Platform] is included as a platform highway can use in highway-codify proposals**

**Would you like to configure how highway-codify uses [Platform]?**

A yes adds [Platform] to the platforms to configure, in the order asked. Do not write that list. Any answer continues onboarding. When `highway-codify-config` started this onboarding for [Platform], do not ask this for [Platform]. Do not ask this for a platform that cannot start automation.

When the ADR, Reference Architecture, and Reference Implementation exist, remove this provider from the provider queue. When another provider remains, repeat `orchestrate` for that provider. When the queue is empty, go to `lineage`.

### lineage

Show one block for every completed provider, in the order they were created.

**[Provider]**

[ADR id] → [RA id] → [RI id]

[One sentence naming the capabilities this provider now covers.]

Then go to `configure`.

### configure

1. When no platform to configure remains, go to `summary`.
2. Take the first platform to configure. Remove it from the list.
3. Emit: Let's configure how highway-codify uses [Platform].
4. Follow `highway-codify-config` for [Platform], with the return step `configure` in `highway-onboarding`.

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

- The overview is shown once, before the first capability list, and opens with the level-3 heading "Let's get to know your technology landscape".
- Each proposed capability names what a technology does for the organization. An activity that no technology supports is not proposed. An activity with no named system still yields its technology capability, and `map` asks for the provider.
- Each capability is its own numbered item, with its bold title, a blank line, then its description.
- The capability starting point includes **AI-Augmented Technology Development:** Using AI systems to assist with research, planning, and implementation of technology solutions.
- A removed AI-Augmented Technology Development line is not placed on the capability queue.
- Each capability title follows `capability title` in `highway-implementation`. Two activities that rely on one technology are two capabilities.
- The AI-Augmented Technology Development provider is the agent platform the session identifies by name. An unidentified name uses the unable-to-infer prompt.
- The mapping transition is shown once, before the first capability mapping.
- Each mapping label is bold, followed by a blank line and its value.
- The agent platform is not assigned to a capability it does not operate.
- The capability starting point is accepted before any platform question.
- Each capability is mapped before the provider groups are shown.
- The provider queue starts only after the mapping is accepted.
- For each provider, onboarding hands the ADR to `highway-adr`, then the Reference Architecture to `highway-architecture`, then the Reference Implementation to `highway-implementation`, once each, without asking the person to accept any of them.
- The summary tells the person they can review a Decision, Reference Architecture, or Reference Implementation.
- A review that names nothing lists each provider's Decision, Reference Architecture, and Reference Implementation, and asks which to review or whether to review all.
- Review all shows one record at a time: for each provider, the Decision, then the Reference Architecture, then the Reference Implementation.
- Each record is introduced with **Review the [record] Highway has prepared:**
- A later provider is introduced with "Review the [provider] records Highway has prepared for you."
- A shown record asks **What would you add, correct, or remove?**
- A failed handoff is followed once more and is named when it still fails. A declined title keeps the earlier records and does not claim onboarding is complete.
- No Request or Discovery record is created.
- The Reference Implementation is written only after that architecture record exists.
- A failed architecture or implementation does not claim onboarding is complete.
- Lineage is shown only after every provider on the queue has an ADR, Reference Architecture, and Reference Implementation, and it lists each of those providers.
- No inventory file is written.
- An implementation that can start automation is included in `library/coding-standards/codify-platforms.md` by `highway-implementation`, with blank guidance. The person is asked whether to configure how highway-codify uses it, and any answer continues onboarding. No platform that cannot start automation is asked about.
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