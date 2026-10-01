# Feature 118 Research

## Decision: Keep the existing four-domain Profile record and schema

**Rationale**: The current shared template already defines schema `3.0.0`, the four readiness domains, optional Context, and deterministic narrative rules. Feature 118 explicitly prohibits changing `profile-record.md`, so implementation must change the owning skill and its verification without introducing a second record model.

**Alternatives considered**: Add enrichment categories or advisory classifications to the retained record; rejected because those categories are transient reasoning inputs and optional enrichment must not affect readiness.

## Decision: Keep website assistance as an existing capability boundary

**Rationale**: The current Profile contract already accepts a supplied Organization URL, keeps website-derived facts proposed until acceptance, and continues when retrieval is unavailable. Feature 118 needs the behavior aligned and tested, not a new HTTP client, retrieval protocol, or dependency.

**Alternatives considered**: Add a retrieval library or define a new service contract; rejected because the feature is a Markdown skill contract change and the specification states that supported retrieval is existing capability.

## Decision: Use accepted evidence as the recommendation pivot

**Rationale**: The Experience Standard 6.0.0 requires accepted context to be re-evaluated before each unresolved guided question and grounded recommendations to replace a question when useful. Profile-specific text should define its four-domain evidence ownership and paragraph forms while citing the shared standard for generic acceptance, alternatives, and presentation.

**Alternatives considered**: Preserve question-first acquisition and offer enrichment afterward; rejected because it conflicts with X2.13 and would reintroduce repetitive questioning.

## Decision: Keep cohesive paragraph recommendations transient until acceptance

**Rationale**: Vision, Competitive Path, and Guiding Principles need useful synthesis without exposing internal categories or changing the retained schema. A single reviewable paragraph preserves user ownership, supports the save-before-result boundary, and maps accepted content to the existing domain narrative.

**Alternatives considered**: Store category fields, generate multiple fragments, or automatically persist generated prose; rejected because each either leaks internal structure, weakens reviewability, or violates the acceptance boundary.

## Decision: Preserve save-before-result and suppress machine results in orchestration

**Rationale**: The current Profile contract and Constitution P12.13–P12.15 require accepted mutation persistence before dependent owner results, while Experience Standard X2.34–X2.35 suppresses orchestration-only fields after the final user-facing interaction. Direct readiness remains available because it is a distinct owner boundary.

**Alternatives considered**: Restore post-write byte verification or render machine fields as a completion receipt; rejected because the current Profile contract removed post-write verification and the Experience Standard prohibits machine-result leakage in normal orchestration.

## Decision: No external contracts directory

**Rationale**: Profile exposes a skill interaction and an internal readiness result, not a network API or reusable programmatic interface. The readiness fields and user-facing behavior are documented in `data-model.md` and the quickstart; adding a separate contract file would duplicate the owning skill and shared governance.

**Alternatives considered**: Add a CLI/API contract; rejected because no new CLI parser, endpoint, wire format, or external integration is introduced.

## Decision: Version metadata remains 5.1.0

**Rationale**: The repository already contains `highway-profile` metadata version `5.1.0`. The feature specification requests the 5.0.0-to-5.1.0 MINOR release metadata but also says to preserve an already-present 5.1.0 baseline. Implementation must not bump beyond 5.1.0.

**Alternatives considered**: Increment to 5.2.0 because the feature adds advisory behavior; rejected because the requested version baseline is already present and the retained inputs, outputs, schema, and operations remain compatible.

## Decision: Use focused contract tests plus the full suite

**Rationale**: Existing tests already cover Profile schema, lifecycle, template citations, readiness, and Experience alignment. Feature 118 should add or amend focused assertions for first-time introduction, recommendation pivot, cohesive paragraph forms, hidden categories, completion synthesis, and machine-result suppression, then run `bash .highway/tools/tests/run-all.sh`.

**Alternatives considered**: Rely only on static reading or create a new test framework; rejected because the repository's established Bash contract tests provide the smallest compatible validation surface.
