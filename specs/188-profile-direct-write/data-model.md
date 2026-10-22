# Data Model: Profile Direct Write

## Domain proposal

- **Domains**: Vision, Competitive Path, Guiding Principles. Identity uses a proposal when a supported starting point exists, and a question only when it does not.
- **Vision fields**: Future Direction, Desired Impact, Future State.
- **Competitive Path fields**: Primary Approach, Strategic Advantage, Important Tradeoff. The tradeoff is always present as an inference the person can correct.
- **Guiding Principles**: 3 to 5 bullets. Each has a short name and a decision-making value.
- **Acceptance**: One confirmation. The accepted bullets are the held domain. A rejected term is omitted.
- **Decline**: The domain is `bounded` and has no narrative section.

## Stored profile

- **Path**: `library/knowledge/profile.md` from the repository root.
- **Ignored path**: `.highway/library/knowledge/profile.md`. It is not read, copied, or reviewed.
- **Frontmatter**: `schema_version`, and `identity`, `vision`, `competitive_path`, `guiding_principles`, each `not_discussed`, `discussed`, or `bounded`.
- **Body headings**: Who We Are, Where We're Going, How We Plan to Get There, What Guides Our Decisions. A heading is rendered only when that domain has accepted bullets.
- **Narrative**: The accepted bullets, in the order accepted. No joined paragraph.
- **Context**: Optional, after the domain sections. Repository Name, Organization Name, Organization URL, and Organizational Context render only when accepted.
- **Write**: Once, after Guiding Principles is accepted or declined. The folder is created if it is absent.

## Readers

- **Profile**: Reads and reviews only `library/knowledge/profile.md`.
- **Setup**: Uses that file to decide whether the welcome is shown.
- **Objectives, Controls, and NFRs**: Name that file as accepted profile context when it is present.
