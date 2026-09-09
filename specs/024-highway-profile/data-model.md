# Data Model: Highway Organizational Profile

## Organizational Profile

The distributed, user-owned YAML artifact at `.highway/profile.yaml`.

| Field | Meaning | Required/validation |
|---|---|---|
| `metadata.version` | Profile schema/content version | Required; initial distributed value is `1.0.0` |
| `metadata.description` | Stable description of the profile's contextual purpose | Required; preserved as framework-owned metadata |
| `constraints` | Hard organizational boundaries | Optional; omitted when empty; values remain user-owned |
| `strategic_directions` | Organizational goals that influence recommendations | Optional; omitted when empty; values remain user-owned |
| `preferences` | Recommender preferences that may be overridden | Optional; omitted when empty; values remain user-owned |
| future sections | `business_context`, `architecture_principles`, `approved_technologies`, `prohibited_technologies`, `operating_model`, `vendor_strategy` | Optional extension points; preserve current top-level ordering |

### Structural invariants

- Top-level sections, when present, appear in this order: `metadata`, `constraints`, `strategic_directions`, `preferences`, followed by supported future sections in their declared extension order.
- `metadata` is first and contains `version` and `description`.
- Empty optional sections are omitted.
- No timestamp, random identifier, or environment-derived value is generated.
- User wording, capitalization, grouping, and value order are preserved unless the requested mutation changes them.
- Structural validation does not judge the semantic correctness of user values.

## Profile Node

A resolvable nested path such as `preferences.cloud.preferred`.

| Attribute | Meaning |
|---|---|
| category | Top-level or nested organizational concern |
| path | Exact location in the profile |
| values | Existing or proposed user-owned scalar/list/map content |
| operation | `add`, `update`, `remove`, or `reset` |

## Questionnaire Response

The set of answers collected by `setup` or `configure`. It is an input to a proposed profile, not a persisted intermediate artifact. Unanswered questions do not create inferred values.

## Mutation Preview

The transient confirmation object shown before any write.

| Field | Meaning |
|---|---|
| Action | Inferred operation name |
| File | `.highway/profile.yaml` |
| Summary | Human-readable description of the change |
| Current State | Existing value or node, when applicable |
| Proposed State | Resulting value or node |
| Affected Entries | Exact profile paths |
| Ramifications | Downstream impact of the change |
| Confirmation Status | Pending, Committed, or Declined |

## State transitions

- `Absent -> Proposed -> Committed` for confirmed setup.
- `Absent -> Proposed -> Declined` for declined setup; file remains absent.
- `Present -> Proposed -> Committed` for confirmed add/update/remove/reset.
- `Present -> Proposed -> Declined` for declined mutation; original bytes remain unchanged.
- `Malformed -> Error` for any action; no write is attempted.
- `Ambiguous -> Error` for an unresolved action/category/value; candidates are shown and no write is attempted.
