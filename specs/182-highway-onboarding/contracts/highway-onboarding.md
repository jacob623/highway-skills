# Contract: highway-onboarding

## Invocation

`/highway-onboarding` takes no required command argument or environment description. It loads declared accepted repository context, then asks only for missing evidence at the next validation boundary.

## Interaction contract

1. Present one concise sentence summarizing accepted capability coverage.
2. Present grounded missing-capability proposals in business language, each marked provisional.
3. Ask exactly: **What would you add, correct, or remove?** Accept additions, corrections, removals, or uncertainty without treating uncertainty as acceptance.
4. Process accepted capabilities one at a time. Present business purpose before requesting the current platform or process.
5. Preserve every requester-supplied mapping, including custom processes, explicit unknowns, multiple mappings, and optional primary mappings.
6. Group mappings by provider for review only. Do not create provider, application, technology, or landscape records.
7. Process one provider group at a time. Present capabilities, grounded alternatives, rationale, and limitations as a proposed pre-existing ADR.
8. Ask the same correction-oriented question before ADR acceptance. Requests for examples or more information do not count as acceptance.

## ADR handoff contract

On acceptance, create the ADR directly from `.highway/library/templates/output/adr-record.md` and `.highway/library/templates/output/adr-catalog.md` with the stabilized proposal, accepted mappings, grounding, and provenance. Onboarding owns identifier allocation, record structure, acceptance, validation, and atomic persistence for this path. Do not require or fabricate Discovery or option identifiers.

The direct onboarding path writes exactly one scalar `request: onboarding` value and one scalar
`discovery: highway` value. It creates a normal ADR record, not an onboarding-specific artifact.

## Downstream orchestration contract

```text
ADR success -> Architecture(owner input = ADR id)
Architecture success -> Implementation(owner input = Architecture id)
Any failure -> stop before next owner
```

For Architecture or Implementation failures, retry the failed owner no more than three times. After the third failure, preserve prior durable results, report the failed boundary and last successful result, and expose manual resume from that owner. Resume never repeats successful owner mutations.

A successful final summary is only: `Platform -> ADR -> Reference Architecture -> Reference Implementation`. It does not expose catalogs, allocation state, internal owner results, or processing details.

## Routing contract

Requests for ADR behavior outside this direct onboarding path route to the existing Discovery-based `highway-adr` workflow. Requests for Architecture, Implementation, Controls, NFRs, or relationships outside this flow route to their owning workflows. Onboarding performs no downstream mutation for unrelated requests.

## Failure and no-write contract

Working Ideas, rejected findings, unknown values, unavailable sources, and unaccepted rationale are not durable accepted knowledge. If the required owner mutation fails, onboarding does not claim completion. A failure before ADR persistence creates no onboarding-owned substitute artifact.
