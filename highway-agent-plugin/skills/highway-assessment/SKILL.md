---
name: highway-assessment
description: "Assesses accepted repository context. Use when the person wants to see how the accepted architectures, implementations, or whole portfolio stand."
license: Apache-2.0
metadata:
  version: 5.5.0
  usage: "Run highway-assessment."
---

# highway-assessment

## Purpose

Surfaces up to five grounded observations at a time from accepted repository knowledge, writes each new finding before the person sees it, shows the finding the person chooses, and lists accepted records that are ready for the next stage.

## When to use

- The person invokes `highway-assessment`.
- The person invokes `highway-assessment architectures`, `highway-assessment implementations`, or `highway-assessment portfolio`.

## When not to use

Do not create or change Profile, Objectives, Controls, NFRs, Requests, Discoveries, ADRs, architectures, or implementations.
Do not create an inventory.
Do not treat a finding as organizational fact before the person accepts it.
Do not invent a finding when accepted evidence does not support one.
Do not report Status, Summary, Next Action, Blocking Reason, Missing, Complete, or Blocked.

## Inputs

- Accepted Profile, Objectives, Controls, NFRs, Requests, Discoveries, ADRs, architectures, and implementations when present.
- Catalogs, read before source records: `adrs/adrs.md`, `architectures/architectures.md`, `implementations/implementations.md`, and `implementations/capabilities.md`.
- `requests/requests.md`, `discoveries/discoveries.md`, and `code/code.md`, for ready records.
- `library/knowledge/assessment-findings.md`.
- The domain named in the invocation. The default domain is `portfolio`.
- The highway-experience skill, activated first.

## Outputs

`library/knowledge/assessment-findings.md` keeps the structure highway-setup seeded.

- A row in `library/knowledge/assessment-findings.md` before the finding is shown.
- An updated row when the person accepts, dismisses, or corrects that finding.
- A list of up to five findings, the chosen finding, then a summary when no further grounded finding remains.
- A list of accepted records ready for the next stage, which writes nothing.
- No owner artifact and no new identifier family.

## Procedure

Activate the highway-experience skill before any output the person sees, and follow it for Highway's identity, the Experience Standard, and the storage contract.

Before the first question, confirm these seeded files exist: `library/knowledge/assessment-findings.md`.
When any is absent, emit the message below exactly, stop, and write nothing.

**Oops... we need to setup your repository.**

Highway needs to gather your organizational preferences and set up your repository. Run highway-setup to get started.

Emit only the active template. Start at `review`. For ready records, go to `ready records`. For gaps, follow this order: `write` each new finding, then show the findings in `list of findings`, then show the chosen finding in `finding`, then return to `list of findings`. Go to `summary` when no further finding remains. Read catalogs before opening source records. Open a source record only when the catalog row does not answer the question. A conflict between a catalog and a record is reported as uncertainty. Do not repair either file.

The domain is `portfolio` unless the invocation says `architectures` or `implementations`.

`portfolio` correlates the accepted catalogs. `architectures` compares architecture records with the capability catalog. `implementations` uses the capability catalog for provider, reuse, and dependency observations.

Before a step in this table, read its file and follow it to the end.

| File | Steps |
| --- | --- |
| `references/findings.md` | `write`, `list of findings`, `finding` |
| `references/ready-records.md` | `ready records` |

### Entry

1. Read `library/knowledge/assessment-findings.md`.
2. When its revision cannot be read, stop. Say the findings file could not be read. Write nothing.
3. Go to `review`.

### Classify

Classify the latest reply before any other action.

- `select`: chooses a listed finding, by number or by its summary.
- `more`: asks to see additional findings.
- `back`: asks to go back to the list of findings.
- `edit`: adds, removes, corrects, or replaces the proposed finding.
- `accept`: asks to save the finding for later.
- `dismiss`: asks to dismiss or discard one or more findings.
- `explore`: asks to explore a solution now.
- `unknown`: the person says they do not know.
- `question`: asks for an explanation or a recommendation about the current finding.
- `decline`: the person stops the assessment.
- `gaps`: chooses observed gaps, by number or in words.
- `ready`: chooses accepted artifacts ready for the next stage, by number or in words.
- `advance`: chooses a listed ready record, by category number and letter or by its title.
- `menu`: asks to return to the main menu.

"Save it for later" and "save this for later" are `accept`. "Discard this finding" and "discard it entirely" are `dismiss`. "Explore a solution now" is `explore`.

### review

Write nothing on this step.

**What would you like to review?**

1. Observed gaps against accepted architectures.
2. Accepted artifacts ready for progression to the next stage (requests, discoveries, decisions, architectures, and implementations).

- `gaps`: go to `list of findings`. The domain in the invocation applies.
- `ready`: go to `ready records`.
- `question`: answer. Then re-emit this menu. Stay on `review`.
- `unknown`: re-emit this menu. Stay on `review`.
- `decline`: go to `summary`.

### summary

**Assessment complete**

* **[ID]:** [One sentence.] *(Status: [Status])*

[One short paragraph on what the accepted records show together.]

**Where would you like to go next?**

Run `highway-help` to explore what Highway can help you do.

## Verification

- Assessment opens on **What would you like to review?** with observed gaps first and ready artifacts second. Nothing is written before a choice.
- Observed gaps go to the list of findings, which is unchanged.
- The default domain is `portfolio`.
- Catalogs are read before source records.
- The skill creates no owner artifact.
- This skill does not write a request record.

## Error Handling

- An unreadable findings file stops the skill and writes nothing.
- A failed write leaves the findings file unchanged and does not show the finding.
- A stale revision writes nothing.
- An unsupported category or status writes nothing.
- Missing evidence stays unknown and does not become a finding.

## Example

`/highway-assessment portfolio`
