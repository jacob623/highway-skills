# Contract: The Validator's Agent Skills Checks

`framework/validate-skill.sh <skill-dir>` keeps its output contract: findings go to stderr as
`ERROR: [<tag>] <message>` lines, and the five verdict lines and the `OK:`/`FAILED:` line go to
stdout, with exit 0 or 1. This phase adds or changes the findings below. Every finding names its
field.

## Parse

| Condition | Finding |
| --- | --- |
| `python3` or PyYAML missing | `ERROR: [SCHEMA] the YAML parser is unavailable: framework/validate-skill.sh needs python3 with the PyYAML module` |
| No opening `---` line, or no closing `---` line | `ERROR: [SCHEMA] SKILL.md must start with a frontmatter block between two '---' lines` |
| YAML syntax error | `ERROR: [SCHEMA] frontmatter is not valid YAML: <parser message, first line>` |
| A key repeated at one level | `ERROR: [SCHEMA] duplicate key '<key>' in frontmatter` |
| Frontmatter not a mapping | `ERROR: [SCHEMA] frontmatter must be a YAML mapping` |

A parse failure stops the frontmatter checks below, so one malformed block is reported once. The
body checks still run.

## Fields

| Condition | Finding |
| --- | --- |
| Top-level key outside `name`, `description`, `license`, `compatibility`, `allowed-tools`, `metadata` | `ERROR: [SCHEMA] undeclared top-level key '<key>'` |
| `metadata` key outside `version`, `usage` | `ERROR: [SCHEMA] undeclared metadata key 'metadata.<key>'` |
| A string field resolves to another type | `ERROR: [SCHEMA] field '<field>' must be a string (YAML reads it as <type>)` |
| `metadata` not a mapping | `ERROR: [SCHEMA] field 'metadata' must be a mapping` |
| Required field missing | `ERROR: [SCHEMA] missing required field '<field>'` |
| Parser and line reader disagree | `ERROR: [SCHEMA] field '<field>' reads differently in a strict YAML parser` |

## Values

| Condition | Finding |
| --- | --- |
| Folder id not kebab-case | `ERROR: [SCHEMA] invalid id '<id>' -- directory name must match ^[a-z0-9]+(-[a-z0-9]+)*$ (kebab-case)` (unchanged) |
| `name` over 64 characters | `ERROR: [SCHEMA] field 'name' exceeds 64 characters (got <n>)` |
| `name` differs from folder | `ERROR: [SCHEMA] frontmatter 'name' ('<name>') does not match directory-derived id '<id>'` (unchanged) |
| `description` empty | `ERROR: [SCHEMA] missing required field 'description'` (unchanged) |
| `description` over 1,024 | `ERROR: [SCHEMA] field 'description' exceeds 1024 characters (got <n>)` |
| `compatibility` present and empty | `ERROR: [SCHEMA] field 'compatibility' is shorter than the minimum 1 characters (got 0)` |
| `compatibility` over 500 | `ERROR: [SCHEMA] field 'compatibility' exceeds 500 characters (got <n>)` |
| `metadata.usage` missing | `ERROR: [SCHEMA] missing required field 'metadata.usage'` |
| `metadata.usage` over 500 | `ERROR: [SCHEMA] field 'metadata.usage' exceeds 500 characters (got <n>)` |
| No "Use when" sentence | `ERROR: [P5.15] description has no sentence beginning "Use when" (<P5.15 Observable>)` |

The name rules on uppercase, leading or trailing hyphens, and consecutive hyphens are decided by
the folder id check together with the name-match check. A `name` that breaks any of them either
differs from a kebab-case folder or sits in a folder that is not kebab-case.

## Removed findings

- `[SCHEMA] field 'compatibility' ("…") must be one of: …`
- `[SCHEMA] field 'metadata.agent_exceptions[].…'`
- `[DEPENDENCY] …`
- `[LEXICON]` and other word-list findings
- `[SCHEMA] field 'description' is shorter than the minimum 10 characters`
