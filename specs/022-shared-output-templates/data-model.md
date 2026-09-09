# Data Model: Shared Output Templates

## Output Template

A complete, shared skeleton for one retained file artifact.

| Field | Description | Validation |
|---|---|---|
| Template path | Path under `.highway/library/templates/output/` | Exists and is distributed with the framework |
| File type | The emitted artifact kind, such as NFR record or Control record | One template per distinct output structure |
| Frontmatter block | Required metadata shape at the start of the file | Present for every retained file artifact |
| Body structure | Ordered sections and placeholders following frontmatter | Matches the existing output contract for the file type |
| User-owned values | Placeholder positions filled by the user or skill run | Not semantically judged by Highway |

## Citing Skill

A `SKILL.md` whose `Outputs` section identifies an output template.

| Field | Description | Validation |
|---|---|---|
| Skill id | Stable skill identifier | Matches the skill's frontmatter |
| Emitted file path | Runtime path written by the skill | Declared under `Outputs` |
| Template citation | Shared template path used for the complete structure | Names a file under `.highway/library/templates/output/` |
| Output declaration | The skill's remaining output behavior | Does not independently restate the template's field or body contract |

## Emitted Output Contract

The structure a skill promises to produce for a file type.

| Field | Description | Validation |
|---|---|---|
| Frontmatter fields | Ordered metadata fields | Preserved during migration and present in emitted files |
| Body sections | Ordered Markdown sections | Preserved during migration and represented by the template |
| Artifact retention | Whether the file remains after the skill completes | Frontmatter rule applies only when retained |
| Semantic content | User-owned values and policy meaning | Out of scope for Highway validation |

## Shared Artifact Dependency

The relationship tracked by `D8.1`.

| Relationship | Meaning |
|---|---|
| Library artifact -> citing skill | A template or other shared library file is named by a skill |
| Change -> dependent review | A library change requires re-validation of every citing skill |
| Review -> output match | The citing skill's complete frontmatter and body still match the changed artifact |

## State Transitions

1. **Uncited output** -> **Template cited** when a skill's Outputs section names a complete shared output template.
2. **Inline structure** -> **Template-defined structure** when the skill removes duplicate field and body-shape prose without changing the emitted contract.
3. **Template changed** -> **Dependent review required** when a shared template is modified.
4. **Dependent review required** -> **Conforming** when every citing skill's complete output still matches.
5. **Dependent review required** -> **Mismatch reported** when any citing skill no longer matches.

## Implementation Evidence

- `P9.1` is enforced by the registered check in `.highway/tools/lib/rule-checks.sh`.
- `X1.5` and `D8.1` remain agent-checkable governance obligations.
- `.highway/tools/tests/output-template.test.sh` verifies both complete templates, both citations,
  preserved fields, body placeholders, and the current citing-skill set.
