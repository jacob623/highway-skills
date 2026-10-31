# Research: Highway Codify

## Decision: The automation id is CDY plus eight hex digits

- **Decision**: Derive the id from the automation title with the same eight-letter sampling and letter-to-hex map the other records use. The prefix is `CDY`. The folder is `code/CDY` plus those eight hex digits. A collision uses the existing title distinction: the person sees a small title change, and the write waits until that title is accepted. The message does not mention identifiers, hex, sampling, or the catalog.
- **Rationale**: The folder sketch used this prefix. The person works from the title. The id keeps the folder tied to the catalog row.
- **Alternatives considered**: A new derivation was rejected because every other record already shares one algorithm. Hiding the folder id and using a slug of the title was rejected because a removed row must keep its id after the folder is gone.

## Decision: A running instance is two phrases, or it is absent

- **Decision**: Read only the accepted implementation record's Context and Implementation Summary. An instance is running when either section contains `instance is running` or `instances are running`, compared without regard to case. Any other wording, including silence, means no running instance. The proposal states the sentence it used, or `None` when it used silence. The person can correct the day before acceptance. Codify does not write that reading back onto the implementation record.
- **Rationale**: The implementation record has no instance field, and this feature does not add one. A fixed phrase is the same result for the same record. Correction stays on the proposal.
- **Alternatives considered**: Treating any use of "running" as enough was rejected because it also matches unrelated sentences. Inferring an instance from a product name was rejected because the record would not have stated it.

## Decision: Five matches are exact title, then capability, then summary

- **Decision**: Compare without regard to case. An exact implementation title selects that one implementation. Otherwise a realized capability title that appears in full inside the person's words is a match. Otherwise an implementation title that appears in full inside the person's words, or the person's words appearing in full inside the summary, is a match. When more than five match, keep five: exact titles first, then capability titles, then summary matches. Within each group, keep implementation catalog order. Stop at five.
- **Rationale**: Exact title already selects one. The cap and the description match are already required. Catalog order is the order the other skills use for a list.
- **Alternatives considered**: A resemblance score was rejected because wording resemblance is not a match elsewhere. Showing an arbitrary five was rejected because the same words would not yield the same list.

## Decision: A finding's evidence is the match set

- **Decision**: When the accepted request was seeded from an assessment finding, the matches are the accepted implementations that finding's accepted evidence names. Description matches are not added. The same one, two-to-five, and more-than-five rules then apply to that set. The person sees titles and descriptions.
- **Rationale**: The spec says the finding's evidence supplies the implementations when the person did not name them.
- **Alternatives considered**: Re-matching the edited request text and dropping the evidence list was rejected because the spec names the evidence as the match set.

## Decision: The close carries the title and the action, not the day

- **Decision**: The action is the accepted request's Desired Change, as one action. When that text asks for a second action, the proposal keeps the first and says the other waits for another run. After one implementation is selected, the close names it by title and tells the person to run `/highway-codify` for that title to do that action. It does not state Day 1 or Day 2, and it does not continue into codify in the same message. Zero matches still tell the person to run `/highway-discovery` with the request id. The request record does not gain an implementation field.
- **Rationale**: The request close already announces the next skill as a command. The day is codify's reading of the implementation. The request is already accepted before the close.
- **Alternatives considered**: Continuing into codify in the same message was rejected because assessment is the skill that continues, and the request close is the handoff. Storing the match on the request was rejected because the spec leaves that record unchanged.

## Decision: No request still proposes one action from the record

- **Decision**: When codify starts with an implementation and no action, no running instance proposes `Establish [implementation title]` as Day 1. A running instance proposes the first realized capability title as Day 2. When that implementation has no realized capability, the action is `Run [implementation title]`. The person can correct the proposal. Preparation stays in the enabling instructions.
- **Rationale**: A direct run still needs one action, and the same record must produce the same proposal.
- **Alternatives considered**: Leaving the action blank until the person types one was rejected because the proposal has to show one automation before acceptance.

## Decision: The means is the implementation's accepted architecture

- **Decision**: The proposal selects the accepted architecture named by the implementation and shows that architecture's title. The person can switch to another accepted architecture by title. A missing architecture, or one that is not accepted, is refused. When no accepted architecture is available, the proposal says so and does not name a tool the architecture does not describe.
- **Rationale**: The implementation already names one architecture. The spec requires the means to be an accepted architecture and forbids inventing one.
- **Alternatives considered**: Searching every architecture for a tool name was rejected because the architecture record does not carry product names, and the parent architecture is already the means.

## Decision: Tests

- **Decision**: Add `highway-codify.test.sh` as a static document contract over the new skill, the two templates, the request close, and the unchanged assessment explore path. Amend `output-template.test.sh` so the citing-skill count is 12 and the new skill is in the citing list. Record the retired count in `retirements.md`.
- **Rationale**: D3.3 and D3.5. Assessment's behavior does not change, so its version does not change. The new test locks the existing explore sentence.
