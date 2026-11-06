# Quickstart: Standard Starting Point

## Prerequisites

- Repository root with `.highway/`.
- Bash 3.2 or later.

## Static check

```bash
bash .highway/tools/tests/standard-starting-point.test.sh
```

Expected: `PASS: config steps are ordered, numbered, and open each standard proposal as a starting point`

The test checks the sentences in [contracts/config-steps.md](contracts/config-steps.md), the heading order, the rejected line, the banned words, the word limits, and the version.

## Full suite

```bash
bash .highway/tools/tests/run-all.sh
```

Expected: `Summary: 73 passed, 0 failed`

## Validation

```bash
bash .highway/tools/validate-skill.sh .highway/skills/highway-codify-config
```

## Walkthrough

1. Add a coding standard. The consequence sentence appears, then the starting-point line naming the technology, then `**Standard Title:**`.
2. Edit the proposal. The re-shown proposal has no starting-point line.
3. Remove a standard. No starting-point line appears.
4. Invoke `/highway-codify-config` with an accepted implementation title. The proposal opens with no menu and no platform list.
5. After a platform write, answer the conflicts question with "what does that mean?". It is answered and asked again.
