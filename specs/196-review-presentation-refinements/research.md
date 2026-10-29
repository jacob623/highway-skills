# Research: Review Presentation Refinements

## Decision: Numbered capture items keep their details indented

- **Decision**: Each captured item becomes `1. **[Title]:** [Statement]`, with its other lines indented under the number. `---` stays between items, and none follows the last.
- **Rationale**: This matches the numbered recommendation sets and the clarification. Indented details stay inside the numbered item.
- **Alternatives considered**: Removing `---` was rejected in clarification.

## Decision: The finding title is derived, not stored

- **Decision**: Each listed finding opens with `1. **[Finding title]:**`, a short title based on that finding's Finding text. The title is not written to the findings file.
- **Rationale**: The findings template has no title column, and the spec keeps the file unchanged.
- **Alternatives considered**: Adding a title column was rejected because it changes the shared template and its tests.

## Decision: Dismiss from the list

- **Decision**: In `list of findings`, `dismiss` sets each named finding to `Dismissed` through `write`, then re-emits the list without them, filled back to at most 5. When none remain, go to `summary`. `Classify` describes `dismiss` as dismissing or discarding one or more findings.
- **Rationale**: The new list lines tell the person they can dismiss from the list.
- **Alternatives considered**: Requiring the person to open a finding first was rejected because the list now offers dismissal.

## Decision: The two closing lines are mutually exclusive

- **Decision**: When no more findings remain than are shown, emit "If you'd like to dismiss any of these, just say so." When more remain, emit "If you'd like to dismiss any of these or see additional findings, just say so." instead.
- **Rationale**: This follows the supplied copy for each case.

## Decision: Request `capture` merges into `start`

- **Decision**: Remove `### capture`. `start` keeps its grounding rules and lead-in, then shows the capture layout: a level-1 title heading and seven level-2 domain headings. The title rule moves into `start`. `accept` goes to `identifier`.
- **Rationale**: The step keeps the name `start`, so `intake` and the assessment hand-off still reach it.
- **Alternatives considered**: Naming the step `capture` was rejected because assessment hands off to `start`.

## Decision: Readable names are shown, snake-case names are written

- **Decision**: Under the Solution Constraints heading, each field is a bulleted bold readable name with its value, in record order. A value that is `unknown` or `[]` is shown as `None`. The skill's rules keep the snake-case names because they describe the record.
- **Rationale**: The record template and `static-operating-nfrs.test.sh` keep the snake-case names. Only what the person sees changes.

## Decision: "none" from the person

- **Decision**: The three platform and system list fields hold `[]`. `allowed_solution_classes` and the four restriction fields hold `unknown`.
- **Rationale**: This follows the clarification and uses the record's existing states.

## Decision: Tests

- **Decision**: Amend `onboarding-assessment-guidance.test.sh` for the finding title, Solution Complexity, the dismiss lines, and the new finding closing line. Amend `static-highway-capability.test.sh` for the new description. Add `review-presentation-refinements.test.sh` for numbered capture, the request merge, readable names, and None. Record removed assertions in `retirements.md`.
- **Rationale**: D3.3 and D3.5.
