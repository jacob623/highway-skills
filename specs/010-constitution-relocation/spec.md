# Feature Specification: Constitution Relocation and Shipped-Tree Independence

**Feature Branch**: `010-constitution-relocation`

**Created**: 2026-09-08

**Status**: Draft

**Input**: User description: "I want the Highway Skills Constitution to live inside the .highway/ framework directory instead of .specify/memory/, because .specify/ is a development-only directory that is stripped when Highway is packaged for users, while the validators under .highway/tools/ that read the constitution do ship. Today that means the packaged toolchain is broken and nothing detects it, and it also means the /speckit.constitution command can overwrite Highway's shipping governance document. Move the constitution to .highway/governance/constitution.md and update every reference to it, including validate-skill.sh, validate-library.sh, lib/constitution.sh, the tools README, the skills authoring standard, and the three tests that resolve the path. The path lib/constitution.sh resolves should be configurable rather than hard-coded so a caller can point at a different location. Separately, no file under .highway/ or under the generated agent adapter trees may reference specs/ or .specify/ at all: the highway-help skill's Outputs and Verification sections currently link into specs/009-skill-id-namespace-alignment, and those links are copied verbatim into every generated adapter, so they are dangling references in every shipped copy. Replace those with references that resolve inside the shipped tree, bump the skill's version accordingly, and regenerate the catalog and all adapters. Add a test that fails if any shipped file references a development-only path."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The governance document ships with the framework it governs (Priority: P1)

The Highway Skills Constitution is the document the validation tooling reads to decide whether a
skill is conformant. That tooling is part of the framework and is distributed to users. The
constitution currently lives in a directory that exists only during development and is removed
when Highway is packaged, so the distributed tooling has no document to read. The constitution
moves inside the framework directory alongside the tooling that depends on it.

**Why this priority**: Without this, the distributed validation toolchain cannot function at all.
The defect is also invisible during development, because the development tree always contains the
directory that the distribution lacks.

**Independent Test**: Copy the framework directory on its own, with the development directories
absent, and confirm the validator resolves its governance document and runs to completion.

**Acceptance Scenarios**:

1. **Given** the constitution has moved into the framework directory, **When** a skill is
   validated, **Then** validation completes and reports the same verdict it reported before the
   move.
2. **Given** a copy of the framework directory with all development directories removed, **When**
   a skill is validated, **Then** validation completes rather than failing to locate its
   governance document.
3. **Given** the development-tree location of the constitution, **When** a maintainer regenerates
   the development-process governance document, **Then** the Highway Skills Constitution is
   unaffected.

---

### User Story 2 - No distributed file points at something the user does not have (Priority: P1)

Files that ship to users currently contain references to development-only locations: design
records, contracts, and the governance document, all under directories excluded from the
distribution. Some of these are links inside documents users read, and two of them sit inside the
help skill's body, which is copied verbatim into every generated agent adapter. Every such
reference is unresolvable in the distribution.

**Why this priority**: These are user-visible defects in the product surface. The help skill's
references are the worst case, because they are duplicated into three separate agent trees.

**Independent Test**: Search every distributed file for a reference to a development-only location
and confirm none is found; follow every cross-reference in a distributed file and confirm each
resolves to something present in the distribution.

**Acceptance Scenarios**:

1. **Given** the distributed framework tree, **When** every file is searched for a reference to a
   development-only location, **Then** no occurrence is found.
2. **Given** the help skill's body, **When** its cross-references are followed, **Then** each one
   resolves to a file that is present in the distribution.
3. **Given** the help skill's body has changed, **When** the catalog and agent adapters are
   regenerated, **Then** every generated copy carries the corrected references and the recorded
   version.
4. **Given** a distributed document that previously cited a design record by path, **When** a
   reader consults it, **Then** the provenance of the decision is still identifiable without a
   path that fails to resolve.

---

### User Story 3 - The boundary cannot be crossed again without failing (Priority: P2)

Once the distributed tree is independent, nothing currently prevents a future change from
reintroducing a development-only reference. Because the development tree always contains those
directories, such a regression would pass every existing check and reach users undetected. An
automated check makes the boundary self-enforcing.

**Why this priority**: It protects the outcome of the first two stories for the life of the
project, but it delivers no value until those stories are complete.

**Independent Test**: Deliberately add a development-only reference to a distributed file, run the
test suite, and confirm it fails and names the offending file.

**Acceptance Scenarios**:

1. **Given** a distributed file containing a reference to a development-only location, **When**
   the test suite runs, **Then** it fails and names the offending file.
2. **Given** a distributed tree with no such reference, **When** the test suite runs, **Then** the
   check passes.
3. **Given** a development-only file that references a development-only location, **When** the
   test suite runs, **Then** the check does not flag it.

---

### Edge Cases

- **What counts as a distributed file?** The check needs an unambiguous rule for which paths are
  in scope. Test fixtures and test scripts sit inside the framework directory but may or may not
  be distributed. Resolved by requiring the feature to state the in-scope path set explicitly, in
  one place, rather than encoding it separately in each check.
- **What happens to the vacated development-tree location?** Every one of the ten development
  workflow commands reads that path. Removing the file outright degrades all of them until the
  next phase replaces it. Resolved by leaving a short placeholder at the vacated location that
  records the relocation and states that development-process rules will replace it.
- **How is design provenance preserved when a path reference is removed?** Source comments and
  documents cite design records to explain why a decision was made. Removing the citation loses
  that. Resolved by keeping the citation in a form that names the record without stating a path
  that fails to resolve.
- **How is the help skill's version classified?** Its cross-references change but the behaviour it
  guarantees does not. The change is a wording repair with no change to declared inputs, outputs,
  or verification criteria.
- **What if a reference is inside a test fixture?** Fixtures deliberately contain non-conformant
  content to exercise failure paths. The check must not treat fixture content as a violation.
- **What about the plan document at the repository root?** It is development-only and legitimately
  references development locations; it must not be treated as distributed.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Highway Skills Constitution MUST reside inside the framework directory that is
  distributed to users.
- **FR-002**: Every consumer of the constitution MUST resolve it at its new location without the
  caller supplying an override.
- **FR-003**: The constitution's location MUST remain overridable by a caller. *(An override
  mechanism already exists; only the fallback location changes.)*
- **FR-004**: Validation MUST succeed against a copy of the framework tree from which all
  development-only directories have been removed.
- **FR-005**: No distributed file MUST reference a development-only location, whether that
  reference is a document link or a source comment.
- **FR-006**: Every cross-reference in a distributed file MUST resolve to a path that is present
  in the distribution.
- **FR-007**: Where a distributed file previously cited a design record by path, it MUST continue
  to identify that record by name rather than by path.
- **FR-007a**: The form used to identify a design record by name MUST be consistent across every
  distributed file that cites one.
- **FR-008**: The help skill's recorded version MUST be incremented to reflect its content change.
- **FR-009**: The catalog and every generated agent adapter MUST be regenerated so that no
  generated copy retains a superseded reference.
- **FR-010**: The vacated development-tree location MUST hold a placeholder that records the
  relocation, so that development workflow commands continue to function.
- **FR-011**: An automated check MUST fail when a distributed file references a development-only
  location, and MUST name the offending file.
- **FR-012**: The automated check MUST NOT flag a development-only file, nor a test fixture whose
  non-conformance is deliberate.
- **FR-013**: The set of paths treated as distributed MUST be declared in exactly one place.
- **FR-014**: Documentation that describes the constitution's location MUST state the new
  location.

### Key Entities

- **Governance document**: The document defining the rules a skill must satisfy. Read by the
  validation tooling; distributed to users.
- **Distributed file**: A file included in the user-facing package.
- **Development-only file**: A file excluded from the user-facing package, existing solely to
  build and record the development of Highway.
- **Cross-reference**: A pointer from one file to another, whether a document link or a source
  comment citing a design record.
- **Placeholder**: A short stand-in left at a vacated location so that consumers of that location
  continue to function.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Searching every distributed file for a reference to a development-only location
  returns zero results.
- **SC-002**: Validation of a skill succeeds against a copy of the framework tree with all
  development-only directories removed.
- **SC-003**: Every cross-reference in a distributed file resolves to a path present in the
  distribution, with zero unresolvable references.
- **SC-004**: Introducing a single development-only reference into any distributed file causes the
  test suite to fail and to name that file.
- **SC-005**: The complete test suite passes, with no test removed or weakened.
- **SC-006**: Every skill's verdict is unchanged from before this feature, except where a verdict
  change is the deliberate result of a recorded content change.
- **SC-007**: Regenerating the catalog and agent adapters produces no difference after the feature
  is complete, confirming every generated copy is current.

## Assumptions

- The validation tooling is distributed to users. If the package were later reduced to runtime
  content only, FR-004 would become unnecessary but would remain harmless. That packaging decision
  is out of scope here and is settled in a later phase.
- The override mechanism for the constitution's location already exists, so FR-003 requires
  changing the fallback rather than adding a capability. The user description assumed this needed
  to be built.
- The scope of references to remove is larger than the user description assumed: development-only
  paths are referenced from twenty distributed files, not two, totalling thirty-four references.
  The description named only the help skill's two document links; the remainder are
  cross-references in tooling source comments and in documentation.
- Removing a path reference does not require removing the design record it named; the record stays
  where it is, and the distributed file identifies it by name rather than by path.
- The help skill's change is a wording repair that alters no declared input, output, or
  verification criterion, so its version increment is the smallest available.
- The placeholder left at the vacated location is temporary. The next phase replaces it with a
  development-process governance document; that work is out of scope here.
- Test fixtures deliberately contain non-conformant content and are excluded from the new check.
- This feature changes no rule text in the constitution. Only its location and the references to
  it change.
- This feature does not introduce a packaging tool. It establishes the independence that a
  packaging tool will later verify continuously.

## Clarifications

### Session 2026-09-08

- **Q**: Are source comments citing design records in scope alongside document links, or is this
  feature limited to references that render as broken links to a user?
- **A**: Both kinds are in scope. Every reference to a development-only location is removed from
  every distributed file, regardless of whether it renders as a link. Provenance is preserved by
  naming the design record rather than stating its path.
- **Consequences**: Twenty distributed files are in scope rather than five. The automated check
  becomes a plain search for the development-only location strings, requiring no judgement about
  reference kind at check time, which is what makes the check trustworthy over time. The
  alternative would have required the check to distinguish links from comments and would have left
  a category of reference permanently exempt.
