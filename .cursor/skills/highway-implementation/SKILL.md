---
name: highway-implementation
description: "Manages one reference implementation from one accepted reference architecture."
usage: "Invoke as /highway-implementation with one architecture id."
compatibility: all
metadata:
  version: 7.12.0
---

# highway-implementation

## Purpose

Creates one proposed Reference Implementation from an accepted Reference Architecture after the person accepts the proposed realization, and records new realized capabilities on an accepted implementation when `highway-codify-config` passes them, and sets the preferred delivery platforms on an accepted implementation when `highway-codify` hands it off.

## When to use

- The person invokes `/highway-implementation` with one Reference Architecture id.
- The person invokes `/highway-implementation` without a Reference Architecture id.
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
- A project root containing `.highway/`.

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

Highway needs to gather your organizational preferences and set up your repository. Run /highway-setup to get started.

Emit only the active template. Follow this order: `onboarding` when `highway-onboarding` hands off an accepted Reference Architecture id; `add capabilities` when `highway-codify-config` passes new realized capabilities; `delivery platforms`, with `delivery decline`, when `highway-codify` hands off an accepted implementation; `choose` when no architecture id is supplied; otherwise `start`, which follows `execution`, then `identifier`, `title` when needed, `write`, `platforms`, and `close`. The accepted Reference Architecture remains authoritative. A realization cannot redesign it or override the ADR. A missing Profile, Objective, Control, or NFR continues without invented evidence. A malformed one of those baselines stops the skill and writes nothing. Clarification is read-only. An open finding can inform a risk. It cannot block the proposal.

One accepted architecture can have more than one current implementation. A current implementation is an accepted implementation-catalog row for that architecture. A removed row does not count and does not block a new one. Creating another leaves every existing implementation in place and does not change the decision or the architecture.

### Entry

When `highway-onboarding` hands off an accepted `RA` id, a provider, and the capabilities it serves, go to `onboarding`.

1. When the invocation names an accepted implementation, new realized capabilities, and a return step, go to `add capabilities`.
2. When the invocation names an accepted implementation and a return step, and names no realized capabilities, go to `delivery platforms`.
3. Read the invocation for one Reference Architecture id.
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
2. When the name has an accepted implementation and no row, emit: Let's configure [Platform]. Follow `highway-codify-config` for [Platform], with the return step `execution` in `highway-implementation`.
3. When the name has no accepted implementation, emit: Let's onboard [Platform]. Follow `highway-onboarding` for [Platform], with the return step `execution` in `highway-implementation`.
4. A listed coding-standard title, or None, replaces Language. Any other title is left out. Say: [Title] is not a listed coding standard. To add it, run /highway-codify-config.
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

### start

Build the proposed realization from the accepted architecture. Follow `execution`. Follow `capability title` for each capability. Cover every responsibility the architecture states. Mark a row `not applicable` only when that stated responsibility does not apply to this realization. Do not add a responsibility the architecture does not state. For each thing the architecture left free, state the choice this realization made, or `None` when nothing may vary. State the realized interface for each architecture interface, how conformance was shown, and the limitations of this realization, each or `None`. State one technology choice, with its intent, its reason, and its evidence. When evidence does not support a technology, use `Unknown` rather than inventing one. Derive the title with the rules in `identifier`.

When a proposed realization contradicts the architecture, name the requirement, the conflict, and the impact. Offer `Resolve implementation` or `Revisit architecture`. Do not write.

**Here is a proposed starting point for your implementation:**

**Title:** [Product title.]

**Summary:** [What this realization does.]

**Realizations:**
- **[Component]:** [Technology or mechanism, and the responsibility it covers.]

**Deployment:** [Where and how it runs.]

**Data:** [How data is stored and moved, or `None`.]

**Security:** [How accepted Controls are realized, or `None`.]

**Operations:** [How accepted NFRs are met in operation, or `None`.]

**Deployed by:** [Platform. Or: Needed.]

**Why it matters:** [From `why it matters`.]

**Managed by:** [Platform. Or: Needed.]

**Why it matters:** [From `why it matters`.]

**Language:** [Standard Title. Or: None.]

**Why it matters:** [From `why it matters`.]

**Capabilities:**
- **[Business capability]:** Realized by [provider or mechanism]. A capability is a business outcome, not a component name.

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: when the edit names Deployed by, Managed by, or Language, follow `field`. Otherwise follow `capability title` for each capability it adds or corrects, then emit one consequence sentence, or the one `capability title` gave. A new title is a supplied title. Re-emit this block with the edit applied. Stay on `start`.
- `accept`: when Deployed by or Managed by is Needed, name that field and stay on `start`. When a stated responsibility is neither covered nor marked not applicable, name it and stay on `start`. Otherwise go to `identifier`.
- `unknown`: re-emit this block. Stay on `start`.
- `question`: answer, then re-emit this block. Stay on `start`.
- `decline`: stop. Write nothing.

### identifier

The implementation title is the product in the title of the decision this realization came from, unless the person supplied a title.

- Remove a leading "Adopt", without regard to case. The product is the text before the first " for ", without regard to case. Capitalize its first letter. Keep every other word as written, so joined products and a named mechanism stay whole.
- When the decision title has no " for ", use the decision's Selected Option when it is a name that appears in the title. Otherwise use the rest of the title.

Deriving the id from that title:

1. Lowercase the title. Remove hyphens and apostrophes. Split the rest into words.
2. Take eight letters: the first two of word 1, the first two of word 2, the first two of word 3, and the last two of the last word. When the title has only two words, the third sample is the first two of the last word.
3. When a word is shorter than two letters, continue into the next word. A one-word title repeats until there are eight letters.
4. Map each letter. Digits stay as they are.

a 0, b 1, c 2, d 3, e 4, f 5, g 6, h 7, i 8, j 9, k a, l b, m c, n d, o e, p f, q 0, r 1, s 2, t 3, u 4, v 5, w 6, x 7, y 8, z 9.

5. The id is `RI` plus those eight hex digits.

Compare that id with `implementations/implementations.md`, including removed rows.

- The same title already has that id under this architecture: use the existing record. Do not write a second one. Go to `platforms`.
- The same title already has that id under a different architecture: the title becomes "[Product] for [purpose]". The purpose is the text after the first " for ", as written. Derive the id again. When the decision title has no purpose, go to `title`.
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

The record follows `assets/implementation-record.md`.

- `id` is the derived `RI` id.
- `architecture` is the Reference Architecture id.
- `status` is `accepted`.
- The title is the accepted implementation title.
- Include Variation Choices, Coverage, Realized Interfaces, Conformance Evidence, Limitations, Technology Choice, Execution, Context, Implementation Summary, Realized Capabilities, Runtime Components, Data Realization, Integration Realization, Security Control Realization, NFR Realization, Assumptions, Risks, Constraints, Dependencies, and Traceability.
- Coverage has one row per responsibility the architecture states. Status is covered or not applicable.
- When every row is covered or not applicable, Conformance is `compatible`. Do not write a gap section or a conflict section.
- When a stated responsibility is uncovered, Conformance is `incomplete` and the gap is stated.
- A technology choice is stated once, with its intent, its reason, and its evidence.
- The architecture is named once, in Architecture Reference.
- Security Control Realization and NFR Realization project the accepted Controls and NFRs. Do not change those records.
- Traceability names the Request, Discovery, the decision this realization came from, and this implementation. Do not name the architecture again.
- Each realized capability title follows the capability title rule, and each capability has one or more Realized By values.

Capability title rule: a capability title is one noun phrase of five words or fewer. A hyphenated word counts as one word. Modifiers can precede the noun. A title does not contain `and`, `or`, `&`, `/`, `+`, or a comma. A title that joins two things is two capabilities, one per part. Each part keeps its own words and repeats a shared noun when there is one.

Edit `implementations/capabilities.md` in its existing structure.

The catalog is written with its owning Reference Implementation. It has no `Next ID` field. The columns are ID, Parent, Title, and Realized By.

Parent is the implementation id. Title is one capability and follows the capability title rule. Realized By lists the providers or mechanisms, in alphabetical order. The id is CAP plus eight hex digits derived from the title. The same Parent and title reuse that id. A removed row is not used; rows for one Parent are replaced on each write, and other Parents stay unchanged.

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

Edit `implementations/implementations.md` in its existing structure.

The catalog owns the baseline version and the implementation index. It has no `Next ID` field. The index columns are Implementation ID, Architecture ID, Implementation Title, Implementation Path, and Status.

Each Implementation ID appears once. Rows are ordered by Implementation ID. The Implementation ID is `RI` plus the eight hex digits derived from the title. Architecture ID is the accepted Reference Architecture this implementation realizes. More than one row may name the same Architecture ID. A removed row does not count as a current implementation. Status is `accepted` or `removed`.

`accepted` has a record at `implementations/<id>.md`. `removed` has no record file. A removed row stays in the index, keeps the title that last held that id, and leaves the id taken.

- The index columns are Implementation ID, Architecture ID, Implementation Title, Implementation Path, and Status.
- Implementation ID is the `RI` id. Architecture ID is the `RA` id. Implementation Path is `implementations/<RI id>.md`. Status is `accepted`.
- Order the index by ID.
- Do not allocate from `Next ID`.
- The first catalog version is `1.0.0`.
- Adding an implementation increments the minor version.
- More than one row may name the same Architecture ID.

On success, go to `platforms`.

### platforms

When `onboarding` follows this step, return to `highway-onboarding` instead of going to `close`. Do not emit the included line or ask the question.

Read the accepted implementation's Technology Choice, Runtime Components, and Realized By. It can start automation when they describe a pipeline, an orchestrator, a self-service platform, a desired-state or GitOps tool, or an agent that starts the work. A store, a newsletter, a records product, or a backup cannot. When it cannot, write nothing, say nothing, and go to `close`.

Otherwise edit `library/coding-standards/codify-platforms.md` in its existing structure. Every row comes from an accepted implementation. There is one row per Implementation ID. Rows stay in the order they were added. Platform is the implementation title. Implementation ID is its `RI` id. Kind is blank. When to use and When not to use are blank. Keep one row for this Implementation ID: when present, replace its Platform and keep its Kind, When to use, and When not to use; otherwise append it. Leave every other row unchanged. A failed write leaves the existing file unchanged. Say what failed, then go to `close`.

On success, emit:

**[Platform] is included as a platform highway can use in highway-codify proposals**

**Would you like to configure how highway-codify uses [Platform]?**

- `accept`, or a yes: emit: Let's configure how highway-codify uses [Platform]. Follow `highway-codify-config` for [Platform], with the return step `close` in `highway-implementation`.
- `decline`, or a no: go to `close`.
- `question`: answer, then re-emit the question.
- `unknown`: go to `close`.

Opening, listing, or declining does not enter `platforms`.

### close

**Reference Implementation recorded**

- **Implementation record:** `implementations/[RI id].md`
- **Title:** [Title]
- **Identifier:** `[RI id]`
- **Architecture:** `[RA id]`

This is a realization blueprint. It does not authorize deployment.

### add capabilities

1. Hold the return step for this visit.
2. Read `implementations/[RI id].md` and `implementations/capabilities.md`. When the implementation is not accepted, say it is not accepted. Write nothing. Go to the held step.
3. Leave out a passed capability whose title Realized Capabilities already lists.
4. Derive each capability id as `write` does. When a title breaks the capability title rule, or `write` would ask for a wording change, leave that capability out.
5. Append each remaining capability to Realized Capabilities, in the order passed, with its Title, Realized By, and Evidence. Change no other byte of the record.
6. Rewrite this Parent's rows in `implementations/capabilities.md` as `write` does, with the new capabilities. Leave other Parents unchanged.
7. Write the record and the catalog together. A failed write leaves both unchanged. Say what failed. Go to the held step.
8. Emit **New capabilities recorded for [Title]:** and list each recorded title. Name each capability left out in step 4.
9. Go to the held step. Do not ask a question. Do not run `platforms` or `close`.

### delivery platforms

1. Hold the return step for this visit. Keep it while configuration or onboarding runs from this step.
2. Read `implementations/[RI id].md` and its architecture.
3. Hold the record's value for each Execution field. Deployed by and Managed by are unset when `Needed`, empty, or naming a platform with no row. Language is unset when `Needed`, empty, or naming a standard with no row. Hold the `execution` value for each unset field. A value the person named in this visit replaces the held value.
4. Emit:

**Here is the proposed Deployed by, Managed by and Language for [Product Title]**

**Product Title:** [Title]

**Architecture Reference:** [RA id] — [Architecture title]

**Deployed by:** [Platform. Or: Needed.]

**Why it matters:** [From `why it matters`.]

**Managed by:** [Platform. Or: Needed.]

**Why it matters:** [From `why it matters`.]

**Language:** [Standard Title. Or: None.]

**Why it matters:** [From `why it matters`.]

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: follow `field` for each named field, with the return step `delivery platforms` in `highway-implementation`. Re-emit this view.
- `accept`: when Deployed by, Managed by, or Language is Needed, name that field and re-emit this view. Otherwise rewrite the three Execution lines with the held fields. Change no other byte. A failed write leaves the record unchanged. Say what failed. Re-emit this view. On success, emit: The preferred delivery platforms for [Title] are set. Picking up your highway-codify run. Go to the held step.
- `decline`: go to `delivery decline`.
- `question`: answer, then re-emit this view.
- `unknown`: re-emit this view.

Do not create an implementation. Do not run `platforms` or `close`.

### delivery decline

Write nothing. Emit:

Leaving the preferred delivery platforms for [Title] unset. highway-codify needs these details before it can make proposals for [Title].

**Would you like to return and provide these details now?**

- A yes: re-emit the `delivery platforms` view.
- A no, or `decline`: go to the held step.
- `question`: answer, then re-emit this question.
- `unknown`: re-emit this question.

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
- Each capability title follows the capability title rule. A title that joins two things becomes two capabilities without a question, and the consequence sentence names the compounding effect.
- A capability id is `CAP` plus eight hex digits. The same Parent and title reuse that id. No capability record file is written.
- The record contains no plans, tasks, source code, or infrastructure definitions.
- Each id is `RI` plus eight hex digits derived from the title.
- The implementation title is the decision's product or named mechanism, without "Adopt". The proposal shows it before acceptance. It gains "for" and the purpose only when that title belongs to an implementation of a different architecture.
- The catalog index columns are Implementation ID, Architecture ID, Implementation Title, Implementation Path, and Status.
- A taken id names the conflicting titles, says a title change is appropriate, and shows a new title. The write waits until the person accepts that title.
- That message does not mention identifiers, hex, sampling, or the catalog.
- A failed write leaves existing implementation, implementation-catalog, and capability-catalog bytes unchanged.
- The skill does not change the Reference Architecture, the decision statement, the rationale, the selected option, or the decision status.
- The skill does not write an implementation id onto the ADR.
- An accepted implementation that can start automation, such as an agent that starts the work, gets one row in `library/coding-standards/codify-platforms.md` with blank When to use and When not to use. The person is told it is included and asked whether to configure how highway-codify uses it. A yes emits "Let's configure how highway-codify uses [Platform]." and follows `highway-codify-config` for that platform with the return step `close`. A no goes to `close`. Under `onboarding`, the step returns to highway-onboarding after the write, without the included line or the question.
- A store, a newsletter, a records product, or a backup gets no row and no message. Opening, listing, or declining writes no row.
- An invocation from `highway-codify-config` naming an accepted implementation, new realized capabilities, and a return step goes to `add capabilities`. It appends them to Realized Capabilities and to this Parent's capability rows, changes no other record byte, asks no question, and goes to the held step. A passed title that breaks the capability title rule is left out and named.
- An invocation from `highway-codify` naming an accepted implementation and a return step goes to `delivery platforms`. It opens with "Here is the proposed Deployed by, Managed by and Language for [Product Title]", then shows Product Title, Architecture Reference, Deployed by, Managed by, and Language, each field followed by its Why it matters line. Accept stays on the view while a field is Needed. Acceptance rewrites only the three Execution lines, emits "The preferred delivery platforms for [Title] are set. Picking up your highway-codify run.", and goes to the held step.
- The delivery platforms view holds the record's fields, then the `execution` value for each unset one: Deployed by or Managed by that is `Needed`, empty, or has no row, and Language that is `Needed`, empty, or has no row. A stored `None` is shown as stored. A value the person named in the visit replaces it. This implementation's row is never a candidate.
- A handoff from `highway-onboarding` writes an accepted implementation without a proposal and returns its `RI` id to highway-onboarding, never to a step another visit holds. It asks only the title message, when the title cannot be used. A `decline` writes nothing.
- An onboarded implementation stores Deployed by, Managed by, and Language as `Needed`.
- The `start` proposal and the delivery platforms view follow Deployed by, Managed by, and Language each with its Why it matters line from `why it matters`.
- A decline writes nothing, emits "Leaving the preferred delivery platforms for [Title] unset. highway-codify needs these details before it can make proposals for [Title].", and asks whether to return. A yes shows the view again. A no goes to the held step.

## Error Handling

- A missing or unknown architecture stops the skill and writes nothing.
- An architecture that is not accepted stops the skill and writes nothing.
- A realization that contradicts the architecture stops the write and names the conflict.
- A malformed present Profile, Objective, Control, or NFR baseline stops the skill and writes nothing.
- A failed write leaves the architecture and every other implementation unchanged, and leaves existing implementation, implementation-catalog, and capability-catalog bytes unchanged.
- Declining a proposal writes nothing.

## Example

`/highway-implementation RAb7c41e20`