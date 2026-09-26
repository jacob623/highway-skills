# Research: Conversational Objective Discovery

## Decision: Keep the implementation inside the existing skill and shell-test surfaces

**Rationale:** Feature 093 changes two shipped Markdown skill contracts and their focused validation tests. Existing skills, generated adapters, catalog generation, and `.highway/tools/tests/run-all.sh` already provide the required delivery and verification path. No application runtime, package, service, or new persistence layer is needed.

**Alternatives considered:** A separate conversation service or persisted wizard store was rejected because Setup must remain an orchestrator, transient discovery state must not be persisted, and the repository has no runtime service boundary for this behavior.

## Decision: Objectives owns adaptive discovery and durable mutation

**Rationale:** The current contracts assign Objective interpretation, identifiers, records, catalogs, readiness, transactions, and completion claims to `highway-objectives`. Setup can introduce purpose and forward owner results, but it must not interpret evidence or write Objective artifacts.

**Alternatives considered:** Putting the conversation in `highway-setup` was rejected because it would duplicate owner semantics and violate the existing ownership boundary.

## Decision: Preserve the shared Objective templates as structural authorities

**Rationale:** `.highway/library/templates/output/objective-record.md` and `objective-catalog.md` define retained structure. The amended skill should cite them and retain only behavioral rules, preventing a second schema in the skill text.

**Alternatives considered:** Repeating the record and catalog schema in the skill was rejected because it can drift from shared output contracts and violates shared-template governance.

## Decision: Use transient evidence and proposal state with no resume store

**Rationale:** Outcome, Success, Significance evidence, suggestions, grouping decisions, and synthesized proposal fields are needed during one interaction but are not durable schema fields. A new invocation must read persisted readiness and never restore prompts, drafts, or checkpoints.

**Alternatives considered:** Persisting a draft or checkpoint was rejected because the feature explicitly preserves the New interaction resume contract and would create a second source of truth.

## Decision: Treat context failure at the consuming-skill boundary

**Rationale:** Objectives records unavailable, malformed, or contradictory Repository Context input after it is available for consumption, excludes unusable context, and continues with valid evidence. This does not override an owner-level `Blocked` result for malformed authoritative Profile state.

**Alternatives considered:** Treating every malformed context input as optional was rejected because it could hide an authoritative owner failure; treating every context issue as globally blocking was rejected because declared context absence must not prevent valid workflow progress.

## Decision: Verify both retained outputs before any completion claim

**Rationale:** A confirmed creation must revalidate the baseline, recheck overlap, allocate one permanent identifier, persist record and catalog together, verify both retained outputs, and only then report creation completed. Persistence failure preserves the prior baseline and names the unverified output.

**Alternatives considered:** Reporting success after one file write or after staging was rejected because record and catalog are a coupled retained-output contract.

## Decision: Use focused static and executable Bash tests plus the full suite

**Rationale:** Existing tests distinguish source-document contract checks from executed behavior fixtures, support seeded failure probes, and run under macOS Bash 3.2-compatible conventions. Feature 093 needs focused assertions for adaptive conversation, ownership, context, persistence, and generated correspondence, followed by `run-all.sh`.

**Alternatives considered:** Relying only on prose review or only on static grep checks was rejected because the feature includes state transitions, byte-preservation, transaction failure, and no-resume behavior.
