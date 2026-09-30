# Data Model: Final NFR Contract Cleanup

## NFR Skill Contract

The canonical runtime contract at `.highway/skills/highway-nfrs/SKILL.md`.

### Invariants

- Version remains `11.0.0`.
- Direct NFR capture bypasses inferred-content review but not validation or persistence safeguards.
- Explicit recommendation selection is acceptance without redundant review.
- Materially interpreted user-authored input uses the exact captured-NFR review.
- Readiness and active collection completion remain separate.

## NFR Candidate State

Persisted at `.highway/catalog/nfr-candidate-state.md` and owned by NFRs.

### State responsibilities

- Associate candidates with the originating immutable `CTLXXXXXX`.
- Preserve ordered candidate content.
- Preserve each candidate decision before advancing.
- Resume from the first unresolved candidate.
- Supply the state needed to determine NFR readiness.

### State transitions

`Pending` → `Accept|Modify|Replace|Reject|Cancel`

The transition is persisted before the next candidate is presented. A blocked or inconsistent state
does not mutate accepted NFR records.

## NFR Record

User-owned records follow `.highway/library/templates/output/nfr-record.md`.

### Retained structure

- Frontmatter: `id`, `title`, `status`, `controls`.
- Body: accepted NFR statement and accepted evidence-grounded rationale.
- Direct NFRs: `controls: []`.
- Control-derived NFRs: immutable `CTLXXXXXX` relationship identifiers.

Recommendation Grounding is not an NFR-record field and is not copied from the originating Control.

## Owner Results

### Readiness

`Status`, `Summary`, `Next Action`, and `Blocking Reason`, with statuses `Complete`, `In Progress`,
`Blocked`, and `Not Applicable`.

### Collection

`Action Status`, `Collection Result`, `Next Action`, and `Blocking Reason`. No created-NFR-ID list
is part of this result.
