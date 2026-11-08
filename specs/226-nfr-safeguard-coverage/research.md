# Research: NFR Safeguard Coverage

## R1. What counts as coverage

- **Decision**: A Control is reflected only by a queued or captured NFR. A shown recommendation the person did not select does not reflect its Control. Rule 5 still omits a shown title, except one that reflects a Control no queued or captured NFR reflects. `more` omits every title in the set just shown.
- **Rationale**: Today rule 1 counts a shown NFR as reflecting its Control. A safeguard the person skipped once is never offered again, which leaves it uncovered. The exception in rule 5 lets the next queue message offer it again. The `more` line keeps a request for more from repeating the set the person is looking at.
- **Alternatives considered**: Count shown titles as coverage (today's gap). Re-offer every shown title (non-Control titles would return and `more` would never reach its closing message).

## R2. Five-choice limit

- **Decision**: Keep the 3 to 5 rule for every set.
- **Rationale**: Experience Standard X2.16 caps a recommendation set at five choices. The person chose to keep it during planning. Rule 2 already fills sets with Control-derived recommendations while any Control is unreflected, and the queue message shows the next set right after a selection.
- **Alternatives considered**: Amend X2.16 for this skill. Combine several safeguards into each of five items.

## R3. Rationale wording

- **Decision**: One Control: `**Enforces your Safeguard, [Control title],** by [how the expectation keeps that Control true].` More than one: `**Enforces your Safeguards, [Control titles],** by [how the expectation keeps those Controls true].` Name two Controls as `[A] and [B]`, and three or more as `[A], [B], and [C]`. Any other rationale is one line grounded in the accepted Profile and accepted Objectives. The rule lives in `recommend`. `capture` reuses the set's line, writes a new line for the person's own expectation with the same rule, and keeps an edited rationale as written. A `review` edit that adds an NFR uses the same rule.
- **Rationale**: The person sees the word safeguard in highway-controls, and the Control title is the name they accepted. One rule in one place satisfies P7.3.
- **Alternatives considered**: Use the Control id (not user-facing). Keep the opening on edited rationales (the person chose to keep their own words).

## R4. Moved pins

- `guided-flow-refinements.test.sh` line 69: `Derive each recommendation from an accepted Control that no queued, shown, or captured NFR reflects yet.` becomes `Derive each recommendation from an accepted Control that no queued or captured NFR reflects yet.`

No other test pins a replaced line. `guided-flow-refinements.test.sh` keeps passing on `1. **[Title]:** [One sentence.]`, which stays in all three set templates.

## R5. Records

- **Decision**: No template change. `controls` already lists the Controls that influenced an NFR. The write step adds that it includes every Control the rationale names.
- **Rationale**: The record body already stores the line shown with **Why it matters:**.
