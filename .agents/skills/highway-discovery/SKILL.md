---
name: highway-discovery
description: "Manages one discovery for a complete request."
usage: "Invoke as /highway-discovery with one request id or one discovery id."
compatibility: all
metadata:
  version: 3.0.0
---

# highway-discovery

## Purpose

Creates one Discovery for a completed Request, writes every option before the list is shown, and updates that file when the person adds, replaces, or removes an option.

## When to use

- The person invokes `/highway-discovery` with one Request id.
- The person invokes `/highway-discovery` with one Discovery id.
- The person invokes `/highway-discovery` without a Request id or a Discovery id.

## When not to use

Do not select a Request by recency, filename, or batch.
Do not analyze an incomplete Request or invent missing request evidence.
Do not approve, create, or change Objectives, Controls, NFRs, Requests, ADRs, Architectures, or Implementations.
Do not record a selected option, a rejected option, or an architecture decision.
Do not report Status, Summary, Next Action, Blocking Reason, Missing, Complete, or Blocked.

## Inputs

- One Request id that matches one row in `requests/requests.md`, when the person supplies one.
- One Discovery id that matches one row in `discoveries/discoveries.md`, when the person supplies one.
- The completed Request at `requests/[ID].md`.
- Accepted Profile, Objectives, Controls, and NFRs when present.
- `clarifications/clarifications.md` and one Clarification at `CLAR-[REQ-ID]` when that row exists.
- Reference Architectures and Reference Implementations when present, for exact matching and tie-breaks only.
- `requests/requests.md` and `discoveries/discoveries.md`.
- `.highway/library/templates/output/discovery-record.md`.
- `.highway/library/templates/output/discovery-catalog.md`.
- `.highway/governance/experience-standard.md`.
- A project root containing `.highway/`.

## Outputs

The complete structure is `.highway/library/templates/output/discovery-record.md` and `.highway/library/templates/output/discovery-catalog.md`.

- One Discovery record at `discoveries/[ID].md`, written before the option list is shown.
- An updated `discoveries/discoveries.md` written with that record.
- An updated record when the person adds, replaces, or removes an option.
- No Discovery artifact when fewer than two options remain or a write fails.

## Procedure

User-visible interaction follows the Highway Experience Standard. Repository ownership stays with the person.

Emit only the active template. Follow this order: `choose` when neither id is supplied; `analyze` for a Request; `identifier`, `title` when needed, and `write` before `start`; then `explore`. A supplied Discovery id goes to `start` and does not write. The recommendation is advisory. ADR owns the decision. Do not mutate the Request, Clarification, Profile, Objectives, Controls, NFRs, Architectures, or Implementations.

Load evidence in this order: Request, its eight Solution Constraints, Clarification responses, Profile, Objectives, Controls, NFRs, Reference Architectures. Request evidence wins when Clarification disagrees. Clarification changes assumptions, risks, unknowns, and research findings only. It does not change which options exist, their scores, or the recommendation.

Redact secrets and regulated personal data before scoring or writing. Replace each with a stable category marker.

### Entry

1. Read the invocation for one Request id or one Discovery id.
2. When both are present, go to `choose`.
3. When one Request id is present, resolve it. When it matches no request, stop. Say the Request was not found. Write nothing. When its `## Completeness` is not `Complete`, stop. Say the Request is incomplete. Write nothing. Otherwise go to `analyze`.
4. When one Discovery id is present, resolve it. When it matches no Discovery, stop. Say the Discovery was not found. Write nothing. Otherwise load its options and go to `start`. Do not write.
5. When neither is present, go to `choose`.

### choose

When both a Request id and a Discovery id were supplied, ask which one to use.

**Would you like to analyze the Request, or explore the Discovery?**

- The Request: follow Entry case 3.
- The Discovery: follow Entry case 4.
- `unknown`: re-emit this question. Stay on `choose`.
- `decline`: stop. Write nothing.

When neither id was supplied, read `requests/requests.md` and `discoveries/discoveries.md`. A Request is ready to analyze when its Status is `accepted`, its record `## Completeness` is `Complete`, and its ID does not appear as Request ID on any Discovery catalog row. A removed Discovery row still counts as that Request already having a Discovery. A Discovery is ready to explore when its Status is `accepted`.

When none are ready, say that no Request or Discovery is waiting. Write nothing.

Otherwise emit one numbered list, starting at 1. Requests come first, in Request catalog order, then Discoveries, in Discovery catalog order. Omit an empty group. Show each id and its title. A stated number selects that row.

**Requests ready to analyze**

**1. [Request ID]:** [Request Title]

**Discoveries ready to explore**

**2. [Discovery ID]:** [Discovery Title]

**Which would you like to work on?**

- A Request id, a listed Request title, or its number: follow Entry case 3.
- A Discovery id, a listed Discovery title, or its number: follow Entry case 4.
- `unknown`: re-emit this list. Stay on `choose`.
- `decline`: stop. Write nothing.

### Classify

Classify the latest reply before any other action.

- `select`: names an option, or states its number, to explore.
- `decide`: says they are ready to decide on an option.
- `matrix`: asks to see the comparison matrix.
- `edit`: adds, removes, corrects, splits, combines, or replaces an option or the Discovery title.
- `accept`: affirms the current block and adds no fact.
- `unknown`: the person says they do not know.
- `question`: asks for an explanation, a comparison, examples, or costs.
- `decline`: the person stops or cancels.

On `start`, "looks good" stays on `start`. It does not select an option.

### analyze

Generate candidate options from the Request's Desired Change, then from accepted Objectives, Controls, NFRs, and Reference Architectures.

When `allowed_solution_classes` is known, keep only options in those classes. When it is `unknown`, do not filter by class.

Exclude an option that violates `existing_platforms_required`, `hosting_restrictions`, `vendor_restrictions`, `procurement_constraints`, or `regulatory_restrictions`. Record each exclusion with the option title, the constraint, and the reason. Preferred platforms and known systems do not exclude an option.

Sort the remaining options by Desired Change alignment, Objective alignment, constraint alignment, then title. Keep the first two to five. When more than five remain, keep the first five and record the rest as excluded by that boundary. When fewer than two remain, stop. Say the Request does not support two viable options. Write nothing.

Derive each option id with the title rule in `identifier`, using the prefix `OPT`. Then score only the retained options.

- Required Platform Match is 100.
- Preferred Platform Match is 100 when a preferred platform is used, and 50 otherwise.
- Known-System Alignment is 100 when all declared known systems are reused, 75 when some are reused, and 50 when none are reused.
- Score weights are Objective 25, NFR 25, Control 20, Constraint Alignment 20, and Risk Reduction 10. Use floor rounding. A zero denominator scores 0. The total is 0 through 100.
- Confidence is High for 90 through 100, Medium for 70 through 89, and Low for 0 through 69.
- Complexity, Governance Impact, and Operational Overhead do not change the score.

Match a Reference Architecture only by explicit identifier, exact title, capability id, Objective id, Control id, or NFR id, in that order. Do not match by similarity.

Count a Reference Implementation only when it references a matched Reference Architecture, or references that architecture's id. Count each implementation id once. A missing or unreadable implementation counts as zero.

When totals tie, pick the winner in this order, and stop at the first criterion that leaves one option: a Reference Architecture match, then the higher Reference Implementation count, then the lower `OPT` id in alphabetical order. Reference Implementation evidence does not change a score except through this tie-break.

Mark exactly one option `Recommended`. Go to `identifier`.

### identifier

Derive an id from a title.

1. Lowercase the title. Remove hyphens and apostrophes. Split the rest into words.
2. Take eight letters: the first two of word 1, the first two of word 2, the first two of word 3, and the last two of the last word. When the title has only two words, the third sample is the first two of the last word.
3. When a word is shorter than two letters, continue into the next word. A one-word title repeats until there are eight letters.
4. Map each letter. Digits stay as they are.

a 0, b 1, c 2, d 3, e 4, f 5, g 6, h 7, i 8, j 9, k a, l b, m c, n d, o e, p f, q 0, r 1, s 2, t 3, u 4, v 5, w 6, x 7, y 8, z 9.

5. Prefix `DISC` for the Discovery title. Prefix `OPT` for an option title.

Compare the Discovery id with `discoveries/discoveries.md`, including removed rows. Compare option ids with each other.

- The same Discovery title already has that id: use the existing record. Do not write a second one. Go to `start`.
- The Discovery id is taken for a different title, or two option titles share an id: go to `title`.
- The ids are free: go to `write`.

### title

Name each conflicting title. Say that a title change is appropriate. Then show the new title for acceptance.

The existing Discovery Title, **[Existing title]** and this new Discovery Title, **[this title]**, are too similar. A title change is appropriate. I would recommend:

**[New title]**

Use "Option Title" instead of "Discovery Title" when the collision is between options.

**What would you add, correct, or remove?**

If this is accurate, just say so.

The new title is a small change the person can recognize. Its derived id must be free. Do not mention identifiers, hex, sampling, or the catalog.

- `accept`: replace the held title. Return to `identifier`.
- `edit`: use the person's title. Return to `identifier`.
- `question`: answer in one sentence. Re-emit this message.
- `unknown`: re-emit this message.

Do not write until every id is free or the existing Discovery is reused.

### write

Write `discoveries/[ID].md` and `discoveries/discoveries.md` together. Write neither file until both are valid. A failed write leaves every existing Discovery byte unchanged. Say what failed in terms the person can act on. Stay on `write`.

The Discovery title is `Options for [request title]` unless the person supplied a title.

The record follows `.highway/library/templates/output/discovery-record.md`.

- `id` is the derived `DISC` id.
- `request` is the Request id.
- `status` is `accepted`.
- The title is the Discovery title.
- Copy the Request evidence and the eight Solution Constraints in their source order.
- Write every retained option, including its why, summary, request alignment, objective alignment, control alignment, NFR alignment, benefits, risks, assumptions, dependencies, and licensing costs.
- Include Research Findings, Assumptions, Risks, Unknowns, the Candidate Elimination Log, the Comparison Matrix, and one advisory Recommendation.
- The matrix totals equal the option scores. Exactly one option is `Recommended`.
- Do not write a selected option, a rejected option, a decision, or an authorization.

The catalog follows `.highway/library/templates/output/discovery-catalog.md`.

- Add one index row with the Discovery ID, Request ID, Discovery Title, and Status `accepted`.
- Order the index by Discovery id.
- Do not allocate from `Next ID`.
- The first catalog version is `1.0.0`.
- The first write increments the minor version.
- Adding, replacing, or removing an option updates that record and increments the patch version.
- Emit no timestamp, random value, or environment value.

On success, return to `start` and emit the option list. Emit nothing else before that list.

### start

When this analysis has not been written, write every retained option through `identifier` and `write` before emitting anything. The person is exploring the options. The write does not select an option.

Emit one numbered line per option, starting at 1, in displayed order. Show the option id and its title. Put `(Recommended)` after the recommended option title. The why is one sentence grounded in the Request, Objectives, Controls, and NFRs. A stated number selects that option.

**Here is a proposed starting point for your discovery:**

**1. [Option id]:** [Option title] (Recommended) — [Why this option fits.]

**2. [Option id]:** [Option title] — [Why this option fits.]

**Which option would you like to explore, or would you like to see a comparison matrix?**

If you are ready to decision on one of these options, just say so.

- `select`: go to `explore` for the named or numbered option.
- `decide`: continue as `highway-adr` with this Discovery id. When the reply also names an option or its number, pass that option id and continue at `start`. When it does not, continue at `choose-option`. Do not create the ADR in this skill.
- `matrix`: emit one row per option. The Option column shows the same number used in the list, then the option title, as `1. [Option title]`. That number is part of the Option column and does not count toward the column limit. Use at most 6 columns. Include Operational considerations and Licensing costs. Choose the remaining columns from the differences that matter for this Request. When a dollar estimate is available, show that figure. Otherwise use Low, Medium, High, a bounded range, or Unknown. The matrix does not change scores. Then ask **Which option would you like to explore?** Under that question, in normal text, emit: If you are ready to decision on one of these options, just say so. Do not offer the comparison matrix again. Stay on `start`.
- `edit`: when the person adds, replaces, or removes an option, update the Discovery file through `write`, then emit one consequence sentence and this block. Stay on `start`.
- `accept`: re-emit this block. Stay on `start`.
- `unknown`: re-emit this block. Stay on `start`.
- `question`: answer without opening an option. For two named options, compare them without changing scores. Re-emit this block after the answer. Stay on `start`.
- `decline`: stop. Write nothing.

### explore

Emit the named option in this order. Use accepted Request, Objective, Control, and NFR evidence. Label unavailable evidence `None`. Do not change scores.

**[Option title]**

**Summary:** [What the option is and how it addresses the request.]

**Request Alignment:** [How it fits the Request, or `None`.]

**Objective Alignment:** [How it fits accepted Objectives, or `None`.]

**Control Alignment:** [How it fits accepted Controls, or `None`.]

**NFR Alignment:** [How it fits accepted NFRs, or `None`.]

**Benefits:**
- [Expected value.]

**Risks:**
- [Material drawback.]

**Assumptions:**
- [Condition that must hold.]

**Dependencies:**
- [Required system, decision, or constraint, or `None`.]

**Licensing costs:** [A dollar figure when one is available. Otherwise Low, Medium, High, a bounded range, or Unknown.]

**Are there any additional concerns you would like to explore for this option, or would you like to return to the list of options?**

- `question`: answer the question about this option. When the answer includes a cost, use a dollar figure when one is available. Otherwise use Low, Medium, High, a bounded range, or Unknown. Do not change scores. Then re-emit this question. Stay on `explore`.
- A request to return to the list: go to `start`.
- `select`: go to `explore` for the newly named or numbered option.
- `decide`: continue as `highway-adr` with this Discovery id. When the reply also names an option or its number, pass that option id and continue at `start`. When it does not, continue at `choose-option`. Do not create the ADR in this skill.
- `accept`: return to `start`.
- `unknown`: re-emit this question. Stay on `explore`.
- `decline`: stop. Write nothing.

## Verification

- A Request id for a completed Request begins at `analyze`, then `start`.
- A Discovery id shows `start` from the stored options and does not write.
- An invocation with neither id lists the complete Requests that have no Discovery catalog row, then the accepted Discoveries. Each line shows the id and its title. The list is numbered across both groups. A stated number selects that row. A removed Discovery row keeps that Request off the list.
- `start` lists each option with a number, the option id, the title, and one why sentence.
- The recommended option title is followed by `(Recommended)`.
- A stated number selects that option.
- `start` asks which option to explore, or whether to see a comparison matrix, then says the person can decide.
- The comparison matrix has at most 6 columns and includes Operational considerations and Licensing costs. The Option column includes the same number as the list, and that number does not count as a column.
- After the comparison matrix, the question asks which option to explore, does not offer the matrix again, and says the person can decide.
- A reply that is ready to decide continues as `highway-adr` with this Discovery id. This skill does not create the ADR.
- The explored option shows Summary, Request Alignment, Objective Alignment, Control Alignment, NFR Alignment, Benefits, Risks, Assumptions, Dependencies, and Licensing costs.
- Fewer than two viable options writes nothing.
- A new analysis writes every retained option before the option list is shown.
- Adding, replacing, or removing an option updates the Discovery file.
- The record contains two to five `OPT` ids, one `Recommended` status, and matrix totals that equal the scores.
- Each Discovery id is `DISC` plus eight hex digits derived from the Discovery title.
- Each option id is `OPT` plus eight hex digits derived from the option title.
- A taken id names the conflicting titles, says a title change is appropriate, and shows a new title. The write waits until the person accepts that title.
- That message does not mention identifiers, hex, sampling, or the catalog.
- Mandatory constraint violations are excluded before scoring.
- Tie-break order is Reference Architecture match, Reference Implementation count, then lower `OPT` id.
- Clarification does not change options, scores, or the recommendation.
- A failed write leaves existing Discovery bytes unchanged.
- The skill creates no ADR and records no decision.

## Error Handling

- A missing, ambiguous, or incomplete Request stops the skill and writes nothing.
- A Discovery id that matches nothing stops the skill and writes nothing.
- Fewer than two viable options stops the skill and writes nothing.
- A malformed present Profile, Objective, Control, or NFR baseline stops the skill and writes nothing.
- A missing optional baseline leaves that relationship empty and continues.
- A missing or unreadable Reference Architecture yields no match and continues.
- A malformed or unreadable Reference Implementation counts as zero and continues.
- A failed write leaves existing Discovery and catalog bytes unchanged.

## Example

`/highway-discovery REQ3f2a9c10`