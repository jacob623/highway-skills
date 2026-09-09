# Feature Specification: Highway NFR Management

**Feature Branch**: `020-highway-nfrs`

**Created**: 2026-09-08

**Status**: Draft

**Input**: User description: Create `/highway-nfrs`, a skill that manages the repository-wide Non-Functional Requirement baseline used by Highway. NFRs describe desired quality attributes, operational characteristics, constraints, and outcomes. `/highway-controls` already exists; the relationship between NFRs and Controls remains deferred, with reciprocal reserved fields only.

**Decisions settled before drafting** (2026-09-08):

| Question | Decision |
|---|---|
| Where NFRs live | `library/governance/` at the project root, a sibling of `.highway/` - never inside it |
| NFR file format | YAML frontmatter and a Markdown body, in `.md` |
| Catalog format | `nfrs.md`, a generated prose index with no timestamp |
| Identifier allocation | A `next_id` field in the catalog, so identifiers survive removal |
| Per-item versioning | None; the baseline carries the only version |
| Destructive actions | Confirm first, naming every NFR that would be lost |
| Relationships | `controls: []` is reserved on every NFR; no relationship is populated in this phase |

## User Scenarios & Testing *(mandatory)*

### User Story 1 - An author adds a global NFR (Priority: P1)

A repository maintainer states a desired quality attribute, such as high availability, and gets back an NFR with a stable identifier, a rationale, and a generated catalog entry in the repository-owned governance directory.

**Why this priority**: Add is the foundation of the baseline; without it there is no NFR for the other actions to manage.

**Independent Test**: Add an NFR to an empty baseline and verify its file, identifier, reserved relationship field, catalog entry, and version increment.

**Acceptance Scenarios**:

1. **Given** no NFRs exist, **When** the first NFR is added, **Then** it receives the lowest unused identifier and the catalog is created.
2. **Given** an NFR is added, **When** its file is read, **Then** it contains an identifier, title, status, empty `controls` field, statement, and rationale.
3. **Given** an NFR is added, **When** the catalog is read, **Then** it indexes the NFR, records the next identifier, and records a baseline version increased by MINOR.
4. **Given** an NFR already exists, **When** another is added, **Then** the recorded next identifier is consumed and advanced rather than derived from the highest file currently present.

---

### User Story 2 - The user's governance remains outside Highway's authoring rules (Priority: P1)

A repository maintainer stores NFRs under the root-level `library/governance/` directory. Highway manages those files through `/highway-nfrs`, but does not judge their prose against the Highway Skills Constitution or sweep them into the Highway library.

**Why this priority**: The boundary prevents user-owned governance from being mistaken for framework content and rejected for rules that apply only to Highway's own artifacts.

**Independent Test**: Place NFR content at the project root and confirm that Highway library validation and generation do not classify or index it as framework content.

**Acceptance Scenarios**:

1. **Given** an NFR under root `library/governance/`, **When** a Highway generator runs, **Then** the NFR is not swept into a Highway catalog or validated as a Highway library artifact.
2. **Given** the library validator is invoked on a root-level user NFR by a relative or absolute path, **Then** it reports the file as outside the framework scope rather than judging its content.
3. **Given** an NFR body uses wording that would be unsuitable for a Highway skill, **When** the suite runs, **Then** no Highway rule reports on the NFR body.

---

### User Story 3 - A maintainer changes the baseline without losing named work (Priority: P1)

A maintainer can replace the entire NFR baseline or remove one NFR, while seeing every NFR that would be lost before confirmation and preserving the high-water identifier.

**Why this priority**: Set and Remove are destructive actions. Explicit, itemized confirmation is necessary before user-owned governance is deleted.

**Independent Test**: Request a Set that drops existing NFRs and a Remove, then verify the loss list, confirmation gate, no-write behavior on refusal, and major version changes.

**Acceptance Scenarios**:

1. **Given** a Set would remove existing NFRs, **When** it is requested, **Then** every removed NFR is named by identifier and title before any file changes.
2. **Given** a Remove is requested, **When** it is presented, **Then** the target NFR is named by identifier and title and confirmation is required before deletion.
3. **Given** confirmation is withheld, **When** the action ends, **Then** no NFR file, catalog entry, identifier high-water mark, or version changes.
4. **Given** an NFR is removed or the baseline is replaced, **When** the catalog is read, **Then** the baseline version has increased by exactly one MAJOR step.
5. **Given** an identifier has been retired, **When** a later NFR is added, **Then** the retired identifier is not reused.

---

### User Story 4 - A maintainer can revise an NFR without changing its identity (Priority: P2)

A maintainer can update an existing NFR's statement, title, rationale, or other requested fields while preserving its identifier and untouched metadata.

**Why this priority**: NFRs evolve, but references to an NFR must remain stable.

**Independent Test**: Update an existing NFR and verify that its identifier remains unchanged, untouched metadata remains present, and the baseline version changes once by PATCH when the obligation is unchanged.

**Acceptance Scenarios**:

1. **Given** an existing NFR is referenced by identifier, **When** it is updated, **Then** the identifier remains unchanged.
2. **Given** only the NFR statement changes, **When** the update completes, **Then** metadata not targeted by the change is preserved.
3. **Given** the update does not change the obligation, **When** the catalog is read, **Then** the baseline version increases by exactly one PATCH step.

---

### User Story 5 - The skill classifies and advises without overruling the author (Priority: P2)

A maintainer receives useful guidance when a proposed NFR is vague, resembles an existing NFR, or is actually an enforceable implementation requirement. The maintainer can still keep a vague NFR after hearing the advice, while Control-like statements are routed to `/highway-controls`.

**Why this priority**: Advice improves the baseline without turning the skill into a gate that users bypass by editing files by hand.

**Independent Test**: Offer outcome-shaped, implementation-shaped, vague, and similar statements and verify the guidance, routing, and author choice behavior.

**Acceptance Scenarios**:

1. **Given** a proposed statement describes a desired outcome such as security or availability, **When** it is offered, **Then** it is treated as an NFR.
2. **Given** a proposed statement prescribes a specific, testable, auditable, or enforceable implementation requirement, **When** it is offered, **Then** the skill identifies it as a Control and offers `/highway-controls`.
3. **Given** an NFR is vague, **When** it is offered, **Then** the skill explains the weakness and gives at least one improved alternative without refusing the NFR.
4. **Given** the author keeps the advised wording, **When** they confirm, **Then** the NFR is recorded as requested.
5. **Given** a proposed NFR resembles an existing one, **When** it is offered, **Then** the existing NFR is named by identifier and title rather than merely calling it a duplicate.
6. **Given** `/highway-controls` receives an outcome-shaped statement, **When** it classifies the statement, **Then** it identifies the statement as an NFR and names `/highway-nfrs` as the destination.

---

### User Story 6 - Ambiguous requests fail without partial writes (Priority: P1)

A maintainer gets a precise question rather than an accidental mutation when the intended action, target NFR, update-versus-replace meaning, or matching existing NFR cannot be determined.

**Why this priority**: A governance tool must not guess when a guess can delete or misidentify a policy.

**Independent Test**: Exercise ambiguous actions and missing references against a temporary baseline and verify that each aborts with an explanation and leaves every file unchanged.

**Acceptance Scenarios**:

1. **Given** the intended action or target is ambiguous, **When** the request is processed, **Then** the skill asks for clarification and writes nothing.
2. **Given** a referenced NFR does not exist, **When** it is requested for update or removal, **Then** the skill names what it searched for and aborts without creating a replacement.
3. **Given** NFR files exist but the catalog is absent, **When** a mutation is requested, **Then** the skill aborts because the next identifier cannot safely be recovered.
4. **Given** `.highway/` cannot be located, **When** the skill tries to determine the project root, **Then** it aborts and asks for clarification without creating a directory elsewhere.

### Edge Cases

- An empty baseline must be initialized by Add rather than assumed to have a catalog.
- A Set may add and remove NFRs simultaneously; all losses must be named before any change.
- Removing the highest-numbered NFR must not lower `next_id`.
- An NFR with no Control relationship is valid in this phase; `controls: []` remains present.
- Relationship ownership is intentionally undecided; neither skill may populate a link in this phase.
- Similar NFRs may both be retained after advice; the skill does not enforce semantic uniqueness.
- A Set or Remove refusal must leave files, catalog, version, and `next_id` unchanged.
- A malformed or internally inconsistent catalog must be reported rather than silently reconstructed in a way that could reuse an identifier.

## Requirements *(mandatory)*

### Functional Requirements

#### Location and containment

- **FR-001**: The skill MUST write NFR artifacts under root-level `library/governance/`, a sibling of `.highway/`, and MUST never write them under `.highway/`.
- **FR-002**: Highway generators and validators MUST NOT sweep, index, or judge root-level user NFR files as Highway library content.
- **FR-003**: The library validator MUST decline to classify a root-level user NFR whether the path is supplied relatively or absolutely.
- **FR-004**: The skill MUST determine the project root from the presence of `.highway/` and MUST abort rather than guess another location when it cannot do so.

#### Catalog and NFR artifacts

- **FR-005**: Each NFR MUST be stored in an individual Markdown file named `NFRXXXXXX.md` beneath `library/governance/nfrs/`.
- **FR-006**: Each NFR file MUST use YAML frontmatter and a Markdown body containing the NFR statement and rationale.
- **FR-007**: Each NFR frontmatter MUST contain its ID, title, status, and a reserved `controls` field initialized as an empty list in this phase.
- **FR-008**: An NFR MUST NOT carry a version of its own; the baseline catalog carries the sole version.
- **FR-009**: The generated catalog at `library/governance/nfrs.md` MUST state that it defines the repository-wide NFR baseline, explain global applicability unless superseded by consuming artifacts, direct users to `/highway-nfrs`, warn against direct edits, record the baseline version and next identifier, and index every NFR.
- **FR-010**: The catalog MUST contain no timestamp or other undeclared changing content, so an unchanged baseline regenerates identically.
- **FR-011**: The catalog MUST be generated prose rather than an opaque data dump and MUST be regenerated after every successful baseline mutation.

#### Identifiers

- **FR-012**: NFR identifiers MUST use the form `NFR` followed by exactly six digits.
- **FR-013**: An NFR identifier MUST be repository-wide unique, MUST NOT change after creation, and MUST NOT be reused after removal.
- **FR-014**: The catalog MUST record the next identifier to allocate, and Add MUST consume and advance that value rather than deriving it from files currently present.

#### Actions and versioning

- **FR-015**: The skill MUST support Set, Add, Update, and Remove.
- **FR-016**: Add MUST allocate the recorded next identifier, create an NFR with an empty `controls` field, update the catalog, and increment the baseline exactly once by MINOR.
- **FR-017**: Update MUST preserve the NFR identifier and metadata not targeted by the change, update the requested definition, and increment the baseline exactly once by PATCH when the obligation is unchanged.
- **FR-018**: Remove MUST name the target by identifier and title, obtain confirmation, delete its file and catalog entry, leave `next_id` untouched, and increment the baseline exactly once by MAJOR.
- **FR-019**: Set MUST identify every NFR absent from the replacement baseline by identifier and title, obtain confirmation before writing, remove those NFRs, regenerate the catalog, and increment the baseline exactly once by MAJOR.
- **FR-020**: The baseline version MUST use Semantic Versioning in `MAJOR.MINOR.PATCH` form and version management MUST be automatic.
- **FR-021**: Where a destructive confirmation is withheld, the skill MUST change no file, catalog value, version, or identifier high-water mark.

#### Classification and advice

- **FR-022**: The skill MUST classify desired outcomes, quality attributes, operational characteristics, business outcomes, and constraints as NFR candidates.
- **FR-023**: The skill MUST identify statements prescribing specific, testable, auditable, or enforceable implementation requirements as Controls and offer to route them to `/highway-controls`.
- **FR-024**: The skill MUST advise on vague NFRs and offer at least one improved alternative without refusing an NFR the user still wants.
- **FR-025**: When a proposal resembles an existing NFR, the skill MUST name the matching NFR by identifier and title.
- **FR-026**: `/highway-controls` MUST identify outcome-shaped statements as NFRs and name `/highway-nfrs` as the destination.

#### Ambiguity and safety

- **FR-027**: If the intended action, update-versus-replace meaning, matching NFR, or referenced NFR cannot be determined confidently, the skill MUST ask and write nothing.
- **FR-028**: If a referenced NFR does not exist, the skill MUST abort, name what it searched for, and MUST NOT create one implicitly.
- **FR-029**: If the catalog is absent while NFR files exist, the skill MUST abort rather than infer `next_id` from the files.

#### Forward compatibility and authority

- **FR-030**: Every NFR MUST carry the reserved `controls` field even though relationship management is out of scope in this phase.
- **FR-031**: The skill MUST preserve compatibility with future relationship validation and traceability reporting without deciding which skill will own relationship writes.
- **FR-032**: The skill MUST treat root-level `library/governance/` as user-owned content and MUST judge only whether the proposal is better classified as an NFR or Control, not enforce Highway prose rules on the NFR content.
- **FR-033**: The `/highway-nfrs` skill MUST be the authoritative mechanism for managing the global NFR baseline and MUST instruct users not to edit generated files directly.

### Key Entities

- **NFR**: A repository-wide desired quality attribute, operational characteristic, constraint, or business outcome with a stable `NFRXXXXXX` identifier, title, status, statement, rationale, and reserved Control relationship field.
- **NFR baseline**: The complete set of NFRs, carrying one semantic version that is authoritative for the set.
- **NFR catalog**: The generated prose index containing the baseline version, the next identifier, and an index of all NFRs.
- **Identifier high-water mark**: The catalog's next allocation value, which prevents retired identifiers from being reused.
- **Control relationship**: A future association represented by the reserved `controls` field on an NFR and the already-reserved `nfrs` field on a Control; no link is populated here.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A maintainer can add an NFR from a plain-language outcome and receive an individually stored, stably identified, catalogued NFR with an empty `controls` field.
- **SC-002**: Every successful Add, Update, Remove, and Set action changes the baseline version exactly once according to the specified Semantic Versioning rule.
- **SC-003**: No accepted destructive action removes an NFR before the user has seen its identifier and title, and a refused confirmation produces zero file changes.
- **SC-004**: No sequence of add and remove actions produces a repeated NFR identifier.
- **SC-005**: Regenerating the catalog from an unchanged baseline produces byte-identical output because no timestamp is recorded.
- **SC-006**: Root-level NFR content is absent from Highway catalogs and is not reported by Highway content validators, regardless of relative or absolute invocation path.
- **SC-007**: At least one outcome-shaped proposal, one Control-shaped proposal, one vague proposal, and one similar proposal each produce the specified advice or routing behavior without preventing the author's final decision where applicable.
- **SC-008**: Ambiguous requests, missing references, missing catalogs with existing files, and missing project roots produce no mutation and an explanation of what must be clarified.
- **SC-009**: The Highway test suite passes with the NFR skill registered, generated artifacts current, and the reciprocal `/highway-controls` routing guidance present.

## Assumptions

- **The user owns everything under root `library/governance/`.** The skill writes there and governs nothing about the prose beyond classification advice.
- **The NFR and Control baselines remain independent in this phase.** Reserved fields are present but no relationship is populated or validated.
- **The project root is the directory containing `.highway/`.** The skill does not create a governance directory when that anchor is absent.
- **The catalog is authoritative for `next_id`.** Existing files cannot safely recover the highest identifier ever issued.
- **The baseline starts at the repository's existing semantic versioning convention and increments one time per successful action.** The exact initial version is established during implementation from the repository state.
- **The skill's own documentation and generated adapters are Highway artifacts.** They remain subject to the Highway Skills Constitution and Experience Standard, unlike the user-owned NFR files.
- **Relationship ownership is intentionally undecided.** A later relationship-management phase must decide it before either skill writes links.

## Dependencies

- The existing `/highway-controls` skill and its reserved `nfrs` relationship field.
- The Highway Skills Constitution and Highway Experience Standard for the skill's own authoring, interaction, and generated artifacts.
- The existing root-containment behavior that distinguishes user `library/governance/` from `.highway/library/governance/`.
- The generated catalog, adapter, distribution, and registration mechanisms used by existing Highway skills.

## Out of Scope

- Populating, validating, or owning NFR-to-Control relationships.
- Deciding which skill owns relationship writes once both sides can populate links.
- Validating whether an NFR is actually achieved by a repository solution.
- Enforcing a specific technology, implementation, test method, or prose style on an NFR.
- Reusing or renumbering retired NFR identifiers.
- Reconstructing a missing catalog's high-water mark from individual NFR files.
