# Feature 060 Research

## Decision: Preserve the existing Markdown and Bash contract architecture

**Rationale**: Discovery is an instruction-driven repository skill. Its shipped behavior is
owned by `.highway/skills/highway-discovery/SKILL.md`, its durable output structure is owned by
`.highway/library/templates/output/discovery-record.md`, and its deterministic checks use the
existing Bash 3.2-compatible test harness. Feature 060 can be implemented without a new runtime,
package, interpreter, service, or storage layer.

**Alternatives considered**: Introducing an executable Discovery engine or a new parser was
rejected because the repository's current contract is Markdown-driven and the feature explicitly
preserves existing toolchain and ownership boundaries.

## Decision: Treat Request Solution Constraints as closed, read-only Discovery inputs

**Rationale**: The Request-side contract defines eight fields in stable order and distinguishes
empty arrays from `unknown`. Request owns collection and validity; Discovery consumes the completed
Request evidence and must not reinterpret absent values, mutate the Request, or add recommendation
content to it.

**Alternatives considered**: Duplicating the Request schema in Discovery was rejected because it
would create competing authorities. Inferring constraints from other Request prose was rejected
because it would violate deterministic, explicit-input behavior.

## Decision: Separate eligibility filtering from retained-candidate scoring

**Rationale**: Known allowed solution classes and mandatory restrictions define the candidate space.
A candidate that fails `existing_platforms_required`, hosting, vendor, procurement, or regulatory
constraints is excluded before scoring and recorded in the Candidate Elimination Log. Constraint
Alignment Score is calculated only for retained candidates and cannot restore an eliminated option.
Preferred platforms and known systems influence scoring only.

**Alternatives considered**: Applying all constraints as score penalties was rejected because it
would allow invalid candidates to reach comparison or recommendation. Letting required-platform
mismatch remain eligible was rejected by the accepted clarification for this feature.

## Decision: Use explicit deterministic scoring tables

**Rationale**: Required-platform match is 100 for every retained candidate because failed matches
are filtered before scoring. Preferred-platform alignment is 100 when used and 50 otherwise.
Known-system alignment is 100 when all declared systems are reused, 75 when one or more but not all
are reused, and 50 when none are reused. The overall score uses Objective 25, NFR 25, Control 20,
Constraint Alignment 20, and Risk Reduction 10.

**Alternatives considered**: A qualitative or relative "higher score" rule was rejected because it
would permit implementation-specific interpretation and undermine repeatability.

## Decision: Extend existing Discovery contracts and shared template

**Rationale**: Feature 049 established the Discovery analysis, conversation, and artifact contract
boundaries. Feature 060 adds constraint input loading, filtering, elimination reporting, retained
candidate fields, matrix semantics, and revised score composition to the analysis and artifact
contracts while leaving the conversation and ADR handoff ownership intact.

**Alternatives considered**: A separate constraint-specific output artifact was rejected because
it would split the canonical Discovery record and make the recommendation/matrix inconsistent.

## Decision: Keep output ordering explicit and canonical

**Rationale**: Request Solution Constraints render in the eight-field Request order. Candidate
Elimination Log entries sort by candidate identifier, constraint category, then constraint
identifier or value. Retained candidates and matrix rows retain the existing deterministic option
ordering. These rules eliminate filesystem and generation-order variation.

**Alternatives considered**: Preserving source or generation order was rejected because candidate
creation order is not a stable contract.

## Decision: Validate through static contracts and disposable behavior probes

**Rationale**: Existing tests combine document-contract assertions with shell probes for source,
generated artifacts, and disposable fixtures. Feature 060 should add assertions for every new
contract and seeded failures for each declared artifact class, then run focused validators,
generator correspondence checks, packaging checks, and the full suite.

**Alternatives considered**: Relying only on manual review or only on a full-suite result was
rejected because neither independently proves the new filtering and ordering rules.

## Resolved Planning Unknowns

- **Implementation language**: Existing Markdown instructions and Bash 3.2-compatible checks.
- **Persistence**: Existing user-owned Request/Discovery Markdown and catalog files.
- **External interfaces**: Existing skill invocation, record, catalog, analysis, conversation, and
  ADR handoff contracts; no new external interface.
- **Performance and scale**: One bounded Request per invocation, two through five retained options,
  finite closed-input catalogs, and no network operation.
