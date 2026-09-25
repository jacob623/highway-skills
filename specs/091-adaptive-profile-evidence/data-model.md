# Feature 091 Data Model

## Profile Proposal

- **Purpose**: Transient collection result awaiting user acceptance.
- **Fields**: proposal evidence by domain, explicit boundaries, derived domain outcomes, rendered Markdown bytes.
- **Rules**: never authoritative; may combine accepted Profile content with new Configure evidence; must be shown before confirmation.

## Accepted Profile

- **Purpose**: Authoritative user-owned organizational context.
- **Location**: `.highway/library/knowledge/profile.md`.
- **Fields**: `schema_version`, exactly five domain outcomes, optional narrative sections, fixed title.
- **Rules**: only accepted evidence is retained; frontmatter and section order are deterministic; no unsupported claims.

## Evidence Domain

Five stable keys: `identity`, `vision`, `competitive_path`, `guiding_principles`, and `highway_role`.
Each persists exactly one outcome: `not_discussed`, `discussed`, or `bounded`.

## Domain Outcome

- `not_discussed`: no retained narrative and readiness is Missing.
- `discussed`: accepted evidence exists and no unresolved FR-005 information need remains; narrative is required.
- `bounded`: the user explicitly establishes an unavailable, unknown, not-established, or intentionally withheld boundary; narrative is optional when evidence also exists.

## Readiness

Derived only from the authoritative artifact: absent or any `not_discussed` is `Missing`, malformed structural state is `Blocked`, and five valid `discussed`/`bounded` outcomes are `Complete`.

## Mutation

A confirmed Add, Update, Remove, or Reset transforms accepted evidence and domain outcomes. Every mutation validates, previews, confirms, writes, verifies persisted bytes, and reports the resulting readiness. Declined, ambiguous, malformed, failed, and no-op mutations preserve bytes.

## Relationships and invariants

- Proposal evidence may support multiple domains and must not be requested again during that proposal.
- Accepted Profile content is available only to explicitly participating skills.
- `not_discussed` never has a narrative section; `discussed` always has one; `bounded` may have one only when accepted evidence exists.
- Setup resumes from persisted domain outcomes, never from an unanswered question or transient draft.
