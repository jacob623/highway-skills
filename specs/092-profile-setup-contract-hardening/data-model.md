# Feature 092 Data Model

## Retained Markdown Profile

- **Path**: `.highway/library/knowledge/profile.md`
- **Owner**: `highway-profile`
- **Role**: Accepted, user-owned organizational Repository Context.
- **Frontmatter**: Required delimiters and supported `schema_version: 2.0.0`.
- **Domains**: Exactly five ordered keys: `identity`, `vision`, `competitive_path`, `guiding_principles`, `highway_role`.
- **Outcomes**: Each domain is exactly `not_discussed`, `discussed`, or `bounded`.
- **Narrative invariant**: `not_discussed` has no narrative; `discussed` has narrative; `bounded` has narrative only when accepted evidence exists.
- **Lifecycle**: Absent -> Missing; present invalid -> Blocked; present valid with any `not_discussed` -> Missing; otherwise -> Complete.
- **Mutation invariant**: Proposals are transient until acceptance. Declined, ambiguous, malformed, interrupted, failed, and byte-identical no-op mutations do not write.

## Profile Output Template

- **Path**: `.highway/library/templates/output/profile-record.md`
- **Owner**: Highway library/template layer.
- **Role**: Complete reusable structural authority for generated Profile records.
- **Boundary**: Template metadata describes the template file and is not generated Profile content.
- **Removed siblings**: `.highway/library/templates/output/profile.md` and `.highway/library/templates/output/profile.yaml` must be absent and cannot be fallback inputs.

## Profile Readiness Result

- **Fields and order**: `Status`, `Summary`, `Next Action`, `Blocking Reason`.
- **Profile action vocabulary**:
  - absent + Missing -> `/highway-profile setup`
  - valid incomplete + Missing -> `/highway-profile configure`
  - Complete -> `None`
  - Blocked -> `None`
- **Owner**: Profile computes the result; Setup validates response shape only.

## Owner Readiness Result

- **Relationship**: Setup consumes one result from each owner: Profile, Objectives, Controls, NFRs.
- **Terminal results**: Profile/Objectives/Controls `Complete`; NFR `Complete` or `Not Applicable`.
- **Non-terminal results**: Missing with a supported action; NFR `In Progress` with a supported action.
- **Malformed result**: Missing, duplicated, reordered, or unrecognized required field; unsupported status; invalid status/action combination; or inconsistent blocking reason.

## Repository Context Documents

- **Foundational inputs**: `highway-identity.md`, `highway-vision.md`, `highway-platform-objectives.md`.
- **Semantic roles**: Identity supplies behavioral guidance; Vision supplies strategic direction; Platform Objectives supply evaluation criteria.
- **Non-promotion rule**: These documents can influence evidence significance and follow-up decisions, but cannot supply unsupported organizational facts to retained Profile narrative.
- **Precedence**: Workflow-specific user input remains authoritative; document roles describe overlap semantics rather than a universal override order.

## Setup Owner Loop

- **Owners and order**: Profile -> Objectives -> Controls -> NFRs.
- **Active orchestration**: Validate response, advance terminal results, delegate supported non-terminal actions, consume action result, re-read readiness, then advance only from new terminal readiness.
- **Status-only**: Report owner result without delegation or collection.
- **Stopping results**: Blocked, malformed, unknown, declined, aborted, and failed.

## Generated/Distributed Dependent Inventory

Each changed source records zero or more dependents identified by existing correspondence mechanisms. Each record contains source, dependent, regeneration action or `None`, and correspondence-test result.
