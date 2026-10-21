---
name: highway-assessment
description: "Assess accepted repository context."
usage: "Invoke as /highway-assessment."
compatibility: all
metadata:
  version: 2.0.0
---

# highway-assessment

## Purpose

Surfaces one grounded observation at a time from accepted repository knowledge and writes that finding before the person sees it.

## When to use

- The person invokes `/highway-assessment`.
- The person invokes `/highway-assessment architectures`, `/highway-assessment implementations`, or `/highway-assessment portfolio`.

## When not to use

Do not create or change Profile, Objectives, Controls, NFRs, Requests, Discoveries, ADRs, architectures, or implementations.
Do not create an inventory.
Do not treat a finding as organizational fact before the person accepts it.
Do not invent a finding when accepted evidence does not support one.
Do not report Status, Summary, Next Action, Blocking Reason, Missing, Complete, or Blocked.

## Inputs

- Accepted Profile, Objectives, Controls, NFRs, Requests, Discoveries, ADRs, architectures, and implementations when present.
- Catalogs, read before source records: `adrs/adrs.md`, `architectures/architectures.md`, `implementations/implementations.md`, and `implementations/capabilities.md`.
- `.highway/library/knowledge/assessment-findings.md` when present.
- `.highway/library/templates/output/assessment-findings.md`.
- The domain named in the invocation. The default domain is `portfolio`.
- `.highway/governance/experience-standard.md`.
- A project root containing `.highway/`.

## Outputs

The complete structure is `.highway/library/templates/output/assessment-findings.md`.

- A row in `.highway/library/knowledge/assessment-findings.md` before the finding is shown.
- An updated row when the person accepts, dismisses, or corrects that finding.
- One proposed finding at a time, then a summary when no further grounded finding remains.
- No owner artifact and no new identifier family.

## Procedure

Emit only the active template. Follow this order: `open`, then `write` the finding, then show it in `finding`, then `summary` when no further finding remains. Read catalogs before opening source records. Open a source record only when the catalog row does not answer the question. A conflict between a catalog and a record is reported as uncertainty. Do not repair either file.

The domain is `portfolio` unless the invocation says `architectures` or `implementations`.

`portfolio` correlates the accepted catalogs. `architectures` compares architecture records with the capability catalog. `implementations` uses the capability catalog for provider, reuse, and dependency observations.

Read `implementations/capabilities.md` before an implementation or architecture record. A row's Title is the business capability. Parent is the implementation id. Realized By is who provides it. Trace Parent through `implementations/implementations.md` to the Architecture ID, then through `architectures/architectures.md` to the ADR ID, then through `adrs/adrs.md` to the Discovery ID and Request ID. Use that chain for coverage, consistency, reuse, and dependency findings. Do not open those records when the catalogs already support the observation. Do not change the capability catalog.

A finding has one category and one domain. The categories are Coverage, Consistency, Dependency, Opportunity, Reuse, and Risk.

### Entry

1. Read `.highway/library/knowledge/assessment-findings.md` when it exists.
2. When its revision cannot be read, stop. Say the findings file could not be read. Write nothing.
3. Go to `open`.

### Classify

Classify the latest reply before any other action.

- `edit`: adds, removes, corrects, or replaces the proposed finding.
- `accept`: asks to save the finding for later.
- `dismiss`: asks to discard the finding.
- `explore`: asks to explore a solution now.
- `unknown`: the person says they do not know.
- `question`: asks for an explanation or a recommendation about the current finding.
- `decline`: the person stops the assessment.

"Save it for later" and "save this for later" are `accept`. "Discard this finding" and "discard it entirely" are `dismiss`. "Explore a solution now" is `explore`.

### open

When the file has findings whose Status is `Open`, list them:

* **[ID]:** [One sentence.] *(Status: Open)*

Then go to `finding`.

When no open finding exists, go to `finding`. Do not announce an empty file.

### write

Write `.highway/library/knowledge/assessment-findings.md` with the columns ID, Category, Domain, Finding, Status, and Disposition. Do not write a fingerprint.

Derive the id from the observation.

1. Lowercase the observation. Remove hyphens and apostrophes. Split the rest into words.
2. Take eight letters: the first two of word 1, the first two of word 2, the first two of word 3, and the last two of the last word. When the observation has only two words, the third sample is the first two of the last word.
3. When a word is shorter than two letters, continue into the next word. A one-word observation repeats until there are eight letters.
4. Map each letter. Digits stay as they are.

a 0, b 1, c 2, d 3, e 4, f 5, g 6, h 7, i 8, j 9, k a, l b, m c, n d, o e, p f, q 0, r 1, s 2, t 3, u 4, v 5, w 6, x 7, y 8, z 9.

5. The id is `F` plus those eight hex digits.

When that id already belongs to the same observation, reuse the row. When it belongs to a different observation, do not write the new finding yet. Name both observations, say a wording change is appropriate, and show a small change. Write only after that wording is free. Do not mention identifiers, hex, sampling, or the file.

- A finding is written with Status `Open` before it is shown.
- `accept` sets that row to `Accepted`.
- `dismiss` sets that row to `Dismissed`.
- Disposition is `None` unless the person stated one.
- Increment `revision` by one.
- When the file changed since it was read, write nothing. Say the findings file changed and must be reloaded.
- A failed write leaves the file unchanged and the finding is not shown.

### finding

Propose one observation the accepted evidence supports and the findings file does not already contain. Derive its id from the observation. When that id already belongs to the same observation, do not propose it again. When no further grounded observation remains, go to `summary`.

Write the finding through `write` with Status `Open` before emitting it. Emit nothing for this finding until that write succeeds.

**Based on what Highway knows, this may be something worth visiting:**

[Observation]

- **Possible solutions:**
  - **[Solution]:** [What it does.]
- **Overall complexity:** [Low, Medium, or High.]
- **Cost range:** [A dollar range for the finding when one is available. Otherwise Unknown.]

Offer at least two possible solutions. They are a rough idea, not a selection. Do not invent a dollar figure. Use Unknown when no dollar range is available.

**Would you like to explore a solution now?**

If you want to save this for later, or discard it entirely, just say so.

- `edit`: emit one consequence sentence. Update the written row through `write`. Then re-emit this finding. Stay on `finding`.
- `accept`: update the written row to Status `Accepted` through `write`. Then list the retained findings and go to `finding` for the next observation.
- `dismiss`: update the written row to Status `Dismissed` through `write`. Then list the retained findings and go to `finding` for the next observation.
- `explore`: update the written row to Status `Accepted` through `write`. Emit exactly: `We'll turn this finding into a request so you can shape it and explore options. You can run /highway-assessment later for more recommendations.` Then continue as `highway-request` at `start` in the same message. Seed that start with the observation, the accepted evidence, and the uncertainty. Do not seed the possible solutions, the complexity, or the cost range. Do not ask the person to name a solution. Do not create the request in this skill.

- `question`: answer from accepted evidence. Then re-emit this finding and this question. Stay on `finding`.
- `unknown`: record that uncertainty on the written row through `write`. Then re-emit this finding. Stay on `finding`.
- `decline`: go to `summary`.

After `accept` or `dismiss`, list the retained findings for this session:

* **[ID]:** [One sentence.] *(Status: Accepted or Dismissed)*

### summary

**Assessment complete**

* **[ID]:** [One sentence.] *(Status: [Status])*

[One short paragraph on what the accepted records show together.]

**Where would you like to go next?**

Run `/highway-help` to explore what Highway can help you do.

## Verification

- The default domain is `portfolio`.
- Catalogs are read before source records.
- Findings about providers, reuse, coverage, and dependencies use `implementations/capabilities.md` and its Parent chain.
- Open findings are shown before a new finding.
- A new finding is written with Status `Open` before it is shown.
- One proposed finding is shown at a time.
- A proposed finding opens with **Based on what Highway knows, this may be something worth visiting:**, then the observation, then several possible solutions, an overall complexity, and a dollar cost range when one is available.
- The finding asks **Would you like to explore a solution now?** and says the person can save it for later or discard it entirely.
- A question about that finding is answered, then the same finding is shown again.
- Save for later updates the written row to Status `Accepted`.
- Discard updates the written row to Status `Dismissed`.
- Explore a solution now updates the written row to Status `Accepted`, tells the person the finding is becoming a request, says they can run `/highway-assessment` later, and then continues as `highway-request` at `start`. Possible solutions, complexity, and cost are not seeded.
- The id is `F` plus eight hex digits derived from the observation.
- The same observation reuses that id. A collision with a different observation waits for a wording change.
- The findings file has no fingerprint column.
- A stale revision writes nothing.
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
