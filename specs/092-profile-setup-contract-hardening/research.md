# Feature 092 Research

## Decision: Keep the retained Profile as Markdown and make `profile-record.md` the sole shared output template

- Rationale: Feature 091 established `.highway/library/knowledge/profile.md` as the accepted user-owned artifact and the existing template already defines the five-domain Markdown structure. Renaming the output template makes the template/artifact boundary explicit without changing the retained artifact location.
- Alternatives considered: Keep `profile.md` as both template and retained artifact, which preserves ambiguity; or rename the retained artifact, which expands scope and breaks existing Profile participation references.

## Decision: Remove both obsolete output-template artifacts

- Rationale: `.highway/library/templates/output/profile.md` and `.highway/library/templates/output/profile.yaml` are legacy or ambiguous shipped inputs. The new contract requires `.highway/library/templates/output/profile-record.md` and forbids YAML fallback, migration, or distribution treatment.
- Alternatives considered: Keep the YAML file as a migration fallback, which violates runtime self-containment and creates competing authority; keep the old Markdown template as an alias, which permits stale correspondence.

## Decision: Use owner readiness as the only Setup stage-advancement authority

- Rationale: Profile owns artifact inspection and readiness. Setup can validate the four-field response shape, delegate a declared Next Action during active orchestration, re-read readiness after a verified action, and advance only from the resulting terminal owner status.
- Alternatives considered: Recompute Profile state in Setup, which violates owner separation; advance from action completion alone, which can report completion before the owner contract is satisfied.

## Decision: Express runtime interfaces as Markdown contracts and shell fixtures

- Rationale: The repository is a documentation-led skill distribution with no service API or runtime library. The stable interfaces are skill Inputs/Outputs, readiness responses, template structure, governance documents, and generated correspondence.
- Alternatives considered: Add a runtime parser or service layer, which introduces unrequested dependencies and violates the no-new-technology boundary.

## Decision: Use existing shell validators, focused tests, and disposable fixtures

- Rationale: Existing checks run under macOS Bash 3.2, use the declared toolchain, and already distinguish static document-contract evidence from executed behavior. New fixtures can cover malformed responses, schema versions, no-op writes, context non-promotion, X2.3 composition, and template removal without adding a framework.
- Alternatives considered: Add Python or a third-party test framework, which violates the declared runtime/toolchain constraints and is unnecessary for contract validation.

## Decision: Regenerate only correspondence-identified dependents

- Rationale: The development constitution requires generated outputs to remain synchronized with changed inputs. The implementation will inventory affected catalogs, adapters, manifests, and distribution entries before regeneration, record `None` where no dependent exists, and verify correspondence after regeneration.
- Alternatives considered: Regenerate every generated artifact unconditionally, which creates unnecessary metadata churn and obscures dependency scope.

## Decision: Defer semantic version numbers until the actual diffs are classified

- Rationale: Profile, Setup, affected Interactive Workflow skills, the Experience Standard, and the Constitution each have separate versioning policies. Metadata syntax repair is independent from behavioral classification, and the specification must not preassign results.
- Alternatives considered: Hard-code version bumps in the plan, which could misclassify a definition repair or omit a breaking contract change.

## Decision: Treat X2.3 and X2.7-X2.10 as a composed interaction contract

- Rationale: Required acknowledgments, Decision Context, Relevant Examples, and user-relevant progress remain valid when they contain no unrequested mechanics. Context consumption is internal; ordinary output must not expose loading or evaluation machinery merely as proof.
- Alternatives considered: Suppress all context-grounded output under X2.3, which would violate the existing Experience Standard observables and reduce user value.
