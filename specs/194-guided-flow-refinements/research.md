# Research: Guided Flow Refinements

## Decision: Bold label, blank line, indented content

- **Decision**: Each starting-point item becomes `- **[Label]**`, a blank line, then the content indented under the same bullet.
- **Rationale**: Today the content sits on the line after the label with no blank line, so Markdown joins them into one line. A blank line keeps both in the same bullet and puts the content in its own paragraph. This is the "new line after each" the person asked for.
- **Alternatives considered**: A trailing hard break was rejected because it depends on invisible whitespace. Dropping the bullets was rejected because the request did not ask for it.

## Decision: Numbered sets use `1.` with the same item form

- **Decision**: Every recommendation item becomes `1. **[Title]:** [One sentence.]`, with a rule to number every recommendation in the set from 1.
- **Rationale**: The item form stays a bold title and one sentence. Only the list marker changes.
- **Alternatives considered**: Continuing numbers from the queue list was rejected because selections refer to the set the person just read.

## Decision: Numbers select from the current set

- **Decision**: `select` in `Classify` names recommendations by title or by number. In a queue message, a number refers to the recommendation set, not the queue list.
- **Rationale**: Numbered sets invite numbered replies. The queue list is not selectable.
- **Alternatives considered**: None. Leaving numbers unclassified would route them to `unknown`.

## Decision: Closing copy order

- **Decision**: The first set and the set shown with the queue close with the skill's question, then "You can select some, all or provide your own …", then "If you'd like additional suggestions, just say so." The set shown when the queue already has items closes with its own question, then the same two lines.
- **Rationale**: This is the supplied copy, and the clarification kept that set's own question.
- **Alternatives considered**: Keeping "If none of these fit…" in the queue-has-items set was rejected in clarification.

## Decision: Add-another line in both exhaustion messages

- **Decision**: The add-another line follows the ready-to-review question in `more` and in the queue's exhaustion message.
- **Rationale**: Both messages end with the same question and lead to the same reply handling. `own` is already handled there.
- **Alternatives considered**: Adding the line only in `more` was rejected because the queue message is the more common path.

## Decision: NFR recommendation order

- **Decision**: Replace NFR `recommend` rules 1 to 3. While an accepted Control is not reflected by a queued, shown, or captured NFR, a set contains only Control-derived recommendations, plus the two operating limits in the first set. Profile and Objectives refine scope, priority, and wording. One NFR may reflect more than one Control. After every Control is reflected, the coverage check across areas applies, and grounded Profile, Objectives, or uncovered-area expectations may follow. A Control not yet reflected counts as a remaining grounded recommendation, so `more` and `queue` do not show the exhaustion message while one remains.
- **Rationale**: This matches FR-007, FR-008, and FR-008a. Coverage continues across sets that keep the 3 to 5 limit.
- **Alternatives considered**: Raising the first set's limit was rejected in clarification and conflicts with X2.16.

## Decision: Operating limits stay title and sentence in the set

- **Decision**: **No system hosting** and **Direct purchase** appear as numbered items using their title and statement. Their **Why it matters:** lines stay where they are and are used at capture.
- **Rationale**: Every recommendation is a bold title and one sentence. The Request mapping and the 191 test depend on the existing text.
- **Alternatives considered**: Showing the rationale inside the set was rejected because other recommendations carry no rationale there.

## Decision: Fix one typo in the supplied copy

- **Decision**: Use "operational expectation" where the supplied NFR copy said "operational expection".
- **Rationale**: The spec records this as a typo.
- **Alternatives considered**: Copying the typo was rejected.

## Decision: One new contract test

- **Decision**: Add `guided-flow-refinements.test.sh`. It checks every new line, the numbered item form, the number rule, the bold Profile labels, and the NFR Control-first rules. It fails when "If none of these fit", "just let me know", or a `- **[Title]:** [One sentence.]` bullet remains in Objectives, Controls, or NFRs, or when a plain `- Future Direction` label remains in Profile.
- **Rationale**: D3.3 requires a test for the behavior change. No existing test covers this copy.
- **Alternatives considered**: One test per skill was rejected because a single feature contract is easier to keep aligned.
