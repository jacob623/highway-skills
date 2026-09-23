# Clarification Contract Consistency Contract

## Canonical Inputs

- `.highway/skills/highway-clarify/SKILL.md`
- `.highway/library/templates/output/clarification-record.md`
- `.highway/tools/tests/highway-clarify.test.sh`
- `.highway/tools/tests/output-template.test.sh`

Generated catalogs and agent adapters are derived outputs and must be refreshed after canonical inputs change.

## Recommendation

The valid basis/state mappings are:

| Recommendation Basis | Valid Recommendation State |
|---|---|
| `authoritative` | Evidence-backed recommendation, not `Unknown` or `Escalate for Decision` |
| `evidence-gap` | `Unknown` |
| `conflict` | `Escalate for Decision` |

`Unknown / Escalate for Decision` and any additional combined or conflict-state vocabulary are invalid.

## Evidence Sources

Each evidence source is a direct list item with:

- Source Type
- Source Identifier
- Reason Used

Multiple sources use multiple list items. Zero sources use `Evidence Sources: None`. A nested `Source:` wrapper is invalid for generated or retained records.

## Resolution History

Each Resolution History list item contains Finding, Response, Revision, and Actor. Finding identifiers must reference findings in the same record and must not repeat within one Resolution History section, regardless of other field values.

## Failure

A violation of FR-001 through FR-019 must fail validation, write no retained output, and preserve every pre-operation byte. Validation covers canonical examples, generated clarification records, generated adapters/catalogs, and disposable fixtures.

## Conformance

`clarify.md` and `clarification-record.md` must express the same recommendation vocabulary, basis/state mappings, Evidence Sources structure, duplicate-history rule, and no-partial-write consequence. A full repository and generated-artifact search must find no retired combined conflict state outside historical version-control records.
