# Quickstart: Highway Profile Path Migration

This guide validates Feature 025 after implementation. It does not prescribe implementation bodies.

## Prerequisites

- Run from the repository root.
- Use the declared Bash 3.2.57-compatible toolchain.
- Use a disposable workspace for confirmed profile writes.

## 1. Validate the canonical profile and source skill

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-profile
.highway/tools/validate-profile.sh .highway/library/templates/output/profile.yaml
```

Expected result: both validators exit 0; the profile is pure YAML with the exact required schema.

## 2. Run the clean-migration audit

Run the focused migration/orphan test introduced for this feature.

Expected result: the canonical profile exists, `.highway/profile.yaml` is absent, and no former-path reference remains in source, tests, fixtures, catalogs, adapters, manifests, or distribution metadata.

Current implementation validation: `.highway/tools/audit-profile-migration.sh` and
`.highway/tools/tests/profile-migration.test.sh` both pass against the repository tree.

To prove the negative case, place a temporary former-path fixture or stale manifest reference in the disposable workspace and rerun the audit.

Expected result: the audit exits non-zero and identifies the orphan.

## 3. Validate the default schema

Inspect `.highway/library/templates/output/profile.yaml` and confirm:

- `metadata` is first with version `1.0.0` and the specified folded description
- `organization.name` and `organization.industry` are empty strings
- every remaining required section is present as an empty mapping
- no frontmatter, timestamps, random identifiers, or additional seeded values exist

## 4. Verify version maintenance

Against a disposable populated profile, exercise confirmed and declined `add`, `update`, `remove`, and `reset` operations.

Expected result:

- confirmed add/update/remove increments PATCH
- confirmed reset increments MINOR
- schema-breaking release increments MAJOR
- declined, malformed, ambiguous, and aborted operations leave profile bytes and version unchanged

## 5. Regenerate and validate distribution correspondence

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-distribution.sh
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/library-containment.test.sh
.highway/tools/tests/run-all.sh
```

Expected result: the canonical profile is packaged exactly once, the former path is not packaged, generated catalogs/adapters/manifests agree with source inputs, and the full suite exits 0.

## 6. Check deterministic migration output

Repeat the audit and generation checks without changing inputs.

Expected result: no stale path appears, profile values remain unchanged, and no migration-specific timestamp or random identifier is introduced.
