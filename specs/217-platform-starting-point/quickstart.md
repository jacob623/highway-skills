# Quickstart: Platform Starting Point and Automation Grounding

## Prerequisites

- Repository root with `.highway/`.
- Bash 3.2 or later.

## Static check

```bash
bash .highway/tools/tests/platform-starting-point.test.sh
```

Expected: `PASS: config proposals start from automation best practice and record new capabilities`

The test checks every sentence in [contracts/config-steps.md](contracts/config-steps.md), the rejected lines, the banned words, the word limits, and the versions.

## Full suite

```bash
bash .highway/tools/tests/run-all.sh
```

Expected: `Summary: 72 passed, 0 failed`

## Validation

```bash
bash .highway/tools/validate-skill.sh .highway/skills/highway-codify-config
bash .highway/tools/validate-skill.sh .highway/skills/highway-implementation
```

## Walkthrough

1. Run `/highway-codify-config` with an accepted pipeline implementation's title.
2. The proposal shows the consequence sentence, then the starting-point line, then the fields. Each use entry is five words or fewer with **Why it matters:** beneath it. New Realized Capabilities lists documented automation capabilities the implementation does not list.
3. Edit an entry. The re-shown proposal has no starting-point line.
4. Accept. Configuration says "Let's record the new capabilities for [Platform]." `highway-implementation` records them, lists what it wrote, and returns. Configuration then asks the conflicts or coding-standards question, or shows `platforms`.
