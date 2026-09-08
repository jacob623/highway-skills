# Feature Specification: Distribution Packaging

**Feature Branch**: `012-distribution-packaging`

**Created**: 2026-09-08

**Status**: Draft

**Input**: User description: "I want a repeatable packaging step that produces the user-facing Highway distribution from this repository, because I develop Highway with Spec Kit but ship it without Spec Kit, and today that strip is manual and unverified. Every path in the repository must be declared as either shipped or development-only, with no ambiguity, and the packaging tool must read that declaration rather than hard-coding a list. After packaging, the tool must verify the result is self-contained: no file in the package references .specify/ or specs/, every documentation cross-reference in the package resolves to a path inside the package, and the skill validator runs successfully against the packaged tree with the development directories absent. Packaging the same commit twice must produce byte-identical output. Follow the same drift-refusal and hash-manifest pattern that generate-agent-adapters.sh already uses. Add tests so that a packaging regression fails in the test suite rather than at a user. I also need to decide and record whether the package includes the authoring toolchain under .highway/tools/ and the Layer 1 constitution, or only the runtime skills, catalog, library, and agent adapters."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Producing the distribution is one repeatable step (Priority: P1)

Highway is built in a repository that contains both the product and the machinery used to build
it. Handing the product to a user means separating the two. Today that separation exists only as
an intention: it has never been performed, no tool performs it, and the boundary is enforced only
by a check that says what must not be referenced rather than what is included.

**Why this priority**: Nothing else in this feature is reachable without it. A verification step
needs an artifact to verify, and a regression test needs a command to re-run.

**Independent Test**: Run the packaging step against a clean checkout and inspect the result: it
contains the product, contains nothing used only to build the product, and required no manual
step.

**Acceptance Scenarios**:

1. **Given** a clean repository, **When** the packaging step runs, **Then** a distribution is
   produced without any manual file selection.
2. **Given** the produced distribution, **When** its contents are compared to the declaration,
   **Then** every included path is declared as shipped and no development-only path appears.
3. **Given** a path in the repository, **When** its classification is looked up, **Then** exactly
   one classification applies and no path is unclassified.
4. **Given** the same commit, **When** the packaging step runs twice, **Then** the two results are
   byte-identical.

---

### User Story 2 - The distribution is verified before anyone receives it (Priority: P1)

A distribution that is merely produced is not known to work. The failure this feature exists to
prevent is silent: the repository is complete, so every check passes locally, while the extracted
subset is missing something it needs and only the user discovers it.

**Why this priority**: Producing an unverified distribution reproduces the defect that motivated
the whole governance effort — a green development tree and a broken product.

**Independent Test**: Take the produced distribution alone, with no access to the repository that
built it, and confirm it is internally complete and its tooling runs.

**Acceptance Scenarios**:

1. **Given** the produced distribution, **When** every file is searched for a development-only
   location, **Then** none is found.
2. **Given** the produced distribution, **When** every documentation cross-reference is followed,
   **Then** each resolves to a path inside the distribution.
3. **Given** the produced distribution in isolation, **When** the skill validator runs against it,
   **Then** it completes successfully.
4. **Given** a verification failure, **When** the packaging step reports it, **Then** it names the
   file and the specific problem, and produces no distribution.

---

### User Story 3 - A packaging regression fails here, not at a user (Priority: P2)

Once the distribution is correct, nothing prevents a later change from breaking it. Because the
development tree always contains everything, such a break is invisible locally — which is the
same class of defect this whole effort has been removing.

**Why this priority**: It protects the outcome of the first two stories for the life of the
project, but delivers nothing until they exist.

**Independent Test**: Deliberately introduce a change that would break the distribution, run the
test suite, and confirm it fails and names the cause.

**Acceptance Scenarios**:

1. **Given** a change that adds an undeclared path, **When** the suite runs, **Then** it fails and
   names that path.
2. **Given** a change that makes a shipped file reference a development-only location, **When**
   the suite runs, **Then** it fails and names that file.
3. **Given** an unchanged repository, **When** the suite runs, **Then** the packaging checks pass.

---

### Edge Cases

- **A directory can hold both product and non-product.** The agent adapter directories contain
  Highway's own adapters alongside eleven adapters belonging to the development workflow. Any
  classification that works at directory granularity gets this wrong, so the declaration must
  distinguish entries within a directory.
- **What is the front page of a distribution?** The repository's front page is the natural
  candidate, but it currently links to a development-only location, so shipping it unchanged
  would violate the boundary on the first run. *(See Question 2.)*
- **Regenerating breaks determinism; copying preserves it.** One generated artifact records the
  time it was generated. A packaging step that regenerates it produces a different result on every
  run; one that copies what is already committed does not. This constrains how packaging is
  allowed to work.
- **A distribution is not a repository.** Version control metadata, ignore files, and anything
  else meaningful only inside a working copy have no role in a distribution, and the toolchain
  must not assume a repository is present.
- **An empty classification is a silent hole.** If a path can be neither shipped nor
  development-only, a new directory would default to invisible and never be noticed. Every path
  must resolve to exactly one classification.
- **The test fixtures are deliberately non-conformant.** They exist to make checks fail. The
  recorded scope decision excludes the test directory, and nothing outside it references it, so
  the severance is clean and nothing deliberately broken reaches a recipient.
- **A partial toolchain is worse than none.** The generators write into the directory above the
  framework root. Including the validator without them would let a recipient confirm a skill is
  correct and then have no way to put it in front of an agent.
- **Verification must be able to fail.** A verification step never observed rejecting a bad
  distribution proves nothing about the distributions it accepts.
- **The front page's source cannot sit where it lands.** The distribution's front page belongs at
  the distribution root, but the repository root is already occupied by the repository's own front
  page, which is not the same document. The classification must therefore be able to say that a
  source path appears elsewhere in the distribution.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: A single step MUST produce the distribution from the repository, with no manual file
  selection.
- **FR-002**: Every path in the repository MUST carry exactly one classification: included in the
  distribution, or not.
- **FR-003**: The classification MUST be declared in exactly one place.
- **FR-004**: The packaging step MUST read that declaration rather than carrying its own copy of
  the list.
- **FR-005**: The classification MUST be able to distinguish entries within a single directory,
  because at least one directory holds both product and non-product content.
- **FR-006**: An undeclared path MUST be reported rather than silently included or excluded.
- **FR-007**: The packaging step MUST verify that no file in the distribution references a
  development-only location.
- **FR-008**: The packaging step MUST verify that every documentation cross-reference in the
  distribution resolves to a path inside the distribution.
- **FR-009**: The packaging step MUST verify that the skill validator, run from inside the
  distribution, completes successfully against every skill in the distribution.
- **FR-009a**: That verification MUST use only what the distribution contains, so that a missing
  component is detected rather than supplied from the repository.
- **FR-010**: A verification failure MUST name the file and the specific problem.
- **FR-011**: A verification failure MUST prevent a distribution from being produced, rather than
  producing one and reporting a warning.
- **FR-012**: Packaging the same repository state twice MUST produce byte-identical results.
- **FR-013**: The packaging step MUST refuse to overwrite a target it did not produce, recording
  what it produced so that later runs can tell.
- **FR-014**: A change that would break the distribution MUST fail the test suite.
- **FR-015**: The verification MUST be demonstrably capable of failing.
- **FR-016**: The decision about which components the distribution includes MUST be recorded with
  its reasoning, not merely applied.
- **FR-017**: The distribution MUST carry a front page written for someone receiving Highway,
  describing what they can do with it.
- **FR-018**: The distribution's front page MUST NOT be the repository's own front page, which
  addresses a contributor and describes work a recipient cannot perform.
- **FR-019**: The classification MUST be able to state that a source path appears at a different
  location in the distribution, because the front page's source cannot occupy the distribution
  root in the repository.

### Key Entities

- **Distribution**: The set of files handed to a user. Contains the product and nothing used only
  to build it.
- **Path classification**: The declaration assigning every repository path to exactly one of
  included or excluded.
- **Packaging step**: The single operation producing a distribution from the repository.
- **Verification**: The checks a candidate distribution must pass before it is accepted.
- **Production record**: What the packaging step recorded about what it produced, so a later run
  can tell its own output from a hand-edit.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A distribution is produced by one step, with zero manual file selections.
- **SC-002**: Every repository path resolves to exactly one classification; the count of
  unclassified paths is zero.
- **SC-003**: Searching the distribution for a development-only location returns zero results.
- **SC-004**: Every documentation cross-reference in the distribution resolves; the count of
  unresolvable references is zero.
- **SC-005**: The skill validator completes successfully against the distribution in isolation.
- **SC-006**: Two consecutive packaging runs from the same repository state produce no
  differences.
- **SC-007**: Introducing an undeclared path, or a development-only reference in a shipped file,
  causes the test suite to fail and name the cause.
- **SC-008**: The complete test suite passes, with no test removed or weakened.
- **SC-009**: The component-scope decision and its reasoning are recorded in a durable document.

## Assumptions

- The boundary this feature enforces already exists as a rule and as a check that searches shipped
  content for development-only references. This feature adds the complementary half: a declaration
  of what is included, and a produced artifact that can be verified as a whole. The existing
  declaration of distributed paths is the natural seed for the new classification, and the two
  must not become separate sources of truth.
- Packaging copies committed artifacts rather than regenerating them. Regeneration would defeat
  byte-identical output, because one generated artifact records its generation time. Producing
  identical results therefore depends on the repository already being current, which existing
  rules already require.
- The distribution is a directory tree rather than an archive format. Nothing in the description
  requires an archive, and a tree is directly inspectable by the verification steps.
- A distribution is not a working copy, so version-control metadata and ignore files are excluded
  without needing a decision.
- The repository front page currently references a development-only location. Because the recorded
  decision gives the distribution its own front page, that reference stays in the repository and
  never reaches a recipient. The repository front page is not classified as included.
- The recorded scope decision keeps the development constitution's rule about the packaged tree
  validating successfully both satisfiable and meaningful, because the validator is present in the
  distribution. No amendment to that rule is needed.
- No skill content changes, so no skill version increments and no generated artifact is
  regenerated by this feature.

## Clarifications

### Session 2026-09-08

- **Q1**: Does the distribution include the authoring toolchain and the governing document, or
  only the runtime content?
- **A1**: The distribution includes the runtime content, the authoring toolchain, and the
  governing document. It excludes the toolchain's own test suite and fixtures. Everything included
  sits inside the framework directory.
- **Consequences**: A recipient can author a skill, validate it, and generate the adapters that
  put it in front of their agent — the complete loop rather than a fragment of it. Validation
  requires the governing document, so it is included; the validator resolves it relative to the
  toolchain's own location, which holds inside the distribution.
- **Why not the validator alone**: the generators write into the directory above the framework
  root, which in a recipient's workspace is their own project root. Shipping validation without
  generation would let someone confirm a skill is correct and then have no way to deploy it.
- **Why the tests are excluded**: the fixtures are deliberately non-conformant, existing to prove
  checks can fail. Nothing outside the test directory references it, so the severance is clean and
  nothing deliberately broken reaches a recipient.
- **On the rule identifiers becoming visible**: this was weighed as the main cost and found
  smaller than it appears. The governing document already commits to identifier stability across
  amendments and to never reusing a retired identifier. Shipping the toolchain makes an existing
  commitment visible rather than creating a new one.
- **An earlier decision reversed**: runtime-only was recorded first and then reconsidered. It
  would have left one development-constitution rule describing a tree that is not the
  distribution, because that rule's observable names the validator running against the packaged
  tree. Including the toolchain makes that rule literally true again and lets the packaging
  verification prove self-containment by running the shipped validator from inside the
  distribution — which runtime-only could not do, since the validator resolves its governing
  document relative to its own location rather than the tree under inspection.

- **Q2**: Does the distribution have a front page, and where does it come from?
- **A2**: A distribution-specific front page, separate from the repository's own.
- **Consequences**: A recipient gets orientation written for them. The repository's front page
  addresses a contributor, describes the test suite, which is not included, and carries a
  reference into a development-only location. Those three make it the wrong document to hand over
  even though the toolchain it describes is now largely present. The cost is a second document to
  keep current, and a classification that can place a source file at a different location in the
  distribution.
