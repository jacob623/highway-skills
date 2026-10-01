# Feature 116 Validation Guide

## Prerequisites

Run from the repository root on macOS or another environment with Bash 3.2-compatible tools. No package installation is required.

```bash
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

## Pre-change baseline

Before implementation, confirm the repository is clean for the existing contract:

```bash
bash .highway/tools/tests/run-all.sh
```

Expected result: the current repository suite passes before Feature 116 implementation begins.

## Focused contract validation

After updating the Profile skill and its tests, run the focused checks:

```bash
bash .highway/tools/tests/profile-behavior.test.sh
bash .highway/tools/tests/profile-structure.test.sh
bash .highway/tools/tests/profile-context-contract.test.sh
bash .highway/tools/tests/profile-template-migration.test.sh
bash .highway/tools/tests/constitution-profile-context.test.sh
bash .highway/tools/tests/feature-092-contract.test.sh
```

Expected result: the checks require the one-time introduction ordering and suppression, cohesive paragraph recommendations for all three enrichment domains, evidence-only grounding, hidden categories, acceptance/state transitions, canonical fallback, save-before-result persistence, retained completion synthesis, schema 3.0.0, and the exact Experience Standard sentence.

## Generated artifact validation

Regenerate the Profile adapters and catalog artifacts from the authoritative source:

```bash
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-catalog.sh
```

Confirm every distributed Profile copy is identical to the source:

```bash
diff .highway/skills/highway-profile/SKILL.md .github/skills/highway-profile/SKILL.md
diff .highway/skills/highway-profile/SKILL.md .claude/skills/highway-profile/SKILL.md
diff .highway/skills/highway-profile/SKILL.md .cursor/skills/highway-profile/SKILL.md
diff .highway/skills/highway-profile/SKILL.md .agents/skills/highway-profile/SKILL.md
```

Expected result: each `diff` command produces no output and exits 0; catalog entries report version 5.1.0.

## Full validation

```bash
bash .highway/tools/tests/run-all.sh
git diff --check
```

Expected result: the complete repository suite exits 0, generated artifacts remain synchronized, and no whitespace errors are reported. The feature does not edit the constitution, Experience Standard, Setup, Objectives, Controls, NFRs, output templates, Highway Profile Intent Summary, or Brownfield Onboarding Idea.
