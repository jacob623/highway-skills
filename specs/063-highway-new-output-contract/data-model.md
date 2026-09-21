# Data Model: Highway New Shared Output Contract Migration

## Request Record Template

Represents the authoritative serialized structure for one user-owned Request record.

| Field | Description | Validation |
|---|---|---|
| Artifact identity | Request record template and `REQ` artifact family | Path and identifier match the existing Request contract |
| Frontmatter contract | Required metadata and lifecycle values | Validated against `request-record.md` and existing status semantics |
| Evidence sections | Seven evidence-domain representations and completeness | Shape belongs to the template; completeness behavior belongs to `highway-new` |
| Solution Constraints | Ordered constraint fields and empty/unknown representations | Shape belongs to the template; accepted values and handoff behavior remain in the skill |
| Privacy-safe content | Written evidence after secret/regulated-data screening | Blocked data is excluded and replacement handling remains behavioral |

## Request Catalog Template

Represents the authoritative serialized structure for the user-owned Request catalog.

| Field | Description | Validation |
|---|---|---|
| Catalog identity | Request catalog path and represented record family | Matches `request-catalog.md` |
| Version | Catalog version representation | Preserves existing version semantics |
| Next identifier | Next `REQ` identifier allocation value | Exactly six digits and advances once after successful creation |
| Index row | Request identifier and catalog-owned summary fields | Matches the complete catalog template |
| Ownership/layout | Catalog ownership statement and empty-state layout | Template conformance, not duplicated skill shape prose |

## Highway New Behavioral Contract

Represents the skill-owned rules that operate on the two template-owned outputs.

| Behavior | Required property | Validation |
|---|---|---|
| Evidence intake | Seven domains, one question at a time, first incomplete domain selected | Focused skill checks and disposable probes |
| Privacy | Secrets and regulated personal data are excluded; blocked replacement writes nothing | Privacy probes and no-write assertions |
| Determinism | Same input yields same questions, examples, title, and artifact content | Repeated-input comparison |
| Allocation | Valid `REQ` next ID, bounded retries, exactly-once successful advancement | Allocation and conflict probes |
| Transaction | Record and catalog are prepared and validated before either is written | Failure byte-preservation probes |
| Discovery handoff | Solution Constraints limit candidate space without selecting architecture or creating Discovery/ADR artifacts | Behavioral contract checks |

## Generated Adapter

Represents the derived highway-new skill distributed to GitHub Copilot, Claude Code, and Cursor.

- **Source**: `.highway/skills/highway-new/SKILL.md`.
- **Integrity rule**: regenerate from canonical source and validate correspondence; do not hand-edit.

## Contract Validation Fixture

Represents a temporary valid or invalid copy used to prove one contract rule.

- **Valid fixture**: contains both complete template citations and retained behavior.
- **Invalid fixture**: changes one targeted citation, structural duplication, or behavior token.
- **Isolation rule**: fixture runs leave canonical skills, templates, generated adapters, and
  user-owned Request data byte-for-byte unchanged.

## Relationships

```text
Request record template 1 ---- 1 Request catalog template
          ^                         ^
          | cited by                | cited by
          +------ Highway New behavioral contract ------+
                                      |
                                      | generates
                                      v
                              Generated adapters
```

## Lifecycle

1. Read the canonical Request templates and `highway-new` behavior.
2. Replace duplicated structure prose with complete template citations.
3. Replace duplicated shape verification with template-conformance verification.
4. Run independent disposable contract probes and byte-preservation checks.
5. Regenerate adapters from the canonical skill.
6. Validate correspondence, packaging, and the full repository suite.
