# Data Model: Promote Rewritten Skills

The behavioral fields inside each skill stay in the draft. This model records only the promotion entities and the catalog rules the templates must match.

## Rewritten skill

- **Identity**: Skill name in the draft frontmatter.
- **Source**: One Markdown file in `highway-skills-v2`.
- **Destination**: `.highway/skills/<name>/SKILL.md`.
- **Published copies**: One generated adapter per declared agent tree.
- **Validation**: Required authoring sections are present, and `validate-skill.sh` reports no rule failure.
- **Relationship**: Cites zero or more shared output templates. A changed template is re-checked against every skill that cites it.

## Reserved name

- **Identity**: `highway-new`.
- **Rule**: The directory remains. The skill does not collect or write a request. It directs the person to `highway-request`.

## Catalog template

- **Identity**: An existing file under `.highway/library/templates/output/`.
- **Source of columns and statuses**: The matching draft in `highway-skills-v2`, or `implementation.md` for the capability catalog.
- **Objectives, Controls, and Non-Functional Requirements**: Status is `active` or `removed`.
- **Request, Discovery, Decision, Reference Architecture, and Reference Implementation**: Status is `accepted` or `removed`.
- **Assessment findings**: Status vocabulary is the one in the findings draft. It is not forced into the two status pairs above.
- **Capability catalog**: Columns are ID, Parent, Title, and Realized By. Parent is the implementation id. There is no `Next ID`. A capability id is `CAP` plus eight hexadecimal digits derived from the title.
- **Removed row**: The row stays, the identifier stays taken, and the record is not actionable.

## Actionable record

- **Identity**: A catalog row the invoked skill can still act on.
- **Shown as**: A number, the identifier, and the title.
- **Order**: Catalog order. Discovery's missing-identifier list numbers Requests first, then Discoveries, in one sequence.
- **Exclusion**: A row whose downstream record already exists, including a removed downstream row, is excluded.

## Invariant

- **Identifier**: Prefix plus eight hexadecimal digits derived from the title. The same title reuses the identifier. A collision with a different title asks for a title change and does not explain the derivation. No clock, local program, or person-identifying fragment is used.
- **Decision**: One Discovery has at most one Decision.
- **Reference Architecture**: Conceptual. It names no platform, product, vendor, or specific technology.

## State transitions

- A promoted catalog row moves between the two statuses allowed for that catalog. No third status is added by this promotion.
- Assessment finding statuses follow the findings draft.
- `highway-new` does not gain a request-writing state.
