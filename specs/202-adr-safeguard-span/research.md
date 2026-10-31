# Research: ADR Safeguard Span

## Decision: A span is recognized from the copied matches

- **Decision**: `highway-adr` uses the span when all of these hold: more than one architecture matches; every match reason is the same Control id, or every match reason is the same NFR id; the selected option's Control or NFR alignment names that id; and the selected option title names none of the matched architectures.
- **Rationale**: ADR copies the Discovery matches and does not recompute them, so the span must be decided from what was copied. The safeguard id is the only thing the matches share. An option that names one of the matched architectures is choosing among them, which keeps the existing question.
- **Alternatives considered**: Recompute matches inside ADR. Rejected: ADR must not recompute matches. Ask the person whether the decision applies to each service. Rejected: the spec removes that question for this case.

## Decision: The ADR catalog cell and handoff field list every architecture

- **Decision**: For a span, the ADR catalog Architecture ID cell and the record's `Reference Architecture` handoff field list every RA id in the set, in id order, separated by a comma and a space. That is the separator the architecture catalog already uses for its ADR ID cell. A cell with more than one id is how Entry recognizes a recorded span.
- **Rationale**: FR-009 forbids `None` and requires every architecture to be named. Reusing the existing list format adds no new syntax. Narrowing to one architecture produces one id, which is the existing single-architecture shape.
- **Alternatives considered**: A new column, or one ADR row per architecture. Rejected: one Discovery has at most one ADR row, and a new column changes every reader of the catalog.

## Decision: The architecture catalog allows a span decision on several rows

- **Decision**: Keep the sentence "An ADR id appears on at most one row." in `architecture-catalog.md` and add the exception: a decision whose Architecture ID cell names several architectures appears on the row of each one.
- **Rationale**: FR-008 adds the span decision to each architecture's current decisions. The existing assertion in `multiple-reference-implementations.test.sh` stays as written, so no test is weakened.
- **Alternatives considered**: Rewrite the sentence. Rejected: it would remove a required string from an existing test.

## Decision: Span record content

- **Decision**: `supersedes` is `None`. `## Decision Scope` Covers names every architecture in the set by title. The handoff Architecture Direction says the decision runs beside the current decision of each named architecture. Required Architecture Work is `None`. The Decision authorization line is unchanged, as it is for a reused architecture today.
- **Rationale**: FR-010 requires no new architecture work. The authorization line is fixed by the template and already appears on decisions that reuse an architecture.
- **Alternatives considered**: A new authorization line for spans. Rejected: it changes a string other tests and skills rely on, with no change in what the person can do next.

## Decision: The span write covers every affected file at once

- **Decision**: Acceptance writes the ADR record, the ADR catalog, the Current Decisions of each architecture record in the set, and the architecture catalog ADR ID cells together. Nothing is written until all are valid.
- **Rationale**: That is the same all-or-nothing write ADR uses for one reused architecture, extended to several.
- **Alternatives considered**: Write the ADR first and update architectures afterward. Rejected: a failure would leave architectures that do not list a recorded decision.

## Decision: Narrowing is handled inside `start`

- **Decision**: A reply that removes architectures from the set re-emits the span proposal with one consequence sentence. The proposal says, in plain text, "If you'd like to leave out any of these architectures, just say so." A name that did not match is not added. One remaining architecture leaves the span and asks the existing replace-or-beside question.
- **Rationale**: It follows the pattern `start` already uses for a picked architecture. No new reply class is needed.
- **Alternatives considered**: A separate narrowing step. Rejected: it adds a step for one edit.

## Decision: The span proposal names every architecture

- **Decision**: The span proposal lists each architecture in the set by title, with no cap.
- **Rationale**: The names are what the decision covers, not a list to pick from, so the five-item cap on choice lists does not apply. SC-001 requires all six to be named.
- **Alternatives considered**: Cap at five with a show-more line. Rejected: the person would accept a decision whose coverage they had not seen.

## Decision: The span close counts uncovered implementations

- **Decision**: A current implementation is an accepted row in `implementations/implementations.md` whose Architecture ID is in the set. It is covered when an accepted row in `code/code.md` names it and that automation's `## Action` is the decision title. The close says which architectures in the set have no current implementation. It then offers codify for the one uncovered implementation, lists two to five by title, or lists none and asks for a name when there are more than five. When none is uncovered, it says so. When no implementation exists in the set, its one step is `/highway-implementation [first RA id]`. The codify step uses the request close wording: Run `/highway-codify` for **[Implementation title]** to **[Decision title]**.
- **Rationale**: These are the counting and wording rules the spec and the request close already set. Architectures are ordered by id, which is architecture index order.
- **Alternatives considered**: Match coverage by automation title. Rejected: the spec defines coverage by the action.

## Decision: Opening a recorded span goes to the close

- **Decision**: Entry case 4 shows the recorded decision and writes nothing. When its Architecture ID cell names more than one architecture, it then goes to `close`, which offers only what is still uncovered.
- **Rationale**: FR-014 requires the remaining work without proposing the decision again.
- **Alternatives considered**: A separate resume step. Rejected: `close` already computes what remains.

## Decision: Assessment opens on a review menu

- **Decision**: Entry goes to a new `review` step, which asks **What would you like to review?** and lists the two choices in the user's words. Choosing gaps goes to `list of findings` unchanged, including its first-visit heading. Choosing ready artifacts goes to a new `ready records` step. The menu is shown for every invocation. A domain argument applies to the findings.
- **Rationale**: FR-018 keeps the findings list exactly as it is. The existing test requires the heading at `list of findings`.
- **Alternatives considered**: Move the heading before the menu. Rejected: it changes the findings list and an existing assertion.

## Decision: Each category uses the next skill's own waiting rule

- **Decision**: A request is ready when no discovery row names it, the rule `highway-discovery` uses. A discovery is ready when no decision row names it, the rule `highway-adr` uses. A decision is ready when its Architecture ID cell is `None` and no architecture row lists it, the rule `highway-architecture` uses. A removed row counts in each of these. An architecture is ready when no accepted implementation names it. An implementation is ready when no accepted automation names it. A removed implementation or automation row does not count, as those catalogs state. An accepted request is always complete, because `highway-request` writes `Complete` with the accepted record.
- **Rationale**: A record offered by assessment must be one the next skill will accept. The spec's FR-020 and User Story 6 were aligned to these rules during planning.
- **Alternatives considered**: Count only accepted rows everywhere. Rejected: a request with a removed discovery would be offered, and `highway-discovery` would collide with the removed id.

## Decision: Ready records use letters and new reply classes

- **Decision**: Categories are shown as `**1. Requests**` and records as `**a. [Record title]:** Ready for [stage].` Assessment adds the classes `gaps`, `ready`, `advance`, and `menu`. The existing `select` and `more` lines stay word for word, and `more` is also handled in `ready records`. A show-more view lists only the categories that still have records, numbered from 1 in the order shown, and continues each category's letters. A reply refers to the view just shown.
- **Rationale**: Bold lines are not ordered-list items, so lettering does not trip P8.1. Existing assertions on `select` and `more` stay intact.
- **Alternatives considered**: Reuse `select` for records. Rejected: its wording names findings, and changing it would remove an asserted string.

## Decision: The return line is always present

- **Decision**: The ready view always ends with "If you'd like to return to the main menu, just say so." When more records remain, "If you'd like to see more records, just say so." comes before it.
- **Rationale**: FR-022 requires the exact return sentence. FR-019 requires the show-more offer.
- **Alternatives considered**: One combined sentence, as the findings list does. Rejected: it would drop the exact sentence FR-022 names.

## Decision: Assessment hands off by continuing, not by command

- **Decision**: Advancing a record continues as the next skill in the same message: `highway-discovery` with the Request id, `highway-adr` with the Discovery id, `highway-architecture` with the ADR id, `highway-implementation` with the RA id, and `highway-codify` with the implementation title. Assessment writes nothing for this.
- **Rationale**: This matches how `explore` already continues as `highway-request`. `highway-codify.test.sh` rejects the literal `/highway-codify` in assessment, so the handoff names the skill without the slash command.
- **Alternatives considered**: Tell the person which command to run. Rejected: the spec says choosing continues in that skill.

## Decision: Discovery adds a reply class for the explored option

- **Decision**: `explore` emits "If you'd like to select this option for the Decision record, just say so." after its question. A new class, `adopt`, means the person selects the option being explored. It continues as `highway-adr` with this Discovery id and this option id at `start`. The existing `decide` handling in `start` and `explore` is unchanged.
- **Rationale**: FR-025 keeps the existing decide path. A separate class stops "select this option" from being read as a `decide` with no option, which goes to `choose-option`.
- **Alternatives considered**: Change `decide` in `explore` to default to the explored option. Rejected: it changes an existing path the spec keeps.

## Decision: The product-claim check runs before the cap and the scores

- **Decision**: After constraint exclusions, and before the two-to-five cap and scoring, discovery checks each generated option that names a product or feature. The cap then applies to what remains. A removed option does not take a slot.
- **Rationale**: A retired feature in the first five would otherwise hide a viable option past the boundary. Scoring only what remains keeps the existing weights, and the recommendation is chosen again from those options.
- **Alternatives considered**: Check only the two to five that would have been shown. Rejected: a retired option would occupy a slot. Check after the record is written. Rejected: the person would be shown the option before it could be removed.

## Decision: Only the vendor's own current documentation can remove an option

- **Decision**: The check looks at the vendor's current public documentation, product pages, and release notes, using only the product or feature name and the vendor name. The option is removed when that documentation says the product or feature is deprecated, retired, or no longer offered. Conflicting vendor pages still remove it, and both sources are recorded. A blog, forum, or comparison, a check that finds nothing, and a check that cannot be completed are inconclusive: the option stays, and the result is recorded as inconclusive.
- **Rationale**: A secondary source is how a live product gets dropped by mistake. An inconclusive check is the Sawyer failure in the other direction: absence of a page is not support and not a contradiction.
- **Alternatives considered**: Treat any web page that says "deprecated" as a removal. Rejected: the spec limits removal to the vendor's own documentation. Treat an inconclusive check as removal. Rejected: the option would disappear whenever documentation could not be reached.

## Decision: A required platform is judged from accepted evidence

- **Decision**: An option that depends on a platform named in `existing_platforms_required` is held out of the scored options when the request, its clarification, profile, objectives, controls, NFRs, and reference architectures do not say that platform supports it. Vendor documentation that the product includes the capability does not count. When required platforms are unknown, no option is held. The person can add the option afterward, and the check does not remove an option the person adds or replaces.
- **Rationale**: Public documentation answers what the product offers. It does not answer what this organization's platform can do. The person's addition is their confirmation.
- **Alternatives considered**: Accept vendor documentation as platform support. Rejected: that is the Sawyer miss. Ask a question before the list. Rejected: discovery writes the options before the list and does not add a question here.

## Decision: Where the check is recorded

- **Decision**: Research Findings gains one entry per check: the claim, the source or `None`, and `contradicted`, `confirmed`, or `inconclusive`. The entry is not accepted repository evidence. The Candidate Elimination Log gains a row for each removed option, category `product currency`, value the source, and a row for each held option, category `required platform`, value the platform name. Both use Status `Excluded` and an `OPT` id derived from the title. Before the option list, one plain sentence names each removed option and its source, and one names each held option and its platform. The current-implementation notice stays first.
- **Rationale**: The log is where discovery already records options it did not keep. The sentences are how the person sees the removal without opening the file. The template's Research Findings line today says findings come only from the closed request, so that line has to name the check and its source.
- **Alternatives considered**: Record the check only in the conversation. Rejected: a later reader of the discovery would not see why an option is absent. A new file for the check. Rejected: the record already has the two sections.

## Decision: A recorded discovery is not checked again

- **Decision**: Opening a discovery id loads the stored options and does not run the check. The check runs only when analysis writes options.
- **Rationale**: A supplied discovery id does not write. Re-checking would change stored options, scores, and ids.
- **Alternatives considered**: Re-check on every open and update the record. Rejected: it breaks the existing rule that opening a discovery writes nothing.

## Decision: Version bumps

- **Decision**: `highway-adr` 4.0.0 to 5.0.0, `highway-assessment` 4.0.0 to 5.0.0, and `highway-discovery` 4.0.0 to 5.0.0, because each changes what an existing input produces. `adr-catalog.md` 4.0.0 to 4.1.0, `adr-record.md` 3.0.0 to 3.1.0, `architecture-catalog.md` 3.0.0 to 3.1.0, and `discovery-record.md` 1.0.0 to 1.1.0, because each adds a case and existing records stay valid.
- **Rationale**: These follow the bump rules applied to codify in features 200 and 201.
- **Alternatives considered**: MAJOR template bumps. Rejected: no existing record becomes invalid.

## Decision: One new test file

- **Decision**: Add `.highway/tools/tests/adr-span-progression.test.sh`, a static document contract test for the strings this feature adds to the three skills and four templates. Existing assertions are not changed.
- **Rationale**: D3.3 requires a test change. The feature spans three skills, so one file keeps its assertions together.
- **Alternatives considered**: Spread new assertions across three existing tests. Rejected: harder to find, and no existing test owns discovery's explore ending.
