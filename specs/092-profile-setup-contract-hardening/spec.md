# Feature Specification: Profile and Setup Contract Hardening

**Feature Branch**: `092-profile-setup-contract-hardening`

**Created**: 2026-09-25

**Status**: Draft

**Input**: User description: Strengthen the Highway Experience Standard's implementation-detail boundary, make Setup orchestration-only and owner-driven, make Profile an explicit consumer and provider of Repository Context, complete the related constitutional amendments, remove development-history leakage from runtime contracts, move absent-versus-incomplete routing into Profile readiness, align the shared Markdown Profile template with its retained artifact contract, and add compliance, hygiene, routing, context-consumption, interaction, and persistence tests.

## Implementation Scope

Feature 092 covers the Highway Experience Standard, the Highway Skills Constitution, `highway-profile`,
`highway-setup`, `.highway/library/templates/output/profile-record.md`,
`.highway/library/knowledge/highway-identity.md`, affected validators and tests, and generated or
distributed artifacts identified by the repository's existing correspondence or generation mechanisms
as deriving from changed sources. It also includes existing Interactive Workflow skills requiring
minimal conformance changes as a direct consequence of X2.3. It does not add Profile domains, make
Setup a Repository Context consumer, or silently make unrelated downstream skills consume Profile.

## User Scenarios & Testing

### User Story 1 - Suppress Unrequested Implementation Details (Priority: P1)

As a person using an Interactive Workflow, I want to receive the next user-relevant action without internal routing, evaluation, validation, orchestration, or artifact-processing commentary unless I explicitly request those details.

The X2.3 boundary concerns internal workflow mechanics, not all technical content. It does not suppress
technical content needed to answer the user's substantive request; it suppresses internal mechanics
unless those mechanics were requested. X2.3 does not suppress required Contextual Acknowledgments,
Decision Context, Relevant Examples, or user-relevant progress when those outputs contain no unrequested
implementation mechanics. Repository Context consumption and user-visible Repository Context
acknowledgment are separate concerns: Profile consults declared context as required by the Constitution,
while user-visible output follows the Experience Standard and does not expose repository-loading
mechanics merely to prove that context was consumed.

**Why this priority**: The experience standard should protect the interaction boundary across the whole workflow, not only at its opening.

**Independent Test**: Run normal Setup and Profile collection fixtures and verify that user-visible output contains the relevant acknowledgment, owner context, and next question or result, while omitting unrequested implementation details; run explicit detail-request fixtures and verify requested mechanics may be explained without changing workflow ownership or persistence behavior.

**Acceptance Scenarios**:

1. **Given** a normal Setup request with an incomplete owner, **When** Setup presents the next interaction, **Then** it emits only relevant user-facing context and the owner's next question, decision, result, or actionable error.
2. **Given** a user explicitly requests implementation details, **When** the workflow explains the requested mechanics, **Then** it does not transfer ownership, alter readiness, alter persistence, or disclose unrelated mechanics.
3. **Given** a guided evidence-collection interaction, **When** more information is needed, **Then** no more than one unresolved question or decision is exposed at a time.

### User Story 2 - Route Setup Through Owner Results (Priority: P1)

As a person running Highway Setup, I want Setup to consume owner-provided readiness and next actions so that it can orchestrate the sequence without inspecting Profile internals or second-guessing Profile decisions.

**Why this priority**: Owner/orchestrator separation prevents routing drift and preserves Profile ownership of Profile state.

**Independent Test**: Exercise absent, incomplete, complete, malformed, unsupported Next Action, malformed owner response, and NFR `In Progress` readiness fixtures and verify Setup validates the four-field owner response, delegates supported Next Actions during active orchestration, reports them without delegation during status-only requests, stops on blocked or invalid results, and advances only after owner readiness reaches terminal success.

**Acceptance Scenarios**:

1. **Given** no authoritative Profile exists, **When** Profile readiness is requested, **Then** it returns `Status: Missing` and `Next Action: /highway-profile setup`.
2. **Given** a valid incomplete Profile exists, **When** Profile readiness is requested, **Then** it returns `Status: Missing` and `Next Action: /highway-profile configure`.
3. **Given** a complete Profile exists, **When** Setup consumes Profile readiness, **Then** it requests Objectives readiness without inspecting Profile metadata or domain content.
4. **Given** a malformed Profile exists, **When** Setup consumes Profile readiness, **Then** it reports the owner-provided blocked result and does not invoke later owners.
5. **Given** the user requests Setup status only and an owner is Missing, **When** Setup reports status, **Then** it reports the owner-provided status and Next Action without initiating owner collection.
6. **Given** Setup delegates a supported Missing owner action during active orchestration, **When** that action completes successfully, **Then** Setup consumes the owner's verified action result, requests that owner's readiness again, and advances only when the resulting readiness status satisfies that owner's terminal-success contract.

### User Story 3 - Use Declared Repository Context (Priority: P1)

As a Profile owner, I want Profile to declare and consult the Highway identity, vision, and platform-objective context that can influence evidence evaluation and proposal generation, while keeping workflow-specific input authoritative.

**Why this priority**: Context-dependent Profile behavior must be explicit, reviewable, and non-fabricating.

Foundational Highway Repository Context informs the significance of organizational evidence; it is not
itself organizational evidence. It may help Profile decide what matters, but user input, proposal
content, and accepted Profile evidence determine what is true about the organization.

**Independent Test**: Validate the reference Participating Skill fixture and Profile contract, then run fixtures with each declared context document present and absent; verify the declared semantic roles, missing-context records, no substitution, and workflow-input precedence.

**Acceptance Scenarios**:

1. **Given** the three foundational context documents are available, **When** Profile evaluates context-dependent evidence, **Then** it consults Identity for behavioral guidance, Vision for strategic direction, and Platform Objectives for evaluation criteria before producing the dependent output without exposing context-loading mechanics merely to prove that context was consumed.
2. **Given** a declared context document is absent, **When** Profile performs context-dependent evaluation, **Then** the absence is recorded and no invented or generic content is represented as originating from that missing Repository Context Document; bounded generic guidance remains permitted when the governing interaction contract allows it.
3. **Given** workflow-specific input conflicts with declared Repository Context, **When** Profile evaluates the active request, **Then** the workflow-specific input remains authoritative.
4. **Given** a reference Participating Skill fixture has not declared `profile.md` as behavior-influencing context, **When** the participation contract is evaluated, **Then** Profile context is not applied by that fixture.

### User Story 4 - Maintain a Durable, Conforming Markdown Profile (Priority: P1)

As a person managing organizational context, I want the retained Profile to follow one shared Markdown structure with deterministic metadata, canonical sections, and state-consistent narrative so that the artifact remains readable and verifiable.

**Why this priority**: The retained Profile is the durable boundary between accepted organizational evidence and future workflow behavior.

**Independent Test**: Render representative accepted, bounded, incomplete, and empty states; validate the retained artifact; compare repeated renders byte-for-byte; and verify persistence mismatches fail before completion.

**Acceptance Scenarios**:

1. **Given** a retained Profile, **When** it is opened, **Then** it begins with the required frontmatter, contains `# Organizational Profile`, and has exactly five domain outcomes in canonical order.
2. **Given** a `not_discussed` domain, **When** the Profile is rendered, **Then** its narrative section is absent.
3. **Given** a `discussed` domain, **When** the Profile is rendered, **Then** its canonical narrative section is present.
4. **Given** a `bounded` domain with accepted evidence, **When** the Profile is rendered, **Then** its canonical narrative section is present.
5. **Given** a `bounded` domain without accepted evidence, **When** the Profile is rendered, **Then** its canonical narrative section is absent.
6. **Given** identical accepted evidence and state, **When** the Profile is rendered repeatedly, **Then** the resulting bytes contain no timestamp, random value, or environment-dependent content and are identical.
7. **Given** persisted bytes do not match the accepted proposal, **When** a mutation completes, **Then** the workflow reports a non-success result naming `.highway/library/knowledge/profile.md`.

### User Story 5 - Keep Runtime Contracts Self-Contained (Priority: P2)

As a maintainer, I want production skills, templates, and runtime contracts to express durable behavior directly rather than requiring feature specifications or implementation-history identifiers.

**Why this priority**: Runtime agents must be able to execute the contracts from durable inputs, outputs, governance, and declared context alone.

**Independent Test**: Scan production Profile and Setup skills, the Profile template, and related runtime contracts for development identifiers; permit historical references only in specifications, plans, tasks, commits, and amendment provenance.

**Acceptance Scenarios**:

1. **Given** the Profile runtime skill, **When** it is inspected, **Then** it contains no dependency on `FR-*`, feature numbers, feature branch names, implementation-plan identifiers, or task identifiers.
2. **Given** stable governance identifiers such as `P11.1` or `X2.3`, **When** they are used in runtime contracts, **Then** they remain allowed as durable references.
3. **Given** a new agent instance receives only the runtime skill, its declared Inputs and Outputs, shared templates, governing documents, and declared Repository Context, **When** it executes the workflow, **Then** it can determine all decisions and persistence behavior without opening a feature specification.

### User Story 6 - Complete Governance and Compliance Records (Priority: P2)

As a maintainer, I want the Experience Standard and Highway Skills Constitution amendments to record their version impact, scope, self-application review, footer metadata, and compliance evidence so that the strengthened contracts are governable.

**Why this priority**: Governance changes must be traceable and self-consistent before implementation is accepted.

**Independent Test**: Run the applicable Experience Standard, Constitution, UX, context-participation, runtime-hygiene, template, routing, and generated-artifact checks and verify the amendment records and footers are internally consistent.

**Acceptance Scenarios**:

1. **Given** the X2.3 interaction-wide boundary change, **When** the Experience Standard amendment is reviewed, **Then** it is expected to classify as MAJOR because it strengthens an existing obligation so previously conforming work can fail, and the amendment process verifies that classification against the Versioning Policy before assigning the resulting version.
2. **Given** the Repository Context definition and list changes, **When** the Constitution amendment is reviewed, **Then** it records semantic-version classification, definition and list changes, precedence effects, self-application review, Compliance Review Protocol results, footer, and Last Amended metadata.
3. **Given** generated catalogs or agent adapters depend on changed runtime skills or templates, **When** the implementation is complete, **Then** the corresponding generated artifacts are regenerated and correspondence checks pass.

### Edge Cases

- Profile readiness must distinguish absent and incomplete Profiles through the owner-provided Next Action while using `Missing` for both statuses.
- A malformed Profile must return `Blocked` with a specific structural failure and must never be overwritten by mutation or Setup.
- A missing Identity, Vision, or Platform Objectives context document must remain missing and must not be replaced with inferred content.
- An interrupted first-time Profile setup must restart because no accepted Profile exists.
- An interrupted Configure operation must preserve the previously accepted Profile byte-for-byte.
- A `bounded` domain may have no narrative when no accepted evidence exists, but a `not_discussed` domain must never have narrative.
- A user request for implementation details must be limited to the requested mechanics and must not alter ownership, readiness, routing, or persistence semantics.
- Technical content needed to answer the user's substantive request remains allowed even when it is not an implementation detail.
- Historical references to features and requirements may remain in explicitly historical records, but not in production runtime contracts.
- The obsolete output-template artifacts `.highway/library/templates/output/profile.md` and `.highway/library/templates/output/profile.yaml` are removed; the retained user-owned artifact remains `.highway/library/knowledge/profile.md`.
- Setup must stop on declined, aborted, blocked, malformed, or unknown owner results and must not invoke later owners.
- A blocked Profile always uses `Next Action: None` under this contract; introducing a supported repair action requires a separately versioned contract change.
- Setup status-only requests report owner results without initiating owner collection.
- NFR `In Progress` is non-terminal; Setup presents or delegates the NFR owner's Next Action and does not report Setup Complete.

### Profile Readiness Contract

| Profile state | Status | Next Action | Blocking Reason |
|---|---|---|---|
| Absent | Missing | `/highway-profile setup` | None |
| Valid incomplete | Missing | `/highway-profile configure` | None |
| Complete | Complete | None | None |
| Malformed | Blocked | None | Specific structural failure |

Summary is owner-authored explanatory text and does not affect Setup routing. Setup routes only from
Status and the owner-provided Next Action; Blocking Reason is user-facing error context, not routing
language. A future supported repair action may change the blocked Next Action contract only through
the applicable Profile skill-versioning process.

For Profile, the closed Next Action vocabulary is:

| Profile Status | Allowed Next Action |
|---|---|
| Missing, absent | `/highway-profile setup` |
| Missing, incomplete | `/highway-profile configure` |
| Complete | `None` |
| Blocked | `None` |

Other owners define their own allowed Next Action vocabulary in their readiness contracts; Setup
consumes that declaration and does not invent action names.

**Malformed Owner Readiness Result**: A readiness result with a missing, duplicated, reordered, or
unrecognized required field; an unsupported Status; an invalid Status/Next Action combination; or a
Blocking Reason inconsistent with the owner's declared readiness contract.

### Setup Owner Loop and Terminality

Setup requests owner readiness, advances immediately only on terminal success, and otherwise presents or
delegates the owner-provided Next Action. After a delegated owner mutation reports verified completion,
Setup consumes that action result, re-reads the owner's readiness, and advances only when the resulting
readiness status satisfies that owner's terminal-success contract. The action result confirms the
mutation; readiness determines stage advancement.
On an explicit readiness or status-only request, Setup reports the owner result without initiating
collection. The terminality contract is:

| Owner | Terminal success |
|---|---|
| Profile | Complete |
| Objectives | Complete |
| Controls | Complete |
| NFRs | Complete or Not Applicable |

The canonical Setup algorithm is: (1) request owner readiness; (2) validate the four-field response;
(3) advance on terminal success; (4) during active orchestration, delegate a supported Next Action for
a non-terminal result; (5) consume the owner action result; (6) when that result reports verified
completion, re-read owner readiness; (7) advance only from the new readiness result; and (8) stop on
Blocked, malformed, unknown, declined, aborted, or failed results. Status-only requests report the
owner result without delegation. No other owner status permits Setup to advance to the next owner.

| Owner readiness result | Active orchestration | Status-only request |
|---|---|---|
| Terminal success | Advance | Report |
| Missing with supported Next Action | Delegate | Report |
| NFR `In Progress` with supported Next Action | Delegate | Report |
| Blocked | Stop and report | Report |
| Malformed or unknown | Stop and report error | Report error |
| Declined or aborted owner action | Stop | Not applicable |
| Failed owner action | Stop | Not applicable |

## Requirements

### Functional Requirements

- **FR-001**: The Experience Standard MUST define X2.3 as prohibiting user-visible Implementation details throughout an Interactive Workflow unless the user requested those details.
- **FR-002**: The Experience Standard MUST define the X2.3 Observable as user-visible output excluding Implementation details unless requested, and its rationale and Interactive Workflow UX Contract MUST reflect the interaction-wide boundary.
- **FR-003**: The implementation MUST preserve X2.2, X2.4, X2.5, and X2.6 behavior, including next-action priority, one unresolved guided-collection question or decision, legitimate progress reporting, and user-relevant progress wording.
- **FR-004**: Setup MUST reference the authoritative Interactive Workflow UX Contract in the Highway Experience Standard and MUST emit only user-relevant acknowledgments, active-owner context, and the owner's next question, decision, result, or actionable error during routine collection.
- **FR-005**: Setup MUST suppress unrequested implementation details, including readiness evaluation, owner selection, routing, forwarding, validation mechanics, evaluation order, artifact inspection, orchestration, internal processing, and similar mechanics.
- **FR-006**: Setup MUST preserve the substantive content and declared structured-field ordering of owner-provided questions, Decision Context, Relevant Examples, contextual acknowledgments, summaries, next actions, and blocking reasons while applying only presentation needed for the Setup interaction contract, without adding implementation commentary or a second question.
- **FR-007**: Setup MUST use numbered owner-driven steps, invoke supported owner Next Actions during active orchestration, stop on blocked or invalid owner results, and emit completion only after every owner reaches terminal success.
- **FR-008**: Setup MUST consume Profile `Status`, `Summary`, `Next Action`, and `Blocking Reason` without inspecting Profile frontmatter, domains, narrative, schema version, or other internals to choose a route. Setup MAY validate that the owner response conforms to the declared four-field contract; this is response validation, not Profile readiness recomputation.
- **FR-009**: Profile readiness MUST classify persisted state in this order: absent Profile -> `Missing`; present invalid Profile -> `Blocked`; present valid Profile with any `not_discussed` domain -> `Missing`; otherwise -> `Complete`.
- **FR-010**: Profile MUST declare `.highway/library/knowledge/highway-identity.md`, `.highway/library/knowledge/highway-vision.md`, and `.highway/library/knowledge/highway-platform-objectives.md` as Repository Context Inputs.
- **FR-011**: Before context-dependent evidence evaluation or proposal generation, Profile MUST consult each available declared context document, using Identity for behavioral guidance, Vision for strategic direction, and Platform Objectives for evaluation criteria.
- **FR-012**: Profile MUST record missing declared context documents without replacing them with invented or generic content represented as repository-derived context; bounded generic guidance remains permitted when the governing interaction contract allows it, and workflow-specific user input MUST remain authoritative during conflicts.
- **FR-013**: Profile MUST describe the accepted Profile at `.highway/library/knowledge/profile.md` as user-owned organizational Repository Context and MUST state that downstream skills consume it only after declaring it as behavior-influencing context.
- **FR-014**: Setup MUST remain orchestration-only and MUST NOT become a consumer of Highway Identity, Highway Vision, Highway Platform Objectives, or Profile solely because Profile consumes them.
- **FR-015**: The Constitution MUST define a Repository Context Document as an authoritative file under `.highway/library/knowledge/` describing Highway identity, vision, objectives, decision evaluation, or user-owned organizational context.
- **FR-016**: The Constitution MUST retain the four authoritative Repository Context Documents and their behavioral, strategic, evaluative, organizational, and workflow-input overlap semantics.
- **FR-017**: The Constitution amendment MUST record semantic-version classification, definition and authoritative-list changes, overlap or precedence effects including an explicit statement when no Principle Precedence change occurs, self-application review, Compliance Review Protocol evidence, footer, and Last Amended metadata without preassigning a version outside the policy. Classification MUST distinguish a definition repair that reconciles already-ratified Principle XI from a substantive change to Repository Context obligations.
- **FR-018**: The Experience Standard amendment MUST classify the X2.3 change under its Versioning Policy and verify the expected MAJOR classification because the interaction-wide prohibition can invalidate previously conforming work, then update its Sync Impact Report and footer, perform self-application review, and run applicable compliance checks without preassigning the resulting version.
- **FR-019**: Production runtime behavior MUST NOT depend on resolving development-history identifiers such as `FR-*`, feature numbers, feature branches, implementation-plan identifiers, or task identifiers.
- **FR-020**: Runtime identifier hygiene checks MUST distinguish prohibited runtime dependencies from permitted historical references in specifications, plans, tasks, commits, amendment provenance, and other explicitly historical records. Development identifiers inside explicitly delimited amendment-history or provenance sections are excluded from runtime-dependency failure unless runtime instructions refer to them.
- **FR-021**: The shared Profile template MUST define the complete generated Profile structure, including retained frontmatter delimiters, `schema_version: 2.0.0`, exactly five domain outcomes in the order `identity`, `vision`, `competitive_path`, `guiding_principles`, `highway_role`, and canonical headings in the order `# Organizational Profile`, `## Who We Are`, `## Where We're Going`, `## How We Plan to Get There`, `## What Guides Our Decisions`, `## How Highway Helps`; unsupported domain sections remain omitted while preserving relative order.
- **FR-022**: Metadata describing `.highway/library/templates/output/profile-record.md` itself MUST remain outside the generated retained-Profile structure and distinct from retained `schema_version`; it describes the template artifact and is not part of the generated-content skeleton. The template MUST remain the sole complete structural authority cited by the Profile skill.
- **FR-023**: Profile rendering and validation MUST enforce the state-to-narrative invariants: `not_discussed` absent, `discussed` present, `bounded` with accepted evidence present, and `bounded` without accepted evidence absent.
- **FR-024**: Profile mutations MUST validate the authoritative artifact, preview proposed changes, request confirmation where required, write only after confirmation, verify persisted bytes against the accepted proposal, and preserve the artifact on declined, ambiguous, malformed, interrupted, or failed operations. A byte-identical proposed mutation performs no write and does not require persistence verification for unchanged retained output.
- **FR-025**: Profile error handling MUST treat an absent Profile as a valid initial state: readiness returns `Missing`, setup begins initial collection, view/show/describe reports absence without creating an artifact, and operations requiring existing accepted evidence abort with the authoritative path.
- **FR-026**: Profile Verification MUST name each available and absent declared Repository Context Document in verification evidence without creating a missing-context retained artifact, confirm no substitution, confirm workflow-input precedence, and confirm persistence verification before successful completion claims.
- **FR-027**: Profile's Interactive Workflow UX Contract MUST reference the Experience Standard, limit evidence collection to one unresolved question, suppress unrequested implementation details, describe applicable progress using domain outcomes rather than question counts, and define exits, outcomes, and resume applicability.
- **FR-028**: The implementation MUST add or update fixtures and tests for normal and explicit implementation-detail interactions, Profile context consumption and absence, owner-driven readiness routing, runtime identifier hygiene, template conformance, persistence mismatch, generated correspondence, Setup non-inspection, and regression coverage for every discovered Interactive Workflow, including Objectives, Controls, and NFRs.
- **FR-029**: The implementation MUST update identified generated or distributed dependents and all directly affected compliance checks after changing source skills, governance documents, templates, or catalog inputs.
- **FR-030**: The implementation MUST review every amended production skill for runtime-dependency self-containment and block completion if any of the ten runtime-dependency hygiene questions has a negative answer.
- **FR-031**: The implementation MUST synchronize the Repository Context description in `.highway/library/knowledge/highway-identity.md` with the amended constitutional document list while keeping the Constitution normative for membership, participation, overlap semantics, and validation.
- **FR-032**: Setup MUST NOT derive routing from Profile `Summary` or `Blocking Reason`; routing uses Profile `Status` and owner-provided `Next Action`. Setup MUST present owner-provided `Summary` and `Blocking Reason` as user-facing owner context without interpreting them as routing instructions or rewriting their substantive meaning.
- **FR-033**: The X2.3 amendment impact review MUST discover all repository skills that implement or declare an Interactive Workflow and evaluate every discovered skill against the amended X2.3 contract, including X2.7, X2.8, X2.9, and X2.10 compatibility; Objectives, Controls, and NFRs are mandatory known cases, not the complete inventory.
- **FR-034**: Changes to `highway-profile` Inputs, readiness output semantics, Verification, or behavioral guarantees MUST be classified under the Skill Versioning Policy and reflected in `metadata.version`; the implementation MUST explicitly evaluate compatibility for existing consumers of those contracts.
- **FR-035**: Changes to `highway-setup` routing, owner-result consumption, Outputs, Verification, or behavioral guarantees MUST be classified under the Skill Versioning Policy and reflected in `metadata.version`; the implementation MUST explicitly evaluate whether the change redefines an existing behavioral guarantee.
- **FR-036**: Each numbered Setup workflow step MUST identify its failure condition and map to an Error Handling action satisfying the current Skills Constitution.
- **FR-037**: When Setup actively orchestrates foundational setup, a supported owner `Next Action` MUST be delegated to that owner workflow; on a readiness or status-only request, Setup MUST report the action without initiating collection.
- **FR-038**: The implementation MUST provide a fixture demonstrating that template artifact metadata remains separate from the template-defined generated Profile structure and is never emitted into `.highway/library/knowledge/profile.md`.
- **FR-039**: The template MUST be capable of representing each canonical domain outcome, including `not_discussed`; initial setup MUST not persist a placeholder Profile. Initial setup MAY use the shared template as an in-memory structural rendering contract before acceptance; this does not create authoritative Profile state.
- **FR-040**: The implementation MUST test template-versus-initial-persistence semantics, including reusable-template outcome representation, no placeholder write during initial setup, no write when starting `/highway-profile setup` and asking the first Identity question, and readiness `Missing` for an authorized partial retained Profile.
- **FR-041**: If malformed skill metadata syntax exists, the implementation MUST repair that syntax.
- **FR-042**: Metadata syntax repair and semantic-version classification MUST be evaluated independently for every amended skill.
- **FR-043**: Profile's numbered workflow MUST consult available declared Repository Context before the first context-dependent evidence evaluation or proposal-generation decision in the active invocation.
- **FR-044**: If an owner returns a `Next Action` that Setup does not recognize as a supported owner action, Setup MUST treat the owner response as malformed, stop orchestration, and invoke no later owner.
- **FR-045**: Profile readiness MUST return `Blocked` when retained `schema_version` is missing, malformed, or unsupported by the executing Profile skill, without silently reinterpreting or migrating it. `2.0.0` is the only schema version supported by this feature unless an already-declared authoritative compatibility range is identified.
- **FR-046**: Before regeneration, the implementation MUST identify each generated or distributed artifact whose declared source includes an artifact changed by Feature 092; only identified dependents are regenerated, and completion evidence MUST list each changed source, identified dependent, regeneration action or `None`, and correspondence-test result.
- **FR-047**: The template file MUST be treated as a Highway library artifact describing how to generate a Profile, while `.highway/library/knowledge/profile.md` is the user-owned organizational artifact; template metadata MUST never be copied into the generated Profile unless explicitly declared as generated structure.
- **FR-048**: The implementation MUST provide a cross-rule interaction fixture covering X2.3, X2.7, X2.8, X2.9, and X2.10 in which Profile uses applicable Repository Context, supplies required contextual acknowledgment and Decision Context, provides a Relevant Example when it clarifies response form, and suppresses unrequested domain evaluation, evidence-completeness, routing, validation, and context-loading mechanics.
- **FR-049**: Any existing Interactive Workflow that becomes non-conforming solely because of the X2.3 amendment MUST receive the minimum runtime-contract or fixture change required to restore compliance.
- **FR-050**: A runtime contract MAY cite a stable governance rule identifier only when its governing document is a declared dependency where required by the skill contract. Profile SHOULD directly declare only Highway Identity, Highway Vision, and Highway Platform Objectives as its foundational Repository Context Inputs and express runtime behavior without resolving P/X rule IDs; if Profile or Setup directly instructs the executing agent to resolve governing rule IDs, the corresponding governing documents MUST appear in Inputs. Setup MUST remain an orchestrator, not a Repository Context consumer, unless its runtime contract directly requires that dependency.
- **FR-051**: The implementation MUST provide deterministic runtime-hygiene fixtures covering the known current Profile leaks `FR-005` and `Feature 091`, plus generalized checks preventing feature-branch, implementation-plan, and task identifiers from becoming runtime dependencies.
- **FR-052**: The implementation MUST provide regression fixtures verifying that Profile uses domain-oriented progress rather than question-count progress, Setup does not independently determine absent-versus-incomplete routing, and the template separates metadata, retained frontmatter, title, canonical keys, and generated output.
- **FR-053**: Profile readiness MUST map Absent to `Missing` with `/highway-profile setup`, valid incomplete to `Missing` with `/highway-profile configure`, Complete to `Complete` with `None`, and malformed to `Blocked` with `None`, using the four fields `Status`, `Summary`, `Next Action`, and `Blocking Reason`.
- **FR-054**: Setup MUST recognize owner Next Actions from the owning skill's declared readiness contract and MUST NOT invent or normalize an undeclared owner route.
- **FR-055**: NFR `In Progress` MUST remain non-terminal in Setup; Setup follows the NFR owner's declared Next Action during active orchestration and MUST NOT report Setup Complete.
- **FR-056**: Declared Repository Context MAY influence Profile's determination of whether missing organizational evidence can alter recommendations, explanations, responsibilities, governance interpretation, workflow selection, or generated artifacts, but Repository Context MUST NOT supply organizational facts about the user that the user has not provided.
- **FR-057**: Any Interactive Workflow modified for X2.3 conformance MUST classify its own change under the Skill Versioning Policy and update `metadata.version` when required.
- **FR-058**: The implementation MUST provide a constitutional consistency check confirming that the Repository Context definition includes organizational context, Principle XI lists the same four documents, overlap roles agree with Highway Identity, and no conflicting Repository Context statement remains elsewhere in the Constitution.
- **FR-059**: The X2.3 impact review MUST record each discovered Interactive Workflow, whether it was detected, its X2.3 result, any required change, and the resulting skill-version classification.
- **FR-060**: The implementation MUST test no-op Profile mutations by verifying No Change, no write, byte identity, no false persistence failure, and readiness derived from the unchanged Profile.
- **FR-061**: The implementation MUST provide a schema-version fixture matrix covering valid `2.0.0`, absent, malformed, and unsupported valid SemVer values; only valid `2.0.0` proceeds to classification, and no case may trigger automatic migration.
- **FR-062**: The implementation MUST test amended skill metadata syntax so `metadata.version` parses as SemVer, contains no skill-name suffix, and leaves the skill name separately declared; this syntax check remains independent from behavioral version classification.
- **FR-063**: Feature 092 MUST NOT make every Repository Context Document mandatory for every Participating Skill; each skill continues to declare only context that can alter its own Behavior.
- **FR-064**: The implementation MUST provide a non-promotion fixture in which Highway Vision or a Platform Objective describes a desired Highway capability and Profile records no such capability as an organizational fact or retained Profile evidence.
- **FR-065**: The implementation MUST remove the obsolete output template `.highway/library/templates/output/profile.md` and MUST provide the replacement output template at `.highway/library/templates/output/profile-record.md`.
- **FR-066**: The implementation MUST remove the obsolete YAML Profile file `.highway/library/templates/output/profile.yaml`; no active Profile contract, validator, generated artifact, or distribution manifest may treat that file as an output template or fallback.

### Key Entities

- **Interactive Workflow**: A user-facing workflow that expects a response, decision, confirmation, approval, rejection, or other input and is governed by the Experience Standard.
- **Implementation Detail**: Internal workflow mechanics such as ownership, routing, validation, evaluation order, artifact inspection, orchestration, and internal processing.
- **Profile Readiness Result**: The owner-produced Status, Summary, Next Action, and Blocking Reason used by Setup without exposing or inspecting Profile internals.
- **Malformed Owner Readiness Result**: An owner response that violates the required four-field structure or the owning skill's declared readiness contract.
- **Incomplete Profile**: A structurally valid retained Profile containing at least one `not_discussed` domain outcome.
- **Malformed Profile**: A retained Profile that fails the shared structural contract or Profile validation rules, including invalid frontmatter, invalid schema version, missing or invalid domain outcomes, or state-to-narrative contradiction.
- **Repository Context Document**: An authoritative Highway knowledge document that can influence declared skill behavior, including user-owned organizational Profile context.
- **Participating Skill**: A skill that declares behavior-influencing Repository Context in Inputs and consults available declared context before dependent output.
- **Retained Markdown Profile**: The accepted organizational artifact with deterministic frontmatter, domain outcomes, and conditional canonical narrative sections.
- **Governance Rule Identifier**: A stable identifier owned by a durable governing document, such as `P11.1` or `X2.3`, that a runtime contract may reference.
- **Development Identifier**: A feature, requirement, branch, plan, or task identifier used for development traceability and prohibited as a dependency of production runtime behavior.
- **Missing Context Record**: Non-fabricated verification or review evidence naming a declared Repository Context Document that was unavailable; it does not itself create Repository Context or a retained artifact.
- **Constitutional Amendment**: A governed change to the Highway Skills Constitution requiring version classification, impact reporting, self-application, and compliance evidence.

## Success Criteria

### Measurable Outcomes

- **SC-001**: 100% of normal Setup and Profile interaction fixtures contain no unrequested implementation-detail output, while 100% of explicit-detail-request fixtures explain the requested mechanics without changing ownership or persistence semantics.
- **SC-002**: 100% of owner-routing fixtures pass for absent, incomplete, complete, malformed, unsupported Next Action, malformed owner response, and NFR `In Progress` cases; Setup performs zero Profile-state recomputation and advances only from the declared terminality contract.
- **SC-003**: 100% of Profile context fixtures confirm all three foundational context declarations, correct semantic use, missing-context recording, non-fabrication, and workflow-input precedence.
- **SC-004**: 100% of valid retained Profile fixtures pass frontmatter, five-domain, canonical-heading, state-to-narrative, and deterministic-byte validation, with no timestamp, random value, or environment-dependent content.
- **SC-005**: 100% of runtime hygiene scans covering production runtime artifacts modified by Feature 092 and their directly generated or distributed derivatives report no prohibited development-history dependency, while historical records remain permitted.
- **SC-006**: All compliance checks declared applicable by the amended Constitution, Experience Standard, affected skills, templates, generated-artifact contracts, and implementation plan report zero unresolved failures.
- **SC-007**: In 100% of runtime self-containment fixtures, all Profile and Setup decisions can be derived from the supplied durable runtime contracts without providing the Feature 092 specification or other development-history records.
- **SC-008**: Maintainer review confirms both amended governing documents contain internally consistent version classification, Sync Impact Report, footer metadata, self-application review, and applicable compliance evidence.
- **SC-009**: Every discovered Interactive Workflow has a recorded X2.3 verdict, and every failure introduced by the X2.3 amendment is repaired before completion.
- **SC-010**: Each Interactive Workflow changed for X2.3 conformance has its skill-version classification recorded and reflected in metadata when required.
- **SC-011**: Profile context fixtures demonstrate that Highway Identity, Vision, and Platform Objectives may influence evidence significance and adaptive follow-up but contribute zero unsupported organizational facts to retained Profile narrative.
- **SC-012**: Every changed source has a recorded dependent-artifact inventory, and every identified generated or distributed dependent passes its correspondence check after regeneration when regeneration is required.
- **SC-013**: The replacement output template exists only at `.highway/library/templates/output/profile-record.md`, the obsolete Markdown and YAML output-template files are absent, and the retained user-owned artifact remains `.highway/library/knowledge/profile.md`.

## Implementation Scope and Completion

Feature 092 changes:

- the interaction-detail boundary in the Highway Experience Standard;
- the Repository Context definition, amendment metadata, and precedence record in the Highway Skills Constitution;
- `highway-profile` and `highway-setup`;
- the shared Profile Markdown template;
- removal of the obsolete `.highway/library/templates/output/profile.md` and `.highway/library/templates/output/profile.yaml` output-template artifacts;
- descriptive Highway Identity Repository Context documentation;
- directly affected validators, fixtures, compliance checks, and generated or distributed artifacts identified by the repository's existing correspondence or generation mechanisms as deriving from changed sources.

Feature 092 does not:

- add new Profile evidence domains;
- change Profile into an Objective, Control, or NFR;
- make Setup a Repository Context consumer solely because owner skills consume context;
- silently make unrelated downstream skills consume Profile;
- add a new persistence technology.

Feature 092 is complete only when the Experience Standard amendment is ratified and every discovered
Interactive Workflow passes its amended X2.3 obligations; the constitutional Repository Context
definition, amendment record, and Highway Identity description are synchronized; Profile consumes only
its declared foundational context without promoting that context into organizational facts; Profile
readiness owns absent-versus-incomplete routing; Setup validates and consumes owner contracts without
inspecting owner artifacts; the shared Profile template and retained Profile satisfy their separate
structural roles; Profile and Setup contain no runtime dependency on development identifiers; all
amended skills have correct semantic-version classifications and valid metadata; every identified
generated or distributed dependent is regenerated when required; and all declared applicable compliance
checks report no unresolved failure.

After the readiness-classification, owner-loop, context-consumption, X2.3 impact, template-layer,
runtime-hygiene, and versioning clarifications in this specification are incorporated, implementation
planning treats the product model as frozen unless a concrete source-contract contradiction prevents
implementation or verification. Implementation MUST NOT add new Profile domains, Profile persistence
locations, readiness statuses, Setup stages, downstream Profile participants, or Repository Context
documents.

## Assumptions

- The existing Highway Experience Standard and Highway Skills Constitution remain the authoritative governance documents; this feature updates them through their existing amendment policies.
- Feature numbering remains sequential and this specification is Feature 092.
- The accepted Profile remains a user-owned artifact at `.highway/library/knowledge/profile.md`.
- Setup remains an orchestrator and does not become a Participating Skill for context documents merely because Profile consumes them.
- Existing generated catalogs, adapters, manifests, and distribution correspondence checks remain the required derived-artifact mechanism.
- Historical feature references in specifications, plans, tasks, commits, amendment provenance, and explicitly historical transcripts may remain when they do not serve as runtime instructions.
- No new external service, framework, persistence technology, or user-facing application is required.
- The current Profile domain model and accepted Markdown artifact semantics remain in scope; this feature hardens contracts and their evidence rather than adding new organizational domains.
