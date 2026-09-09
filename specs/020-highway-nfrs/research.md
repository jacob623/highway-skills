# Research: Highway NFR Management

**Feature**: 020-highway-nfrs | **Date**: 2026-09-08

The feature specification settles the product behavior. Research confirms how those decisions fit the
existing Controls implementation and the repository's layered governance rules.

## R1 - Where user NFRs belong

**Decision**: Write NFR catalogs and records under root-level `library/governance/`, sibling to
`.highway/`, and never under `.highway/`.

**Rationale**: The existing containment guard resolves paths and declines files outside the
framework root. Keeping user governance at the project root means Highway can provide the authoring
skill without applying Highway's own library rules to the user's NFR prose. This is the same
boundary already used by Controls.

**Alternatives considered**:

- `.highway/library/governance/`: rejected because it places user-owned content inside the
  framework's validated library.
- A second hidden governance directory: rejected because it would diverge from the established
  Controls location and make the two baselines harder to discover.

## R2 - How identifiers and versions remain authoritative

**Decision**: Store `next_id` and the sole Semantic Version in the generated NFR catalog. Do not
store a per-NFR version and never derive the next identifier from files present.

**Rationale**: Removing the highest-numbered record must not make its identifier available again.
The catalog's high-water mark preserves that fact. One baseline version avoids conflicting counters
between an item and the set it belongs to. These are settled Controls decisions and must remain
symmetric.

**Alternatives considered**:

- Derive the next ID from the highest file: rejected because removal can cause identifier reuse.
- Add a version to each NFR: rejected because two version authorities could disagree.
- Add a timestamp to the catalog: rejected because unchanged inputs would produce different output.

## R3 - How actions and destructive changes are exposed

**Decision**: Use one `/highway-nfrs` skill with Set, Add, Update, and Remove. Require confirmation
for Set and Remove after naming each lost NFR by identifier and title; write nothing when
confirmation is withheld.

**Rationale**: This matches the Controls action contract and the Experience Standard's loss
confirmation rule. Set is retained in the same skill because the user requested one authoritative
mechanism and the implementation can measure the P7.4/P7.5 limits before deciding whether a split
is required.

**Alternatives considered**:

- A separate Set skill: deferred unless the measured skill contract exceeds the constitution's
  limits. Splitting prematurely would create two authorities without evidence that it is needed.
- Confirmation by count only: rejected because a count does not identify the work at risk.

## R4 - How NFRs and Controls classify each other

**Decision**: NFRs describe outcomes, quality attributes, operational characteristics, constraints,
or business outcomes. Specific, testable, auditable, or enforceable implementation requirements are
Controls. Each skill routes the other category to the reciprocal skill.

**Rationale**: The classification is already the conceptual mirror of `highway-controls`. Adding
reciprocal routing in this feature prevents a user from being told only where a statement does not
belong. Relationship fields remain empty; classification routing is not relationship management.

**Alternatives considered**:

- Refuse misclassified input: rejected because vague or user-preferred governance should remain
  recordable after advice.
- Populate NFR-Control links during routing: rejected because relationship ownership is explicitly
  deferred and writing from both sides could create disagreement.

## R5 - What generated and validation artifacts are required

**Decision**: Register the skill with the catalog, three generated adapters, adapter manifest rows,
distribution manifest rows, and regenerated outputs. Add focused tests for NFR behavior and the
reciprocal Controls routing, then run the complete suite.

**Rationale**: Feature 016's correspondence rules make source-to-artifact completeness a required
part of adding a skill. The Controls feature also demonstrated that user-boundary behavior needs a
focused test while existing fixtures must continue to pass.

**Alternatives considered**:

- Ship only `SKILL.md`: rejected because adapters and manifests are part of the distributed skill
  surface.
- Modify existing tests without adding a focused test: rejected by the development constitution's
  verification rule for behavioral changes.

## R6 - Platform and dependency constraints

**Decision**: Keep any repository script changes compatible with Bash 3.2.57 and the declared
utility toolchain. Add no runtime package or external service.

**Rationale**: The distributed Highway tree must run on the repository's target macOS environment.
The NFR records themselves are Markdown and do not require a parser or service dependency.

**Alternatives considered**:

- Introduce a YAML or Markdown runtime parser: rejected because the skill is agent instructions and
  the repository's existing generation/test patterns use shell and text files.
- Add a package manager dependency: rejected because it increases distribution and platform risk
  without adding user value for this baseline.

## Conclusion

All technical-context decisions are resolved. No open clarification item remains for Phase 1.
The implementation must preserve the root containment boundary, deterministic catalog output,
identifier high-water mark, reciprocal routing, generated-artifact correspondence, and explicit
loss confirmation.
