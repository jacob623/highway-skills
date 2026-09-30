# Research: Final Setup Contract Cleanup

## Decision: Preserve owner-specific result contracts

- **Decision**: Setup will use a generic owner loop, while Controls/NFRs retain their Collection
  Result contracts and Profile/Objectives retain their own owner results.
- **Rationale**: The owner contracts do not expose one shared collection-result shape. Imposing one
  would misrepresent ownership and create invalid routing requirements.
- **Alternatives considered**: A universal four-field collection result was rejected because it
  conflicts with the existing Profile and Objectives contracts.

## Decision: Keep the correction within version 8.0.0

- **Decision**: Correct the malformed Purpose boundary and simplify the existing Setup contract
  without changing the skill version.
- **Rationale**: The requested changes complete and correct the already-planned 8.0.0 contract.
- **Alternatives considered**: A major version increment was rejected because no new contract family
  is being introduced.

## Decision: Make first-run welcome and transitions explicit

- **Decision**: Store the exact welcome and transition blocks in the Setup Outputs/Workflow contract,
  with emission conditions tied to initial or first active domain interaction.
- **Rationale**: Exact wording and one-time behavior are user-visible acceptance requirements.
- **Alternatives considered**: Leaving separators to implied rendering was rejected because the
  contract requires each transition block to contain `---`.

No unresolved technical unknowns remain.
