# Feature Specification: Collaborative Knowledge Development

**Feature Branch**: `124-collaborative-knowledge`

**Created**: 2026-10-02

**Status**: Draft

**Input**: User description: Establish a constitutional collaborative knowledge-state model distinguishing accepted repository knowledge, transient Active Reasoning Context and Working Ideas, Converged Proposals, and accepted user-owned artifacts without prescribing conversational technique or introducing durable conversational state.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Develop Ideas Without Premature Authority (Priority: P1)

As a person working with Highway, I want contributions and recommendations to remain working ideas while we develop them, so that exploration does not silently become accepted organizational knowledge.

**Why this priority**: The authority boundary is the core safety guarantee. It must be explicit before skills can support richer collaborative development.

**Independent Test**: Review the Constitution definitions and collaborative-development rules against examples of user contributions, Highway interpretations, alternatives, and recommendations; confirm none are treated as accepted repository knowledge before the applicable acceptance boundary.

**Acceptance Scenarios**:

1. **Given** a user contribution or Highway recommendation is still being refined, **When** the owning skill considers it during the active interaction, **Then** it is treated as a Working Idea within Active Reasoning Context and not as authoritative repository knowledge.
2. **Given** a Working Idea conflicts with accepted user evidence or authoritative repository state, **When** Highway reasons about the active task, **Then** the accepted evidence or authoritative state remains authoritative.
3. **Given** a Working Idea is discarded, corrected, replaced, split, combined, or abandoned, **When** the interaction continues, **Then** no retained artifact is created solely because the idea existed.

---

### User Story 2 - Converge Complete Proposals Before Acceptance (Priority: P1)

As an artifact owner, I want Highway to distinguish an evolving Working Idea from a complete Converged Proposal, so that acceptance applies to a complete candidate artifact rather than an early expression of interest.

**Why this priority**: The distinction prevents ambiguous agreement such as liking a direction from being mistaken for acceptance of a complete Objective, Control, NFR, architecture, or other artifact.

**Independent Test**: Inspect the Converged Proposal definition and P12A.2 contract with representative incomplete and complete candidates; confirm owner acceptance is available only for the complete candidate.

**Acceptance Scenarios**:

1. **Given** a collaborative thread has produced only an incomplete or evolving idea, **When** the owner evaluates acceptance, **Then** it remains a Working Idea and is not treated as a complete accepted artifact.
2. **Given** the owning workflow has enough understanding to produce a complete candidate result, **When** it presents that result at the applicable acceptance boundary, **Then** the result is a Converged Proposal that may be accepted without requiring a prescribed literal phrase.
3. **Given** a person asks for explanation, comparison, refinement, or more information about a proposal, **When** the owner processes that response, **Then** the response is not treated as acceptance unless the applicable acceptance boundary is actually satisfied.

---

### User Story 3 - Preserve Relevant Working Context During an Interaction (Priority: P1)

As a person developing several related ideas in one interaction, I want relevant working context to remain available while the active task is unresolved, so that Highway can connect and refine those ideas without requiring premature persistence.

**Why this priority**: The model must support collaborative development across multiple turns while explicitly avoiding a new durable conversation-state artifact.

**Independent Test**: Exercise an interaction containing multiple relevant Working Ideas, revisions, and relationships; confirm later reasoning can use relevant active context until resolution or interaction end, while no working-state file or retained artifact is introduced by this feature.

**Acceptance Scenarios**:

1. **Given** multiple Working Ideas influence the active task, **When** later reasoning occurs within the same interaction, **Then** relevant ideas and relationships remain available to that reasoning.
2. **Given** an idea is no longer relevant or the active task resolves, **When** the interaction continues or ends, **Then** the owning skill may stop carrying that working context without persisting it as a repository artifact.
3. **Given** a user-owned artifact is accepted, **When** the owner mutation completes, **Then** the newly accepted knowledge becomes available to subsequent reasoning as authoritative context.

---

### User Story 4 - Re-evaluate Context After Accepted Knowledge Changes the Task (Priority: P2)

As a person whose accepted information changes the direction of work, I want Highway to reconsider relevant accumulated context, so that subsequent behavior uses the updated understanding rather than stale assumptions.

**Why this priority**: Re-evaluation is the outer-loop behavior that connects accepted mutations to better subsequent decisions without prescribing what the conversation must say.

**Independent Test**: Provide accepted knowledge that changes the active task, then inspect subsequent behavior and its declared context use; confirm the updated accepted knowledge is used together with other relevant context.

**Acceptance Scenarios**:

1. **Given** accepted knowledge changes the active task, **When** the owning workflow continues, **Then** relevant accumulated context is re-evaluated before subsequent context-dependent behavior.
2. **Given** re-evaluation identifies relevant Working Ideas, accepted user evidence, and repository context, **When** subsequent behavior is produced, **Then** it uses the updated accepted knowledge together with the other relevant declared context.
3. **Given** the active task has no relevant context to reconsider, **When** accepted knowledge is recorded, **Then** the workflow does not invent additional organizational facts or require a durable reasoning record.

### Edge Cases

- A user says they like a direction before a complete artifact exists; this remains a Working Idea or development signal, not acceptance of a complete artifact.
- A Working Idea conflicts with accepted repository knowledge; accepted evidence and authoritative repository state remain superior.
- Several working threads overlap, merge, or diverge; relevant context remains available within the active interaction without creating a persistent thread catalog.
- A Converged Proposal contains an unsupported inference; it remains a proposal and cannot become authoritative without the applicable acceptance boundary.
- A proposal is accepted and its owner mutation fails; no dependent result or orchestration advancement is treated as successful.
- A completed interaction ends with unaccepted Working Ideas; they are not silently restored by this feature in a later interaction.
- A retained artifact template has fields whose order differs from the order in which understanding developed; the owning skill may derive the retained structure from accepted understanding when its contract permits.
- A future organizational possibility is discussed; it remains a possibility or Working Idea unless accepted organizational evidence establishes it.
- An owning skill needs a domain-specific recovery mechanism; that mechanism remains outside this constitutional feature and must be separately declared by the owner.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Constitution MUST define Active Reasoning Context as transient information organized during the active interaction to support reasoning toward the active task, including unaccepted contributions, proposals, interpretations, alternatives, implications, tensions, questions, and relationships.
- **FR-002**: The Constitution MUST define Working Idea as a user contribution, Highway proposal, or evolving synthesis inside Active Reasoning Context that is not yet authoritative user-owned knowledge.
- **FR-003**: The Constitution MUST define Converged Proposal as a complete candidate result produced from the active interaction and presented at the applicable acceptance boundary for possible promotion into user-owned authoritative knowledge.
- **FR-004**: The Constitution MUST preserve the distinction between accepted repository knowledge, transient reasoning and evolving ideas, a complete proposal ready for acceptance, and accepted authoritative user-owned knowledge without creating new retained artifact types.
- **FR-005**: The Constitution MUST add a Collaborative Knowledge Development principle as `XII-A` without renumbering or changing existing P12 rule IDs.
- **FR-006**: The new principle MUST state that Highway may collaboratively develop ideas before they become authoritative artifacts, that retained schema does not dictate conversational question order, and that Working Ideas remain transient until they become a Converged Proposal and cross the applicable acceptance boundary.
- **FR-007**: Rule P12A.1 MUST require skills to treat Active Reasoning Context as transient until an applicable acceptance boundary is satisfied.
- **FR-008**: The observable for P12A.1 MUST establish that unaccepted Working Ideas, Highway interpretations, alternatives, implications, and recommendations are not represented as accepted repository knowledge.
- **FR-009**: Rule P12A.2 MUST require skills to distinguish a Working Idea from a Converged Proposal.
- **FR-010**: The observable for P12A.2 MUST establish that artifact acceptance occurs only after the interaction produces a complete candidate result for the owning artifact, without prescribing literal acceptance wording.
- **FR-011**: Rule P12A.3 MUST require skills to preserve relevant Active Reasoning Context until the active task resolves or the interaction ends.
- **FR-012**: The observable for P12A.3 MUST establish that Active Working Ideas influencing the current task remain available to later reasoning within that interaction.
- **FR-013**: Rule P12A.4 MUST require skills to re-evaluate relevant context after accepted knowledge changes the active task.
- **FR-014**: The observable for P12A.4 MUST establish that behavior following new accepted knowledge uses that knowledge together with other relevant declared context.
- **FR-015**: The Constitution MUST include a non-normative collaborative knowledge lifecycle explaining Accepted context, Working Idea, Collaborative development, Converged Proposal, applicable user acceptance, owner mutation, accepted repository knowledge, re-evaluation, and new Working Ideas.
- **FR-016**: The lifecycle explanation MUST state that collaborative development may involve interpretation, refinement, alternatives, implications, tradeoffs, questions, relationships, and recommendations without creating authoritative organizational facts before acceptance.
- **FR-017**: The lifecycle explanation MUST state that a Working Idea may be discarded, corrected, replaced, split, combined, or abandoned without creating a retained artifact.
- **FR-018**: The lifecycle explanation MUST state that a Converged Proposal is the point at which the owning workflow can present a complete candidate artifact or artifact set for user acceptance.
- **FR-019**: The lifecycle explanation MUST state that the Experience Standard governs how collaboration appears to the person and the owning skill governs what constitutes a complete candidate for its domain.
- **FR-020**: The lifecycle explanation MUST state that retained artifact structure and conversational discovery are separate concerns and that an owning skill may derive retained structure from converged accepted understanding when its contract permits.
- **FR-021**: The Repository Context principle MUST state that Active Reasoning Context may influence the active interaction but remains subordinate to accepted user evidence and authoritative repository state.
- **FR-022**: The Repository Context principle MUST state that a Working Idea does not override accepted repository knowledge merely because Highway is exploring an alternative.
- **FR-023**: The Governance section MUST preserve the existing acceptance boundary and explain that Working Ideas and Active Reasoning Context are non-authoritative until the applicable acceptance boundary is satisfied.
- **FR-024**: Existing owner-controlled mutation and orchestration rules, including P12.13 through P12.15, MUST remain unchanged in rule ID and semantics.
- **FR-025**: The amendment MUST NOT introduce a conversation-state file, Working Idea file, reasoning log, chain-of-thought persistence, hidden reasoning artifact, durable thread catalog, or cross-interaction transient conversation restoration requirement.
- **FR-026**: The amendment MUST NOT classify future organizational growth, hiring, deployment, maturity, or other possible future states as accepted organizational facts without accepted evidence.
- **FR-027**: The amendment MUST NOT add rules requiring acknowledgment, sharpening, visible interpretation, opinion, exploratory questions, tradeoffs, specific wording, turn counts, thread presentation, re-evaluation narration, or exposed reasoning mechanics.
- **FR-028**: Principle Precedence MUST place XII-A below X. Experience Compliance and above XI. Repository Context, without altering higher-ranked correctness, mutation, security, deterministic-decision, or owner-control principles.
- **FR-029**: Self-Application MUST review P12A.1 through P12A.4 for one normative keyword, one obligation, one observable, one tier, rule-length compliance, and absence of prohibited vagueness.
- **FR-030**: The Sync Impact Report MUST identify likely synchronization impact for the Experience Standard, `highway-profile`, `highway-objectives`, `highway-controls`, `highway-nfrs`, and future Architecture/ADR workflows without modifying those artifacts in this feature.
- **FR-031**: The Sync Impact Report MUST record the rollout order of Highway Identity, Experience Standard, `highway-profile`, behavioral testing, `highway-objectives`, `highway-controls`, `highway-nfrs`, and architecture workflows.
- **FR-032**: The Constitution version and amendment classification MUST follow its own semantic-versioning policy based on whether previously conforming governed skills become non-conforming.
- **FR-033**: The amendment MUST preserve the guarantee that accepted owner mutations occur before dependent results and that orchestrators wait for owner results.

### Key Entities *(include if feature involves data)*

- **Accepted Repository Knowledge**: Accepted user-owned or authoritative repository information available to guide later work.
- **Active Reasoning Context**: Transient interaction-scoped information organized to support reasoning toward the active task.
- **Working Idea**: An evolving contribution, proposal, interpretation, or synthesis that remains non-authoritative.
- **Converged Proposal**: A complete candidate artifact or artifact set ready to cross its applicable acceptance boundary.
- **Accepted User-Owned Artifact**: A candidate accepted through the owning workflow and persisted through the existing owner-controlled mutation path.
- **Repository Context**: Accepted repository knowledge that remains distinct from transient Active Reasoning Context.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of the three new definitions appear in the Constitution with the requested authority distinctions and no new retained artifact type.
- **SC-002**: 100% of P12A.1 through P12A.4 have one obligation, one observable, one tier, and stable identifiers without changing P12.5 through P12.15.
- **SC-003**: 100% of reviewed unaccepted contributions, interpretations, alternatives, implications, and recommendations remain non-authoritative until a complete proposal crosses the applicable acceptance boundary.
- **SC-004**: 100% of reviewed complete candidate artifacts are distinguishable from evolving Working Ideas before acceptance, without requiring literal acceptance wording.
- **SC-005**: 100% of reviewed relevant Working Ideas remain available to later reasoning within the active interaction until task resolution or interaction end, with no new durable conversational-state artifact.
- **SC-006**: 100% of reviewed accepted-knowledge transitions re-evaluate relevant accumulated context before subsequent context-dependent behavior.
- **SC-007**: 100% of reviewed retained-artifact examples preserve the separation between template structure and conversational discovery order.
- **SC-008**: 0 new Constitution requirements introduce conversation-state files, reasoning persistence, durable thread catalogs, hidden reasoning artifacts, or cross-interaction restoration.
- **SC-009**: 0 new Constitution rules prescribe conversational wording, acknowledgment style, sharpening behavior, visible reasoning, exploratory question patterns, tradeoff presentation, or thread narration.
- **SC-010**: 100% of existing owner-mutation and orchestration guarantees remain unchanged and continue to require mutation before dependent results.
- **SC-011**: The amendment's version classification is justified against the Constitution's semantic-versioning policy, with no unexamined assumption that a new rule is automatically MINOR.
- **SC-012**: The final Constitution review identifies synchronization impact for all six named downstream areas and records the requested rollout order.

## Assumptions

- The canonical artifact for this feature is `.highway/governance/constitution.md`; no other governance, skill, or testing artifact is modified as part of specification or implementation unless a later plan explicitly identifies a required verification update.
- Existing P12.5 through P12.15 identifiers are stable and will not be renumbered or reused.
- `XII-A` is the preferred principle label because it preserves existing Roman-numeral structure and stable P12 identifiers.
- Active Reasoning Context exists only within the active interaction by default and is not a retained artifact or cross-interaction recovery mechanism.
- Existing acceptance boundaries, owner mutations, dependent-result ordering, and orchestrator waiting behavior remain authoritative.
- The Constitution amendment will assess whether P12A.1 through P12A.4 invalidate any currently conforming governed skill before choosing MAJOR or MINOR classification.
- The Experience Standard remains authoritative for conversational presentation, and owning skills remain authoritative for domain-specific completeness and acceptance behavior.
- Future organizational possibilities remain advisory possibilities unless accepted organizational evidence establishes them.
- No new dependency, public runtime interface, storage schema, or external integration is introduced.
