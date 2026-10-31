# Retirements: Multiple Reference Implementations

## adr-record-completeness.test.sh

- **Removed assertion**: The ADR template contains `Reference Implementation: <RI id, or `None`>`.
- **Reason**: The decision handoff has no implementation entry.
- **Replacement**: The handoff section is rejected when it contains `Reference Implementation:`.

- **Removed assertion**: `highway-adr` contains `Reference Architecture `None`, Reference Implementation `None``.
- **Reason**: A reused architecture is named in the handoff when the decision is accepted. The handoff no longer has an implementation entry, so the paired `None` wording is no longer the rule.
- **Replacement**: `highway-adr` must contain `Do not write an implementation entry.`

- **Removed assertion**: `highway-onboarding` contains `set the ADR's `Reference Architecture` or `Reference Implementation` field to its id.`
- **Reason**: Onboarding sets the architecture id and does not set an implementation id.
- **Replacement**: Onboarding must contain `set the ADR's `Reference Architecture` field to its id`.

- **Removed assertion**: `highway-onboarding` contains `the ADR names the architecture and its Reference Implementation stays `None``.
- **Reason**: The decision does not store an implementation id, so there is no field left at `None`.
- **Replacement**: Onboarding must contain `does not name an implementation`.

- **Removed assertion**: `highway-implementation` contains `Do not change the ADR, except its Reference Implementation field.`
- **Reason**: The decision does not store an implementation id. The implementation skill no longer writes the ADR.
- **Replacement**: The implementation skill must contain `Do not change the ADR.` and must not contain `Reference Implementation field`.

## static-operating-nfrs.test.sh

- **Removed assertion**: `git diff` and `git diff --cached` of `.highway/skills/highway-discovery/SKILL.md` exit 0.
- **Reason**: That check froze Discovery for the operating-limit feature. Discovery now names an existing implementation before the options, so a later edit is required.
- **Replacement**: The operating-limit assertions on `highway-nfrs` and `highway-request` remain. Discovery is still required to exist.
