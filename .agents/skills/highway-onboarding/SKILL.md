---
name: highway-onboarding
description: "Manages one decision, one reference architecture, and one reference implementation."
usage: "Invoke as `/highway-onboarding`."
compatibility: all
metadata:
  version: 3.0.0
---

# highway-onboarding

## Purpose

Brings existing platforms into Highway by validating capabilities, mapping them to providers, and orchestrating one decision, architecture, and implementation for each provider group.

## When to use

- The person invokes `/highway-onboarding`.
- Accepted Profile, Objectives, Controls, NFRs, or existing architecture records can ground a capability.

## When not to use

Do not create a technology, platform, provider, or application inventory.
Do not create a Request, Discovery, or synthetic `DISC` record.
Do not use `highway-adr` for this path. That skill requires a Discovery.
Do not change Profile, Objectives, Controls, or NFRs.
Do not authorize deployment.
Do not authorize the agent platform to act on its own.
Do not report Status, Summary, Next Action, Blocking Reason, Missing, Complete, or Blocked.

## Inputs

- Accepted Profile, Objectives, Controls, NFRs, ADRs, architectures, and implementations when present.
- Material the person supplies, including a website when retrieval is available.
- `adrs/adrs.md` when present.
- `.highway/library/templates/output/adr-record.md`.
- `.highway/library/templates/output/adr-catalog.md`.
- `highway-architecture`.
- `highway-implementation`.
- `.highway/governance/experience-standard.md`.
- A project root containing `.highway/`.

## Outputs

The complete structure is `.highway/library/templates/output/adr-record.md`, `.highway/library/templates/output/architecture-record.md`, and `.highway/library/templates/output/implementation-record.md`.

- One accepted ADR per provider group, at `adrs/[ID].md`, with Parent `highway`.
- One Reference Architecture and one Reference Implementation for that ADR, produced by their owning skills.
- One lineage that lists every completed provider, then one summary.
- No inventory file. The capability queue and the provider queue are not written.

## Procedure

Emit only the active template. Follow the steps in this order: `capabilities`, `map`, `mapping`, `orchestrate`, `lineage`, then `summary`. Review happens only when the person asks for it from the summary.

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

### capabilities

Build a starting point from accepted repository context. Include a capability when that context supports it. Do not ask the person to invent the list.

On the first visit, emit this level-3 heading, then the sentence under it, then the starting point. On an edit, re-emit only the starting point. [Name] is the accepted Organization Name. Use the Repository Name when no Organization Name has been accepted.

This is where Highway helps you navigate your technology landscape

We'll connect existing capabilities so future recommendations align with [Name]'s target direction.

**Here are the capabilities Highway believes you have today:**

**Highway:** Connect accepted business goals, decisions, architecture, and implementation work into a single traceable system of knowledge.

**[Capability title]:** [What the organization does.]

Include the Highway line on the first capability list. Omit it when an accepted ADR already records the Highway capability for the same agent-platform name. The person may correct or remove the line before accept. A removed Highway line is not placed on the capability queue.

Emit one line per other capability. Do not include a provider.

**What would you add, correct, or remove?**

If this is accurate, just say so. If you don't know, say "I don't know" and we'll work through it together.

- `edit`: emit one consequence sentence. Re-emit the starting point with the edit applied. Stay on `capabilities`.
- `accept`: place the capabilities on the capability queue, in displayed order. Go to `map`.
- `unknown`: re-emit the starting point. Stay on `capabilities`.
- `question`: answer, then re-emit the starting point. Stay on `capabilities`.
- `decline`: stop. Write nothing.

### map

Take the first capability on the capability queue.

**[Capability title]:** [What the organization does.]
**Business Purpose:** [Business purpose.]
**Provider:** [observed platform, or `Unknown`]

When the capability title is Highway and the session identifies the agent platform by name, that name is the provider. Cursor, VS Code, Claude, and Codex are names the session may identify. Do not guess a name. When no name is identified, the provider is `Unknown`. A corrected name replaces the provider. Do not assign this provider to a capability the platform does not operate.

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

Take the next provider on the provider queue. Create that provider's ADR, then its Reference Architecture, then its Reference Implementation. Do not ask the person to accept any of them. Emit nothing else until every provider on the queue has its three records.

Build the ADR from accepted Profile, Objectives, Controls, NFRs, and the capabilities this provider serves.

- **Provider:** [Provider]
- **Capabilities:** [Capabilities this provider serves.]
- **Decision:** [Adopt this provider for those capabilities.]
- **Alternatives:** [Why each alternative is weaker for this organization.]
- **Why:** [Rationale grounded in accepted Profile, Objectives, Controls, and NFRs.]
- **Limitations:** [What this provider does not cover, or `None`.]

The ADR title is the decision sentence. Derive the id from that title.

1. Lowercase the title. Remove hyphens and apostrophes. Split the rest into words.
2. Take eight letters: the first two of word 1, the first two of word 2, the first two of word 3, and the last two of the last word. When the title has only two words, the third sample is the first two of the last word.
3. When a word is shorter than two letters, continue into the next word. A one-word title repeats until there are eight letters.
4. Map each letter. Digits stay as they are.

a 0, b 1, c 2, d 3, e 4, f 5, g 6, h 7, i 8, j 9, k a, l b, m c, n d, o e, p f, q 0, r 1, s 2, t 3, u 4, v 5, w 6, x 7, y 8, z 9.

5. The id is `ADR` plus those eight hex digits.

Compare that id with `adrs/adrs.md`, including removed rows. When the same title already has that id, use the existing record. When the id is taken for a different title, add the provider name to the title and derive the id again. Do not ask.

Write `adrs/[ID].md` and `adrs/adrs.md` together. A failed write leaves every existing ADR byte unchanged. Stay on `orchestrate` for this provider. Do not create the architecture or the implementation.

- `id` is the derived `ADR` id.
- `request` is `onboarding`.
- `discovery` is `highway`.
- `status` is `accepted`.
- `supersedes` is `None`.
- `superseded_by` is `None`.
- The catalog columns are ADR ID, Discovery ID, Request ID, ADR Title, ADR Path, and Status. Discovery ID is `highway`. Request ID is `onboarding`. ADR Path is `adrs/<ADR id>.md`. Status is `accepted`.
- Do not allocate from `Next ID`.
- Do not create a Discovery record.

When the ADR exists, create the Reference Architecture, then the Reference Implementation. Follow `highway-architecture` and `highway-implementation` for the record shape, identifiers, and catalogs. Do not emit their questions, starting points, or acceptance requests. Write both records with status `accepted`.

When either of those records cannot be written, try that record once more. When it still cannot be written, keep the ADR and any earlier provider results. Say which record could not be written. Do not claim onboarding is complete.

When the ADR, Reference Architecture, and Reference Implementation exist, remove this provider from the provider queue. When another provider remains, repeat `orchestrate` for that provider. When the queue is empty, go to `lineage`.

### lineage

Show one block for every completed provider, in the order they were created.

**[Provider]**

[ADR id] → [RA id] → [RI id]

[One sentence naming the capabilities this provider now covers.]

Then go to `summary`.

### summary

List every completed provider group.

**Onboarding is now complete for [Name]**

1. **[Provider]:** [ADR id] → [RA id] → [RI id] ([capabilities])

If you'd like to review your Decision, Reference Architecture or Reference Implementation records, just say so.

**Where would you like to go next?**

`/highway-assessment` is a good choice. Highway can perform an assessment of your current business context and provide recommendations you can act on today.

Run /highway-help to explore what Highway can help you do.

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

- `edit`: emit one consequence sentence. Update that record. Re-emit the record hand-off, that record, and this question. Stay on `review`.
- `accept`: when another record remains in this review, show the next record. When the next record belongs to a different provider, emit the provider hand-off first. When none remain, return to the summary question.
- `question`: answer, then re-emit the record hand-off, that record, and this question. Stay on `review`.
- `unknown`: re-emit the record hand-off, that record, and this question. Stay on `review`.
- `decline`: return to the summary question.

## Verification

- The capability starting point includes **Highway:** Connect accepted business goals, decisions, architecture, and implementation work into a single traceable system of knowledge.
- A removed Highway line is not placed on the capability queue.
- Highway's provider is the agent platform the session identifies by name. An unidentified name uses the unable-to-infer prompt.
- The agent platform is not assigned to a capability it does not operate.
- The capability starting point is accepted before any platform question.
- Each capability is mapped before the provider groups are shown.
- The provider queue starts only after the mapping is accepted.
- For each provider, the ADR is written, then the Reference Architecture, then the Reference Implementation, without asking the person to accept any of them.
- The summary tells the person they can review a Decision, Reference Architecture, or Reference Implementation.
- A review that names nothing lists each provider's Decision, Reference Architecture, and Reference Implementation, and asks which to review or whether to review all.
- Review all shows one record at a time: for each provider, the Decision, then the Reference Architecture, then the Reference Implementation.
- Each record is introduced with **Review the [record] Highway has prepared:**
- A later provider is introduced with "Review the [provider] records Highway has prepared for you."
- A shown record asks **What would you add, correct, or remove?**
- An onboarding ADR uses `request: onboarding`, `discovery: highway`, and Discovery ID `highway`.
- No Request or Discovery record is created.
- The Reference Implementation is written only after that architecture record exists.
- A failed architecture or implementation does not claim onboarding is complete.
- Lineage is shown only after every provider on the queue has an ADR, Reference Architecture, and Reference Implementation, and it lists each of those providers.
- No inventory file is written.
- The summary recommends `/highway-assessment`, then `/highway-help`.

## Error Handling

- An unreadable website continues from accepted repository evidence and says the site could not be read.
- A failed ADR write leaves existing ADR bytes unchanged and does not create an architecture.
- A failed architecture or implementation write keeps earlier records and names the record that could not be written.
- A capability the person says does not exist is removed and is not mapped.
- A provider the person says does not exist is marked `Does not exist` and does not create a provider decision.

## Example

`/highway-onboarding`