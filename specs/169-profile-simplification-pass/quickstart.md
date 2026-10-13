# Quickstart: Profile Simplification Pass

## Prerequisites

Run from the repository root with macOS system tools available:

```bash
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
```

## Focused Contract

After implementation, run:

```bash
bash .highway/tools/tests/feature-169-profile-simplification.test.sh
```

Expected result:

```text
OK: Feature 169 Profile Simplification Pass contract passes
```

The focused contract verifies removal of the five competing sections, retention of Interpretation confidence, structure guidance in all four opportunities, removal of obsolete verification claims, protected boundaries, and generated correspondence.

## Source Validation and Regeneration

```bash
bash .highway/tools/validate-skill.sh .highway/skills/highway-profile
bash .highway/tools/generate-agent-adapters.sh
bash .highway/tools/generate-catalog.sh
git diff --check
```

## Full Suite

```bash
bash .highway/tools/tests/run-all.sh
```

Expected outcome: the complete repository suite exits successfully with zero failures.

## Evidence Boundary

These checks establish static document and generated-correspondence properties. They do not by themselves prove how an agent behaves in a live conversation; runtime conversational evaluation remains outside this feature's validation claim.
