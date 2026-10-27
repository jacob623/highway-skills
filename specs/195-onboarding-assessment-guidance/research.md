# Research: Onboarding and Assessment Guidance

## Decision: A new `overview` step owns the opening

- **Decision**: Add `### overview` between `Classify` and `capabilities`. It emits the supplied copy once, then goes to `capabilities`. "What we'll do together" is a plain line with an instruction to emit it as a level-3 heading. The `[Name]` rule moves from `capabilities` to `overview`.
- **Rationale**: A literal `###` line inside the skill would start a new section. Setup's welcome uses the same pattern.
- **Alternatives considered**: Keeping the opening inside `capabilities` was rejected because the request names a separate section.

## Decision: Numbered capability items, one capability each

- **Decision**: The starting point becomes numbered items: `1. **[Capability title]:**`, a blank line, then the indented description. AI-Assisted Engineering and Planning is item 1 when included. Highway's own proposals name one capability each and split joined activities.
- **Rationale**: Numbers let the person refer to an item. The blank line separates the title from the description.
- **Alternatives considered**: Splitting what the person adds was rejected. Their wording is kept.

## Decision: No equivalence for earlier Highway records

- **Decision**: An accepted ADR recording the earlier Highway capability does not count as AI-Assisted Engineering and Planning.
- **Rationale**: The project is in development, so backward compatibility with earlier onboarding records is not required.
- **Alternatives considered**: Treating earlier Highway records as the same capability was removed at the user's request.

## Decision: Mapping transition on the first capability only

- **Decision**: `map` emits the supplied transition before the block for the first capability on the queue, then never again in the run. Each label in the block is bold, followed by a blank line and its value.
- **Rationale**: The transition marks the move from capabilities to providers once.
- **Alternatives considered**: Emitting it in `capabilities` after accept was rejected because the request ties it to the first mapping.

## Decision: `list of findings` replaces `open`

- **Decision**: Remove `### open`. Add `### list of findings` before `### finding`. `Entry` goes to it. On the first visit it emits the opening heading and paragraph. It lists Open findings from earlier runs first, then new grounded findings, at most 5 in total. Each new finding is written as Open through `write` before the list is shown. A failed write leaves that finding out. Complexity is derived from accepted evidence for every listed finding.
- **Rationale**: This follows both clarifications and keeps the write-before-show rule.
- **Alternatives considered**: Writing a finding only when chosen was rejected in clarification.

## Decision: New reply types

- **Decision**: Add `select` (chooses a listed finding by number or by its summary), `more` (asks for additional findings), and `back` (asks to go back to the list of findings) to `Classify`.
- **Rationale**: The list and the finding details need these replies.
- **Alternatives considered**: Reusing `explore` for selection was rejected because it already means starting a request.

## Decision: Save and discard return to the list

- **Decision**: `accept` and `dismiss` update the row as today, then go to `list of findings`. The separate retained-findings list is removed. `back` goes to `list of findings` without changing the row. `decline` from either step goes to `summary`.
- **Rationale**: This follows the first clarification. The list is now the home of the assessment.
- **Alternatives considered**: Keeping the retained-findings list was rejected as a second list with the same purpose.

## Decision: Amend the static capability test

- **Decision**: Replace the three Highway assertions in `static-highway-capability.test.sh` with the AI-Assisted Engineering and Planning sentences. Record the superseded assertions in `retirements.md`.
- **Rationale**: D3.5 requires a recorded reason when an assertion is removed.
- **Alternatives considered**: Deleting the test was rejected because the static capability still exists under its new title.

## Decision: One new contract test

- **Decision**: Add `onboarding-assessment-guidance.test.sh` for the overview, numbered capabilities, mapping transition and layout, assessment opening, list of findings, reply types, and the go-back line. It fails when "save this for later, or discard it entirely", `### open`, or the old capabilities heading remains.
- **Rationale**: D3.3 requires a test for the behavior change.
