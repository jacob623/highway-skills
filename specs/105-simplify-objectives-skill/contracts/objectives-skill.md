# Contract: highway-objectives skill

**Source**: `.highway/skills/highway-objectives/SKILL.md`

**Version**: 3.0.0, from 2.0.0.

## Experience

The Experience section is exactly:

`User-visible interaction follows the Highway Experience Standard.`

The skill does not restate one-question behavior, Decision Context, acknowledgments, implementation-detail suppression, recommendation acceptance, examples, progress, or confirmation behavior.

## Discovery

Evaluate Business Objective, Success, and Highway Relevance. Significance is absent. Do not ask why an Objective is meaningful or important.

The broad opening is exactly `**What's an important outcome you'd like to achieve?**` and is used only when no Objective evidence was supplied and no useful grounded recommendation is available. The sentence that tells the person to ask for suggestions is absent.

Missing Success uses `**How would you measure success in [stated objective]?**`.

Missing Highway Relevance uses `**What role should technology play in helping [Organization Name] achieve this objective?**` when an Organization Name has been accepted, unless accepted Profile evidence and the active Objective evidence already establish useful downstream relevance.

## Recommendations

Offer a grounded recommendation from accepted Profile evidence before an unnecessary question. Do not wait for a suggestion request. Prefer the accepted Organization Name. Keep the user-authored path available. Do not manufacture a recommendation when Profile evidence cannot ground one.

A selection of one, several, or all displayed recommendations is captured directly, without the captured-content review and without a second confirmation.

## Review

Materially interpreted user-authored input uses this content inside the Experience Standard's material-interpretation review:

`Here's what I've captured as your objective:`

`[Objective Title]`

`[Statement]`

`**Success looks like:**`

`- [Success Measure]`

`**Why it matters:**`

`[Rationale]`

`**Does this objective look right?**`

`Here's the objective I've captured:` and `Success Measures Success looks like:` are absent.

## Continuation

After one captured Objective during setup or configure, ask exactly `**Is there another objective you'd like to capture?**`.

After a selection of several or all displayed recommendations during setup or configure, capture them together and ask that question once.

Add and new do not ask that question.

Setup and configure do not end because readiness became Complete.

## Persistence and failures

Persistence is successful atomic persistence. The skill does not require a post-write persistence check, a retained-output check, a file-existence check, or a byte-equality check.

Error Handling lists only:

- a malformed Objective record, catalog, or allocation state is Blocked and is not mutated
- an unresolved update or remove target stops and identifies the target
- destructive removal or reset follows the Experience Standard's destructive-confirmation behavior

## Verification

Verification confirms the checks in spec FR-034. It does not restate generic Experience Standard or Constitution requirements.

## Example

The example is an inline invocation and does not repeat the version or describe persist-and-verify.

## Setup quotation

`.highway/skills/highway-setup/SKILL.md` no longer quotes `If you'd like some suggestions based on your organization's Profile, just let me know.` Setup's version and orchestration stay.
