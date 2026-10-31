# Feature Specification: ADR Safeguard Span

**Feature Branch**: `202-adr-safeguard-span`

**Created**: 2026-10-31

**Status**: Draft

**Input**: User description: "When a decision turns on one safeguard in each already adopted service, and every matching architecture is bound by that same safeguard, do not ask which single architecture the decision uses. Record one decision that runs beside the current decision of each matched architecture. Do not replace those decisions and do not create a new architecture. Close to codify, one implementation at a time. When assessment starts, ask what to review: observed gaps against accepted architectures, or accepted artifacts ready for the next stage. Gaps stay the current findings list. Ready artifacts are grouped by record type from the catalogs, are not recorded as findings, and advancing one continues in the skill for its next stage. At the end of exploring a discovery option, say the person can select that option for the decision, and send that choice to the decision skill with the discovery and the option. Before discovery writes its options, check each option's named product or feature against that vendor's current public documentation. Remove an option whose product or feature the vendor no longer offers, and record the source. Leave an option out of the scored set when a required platform's support for it is not in accepted evidence. An inconclusive check stays an unknown and does not count as support."

## Clarifications

### Session 2026-10-31

- Q: Should an accepted implementation that already has one automation still appear in the "ready for the next stage" list? → A: List an implementation only when no accepted automation names it.
- Q: How many records should each category in the progression list show at once? → A: At most five per category, plus a line offering to show more when more remain.
- Q: When the progression view shows several categories, should the numbers run across the whole view or restart at 1 in each category? → A: Number the categories, letter the records.
- Q: If a discovery's decision was removed, should that discovery show up as ready for a new decision? → A: No. Any decision row, including a removed one, means the discovery already has a decision.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - See that one safeguard covers every matched service (Priority: P1)

A person has selected an option that turns on one safeguard in each service they already use. Several accepted architectures match, and every match is that same safeguard. The proposal names every matched architecture as the set this decision covers. It says the decision runs beside each current decision, that none of those decisions is replaced, and that no new architecture follows. It does not ask which one architecture the decision should use.

**Why this priority**: Asking the person to pick one service records the safeguard against that service only and leaves the others undecided. The person already chose each service.

**Independent Test**: Open a decision whose selected option turns on one safeguard for each matched architecture, with six architectures matched only by that safeguard. Read the proposal. It names all six, it does not ask which architecture to use, and nothing is written.

**Acceptance Scenarios**:

1. **Given** more than one architecture matches and every match is the same safeguard, and the selected option turns that safeguard on for each of those architectures, **When** the proposal is shown, **Then** it names every matched architecture and does not ask which architecture this decision should use.
2. **Given** that proposal, **When** it is read, **Then** it says the decision runs beside the current decision of each matched architecture, that none of those decisions is replaced, and that no new architecture follows.
3. **Given** the matches include an exact title, an identifier, or a capability, **When** the proposal is shown, **Then** the person is still asked which architecture this decision should use.
4. **Given** the matches are not all the same safeguard, **When** the proposal is shown, **Then** the person is still asked which architecture this decision should use.
5. **Given** exactly one architecture matches, **When** the proposal is shown, **Then** the existing replace-or-beside question is asked and this span is not used.
6. **Given** the person has not accepted the proposal, **When** the repository is read, **Then** nothing is written.

---

### User Story 2 - Narrow the set before accepting (Priority: P1)

The person can remove architectures from the set. The decision then covers only what remains. Narrowing to one architecture leaves the span and uses the existing single-architecture proposal, including its replace-or-beside question. The person cannot add an architecture that did not match.

**Why this priority**: "Each service" is the default. The person must still be able to keep the safeguard off one service without starting the decision over.

**Independent Test**: From a six-architecture span, remove one. The proposal names the remaining five and still does not ask for a single architecture. Remove until one remains. The proposal asks whether that decision replaces the current one or runs beside it.

**Acceptance Scenarios**:

1. **Given** the span proposal, **When** the person removes one matched architecture, **Then** the proposal names the remaining architectures and still does not ask which single architecture to use.
2. **Given** the person narrows the set to one architecture, **When** the proposal is shown again, **Then** it asks whether this decision replaces that architecture's current decision or runs beside it, and the removed architectures are not part of the decision.
3. **Given** the span proposal, **When** the person names an architecture that did not match, **Then** that architecture is not added.
4. **Given** the person declines the proposal, **When** the skill stops, **Then** nothing is written.

---

### User Story 3 - Record one decision against every architecture in the set (Priority: P1)

The person accepts the span. One decision is written. Each architecture in the set gains this decision beside its current decision. No current decision is superseded. No architecture is created, and no architecture's description changes. The decision's index names every architecture in the set. It does not use the empty architecture marker that means a new architecture will follow.

**Why this priority**: The proposal is lost if acceptance stores the decision against one architecture, or if an empty architecture marker sends the person to create a new one.

**Independent Test**: Accept a span of six. Read the decision, the index, and the six architectures. One decision exists. Each architecture lists it beside its existing decision. No decision is superseded. No new architecture exists. The index names all six.

**Acceptance Scenarios**:

1. **Given** the person accepts the span, **When** the decision is read, **Then** one decision is written and it names every architecture in the set.
2. **Given** acceptance succeeds, **When** each architecture in the set is read, **Then** this decision is listed beside the current decision and the earlier decision is still in force.
3. **Given** acceptance succeeds, **When** the architectures are counted, **Then** no architecture was created and no architecture's description changed.
4. **Given** acceptance succeeds, **When** the decision index is read, **Then** it names every architecture in the set and does not use the empty marker that means a new architecture will follow.
5. **Given** the same Discovery already has this decision, **When** it is opened again, **Then** the recorded decision is shown and nothing new is written.

---

### User Story 4 - Codify one implementation at a time (Priority: P1)

After the decision is recorded, the next step is codify for one implementation, not a new architecture and not a new implementation. The action is the decision title. One implementation is offered directly. Two to five are listed for a pick. More than five are not listed until the person names one. An implementation already covered by an accepted automation for this action is not offered again. Opening the recorded decision later continues with what is left and does not ask for the decision again.

**Why this priority**: The services are already adopted. The remaining work is turning the safeguard on in each one, and each of those is a separate piece of work.

**Independent Test**: Accept a span whose six architectures each have a current implementation and no automation for this action. The close asks which implementation to codify and lists none of them. Name one. The close gives one codify step for that implementation and this decision's title. Record an accepted automation for it, open the decision again, and that implementation is not offered.

**Acceptance Scenarios**:

1. **Given** every architecture in the set has a current implementation, **When** the close is read, **Then** it suggests codify and does not suggest creating an architecture or an implementation.
2. **Given** one uncovered implementation, **When** the close is read, **Then** it gives one codify step for that implementation's title and this decision's title.
3. **Given** two to five uncovered implementations, **When** the close is read, **Then** it lists each by title and, after the person picks one, gives one codify step for that implementation.
4. **Given** more than five uncovered implementations, **When** the close is read, **Then** it lists none and asks the person to name one. After they name one, it gives one codify step for that implementation.
5. **Given** an implementation already has an accepted automation for this decision's action, **When** the close is read, **Then** that implementation is not offered.
6. **Given** every implementation in the set is already covered, **When** the close is read, **Then** it says so and suggests no codify step.
7. **Given** the decision is already recorded, **When** it is opened again, **Then** the close offers only uncovered implementations and the decision is not proposed again.
8. **Given** a matched architecture has no current implementation, **When** the close is read, **Then** that architecture is named as not yet implemented, it is not offered for codify, and the implementations that do exist are still offered.

---

### User Story 5 - Choose gaps or ready records (Priority: P1)

Assessment opens by asking what the person would like to review. The first choice is observed gaps against accepted architectures. The second is accepted artifacts ready for the next stage. Choosing gaps shows the findings list assessment already shows. Nothing is written before the choice.

**Why this priority**: Assessment currently opens on findings. The person needs a way to review work that is ready to move forward without mixing that work into the findings.

**Independent Test**: Start assessment. Read the menu. It asks what to review and offers the two choices in that order. Choose gaps. The findings list is unchanged, and the progression list is absent.

**Acceptance Scenarios**:

1. **Given** assessment starts, **When** the first message is read, **Then** it asks **What would you like to review?** and offers observed gaps, then accepted artifacts ready for progression, numbered from 1.
2. **Given** the menu, **When** the person chooses observed gaps, **Then** the findings list is the one assessment already shows.
3. **Given** the menu and no choice yet, **When** the repository is read, **Then** nothing is written.

---

### User Story 6 - Advance a record that is ready for the next stage (Priority: P1)

The person chooses ready artifacts. Each record type is a category, in this order: requests, discoveries, decisions, architectures, and implementations. Under each category is an ordered list of the accepted records whose next stage does not exist yet. The catalogs decide that. These records are not findings. The person is asked which record to advance, and told they can return to the menu. Choosing one continues in the skill that owns the next stage. Assessment does not create that next record.

**Why this priority**: A request with no discovery, or an implementation with no automation, is waiting work. It should be offered for advancement without being stored as a gap.

**Independent Test**: With one accepted request that has no discovery, and one accepted implementation that already has an automation, open the progression view. The request is listed by title under requests and is marked ready for discovery. The implementation is absent. Choose the request. Discovery opens for that request, and the findings file is unchanged.

**Acceptance Scenarios**:

1. **Given** the person chooses ready artifacts, **When** the view is read, **Then** the categories appear in the order requests, discoveries, decisions, architectures, and implementations, and a category with nothing ready is omitted.
2. **Given** an accepted request that no discovery row names, **When** the view is read, **Then** that request is listed by title under requests as ready for discovery. A request named by a removed discovery row is not listed.
3. **Given** an accepted discovery that no decision row names, **When** the view is read, **Then** it is listed under discoveries as ready for a decision. A discovery named by a removed decision row is not listed.
4. **Given** an accepted decision whose architecture cell is the empty marker and that no architecture row lists, **When** the view is read, **Then** it is listed under decisions as ready for an architecture.
5. **Given** an accepted architecture with no accepted implementation, **When** the view is read, **Then** it is listed under architectures as ready for an implementation.
6. **Given** an accepted implementation with no accepted automation, **When** the view is read, **Then** it is listed under implementations as ready for codify.
7. **Given** a record that already has its next stage, or a removed or superseded row, **When** the view is read, **Then** that record is absent.
8. **Given** the view, **When** it is read, **Then** it asks which record to advance and says, in plain text, "If you'd like to return to the main menu, just say so."
9. **Given** the person returns to the menu, **When** assessment responds, **Then** the two-choice menu is shown and nothing is written.
10. **Given** the person chooses a listed record, **When** assessment continues, **Then** it opens the skill for that next stage and does not create the next record itself.
11. **Given** the progression view, **When** the findings file is read, **Then** no new finding was written.
12. **Given** a category has more than five ready records, **When** the view is read, **Then** it shows five in that category and offers to show more. Asking for more shows the next records in catalog order.
13. **Given** the view, **When** it is read, **Then** categories are numbered from 1 and the records in each category are lettered from `a`.
14. **Given** the view, **When** the person replies with a category number and a letter, such as `2b`, or with a record title, **Then** exactly that record is selected.
15. **Given** more than one category is shown, **When** the person replies with only a letter or only a category number, **Then** assessment asks again and writes nothing.

---

### User Story 7 - Select the explored option for the decision (Priority: P1)

After the person explores one discovery option, the exploration ending keeps its question and adds a plain-text line saying they can select this option for the decision. Choosing that line opens the decision skill on this discovery and this option. Discovery does not write the decision.

**Why this priority**: The exploration ending asks about concerns or returning to the list. The person who is ready to decide this option needs a direct way to say so without leaving the option.

**Independent Test**: Explore one option. Read the ending. The existing question is present, and the selection sentence follows it in plain text. Choose it. The decision skill opens on that option, and no decision file is written by discovery.

**Acceptance Scenarios**:

1. **Given** an option is being explored, **When** the ending is read, **Then** it asks **Are there any additional concerns you would like to explore for this option, or would you like to return to the list of options?** and then says, in plain text, "If you'd like to select this option for the Decision record, just say so."
2. **Given** that ending, **When** the person selects this option for the decision, **Then** the decision skill opens with this discovery and this option, at the decision proposal.
3. **Given** that choice, **When** the repository is read, **Then** discovery has written no decision.
4. **Given** the person uses the existing way to decide from the option list, **When** discovery responds, **Then** that existing path is unchanged.

---

### User Story 8 - Check product claims before the options are shown (Priority: P1)

Discovery has generated its options and has not written them yet. For each option that relies on a named product or feature, discovery checks that vendor's current public documentation. An option whose product or feature the vendor no longer offers is removed, and the person is told why, with the source. An option that depends on a required platform is left out of the scored options when accepted evidence does not say that platform supports it. A check that cannot confirm or contradict a claim leaves the option in place and records an unknown. The check does not change the score of an option that remains, and it does not override an accepted control, NFR, or constraint.

**Why this priority**: A proposed option that names a retired feature, or that assumes a required platform can do something the evidence does not support, sends the person into a decision about a solution discovery cannot stand behind.

**Independent Test**: Analyze a request whose generated options include one that relies on a named feature the vendor's current documentation says is no longer offered, and one that depends on a required platform the accepted evidence does not confirm. Read the option list. The retired option is absent and named in a sentence that cites the source. The unconfirmed platform option is absent and named as unconfirmed. A third option, whose vendor documentation could not be found, is listed, and the discovery records that the check was inconclusive.

**Acceptance Scenarios**:

1. **Given** a generated option relies on a named product or feature, **When** the vendor's current public documentation says that product or feature is deprecated, retired, or no longer offered, **Then** the option is not written and not shown, and one plain sentence before the option list names the option and the source.
2. **Given** the vendor's documentation still describes the named product or feature, **When** the options are written, **Then** the option remains and its score is the score it would have had without the check.
3. **Given** no vendor documentation is found, only a secondary source is found, or the check cannot be completed, **When** the options are written, **Then** the option remains, the discovery records the check as inconclusive, and the option is not treated as confirmed.
4. **Given** one vendor page still describes the product or feature and another says it is no longer offered, **When** the options are written, **Then** the option is removed and both sources are recorded.
5. **Given** an option depends on a platform named by the request's required platforms, and the accepted request, clarification, profile, objectives, controls, NFRs, and architectures do not say that platform supports the option, **When** the options are written, **Then** the option is not scored and not shown, and one plain sentence names the option and the platform. Vendor documentation that the product includes the capability does not count as this organization's platform supporting it.
6. **Given** the required platforms are unknown, **When** the options are written, **Then** no option is held out for platform support.
7. **Given** an option names no product or feature, **When** the check runs, **Then** that option is unchanged.
8. **Given** removals and holds leave fewer than two options, **When** discovery stops, **Then** it names what was removed or held, and it writes nothing.
9. **Given** the person adds or replaces an option after the list is shown, **When** discovery updates the record, **Then** this check does not remove that option.
10. **Given** a discovery was already written, **When** it is opened, **Then** the recorded options are shown and this check does not run again.

---

### Edge Cases

- Nothing matches. The decision stands on its own and a new architecture follows, as it does today.
- The person narrows a span to one architecture and chooses replace. Only that one current decision is superseded. The architectures removed from the set are unchanged.
- The person narrows a span to one architecture and chooses beside. The decision is added only to that architecture.
- A span of two to five uses the same beside-each proposal as a span of six. Only the close changes with the count.
- One architecture in the set has a current implementation and another does not. Codify is offered only for the one that has an implementation. The other is named as not yet implemented.
- No architecture in the set has a current implementation. The close names them and its one next step is to create the implementation for the first of them. The decision still applies to all of them.
- The person names an implementation that is not in the set. It is not offered, and the close asks again.
- The person declines the proposal. Nothing is written.
- Opening a recorded decision that is not a span still shows that decision and writes nothing. Its close is unchanged.
- Assessment is opened and nothing is accepted yet. The menu is shown and nothing is written.
- The person asks to review gaps. The findings list is the one assessment already shows. No progression list is shown.
- No accepted record is ready for a next stage. The progression view says so, offers the return line, and writes nothing.
- A category has no ready record. That category is omitted. The other categories are still shown.
- The person names a record that is not in the progression list, or a letter that is not in the named category. Assessment asks again and writes nothing.
- Only one category is shown. A letter alone selects that record.
- The person returns to the menu from the progression view. The two-choice menu is shown again.
- The person selects the explored option for the decision. Discovery does not write a decision. The decision skill opens on that option.
- Vendor documentation contradicts a named product or feature. That option is removed before the options are written. The person is told the option and the source. The scores of the options that remain are unchanged.
- One vendor page describes the product or feature and another says it is no longer offered. The option is removed and both sources are recorded.
- No vendor documentation is found, or only a blog, forum, or comparison is found, or the check cannot be completed. The option remains and the check is recorded as inconclusive.
- An option depends on a required platform and accepted evidence does not confirm support. The option is named and left out of the scored options. The person can add it. Public documentation that the product includes the capability does not put the option back.
- Required platforms are unknown. No option is held out for platform support.
- The check leaves fewer than two options. Discovery names what was removed or held and writes nothing.
- The person adds an option after the list is shown. The check does not remove it.
- A recorded discovery is opened. The recorded options are shown and the check does not run again.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: When more than one architecture matches, every match is the same safeguard, and the selected option turns that safeguard on for each matched architecture, `highway-adr` MUST show one span proposal and MUST NOT ask which architecture this decision should use.
- **FR-002**: The span proposal MUST name every matched architecture. It MUST say the decision runs beside the current decision of each, that none of those decisions is replaced, and that no new architecture follows.
- **FR-003**: The span MUST NOT apply when any match is an exact title, an identifier, or a capability, or when the matches are not all the same safeguard. Those proposals MUST keep the existing choice of one architecture.
- **FR-004**: Exactly one matching architecture MUST keep the existing replace-or-beside question. A span MUST NOT be shown for one architecture.
- **FR-005**: The person MUST be able to remove matched architectures before acceptance. The revised proposal MUST cover only what remains. Narrowing to one architecture MUST leave the span and MUST ask whether that decision replaces the current decision or runs beside it.
- **FR-006**: An architecture that did not match MUST NOT be added to the set. Declining the proposal MUST write nothing.
- **FR-007**: Acceptance of a span MUST write one decision that names every architecture still in the set. One Discovery MUST still produce at most one decision.
- **FR-008**: Acceptance MUST add this decision beside the current decision of each architecture in the set. It MUST NOT supersede those decisions, MUST NOT create an architecture, and MUST NOT change an architecture's description.
- **FR-009**: The decision index MUST name every architecture in the set. It MUST NOT use the empty architecture marker that means a new architecture will follow.
- **FR-010**: The recorded decision MUST authorize no new architecture and no new implementation. Its required architecture work MUST be none.
- **FR-011**: When every architecture in the set has a current implementation, the close MUST suggest exactly one next step, and that step MUST be codify. It MUST NOT suggest creating an architecture or an implementation.
- **FR-012**: The codify step MUST name one implementation title and this decision's title as the action. One uncovered implementation MUST be offered directly. Two to five MUST be listed by title for a pick. More than five MUST list none until the person names one.
- **FR-013**: An implementation that already has an accepted automation for this decision's action MUST NOT be offered. When every implementation in the set is covered, the close MUST say so and MUST suggest no codify step.
- **FR-014**: Opening an already recorded span MUST show the recorded decision, MUST write nothing, and MUST offer only the implementations that are still uncovered. The decision MUST NOT be proposed again.
- **FR-015**: An architecture in the set with no current implementation MUST be named as not yet implemented and MUST NOT be offered for codify. Implementations that exist MUST still be offered. When none exist, the one next step MUST be to create the implementation for the first architecture in the set.
- **FR-016**: The request close, and the rules for a decision that is not a span, MUST stay as they are. The span behavior MUST be imperative steps in `highway-adr`. The system MUST NOT add a second skill for the span.
- **FR-017**: When assessment starts, it MUST ask **What would you like to review?** and offer two numbered choices, in this order: observed gaps against accepted architectures, then accepted artifacts ready for progression to the next stage. Nothing is written before a choice.
- **FR-018**: Choosing observed gaps MUST show the findings list assessment already shows. That list, and the finding the person then opens, MUST keep their current behavior.
- **FR-019**: Choosing ready artifacts MUST group them by record type, in this order: requests, discoveries, decisions, architectures, and implementations. Each category MUST be an ordered list of the records in that category that are ready for the next stage, showing at most five. When more remain in any category, the view MUST offer to show more, and showing more MUST continue each category after the records already shown. A category with no ready record MUST be omitted. The determination MUST use the accepted catalogs. These records MUST NOT be written as findings.
- **FR-020**: A record is ready only when its catalog row is accepted and its next stage has not been started, as defined here for each record type. An accepted request is ready for discovery only when no discovery row names it. A removed discovery row still counts. An accepted discovery is ready for a decision only when no decision row names it. A removed or superseded decision row still counts, so that discovery is not ready. An accepted decision is ready for an architecture when its architecture cell is the empty marker and no architecture row lists it. A removed architecture row still counts. An accepted architecture is ready for an implementation when no accepted implementation names it. An accepted implementation is ready for codify only when no accepted automation names it. An implementation with one or more accepted automations is not listed, and the person can still run codify for it directly. A removed or superseded row is not ready.
- **FR-021**: Categories MUST be numbered from 1 in the order shown. Within a category, records MUST be lettered from `a`, in catalog order, and showing more MUST continue that category's letters. Each item MUST show the record title and the stage it is ready for. It MUST NOT use an id as the label. A category number with a letter, such as `2b`, or a record title, MUST select exactly one record. A category number alone, or a letter alone when more than one category is shown, MUST ask again and write nothing.
- **FR-022**: The progression view MUST ask which record the person would like to advance, and MUST say, in plain text, "If you'd like to return to the main menu, just say so." Returning shows the two-choice menu again and writes nothing. A record that is not listed asks again and writes nothing. When no record is ready, the view says so, keeps the return line, and writes nothing.
- **FR-023**: Choosing a ready record MUST continue in the skill for its next stage and MUST NOT create that next record inside assessment. A request continues as `highway-discovery` with that request. A discovery continues as `highway-adr` with that discovery. A decision continues as `highway-architecture` with that decision. An architecture continues as `highway-implementation` with that architecture. An implementation continues as `highway-codify` with that implementation's title.
- **FR-024**: After the exploration question **Are there any additional concerns you would like to explore for this option, or would you like to return to the list of options?**, discovery MUST add, in plain text, "If you'd like to select this option for the Decision record, just say so."
- **FR-025**: Choosing that sentence MUST continue as `highway-adr` with this Discovery id and this option id, at the start of the decision proposal. Discovery MUST NOT create the decision. The existing exploration question, and the existing way to decide without that sentence, MUST stay.
- **FR-026**: Before discovery writes its options, it MUST check each generated option that relies on a named product or feature against that vendor's current public documentation. The check MUST use the product or feature name and the vendor name only. An option that names no product or feature MUST be left unchanged.
- **FR-027**: When the vendor's current public documentation says the named product or feature is deprecated, retired, or no longer offered, discovery MUST remove that option before scoring. When one vendor page still describes it and another says it is no longer offered, discovery MUST remove the option and record both sources. The option MUST NOT be written or shown.
- **FR-028**: When vendor documentation still describes the named product or feature, the option MUST remain. The check MUST NOT change that option's score and MUST NOT override an accepted control, NFR, or constraint.
- **FR-029**: When no vendor documentation is found, only a secondary source is found, or the check cannot be completed, the option MUST remain. Discovery MUST record the check as inconclusive. An inconclusive check MUST NOT be treated as confirmation.
- **FR-030**: Each check MUST be recorded with the claim, the source, and the result: contradicted, confirmed, or inconclusive. A result from this check is not accepted repository evidence.
- **FR-031**: An option that depends on a platform named in the request's required platforms MUST be left out of the scored options when the accepted request, clarification, profile, objectives, controls, NFRs, and architectures do not say that platform supports the option. Vendor documentation that the product includes the capability MUST NOT count as support. When the required platforms are unknown, this hold MUST NOT apply.
- **FR-032**: A removed option and a held option MUST each be named in one plain sentence before the option list, or in the stop message when fewer than two options remain. The sentence for a removed option MUST name the source. The sentence for a held option MUST name the platform. Discovery MUST write nothing when fewer than two options remain.
- **FR-033**: An option the person adds or replaces after the list is shown MUST NOT be removed by this check. Opening a discovery that is already written MUST show the recorded options and MUST NOT run this check again.

### Key Entities

- **Span**: One accepted decision applied beside the current decision of every architecture matched by the same safeguard. It is one decision, not one decision per architecture.
- **Safeguard match**: A match that exists only because the architecture is bound by one Control or one NFR. A match by exact title, identifier, or capability is not a safeguard match.
- **Covered implementation**: A current implementation of an architecture in the set that already has an accepted automation for this decision's action.
- **Empty architecture marker**: The index value that means no architecture is reused and a new architecture will follow. A span does not use it.
- **Ready record**: An accepted catalog row whose next stage has not been started, under the rule for its record type in FR-020. It is shown for advancement and is not a finding.
- **Review menu**: The two choices assessment offers at the start: observed gaps, or accepted artifacts ready for the next stage.
- **Product claim**: A named product or feature a generated option relies on. An option with no named product or feature has no product claim.
- **Vendor documentation**: The vendor's current public documentation, product pages, or release notes. A blog, forum, or comparison is a secondary source.
- **Inconclusive check**: A product-claim check that found no vendor documentation, found only a secondary source, or could not be completed. The option remains, and the result is not confirmation.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A span of 6 architectures asks the single-architecture question 0 times and names all 6 architectures in the proposal.
- **SC-002**: Accepting that span writes 1 decision, supersedes 0 decisions, creates 0 architectures, and adds the decision to 6 current-decision lists.
- **SC-003**: The decision index names 6 architectures and uses the empty architecture marker 0 times.
- **SC-004**: The close suggests 1 next step. When all 6 architectures have current implementations, that step is codify 1 time and a suggestion to create an architecture or an implementation 0 times.
- **SC-005**: With 6 uncovered implementations, the close lists 0 implementations until the person names 1, then gives 1 codify step for that implementation and this decision's title.
- **SC-006**: After that implementation is covered, opening the decision again writes 0 files and offers that implementation 0 times.
- **SC-007**: Narrowing a span to 1 architecture asks the replace-or-beside question 1 time and adds the decision to 0 of the removed architectures.
- **SC-008**: Assessment asks the review question 1 time at the start and offers 2 choices. Choosing gaps shows the findings list 1 time and the progression list 0 times.
- **SC-009**: A progression view writes 0 findings and shows at most 5 records per category. Each ready record appears in 1 category, in catalog order, labeled by its title. Choosing one continues in 1 next-stage skill and creates that next record in assessment 0 times.
- **SC-010**: The exploration ending shows the selection sentence 1 time. Choosing it opens the decision skill on that option 1 time and writes 0 decisions in discovery.
- **SC-011**: An option whose vendor documentation says the named feature is no longer offered is shown 0 times, changes the score of each remaining option 0 times, and is named with its source 1 time.
- **SC-012**: An option whose required platform is unconfirmed by accepted evidence is scored 0 times. Vendor documentation that the product includes the capability puts that option back 0 times. An inconclusive check leaves the option listed 1 time and records the result as inconclusive.

## Assumptions

- A safeguard match is a match by one Control or one NFR. Matches by exact title, identifier, or capability stay on the existing single-choice path even when a safeguard also matches.
- The span applies when the selected option turns that one safeguard on for each matched architecture and does not choose a new service. An option that chooses among the matched architectures keeps the existing question.
- "Runs beside" means each existing adoption decision stays in force. This feature does not offer replace while more than one architecture remains in the set.
- The codify wording is the one the request close already uses: one step names the implementation title and the action. The action is this decision's title.
- An implementation is covered when an accepted automation for that implementation carries this decision's title as its action.
- Architectures in the set are ordered as they appear in the architecture index. "The first" means the first in that order.
- Opening a recorded span uses the decision already written. It does not start a second decision for the same Discovery.
- The suggestion list, the task list, and the coding standards are unchanged. The span decides where the decision is recorded and which one implementation is offered next.
- Ready records are read from the accepted catalogs only. A catalog row that is removed or superseded is not ready. A span decision names architectures, so its architecture cell is not the empty marker and it is not offered for a new architecture.
- The progression list shows at most five records per category, the same cap as the other choice lists. More are shown only when the person asks.
- Assessment does not write the request, discovery, decision, architecture, implementation, or automation. It continues in the skill that owns the next stage.
- The new discovery sentence selects the option being explored. It does not open the decision skill on a different option. The existing sentence that says the person can decide, on the option list, stays where it is.
- The product-claim check runs after options are generated and before they are scored and written. The two-to-five cap is applied after removals and holds, so a removed option does not take a place. Removing an option can change which option is recommended, because the recommendation is chosen from the options that remain. It does not change how a remaining option is scored.
- A removed option is recorded in the Candidate Elimination Log with the category `product currency` and the source. A held option is recorded there with the category `required platform` and the platform name. The person can add a held option through the existing way to add an option.
- Accepted evidence for platform support is the request, its clarification, the profile, objectives, controls, NFRs, and reference architectures. The check sends only the product or feature name and the vendor name.
- Opening a recorded discovery shows the options that were written. A later change in vendor documentation is picked up when a new analysis writes new options.
