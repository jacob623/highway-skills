# Controls 4.0.0 Correction Contract

`highway-controls` remains version `4.0.0`.

The Proposal and Persistence section retains one revalidation paragraph beginning:

> Revalidate the authoritative baseline, catalog, allocation state, and final-proposal overlap before persistence.

The earlier duplicated paragraph beginning `Before allocation, revalidate the authoritative
baseline...` is absent.

The Error Handling section relies on the Constitution's common failure model and does not repeat
`A failed mutation cannot report success.`

The setup/configure collection result contains exactly:

```text
Action Status
Collection Result
Next Action
Blocking Reason
```

No `Created Control IDs` field is restored. A successfully created new Control invokes NFR-owned
candidate generation once; NFRs owns subsequent candidate state, review, persistence, and readiness.
