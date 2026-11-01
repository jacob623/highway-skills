# Contract: Record Titles

## highway-architecture

### Proposal

The first line of the proposal is:

**Title:** [Purpose title.]

### identifier

- The architecture title is the purpose in the ADR title, unless the person supplied a title that names no product.
- Remove a leading "Adopt", without regard to case. The purpose is the text after the first " for ". Capitalize its first letter. Keep every other word.
- When the ADR title has no " for ", remove the Selected Option name when it appears in the title. Use the rest.
- When the title would be empty or would name a product, ask for a purpose title before deriving the id.
- The same title already has that id and its row lists this ADR: use the existing record. Go to `name`.
- The same title already has that id for a different ADR: go to `title`.

Removed sentence: "The architecture title is the ADR title unless the person supplied a title."

## highway-implementation

### Proposal

The first line of the proposal is:

**Title:** [Product title.]

### identifier

- The implementation title is the product in the title of the decision this realization came from, unless the person supplied a title.
- Remove a leading "Adopt", without regard to case. The product is the text before the first " for ". Capitalize its first letter. Keep every other word.
- When the decision title has no " for ", use the Selected Option name when it appears in the title. Otherwise use the rest of the title.
- The same title already has that id under this architecture: use the existing record.
- The same title already has that id under a different architecture: the title becomes "[Product] for [purpose]". Derive the id again.
- The id is taken for a different title: go to `title`.

Removed sentence: "The implementation title is the architecture title unless the person supplied a title."

## Templates

- `architecture-record.md`: the heading is `# <purpose title>`. One sentence says the title is the decision's purpose and names no product.
- `implementation-record.md`: the heading is `# <product title>`. One sentence says the title is the product or named mechanism, plus "for" and the purpose only when the product title is taken.

## Unchanged

The ADR record, onboarding text, discovery and ADR exact-title matching, request close matching, and codify `choose` stay unchanged.
