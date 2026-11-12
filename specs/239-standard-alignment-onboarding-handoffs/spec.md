# Feature Specification: Standard Alignment Onboarding Handoffs

**Feature Branch**: `feature/std-alignment-phase10`

**Created**: 2026-11-11

**Status**: Draft

**Input**: User description: "create a new spec to implement phase 10 of standard-alignment.md". Phase 10 (Onboarding Handoffs) makes highway-adr, highway-architecture, and highway-implementation the only creators of their records, with highway-onboarding handing each record to its owner, following the Phase 1 resolutions. `adr-record.md`, `architecture-record.md`, and `implementation-record.md` move to the `assets/` of highway-adr, highway-architecture, and highway-implementation. Each of the three gains an onboarding entry step that writes its record as accepted without asking the person, with the onboarding rules from highway-onboarding. highway-onboarding drops its ADR-writing section and its architecture and implementation rules, and hands each record to its owner. highway-architecture drops the ADR template, and highway-adr drops the architecture template. The ADR catalog gap closes: onboarding and highway-architecture's `name` step leave `adrs/adrs.md` in the same state. Harness scenarios cover onboarding end to end, including the chain where highway-implementation's `execution` step starts onboarding and returns. Exit: `.highway/library/templates/` is empty, onboarding produces the same records as before, and the full suite and harness pass.

## Clarifications

### Session 2026-11-11

- Q: During onboarding, highway-architecture or highway-implementation derives an id already taken by a different title, or an architecture purpose would be empty or name a product. Today's onboarding text uses the owners' identifier rules but forbids their questions, so it does not say what happens. What should the onboarding entry step do? → A: Ask the person in this one case, with the owner's existing title question, then continue onboarding. Nothing is written for that record until the person gives a usable title.
- Q: When a person edits an onboarded ADR, Reference Architecture, or Reference Implementation from onboarding's `review` step, which skill should apply the edit? → A: Onboarding keeps applying review edits itself, editing the person's record in its existing structure, with no template. The owners stay the only creators.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Onboarding hands each record to the skill that owns it (Priority: P1)

A person runs `/highway-onboarding`, accepts the capabilities, maps each one to a provider, and accepts the mapping. For each provider, Highway writes a decision, a Reference Architecture, and a Reference Implementation, as it does today. The person sees the same conversation and gets the same records. Behind that, highway-onboarding no longer writes any of the three records itself. It passes what it learned to highway-adr, then highway-architecture, then highway-implementation, and each writes its own record through a new onboarding entry step, without asking the person anything unless a title cannot be used (scenario 9).

**Why this priority**: This is the phase's purpose. Each kind of record gets exactly one skill that creates it, so the record's rules and template live in one place. That is what lets each template move into its owner's folder (User Story 2), and it removes the second copy of the ADR, architecture, and implementation rules from highway-onboarding.

**Independent Test**: Run onboarding for one provider in a set-up project, before and after the change, with the same replies. Compare the conversation and every file written.

**Acceptance Scenarios**:

1. **Given** a set-up project and an accepted provider mapping, **When** onboarding reaches `orchestrate` for a provider, **Then** highway-adr writes the ADR, then highway-architecture writes the Reference Architecture for that ADR, then highway-implementation writes the Reference Implementation for that architecture, each without a question, a starting point, or an acceptance request, except the title question in scenario 9.
2. **Given** the same project, mapping, and evidence before and after the change, **When** onboarding finishes, **Then** it has written the same files at the same paths, with the same ids, sections, field values, and catalog rows, including the ADR catalog Architecture ID that onboarding already sets.
3. **Given** an onboarding ADR, **When** a maintainer reads it, **Then** it has `request: onboarding` and `discovery: highway`; Discovery, Request, Recommendation, Recommendation Rationale, Comparison Matrix, Reference Architecture Matches, and Discovery Confidence are `None`; it has no Recommendation Override; Selected Option is the provider name and Selection Source is `Accepted onboarding mapping`; each alternative is headed by its name with no option id; and its catalog row has Discovery ID `highway` and Request ID `onboarding`.
4. **Given** an onboarding architecture, **When** a maintainer reads it, **Then** its Current Decisions list is the onboarding ADR, it has no Key Technologies, its status is `accepted`, and its catalog ADR ID cell is that ADR id.
5. **Given** an onboarding implementation, **When** a maintainer reads it, **Then** its Execution is `Deployed by: Needed`, `Managed by: Needed`, and `Language: Needed`; it has its `RI` id and `RA` parent; and its coverage, conformance, realized interface, conformance evidence, limitations, single technology choice, and single architecture reference follow the onboarding rules that highway-onboarding holds today.
6. **Given** an onboarded implementation that can start automation, **When** highway-implementation writes it, **Then** it also writes the platform row in `library/coding-standards/codify-platforms.md` and returns to onboarding without showing the "included" line or asking to configure. Onboarding then shows that line and asks whether to configure, as it does today. Onboarding hands the implementation off once, not once for the record and again for the platform row.
7. **Given** highway-onboarding after this change, **When** a maintainer reads it, **Then** it holds no ADR-writing section, no ADR id derivation, no architecture or implementation record rules, and no record template among its inputs or outputs, and it no longer tells the agent not to use highway-adr.
8. **Given** a record write that fails during onboarding, **When** it still fails on one retry, **Then** the earlier records stay in place, onboarding names the record that could not be written, and it does not say onboarding is complete, as it does today.
9. **Given** an onboarding architecture or implementation whose derived id is taken by a different title, or an architecture whose purpose would be empty or name a product, **When** the owner's onboarding entry step reaches its title, **Then** it asks the person the owner's existing title question, writes nothing for that record until the person gives a usable title, and then writes the record and continues onboarding without any other question.
10. **Given** the summary after onboarding, **When** the person reviews a record and edits it, **Then** onboarding updates that record in its existing structure, as it does today, without reading a template.

---

### User Story 2 - The three remaining record templates live with their owners (Priority: P1)

A maintainer opens highway-adr, highway-architecture, and highway-implementation and finds each one's record template in its own `assets/`, named by a path relative to its own folder. `.highway/library/` holds no file at all. highway-architecture no longer reads the ADR template, because it never creates an ADR; it works from the person's ADR file. highway-adr no longer reads the architecture template, because it never creates an architecture; it edits the person's existing architecture record.

**Why this priority**: It completes the template moves begun in Phase 9 and is the phase's exit condition. A plugin skill cannot read files outside its own folder, and these three templates could not move until onboarding stopped reading them.

**Independent Test**: List the three owners' `assets/` and compare each template with its pre-change content. List `.highway/library/`. Search every Highway skill for `.highway/library/`.

**Acceptance Scenarios**:

1. **Given** the repository after this change, **When** a maintainer lists the owners' `assets/`, **Then** `adr-record.md` is in highway-adr's, `architecture-record.md` in highway-architecture's, and `implementation-record.md` in highway-implementation's, each byte-identical to its pre-change content, including the ADR template's onboarding paragraph.
2. **Given** each owner, **When** a maintainer reads it, **Then** every mention of its template is `assets/<file>.md`, and it names no path under `.highway/library/`.
3. **Given** highway-architecture, **When** a maintainer reads its Inputs, **Then** it reads the accepted ADR at `adrs/[ID].md` and does not name `adr-record.md`.
4. **Given** highway-adr, **When** a maintainer reads its Inputs, **Then** it does not name `architecture-record.md`, and when a decision reuses, replaces, runs beside, or spans an architecture, it edits that existing record's Current Decisions and changes nothing else in it, as it does today.
5. **Given** `.highway/library/` after this change, **When** a maintainer lists it, **Then** it holds no file.
6. **Given** any Highway skill, **When** a maintainer searches it, **Then** it names no path under `.highway/library/`.

---

### User Story 3 - Both ways of creating an architecture leave the ADR catalog the same (Priority: P2)

Today, when onboarding writes an architecture, it sets the ADR's Reference Architecture field and the ADR catalog's Architecture ID. When a person runs `/highway-architecture`, its `name` step sets only the ADR's field and leaves `adrs/adrs.md` saying `None`. After this change, `name` sets both, so a person who creates an architecture by hand and a person who onboards one end with the same ADR catalog. Because onboarding now creates its architecture through highway-architecture, both paths run the same step.

**Why this priority**: It closes a real inconsistency that the handoff would otherwise carry into highway-architecture, and it is the one change in this phase that alters what a person running `/highway-architecture` gets. It ranks below the handoff and the move because it is a single field.

**Independent Test**: Create an architecture with `/highway-architecture` for an accepted ADR, and onboard a provider. Read the ADR catalog row for each ADR.

**Acceptance Scenarios**:

1. **Given** an accepted ADR whose catalog Architecture ID is `None`, **When** `/highway-architecture` writes its architecture, **Then** the ADR's Reference Architecture field and that ADR's catalog Architecture ID both name the new `RA` id, and no other ADR or ADR catalog byte changes.
2. **Given** an onboarded provider, **When** its architecture is written, **Then** the ADR and the ADR catalog end in the same state as in scenario 1.
3. **Given** a project missing `adrs/adrs.md`, **When** the person runs `/highway-architecture`, **Then** it shows the fixed setup message, asks nothing, and writes nothing, because it now edits that seeded file.
4. **Given** a failed ADR or ADR catalog update after the architecture is written, **When** the step ends, **Then** the architecture and its catalog row stay, the person is told the ADR could not be updated to name the architecture and that running `/highway-architecture [ADR id]` again will name it, and the chain is not called complete.
5. **Given** `/highway-architecture` without an ADR id after this change, **When** it lists the ADRs waiting for an architecture, **Then** an ADR whose architecture was written by either path is not listed.

---

### User Story 4 - Onboarding started from a Reference Implementation returns to it (Priority: P2)

A person is building a Reference Implementation and names, as Deployed by or Managed by, a platform Highway has never onboarded. highway-implementation says "Let's onboard [Platform]" and starts onboarding with the return step `execution`. Onboarding runs, and its own implementation for the new platform is written by highway-implementation's onboarding entry step. That entry step returns to onboarding, not to the proposal the person was building. Onboarding then returns to `execution` in the person's original visit, and the person continues the implementation they started.

**Why this priority**: The handoff creates a second visit to highway-implementation inside the first, which has never happened before. Without an explicit rule, the inner visit could resume the outer visit's held step and lose the onboarding. It ranks below User Story 1 because it is one path through it.

**Independent Test**: A harness scenario that starts `/highway-implementation` for an accepted architecture, names an un-onboarded platform, completes onboarding, and accepts the original proposal. It checks that both implementations exist and the conversation returns to the original proposal.

**Acceptance Scenarios**:

1. **Given** highway-implementation's `field` step names a platform with no accepted implementation, **When** onboarding runs with the return step `execution`, **Then** highway-implementation's onboarding entry step writes the platform's implementation and returns to onboarding, and does not resume the outer visit's held step.
2. **Given** that onboarding has written its records, **When** it finishes the platform row, **Then** it returns to `execution` in the original highway-implementation visit, does not ask to configure, and does not continue the provider queue, as it does today.
3. **Given** the original visit resumes, **When** the person accepts the proposal, **Then** the original implementation is written, and the onboarded implementation is unchanged.

---

### User Story 5 - Checks and scenarios cover the handoffs (Priority: P3)

Every check that compared a record against one of the three templates still runs, now against the template in its owner's `assets/`. The bash checks that read onboarding rules from highway-onboarding read them from the owners instead. The harness scenarios check each onboarded record against its template, check the ADR catalog Architecture ID on both paths, and cover the chain in User Story 4.

**Why this priority**: Without it, the move would silently switch off coverage, and the one behavior change in this phase would be untested. It adds no behavior of its own.

**Independent Test**: Run the bash suite and the harness TypeScript tests. Run the template check for each moved template against a matching record and against a copy with a required heading removed. Ask the harness which scenarios a change to each moved template selects. Build the distribution and list what it ships.

**Acceptance Scenarios**:

1. **Given** a record and its moved template, **When** the template check runs, **Then** it reads the template from the owner's `assets/` and reports missing parts as it does today, and a record with a required heading removed fails.
2. **Given** the onboarding smoke scenario, **When** it runs, **Then** it checks the ADR, the Reference Architecture, and the Reference Implementation each against its template, and checks that the ADR catalog row names the architecture.
3. **Given** the architecture chain scenario, **When** it runs, **Then** it checks that the ADR catalog row names the new architecture.
4. **Given** a new scenario for User Story 4, **When** it runs, **Then** it covers highway-implementation starting onboarding and returning to the original visit.
5. **Given** a change to each moved template, **When** the harness selects scenarios for that path, **Then** it selects the owner's scenarios and every scenario that passes through the owner, including onboarding's.
6. **Given** each owner, **When** the skill validator runs on it, **Then** it checks the moved template as a complete template, and a template that breaks a check fails the skill.
7. **Given** a bash check that verified an onboarding rule in highway-onboarding's text, **When** it runs after this change, **Then** it verifies the same rule in the owner skill that now holds it, and it fails on a seeded copy with that rule removed.

---

### Edge Cases

- A provider whose derived ADR title and id already belong to an existing record reuses that record, as today. Its architecture and implementation steps then find the ADR's existing architecture or the architecture's existing implementation with the same title and reuse them, so onboarding the same provider twice writes no second record.
- A derived ADR id taken by a different title gets the provider name added to its title and is derived again, without asking, as today.
- A derived `RA` or `RI` id taken by a different title, or an architecture purpose that would be empty or name a product, is the one case where an onboarding entry step asks the person: it uses the owner's existing title question (User Story 1 scenario 9). Today's onboarding text leaves this case undefined, so it is new behavior, not a change to defined behavior. A same-title reuse, and highway-implementation's same-title rename to "[Product] for [purpose]" under a different architecture, still ask nothing.
- A person who declines the title question stops onboarding for that provider as the owner's `decline` does today: nothing is written for that record, earlier records stay, and onboarding does not say it is complete.
- An edit the person makes from onboarding's `review` step is applied by onboarding to the existing record, following the file's own structure, as Phase 1 allows: creating a file needs the template, editing an existing file follows the file. The owners stay the only creators, and no owner gains an edit step.
- Every onboarding ADR has Discovery ID `highway`, so highway-adr's rule that a Discovery ID appears on at most one ADR catalog row exempts `highway`, as onboarding's rows already do today.
- highway-adr's onboarding entry step reads no Discovery, Request, or Clarification. Its evidence is the accepted Profile, Objectives, Controls, and NFRs and the capabilities onboarding passes.
- Onboarding started by highway-codify-config for a platform keeps its behavior: it does not ask to configure that platform, and its summary ends with the line to finish adding it.
- A failed implementation write leaves the ADR naming the architecture and no implementation, as today. A failed ADR write leaves every existing ADR byte unchanged and creates no architecture.
- An ADR catalog Architecture ID cell that already lists several architectures belongs to a span decision. highway-architecture never creates an architecture for such an ADR, so `name` never sets it.
- Editing an existing ADR catalog row's Architecture ID does not change the catalog version; only adding an ADR does, as today.
- With all three templates moved, nothing under `.highway/library/` remains to ship or validate. `.highway/catalog/index.json` stays until Phase 11 removes `.highway/`.
- Test fixtures under `tests/fixtures/` that cite an old template path but are read by no test are out of scope, as in Phase 9.
- Specs under `specs/` name the old locations and the old onboarding text as history and do not change.
- `rollout-plan.md` stays gitignored and excluded in the distribution manifest.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `adr-record.md`, `architecture-record.md`, and `implementation-record.md` MUST move from `.highway/library/templates/output/` to the `assets/` of highway-adr, highway-architecture, and highway-implementation, with their content unchanged. Each owner MUST name its template as `assets/<file>.md` everywhere it names it.
- **FR-002**: After this change, `.highway/library/` MUST hold no file, and no Highway skill, script, test, or harness file MUST name a path under `.highway/library/` except as history in specs.
- **FR-003**: highway-adr MUST gain an onboarding entry step. Given a provider, the capabilities it serves, the decision, the alternatives, the rationale, and the limitations, it MUST write the onboarding ADR and its catalog row as described in User Story 1 scenario 3, as `accepted`, without asking the person, and return the ADR id to the caller. The step MUST derive the ADR id from the decision title, MUST reuse an existing record whose title has that id, and MUST, when the id is taken by a different title, add the provider name to the title and derive again without asking.
- **FR-004**: highway-architecture MUST gain an onboarding entry step. Given an accepted ADR id, it MUST write the architecture and its catalog row as `accepted`, without asking the person except as FR-021 allows, with the onboarding rules highway-onboarding holds today: Current Decisions is that ADR, no Key Technologies, and the catalog ADR ID cell is that ADR id. It MUST then run `name` and return the `RA` id to the caller. When the ADR already names an architecture, it MUST return that id and write nothing.
- **FR-005**: highway-implementation MUST gain an onboarding entry step. Given an accepted `RA` id, the provider, and the capabilities it serves, it MUST write the implementation, its catalog row, and its capability rows as `accepted`, without asking the person except as FR-021 allows, skipping the `execution` proposal and questions, with Execution `Needed` for all three fields and the onboarding rules highway-onboarding holds today. It MUST then continue to `platforms`, which writes the platform row when the implementation can start automation, and return the `RI` id to highway-onboarding without showing the "included" line or the configure question.
- **FR-006**: highway-onboarding MUST hand each provider's ADR to highway-adr, then the architecture to highway-architecture, then the implementation to highway-implementation, through their onboarding entry steps, once each. It MUST drop its ADR-writing section, its ADR id derivation, its architecture and implementation record rules, all three templates from its inputs and outputs, and its instruction not to use highway-adr. Its capability, mapping, lineage, configure, summary, and review steps, the "included" line, and the configure question MUST be unchanged. A review edit MUST still be applied by onboarding, to the person's record in its existing structure, without reading any record template.
- **FR-007**: highway-architecture MUST NOT read `adr-record.md`; it reads the accepted ADR from `adrs/[ID].md`. highway-adr MUST NOT read `architecture-record.md`; it edits an existing architecture record's Current Decisions and changes nothing else in it.
- **FR-008**: highway-architecture's `name` step MUST set the ADR's `Reference Architecture` field and that ADR's catalog Architecture ID to the new `RA` id, and change no other ADR or ADR catalog byte. Onboarding and a direct `/highway-architecture` run MUST leave `adrs/adrs.md` in the same state. highway-architecture's seeded-file entry check MUST name `adrs/adrs.md` as well as `architectures/architectures.md`. A failed update MUST keep the architecture, say the ADR could not be updated to name it and that running `/highway-architecture [ADR id]` again will, and not call the chain complete.
- **FR-009**: For the same project, mapping, and evidence, onboarding MUST write the same files at the same paths, with the same ids, sections, field values, and catalog rows, and show the person the same messages and questions as before the change, in every case today's onboarding text defines. The case in FR-021 is not defined today and is exempt.
- **FR-010**: When an ADR, architecture, or implementation write fails during onboarding, it MUST be tried once more. When it still fails, the earlier records and earlier provider results MUST be kept, onboarding MUST name the record that could not be written, and it MUST NOT say onboarding is complete. A failed ADR write MUST leave every existing ADR byte unchanged and create no architecture. A failed implementation write MUST leave the ADR naming the architecture and no implementation.
- **FR-011**: When highway-implementation's `field` step starts onboarding with the return step `execution`, the implementation onboarding entry step MUST return to onboarding and MUST NOT resume the outer visit's held step. Onboarding MUST then return to `execution` in the original visit without asking to configure and without continuing the provider queue.
- **FR-012**: Onboarding started by highway-codify-config MUST keep its current behavior.
- **FR-013**: highway-adr, highway-architecture, highway-implementation, and highway-onboarding MUST each increment their version MINOR.
- **FR-014**: The paths helper, the template check, the fixture check, the skill validator, and harness scenario selection MUST find each moved template at its new location. The skill validator MUST check each moved template as a complete template. A change to a moved template MUST select its owner's scenarios and every scenario that passes through the owner.
- **FR-015**: Each bash check that verified an onboarding rule in highway-onboarding's text MUST verify the same rule in the owner skill that now holds it. Each new or moved check MUST have a seeded failure that proves it fails.
- **FR-016**: The harness MUST check, in the onboarding smoke scenario, the ADR, Reference Architecture, and Reference Implementation each against its template, and the ADR catalog row's Architecture ID; MUST check the ADR catalog Architecture ID in the architecture chain scenario; and MUST add a scenario for the chain in FR-011. Every new or changed scenario MUST pass the harness's static checks.
- **FR-017**: The distribution manifest, the generators, the agent copies, and highway-help's catalog MUST follow the new arrangement. Each moved template ships inside its skill's folder, and regenerating every generated artifact MUST then leave no diff.
- **FR-018**: Where the Highway Skills Constitution or the development constitution names these templates, onboarding's record writing, or the ADR catalog's Architecture ID, it MUST follow the new arrangement as a MINOR amendment, recorded in its Sync Impact Report and, for the development constitution, with its self-application review.
- **FR-019**: Live documents MUST describe the new arrangement in the same change: `README.md`, `framework/README.md`, `framework/authoring-standard.md`, `harness/README.md`, and `standard-alignment.md`, which also marks Phase 10 complete with a status note.
- **FR-020**: The full bash suite and the harness TypeScript tests MUST pass before the first edit and after the last.
- **FR-021**: When highway-architecture's or highway-implementation's onboarding entry step derives an id taken by a different title, or highway-architecture's would derive an empty purpose or one that names a product, the entry step MUST ask the person the owner's existing title question and MUST write nothing for that record until the person gives a usable title. It MUST then write the record and return to onboarding. A `decline` MUST stop onboarding for that provider, keep earlier records, and not say onboarding is complete. No other case in an entry step MAY ask the person anything.

### Key Entities

- **Owner**: the one skill that creates a kind of record: highway-adr for ADRs, highway-architecture for Reference Architectures, highway-implementation for Reference Implementations.
- **Onboarding entry step**: a step in an owner that highway-onboarding calls with what it learned. It writes the owner's record as `accepted` without asking the person, except the owner's title question when a title cannot be used, and returns the record's id.
- **Handoff**: highway-onboarding calling an owner's onboarding entry step for one record of one provider. Each provider has three: ADR, architecture, implementation.
- **Onboarding variant**: the record values that differ when onboarding creates the record, such as `discovery: highway` on an ADR or `Needed` Execution on an implementation. Each owner holds its own.
- **ADR catalog Architecture ID**: the cell in `adrs/adrs.md` naming the architecture a decision led to, or `None` before it exists. After this phase, both ways of creating an architecture set it.
- **Held step**: the step an outer skill visit returns to when a skill it started finishes. The `execution` step of the original highway-implementation visit in User Story 4.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 3 of 3 moved templates are in their owners' `assets/`, each byte-identical to its pre-change content, and `.highway/library/` holds 0 files.
- **SC-002**: 0 Highway skills name a path under `.highway/library/`, and highway-onboarding names 0 record templates.
- **SC-003**: For a fixed project, mapping, and set of replies with no id collision, onboarding writes the same files, ids, sections, field values, and catalog rows as before, and the person sees 0 new or changed questions. An entry step asks a question only in the title case of FR-021.
- **SC-004**: In 100% of architectures created, by onboarding or by `/highway-architecture`, the ADR's Reference Architecture field and its catalog Architecture ID name the same `RA` id.
- **SC-005**: Each of the three records has exactly 1 creating skill, and highway-onboarding holds 0 record-creation rules for them. highway-onboarding's instruction text is shorter than before.
- **SC-006**: The onboarding smoke scenario checks 3 of 3 onboarded records against their templates. A scenario covers highway-implementation starting onboarding and returning to the original visit. Every scenario passes the harness's static checks.
- **SC-007**: Regenerating every generated artifact changes 0 files, the distribution ships each moved template inside its skill, and the full bash suite and the harness TypeScript tests pass.

## Assumptions

- The move uses `mv`, so each template's content and frontmatter stay as they are, including the ADR template's onboarding paragraph.
- Each owner's onboarding entry step is reached only from highway-onboarding. A person invoking the owner directly sees no change, except the Architecture ID that `/highway-architecture` now sets.
- Onboarding passes the provider, the capabilities it serves, the decision, the alternatives, the rationale, and the limitations to highway-adr, then the ADR id to highway-architecture, then the `RA` id, the provider, and the capabilities to highway-implementation. How each handoff is worded is left to the plan.
- The retry on a failed write is kept, but where it runs, in onboarding or in the entry step, is left to the plan, as long as the person sees the same result.
- Live harness runs need an agent token. Scenarios are written and statically checked in this phase, and run when a token is available, as in earlier phases.
- Only highway-codify is gated by harness coverage, so the new Verification bullets in the four changed skills are reported, not required to be covered.
- The skills change defined behavior only as User Story 3 describes. The title question in FR-021 covers a case today's text leaves undefined. Every other change keeps what the person sees and what is written.
- No harness scenario stages an id collision. A bash check verifies the title-question rule in each entry step's text.
- The distribution keeps placing skills under `.highway/skills/` until Phase 14.
- Highway is unreleased, so there is no backward compatibility to keep and no migration of projects made under the old arrangement.
- Historical specs keep the old paths and the old onboarding text.
- Nothing is committed until the maintainer asks.
