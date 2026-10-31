---
description: "Task list for the ADR safeguard span, assessment review, and discovery checks"
---

# Tasks: ADR Safeguard Span

**Input**: Design documents from `/specs/202-adr-safeguard-span/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: The specification does not request test-first work per story. The plan adds `.highway/tools/tests/adr-span-progression.test.sh`. T006 writes that test and records it failing before any skill edit. No existing assertion is removed.

**Organization**: Tasks are grouped by user story. All eight stories are P1 and stay in spec order. Task IDs follow execution order.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1 through US8)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prove the suite is green before any edit

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing summary in `specs/202-adr-safeguard-span/baseline.txt`. Stop if it exits non-zero

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Let one decision name several architectures, and let a discovery record a product-claim check

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 [P] Update `.highway/library/templates/output/adr-catalog.md` to version 4.1.0 per `specs/202-adr-safeguard-span/contracts/adr-span.md`. Keep every current column and the sentence that `None` means a new architecture will follow. Add that a span lists every RA id in the Architecture ID cell, in id order, separated by a comma and a space
- [X] T003 [P] Update `.highway/library/templates/output/adr-record.md` to version 3.1.0 per `specs/202-adr-safeguard-span/contracts/adr-span.md`. Keep the handoff free of an implementation entry. Add that a span's `Reference Architecture` lists the same RA ids as the catalog cell, in id order, separated by a comma and a space
- [X] T004 [P] Update `.highway/library/templates/output/architecture-catalog.md` to version 3.1.0 per `specs/202-adr-safeguard-span/contracts/adr-span.md`. Keep the sentence `An ADR id appears on at most one row.` Add that a span decision appears on the row of each architecture it names. Do not edit `.highway/skills/highway-architecture/SKILL.md`
- [X] T005 [P] Update `.highway/library/templates/output/discovery-record.md` to version 1.1.0 per `specs/202-adr-safeguard-span/contracts/product-claim-check.md`. Keep findings from the closed request. Add one check entry shape under `## Research Findings`: `Claim`, `Source` or `None`, and `Result` of `contradicted`, `confirmed`, or `inconclusive`, and state that a check result is not accepted repository evidence. State that the elimination log allows categories `product currency` and `required platform`
- [X] T006 Create `.highway/tools/tests/adr-span-progression.test.sh` as a static document contract test. Begin with `# Instrument class: static-document-contract`, `# Artifact classes: source-document`, and a `# Seeded failure probe:` line. Require the span proposal, the narrowing sentence, the multi-id catalog cell, the codify close, the review question, the ready-record letters, the discovery selection sentence, and the product-claim check sentences named in `specs/202-adr-safeguard-span/contracts/`. Require `An ADR id appears on at most one row.` to remain, and reject the literal `/highway-codify` in `.highway/skills/highway-assessment/SKILL.md`. Run the test once, record the failure in `specs/202-adr-safeguard-span/probe-fail.txt`, and do not edit a skill to make it pass

**Checkpoint**: The four templates are updated and the new test has been seen failing

---

## Phase 3: User Story 1 - See that one safeguard covers every matched service (Priority: P1) 🎯 MVP

**Goal**: A safeguard-only multi-match shows one span proposal and does not ask which architecture to use

**Independent Test**: Read the proposal for six architectures matched only by one safeguard. It names all six, it does not ask which architecture to use, and nothing is written

### Implementation for User Story 1

- [X] T007 [US1] In `.highway/skills/highway-adr/SKILL.md` `start`, per `specs/202-adr-safeguard-span/contracts/adr-span.md`, show the span proposal when more than one architecture matches, every match is the same Control id or every match is the same NFR id, the selected option's alignment names that id, and the option title names none of the matched architectures. The Architecture line says the decision runs beside the current decision of each, that none of those decisions is replaced, and that no new architecture follows, then one bullet per architecture title in id order with no cap. Do not ask **Which architecture should this decision use?** Keep that question when any match is an identifier, an exact title, or a capability, or when the matches are not all the same safeguard. Keep the replace-or-beside question when exactly one architecture matches. Write nothing before acceptance

**Checkpoint**: The span proposal can be read and declined without a write

---

## Phase 4: User Story 2 - Narrow the set before accepting (Priority: P1)

**Goal**: The person can leave architectures out, and one remaining architecture returns to the replace-or-beside question

**Independent Test**: From a six-architecture span, remove one and read five with no single-architecture question. Remove until one remains and read the replace-or-beside question

### Implementation for User Story 2

- [X] T008 [US2] In `.highway/skills/highway-adr/SKILL.md` `start`, per `specs/202-adr-safeguard-span/contracts/adr-span.md`, add the plain-text line `If you'd like to leave out any of these architectures, just say so.` A reply that leaves two or more re-emits the span proposal with one consequence sentence. A reply that leaves one leaves the span and asks **Does this decision replace [decision], or run beside it?** An architecture that did not match is not added. Decline writes nothing

**Checkpoint**: Narrowing changes the proposal and still writes nothing

---

## Phase 5: User Story 3 - Record one decision against every architecture in the set (Priority: P1)

**Goal**: Acceptance writes one decision beside each architecture in the set and creates no architecture

**Independent Test**: Accept a span of six. One decision exists, each architecture lists it beside its current decision, nothing is superseded, and the index names all six

### Implementation for User Story 3

- [X] T009 [US3] In `.highway/skills/highway-adr/SKILL.md` `write`, per `specs/202-adr-safeguard-span/contracts/adr-span.md` and `specs/202-adr-safeguard-span/data-model.md`, write the ADR record, the ADR catalog row, each architecture's Current Decisions, and each architecture catalog ADR ID cell together, or write none. Set `supersedes` to `None`, name every architecture by title in Decision Scope, set Required Architecture Work to `None`, and list every RA id in id order, separated by a comma and a space, in the handoff and in the catalog Architecture ID cell. Add this ADR id beside each current decision. Do not supersede a decision, create an architecture, or change an architecture's description. One Discovery still has at most one ADR

**Checkpoint**: Accepting a span updates the decision and every architecture in one write

---

## Phase 6: User Story 4 - Codify one implementation at a time (Priority: P1)

**Goal**: The span close offers codify for one uncovered implementation, and opening the recorded span continues there

**Independent Test**: Accept a span of six current implementations with no automation for this action. The close lists none and asks for one. After that implementation is covered, opening the decision does not offer it

### Implementation for User Story 4

- [X] T010 [US4] In `.highway/skills/highway-adr/SKILL.md` Entry and `close`, per `specs/202-adr-safeguard-span/contracts/adr-span.md`, show a recorded decision and write nothing, and go to `close` when its Architecture ID cell names more than one architecture. Name each architecture in the set with no current implementation as not yet implemented. Then offer one of: `/highway-implementation [first RA id]` when none exist; a sentence that every implementation already has an automation for this decision title and no codify step when all are covered; `Run /highway-codify for **[Implementation title]** to **[Decision title]**.` for one uncovered implementation; a title list and **Which implementation would you like to codify first?** for two to five; no list and that question for more than five. Coverage is an accepted `code/code.md` row whose Action is the decision title. A name outside the uncovered set asks again. Leave the non-span close unchanged
- [X] T011 [US4] In `.highway/skills/highway-adr/SKILL.md`, bump `metadata.version` from 4.0.0 to 5.0.0 and add Verification bullets for the span proposal, the narrowing rule, the multi-id write, and the codify close. Add no MUST-level rule. Keep the frontmatter description and usage unchanged

**Checkpoint**: A recorded span offers only uncovered implementations

---

## Phase 7: User Story 5 - Choose gaps or ready records (Priority: P1)

**Goal**: Assessment opens by asking what to review, and gaps show the findings list unchanged

**Independent Test**: Start assessment. The first message asks what to review and offers gaps, then ready artifacts. Choosing gaps shows the findings list and no progression list

### Implementation for User Story 5

- [X] T012 [P] [US5] In `.highway/skills/highway-assessment/SKILL.md`, per `specs/202-adr-safeguard-span/contracts/assessment-review.md`, change Entry to go to `review`. Add reply classes `gaps` and `ready` without changing the existing `select` or `more` lines. `review` asks **What would you like to review?** and offers `1. Observed gaps against accepted architectures.` then `2. Accepted artifacts ready for progression to the next stage (requests, discoveries, decisions, architectures, and implementations).` `gaps` goes to `list of findings` unchanged, including its first-visit heading. A domain argument still applies to findings. Write nothing before a choice

**Checkpoint**: The menu is the first message and the findings list is unchanged

---

## Phase 8: User Story 6 - Advance a record that is ready for the next stage (Priority: P1)

**Goal**: Ready records are grouped from the catalogs, capped at five per category, and choosing one continues in the next skill

**Independent Test**: With one accepted request that no discovery names, and one implementation that already has an automation, the request is listed under requests and the implementation is absent. Choosing the request continues as discovery and writes no finding

### Implementation for User Story 6

- [X] T013 [US6] In `.highway/skills/highway-assessment/SKILL.md`, add `ready records` per `specs/202-adr-safeguard-span/contracts/assessment-review.md` and the readiness table in `specs/202-adr-safeguard-span/data-model.md`. Read the six catalogs and do not open records. Categories are numbered from 1 in the order requests, discoveries, decisions, architectures, implementations, and an empty category is omitted. Records are lettered from `a` as `**a. [Record title]:** Ready for [stage].`, at most five per category, and showing more continues the letters. Ask **Which record would you like to advance?** End with `If you'd like to return to the main menu, just say so.` Offer `If you'd like to see more records, just say so.` only when more remain. Add classes `advance` and `menu`. `advance` continues as the next skill and does not create the record. The codify handoff continues as `highway-codify` with the implementation title and does not contain `/highway-codify`. A number alone, or a letter alone when more than one category is shown, asks again and writes nothing. When nothing is ready, say so and keep the return line. Write no finding
- [X] T014 [US6] In `.highway/skills/highway-assessment/SKILL.md`, bump `metadata.version` from 4.0.0 to 5.0.0 and add Verification bullets for the review menu, the five-record cap, the lettered records, and the handoffs. Keep every string `.highway/tools/tests/onboarding-assessment-guidance.test.sh` requires. Add no MUST-level rule

**Checkpoint**: A ready record continues in the next skill and is not a finding

---

## Phase 9: User Story 7 - Select the explored option for the decision (Priority: P1)

**Goal**: The exploration ending says the person can select this option, and that choice opens the decision on it

**Independent Test**: Explore one option. The existing question is present and the selection sentence follows it. Choosing it opens the decision skill on that option and writes no decision

### Implementation for User Story 7

- [X] T015 [P] [US7] In `.highway/skills/highway-discovery/SKILL.md` `explore`, per `specs/202-adr-safeguard-span/contracts/discovery-select.md`, after the exploration question add the plain-text line `If you'd like to select this option for the Decision record, just say so.` Add reply class `adopt`. `adopt` continues as `highway-adr` with this Discovery id and this option id at `start` and does not create the ADR. Leave the `decide` class and its handling in `start` and `explore` unchanged

**Checkpoint**: The selection sentence hands this option to the decision skill

---

## Phase 10: User Story 8 - Check product claims before the options are shown (Priority: P1)

**Goal**: A named product the vendor no longer offers is removed before scoring, and an unconfirmed required platform is held out of the scored options

**Independent Test**: Analyze a request with one retired feature and one unconfirmed required platform. Both are absent and named. An option whose vendor documentation cannot be found is listed and recorded as inconclusive

### Implementation for User Story 8

- [X] T016 [US8] In `.highway/skills/highway-discovery/SKILL.md` `analyze` and `start`, per `specs/202-adr-safeguard-span/contracts/product-claim-check.md`, check each generated option that names a product or feature after constraint exclusions and before the two-to-five cap and scoring. Send only the product or feature name and the vendor name. Remove the option when the vendor's current public documentation says it is deprecated, retired, or no longer offered, including when another vendor page still describes it, and record both sources. Keep the option and its score when the vendor still describes it. Keep the option and record `inconclusive` when no vendor documentation is found, only a secondary source is found, or the check cannot be completed. Hold out an option that depends on a platform in `existing_platforms_required` when accepted evidence does not say that platform supports it. Vendor documentation does not count, and unknown required platforms hold nothing. Record each check in Research Findings and each removed or held option in the elimination log with an `OPT` id, Status `Excluded`, and category `product currency` or `required platform`. Before the option list, after the current-implementation notice, one sentence names each removed option and its source, and one names each held option and its platform. Fewer than two remaining options names them and writes nothing. An option the person adds or replaces is not checked. Opening a written discovery does not run the check
- [X] T017 [US8] In `.highway/skills/highway-discovery/SKILL.md`, bump `metadata.version` from 4.0.0 to 5.0.0 and add Verification bullets for the check, the inconclusive result, the required-platform hold, and the selection sentence. Add no MUST-level rule. Keep the frontmatter description and usage unchanged

**Checkpoint**: Retired claims and unconfirmed platforms are absent from the scored options

---

## Phase 11: Polish & Cross-Cutting Concerns

**Purpose**: Validate, publish, and prove the suite is green

- [X] T018 Run `.highway/tools/validate-skill.sh` on `.highway/skills/highway-adr`, `.highway/skills/highway-assessment`, `.highway/skills/highway-discovery`, `.highway/skills/highway-architecture`, and `.highway/skills/highway-onboarding`, and `.highway/tools/validate-library.sh` on the four changed templates. Repair only reported authoring-rule failures. Do not edit `.highway/skills/highway-architecture/SKILL.md` or `.highway/skills/highway-onboarding/SKILL.md`
- [X] T019 Run `.highway/tools/generate-library-catalog.sh`, `.highway/tools/generate-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh`
- [X] T020 Run `.highway/tools/tests/run-all.sh` once, with no other suite running, and require exit 0
- [X] T021 Execute the checks in `specs/202-adr-safeguard-span/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup. T006 depends on T002 through T005. Blocks every user story
- **User Stories (Phases 3 to 10)**: Depend on Foundational
- **Polish (Phase 11)**: Depends on every user story

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational. The span proposal
- **User Story 2 (P1)**: Starts after User Story 1. Narrows that proposal
- **User Story 3 (P1)**: Starts after User Story 2. Writes the accepted span
- **User Story 4 (P1)**: Starts after User Story 3. Closes and resumes the recorded span
- **User Story 5 (P1)**: Starts after Foundational. No dependency on the ADR stories
- **User Story 6 (P1)**: Starts after User Story 5. The ready view uses the menu
- **User Story 7 (P1)**: Starts after Foundational. No dependency on the ADR or assessment stories
- **User Story 8 (P1)**: Starts after User Story 7. The check and the selection sentence edit the same skill

### Parallel Opportunities

- T002, T003, T004, and T005 edit different templates and can run together
- T007 through T011 edit `.highway/skills/highway-adr/SKILL.md` and stay in order
- T012 through T014 edit `.highway/skills/highway-assessment/SKILL.md` and can run alongside the ADR tasks
- T015 through T017 edit `.highway/skills/highway-discovery/SKILL.md` and can run alongside the ADR and assessment tasks
- Do not parallelize two tasks that edit the same skill

---

## Parallel Example: User Story 5

```text
Task: "T007 Show the span proposal in .highway/skills/highway-adr/SKILL.md"
Task: "T012 Open assessment on the review menu in .highway/skills/highway-assessment/SKILL.md"
Task: "T015 Add the selection sentence in .highway/skills/highway-discovery/SKILL.md"
```

---

## Implementation Strategy

### MVP First (User Story 1)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Stop and read a six-architecture span proposal. It names all six and asks no single-architecture question

### Incremental Delivery

1. User Stories 1 through 4 record a span and offer codify one implementation at a time
2. User Stories 5 and 6 open assessment on the review menu and advance a ready record
3. User Story 7 selects the explored option for the decision
4. User Story 8 checks product claims before the options are written
5. Polish validates, regenerates, and requires a green suite

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to a user story for traceability
- Do not commit unless asked
- Stop at any checkpoint to validate that story on its own
