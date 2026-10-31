# Research: Codify Suggestions

## Decision: The diagram is a fenced flowchart

- **Decision**: The proposal and the saved record contain one fenced `flowchart` block. Each component is one node, in the order the proposal names them. An arrow connects each node to the next and is labeled with the action. When the proposal names no component, the block has one node, the action title, and no component arrows. No image file is written.
- **Rationale**: The diagram has to be read in the proposal and kept in the saved record. A fenced block stays in the same file as the other proposal fields.
- **Alternatives considered**: An image file was rejected because the record would then depend on a second artifact. A prose description of the path was rejected because the spec requires a diagram.

## Decision: The list uses the explore question

- **Decision**: The list opens with `Based on the current state of this implementation, these may be worth visiting:` as a bold line. Each item is numbered from 1 and shows the title in bold and one summary sentence under it. The question is `Would you like to explore any of these options?` The next line is `You can also provide your own.` A number, a title, or a summary selects that item and opens the proposal. The person's own words select their automation even when they also name a listed item. Exploring does not open a second screen and does not write a file.
- **Rationale**: The spec requires the explore wording the other skills use for a numbered list, plus a way to provide one's own.
- **Alternatives considered**: Copying the findings question unchanged was rejected because that question names findings. A separate detail screen was rejected because the spec says the next view is the proposal.

## Decision: Current-state kind comes first, then record order

- **Decision**: Compare without regard to case. A realized capability whose title contains `establish` is an establishing suggestion. Every other realized capability is a run, change, or recover suggestion. When no instance is running, establishing suggestions come first. When an instance is running, the other kind comes first. Within a kind, keep the order of the Realized Capabilities section. When the leading kind has no capability, add one suggestion: `Establish [implementation title]` when no instance is running, or `Run [implementation title]` when one is. Its summary is the first sentence of the implementation summary, or `None` when that section is empty. Stop at five and drop from the end. A suggestion that names a tool the accepted architecture does not describe is left off the list.
- **Rationale**: The spec orders by current state, then by the record. The same record must produce the same list. The existing establish and run phrases stay available when the record has no capability of that kind.
- **Alternatives considered**: Treating every capability as equally relevant was rejected because the spec puts the fitting kind first. A resemblance score was rejected because the other skills do not match by resemblance.

## Decision: A named action skips the list

- **Decision**: When the invocation already names one action, go to the proposal for that action. Do not show the suggestion list. The title is that action. The summary is one sentence for that action. The proposal still includes the description, the flowchart, at least one acceptance criterion, and each component's responsibility and boundary, plus the current state, the day, and the means.
- **Rationale**: This is the clarification. The request close already names the action, and that close is not changed.
- **Alternatives considered**: Putting the named action first on the list was rejected by the clarification.

## Decision: Tests

- **Decision**: Add the list question, the provide-your-own line, the flowchart fence, `Responsibility:`, and `Boundary:` to `highway-codify.test.sh`. Keep every existing assertion, including `Establish` and the request close.
- **Rationale**: D3.3. D3.5 does not apply because no assertion is removed.
