# Feature 089 Research

## Decision: Constitution owns N6-N9

- **Decision**: Register N6-N9 in the Highway Skills Constitution's closed Permitted N/A Conditions table. The Experience Standard references applicable IDs without redefining them.
- **Rationale**: The Compliance Review Protocol requires every N/A verdict to name an ID from its closed list. A single registry prevents the new persistence and experience conditions from becoming ambiguous across governing documents.
- **Alternatives considered**: Defining N6-N9 independently in both documents was rejected because identical IDs would have competing owners. Moving the historical N3/N5 vocabulary is deferred; Feature 089 must not extend that fragmentation.

## Decision: Atomic P12 rule decomposition

- **Decision**: Add Principle XII, Persistence and Completion Integrity, with separate rules for verification before a Verified Completion Claim, blocking claims after failed verification, naming the unverified output, verifying every output in a multi-output claim, and consuming the owner result.
- **Rationale**: The Constitution requires one keyword and one obligation per normative rule, plus a concrete Observable, Tier, and 25-word maximum. Atomic rules preserve independently testable obligations and avoid hiding failure semantics in compound prose.
- **Alternatives considered**: Combining the obligations into one broad completion rule was rejected because it would violate rule-shape constraints and make partial verification failures difficult to review.

## Decision: Per-rule N6 applicability

- **Decision**: Map N6 to the Retained Output-dependent persistence verification rules, conceptually P12.1-P12.4. Evaluate the owner/orchestrator result-consumption rule by its orchestration trigger rather than assigning N6 merely because an orchestrator may declare no Retained Output.
- **Rationale**: N/A conditions apply to individual obligations, not automatically to an entire principle. An orchestrator can consume an owner's failed result without owning a retained output itself.
- **Alternatives considered**: Applying N6 to all of Principle XII was rejected because it would incorrectly exempt orchestration integrity.

## Decision: Experience rule placement

- **Decision**: Add Presentation Label under X1 as X1.6, and add Decision Context and Relevant Example under X2 as X2.9 and X2.10. Keep the no-extra-decision requirement in the existing Interactive Workflow UX Contract rather than adding another X identifier.
- **Rationale**: X1 owns output structure and X2 owns interaction. The existing contract is explicitly interpretive and organizational, so it can express anti-ceremony without creating a competing normative namespace.
- **Alternatives considered**: A new standalone X rule for the no-extra-decision requirement was rejected as redundant with X2.4, the new supporting-information rules, and X2.8.

## Decision: Version reconciliation

- **Decision**: Treat the latest completed Constitution Sync Impact Report as authoritative: it records 2.5.0, while the footer still says 2.4.0. Reconcile the footer to 2.5.0 before calculating the Feature 089 amendment version, then apply the resulting MINOR bump. The Experience Standard currently records 1.5.0 and receives its additive amendment bump.
- **Rationale**: Versioning cannot safely calculate from conflicting metadata. Explicit reconciliation prevents silently selecting the stale footer or double-applying a version increment.
- **Alternatives considered**: Bumping from the stale footer directly was rejected because it would produce an incorrect version history. Treating the top report as already fully applied was rejected because the footer must be synchronized as part of the implementation.

## Decision: Validation scope

- **Decision**: Extend only the governance inventory, UX alignment, and focused Feature 089 validation tests required to recognize new P/X rules, N6-N9, counts, precedence, metadata, and no-skill-file scope. Run the complete suite after focused checks.
- **Rationale**: The spec explicitly permits supporting validation changes while forbidding individual skill-file migration. Existing shell tooling and Bash 3.2 compatibility remain the repository's established test surface.
- **Alternatives considered**: Modifying skill files during the amendment was rejected because migration is follow-up work and unchanged skills are grandfathered.
