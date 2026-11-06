# Quickstart: Group Realized Capabilities

## Prerequisites

- Repository root with `.highway/`.
- Bash 3.2 or later.

## Static check

```bash
bash .highway/tools/tests/group-realized-capabilities.test.sh
```

Expected: `PASS: current groups realized capabilities by the automation`

The test checks the steps in [contracts/current-steps.md](contracts/current-steps.md), the Verification bullet, the rejected lines, the banned words, the word limit, and the version.

## Full suite

```bash
bash .highway/tools/tests/run-all.sh
```

Expected: `Summary: 75 passed, 0 failed`

## Validation

```bash
bash .highway/tools/validate-skill.sh .highway/skills/highway-codify-config
```

## Walkthrough

1. Add a platform whose documentation describes three review features that hand off through a pull request. New Realized Capabilities lists one review capability. Its title has five words or fewer and no product name. The evidence names the features and the pull request.
2. The same proposal lists a scheduled run, a scripted run, and proposing a change as separate capabilities when the documentation describes each.
3. Update a platform whose implementation already records a review under another title. The review is not proposed again.
