# Contract: Profile Record

Source: `.highway/library/templates/output/profile-record.md`

Structural classification stays in `.highway/tools/lib/profile.sh` and `.highway/tools/validate-profile.sh`. This feature does not change those files.

## Version

| Field | Value |
|---|---|
| Schema | 3.0.0, unchanged |
| Template metadata | 3.0.0, unchanged |
| Supported schema | 3.0.0 only |

A file whose `schema_version` is 2.0.0 still fails structural classification and is left unchanged.

## Domain map

Unchanged.

| Key | Heading | Readiness |
|---|---|---|
| `identity` | `## Who We Are` | Yes |
| `vision` | `## Where We're Going` | Yes |
| `competitive_path` | `## How We Plan to Get There` | Yes |
| `guiding_principles` | `## What Guides Our Decisions` | Yes |

`highway_role` and `## How Highway Helps` stay absent. The title stays `# Organizational Profile`.

## Context group

Owned by the template's structural guidance. Rendered in a retained record only when accepted, after the domain narratives:

- `## Context`
- `### Repository Name`
- `### Organization Name`
- `### Organization URL`
- `### Organizational Context`

These headings are not domain keys. A child with no accepted value is omitted. When every child is omitted, `## Context` is omitted. The default template body does not emit an empty Context section.

## Narrative and context rules

The template states that:

- Domain narratives contain only accepted evidence.
- `not_discussed` has no narrative.
- `discussed` has an accepted narrative.
- `bounded` may have an accepted narrative.
- Optional Context contains only user-provided or user-accepted information.
- Absent optional context is omitted.

The template does not define the meaning, quality, discovery, recommendation, or acceptance of that evidence.

## Helper assertions

`profile_domain_keys` still returns the four keys and does not return `highway_role`. The schema check still requires `3.0.0`. The domain count check still requires 4. A schema 2.0.0 fixture still fails. Context does not change those results.
