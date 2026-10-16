# Data Model: Highway Onboarding

## Onboarding Session

Transient state for one `/highway-onboarding` run.

| Field | Type | Rules |
|---|---|---|
| session status | `working\|awaiting-validation\|awaiting-mapping\|awaiting-adr-acceptance\|orchestrating\|paused\|completed\|failed` | Only the owning boundary may advance the status. |
| accepted context | references to accepted Profile, Objective, Control, NFR, ADR, Architecture, Implementation | Read-only grounding context. |
| source evidence | evidence items | Includes repository context, conversation, manually provided websites, and imported materials. |
| capabilities | capability records | Provisional until requester validation; accepted records enter the capability queue. |
| mappings | mapping records | Accepted onboarding evidence; many-to-many in both directions. |
| platform queue | grouped mapping projections | Transient review ordering; never persisted as an inventory. |
| owner progress | owner mutation results | Stores durable identifiers and last successful boundary for resume. |

## Evidence Item

`source_kind` is one of `repository`, `conversation`, `website`, or `imported_material`. Each item also has content or reference, availability state, grounding references, and whether the requester validated it. Unavailable or contradictory items remain visible as limitations and cannot independently support an accepted historical claim.

## Capability

Fields: `name`, `business_purpose`, `grounding`, `status`, `user_contribution`, and optional `uncertainty_reason`.

`status` is one of `proposed`, `unknown`, `accepted`, or `rejected`. Only `accepted` capabilities enter the mapping queue. Rejected capabilities cannot be promoted without a new user contribution.

## Capability Mapping

Fields: `capability_id`, `provider_label`, `provider_kind` (`platform`, `service`, `custom_process`, `unknown`), `primary`, `evidence_ids`, and `status`.

The relation is many-to-many: one capability can have multiple mappings and one provider label can serve multiple capabilities. `primary` is optional and requester-supplied; it is not inferred from frequency or ordering. `unknown` is retained as explicit evidence but cannot authorize ADR creation by itself.

## Proposed Pre-existing ADR

Fields: `provider_group`, `capability_ids`, `alternatives`, `rationale`, `uncertainties`, `grounding`, `contribution_history`, and `status`.

`status` is `working-idea`, `awaiting-validation`, `accepted`, or `rejected`. Alternatives and rationale remain provisional until the requester accepts the stabilized proposal. Unsupported historical claims are represented in `uncertainties`, not as facts.

## Onboarding Provenance

```yaml
request: onboarding
discovery: highway
```

Each onboarding ADR has exactly one scalar request provenance value and one scalar discovery-source
value. Onboarding never creates a synthetic Discovery record.

## Owner Mutation Result

Fields: `owner` (`adr`, `architecture`, `implementation`), `status`, `attempt_count`, `durable_id`, `failure_reason`, and `resume_boundary`.

A successful result must have its durable identifier before the next owner is invoked. `attempt_count` is capped at three for a failed downstream owner. Resume uses the stored `durable_id` values and begins at `resume_boundary`.

## State transitions

```text
working -> awaiting-validation -> awaiting-mapping -> awaiting-adr-acceptance
awaiting-adr-acceptance -> orchestrating -> completed
orchestrating -> paused (after three failed downstream attempts)
paused -> orchestrating (manual resume at failed owner)
working/awaiting-* -> failed only for unrecoverable input or owner contract failure
```
