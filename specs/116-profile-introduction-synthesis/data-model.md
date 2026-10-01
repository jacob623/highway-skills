# Feature 116 Data Model

## Retained Profile

- **Owner**: `highway-profile`
- **Storage**: `.highway/library/knowledge/profile.md`
- **Template**: `.highway/library/templates/output/profile-record.md`
- **Schema**: 3.0.0, unchanged
- **Readiness keys**: exactly `identity`, `vision`, `competitive_path`, and `guiding_principles`
- **Allowed states**: `not_discussed`, `discussed`, `bounded`
- **Optional context**: Repository Name, Organization Name, Organization URL, and organizational context remain optional context and do not independently determine readiness.

## Evidence lifecycle

1. **Proposed**: website-derived names and facts are discovered but are not organizational truth.
2. **Accepted**: the person accepts supplied or discovered evidence; accepted evidence may contribute to multiple domains.
3. **Persisted**: Profile constructs and saves the retained mutation before returning dependent readiness or owner results.
4. **Ready**: the affected domain becomes `discussed` when accepted evidence establishes it, or `bounded` when the person explicitly bounds an otherwise unresolved domain.

## First-time introduction

- **Owner**: `highway-profile`
- **Trigger**: Profile setup begins with no retained Profile.
- **Content**: The required heading and sentence from FR-002.
- **Lifetime**: Transient interaction output; emitted once before the Repository Name question and never persisted.
- **Suppression**: Absent during configure or resume of an existing retained Profile, and not repeated later in the same first-time interaction.

## Cohesive paragraph recommendation

- **Owner**: `highway-profile`, with generic presentation and acceptance governed by the Highway Experience Standard.
- **Domain**: One of Vision, Competitive Path, or Guiding Principles.
- **Source evidence**: Accepted Profile evidence only, including accepted Identity, accepted website-derived information, existing accepted domain evidence, and accepted context relevant to the domain.
- **Shape**: One concise paragraph with a domain-specific lead-in and one review boundary; it may be accepted, changed, replaced, or declined according to the shared interaction contract.
- **Grounding categories**: Internal only. Vision uses Future State, Impact, Reach / Scale, Position, and Experience / Reputation. Competitive Path uses Customer / Participant, Offering, Market / Reach, Differentiation, Operations, and Capability Development. Guiding Principles uses People, Trust, Quality, Simplicity, Change, Stewardship, and Autonomy.
- **Persistence**: An accepted paragraph becomes the domain narrative and is persisted before dependent readiness or owner results. Category names are never persisted.
- **State effect**: Acceptance of a paragraph that establishes an unresolved domain sets it to `discussed`; acceptance for an already `discussed` or `bounded` domain enriches the narrative without changing readiness.
- **Fallback**: If no useful paragraph can be supported, Profile asks the applicable canonical question.

## Readiness

- `Missing`: the retained Profile is absent or any domain is `not_discussed`.
- `Blocked`: the retained Profile is malformed or uses an unsupported schema; no mutation occurs.
- `Complete`: all four domains are `discussed` or `bounded`.
- Readiness returned to an orchestrator is machine-oriented; normal guided conversation does not render its status, summary, next action, or blocking reason fields.

## Completion output

When guided setup or configure reaches `Complete`, Profile emits exactly one concise user-relevant synthesis before returning control to Setup. It remains distinct from the transient first-time introduction and contains no machine status fields or new question.
