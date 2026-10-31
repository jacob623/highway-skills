# Research: ADR Record Completeness

## Decision: Keep the section order and add two sections

- **Decision**: Keep the current body order. Add `## Decision Scope`, with Covers and Leaves Open, and `## Revisit When` directly after `## Decision`.
- **Rationale**: The new prose sits next to the decision it qualifies. Reordering the rest is outside the findings.
- **Alternatives considered**: Moving Discovery Reference to the end was rejected as a wider change with no finding behind it.

## Decision: Context holds Problem, Forces, and Evidence

- **Decision**: `## Context` has `Problem:`, `Forces:`, and `Evidence:`. Evidence keeps the evidence-resolution record or `None`.
- **Rationale**: FR-001 requires the problem and the forces in prose. The existing evidence record keeps a home.

## Decision: Alternatives are the only home for option definitions

- **Decision**: Remove Candidate Solution Options from Discovery Reference. Each alternative has `Definition:`, `Outcome:`, and `Reason:`. Remove `Selection Status`. A Discovery-backed alternative is headed by its option id and includes the chosen one as `Selected`. An onboarding alternative is headed by its name.
- **Rationale**: The definition sits beside the reason, the chosen option is not copied into Discovery Reference, and the clarification places the chosen option in the list.
- **Alternatives considered**: Keeping Candidate Solution Options as ids only was rejected because it copies the chosen option into Discovery Reference. For onboarding, FR-010's candidate options are satisfied because no option id is written anywhere.

## Decision: The recommendation line stays in Discovery Reference

- **Decision**: `Recommendation:` keeps the Discovery's recommended option, even when the person chose it.
- **Rationale**: It records what the research recommended, not what was decided. Recommendation Override remains the only other statement of the decision.

## Decision: Onboarding values in the Decision

- **Decision**: `Selected Option:` holds the option id, or the adopted provider's name for onboarding. `Selection Source:` is `User-provided explicit selection`, or `Accepted onboarding mapping` for onboarding. Decision Confidence and Recommendation Override are not written for onboarding when no Discovery exists. Confidence is `None`.
- **Rationale**: The template keeps the strings the suite requires, and onboarding writes no option id.

## Decision: Handoff names its products

- **Decision**: The handoff keeps Architecture Direction, Required Architecture Work, and Authorization to Proceed. It adds `Reference Architecture:` and `Reference Implementation:`, each an id or `None`. It drops Selected Option and Reference Architecture Matches.
- **Rationale**: FR-006, FR-007, and FR-008.

## Decision: Architecture and implementation update the ADR after their own write

- **Decision**: After `highway-architecture` writes its record and catalog, it sets `Reference Architecture:` on the ADR. After `highway-implementation` writes its records, it traces the architecture to its ADR and sets `Reference Implementation:`. Neither changes any other ADR byte. When that update fails, the new record remains, the skill says the ADR could not be updated, and it does not call the chain complete. When either skill finds its existing record for the same parent and the ADR field is still `None`, it sets that field.
- **Rationale**: This follows the clarification. Re-invoking the skill is the later update, with no new command.
- **Alternatives considered**: Writing the ADR in the same transaction was rejected by the clarification. Deriving the ids from catalogs at read time was rejected because FR-008 requires the ADR to name them.

## Decision: Onboarding fills the handoff in `orchestrate`

- **Decision**: Onboarding writes the ADR with both ids `None`, writes the architecture and sets its id, then writes the implementation and sets its id. A failed ADR update is tried once more, like the other onboarding writes. If it still fails, onboarding names the failure and does not claim to be complete.
- **Rationale**: This matches onboarding's retry rule and FR-011.

## Decision: Superseded status

- **Decision**: `status` is `accepted` or `superseded`. It is `superseded` exactly when `superseded_by` names an ADR. The catalog status is `accepted`, `superseded`, or `removed`. A superseded row keeps its file and its id.
- **Rationale**: FR-012 and FR-013. No current writer sets `superseded_by`, so this feature defines the rule for any writer.

## Decision: Typed governance links

- **Decision**: Each relationship line is `- OBJXXXXXX: advances`, `- CTLXXXXXX: bound by`, or `- NFRXXXXXX: satisfies`. An empty section is `None`.
- **Rationale**: FR-014.

## Decision: Tests

- **Decision**: Add `adr-record-completeness.test.sh` for the template sections and fields, the catalog statuses, the write rules in `highway-adr` and `highway-onboarding`, and the handoff updates in `highway-architecture` and `highway-implementation`. It fails when `Selection Status`, `Candidate Solution Options`, or a handoff copy of the chosen option or matches remains.
- **Rationale**: D3.3. No existing assertion is removed.
