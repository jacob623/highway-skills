# Feature 115 Validation Guide

## Prerequisites

Run from the repository root on macOS or another environment with Bash 3.2-compatible tools. No package installation is required.

```bash
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

## Focused validation

Run the Profile contract and structural checks through Bash:

```bash
bash .highway/tools/tests/profile-behavior.test.sh
bash .highway/tools/tests/profile-structure.test.sh
bash .highway/tools/tests/profile-context-contract.test.sh
bash .highway/tools/tests/profile-template-migration.test.sh
bash .highway/tools/tests/constitution-profile-context.test.sh
```

Expected result: every focused test exits 0 and the behavior test requires recommendation-first acquisition, save-before-result, question-before-explanation, completion synthesis, and no obsolete question-first contract.

## Distribution validation

Confirm the source skill and all distributed copies are identical:

```bash
diff .highway/skills/highway-profile/SKILL.md .github/skills/highway-profile/SKILL.md
diff .highway/skills/highway-profile/SKILL.md .claude/skills/highway-profile/SKILL.md
diff .highway/skills/highway-profile/SKILL.md .cursor/skills/highway-profile/SKILL.md
diff .highway/skills/highway-profile/SKILL.md .agents/skills/highway-profile/SKILL.md
```

Expected result: all `diff` commands produce no output and exit 0. The source version is 5.0.0 and the retained template remains schema 3.0.0.

## Full validation

```bash
bash .highway/tools/tests/run-all.sh
```

Expected result: the complete repository test suite exits 0 with no regressions. The feature does not edit the constitution, Experience Standard, Setup, Objectives, Controls, NFRs, output templates, or stale follow-up documents.
