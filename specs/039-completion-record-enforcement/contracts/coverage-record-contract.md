# Coverage Record Contract

## Scope

Every completed feature directory from 021 onward, plus Feature 020, MUST contain `coverage.md`.
Features 001 through 019 are owned by Feature 040. This is a development record and is not shipped.

## Required form

```markdown
| Requirement | Outcome | Evidence |
|---|---|---|
| FR-001 | satisfied | path/to/artifact: concise evidence |
```

## Contract rules

- The header columns are exactly `Requirement`, `Outcome`, and `Evidence`, in that order.
- Each requirement declared in `spec.md` appears exactly once.
- No unknown requirement ID appears.
- `Outcome` is exactly `satisfied`, `deferred`, or `historical`.
- `historical` is valid only for Features 001 through 020.
- Every Evidence cell is non-empty.
- A `satisfied` row names an existing artifact.
- A `deferred` row names the reason and the feature or work that owns the deferral.
- A `historical` row names the completion record its claim carries forward from and implies no owner.
- A corrective relationship names the originating feature and revised requirement in the evidence.
- A requirement about runtime behavior names executed-behavior evidence, not only a static document-contract assertion.

## Historical correction form

```markdown
| FR-002 | deferred | Feature 020 requirement not satisfied; superseded by Feature 034 FR-001 |
```

The exact evidence wording may vary, but the originating requirement and superseding owner must be
unambiguous.
