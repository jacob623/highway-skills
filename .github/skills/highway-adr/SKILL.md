---
name: highway-adr
description: "Manages one architecture decision for one discovery."
usage: "Invoke as /highway-adr with one discovery id."
compatibility: all
metadata:
  version: 3.0.0
---

# highway-adr

## Purpose

Records one accepted architecture decision for a Discovery after the person selects an option and accepts the proposed decision.

## When to use

- The person invokes `/highway-adr` with one Discovery id and one option id.
- The person invokes `/highway-adr` with one Discovery id.
- The person invokes `/highway-adr` without a Discovery id or an option id.

## When not to use

Do not generate new candidate options or change a Discovery.
Do not recalculate scores, reorder the comparison, or recompute Reference Architecture matches.
Do not change Requests, Clarifications, Profile, Objectives, Controls, or NFRs.
Do not authorize implementation.
Do not report Status, Summary, Next Action, Blocking Reason, Missing, Complete, or Blocked.

## Inputs

- One Discovery id that matches one row in `discoveries/discoveries.md`, when the person supplies one.
- One option id contained in that Discovery, when the person supplies one.
- The Discovery record at `discoveries/[ID].md`.
- `clarifications/clarifications.md` when present, for `CLAR-[REQ id]` and `CLAR-[DISC id]` only.
- Accepted Profile, Objectives, Controls, and NFRs when present.
- `discoveries/discoveries.md` and `adrs/adrs.md`.
- `.highway/library/templates/output/adr-record.md`.
- `.highway/library/templates/output/adr-catalog.md`.
- `.highway/governance/experience-standard.md`.
- A project root containing `.highway/`.

## Outputs

The complete structure is `.highway/library/templates/output/adr-record.md` and `.highway/library/templates/output/adr-catalog.md`.

- One ADR at `adrs/[ID].md` after the person accepts the proposed decision.
- An updated `adrs/adrs.md` written with that record.
- A closing message that names the ADR and the architecture command.
- No ADR when the person has not selected an option or a write fails.

## Procedure

User-visible interaction follows the Highway Experience Standard. Repository ownership stays with the person.

Emit only the active template. Follow this order: `choose-discovery` when no Discovery id is supplied; `choose-option` when no option is supplied; otherwise `start`, then `identifier`, `title` when needed, `write`, and `close`. Discovery owns the options, scores, recommendation, and matches. Copy those values. Do not change them. The person owns the selection. Do not select an option from the recommendation, a score, or alphabetical order.

Read evidence in this order: Discovery, Clarification for that Discovery, the Request, Clarification for that Request, Profile, Objectives, Controls, NFRs. A missing Clarification continues without it. An open finding can inform a risk. It cannot select or reject an option. Do not change Clarification.

One Discovery has one ADR. When `adrs/adrs.md` already has an ADR for that Discovery id, show that decision and write nothing.

### Entry

1. Read the invocation for one Discovery id and one option id.
2. When neither is present, go to `choose-discovery`.
3. When a Discovery id is present, resolve it. When it matches no Discovery, stop. Say the Discovery was not found. Write nothing.
4. When that Discovery already has an ADR, show the recorded decision. Write nothing.
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
- `edit`: adds, removes, corrects, or replaces decision text.
- `accept`: affirms the proposed decision and adds no fact.
- `unknown`: the person says they do not know.
- `question`: asks for an explanation.
- `decline`: the person stops or cancels.

On `start`, "looks good" is `accept`.

### start

Build the proposed decision from the selected option and the Discovery. Copy the comparison and the matches. When the selected option is not the recommended option, include the override.

**Here is a proposed starting point for your decision:**

**Decision:** [Selected option title]

**Why:** [Decision rationale grounded in the Discovery and accepted Objectives, Controls, and NFRs.]

**Alternatives:**
- **[Other option title]:** [Evaluated when it remains viable. Rejected when the Discovery excluded it.]

**Consequences:**
- **Positive:** [What improves.]
- **Negative:** [What is given up.]
- **Operational:** [How operation changes.]
- **Governance:** [Which accepted Controls or NFRs this decision carries.]

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: emit one consequence sentence. Re-emit this block with the edit applied. Stay on `start`. The selected option stays the option the person named.
- `accept`: go to `identifier`.
- `unknown`: re-emit this block. Stay on `start`.
- `question`: answer, then re-emit this block. Stay on `start`.
- `decline`: stop. Write nothing.

### identifier

The ADR title is the selected option title unless the person supplied a title.

1. Lowercase the title. Remove hyphens and apostrophes. Split the rest into words.
2. Take eight letters: the first two of word 1, the first two of word 2, the first two of word 3, and the last two of the last word. When the title has only two words, the third sample is the first two of the last word.
3. When a word is shorter than two letters, continue into the next word. A one-word title repeats until there are eight letters.
4. Map each letter. Digits stay as they are.

a 0, b 1, c 2, d 3, e 4, f 5, g 6, h 7, i 8, j 9, k a, l b, m c, n d, o e, p f, q 0, r 1, s 2, t 3, u 4, v 5, w 6, x 7, y 8, z 9.

5. The id is `ADR` plus those eight hex digits.

Compare that id with `adrs/adrs.md`, including removed rows.

- The same title already has that id: use the existing record. Do not write a second one. Go to `close`.
- The id is taken for a different title: go to `title`.
- The id is free: go to `write`.

### title

Name each conflicting title. Say that a title change is appropriate. Then show the new title for acceptance.

The existing ADR Title, **[Existing title]** and this new ADR Title, **[this title]**, are too similar. A title change is appropriate. I would recommend:

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

Write `adrs/[ID].md` and `adrs/adrs.md` together. Write neither file until both are valid. A failed write leaves every existing ADR byte unchanged. Say what failed in terms the person can act on. Stay on `write`.

The record follows `.highway/library/templates/output/adr-record.md`.

- `id` is the derived `ADR` id.
- `request` is the Discovery's Request id.
- `discovery` is the Discovery id.
- `status` is `accepted`.
- `supersedes` is `None`.
- `superseded_by` is `None`.
- The title is the accepted ADR title.
- Copy the Discovery comparison, recommendation, confidence, and Reference Architecture matches into `## Discovery Reference` and `## Decision Confidence` without recalculation.
- `## Context` states the problem this decision responds to and the forces that make it necessary, in prose, and the evidence-resolution record or `None`.
- `## Decision` records the selected option, `User-provided explicit selection`, the decision statement, the rationale, and this authorization: Proceed to Reference Architecture. Implementation is not authorized.
- `## Decision Scope` states what the decision covers and what it leaves open, or `None` for what it leaves open.
- `## Revisit When` states the condition that should cause the decision to be reopened, or `None` when no condition is known.
- When the selected option differs from the Discovery recommendation, write `## Recommendation Override` with both options and the override rationale. Omit that section when they are the same.
- `## Alternatives Considered` lists every Discovery option, headed by its option id, with its definition, one outcome, and a reason. The selected option is `Selected`. Every other option is `Evaluated` when it remained viable, or `Rejected` when the Discovery excluded it.
- Each Objective relationship is the Objective id and `advances`. Each Control relationship is the Control id and `bound by`. Each NFR relationship is the NFR id and `satisfies`. A section with no relationship is `None`.
- `## Reference Architecture Handoff` names the architecture direction or `None`, the required architecture work or `None`, Reference Architecture `None`, Reference Implementation `None`, and authorization to proceed to Reference Architecture. Do not repeat the selected option or the matches there.
- Emit no timestamp, random value, or environment value.

Status is `superseded` in the record and in the catalog exactly when `superseded_by` names an ADR. Otherwise it is `accepted`. A superseded record keeps its file and its id. Do not treat it as removed.

The catalog follows `.highway/library/templates/output/adr-catalog.md`.

- Add one index row with the ADR ID, Discovery ID, Request ID, ADR Title, ADR Path, and Status `accepted`.
- Order the index by ADR id.
- Do not allocate from `Next ID`.
- The first catalog version is `1.0.0`.
- Adding an ADR increments the minor version.
- One Discovery id appears on at most one row.

On success, go to `close`.

### close

**Architecture decision recorded**

- **ADR record:** `adrs/[ADR id].md`
- **Title:** [Title]
- **Identifier:** `[ADR id]`
- **Discovery:** `[DISC id]`
- **Selected option:** [Option title]

Run `/highway-architecture [ADR id]` to create the Reference Architecture.

## Verification

- A Discovery id and an option id open the proposed decision for that option.
- A Discovery id without an option id lists the options with numbers. Each line shows the option id and its title. A stated number selects that option.
- An invocation with neither id lists the accepted Discoveries whose Discovery ID is absent from every ADR catalog row. Each line shows the Discovery ID and its title. The list is numbered. A stated number selects that Discovery. A removed ADR row keeps that Discovery off the list.
- The proposed decision is accepted before the ADR is written.
- One Discovery produces at most one ADR.
- The selected option is the option the person named or numbered.
- The comparison and matches are copied from the Discovery.
- Recommendation Override is written only when the selection differs from the recommendation.
- Context states the problem and the forces. The record states what the decision covers, what it leaves open, and when to revisit it, or `None`.
- Alternatives Considered includes the selected option as `Selected`, and each alternative has a definition, one outcome, and a reason.
- The handoff does not repeat the selected option or the matches. Reference Architecture and Reference Implementation are `None` when the ADR is written.
- Relationship lines use `advances`, `bound by`, and `satisfies`, or `None`.
- Status is `superseded` in the record and catalog exactly when `superseded_by` names an ADR, and the record file remains.
- Authorization proceeds to Reference Architecture and does not authorize implementation.
- Each id is `ADR` plus eight hex digits derived from the title.
- A taken id names the conflicting titles, says a title change is appropriate, and shows a new title. The write waits until the person accepts that title.
- That message does not mention identifiers, hex, sampling, or the catalog.
- A failed write leaves existing ADR bytes unchanged.
- The closing message names `/highway-architecture [ADR id]`.
- The skill does not change the Discovery.

## Error Handling

- A missing or unknown Discovery stops the skill and writes nothing.
- An option that is not in the Discovery returns to `choose-option` and writes nothing.
- A second ADR for the same Discovery stops the write and shows the existing decision.
- A malformed present Discovery stops the skill and writes nothing.
- A failed write leaves existing ADR and catalog bytes unchanged.

## Example

`/highway-adr DISC3f2a9c10 OPTa91c2b04`