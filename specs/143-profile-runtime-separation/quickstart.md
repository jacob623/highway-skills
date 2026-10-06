# Feature 143 Validation Guide

## Prerequisites

Run from the repository root with the current Feature 143 branch and Bash-compatible shell tools.
No extension hooks or new dependencies are required.

Protected artifacts for this feature:

- `.highway/library/templates/output/profile-record.md`
- `.highway/governance/experience-standard.md`
- `.highway/governance/constitution.md`
- `.highway/library/knowledge/highway-identity.md`

## Focused Profile checks

After implementation, run the focused Profile contracts that cover the retained template, readiness,
acquisition, lifecycle, participation, structure, and recent runtime alignment:

```sh
for test_script in \
  .highway/tools/tests/profile-behavior.test.sh \
  .highway/tools/tests/profile-context-contract.test.sh \
  .highway/tools/tests/profile-lifecycle.test.sh \
  .highway/tools/tests/profile-markdown-contract.test.sh \
  .highway/tools/tests/profile-participation.test.sh \
  .highway/tools/tests/profile-structure.test.sh \
  .highway/tools/tests/profile-runtime-separation.test.sh \
  .highway/tools/tests/feature-092-contract.test.sh \
  .highway/tools/tests/feature-122-profile-experience-synchronization.test.sh \
  .highway/tools/tests/feature-134-profile-contribution-opportunity.test.sh \
  .highway/tools/tests/feature-136-profile-substantive-re-evaluation.test.sh \
  .highway/tools/tests/feature-137-profile-acquisition-expression-persistence.test.sh \
  .highway/tools/tests/feature-138-visible-profile-structure.test.sh \
  .highway/tools/tests/feature-140-profile-convergence-alignment.test.sh; do
  bash "$test_script" || exit 1
done
```

Expected outcomes:

- Current-state readiness has Missing, Blocked, and Complete behavior without historical-schema branches.
- The four Profile domains and `not_discussed`/`discussed`/`bounded` semantics remain intact.
- Acquisition evidence remains proposed until acceptance and can inform multiple unresolved domains.
- Organizational expression affects representation only and is not retained.
- Domain completeness remains distinct from Experience Standard convergence.
- Acceptance precedes successful owner mutation and dependent output.
- Protected artifacts are unchanged.

## Generated adapter correspondence

After editing `.highway/skills/highway-profile/SKILL.md`, regenerate the declared agent adapters using
the repository's existing generator, then verify correspondence:

```sh
.highway/tools/generate-agent-adapters.sh
bash .highway/tools/tests/adapter-coverage.test.sh
```

The generated copies must remain aligned with the source skill. Do not hand-edit generated copies.

## Full validation

```sh
.highway/tools/tests/run-all.sh
git diff --check
```

Expected result: all registered checks pass with zero failures, protected artifacts have no diff, and
no obsolete schema or YAML compatibility language remains in the active Profile skill.

Observed result for Feature 143: `run-all.sh` completed with `72 passed, 0 failed`.

## Manual semantic review

Review the final skill against [data-model.md](data-model.md) and verify:

1. `When not to use`, Outputs, Profile model, Verification, and Error Handling describe only the current Profile model.
2. `Domain model`, `Domain completeness`, and the four domain contracts contain Profile-specific meaning without copying generic interaction loops.
3. Acquisition preserves Repository Name setup, reusable-material opportunity, URL Context, source evidence boundaries, canonical fallback questions, and cross-domain evaluation.
4. Operations preserve explicit `bounded`, accepted mutation-before-dependent-output, failure stopping, guided completion synthesis, and supported operations.
5. The skill version follows the Constitution Skill Versioning Policy while the retained Profile schema remains unchanged.
