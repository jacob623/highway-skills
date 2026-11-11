# Data Model: Standard Alignment Catalog Seeding

## Seeded file

- **Asset**: a file in `skills/highway-setup/assets/` (contract `seeding.md`).
- **Project path**: where setup writes it.
- **Lifecycle**: absent, then seeded (byte-identical to the asset), then edited by its writing skills.
  Setup never moves a file back or rewrites it.
- **Validation**: the template check in skeleton mode (frontmatter keys, `## ` headings, table header rows).

## Catalog rule

- **Source**: a rule paragraph of a retired template, moved verbatim.
- **Holder**: each skill that writes the part of the catalog the rule governs (research R5).

| Project file | Writers |
| --- | --- |
| `requests/requests.md` | highway-request |
| `discoveries/discoveries.md` | highway-discovery |
| `adrs/adrs.md` | highway-adr; highway-onboarding (its own rows, until Phase 10) |
| `architectures/architectures.md` | highway-architecture; highway-adr (ADR ID cell only) |
| `implementations/implementations.md` | highway-implementation |
| `implementations/capabilities.md` | highway-implementation |
| `code/code.md`, `code/integrations.md` | highway-codify |
| `library/coding-standards/codify-platforms.md` | highway-implementation (adds rows); highway-codify-config (Kind and guidance) |
| `library/coding-standards/coding-standards.md` | highway-codify-config |
| `library/knowledge/assessment-findings.md` | highway-assessment |
| `library/knowledge/storage.md` | highway-setup only |

## Shared rule

- **Fields**: `skills` (the skills that state it), `rule` (the exact line).
- **Instances**: capability title rule; ADR ID cell rule (contract `shared-rules.md`).
- **Invariant**: each named skill holds `rule` as a whole line.

## Entry check

- **Fields**: the skill, its seeded files, the fixed instruction, the fixed two-line message.
- **Invariant**: it precedes the skill's first `###` step and its first question (contract `entry-check.md`).

## Governance catalog template

- **Location**: `skills/highway-<objectives|controls|nfrs>/assets/<objective|control|nfr>-catalog.md`.
- **Not seeded**: absent means never set up; empty means declined.
