# Profile Migration Contract

## Canonical Artifact

The only authoritative profile path is:

```text
.highway/library/templates/output/profile.yaml
```

The former path `.highway/profile.yaml` must not exist or appear in repository or distribution metadata after migration.

## Required YAML Contract

The artifact is pure YAML with no frontmatter. Its top-level order is:

```text
metadata
organization
constraints
strategic_directions
preferences
business_context
architecture_principles
approved_technologies
prohibited_technologies
operating_model
vendor_strategy
```

The default version is `1.0.0`; `organization.name` and `organization.industry` are empty strings; all other required sections are empty mappings; and the specified folded description is retained.

## Audit Contract

The migration audit returns success only when:

- the canonical profile exists;
- the former profile path is absent;
- no former-path reference exists in source, tests, fixtures, catalogs, adapters, adapter manifests, distribution manifests, or other distribution metadata; and
- packaging includes the canonical profile exactly once.

A stale artifact or reference causes failure and identifies the offending path or record.

## Version Contract

Confirmed `add`, `update`, and `remove` operations increment PATCH. A confirmed `reset` increments MINOR. A schema-breaking release increments MAJOR. Declined or failed operations do not change content or version.
