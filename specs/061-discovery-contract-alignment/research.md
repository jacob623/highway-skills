# Feature 061 Research: Discovery Contract Alignment

## Decision: Keep canonical section ordering in shipped source artifacts

**Decision**: Require the Discovery skill, its Verification section, and `discovery-record.md` to declare identical section names and ordering, without copying the full list into the feature requirement.

**Rationale**: The shipped skill and shared template are the existing contract authorities. The feature requirement should assert correspondence, while future section additions update those authorities and their focused checks together.

**Alternatives considered**: Embedding the full list in FR-002 was rejected because it creates a second canonical list. A new runtime schema was rejected because the project is Markdown-driven and the feature does not introduce a runtime parser.

## Decision: Validate alignment values as integers from 0 through 100

**Decision**: Accept only integer values in the inclusive range 0 through 100 for Desired Change, Objective, and Constraints alignment fields.

**Rationale**: This gives validators unambiguous boundary and type behavior. Disposable invalid fixtures can independently prove rejection of decimals, negative values, and values above 100.

**Alternatives considered**: Qualitative labels were rejected because the specification already requires a numeric representation. Decimal values were rejected because they leave precision and comparison behavior unspecified.

## Decision: Extend the existing focused Bash test with disposable fixtures

**Decision**: Add independent valid and invalid fixture checks to `.highway/tools/tests/highway-discovery.test.sh`, using temporary files or directories and preserving canonical bytes.

**Rationale**: The repository already requires Bash 3.2-compatible tests, seeded probes, and disposable artifact classes. Independent invalid fixtures make each deterministic contract failure diagnosable and satisfy the clarification decisions.

**Alternatives considered**: A new test framework or runtime validator was rejected because it adds dependencies and duplicates the existing shell harness. Combined-only fixtures were rejected because they obscure which rule failed.

## Decision: Regenerate all derived artifacts from canonical inputs

**Decision**: After changing the canonical skill/template and focused test, run the existing agent-adapter and catalog generators, then run adapter correspondence and the full suite.

**Rationale**: Generated artifacts are product-surface copies and must not become independent authorities. Existing generators and tests already prove source-to-output currency.

**Alternatives considered**: Hand-editing adapters or catalogs was rejected by generated-artifact integrity rules. Adding a new generator was rejected because the current generators cover the affected outputs.

## Resolved Technical Context

- Canonical skill: `.highway/skills/highway-discovery/SKILL.md`.
- Canonical output template: `.highway/library/templates/output/discovery-record.md`.
- Focused test: `.highway/tools/tests/highway-discovery.test.sh`.
- Generated outputs: GitHub Copilot, Claude Code, and Cursor Discovery adapters plus catalog artifacts.
- Toolchain: Bash 3.2-compatible shell utilities already used by the repository.
- No runtime service, database, package manager, or external interface is added.
