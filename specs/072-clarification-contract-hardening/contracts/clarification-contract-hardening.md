# Clarification Contract Hardening Contract

## Command Surface

Feature 072 preserves the existing Clarification command forms:

- `/highway-clarify <ARTIFACT-ID>` generates deterministic guidance.
- `/highway-clarify update <ARTIFACT-ID>` records selection or an explicitly accepted response.
- `/highway-clarify inspect <ARTIFACT-ID>` reports status and counts without writing.
- `/highway-clarify read <ARTIFACT-ID>` returns the complete validated record without writing.
- `/highway-clarify status <ARTIFACT-ID>` returns the lightweight consumer response without writing.

## Version and Identity

- The canonical skill and retained clarification-record template declare version `2.0.0`.
- Every finding category agrees with the category segment of its fingerprint.
- A mismatch is invalid and produces no partial write.

## Two-Stage Recommendation Selection

1. Select the source set for the finding artifact type.
2. Apply the global Recommendation Precedence order only to selected sources.

Artifact-specific sets:

- `REQ`: Request, Profile, Objectives, Controls, NFRs.
- `DISC`: Discovery Findings, Assumptions, Risks, Unknowns, Objectives, Controls, NFRs.
- `ADR`: Discovery handoff, ADR context, selected candidate option.
- `RA`: Architecture contents, Controls, NFRs, Objectives.

Global precedence, highest first: Source artifact, Clarification responses, Profile, Objectives, Controls, NFRs, Discovery, Reference Architectures, Reference Implementations. Non-member sources are ignored.

## Recommendation States

- `Unknown`: no authoritative evidence exists in the selected source set. The rationale identifies the evidence gap.
- `Unknown / Escalate for Decision`: authoritative evidence exists at the highest applicable precedence but conflicts. No conflicting value is Recommended; conflicting values become traceable alternatives and require explicit A/B/C/D Custom selection.

## Evidence Traceability

Every evidence-backed recommendation or alternative includes:

- Source Type
- Source Identifier
- Reason Used

## Escalation Ownership

- `REQ` -> Request owner.
- `DISC` -> Discovery consumer or responsible architect.
- `ADR` -> ADR decision authority.
- `RA` -> Reference Architecture owner.

Escalation ownership is advisory and does not modify source artifacts.

## Option Selection Lifecycle

Selecting A, B, C, or D records Selected Option only. It does not create a Response or resolve a finding. A user may provide or accept a Response afterward. Only an explicitly accepted Response may perform `open -> resolved`; Response remains authoritative. Resolved findings do not reopen.

## Consumer Contract

Consumers may use Question, Why It Matters, Response, Selected Option, and Status. Consumers must not treat Recommended Option or Alternative Options as authoritative decisions. Generated options are advisory guidance only.

## Ownership Verification

Verification must confirm that guided resolution:

- Never approves a governance decision.
- Never selects an architecture.
- Never resolves a finding automatically.
- Never changes Discovery recommendations.
- Never changes ADR decisions.
- Never modifies source artifacts.

## Failure Contract

Version mismatch, fingerprint/category mismatch, incomplete traceability, invalid selections, unsupported conflicts, ownership violations, privacy failures, and revision conflicts produce no partial write. Existing finding states, counts, history, privacy filtering, and source immutability remain authoritative.
