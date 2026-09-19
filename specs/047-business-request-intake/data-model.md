# Data Model: Business Request Intake

## Request Record

A user-owned Markdown artifact at `requests/REQXXXXXX.md`.

| Field | Meaning | Validation |
|---|---|---|
| `id` | Permanent request identifier | `REQ` followed by exactly six digits; allocated from catalog `Next ID` |
| `status` | Request lifecycle state | One of `proposed`, `active`, `closed`, `withdrawn`; `highway-new` writes only `proposed` |
| `title` | Request heading | Requester-supplied title when present; otherwise deterministic derivation from Problem evidence |
| `problem` | Business problem | User-authored content required |
| `actors` | People, teams, stakeholders, consumers, or user groups | At least one actor, role, team, stakeholder, consumer, or user group required |
| `current_process` | How the activity works today | User-authored content required |
| `desired_change` | What should differ after completion | User-authored content required |
| `success_measure` | How success will be observed | User-authored content required |
| `business_constraints` | Limits, obligations, dependencies, preservation, or explicit absence | User-authored content, `None`, `No business constraints`, or `No known constraints` |
| `completeness` | Request completeness state | `Complete` only when all six domains are complete; otherwise `Incomplete` |

Request records do not contain Request-to-Objective, Request-to-Control, or Request-to-NFR relationship fields.

## Request Catalog

A repository-owned Markdown artifact at `requests/requests.md`.

| Field | Meaning | Validation |
|---|---|---|
| `version` | Catalog format version | Bootstrap value `1.0.0`; preserved on normal allocation |
| `next_id` | Authoritative next identifier | Six-digit `REQ` value; allocation source is the catalog, never filenames or observed maxima |
| request index | Discoverable request entries | Each created request appears once with its ID, title, and status |

When the catalog is absent, bootstrap creates `requests/requests.md` with `Version: 1.0.0` and `Next ID: REQ000001` before allocating the first request.

## Evidence Domain

One of exactly six ordered domains:

1. Problem
2. Actors
3. Current Process
4. Desired Change
5. Success Measure
6. Business Constraints

Completeness is deterministic: content presence is required for five domains; Actors requires at least one actor-like subject; Business Constraints accepts content or one of the three explicit no-constraint statements.

## Contextual Example

Transient guidance generated from, in order, existing request evidence, Profile context, Objectives, Controls, and NFRs. Examples are never request fields, user answers, or requirements.

## State Transitions

### Request lifecycle

`proposed` -> `active` -> `closed`

`proposed` -> `withdrawn`

`active` -> `withdrawn`

`highway-new` creates only the initial `proposed` state and performs no transitions.

### Completeness

`Incomplete` -> `Complete` when all six evidence domains satisfy their rules.

`Complete` -> `Incomplete` if a later edit removes required evidence; later editing behavior is outside Version 1.

## Transaction Invariants

- Catalog allocation and catalog update are one exclusive operation.
- Request and catalog artifacts are both built and validated before either is written.
- Any failure preserves existing bytes and produces no partial request creation.
- Identical inputs produce identical title, question selection, examples, evidence interpretation, and artifact content, except for the intentional catalog next-ID advancement of a new allocation.
- Secrets and regulated personal data are excluded from written request content.
