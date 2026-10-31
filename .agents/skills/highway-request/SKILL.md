---
name: highway-request
description: "Manages one business request and its accepted artifact."
usage: "Invoke as /highway-request with the business change."
compatibility: all
metadata:
  version: 5.0.0
---

# highway-request

## Purpose

Collects one business request from the invocation.

## When to use

- The person invokes `/highway-request` with a business problem, idea, or desired change.
- The person invokes `/highway-request` and the description is still to be supplied.

## When not to use

Do not create Discovery, ADR, Architecture, Implementation, Control, NFR, or Objective records.
Do not change the status of an existing request.
Do not choose a solution or an architecture while shaping the request. The close may name an accepted implementation. Do not write an implementation.
Do not report Status, Summary, Next Action, Blocking Reason, Missing, Complete, or Blocked.
Do not show Current Domain, Completed Domains, or Remaining Domains.

## Inputs

- The person's invocation text.
- Accepted Profile, Objectives, Controls, and NFRs when present.
- `requests/requests.md` and `requests/REQ*.md` when present.
- `.highway/library/templates/output/request-record.md`.
- `.highway/library/templates/output/request-catalog.md`.
- `.highway/governance/experience-standard.md`.
- A project root containing `.highway/`.

## Outputs

The complete structure is `.highway/library/templates/output/request-record.md` and `.highway/library/templates/output/request-catalog.md`.

- One request record at `requests/[ID].md` after the complete proposal is accepted.
- An updated `requests/requests.md` written with that record.
- A closing message that names the record and exactly one next step.
- No request artifact when the proposal is not accepted or a write fails.

## Procedure

Emit only the active template. Follow this order: `intake` when the invocation has no description; otherwise `start`, then `identifier`, `title` when needed, `write`, and `close`. Follow `.highway/governance/experience-standard.md` for attribution and acceptance wording. Use accepted Profile, Objectives, Controls, and NFRs as grounding. Do not ask for facts those records already answer. Do not treat an example as the person's evidence.

Collect seven domains in this order: Problem, Actors, Current Process, Desired Change, Success Measure, Business Constraints, Solution Constraints. Record `Unknown` when the person says they do not know. Do not invent a value.

Exclude a secret or regulated personal data. Ask for a business-relevant replacement. After three blocked replacements, stop and write nothing.

### Entry

1. Read the invocation. A handoff from `highway-assessment` is invocation context.
2. When it names a business problem, idea, desired change, or a seeded assessment finding, go to `start`. Do not carry assessment solution examples into the request. The close names the next skill after the request is accepted.
3. When it does not, go to `intake`.
4. When `.highway/` cannot be found, stop. Say the project root cannot be located. Write nothing.

### Classify

Classify the latest reply before any other action.

- `edit`: adds, removes, corrects, splits, combines, or replaces substance.
- `accept`: affirms the current block and adds no fact.
- `unknown`: the person says they do not know.
- `question`: the person asks for an explanation.
- `decline`: the person stops, cancels, or pauses the request.

On `start`, "looks good" is `accept`.

### intake

**What business problem, idea, or change should this request cover?**

If you don't know, say "I don't know" and we'll work through it together.

- `own` or `edit`: use that description. Go to `start`.
- `unknown`: re-emit this template. Stay on `intake`.
- `question`: answer in one sentence. Re-emit this template. Stay on `intake`.
- `decline`: stop. Write nothing.

### start

Build one starting point from the invocation and accepted repository context. Fill every slot, including Solution Constraints. Use `Unknown` or `No business constraints` only for a slot the evidence cannot support. Do not ask the person to originate a slot that the starting point can propose.

Solution Constraints limit later Discovery. They do not choose an architecture, technology, or candidate.

- `allowed_solution_classes`: one or more classes, or `unknown`. Never an empty list.
- `existing_platforms_required`: platforms that must be used, an empty list, or `unknown`.
- `existing_platforms_preferred`: platforms the person prefers, an empty list, or `unknown`. Keep these distinct from required platforms.
- `known_systems`: systems involved, an empty list, or `unknown`.
- `hosting_restrictions`: a non-empty restriction or `unknown`.
- `vendor_restrictions`: a non-empty restriction or `unknown`.
- `procurement_constraints`: a non-empty restriction or `unknown`.
- `regulatory_restrictions`: a non-empty restriction or `unknown`.

When an active NFR is titled **No system hosting**, set `hosting_restrictions` to its statement. Set `allowed_solution_classes` to `managed service` when that statement says the organization does not host. Set it to `hosted system` when that statement says the organization hosts. Do not leave either field `unknown`.

When an active NFR is titled **Direct purchase**, set `procurement_constraints` and `vendor_restrictions` to its statement. Do not leave either field `unknown`. Copy a corrected statement under the same title.

Do not recreate a removed or retitled limit from another NFR. When the request material states the hosting or buying limit, show that material for the field instead.

Derive a short title from the Problem. Use a title the person already supplied when they supplied one.

Show each Solution Constraints field by its readable name, in the field order above. Show `None` when a value is `unknown` or an empty list. When the person says "none" for a field, hold an empty list for `existing_platforms_required`, `existing_platforms_preferred`, and `known_systems`. Hold `unknown` for `allowed_solution_classes`, `hosting_restrictions`, `vendor_restrictions`, `procurement_constraints`, and `regulatory_restrictions`. The record keeps the field names and values above.

**Here is a proposed starting point for your request:**

Emit this level-1 heading:

[Title]

Emit these level-2 headings, in this order, with the text under each:

Problem
[What is going wrong or missing.]

Actors
[Who is involved.]

Current Process
[How the work happens today.]

Desired Change
[What should be different.]

Success Measure
[What will show the change worked.]

Business Constraints
[Limits on the business change, or `No business constraints`.]

Solution Constraints
- **Allowed Solution Classes:** [One or more classes, or None.]
- **Existing Platforms Required:** [Platforms, or None.]
- **Existing Platforms Preferred:** [Platforms, or None.]
- **Known Systems:** [Systems, or None.]
- **Hosting Restrictions:** [Restriction, or None.]
- **Vendor Restrictions:** [Restriction, or None.]
- **Procurement Constraints:** [Restriction, or None.]
- **Regulatory Restrictions:** [Restriction, or None.]

**What would you add, correct, or remove?**

If this is accurate, just say so. If you don't know, say "I don't know" and we'll work through it together.

- `edit`: emit one consequence sentence. Re-emit this block with the edit applied. Stay on `start`.
- `accept`: hold the title and all seven domains. When `allowed_solution_classes` is empty, restore one or more grounded classes or `unknown` and re-emit this block. Otherwise go to `identifier`.
- `unknown`: re-emit this block. Stay on `start`.
- `question`: answer in one sentence. Re-emit this block. Stay on `start`.
- `decline`: stop. Write nothing.

A malformed Solution Constraints field names that field by its readable name, its accepted shape, and one valid example, then re-emits this block with that field corrected. Update only that field.

### identifier

Derive the id from the accepted title.

1. Lowercase the title. Remove hyphens and apostrophes. Split the rest into words.
2. Take eight letters: the first two of word 1, the first two of word 2, the first two of word 3, and the last two of the last word. When the title has only two words, the third sample is the first two of the last word.
3. When a word is shorter than two letters, continue into the next word. A one-word title repeats until there are eight letters.
4. Map each letter. Digits stay as they are.

a 0, b 1, c 2, d 3, e 4, f 5, g 6, h 7, i 8, j 9, k a, l b, m c, n d, o e, p f, q 0, r 1, s 2, t 3, u 4, v 5, w 6, x 7, y 8, z 9.

5. The id is `REQ` plus those eight hex digits.

Compare that id with `requests/requests.md`, including removed rows.

- The same title already has that id: use the existing record. Do not write a second one. Go to `close`.
- The id is taken for a different title: go to `title`.
- The id is free: go to `write`.

### title

Name each conflicting title. Say that a title change is appropriate. Then show the new title for acceptance.

The existing Request Title, **[Existing title]** and this new Request Title, **[this title]**, are too similar. A title change is appropriate. I would recommend:

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

Write `requests/[ID].md` and `requests/requests.md` together. Write neither file until both are valid. A failed write leaves every existing request byte unchanged. Say what failed in terms the person can act on. Stay on `write`.

The record follows `.highway/library/templates/output/request-record.md`.

- `id` is the derived `REQ` id.
- `status` is `accepted`.
- The title is the accepted title.
- The seven domain sections hold the accepted evidence.
- `## Completeness` is `Complete`.
- Do not write relationship sections.

The catalog follows `.highway/library/templates/output/request-catalog.md`.

- Add one index row for this request.
- Order the index by identifier.
- Do not allocate from `Next ID`.
- The first catalog version is `1.0.0`.
- Adding a request increments the minor version.
- Emit no timestamp, random value, or environment value.

On success, go to `close`.

### close

**Request created**

- **Request record:** `requests/[ID].md`
- **Title:** [Title]
- **Identifier:** `[ID]`
- **Status:** accepted

Read `implementations/implementations.md`. A match is an accepted row. A removed row does not match. Open an accepted implementation record to read its summary and its realized capability titles.

When Entry recorded a handoff from `highway-assessment`, the match set is the accepted implementations named by that finding's accepted evidence. Do not add other matches.

Otherwise compare the accepted request title and Desired Change, without regard to case. An exact implementation title selects that one implementation. Otherwise a realized capability title that appears in full in that text is a match. Otherwise an implementation title that appears in full in that text, or that text appearing in full in the summary, is a match. Put exact titles first, then capability titles, then summary matches. Within each group, keep catalog order.

The action is Desired Change. When it states a second action, keep the first and say the other waits for another run.

When one implementation matches, name it by title. Do not mention discovery. Do not state the day. Emit:

Run `/highway-codify` for **[Implementation title]** to **[action]**.

When two to five match, list them by title and short description. Do not use an id as the label. After the person picks one, emit the one-match line and say the others wait for another run.

When more than five match, list none. Say the person can give a title or a description. Then suggest at most five by the same order.

When no accepted implementation matches, emit:

Run `/highway-discovery [ID]` to evaluate candidate solutions against your objectives, safeguards, and operational expectations.

Do not continue into codify in the same message. Do not rewrite the request.

## Verification

- An invocation with a business description begins at the request starting point.
- The starting point includes Solution Constraints.
- The starting point shows the title as a level-1 heading and each of the seven domains as a level-2 heading.
- Solution Constraints are shown by readable name, with `None` for a value that is `unknown` or an empty list. The record keeps its field names and values.
- "Looks good" on the starting point writes the record and catalog. The person accepts the request once.
- No record is written while a domain is missing.
- `allowed_solution_classes` contains one or more values or `unknown`.
- Each id is `REQ` plus eight hex digits derived from the title.
- A taken id for a different title names the conflicting titles, says a title change is appropriate, and shows a new title. The write waits until the person accepts that title.
- That message does not mention identifiers, hex, sampling, or the catalog.
- A secret or regulated personal value is not written.
- A failed write leaves existing request and catalog bytes unchanged.
- The closing message names the record and exactly one next step. One match names `/highway-codify` for that title and the one action, and does not state the day. No match names `/highway-discovery [ID]`.
- The skill creates no Discovery or ADR artifact.

## Error Handling

- An empty invocation stays on `intake` and writes nothing.
- A missing `.highway/` root stops the skill and writes nothing.
- A missing record or catalog template stops the skill, names the template path, and writes nothing.
- A failed write leaves existing request and catalog bytes unchanged.
- A secret or regulated personal value is replaced up to three times, then the skill stops and writes nothing.
- An invalid Solution Constraints field is replaced up to three times. Further failure leaves existing bytes unchanged.

## Example

`/highway-request We need a consistent way for finance reviewers to reduce manual invoice comparison time.`