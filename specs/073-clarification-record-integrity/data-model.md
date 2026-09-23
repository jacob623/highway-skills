# Data Model: Clarification Record Integrity

## Clarification Record Frontmatter

| Field | Meaning | Validation |
|---|---|---|
| `id` | Stable clarification record identifier | Present exactly once in one delimited frontmatter block |
| `artifact_id` | Owning artifact identifier | Present and consistent with the record |
| `artifact_type` | `REQ`, `DISC`, `ADR`, or `RA` | Supported value |
| `source_path` | Source artifact path | Retained as metadata; source remains immutable |
| `status` | Record lifecycle status | Present in frontmatter and not duplicated in body metadata |
| `revision` | Record revision | Present and incremented by existing revision rules |
| `open_findings` | Count of open findings | Consistent with finding state |
| `resolved_findings` | Count of resolved findings | Consistent with finding state |
| `total_findings` | Total finding count | Equals open plus resolved findings |
| `blocking_reason` | Current blocking explanation | Present even when no blocking reason applies |

## Finding Identity

| Field | Meaning | Validation |
|---|---|---|
| `finding_id` | Stable `CLAR-<ARTIFACT-ID>-NNN` identifier | Unique within the record and referenced exactly by history |
| `category` | Finding category | Required and consistent with fingerprint |
| `fingerprint` | Normalized finding identity | Canonically aligned with other finding fields; no extra indentation |
| `artifact_type` | Owning artifact family | One of `REQ`, `DISC`, `ADR`, or `RA` |
| `status` | Finding state | Open or resolved under existing lifecycle rules |

## Resolution History Entry

Each entry is a distinct list item containing:

- `Finding`
- `Response`
- `Revision`
- `Actor`

The Finding value must reference exactly one finding in the record and must not be repeated within Resolution History.

## Evidence Source

Each source is a separate list item containing:

- `Source Type`
- `Source Identifier`
- `Reason Used`

When there are no sources, the field contains `None`.

## Recommendation Basis and State

| Recommendation Basis | Recommendation State in `Recommended Option` | Meaning |
|---|---|---|
| `authoritative` | Evidence-backed recommendation | A single authoritative value determined the guidance |
| `evidence-gap` | `Unknown` | No authoritative evidence exists in the eligible source set |
| `conflict` | `Escalate for Decision` | Authoritative evidence conflicts at the applicable precedence |

Basis and state are deterministic and advisory for all four artifact types.

## Option Selection Lifecycle

| Event | Selected Option | Response | Finding state |
|---|---|---|---|
| Initial finding | `None` | `None` | `open` |
| User selects A/B/C/D | Selected value | Unchanged | `open` |
| Candidate response supplied | Selected value or `None` | Candidate response | `open` |
| Accepted response | Selected value or `None` | Accepted response | `open -> resolved` |
| Existing resolved finding | Retained | Retained | `resolved` |

Selected Option is informational. Response remains authoritative; resolved findings do not reopen.

## Invariants

- The frontmatter block has one opening and one closing delimiter.
- Every Resolution History entry maps to one unique finding identifier.
- Every evidence source has all three traceability fields, or the field contains `None`.
- Recommendation Basis and Recommendation State use only the declared mappings.
- Invalid inputs produce no partial write and source bytes remain unchanged.
