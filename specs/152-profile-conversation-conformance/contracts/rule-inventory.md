# Contract: Rule Inventory

Exact rows added to and amended in `.highway/governance/experience-standard.md`. This feature
authors these rows, so quoting them here does not engage D1.4.

New identifiers begin at **X2.58**. Retired identifiers X1.7, X2.2, X2.27, X2.28, and X2.33 are not
reused. Every row satisfies P1.1 (one keyword), P1.2 (one obligation), and P1.3 (25 words or fewer);
the word count of each rule text is given for verification.

---

## Added rows — `### X2 - Interaction`

| ID | Rule | Observable | Words |
|---|---|---|---|
| X2.58 | A domain's substance MUST cross an explicit acceptance boundary before it is retained. | Retained content traces to a response in which the person accepted that specific candidate. | 13 |
| X2.59 | An unambiguous approval MUST be treated as acceptance regardless of its wording. | Acceptance is determined by the response's meaning; no particular phrase is required or awaited. | 10 |
| X2.60 | A re-presented candidate MUST name what changed since the person accepted it. | The re-presentation states the specific changed material rather than showing the candidate again unchanged. | 12 |
| X2.61 | A candidate whose development since acceptance is unclear MUST be presented for review. | When normalized comparison cannot establish identity with accepted content, the candidate is shown rather than suppressed. | 13 |
| X2.62 | A term the person rejected MUST NOT reappear, including as a synonym. | Neither the rejected term nor a substitute carrying the same meaning appears in later output. | 12 |
| X2.63 | An amended candidate MUST retain the accepted content's original form. | Headings, ordering, and structure of the accepted version are unchanged apart from the amendment. | 10 |
| X2.64 | A correction that cannot be located in accepted content MUST be reported to the person. | The response names what could not be found, rather than applying it elsewhere or dropping it. | 15 |
| X2.65 | An acknowledgment of a Substantive Contribution MUST add understanding beyond restating it. | The acknowledgment states an implication, consequence, tension, or connection absent from the person's own words. | 12 |
| X2.66 | Each Substantive Contribution MUST receive one acknowledgment. | Acknowledgment follows every response supplying such information, and does not follow responses that do not. | 7 |
| X2.67 | A question requiring the person's response MUST be emphasized where it appears. | The question text carries bold emphasis; surrounding guidance does not. | 12 |

**New total**: 49 + 10 = **59**. Update the `-ne 49` assertion at all five sites listed in the plan.

### Notes on specific rows

- **X2.58 / X2.59** are the acceptance floor and its recognition test. X2.18 and X2.19 already bound
  what does *not* count as acceptance; neither states that a boundary is required at all, nor that
  recognition is by meaning. That gap is what one observed run fell through.
- **X2.60 / X2.61** are the ceiling and its tie-break. They complement X2.51 rather than duplicating
  it: X2.51 forbids re-review, X2.60 governs the legitimate re-presentation case, X2.61 resolves the
  case where identity cannot be established.
- **X2.62** is distinct from X2.53. X2.53 excludes terms the person never *adopted*; X2.62 excludes
  terms the person actively *rejected*, and extends to synonyms, which is how the observed violation
  evaded X2.53.
- **X2.65 / X2.66** are two rules because P1.1 permits one keyword each. "Adds understanding" and
  "occurs for each contribution" are separate obligations.
- **X2.67** fills a gap confirmed during planning: no rule about emphasis exists anywhere in the
  repository. See Research D5.

---

## Amended rows

| ID | Field | Change |
|---|---|---|
| X2.51 | Observable | Append the identity test: comparison with confirmed content ignores whitespace differences. Resolves clarification Q4. Rule text unchanged. |
| X2.4 | Observable | State that material ambiguity in the person's own contribution is consequential, result-changing uncertainty. Reconciles FR-020 without a competing rule. Rule text unchanged. See Research D6. |

Both amendments leave the rule text untouched, so neither changes the row count and neither affects
any rule-text assertion in the existing suite.

---

## Provenance footer

D5.3 requires a superseding document to name every element it changes. The footer paragraph must
name: the ten added identifiers, the two amended Observables, and the fact that no identifier is
retired by this amendment.

Version string: `10.0.0` → `11.0.0` at line 3 and in the footer. `Last Amended` updated.

---

## Rules deliberately not added

| Behavior | Why no rule |
|---|---|
| Capture heading | X2.21 already states it. Only the literal was missing from the skill. |
| Narration of internals | X2.36 already states it. |
| Validation question wording | X2.49 already states it and already held. |
| Vision boundary | Domain meaning is owned by `highway-profile`, not the standard. |
| Cross-domain preservation | Owned by `highway-profile`. |
| Readiness and persistence operations | Owned by `highway-profile`. FR-026 requires the authorization to stay local — no general permission and no general prohibition anywhere. |
