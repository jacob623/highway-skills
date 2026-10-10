# Feature 156 Research

## Decision: Keep the feature inside the existing Profile skill

**Rationale**: The request names `highway-profile/SKILL.md` as the owning artifact and explicitly excludes changes to the Experience Standard, other workflows, persistence, and the existing advisory scaffolding. A separate guidance section preserves those ownership boundaries.

**Alternatives considered**:

- Change the Experience Standard: rejected because the feature explicitly preserves the Standard.
- Add a new contribution category: rejected because the feature improves selection and execution of existing types.
- Add runtime state or Profile schema: rejected because the behavior is guidance for emitted reasoning, not retained data.

## Decision: Model the advisory move as a connected linear chain

**Rationale**: The clarification permits structure → implication → possibility or tradeoff when each step derives directly from the immediately preceding step. Branching alternatives, independent possibilities, recommendation sets, and opportunity catalogs remain prohibited.

**Alternatives considered**:

- Permit only one follow-on item: rejected because it excludes the requested structure → implication → possibility behavior.
- Permit arbitrary connected extensions: rejected because it weakens the contribution bound and risks recommendation-set behavior.

## Decision: Use static-document contract verification

**Rationale**: Existing repository tests verify source-document delivery sites and generated-adapter correspondence. The focused test can assert the new guidance, its negative boundaries, and the unchanged Experience Standard row while clearly disclaiming runtime conversational proof.

**Alternatives considered**:

- Add a runtime conversation simulator: rejected because the repository's current Feature 154/155 evidence boundary distinguishes static text delivery from runtime behavior.
- Modify an unrelated existing test: rejected because the feature needs an independently discoverable, focused contract check.

## Decision: Regenerate all declared Profile adapters

**Rationale**: Profile source is copied into the `.github`, `.claude`, `.cursor`, and `.agents` adapter trees. The existing generator and adapter manifest are the repository authority for those outputs.

**Alternatives considered**:

- Hand-edit generated adapters: rejected by the repository's generated-artifact integrity rules.
- Leave adapters stale: rejected because consumers may receive different guidance from the source skill.

## Unresolved research questions

None. Implementation details are bounded by existing repository patterns and no external dependency or interface is introduced.
