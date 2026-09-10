# Quickstart: Feature 032 Validation

## Prerequisites

Run from the repository root with the standard macOS shell toolchain. The tests must run with the
repository's Bash 3.2-compatible command set and must not require a package installation.

## 1. Establish the baseline

```sh
PATH=/usr/bin:/bin:/usr/sbin:/sbin /bin/bash .highway/tools/tests/run-all.sh
```

Expected result: the pre-change suite completes successfully. Record the baseline result before
editing behavioral tests, as required by the development constitution.

## 2. Run focused behavioral validation

```sh
PATH=/usr/bin:/bin:/usr/sbin:/sbin /bin/bash .highway/tools/tests/control-derived-nfr.test.sh
PATH=/usr/bin:/bin:/usr/sbin:/sbin /bin/bash .highway/tools/tests/relationship-integrity.test.sh
```

Expected result: both tests execute disposable-tree scenarios, including positive, rejection,
confirmation, determinism, preservation, and injected-failure cases, and leave no temporary probes.

## 3. Verify historical requirement coverage

```sh
PATH=/usr/bin:/bin:/usr/sbin:/sbin /bin/bash .highway/tools/tests/completion-coverage.test.sh
```

Expected result: Features 030 and 031 each have one coverage row per functional requirement, with no
missing or duplicate identifiers. Evidence status must distinguish executable behavior from structural
or documentation-only evidence.

## 4. Run the complete validation surface

```sh
PATH=/usr/bin:/bin:/usr/sbin:/sbin /bin/bash .highway/tools/tests/run-all.sh
git diff --check
```

Expected result: focused behavior, validators, packaging/correspondence checks, completion coverage,
and the full suite pass with zero failures. No temporary files remain and unrelated user-owned bytes
are unchanged.

## References

- Evidence categories and workflow cases: [behavioral-evidence.md](contracts/behavioral-evidence.md)
- Entities and validation rules: [data-model.md](data-model.md)
- Requirement mapping authority: `specs/030-control-derived-nfr-generation/coverage.md` and
  `specs/031-relationship-reconciliation-integrity/coverage.md`
