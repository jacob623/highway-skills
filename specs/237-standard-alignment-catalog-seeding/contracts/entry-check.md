# Contract: the entry check

## Text

In each skill listed below, the paragraph after the activation sentence in `## Procedure` is exactly:

```markdown
Before the first question, confirm these seeded files exist: <files>.
When any is absent, emit the message below exactly, stop, and write nothing.

**Oops... we need to setup your repository.**

Highway needs to gather your organizational preferences and set up your repository. Run /highway-setup to get started.
```

`<files>` is the skill's list below, each in backticks, in the order shown, joined by `, `. Every other
line is identical in every skill.

| Skill | Files |
| --- | --- |
| highway-request | `requests/requests.md` |
| highway-discovery | `discoveries/discoveries.md` |
| highway-adr | `adrs/adrs.md`, `architectures/architectures.md` |
| highway-architecture | `architectures/architectures.md` |
| highway-implementation | `implementations/implementations.md`, `implementations/capabilities.md`, `library/coding-standards/codify-platforms.md` |
| highway-onboarding | `adrs/adrs.md`, `architectures/architectures.md`, `implementations/implementations.md`, `implementations/capabilities.md`, `library/coding-standards/codify-platforms.md` |
| highway-codify | `code/code.md`, `code/integrations.md` |
| highway-codify-config | `library/coding-standards/codify-platforms.md`, `library/coding-standards/coding-standards.md` |
| highway-assessment | `library/knowledge/assessment-findings.md` |

## Test

`tests/catalog-seeding.test.sh` fails when, for any skill above:

- the check line is missing, does not name exactly that skill's files, or is not before the first `### `
  heading of `## Procedure`;
- the instruction line or either message line differs by any byte;
- the skill has a step that creates a seeded file or its folder when absent, or writes a seeded file from a
  template.

It also fails when a skill outside the table names a seeded file as written in its Outputs.

## Harness

`request-setup-needed` (contract `harness-shows.md`) proves an agent stops: the message is shown, no
question is asked, and no file is written.
