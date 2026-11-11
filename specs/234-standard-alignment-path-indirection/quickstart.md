# Quickstart: Standard Alignment Path Indirection

Validation scenarios for spec 234. Run from the repository root. Run the bash suite outside the
sandbox, because tests write agent trees inside temporary copies.

## 1. Full suite and harness tests

```bash
bash .highway/tools/tests/run-all.sh
(cd harness && npm test)
```

Expected: every bash test passes, and the TypeScript tests pass.

## 2. Removed tests and fixtures are gone (User Story 1)

```bash
ls .highway/tools/tests | grep -E 'profile-yaml|path-integrity|feature-092-correspondence|profile-adaptive|runtime-contract-hygiene|experience-standard-amendment|feature-141'
ls .highway/tools/tests/fixtures/profile-092 .highway/tools/tests/fixtures/profile-091
```

Expected: the first command prints nothing. The second lists no `dependent-artifact-inventory.tsv`,
`impact-review.tsv`, or `adaptive-corpus.md`.

## 3. No exact version check remains (User Story 1)

```bash
grep -nE "'version: [0-9]+\.[0-9]+\.[0-9]+'|\*\*Version\*\*: |Version change: " .highway/tools/tests/*.test.sh
```

Expected: no match outside disposable fixture text a test writes itself. Then bump a skill's
`metadata.version` and its Example line in a scratch copy and run the suite: no test fails on the
number.

## 4. The check passes and can fail (User Story 4)

```bash
bash .highway/tools/tests/path-construction.test.sh
bash .highway/tools/tests/path-construction.test.sh --probe source-document; echo "exit $?"
bash .highway/tools/tests/path-construction.test.sh --probe source-document --neutralise; echo "exit $?"
```

Expected: pass; non-zero; zero. Then add a line such as `x="$REPO_ROOT/.highway/skills"` to a test,
run the check, and confirm it names that file and line. Remove the line.

## 5. Moving one location needs one edit (User Story 2, SC-004)

In a disposable copy of the repository:

1. Move `.highway/skills` to `.highway/skill-sources` and change only `HW_SKILLS` in the helper.
2. Run `validate-skill.sh` on one skill, `generate-catalog.sh`, and `adapter-coverage.test.sh`.
3. Move `nfr-record.md` to another folder and change only its `hw_template` arm.
4. Run `output-template.test.sh`.

Expected: every command passes with no other edit.

## 6. Harness reads the helper (User Story 3)

```bash
bash harness/bin/path-map.sh --location skills
bash .highway/tools/tests/harness-path-map.test.sh
```

Expected: `.highway/skills`, then a pass.

## 7. Distribution validates and nothing else changed

```bash
bash .highway/tools/tests/distribution-packaging.test.sh
bash .highway/tools/generate-agent-adapters.sh && bash .highway/tools/generate-catalog.sh && bash .highway/tools/generate-instructions.sh
git status --porcelain .claude .cursor .github .agents .highway/catalog AGENTS.md
```

Expected: pass, and no generated file changed.
