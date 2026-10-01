# Feature 118 Data Model

## Profile

The retained organizational artifact at `.highway/library/knowledge/profile.md`.

**Owned by**: `highway-profile`.

**Structure**: Shared by `.highway/library/templates/output/profile-record.md`; no template edit is in scope.

**Schema**: `3.0.0`.

**Readiness**: Determined only by the four readiness domains. Optional Context and optional enrichment do not alter readiness.

## Readiness Domain

A domain is one of:

| Key | Meaning | Narrative heading |
|---|---|---|
| `identity` | What the organization does | `## Who We Are` |
| `vision` | The desired future direction | `## Where We're Going` |
| `competitive_path` | How the organization plans to get there | `## How We Plan to Get There` |
| `guiding_principles` | What guides organizational decisions | `## What Guides Our Decisions` |

Each domain has exactly one state:

| State | Meaning | Narrative rule |
|---|---|---|
| `not_discussed` | No accepted evidence or boundary establishes the domain | No narrative |
| `discussed` | Accepted evidence establishes the domain | Accepted narrative required |
| `bounded` | The person explicitly bounds an otherwise unresolved domain | Accepted narrative permitted, not required |

A valid Profile is `Complete` only when every domain is `discussed` or `bounded`. Any `not_discussed` domain makes a valid Profile `Missing`; absent, malformed, contradictory, or unsupported Profiles are handled by the existing Profile readiness contract.

## Optional Context

Optional accepted context remains structurally owned by `profile-record.md` and is not a readiness domain.

Possible accepted values include:

- Repository Name
- Organization Name
- Organization URL
- Organizational Context

The supplied Organization URL is accepted context. Website-derived Organization Name and other derived facts remain proposed until accepted. Absent optional values are omitted rather than represented by placeholders.

## Accepted Evidence

User-provided or user-accepted organizational information that may be persisted and reused across all four domains.

**Lifecycle**:

1. Evidence is supplied, discovered, or proposed.
2. Discovered or interpreted evidence remains transient until the applicable acceptance boundary.
3. Accepted evidence is persisted before dependent readiness or owner results.
4. Accepted evidence expands the grounding available to the next domain decision.

Foundational Highway context can influence interpretation and recommendation quality but is never promoted into organizational evidence.

## Proposed Discovery

Website-derived or otherwise discovered information awaiting acceptance. It is transient, does not establish readiness, and cannot be presented as user-owned content.

## Cohesive Paragraph Recommendation

A single grounded recommendation for Vision, Competitive Path, or Guiding Principles. It combines accepted evidence without exposing internal enrichment categories.

**Forms**:

- Vision: `Based on what I know about [Organization Name], I could see your vision as [grounded Vision paragraph].`
- Competitive Path: `Based on that direction, [Organization Name] could pursue it by [grounded Competitive Path paragraph].`
- Guiding Principles: `From what you've shared, [Organization Name] seems guided by [grounded Guiding Principles paragraph].`

The paragraph remains a proposal until accepted. Acceptance establishes the corresponding domain as `discussed`; optional enrichment accepted for an already `discussed` or `bounded` domain does not change readiness.

## Enrichment Categories

Internal reasoning categories only. They are not fields, enum values, headings, or retained metadata.

- Vision: Future State, Impact, Reach / Scale, Position, Experience / Reputation
- Competitive Path: Customer / Participant, Offering, Market / Reach, Differentiation, Operations, Capability Development
- Guiding Principles: People, Trust, Quality, Simplicity, Change, Stewardship, Autonomy

Coverage of every category is not required. Unsupported details remain unknown rather than being invented.

## Readiness Result

The internal Profile owner result remains:

- `Status:`
- `Summary:`
- `Next Action:`
- `Blocking Reason:`

Setup may consume this result, and direct readiness may show it. Normal orchestrated conversation suppresses machine-only fields.

## Completion Synthesis

One concise user-relevant summary emitted after the final accepted guided Profile mutation and before Setup resumes when accepted context can be meaningfully summarized. It may use the accepted Organization Name and must state that Highway will use the understanding to improve later guidance. It contains no machine result fields and no new question.
