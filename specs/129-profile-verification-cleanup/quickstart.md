# Quickstart: Profile Verification Cleanup

## Scope

This feature changes only Verification language and the duplicate final Experience section in
`.highway/skills/highway-profile/SKILL.md`. It must not change the Profile record template, schema,
readiness semantics, shared governance authorities, or other Profile behavior.

## Prerequisites

Run from the repository root:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

No `.specify/extensions.yml` hooks are registered for this feature.

## 1. Verify protected Profile structure

```sh
grep -Fq 'schema_version: 3.0.0' .highway/library/templates/output/profile-record.md
grep -Fq 'identity: not_discussed' .highway/library/templates/output/profile-record.md
grep -Fq 'vision: not_discussed' .highway/library/templates/output/profile-record.md
grep -Fq 'competitive_path: not_discussed' .highway/library/templates/output/profile-record.md
grep -Fq 'guiding_principles: not_discussed' .highway/library/templates/output/profile-record.md
```

Expected outcome: all commands exit successfully and the protected template is unchanged.

## 2. Run focused Profile contracts

```sh
bash .highway/tools/tests/profile-behavior.test.sh
bash .highway/tools/tests/profile-lifecycle.test.sh
bash .highway/tools/tests/profile-structure.test.sh
bash .highway/tools/tests/profile-context-contract.test.sh
bash .highway/tools/tests/profile-participation.test.sh
bash .highway/tools/tests/profile-markdown-contract.test.sh
bash .highway/tools/tests/feature-092-contract.test.sh
bash .highway/tools/tests/feature-122-profile-experience-synchronization.test.sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
```

Expected outcome: every focused contract passes and recognizes Working Idea / Converged Proposal
boundaries without requiring a local acknowledgment stage, paragraph-only output, or numeric advisory
limit.

## 3. Regenerate and verify correspondence

```sh
bash .highway/tools/generate-agent-adapters.sh
bash .highway/tools/generate-catalog.sh
bash .highway/tools/generate-library-catalog.sh
bash .highway/tools/tests/feature-092-correspondence.test.sh
bash .highway/tools/tests/adapter-coverage.test.sh
bash .highway/tools/tests/path-integrity.test.sh
```

Expected outcome: generated Profile adapters, catalog entries, and manifests correspond to the source
skill; no generated artifact is hand-edited.

## 4. Run Grow Creative setup

Run the repository's Grow Creative setup workflow after focused behavioral testing. Confirm that the
Profile workflow demonstrates development of partial ideas, direct convergence of mature contributions,
clear Converged Proposal acceptance, contextual re-evaluation after acceptance, and natural transitions
when no useful contribution remains.

Expected outcome: setup completes without requiring a Profile redesign, and Profile is frozen for this
iteration before work moves to Objectives.
Validation result: the focused Profile behavior, lifecycle, context, participation, structure,
Markdown, ownership, synchronization, and UX contracts all passed. The repository has no separate
executable Grow Creative command; these contracts provide the repository-owned behavioral setup
coverage for partial ideas, direct mature convergence, acceptance boundaries, contextual
re-evaluation, and natural transitions. Profile is frozen for this iteration before Objectives.

## 5. Run the full suite

```sh
bash .highway/tools/tests/run-all.sh
```

Expected outcome: the complete repository suite exits `0` with no failures.

## 6. Review scope and whitespace

```sh
git diff --check -- \
  .highway/skills/highway-profile/SKILL.md \
  .highway/tools/tests \
  .github/skills/highway-profile \
  .claude/skills/highway-profile \
  .cursor/skills/highway-profile \
  .agents/skills/highway-profile \
  .highway/catalog \
  .highway/tools/.adapter-manifest \
  specs/129-profile-verification-cleanup
```

Review that `profile-record.md`, shared governance authorities, unrelated skills, and retained Profile
schema semantics remain unchanged. Confirm the final Profile skill has no duplicate final `### Experience`
section and no obsolete Verification checks.
