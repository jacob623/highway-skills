# Feature 137 Research

## Decision: Amend the source skill, not the retained Profile

- **Rationale**: Baseline version 5.3.0, the `highway-profile` title, Inputs, Acquisition, Enrichment, Operations, and Verification all live in `.highway/skills/highway-profile/SKILL.md`. The request name `profile.md` identifies that skill contract. `.highway/library/knowledge/profile.md` is retained organizational knowledge, and `profile-record.md` remains schema 3.0.0.
- **Alternatives considered**: Editing only the retained organizational Profile was rejected because it has none of the cited skill sections. Editing Setup, Controls, NFRs, the Experience Standard, or the Constitution was rejected by the spec.

## Decision: Classify the complete amendment as MAJOR, 5.3.0 to 6.0.0

- **Rationale**: The Skill Versioning Policy defines a breaking change as removing, narrowing, or redefining a skill contract or behavioral guarantee. This amendment removes the enrichment-category framework, narrows Vision and Competitive Path, and replaces the discovered-Identity Contribution Opportunity exception. Added acquisition and expression capabilities do not keep the classification at MINOR.
- **Alternatives considered**: 5.4.0 was rejected because it would leave a breaking change on a MINOR version. A PATCH was rejected because Verification and user-visible behavior change. A pre-existing draft test expecting 5.4.0 is superseded by this classification.

## Decision: Keep imperative prose and do not add MUST or SHOULD keywords

- **Rationale**: The Profile skill currently has no normative keyword lines. Enrichment is already far above 400 words. Adding MUST or SHOULD would make those sections subject to P7.4 and P7.5 and fail validation. The amendment can still be checkable through Verification bullets and static contract tests.
- **Alternatives considered**: Encoding every FR as a MUST rule was rejected because it would violate the skill maintainability limits.

## Decision: Put the acquisition offer and imported-evidence rules in Acquisition

- **Rationale**: The person gets one illustrative opportunity to share a website, description, strategy material, or assistant export before ordinary domain questions. Supplied material is evidence across unresolved domains, not accepted truth, and does not need Profile headings. Missing retrieval and invisible model memory stay non-evidence.
- **Alternatives considered**: A retained source list or source-precedence field was rejected. Asking the website question only when retrieval exists was rejected because the person may supply other readable material even when retrieval is unavailable.

## Decision: Keep organizational expression transient and Profile-local

- **Rationale**: Suitable terminology may shape Working Ideas and Converged Proposals during the active interaction. It does not prove substantive claims, create retained tone or style fields, or control other Highway owners. The person's wording overrides it.
- **Alternatives considered**: A retained voice field was rejected. Propagating expression guidance to Objectives, Controls, or NFRs was rejected.

## Decision: Replace enrichment-category reasoning with domain meaning

- **Rationale**: Vision means the future the organization is trying to create. Competitive Path means the broad approach toward that future. Guiding Principles mean enduring decision guidance. Completeness is a coherent answer to the active domain, not coverage of internal categories. Identity breadth and the shared contribution, clarification, and acceptance architecture stay.
- **Alternatives considered**: Keeping the categories as hidden reasoning aids was rejected because they were over-steering questions and verification.

## Decision: Use volunteered downstream detail only as path evidence

- **Rationale**: The clarification says Profile may use volunteered safeguard, operational, architecture, or implementation detail as evidence of the broad Competitive Path, but must not develop or retain that detail as a safeguard, NFR, architecture, or implementation requirement. Profile still must not ask for those topics.
- **Alternatives considered**: Ignoring volunteered detail even when it informs the path was rejected. Holding it for a later owner inside Profile was rejected because that would add retained handoff state.

## Decision: Make accepted mutation success the persistence boundary

- **Rationale**: Acceptance authorizes the owner mutation. Dependent Profile behavior, readiness, completion synthesis, and return to Setup wait until that mutation succeeds. Failure stops progression and reports the existing common failure context. No post-write read-back is added.
- **Alternatives considered**: Treating conversational acceptance as persistence was rejected. Adding a read-back verification stage was rejected by the spec and the current skill's explicit prohibition.

## Decision: Retarget superseded static assertions and regenerate adapters

- **Rationale**: Feature tests 092, 122, 134, 136, and 137, plus profile behavior and structure tests, lock version 5.3.0 or wording this amendment removes. D3.5 requires those updates to name the superseded behavior. A draft `feature-137-profile-acquisition-expression-persistence.test.sh` expected 5.4.0 and strings from a different draft; it is rewritten to the accepted spec rather than treated as the contract. Adapters are byte copies produced by `generate-agent-adapters.sh`. Catalog metadata is produced by `generate-catalog.sh`. `generate-library-catalog.sh` and `generate-instructions.sh` are re-run so declared generators leave no unexpected diff.
- **Alternatives considered**: Leaving old assertions in place was rejected because they would force the removed category framework and website-only prompt to remain. Hand-editing adapters was rejected by D4.1.

## Resolved dependencies

The Experience Standard already owns import, Working Ideas, Contribution Opportunity, re-evaluation, clarification, and acceptance. Setup already orders Profile, Objectives, Controls, and NFRs. No extension hooks are registered. Protected artifacts remain unchanged.
