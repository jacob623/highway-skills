# Options

Load evidence in this order: Request, its eight Solution Constraints, Clarification responses, Profile, Objectives, Controls, NFRs, Reference Architectures. Request evidence wins when Clarification disagrees. Clarification changes assumptions, risks, unknowns, and research findings only. It does not change which options exist, their scores, or the recommendation.

### analyze

Generate candidate options from the Request's Desired Change, then from accepted Objectives, Controls, NFRs, and Reference Architectures.

When `allowed_solution_classes` is known, keep only options in those classes. When it is `unknown`, do not filter by class.

Exclude an option that violates `existing_platforms_required`, `hosting_restrictions`, `vendor_restrictions`, `procurement_constraints`, or `regulatory_restrictions`. Record each exclusion with the option title, the constraint, and the reason. Preferred platforms and known systems do not exclude an option.

Sort the remaining options by Desired Change alignment, Objective alignment, constraint alignment, then title. Run `check` on them. Then keep the first two to five of the options that remain. When more than five remain, keep the first five and record the rest as excluded by that boundary. When fewer than two remain, stop. Say the Request does not support two viable options. Name each option `check` removed or held. Write nothing.

Derive each option id with the title rule in `identifier`, using the prefix `OPT`. Then score only the retained options.

- Required Platform Match is 100.
- Preferred Platform Match is 100 when a preferred platform is used, and 50 otherwise.
- Known-System Alignment is 100 when all declared known systems are reused, 75 when some are reused, and 50 when none are reused.
- Score weights are Objective 25, NFR 25, Control 20, Constraint Alignment 20, and Risk Reduction 10. Use floor rounding. A zero denominator scores 0. The total is 0 through 100.
- Confidence is High for 90 through 100, Medium for 70 through 89, and Low for 0 through 69.
- Complexity, Governance Impact, and Operational Overhead do not change the score.

Match a Reference Architecture only by explicit identifier, exact title, capability id, Objective id, Control id, or NFR id, in that order. Do not match by similarity.

Count a Reference Implementation only when it references a matched Reference Architecture, or references that architecture's id. Count each implementation id once. A missing or unreadable implementation counts as zero.

When totals tie, pick the winner in this order, and stop at the first criterion that leaves one option: a Reference Architecture match, then the higher Reference Implementation count, then the lower `OPT` id in alphabetical order. Reference Implementation evidence does not change a score except through this tie-break.

Mark exactly one option `Recommended`. Go to `identifier`.

### check

Run this on the options that remain after constraint exclusions, before the two-to-five boundary and before scoring. Do not run it on an option the person adds or replaces, or when a Discovery id is opened.

For each option that relies on a named product or feature, read that vendor's current public documentation, product pages, and release notes. Send only the product or feature name and the vendor name. An option that names no product or feature is not checked.

- The vendor says the product or feature is deprecated, retired, or no longer offered: the result is `contradicted`. Remove the option. Record every vendor page used, including one that still describes it.
- The vendor describes it, and no vendor page says it is no longer offered: the result is `confirmed`. Keep the option. Do not change its score.
- No vendor documentation, only a blog, forum, or comparison, or the check cannot be completed: the result is `inconclusive`. Keep the option. Do not treat it as confirmed.

When `existing_platforms_required` names a platform the option depends on, hold the option out of the scored options unless the Request, its Clarification, Profile, Objectives, Controls, NFRs, or Reference Architectures say that platform supports it. Vendor documentation does not count as that support. When required platforms are `unknown`, hold nothing.

Derive an `OPT` id for each removed or held option. Do not score it. A check does not change the score of an option that remains and does not override an accepted Control, NFR, or constraint.

### identifier

Derive an id from a title.

1. Lowercase the title. Remove hyphens and apostrophes. Split the rest into words.
2. Take eight letters: the first two of word 1, the first two of word 2, the first two of word 3, and the last two of the last word. When the title has only two words, the third sample is the first two of the last word.
3. When a word is shorter than two letters, continue into the next word. A one-word title repeats until there are eight letters.
4. Map each letter. Digits stay as they are.

a 0, b 1, c 2, d 3, e 4, f 5, g 6, h 7, i 8, j 9, k a, l b, m c, n d, o e, p f, q 0, r 1, s 2, t 3, u 4, v 5, w 6, x 7, y 8, z 9.

5. Prefix `DISC` for the Discovery title. Prefix `OPT` for an option title.

Compare the Discovery id with `discoveries/discoveries.md`, including removed rows. Compare option ids with each other.

- The same Discovery title already has that id: use the existing record. Do not write a second one. Go to `start`.
- The Discovery id is taken for a different title, or two option titles share an id: go to `title`.
- The ids are free: go to `write`.

### title

Name each conflicting title. Say that a title change is appropriate. Then show the new title for acceptance.

The existing Discovery Title, **[Existing title]** and this new Discovery Title, **[this title]**, are too similar. A title change is appropriate. I would recommend:

**[New title]**

Use "Option Title" instead of "Discovery Title" when the collision is between options.

**What would you add, correct, or remove?**

If this is accurate, just say so.

The new title is a small change the person can recognize. Its derived id must be free. Do not mention identifiers, hex, sampling, or the catalog.

- `accept`: replace the held title. Return to `identifier`.
- `edit`: use the person's title. Return to `identifier`.
- `question`: answer in one sentence. Re-emit this message.
- `unknown`: re-emit this message.

Do not write until every id is free or the existing Discovery is reused.

### write

Write `discoveries/[ID].md` and `discoveries/discoveries.md` together. Write neither file until both are valid. A failed write leaves every existing Discovery byte unchanged. Say what failed in terms the person can act on. Stay on `write`.

The Discovery title is `Options for [request title]` unless the person supplied a title.

The record follows `assets/discovery-record.md`.

- Keep every heading and table header row of `assets/discovery-record.md`, in order, even when a section has no content. Write `None` under a section with no content, after its table header row when it has one.
- `id` is the derived `DISC` id.
- `request` is the Request id.
- `status` is `accepted`.
- The title is the Discovery title.
- Copy the Request evidence and the eight Solution Constraints in their source order.
- Write every retained option, including its why, summary, request alignment, objective alignment, control alignment, NFR alignment, benefits, risks, assumptions, dependencies, and licensing costs.
- Include Research Findings, Assumptions, Risks, Unknowns, the Candidate Elimination Log, the Comparison Matrix, and one advisory Recommendation.
- Research Findings lists each product claim check with its claim, source or `None`, and result. A check result is not accepted repository evidence.
- The Candidate Elimination Log records each option `check` removed, with Constraint Category `product currency` and the source, and each option it held, with `required platform` and the platform name. Each row has Status `Excluded`.
- The matrix totals equal the option scores. Exactly one option is `Recommended`.
- Do not write a selected option, a rejected option, a decision, or an authorization.

Edit `discoveries/discoveries.md` in its existing structure.

The catalog owns the baseline version and the Discovery index. It has no `Next ID` field. The index columns are Discovery ID, Request ID, Discovery Title, and Status.

Each Discovery ID appears once. Rows are ordered by Discovery ID. The Discovery ID is `DISC` plus the eight hex digits derived from the title. Request ID is the completed Request this Discovery analyzes. Status is `accepted` or `removed`.

`accepted` has a record at `discoveries/<id>.md`. `removed` has no record file. A removed row stays in the index, keeps the title that last held that id, and leaves the id taken.

- Add one index row with the Discovery ID, Request ID, Discovery Title, and Status `accepted`.
- Order the index by Discovery id.
- Do not allocate from `Next ID`.
- The first catalog version is `1.0.0`.
- The first write increments the minor version.
- Adding, replacing, or removing an option updates that record and increments the patch version.
- Emit no timestamp, random value, or environment value.

On success, return to `start` and emit the option list. Emit nothing else before that list.

### start

When this analysis has not been written, write every retained option through `identifier` and `write` before emitting anything. The person is exploring the options. The write does not select an option.

When a matched architecture has a current implementation, emit one notice before the numbered options. Name the implementation, the architecture, and the decision that implementation records. Use the exact match already defined: identifier, exact title, capability id, Objective id, Control id, or NFR id. A wording resemblance does not produce this notice. The notice does not ask for confirmation. The person can still explore every option.

**[Implementation]** is a current implementation of **[Architecture]**, from **[Decision]**.

After a new analysis, emit one sentence for each option `check` removed or held, after that notice and before the numbered options.

**[Option title]** was left out. [Vendor] says [product or feature] is no longer offered. Source: [source].

**[Option title]** was left out. Accepted evidence does not say [platform] supports it.

Emit one numbered line per option, starting at 1, in displayed order. Show the option id and its title. Put `(Recommended)` after the recommended option title. The why is one sentence grounded in the Request, Objectives, Controls, and NFRs. A stated number selects that option.

**Here is a proposed starting point for your discovery:**

**1. [Option id]:** [Option title] (Recommended) — [Why this option fits.]

**2. [Option id]:** [Option title] — [Why this option fits.]

**Which option would you like to explore, or would you like to see a comparison matrix?**

If you are ready to decision on one of these options, just say so.

- `select`: go to `explore` for the named or numbered option.
- `decide`: continue as `highway-adr` with this Discovery id. When the reply also names an option or its number, pass that option id and continue at `start`. When it does not, continue at `choose-option`. Do not create the ADR in this skill.
- `matrix`: emit one row per option. The Option column shows the same number used in the list, then the option title, as `1. [Option title]`. That number is part of the Option column and does not count toward the column limit. Use at most 6 columns. Include Operational considerations and Licensing costs. Choose the remaining columns from the differences that matter for this Request. When a dollar estimate is available, show that figure. Otherwise use Low, Medium, High, a bounded range, or Unknown. The matrix does not change scores. Then ask **Which option would you like to explore?** Under that question, in normal text, emit: If you are ready to decision on one of these options, just say so. Do not offer the comparison matrix again. Stay on `start`.
- `edit`: when the person adds, replaces, or removes an option, update the Discovery file through `write`, then emit one consequence sentence and this block. Do not run `check` on an option the person adds or replaces. Stay on `start`.
- `accept`: re-emit this block. Stay on `start`.
- `unknown`: re-emit this block. Stay on `start`.
- `question`: answer without opening an option. For two named options, compare them without changing scores. Re-emit this block after the answer. Stay on `start`.
- `decline`: stop. Write nothing.

### explore

Emit the named option in this order. Use accepted Request, Objective, Control, and NFR evidence. Label unavailable evidence `None`. Do not change scores.

**[Option title]**

**Summary:** [What the option is and how it addresses the request.]

**Request Alignment:** [How it fits the Request, or `None`.]

**Objective Alignment:** [How it fits accepted Objectives, or `None`.]

**Control Alignment:** [How it fits accepted Controls, or `None`.]

**NFR Alignment:** [How it fits accepted NFRs, or `None`.]

**Benefits:**
- [Expected value.]

**Risks:**
- [Material drawback.]

**Assumptions:**
- [Condition that must hold.]

**Dependencies:**
- [Required system, decision, or constraint, or `None`.]

**Licensing costs:** [A dollar figure when one is available. Otherwise Low, Medium, High, a bounded range, or Unknown.]

**Are there any additional concerns you would like to explore for this option, or would you like to return to the list of options?**

If you'd like to select this option for the Decision record, just say so.

- `adopt`: continue as `highway-adr` with this Discovery id and this option id, at `start`. Do not create the ADR in this skill.
- `question`: answer the question about this option. When the answer includes a cost, use a dollar figure when one is available. Otherwise use Low, Medium, High, a bounded range, or Unknown. Do not change scores. Then re-emit this question. Stay on `explore`.
- A request to return to the list: go to `start`.
- `select`: go to `explore` for the newly named or numbered option.
- `decide`: continue as `highway-adr` with this Discovery id. When the reply also names an option or its number, pass that option id and continue at `start`. When it does not, continue at `choose-option`. Do not create the ADR in this skill.
- `accept`: return to `start`.
- `unknown`: re-emit this question. Stay on `explore`.
- `decline`: stop. Write nothing.

## Verification

- `start` lists each option with a number, the option id, the title, and one why sentence.
- When a matched architecture has a current implementation, that notice names the implementation, the architecture, and the decision it came from before the options. A wording resemblance does not. The notice does not ask for confirmation.
- The recommended option title is followed by `(Recommended)`.
- A stated number selects that option.
- `start` asks which option to explore, or whether to see a comparison matrix, then says the person can decide.
- The comparison matrix has at most 6 columns and includes Operational considerations and Licensing costs. The Option column includes the same number as the list, and that number does not count as a column.
- After the comparison matrix, the question asks which option to explore, does not offer the matrix again, and says the person can decide.
- A reply that is ready to decide continues as `highway-adr` with this Discovery id. This skill does not create the ADR.
- The explored option shows Summary, Request Alignment, Objective Alignment, Control Alignment, NFR Alignment, Benefits, Risks, Assumptions, Dependencies, and Licensing costs.
- The explored option ends with its question, then says the person can select this option for the Decision record. Selecting it continues as `highway-adr` with this Discovery id and this option id.
- A named product or feature the vendor no longer offers is removed before scoring and named with its source before the options. An inconclusive check keeps the option and is not confirmation.
- An option that depends on a required platform is held out when accepted evidence does not say that platform supports it. Vendor documentation does not put it back.
- Fewer than two viable options writes nothing.
- The record contains two to five `OPT` ids, one `Recommended` status, and matrix totals that equal the scores.
- Each Discovery id is `DISC` plus eight hex digits derived from the Discovery title.
- Each option id is `OPT` plus eight hex digits derived from the option title.
- A taken id names the conflicting titles, says a title change is appropriate, and shows a new title. The write waits until the person accepts that title.
- That message does not mention identifiers, hex, sampling, or the catalog.
- Mandatory constraint violations are excluded before scoring.
- Tie-break order is Reference Architecture match, Reference Implementation count, then lower `OPT` id.
- Clarification does not change options, scores, or the recommendation.
- A failed write leaves existing Discovery bytes unchanged.
