# Data Model: Highway NFR Management

**Feature**: 020-highway-nfrs | **Date**: 2026-09-08

The model has two ownership layers: Highway owns the skill and its generated distribution
artifacts; the repository user owns the root-level NFR baseline and records.

## Boundary

```text
<project>/
├── .highway/                         <- Highway-governed framework
│   ├── skills/highway-nfrs/SKILL.md  <- shipped authoring skill
│   ├── skills/highway-controls/      <- reciprocal routing guidance
│   └── tools/                        <- generators, validators, tests
└── library/governance/               <- user-owned governance
    ├── nfrs.md                       <- generated catalog
    └── nfrs/NFRXXXXXX.md              <- individual NFR records
```

## Entities

### NFR

One file at `library/governance/nfrs/NFRXXXXXX.md`, with YAML frontmatter and a Markdown body.

| Field | Constraint | Owner |
|---|---|---|
| `id` | `NFR` plus exactly six digits; allocated once, immutable, never reused | Skill allocates; immutable thereafter |
| `title` | Human-readable name; included in loss notices and catalog index | User |
| `status` | User-owned lifecycle value; preserved unless explicitly changed | User |
| `controls` | Reserved list, present and empty in this phase | Reserved for future relationship management |
| statement | Desired quality attribute, operational characteristic, constraint, or outcome | User |
| rationale | Why the NFR exists | User |

An NFR has no per-item version. The baseline catalog is the only version authority.

### NFR baseline

The complete set of NFR records, managed as one semantic version. Successful actions increment it
exactly once:

| Action | Version increment |
|---|---|
| Add | MINOR |
| Update without changing the obligation | PATCH |
| Remove | MAJOR |
| Set replacement | MAJOR |

### NFR catalog

`library/governance/nfrs.md`, generated prose containing:

- the repository-wide baseline statement
- global applicability unless a consuming artifact supersedes it
- the `/highway-nfrs` management instruction
- the direct-edit warning
- the baseline semantic version
- the `next_id` high-water mark
- an index of every NFR

The catalog has no timestamp. Its content is a function of the baseline records, version, and
recorded next identifier.

### Identifier high-water mark

`next_id` in the catalog is the authority for allocation.

```text
next_id in catalog
    |
    +-- Add: consume it, then advance it
    +-- Update: leave it unchanged
    +-- Remove: leave it unchanged
    +-- Set: allocate only new records and never lower it
```

If the catalog is absent while NFR files exist, mutation aborts. The highest present file cannot
prove the highest identifier ever issued.

### Control relationship placeholder

The NFR's `controls` list and the Control's reserved `nfrs` list are reciprocal placeholders. Both
remain empty in this feature. Relationship ownership and link validation are intentionally not
modelled until a later phase decides which side writes links.

## Validation rules

| ID | Constraint | Source |
|---|---|---|
| V1 | NFR files are under root `library/governance/nfrs/`, never `.highway/` | FR-001, FR-004 |
| V2 | Root-level NFR content is outside Highway library validation and catalogs | FR-002, FR-003 |
| V3 | Every NFR uses `NFRXXXXXX` and the identifier is stable and never reused | FR-012, FR-013 |
| V4 | `next_id` is read from the catalog and never reconstructed from files | FR-014, FR-029 |
| V5 | Every record has `id`, `title`, `status`, `controls`, statement, and rationale | FR-006, FR-007, FR-030 |
| V6 | No NFR has an individual version | FR-008 |
| V7 | Destructive actions name every lost NFR by ID and title before confirmation | FR-018, FR-019 |
| V8 | Refused confirmation leaves all files, version values, and high-water marks unchanged | FR-021 |
| V9 | Exactly one baseline version increment occurs per successful action | FR-016 through FR-020 |
| V10 | The catalog is deterministic and timestamp-free | FR-010, FR-011 |
| V11 | Control-shaped statements route to `/highway-controls`; outcome-shaped statements route to `/highway-nfrs` | FR-023, FR-026 |

## State transitions

```text
             Add                 Update                 Remove
    (none) ---------> active --------------------------> (retired)
                         |                                  |
                         | id fixed for life                | id never reissued
                         +----------------------------------+

    Set: existing baseline --confirmed replacement--> replacement baseline
```

`status` is not constrained to a fixed vocabulary in this phase. The model tracks record existence,
identity, mutation, and retirement because those properties protect references and versioning.

## Deliberately not modelled

| Not modelled | Why |
|---|---|
| Whether an NFR is achieved by a solution | This skill manages declarations, not compliance evidence |
| Whether an NFR is sufficiently specific | The skill advises and offers alternatives; it does not refuse the author's choice |
| NFR-to-Control links | Reserved fields only; relationship ownership is deferred |
| Per-NFR history | Repository history already records file changes |
| Citation resolution after removal | External references cannot be reliably discovered here |
