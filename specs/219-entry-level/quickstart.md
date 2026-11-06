# Quickstart: Entry Level

## Prerequisites

- Repository root with `.highway/`.
- Bash 3.2 or later.

## Static check

```bash
bash .highway/tools/tests/entry-level.test.sh
```

Expected: `PASS: config proposals offer classes of automation with each consequence under its entry`

The test checks the sentences in [contracts/config-steps.md](contracts/config-steps.md), the heading order, both proposal shapes, the rejected lines, the banned words, the word limits, and the version.

## Full suite

```bash
bash .highway/tools/tests/run-all.sh
```

Expected: `Summary: 74 passed, 0 failed`

## Validation

```bash
bash .highway/tools/validate-skill.sh .highway/skills/highway-codify-config
```

## Walkthrough

1. Add an agent platform. When to use and When not to use hold one to four classes each, such as Agentic automation or Human in the loop. No entry is a task.
2. Each entry is followed by a blank line, then **Why it matters:** and one consequence sentence. The proposal has no **Consequences:** section.
3. Add a coding standard. Its When to use and When not to use follow the same form. Its Coding Standards rules still each contain the word must.
4. Add Bug investigation to an agent proposal and accept it. Update that platform. Bug investigation is still an entry.
