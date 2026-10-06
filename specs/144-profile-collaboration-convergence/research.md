# Research: Profile Collaboration Convergence

## Decision: Use a Profile-local ordered semantic decision

**Rationale**: The existing Profile contract already separates domain completeness from conversational convergence and delegates generic collaboration behavior to the Experience Standard. A short ordered decision near Domain completeness applies those rules to the four Profile domains without creating a new global rule or runtime state.

**Alternatives considered**:
- Add a global Experience Standard rule: rejected because the requested behavior is Profile-specific and the existing standard already owns the generic concepts.
- Add a persisted convergence field: rejected because Working Ideas and convergence are transient interaction concepts and the retained schema must remain unchanged.

## Decision: Represent behavioral coverage as development-only transcript fixtures

**Rationale**: The behavior concerns multi-turn semantic development, so static phrase assertions alone are insufficient. Synthetic fixtures can describe varied organization-neutral scenarios without becoming Profile Inputs or runtime dependencies.

**Alternatives considered**:
- Exact golden-response snapshots: rejected because semantic equivalence does not require identical wording and snapshots would overfit a model or phrasing.
- Runtime fixture loading: rejected because shipped Profile behavior must not depend on development artifacts.

## Decision: Run all eight fixtures through the development validation workflow

**Rationale**: The accepted clarification requires option A. A repeatable validation entry point makes the fixture set visible to the full suite while preserving the distinction between development-time evaluation and Profile save behavior. Deterministic checks enforce fixture shape and hard failures; semantic review fields cover qualities that cannot be reduced to exact strings.

**Alternatives considered**:
- Review-only fixtures: rejected because regressions would not be visible in routine validation.
- A new runtime save hook: rejected because saving the output Profile must remain unchanged and fixtures must not be runtime dependencies.

## Decision: Keep the retained Profile schema and versioning boundary unchanged except for a minor capability increment

**Rationale**: The feature adds Profile-specific collaborative reasoning capability without redefining existing persisted artifacts or breaking acceptance/readiness behavior. The Skill Versioning Policy therefore calls for the next minor `highway-profile` version, expected from `8.0.0` to `8.1.0`.

**Alternatives considered**:
- Schema change: rejected because transient Working Ideas, reasoning, convergence state, and contribution opportunities do not belong in retained Profile records.
- Major version change: rejected because no breaking contract or existing behavioral guarantee is removed or redefined.

## Decision: Use the existing Bash 3.2-compatible test discovery and generated-artifact workflow

**Rationale**: The repository's `run-all.sh` discovers `*.test.sh` files, and existing Profile tests already cover source documents, generated adapters, and disposable fixtures. Reusing these conventions minimizes dependencies and preserves distributed-tree portability.

**Alternatives considered**:
- Introduce a new language or test framework: rejected because it would add dependency and portability cost for development-only document evaluation.
- Manually dispatch the new test from `run-all.sh`: rejected because discovery already provides the required automatic inclusion.
