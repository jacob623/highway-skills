# Profile Owner Contract

## Authority

`/highway-profile` owns Profile evidence, five domain outcomes, readiness, mutations, persistence, and the authoritative artifact at `.highway/library/knowledge/profile.md`.

## Readiness output

The owner emits exactly four lines:

```text
Status: <Complete, Missing, or Blocked>
Summary: <Profile readiness explanation>
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

Readiness is read-only and evaluates only the persisted Markdown artifact.

## Persistence boundary

Setup and Configure proposals remain transient until acceptance. Successful writes are structurally validated and byte-verified before completion. Legacy YAML is ignored and cannot influence behavior.

## Mutation boundary

Add, Update, Remove, and Reset validate and preview the proposed change, request confirmation, preserve bytes on failure or decline, and report domain/readiness transitions.
