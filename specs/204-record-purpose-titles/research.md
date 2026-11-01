# Research: Record Purpose Titles

## R1. Splitting the decision title

- **Decision**: Remove a leading `Adopt ` without regard to case. Split the rest at the first ` for `, compared without regard to case. The text before it is the product. The text after it is the purpose. Capitalize the first letter of each, and keep every other word as written.
- **Rationale**: Every title in the spec follows "Adopt [product] for [purpose]". Keeping the decision's words makes the result predictable. "Adopt local MacBook design apps for kit design" yields "Local MacBook design apps" and "Kit design".
- **Alternatives considered**: Dropping words such as "local". Rejected because no general rule says which words to drop.

## R2. A decision title without " for "

- **Decision**: Remove a leading `Adopt`. When the decision's Selected Option is a name that appears in the remaining title, that name is the product, and the architecture title is the remaining title without it. Otherwise the implementation title is the remaining title, and the architecture title is also the remaining title. When the architecture title would then name the product, or would be empty, ask for a purpose title.
- **Rationale**: Onboarding writes the provider name as Selected Option, so that name is reliable. A Discovery-backed Selected Option is an option id and does not appear in the title, so the fallback applies.

## R3. Which decision an implementation reads

- **Decision**: Use the decision this realization came from, which the implementation already names in Traceability.
- **Rationale**: The skill already identifies this decision. Using it keeps title and traceability consistent.

## R4. Product title collisions

- **Decision**: In `identifier`, when the derived id has the same title under a different Architecture ID, use "[product] for [purpose]" and derive again. When the same title has the same Architecture ID, reuse the record as today. When an id is taken by a different title, use the existing `title` step.
- **Rationale**: Short product titles repeat across architectures. Without this rule, a second "Notion" would reuse the first Notion record.

## R5. Architecture title collisions

- **Decision**: When the derived id has the same title but that architecture's catalog row names a different ADR, go to the existing `title` step. Reuse only when the ADR also matches.
- **Rationale**: Purpose titles can repeat across decisions. Reusing another decision's architecture would attach this decision without listing it in Current Decisions. Discovery and ADR already offer an exact-title match before an architecture is created, so this case is rare.

## R6. Showing the title

- **Decision**: Add `**Title:** [Purpose title.]` as the first line of the architecture proposal and `**Title:** [Product title.]` as the first line of the implementation proposal. An edit to the title is a supplied title. An architecture title edit that names a product follows the existing rule that leaves it out and says it belongs on the implementation.
- **Rationale**: Spec FR-007 requires that the person sees the title before acceptance. Neither proposal shows a title today.

## R7. Short implementation titles in matching

- **Decision**: Leave `highway-request` close matching and `highway-codify` choose matching unchanged.
- **Rationale**: A request that names "Notion" is about the Notion implementation. Those skills already rank exact titles first and keep catalog order.
- **Consequence**: An implementation titled with a common word, such as "The factory" or "Cursor", can match a request that uses that word in passing. Revisit matching separately if that causes a wrong next step.

## R8. Existing records

- **Decision**: No conversion and no migration, per clarification Q1. Opening an accepted record does not rename it.
