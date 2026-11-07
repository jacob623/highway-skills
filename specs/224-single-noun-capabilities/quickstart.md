# Quickstart: Single Noun Capabilities

## Prerequisites

- Repository root with `.highway/`.
- Bash 3.2 or later.

## Static check

```bash
bash .highway/tools/tests/single-noun-capabilities.test.sh
```

Expected: `PASS: a capability is one noun phrase of five words or fewer`

The test checks [contracts/title-rule.md](contracts/title-rule.md), [contracts/onboarding.md](contracts/onboarding.md), and [contracts/codify-rank.md](contracts/codify-rank.md), the rejected text, and the versions.

## Full suite

```bash
bash .highway/tools/tests/run-all.sh
```

Expected: `Summary: 79 passed, 0 failed`

## Validation

```bash
for s in highway-implementation highway-onboarding highway-architecture highway-codify-config highway-codify; do
  bash .highway/tools/validate-skill.sh ".highway/skills/$s"
done
```

## Walkthrough

1. Onboard with context naming class registration and workshop registration on one platform. The list shows Class Registration and Workshop Registration.
2. Add "Research and Development". The list shows Research and Development as two items, and the consequence sentence explains the compounding risk.
3. The first item is AI-Augmented Technology Development, provided by the session's agent platform.
4. Propose an implementation. Each capability is one entry. The capability catalog has one row per capability.
5. Start codify with no running instance. The first suggestion is Establish [implementation title], then one per capability.
