# Contract: highway-help index

## Generator

`bash framework/generate-catalog.sh`

- Validates every skill first (`validate-skill.sh`). On any failure it writes nothing and exits
  non-zero, naming the skill. A `name` that differs from its folder is such a failure.
- Writes `skills/highway-help/assets/index.json` (`HW_HELP_INDEX`): one top-level `entries` array,
  fields as in `data-model.md`.
- Writes nothing under `.highway/`.

## Reader

highway-help reads `assets/index.json` in its own folder and nothing else. Its output is unchanged:

- Single-Skill mode prints six lines, in order: `Name:`, `Description:`, `Dependencies:`,
  `Version:`, `Usage:`, `Example:`. Every value comes from the identifier's entry.
- All-Skills mode prints one `Name:`/`Description:`/`Help: /highway-help <id>` block per entry, or
  `No skills are registered yet.`.
- Unknown identifier: `ERROR: no skill registered with id '<declared-id>'`.
- Index missing or unreadable:
  `ERROR: the skill index 'assets/index.json' is missing or unreadable`.
