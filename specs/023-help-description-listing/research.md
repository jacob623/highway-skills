# Research: Help Description Listing

## Decision: Change only the All-Skills label

**Decision**: Replace the All-Skills block's `Usage:` label with `Description:` and keep the catalog entry's description value unchanged. Preserve the Single-Skill six-line response, including its `Usage:` field.

**Rationale**: The requested behavior targets invocation without a parameter. The existing skill contract already separates All-Skills and Single-Skill modes, so changing only the affected mode avoids a compatibility regression.

**Alternatives considered**:
- Rename the catalog's `usage` field: rejected because it is still required by Single-Skill mode and describes invocation syntax.
- Remove `Usage:` from all help output: rejected because the named-skill contract explicitly requires it.
- Add a second descriptive field: rejected because the request is a replacement in the existing three-line listing block.

## Decision: Use catalog descriptions as the listing source

**Decision**: Render each All-Skills `Description:` value from the resolved catalog entry in catalog order.

**Rationale**: `.highway/catalog/index.json` is the authoritative registry input named by the skill. This preserves existing ordering, identifier resolution, and one-block-per-entry behavior without introducing another source of truth.

**Alternatives considered**:
- Read descriptions directly from every skill file during listing: rejected because the contract requires the catalog to be read once and the catalog already contains the resolved description.
- Derive descriptions from usage text: rejected because it would produce the wrong user-facing meaning and violate the requested behavior.

## Decision: Test the source contract and generated correspondence

**Decision**: Add or amend focused checks for the All-Skills label and preserve the existing named-skill checks, then run the full `.highway/tools/tests/run-all.sh` suite and regenerate derived artifacts after the source skill changes.

**Rationale**: `SKILL.md` is distributed through generated adapters, and the repository's D3/D4 rules require a regression check plus generator correspondence after an input changes.

**Alternatives considered**:
- Rely only on manual review: rejected because the label substitution and preservation requirement are directly testable.
- Edit generated adapters directly: rejected by generated-artifact governance; the source skill is the input to regenerate.
