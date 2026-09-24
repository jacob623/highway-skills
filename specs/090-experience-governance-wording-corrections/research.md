# Feature 090 Research

## Decision: Preserve the existing governance ownership boundary

- **Decision**: Keep normative rule text in `.highway/governance/experience-standard.md` and `.highway/governance/constitution.md`; update validators only where they cannot prove the corrected wording or metadata.
- **Rationale**: The feature is a correction to two authoritative governance documents. Moving rule text or modifying individual skills would violate the stated scope and create a second authority surface.
- **Alternatives considered**: Adding a separate policy document was rejected because it would duplicate authority. Updating skill files was rejected because Feature 090 explicitly excludes migration.

## Decision: Treat the Principle XII move as behavior-affecting versioning work

- **Decision**: Classify the Constitution amendment against its own Versioning Policy based on the changed conflict-resolution ordering, independently of the Experience Standard wording amendment.
- **Rationale**: Principle Precedence determines which principle prevails in a conflict. Moving Principle XII above Principles VIII, VII, II, III, X, and XI can change outcomes and is not merely presentational.
- **Alternatives considered**: Treating the move as PATCH wording repair was rejected because PATCH is limited to wording or typo repair with no Observable change; treating the final classification as predetermined was rejected because the policy must be applied to the implemented amendment.

## Decision: Align X2.9 minimally to the existing Observable vocabulary

- **Decision**: Change only the X2.9 trigger wording needed to name downstream recommendations, decisions, artifacts, governance interpretations, and workflow actions, while preserving X2.9, its Tier, Sample classification unless validation conventions require otherwise, N7, and its applicability boundary.
- **Rationale**: The spec permits wording alignment but forbids adding obligations or changing the intended rule. The Observable already defines the five outcome categories.
- **Alternatives considered**: Broadening X2.9 beyond those five categories was rejected because it would change applicability. Redefining the Observable was rejected because only minimum alignment is authorized.

## Decision: Use focused validators plus the full suite

- **Decision**: Extend or add only assertions in the constitution inventory and UX alignment validation surfaces, run both focused tests, then run `.highway/tools/tests/run-all.sh`.
- **Rationale**: These validators already own rule inventory, precedence, amendment metadata, X2.9, and Interactive Workflow UX Contract checks. The full suite verifies no unrelated regression.
- **Alternatives considered**: A new standalone test runner was rejected because it would duplicate existing harness behavior and add an unnecessary validation surface.
