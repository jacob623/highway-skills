# Quickstart: Profile Collaborative Development

## Scope

This feature changes `.highway/skills/highway-profile/SKILL.md` and directly affected Profile contract
checks. It must not change `.highway/library/templates/output/profile-record.md`, schema version
`3.0.0`, the four retained domains, or shared governance documents.

Implementation record: protected paths are `.highway/library/templates/output/profile-record.md`,
`.highway/governance/constitution.md`, `.highway/governance/experience-standard.md`, and
`.highway/library/knowledge/highway-identity.md`. The protected Profile template baseline hash was
`7757aa2c935536877c1a28d14101ef31bbbac64663998d9de82611866e83482d`.

## Prerequisites

Run from the repository root with the repository's macOS-compatible Bash environment.

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

## 1. Validate protected Profile structure

Confirm the retained template remains unchanged in semantics:

```sh
grep -Fq 'schema_version: 3.0.0' .highway/library/templates/output/profile-record.md
grep -Fq 'identity: not_discussed' .highway/library/templates/output/profile-record.md
grep -Fq 'vision: not_discussed' .highway/library/templates/output/profile-record.md
grep -Fq 'competitive_path: not_discussed' .highway/library/templates/output/profile-record.md
grep -Fq 'guiding_principles: not_discussed' .highway/library/templates/output/profile-record.md
```

Expected outcome: all commands exit successfully.

## 2. Run focused Profile contracts

```sh
bash .highway/tools/tests/profile-behavior.test.sh
bash .highway/tools/tests/profile-lifecycle.test.sh
bash .highway/tools/tests/profile-structure.test.sh
bash .highway/tools/tests/profile-context-contract.test.sh
bash .highway/tools/tests/profile-participation.test.sh
bash .highway/tools/tests/feature-092-contract.test.sh
bash .highway/tools/tests/feature-122-profile-experience-synchronization.test.sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
```

Expected outcome: each test passes while asserting that Working Ideas remain transient, only
Converged Proposals cross acceptance, accepted knowledge persists before dependent results, and
Profile still preserves readiness and presentation contracts.

## 3. Check generated correspondence

When the Profile skill changes, run the repository's declared generators according to their normal
workflow and inspect the resulting diff. Generated adapters, catalogs, and manifests must remain
correspondent with the source skill; do not hand-edit generated artifacts.

Expected outcome: regeneration produces only the expected source-dependent updates and no orphan or
missing Profile entries.

## 4. Run the full suite

```sh
bash .highway/tools/tests/run-all.sh
```

Expected outcome: the complete repository suite exits `0` with no failures.

Validation result: `63 passed, 0 failed`.

## 5. Review scope and whitespace

```sh
git diff --check -- \
  .highway/skills/highway-profile/SKILL.md \
  .highway/tools/tests \
  .github/skills/highway-profile \
  .claude/skills/highway-profile \
  .cursor/rules/highway-profile.mdc \
  .codex/skills/highway-profile \
  .highway/catalog \
  .highway/tools/.adapter-manifest
```

Review that no changes touch `profile-record.md`, unrelated skills, schemas, or shared governance
artifacts.
