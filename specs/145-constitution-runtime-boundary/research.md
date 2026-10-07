# Research: Constitution Runtime Boundary

## Decision: Amend only the Highway Skills Constitution and its development validators

**Rationale**: The requested change is a Layer 1 governance refactor. The authoritative artifact is `.highway/governance/constitution.md`; the repository's Constitution inventory, coverage, rule, alignment, and context tests validate it. The Experience Standard, Highway Identity, and individual skills are explicitly protected from this feature.

**Alternatives considered**:
- Updating runtime skills at the same time: rejected because the request requires downstream cleanup to remain visible follow-up work.
- Creating a replacement runtime failure or collaboration contract: rejected because it would recreate the upward runtime dependency this feature removes.

## Decision: Classify the amendment as MAJOR

**Rationale**: The change removes or redefines current governance rules and principles, retires runtime-owned concepts, and changes the meaning of Principle VI, Principle XI, Principle XII, Principle XIII, precedence, and Governance. The existing Constitution versioning policy classifies removed or redefined rules as MAJOR. The current footer is `7.0.0`, so the implementation target is `8.0.0` unless amendment review identifies an additional breaking classification.

**Alternatives considered**:
- MINOR for a scope clarification: rejected because previously conforming runtime-governance interpretations must no longer conform.
- PATCH for wording-only cleanup: rejected because rule ownership and applicability change materially.

## Decision: Preserve stable surviving rule IDs and retire obsolete IDs explicitly

**Rationale**: Stable identifiers are used by inventory, coverage, observables, tiers, and historical validation. Surviving IDs must not be renumbered. Removed or redefined rules must be listed in the Sync Impact Report and any repository retirement mechanism used by the existing validators.

**Alternatives considered**:
- Renumbering rows to close gaps: rejected because it breaks traceability and historical references.
- Leaving obsolete rows marked non-normative: rejected because stale runtime governance would remain discoverable as current policy.

## Decision: Treat determinism as a contract classification, not a universal runtime reasoning rule

**Rationale**: Authoritative state, mutation, persistence, ownership, routing, readiness, identifiers, artifact structure, output contracts, destructive actions, declared outcomes, and contractually deterministic generated content need repeatable outcomes. Advisory interpretations, connections, implications, alternatives, recommendations, explanations, examples, and phrasing may vary within owning contracts. Principle VI, its rationale, precedence reason, and examples must express that boundary without instructing executing agents.

**Alternatives considered**:
- Retain identical-action determinism for every choice: rejected because it constrains Experience-owned generative interaction.
- Remove Principle VI entirely: rejected because correctness-critical contract decisions still need explicit deterministic criteria.

## Decision: Narrow context governance to development validation

**Rationale**: Principle XI remains useful for checking that a skill declares context sources and respects user-owned workflow inputs, but its current Vision, Platform Objectives, and behavioral-guidance roles are obsolete. `highway-identity.md` is non-normative shared context only. Generic runtime interaction semantics belong to the Experience Standard or owning skill.

**Alternatives considered**:
- Replace retired context documents with new categories: rejected by scope and by the requested consolidation into Highway Identity.
- Remove all context validation: rejected because context declaration and ownership remain important shipped-contract safeguards.

## Decision: Remove Constitution-owned runtime collaboration and failure authority

**Rationale**: Working Ideas, Converged Proposals, Active Reasoning Context, collaborative development, and convergence are Experience-owned when user-visible. The Constitution may validate delegation and artifact acceptance boundaries, but it must not define runtime lifecycle semantics. Common failure behavior must be required of the skill or intended runtime owner, without creating a new shared runtime failure contract in this change.

**Alternatives considered**:
- Keep the current Principle XIII with an Experience disclaimer: rejected because the remaining rules would still make Layer 1 the apparent runtime authority.
- Copy Experience Standard definitions into a development section: rejected because it duplicates and risks diverging from Layer 2.

## Decision: Audit downstream references without editing them

**Rationale**: Existing skills and tests reference the Constitution common failure model and retired context documents. The implementation should produce an explicit inventory of follow-up references and adjust only Constitution-specific validation expectations. This keeps scope honest and lets later owner features migrate runtime contracts deliberately.

**Alternatives considered**:
- Rewrite all downstream skills in this feature: rejected by the explicit change discipline.
- Ignore downstream references: rejected because it would conceal breakage introduced by the boundary change.

## Observed downstream follow-up references

The final suite exposed three existing consumers that remain outside this feature's protected scope:

- `.highway/tools/tests/constitution-profile-context.test.sh` still asserts Identity content owned by
	`.highway/library/knowledge/highway-identity.md`.
- `profile-participation.test.sh` still expects the older context vocabulary and requires a later
	Profile/Identity synchronization update.
- `profile-runtime-separation.test.sh` treats any edit to the Constitution as a protected Profile
	runtime-artifact change; its baseline policy must be updated by the owning Profile feature.

These are reported rather than repaired here. The Experience Standard, Highway Identity, Profile
artifacts, and individual skills remain unmodified.
