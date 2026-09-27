# Quickstart: Highway Setup NFR Handoff

## Prerequisites

Run from the repository root with the existing Highway shell toolchain:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

## Static contract validation

```sh
./.highway/tools/validate-skill.sh .highway/skills/highway-setup
```

Expected result: the canonical Setup skill passes validation.

## Focused behavior validation

```sh
bash .highway/tools/tests/highway-setup.test.sh
bash .highway/tools/tests/highway-setup-executable.test.sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
bash .highway/tools/tests/feature-092-contract.test.sh
```

Expected result: Setup preserves existing owner routing, validates Controls Action Result and
readiness ordering, covers both pre-delegation and post-collection Controls `Complete` paths,
emits the handoff only before an actual NFR interaction, suppresses it for terminal no-interaction
results and resumed work, and emits the new conclusion only after successful completion.

## Generated correspondence validation

After changing the canonical Setup skill, regenerate the distributed representations using the
repository's existing generator workflow, then run:

```sh
bash .highway/tools/tests/adapter-coverage.test.sh
bash .highway/tools/tests/feature-092-correspondence.test.sh
```

Expected result: all Setup adapters and generated catalogs/manifests match the canonical source.

## Full validation

```sh
./.highway/tools/tests/run-all.sh
```

Expected result: all applicable repository checks pass, including packaging, path integrity,
skill and library validation, generated correspondence, Experience Standard checks, and the
focused Setup behavior checks.

## Manual acceptance matrix

1. Existing Controls: pre-delegation Controls `Complete` plus NFR interaction -> one handoff.
2. New Controls: `Finished` plus fresh Controls `Complete` plus NFR interaction -> one handoff.
3. Active Controls: `Continue` -> no handoff and no NFR delegation.
4. Missing/Blocked Controls: no handoff and no later owner invocation.
5. Terminal NFR result with no interaction -> no manufactured NFR interaction and no handoff.
6. Resumed NFR work -> owner output unchanged and no repeated handoff.
7. Successful terminal owner results -> new conclusion, no old dashboard, `/highway-help` offered only.
8. Any failed or non-terminal required owner -> no successful conclusion.
