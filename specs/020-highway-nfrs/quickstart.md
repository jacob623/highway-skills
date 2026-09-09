# Quickstart: Validating Highway NFR Management

**Feature**: 020-highway-nfrs | **Date**: 2026-09-08

Run commands from the project root. The scenarios below are validation targets for the
implementation; they do not create a real user baseline in the repository.

## Prerequisites

```bash
.highway/tools/tests/run-all.sh
.highway/tools/validate-skill.sh .highway/skills/highway-nfrs
```

Expected: the suite is green before implementation work begins, and the new skill has no unchecked
Highway Constitution rules.

## 1. Root containment holds

Create a temporary root-level NFR record using the shape in [nfrs-skill.md](contracts/nfrs-skill.md),
then invoke the library validator with both path forms:

```bash
.highway/tools/validate-library.sh library/governance/nfrs/NFR000001.md 2>&1 | tail -1
.highway/tools/validate-library.sh "$(pwd)/library/governance/nfrs/NFR000001.md" 2>&1 | tail -1
```

Expected: both invocations decline the file as outside the framework root. The fixture tree under
`.highway/tools/tests/fixtures/library/` continues to validate as before.

## 2. Add and identifier high-water mark

```text
/highway-nfrs Add an NFR requiring systems to be highly available.
```

Expected: the skill creates `NFR000001.md`, sets `controls: []`, creates `nfrs.md`, and records
the next identifier. Remove that NFR through a confirmed Remove, then Add another.

Expected: the later NFR receives an identifier above the retired one, not the retired identifier.

## 3. Deterministic catalog

```bash
cp library/governance/nfrs.md /tmp/nfrs-before
# regenerate the catalog without changing any NFR
cmp /tmp/nfrs-before library/governance/nfrs.md && echo "catalog identical"
grep -Eiq 'generated[ _-]*at|timestamp' library/governance/nfrs.md && echo "unexpected timestamp" || echo "no timestamp"
```

Expected: the catalog is identical and contains no timestamp.

## 4. Destructive confirmation

```text
/highway-nfrs Set the global NFRs to: Systems must be reliable.
```

Expected: every NFR absent from the replacement is named by ID and title before confirmation. A
negative response leaves the NFR tree, catalog, version, and `next_id` unchanged. A confirmed Set
increments the baseline by exactly one MAJOR step.

## 5. Advice and reciprocal routing

```text
/highway-nfrs Add an NFR requiring administrative access to use MFA.
/highway-controls Add a requirement that systems remain highly available.
```

Expected: the first request identifies a Control and offers `/highway-controls`; the second
identifies an NFR and names `/highway-nfrs`. A vague NFR receives an improved alternative but can
still be recorded when the author keeps it.

## 6. Ambiguity safety

```text
/highway-nfrs Update the availability requirement.
/highway-nfrs Remove NFR999999.
```

Expected: the first request asks which NFR is intended and the second names the missing reference;
neither changes a file. If NFR files exist without a catalog, mutation also aborts rather than
reconstructing `next_id`.

## 7. Registration and final suite

```bash
grep -c 'highway-nfrs' .highway/catalog/index.json
ls .github/skills/highway-nfrs .claude/skills/highway-nfrs .cursor/rules/highway-nfrs.mdc 2>&1 | grep -c 'highway-nfrs'
grep -c 'highway-nfrs' .highway/tools/.adapter-manifest
grep -c 'highway-nfrs' .highway/tools/.distribution-manifest
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/run-all.sh
```

Expected: one catalog entry, three adapters, adapter-manifest rows, distribution-manifest rows,
and a passing complete suite. Generated output is current and root-level user NFR files appear in
none of Highway's catalogs.
