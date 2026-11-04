# Data Model: Codify Write Refactor

No new artifact or field.

## Automation catalog row (read)

- **Source**: `code/code.md`, from `codify-catalog.md`.
- **Fields used**: Implementation ID, Automation Title, Automation Path, Status.
- **Rule**: Only rows with Status `accepted` and the selected Implementation ID are considered.

## Automation record (read when meaning suggests a match)

- **Source**: `codify.md` at the row's Automation Path.
- **Fields used**: title, Summary, Description.
- **Rule**: The suggestion is left out when one of them is the suggested action. An absent file leaves the suggestion in.

## Suggestion (transient)

- **Fields**: action title, one summary sentence.
- **States**: kept, or left out by `codified`. Left-out suggestions are removed before the list is capped at five.

## Task list (unchanged)

- **Source**: `codify-tasks.md` 4.0.0. `write` names it and states none of its line rules.
