# Data Model: Organize Profile Context

## Profile skill

The agent behavior for collecting and retaining organizational Profile evidence.

| Field | After this amendment |
|---|---|
| Identifier | highway-profile |
| Version | 4.0.0, unchanged |
| Behavior sections | Profile model, Acquisition, Enrichment, Operations |
| Removed section | Evidence |
| Experience section | `User-visible interaction follows the Highway Experience Standard.` |
| Ordering | The eight acquisition steps in [contracts/profile-skill.md](./contracts/profile-skill.md) |
| Failure exceptions | Unsupported schema, obsolete YAML Profile, malformed record |

## Profile record

The retained Markdown artifact described by `.highway/library/templates/output/profile-record.md`.

| Field | After this amendment |
|---|---|
| Schema | 3.0.0, unchanged |
| Template metadata version | 3.0.0, unchanged |
| Title | `# Organizational Profile` |
| Domain keys | `identity`, `vision`, `competitive_path`, `guiding_principles` |
| Domain outcomes | `not_discussed`, `discussed`, `bounded` |
| Narrative headings | Who We Are, Where We're Going, How We Plan to Get There, What Guides Our Decisions |
| Optional group | `## Context` after those narratives, only when at least one child is accepted |
| Context children | `### Repository Name`, `### Organization Name`, `### Organization URL`, `### Organizational Context` |

A `not_discussed` domain has no narrative. A `discussed` domain has an accepted narrative. A `bounded` domain may have an accepted narrative and has none when no accepted evidence exists.

## Context

Accepted organizational facts that do not affect readiness. Each child is omitted when that fact has not been accepted. The Context heading is omitted when every child is omitted.

| Child | Acceptance |
|---|---|
| Repository Name | Accepted when the person answers the opening question |
| Organization Name | Accepted when the person supplies or accepts it. A website-derived name stays proposed until then |
| Organization URL | Accepted when the person supplies it |
| Organizational Context | Additional accepted organizational context |

## Readiness result

Unchanged. Status, Summary, Next Action, and Blocking Reason are decided by the retained record and the four domains. Context does not change the result.

| Condition | Status | Next Action |
|---|---|---|
| No retained Profile | Missing | `/highway-profile setup` |
| Schema other than 3.0.0, including 2.0.0 | Blocked | None |
| Malformed structure | Blocked | None |
| Any readiness domain `not_discussed` | Missing | `/highway-profile configure` |
| All four domains `discussed` or `bounded` | Complete | None |

## Enrichment categories

Internal labels. They are not record fields and do not block Complete.

| Domain | Categories |
|---|---|
| Vision | Future State, Impact, Reach / Scale, Position, Experience / Reputation |
| Competitive Path | Customer / Participant, Offering, Market / Reach, Differentiation, Operations, Capability Development |
| Guiding Principles | People, Trust, Quality, Simplicity, Change, Stewardship, Autonomy |

## Domain outcome transitions

Unchanged. A domain moves from `not_discussed` to `discussed` or `bounded` when accepted evidence exists. Schema 2.0.0 has no transition into 3.0.0.
