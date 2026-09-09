# Data Model: Highway Profile Path Migration

## Canonical Profile Artifact

The single authoritative pure-YAML profile at `.highway/library/templates/output/profile.yaml`.

| Field | Meaning | Required/validation |
|---|---|---|
| `metadata.version` | Profile schema/content version | Required; initial distributed value is `1.0.0`; semantic policy applies to confirmed mutations |
| `metadata.description` | Stable contextual purpose | Required; folded description is fixed in the default artifact |
| `organization.name` | User-owned organization name | Required key; empty string in the default |
| `organization.industry` | User-owned industry | Required key; empty string in the default |
| `constraints` | Organizational constraints | Required mapping; empty in the default |
| `strategic_directions` | Strategic directions | Required mapping; empty in the default |
| `preferences` | Technology and operating preferences | Required mapping; empty in the default |
| `business_context` | Business context | Required mapping; empty in the default |
| `architecture_principles` | Architecture principles | Required mapping; empty in the default |
| `approved_technologies` | Approved technologies | Required mapping; empty in the default |
| `prohibited_technologies` | Prohibited technologies | Required mapping; empty in the default |
| `operating_model` | Operating model | Required mapping; empty in the default |
| `vendor_strategy` | Vendor strategy | Required mapping; empty in the default |

### Structural invariants

- The document is pure YAML with no Markdown or YAML frontmatter delimiters.
- Top-level keys appear in the exact order defined in the specification.
- `metadata` is first.
- All required mappings remain present, even when empty.
- The default contains no values beyond the specified metadata and empty organization fields.
- No timestamp, random identifier, or environment-derived value is generated.
- User wording, capitalization, grouping, and value order are preserved unless explicitly changed.

## Former Profile Path

The obsolete `.highway/profile.yaml` location. It is invalid after migration and must have zero files and zero references.

## Orphaned Migration Artifact

Any stale former-path file or reference in source skills, validators, tests, fixtures, catalogs, adapters, adapter manifests, distribution manifests, or other distribution metadata.

## Clean-Migration Audit

A repeatable validation result over the repository and generated distribution surfaces.

| Result | Meaning |
|---|---|
| `PASS` | Canonical profile exists, former path is absent, and no orphan reference is found |
| `FAIL` | One or more former-path artifacts or references remain; each is reported |

## Version State

| Operation | Version change | Commit condition |
|---|---|---|
| Confirmed `add` | PATCH | Only after the content write succeeds |
| Confirmed `update` | PATCH | Only after the content write succeeds |
| Confirmed `remove` | PATCH | Only after the content write succeeds |
| Confirmed `reset` | MINOR | Only after the content write succeeds |
| Schema-breaking release | MAJOR | Only when the schema change is released |
| Declined, malformed, ambiguous, or aborted operation | None | Profile and version remain unchanged |

## State Transitions

- `Former path present -> Canonical path present -> Former path absent` for a successful migration.
- `Canonical path present + no stale references -> Audit PASS`.
- `Canonical path present + any orphan -> Audit FAIL`.
- `Profile mutation proposed -> Confirmed write -> Version increment`.
- `Profile mutation proposed -> Declined or pre-write error -> Original bytes and version retained`.
