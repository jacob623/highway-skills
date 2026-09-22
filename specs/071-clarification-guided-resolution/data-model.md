# Data Model: Clarification Guided Resolution Workflow

## Finding Guidance

| Field | Meaning | Validation |
|---|---|---|
| `Finding` | Existing deterministic finding summary | Required for every finding; identity remains unchanged |
| `Question` | One deterministic question describing the decision needed | Exactly one for every open finding; retained after resolution |
| `Why It Matters` | One deterministic consequence explanation | Exactly one for every open finding; retained after resolution |
| `Recommended Option` | First advisory option | Derived from highest-precedence evidence, or `Unknown / Escalate for Decision` when evidence is absent or conflicts |
| `Recommended Rationale` | Traceable explanation for the recommendation | Required and deterministic |
| `Alternative Option B` | First generated alternative | In a highest-precedence conflict, contains conflicting value 1 |
| `Alternative Option C` | Second generated alternative | In a highest-precedence conflict, contains conflicting value 2 |
| `Custom Option` | User-supplied answer path | Always present; never selected automatically |
| `Selected Option` | Informational user selection | Only `A`, `B`, `C`, `D`, or `None`; does not resolve a finding |
| `Response` | User-owned response candidate or accepted response | Defaults to `None`; only an explicitly accepted response resolves |
| `Evidence Sources` | Source references supporting guidance | Privacy-filtered, deterministic, and retained for traceability |

## Finding Lifecycle

```text
open --accepted response--> resolved
open --option selection--> open
open --custom candidate--> open
resolved --any update--> resolved
```

No other finding state or transition is supported. Resolved findings retain guidance, selection,
response, identifier, fingerprint, history, and evidence references.

## Guidance Source Precedence

The global precedence order is:

1. Source artifact
2. Clarification responses
3. Profile
4. Objectives
5. Controls
6. NFRs
7. Discovery
8. Reference Architectures
9. Reference Implementations

The artifact-specific source set is applied before evaluating this order:

- `REQ`: Request evidence, Profile, Objectives, Controls, NFRs
- `DISC`: Discovery Findings, Assumptions, Risks, Unknowns, Objectives, Controls, NFRs
- `ADR`: Discovery handoff, ADR context, selected candidate option
- `RA`: Architecture contents, Controls, NFRs, Objectives

Only declared sources participate. If the highest available precedence has contradictory values,
no value is recommended; the result is `Unknown / Escalate for Decision`, both source references
are recorded, conflicting values are alternatives B and C, and explicit selection is required.

## Record Invariants

- `total_findings = open_findings + resolved_findings`.
- Findings have stable identifiers and normalized fingerprints.
- Generated guidance is deterministic for identical inputs and contains no volatile metadata.
- Invalid selected options, unsupported states, privacy failures, conflicts, and validation failures produce no partial write.
- Source artifact bytes are unchanged by generation, selection, or accepted-response recording.
- Guidance remains advisory and cannot approve governance, architecture, recommendation, or ADR decisions.
