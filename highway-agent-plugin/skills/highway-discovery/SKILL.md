---
name: highway-discovery
description: "Manages one discovery for a complete request. Use when a request is complete and the person wants to explore options for it, or wants to resume an existing discovery."
license: Apache-2.0
metadata:
  version: 5.8.0
  usage: "Run highway-discovery with one request id or one discovery id."
---

# highway-discovery

## Purpose

Creates one Discovery for a completed Request, checks each named product claim before writing, writes every option before the list is shown, and updates that file when the person adds, replaces, or removes an option.

## When to use

- The person invokes `highway-discovery` with one Request id.
- The person invokes `highway-discovery` with one Discovery id.
- The person invokes `highway-discovery` without a Request id or a Discovery id.

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
- The vendor's current public documentation for each product or feature a generated option names.
- `requests/requests.md` and `discoveries/discoveries.md`.
- `assets/discovery-record.md`.
- The highway-experience skill, activated first.

## Outputs

The complete structure is `assets/discovery-record.md`. `discoveries/discoveries.md` keeps the structure highway-setup seeded.

- One Discovery record at `discoveries/[ID].md`, written before the option list is shown.
- An updated `discoveries/discoveries.md` written with that record.
- An updated record when the person adds, replaces, or removes an option.
- No Discovery artifact when fewer than two options remain or a write fails.

## Procedure

Activate the highway-experience skill before any output the person sees, and follow it for Highway's identity, the Experience Standard, and the storage contract.

Before the first question, confirm these seeded files exist: `discoveries/discoveries.md`.
When any is absent, emit the message below exactly, stop, and write nothing.

**Oops... we need to setup your repository.**

Highway needs to gather your organizational preferences and set up your repository. Run highway-setup to get started.

User-visible interaction follows the Highway Experience Standard. Repository ownership stays with the person.

Emit only the active template. Follow this order: `choose` when neither id is supplied; `analyze` and `check` for a Request; `identifier`, `title` when needed, and `write` before `start`; then `explore`. A supplied Discovery id goes to `start` and does not write. The recommendation is advisory. ADR owns the decision. Do not mutate the Request, Clarification, Profile, Objectives, Controls, NFRs, Architectures, or Implementations.

Redact secrets and regulated personal data before scoring or writing. Replace each with a stable category marker.

Before a step in this table, read its file and follow it to the end.

| File | Steps |
| --- | --- |
| `references/options.md` | `analyze`, `check`, `identifier`, `title`, `write`, `start`, `explore` |

### Entry

1. Read the invocation for one Request id or one Discovery id. When it has neither, and contains the exact title of one Discovery that is ready to explore, as `choose` defines it, that Discovery's id is present. Otherwise, when it contains the exact title of one Request that is ready to analyze, that Request's id is present. Compare without regard to case.
2. When both are present, go to `choose`.
3. When one Request id is present, resolve it. When it matches no request, stop. Say the Request was not found. Write nothing. When its `## Completeness` is not `Complete`, stop. Say the Request is incomplete. Write nothing. Otherwise go to `analyze`.
4. When one Discovery id is present, resolve it. When it matches no Discovery, stop. Say the Discovery was not found. Write nothing. Otherwise load its options and go to `start`. Do not write. Do not run the check.
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
- `adopt`: selects the option being explored for the Decision record.
- `matrix`: asks to see the comparison matrix.
- `edit`: adds, removes, corrects, splits, combines, or replaces an option or the Discovery title.
- `accept`: affirms the current block and adds no fact.
- `unknown`: the person says they do not know.
- `question`: asks for an explanation, a comparison, examples, or costs.
- `decline`: the person stops or cancels.

On `start`, "looks good" stays on `start`. It does not select an option.

## Verification

- A Request id for a completed Request begins at `analyze`, then `start`.
- A Discovery id shows `start` from the stored options and does not write.
- An invocation with neither id lists the complete Requests that have no Discovery catalog row, then the accepted Discoveries. Each line shows the id and its title. The list is numbered across both groups. A stated number selects that row. A removed Discovery row keeps that Request off the list.
- Opening a Discovery id, or adding an option, does not run the check.
- A new analysis writes every retained option before the option list is shown.
- Adding, replacing, or removing an option updates the Discovery file.
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