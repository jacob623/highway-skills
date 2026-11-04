# Research: Propose Edit Lines

## R1. How the edit line splits

- **Decision**: Keep every clause. Put the shared rules on the `edit` line, and each kind of edit on the next indented line. The text of each clause is unchanged, so the word count stays 392.
- **Rationale**: FR-002 and FR-003. A rewrite could drop a consequence. A line break cannot.
- **Alternatives considered**: A new `### edit` step. Rejected by FR-005.

## R2. Line length

- **Decision**: The longest resulting line is the catalog-title clause, at 175 characters. The limit is 240. A leading hyphen on each line counts as a word and would put `propose` at 401, so the lines carry no extra marker.
- **Rationale**: FR-001. The current line is 1,007 characters.

## R3. Replaced assertions (D3.5)

These pins name `highway-codify` and move from `9.0.0` to `9.0.1`. Reason: PATCH bump only.

- `codify-file-layout.test.sh`: the `version: 9.0.0` entry in the `$CODIFY` loop.
- `codify-config-skill.test.sh`: the same entry in its `$CODIFY` loop.
- `codify-platform-catalog.test.sh`: the same entry in its `$CODIFY` loop. The `$ONBOARD` pin `version: 9.0.0` stays.
- `codify-closing-guide.test.sh`: the same entry in its `$CODIFY` loop.
- `codify-write-refactor.test.sh`: the skill-body requirement `version: 9.0.0`.

## R4. What stays

- **Decision**: The proposal block, from the diagram sentence through `decline`, is not edited. No other step is edited. The version field is the only other change in the skill.
- **Rationale**: FR-004 and FR-005.
