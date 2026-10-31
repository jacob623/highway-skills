# Data Model: ADR Safeguard Span

## Span

One accepted decision applied beside the current decision of each architecture in its set.

| Field | Rule |
|---|---|
| Set | The matched architectures the person kept, at least two, in id order |
| Safeguard | The one Control id or NFR id every match shares |
| Decision title | The selected option title, unless the person supplied a title |

Validation:

- Every match reason is the same Control id, or every match reason is the same NFR id.
- No match is by identifier, exact title, or capability id.
- The selected option's Control or NFR alignment names the safeguard.
- The selected option title names none of the matched architectures.
- An architecture that did not match never joins the set.

State:

| From | Event | To |
|---|---|---|
| Proposed | The person removes architectures, and two or more remain | Proposed, with the smaller set |
| Proposed | The person removes architectures, and one remains | Single-architecture proposal with the replace-or-beside question |
| Proposed | `accept` | Recorded |
| Proposed | `decline` | Nothing written |
| Recorded | Discovery opened again | Recorded decision shown, then `close` |

## Span ADR Record

File: `adrs/[ADR id].md`, shaped by `.highway/library/templates/output/adr-record.md`.

| Field | Span value |
|---|---|
| `supersedes` | `None` |
| `superseded_by` | `None` |
| `status` | `accepted` |
| Decision Scope, Covers | Names every architecture in the set by title |
| Handoff, Architecture Direction | Runs beside the current decision of each named architecture |
| Handoff, Required Architecture Work | `None` |
| Handoff, Reference Architecture | Every RA id in the set, in id order, separated by a comma and a space |

## ADR Catalog Row

File: `adrs/adrs.md`, shaped by `.highway/library/templates/output/adr-catalog.md`.

| Column | Span value |
|---|---|
| Architecture ID | Every RA id in the set, in id order, separated by a comma and a space. Never `None` |

A cell with more than one RA id marks a recorded span.

## Architecture Record and Catalog

| Place | Change on span acceptance |
|---|---|
| `architectures/[RA id].md`, `## Current Decisions` | The span ADR id is added, in id order. Existing ids stay |
| `architectures/architectures.md`, ADR ID cell | The span ADR id is added, in id order, on the row of each architecture in the set |

No architecture is created. No conceptual body changes.

## Covered Implementation

| Term | Rule |
|---|---|
| Current implementation | An accepted row in `implementations/implementations.md` whose Architecture ID is in the set |
| Covered | An accepted row in `code/code.md` names that implementation, and that automation's `## Action` is the decision title |
| Uncovered | A current implementation that is not covered |
| Not yet implemented | An architecture in the set with no current implementation |

## Span Close

| Uncovered implementations | Close |
|---|---|
| None, and no current implementation exists in the set | One step: `/highway-implementation [first RA id]` |
| None, and every current implementation is covered | Says every implementation is covered. No codify step |
| One | One codify step for that implementation |
| Two to five | Lists each by title, then one codify step for the pick |
| More than five | Lists none and asks for a name, then one codify step for that name |

Every close also names each architecture in the set that is not yet implemented. A name outside the uncovered list is not offered, and the close asks again.

## Review Menu

| Item | Text |
|---|---|
| Question | **What would you like to review?** |
| 1 | Observed gaps against accepted architectures. |
| 2 | Accepted artifacts ready for progression to the next stage (requests, discoveries, decisions, architectures, and implementations). |

## Ready Record

| Category | Ready when | Stage label | Continues as |
|---|---|---|---|
| Requests | Accepted, and no discovery row names it | Ready for discovery | `highway-discovery` with the Request id |
| Discoveries | Accepted, and no decision row names it | Ready for a decision | `highway-adr` with the Discovery id |
| Decisions | Accepted, Architecture ID is `None`, and no architecture row lists it | Ready for an architecture | `highway-architecture` with the ADR id |
| Architectures | Accepted, and no accepted implementation names it | Ready for an implementation | `highway-implementation` with the RA id |
| Implementations | Accepted, and no accepted automation names it | Ready for codify | `highway-codify` with the implementation title |

- A removed row counts as a next stage for requests, discoveries, and decisions. It does not count for architectures or implementations.
- A removed or superseded row is never ready.
- Records keep catalog order within a category.
- Ready records are never written to the findings file.

## Product Claim Check

Runs in discovery analysis, after constraint exclusions and before the two-to-five cap and scoring. Uses the product or feature name and the vendor name only.

| Result | Rule |
|---|---|
| Contradicted | Vendor documentation says the named product or feature is deprecated, retired, or no longer offered. Conflicting vendor pages still contradict. The option is removed |
| Confirmed | Vendor documentation describes the named product or feature, and no vendor page says it is no longer offered. The option stays. Its score is unchanged |
| Inconclusive | No vendor documentation, only a secondary source, or the check cannot be completed. The option stays and is not treated as confirmed |

An option with no named product or feature is not checked.

### Research Finding

One entry per check, in `## Research Findings`. Not accepted repository evidence.

| Field | Rule |
|---|---|
| Claim | The named product or feature |
| Source | The vendor documentation, both pages when they conflict, or `None` |
| Result | `contradicted`, `confirmed`, or `inconclusive` |

### Elimination row

One row per removed or held option. `OPT` id derived from the title. Status `Excluded`. Not one of the two to five scored options.

| Category | Value | When |
|---|---|---|
| `product currency` | The source | The claim was contradicted |
| `required platform` | The platform name | The option depends on a required platform and accepted evidence does not say that platform supports it |

Accepted evidence is the request, its clarification, profile, objectives, controls, NFRs, and reference architectures. Vendor documentation does not count. When required platforms are unknown, no option is held.

### What the person sees

When two or more options remain: the current-implementation notice, if any, then one plain sentence per removed option naming the option and the source, then one plain sentence per held option naming the option and the platform, then the option list.

When fewer than two remain: discovery names what was removed or held and writes nothing.

An option the person adds or replaces is not checked. Opening a written discovery shows the recorded options and does not check again.

## Ready View

| Element | Rule |
|---|---|
| Category | `**[n]. [Category]**`, numbered from 1 in the order shown. Empty categories are omitted |
| Record | `**[letter]. [Record title]:** [Stage label].`, lettered from `a` |
| Cap | At most five records per category per view |
| Show more | Lists only categories with remaining records, numbered from 1, letters continuing |
| Selection | `[n][letter]` or a record title selects one record. A number alone, or a letter alone when more than one category is shown, asks again |
