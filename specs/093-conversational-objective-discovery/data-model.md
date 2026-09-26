# Data Model: Conversational Objective Discovery

## Objective Discovery Conversation

Transient owner-controlled interaction state for one invocation.

- **Evidence:** User-provided outcome, success, significance, grouping, corrections, and adopted suggestions.
- **Context:** Relevant accepted Profile evidence, other declared context used for framing, and existing Objective artifacts used for overlap guidance.
- **State:** Collecting, proposal-ready, awaiting validation, overlap-resolution, completed, declined, abandoned, blocked, or failed.
- **Persistence:** Never persisted, resumed, or represented as a durable record.

## Objective Proposal

Transient complete interpretation awaiting one natural-language validation decision.

- **Fields:** Proposed title, Statement, Success Measures, and Rationale.
- **Readiness:** Outcome supports Statement, Success supports at least one measure, and Significance supports Rationale.
- **Rules:** One unresolved response-demanding question or decision at a time; corrections re-evaluate all affected evidence; identifier and catalog mechanics remain internal before confirmation.
- **Persistence:** No proposal metadata, dimension labels, evidence classifications, or conversation state is written.

## Objective Record

Durable user-owned Markdown record at `library/objectives/OBJXXXXXX.md`.

- **Fields:** `id`, `title`, `status`, `capabilities: []`, Statement, Success Measures, and Rationale.
- **Identity:** Permanent six-digit `OBJ` identifier allocated once from catalog `next_id` and never reused.
- **Authority:** Structural shape is defined by `.highway/library/templates/output/objective-record.md`.

## Objective Catalog

Durable user-owned baseline at `library/governance/objectives.md`.

- **Fields:** Semantic baseline version, authoritative `next_id`, deterministic Objective index, ownership warning, and direct-edit warning.
- **Invariants:** Every entry resolves to one record; identifiers are unique; `next_id` exceeds every allocated identifier; ordering is by permanent identifier.
- **Authority:** Structural shape is defined by `.highway/library/templates/output/objective-catalog.md`.

## Objective Readiness

Read-only classification of persisted baseline state.

| State | Condition | Next Action | Blocking Reason |
|---|---|---|---|
| Missing | No valid Objective baseline | `/highway-objectives setup` | `None` |
| Complete | At least one valid record, consistent catalog, valid `next_id` | `None` | `None` |
| Blocked | Malformed or inconsistent baseline | `None` | Non-empty reason |

Readiness always emits `Status`, `Summary`, `Next Action`, and `Blocking Reason` in that order.

## Repository Context

Declared context consumed only when relevant to the active decision.

- **Identity:** Behavioral framing only; no organizational Objective evidence.
- **Highway Vision:** Strategic traceability framing only; no unsupported organizational significance.
- **Highway Platform Objectives:** Highway-assistance evaluation only; no organizational Objective evidence.
- **Profile:** Accepted organizational evidence for suggestions, question framing, Significance interpretation, and proposed Rationale synthesis.
- **Existing Objective artifacts:** Accepted context for overlap and related guidance, not a declared context document and not an independent source of new organizational facts.

Malformed or unusable context is recorded and excluded after the owning workflow has made it available for consumption. An owner `Blocked` result for malformed authoritative state remains authoritative.

## State Transitions

```text
new invocation
  -> collect evidence
  -> ask one unresolved question/decision
  -> proposal-ready
  -> validate naturally
  -> revalidate baseline and overlap
  -> allocate identifier
  -> persist record + catalog
  -> verify both retained outputs
  -> report creation completed

proposal or collection interrupted
  -> no retained transient state
  -> later invocation starts from persisted readiness
```
