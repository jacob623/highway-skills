# Quickstart: Single Rule Shape

## Prerequisites

- Repository root with `.highway/`.
- Bash 3.2 or later.

## Static check

```bash
bash .highway/tools/tests/single-rule-shape.test.sh
```

Expected: `PASS: a coding rule is one must within eight words`

The test checks the steps in [contracts/rule-shape.md](contracts/rule-shape.md), the proposal shape, the skeleton line, the rejected lines, the banned words, the word limits, and both versions.

## Full suite

```bash
bash .highway/tools/tests/run-all.sh
```

Expected: `Summary: 76 passed, 0 failed`

## Validation

```bash
bash .highway/tools/validate-skill.sh .highway/skills/highway-codify-config
```

## Walkthrough

1. Add a platform standard whose documentation describes two outcomes in one sentence. The proposal lists two rules. Each has must once and eight words or fewer. Each has a blank line, then **Why it matters:**. The model suggests at most fifteen, and one of them keeps credentials out of the files.
2. Edit a rule of nine words onto that proposal. The next proposal shows a rewritten rule. The sentence before the proposal states the rewrite.
3. Update a saved standard that already has sixteen rules the person provided. All sixteen remain. The model suggests at most fifteen further rules.
4. Accept the proposal. The standard file lists the rules and has no **Why it matters:** line.
