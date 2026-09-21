# Data Model: Highway Clarify

## Source Artifact

The authoritative artifact being analyzed.

| Field | Meaning | Validation |
|---|---|---|
| `artifact_id` | Exact uppercase identifier such as `REQ000001` | Matches exactly one supported family and six digits. |
| `artifact_type` | `REQ`, `DISC`, `ADR`, or `RA` | Derived from the identifier family. |
| `source_path` | Resolved user-owned path | Comes only from declared path, catalog, or identifier lookup. |
| `source_bytes` | Original source content | Read-only; must remain unchanged after every command. |

## Artifact Resolution Record

The deterministic mapping from an identifier to one source artifact.

- Resolution precedence is explicit in the analysis contract.
- Duplicate or ambiguous mappings fail without scanning by recency or filesystem order.
- Lowercase and mixed-case identifiers fail before lookup.
- Future families are additive and require their own declared mapping.

## Clarification Artifact

A colocated Markdown record with YAML frontmatter and structured body sections.

| Field | Meaning | Validation |
|---|---|---|
| `id` | Clarification identifier derived from source identifier | Stable identifier such as `CLAR-REQ000001`. |
| `artifact_id` | Source identifier | Matches the resolved source exactly. |
| `artifact_type` | Source family | Matches the source resolution record. |
| `source_path` | Source artifact path | Matches deterministic resolution. |
| `status` | `not-started`, `in-progress`, `complete`, or `blocked` | Derived from artifact existence, finding state, and parse validity. |
| `revision` | Integer optimistic-concurrency version | Starts at `1`; successful Update increments exactly once. |
| `blocking_reason` | Reason for malformed or blocked state | Required for `blocked`; otherwise `None`. |
| `generated_at` | Optional descriptive metadata | Must not influence identity, resolution, ordering, or conflict decisions. |

## Finding

One evidence item requiring clarification.

| Field | Meaning | Validation |
|---|---|---|
| `finding_id` | Stable identifier within the artifact | Unique and deterministic for unchanged evidence. |
| `category` | One of five analysis categories | Uses exact priority order: contradiction, missing_input, unknown_value, ambiguity, unresolved_assumption. |
| `severity` | Finding impact | `high`, `medium`, or profile-declared value. |
| `evidence_ref` | Source location or evidence identity | Required and stable for repeat analysis. |
| `summary` | Concise finding statement | Must identify the unresolved issue. |
| `state` | `open` or `resolved` | Derived from response history. |
| `response` | Latest accepted response | Required when resolved; absent while open. |

## Clarification Response

A response associated with one finding.

- Targets exactly one existing `finding_id`.
- Is validated before staging.
- Does not modify the source artifact.
- A privacy-blocked or invalid response produces no write.

## Resolution History Entry

An append-only record of a successful response update.

| Field | Meaning |
|---|---|
| `finding_id` | Finding resolved or updated |
| `response` | Accepted response value |
| `revision` | Revision committed with the response |
| `actor` | Repository user or workflow identity when available |

History is appended only after revision validation succeeds. Conflicting updates append nothing.

## Status Transitions

```text
(no clarification artifact) -> not-started
valid artifact with open findings -> in-progress
valid artifact with zero findings or all findings resolved -> complete
malformed artifact -> blocked
```

Status is advisory and never prevents downstream source consumption.
