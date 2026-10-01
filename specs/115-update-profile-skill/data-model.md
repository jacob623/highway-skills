# Feature 115 Data Model

## Retained Profile

- **Owner**: `highway-profile`
- **Storage**: `.highway/library/knowledge/profile.md`
- **Template**: `.highway/library/templates/output/profile-record.md`
- **Schema**: 3.0.0, unchanged
- **Readiness keys**: exactly `identity`, `vision`, `competitive_path`, and `guiding_principles`
- **Allowed states**: `not_discussed`, `discussed`, `bounded`
- **Optional context**: Repository Name, Organization Name, Organization URL, and organizational context remain optional context and do not independently determine readiness.

## Evidence Lifecycle

1. **Proposed**: website-derived names and facts are discovered but are not organizational truth.
2. **Accepted**: the user accepts supplied or discovered evidence; accepted evidence may contribute to multiple domains.
3. **Persisted**: Profile constructs and saves the retained mutation before returning dependent readiness or owner results.
4. **Ready**: the affected domain becomes `discussed` when accepted evidence establishes it, or `bounded` when the user explicitly bounds an otherwise unresolved domain.

## Readiness

- `Missing`: the retained Profile is absent or any domain is `not_discussed`.
- `Blocked`: the retained Profile is malformed or uses an unsupported schema; no mutation occurs.
- `Complete`: all four domains are `discussed` or `bounded`.
- Readiness returned to an orchestrator is machine-oriented; normal guided conversation does not render its status, summary, next action, or blocking reason fields.

## Recommendation Evaluation

After each accepted response, selected recommendation, or validated discovery, accepted evidence is re-evaluated across all four domains. Grounding categories are internal only:

- Vision: Future State, Impact, Reach / Scale, Position, Experience / Reputation
- Competitive Path: Customer / Participant, Offering, Market / Reach, Differentiation, Operations, Capability Development
- Guiding Principles: People, Trust, Quality, Simplicity, Change, Stewardship, Autonomy

These category names are never persisted. A useful grounded recommendation replaces the applicable canonical question; a canonical question is the fallback when grounding is insufficient.

## Completion Output

When guided setup or configure reaches `Complete`, Profile emits exactly one concise user-relevant synthesis before returning control to Setup. It uses an accepted organization name when available, summarizes accepted direction, explains that the understanding improves later guidance, and contains no machine status fields or new question.
