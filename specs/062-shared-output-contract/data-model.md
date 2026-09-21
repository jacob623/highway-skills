# Data Model: Shared Output Contract Implementation

## Record Template

Represents the authoritative structure for one retained artifact record.

| Field | Description | Validation |
|---|---|---|
| Artifact identity | Stable template name and artifact family | Matches the retained baseline type and existing template naming convention |
| Frontmatter contract | Required metadata keys and placeholder values | Complete and consistent with current user-owned record behavior |
| Body sections | Ordered headings and body fields | Matches the canonical template; no skill-owned duplicate structure |
| Tables and lists | Column labels, ordering, and repeated-item layout | Stable ordering and complete placeholder coverage |
| Empty-state rules | Representation for absent optional evidence | Explicit, deterministic, and compatible with current output behavior |
| Retained shape | Complete serialized record layout | Validated by `validate-library.sh` and focused output-template checks |

## Catalog Template

Represents the authoritative structure for one retained artifact catalog.

| Field | Description | Validation |
|---|---|---|
| Artifact identity | Catalog template name and represented record family | Identifies Request, Objective, Control, NFR, or Discovery |
| Version | Baseline/catalog version representation | Preserves existing version semantics and formatting |
| Next identifier | Next ID allocation value | Preserves existing prefix, width, and allocation behavior |
| Index headings | Ordered catalog metadata and table headings | Matches current generated/user-owned catalog behavior |
| Index columns | Stable identifier, title, status, or equivalent fields | Complete and deterministically ordered |
| Ownership/layout | Catalog ownership statement and empty-state layout | Preserves current catalog semantics and template authority |

## Skill Output Contract

Represents the structural citations and behavioral guarantees owned by an emitting skill.

| Field | Description | Validation |
|---|---|---|
| Record citation | Path to the complete record template | Present for every emitted retained record |
| Catalog citation | Path to the complete catalog template | Present for every emitted retained catalog |
| Structural verification | Template-conformance assertion | References the cited template rather than duplicating shape |
| Behavioral workflow | Lifecycle, ownership, allocation, validation, and decision rules | Retained in the skill and validated by existing skill checks |

## Generated Artifact

Represents an adapter, catalog, or manifest derived from canonical source files.

- **Source**: canonical skill or shared template.
- **Derived forms**: GitHub Copilot, Claude Code, and Cursor adapters; skill and library catalogs; manifests.
- **Integrity rule**: regenerate after canonical changes and compare to a fresh disposable generation, ignoring only documented timestamps.

## Contract Validation Fixture

Represents a disposable valid or invalid source, template, or skill copy used to prove one deterministic rule.

- **Valid fixture**: accepted by the focused contract check.
- **Invalid fixture**: independently rejected for one targeted defect.
- **Isolation rule**: fixtures live in temporary workspaces and leave canonical source, user-owned records, and generated artifacts byte-for-byte unchanged.

## Relationships

```text
Record Template 1 ---- 1 Catalog Template
       |
       | cited by
       v
Skill Output Contract ---- preserves ----> Behavioral Contract
       |
       | generates
       v
Generated Artifact
       ^
       |
Contract Validation Fixture proves source/derived integrity without mutation
```

## Lifecycle

1. Inventory current canonical templates, catalogs, and emitting skills.
2. Create or normalize the authoritative templates without changing user-owned paths or semantics.
3. Update skill citations and remove duplicated structural declarations.
4. Validate canonical templates and behavioral preservation with disposable fixtures.
5. Regenerate derived adapters/catalogs/manifests.
6. Verify correspondence and complete repository validation.
