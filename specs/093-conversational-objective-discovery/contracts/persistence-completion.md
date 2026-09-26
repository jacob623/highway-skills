# Contract: Objective Persistence and Completion

## Retained outputs

A confirmed Objective creation covers two retained outputs:

1. `library/objectives/OBJXXXXXX.md`, conforming to the shared objective-record template.
2. `library/governance/objectives.md`, regenerated from the authoritative baseline and conforming to the shared objective-catalog template.

## Mutation order

1. Revalidate the authoritative baseline and catalog.
2. Re-evaluate final-proposal overlap.
3. Return to user resolution and complete-proposal validation if overlap changed.
4. Allocate the permanent identifier exactly once.
5. Construct the record and catalog mutation.
6. Persist both outputs as one all-or-nothing transaction.
7. Verify both retained outputs.
8. Report creation completed only after both verifications pass.

## Failure contract

A failed write or retained-output verification preserves the prior verified baseline, does not claim successful creation, and names the unverified record or catalog output. Failed, declined, cancelled, and abandoned attempts do not change `next_id`, baseline version, or any transient state.

## Version and relationships

A confirmed Add/New increments the baseline once by MINOR. The record keeps its permanent six-digit `OBJ` identifier and `capabilities: []` relationship shape. Identifier allocation is never reused after removal or reset.
