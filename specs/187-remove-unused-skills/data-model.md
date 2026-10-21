# Data Model: Remove Unused Skills

## Removed skill

- **Identity**: `highway-clarify`, `highway-inquiry`, `highway-relationships`, or `highway-new`.
- **Source**: `.highway/skills/<name>/`.
- **Published copies**: `.github/skills/<name>/`, `.claude/skills/<name>/`, `.cursor/skills/<name>/`, `.agents/skills/<name>/`.
- **Distribution**: One `include` row per agent tree in `.highway/tools/.distribution-manifest`.
- **End state**: The directory, published copies, catalog entry, adapter-manifest rows, and distribution rows are absent.

## Owned template

| Template | Owner | End state |
|---|---|---|
| `.highway/library/templates/output/clarification-record.md` | `highway-clarify` | Deleted |
| `.highway/library/templates/output/clarification-catalog.md` | `highway-clarify` | Deleted |
| `.highway/library/templates/requirements-inquiry.md` | `highway-inquiry` | Deleted |

`highway-relationships` has no output template of its own.

## Shared request template

- **Identity**: `.highway/library/templates/output/request-record.md` and `request-catalog.md`.
- **Owner that remains**: `highway-request`.
- **Rule**: Both files stay byte-for-byte. `highway-request` still cites both paths.

## Remaining skill

- **Identity**: Profile, Objectives, Controls, Non-Functional Requirements, Setup, Request, Discovery, Decision, Reference Architecture, Reference Implementation, Onboarding, Assessment, and Help.
- **Rule**: Source text is not rewritten by this removal. Help's listing changes only because the generated catalog no longer contains the removed skills.

## State transitions

- A removed skill goes from offered to absent. It is not replaced by a reserved stub.
- An owned template goes from present to absent.
- A shared request template stays present.
