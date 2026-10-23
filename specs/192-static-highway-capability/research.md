# Research: Static Highway Capability

## Decision: Include one static line on the capability starting point

- **Decision**: The `capabilities` starting point includes **Highway:** Connect accepted business goals, decisions, architecture, and implementation work into a single traceable system of knowledge. The person may edit or remove that line before accept. A removed line is not placed on the capability queue.
- **Rationale**: The person is using Highway through an agent platform. The agreed sentence is the capability. Removal is how they say it does not apply.
- **Alternatives considered**: Inferring the line only when other context mentions an agent was rejected. The line is static.

## Decision: Map Highway to the agent platform only

- **Decision**: When Highway is mapped and the session identifies the agent platform by name, that name is the provider. Cursor, VS Code, Claude, and Codex are examples of names the session may identify. When the session does not identify a name, the existing unable-to-infer prompt asks the person to name the platform. A corrected name replaces it. No other capability is given this provider unless that capability is work the platform operates.
- **Rationale**: Highway is the work. The agent platform is where it runs. The open session is not evidence that the platform operates invoicing or any other capability.
- **Alternatives considered**: Guessing a product name was rejected. Treating the agent platform as the provider of every unmapped capability was rejected.

## Decision: Do not add a second accepted Highway provider

- **Decision**: Before showing the capability list, if an accepted ADR already records the Highway capability for the same provider name, omit the new Highway line. Onboarding does not authorize the agent platform to act on its own. After mapping is accepted, the existing orchestrate path writes the decision, reference architecture, and reference implementation.
- **Rationale**: The spec forbids a duplicate and forbids autonomous authorization. The record path is already specified.
- **Alternatives considered**: A new record type for the agent platform was rejected.
