# Contract: onboarding ADR record creation

## Ownership

`highway-onboarding` directly creates a standard ADR after the requester accepts the stabilized
proposal. The existing `highway-adr` workflow remains the separate Discovery-based ADR owner and is
not extended for onboarding.

## Inputs

- accepted pre-existing ADR proposal;
- accepted capability mappings and grounding;
- requester contribution/acceptance record;
- onboarding provenance values;
- shared ADR record and catalog output structures.

## Output

Onboarding allocates the normal ADR identifier and persists the existing ADR record structure using
the shared templates. Provenance is one-to-one and always scalar. Minimum onboarding provenance is:

```yaml
request: onboarding
discovery: highway
```

Onboarding does not allocate a synthetic Request or Discovery record and does not emit a parallel ADR type.

## Acceptance and failure

Onboarding determines whether the proposal is accepted and persisted. It may invoke Architecture only after ADR persistence returns success and a durable ADR identifier. On failure, it returns a user-relevant failure result and no successful downstream handoff is permitted.

## Compatibility requirement

All existing Discovery-based ADR tests and output validation remain valid. Direct onboarding creation must not relax or reinterpret the Discovery-based `highway-adr` inputs, provenance, or mutation boundaries.
