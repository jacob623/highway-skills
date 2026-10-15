# Feature 181 Research: Highway New Proposal-First Request Development

## Decision 1: Adopt the established contribution-opportunity interaction model

**Decision**: Model `highway-new` proposal-first intake on the existing Profile, Objectives, Controls, and NFR interaction language: grounded Working Idea, correction-oriented Contribution Opportunity, re-evaluation after substantive contribution, and a separate Converged Proposal acceptance boundary.

**Rationale**: The Experience Standard already defines the behavior needed for this feature through X2.4, X2.11, X2.13, X2.21, X2.37-X2.44, X2.51, X2.59, X2.65-X2.72. Reusing the established pattern preserves consistency and avoids a second interaction vocabulary.

**Alternatives considered**:
- Keep the existing questionnaire and add a final summary: rejected because it does not let the requester correct Highway's understanding early.
- Introduce a new Request-specific confirmation ritual: rejected because it would conflict with the shared Contribution Opportunity and acceptance model.

## Decision 2: Trigger a proposal from grounded evidence, not a fixed domain count

**Decision**: Present a Request Discovery Contribution Opportunity when the active evidence supports a responsible interpretation of at least one consequential Request aspect, such as the problem, actors, current process, desired change, or likely success measure. Show only grounded fields and represent unavailable fields as `Unknown` when the proposal needs to make the gap visible.

**Rationale**: A fixed count would force unnecessary questions for some inputs and produce premature proposals for others. The existing experience rules prioritize useful grounded reasoning over ceremony and require questions only for consequential uncertainty.

**Alternatives considered**:
- Require two or more completed domains: rejected because one well-described problem can support a useful starting point.
- Always show all seven domains: rejected when it would imply unsupported evidence; unknown fields are shown only where they help identify a consequential gap.

## Decision 3: Preserve the seven-domain and Solution Constraint contracts

**Decision**: Keep Problem, Actors, Current Process, Desired Change, Success Measure, Business Constraints, and Solution Constraints as the Request completeness domains. Keep all eight Solution Constraint fields, their list/scalar shapes, `unknown` state, empty-list distinctions, and `allowed_solution_classes` non-empty-or-unknown rule.

**Rationale**: The feature changes how evidence is developed, not what makes a Request complete or how the future Discovery candidate space is constrained.

**Alternatives considered**:
- Make a proposal itself sufficient for creation: rejected because it would weaken Evidence Completeness Rules.
- Collapse Solution Constraints into a single narrative: rejected because it would break the existing Discovery handoff contract.

## Decision 4: Keep proposals and contribution opportunities transient

**Decision**: Request Proposals and Request Discovery Contribution Opportunities remain conversational Working Ideas. They are not Request records, are not persisted, do not allocate identifiers, and cannot create Discovery or ADR artifacts.

**Rationale**: Request remains the owner of acceptance, completeness, allocation, persistence, and creation. Keeping provisional content transient preserves user ownership and no-write guarantees.

**Alternatives considered**:
- Persist draft Request records: rejected because the feature does not require a new durable lifecycle and it would alter ownership and failure behavior.
- Persist a separate proposal artifact: rejected because it would create a substitute record and downstream ambiguity.

## Decision 5: Collect only consequential missing evidence after refinement

**Decision**: After a proposal or substantive correction, reuse evidence already represented in the active understanding, re-evaluate the proposal, and ask at most one consequential user-owned question for the next missing domain or field.

**Rationale**: This satisfies evidence reuse and avoids repeating the questionnaire while preserving the existing one-question interaction and recovery behavior.

**Alternatives considered**:
- Continue asking domains in fixed order: rejected because known evidence can make later questions redundant.
- Ask all missing questions at once: rejected because it conflicts with the existing one-question interaction contract.

## Decision 6: Keep downstream handoff and completion behavior unchanged in ownership

**Decision**: After successful Request creation, provide a concise synthesis and direct the requester to `/highway-discovery REQXXXXXX`. During intake, route architecture, implementation, Discovery, Control, NFR, or relationship requests to their owning workflow without creating downstream artifacts.

**Rationale**: Discovery and ADR remain separate ownership boundaries, and the existing Request handoff is already explicit and testable.

**Alternatives considered**:
- Perform a preliminary Discovery recommendation during intake: rejected because it would cross the Request/Discovery boundary.
- Add ADR selection language to Request acceptance: rejected because ADR owns architectural selection and commitment.

## Decision 7: Validate through static contracts and disposable behavior fixtures

**Decision**: Extend `highway-new.test.sh` with test-first assertions and fixtures for proposal presentation, contribution closure, refinement/evidence reuse, convergence/acceptance, no-write boundaries, and downstream ownership. Keep shared template validation in `output-template.test.sh`, validate the canonical skill, regenerate adapters, and run the full suite.

**Rationale**: The repository is a Git-native Markdown skill suite with no runtime service. Existing shell contract tests are the authoritative validation mechanism and can verify both wording contracts and byte-preservation behavior.

**Alternatives considered**:
- Add a new runtime test framework: rejected because it would add dependencies without a runtime implementation surface.
- Test only generated adapters: rejected because canonical source ownership and source-to-adapter correspondence must both be verified.
