# Contract: Profile Record Template

Source: `.highway/library/templates/output/profile-record.md`

The file is a skeleton document. It is not a valid retained Profile and must not be copied as one.

## Required visible content

- Description value: `Complete output skeleton for retained organizational Profile evidence.`
- Template metadata version: `3.1.0`
- Section headings: `## File Frontmatter` and `## Body`
- Retained frontmatter skeleton contains `schema_version: 3.0.0` and a `domains` mapping with `identity`, `vision`, `competitive_path`, and `guiding_principles`
- Permitted state values named in the skeleton: `not_discussed`, `discussed`, `bounded`
- Body skeleton title: `# Organizational Profile`
- Body headings, in order: `## Who We Are`, `## Where We're Going`, `## How We Plan to Get There`, `## What Guides Our Decisions`, then optional `## Context`
- Context children, in order: `### Repository Name`, `### Organization Name`, `### Organization URL`, `### Organizational Context`

## Required semantics

- `The domain headings above define the permitted retained narrative sections and their ordering. Render a domain heading only when its domain state permits narrative.`
- `## Context is optional and follows all rendered Profile-domain narratives. Omit ## Context when no Context child has accepted content.`
- `Within ## Context, render only accepted children. Absent Context children are omitted.`
- `Template metadata describes profile-record.md and is not retained Profile content.`
- `The retained artifact contains only its retained frontmatter, # Organizational Profile, permitted accepted domain narratives, and permitted accepted optional Context.`

State behavior must state that `discussed` renders accepted narrative, `bounded` renders accepted narrative only when accepted evidence exists, and `not_discussed` renders no narrative section. A bounded narrative is not required for symmetry.

## Prohibited content

- A hidden HTML comment that carries the body contract
- Conversational headings `### Where you're going`, `### How you'll get there`, and `### What will guide your decisions`
- Highway Role, provenance sections, expression fields, inventories, Working Idea state, or workflow instructions
- Any retained schema version other than `3.0.0`
