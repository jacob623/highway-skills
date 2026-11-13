# Orchestrate

### orchestrate

On the first provider, emit this before creating any records. Do not emit it again.

**Highway will now create your decision, reference architecture and implementation records.**

This is how Highway keeps track of your technology landscape.

Take the next provider on the provider queue. Hand it to each owner in this order, once each. Ask the person nothing yourself. Emit nothing else until every provider on the queue has its three records, except a title question an owner asks.

1. Follow `onboarding` in `highway-adr` with the provider, the capabilities it serves, the decision to adopt this provider for those capabilities, each alternative with why it is weaker for this organization, the rationale grounded in accepted Profile, Objectives, Controls, and NFRs, and what this provider does not cover, or `None`. Hold the ADR id it returns.
2. Follow `onboarding` in `highway-architecture` with that ADR id. Hold the `RA` id it returns.
3. Follow `onboarding` in `highway-implementation` with that `RA` id, the provider, and the capabilities it serves. Hold the `RI` id it returns.

When an owner says its record could not be written, or the ADR could not be updated to name the architecture, follow that owner's `onboarding` once more. When it still fails, keep the ADR and any earlier provider results. Say which record could not be written or named. Do not claim onboarding is complete. When the ADR cannot be written, do not hand off the architecture or the implementation. When the implementation cannot be written, the ADR names the architecture and no implementation exists.

When the person declines a title an owner asks for, keep the earlier records. Say which record was not written. Do not hand off the rest of this provider. Do not claim onboarding is complete.

When the caller named the return step `execution`, go to `execution` in `highway-implementation` after `highway-implementation` returns. Do not ask to configure. Do not continue the queue. When `highway-implementation` included the platform, emit:

**[Platform] is included as a platform highway can use in highway-codify proposals**

**Would you like to configure how highway-codify uses [Platform]?**

A yes adds [Platform] to the platforms to configure, in the order asked. Do not write that list. Any answer continues onboarding. When `highway-codify-config` started this onboarding for [Platform], do not ask this for [Platform]. Do not ask this for a platform that cannot start automation.

When the ADR, Reference Architecture, and Reference Implementation exist, remove this provider from the provider queue. When another provider remains, repeat `orchestrate` for that provider. When the queue is empty, go to `lineage`.

### lineage

Show one block for every completed provider, in the order they were created.

**[Provider]**

[ADR id] → [RA id] → [RI id]

[One sentence naming the capabilities this provider now covers.]

Then go to `configure`.

### configure

1. When no platform to configure remains, go to `summary`.
2. Take the first platform to configure. Remove it from the list.
3. Emit: Let's configure how highway-codify uses [Platform].
4. Follow `highway-codify-config` for [Platform], with the return step `configure` in `highway-onboarding`.

## Verification

- For each provider, onboarding hands the ADR to `highway-adr`, then the Reference Architecture to `highway-architecture`, then the Reference Implementation to `highway-implementation`, once each, without asking the person to accept any of them.
- A failed handoff is followed once more and is named when it still fails. A declined title keeps the earlier records and does not claim onboarding is complete.
- The Reference Implementation is written only after that architecture record exists.
- Lineage is shown only after every provider on the queue has an ADR, Reference Architecture, and Reference Implementation, and it lists each of those providers.
- An implementation that can start automation is included in `library/coding-standards/codify-platforms.md` by `highway-implementation`, with blank guidance. The person is asked whether to configure how highway-codify uses it, and any answer continues onboarding. No platform that cannot start automation is asked about.
