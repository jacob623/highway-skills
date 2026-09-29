# Data Model: Simplify the Profile Skill

## Profile skill

The agent behavior for collecting and retaining organizational Profile evidence.

| Field | After this amendment |
|---|---|
| Identifier | highway-profile |
| Version | 4.0.0 |
| Change class | Major |
| Readiness domains | Identity, Vision, Competitive Path, Guiding Principles |
| Removed domain | Highway Role |
| Experience section | Profile follows the Highway Experience Standard. That standard remains the normative authority. |
| Ordering | Classify the retained record, acquire context, accept evidence, persist, report readiness |
| Failure exceptions | Unsupported schema, obsolete YAML Profile, malformed record |

## Profile record

The retained Markdown artifact described by `.highway/library/templates/output/profile-record.md`.

| Field | After this amendment |
|---|---|
| Schema | 3.0.0 |
| Template metadata version | 3.0.0 |
| Title | `# Organizational Profile` |
| Domain keys | `identity`, `vision`, `competitive_path`, `guiding_principles` |
| Domain outcomes | `not_discussed`, `discussed`, `bounded` |
| Narrative headings | Who We Are, Where We're Going, How We Plan to Get There, What Guides Our Decisions |
| Removed | `highway_role`, How Highway Helps |
| Unsupported predecessor | Schema 2.0.0 is Blocked and is not rewritten |

A `not_discussed` domain has no narrative section. A `discussed` domain has one. A `bounded` domain has one only when accepted evidence exists.

## Optional context

Accepted organizational facts that do not affect readiness. Each heading is omitted when that fact has not been accepted.

| Heading | Acceptance |
|---|---|
| `## Repository Name` | Accepted when the person answers the opening question |
| `## Organization Name` | Accepted when the person supplies or accepts it. A website-derived name stays proposed until then |
| `## Organization URL` | Accepted when the person supplies it |
| `## Organizational Context` | Additional accepted organizational context |

## Readiness result

| Field | Values |
|---|---|
| Status | Complete, Missing, or Blocked |
| Summary | A short explanation of that status |
| Next Action | `/highway-profile setup`, `/highway-profile configure`, or None |
| Blocking Reason | A reason, or None |

| Condition | Status | Next Action |
|---|---|---|
| No retained Profile | Missing | `/highway-profile setup` |
| Schema other than 3.0.0, including 2.0.0 | Blocked | None |
| Malformed structure | Blocked | None |
| Any readiness domain `not_discussed` | Missing | `/highway-profile configure` |
| All four domains `discussed` or `bounded` | Complete | None |

Optional context and optional enrichment do not change this table.

## Enrichment categories

Internal labels used to find grounded recommendations. They are not record fields.

| Domain | Categories |
|---|---|
| Vision | Future State, Impact, Reach / Scale, Position, Experience / Reputation |
| Competitive Path | Customer / Participant, Offering, Market / Reach, Differentiation, Operations, Capability Development |
| Guiding Principles | People, Trust, Quality, Simplicity, Change, Stewardship, Autonomy |

## Domain outcome transitions

| From | To | Cause |
|---|---|---|
| `not_discussed` | `discussed` or `bounded` | Accepted evidence for that domain |
| `discussed` | `bounded` | The person bounds the domain |
| `discussed` or `bounded` | `not_discussed` | A remove or reset clears that domain |
| Any state in schema 2.0.0 | No transition | The file is Blocked and is not rewritten |
