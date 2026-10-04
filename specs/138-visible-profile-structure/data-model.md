# Data Model: Visible Profile Structure

## Profile Record Template

The shared file `.highway/library/templates/output/profile-record.md`. It is not a retained Profile.

| Field | Rule |
|---|---|
| `name` | `Organizational Profile` |
| `description` | `Complete output skeleton for retained organizational Profile evidence.` |
| `metadata.version` | `3.1.0` |
| Section order | YAML identity, `## File Frontmatter`, `## Body`, concise rendering semantics |

Template name, description, version, instructions, placeholders, and rendering explanations are not copied into a retained Profile.

## Retained Profile

The accepted record at `.highway/library/knowledge/profile.md`.

| Field | Rule |
|---|---|
| `schema_version` | `3.0.0` |
| `domains.identity` | `not_discussed`, `discussed`, or `bounded` |
| `domains.vision` | `not_discussed`, `discussed`, or `bounded` |
| `domains.competitive_path` | `not_discussed`, `discussed`, or `bounded` |
| `domains.guiding_principles` | `not_discussed`, `discussed`, or `bounded` |
| Title | `# Organizational Profile`, always present |
| Domain headings | `## Who We Are`, `## Where We're Going`, `## How We Plan to Get There`, `## What Guides Our Decisions`, in that order, only when the state permits narrative |
| Context | Optional `## Context` after rendered domain narratives. Children, in order: `### Repository Name`, `### Organization Name`, `### Organization URL`, `### Organizational Context` |

All four domain keys remain present even when their headings are omitted. A `bounded` domain stays `bounded` when it has no narrative. Empty Context and empty Context children are omitted. Present Context children keep their relative order.

### Domain state transitions

| State | Narrative |
|---|---|
| `not_discussed` | No heading and no placeholder |
| `discussed` | Accepted narrative renders |
| `bounded` | Accepted narrative renders only when accepted evidence exists |

No other states are permitted. Context does not change readiness.

## Profile Skill Contract

The source skill `.highway/skills/highway-profile/SKILL.md`, version `7.0.0`.

It owns domain meaning, acquisition, completeness, readiness, persistence, and downstream boundaries. It cites the template for structure and the Experience Standard for generic collaboration. It does not own retained heading order.

Readiness order:

1. No retained Profile: `Missing`, next action `/highway-profile setup`
2. Unsupported or malformed Profile, including schema `2.0.0`: `Blocked`, next action `None`, no mutation
3. Any `not_discussed` domain: `Missing`, next action `/highway-profile configure`
4. All four domains `discussed` or `bounded`: `Complete`, next action `None`

## Relationships

- One template defines the permitted shape of every retained Profile.
- One retained Profile has exactly four domain outcomes and zero or one Context section.
- The skill reads and writes the retained Profile. It does not write the template.
