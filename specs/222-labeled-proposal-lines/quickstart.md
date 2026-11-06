# Quickstart: Labeled Proposal Lines

## Prerequisites

- Repository root with `.highway/`.
- Bash 3.2 or later.

## Static check

```bash
bash .highway/tools/tests/labeled-proposal-lines.test.sh
```

Expected: `PASS: Recommendation and Evidence sit on their own bold line`

The test checks the shapes in [contracts/shapes.md](contracts/shapes.md), the rejected text, the word limits, and the version.

## Full suite

```bash
bash .highway/tools/tests/run-all.sh
```

Expected: `Summary: 77 passed, 0 failed`

## Validation

```bash
bash .highway/tools/validate-skill.sh .highway/skills/highway-codify-config
```

## Walkthrough

1. Add a platform whose When to use overlaps another platform. Under **Conflicts:**, the conflict and its description are followed by a blank line and an indented **Recommendation:** line.
2. On the same proposal, each new realized capability shows its title and Realized By, then a blank line and an indented **Evidence:** line.
3. Add a coding standard whose File Patterns and When to use overlap another standard. Its conflict shows **Recommendation:** the same way.
4. Choose to resolve conflicts from the menu. Each conflict in the list shows **Recommendation:** the same way.
