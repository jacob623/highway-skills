# Requirements Quality Checklist: Conversational Control Discovery

**Purpose**: Review the specification for completeness, clarity, consistency, and testability before planning implementation.
**Created**: 2026-09-25
**Feature**: [spec.md](../spec.md)

**Note**: This checklist is a reviewer-owned requirements-quality review artifact. Mark an item `[x]` only when the requirements-quality criterion is satisfied; `[x]` does not mean implementation is complete.

## Scope And Ownership

- [x] CHK001 The specification clearly separates Setup orchestration from Controls discovery, interpretation, proposal, and persistence ownership.
- [x] CHK002 The specification defines the exact Setup-owned Controls purpose transition and the unchanged Controls-owned opening.
- [x] CHK003 The specification preserves terminal `Complete` behavior and fresh owner-readiness routing.
- [x] CHK004 The specification preserves the existing Control record, catalog, identifier, relationship, readiness, transaction, destructive-action, and Control-derived NFR contracts.
- [x] CHK005 The specification explicitly keeps Concern, Condition, and Obligation transient rather than adding retained fields.

## User Journeys And Behavior

- [x] CHK006 Each prioritized user story has an independent test and Given/When/Then acceptance scenarios.
- [x] CHK007 The specification covers Concern-only, Concern-plus-Condition, complete-obligation, rich-answer, vague-activity, and formal-governance input.
- [x] CHK008 The specification replaces mandatory category onboarding with adaptive discovery and forbids fixed category progress.
- [x] CHK009 The specification covers direct invocation, Setup-mediated invocation, uncertainty, suggestions, suggestion adoption, and guided help.
- [x] CHK010 The specification covers natural acceptance, correction, replacement, rejection, cancellation, abandonment, interruption, and persistence failure.
- [x] CHK011 The specification covers multiple obligations, grouping decisions, explicit grouping, and user-provided order.
- [x] CHK012 The specification covers post-creation continuation and explicit finish without a category loop.
- [x] CHK013 The edge cases cover missing or malformed context, conflicting user/context evidence, overlap, malformed baselines, unsafe allocation, and Setup resume.

## Requirements Quality

- [x] CHK014 Functional requirements use normative, testable language and remain technology-agnostic except where existing contracts require named artifacts or owners.
- [x] CHK015 Functional requirements define all three adaptive discovery dimensions and the at-most-one unresolved question-or-decision rule.
- [x] CHK016 Functional requirements define ordinary-language interaction, formal-language accommodation, user ownership, and active-user precedence.
- [x] CHK017 Functional requirements define the four declared Repository Context Documents and additional accepted governance context without conflating them.
- [x] CHK018 Functional requirements define relevant-only context consumption, unavailable/malformed handling, and no fabricated policy or evidence.
- [x] CHK019 Functional requirements define bounded suggestions, transient adoption semantics, overlap surfacing, and avoidance of redundant governance.
- [x] CHK020 Functional requirements define Decision Context, contextual acknowledgment, and adaptive examples without requiring fixed prompt wording.
- [x] CHK021 Functional requirements define the complete proposal, natural validation, pre-persistence disclosure boundary, and correction invalidation.
- [x] CHK022 Functional requirements define authoritative baseline/overlap revalidation and late-overlap confirmation invalidation.
- [x] CHK023 Functional requirements preserve all-or-nothing persistence, retained-output verification, non-write exits, and prior-baseline preservation.
- [x] CHK024 Functional requirements preserve identifiers, catalog determinism, relationship behavior, readiness ownership, destructive safeguards, and downstream NFR ownership.
- [x] CHK025 Functional requirements define Setup's non-interpretive forwarding boundary and prevent transient state restoration.
- [x] CHK026 Functional requirements require focused verification for both skills and all major behavioral surfaces.

## Verification And Success

- [x] CHK027 Success criteria are measurable and cover handoff ordering, adaptive discovery, category removal, context boundaries, suggestions, corrections, overlap, persistence, readiness, and downstream ownership.
- [x] CHK028 Success criteria include quantitative coverage claims and qualitative preservation of user-owned governance content.
- [x] CHK029 Success criteria cover direct and Setup-mediated invocation, terminal readiness, interruptions, non-write exits, and failed persistence.
- [x] CHK030 Key entities distinguish transient discovery evidence, staged proposal, durable Control, catalog/baseline, context, handoff result, and derived NFR candidate.
- [x] CHK031 Assumptions identify preserved contracts, schema boundaries, historical category scope, user ownership, and generated-artifact correspondence.
- [x] CHK032 No clarification markers remain; scope, dependencies, assumptions, and out-of-scope schema changes are explicit.
- [x] CHK033 Conversational Control creation declares `Resume Applicability: New interaction`, with persisted Controls as the only new-invocation evidence.
- [x] CHK034 The specification defines ordered evidence sufficiency and next-action branching, including complete-obligation bypass and multiple-obligation grouping precedence.
- [x] CHK035 Context roles are definitive, distinguish Repository Context Documents from accepted Business Objectives and Controls, and prevent context from silently choosing organizational policy.
- [x] CHK036 Controls consumes Profile's owner-confirmed `Blocked` result without validating or reclassifying Profile, and distinguishes it from unavailable optional context.
- [x] CHK037 Suggestion vocabulary, zero-grounded-suggestion fallback, adoption boundary, and Constraint-to-NFR routing are explicit.
- [x] CHK038 Contextual Acknowledgment is gated by Material Influence, Decision Context may avoid redundant Setup transition text, and examples cannot constrain user-owned content.
- [x] CHK039 Conversational single-Control persistence explicitly supersedes batch onboarding while preserving atomic record/catalog/version/allocation/relationship transactions.
- [x] CHK040 `setup` and `configure` alias behavior, valid-baseline continuation, `Finished` collection result, and delegated-result-before-readiness ordering are explicit.
- [x] CHK041 Immediate per-Control candidate generation, deferred user-visible review, interruption safety, and candidate-generation failure behavior are explicit.
- [x] CHK042 Exact duplicate and decision-affecting semantic overlap outcomes are distinct, and late-overlap invalidation is scoped accordingly.
- [x] CHK043 Readiness excludes historical categories and inferred governance completeness, and no exhaustive governance baseline is mandatory.
- [x] CHK044 Adaptive discovery has no artificial long-running progress; legacy category progress fields are explicitly removed from the amended UX contract.
- [x] CHK045 The specification requires organizational-spectrum fixtures, a context-reduces-questions criterion, structured proposal presentation, and a North Star end-to-end fixture.
- [x] CHK046 Version impact, Experience Standard coverage, Constitution P11/P12 review, exact verdict gate, and distributed correspondence are explicit release obligations.
- [x] CHK047 Planning requires one authoritative requirement-to-test correspondence map to prevent duplicated statements from diverging.
- [x] CHK048 `Finished` is a Controls-specific collection field on a successful action result, not a shared Owner Outcome, and Setup consumes it before fresh readiness.
- [x] CHK049 Pre-delegation versus post-delegation Setup readiness sequencing and the first-Control continuation regression are explicit.
- [x] CHK050 Obligation readiness uses one measurable-against boundary, does not synthesize optional Concern/Condition labels, and handles vague user-overridden wording explicitly.
- [x] CHK051 Direct invocation uses an exact purpose sentence plus the shared Controls opening, while obligation-led Add invocation skips both openings.
- [x] CHK052 Zero-suggestion fallback wording, suggested-Obligation adoption boundaries, and exact-Control reuse without writes are deterministic.
- [x] CHK053 Contextual connections are advisory unless an existing writable relationship contract authorizes them; persisted Control relationships remain `nfrs` identifiers only.
- [x] CHK054 Created Control IDs are cumulative machine-only provenance, while candidate classification is durable and does not depend on restoring interaction state.
- [x] CHK055 Controls generation ownership and NFR candidate-review ownership are explicitly reconciled and version impact includes any changed NFR contract.
- [x] CHK056 Compliance uses PASS/FAIL/N/A evidence, a separate DEFERRED block, phase-specific applicability, and N5/N6 handling rather than treating all rules as applicable.
- [x] CHK057 The action-selection table covers all supported Controls actions, retains `add` rather than adding `new`, and separates discovery from Update/Remove/Set.
- [x] CHK058 Legacy category and batch Review Complete onboarding is explicitly removed or scoped to a named non-setup action; public Usage, Outputs, Examples, and Verification updates are required.
- [x] CHK059 Continuation prompt and affirmative-continuation routing are explicit, including yes, direct evidence, suggestions, uncertainty, and finish.
- [x] CHK060 Zero-Control finish remains `Missing` and cannot advance Setup; false completion after failed write or verification is covered.
- [x] CHK061 Proposal field labels/order, user-approved title/rationale ownership, deterministic title generation, and deterministic proposal rendering are explicit.
- [x] CHK062 Organizational fixtures measure adaptation of each organization's own intent, including fewer questions for mature language and no jargon requirement for ordinary language.
- [x] CHK063 Discovery dimensions cannot appear as user-visible progress labels, and context application cannot create ceremonial questions.
- [x] CHK064 The feature-level invariant connects context recommendation, accepted/user-adopted governance, and verified persisted readiness boundaries.
- [x] CHK065 User Story 3 distinguishes concern identification/prioritization/suggestion from policy choice and uses relevant connection rather than persisted relationship.
- [x] CHK066 Profile-owner `Blocked` behavior is a separate acceptance scenario with an explicit Controls `Blocked` result and non-empty reason; optional context failure continues.
- [x] CHK067 Normal Control-ready proposals and explicit vague-wording user-override proposals are separate routes with distinct claims about measurability.
- [x] CHK068 Proposal interaction framing places the required review action first and distinguishes it from retained Title, Statement, and Rationale fields.
- [x] CHK069 Collection `Continue` and `Finished` semantics, exact owner-only result fields, zero-Control output, and separation from four-field readiness are explicit.
- [x] CHK070 Immediate candidate generation occurs after verified persistence, candidate review is deferred, zero-candidate behavior is defined, and candidate failure blocks downstream advancement without rolling back the valid Control.
- [x] CHK071 Dependent Controls/NFR ownership reconciliation is a prerequisite, with deterministic candidate-generation ownership and NFR review/persistence ownership stated.
- [x] CHK072 Reuse is limited to an accepted existing Control that represents the adopted requirement; reuse mutates no Control, relationship, identifier, version, or candidate state.
- [x] CHK073 Context priority, advisory relevant-connection versus persisted relationship semantics, no inferred persona/maturity, and explicit Inputs paths are defined.
- [x] CHK074 Each accepted conversational Control is one Add transaction with existing MINOR version semantics; multi-Control and abandoned-proposal version fixtures are required.
- [x] CHK075 Direct `configure`, one-shot `add`, Setup's single `/highway-controls setup` route, absent optional Profile/Objectives, and direct no-context fixtures are explicit.
- [x] CHK076 Interaction-state and repository-state invariants, explicit finish, pause/non-restoration, and completion gating are explicit.
- [x] CHK077 The feature scope limits NFR changes to interruption-safe candidate timing and deferred review, avoiding an unrelated NFR lifecycle redesign.
- [x] CHK078 Collection `Succeeded`, `Declined`, `Aborted`, and `Blocked` semantics, non-empty blocked reasons, exact field ordering, and non-terminal `Continue` behavior are explicit.
- [x] CHK079 Direct `/highway-controls configure` with a valid baseline and one-shot `/highway-controls add` acceptance scenarios are explicit.

## Notes

- Reviewed against the active Spec Kit template, the supplied Conversational Control Discovery request, and existing Setup/Objectives handoff conventions.
- The checklist is complete for requirements quality; implementation planning should still decompose the requirements into source edits, fixtures, and verification tasks.
- `/speckit-implement` must not change checklist markers.
