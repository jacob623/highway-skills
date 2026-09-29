# Contract: Profile Record

Source: `.highway/library/templates/output/profile-record.md`

Structural classification: `.highway/tools/lib/profile.sh` and `.highway/tools/validate-profile.sh`

The skill does not name the validator. The helper accepts only schema 3.0.0 and the four domain keys below.

## Version

| Field | Value |
|---|---|
| Schema | 2.0.0 → 3.0.0 |
| Template metadata | 2.0.0 → 3.0.0 |
| Class | Breaking |
| Supported schema | 3.0.0 only |

A file whose `schema_version` is 2.0.0 fails structural classification. Profile reports that file as Blocked and does not modify it. Content changes to a 3.0.0 record do not change `schema_version`.

## Domain map

| Key | Heading | Readiness |
|---|---|---|
| `identity` | `## Who We Are` | Yes |
| `vision` | `## Where We're Going` | Yes |
| `competitive_path` | `## How We Plan to Get There` | Yes |
| `guiding_principles` | `## What Guides Our Decisions` | Yes |

`highway_role` and `## How Highway Helps` are absent. Each retained domain outcome is `not_discussed`, `discussed`, or `bounded`.

## Optional headings

Rendered only when the corresponding value has been accepted:

- `## Repository Name`
- `## Organization Name`
- `## Organization URL`
- `## Organizational Context`

These headings are outside the domain map. They do not use a placeholder when absent.

## Narrative rules

- `not_discussed` has no narrative section.
- `discussed` has its narrative section.
- `bounded` has its narrative section only when accepted evidence exists.
- Narrative sections keep the heading order above.
- Optional headings, when present, follow the domain narratives.

## Helper assertions

`profile_domain_keys` returns the four keys and does not return `highway_role`. The schema check requires `3.0.0`. The domain count check requires 4. A schema 2.0.0 fixture fails. An unsupported-schema fixture uses a version other than 3.0.0.
